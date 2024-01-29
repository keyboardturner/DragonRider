local DragonRider, DR = ...

DR.mainFrame = CreateFrame("Frame", "DragonRiderMainFrame", UIParent, "PortraitFrameTemplateMinimizable")
DR.mainFrame:SetPortraitTextureRaw("Interface\\ICONS\\Ability_DragonRiding_Glyph01")
--DR.mainFrame.PortraitContainer.portrait:SetTexture("Interface\\AddOns\\Languages\\Languages_Icon_Small")
DR.mainFrame:SetTitle("[PH] Dragon Rider")
DR.mainFrame:SetSize(338,424)
DR.mainFrame:SetPoint("CENTER", UIParent, "CENTER")
DR.mainFrame:SetMovable(true)
DR.mainFrame:SetClampedToScreen(true)
DR.mainFrame:SetScript("OnMouseDown", function(self, button)
	self:StartMoving()
end);
DR.mainFrame:SetScript("OnMouseUp", function(self, button)
	DR.mainFrame:StopMovingOrSizing()
end);
--DR.mainFrame:Hide()
DR.mainFrame:SetScript("OnShow", function()
	PlaySound(74421)
end);
DR.mainFrame:SetScript("OnHide", function()
	PlaySound(74423)
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
DR.mainFrame.backgroundTex:SetAtlas("dragonriding-talents-background")