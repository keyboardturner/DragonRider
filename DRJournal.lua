local DragonRider, DR = ...
local _, L = ...

local function Print(...)
	local prefix = string.format("[PH] Dragon Rider" .. ":");
	DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", prefix, ...));
end

function DR.tooltip_OnEnter(frame, tooltip)
	GameTooltip:SetOwner(frame, "ANCHOR_NONE")
	GameTooltip:SetPoint(getAnchors(frame))
	--GameTooltip_SetDefaultAnchor(GameTooltip, frame);
	--GameTooltip_SetTitle(GameTooltip);
	GameTooltip_AddNormalLine(GameTooltip, tooltip);
	GameTooltip:Show();
end

function DR.tooltip_OnLeave()
	GameTooltip:Hide();
end

DR.mainFrame = CreateFrame("Frame", "DragonRiderMainFrame", UIParent, "PortraitFrameTemplateMinimizable")
tinsert(UISpecialFrames, DR.mainFrame:GetName())
DR.mainFrame:SetPortraitTextureRaw("Interface\\ICONS\\Ability_DragonRiding_Glyph01")
--DR.mainFrame.PortraitContainer.portrait:SetTexture("Interface\\AddOns\\Languages\\Languages_Icon_Small")
DR.mainFrame:SetTitle("[PH] Dragon Rider")
DR.mainFrame:SetSize(550,525)
DR.mainFrame:SetPoint("CENTER", UIParent, "CENTER")
DR.mainFrame:SetMovable(true)
DR.mainFrame:SetClampedToScreen(true)
DR.mainFrame:SetScript("OnMouseDown", function(self, button)
	self:StartMoving();
end);
DR.mainFrame:SetScript("OnMouseUp", function(self, button)
	DR.mainFrame:StopMovingOrSizing();
end);
DR.mainFrame:SetFrameStrata("HIGH")
DR.mainFrame:Hide()
DR.mainFrame:SetScript("OnHide", function()
	PlaySound(74423);
end);

function DR.mainFrame.width()
	return DR.mainFrame:GetWidth();
end

 
DR.mainFrame:SetResizable(true);
DR.mainFrame:SetResizeBounds(338,424,992,534)
DR.mainFrame.resizeButton = CreateFrame("Button", nil, DR.mainFrame)
DR.mainFrame.resizeButton:SetSize(18, 18)
DR.mainFrame.resizeButton:SetPoint("BOTTOMRIGHT")
DR.mainFrame.resizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
DR.mainFrame.resizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
DR.mainFrame.resizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
DR.mainFrame.resizeButton:SetParent(DR.mainFrame)
DR.mainFrame.resizeButton:SetFrameLevel(5)
 
DR.mainFrame.resizeButton:SetScript("OnMouseDown", function(self, button)
    DR.mainFrame:StartSizing("BOTTOMRIGHT")
    --DR.mainFrame:SetUserPlaced(true)
end)
 
DR.mainFrame.resizeButton:SetScript("OnMouseUp", function(self, button)
	local width, height = DR.mainFrame:GetSize()
	if DragonRider_DB.mainFrameSize == nil then
		DragonRider_DB.mainFrameSize = {}
	end
	DragonRider_DB.mainFrameSize.width = width
	DragonRider_DB.mainFrameSize.height = height
	DR.mainFrame:StopMovingOrSizing()
end)



DR.mainFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, DR.mainFrame, "ScrollFrameTemplate")
DR.mainFrame.ScrollFrame:SetPoint("TOPLEFT", DR.mainFrame, "TOPLEFT", 4, -8)
DR.mainFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", DR.mainFrame, "BOTTOMRIGHT", -3, 4)
DR.mainFrame.ScrollFrame.ScrollBar:ClearAllPoints()
DR.mainFrame.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", DR.mainFrame.ScrollFrame, "TOPRIGHT", -12, -18)
DR.mainFrame.ScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", DR.mainFrame.ScrollFrame, "BOTTOMRIGHT", -7, 16)


DR.mainFrame.ScrollFrame.child = CreateFrame("Frame", nil, DR.mainFrame.ScrollFrame)
DR.mainFrame.ScrollFrame:SetScrollChild(DR.mainFrame.ScrollFrame.child)
DR.mainFrame.ScrollFrame.child:SetWidth(DR.mainFrame:GetWidth()-18)
DR.mainFrame.ScrollFrame.child:SetHeight(1)

function DR.mainFrame.Tab_OnClick(self)

	PanelTemplates_SetTab(self:GetParent(), self:GetID())

	local scrollChild = DR.mainFrame.ScrollFrame:GetScrollChild()
	if (scrollChild) then
		scrollChild:Hide();
	end

	DR.mainFrame.ScrollFrame:SetScrollChild(self.content)
	self.content:Show()
	PlaySound(841)

end

function DR.mainFrame.SetTabs(frame,numTabs, ...)
	frame.numTabs = numTabs

	local contents = {};
	local frameName = frame:GetName()

	for i = 1, numTabs do

		DR.mainFrame.TabButtonTest = CreateFrame("Button", frameName .. "Tab" .. i, frame, "PanelTabButtonTemplate")
		DR.mainFrame.TabButtonTest:SetID(i)
		DR.mainFrame.TabButtonTest:SetText(select(i, ...))
		DR.mainFrame.TabButtonTest:SetScript("OnClick", DR.mainFrame.Tab_OnClick)

		DR.mainFrame.TabButtonTest.content = CreateFrame("Frame", nil, DR.mainFrame.ScrollFrame)
		DR.mainFrame.TabButtonTest.content:SetSize(334, 10)
		DR.mainFrame.TabButtonTest.content:Hide()

		table.insert(contents, DR.mainFrame.TabButtonTest.content)

		if (i == 1) then
			DR.mainFrame.TabButtonTest:SetPoint("TOPLEFT", DR.mainFrame, "BOTTOMLEFT", 11,2);
		else
			DR.mainFrame.TabButtonTest:SetPoint("TOPLEFT", _G[frameName .. "Tab" .. (i-1)] , "TOPRIGHT", 3, 0);
		end

		
	end


	DR.mainFrame.Tab_OnClick(_G[frameName .. "Tab1"])

	return unpack(contents);

end

local content1, content2, content3 = DR.mainFrame.SetTabs(DR.mainFrame, 3, "[PH] Score", "[PH] Guide", "[PH] Settings")

DragonRiderMainFrameTab2:SetEnabled(false)
DragonRiderMainFrameTab3:SetEnabled(false)

DragonRiderMainFrameTab2.Text:SetTextColor(.5,.5,.5)
DragonRiderMainFrameTab3.Text:SetTextColor(.5,.5,.5)

DragonRiderMainFrameTab2:SetScript("OnEnter", function(self)
	DR.tooltip_OnEnter(self, "[PH] Coming Soon")
end);
DragonRiderMainFrameTab2:SetScript("OnLeave", DR.tooltip_OnLeave);

DragonRiderMainFrameTab3:SetScript("OnEnter", function(self)
	DR.tooltip_OnEnter(self, "[PH] Coming Soon")
end);
DragonRiderMainFrameTab3:SetScript("OnLeave", DR.tooltip_OnLeave);

function DR.mainFrame.UpdatePopulation()
	for k, v in ipairs(DR.DragonRaceZones) do
		DR.mainFrame.PopulationData(k);
	end
end

DR.mainFrame.accountAll = CreateFrame("CheckButton", nil, content1, "UICheckButtonTemplate");
DR.mainFrame.accountAll:SetPoint("TOPRIGHT", content1, "TOPRIGHT", -15, -15);
DR.mainFrame.accountAll:SetScript("OnClick", function(self)
	if self:GetChecked() then
		Print("[PH] On");
		PlaySound(856);
		DragonRider_DB.useAccountData = true;
		DR.mainFrame.UpdatePopulation()
	else
		Print("[PH] Off");
		PlaySound(857);
		DragonRider_DB.useAccountData = false;
		DR.mainFrame.UpdatePopulation()
	end
end);
DR.mainFrame.accountAll.text = DR.mainFrame.accountAll:CreateFontString()
DR.mainFrame.accountAll.text:SetFont(STANDARD_TEXT_FONT, 11)
DR.mainFrame.accountAll.text:SetPoint("RIGHT", DR.mainFrame.accountAll, "LEFT", -5, 0)
DR.mainFrame.accountAll.text:SetText("[PH] Use Account Settings")
DR.mainFrame.accountAll:SetScript("OnEnter", function(self)
	DR.tooltip_OnEnter(self, "[PH] Tooltip Description")
end);
DR.mainFrame.accountAll:SetScript("OnLeave", DR.tooltip_OnLeave);

DR.mainFrame.backgroundTex = DR.mainFrame.ScrollFrame:CreateTexture()
DR.mainFrame.backgroundTex:SetAllPoints(DR.mainFrame.ScrollFrame)
DR.mainFrame.backgroundTex:SetAtlas("Dragonflight-Landingpage-Background")
--DR.mainFrame.backgroundTex:SetAtlas("dragonriding-talents-background")


DR.mainFrame.backdropInfo = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true,
	tileEdge = true,
	tileSize = 8,
	edgeSize = 8,
	insets = { left = 1, right = 1, top = 1, bottom = 1 },
};

DR.TooltipScan = CreateFrame("GameTooltip", "DragonRiderTooltipScanner", UIParent, "GameTooltipTemplate")

DR.QuestTitleFromID = setmetatable({}, { __index = function(t, id)
	DR.TooltipScan:SetOwner(UIParent, "ANCHOR_NONE")
	if id ~= nil then
		DR.TooltipScan:SetHyperlink("quest:"..id)
	end
	local title = DragonRiderTooltipScannerTextLeft1:GetText()
	DR.TooltipScan:Hide()
	if title and title ~= RETRIEVING_DATA then
		t[id] = title
		return title
	end
end })

DR.mainFrame.isPopulated = false;

function DR.mainFrame.PopulationData(continent)
	local placeValueX = 1
	local placeValueY = 1
	local realmKey = GetRealmName()
	local charKey = UnitName("player") .. " - " .. realmKey

	if DR.mainFrame.isPopulated == true then
		--The same as below, but stripped of creating frames. This should only be used to update existing data.
		for k, v in ipairs(DR.RaceData[continent]) do
			local questName = DR.QuestTitleFromID[DR.RaceData[continent][k]["questID"]]
			local silverTime = DR.RaceData[continent][k]["silverTime"]
			local goldTime = DR.RaceData[continent][k]["goldTime"]
			local medalBronze = "|A:challenges-medal-small-bronze:15:15|a"
			local medalSilver = "|A:challenges-medal-small-silver:15:15|a"
			local medalGold = "|A:challenges-medal-small-gold:15:15|a"
			local medalValue = ""
			if placeValueX == 1 and placeValueY == 1 then
				if DragonRider_DB.useAccountData == true then
					DR.mainFrame["Course"..continent.."_"..placeValueY]:SetText(questName);
				else
					DR.mainFrame["Course"..continent.."_"..placeValueY]:SetText(questName);
				end
			end
			if placeValueX > 6 then
				placeValueX = 1
				placeValueY = placeValueY+1
				if DragonRider_DB.useAccountData == true then
					DR.mainFrame["Course"..continent.."_"..placeValueY]:SetText(questName);
				else
					DR.mainFrame["Course"..continent.."_"..placeValueY]:SetText(questName);
				end
			end
			local scoreValue
			local scoreValueF
			if v.currencyID ~= nil then
				scoreValue = C_CurrencyInfo.GetCurrencyInfo(v.currencyID).quantity/1000
				if scoreValue == 0 then
					scoreValue = nil
				end
				if DragonRider_DB.raceData == nil then
					DragonRider_DB.raceData[charKey] = {};
				end
				if DragonRider_DB.raceData[charKey] == nil then
					DragonRider_DB.raceData[charKey] = {};
				end
				if DragonRider_DB.raceData["Account"] == nil then
					DragonRider_DB.raceData["Account"] = {};
				end
				if DragonRider_DB.raceData ~= nil and scoreValue ~= 0 and scoreValue ~= nil then
					DragonRider_DB.raceData[charKey][v.currencyID] = scoreValue;
					if DragonRider_DB.raceData["Account"][v.currencyID] == nil then
						DragonRider_DB.raceData["Account"][v.currencyID] = {
							score = scoreValue,
							character = charKey
						};
					end
					if DragonRider_DB.raceData["Account"][v.currencyID] ~= nil then
						if  scoreValue < DragonRider_DB.raceData["Account"][v.currencyID]["score"] then
							DragonRider_DB.raceData["Account"][v.currencyID]["score"] = scoreValue;
							DragonRider_DB.raceData["Account"][v.currencyID]["character"] = charKey;
						end
					end
				end
				if scoreValue and goldTime then
					if scoreValue < goldTime then
						medalValue = medalGold
					end
					if scoreValue < silverTime and scoreValue > goldTime then
						medalValue = medalSilver
					end
					if scoreValue > silverTime then
						medalValue = medalBronze
					end
				end

				if DragonRider_DB.useAccountData == true then
					if DragonRider_DB.raceData["Account"][v.currencyID] ~= nil then
						scoreValue = DragonRider_DB.raceData["Account"][v.currencyID]["score"]
					end
				end
				if scoreValue then
					scoreValueF = string.format("%.3f", scoreValue)
				else
					scoreValueF = "0.000"
				end

			end

			if scoreValueF == "0.000" then
				scoreValueF = "--"
			elseif medalValue ~= "" then
				scoreValueF = medalValue..scoreValueF
				if DragonRider_DB.useAccountData == true then
					if DragonRider_DB.raceData["Account"][v.currencyID]["character"] ~= charKey then
						scoreValueF = scoreValueF .. "*"
					end
				end
			end

			--Scores
			DR.mainFrame["backFrame"..continent][k]:SetText(scoreValueF);
			placeValueX = placeValueX+1
		end
		return
	end

	for k, v in ipairs(DR.RaceData[continent]) do
		--Establishing data / frames to be changed later. This should only be completed once upon login.
		local questName = DR.QuestTitleFromID[DR.RaceData[continent][k]["questID"]]
		local silverTime = DR.RaceData[continent][k]["silverTime"]
		local goldTime = DR.RaceData[continent][k]["goldTime"]
		local medalBronze = "|A:challenges-medal-small-bronze:15:15|a"
		local medalSilver = "|A:challenges-medal-small-silver:15:15|a"
		local medalGold = "|A:challenges-medal-small-gold:15:15|a"
		local medalValue = ""
		if placeValueX == 1 and placeValueY == 1 then
			DR.mainFrame["Course"..continent.."_"..placeValueY] = content1:CreateFontString();
			DR.mainFrame["Course"..continent.."_"..placeValueY]:SetPoint("TOPLEFT", DR.mainFrame["backFrame"..continent], "TOPLEFT", 10, -15*placeValueY-20);
			DR.mainFrame["Course"..continent.."_"..placeValueY]:SetFont(STANDARD_TEXT_FONT, 11);
			DR.mainFrame["Course"..continent.."_"..placeValueY]:SetText(questName);
			DR.mainFrame["Course"..continent.."_"..placeValueY]:SetParent(DR.mainFrame["backFrame"..continent]);
		end
		if placeValueX > 6 then
			placeValueX = 1
			placeValueY = placeValueY+1
			DR.mainFrame["backFrame"..continent]:SetHeight(DR.mainFrame["backFrame"..continent]:GetHeight()+15)

			DR.mainFrame["Course"..continent.."_"..placeValueY] = content1:CreateFontString();
			DR.mainFrame["Course"..continent.."_"..placeValueY]:SetPoint("TOPLEFT", DR.mainFrame["backFrame"..continent], "TOPLEFT", 10, -15*placeValueY-20);
			DR.mainFrame["Course"..continent.."_"..placeValueY]:SetFont(STANDARD_TEXT_FONT, 11);
			DR.mainFrame["Course"..continent.."_"..placeValueY]:SetText(questName);
			DR.mainFrame["Course"..continent.."_"..placeValueY]:SetParent(DR.mainFrame["backFrame"..continent]);
		end
		local scoreValue
		local scoreValueF
		if v.currencyID ~= nil then
			scoreValue = C_CurrencyInfo.GetCurrencyInfo(v.currencyID).quantity/1000
			if scoreValue == 0 then
				scoreValue = nil
			end
			if DragonRider_DB.raceData == nil then
				DragonRider_DB.raceData[charKey] = {};
			end
			if DragonRider_DB.raceData[charKey] == nil then
				DragonRider_DB.raceData[charKey] = {};
			end
			if DragonRider_DB.raceData["Account"] == nil then
				DragonRider_DB.raceData["Account"] = {};
			end
			if DragonRider_DB.raceData ~= nil and scoreValue ~= 0 and scoreValue ~= nil then
				DragonRider_DB.raceData[charKey][v.currencyID] = scoreValue;
				if DragonRider_DB.raceData["Account"][v.currencyID] == nil then
					DragonRider_DB.raceData["Account"][v.currencyID] = {
						score = scoreValue,
						character = charKey
					};
				end
				if DragonRider_DB.raceData["Account"][v.currencyID] ~= nil then
					if  scoreValue < DragonRider_DB.raceData["Account"][v.currencyID]["score"] then
						DragonRider_DB.raceData["Account"][v.currencyID]["score"] = scoreValue;
						DragonRider_DB.raceData["Account"][v.currencyID]["character"] = charKey;
					end
				end
			end
			if scoreValue and goldTime then
				if scoreValue < goldTime then
					medalValue = medalGold
				end
				if scoreValue < silverTime and scoreValue > goldTime then
					medalValue = medalSilver
				end
				if scoreValue > silverTime then
					medalValue = medalBronze
				end
			end

			if scoreValue then
				scoreValueF = string.format("%.3f", scoreValue)
			else
				scoreValueF = "0.000"
			end

		end

		if scoreValueF == "0.000" then
			scoreValueF = "--"
		elseif medalValue ~= "" then
			scoreValueF = medalValue..scoreValueF
		end

		--Scores
		DR.mainFrame["backFrame"..continent][k] = content1:CreateFontString();
		DR.mainFrame["backFrame"..continent][k]:SetFont(STANDARD_TEXT_FONT, 11);
		DR.mainFrame["backFrame"..continent][k]:SetPoint("TOPLEFT", DR.mainFrame.resizeFrames["middleFrame_"..placeValueX..continent], "TOPLEFT", 0, -15*placeValueY-20);
		DR.mainFrame["backFrame"..continent][k]:SetText(scoreValueF);
		DR.mainFrame["backFrame"..continent][k]:SetParent(DR.mainFrame["backFrame"..continent]);
		placeValueX = placeValueX+1
	end
end

DR.mainFrame.resizeFrames = {}

function DR.mainFrame.DoPopulationStuff()

	for k, v in ipairs(DR.DragonRaceZones) do
		local MapName = C_Map.GetMapInfo(v).name
		local oneLess = k-1

		if k == 1 then
			DR.mainFrame["backFrame"..k] = CreateFrame("Frame", nil, content1, "BackdropTemplate");
			DR.mainFrame["backFrame"..k]:SetPoint("TOPLEFT", content1, "TOPLEFT", 0, -65);
			DR.mainFrame["backFrame"..k]:SetPoint("TOPRIGHT", DR.mainFrame, "TOPRIGHT", -18, -65);
			DR.mainFrame["titleText"..k] = content1:CreateFontString();
			DR.mainFrame["titleText"..k]:SetPoint("TOPLEFT", DR.mainFrame["backFrame"..k], "TOPLEFT", 0, 15);
			DR.mainFrame["titleText"..k]:SetParent(DR.mainFrame["backFrame"..k])
		else
			DR.mainFrame["backFrame"..k] = CreateFrame("Frame", nil, DR.mainFrame["backFrame"..oneLess], "BackdropTemplate");
			DR.mainFrame["backFrame"..k]:SetPoint("TOPLEFT", DR.mainFrame["backFrame"..oneLess], "BOTTOMLEFT", 0, -35);
			DR.mainFrame["backFrame"..k]:SetPoint("TOPRIGHT", DR.mainFrame["backFrame"..oneLess], "BOTTOMRIGHT", 0, -35);
			DR.mainFrame["titleText"..k] = content1:CreateFontString();
			DR.mainFrame["titleText"..k]:SetPoint("TOPLEFT", DR.mainFrame["backFrame"..k], "TOPLEFT", 0, 15);
			DR.mainFrame["titleText"..k]:SetParent(DR.mainFrame["backFrame"..k])
		end

		DR.mainFrame["backFrame"..k]:SetHeight(65);
		DR.mainFrame["backFrame"..k]:SetBackdrop(DR.mainFrame.backdropInfo);
		DR.mainFrame["backFrame"..k]:SetBackdropColor(0,0,0,.5);

		DR.mainFrame["titleText"..k]:SetFont(STANDARD_TEXT_FONT, 11);
		DR.mainFrame["titleText"..k]:SetText(MapName);

		local leftFrame = CreateFrame("Frame", nil, DR.mainFrame["backFrame"..k] )
		leftFrame:SetPoint("TOPLEFT", DR.mainFrame["backFrame"..k], "TOPLEFT", 0, -1);
		leftFrame:SetPoint("TOPRIGHT", DR.mainFrame["backFrame"..k], "TOPRIGHT", 0, -1);
		leftFrame:SetHeight(15);
		leftFrame.tex = leftFrame:CreateTexture()
		leftFrame.tex:SetAllPoints(leftFrame)
		leftFrame.tex:SetColorTexture(1,1,1,.2)

		local middleFrame_1 = CreateFrame("Frame", nil, DR.mainFrame["backFrame"..k] )
		middleFrame_1:SetPoint("TOP", DR.mainFrame["backFrame"..k], "TOP", -85, 0);
		middleFrame_1:SetWidth(50)
		middleFrame_1:SetHeight(15)
		middleFrame_1.tex = middleFrame_1:CreateTexture()
		middleFrame_1.tex:SetAllPoints(middleFrame_1)
		middleFrame_1.tex:SetColorTexture(1,0,0,.2)

		local middleFrame_2 = CreateFrame("Frame", nil, DR.mainFrame["backFrame"..k] )
		middleFrame_2:SetPoint("TOP", DR.mainFrame["backFrame"..k], "TOP", 0, 0);
		middleFrame_2:SetWidth(50)
		middleFrame_2:SetHeight(15)
		middleFrame_2.tex = middleFrame_2:CreateTexture()
		middleFrame_2.tex:SetAllPoints(middleFrame_2)
		middleFrame_2.tex:SetColorTexture(1,0,1,.2)

		local middleFrame_3 = CreateFrame("Frame", nil, DR.mainFrame["backFrame"..k] )
		middleFrame_3:SetPoint("TOP", DR.mainFrame["backFrame"..k], "TOP", 0, 0);
		middleFrame_3:SetWidth(50)
		middleFrame_3:SetHeight(15)
		middleFrame_3.tex = middleFrame_3:CreateTexture()
		middleFrame_3.tex:SetAllPoints(middleFrame_3)
		middleFrame_3.tex:SetColorTexture(0,0,1,.2)

		local middleFrame_4 = CreateFrame("Frame", nil, DR.mainFrame["backFrame"..k] )
		middleFrame_4:SetPoint("TOP", DR.mainFrame["backFrame"..k], "TOP", 0, 0);
		middleFrame_4:SetWidth(50)
		middleFrame_4:SetHeight(15)
		middleFrame_4.tex = middleFrame_4:CreateTexture()
		middleFrame_4.tex:SetAllPoints(middleFrame_4)
		middleFrame_4.tex:SetColorTexture(0,1,1,.2)

		local middleFrame_5 = CreateFrame("Frame", nil, DR.mainFrame["backFrame"..k] )
		middleFrame_5:SetPoint("TOP", DR.mainFrame["backFrame"..k], "TOP", 0, 0);
		middleFrame_5:SetWidth(50)
		middleFrame_5:SetHeight(15)
		middleFrame_5.tex = middleFrame_5:CreateTexture()
		middleFrame_5.tex:SetAllPoints(middleFrame_5)
		middleFrame_5.tex:SetColorTexture(0,0,0,.2)

		local middleFrame_6 = CreateFrame("Frame", nil, DR.mainFrame["backFrame"..k] )
		middleFrame_6:SetPoint("TOPLEFT", DR.mainFrame["backFrame"..k], "TOP", 0, -1);
		middleFrame_6:SetPoint("TOPRIGHT", DR.mainFrame["backFrame"..k], "TOPRIGHT", 0, -1);
		middleFrame_6:SetHeight(15);
		middleFrame_6.tex = middleFrame_6:CreateTexture()
		middleFrame_6.tex:SetAllPoints(middleFrame_6)
		middleFrame_6.tex:SetColorTexture(1,1,0,.2)


		leftFrame:SetPoint("TOPRIGHT", middleFrame_1, "TOPLEFT", 0, 0);
		middleFrame_6:SetPoint("TOPLEFT", middleFrame_5, "TOPRIGHT", 0, 0);
		middleFrame_2:SetPoint("TOPLEFT", middleFrame_1, "TOPRIGHT", 0, 0);
		middleFrame_3:SetPoint("TOPLEFT", middleFrame_2, "TOPRIGHT", 0, 0);
		middleFrame_4:SetPoint("TOPLEFT", middleFrame_3, "TOPRIGHT", 0, 0);
		middleFrame_5:SetPoint("TOPLEFT", middleFrame_4, "TOPRIGHT", 0, 0);
		middleFrame_6:SetPoint("TOPLEFT", middleFrame_5, "TOPRIGHT", 0, 0);

		DR.mainFrame.resizeFrames["middleFrame_1"..k] = middleFrame_1
		DR.mainFrame.resizeFrames["middleFrame_2"..k] = middleFrame_2
		DR.mainFrame.resizeFrames["middleFrame_3"..k] = middleFrame_3
		DR.mainFrame.resizeFrames["middleFrame_4"..k] = middleFrame_4
		DR.mainFrame.resizeFrames["middleFrame_5"..k] = middleFrame_5
		DR.mainFrame.resizeFrames["middleFrame_6"..k] = middleFrame_6




		local normalText = content1:CreateFontString();
		normalText:SetFont(STANDARD_TEXT_FONT, 11);
		normalText:SetPoint("TOPLEFT", middleFrame_1, "TOPLEFT", 0, -1);
		normalText:SetText(L["Normal"]);
		normalText:SetParent(DR.mainFrame["backFrame"..k]);
		normalText:SetSize(65,30)
		normalText:SetJustifyH("LEFT")
		normalText:SetJustifyV("TOP")

		local advancedText = content1:CreateFontString();
		advancedText:SetFont(STANDARD_TEXT_FONT, 11);
		advancedText:SetPoint("TOPLEFT", middleFrame_2, "TOPLEFT", 0, -1);
		advancedText:SetText(L["Advanced"]);
		advancedText:SetParent(DR.mainFrame["backFrame"..k]);
		advancedText:SetSize(65,30)
		advancedText:SetJustifyH("LEFT")
		advancedText:SetJustifyV("TOP")

		local reverseText = content1:CreateFontString();
		reverseText:SetFont(STANDARD_TEXT_FONT, 11);
		reverseText:SetPoint("TOPLEFT", middleFrame_3, "TOPLEFT", 0, -1);
		reverseText:SetText(L["Reverse"]);
		reverseText:SetParent(DR.mainFrame["backFrame"..k]);
		reverseText:SetSize(65,30)
		reverseText:SetJustifyH("LEFT")
		reverseText:SetJustifyV("TOP")

		local challengeText = content1:CreateFontString();
		challengeText:SetFont(STANDARD_TEXT_FONT, 11);
		challengeText:SetPoint("TOPLEFT", middleFrame_4, "TOPLEFT", 0, -1);
		challengeText:SetText(L["Challenge"]);
		challengeText:SetParent(DR.mainFrame["backFrame"..k]);
		challengeText:SetSize(65,30)
		challengeText:SetJustifyH("LEFT")
		challengeText:SetJustifyV("TOP")

		local reverseChallText = content1:CreateFontString();
		reverseChallText:SetFont(STANDARD_TEXT_FONT, 11);
		reverseChallText:SetPoint("TOPLEFT", middleFrame_5, "TOPLEFT", 0, -1);
		reverseChallText:SetText(L["ReverseChallenge"]);
		reverseChallText:SetParent(DR.mainFrame["backFrame"..k]);
		reverseChallText:SetSize(65,30)
		reverseChallText:SetJustifyH("LEFT")
		reverseChallText:SetJustifyV("TOP")

		local stormText = content1:CreateFontString();
		stormText:SetFont(STANDARD_TEXT_FONT, 11);
		stormText:SetPoint("TOPLEFT", middleFrame_6, "TOPLEFT", 0, -1);
		stormText:SetText(L["Storm"]);
		stormText:SetParent(DR.mainFrame["backFrame"..k]);
		stormText:SetSize(65,30)
		stormText:SetJustifyH("LEFT")
		stormText:SetJustifyV("TOP")


		DR.mainFrame.PopulationData(k)

	end
	DR.mainFrame.isPopulated = true;

end


function DR.mainFrame.Script_OnSizeChanged()
	local width = DR.mainFrame:GetWidth()
	for k, v in pairs(DR.mainFrame.resizeFrames) do
		DR.mainFrame.resizeFrames[k]:SetWidth(width*.115)
	end
end

function DR.mainFrame.Script_OnShow()
	PlaySound(74421);
	DR.mainFrame.Script_OnSizeChanged()
	DR.mainFrame.UpdatePopulation()
	if DragonRider_DB.mainFrameSize ~= nil then
		DR.mainFrame:SetSize(DragonRider_DB.mainFrameSize.width, DragonRider_DB.mainFrameSize.height);
	end
end

DR.mainFrame:SetScript("OnSizeChanged", DR.mainFrame.Script_OnSizeChanged)
DR.mainFrame:SetScript("OnShow", DR.mainFrame.Script_OnShow)