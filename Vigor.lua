local DragonRider, DR = ...
local _, L = ...


---@type LibAdvFlight
local LibAdvFlight = LibStub:GetLibrary("LibAdvFlight-1.1")

-- temp / default settings
local BAR_X = 0
local BAR_Y = -200
local BAR_WIDTH = 32
local BAR_HEIGHT = 32
local BAR_SPACING = 10
local MAX_CHARGES = 6
local SPELL_ID = 372610

-- 1 for vertical (stacks up), 2 for horizontal (stacks right)
local ORIENTATION = 2

-- 1 for top-to-bottom / left-to-right growth
-- 2 for bottom-to-top / right-to-left growth
local DIRECTION = 1

-- How many bubbles before wrapping to a new row/column
local VIGOR_WRAP = 6

-- 1 for vertical, 2 for horizontal
local BAR_FILL_ORIENTATION = 1

-- 1 for (bottom-to-top / left-to-right)
-- 2 for (top-to-Bottom / right-to-left)
local FILL_DIRECTION = 1

local SPARK_WIDTH = 32
local SPARK_HEIGHT = 12

local FLASH_FULL = true
local FLASH_PROGRESS = true

local VigorColors = {
	full = CreateColor(0.24, 0.84, 1.0, 1.0),
	empty = CreateColor(0.3, 0.3, 0.3, 1.0),
	progress = CreateColor(1.0, 1.0, 1.0, 1.0),
	spark = CreateColor(1.0, 1.0, 1.0, 0.9),
	cover = CreateColor(0.4, 0.4, 0.4, 1.0),
	flash = CreateColor(1.0, 1.0, 1.0, 0.9),
	decor = CreateColor(0.4, 0.4, 0.4, 1.0),
};

local DECOR_X = -15
local DECOR_Y = -10


local vigorBar = CreateFrame("Frame", "DragonRider_Vigor", UIParent)
vigorBar:SetPoint("CENTER", BAR_X, BAR_Y)
vigorBar.bars = {};
DR.vigorBar = vigorBar;
vigorBar:Hide();

local function CreateChargeBar(parent, index)
	local bar = CreateFrame("Frame", "DRVigorBubble_"..index, parent)
	bar:SetSize(BAR_WIDTH, BAR_HEIGHT)

	-- background frame
	bar.bg = bar:CreateTexture(nil, "BACKGROUND", nil, 0)
	bar.bg:SetAtlas("dragonriding_vigor_background")
	bar.bg:ClearAllPoints()
	bar.bg:SetAllPoints(bar)
	bar.bg:SetDrawLayer("BACKGROUND", 0)

	-- static fill texture
	bar.staticFill = bar:CreateTexture(nil, "ARTWORK", nil, 1)
	bar.staticFill:SetAtlas("dragonriding_vigor_fill")
	bar.staticFill:SetAllPoints(bar)
	bar.staticFill:SetDesaturated(true)
	bar.staticFill:SetVertexColor(VigorColors.full:GetRGBA())

	-- mask for linear fill
	bar.clippingFrame = CreateFrame("Frame", nil, bar)
	bar.clippingFrame:SetClipsChildren(true)
	bar.clippingFrame:Hide()

	-- animated fill texture, placed inside the clipping mask frame
	bar.animFill = bar.clippingFrame:CreateTexture(nil, "ARTWORK", nil, 1)
	bar.animFill:SetAtlas("dragonriding_vigor_fill_flipbook")
	bar.animFill:SetSize(BAR_WIDTH, BAR_HEIGHT)
	bar.animFillKey = "animFill" -- key for the animation group

	if BAR_FILL_ORIENTATION == 1 then -- vertical
		bar.clippingFrame:SetSize(BAR_WIDTH, 0)
		if FILL_DIRECTION == 1 then -- bottom-to-top
			bar.clippingFrame:SetPoint("BOTTOMLEFT", bar)
			bar.clippingFrame:SetPoint("BOTTOMRIGHT", bar)
			bar.animFill:SetPoint("BOTTOM", bar.clippingFrame, "BOTTOM")
		else -- top-to-bottom
			bar.clippingFrame:SetPoint("TOPLEFT", bar)
			bar.clippingFrame:SetPoint("TOPRIGHT", bar)
			bar.animFill:SetPoint("TOP", bar.clippingFrame, "TOP")
		end
	elseif BAR_FILL_ORIENTATION == 2 then -- Horizontal
		bar.clippingFrame:SetSize(0, BAR_HEIGHT)
		if FILL_DIRECTION == 1 then -- left-to-right
			bar.clippingFrame:SetPoint("TOPLEFT", bar)
			bar.clippingFrame:SetPoint("BOTTOMLEFT", bar)
			bar.animFill:SetPoint("LEFT", bar.clippingFrame, "LEFT")
		else -- right-to-left
			bar.clippingFrame:SetPoint("TOPRIGHT", bar)
			bar.clippingFrame:SetPoint("BOTTOMRIGHT", bar)
			bar.animFill:SetPoint("RIGHT", bar.clippingFrame, "RIGHT")
		end
	end

	local animGroup = bar:CreateAnimationGroup()
	animGroup:SetLooping("REPEAT")
	bar.animGroup = animGroup

	-- animation for the fill texture
	local flipAnim = animGroup:CreateAnimation("FlipBook")
	flipAnim:SetChildKey(bar.animFillKey)
	flipAnim:SetDuration(1.0)
	flipAnim:SetOrder(1)
	flipAnim:SetFlipBookRows(5)
	flipAnim:SetFlipBookColumns(4)
	flipAnim:SetFlipBookFrames(20)

	animGroup:SetScript("OnPlay", function()
		bar.clippingFrame:Show()
	end)
	animGroup:SetScript("OnStop", function()
		bar.clippingFrame:Hide()
	end)

	-- cover
	bar.overlayFrame = CreateFrame("Frame", nil, bar)
	--bar.overlayFrame:SetPoint("TOPLEFT", bar, "TOPLEFT", -bar:GetWidth()*.4, bar:GetHeight()*.4)
	--bar.overlayFrame:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", bar:GetWidth()*.4, -bar:GetHeight()*.4)
	-- ensure cover is above the clipping frame
	bar.overlayFrame:SetFrameLevel(bar.clippingFrame:GetFrameLevel() + 10)
	bar.cover = bar.overlayFrame:CreateTexture(nil, "OVERLAY", nil, 3)
	bar.cover:SetAtlas("dragonriding_vigor_frame")
	bar.cover:SetAllPoints()
	-- doesns't look great atm, probably change later
	bar.cover:SetDesaturated(true)
	bar.cover:SetVertexColor(VigorColors.cover:GetRGBA())

	-- spark clipping frame (masking)
	-- this frame will contain the spark and be masked by the bubble shape.
	bar.sparkClippingFrame = CreateFrame("Frame", nil, bar)
	--bar.sparkClippingFrame:SetPoint("TOPLEFT", bar, "TOPLEFT", -bar:GetWidth()*.4, bar:GetHeight()*.4)
	--bar.sparkClippingFrame:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", bar:GetWidth()*.4, -bar:GetHeight()*.4)
	bar.sparkClippingFrame:SetFrameLevel(bar.clippingFrame:GetFrameLevel() + 5)
	bar.sparkMask = bar.sparkClippingFrame:CreateMaskTexture(nil, "ARTWORK")
	bar.sparkMask:SetAtlas("dragonriding_vigor_mask")
	bar.sparkMask:SetAllPoints(bar.sparkClippingFrame)
	bar.spark = bar.sparkClippingFrame:CreateTexture(nil, "OVERLAY", nil, 2)
	bar.spark:SetAtlas("dragonriding_vigor_spark")
	bar.spark:SetSize(SPARK_WIDTH, SPARK_HEIGHT)
	bar.spark:SetBlendMode("ADD")
	bar.spark:SetVertexColor(VigorColors.spark:GetRGBA())
	bar.spark:AddMaskTexture(bar.sparkMask)

	-- flash texture
	bar.flash = bar.overlayFrame:CreateTexture(nil, "OVERLAY", nil, 4)
	bar.flash:SetAtlas("dragonriding_vigor_flash")
	bar.flash:SetAllPoints()
	bar.flash:SetVertexColor(VigorColors.flash:GetRGBA())
	bar.flash:Hide()

	-- animation group for the "full" flash (one-shot fade out)
	bar.flashAnimFull = bar:CreateAnimationGroup()
	local flashFullAnim = bar.flashAnimFull:CreateAnimation("Alpha")
	flashFullAnim:SetChildKey("flash")
	flashFullAnim:SetFromAlpha(1.0)
	flashFullAnim:SetToAlpha(0)
	flashFullAnim:SetDuration(0.5)
	flashFullAnim:SetOrder(1)
	
	bar.flashAnimFull:SetScript("OnPlay", function()
		bar.flash:Show();
		if not DragonRider_DB.muteVigorSound then
			PlaySound(201528, "SFX") -- "bling" sound upon full vigor bar
		end
	end)
	bar.flashAnimFull:SetScript("OnFinished", function() bar.flash:Hide() end)
	
	-- animation group for the "progress" flash (looping pulse)
	bar.flashAnimProgress = bar:CreateAnimationGroup()
	bar.flashAnimProgress:SetLooping("REPEAT")
	
	local flashProgAnimIn = bar.flashAnimProgress:CreateAnimation("Alpha")
	flashProgAnimIn:SetChildKey("flash")
	flashProgAnimIn:SetFromAlpha(0.2)
	flashProgAnimIn:SetToAlpha(0.8)
	flashProgAnimIn:SetDuration(0.7)
	flashProgAnimIn:SetOrder(1)
	
	local flashProgAnimOut = bar.flashAnimProgress:CreateAnimation("Alpha")
	flashProgAnimOut:SetChildKey("flash")
	flashProgAnimOut:SetFromAlpha(0.8)
	flashProgAnimOut:SetToAlpha(0.2)
	flashProgAnimOut:SetDuration(0.7)
	flashProgAnimOut:SetOrder(2)
	
	bar.flashAnimProgress:SetScript("OnPlay", function() bar.flash:Show() end)
	bar.flashAnimProgress:SetScript("OnStop", function() bar.flash:Hide() end)

	-- progress control
	function bar:SetProgress(percent)
		percent = math.max(0, math.min(percent, 1))
		bar.progress = percent

		local currentWidth, currentHeight = bar:GetSize()

		if BAR_FILL_ORIENTATION == 1 then -- Vertical
			local fillHeight = currentHeight * percent
			bar.clippingFrame:SetHeight(fillHeight)
			-- position the spark at the top edge of the fill
			bar.spark:ClearAllPoints()
			local yOffset = (FILL_DIRECTION == 1 and 1 or -1) * fillHeight
			local anchorPoint = (FILL_DIRECTION == 1 and "BOTTOM" or "TOP")
			bar.spark:SetPoint("CENTER", bar, anchorPoint, 0, yOffset)

		elseif BAR_FILL_ORIENTATION == 2 then -- Horizontal
			local fillWidth = currentWidth * percent
			bar.clippingFrame:SetWidth(fillWidth)
			-- position the spark at the leading edge of the fill
			bar.spark:ClearAllPoints()
			local xOffset = (FILL_DIRECTION == 1 and 1 or -1) * fillWidth
			local anchorPoint = (FILL_DIRECTION == 1 and "LEFT" or "RIGHT")
			bar.spark:SetPoint("CENTER", bar, anchorPoint, xOffset, 0)
			bar.spark:SetRotation(math.rad(90))
		end

		-- show spark only when filling, not when full or empty
		if percent > 0.01 and percent < 0.99 then
			bar.spark:Show()
		else
			bar.spark:Hide()
		end

		--bar:SetAlpha(0.6 + 0.4 * percent)
	end

	-- initialize
	bar:SetProgress(0)
	bar.isFull = false
	return bar
end

-- calculates the layout based on settings
function DR.UpdateVigorLayout()
	local vigorWrap
	local orientation
	local bar_width
	local bar_height
	local bar_spacing
	local direction
	if DragonRider_DB then
		vigorWrap = (DragonRider_DB.vigorWrap and DragonRider_DB.vigorWrap > 0 and DragonRider_DB.vigorWrap) or VIGOR_WRAP
		orientation = (DragonRider_DB.vigorBarOrientation) or ORIENTATION
		bar_width = (DragonRider_DB.vigorBarWidth) or BAR_WIDTH
		bar_height = (DragonRider_DB.vigorBarHeight) or BAR_HEIGHT
		bar_spacing = (DragonRider_DB.vigorBarSpacing) or BAR_SPACING
		direction = (DragonRider_DB.vigorBarDirection) or DIRECTION
	else
		vigorWrap = VIGOR_WRAP
		orientation = ORIENTATION
		bar_width = BAR_WIDTH
		bar_height = BAR_HEIGHT
		bar_spacing = BAR_SPACING
		direction = DIRECTION
	end

	local wrap = math.min(vigorWrap, MAX_CHARGES)
	if wrap <= 0 then wrap = MAX_CHARGES end

	if orientation == 1 then -- Vertical layout
		local numCols = math.ceil(MAX_CHARGES / wrap)
		local numRowsOnLongestCol = wrap

		local totalWidth = (numCols * bar_width) + (math.max(0, numCols - 1) * bar_spacing)
		local totalHeight = (numRowsOnLongestCol * bar_height) + (math.max(0, numRowsOnLongestCol - 1) * bar_spacing)
		vigorBar:SetSize(totalWidth, totalHeight)

		for i, bar in ipairs(vigorBar.bars) do
			bar:SetSize(bar_width, bar_height)
			bar.animFill:SetSize(bar_width, bar_height)
			if BAR_FILL_ORIENTATION == 1 then bar.clippingFrame:SetWidth(bar_width)
			elseif BAR_FILL_ORIENTATION == 2 then bar.clippingFrame:SetHeight(bar_height)
			end
			
			bar.overlayFrame:ClearAllPoints()
			bar.overlayFrame:SetPoint("TOPLEFT", bar, "TOPLEFT", -bar:GetWidth()*.4, bar:GetHeight()*.4)
			bar.overlayFrame:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", bar:GetWidth()*.4, -bar:GetHeight()*.4)

			bar.sparkClippingFrame:ClearAllPoints()
			bar.sparkClippingFrame:SetPoint("TOPLEFT", bar, "TOPLEFT", -bar:GetWidth()*.4, bar:GetHeight()*.4)
			bar.sparkClippingFrame:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", bar:GetWidth()*.4, -bar:GetHeight()*.4)

			bar:ClearAllPoints()
			local col = math.floor((i - 1) / wrap)
			local row = (i - 1) % wrap

			-- calculate how many bars are in this column to center it vertically
			local numBarsInThisCol = (col < numCols - 1) and wrap or (MAX_CHARGES - (col * wrap))
			local colHeight = (numBarsInThisCol * bar_height) + (math.max(0, numBarsInThisCol - 1) * bar_spacing)
			local yOffset = (totalHeight - colHeight) / 2

			if direction == 1 then -- left-to-right columns, top-to-bottom bars
				local x = col * (bar_width + bar_spacing)
				local y = -(yOffset + row * (bar_height + bar_spacing))
				bar:SetPoint("TOPLEFT", vigorBar, "TOPLEFT", x, y)
			else -- right-to-left columns, bottom-to-top bars
				local x = -(col * (bar_width + bar_spacing))
				local y = yOffset + row * (bar_height + bar_spacing)
				bar:SetPoint("BOTTOMRIGHT", vigorBar, "BOTTOMRIGHT", x, y)
			end

			if bar.progress then bar:SetProgress(bar.progress) end
		end

	elseif orientation == 2 then -- Horizontal layout
		local numRows = math.ceil(MAX_CHARGES / wrap)
		local numColsOnLongestRow = wrap

		local totalWidth = (numColsOnLongestRow * bar_width) + (math.max(0, numColsOnLongestRow - 1) * bar_spacing)
		local totalHeight = (numRows * bar_height) + (math.max(0, numRows - 1) * bar_spacing)
		vigorBar:SetSize(totalWidth, totalHeight)

		for i, bar in ipairs(vigorBar.bars) do
			bar:SetSize(bar_width, bar_height)
			bar.animFill:SetSize(bar_width, bar_height)
			if BAR_FILL_ORIENTATION == 1 then bar.clippingFrame:SetWidth(bar_width)
			elseif BAR_FILL_ORIENTATION == 2 then bar.clippingFrame:SetHeight(bar_height)
			end
			
			bar.overlayFrame:ClearAllPoints()
			bar.overlayFrame:SetPoint("TOPLEFT", bar, "TOPLEFT", -bar:GetWidth()*.4, bar:GetHeight()*.4)
			bar.overlayFrame:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", bar:GetWidth()*.4, -bar:GetHeight()*.4)

			bar.sparkClippingFrame:ClearAllPoints()
			bar.sparkClippingFrame:SetPoint("TOPLEFT", bar, "TOPLEFT", -bar:GetWidth()*.4, bar:GetHeight()*.4)
			bar.sparkClippingFrame:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", bar:GetWidth()*.4, -bar:GetHeight()*.4)

			bar:ClearAllPoints()
			local row = math.floor((i - 1) / wrap)
			local col = (i - 1) % wrap

			-- calculate how many bars are in this row to center it horizontally
			local numBarsInThisRow = (row < numRows - 1) and wrap or (MAX_CHARGES - (row * wrap))
			local rowWidth = (numBarsInThisRow * bar_width) + (math.max(0, numBarsInThisRow - 1) * bar_spacing)
			local xOffset = (totalWidth - rowWidth) / 2

			if direction == 1 then -- top-to-bottom rows, left-to-right bars
				local x = xOffset + col * (bar_width + bar_spacing)
				local y = -(row * (bar_height + bar_spacing))
				bar:SetPoint("TOPLEFT", vigorBar, "TOPLEFT", x, y)
			else -- bottom-to-top rows, right-to-left bars
				local x = -(xOffset + col * (bar_width + bar_spacing))
				local y = row * (bar_height + bar_spacing)
				bar:SetPoint("BOTTOMRIGHT", vigorBar, "BOTTOMRIGHT", x, y)
			end

			if bar.progress then bar:SetProgress(bar.progress) end
		end
	end
end

-- create all the bar objects first
for i = 1, MAX_CHARGES do
	vigorBar.bars[i] = CreateChargeBar(vigorBar, i)
end

DR.UpdateVigorLayout()


-- side wings art
vigorBar.decor = {};

local function CreateDecor(parent, index)
	local decor = CreateFrame("Frame", "DragonRider_Decor"..index, parent)
	decor:SetSize(64, 64) -- adjust size as desired
	decor.texture = decor:CreateTexture(nil, "ARTWORK", nil, 1)
	decor.texture:SetAtlas("dragonriding_vigor_decor")
	decor.texture:SetAllPoints(decor)
	decor.texture:SetDesaturated(true)
	decor.texture:SetVertexColor(VigorColors.decor:GetRGBA())

	if index == 1 then
		-- Left side (mirrored)
		decor:SetPoint("RIGHT", parent, "LEFT", -DECOR_X, DECOR_Y)
		decor.texture:SetTexCoord(1, 0, 0, 1) -- horizontal flip
	else
		-- Right side (normal)
		decor:SetPoint("LEFT", parent, "RIGHT", DECOR_X, DECOR_Y)
	end

	parent.decor[index] = decor
	return decor
end

for i = 1, 2 do
	vigorBar.decor[i] = CreateDecor(vigorBar, i);
end

local DecorOptions = {
	[1] = {
		Atlas = "dragonriding_vigor_decor"
	},
	[2] = {
		Atlas = "dragonriding_sgvigor_decor_bronze"
	},
	[3] = {
		Atlas = "dragonriding_sgvigor_decor_dark"
	},
	[4] = {
		Atlas = "dragonriding_sgvigor_decor_gold"
	},
	[5] = {
		Atlas = "dragonriding_sgvigor_decor_silver"
	},
};

function DR.ToggleDecor()
	local toggleModels = DragonRider_DB and DragonRider_DB.sideArt
	local PosX, PosY = (DragonRider_DB and DragonRider_DB.sideArtPosX) or DECOR_X, (DragonRider_DB and DragonRider_DB.sideArtPosY) or DECOR_Y
	local Size = (DragonRider_DB and DragonRider_DB.sideArtSize) or 1
	if toggleModels then
		for i = 1, 2 do
			vigorBar.decor[i]:Show()
		end
	else
		for i = 1, 2 do
			vigorBar.decor[i]:Hide()
		end
	end


	local themeIndex = DragonRider_DB.sideArtStyle or 1
	local options = DecorOptions[themeIndex] or DecorOptions[1]

	for i = 1, 2 do
		local decor = vigorBar.decor[i]
		if decor then
			if options.Atlas then
				decor.texture:SetAtlas(options.Atlas)
			elseif options.Texture then
				decor.texture:SetTexture(options.Texture)
			end
		end

		if i == 1 then
			-- Left side (mirrored)
			decor:SetPoint("RIGHT", vigorBar, "LEFT", -PosX, PosY)
		else
			-- Right side (normal)
			decor:SetPoint("LEFT", vigorBar, "RIGHT", PosX, PosY)
		end
		decor:SetScale(Size)
	end
end



local function UpdateChargeBars()
	
	local info = C_Spell.GetSpellCharges(SPELL_ID)
	if not info then return end

	local current = info.currentCharges or 0
	local max = info.maxCharges or MAX_CHARGES
	local start = info.cooldownStartTime or 0
	local duration = info.cooldownDuration or 0

	local rF, gF, bF, aF
	if DragonRider_DB and DragonRider_DB.vigorBarColor and DragonRider_DB.vigorBarColor.full then
		rF = DragonRider_DB.vigorBarColor.full.r
		gF = DragonRider_DB.vigorBarColor.full.g
		bF = DragonRider_DB.vigorBarColor.full.b
		aF = DragonRider_DB.vigorBarColor.full.a
	else
		rF, gF, bF, aF = VigorColors.full:GetRGBA()
	end

	local rP, gP, bP, aP
	if DragonRider_DB and DragonRider_DB.vigorBarColor and DragonRider_DB.vigorBarColor.progress then
		rP = DragonRider_DB.vigorBarColor.progress.r
		gP = DragonRider_DB.vigorBarColor.progress.g
		bP = DragonRider_DB.vigorBarColor.progress.b
		aP = DragonRider_DB.vigorBarColor.progress.a
	else
		rP, gP, bP, aP = VigorColors.progress:GetRGBA()
	end

	local rE, gE, bE, aE
	if DragonRider_DB and DragonRider_DB.vigorBarColor and DragonRider_DB.vigorBarColor.empty then
		rE = DragonRider_DB.vigorBarColor.empty.r
		gE = DragonRider_DB.vigorBarColor.empty.g
		bE = DragonRider_DB.vigorBarColor.empty.b
		aE = DragonRider_DB.vigorBarColor.empty.a
	else
		rE, gE, bE, aE = VigorColors.empty:GetRGBA()
	end

	local rS, gS, bS, aS
	if DragonRider_DB and DragonRider_DB.vigorBarColor and DragonRider_DB.vigorBarColor.spark then
		rS = DragonRider_DB.vigorBarColor.spark.r
		gS = DragonRider_DB.vigorBarColor.spark.g
		bS = DragonRider_DB.vigorBarColor.spark.b
		aS = DragonRider_DB.vigorBarColor.spark.a
	else
		rS, gS, bS, aS = VigorColors.cover:GetRGBA()
	end

	local rC, gC, bC, aC
	if DragonRider_DB and DragonRider_DB.vigorBarColor and DragonRider_DB.vigorBarColor.cover then
		rC = DragonRider_DB.vigorBarColor.cover.r
		gC = DragonRider_DB.vigorBarColor.cover.g
		bC = DragonRider_DB.vigorBarColor.cover.b
		aC = DragonRider_DB.vigorBarColor.cover.a
	else
		rC, gC, bC, aC = VigorColors.cover:GetRGBA()
	end

	local rFl, gFl, bFl, aFl
	if DragonRider_DB and DragonRider_DB.vigorBarColor and DragonRider_DB.vigorBarColor.flash then
		rFl = DragonRider_DB.vigorBarColor.flash.r
		gFl = DragonRider_DB.vigorBarColor.flash.g
		bFl = DragonRider_DB.vigorBarColor.flash.b
		aFl = DragonRider_DB.vigorBarColor.flash.a
	else
		rFl, gFl, bFl, aFl = VigorColors.cover:GetRGBA()
	end

	local rD, gD, bD, aD
	if DragonRider_DB and DragonRider_DB.vigorBarColor and DragonRider_DB.vigorBarColor.decor then
		rD = DragonRider_DB.vigorBarColor.decor.r
		gD = DragonRider_DB.vigorBarColor.decor.g
		bD = DragonRider_DB.vigorBarColor.decor.b
		aD = DragonRider_DB.vigorBarColor.decor.a
	else
		rD, gD, bD, aD = VigorColors.cover:GetRGBA()
	end


	for i = 1, 2 do
		vigorBar.decor[i].texture:SetVertexColor(rD, gD, bD, aD)
	end

	for i = 1, MAX_CHARGES do
		local bar = vigorBar.bars[i]
		if not bar then break end

		bar.spark:SetVertexColor(rS, gS, bS, aS)
		bar.cover:SetVertexColor(rC, gC, bC, aC)
		bar.flash:SetVertexColor(rFl, gFl, bFl, aFl)

		if i <= current then -- fully charged
			bar.staticFill:Show()
			bar.staticFill:SetDesaturated(false)
			bar.staticFill:SetVertexColor(rF, gF, bF, aF)
			if bar.animGroup:IsPlaying() then bar.animGroup:Stop() end
			bar:SetProgress(1)

			-- stop progress flash if it was running
			if bar.flashAnimProgress:IsPlaying() then
				bar.flashAnimProgress:Stop()
			end

			-- check if it *just* became full
			if not bar.isFull and DragonRider_DB.toggleFlashFull then
				bar.flashAnimFull:Play()
			end
			bar.isFull = true -- set current state

		elseif i == current + 1 and duration > 0 then -- recharging
			bar.isFull = false -- mark as not full
			bar.staticFill:Hide()
			if not bar.animGroup:IsPlaying() then bar.animGroup:Play() end

			local elapsed = GetTime() - start
			local progress = math.min(elapsed / duration, 1)
			bar.animFill:SetVertexColor(rP, gP, bP, aP)
			bar:SetProgress(progress)

			-- play progress flash
			if DragonRider_DB.toggleFlashProgress and not bar.flashAnimProgress:IsPlaying() then
				bar.flashAnimProgress:Play()
			end
			
			-- stop full flash if it was somehow running
			if bar.flashAnimFull:IsPlaying() then
				bar.flashAnimFull:Stop()
				bar.flash:Hide()
			end

		else -- empty
			bar.isFull = false -- mark as not full
			bar.staticFill:Show()
			bar.staticFill:SetDesaturated(true)
			bar.staticFill:SetVertexColor(rE, gE, bE, aE)
			if bar.animGroup:IsPlaying() then bar.animGroup:Stop() end
			bar:SetProgress(0)

			-- stop any flashes
			if bar.flashAnimProgress:IsPlaying() then
				bar.flashAnimProgress:Stop()
			end
			if bar.flashAnimFull:IsPlaying() then
				bar.flashAnimFull:Stop()
				bar.flash:Hide()
			end
		end
	end
end

local updateTimer = 0 -- throttle
vigorBar:SetScript("OnUpdate", function(self, elapsed)
	updateTimer = updateTimer + elapsed
	if updateTimer > 0.1 then
		UpdateChargeBars()
		updateTimer = 0
	end
end)



---------------------------------------------------------------------------------------------------------------
-- Models
---------------------------------------------------------------------------------------------------------------

DR.model = {};
DR.modelScene = {};

local ModelOptions = {
	[1] = { -- Wind
		modelFileID = 1100194,
		Pos = {
			X = 5, Y = 0, Z = -1.5,
		},
		Yaw = 0,
		Pitch = 0,
		Anim = 1,
	},
	[2] = { -- Lightning
		modelFileID = 3009394,
		Pos = {
			X = 5, Y = 0, Z = -.5,
		},
		Yaw = 0,
		Pitch = 0,
		Anim = 1,
	},
	[3] = { -- Fire Form
		modelFileID = 166112,
		Pos = {
			X = 2.2, Y = 0, Z = -.65,
		},
		Yaw = 0,
		Pitch = 0,
		Anim = 1,
	},
	[4] = { -- Arcane Form
		modelFileID = 165568,
		Pos = {
			X = 2.2, Y = 0, Z = -.65,
		},
		Yaw = 0,
		Pitch = 0,
		Anim = 1,
	},
	[5] = { -- Frost Form
		modelFileID = 166209,
		Pos = {
			X = 2.2, Y = 0, Z = -.65,
		},
		Yaw = 0,
		Pitch = 0,
		Anim = 1,
	},
	[6] = { -- Holy Form
		modelFileID = 166322,
		Pos = {
			X = 2.2, Y = 0, Z = -.65,
		},
		Yaw = 0,
		Pitch = 0,
		Anim = 1,
	},
	[7] = { -- Nature Form
		modelFileID = 166603,
		Pos = {
			X = 2.2, Y = 0, Z = -.65,
		},
		Yaw = 0,
		Pitch = 0,
		Anim = 1,
	},
	[8] = { -- Shadow Form
		modelFileID = 166792,
		Pos = {
			X = 2.2, Y = 0, Z = -.65,
		},
		Yaw = 0,
		Pitch = 0,
		Anim = 1,
	},


	--[[
	[number] = { -- Water (wasn't very visible, maybe revisit later)
		modelFileID = 791823,
		Pos = {
			X = 3, Y = 0, Z = -.3,
		},
		Yaw = 0,
		Pitch = 1,
		Anim = 1,
	},
	]]
};

function DR.modelSetup()
	local themeIndex = DragonRider_DB.modelTheme or 1
	local options = ModelOptions[themeIndex] or ModelOptions[1]

	for i = 1, MAX_CHARGES do
		local model = DR.model[i]
		if model then
			model:SetModelByFileID(options.modelFileID)
			model:SetPosition(options.Pos.X, options.Pos.Y, options.Pos.Z)
			if options.Pitch then
				model:SetPitch(options.Pitch)
			end
			model:SetYaw(options.Yaw or 0) -- rotation?
			if options.Anim then
				model:SetAnimation(options.Anim)
			end
		end
	end
end


for i = 1, MAX_CHARGES do
	DR.modelScene[i] = CreateFrame("ModelScene", nil, vigorBar.bars[i])
	DR.modelScene[i]:SetAllPoints()
	DR.modelScene[i]:SetFrameStrata("HIGH")
	DR.modelScene[i]:SetFrameLevel(vigorBar.bars[i]:GetFrameLevel() + 5)
	DR.modelScene[i]:SetSize(43,43)

	DR.model[i] = DR.modelScene[i]:CreateActor()
end

DR.modelSetup()


function DR.hideModels()
	for i = 1, MAX_CHARGES do
		DR.modelScene[i]:Hide()
	end
end

DR.hideModels()

function DR.vigorCounter()
	local vigorCurrent = LibAdvFlight:GetCurrentVigor()
	local toggleModels = DragonRider_DB and DragonRider_DB.toggleModels
	if not vigorCurrent then
		-- vigorCurrent will be nil during login I think
		return;
	end
	if toggleModels then
		for i = 1, MAX_CHARGES do
			if vigorCurrent >= i then
				DR.modelScene[i]:Show()
			else
				DR.modelScene[i]:Hide()
			end
		end
	else
		DR.hideModels();
	end
end
