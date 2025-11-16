local DragonRider, DR = ...
local _, L = ...


---@type LibAdvFlight
local LibAdvFlight = LibStub:GetLibrary("LibAdvFlight-1.1")

---------------------------------------------------------------------------------------------------------------
-- Static Charges
---------------------------------------------------------------------------------------------------------------

DR.charge = CreateFrame("Frame", nil, DR.vigorBar)
DR.charge:SetAllPoints(DR.vigorBar)
DR.charge:RegisterEvent("UNIT_AURA")
DR.charge:RegisterEvent("SPELL_UPDATE_COOLDOWN")

local MAX_CHARGE_FRAMES = 10
local MAX_VIGOR_BARS = 6
local CHARGE_SIZE = 32 -- probably needs to be a slider option in the future
local PADDING = -10 -- static charge distance from vigor (also probably needs to be an option)

-- vigor bar defaults
local BAR_WIDTH_DEFAULT = 32
local BAR_HEIGHT_DEFAULT = 32
local BAR_SPACING_DEFAULT = 10
local DEFAULT_ORIENTATION = 2
local DEFAULT_VIGOR_WRAP = 6

local TexturePath = "Interface\\AddOns\\DragonRider\\Textures\\"

local ChargeOptions = {
	[1] = { -- default - gold
		Base = TexturePath.."Points_Gold_Empty",
		Cover = TexturePath.."Points_Gold_Cover",
		Fill = TexturePath.."Points_Fill",
		Desat = false,
	},
	[2] = { -- algari bronze
		Base = TexturePath.."Points_Bronze_Empty",
		Cover = TexturePath.."Points_Bronze_Cover",
		Fill = TexturePath.."Points_Fill",
		Desat = false,
	},
	[3] = { -- algari dark
		Base = TexturePath.."Points_Dark_Empty",
		Cover = TexturePath.."Points_Dark_Cover",
		Fill = TexturePath.."Points_Fill",
		Desat = false,
	},
	[4] = { -- algari gold
		Base = TexturePath.."Points_Gold_Empty",
		Cover = TexturePath.."Points_Gold_Cover",
		Fill = TexturePath.."Points_Fill",
		Desat = false,
	},
	[5] = { -- algari silver
		Base = TexturePath.."Points_Silver_Empty",
		Cover = TexturePath.."Points_Silver_Cover",
		Fill = TexturePath.."Points_Fill",
		Desat = false,
	},
	[6] = { -- default - desat
		Base = TexturePath.."Points_Silver_Empty",
		Cover = TexturePath.."Points_Silver_Cover",
		Fill = TexturePath.."Points_Fill",
		Desat = true,
	},
	[7] = { -- algari - desat
		Base = TexturePath.."Points_Silver_Empty",
		Cover = TexturePath.."Points_Silver_Cover",
		Fill = TexturePath.."Points_Fill",
		Desat = true,
	},
	[8] = { -- minimalist - desat
		Base = TexturePath.."Points_Silver_Empty",
		Cover = TexturePath.."Points_Silver_Cover",
		Fill = TexturePath.."Points_Fill",
		Desat = true,
	},
};

for i = 1, MAX_CHARGE_FRAMES do
	DR.charge[i] = CreateFrame("Frame", "DragonRider_StaticCharge_"..i, DR.charge)
	DR.charge[i]:SetSize(CHARGE_SIZE, CHARGE_SIZE)
	DR.charge[i]:SetFrameLevel(5)
	
	DR.charge[i].texBase = DR.charge[i]:CreateTexture(nil, "BACKGROUND", nil, 0)
	DR.charge[i].texBase:SetAllPoints()
	DR.charge[i].texFill = DR.charge[i]:CreateTexture(nil, "OVERLAY", nil, 1)
	DR.charge[i].texFill:SetAllPoints()
	DR.charge[i].texFill:Hide()
	DR.charge[i].texCover = DR.charge[i]:CreateTexture(nil, "OVERLAY", nil, 2)
	DR.charge[i].texCover:SetAllPoints()
	DR.charge[i]:Hide()
end

function DR:chargeSetup(number)
	local charge = DR.charge[number]
	if not charge then return end

	local themeVigor = (DragonRider_DB and DragonRider_DB.themeVigor) or 1
	local options = ChargeOptions[themeVigor] or ChargeOptions[1]

	charge.texBase:SetTexture(options.Base)
	charge.texCover:SetTexture(options.Cover)
	charge.texFill:SetTexture(options.Fill)

	local desat = options.Desat or false
	charge.texBase:SetDesaturated(desat)
	charge.texCover:SetDesaturated(desat)
	charge.texFill:SetDesaturated(desat)

	local rF, gF, bF, aF = 1, 1, 1, 1
	if DragonRider_DB and DragonRider_DB.vigorBarColor and DragonRider_DB.vigorBarColor.full then
		rF = DragonRider_DB.vigorBarColor.full.r
		gF = DragonRider_DB.vigorBarColor.full.g
		bF = DragonRider_DB.vigorBarColor.full.b
		aF = DragonRider_DB.vigorBarColor.full.a
	end
	charge.texFill:SetVertexColor(rF, gF, bF, aF)

	local rE, gE, bE, aE = 1, 1, 1, 1
	if DragonRider_DB and DragonRider_DB.vigorBarColor and  DragonRider_DB.vigorBarColor.background then
		rE = DragonRider_DB.vigorBarColor.background.r
		gE = DragonRider_DB.vigorBarColor.background.g
		bE = DragonRider_DB.vigorBarColor.background.b
		aE = DragonRider_DB.vigorBarColor.background.a
	end
	charge.texBase:SetVertexColor(rE, gE, bE, aE)

	local rC, gC, bC, aC = 1, 1, 1, 1
	if DragonRider_DB and DragonRider_DB.vigorBarColor and DragonRider_DB.vigorBarColor.cover then
		rC = DragonRider_DB.vigorBarColor.cover.r
		gC = DragonRider_DB.vigorBarColor.cover.g
		bC = DragonRider_DB.vigorBarColor.cover.b
		aC = DragonRider_DB.vigorBarColor.cover.a
	end
	charge.texCover:SetVertexColor(rC, gC, bC, aC)
end


function DR.UpdateChargePositions()
	for i = 1, MAX_CHARGE_FRAMES do
		if DR.charge[i] then DR.charge[i]:Hide() end
	end

	if not DR.vigorBar or not DR.vigorBar.bars or not DragonRider_DB or not LibAdvFlight then
		return
	end

	local bar_spacing = (DragonRider_DB.vigorBarSpacing) or BAR_SPACING_DEFAULT
	local orientation = (DragonRider_DB.vigorBarOrientation) or DEFAULT_ORIENTATION
	local vigorWrap = (DragonRider_DB.vigorWrap and DragonRider_DB.vigorWrap > 0 and DragonRider_DB.vigorWrap) or DEFAULT_VIGOR_WRAP

	if not DR.vigorBar:IsShown() or not LibAdvFlight.HasLightningRush() or orientation == 1 then
		return
	end

	for i = 1, MAX_VIGOR_BARS - 1 do
		local top_charge = DR.charge[i]
		local bottom_charge = DR.charge[i + (MAX_VIGOR_BARS - 1)]
		
		if top_charge and bottom_charge and DR.vigorBar.bars[i] and DR.vigorBar.bars[i+1] then
			
			local row_i = math.floor((i - 1) / vigorWrap)
			local row_i_plus_1 = math.floor(i / vigorWrap)

			if row_i == row_i_plus_1 then
				DR:chargeSetup(i)
				DR:chargeSetup(i + (MAX_VIGOR_BARS - 1))
				
				-- Definitely need to change this in the future, it doesn't handle the rows/columns very well atm
				top_charge:ClearAllPoints()
				top_charge:SetPoint("CENTER", DR.vigorBar.bars[i], "TOPRIGHT", bar_spacing / 2, (CHARGE_SIZE / 2) + PADDING)
				
				bottom_charge:ClearAllPoints()
				bottom_charge:SetPoint("CENTER", DR.vigorBar.bars[i], "BOTTOMRIGHT", bar_spacing / 2, -(CHARGE_SIZE / 2) - PADDING)
				
				top_charge:Show()
				bottom_charge:Show()
			end
		end
	end
end


function DR.charge:OnEvent(event, ...)
	if event == "UNIT_AURA" then
		local unit = select(1, ...)
		if unit == "player" then
			DR.UpdateChargePositions() 
			
			local chargeCount = 0
			if C_UnitAuras.GetPlayerAuraBySpellID(418590) then
				chargeCount = C_UnitAuras.GetPlayerAuraBySpellID(418590).applications
			end
			
			for i = 1, MAX_VIGOR_BARS - 1 do 
				local top_charge = DR.charge[i]
				local bottom_charge = DR.charge[i + (MAX_VIGOR_BARS - 1)]

				if top_charge and top_charge.texFill then
					if i <= chargeCount then 
						top_charge.texFill:Show()
					else
						top_charge.texFill:Hide()
					end
				end

				if bottom_charge and bottom_charge.texFill then
					if (i + 5) <= chargeCount then 
						bottom_charge.texFill:Show()
					else
						bottom_charge.texFill:Hide()
					end
				end
			end
		end
	end
	
	if event == "SPELL_UPDATE_COOLDOWN" then
		local isEnabled, startTime, modRate, duration
		if C_Spell.GetSpellCooldown then
			local cooldownInfo = C_Spell.GetSpellCooldown(418592)
			isEnabled, startTime, modRate, duration = cooldownInfo.isEnabled, cooldownInfo.startTime, cooldownInfo.modRate, cooldownInfo.duration
		else
			isEnabled, startTime, modRate, duration = GetSpellCooldown(418592)
		end
	end
end

DR.charge:SetScript("OnEvent", DR.charge.OnEvent)