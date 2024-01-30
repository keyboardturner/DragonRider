local DragonRider, DR = ...

DR.mainFrame = CreateFrame("Frame", "DragonRiderMainFrame", UIParent, "PortraitFrameTemplateMinimizable")
tinsert(UISpecialFrames, DR.mainFrame:GetName())
DR.mainFrame:SetPortraitTextureRaw("Interface\\ICONS\\Ability_DragonRiding_Glyph01")
--DR.mainFrame.PortraitContainer.portrait:SetTexture("Interface\\AddOns\\Languages\\Languages_Icon_Small")
DR.mainFrame:SetTitle("[PH] Dragon Rider")
DR.mainFrame:SetSize(550,525)
DR.mainFrame.width = DR.mainFrame:GetWidth();
DR.mainFrame:SetPoint("CENTER", UIParent, "CENTER")
DR.mainFrame:SetMovable(true)
DR.mainFrame:SetClampedToScreen(true)
DR.mainFrame:SetScript("OnMouseDown", function(self, button)
	self:StartMoving();
end);
DR.mainFrame:SetScript("OnMouseUp", function(self, button)
	DR.mainFrame:StopMovingOrSizing();
end);
DR.mainFrame:Hide()
DR.mainFrame:SetScript("OnShow", function()
	PlaySound(74421);
end);
DR.mainFrame:SetScript("OnHide", function()
	PlaySound(74423);
end);

function DR.mainFrame:tooltip_OnEnter(frame, text)
	if GameTooltip:IsShown() == false then
		GameTooltip_SetDefaultAnchor(GameTooltip, frame);
	end
	GameTooltip:ClearAllPoints();
	GameTooltip:SetText(text, 1, 1, 1, 1, true);
	GameTooltip:SetPoint("BOTTOMLEFT", frame, "TOPRIGHT", 0, 0);
	GameTooltip:Show();
end
function DR.mainFrame.tooltip_OnLeave()
	GameTooltip:Hide();
end

DragonRiderGlobal = DR.mainFrame



DR.mainFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, DR.mainFrame, "ScrollFrameTemplate")
DR.mainFrame.ScrollFrame:SetPoint("TOPLEFT", DR.mainFrame, "TOPLEFT", 4, -8)
DR.mainFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", DR.mainFrame, "BOTTOMRIGHT", -3, 4)
DR.mainFrame.ScrollFrame.ScrollBar:ClearAllPoints()
DR.mainFrame.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", DR.mainFrame.ScrollFrame, "TOPRIGHT", -12, -18)
DR.mainFrame.ScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", DR.mainFrame.ScrollFrame, "BOTTOMRIGHT", -7, 0)


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

function DR.mainFrame.PopulationData(continent)
	local placeValueX = 1
	local placeValueY = 1
	for k, v in ipairs(DR.RaceData[continent]) do
		if placeValueX > 6 then
			placeValueX = 1
			placeValueY = placeValueY+1
			DR.mainFrame["backFrame"..continent]:SetHeight(DR.mainFrame["backFrame"..continent]:GetHeight()+15)
		end
		local scoreValue
		local scoreValueF
		if v.currencyID ~= nil then
			scoreValue = C_CurrencyInfo.GetCurrencyInfo(v.currencyID).quantity/1000
			scoreValueF = string.format("%.3f", scoreValue)
		end
		DR.mainFrame["backFrame"..continent][k] = content1:CreateFontString();
		DR.mainFrame["backFrame"..continent][k]:SetFont("Fonts\\FRIZQT__.TTF", 11);
		DR.mainFrame["backFrame"..continent][k]:SetPoint("TOPLEFT", DR.mainFrame["backFrame"..continent], "TOPLEFT", 65*placeValueX+90, -15*placeValueY-20);
		DR.mainFrame["backFrame"..continent][k]:SetText(scoreValueF);
		placeValueX = placeValueX+1
	end
end

function DR.mainFrame.DoPopulationStuff()

	for k, v in ipairs(DR.DragonRaceZones) do
		local MapName = C_Map.GetMapInfo(v).name
		local oneLess = k-1
		local questName = DR.QuestTitleFromID[DR.RaceData[k][1]["questID"]]

		if k == 1 then
			DR.mainFrame["backFrame"..k] = CreateFrame("Frame", nil, content1, "BackdropTemplate");
			DR.mainFrame["backFrame"..k]:SetPoint("TOPLEFT", content1, "TOPLEFT", 0, -65);
			DR.mainFrame["titleText"..k] = content1:CreateFontString();
			DR.mainFrame["titleText"..k]:SetPoint("TOPLEFT", DR.mainFrame["backFrame"..k], "TOPLEFT", 0, 15);
		else
			DR.mainFrame["backFrame"..k] = CreateFrame("Frame", nil, DR.mainFrame["backFrame"..oneLess], "BackdropTemplate");
			DR.mainFrame["backFrame"..k]:SetPoint("TOPLEFT", DR.mainFrame["backFrame"..oneLess], "BOTTOMLEFT", 0, -35);
			DR.mainFrame["titleText"..k] = content1:CreateFontString();
			DR.mainFrame["titleText"..k]:SetPoint("TOPLEFT", DR.mainFrame["backFrame"..k], "TOPLEFT", 0, 15);
		end

		DR.mainFrame["backFrame"..k]:SetSize(DR.mainFrame.width-25,65);
		DR.mainFrame["backFrame"..k]:SetBackdrop(DR.mainFrame.backdropInfo);
		DR.mainFrame["backFrame"..k]:SetBackdropColor(0,0,0,.5);

		DR.mainFrame["titleText"..k]:SetFont("Fonts\\FRIZQT__.TTF", 11);
		DR.mainFrame["titleText"..k]:SetText(MapName);

		DR.mainFrame["Course"..k] = content1:CreateFontString();
		DR.mainFrame["Course"..k]:SetPoint("TOPLEFT", DR.mainFrame["backFrame"..k], "TOPLEFT", 10, -15);
		DR.mainFrame["Course"..k]:SetFont("Fonts\\FRIZQT__.TTF", 11);
		DR.mainFrame["Course"..k]:SetText(questName);

		DR.mainFrame["Normal"..k] = content1:CreateFontString();
		DR.mainFrame["Normal"..k]:SetFont("Fonts\\FRIZQT__.TTF", 11);
		DR.mainFrame["Normal"..k]:SetPoint("TOPLEFT", DR.mainFrame["backFrame"..k], "TOPLEFT", 65*1+90, -15);
		DR.mainFrame["Normal"..k]:SetText("[PH] Normal");

		DR.mainFrame["Advanced"..k] = content1:CreateFontString();
		DR.mainFrame["Advanced"..k]:SetFont("Fonts\\FRIZQT__.TTF", 11);
		DR.mainFrame["Advanced"..k]:SetPoint("TOPLEFT", DR.mainFrame["backFrame"..k], "TOPLEFT", 65*2+90, -15);
		DR.mainFrame["Advanced"..k]:SetText("[PH] Advanced");

		DR.mainFrame["Reverse"..k] = content1:CreateFontString();
		DR.mainFrame["Reverse"..k]:SetFont("Fonts\\FRIZQT__.TTF", 11);
		DR.mainFrame["Reverse"..k]:SetPoint("TOPLEFT", DR.mainFrame["backFrame"..k], "TOPLEFT", 65*3+90, -15);
		DR.mainFrame["Reverse"..k]:SetText("[PH] Reverse");

		DR.mainFrame["Challenge"..k] = content1:CreateFontString();
		DR.mainFrame["Challenge"..k]:SetFont("Fonts\\FRIZQT__.TTF", 11);
		DR.mainFrame["Challenge"..k]:SetPoint("TOPLEFT", DR.mainFrame["backFrame"..k], "TOPLEFT", 65*4+90, -15);
		DR.mainFrame["Challenge"..k]:SetText("[PH] Challenge");

		DR.mainFrame["RevChall"..k] = content1:CreateFontString();
		DR.mainFrame["RevChall"..k]:SetFont("Fonts\\FRIZQT__.TTF", 11);
		DR.mainFrame["RevChall"..k]:SetPoint("TOPLEFT", DR.mainFrame["backFrame"..k], "TOPLEFT", 65*5+90, -15);
		DR.mainFrame["RevChall"..k]:SetText("[PH] Reverse Challenge");

		DR.mainFrame["Storm"..k] = content1:CreateFontString();
		DR.mainFrame["Storm"..k]:SetFont("Fonts\\FRIZQT__.TTF", 11);
		DR.mainFrame["Storm"..k]:SetPoint("TOPLEFT", DR.mainFrame["backFrame"..k], "TOPLEFT", 65*6+90, -15);
		DR.mainFrame["Storm"..k]:SetText("[PH] Storm");


		DR.mainFrame.popNameTitle = content1:CreateFontString();
		DR.mainFrame.popNameTitle:SetFont("Fonts\\FRIZQT__.TTF", 11);
		DR.mainFrame.popNameTitle:SetPoint("TOPLEFT", DR.mainFrame.backFrame, "TOPLEFT", 10, -15);
		DR.mainFrame.popNameTitle:SetText("[PH] Felwood Flyover");

		DR.mainFrame.popSecondsCountedTitle = content1:CreateFontString();
		DR.mainFrame.popSecondsCountedTitle:SetFont("Fonts\\FRIZQT__.TTF", 11);
		DR.mainFrame.popSecondsCountedTitle:SetPoint("TOPLEFT", DR.mainFrame.backFrame, "TOPLEFT", 115, -15);
		DR.mainFrame.popSecondsCountedTitle:SetText("[PH] -- 1");

		DR.mainFrame.popLastSeenTitle = content1:CreateFontString();
		DR.mainFrame.popLastSeenTitle:SetFont("Fonts\\FRIZQT__.TTF", 11);
		DR.mainFrame.popLastSeenTitle:SetPoint("TOPLEFT", DR.mainFrame.backFrame, "TOPLEFT", 115+95, -15);
		DR.mainFrame.popLastSeenTitle:SetText("[PH] -- 2");

		DR.mainFrame.popFirstSeenTitle = content1:CreateFontString();
		DR.mainFrame.popFirstSeenTitle:SetFont("Fonts\\FRIZQT__.TTF", 11);
		DR.mainFrame.popFirstSeenTitle:SetPoint("TOPLEFT", DR.mainFrame.backFrame, "TOPLEFT", 305+95, -15);
		DR.mainFrame.popFirstSeenTitle:SetText("[PH] -- 3");


		DR.mainFrame.PopulationData(k)

	end

end

