local DragonRider, DR = ...
local _, L = ...


---@type LibAdvFlight
local LibAdvFlight = LibStub:GetLibrary("LibAdvFlight-1.1")

---------------------------------------------------------------------------------------------------------------
-- Charges
---------------------------------------------------------------------------------------------------------------

DR.charge = CreateFrame("Frame")
DR.charge:RegisterEvent("UNIT_AURA")
DR.charge:RegisterEvent("SPELL_UPDATE_COOLDOWN")

function DR:chargeSetup(number)
	if UIWidgetPowerBarContainerFrame and UIWidgetPowerBarContainerFrame.widgetFrames then
		--DR.SetUpChargePos(number)
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
	-- This function now only handles relative positioning for charges 2 through 10
	if i ~= 1 then
		if C_UnitAuras.GetPlayerAuraBySpellID(417888) then
			DR.charge[i]:SetPoint("CENTER", DR.charge[i-1], 30.5, 0)
		else
			DR.charge[i]:SetPoint("CENTER", DR.charge[i-1], 26.75, 0)
		end
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
	DR.charge[i] = CreateFrame("Frame", nil, UIParent)
	DR.charge[i]:SetSize(25,25)

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

function DR.UpdateChargePositions(anchorFrame)
	if not anchorFrame then return end

	DR.charge[1]:SetParent(anchorFrame)
	DR.charge[1]:ClearAllPoints()

	if C_UnitAuras.GetPlayerAuraBySpellID(417888) then
		DR.charge[1]:SetPoint("TOPLEFT", anchorFrame, "TOPLEFT", 45, 8)
	else
		DR.charge[1]:SetPoint("TOPLEFT", anchorFrame, "TOPLEFT", 31, 14)
	end
	DR.charge[1]:SetScale(1.5625)

	for i = 1, 10 do
		DR.SetUpChargePos(i)
		DR:chargeSetup(i) -- Update textures
		if C_UnitAuras.GetPlayerAuraBySpellID(418590) and DragonRider_DB.lightningRush then
			DR.charge[i]:Show();
		else
			DR.charge[i]:Hide();
		end
	end
end

function DR.toggleCharges(self, event, arg1)
	if event == "UNIT_AURA" and arg1 == "player" then
		if C_UnitAuras.GetPlayerAuraBySpellID(418590) then
			local chargeCount = C_UnitAuras.GetPlayerAuraBySpellID(418590).applications
			for i = 1,10 do
				-- DR:chargeSetup(i) -- No need to call this here anymore, let UpdateChargePositions handle it
				if i <= chargeCount then
					DR.charge[i].texFill:Show();
				else
					DR.charge[i].texFill:Hide();
				end
			end
			-- DR.setPositions(); -- This creates a potential loop, let setPositions call the update
		else
			for i = 1,10 do
				DR.charge[i].texFill:Hide();
			end
			-- DR.setPositions();
		end
	end
	if event == "SPELL_UPDATE_COOLDOWN" then

	if LE_EXPANSION_LEVEL_CURRENT <= LE_EXPANSION_WAR_WITHIN then
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
end

DR.charge:SetScript("OnEvent", DR.toggleCharges)