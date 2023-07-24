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
DR.tick1:SetSize(17,DR.statusbar:GetHeight()*1.5)
DR.tick1:SetPoint("TOP", DR.statusbar, "TOPLEFT", (65 / 100) * DR.statusbar:GetWidth(), 5)

DR.tick2 = DR.statusbar:CreateTexture(nil, "OVERLAY")
DR.tick2:SetAtlas("UI-Frame-Bar-BorderTick")
DR.tick2:SetSize(17,DR.statusbar:GetHeight()*1.5)
DR.tick2:SetPoint("TOP", DR.statusbar, "TOPLEFT", (60 / 100) * DR.statusbar:GetWidth(), 5)


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

DR.modelScene1 = CreateFrame("ModelScene", nil, DR.statusbar)
DR.modelScene1:SetPoint("CENTER", DR.statusbar, "CENTER", -105, -36)
DR.modelScene1:SetWidth(43)
DR.modelScene1:SetHeight(43)
DR.modelScene1:SetFrameStrata("HIGH")

DR.model1 = DR.modelScene1:CreateActor()
DR.model1:SetModelByFileID(1100194)
DR.model1:SetPosition(5,0,-1.5)
--DR.model1:SetPitch(.3)
DR.model1:SetYaw(0)
DR.modelScene1:Show()

DR.modelScene2 = CreateFrame("ModelScene", nil, DR.statusbar)
DR.modelScene2:SetPoint("CENTER", DR.statusbar, "CENTER", -65, -36)
DR.modelScene2:SetWidth(43)
DR.modelScene2:SetHeight(43)
DR.modelScene2:SetFrameStrata("HIGH")

DR.model2 = DR.modelScene2:CreateActor()
DR.model2:SetModelByFileID(1100194)
DR.model2:SetPosition(5,0,-1.5)
--DR.model2:SetPitch(.5)
DR.model2:SetYaw(1)
DR.modelScene2:Show()

DR.modelScene3 = CreateFrame("ModelScene", nil, DR.statusbar)
DR.modelScene3:SetPoint("CENTER", DR.statusbar, "CENTER", -25, -36)
DR.modelScene3:SetWidth(43)
DR.modelScene3:SetHeight(43)
DR.modelScene3:SetFrameStrata("HIGH")

DR.model3 = DR.modelScene3:CreateActor()
DR.model3:SetModelByFileID(1100194)
DR.model3:SetPosition(5,0,-1.5)
--DR.model3:SetPitch(.3)
DR.model3:SetYaw(2)
DR.modelScene3:Show()

DR.modelScene4 = CreateFrame("ModelScene", nil, DR.statusbar)
DR.modelScene4:SetPoint("CENTER", DR.statusbar, "CENTER", 25, -36)
DR.modelScene4:SetWidth(43)
DR.modelScene4:SetHeight(43)
DR.modelScene4:SetFrameStrata("HIGH")

DR.model4 = DR.modelScene4:CreateActor()
DR.model4:SetModelByFileID(1100194)
DR.model4:SetPosition(5,0,-1.5)
--DR.model4:SetPitch(.3)
DR.model4:SetYaw(3)
DR.modelScene4:Show()

DR.modelScene5 = CreateFrame("ModelScene", nil, DR.statusbar)
DR.modelScene5:SetPoint("CENTER", DR.statusbar, "CENTER", 65, -36)
DR.modelScene5:SetWidth(43)
DR.modelScene5:SetHeight(43)
DR.modelScene5:SetFrameStrata("HIGH")

DR.model5 = DR.modelScene5:CreateActor()
DR.model5:SetModelByFileID(1100194)
DR.model5:SetPosition(5,0,-1.5)
--DR.model5:SetPitch(.3)
DR.model5:SetYaw(4)
DR.modelScene5:Show()

DR.modelScene6 = CreateFrame("ModelScene", nil, DR.statusbar)
DR.modelScene6:SetPoint("CENTER", DR.statusbar, "CENTER", 105, -36)
DR.modelScene6:SetWidth(43)
DR.modelScene6:SetHeight(43)
DR.modelScene6:SetFrameStrata("HIGH")

DR.model6 = DR.modelScene6:CreateActor()
DR.model6:SetModelByFileID(1100194)
DR.model6:SetPosition(5,0,-1.5)
--DR.model6:SetPitch(.3)
DR.model6:SetYaw(5)
DR.modelScene6:Show()


C_Timer.NewTicker(.1, function()
    local isGliding, canGlide, forwardSpeed = C_PlayerInfo.GetGlidingInfo()
    local base = isGliding and forwardSpeed or GetUnitSpeed("player")
    local movespeed = Round(base / BASE_MOVEMENT_SPEED * 100)
    local roundedSpeed = Round(forwardSpeed, 3)
    if UIWidgetPowerBarContainerFrame:HasAnyWidgetsShowing() == true then
        DR:Show()
        if forwardSpeed == 0 then
            --DR.statusbar:Hide()
            --DR.glide:Hide()
        else
            --DR.statusbar:Show()
            --DR.glide:Show()
        end
    else
        --DR:Hide()
        --DR.statusbar:Hide()
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

--DR:Hide()
--DR.statusbar:Hide()

DR.MountEvents = {
    ["PLAYER_MOUNT_DISPLAY_CHANGED"] = true,
    ["MOUNT_JOURNAL_USABILITY_CHANGED"] = true,
    ["LEARNED_SPELL_IN_TAB"] = true,
    ["PLAYER_CAN_GLIDE_CHANGED"] = true,
    ["COMPANION_UPDATE"] = true,
    ["PLAYER_LOGIN"] = true,
};

DR.vigorEvent = CreateFrame("Frame")
DR.vigorEvent:RegisterEvent("UNIT_POWER_UPDATE")


function DR.vigorCounter()
    local vigorCurrent = UnitPower("player", Enum.PowerType.AlternateMount)
    local vigorMax = UnitPowerMax("player", Enum.PowerType.AlternateMount)
    if vigorCurrent == 0 then
        DR.modelScene1:Hide()
        DR.modelScene2:Hide()
        DR.modelScene3:Hide()
        DR.modelScene4:Hide()
        DR.modelScene5:Hide()
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
end

DR.vigorEvent:SetScript("OnEvent", DR.vigorCounter)

DR:RegisterEvent("ADDON_LOADED")
DR:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
DR:RegisterEvent("MOUNT_JOURNAL_USABILITY_CHANGED")
DR:RegisterEvent("LEARNED_SPELL_IN_TAB")
DR:RegisterEvent("PLAYER_CAN_GLIDE_CHANGED")
DR:RegisterEvent("COMPANION_UPDATE")
DR:RegisterEvent("PLAYER_LOGIN")
--DR:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")


function DR.setPositions()
    DR.statusbar:ClearAllPoints();
    DR.statusbar:SetPoint("BOTTOM", UIWidgetPowerBarContainerFrame, "TOP", 0, 5);
    DR.statusbar:Show();
end

function DR.clearPositions()
    DR.statusbar:ClearAllPoints();
    DR.statusbar:Hide();
end

DR.clearPositions()

function DR:toggleEvent(event, arg1)
    if DR.MountEvents[event] then
        if IsMounted() == true then
            for _, mountId in ipairs(C_MountJournal.GetCollectedDragonridingMounts()) do
                if select(4, C_MountJournal.GetMountInfoByID(mountId)) then
                    DR.setPositions();
                end
            end
        else
            DR.clearPositions();
        end
    end
end


DR:SetScript("OnEvent", DR.toggleEvent)