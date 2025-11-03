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
	speedometerWidth = 244,
	speedometerHeight = 24,
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
			a=1,
		},
		vigor = {
			r=1,
			g=1,
			b=1,
			a=1,
		},
		over = {
			r=1,
			g=1,
			b=1,
			a=1,
		},
	},
	speedTextScale = 12,
	glyphDetector = true, -- unused
	vigorProgressStyle = 1, -- 1 = vertical, 2 = horizontal, 3 = cooldown
	cooldownTimer = { -- unused
		whirlingSurge = true,
		bronzeTimelock = true,
		aerialHalt = true,
	},
	barStyle = 1, -- this is now deprecated
	statistics = {},
	multiplayer = true,
	sideArt = true,
	sideArtStyle = 1,
	sideArtPosX = -15,
	sideArtPosY = -10,
	tempFixes = {
		hideVigor = true, -- this is now deprecated
	},
	showtooltip = true,  -- this is now deprecated
	fadeVigor = false, -- this is now deprecated
	fadeSpeed = true,  -- this is now deprecated
	lightningRush = true,
	muteVigorSound = false,
	themeSpeed = 1, -- default
	themeVigor = 1, -- default
	vigorPosX = 0,
	vigorPosY = -200,
	vigorBarWidth = 32,
	vigorBarHeight = 32,
	vigorBarSpacing = 10,
	vigorBarOrientation = 1,
	vigorBarDirection = 1,
	vigorWrap = 6,
	vigorBarFillDirection = 1,
	vigorSparkWidth = 32,
	vigorSparkHeight = 12,
	toggleFlashFull = true,
	toggleFlashProgress = true,
	modelTheme = 1,
	vigorBarColor = {
		full = {
			r=0.24,
			g=0.84,
			b=1.0,
			a=1.0,
		},
		empty = {
			r=0.3,
			g=0.3,
			b=0.3,
			a=1.0,
		},
		progress = {
			r=1.0,
			g=1.0,
			b=1.0,
			a=1.0,
		},
		spark = {
			r=1.0,
			g=1.0,
			b=1.0,
			a=0.9,
		},
		cover = {
			r=0.4,
			g=0.4,
			b=0.4,
			a=1.0,
		},
		flash = {
			r=1.0,
			g=1.0,
			b=1.0,
			a=1.0,
		},
		decor = {
			r=0.4,
			g=0.4,
			b=0.4,
			a=1.0,
		},
	},
};

DR.defaultsTable = defaultsTable

function DR.MergeDefaults(saved, defaults)
	for key, defaultValue in pairs(defaults) do
		local savedValue = saved[key]

		if savedValue == nil then
			if type(defaultValue) == "table" then
				saved[key] = CopyTable(defaultValue) 
			else
				saved[key] = defaultValue
			end
		elseif type(savedValue) == "table" and type(defaultValue) == "table" then
			DR.MergeDefaults(savedValue, defaultValue)
		end
	end
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

LibAdvFlight.RegisterCallback(LibAdvFlight.Events.VIGOR_CHANGED, DR.vigorCounter);

DR.EventsList = CreateFrame("Frame")

DR.EventsList:RegisterEvent("ADDON_LOADED")
DR.EventsList:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
DR.EventsList:RegisterEvent("MOUNT_JOURNAL_USABILITY_CHANGED")
if LE_EXPANSION_LEVEL_CURRENT <= LE_EXPANSION_WAR_WITHIN then
	DR.EventsList:RegisterEvent("LEARNED_SPELL_IN_TAB")
end
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
	if SettingsPanel:IsShown() then return end
	if DragonRider_DB.DynamicFOV == true then
		C_CVar.SetCVar("AdvFlyingDynamicFOVEnabled", 1)
	elseif DragonRider_DB.DynamicFOV == false then
		C_CVar.SetCVar("AdvFlyingDynamicFOVEnabled", 0)
	end

	-- Setup ParentFrame anchor
	ParentFrame:ClearAllPoints()
	ParentFrame:SetScale(UIWidgetPowerBarContainerFrame:GetScale()) -- because some of you are rescaling this thing...... the "moving vigor bar" was your fault.
	ParentFrame:SetPoint("TOPLEFT", UIWidgetPowerBarContainerFrame, "TOPLEFT")
	ParentFrame:SetPoint("BOTTOMRIGHT", UIWidgetPowerBarContainerFrame, "BOTTOMRIGHT")
	for k, v in pairs(DR.WidgetFrameIDs) do
		if UIWidgetPowerBarContainerFrame.widgetFrames[v] and UIWidgetPowerBarContainerFrame.widgetFrames[v]:IsShown() then
			ParentFrame:ClearAllPoints()
			ParentFrame:SetPoint("TOPLEFT", UIWidgetPowerBarContainerFrame.widgetFrames[v], "TOPLEFT")
			ParentFrame:SetPoint("BOTTOMRIGHT", UIWidgetPowerBarContainerFrame.widgetFrames[v], "BOTTOMRIGHT")
		end
	end

	-- Position Speedometer
	DR.statusbar:ClearAllPoints();
	local point, relPoint, xOff, yOff = "BOTTOM", "TOP", DragonRider_DB.speedometerPosX, DragonRider_DB.speedometerPosY
	if DragonRider_DB.speedometerPosPoint == 2 then
		point, relPoint = "TOP", "BOTTOM"
	elseif DragonRider_DB.speedometerPosPoint == 3 then
		point, relPoint = "RIGHT", "LEFT"
	elseif DragonRider_DB.speedometerPosPoint == 4 then
		point, relPoint = "LEFT", "RIGHT"
	end
	DR.statusbar:SetPoint(point, ParentFrame, relPoint, xOff, yOff);
	DR.statusbar:SetScale(DragonRider_DB.speedometerScale)
	DR.glide:SetFont(STANDARD_TEXT_FONT, DragonRider_DB.speedTextScale)
	
	-- Position Custom Vigor Bar
	DR.vigorBar:SetParent(ParentFrame)
	DR.vigorBar:ClearAllPoints()
	DR.vigorBar:SetPoint("CENTER", 0, 0) -- Center on the parent anchor
	
	-- Position Static Charges
	DR.UpdateChargePositions(ParentFrame)
	
	-- Handle Side Art Alpha
	local PowerBarChildren = {UIWidgetPowerBarContainerFrame:GetChildren()}
	if PowerBarChildren[3] ~= nil then
		for _, child in ipairs({PowerBarChildren[3]:GetRegions()}) do
			child:SetAlpha(DragonRider_DB.sideArt and 1 or 0)
		end
	end
end

function DR.clearPositions()
	DR.HideWithFadeBar();
	for i = 1, 10 do
		DR.charge[i]:Hide();
	end
	DR.hideModels()
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


local function CreateColorPickerButtonForSetting(category, setting, tooltip)
	local data = Settings.CreateSettingInitializerData(setting, {}, tooltip);
	local initializer = Settings.CreateSettingInitializer("DragonRiderColorSwatchSettingTemplate", data);
	local layout = SettingsPanel:GetLayout(category);
	layout:AddInitializer(initializer);
	return initializer;
end

local function UpdateSettingsFramePositions(categoryID)
	if SettingsPanel and SettingsPanel:IsShown() then -- and SettingsPanel.selectedCategory and SettingsPanel.selectedCategory.ID == categoryID -- need to find the actual currently selected thing
		DR.vigorBar:SetFrameStrata("DIALOG");
		DR.statusbar:SetFrameStrata("DIALOG");
		DR.vigorBar:ClearAllPoints()
		DR.statusbar:ClearAllPoints()
		DR.vigorBar:SetPoint("TOP", SettingsPanel, "BOTTOM")
		DR.statusbar:SetPoint("BOTTOM", DR.vigorBar, "TOP", 0, 13)
		
		DR.statusbar:Show();
		DR.vigorBar:Show();
	else
		DR.statusbar:SetFrameStrata("MEDIUM");
		DR.vigorBar:SetFrameStrata("MEDIUM");

		DR.setPositions()
		DR.SetTheme()
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

		if not DragonRider_DB then
			DragonRider_DB = CopyTable(defaultsTable)
		else
			DR.MergeDefaults(DragonRider_DB, defaultsTable)
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
			DR.SetTheme()
			DR.UpdateVigorLayout()
		end

		local category, layout = Settings.RegisterVerticalLayoutCategory("Dragon Rider")

		local categorySpeedometer, layoutSpeedometer = Settings.RegisterVerticalLayoutSubcategory(category, L["ProgressBar"]);

		local categoryVigor, layoutVigor = Settings.RegisterVerticalLayoutSubcategory(category, L["Vigor"]);

		--local subcategory, layout2 = Settings.RegisterVerticalLayoutSubcategory(category, "my very own subcategory")

		--layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(string.format(L["Version"], GetAddOnMetadata("DragonRider", "Version"))));

		--layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L["ProgressBar"])); -- moved to subcategory

		local CreateDropdown = Settings.CreateDropdown or Settings.CreateDropDown
		local CreateCheckbox = Settings.CreateCheckbox or Settings.CreateCheckBox

		local function RegisterSetting(key, defaultValue, name, subKey)
			local uniqueVariable
			local setting

			if subKey then
				-- This block handles nested settings like DragonRider_DB.speedBarColor.slow
				uniqueVariable = "DR_" .. key .. "_" .. subKey
				
				-- Ensure the parent table exists to avoid errors
				if DragonRider_DB[key] == nil then DragonRider_DB[key] = {} end

				-- Register the setting against the sub-table
				setting = Settings.RegisterAddOnSetting(category, uniqueVariable, subKey, DragonRider_DB[key], type(defaultValue), name, defaultValue)
				
				-- Set the initial value from the nested variable
				if DragonRider_DB[key][subKey] == nil then DragonRider_DB[key][subKey] = defaultValue end
				setting:SetValue(DragonRider_DB[key][subKey])
			else
				-- This block handles top-level settings like DragonRider_DB.toggleModels
				uniqueVariable = "DR_" .. key
				setting = Settings.RegisterAddOnSetting(category, uniqueVariable, key, DragonRider_DB, type(defaultValue), name, defaultValue)
				if DragonRider_DB[key] == nil then DragonRider_DB[key] = defaultValue end
				setting:SetValue(DragonRider_DB[key])
			end

			Settings.SetOnValueChangedCallback(uniqueVariable, OnSettingChanged)
			return setting
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
			local defaultValue = defaultsTable[variable]

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
			local defaultValue = defaultsTable[variable]  -- Corresponds to "Option 1" below.
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
			local defaultValue = defaultsTable[variable]  -- Corresponds to "Option 1" below.
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
			local defaultValue = defaultsTable[variable]
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
			local defaultValue = defaultsTable[variable]
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
			local defaultValue = defaultsTable[variable]
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
			local defaultValue = defaultsTable[variable]
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
			local defaultValue = defaultsTable[variable]  -- Corresponds to "Option 1" below.
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
			local defaultValue = defaultsTable[variable]
			local minValue = 2
			local maxValue = 30
			local step = .5

			local setting = RegisterSetting(variable, defaultValue, name);
			local options = Settings.CreateSliderOptions(minValue, maxValue, step)
			options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
			Settings.CreateSlider(categorySpeedometer, setting, options, tooltip)
		end

		layoutSpeedometer:AddInitializer(CreateSettingsListSectionHeaderInitializer(COLOR_PICKER));

		-- Speedometer Colors
		do -- Low Speed Progress Bar Color
			local key, subKey = "speedBarColor", "slow"
			local name = L["ProgressBarColor"] .. " - " .. L["Low"]
			local tooltip = L["ColorPickerLowProgTT"]
			local setting = RegisterSetting(key, defaultsTable[key][subKey], name, subKey)
			CreateColorPickerButtonForSetting(categorySpeedometer, setting, tooltip)
		end

		do -- Vigor Speed Progress Bar Color
			local key, subKey = "speedBarColor", "vigor"
			local name = L["ProgressBarColor"] .. " - " .. L["Vigor"] 
			local tooltip = L["ColorPickerMidProgTT"]
			local setting = RegisterSetting(key, defaultsTable[key][subKey], name, subKey)
			CreateColorPickerButtonForSetting(categorySpeedometer, setting, tooltip)
		end

		do -- High Speed Progress Bar Color
			local key, subKey = "speedBarColor", "over"
			local name = L["ProgressBarColor"] .. " - " .. L["High"]
			local tooltip = L["ColorPickerHighProgTT"]
			local setting = RegisterSetting(key, defaultsTable[key][subKey], name, subKey)
			CreateColorPickerButtonForSetting(categorySpeedometer, setting, tooltip)
		end

		-- Text Colors
		do -- Low Speed Text Color
			local key, subKey = "speedTextColor", "slow"
			local name = L["UnitsColor"] .. " - " .. L["Low"]
			local tooltip = L["ColorPickerLowTextTT"]
			local setting = RegisterSetting(key, defaultsTable[key][subKey], name, subKey)
			CreateColorPickerButtonForSetting(categorySpeedometer, setting, tooltip)
		end

		do -- Vigor Speed Text Color
			local key, subKey = "speedTextColor", "vigor"
			local name = L["UnitsColor"] .. " - " .. L["Vigor"]
			local tooltip = L["ColorPickerMidTextTT"]
			local setting = RegisterSetting(key, defaultsTable[key][subKey], name, subKey)
			CreateColorPickerButtonForSetting(categorySpeedometer, setting, tooltip)
		end

		do -- High Speed Text Color
			local key, subKey = "speedTextColor", "over"
			local name = L["UnitsColor"] .. " - " .. L["High"]
			local tooltip = L["ColorPickerHighTextTT"]
			local setting = RegisterSetting(key, defaultsTable[key][subKey], name, subKey)
			CreateColorPickerButtonForSetting(categorySpeedometer, setting, tooltip)
		end


		Settings.RegisterAddOnCategory(categorySpeedometer)

		-- Vigor Subcategory

		do
			local variable = "themeVigor"
			local defaultValue = defaultsTable[variable]  -- Corresponds to "Option 1" below.
			local name = "[PH]"..L["VigorTheme"].." [NYI]"
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
			local name = "[PH]"..L["VigorPosXName"].." [NYI]"
			local tooltip = L["VigorPosXNameTT"]
			local defaultValue = defaultsTable[variable]
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
			local name = "[PH]"..L["VigorPosYName"].." [NYI]"
			local tooltip = "[PH]"..L["VigorPosYNameTT"]
			local defaultValue = defaultsTable[variable]
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
			local defaultValue = defaultsTable[variable]
			local minValue = 1
			local maxValue = 500
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
			local defaultValue = defaultsTable[variable]
			local minValue = 1
			local maxValue = 500
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
			local defaultValue = defaultsTable[variable]
			local minValue = 0
			local maxValue = 100
			local step = 1

			local setting = RegisterSetting(variable, defaultValue, name);
			local options = Settings.CreateSliderOptions(minValue, maxValue, step);
			options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
			Settings.CreateSlider(categoryVigor, setting, options, tooltip);
		end

		do
			local variable = "vigorBarOrientation"
			local defaultValue = defaultsTable[variable]  -- Corresponds to "Option 1" below.
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
			local defaultValue = defaultsTable[variable]  -- Corresponds to "Option 1" below.
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
			local defaultValue = defaultsTable[variable]
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
			local defaultValue = defaultsTable[variable]  -- Corresponds to "Option 1" below.
			local name = "[PH]"..L["VigorBarFillDirectionName"].." [NYI]"
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
			local name = "[PH]"..L["VigorSparkWidthName"].." [NYI]"
			local tooltip = "[PH]"..L["VigorSparkWidthNameTT"]
			local defaultValue = defaultsTable[variable]
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
			local name = "[PH]"..L["VigorSparkHeightName"].." [NYI]"
			local tooltip = "[PH]"..L["VigorSparkHeightNameTT"]
			local defaultValue = defaultsTable[variable]
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
			local defaultValue = defaultsTable[variable]

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateCheckbox(categoryVigor, setting, tooltip)
		end

		do
			local variable = "toggleFlashProgress"
			local name = "[PH]"..L["ToggleFlashProgressName"]
			local tooltip = "[PH]"..L["ToggleFlashProgressNameTT"]
			local defaultValue = defaultsTable[variable]

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateCheckbox(categoryVigor, setting, tooltip)
		end

		do
			local variable = "toggleModels"
			local name = L["ToggleModelsName"]
			local tooltip = L["ToggleModelsTT"]
			local defaultValue = defaultsTable[variable]

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateCheckbox(categoryVigor, setting, tooltip)
		end

		do
			local variable = "modelTheme"
			local defaultValue = defaultsTable[variable]  -- Corresponds to "Option 1" below.
			local name = "[PH]"..L["ModelThemeName"].." [NYI]"
			local tooltip = "[PH]"..L["ModelThemeNameTT"]

			local function GetOptions()
				local container = Settings.CreateControlTextContainer()
				container:Add(1, "[PH]"..L["Wind"])
				container:Add(2, "[PH]"..L["Lightning"])
				return container:GetData()
			end

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateDropdown(categoryVigor, setting, GetOptions, tooltip)
		end

		do
			local variable = "sideArt"
			local name = L["SideArtName"].." [NYI]"
			local tooltip = L["SideArtTT"]
			local defaultValue = defaultsTable[variable]

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateCheckbox(categoryVigor, setting, tooltip)
		end

		do
			local variable = "sideArtStyle"
			local defaultValue = defaultsTable[variable]  -- Corresponds to "Option 1" below.
			local name = "[PH]"..L["SideArtStyleName"].." [NYI]"
			local tooltip = "[PH]"..L["SideArtStyleNameTT"]

			local function GetOptions()
				local container = Settings.CreateControlTextContainer()
				container:Add(1, "[PH]"..L["Default"])
				container:Add(2, "[PH]"..L["Algari"])
				return container:GetData()
			end

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateDropdown(categoryVigor, setting, GetOptions, tooltip)
		end

		do
			local variable = "sideArtPosX"
			local name = "[PH]"..L["SideArtPosX"].." [NYI]"
			local tooltip = L["SideArtPosXTT"]
			local defaultValue = defaultsTable[variable]
			local minValue = -100
			local maxValue = 100
			local step = 1

			local setting = RegisterSetting(variable, defaultValue, name);
			local options = Settings.CreateSliderOptions(minValue, maxValue, step);
			options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
			Settings.CreateSlider(categoryVigor, setting, options, tooltip);
		end

		do
			local variable = "sideArtPosY"
			local name = "[PH]"..L["SideArtPosY"].." [NYI]"
			local tooltip = L["SideArtPosYTT"]
			local defaultValue = defaultsTable[variable]
			local minValue = -100
			local maxValue = 100
			local step = 1

			local setting = RegisterSetting(variable, defaultValue, name);
			local options = Settings.CreateSliderOptions(minValue, maxValue, step);
			options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
			Settings.CreateSlider(categoryVigor, setting, options, tooltip);
		end

		do
			local variable = "showtooltip"
			local name = L["ShowVigorTooltip"].." [NYI]"
			local tooltip = L["ShowVigorTooltipTT"]
			local defaultValue = defaultsTable[variable]

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateCheckbox(categoryVigor, setting, tooltip)
		end

		do
			local variable = "muteVigorSound"
			local name = L["MuteVigorSound_Settings"]
			local tooltip = L["MuteVigorSound_SettingsTT"]
			local defaultValue = defaultsTable[variable]

			local setting = RegisterSetting(variable, defaultValue, name);
			CreateCheckbox(categoryVigor, setting, tooltip)
		end

		layoutVigor:AddInitializer(CreateSettingsListSectionHeaderInitializer(COLOR_PICKER));


		-- Vigor Colors
		do -- full
			local key, subKey = "vigorBarColor", "full"
			local name = "[PH]"..L["VigorColor"] .. " - " .. "[PH]"..L["Full"]
			local tooltip = "[PH]"..L["VigorColor"] .. " - " .. "[PH]"..L["Full"]
			local setting = RegisterSetting(key, defaultsTable[key][subKey], name, subKey)
			CreateColorPickerButtonForSetting(categoryVigor, setting, tooltip)
		end
		do -- empty
			local key, subKey = "vigorBarColor", "empty"
			local name = "[PH]"..L["VigorColor"] .. " - " .. "[PH]"..L["Empty"]
			local tooltip = "[PH]"..L["VigorColor"] .. " - " .. "[PH]"..L["Empty"]
			local setting = RegisterSetting(key, defaultsTable[key][subKey], name, subKey)
			CreateColorPickerButtonForSetting(categoryVigor, setting, tooltip)
		end
		do -- progress
			local key, subKey = "vigorBarColor", "progress"
			local name = "[PH]"..L["VigorColor"] .. " - " .. "[PH]"..L["Progress"]
			local tooltip = "[PH]"..L["VigorColor"] .. " - " .. "[PH]"..L["Progress"]
			local setting = RegisterSetting(key, defaultsTable[key][subKey], name, subKey)
			CreateColorPickerButtonForSetting(categoryVigor, setting, tooltip)
		end
		do -- spark
			local key, subKey = "vigorBarColor", "spark"
			local name = "[PH]"..L["VigorColor"] .. " - " .. "[PH]"..L["Spark"]
			local tooltip = "[PH]"..L["VigorColor"] .. " - " .. "[PH]"..L["Spark"]
			local setting = RegisterSetting(key, defaultsTable[key][subKey], name, subKey)
			CreateColorPickerButtonForSetting(categoryVigor, setting, tooltip)
		end
		do -- cover
			local key, subKey = "vigorBarColor", "cover"
			local name = "[PH]"..L["VigorColor"] .. " - " .. "[PH]"..L["Cover"]
			local tooltip = "[PH]"..L["VigorColor"] .. " - " .. "[PH]"..L["Cover"]
			local setting = RegisterSetting(key, defaultsTable[key][subKey], name, subKey)
			CreateColorPickerButtonForSetting(categoryVigor, setting, tooltip)
		end
		do -- decor
			local key, subKey = "vigorBarColor", "decor"
			local name = "[PH]"..L["VigorColor"] .. " - " .. "[PH]"..L["Decor"]
			local tooltip = "[PH]"..L["VigorColor"] .. " - " .. "[PH]"..L["Decor"]
			local setting = RegisterSetting(key, defaultsTable[key][subKey], name, subKey)
			CreateColorPickerButtonForSetting(categoryVigor, setting, tooltip)
		end
		do -- flash
			local key, subKey = "vigorBarColor", "flash"
			local name = "[PH]"..L["VigorColor"] .. " - " .. "[PH]"..L["Flash"]
			local tooltip = "[PH]"..L["VigorColor"] .. " - " .. "[PH]"..L["Flash"]
			local setting = RegisterSetting(key, defaultsTable[key][subKey], name, subKey)
			CreateColorPickerButtonForSetting(categoryVigor, setting, tooltip)
		end

		Settings.RegisterAddOnCategory(categoryVigor)


		SettingsPanel:HookScript("OnShow", function() UpdateSettingsFramePositions(category.ID) end);
		SettingsPanel:HookScript("OnHide", function() UpdateSettingsFramePositions(category.ID) end);
		EventRegistry:RegisterCallback("Settings.CategoryChanged", function() UpdateSettingsFramePositions(category.ID) end);

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
			DR.vigorBar:Show();
			DR.vigorCounter();
		end

		local function OnAdvFlyEnd()
			DR.HideWithFadeBar();
			DR.setPositions();
		end

		-- when the player dismounts
		local function OnAdvFlyDisabled()
			DR.HideWithFadeBar();
			DR.clearPositions();
			DR.vigorBar:Hide();
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