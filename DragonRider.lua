local _, L = ...

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

};

local function ShowColorPicker(r, g, b, a, changedCallback)
    ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a;
    ColorPickerFrame.previousValues = {r,g,b,a};
    ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = changedCallback, changedCallback, changedCallback;
    ColorPickerFrame:SetColorRGB(r,g,b);
    ColorPickerFrame:Hide(); -- Need to run the OnShow handler.
    ColorPickerFrame:Show();
end

local function ProgBarLowColor(restore)
    local newR, newG, newB, newA; -- I forgot what to do with the alpha value but it's needed to not swap RGB values
    if restore then
     -- The user bailed, we extract the old color from the table created by ShowColorPicker.
        newR, newG, newB, newA = unpack(restore);
    else
     -- Something changed
        newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB();
    end
     -- Update our internal storage.
    r, g, b, a = newR, newG, newB, newA
     -- And update any UI elements that use this color...
    DragonRider_DB.speedBarColor.slow.r, DragonRider_DB.speedBarColor.slow.g, DragonRider_DB.speedBarColor.slow.b, DragonRider_DB.speedBarColor.slow.a = newR, newG, newB, newA;
end

local function ProgBarMidColor(restore)
    local newR, newG, newB, newA; -- I forgot what to do with the alpha value but it's needed to not swap RGB values
    if restore then
     -- The user bailed, we extract the old color from the table created by ShowColorPicker.
        newR, newG, newB, newA = unpack(restore);
    else
     -- Something changed
        newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB();
    end
     -- Update our internal storage.
    r, g, b, a = newR, newG, newB, newA
     -- And update any UI elements that use this color...
    DragonRider_DB.speedBarColor.vigor.r, DragonRider_DB.speedBarColor.vigor.g, DragonRider_DB.speedBarColor.vigor.b, DragonRider_DB.speedBarColor.vigor.a = newR, newG, newB, newA;
end

local function ProgBarHighColor(restore)
    local newR, newG, newB, newA; -- I forgot what to do with the alpha value but it's needed to not swap RGB values
    if restore then
     -- The user bailed, we extract the old color from the table created by ShowColorPicker.
        newR, newG, newB, newA = unpack(restore);
    else
     -- Something changed
        newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB();
    end
     -- Update our internal storage.
    r, g, b, a = newR, newG, newB, newA
     -- And update any UI elements that use this color...
    DragonRider_DB.speedBarColor.over.r, DragonRider_DB.speedBarColor.over.g, DragonRider_DB.speedBarColor.over.b, DragonRider_DB.speedBarColor.over.a = newR, newG, newB, newA;
end

local function TextLowColor(restore)
    local newR, newG, newB, newA; -- I forgot what to do with the alpha value but it's needed to not swap RGB values
    if restore then
     -- The user bailed, we extract the old color from the table created by ShowColorPicker.
        newR, newG, newB, newA = unpack(restore);
    else
     -- Something changed
        newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB();
    end
     -- Update our internal storage.
    r, g, b, a = newR, newG, newB, newA
     -- And update any UI elements that use this color...
    DragonRider_DB.speedTextColor.slow.r, DragonRider_DB.speedTextColor.slow.g, DragonRider_DB.speedTextColor.slow.b, DragonRider_DB.speedTextColor.slow.a = newR, newG, newB, newA;
end

local function TextMidColor(restore)
    local newR, newG, newB, newA; -- I forgot what to do with the alpha value but it's needed to not swap RGB values
    if restore then
     -- The user bailed, we extract the old color from the table created by ShowColorPicker.
        newR, newG, newB, newA = unpack(restore);
    else
     -- Something changed
        newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB();
    end
     -- Update our internal storage.
    r, g, b, a = newR, newG, newB, newA
     -- And update any UI elements that use this color...
    DragonRider_DB.speedTextColor.vigor.r, DragonRider_DB.speedTextColor.vigor.g, DragonRider_DB.speedTextColor.vigor.b, DragonRider_DB.speedTextColor.vigor.a = newR, newG, newB, newA;
end

local function TextHighColor(restore)
    local newR, newG, newB, newA; -- I forgot what to do with the alpha value but it's needed to not swap RGB values
    if restore then
     -- The user bailed, we extract the old color from the table created by ShowColorPicker.
        newR, newG, newB, newA = unpack(restore);
    else
     -- Something changed
        newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB();
    end
     -- Update our internal storage.
    r, g, b, a = newR, newG, newB, newA
     -- And update any UI elements that use this color...
    DragonRider_DB.speedTextColor.over.r, DragonRider_DB.speedTextColor.over.g, DragonRider_DB.speedTextColor.over.b, DragonRider_DB.speedTextColor.over.a = newR, newG, newB, newA;
end




local DR = CreateFrame("Frame", nil, UIParent)

DR.statusbar = CreateFrame("StatusBar", nil, UIParent)
DR.statusbar:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
DR.statusbar:SetWidth(305/1.25)
DR.statusbar:SetHeight(66.5/2.75)
DR.statusbar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
DR.statusbar:GetStatusBarTexture():SetHorizTile(false)
DR.statusbar:GetStatusBarTexture():SetVertTile(false)
DR.statusbar:SetStatusBarColor(.98, .61, .0)
DR.statusbar:SetMinMaxValues(0, 100)
Mixin(DR.statusbar, SmoothStatusBarMixin)
DR.statusbar:SetMinMaxSmoothedValue(0,100)

DR.tick1 = DR.statusbar:CreateTexture(nil, "OVERLAY")
DR.tick1:SetAtlas("UI-Frame-Bar-BorderTick")
DR.tick1:SetSize(17,DR.statusbar:GetHeight()*1.5)
DR.tick1:SetPoint("TOP", DR.statusbar, "TOPLEFT", (65 / 100) * DR.statusbar:GetWidth(), 5)

DR.tick2 = DR.statusbar:CreateTexture(nil, "OVERLAY")
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


DR.backdropL = DR.statusbar:CreateTexture(nil, "OVERLAY")
DR.backdropL:SetAtlas("widgetstatusbar-borderleft") -- UI-Frame-Dragonflight-TitleLeft
DR.backdropL:SetPoint("LEFT", DR.statusbar, "LEFT", -7, 0)
DR.backdropL:SetWidth(35)
DR.backdropL:SetHeight(40)

DR.backdropR = DR.statusbar:CreateTexture(nil, "OVERLAY")
DR.backdropR:SetAtlas("widgetstatusbar-borderright") -- UI-Frame-Dragonflight-TitleRight
DR.backdropR:SetPoint("RIGHT", DR.statusbar, "RIGHT", 7, 0)
DR.backdropR:SetWidth(35)
DR.backdropR:SetHeight(40)

DR.backdropM = DR.statusbar:CreateTexture(nil, "OVERLAY")
DR.backdropM:SetAtlas("widgetstatusbar-bordercenter") -- _UI-Frame-Dragonflight-TitleMiddle
DR.backdropM:SetPoint("TOPLEFT", DR.backdropL, "TOPRIGHT", 0, 0)
DR.backdropM:SetPoint("BOTTOMRIGHT", DR.backdropR, "BOTTOMLEFT", 0, 0)

DR.backdropTopper = DR.statusbar:CreateTexture(nil, "OVERLAY")
DR.backdropTopper:SetAtlas("dragonflight-score-topper")
DR.backdropTopper:SetPoint("TOP", DR.statusbar, "TOP", 0, 38)
DR.backdropTopper:SetWidth(350)
DR.backdropTopper:SetHeight(65)

DR.backdropFooter = DR.statusbar:CreateTexture(nil, "OVERLAY")
DR.backdropFooter:SetAtlas("dragonflight-score-footer")
DR.backdropFooter:SetPoint("BOTTOM", DR.statusbar, "BOTTOM", 0, -32)
DR.backdropFooter:SetWidth(350)
DR.backdropFooter:SetHeight(65)

DR.statusbar.bg = DR.statusbar:CreateTexture(nil, "BACKGROUND")
DR.statusbar.bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
DR.statusbar.bg:SetAllPoints(true)
DR.statusbar.bg:SetVertexColor(.0, .0, .0, .8)

DR.glide = DR.statusbar:CreateFontString(nil, nil, "GameTooltipText")
DR.glide:SetPoint("LEFT", DR.statusbar, "LEFT", 10, 0)

DR.modelScene1 = CreateFrame("ModelScene", nil, UIParent)
DR.modelScene1:SetPoint("CENTER", DR.statusbar, "CENTER", -105, -36)
DR.modelScene1:SetWidth(43)
DR.modelScene1:SetHeight(43)
DR.modelScene1:SetFrameStrata("MEDIUM")
DR.modelScene1:SetFrameLevel(500)

DR.model1 = DR.modelScene1:CreateActor()
DR.model1:SetModelByFileID(1100194)
DR.model1:SetPosition(5,0,-1.5)
--DR.model1:SetPitch(.3)
DR.model1:SetYaw(0)
DR.modelScene1:Show()

DR.modelScene2 = CreateFrame("ModelScene", nil, UIParent)
DR.modelScene2:SetPoint("CENTER", DR.statusbar, "CENTER", -65, -36)
DR.modelScene2:SetWidth(43)
DR.modelScene2:SetHeight(43)
DR.modelScene2:SetFrameStrata("MEDIUM")
DR.modelScene2:SetFrameLevel(500)

DR.model2 = DR.modelScene2:CreateActor()
DR.model2:SetModelByFileID(1100194)
DR.model2:SetPosition(5,0,-1.5)
--DR.model2:SetPitch(.5)
DR.model2:SetYaw(1)
DR.modelScene2:Show()

DR.modelScene3 = CreateFrame("ModelScene", nil, UIParent)
DR.modelScene3:SetPoint("CENTER", DR.statusbar, "CENTER", -25, -36)
DR.modelScene3:SetWidth(43)
DR.modelScene3:SetHeight(43)
DR.modelScene3:SetFrameStrata("MEDIUM")
DR.modelScene3:SetFrameLevel(500)

DR.model3 = DR.modelScene3:CreateActor()
DR.model3:SetModelByFileID(1100194)
DR.model3:SetPosition(5,0,-1.5)
--DR.model3:SetPitch(.3)
DR.model3:SetYaw(2)
DR.modelScene3:Show()

DR.modelScene4 = CreateFrame("ModelScene", nil, UIParent)
DR.modelScene4:SetPoint("CENTER", DR.statusbar, "CENTER", 25, -36)
DR.modelScene4:SetWidth(43)
DR.modelScene4:SetHeight(43)
DR.modelScene4:SetFrameStrata("MEDIUM")
DR.modelScene4:SetFrameLevel(500)

DR.model4 = DR.modelScene4:CreateActor()
DR.model4:SetModelByFileID(1100194)
DR.model4:SetPosition(5,0,-1.5)
--DR.model4:SetPitch(.3)
DR.model4:SetYaw(3)
DR.modelScene4:Show()

DR.modelScene5 = CreateFrame("ModelScene", nil, UIParent)
DR.modelScene5:SetPoint("CENTER", DR.statusbar, "CENTER", 65, -36)
DR.modelScene5:SetWidth(43)
DR.modelScene5:SetHeight(43)
DR.modelScene5:SetFrameStrata("MEDIUM")
DR.modelScene5:SetFrameLevel(500)

DR.model5 = DR.modelScene5:CreateActor()
DR.model5:SetModelByFileID(1100194)
DR.model5:SetPosition(5,0,-1.5)
--DR.model5:SetPitch(.3)
DR.model5:SetYaw(4)
DR.modelScene5:Show()

DR.modelScene6 = CreateFrame("ModelScene", nil, UIParent)
DR.modelScene6:SetPoint("CENTER", DR.statusbar, "CENTER", 105, -36)
DR.modelScene6:SetWidth(43)
DR.modelScene6:SetHeight(43)
DR.modelScene6:SetFrameStrata("MEDIUM")
DR.modelScene6:SetFrameLevel(500)

DR.model6 = DR.modelScene6:CreateActor()
DR.model6:SetModelByFileID(1100194)
DR.model6:SetPosition(5,0,-1.5)
--DR.model6:SetPitch(.3)
DR.model6:SetYaw(5)
DR.modelScene6:Show()


function DR.toggleModels()
    DR.modelScene1:Hide()
    DR.modelScene2:Hide()
    DR.modelScene3:Hide()
    DR.modelScene4:Hide()
    DR.modelScene5:Hide()
    DR.modelScene6:Hide()
end

DR.toggleModels()

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
        return "%" .. L["UnitPercent"]
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
    else
        return forwardSpeed
    end
end

function DR.updateSpeed()
    local isGliding, canGlide, forwardSpeed = C_PlayerInfo.GetGlidingInfo()
    local base = isGliding and forwardSpeed or GetUnitSpeed("player")
    local movespeed = Round(base / BASE_MOVEMENT_SPEED * 100)
    local roundedSpeed = Round(forwardSpeed, 3)
    if UIWidgetPowerBarContainerFrame:HasAnyWidgetsShowing() == true then
        DR:Show()
    end
    if forwardSpeed > 65 then
        local textColor = CreateColor(DragonRider_DB.speedTextColor.over.r, DragonRider_DB.speedTextColor.over.g, DragonRider_DB.speedTextColor.over.b):GenerateHexColor()
        DR.glide:SetText(format("|c" .. textColor .. "%.1f" .. DR.useUnits() .. "|r", DR:convertUnits(forwardSpeed))) -- ff71d5ff (nice purple?) -
        DR.statusbar:SetStatusBarColor(DragonRider_DB.speedBarColor.over.r, DragonRider_DB.speedBarColor.over.g, DragonRider_DB.speedBarColor.over.b, DragonRider_DB.speedBarColor.over.a)
    elseif forwardSpeed >= 60 and forwardSpeed <= 65 then
        local textColor = CreateColor(DragonRider_DB.speedTextColor.vigor.r, DragonRider_DB.speedTextColor.vigor.g, DragonRider_DB.speedTextColor.vigor.b):GenerateHexColor()
        DR.glide:SetText(format("|c" .. textColor .. "%.1f" .. DR.useUnits() .. "|r", DR:convertUnits(forwardSpeed))) -- ff71d5ff (nice blue?) - 
        DR.statusbar:SetStatusBarColor(DragonRider_DB.speedBarColor.vigor.r, DragonRider_DB.speedBarColor.vigor.g, DragonRider_DB.speedBarColor.vigor.b, DragonRider_DB.speedBarColor.vigor.a)
    else
        local textColor = CreateColor(DragonRider_DB.speedTextColor.slow.r, DragonRider_DB.speedTextColor.slow.g, DragonRider_DB.speedTextColor.slow.b):GenerateHexColor()
        DR.glide:SetText(format("|c" .. textColor .. "%.1f" .. DR.useUnits() .. "|r", DR:convertUnits(forwardSpeed))) -- fff2a305 (nice yellow?) - 
        DR.statusbar:SetStatusBarColor(DragonRider_DB.speedBarColor.slow.r, DragonRider_DB.speedBarColor.slow.g, DragonRider_DB.speedBarColor.slow.b, DragonRider_DB.speedBarColor.slow.a)
    end
    DR.statusbar:SetSmoothedValue(forwardSpeed)
end

DR.TimerNamed = C_Timer.NewTicker(.1, function()
    DR.updateSpeed()
end)
DR.TimerNamed:Cancel();


DR.MountEvents = {
    ["PLAYER_MOUNT_DISPLAY_CHANGED"] = true,
    ["MOUNT_JOURNAL_USABILITY_CHANGED"] = true,
    ["LEARNED_SPELL_IN_TAB"] = true,
    ["PLAYER_CAN_GLIDE_CHANGED"] = true,
    ["COMPANION_UPDATE"] = true,
    ["PLAYER_LOGIN"] = true,
};

DR.FakeMounts = {
    413409,
    417556,
    417548,
    417554,
    417552,
};

DR.vigorEvent = CreateFrame("Frame")
DR.vigorEvent:RegisterEvent("UNIT_POWER_UPDATE")


function DR.vigorCounter()
    local vigorCurrent = UnitPower("player", Enum.PowerType.AlternateMount)
    local vigorMax = UnitPowerMax("player", Enum.PowerType.AlternateMount)

    if DragonRider_DB.toggleModels == false then
        DR.toggleModels()
        return
    end

    if vigorCurrent == 0 then
        DR.toggleModels()
    end

    if vigorCurrent >=1 then
        DR.modelScene1:Show()
    else
        DR.modelScene1:Hide()
    end
    if vigorCurrent >=2 then
        DR.modelScene2:Show()
    else
        DR.modelScene2:Hide()
    end
    if vigorCurrent >=3 then
        DR.modelScene3:Show()
    else
        DR.modelScene3:Hide()
    end
    if vigorCurrent >=4 then
        DR.modelScene4:Show()
    else
        DR.modelScene4:Hide()
    end
    if vigorCurrent >=5 then
        DR.modelScene5:Show()
    else
        DR.modelScene5:Hide()
    end
    if vigorCurrent >=6 then
        DR.modelScene6:Show()
    else
        DR.modelScene6:Hide()
    end

    local frameLevelThing = UIWidgetPowerBarContainerFrame:GetFrameLevel()+15
    DR.modelScene1:SetFrameLevel(frameLevelThing)
    DR.modelScene2:SetFrameLevel(frameLevelThing)
    DR.modelScene3:SetFrameLevel(frameLevelThing)
    DR.modelScene4:SetFrameLevel(frameLevelThing)
    DR.modelScene5:SetFrameLevel(frameLevelThing)
    DR.modelScene6:SetFrameLevel(frameLevelThing)
    DR.setPositions()
end

DR.vigorEvent:SetScript("OnEvent", DR.vigorCounter)

DR:RegisterEvent("ADDON_LOADED")
DR:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
DR:RegisterEvent("MOUNT_JOURNAL_USABILITY_CHANGED")
DR:RegisterEvent("LEARNED_SPELL_IN_TAB")
DR:RegisterEvent("PLAYER_CAN_GLIDE_CHANGED")
DR:RegisterEvent("COMPANION_UPDATE")
DR:RegisterEvent("PLAYER_LOGIN")


function DR.setPositions()
    DR.statusbar:ClearAllPoints();
    DR.statusbar:SetPoint("BOTTOM", UIWidgetPowerBarContainerFrame, "TOP", 0, 5);
    if DragonRider_DB.speedometerPosPoint == 1 then
        DR.statusbar:ClearAllPoints();
        DR.statusbar:SetPoint("BOTTOM", UIWidgetPowerBarContainerFrame, "TOP", DragonRider_DB.speedometerPosX, DragonRider_DB.speedometerPosY);
    elseif DragonRider_DB.speedometerPosPoint == 2 then
        DR.statusbar:ClearAllPoints();
        DR.statusbar:SetPoint("TOP", UIWidgetPowerBarContainerFrame, "BOTTOM", DragonRider_DB.speedometerPosX, DragonRider_DB.speedometerPosY);
    elseif DragonRider_DB.speedometerPosPoint == 3 then
        DR.statusbar:ClearAllPoints();
        DR.statusbar:SetPoint("RIGHT", UIWidgetPowerBarContainerFrame, "LEFT", DragonRider_DB.speedometerPosX, DragonRider_DB.speedometerPosY);
    elseif DragonRider_DB.speedometerPosPoint == 4 then
        DR.statusbar:ClearAllPoints();
        DR.statusbar:SetPoint("LEFT", UIWidgetPowerBarContainerFrame, "RIGHT", DragonRider_DB.speedometerPosX, DragonRider_DB.speedometerPosY);
    end
    DR.statusbar:SetScale(DragonRider_DB.speedometerScale)
    DR.modelScene1:ClearAllPoints();
    DR.modelScene2:ClearAllPoints();
    DR.modelScene3:ClearAllPoints();
    DR.modelScene4:ClearAllPoints();
    DR.modelScene5:ClearAllPoints();
    DR.modelScene6:ClearAllPoints();
    
    if IsPlayerSpell(377922) == true then -- 6 vigor
        DR.modelScene1:SetPoint("CENTER", UIWidgetPowerBarContainerFrame, "CENTER", -105, 14);
        DR.modelScene2:SetPoint("CENTER", UIWidgetPowerBarContainerFrame, "CENTER", -63, 14);
        DR.modelScene3:SetPoint("CENTER", UIWidgetPowerBarContainerFrame, "CENTER", -21, 14);
        DR.modelScene4:SetPoint("CENTER", UIWidgetPowerBarContainerFrame, "CENTER", 21, 14);
        DR.modelScene5:SetPoint("CENTER", UIWidgetPowerBarContainerFrame, "CENTER", 63, 14);
        DR.modelScene6:SetPoint("CENTER", UIWidgetPowerBarContainerFrame, "CENTER", 105, 14);
    elseif IsPlayerSpell(377921) == true then -- 5 vigor
        DR.modelScene1:SetPoint("CENTER", UIWidgetPowerBarContainerFrame, "CENTER", -84, 14);
        DR.modelScene2:SetPoint("CENTER", UIWidgetPowerBarContainerFrame, "CENTER", -42, 14);
        DR.modelScene3:SetPoint("CENTER", UIWidgetPowerBarContainerFrame, "CENTER", 0, 14);
        DR.modelScene4:SetPoint("CENTER", UIWidgetPowerBarContainerFrame, "CENTER", 42, 14);
        DR.modelScene5:SetPoint("CENTER", UIWidgetPowerBarContainerFrame, "CENTER", 84, 14);
        DR.modelScene6:Hide()
    elseif IsPlayerSpell(377920) == true then -- 4 vigor
        DR.modelScene1:SetPoint("CENTER", UIWidgetPowerBarContainerFrame, "CENTER", -63, 14);
        DR.modelScene2:SetPoint("CENTER", UIWidgetPowerBarContainerFrame, "CENTER", -21, 14);
        DR.modelScene3:SetPoint("CENTER", UIWidgetPowerBarContainerFrame, "CENTER", 21, 14);
        DR.modelScene4:SetPoint("CENTER", UIWidgetPowerBarContainerFrame, "CENTER", 63, 14);
        DR.modelScene5:Hide()
        DR.modelScene6:Hide()
    else
        DR.modelScene1:SetPoint("CENTER", UIWidgetPowerBarContainerFrame, "CENTER", -42, 14);
        DR.modelScene2:SetPoint("CENTER", UIWidgetPowerBarContainerFrame, "CENTER", 0, 14);
        DR.modelScene3:SetPoint("CENTER", UIWidgetPowerBarContainerFrame, "CENTER", 42, 14);
        DR.modelScene4:Hide()
        DR.modelScene5:Hide()
        DR.modelScene6:Hide()
    end
end

function DR.clearPositions()
    DR.statusbar:ClearAllPoints();
    DR.statusbar:Hide();
end

DR.clearPositions()


function DR:toggleEvent(event, arg1)
    if event == "ADDON_LOADED" and arg1 == "DragonRider" then
        
        if DragonRider_DB == nil then
            DragonRider_DB = CopyTable(defaultsTable)
        end

        local settingsPanel = CreateFrame("Frame")
        local VERSION_TEXT = string.format(L["Version"], GetAddOnMetadata("DragonRider", "Version"));

        settingsPanel.name = GetAddOnMetadata("DragonRider", "Title")

        settingsPanel.Headline = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal");
        settingsPanel.Headline:SetFont(settingsPanel.Headline:GetFont(), 23);
        settingsPanel.Headline:SetTextColor(1,.73,0,1);
        settingsPanel.Headline:ClearAllPoints();
        settingsPanel.Headline:SetPoint("TOPLEFT", settingsPanel, "TOPLEFT",12,-12);
        settingsPanel.Headline:SetText(GetAddOnMetadata("DragonRider", "Title"));

        settingsPanel.Version = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal");
        settingsPanel.Version:SetFont(settingsPanel.Version:GetFont(), 12);
        settingsPanel.Version:SetTextColor(1,1,1,1);
        settingsPanel.Version:ClearAllPoints();
        settingsPanel.Version:SetPoint("TOPLEFT", settingsPanel, "TOPLEFT",400,-21);
        settingsPanel.Version:SetText(VERSION_TEXT);

        local settingsPanelScrollFrame = CreateFrame("ScrollFrame", nil, settingsPanel, "ScrollFrameTemplate")
        settingsPanelScrollFrame:SetPoint("TOPLEFT", 3, -4)
        settingsPanelScrollFrame:SetPoint("BOTTOMRIGHT", -27, 4)

        settingsPanel.scrollChild = CreateFrame("Frame")
        settingsPanelScrollFrame:SetScrollChild(settingsPanel.scrollChild)
        settingsPanel.scrollChild:SetWidth(SettingsPanel:GetWidth()-18)
        settingsPanel.scrollChild:SetHeight(1)

        ---------------------------------------------------------------------------------------------------------------------------------
        ---------------------------------------------------------------------------------------------------------------------------------
        ---------------------------------------------------------------------------------------------------------------------------------
        

        function settingsPanel:tooltip_OnEnter(frame, text)
            if GameTooltip:IsShown() == false then
                GameTooltip_SetDefaultAnchor(GameTooltip, frame);
            end
            GameTooltip:ClearAllPoints();
            GameTooltip:SetText(text, 1, 1, 1, 1, true);
            GameTooltip:SetPoint("BOTTOMLEFT", frame, "TOPRIGHT", 0, 0);
            GameTooltip:Show();
        end
        function settingsPanel.tooltip_OnLeave()
            GameTooltip:Hide();
        end

        settingsPanel.scrollChild.vigorText = settingsPanel.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal");
        settingsPanel.scrollChild.vigorText:SetFont(settingsPanel.scrollChild.vigorText:GetFont(), 15);
        settingsPanel.scrollChild.vigorText:SetTextColor(1,1,1,1);
        settingsPanel.scrollChild.vigorText:ClearAllPoints();
        settingsPanel.scrollChild.vigorText:SetPoint("TOPLEFT", 5, -53*1);
        settingsPanel.scrollChild.vigorText:SetText(L["Vigor"]);

        settingsPanel.scrollChild.speedometerText = settingsPanel.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal");
        settingsPanel.scrollChild.speedometerText:SetFont(settingsPanel.scrollChild.speedometerText:GetFont(), 15);
        settingsPanel.scrollChild.speedometerText:SetTextColor(1,1,1,1);
        settingsPanel.scrollChild.speedometerText:ClearAllPoints();
        settingsPanel.scrollChild.speedometerText:SetPoint("TOPLEFT", 350, -53*1);
        settingsPanel.scrollChild.speedometerText:SetText(L["Speedometer"]);


        settingsPanel.scrollChild.modelCheckbox = CreateFrame("CheckButton", nil, settingsPanel.scrollChild, "UICheckButtonTemplate"); -- SettingsCheckBoxTemplate
        settingsPanel.scrollChild.modelCheckbox:ClearAllPoints();
        settingsPanel.scrollChild.modelCheckbox:SetPoint("TOPLEFT", 5, -53*1.5);
        settingsPanel.scrollChild.modelCheckbox.text:SetText(L["ToggleModelsName"]);
        settingsPanel.scrollChild.modelCheckbox:SetScript("OnClick", function(self)
            if settingsPanel.scrollChild.modelCheckbox:GetChecked() then
                DragonRider_DB.toggleModels = true;
                DR.vigorCounter();
                DR.setPositions();
            else
                DragonRider_DB.toggleModels = false;
                DR.vigorCounter();
                DR.setPositions();
            end
        end);
        settingsPanel.scrollChild.modelCheckbox:SetChecked(DragonRider_DB.toggleModels)
        settingsPanel.scrollChild.modelCheckbox:SetScript("OnEnter", function(self)
            settingsPanel:tooltip_OnEnter(self, L["ToggleModelsTT"])
        end);
        settingsPanel.scrollChild.modelCheckbox:SetScript("OnLeave", settingsPanel.tooltip_OnLeave
        );


        settingsPanel.menu = {
            { text = L["Top"], func = function() DragonRider_DB.speedometerPosPoint = 1; DR.vigorCounter(); DR.setPositions(); end },
            { text = L["Bottom"], func = function() DragonRider_DB.speedometerPosPoint = 2; DR.vigorCounter(); DR.setPositions(); end },
            { text = L["Left"], func = function() DragonRider_DB.speedometerPosPoint = 3; DR.vigorCounter(); DR.setPositions(); end },
            { text = L["Right"], func = function() DragonRider_DB.speedometerPosPoint = 4; DR.vigorCounter(); DR.setPositions(); end },
        };

        settingsPanel.scrollChild.menuFrame = CreateFrame("Frame", nil, settingsPanel.scrollChild, "UIDropDownMenuTemplate")
        settingsPanel.scrollChild.positionButton = CreateFrame("Button", nil, settingsPanel.scrollChild, "SharedGoldRedButtonSmallTemplate")
        settingsPanel.scrollChild.positionButton:SetPoint("TOPLEFT", 350, -53*1.5);
        settingsPanel.scrollChild.positionButton:SetSize(150, 26);
        settingsPanel.scrollChild.positionButton:SetText(L["SpeedPosPointName"])
        settingsPanel.scrollChild.positionButton:SetScript("OnClick", function() EasyMenu(settingsPanel.menu, settingsPanel.scrollChild.menuFrame, settingsPanel.scrollChild.positionButton, 0 , 0, "MENU", 10) end)
        settingsPanel.scrollChild.positionButton:SetScript("OnEnter", function(self)
            settingsPanel:tooltip_OnEnter(self, L["SpeedPosPointTT"])
        end);
        settingsPanel.scrollChild.positionButton:SetScript("OnLeave", settingsPanel.tooltip_OnLeave);


        settingsPanel.scrollChild.xPos = CreateFrame("Slider", nil, settingsPanel.scrollChild, "OptionsSliderTemplate");
        settingsPanel.scrollChild.xPos:SetWidth(250);
        settingsPanel.scrollChild.xPos:SetHeight(15);
        settingsPanel.scrollChild.xPos:SetMinMaxValues(-Round(GetScreenWidth()),Round(GetScreenWidth()));
        settingsPanel.scrollChild.xPos:SetValueStep(1);
        settingsPanel.scrollChild.xPos:SetObeyStepOnDrag(true)
        settingsPanel.scrollChild.xPos:ClearAllPoints();
        settingsPanel.scrollChild.xPos:SetPoint("TOPLEFT", settingsPanel.scrollChild, "TOPLEFT", 350, -53*2.5);
        settingsPanel.scrollChild.xPos.Low:SetText(L["Left"]);
        settingsPanel.scrollChild.xPos.High:SetText(L["Right"]);
        settingsPanel.scrollChild.xPos.Text:SetText(L["SpeedPosXName"]);
        settingsPanel.scrollChild.xPos:SetScript("OnValueChanged", function()
            local scaleValue = settingsPanel.scrollChild.xPos:GetValue();
            DragonRider_DB.speedometerPosX = scaleValue
            DR.vigorCounter();
            DR.setPositions();
        end)
        settingsPanel.scrollChild.xPos:SetValue(DragonRider_DB.speedometerPosX)
        settingsPanel.scrollChild.xPos:SetScript("OnEnter", function(self)
            settingsPanel:tooltip_OnEnter(self, L["SpeedPosXTT"])
        end);
        settingsPanel.scrollChild.xPos:SetScript("OnLeave", settingsPanel.tooltip_OnLeave);


        settingsPanel.scrollChild.yPos = CreateFrame("Slider", nil, settingsPanel.scrollChild, "OptionsSliderTemplate");
        settingsPanel.scrollChild.yPos:SetWidth(250);
        settingsPanel.scrollChild.yPos:SetHeight(15);
        settingsPanel.scrollChild.yPos:SetMinMaxValues(-Round(GetScreenWidth()),Round(GetScreenWidth()));
        settingsPanel.scrollChild.yPos:SetValueStep(1);
        settingsPanel.scrollChild.yPos:SetObeyStepOnDrag(true)
        settingsPanel.scrollChild.yPos:ClearAllPoints();
        settingsPanel.scrollChild.yPos:SetPoint("TOPLEFT", settingsPanel.scrollChild, "TOPLEFT", 350, -53*3);
        settingsPanel.scrollChild.yPos.Low:SetText(L["Bottom"]);
        settingsPanel.scrollChild.yPos.High:SetText(L["Top"]);
        settingsPanel.scrollChild.yPos.Text:SetText(L["SpeedPosYName"]);
        settingsPanel.scrollChild.yPos:SetScript("OnValueChanged", function()
            local scaleValue = settingsPanel.scrollChild.yPos:GetValue();
            DragonRider_DB.speedometerPosY = scaleValue
            DR.vigorCounter();
            DR.setPositions();
        end)
        settingsPanel.scrollChild.yPos:SetValue(DragonRider_DB.speedometerPosY)
        settingsPanel.scrollChild.yPos:SetScript("OnEnter", function(self)
            settingsPanel:tooltip_OnEnter(self, L["SpeedPosYTT"])
        end);
        settingsPanel.scrollChild.yPos:SetScript("OnLeave", settingsPanel.tooltip_OnLeave);


        settingsPanel.scrollChild.scaleProg = CreateFrame("Slider", nil, settingsPanel.scrollChild, "OptionsSliderTemplate");
        settingsPanel.scrollChild.scaleProg:SetWidth(250);
        settingsPanel.scrollChild.scaleProg:SetHeight(15);
        settingsPanel.scrollChild.scaleProg:SetMinMaxValues(.4,4);
        settingsPanel.scrollChild.scaleProg:SetValueStep(.1);
        settingsPanel.scrollChild.scaleProg:SetObeyStepOnDrag(true)
        settingsPanel.scrollChild.scaleProg:ClearAllPoints();
        settingsPanel.scrollChild.scaleProg:SetPoint("TOPLEFT", settingsPanel.scrollChild, "TOPLEFT", 350, -53*3.5);
        settingsPanel.scrollChild.scaleProg.Low:SetText(L["Small"]);
        settingsPanel.scrollChild.scaleProg.High:SetText(L["Large"]);
        settingsPanel.scrollChild.scaleProg.Text:SetText(L["SpeedScaleName"]);
        settingsPanel.scrollChild.scaleProg:SetScript("OnValueChanged", function()
            local scaleValue = settingsPanel.scrollChild.scaleProg:GetValue();
            DragonRider_DB.speedometerScale = scaleValue
            DR.vigorCounter();
            DR.setPositions();
        end)
        settingsPanel.scrollChild.scaleProg:SetValue(DragonRider_DB.speedometerScale)
        settingsPanel.scrollChild.scaleProg:SetScript("OnEnter", function(self)
            settingsPanel:tooltip_OnEnter(self, L["SpeedPosYTT"])
        end);
        settingsPanel.scrollChild.scaleProg:SetScript("OnLeave", settingsPanel.tooltip_OnLeave);


        settingsPanel.menu2 = {
            { text = L["Yards"] .. " - " .. L["UnitYards"], func = function() DragonRider_DB.speedValUnits = 1; DR.vigorCounter(); DR.setPositions(); end },
            { text = L["Miles"] .. " - " .. L["UnitMiles"], func = function() DragonRider_DB.speedValUnits = 2; DR.vigorCounter(); DR.setPositions(); end },
            { text = L["Meters"] .. " - " .. L["UnitMeters"], func = function() DragonRider_DB.speedValUnits = 3; DR.vigorCounter(); DR.setPositions(); end },
            { text = L["Kilometers"] .. " - " .. L["UnitKilometers"], func = function() DragonRider_DB.speedValUnits = 4; DR.vigorCounter(); DR.setPositions(); end },
            { text = L["Percentage"] .. " - " .. L["UnitPercent"], func = function() DragonRider_DB.speedValUnits = 5; DR.vigorCounter(); DR.setPositions(); end },
        };

        settingsPanel.scrollChild.menuFrame2 = CreateFrame("Frame", nil, settingsPanel.scrollChild, "UIDropDownMenuTemplate")
        settingsPanel.scrollChild.positionButton2 = CreateFrame("Button", nil, settingsPanel.scrollChild, "SharedGoldRedButtonSmallTemplate")
        settingsPanel.scrollChild.positionButton2:SetPoint("TOPLEFT", 350, -53*4);
        settingsPanel.scrollChild.positionButton2:SetSize(150, 26);
        settingsPanel.scrollChild.positionButton2:SetText(L["Units"])
        settingsPanel.scrollChild.positionButton2:SetScript("OnClick", function() EasyMenu(settingsPanel.menu2, settingsPanel.scrollChild.menuFrame2, settingsPanel.scrollChild.positionButton2, 0 , 0, "MENU", 10) end)
        settingsPanel.scrollChild.positionButton2:SetScript("OnEnter", function(self)
            settingsPanel:tooltip_OnEnter(self, L["UnitsTT"])
        end);
        settingsPanel.scrollChild.positionButton2:SetScript("OnLeave", settingsPanel.tooltip_OnLeave);


        settingsPanel.scrollChild.progLowColor = CreateFrame("Button", nil, settingsPanel.scrollChild, "SharedGoldRedButtonSmallTemplate")
        settingsPanel.scrollChild.progLowColor:SetPoint("TOPLEFT", 350, -53*4.5);
        settingsPanel.scrollChild.progLowColor:SetSize(120, 26);
        settingsPanel.scrollChild.progLowColor:SetText(COLOR_PICKER)
        settingsPanel.scrollChild.progLowColor:SetScript("OnClick", function() ShowColorPicker(DragonRider_DB.speedBarColor.slow.r, DragonRider_DB.speedBarColor.slow.g, DragonRider_DB.speedBarColor.slow.b, DragonRider_DB.speedBarColor.slow.a, ProgBarLowColor); end)

        settingsPanel.scrollChild.progLowColorText = settingsPanel.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal");
        settingsPanel.scrollChild.progLowColorText:SetFont(settingsPanel.scrollChild.progLowColorText:GetFont(), 11);
        settingsPanel.scrollChild.progLowColorText:SetTextColor(1,1,1,1);
        settingsPanel.scrollChild.progLowColorText:ClearAllPoints();
        settingsPanel.scrollChild.progLowColorText:SetPoint("TOPLEFT", 475, -53*4.5);
        settingsPanel.scrollChild.progLowColorText:SetText(L["ProgressBar"] .. " " .. COLOR .. " - " .. L["Low"]);


        settingsPanel.scrollChild.progMidColor = CreateFrame("Button", nil, settingsPanel.scrollChild, "SharedGoldRedButtonSmallTemplate")
        settingsPanel.scrollChild.progMidColor:SetPoint("TOPLEFT", 350, -53*5);
        settingsPanel.scrollChild.progMidColor:SetSize(120, 26);
        settingsPanel.scrollChild.progMidColor:SetText(COLOR_PICKER)
        settingsPanel.scrollChild.progMidColor:SetScript("OnClick", function() ShowColorPicker(DragonRider_DB.speedBarColor.vigor.r, DragonRider_DB.speedBarColor.vigor.g, DragonRider_DB.speedBarColor.vigor.b, DragonRider_DB.speedBarColor.vigor.a, ProgBarMidColor); end)

        settingsPanel.scrollChild.progMidColorText = settingsPanel.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal");
        settingsPanel.scrollChild.progMidColorText:SetFont(settingsPanel.scrollChild.progMidColorText:GetFont(), 11);
        settingsPanel.scrollChild.progMidColorText:SetTextColor(1,1,1,1);
        settingsPanel.scrollChild.progMidColorText:ClearAllPoints();
        settingsPanel.scrollChild.progMidColorText:SetPoint("TOPLEFT", 475, -53*5);
        settingsPanel.scrollChild.progMidColorText:SetText(L["ProgressBar"] .. " - " .. L["Vigor"]);


        settingsPanel.scrollChild.progHighColor = CreateFrame("Button", nil, settingsPanel.scrollChild, "SharedGoldRedButtonSmallTemplate")
        settingsPanel.scrollChild.progHighColor:SetPoint("TOPLEFT", 350, -53*5.5);
        settingsPanel.scrollChild.progHighColor:SetSize(120, 26);
        settingsPanel.scrollChild.progHighColor:SetText(COLOR_PICKER)
        settingsPanel.scrollChild.progHighColor:SetScript("OnClick", function() ShowColorPicker(DragonRider_DB.speedBarColor.over.r, DragonRider_DB.speedBarColor.over.g, DragonRider_DB.speedBarColor.over.b, DragonRider_DB.speedBarColor.over.a, ProgBarHighColor); end)

        settingsPanel.scrollChild.progHighColorText = settingsPanel.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal");
        settingsPanel.scrollChild.progHighColorText:SetFont(settingsPanel.scrollChild.progHighColorText:GetFont(), 11);
        settingsPanel.scrollChild.progHighColorText:SetTextColor(1,1,1,1);
        settingsPanel.scrollChild.progHighColorText:ClearAllPoints();
        settingsPanel.scrollChild.progHighColorText:SetPoint("TOPLEFT", 475, -53*5.5);
        settingsPanel.scrollChild.progHighColorText:SetText(L["ProgressBar"] .. " - " .. L["High"]);


        settingsPanel.scrollChild.progHighColor = CreateFrame("Button", nil, settingsPanel.scrollChild, "SharedGoldRedButtonSmallTemplate")
        settingsPanel.scrollChild.progHighColor:SetPoint("TOPLEFT", 350, -53*6);
        settingsPanel.scrollChild.progHighColor:SetSize(120, 26);
        settingsPanel.scrollChild.progHighColor:SetText(COLOR_PICKER)
        settingsPanel.scrollChild.progHighColor:SetScript("OnClick", function() ShowColorPicker(DragonRider_DB.speedTextColor.slow.r, DragonRider_DB.speedTextColor.slow.g, DragonRider_DB.speedTextColor.slow.b, DragonRider_DB.speedTextColor.slow.a, TextLowColor); end)

        settingsPanel.scrollChild.UnitsLowColorText = settingsPanel.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal");
        settingsPanel.scrollChild.UnitsLowColorText:SetFont(settingsPanel.scrollChild.UnitsLowColorText:GetFont(), 11);
        settingsPanel.scrollChild.UnitsLowColorText:SetTextColor(1,1,1,1);
        settingsPanel.scrollChild.UnitsLowColorText:ClearAllPoints();
        settingsPanel.scrollChild.UnitsLowColorText:SetPoint("TOPLEFT", 475, -53*6);
        settingsPanel.scrollChild.UnitsLowColorText:SetText(L["Units"] .. " - " .. L["Low"]);


        settingsPanel.scrollChild.progHighColor = CreateFrame("Button", nil, settingsPanel.scrollChild, "SharedGoldRedButtonSmallTemplate")
        settingsPanel.scrollChild.progHighColor:SetPoint("TOPLEFT", 350, -53*6.5);
        settingsPanel.scrollChild.progHighColor:SetSize(120, 26);
        settingsPanel.scrollChild.progHighColor:SetText(COLOR_PICKER)
        settingsPanel.scrollChild.progHighColor:SetScript("OnClick", function() ShowColorPicker(DragonRider_DB.speedTextColor.vigor.r, DragonRider_DB.speedTextColor.over.g, DragonRider_DB.speedTextColor.over.b, DragonRider_DB.speedTextColor.over.a, TextMidColor); end)

        settingsPanel.scrollChild.UnitsMidColorText = settingsPanel.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal");
        settingsPanel.scrollChild.UnitsMidColorText:SetFont(settingsPanel.scrollChild.UnitsMidColorText:GetFont(), 11);
        settingsPanel.scrollChild.UnitsMidColorText:SetTextColor(1,1,1,1);
        settingsPanel.scrollChild.UnitsMidColorText:ClearAllPoints();
        settingsPanel.scrollChild.UnitsMidColorText:SetPoint("TOPLEFT", 475, -53*6.5);
        settingsPanel.scrollChild.UnitsMidColorText:SetText(L["Units"] .. " - " .. L["Vigor"]);


        settingsPanel.scrollChild.progHighColor = CreateFrame("Button", nil, settingsPanel.scrollChild, "SharedGoldRedButtonSmallTemplate")
        settingsPanel.scrollChild.progHighColor:SetPoint("TOPLEFT", 350, -53*7);
        settingsPanel.scrollChild.progHighColor:SetSize(120, 26);
        settingsPanel.scrollChild.progHighColor:SetText(COLOR_PICKER)
        settingsPanel.scrollChild.progHighColor:SetScript("OnClick", function() ShowColorPicker(DragonRider_DB.speedTextColor.over.r, DragonRider_DB.speedTextColor.over.g, DragonRider_DB.speedTextColor.over.b, DragonRider_DB.speedTextColor.over.a, TextHighColor); end)

        settingsPanel.scrollChild.UnitsHighColorText = settingsPanel.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal");
        settingsPanel.scrollChild.UnitsHighColorText:SetFont(settingsPanel.scrollChild.UnitsHighColorText:GetFont(), 11);
        settingsPanel.scrollChild.UnitsHighColorText:SetTextColor(1,1,1,1);
        settingsPanel.scrollChild.UnitsHighColorText:ClearAllPoints();
        settingsPanel.scrollChild.UnitsHighColorText:SetPoint("TOPLEFT", 475, -53*7);
        settingsPanel.scrollChild.UnitsHighColorText:SetText(L["Units"] .. " - " .. L["High"]);
















        function DR.resetMenuValues()
            settingsPanel.scrollChild.modelCheckbox:SetChecked(DragonRider_DB.toggleModels);
            settingsPanel.scrollChild.xPos:SetValue(DragonRider_DB.speedometerPosX);
            settingsPanel.scrollChild.yPos:SetValue(DragonRider_DB.speedometerPosY);
            settingsPanel.scrollChild.scaleProg:SetValue(DragonRider_DB.speedometerScale);
        end

        StaticPopupDialogs["DRAGONRIDER_RESET_SETTINGS"] = {
            text = L["ResetAllSettingsConfirm"],
            button1 = "Yes",
            button2 = "No",
            OnAccept = function()
                DragonRider_DB = nil;
                DragonRider_DB = CopyTable(defaultsTable);
                DR.vigorCounter();
                DR.setPositions();
                DR.resetMenuValues();
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
        };
        
        settingsPanel.scrollChild.resetSettings = CreateFrame("Button", "Bingus", settingsPanel.scrollChild, "SharedGoldRedButtonSmallTemplate")
        settingsPanel.scrollChild.resetSettings:SetPoint("TOPRIGHT", -280, -16);
        settingsPanel.scrollChild.resetSettings:SetSize(96, 22);
        settingsPanel.scrollChild.resetSettings:SetText(SETTINGS_DEFAULTS)
        settingsPanel.scrollChild.resetSettings:SetScript("OnClick", function()
            StaticPopup_Show("DRAGONRIDER_RESET_SETTINGS")
        end)
        settingsPanel.scrollChild.resetSettings:SetScript("OnEnter", function(self)
            settingsPanel:tooltip_OnEnter(self, L["ResetAllSettingsTT"])
        end);
        settingsPanel.scrollChild.resetSettings:SetScript("OnLeave", settingsPanel.tooltip_OnLeave
        );


        ---------------------------------------------------------------------------------------------------------------------------------
        ---------------------------------------------------------------------------------------------------------------------------------
        ---------------------------------------------------------------------------------------------------------------------------------


        local category = Settings.RegisterCanvasLayoutCategory(settingsPanel,"Dragon Rider")
        Settings.RegisterAddOnCategory(category)

        DR.vigorCounter()
    end

    if DR.MountEvents[event] then
        if IsMounted() == true then
            for _, mountId in ipairs(C_MountJournal.GetCollectedDragonridingMounts()) do -- should be future-proof for all dragonriding mounts
                if select(4, C_MountJournal.GetMountInfoByID(mountId)) then
                    DR.setPositions();
                    DR.TimerNamed:Cancel();
                    DR.TimerNamed = C_Timer.NewTicker(.1, function()
                        DR.updateSpeed()
                    end)
                    DR.statusbar:Show();

                end
            end
            for _, fakeMount in ipairs(DR.FakeMounts) do -- handles the Kalimdor Cup that use fake buffs
                if C_UnitAuras.GetPlayerAuraBySpellID(fakeMount) then
                    DR.setPositions();
                    DR.TimerNamed:Cancel();
                    DR.TimerNamed = C_Timer.NewTicker(.1, function()
                        DR.updateSpeed()
                    end)
                    DR.statusbar:Show();
                end
            end
        else
            DR.clearPositions();
            DR.TimerNamed:Cancel();
        end
        --[[
        if C_UnitAuras.GetPlayerAuraBySpellID(369536) then -- this could supposedly handle the Dracthyr Soar, but addon currently anchors to vigor bar, so this is for future update
            DR.setPositions();
            DR.TimerNamed:Cancel();
            DR.TimerNamed = C_Timer.NewTicker(.1, function()
                DR.updateSpeed()
            end)
        end
        ]]
    end
end


DR:SetScript("OnEvent", DR.toggleEvent)