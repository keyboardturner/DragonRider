local DragonRider, DR = ...
local _, L = ...

--A purposeful global variable for other addons
DragonRider_API = DR

---@type LibAdvFlight
local LibAdvFlight = LibStub:GetLibrary("LibAdvFlight-1.1");

---------------------------------------------------------------------------------------------------------------
-- DRIVE system
---------------------------------------------------------------------------------------------------------------

local DRIVE_LAST_TIME;
local DRIVE_LAST_POS;
DR.DriveUtils = {};

function DR.DriveUtils.GetPosition()
	local map = C_Map.GetBestMapForUnit("player");
	local pos = C_Map.GetPlayerMapPosition(map, "player");
	local _, worldPos = C_Map.GetWorldPosFromMapPos(map, pos);
	return worldPos;
end

function DR.DriveUtils.GetSpeed()
	if not IsPlayerMoving() then
		return 0;
	end

	local currentPos = DR.DriveUtils.GetPosition();
	if not currentPos then
		return 0;
	end

	if not DRIVE_LAST_POS then
		DRIVE_LAST_POS = CreateVector2D(currentPos:GetXY());
		return 0;
	end

	local currentTime = GetTime();
	if not DRIVE_LAST_TIME then
		DRIVE_LAST_TIME = currentTime;
		return 0;
	end

	local dx, dy = Vector2D_Subtract(currentPos.x, currentPos.y, DRIVE_LAST_POS.x, DRIVE_LAST_POS.y);
	local distance = sqrt(dx^2 + dy^2);
	local speed = distance / (currentTime - DRIVE_LAST_TIME);

	DRIVE_LAST_TIME = currentTime;
	DRIVE_LAST_POS:SetXY(currentPos:GetXY());

	return speed;
end

local DRIVE_MAX_SAMPLES = 3;
local SPEED_SAMPLES = CreateCircularBuffer(DRIVE_MAX_SAMPLES);

function DR.DriveUtils.GetSmoothedSpeed()
	if not IsPlayerMoving() then
		return 0;
	end

	local currentSpeed = DR.DriveUtils.GetSpeed();
	SPEED_SAMPLES:PushFront(currentSpeed);

	local total = 0;
	for _, speed in SPEED_SAMPLES:EnumerateIndexedEntries() do
		total = total + speed;
	end

	return total / SPEED_SAMPLES:GetNumElements();
end

local CAR_SPELL_ID = 460013;
function DR.DriveUtils.IsDriving()
	local aura = C_UnitAuras.GetPlayerAuraBySpellID(CAR_SPELL_ID);
	return aura and true or false;
end

---------------------------------------------------------------------------------------------------------------
-- DRIVE system
---------------------------------------------------------------------------------------------------------------


DR.statusbar = CreateFrame("StatusBar", "DRStatusBar", UIParent)
DR.statusbar:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
DR.statusbar:SetWidth(305/1.25)
DR.statusbar:SetHeight(66.5/2.75)
DR.statusbar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
DR.statusbar:GetStatusBarTexture():SetHorizTile(false)
DR.statusbar:GetStatusBarTexture():SetVertTile(false)
DR.statusbar:SetStatusBarColor(.98, .61, .0)
Mixin(DR.statusbar, SmoothStatusBarMixin)
DR.statusbar:SetMinMaxSmoothedValue(0,100)

DR.tick1 = DR.statusbar:CreateTexture(nil, "OVERLAY", nil, 1)
DR.tick1:SetAtlas("UI-Frame-Bar-BorderTick")
DR.tick1:SetSize(17,DR.statusbar:GetHeight()*1.5)
DR.tick1:SetPoint("TOP", DR.statusbar, "TOPLEFT", (65 / 100) * DR.statusbar:GetWidth(), 5)

DR.tick2 = DR.statusbar:CreateTexture(nil, "OVERLAY", nil, 1)
DR.tick2:SetAtlas("UI-Frame-Bar-BorderTick")
DR.tick2:SetSize(17,DR.statusbar:GetHeight()*1.5)
DR.tick2:SetPoint("TOP", DR.statusbar, "TOPLEFT", (60 / 100) * DR.statusbar:GetWidth(), 5)

--[[
DR.tick25 = DR.statusbar:CreateTexture(nil, "OVERLAY")
DR.tick25:SetAtlas("UI-Frame-Bar-BorderTick")
DR.tick25:SetSize(17,DR.statusbar:GetHeight()*1)
DR.tick25:SetPoint("TOP", DR.statusbar, "TOPLEFT", (25 / 100) * DR.statusbar:GetWidth(), 5)

DR.tick50 = DR.statusbar:CreateTexture(nil, "OVERLAY")
DR.tick50:SetAtlas("UI-Frame-Bar-BorderTick")
DR.tick50:SetSize(17,DR.statusbar:GetHeight()*1)
DR.tick50:SetPoint("TOP", DR.statusbar, "TOPLEFT", (50 / 100) * DR.statusbar:GetWidth(), 5)

DR.tick75 = DR.statusbar:CreateTexture(nil, "OVERLAY")
DR.tick75:SetAtlas("UI-Frame-Bar-BorderTick")
DR.tick75:SetSize(17,DR.statusbar:GetHeight()*1)
DR.tick75:SetPoint("TOP", DR.statusbar, "TOPLEFT", (75 / 100) * DR.statusbar:GetWidth(), 5)
]]


DR.backdropL = DR.statusbar:CreateTexture(nil, "OVERLAY", nil, 2)
DR.backdropL:SetAtlas("widgetstatusbar-borderleft") -- UI-Frame-Dragonflight-TitleLeft
DR.backdropL:SetPoint("LEFT", DR.statusbar, "LEFT", -7, 0)
DR.backdropL:SetWidth(35)
DR.backdropL:SetHeight(40)

DR.backdropR = DR.statusbar:CreateTexture(nil, "OVERLAY", nil, 2)
DR.backdropR:SetAtlas("widgetstatusbar-borderright") -- UI-Frame-Dragonflight-TitleRight
DR.backdropR:SetPoint("RIGHT", DR.statusbar, "RIGHT", 7, 0)
DR.backdropR:SetWidth(35)
DR.backdropR:SetHeight(40)

DR.backdropM = DR.statusbar:CreateTexture(nil, "OVERLAY", nil, 2)
DR.backdropM:SetAtlas("widgetstatusbar-bordercenter") -- _UI-Frame-Dragonflight-TitleMiddle
DR.backdropM:SetPoint("TOPLEFT", DR.backdropL, "TOPRIGHT", 0, 0)
DR.backdropM:SetPoint("BOTTOMRIGHT", DR.backdropR, "BOTTOMLEFT", 0, 0)

DR.backdropTopper = DR.statusbar:CreateTexture(nil, "OVERLAY", nil, 1)
DR.backdropTopper:SetAtlas("dragonflight-score-topper")
DR.backdropTopper:SetPoint("TOP", DR.statusbar, "TOP", 0, 38)
DR.backdropTopper:SetWidth(350)
DR.backdropTopper:SetHeight(65)

DR.backdropFooter = DR.statusbar:CreateTexture(nil, "OVERLAY", nil, 1)
DR.backdropFooter:SetAtlas("dragonflight-score-footer")
DR.backdropFooter:SetPoint("BOTTOM", DR.statusbar, "BOTTOM", 0, -32)
DR.backdropFooter:SetWidth(350)
DR.backdropFooter:SetHeight(65)

DR.statusbar.bg = DR.statusbar:CreateTexture(nil, "BACKGROUND", nil, 0)
DR.statusbar.bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
DR.statusbar.bg:SetAllPoints(true)
DR.statusbar.bg:SetVertexColor(.0, .0, .0, .8)

local frameborder = CreateFrame("frame",nil,DR.statusbar)
frameborder:SetAllPoints(DR.statusbar)
frameborder:SetFrameStrata("BACKGROUND")
frameborder:SetFrameLevel(1)
frameborder.left = frameborder:CreateTexture(nil,"BORDER")
frameborder.left:SetPoint("BOTTOMLEFT",frameborder,"BOTTOMLEFT",-2,-2)
frameborder.left:SetPoint("TOPRIGHT",frameborder,"TOPLEFT",0,0)
frameborder.left:SetColorTexture(0,0,0,1)
frameborder.right = frameborder:CreateTexture(nil,"BORDER")
frameborder.right:SetPoint("BOTTOMLEFT",frameborder,"BOTTOMRIGHT",0,0)
frameborder.right:SetPoint("TOPRIGHT",frameborder,"TOPRIGHT",2,0)
frameborder.right:SetColorTexture(0,0,0,1)
frameborder.top = frameborder:CreateTexture(nil,"BORDER")
frameborder.top:SetPoint("BOTTOMLEFT",frameborder,"TOPLEFT",-2,0)
frameborder.top:SetPoint("TOPRIGHT",frameborder,"TOPRIGHT",2,2)
frameborder.top:SetColorTexture(0,0,0,1)
frameborder.bottom = frameborder:CreateTexture(nil,"BORDER")
frameborder.bottom:SetPoint("BOTTOMLEFT",frameborder,"BOTTOMLEFT",-2,-2)
frameborder.bottom:SetPoint("TOPRIGHT",frameborder,"BOTTOMRIGHT",2,0)
frameborder.bottom:SetColorTexture(0,0,0,1)

DR.glide = DR.statusbar:CreateFontString(nil, nil, "GameTooltipText")
DR.glide:SetPoint("LEFT", DR.statusbar, "LEFT", 10, 0)

function DR.useUnits()
	if DragonRider_DB.speedValUnits == 1 then
		return " " .. L["UnitYards"]
	elseif DragonRider_DB.speedValUnits == 2 then
		return " " .. L["UnitMiles"]
	elseif DragonRider_DB.speedValUnits == 3 then
		return " " .. L["UnitMeters"]
	elseif DragonRider_DB.speedValUnits == 4 then
		return " " .. L["UnitKilometers"]
	elseif DragonRider_DB.speedValUnits == 5 then
		return "%" --.. L["UnitPercent"]
	elseif DragonRider_DB.speedValUnits == 6 then
		return ""
	else
		return L["UnitYards"]
	end
end

function DR:convertUnits(forwardSpeed)
	if DragonRider_DB.speedValUnits == 1 then
		return forwardSpeed
	elseif DragonRider_DB.speedValUnits == 2 then
		return forwardSpeed*2.045
	elseif DragonRider_DB.speedValUnits == 3 then
		return forwardSpeed
	elseif DragonRider_DB.speedValUnits == 4 then
		return forwardSpeed*3.6
	elseif DragonRider_DB.speedValUnits == 5 then
		return forwardSpeed/7*100
	elseif DragonRider_DB.speedValUnits == 6 then
		return forwardSpeed
	else
		return forwardSpeed
	end
end

local DRAGON_RACE_AURA_ID = 369968;

function DR.updateSpeed()
	if not LibAdvFlight.IsAdvFlyEnabled() and not DR.DriveUtils.IsDriving() then
		return;
	end

	local forwardSpeed = LibAdvFlight.GetForwardSpeed();
	if not LibAdvFlight.IsAdvFlyEnabled() then
		forwardSpeed = DR.DriveUtils.GetSmoothedSpeed()
	end
	local racing = C_UnitAuras.GetPlayerAuraBySpellID(DRAGON_RACE_AURA_ID)

	local THRESHOLD_HIGH;
	local THRESHOLD_LOW;
	local MIN_BAR_VALUE;
	local MAX_BAR_VALUE;

	if DR.DragonRidingZoneCheck() == true or racing then
		THRESHOLD_HIGH = 65;
		THRESHOLD_LOW = 60;
		MIN_BAR_VALUE = 0;
		MAX_BAR_VALUE = 100;
	elseif DR.DriveUtils.IsDriving() then
		THRESHOLD_HIGH = 100 * .55;
		THRESHOLD_LOW = 100 * .40;
		MIN_BAR_VALUE = 0;
		MAX_BAR_VALUE = 100;
	else
		THRESHOLD_HIGH = 85 * .65;
		THRESHOLD_LOW = 85 * .60;
		MIN_BAR_VALUE = 0;
		MAX_BAR_VALUE = 85;
	end

	DR.statusbar:SetMinMaxValues(MIN_BAR_VALUE, MAX_BAR_VALUE);
	local textColor;
	local barColor;

	if forwardSpeed > THRESHOLD_HIGH then
		textColor = DragonRider_DB.speedTextColor.over;
		barColor = DragonRider_DB.speedBarColor.over;
	elseif forwardSpeed >= THRESHOLD_LOW and forwardSpeed <= THRESHOLD_HIGH then
		textColor = DragonRider_DB.speedTextColor.vigor;
		barColor = DragonRider_DB.speedBarColor.vigor;
	else
		textColor = DragonRider_DB.speedTextColor.slow;
		barColor = DragonRider_DB.speedBarColor.slow;
	end

	textColor = CreateColor(textColor.r, textColor.g, textColor.b, textColor.a);
	local text = format("|c%s%.1f%s|r", textColor:GenerateHexColor(), DR:convertUnits(forwardSpeed), DR.useUnits());
	if DR.DriveUtils.IsDriving() then
		text = format("|c%s%.0f%s|r", textColor:GenerateHexColor(), DR:convertUnits(forwardSpeed), DR.useUnits());
	end
	DR.glide:SetText(text);
	DR.statusbar:SetStatusBarColor(barColor.r, barColor.g, barColor.b, barColor.a);

	if DragonRider_DB.speedValUnits == 6 then
		DR.glide:SetText("")
	end
	DR.statusbar:SetSmoothedValue(forwardSpeed)
end

function DR.SetTheme()
	if DragonRider_DB.themeSpeed == 1 then --Default
		DR.statusbar:SetWidth(305/1.25)
		DR.statusbar:SetHeight(66.5/2.75)
		DR.statusbar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
		DR.statusbar:GetStatusBarTexture():SetHorizTile(false)
		DR.statusbar:GetStatusBarTexture():SetVertTile(false)
		DR.statusbar.bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")

		DR.tick1:SetAtlas("UI-Frame-Bar-BorderTick")
		DR.tick2:SetAtlas("UI-Frame-Bar-BorderTick")
		DR.tick1:SetSize(17,DR.statusbar:GetHeight()*1.5)
		DR.tick1:SetPoint("TOP", DR.statusbar, "TOPLEFT", (65 / 100) * DR.statusbar:GetWidth(), 5)
		DR.tick2:SetSize(17,DR.statusbar:GetHeight()*1.5)
		DR.tick2:SetPoint("TOP", DR.statusbar, "TOPLEFT", (60 / 100) * DR.statusbar:GetWidth(), 5)
		if DR.DriveUtils.IsDriving() then
			DR.tick1:SetPoint("TOP", DR.statusbar, "TOPLEFT", (40 / 100) * DR.statusbar:GetWidth(), 5)
			DR.tick2:SetPoint("TOP", DR.statusbar, "TOPLEFT", (55 / 100) * DR.statusbar:GetWidth(), 5)
		end

		DR.backdropL:SetAtlas("widgetstatusbar-borderleft")
		DR.backdropR:SetAtlas("widgetstatusbar-borderright")
		DR.backdropM:SetAtlas("widgetstatusbar-bordercenter")
		DR.backdropL:SetWidth(35)
		DR.backdropL:SetHeight(40)
		DR.backdropR:SetWidth(35)
		DR.backdropR:SetHeight(40)
		DR.backdropL:SetPoint("LEFT", DR.statusbar, "LEFT", -7, 0)
		DR.backdropR:SetPoint("RIGHT", DR.statusbar, "RIGHT", 7, 0)

		DR.backdropTopper:SetAtlas("dragonflight-score-topper")
		DR.backdropFooter:SetAtlas("dragonflight-score-footer")
		DR.backdropTopper:SetSize(350,65)
		DR.backdropFooter:SetSize(350,65)
		DR.backdropTopper:SetPoint("TOP", DR.statusbar, "TOP", 0, 38)
		DR.backdropFooter:SetPoint("BOTTOM", DR.statusbar, "BOTTOM", 0, -32)
		DR.backdropTopper:SetDrawLayer("OVERLAY", 3)
		DR.backdropFooter:SetDrawLayer("OVERLAY", 3)

		frameborder.left:SetColorTexture(0,0,0,0)
		frameborder.right:SetColorTexture(0,0,0,0)
		frameborder.top:SetColorTexture(0,0,0,0)
		frameborder.bottom:SetColorTexture(0,0,0,0)


	elseif DragonRider_DB.themeSpeed == 2 then --Algari
		DR.statusbar:SetWidth(305/1.25)
		DR.statusbar:SetHeight(66.5/2.75)

		--change for algarian stormrider colors
		if UIWidgetPowerBarContainerFrame then
			if UIWidgetPowerBarContainerFrame.widgetFrames then
				if UIWidgetPowerBarContainerFrame.widgetFrames[5140] then -- gold tex
					DR.backdropL:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_L_G.blp")
					DR.backdropR:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_R_G.blp")
					DR.backdropM:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_M_G.blp")

					DR.backdropTopper:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_Topper_G.blp")
					DR.backdropFooter:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_Footer_G.blp")

				elseif UIWidgetPowerBarContainerFrame.widgetFrames[5143] then -- silver tex
					DR.backdropL:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_L_S.blp")
					DR.backdropR:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_R_S.blp")
					DR.backdropM:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_M_S.blp")

					DR.backdropTopper:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_Topper_S.blp")
					DR.backdropFooter:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_Footer_S.blp")

				elseif UIWidgetPowerBarContainerFrame.widgetFrames[5144] then -- bronze tex
					DR.backdropL:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_L_B.blp")
					DR.backdropR:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_R_B.blp")
					DR.backdropM:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_M_B.blp")

					DR.backdropTopper:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_Topper_B.blp")
					DR.backdropFooter:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_Footer_B.blp")

				elseif UIWidgetPowerBarContainerFrame.widgetFrames[5145] then -- dark tex
					DR.backdropL:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_L_D.blp")
					DR.backdropR:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_R_D.blp")
					DR.backdropM:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_M_D.blp")

					DR.backdropTopper:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_Topper_D.blp")
					DR.backdropFooter:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_Footer_D.blp")

				else --default, should be gold tex
					DR.backdropL:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_L_G.blp")
					DR.backdropR:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_R_G.blp")
					DR.backdropM:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_M_G.blp")

					DR.backdropTopper:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_Topper_G.blp")
					DR.backdropFooter:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_Footer_G.blp")

				end
			end
		end

		DR.statusbar:SetStatusBarTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_Progress.blp")
		DR.statusbar:GetStatusBarTexture():SetHorizTile(false)
		DR.statusbar:GetStatusBarTexture():SetVertTile(false)
		DR.statusbar.bg:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Ed\\Ed_BG.blp")

		DR.tick1:SetAtlas("UI-Frame-Bar-BorderTick")
		DR.tick2:SetAtlas("UI-Frame-Bar-BorderTick")
		DR.tick1:SetSize(17,DR.statusbar:GetHeight()*1.5)
		DR.tick1:SetPoint("TOP", DR.statusbar, "TOPLEFT", (65 / 100) * DR.statusbar:GetWidth(), 5)
		DR.tick2:SetSize(17,DR.statusbar:GetHeight()*1.5)
		DR.tick2:SetPoint("TOP", DR.statusbar, "TOPLEFT", (60 / 100) * DR.statusbar:GetWidth(), 5)
		if DR.DriveUtils.IsDriving() then
			DR.tick1:SetPoint("TOP", DR.statusbar, "TOPLEFT", (40 / 100) * DR.statusbar:GetWidth(), 5)
			DR.tick2:SetPoint("TOP", DR.statusbar, "TOPLEFT", (55 / 100) * DR.statusbar:GetWidth(), 5)
		end

		DR.backdropL:SetWidth(70)
		DR.backdropL:SetHeight(75)
		DR.backdropR:SetWidth(70)
		DR.backdropR:SetHeight(75)
		DR.backdropL:SetPoint("LEFT", DR.statusbar, "LEFT", -37, 0)
		DR.backdropR:SetPoint("RIGHT", DR.statusbar, "RIGHT", 37, 0)

		DR.backdropTopper:SetSize(150,65)
		DR.backdropFooter:SetSize(115,50)
		DR.backdropTopper:SetPoint("TOP", DR.statusbar, "TOP", 0, 39)
		DR.backdropFooter:SetPoint("BOTTOM", DR.statusbar, "BOTTOM", 0, -28)
		DR.backdropTopper:SetDrawLayer("OVERLAY", 3)
		DR.backdropFooter:SetDrawLayer("OVERLAY", 3)

		frameborder.left:SetColorTexture(0,0,0,0)
		frameborder.right:SetColorTexture(0,0,0,0)
		frameborder.top:SetColorTexture(0,0,0,0)
		frameborder.bottom:SetColorTexture(0,0,0,0)


	elseif DragonRider_DB.themeSpeed == 3 then -- Minimalist
		DR.statusbar:SetWidth(305/1.25)
		DR.statusbar:SetHeight(66.5/2.75)
		DR.statusbar:SetStatusBarTexture("Interface\\buttons\\white8x8")
		DR.statusbar:GetStatusBarTexture():SetHorizTile(false)
		DR.statusbar:GetStatusBarTexture():SetVertTile(false)
		DR.statusbar.bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")

		DR.tick1:SetTexture("Interface\\buttons\\white8x8")
		DR.tick2:SetTexture("Interface\\buttons\\white8x8")
		DR.tick1:SetSize(1,DR.statusbar:GetHeight())
		DR.tick1:SetPoint("TOP", DR.statusbar, "TOPLEFT", (65 / 100) * DR.statusbar:GetWidth(), 0)
		DR.tick2:SetSize(1,DR.statusbar:GetHeight())
		DR.tick2:SetPoint("TOP", DR.statusbar, "TOPLEFT", (60 / 100) * DR.statusbar:GetWidth(), 0)
		if DR.DriveUtils.IsDriving() then
			DR.tick1:SetPoint("TOP", DR.statusbar, "TOPLEFT", (40 / 100) * DR.statusbar:GetWidth(), 5)
			DR.tick2:SetPoint("TOP", DR.statusbar, "TOPLEFT", (55 / 100) * DR.statusbar:GetWidth(), 5)
		end
		DR.tick1:SetColorTexture(1, 1, 1, 1)
		DR.tick2:SetColorTexture(1, 1, 1, 1)

		DR.backdropL:SetAtlas(nil)
		DR.backdropR:SetAtlas(nil)
		DR.backdropM:SetAtlas(nil)
		DR.backdropL:SetWidth(35)
		DR.backdropL:SetHeight(40)
		DR.backdropR:SetWidth(35)
		DR.backdropR:SetHeight(40)
		DR.backdropL:SetPoint("LEFT", DR.statusbar, "LEFT", -7, 0)
		DR.backdropR:SetPoint("RIGHT", DR.statusbar, "RIGHT", 7, 0)

		DR.backdropTopper:SetAtlas(nil)
		DR.backdropFooter:SetAtlas(nil)
		DR.backdropTopper:SetSize(350,65)
		DR.backdropFooter:SetSize(350,65)
		DR.backdropTopper:SetPoint("TOP", DR.statusbar, "TOP", 0, 38)
		DR.backdropFooter:SetPoint("BOTTOM", DR.statusbar, "BOTTOM", 0, -32)
		DR.backdropTopper:SetDrawLayer("OVERLAY", 3)
		DR.backdropFooter:SetDrawLayer("OVERLAY", 3)

		frameborder.left:SetColorTexture(0,0,0,1)
		frameborder.right:SetColorTexture(0,0,0,1)
		frameborder.top:SetColorTexture(0,0,0,1)
		frameborder.bottom:SetColorTexture(0,0,0,1)

	elseif DragonRider_DB.themeSpeed == 4 then -- Alliance

		DR.statusbar:SetWidth(305/1.25)
		DR.statusbar:SetHeight(66.5/2.75)
		DR.statusbar:SetStatusBarTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Alliance\\Alliance_Progress.blp")
		DR.statusbar:GetStatusBarTexture():SetHorizTile(false)
		DR.statusbar:GetStatusBarTexture():SetVertTile(false)
		DR.statusbar.bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")

		DR.tick1:SetAtlas("UI-Frame-Bar-BorderTick")
		DR.tick2:SetAtlas("UI-Frame-Bar-BorderTick")
		DR.tick1:SetSize(17,DR.statusbar:GetHeight()*1.5)
		DR.tick1:SetPoint("TOP", DR.statusbar, "TOPLEFT", (65 / 100) * DR.statusbar:GetWidth(), 5)
		DR.tick2:SetSize(17,DR.statusbar:GetHeight()*1.5)
		DR.tick2:SetPoint("TOP", DR.statusbar, "TOPLEFT", (60 / 100) * DR.statusbar:GetWidth(), 5)
		if DR.DriveUtils.IsDriving() then
			DR.tick1:SetPoint("TOP", DR.statusbar, "TOPLEFT", (40 / 100) * DR.statusbar:GetWidth(), 5)
			DR.tick2:SetPoint("TOP", DR.statusbar, "TOPLEFT", (55 / 100) * DR.statusbar:GetWidth(), 5)
		end

		DR.backdropL:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Alliance\\Alliance_L.blp")
		DR.backdropR:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Alliance\\Alliance_R.blp")
		DR.backdropM:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Alliance\\Alliance_M.blp")
		DR.backdropL:SetWidth(70)
		DR.backdropL:SetHeight(75)
		DR.backdropR:SetWidth(70)
		DR.backdropR:SetHeight(75)
		DR.backdropL:SetPoint("LEFT", DR.statusbar, "LEFT", -37, 0)
		DR.backdropR:SetPoint("RIGHT", DR.statusbar, "RIGHT", 37, 0)

		DR.backdropTopper:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Alliance\\Alliance_Topper.blp")
		DR.backdropFooter:SetTexture(nil)

		DR.backdropTopper:SetSize(350,65)
		DR.backdropFooter:SetSize(350,65)
		DR.backdropTopper:SetPoint("TOP", DR.statusbar, "TOP", 0, 39.5)
		DR.backdropFooter:SetPoint("BOTTOM", DR.statusbar, "BOTTOM", 0, -28)
		DR.backdropTopper:SetDrawLayer("OVERLAY", 3)
		DR.backdropFooter:SetDrawLayer("OVERLAY", 3)
		DR.backdropFooter:SetDrawLayer("OVERLAY", 3)

		frameborder.left:SetColorTexture(0,0,0,0)
		frameborder.right:SetColorTexture(0,0,0,0)
		frameborder.top:SetColorTexture(0,0,0,0)
		frameborder.bottom:SetColorTexture(0,0,0,0)

	elseif DragonRider_DB.themeSpeed == 5 then -- Horde

		DR.statusbar:SetWidth(305/1.25)
		DR.statusbar:SetHeight(66.5/2.75)
		DR.statusbar:SetStatusBarTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Horde\\Horde_Progress.blp")
		DR.statusbar:GetStatusBarTexture():SetHorizTile(false)
		DR.statusbar:GetStatusBarTexture():SetVertTile(false)
		DR.statusbar.bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")

		DR.tick1:SetAtlas("UI-Frame-Bar-BorderTick")
		DR.tick2:SetAtlas("UI-Frame-Bar-BorderTick")
		DR.tick1:SetSize(17,DR.statusbar:GetHeight()*1.5)
		DR.tick1:SetPoint("TOP", DR.statusbar, "TOPLEFT", (65 / 100) * DR.statusbar:GetWidth(), 5)
		DR.tick2:SetSize(17,DR.statusbar:GetHeight()*1.5)
		DR.tick2:SetPoint("TOP", DR.statusbar, "TOPLEFT", (60 / 100) * DR.statusbar:GetWidth(), 5)
		if DR.DriveUtils.IsDriving() then
			DR.tick1:SetPoint("TOP", DR.statusbar, "TOPLEFT", (40 / 100) * DR.statusbar:GetWidth(), 5)
			DR.tick2:SetPoint("TOP", DR.statusbar, "TOPLEFT", (55 / 100) * DR.statusbar:GetWidth(), 5)
		end

		DR.backdropL:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Horde\\Horde_L.blp")
		DR.backdropR:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Horde\\Horde_R.blp")
		DR.backdropM:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Horde\\Horde_M.blp")
		DR.backdropL:SetWidth(70)
		DR.backdropL:SetHeight(75)
		DR.backdropR:SetWidth(70)
		DR.backdropR:SetHeight(75)
		DR.backdropL:SetPoint("LEFT", DR.statusbar, "LEFT", -37, 0)
		DR.backdropR:SetPoint("RIGHT", DR.statusbar, "RIGHT", 37, 0)

		DR.backdropTopper:SetTexture("Interface\\AddOns\\DragonRider\\Textures\\Speed_Themes\\Horde\\Horde_Topper.blp")
		DR.backdropFooter:SetTexture(nil)

		DR.backdropTopper:SetSize(350,65)
		DR.backdropFooter:SetSize(350,65)
		DR.backdropTopper:SetPoint("TOP", DR.statusbar, "TOP", 0, 39.5)
		DR.backdropFooter:SetPoint("BOTTOM", DR.statusbar, "BOTTOM", 0, -28)
		DR.backdropTopper:SetDrawLayer("OVERLAY", 3)
		DR.backdropFooter:SetDrawLayer("OVERLAY", 3)
		DR.backdropFooter:SetDrawLayer("OVERLAY", 3)

		frameborder.left:SetColorTexture(0,0,0,0)
		frameborder.right:SetColorTexture(0,0,0,0)
		frameborder.top:SetColorTexture(0,0,0,0)
		frameborder.bottom:SetColorTexture(0,0,0,0)

	else -- Revert to default
		DR.statusbar:SetWidth(305/1.25)
		DR.statusbar:SetHeight(66.5/2.75)
		DR.statusbar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
		DR.statusbar:GetStatusBarTexture():SetHorizTile(false)
		DR.statusbar:GetStatusBarTexture():SetVertTile(false)
		DR.statusbar.bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")

		DR.tick1:SetAtlas("UI-Frame-Bar-BorderTick")
		DR.tick2:SetAtlas("UI-Frame-Bar-BorderTick")

		DR.backdropL:SetAtlas("widgetstatusbar-borderleft")
		DR.backdropR:SetAtlas("widgetstatusbar-borderright")
		DR.backdropM:SetAtlas("widgetstatusbar-bordercenter")
		DR.backdropL:SetWidth(35)
		DR.backdropL:SetHeight(40)
		DR.backdropR:SetWidth(35)
		DR.backdropR:SetHeight(40)
		DR.backdropL:SetPoint("LEFT", DR.statusbar, "LEFT", -7, 0)
		DR.backdropR:SetPoint("RIGHT", DR.statusbar, "RIGHT", 7, 0)

		DR.backdropTopper:SetAtlas("dragonflight-score-topper")
		DR.backdropFooter:SetAtlas("dragonflight-score-footer")
		DR.backdropTopper:SetSize(350,65)
		DR.backdropFooter:SetSize(350,65)
		DR.backdropTopper:SetPoint("TOP", DR.statusbar, "TOP", 0, 38)
		DR.backdropFooter:SetPoint("BOTTOM", DR.statusbar, "BOTTOM", 0, -32)
		DR.backdropTopper:SetDrawLayer("OVERLAY", 3)
		DR.backdropFooter:SetDrawLayer("OVERLAY", 3)

		frameborder.left:SetColorTexture(0,0,0,0)
		frameborder.right:SetColorTexture(0,0,0,0)
		frameborder.top:SetColorTexture(0,0,0,0)
		frameborder.bottom:SetColorTexture(0,0,0,0)
	end
end

function DR.GetBarAlpha()
	return DR.statusbar:GetAlpha()
end

DR.fadeInBarGroup = DR.statusbar:CreateAnimationGroup()
DR.fadeOutBarGroup = DR.statusbar:CreateAnimationGroup()

-- Create a fade in animation
DR.fadeInBar = DR.fadeInBarGroup:CreateAnimation("Alpha")
DR.fadeInBar:SetFromAlpha(DR.GetBarAlpha())
DR.fadeInBar:SetToAlpha(1)
DR.fadeInBar:SetDuration(.5) -- Duration of the fade in animation

-- Create a fade out animation
DR.fadeOutBar = DR.fadeOutBarGroup:CreateAnimation("Alpha")
DR.fadeOutBar:SetFromAlpha(DR.GetBarAlpha())
DR.fadeOutBar:SetToAlpha(0)
DR.fadeOutBar:SetDuration(.1) -- Duration of the fade out animation

-- Set scripts for when animations start and finish
DR.fadeOutBarGroup:SetScript("OnFinished", function()
	if LibAdvFlight.IsAdvFlying() or DR.DriveUtils.IsDriving() then
		return
	end
	DR.statusbar:ClearAllPoints();
	DR.statusbar:Hide(); -- Hide the frame when the fade out animation is finished
end)
DR.fadeInBarGroup:SetScript("OnPlay", function()
	DR.setPositions();
	DR.statusbar:Show(); -- Show the frame when the fade in animation starts
end)

-- Function to show the frame with a fade in animation
function DR.ShowWithFadeBar()
	DR.fadeInBarGroup:Stop(); -- Stop any ongoing animations
	DR.fadeInBarGroup:Play(); -- Play the fade in animation
end

-- Function to hide the frame with a fade out animation
function DR.HideWithFadeBar()
	DR.fadeOutBarGroup:Stop(); -- Stop any ongoing animations
	DR.fadeOutBarGroup:Play(); -- Play the fade out animation
end