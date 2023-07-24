local DR = CreateFrame("Frame", nil, UIWidgetPowerBarContainerFrame)

DR.statusbar = CreateFrame("StatusBar", nil, UIWidgetPowerBarContainerFrame)
DR.statusbar:SetPoint("BOTTOM", UIWidgetPowerBarContainerFrame, "TOP", 0, 0)
DR.statusbar:SetWidth(UIWidgetPowerBarContainerFrame:GetWidth()/1.25)
DR.statusbar:SetHeight(UIWidgetPowerBarContainerFrame:GetHeight()/2.75)
DR.statusbar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
DR.statusbar:GetStatusBarTexture():SetHorizTile(false)
DR.statusbar:GetStatusBarTexture():SetVertTile(false)
DR.statusbar:SetStatusBarColor(.98, .61, .0)
DR.statusbar:SetMinMaxValues(0, 100)

local targetProgress = 0
local progressSpeed = 0.1 -- Adjust the speed as needed

-- Function to smoothly update the progress of the status bar
local function UpdateStatusBar(self, elapsed)
    local currentProgress = DR.statusbar:GetValue()
    local diff = targetProgress - currentProgress

    if math.abs(diff) > 0.001 then
        DR.statusbar:SetValue(currentProgress + diff * progressSpeed)
    else
        DR.statusbar:SetValue(targetProgress)
        self:SetScript("OnUpdate", nil) -- Stop the update once we reach the target
    end
end

function SetSmoothProgress(value)
    if value < 0 then
        value = 0
    elseif value > 100 then
        value = 100
    end

    targetProgress = value
    DR.statusbar:SetScript("OnUpdate", UpdateStatusBar)
end

DR.tick1 = DR.statusbar:CreateTexture(nil, "OVERLAY")
DR.tick1:SetAtlas("UI-Frame-Bar-BorderTick")
DR.tick1:SetSize(17,UIWidgetPowerBarContainerFrame:GetHeight()/2.75)
DR.tick1:SetPoint("TOP", DR.statusbar, "TOPLEFT", (65 / 100) * DR.statusbar:GetWidth(), 0)

DR.tick2 = DR.statusbar:CreateTexture(nil, "OVERLAY")
DR.tick2:SetAtlas("UI-Frame-Bar-BorderTick")
DR.tick2:SetSize(17,UIWidgetPowerBarContainerFrame:GetHeight()/2.75)
DR.tick2:SetPoint("TOP", DR.statusbar, "TOPLEFT", (60 / 100) * DR.statusbar:GetWidth(), 0)



DR.backdropL = DR:CreateTexture(nil, "BACKGROUND")
DR.backdropL:SetAtlas("UI-Frame-Dragonflight-TitleLeft")
DR.backdropL:SetPoint("LEFT", DR.statusbar, "LEFT", -50, 0)
DR.backdropL:SetWidth(202/2)
DR.backdropL:SetHeight(85/2)

DR.backdropR = DR:CreateTexture(nil, "BACKGROUND")
DR.backdropR:SetAtlas("UI-Frame-Dragonflight-TitleRight")
DR.backdropR:SetPoint("RIGHT", DR.statusbar, "RIGHT", 50, 0)
DR.backdropR:SetWidth(202/2)
DR.backdropR:SetHeight(85/2)

DR.backdropM = DR:CreateTexture(nil, "BACKGROUND")
DR.backdropM:SetAtlas("_UI-Frame-Dragonflight-TitleMiddle")
DR.backdropM:SetPoint("CENTER", DR.statusbar, "CENTER", 0, 0)
DR.backdropM:SetWidth((UIWidgetPowerBarContainerFrame:GetWidth()/1.25)-102)
DR.backdropM:SetHeight(85/2)

DR.statusbar.bg = DR.statusbar:CreateTexture(nil, "BACKGROUND")
DR.statusbar.bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
DR.statusbar.bg:SetAllPoints(true)
DR.statusbar.bg:SetVertexColor(.0, .0, .0, .8)

DR.backdropL:Hide()
DR.backdropR:Hide()
DR.backdropM:Hide()

DR.glide = DR:CreateFontString(nil, nil, "GameTooltipText")
DR.glide:SetPoint("TOPLEFT", DR.statusbar, "TOPLEFT", 0, 0)


C_Timer.NewTicker(.1, function()
    local isGliding, canGlide, forwardSpeed = C_PlayerInfo.GetGlidingInfo()
    local base = isGliding and forwardSpeed or GetUnitSpeed("player")
    local movespeed = Round(base / BASE_MOVEMENT_SPEED * 100)
    local roundedSpeed = Round(forwardSpeed, 3)
    if UIWidgetPowerBarContainerFrame:HasAnyWidgetsShowing() == true then
        DR:Show()
        if forwardSpeed == 0 then
            DR.statusbar:Hide()
            DR.glide:Hide()
        else
            DR.statusbar:Show()
            DR.glide:Show()
        end
    else
        DR:Hide()
        DR.statusbar:Hide()
    end
    if forwardSpeed > 65 then
        DR.glide:SetText(format("|cffffffff" .. "%.1f" .. "yd/s|r", forwardSpeed)) -- ff71d5ff (nice purple?) -
        DR.statusbar:SetStatusBarColor(168/255, 77/255, 195/255)
    elseif forwardSpeed >= 60 and forwardSpeed <= 65 then
        DR.glide:SetText(format("|cffffffff" .. "%.1f" .. "yd/s|r", forwardSpeed)) -- ff71d5ff (nice blue?) - 
        DR.statusbar:SetStatusBarColor(0/255, 144/255, 155/255)
    else
        DR.glide:SetText(format("|cffffffff" .. "%.1f" .. "yd/s|r", forwardSpeed)) -- fff2a305 (nice yellow?) - 
        DR.statusbar:SetStatusBarColor(196/255, 97/255, 0/255)
    end
    SetSmoothProgress(forwardSpeed)
end)

DR:Hide()
DR.statusbar:Hide()