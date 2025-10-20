local DragonRider, DR = ...
local _, L = ...


---@type LibAdvFlight
local LibAdvFlight = LibStub:GetLibrary("LibAdvFlight-1.1")

-- temp / default settings
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
};


local vigorBar = CreateFrame("Frame", "DragonRider_Vigor", UIParent)
vigorBar:SetPoint("CENTER", 0, -200)
vigorBar.bars = {}

DR.vigorBar = vigorBar


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
	bar.staticFill:SetVertexColor(VigorColors.full:GetRGB())

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
	bar.overlayFrame:SetPoint("TOPLEFT", bar, "TOPLEFT", -bar:GetWidth()*.4, bar:GetHeight()*.4)
	bar.overlayFrame:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", bar:GetWidth()*.4, -bar:GetHeight()*.4)
	-- ensure cover is above the clipping frame
	bar.overlayFrame:SetFrameLevel(bar.clippingFrame:GetFrameLevel() + 10)
	bar.cover = bar.overlayFrame:CreateTexture(nil, "OVERLAY", nil, 3)
	bar.cover:SetAtlas("dragonriding_vigor_frame", true)
	bar.cover:SetAllPoints()
	-- doesns't look great atm, probably change later
	bar.cover:SetDesaturated(true)
	bar.cover:SetVertexColor(VigorColors.cover:GetRGB())

	-- spark clipping frame (masking)
	-- this frame will contain the spark and be masked by the bubble shape.
	bar.sparkClippingFrame = CreateFrame("Frame", nil, bar)
	bar.sparkClippingFrame:SetPoint("TOPLEFT", bar, "TOPLEFT", -bar:GetWidth()*.4, bar:GetHeight()*.4)
	bar.sparkClippingFrame:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", bar:GetWidth()*.4, -bar:GetHeight()*.4)
	bar.sparkClippingFrame:SetFrameLevel(bar.clippingFrame:GetFrameLevel() + 5)
	bar.sparkMask = bar.sparkClippingFrame:CreateMaskTexture(nil, "ARTWORK")
	bar.sparkMask:SetAtlas("dragonriding_vigor_mask")
	bar.sparkMask:SetAllPoints(bar.sparkClippingFrame)
	bar.spark = bar.sparkClippingFrame:CreateTexture(nil, "OVERLAY", nil, 2)
	bar.spark:SetAtlas("dragonriding_vigor_spark")
	bar.spark:SetSize(SPARK_WIDTH, SPARK_HEIGHT)
	bar.spark:SetBlendMode("ADD")
	bar.spark:SetVertexColor(VigorColors.spark:GetRGB())
	bar.spark:AddMaskTexture(bar.sparkMask)

	-- flash texture
	bar.flash = bar.overlayFrame:CreateTexture(nil, "OVERLAY", nil, 4)
	bar.flash:SetAtlas("dragonriding_vigor_flash")
	bar.flash:SetAllPoints()
	bar.flash:SetVertexColor(VigorColors.flash:GetRGB())
	bar.flash:Hide()

	-- animation group for the "full" flash (one-shot fade out)
	bar.flashAnimFull = bar:CreateAnimationGroup()
	local flashFullAnim = bar.flashAnimFull:CreateAnimation("Alpha")
	flashFullAnim:SetChildKey("flash")
	flashFullAnim:SetFromAlpha(1.0)
	flashFullAnim:SetToAlpha(0)
	flashFullAnim:SetDuration(0.5)
	flashFullAnim:SetOrder(1)
	
	bar.flashAnimFull:SetScript("OnPlay", function() bar.flash:Show() end)
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

		if BAR_FILL_ORIENTATION == 1 then -- Vertical
			local fillHeight = BAR_HEIGHT * percent
			bar.clippingFrame:SetHeight(fillHeight)
			-- position the spark at the top edge of the fill
			bar.spark:ClearAllPoints()
			local yOffset = (FILL_DIRECTION == 1 and 1 or -1) * fillHeight
			local anchorPoint = (FILL_DIRECTION == 1 and "BOTTOM" or "TOP")
			bar.spark:SetPoint("CENTER", bar, anchorPoint, 0, yOffset)

		elseif BAR_FILL_ORIENTATION == 2 then -- Horizontal
			local fillWidth = BAR_WIDTH * percent
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
local function UpdateLayout()
	local wrap = math.min(VIGOR_WRAP, MAX_CHARGES)
	if wrap <= 0 then wrap = MAX_CHARGES end

	if ORIENTATION == 1 then -- vertical layout
		local numCols = math.ceil(MAX_CHARGES / wrap)
		local numRowsOnLongestCol = wrap

		local totalWidth = (numCols * BAR_WIDTH) + (math.max(0, numCols - 1) * BAR_SPACING)
		local totalHeight = (numRowsOnLongestCol * BAR_HEIGHT) + (math.max(0, numRowsOnLongestCol - 1) * BAR_SPACING)
		vigorBar:SetSize(totalWidth, totalHeight)

		for i, bar in ipairs(vigorBar.bars) do
			bar:ClearAllPoints()
			local col = math.floor((i - 1) / wrap)
			local row = (i - 1) % wrap

			-- calculate how many bars are in this column to center it vertically
			local numBarsInThisCol = (col < numCols - 1) and wrap or (MAX_CHARGES - (col * wrap))
			local colHeight = (numBarsInThisCol * BAR_HEIGHT) + (math.max(0, numBarsInThisCol - 1) * BAR_SPACING)
			local yOffset = (totalHeight - colHeight) / 2

			if DIRECTION == 1 then -- left-to-right columns, top-to-bottom bars
				local x = col * (BAR_WIDTH + BAR_SPACING)
				local y = -(yOffset + row * (BAR_HEIGHT + BAR_SPACING))
				bar:SetPoint("TOPLEFT", vigorBar, "TOPLEFT", x, y)
			else -- DIRECTION == 2 - right-to-left columns, bottom-to-top bars
				local x = -(col * (BAR_WIDTH + BAR_SPACING))
				local y = yOffset + row * (BAR_HEIGHT + BAR_SPACING)
				bar:SetPoint("BOTTOMRIGHT", vigorBar, "BOTTOMRIGHT", x, y)
			end
		end

	elseif ORIENTATION == 2 then -- horizontal layout
		local numRows = math.ceil(MAX_CHARGES / wrap)
		local numColsOnLongestRow = wrap

		local totalWidth = (numColsOnLongestRow * BAR_WIDTH) + (math.max(0, numColsOnLongestRow - 1) * BAR_SPACING)
		local totalHeight = (numRows * BAR_HEIGHT) + (math.max(0, numRows - 1) * BAR_SPACING)
		vigorBar:SetSize(totalWidth, totalHeight)

		for i, bar in ipairs(vigorBar.bars) do
			bar:ClearAllPoints()
			local row = math.floor((i - 1) / wrap)
			local col = (i - 1) % wrap

			-- calculate how many bars are in this row to center it horizontally
			local numBarsInThisRow = (row < numRows - 1) and wrap or (MAX_CHARGES - (row * wrap))
			local rowWidth = (numBarsInThisRow * BAR_WIDTH) + (math.max(0, numBarsInThisRow - 1) * BAR_SPACING)
			local xOffset = (totalWidth - rowWidth) / 2

			if DIRECTION == 1 then -- top-to-bottom rows, left-to-right bars
				local x = xOffset + col * (BAR_WIDTH + BAR_SPACING)
				local y = -(row * (BAR_HEIGHT + BAR_SPACING))
				bar:SetPoint("TOPLEFT", vigorBar, "TOPLEFT", x, y)
			else -- DIRECTION == 2 - bottom-to-top rows, rRight-to-left bars
				local x = -(xOffset + col * (BAR_WIDTH + BAR_SPACING))
				local y = row * (BAR_HEIGHT + BAR_SPACING)
				bar:SetPoint("BOTTOMRIGHT", vigorBar, "BOTTOMRIGHT", x, y)
			end
		end
	end
end

-- create all the bar objects first
for i = 1, MAX_CHARGES do
	vigorBar.bars[i] = CreateChargeBar(vigorBar, i)
end

UpdateLayout()


local function UpdateChargeBars()
	local info = C_Spell.GetSpellCharges(SPELL_ID)
	if issecretvalue(info) or not info then return end

	local current = info.currentCharges or 0
	local max = info.maxCharges or MAX_CHARGES
	local start = info.cooldownStartTime or 0
	local duration = info.cooldownDuration or 0

	for i = 1, MAX_CHARGES do
		local bar = vigorBar.bars[i]
		if not bar then break end

		if i <= current then -- fully charged
			bar.staticFill:Show()
			bar.staticFill:SetDesaturated(false)
			bar.staticFill:SetVertexColor(VigorColors.full:GetRGB())
			if bar.animGroup:IsPlaying() then bar.animGroup:Stop() end
			bar:SetProgress(1)

			-- stop progress flash if it was running
			if bar.flashAnimProgress:IsPlaying() then
				bar.flashAnimProgress:Stop()
			end

			-- check if it *just* became full
			if not bar.isFull and FLASH_FULL then
				bar.flashAnimFull:Play()
			end
			bar.isFull = true -- set current state

		elseif i == current + 1 and duration > 0 then -- recharging
			bar.isFull = false -- mark as not full
			bar.staticFill:Hide()
			if not bar.animGroup:IsPlaying() then bar.animGroup:Play() end

			local elapsed = GetTime() - start
			local progress = math.min(elapsed / duration, 1)
			bar.animFill:SetVertexColor(VigorColors.progress:GetRGB())
			bar:SetProgress(progress)

			-- play progress flash
			if FLASH_PROGRESS and not bar.flashAnimProgress:IsPlaying() then
				bar.flashAnimProgress:Play()
			end
			
			-- stop full flash if it was somehow running
			if bar.flashAnimFull:IsPlaying() then
				bar.flashAnimFull:Stop()
			end

		else -- empty
			bar.isFull = false -- mark as not full
			bar.staticFill:Show()
			bar.staticFill:SetDesaturated(true)
			bar.staticFill:SetVertexColor(VigorColors.empty:GetRGB())
			if bar.animGroup:IsPlaying() then bar.animGroup:Stop() end
			bar:SetProgress(0)

			-- stop any flashes
			if bar.flashAnimProgress:IsPlaying() then
				bar.flashAnimProgress:Stop()
			end
			if bar.flashAnimFull:IsPlaying() then
				bar.flashAnimFull:Stop()
			end
		end
	end
end

local updateTimer = 0 -- throttle
vigorBar:SetScript("OnUpdate", function(self, elapsed)
	updateTimer = updateTimer + elapsed
	if updateTimer > 0.05 then
		UpdateChargeBars()
		updateTimer = 0
	end
end)

vigorBar:Hide();