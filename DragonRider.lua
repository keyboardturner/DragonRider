local DragonRider, DR = ...
local _, L = ...

--A purposeful global variable for other addons
DragonRider_API = DR

---@type LibAdvFlight
local LibAdvFlight = LibStub:GetLibrary("LibAdvFlight-1.1");

-- reverse-lookup map to find race data from a currency ID quickly.
DR.CurrencyToRaceMap = {}

local defaultsTable = {
	toggleModels = true,
	speedometerPosPoint = 1,
	speedometerPosX = 0,
	speedometerPosY = 5,
	speedometerScale = 1,
	speedValUnits = 1,
	speedBarColor = {
		slow = {
			r=196/255,
			g=97/255,
			b=0/255,
			a=1,
		},
		vigor = {
			r=0/255,
			g=144/255,
			b=155/255,
			a=1,
		},
		over = {
			r=168/255,
			g=77/255,
			b=195/255,
			a=1,
		},
	},
	speedTextColor = {
		slow = {
			r=1,
			g=1,
			b=1,
		},
		vigor = {
			r=1,
			g=1,
			b=1,
		},
		over = {
			r=1,
			g=1,
			b=1,
		},
	},
	speedTextScale = 12,
	glyphDetector = true,
	vigorProgressStyle = 1, -- 1 = vertical, 2 = horizontal, 3 = cooldown
	cooldownTimer = {
		whirlingSurge = true,
		bronzeTimelock = true,
		aerialHalt = true,
	},
	barStyle = 1, -- 1 = standard
	statistics = {},
	multiplayer = true,
	sideArt = true,
	sideArtStyle = 1,
	tempFixes = {
		hideVigor = true, -- this is now deprecated
	},
	showtooltip = true,
	fadeVigor = true,
	fadeSpeed = true,
	lightningRush = true,
	muteVigorSound = false,
	themeSpeed = 1, -- default
	themeVigor = 1, -- default

};

-- here, we just pass in the table containing our saved color config
function DR:ShowColorPicker(configTable)
	local r, g, b, a = configTable.r, configTable.g, configTable.b, configTable.a;

	local function OnColorChanged()
		local newR, newG, newB = ColorPickerFrame:GetColorRGB();
		local newA = ColorPickerFrame:GetColorAlpha();
		configTable.r, configTable.g, configTable.b, configTable.a = newR, newG, newB, newA;
	end

	local function OnCancel()
		configTable.r, configTable.g, configTable.b, configTable.a = r, g, b, a;
	end

	local options = {
		swatchFunc = OnColorChanged,
		opacityFunc = OnColorChanged,
		cancelFunc = OnCancel,
		hasOpacity = a ~= nil,
		opacity = a,
		r = r,
		g = g,
		b = b,
	};

	ColorPickerFrame:SetupColorPickerAndShow(options);
end

DR.WidgetFrameIDs = {
	4460, -- generic DR
	4604, -- non-DR
	5140, -- gold gryphon
	5143, -- silver gryphon
	5144, -- bronze gryphon
	5145, -- dark gryphon
};

--Blizzard has removed the ability to check for "Riding Abroad" in 11.0 while also not adding new API to compensate.
DR.DragonRidingZoneIDs = {
	2444, -- Dragon Isles
	2454, -- Zaralek Cavern
	2548, -- Emerald Dream
	2549, -- Amirdrassil Raid
	2516, -- The Nokhud Offensive
};

function DR.DragonRidingZoneCheck()
	for k, v in pairs(DR.DragonRidingZoneIDs) do
		if GetInstanceInfo() then
			local instanceID = select(8, GetInstanceInfo())
			if instanceID == v then
				return true;
			end
		end
	end
end

DR.model = {};
DR.modelScene = {};

function DR:modelSetup(number)
	if C_UnitAuras.GetPlayerAuraBySpellID(417888) then -- algarian stormrider
		DR.model[number]:SetModelByFileID(3009394)
		DR.model[number]:SetPosition(5,0,-1.5)
		--DR.model1:SetPitch(.3)
		DR.model[number]:SetYaw(0)
	else
		DR.model[number]:SetModelByFileID(1100194)
		DR.model[number]:SetPosition(5,0,-1.5)
		--DR.model1:SetPitch(.3)
		DR.model[number]:SetYaw(0)
	end
end

for i = 1,6 do
	DR.modelScene[i] = CreateFrame("ModelScene", nil, UIParent)
	DR.modelScene[i]:SetPoint("CENTER", DR.statusbar, "CENTER", -145+(i*40), -36)
	DR.modelScene[i]:SetWidth(43)
	DR.modelScene[i]:SetHeight(43)
	DR.modelScene[i]:SetFrameStrata("MEDIUM")
	DR.modelScene[i]:SetFrameLevel(500)

	DR.model[i] = DR.modelScene[i]:CreateActor()

	DR:modelSetup(i)
end


function DR.toggleModels()
	for i = 1,6 do
		DR.modelScene[i]:Hide()
	end
end

DR.toggleModels()

DR.charge = CreateFrame("Frame")
DR.charge:RegisterEvent("UNIT_AURA")
DR.charge:RegisterEvent("SPELL_UPDATE_COOLDOWN")

function DR:chargeSetup(number)
	if UIWidgetPowerBarContainerFrame then
		DR.SetUpChargePos(number)
		if UIWidgetPowerBarContainerFrame.widgetFrames[5140] then -- gold tex
			DR.charge[number].texBase:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Points_Gold_Empty.blp")
			DR.charge[number].texCover:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Points_Gold_Cover.blp")
		elseif UIWidgetPowerBarContainerFrame.widgetFrames[5143] then -- silver tex
			DR.charge[number].texBase:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Points_Silver_Empty.blp")
			DR.charge[number].texCover:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Points_Silver_Cover.blp")
		elseif UIWidgetPowerBarContainerFrame.widgetFrames[5144] then -- bronze tex
			DR.charge[number].texBase:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Points_Bronze_Empty.blp")
			DR.charge[number].texCover:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Points_Bronze_Cover.blp")
		elseif UIWidgetPowerBarContainerFrame.widgetFrames[5145] then -- dark tex
			DR.charge[number].texBase:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Points_Dark_Empty.blp")
			DR.charge[number].texCover:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Points_Dark_Cover.blp")
		elseif C_UnitAuras.GetPlayerAuraBySpellID(418590) then -- default fallback, buff exists, not stormrider
			DR.charge[number].texBase:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Points_Gold_Empty.blp")
			DR.charge[number].texCover:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Points_Gold_Cover.blp")
		else
			DR.charge[number].texBase:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Points_Gold_Empty.blp")
			DR.charge[number].texCover:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Points_Gold_Cover.blp")
			DR.charge[number]:Hide();
		end
	end
end

function DR.SetUpChargePos(i)
	DR.charge[1]:SetPoint("CENTER", UIWidgetPowerBarContainerFrame, -61,15)
	if i ~= 1 then
		if C_UnitAuras.GetPlayerAuraBySpellID(417888) then
			DR.charge[i]:SetPoint("CENTER", DR.charge[i-1], 30.5, 0)
		else
			DR.charge[i]:SetPoint("CENTER", DR.charge[i-1], 26.75, 0)
		end
		DR.charge[i]:SetParent(DR.charge[i-1])
	end
	if DR.charge[6] then
		if C_UnitAuras.GetPlayerAuraBySpellID(417888) then
			DR.charge[6]:SetPoint("CENTER", DR.charge[1], 0, -30)
		else
			DR.charge[6]:SetPoint("CENTER", DR.charge[1], 0, -33)
		end
	end
end

for i = 1, 10 do
	DR.charge[i] = CreateFrame("Frame")
	DR.charge[i]:SetSize(25,25)

	DR.SetUpChargePos(i)

	DR.charge[i].texBase = DR.charge[i]:CreateTexture(nil, "OVERLAY", nil, 0)
	DR.charge[i].texBase:SetAllPoints(DR.charge[i])
	DR.charge[i].texBase:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Points_Gold_Empty.blp")
	DR.charge[i].texFill = DR.charge[i]:CreateTexture(nil, "OVERLAY", nil, 1)
	DR.charge[i].texFill:SetAllPoints(DR.charge[i])
	DR.charge[i].texFill:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Points_Fill.blp")
	DR.charge[i].texCover = DR.charge[i]:CreateTexture(nil, "OVERLAY", nil, 2)
	DR.charge[i].texCover:SetAllPoints(DR.charge[i])
	DR.charge[i].texCover:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Points_Gold_Cover.blp")

	DR.charge[i].texFill:Hide();

end


function DR.toggleCharges(self, event, arg1)
	if event == "UNIT_AURA" and arg1 == "player" then
		if C_UnitAuras.GetPlayerAuraBySpellID(418590) then
			local chargeCount = C_UnitAuras.GetPlayerAuraBySpellID(418590).applications
			for i = 1,10 do
				DR:chargeSetup(i)
				if i <= chargeCount then
					DR.charge[i].texFill:Show();
				else
					DR.charge[i].texFill:Hide();
				end
			end
			DR.setPositions();
		else
			for i = 1,10 do
				DR.charge[i].texFill:Hide();
			end
			DR.setPositions();
		end
	end
	if event == "SPELL_UPDATE_COOLDOWN" then
		local isEnabled, startTime, modRate, duration
		if C_Spell.GetSpellCooldown then
			isEnabled, startTime, modRate, duration = C_Spell.GetSpellCooldown(418592).isEnabled, C_Spell.GetSpellCooldown(418592).startTime, C_Spell.GetSpellCooldown(418592).modRate, C_Spell.GetSpellCooldown(418592).duration
		else
			isEnabled, startTime, modRate, duration = GetSpellCooldown(418592)
		end
		if ( startTime > 0 and duration > 0) then
			local cdLeft = startTime + duration - GetTime()
			for i = 1,10 do
				DR.charge[i].texFill:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Points_Fill_CD.blp");
			end
		else
			for i = 1,10 do
				DR.charge[i].texFill:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Points_Fill.blp");
			end
		end
	end
end

DR.charge:SetScript("OnEvent", DR.toggleCharges)

function DR.vigorCounter(vigorCurrent)
	if not vigorCurrent then
		-- vigorCurrent will be nil during login I think
		return;
	end

	if not LibAdvFlight.IsAdvFlyEnabled() or DR.DriveUtils.IsDriving() then
		DR.toggleModels()
		return
	end

	if not DragonRider_DB.toggleModels then
		DR.toggleModels()
		return
	end

	if vigorCurrent == 0 then
		DR.toggleModels()
	end

	local frameLevelThing = UIWidgetPowerBarContainerFrame:GetFrameLevel()+15
	for i = 1,6 do
		if vigorCurrent >= i then
			DR.modelScene[i]:Show()
		else
			DR.modelScene[i]:Hide()
		end
		DR.modelScene[i]:SetFrameLevel(frameLevelThing)
	end
	DR.setPositions()
end

LibAdvFlight.RegisterCallback(LibAdvFlight.Events.VIGOR_CHANGED, DR.vigorCounter);

DR.EventsList = CreateFrame("Frame")

DR.EventsList:RegisterEvent("ADDON_LOADED")
DR.EventsList:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
DR.EventsList:RegisterEvent("MOUNT_JOURNAL_USABILITY_CHANGED")
DR.EventsList:RegisterEvent("LEARNED_SPELL_IN_TAB")
DR.EventsList:RegisterEvent("PLAYER_CAN_GLIDE_CHANGED")
DR.EventsList:RegisterEvent("COMPANION_UPDATE")
DR.EventsList:RegisterEvent("PLAYER_LOGIN")
DR.EventsList:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
DR.EventsList:RegisterEvent("UPDATE_UI_WIDGET")
DR.EventsList:SetScript("OnEvent", function(self, event, ...)
	if self[event] then
		self[event](self, ...);
	end
end);


function DR.GetWidgetAlpha()
	if UIWidgetPowerBarContainerFrame then
		return UIWidgetPowerBarContainerFrame:GetAlpha()
	end
end

function DR.GetVigorValueExact()
	if UnitPower("player", Enum.PowerType.AlternateMount) and C_UIWidgetManager.GetFillUpFramesWidgetVisualizationInfo(4460) then
		local fillCurrent = (UnitPower("player", Enum.PowerType.AlternateMount) + (C_UIWidgetManager.GetFillUpFramesWidgetVisualizationInfo(4460).fillValue*.01) )
		--local fillMin = C_UIWidgetManager.GetFillUpFramesWidgetVisualizationInfo(4460).fillMax
		local fillMax = C_UIWidgetManager.GetFillUpFramesWidgetVisualizationInfo(4460).numTotalFrames
		return fillCurrent, fillMax
	end
end

-- ugly hack fix for the vigor widget not disappearing when it should
LibAdvFlight.RegisterCallback(LibAdvFlight.Events.ADV_FLYING_DISABLED, function()
	for _, v in ipairs(DR.WidgetFrameIDs) do
		C_Timer.After(1, function()
			local f = UIWidgetPowerBarContainerFrame.widgetFrames[v];
			if f and f:IsShown() then
				f:Hide();
			end
		end);
	end
end);

function DR.SetupVigorToolip()
	EmbeddedItemTooltip:HookScript("OnShow", function(self)
		if not DragonRider_DB.showtooltip then
			for _, v in pairs(DR.WidgetFrameIDs) do
				local f = UIWidgetPowerBarContainerFrame.widgetFrames[v];
				if f then
					if self:GetOwner() == f then
						self:Hide();
					end
				end
			end
		end
	end);
end

local ParentFrame = CreateFrame("Frame", nil, UIParent)
ParentFrame:SetPoint("TOPLEFT", UIWidgetPowerBarContainerFrame, "TOPLEFT")
ParentFrame:SetPoint("BOTTOMRIGHT", UIWidgetPowerBarContainerFrame, "BOTTOMRIGHT")
-- this should solve that weird "moving" thing, the widget adjusts its size based on children


function DR.setPositions()
	DR.SetTheme()
	if DragonRider_DB.DynamicFOV == true then
		C_CVar.SetCVar("AdvFlyingDynamicFOVEnabled", 1)
	elseif DragonRider_DB.DynamicFOV == false then
		C_CVar.SetCVar("AdvFlyingDynamicFOVEnabled", 0)
	end

	ParentFrame:ClearAllPoints()
	ParentFrame:SetScale(UIWidgetPowerBarContainerFrame:GetScale()) -- because some of you are rescaling this thing...... the "moving vigor bar" was your fault.
	ParentFrame:SetPoint("TOPLEFT", UIWidgetPowerBarContainerFrame, "TOPLEFT")
	ParentFrame:SetPoint("BOTTOMRIGHT", UIWidgetPowerBarContainerFrame, "BOTTOMRIGHT")
	for k, v in pairs(DR.WidgetFrameIDs) do
		if UIWidgetPowerBarContainerFrame.widgetFrames[v] then
			ParentFrame:ClearAllPoints()
			ParentFrame:SetPoint("TOPLEFT", UIWidgetPowerBarContainerFrame.widgetFrames[v], "TOPLEFT")
			ParentFrame:SetPoint("BOTTOMRIGHT", UIWidgetPowerBarContainerFrame.widgetFrames[v], "BOTTOMRIGHT")
		end
	end
	DR.statusbar:ClearAllPoints();
	DR.statusbar:SetPoint("BOTTOM", ParentFrame, "TOP", 0, 5);
	if DragonRider_DB.speedometerPosPoint == 1 then
		DR.statusbar:ClearAllPoints();
		DR.statusbar:SetPoint("BOTTOM", ParentFrame, "TOP", DragonRider_DB.speedometerPosX, DragonRider_DB.speedometerPosY);
	elseif DragonRider_DB.speedometerPosPoint == 2 then
		DR.statusbar:ClearAllPoints();
		DR.statusbar:SetPoint("TOP", ParentFrame, "BOTTOM", DragonRider_DB.speedometerPosX, DragonRider_DB.speedometerPosY);
	elseif DragonRider_DB.speedometerPosPoint == 3 then
		DR.statusbar:ClearAllPoints();
		DR.statusbar:SetPoint("RIGHT", ParentFrame, "LEFT", DragonRider_DB.speedometerPosX, DragonRider_DB.speedometerPosY);
	elseif DragonRider_DB.speedometerPosPoint == 4 then
		DR.statusbar:ClearAllPoints();
		DR.statusbar:SetPoint("LEFT", ParentFrame, "RIGHT", DragonRider_DB.speedometerPosX, DragonRider_DB.speedometerPosY);
	end

	if C_UnitAuras.GetPlayerAuraBySpellID(417888) then
		DR.charge[1]:SetPoint("TOPLEFT", ParentFrame, "TOPLEFT", 45,8)
	else
		DR.charge[1]:SetPoint("TOPLEFT", ParentFrame, "TOPLEFT", 31,14)
	end
	DR.charge[1]:SetParent(ParentFrame)
	DR.charge[1]:SetScale(1.5625)

	for i = 1, 10 do
		if C_UnitAuras.GetPlayerAuraBySpellID(418590) and DragonRider_DB.lightningRush == true then
			DR.charge[i]:Show();
			DR:chargeSetup(i)
		else
			DR.charge[i]:Hide();
		end
	end

	local PowerBarChildren = {UIWidgetPowerBarContainerFrame:GetChildren()}
	if PowerBarChildren[3] ~= nil then
		for _, child in ipairs({PowerBarChildren[3]:GetRegions()}) do
			if DragonRider_DB.sideArt == false then
				child:SetAlpha(0)
			else
				child:SetAlpha(1)
			end
		end
	end
	DR.statusbar:SetScale(DragonRider_DB.speedometerScale)
	for i = 1,6 do
		DR.modelScene[i]:SetParent(ParentFrame)
		DR.modelScene[i]:ClearAllPoints();
	end

	if C_UnitAuras.GetPlayerAuraBySpellID(417888) then
		local spacing = 50
		if DR.model[1]:GetModelFileID() == 1100194 then
			for i = 1,6 do
				DR:modelSetup(i)
			end
		end
		-- algarian stormrider uses gems for the vigor bar, spacing is ~50
		if IsPlayerSpell(377922) == true then -- 6 vigor
			for i = 1,6 do
				DR.modelScene[i]:SetParent(ParentFrame)
				DR.modelScene[i]:SetPoint("CENTER", ParentFrame, "CENTER", -175+(i*spacing), 14);
			end
		elseif IsPlayerSpell(377921) == true then -- 5 vigor
			for i = 1,5 do
				DR.modelScene[i]:SetParent(ParentFrame)
				DR.modelScene[i]:SetPoint("CENTER", ParentFrame, "CENTER", -150+(i*spacing), 14);
			end
			for i = 6,6,-1 do
				DR.modelScene[i]:SetParent(ParentFrame)
				DR.modelScene[i]:Hide()
			end
		elseif IsPlayerSpell(377920) == true then -- 4 vigor
			for i = 1,4 do
				DR.modelScene[i]:SetParent(ParentFrame)
				DR.modelScene[i]:SetPoint("CENTER", ParentFrame, "CENTER", -125+(i*spacing), 14);
			end
			for i = 6,5,-1 do
				DR.modelScene[i]:SetParent(ParentFrame)
				DR.modelScene[i]:Hide()
			end
		else
			for i = 1,3 do
				DR.modelScene[i]:SetParent(ParentFrame)
				DR.modelScene[i]:SetPoint("CENTER", ParentFrame, "CENTER", -100+(i*spacing), 14);
			end
			for i = 6,4,-1 do
				DR.modelScene[i]:SetParent(ParentFrame)
				DR.modelScene[i]:Hide()
			end
		end
	else
		local spacing = 42
		if DR.model[1]:GetModelFileID() == 3009394 then
			for i = 1,6 do
				DR:modelSetup(i)
			end
		end
		--dragonriding is a spacing diff of 42
		if IsPlayerSpell(377922) == true then -- 6 vigor
			for i = 1,6 do
				DR.modelScene[i]:SetParent(ParentFrame)
				DR.modelScene[i]:SetPoint("CENTER", ParentFrame, "CENTER", -147+(i*spacing), 14);
			end
		elseif IsPlayerSpell(377921) == true then -- 5 vigor
			for i = 1,5 do
				DR.modelScene[i]:SetParent(ParentFrame)
				DR.modelScene[i]:SetPoint("CENTER", ParentFrame, "CENTER", -126+(i*spacing), 14);
			end
			for i = 6,6,-1 do
				DR.modelScene[i]:SetParent(ParentFrame)
				DR.modelScene[i]:Hide()
			end
		elseif IsPlayerSpell(377920) == true then -- 4 vigor
			for i = 1,4 do 
				DR.modelScene[i]:SetParent(ParentFrame)
				DR.modelScene[i]:SetPoint("CENTER", ParentFrame, "CENTER", -105+(i*spacing), 14);
			end
			for i = 6,5,-1 do
				DR.modelScene[i]:SetParent(ParentFrame)
				DR.modelScene[i]:Hide()
			end
		else
			for i = 1,3 do
				DR.modelScene[i]:SetParent(ParentFrame)
				DR.modelScene[i]:SetPoint("CENTER", ParentFrame, "CENTER", -84+(i*spacing), 14);
			end
			for i = 6,4,-1 do
				DR.modelScene[i]:SetParent(ParentFrame)
				DR.modelScene[i]:Hide()
			end
		end
	end

	DR.glide:SetFont(STANDARD_TEXT_FONT, DragonRider_DB.speedTextScale)
end

function DR.clearPositions()
	DR.HideWithFadeBar();
	for i = 1, 10 do
		DR.charge[i]:Hide();
	end
	DR.toggleModels()
end

DR.clearPositions();


local function Print(...)
	local prefix = string.format("|cFFFFF569"..L["DragonRider"] .. "|r:");
	DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", prefix, ...));
end

DR.commands = {
	[L["COMMAND_journal"]] = function()
		DR.mainFrame:Show();
	end,

	--[[
	["test"] = function()
		Print("Test.");
	end,

	["hello"] = function(subCommand)
		if not subCommand or subCommand == "" then
			Print("No Command");
		elseif subCommand == "world" then
			Print("Specified Command");
		else
			Print("Invalid Sub-Command");
		end
	end,
	]]

	[L["COMMAND_help"]] = function() --because there's not a lot of commands, don't use this yet.
		local concatenatedString
		for k, v in pairs(DR.commands) do
			if concatenatedString == nil then
				concatenatedString = "|cFF00D1FF"..k.."|r"
			else
				concatenatedString = concatenatedString .. ", ".. "|cFF00D1FF"..k.."|r"
			end
			
		end
		Print(L["COMMAND_listcommands"] .. " " .. concatenatedString)
	end
};

local function HandleSlashCommands(str)
	if (#str == 0) then
		DR.commands[L["COMMAND_journal"]]();
		return;
		end

		local args = {};
		for _dummy, arg in ipairs({ string.split(' ', str) }) do
		if (#arg > 0) then
			table.insert(args, arg);
			end
			end

			local path = DR.commands; -- required for updating found table.

			for id, arg in ipairs(args) do

			if (#arg > 0) then --if string length is greater than 0
			arg = arg:lower();          
			if (path[arg]) then
				if (type(path[arg]) == "function") then
					-- all remaining args passed to our function!
					path[arg](select(id + 1, unpack(args))); 
					return;                 
				elseif (type(path[arg]) == "table") then
					path = path[arg]; -- another sub-table found!
				end
				else
					DR.commands[L["COMMAND_journal"]]();
				return;
			end
		end
	end
end

local goldTime
local silverTime

function DR.MuteVigorSound()
	if DragonRider_DB.muteVigorSound == true then
		MuteSoundFile(1489541)
	else
		UnmuteSoundFile(1489541)
	end
end

-- event handling
function DR.EventsList:CURRENCY_DISPLAY_UPDATE(currencyID)
	-- update the temporary gold/silver time variables when their specific currencies update
	if currencyID == 2019 then
		silverTime = C_CurrencyInfo.GetCurrencyInfo(currencyID).quantity;
		return
	end
	if currencyID == 2020 then
		goldTime = C_CurrencyInfo.GetCurrencyInfo(currencyID).quantity;
		return
	end

	local raceLocation = DR.CurrencyToRaceMap and DR.CurrencyToRaceMap[currencyID]

	if raceLocation then
		local raceDataTable = DR.RaceData[raceLocation.zoneIndex].races[raceLocation.raceIndex][raceLocation.difficultyKey]

		-- if the static data is missing gold or silver time, save it
		if raceDataTable and (raceDataTable.goldTime == nil or raceDataTable.silverTime == nil) then
			if DragonRider_DB.raceDataCollector == nil then
				DragonRider_DB.raceDataCollector = {}
			end

			-- only save if we have valid gold/silver times from the last race completion
			if goldTime and silverTime and not DragonRider_DB.raceDataCollector[currencyID] then
				DragonRider_DB.raceDataCollector[currencyID] = {
					currencyID = currencyID,
					goldTime = goldTime,
					silverTime = silverTime
				}
				if DragonRider_DB.debug == true then
					Print("Saving Temp Race Data for Currency ID: " .. currencyID .. " (Gold: " .. goldTime .. ", Silver: " .. silverTime .. ")")
				end
			end
		end

		-- trigger a UI update in the journal to reflect the new score
		if DR.mainFrame and DR.mainFrame.UpdatePopulation then
			DR.mainFrame.UpdatePopulation()
		end

		if DragonRider_DB.debug == true then
			Print("Currency Update for Race: " .. currencyID .. ": " .. C_CurrencyInfo.GetCurrencyInfo(currencyID).name)
			Print("New Time: " .. C_CurrencyInfo.GetCurrencyInfo(currencyID).quantity/1000)
			Print("Last collected times - gold: " .. (goldTime or "N/A") .. ", silver: " .. (silverTime or "N/A"))
		end
	end
end


function DR.EventsList:PLAYER_LOGIN()
	DR.mainFrame.DoPopulationStuff();
	local SeasonID = PlayerGetTimerunningSeasonID()
	if SeasonID then -- needs to fire late to register any data
		DR.mainFrame.CreateDragonRiderFlipbook()
		DR.mainFrame.CreateDragonRiderFlipbook()
		DR.mainFrame.CreateDragonRiderFlipbookRotated()
		DR.mainFrame.CreateDragonRiderFlipbookRotated()
		DR.mainFrame.CreateFadeIcon()
		-- double the frames to make it appear more vibrant, as the flipbook is fairly muted
	end
end

function DR.OnAddonLoaded()
	--[[ -- hiding code test
	if event == "UPDATE_UI_WIDGET" then
		if UIWidgetPowerBarContainerFrame and UIWidgetPowerBarContainerFrame.widgetFrames[4460] then
			if (UIWidgetPowerBarContainerFrame.widgetFrames[4460]:IsShown()) then
				UIWidgetPowerBarContainerFrame.widgetFrames[4460]:Hide()
			end
		end
	end
	]]

	do
		local realmKey = GetRealmName()
		local charKey = UnitName("player") .. " - " .. realmKey

		SLASH_DRAGONRIDER1 = "/"..L["COMMAND_dragonrider"]
		SlashCmdList.DRAGONRIDER = HandleSlashCommands;

		if DragonRider_DB == nil then
			DragonRider_DB = CopyTable(defaultsTable)
		end

		-- build the currency-to-race lookup map on addon load.
		do
			local function buildCurrencyMap()
				DR.CurrencyToRaceMap = {} -- Clear it in case of reloads
				if not DR.RaceData then return end -- Guard against DRRaceData not being loaded yet
			
				for zoneIndex, zoneData in ipairs(DR.RaceData) do
					if zoneData.races then
						for raceIndex, raceInfo in ipairs(zoneData.races) do
							for difficultyKey, difficultyData in pairs(raceInfo) do
								-- Check if it's a difficulty table by looking for currencyID
								if type(difficultyData) == "table" and difficultyData.currencyID then
									DR.CurrencyToRaceMap[difficultyData.currencyID] = {
										zoneIndex = zoneIndex,
										raceIndex = raceIndex,
										difficultyKey = difficultyKey
									}
								end
							end
						end
					end
				end
			end
			buildCurrencyMap()
		end

		if DragonRider_DB.sideArt == nil then
			DragonRider_DB.sideArt = true
		end
		if DragonRider_DB.sideArtStyle == nil then
			DragonRider_DB.sideArtStyle = 1
		end
		if DragonRider_DB.tempFixes == nil then
			DragonRider_DB.tempFixes = {};
		end
		if DragonRider_DB.tempFixes.hideVigor == nil then -- this is now deprecated
			DragonRider_DB.tempFixes.hideVigor = true
		end
		if DragonRider_DB.showtooltip == nil then
			DragonRider_DB.showtooltip = true
		end
		if DragonRider_DB.fadeVigor == nil then
			DragonRider_DB.fadeVigor = false
		end
		--if DragonRider_DB.fadeSpeed == nil then
		--	DragonRider_DB.fadeSpeed = true
		--end
		if DragonRider_DB.lightningRush == nil then
			DragonRider_DB.lightningRush = true
		end
		if DragonRider_DB.DynamicFOV == nil then
			if C_CVar.GetCVar("AdvFlyingDynamicFOVEnabled") == "1" then
				DragonRider_DB.DynamicFOV = true
			elseif C_CVar.GetCVar("AdvFlyingDynamicFOVEnabled") == "0" then
				DragonRider_DB.DynamicFOV = false
			end
		end
		if DragonRider_DB.mainFrameSize == nil then
			DragonRider_DB.mainFrameSize = {
				width = 550,
				height = 525,
			};
		end
		if DragonRider_DB.mainFrameSize ~= nil then
			DR.mainFrame:SetSize(DragonRider_DB.mainFrameSize.width, DragonRider_DB.mainFrameSize.height);
		end
		if DragonRider_DB.useAccountData == nil then
			DragonRider_DB.useAccountData = false;
		else
			DR.mainFrame.accountAll_Checkbox:SetChecked(DragonRider_DB.useAccountData)
		end
		if DragonRider_DB.raceData == nil then
			DragonRider_DB.raceData = {};
			DragonRider_DB.raceData[charKey] = {};
		end
		if DragonRider_DB.muteVigorSound == nil then
			DragonRider_DB.muteVigorSound = false
		end
		DR.MuteVigorSound()
		if DragonRider_DB.themeSpeed == nil then
			DragonRider_DB.themeSpeed = 1
		end

		---------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------

		local version, bild = GetBuildInfo(); -- temp fix for beta
		--local IS_FUTURE = (version == "11.0.2") and tonumber(bild) > 55763;

		local function OnSettingChanged(_, setting, value)
			local variable = setting:GetVariable()

			if strsub(variable, 1, 3) == "DR_" then
				variable = strsub(variable, 4); -- remove our prefix so it matches existing savedvar keys
			end

			DR.vigorCounter()
			DR.setPositions()
			DR.MuteVigorSound()
		end

		local category, layout = Settings.RegisterVerticalLayoutCategory("Dragon Rider")

		local categorySpeedometer, layoutSpeedometer = Settings.RegisterVerticalLayoutSubcategory(category, L["ProgressBar"]);

		local categoryVigor, layoutVigor = Settings.RegisterVerticalLayoutSubcategory(category, L["Vigor"]);

		--local subcategory, layout2 = Settings.RegisterVerticalLayoutSubcategory(category, "my very own subcategory")

		--layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(string.format(L["Version"], GetAddOnMetadata("DragonRider", "Version"))));

		--layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L["ProgressBar"])); -- moved to subcategory

		local CreateDropdown = Settings.CreateDropdown or Settings.CreateDropDown
		local CreateCheckbox = Settings.CreateCheckbox or Settings.CreateCheckBox

		local function RegisterSetting(variableKey, defaultValue, name)
			local uniqueVariable = "DR_" .. variableKey; -- these have to be unique or calamity ensues, savedvars will be unaffected

			local setting;
			setting = Settings.RegisterAddOnSetting(category, uniqueVariable, variableKey, DragonRider_DB, type(defaultValue), name, defaultValue);

			setting:SetValue(DragonRider_DB[variableKey]);
			Settings.SetOnValueChangedCallback(uniqueVariable, OnSettingChanged);

			return setting;
		end

		
		
		--[[
		do
			local variable = "fadeSpeed"
			local name = L["FadeSpeedometer"]
			local tooltip = L["FadeSpeedometerTT"]
			local defaultValue = true

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateCheckbox(category, setting, tooltip)
		end
		]]

		--layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L["Vigor"])); -- moved to subcategory

		

		layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(SPECIAL));

		do
			local variable = "lightningRush"
			local name = L["LightningRush"]
			local tooltip = L["LightningRushTT"]
			local defaultValue = true

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateCheckbox(category, setting, tooltip)
		end

		do
			local variable = "DynamicFOV"
			local name = L["DynamicFOV"]
			local tooltip = L["DynamicFOVTT"]
			local defaultValue = true

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateCheckbox(category, setting, tooltip)
		end

		layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L["DragonridingTalents"]));

		do -- dragonriding talents 
			local function OnButtonClick()
				CloseWindows();
				DragonridingPanelSkillsButtonMixin:OnClick();
			end

			local initializer = CreateSettingsButtonInitializer(L["OpenDragonridingTalents"], L["DragonridingTalents"], OnButtonClick, L["OpenDragonridingTalentsTT"], true);
			layout:AddInitializer(initializer);
		end

		layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(RESET));

		StaticPopupDialogs["DRAGONRIDER_RESET_SETTINGS"] = {
			text = L["ResetAllSettingsConfirm"],
			button1 = YES,
			button2 = NO,
			OnAccept = function()
				DragonRider_DB = CopyTable(defaultsTable);
				DR.vigorCounter();
				DR.setPositions();
				DR.MuteVigorSound();
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
		};

		do -- color picker - high speed text color
			local function OnButtonClick()
				StaticPopup_Show("DRAGONRIDER_RESET_SETTINGS");
			end

			local initializer = CreateSettingsButtonInitializer(L["ResetAllSettings"], RESET, OnButtonClick, L["ResetAllSettingsTT"], true);
			layout:AddInitializer(initializer);
		end

		Settings.RegisterAddOnCategory(category)

		-- Speedometer Subcategory

		do
			local variable = "themeSpeed"
			local defaultValue = 1  -- Corresponds to "Option 1" below.
			local name = L["SpeedometerTheme"]
			local tooltip = L["SpeedometerThemeTT"]

			local function GetOptions()
				local container = Settings.CreateControlTextContainer()
				container:Add(1, L["Default"])
				container:Add(2, L["Algari"])
				container:Add(3, L["Minimalist"])
				container:Add(4, L["Alliance"])
				container:Add(5, L["Horde"])
				return container:GetData()
			end

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateDropdown(categorySpeedometer, setting, GetOptions, tooltip)
		end

		do
			local variable = "speedometerPosPoint"
			local defaultValue = 1  -- Corresponds to "Option 1" below.
			local name = L["SpeedPosPointName"]
			local tooltip = L["SpeedPosPointTT"]

			local function GetOptions()
				local container = Settings.CreateControlTextContainer()
				container:Add(1, L["Top"])
				container:Add(2, L["Bottom"])
				container:Add(3, L["Left"])
				container:Add(4, L["Right"])
				return container:GetData()
			end

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateDropdown(categorySpeedometer, setting, GetOptions, tooltip);
		end

		do
			local variable = "speedometerPosX"
			local name = L["SpeedPosXName"]
			local tooltip = L["SpeedPosXTT"]
			local defaultValue = 0
			local minValue = -Round(GetScreenWidth())
			local maxValue = Round(GetScreenWidth())
			local step = 1

			local setting = RegisterSetting(variable, defaultValue, name);
			local options = Settings.CreateSliderOptions(minValue, maxValue, step);
			options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
			Settings.CreateSlider(categorySpeedometer, setting, options, tooltip);
		end

		do
			local variable = "speedometerPosY"
			local name = L["SpeedPosYName"]
			local tooltip = L["SpeedPosYTT"]
			local defaultValue = 5
			local minValue = -Round(GetScreenHeight())
			local maxValue = Round(GetScreenHeight())
			local step = 1

			local setting = RegisterSetting(variable, defaultValue, name);
			local options = Settings.CreateSliderOptions(minValue, maxValue, step)
			options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
			Settings.CreateSlider(categorySpeedometer, setting, options, tooltip)
		end

		do
			local variable = "speedometerWidth"
			local name = "[PH]"..L["speedometerWidthName"]
			local tooltip = "[PH]"..L["speedometerWidthTT"]
			local defaultValue = 244
			local minValue = 10
			local maxValue = 500
			local step = 1

			local setting = RegisterSetting(variable, defaultValue, name);
			local options = Settings.CreateSliderOptions(minValue, maxValue, step)
			options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
			Settings.CreateSlider(categorySpeedometer, setting, options, tooltip)
		end

		do
			local variable = "speedometerHeight"
			local name = "[PH]"..L["speedometerHeightName"]
			local tooltip = "[PH]"..L["speedometerHeightTT"]
			local defaultValue = 24
			local minValue = 10
			local maxValue = 500
			local step = 1

			local setting = RegisterSetting(variable, defaultValue, name);
			local options = Settings.CreateSliderOptions(minValue, maxValue, step)
			options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
			Settings.CreateSlider(categorySpeedometer, setting, options, tooltip)
		end

		-- scale is essentially defunct with width/height
		--do
		--	local variable = "speedometerScale"
		--	local name = L["SpeedScaleName"]
		--	local tooltip = L["SpeedScaleTT"]
		--	local defaultValue = 1
		--	local minValue = .4
		--	local maxValue = 4
		--	local step = .1
--
		--	local setting = RegisterSetting(variable, defaultValue, name);
		--	local options = Settings.CreateSliderOptions(minValue, maxValue, step)
		--	options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
		--	Settings.CreateSlider(categorySpeedometer, setting, options, tooltip)
		--end

		do
			local variable = "speedValUnits"
			local defaultValue = 1  -- Corresponds to "Option 1" below.
			local name = L["Units"]
			local tooltip = L["UnitsTT"]

			local function GetOptions()
				local container = Settings.CreateControlTextContainer()
				container:Add(1, L["Yards"] .. " - " .. L["UnitYards"])
				container:Add(2, L["Miles"] .. " - " .. L["UnitMiles"])
				container:Add(3, L["Meters"] .. " - " .. L["UnitMeters"])
				container:Add(4, L["Kilometers"] .. " - " .. L["UnitKilometers"])
				container:Add(5, L["Percent"] .. " - " .. L["UnitPercent"])
				container:Add(6, NONE)
				return container:GetData()
			end

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateDropdown(categorySpeedometer, setting, GetOptions, tooltip)
		end

		do
			local variable = "speedTextScale"
			local name = L["SpeedTextScale"]
			local tooltip = L["SpeedTextScaleTT"]
			local defaultValue = 12
			local minValue = 2
			local maxValue = 30
			local step = .5

			local setting = RegisterSetting(variable, defaultValue, name);
			local options = Settings.CreateSliderOptions(minValue, maxValue, step)
			options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
			Settings.CreateSlider(categorySpeedometer, setting, options, tooltip)
		end

		layoutSpeedometer:AddInitializer(CreateSettingsListSectionHeaderInitializer(COLOR_PICKER));

		do -- color picker - low progress bar color
			local function OnButtonClick()
				DR:ShowColorPicker(DragonRider_DB.speedBarColor.slow);
			end

			local initializer = CreateSettingsButtonInitializer(L["ProgressBarColor"] .. " - " .. L["Low"], COLOR_PICKER, OnButtonClick, L["ColorPickerLowProgTT"], true);
			layoutSpeedometer:AddInitializer(initializer);
		end

		do -- color picker - mid progress bar color
			local function OnButtonClick()
				DR:ShowColorPicker(DragonRider_DB.speedBarColor.vigor);
			end

			local initializer = CreateSettingsButtonInitializer(L["ProgressBarColor"] .. " - " .. "[PH]"..L["Recharge"], COLOR_PICKER, OnButtonClick, L["ColorPickerMidProgTT"], true);
			layoutSpeedometer:AddInitializer(initializer);
		end

		do -- color picker - high progress bar color
			local function OnButtonClick()
				DR:ShowColorPicker(DragonRider_DB.speedBarColor.over);
			end

			local initializer = CreateSettingsButtonInitializer(L["ProgressBarColor"] .. " - " .. L["High"], COLOR_PICKER, OnButtonClick, L["ColorPickerHighProgTT"], true);
			layoutSpeedometer:AddInitializer(initializer);
		end

		do -- color picker - low speed text color
			local function OnButtonClick()
				DR:ShowColorPicker(DragonRider_DB.speedTextColor.slow);
			end

			local initializer = CreateSettingsButtonInitializer(L["UnitsColor"] .. " - " .. L["Low"], COLOR_PICKER, OnButtonClick, L["ColorPickerLowTextTT"], true);
			layoutSpeedometer:AddInitializer(initializer);
		end

		do -- color picker - mid speed text color
			local function OnButtonClick()
				DR:ShowColorPicker(DragonRider_DB.speedTextColor.vigor);
			end

			local initializer = CreateSettingsButtonInitializer(L["UnitsColor"] .. " - " .. "[PH]"..L["Recharge"], COLOR_PICKER, OnButtonClick, L["ColorPickerMidTextTT"], true);
			layoutSpeedometer:AddInitializer(initializer);
		end

		do -- color picker - high speed text color
			local function OnButtonClick()
				DR:ShowColorPicker(DragonRider_DB.speedTextColor.over);
			end

			local initializer = CreateSettingsButtonInitializer(L["UnitsColor"] .. " - " .. L["High"], COLOR_PICKER, OnButtonClick, L["ColorPickerHighTextTT"], true);
			layoutSpeedometer:AddInitializer(initializer);
		end


		Settings.RegisterAddOnCategory(categorySpeedometer)

		-- Vigor Subcategory

		do
			local variable = "themeVigor"
			local defaultValue = 1  -- Corresponds to "Option 1" below.
			local name = "[PH]"..L["VigorTheme"]
			local tooltip = "[PH]"..L["VigorThemeTT"]

			local function GetOptions()
				local container = Settings.CreateControlTextContainer()
				container:Add(1, L["Default"])
				container:Add(2, L["Algari"])
				container:Add(3, L["Minimalist"])
				--container:Add(4, L["Alliance"])
				--container:Add(5, L["Horde"])
				return container:GetData()
			end

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateDropdown(categoryVigor, setting, GetOptions, tooltip)
		end

		do
			local variable = "vigorPosX"
			local name = "[PH]"..L["VigorPosXName"]
			local tooltip = L["VigorPosXNameTT"]
			local defaultValue = 0
			local minValue = -Round(GetScreenWidth())
			local maxValue = Round(GetScreenWidth())
			local step = 1

			local setting = RegisterSetting(variable, defaultValue, name);
			local options = Settings.CreateSliderOptions(minValue, maxValue, step);
			options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
			Settings.CreateSlider(categoryVigor, setting, options, tooltip);
		end

		do
			local variable = "vigorPosY"
			local name = "[PH]"..L["VigorPosYName"]
			local tooltip = "[PH]"..L["VigorPosYNameTT"]
			local defaultValue = 0
			local minValue = -Round(GetScreenWidth())
			local maxValue = Round(GetScreenWidth())
			local step = 1

			local setting = RegisterSetting(variable, defaultValue, name);
			local options = Settings.CreateSliderOptions(minValue, maxValue, step);
			options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
			Settings.CreateSlider(categoryVigor, setting, options, tooltip);
		end

		do
			local variable = "vigorBarWidth"
			local name = "[PH]"..L["VigorBarWidthName"]
			local tooltip = "[PH]"..L["VigorBarWidthNameTT"]
			local defaultValue = 0
			local minValue = -Round(GetScreenWidth())
			local maxValue = Round(GetScreenWidth())
			local step = 1

			local setting = RegisterSetting(variable, defaultValue, name);
			local options = Settings.CreateSliderOptions(minValue, maxValue, step);
			options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
			Settings.CreateSlider(categoryVigor, setting, options, tooltip);
		end

		do
			local variable = "vigorBarHeight"
			local name = "[PH]"..L["VigorBarHeightName"]
			local tooltip = "[PH]"..L["VigorBarHeightNameTT"]
			local defaultValue = 0
			local minValue = -Round(GetScreenWidth())
			local maxValue = Round(GetScreenWidth())
			local step = 1

			local setting = RegisterSetting(variable, defaultValue, name);
			local options = Settings.CreateSliderOptions(minValue, maxValue, step);
			options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
			Settings.CreateSlider(categoryVigor, setting, options, tooltip);
		end

		do
			local variable = "vigorBarSpacing"
			local name = "[PH]"..L["VigorBarSpacingName"]
			local tooltip = "[PH]"..L["VigorBarSpacingNameTT"]
			local defaultValue = 0
			local minValue = -Round(GetScreenWidth())
			local maxValue = Round(GetScreenWidth())
			local step = 1

			local setting = RegisterSetting(variable, defaultValue, name);
			local options = Settings.CreateSliderOptions(minValue, maxValue, step);
			options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
			Settings.CreateSlider(categoryVigor, setting, options, tooltip);
		end

		do
			local variable = "vigorBarOrientation"
			local defaultValue = 1  -- Corresponds to "Option 1" below.
			local name = "[PH]"..L["VigorBarOrientationName"]
			local tooltip = "[PH]"..L["VigorBarOrientationNameTT"]

			local function GetOptions()
				local container = Settings.CreateControlTextContainer()
				container:Add(1, "[PH]"..L["Orientation_Vertical"])
				container:Add(2, "[PH]"..L["Orientation_Horizontal"])
				return container:GetData()
			end

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateDropdown(categoryVigor, setting, GetOptions, tooltip)
		end

		do
			local variable = "vigorBarDirection"
			local defaultValue = 1  -- Corresponds to "Option 1" below.
			local name = "[PH]"..L["VigorBarDirectionName"]
			local tooltip = "[PH]"..L["VigorBarDirectionNameTT"]

			local function GetOptions()
				local container = Settings.CreateControlTextContainer()
				container:Add(1, "[PH]"..L["Direction_DownRight"])
				container:Add(2, "[PH]"..L["Direction_UpLeft"])
				return container:GetData()
			end

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateDropdown(categoryVigor, setting, GetOptions, tooltip)
		end

		do
			local variable = "vigorWrap"
			local name = "[PH]"..L["VigorWrapName"]
			local tooltip = L["VigorWrapNameTT"]
			local defaultValue = 0
			local minValue = 1
			local maxValue = 6
			local step = 1

			local setting = RegisterSetting(variable, defaultValue, name);
			local options = Settings.CreateSliderOptions(minValue, maxValue, step);
			options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
			Settings.CreateSlider(categoryVigor, setting, options, tooltip);
		end

		do
			local variable = "vigorBarFillDirection"
			local defaultValue = 1  -- Corresponds to "Option 1" below.
			local name = "[PH]"..L["VigorBarFillDirectionName"]
			local tooltip = "[PH]"..L["VigorBarFillDirectionNameTT"]

			local function GetOptions()
				local container = Settings.CreateControlTextContainer()
				container:Add(1, "[PH]"..L["Direction_DownRight"])
				container:Add(2, "[PH]"..L["Direction_UpLeft"])
				return container:GetData()
			end

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateDropdown(categoryVigor, setting, GetOptions, tooltip)
		end

		do
			local variable = "vigorSparkWidth"
			local name = "[PH]"..L["VigorSparkWidthName"]
			local tooltip = "[PH]"..L["VigorSparkWidthNameTT"]
			local defaultValue = 0
			local minValue = -Round(GetScreenWidth())
			local maxValue = Round(GetScreenWidth())
			local step = 1

			local setting = RegisterSetting(variable, defaultValue, name);
			local options = Settings.CreateSliderOptions(minValue, maxValue, step);
			options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
			Settings.CreateSlider(categoryVigor, setting, options, tooltip);
		end

		do
			local variable = "vigorSparkHeight"
			local name = "[PH]"..L["VigorSparkHeightName"]
			local tooltip = "[PH]"..L["VigorSparkHeightNameTT"]
			local defaultValue = 0
			local minValue = -Round(GetScreenWidth())
			local maxValue = Round(GetScreenWidth())
			local step = 1

			local setting = RegisterSetting(variable, defaultValue, name);
			local options = Settings.CreateSliderOptions(minValue, maxValue, step);
			options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
			Settings.CreateSlider(categoryVigor, setting, options, tooltip);
		end

		do
			local variable = "toggleFlashFull"
			local name = "[PH]"..L["ToggleFlashFullName"]
			local tooltip = "[PH]"..L["ToggleFlashFullNameTT"]
			local defaultValue = true

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateCheckbox(categoryVigor, setting, tooltip)
		end

		do
			local variable = "toggleFlashProgress"
			local name = "[PH]"..L["toggleFlashProgressName"]
			local tooltip = "[PH]"..L["toggleFlashProgressNameTT"]
			local defaultValue = true

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateCheckbox(categoryVigor, setting, tooltip)
		end

		do
			local variable = "toggleModels"
			local name = L["ToggleModelsName"]
			local tooltip = L["ToggleModelsTT"]
			local defaultValue = true

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateCheckbox(categoryVigor, setting, tooltip)
		end

		do
			local variable = "sideArt"
			local name = L["SideArtName"]
			local tooltip = L["SideArtTT"]
			local defaultValue = true

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateCheckbox(categoryVigor, setting, tooltip)
		end

		do
			local variable = "showtooltip"
			local name = L["ShowVigorTooltip"]
			local tooltip = L["ShowVigorTooltipTT"]
			local defaultValue = true

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateCheckbox(categoryVigor, setting, tooltip)
		end

		do
			local variable = "muteVigorSound"
			local name = L["MuteVigorSound_Settings"]
			local tooltip = L["MuteVigorSound_SettingsTT"]
			local defaultValue = false

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateCheckbox(categoryVigor, setting, tooltip)
		end

		layoutVigor:AddInitializer(CreateSettingsListSectionHeaderInitializer(COLOR_PICKER));

		do -- color picker - low progress bar color
			local function OnButtonClick()
				DR:ShowColorPicker(DragonRider_DB.vigorBarColor.full);
			end

			local initializer = CreateSettingsButtonInitializer("[PH]"..L["VigorColor"] .. " - " .. "[PH]"..L["Full"], COLOR_PICKER, OnButtonClick, L["ColorPickerLowProgTT"], true);
			layoutVigor:AddInitializer(initializer);
		end

		do -- color picker - mid progress bar color
			local function OnButtonClick()
				DR:ShowColorPicker(DragonRider_DB.vigorBarColor.empty);
			end

			local initializer = CreateSettingsButtonInitializer("[PH]"..L["VigorColor"] .. " - " .. "[PH]"..L["Empty"], COLOR_PICKER, OnButtonClick, L["ColorPickerMidProgTT"], true);
			layoutVigor:AddInitializer(initializer);
		end

		do -- color picker - high progress bar color
			local function OnButtonClick()
				DR:ShowColorPicker(DragonRider_DB.vigorBarColor.progress);
			end

			local initializer = CreateSettingsButtonInitializer("[PH]"..L["VigorColor"] .. " - " .. "[PH]"..L["Progress"], COLOR_PICKER, OnButtonClick, L["ColorPickerHighProgTT"], true);
			layoutVigor:AddInitializer(initializer);
		end

		do -- color picker - low speed text color
			local function OnButtonClick()
				DR:ShowColorPicker(DragonRider_DB.vigorBarColor.spark);
			end

			local initializer = CreateSettingsButtonInitializer("[PH]"..L["VigorColor"] .. " - " .. "[PH]"..L["Spark"], COLOR_PICKER, OnButtonClick, L["ColorPickerLowTextTT"], true);
			layoutVigor:AddInitializer(initializer);
		end

		do -- color picker - mid speed text color
			local function OnButtonClick()
				DR:ShowColorPicker(DragonRider_DB.vigorBarColor.cover);
			end

			local initializer = CreateSettingsButtonInitializer("[PH]"..L["VigorColor"] .. " - " .. "[PH]"..L["Cover"], COLOR_PICKER, OnButtonClick, L["ColorPickerMidTextTT"], true);
			layoutVigor:AddInitializer(initializer);
		end

		do -- color picker - high speed text color
			local function OnButtonClick()
				DR:ShowColorPicker(DragonRider_DB.vigorBarColor.flash);
			end

			local initializer = CreateSettingsButtonInitializer("[PH]"..L["VigorColor"] .. " - " .. "[PH]"..L["Flash"], COLOR_PICKER, OnButtonClick, L["ColorPickerHighTextTT"], true);
			layoutVigor:AddInitializer(initializer);
		end

		Settings.RegisterAddOnCategory(categoryVigor)


		function DragonRider_OnAddonCompartmentClick(addonName, buttonName, menuButtonFrame)
			if buttonName == "RightButton" then
				Settings.OpenToCategory(category.ID);
			else
				DR.mainFrame:Show();
			end
		end

		function DragonRider_OnAddonCompartmentEnter(addonName, menuButtonFrame)
			local tooltipData = {
				[1] = L["DragonRider"],
				[2] = L["RightClick_TT_Line"],
				[3] = L["LeftClick_TT_Line"],
				[4] = L["SlashCommands_TT_Line"]
			}
			local concatenatedString
			for k, v in ipairs(tooltipData) do
				if concatenatedString == nil then
					concatenatedString = v
				else
					concatenatedString = concatenatedString .. "\n".. v
				end
			end
			DR.tooltip_OnEnter(menuButtonFrame, concatenatedString);
		end

		function DragonRider_OnAddonCompartmentLeave(addonName, menuButtonFrame)
			DR.tooltip_OnLeave();
		end

		---------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------

		-- when the player takes off and starts flying
		local function OnAdvFlyStart()
			DR.ShowWithFadeBar();
			DR.setPositions();
		end

		-- when the player mounts but isn't flying yet
		-- OR when the player lands after flying but is still mounted
		local function OnAdvFlyEnabled()
			DR.HideWithFadeBar();
			DR.setPositions();
		end

		local function OnAdvFlyEnd()
			DR.HideWithFadeBar();
			DR.setPositions();
		end

		-- when the player dismounts
		local function OnAdvFlyDisabled()
			DR.HideWithFadeBar();
			DR.clearPositions();
		end

		LibAdvFlight.RegisterCallback(LibAdvFlight.Events.ADV_FLYING_START, OnAdvFlyStart);
		LibAdvFlight.RegisterCallback(LibAdvFlight.Events.ADV_FLYING_END, OnAdvFlyEnd);
		LibAdvFlight.RegisterCallback(LibAdvFlight.Events.ADV_FLYING_ENABLED, OnAdvFlyEnabled);
		LibAdvFlight.RegisterCallback(LibAdvFlight.Events.ADV_FLYING_DISABLED, OnAdvFlyDisabled);

		local function OnDriveStart()
			if DR.DriveUtils.IsDriving() then
				OnAdvFlyStart();
			end
		end

		local function OnDriveEnd()
			if not DR.DriveUtils.IsDriving() then
				OnAdvFlyEnd();
			end
		end

		local f = CreateFrame("Frame");
		f:SetScript("OnEvent", function(self, event, ...)
			if event == "PLAYER_GAINS_VEHICLE_DATA" then
				OnDriveStart();
			elseif event == "PLAYER_LOSES_VEHICLE_DATA" then
				OnDriveEnd();
			end
		end);
		f:RegisterEvent("PLAYER_GAINS_VEHICLE_DATA");
		f:RegisterEvent("PLAYER_LOSES_VEHICLE_DATA");

		-- this will run every frame, forever :)
		-- put anything that needs to run every frame in here
		local function OnUpdate()
			DR.updateSpeed();
		end

		C_Timer.NewTicker(0.1, OnUpdate);

		DR.SetupVigorToolip();
	end
end

EventUtil.ContinueOnAddOnLoaded("DragonRider", DR.OnAddonLoaded);