# DragonRider

This project aims to bring more information to help maximize skyriding charge usage and speed without being burdensome and still matching the general game style.

Currently this addon includes:

*   Speedometer Bar
     - Speed tracking for Skyriding and D.R.I.V.E.
     - Unit options like yds/s, mph, m/s, km/h, %, or none
     - Dynamic color based on speed thresholds
     - Thematic options
*   Skyriding Charge "Vigor" tracking
     - Visual charge display for the 6 skyriding charges, previously known as "Vigor" before 11.2.7
     - Customizable layout
     - Optional 3d model effects
     - Thematic options
*   Skyriding Race score journal accessible with /dragonrider (for other languages see below)
     - Skyriding Race World Quest tracker
     - Multiplayer Dragonriding Race tracker (Dragon Isles only)
     - Map pins for each race location

Some of the planned features:

*   Cooldown timers for each major spell (Whirling Surge / Lightning Rush, Flap, Bronze Timelock, Second Wind)

A link to my discord for addon projects and other things can be found [here](https://discord.gg/tA4rrmjPp8).

Other Language Slash Commands:

🇪🇸🇲🇽: /dragonrider

🇩🇪: /drachenreiter

🇫🇷: /dragonrider

🇮🇹: /dragonrider

🇵🇹🇧🇷: /dragonrider

🇷🇺: /всадникдракона

🇰🇷: /드래곤라이더

🇨🇳: /龙骑士

🇹🇼: /龍騎士


Additional API:

A global variable can be accessed via `DragonRider_API`.

<details>

<summary>Custom theme setup:</summary>

Other addons can additionally add in their own custom Vigor / Speedometer themes for their users to use with the `RegisterVigorTheme` API. A full example is listed below:

```lua
local function OnAddonLoaded()
	if DragonRider_API then
		--[[VIGOR THEME STRUCTURE
		Each vigor bar consists of multiple visual layers that can be customized
		with different textures, atlases, and effects. All fields are optional
		except where noted, and will fall back to default theme values
		--]]
		
		local myThemeData = {
			-- Full charge texture (displayed when vigor is at 100%)
			Full = {
				Atlas = "dragonriding_sgvigor_fillfull", -- Atlas name (mutually exclusive with Texture)
				-- Texture = "Interface\\Path\\To\\Texture", -- Direct texture path (use instead of Atlas)
				Desat = false, -- Whether to desaturate (grayscale) the texture
			},
			
			-- Empty fill texture (displayed when vigor is depleted but not recharging)
			Fill = {
				Atlas = "dragonriding_sgvigor_fillfull",
				Desat = true, -- Often desaturated to indicate "empty" state
			},
			
			-- Animated progress texture (displayed during vigor recharge)
			Progress = {
				Atlas = "dragonriding_sgvigor_fill_flipbook",
				Desat = false,
				-- Flipbook animation settings (optional - omit for static progress bar)
				Flipbook = {
					Duration = 1.0,		-- Total animation duration in seconds
					Rows = 5,			-- Number of rows in the flipbook texture
					Columns = 4,		-- Number of columns in the flipbook texture
					Frames = 20,		-- Total number of frames to animate through
				},
				-- For static progress (like minimalist theme), set Flipbook = nil
			},
			
			-- Background texture (the base layer behind all other elements)
			Background = {
				Atlas = "dragonriding_sgvigor_background",
				Desat = false,
			},
			
			-- Spark effect (animated glow at the leading edge during recharge)
			Spark = {
				Atlas = "dragonriding_sgvigor_spark",
				Desat = false,
			},
			
			-- Mask texture (used for clipping the spark effect to the bubble shape)
			Mask = {
				Atlas = "dragonriding_sgvigor_mask",
				-- Mask only supports Atlas, not Texture
			},
			
			-- Cover/frame texture (decorative border overlaid on top)
			Cover = {
				Atlas = "dragonriding_sgvigor_frame_bronze",
				Desat = false,
				-- Set Atlas = nil and Texture = nil for no cover (minimalist style)
			},
			
			-- Flash texture (used for "full charge" and "recharging" flash effects)
			Flash = {
				Atlas = "dragonriding_sgvigor_flash",
				Desat = false,
			},
			
			-- Overlay positioning (adjusts the cover and spark clipping frames)
			-- Values are multipliers of the bar width/height
			Overlay = {
				X = .2,		-- Horizontal padding (0 = no padding, 1 = full bar width)
				Y = .2,		-- Vertical padding (0 = no padding, 1 = full bar height)
			},
		};

		--[[SPEEDOMETER THEME STRUCTURE
		The speedometer consists of a progress bar with decorative borders,
		tick marks for speed thresholds, and optional topper/footer elements
		--]]
		
		local mySpeedometerData = {
			Cover = {
				-- Tick Marks (indicate speed thresholds for vigor regeneration)
				TickAtlas = "UI-Frame-Bar-BorderTick",			-- Atlas for tick texture (or use TickTexture)
				-- TickTexture = "Interface\\Path\\To\\Tick",	-- Direct texture path (use instead of TickAtlas)
				Width = 17,										-- Width of each tick mark
				TickHeightMult = 1.0,							-- Multiplier for tick height (relative to bar height)
				TickYOffset = 0,								-- Vertical offset for tick positioning
				TickTexCoords = {0,1,.19,.78},					-- Texture coordinates for precise alignment
				TickDesat = false,								-- Whether to desaturate tick marks
				
				-- Border Textures (decorative frame around the speedometer bar)
				-- You can use either Atlas or Texture for each element, not both
				LeftAtlas = "widgetstatusbar-borderleft",		-- Left border piece
				-- LeftTexture = "Interface\\Path\\To\\Left",	-- Alternative: direct texture path
				RightAtlas = "widgetstatusbar-borderright",		-- Right border piece
				MiddleAtlas = "widgetstatusbar-bordercenter",	-- Middle border piece (tiles)
				
				-- Border sizing and positioning
				CoverLWidth = 35,				-- Width of left border piece
				CoverRWidth = 35,				-- Width of right border piece
				CoverLX = -7,					-- X offset for left border
				CoverLYMult = 0.3,				-- Y offset multiplier for left border (relative to bar height)
				CoverRX = 7,					-- X offset for right border
				CoverRYMult = 0.3,				-- Y offset multiplier for right border
				CoverLTexCoords = {0,1,0,1},	-- Texture coordinates for left border
				CoverRTexCoords = {0,1,0,1},	-- Texture coordinates for right border
				CoverMTexCoords = {0,1,0,1},	-- Texture coordinates for middle border
				CoverDesat = false,				-- Whether to desaturate border elements
				
				-- Background Textures (layer behind the progress bar)
				BackgroundLeftAtlas = "widgetstatusbar-bgleft",			-- Left background piece
				-- BackgroundLeftTexture = "Interface\\Path\\To\\BG",	-- Alternative: direct path
				BackgroundRightAtlas = "widgetstatusbar-bgright",		-- Right background piece
				BackgroundMiddleAtlas = "widgetstatusbar-bgcenter",		-- Middle background (tiles)
				
				-- Background sizing and positioning
				BackgroundLWidth = 35,				-- Width of left background piece
				BackgroundRWidth = 35,				-- Width of right background piece
				BackgroundLX = -2,					-- X offset for left background
				BackgroundLYMult = 0,				-- Y offset multiplier for left background
				BackgroundRX = 2,					-- X offset for right background
				BackgroundRYMult = 0,				-- Y offset multiplier for right background
				BackgroundLTexCoords = {0,1,0,1},	-- Texture coordinates for left background
				BackgroundRTexCoords = {0,1,0,1},	-- Texture coordinates for right background
				BackgroundMTexCoords = {0,1,0,1},	-- Texture coordinates for middle background
				BackgroundDesat = false,     -- Whether to desaturate background elements
				
				-- Decorative Textures (optional topper and footer)
				TopperAtlas = "dragonflight-score-topper",			-- Decoration above the bar
				-- TopperTexture = "Interface\\Path\\To\\Topper",	-- Alternative: direct path
				FooterAtlas = "dragonflight-score-footer",			-- Decoration below the bar
				-- FooterTexture = "Interface\\Path\\To\\Footer",	-- Alternative: direct path
				TopperXY = {0, 38},			-- Position offset {X, Y} for topper
				FooterXY = {0, -32},		-- Position offset {X, Y} for footer
				TopperSize = {350, 65},		-- Size {width, height} for topper
				FooterSize = {350, 65},		-- Size {width, height} for footer
				TopperDesat = false,		-- Whether to desaturate topper
				FooterDesat = false,		-- Whether to desaturate footer
				-- Set TopperAtlas = nil to hide topper, FooterAtlas = nil to hide footer
			},
			
			-- Progress Bar Texture (the moving fill that indicates current speed)
			Bar = {
				BarTexture = "Interface\\TARGETINGFRAME\\UI-StatusBar",
				-- This texture fills the bar based on current speed percentage
			},
		};

		--[[REGISTER YOUR THEME
		Register with unique keys that won't conflict with other addons
		The display name is what users will see in the dropdown menu
		--]]
		
		DragonRider_API.RegisterVigorTheme(
			"MyUniqueAddonKey",		-- Unique identifier (use your addon name)
			"My Cool Theme",		-- Display name shown to users - can be localized
			myThemeData			-- Theme data table
		)
		
		DragonRider_API.RegisterSpeedometerTheme(
			"MyUniqueSpeedometerKey",	-- Unique identifier
			"My Speedometer Theme",		-- Display name shown to users - can be localized
			mySpeedometerData			-- Theme data table
		)
		
		--[[NOTES
		All texture paths must be relative to WoW's root directory
		Atlas names refer to Blizzard's built-in texture atlas system
		Use either Atlas OR Texture for each element, not both
		Desaturation converts textures to grayscale while preserving alpha
		Color tinting is handled by DragonRider's color picker settings
		TexCoords format: {left, right, top, bottom} in 0-1 range
		Multipliers (like TickHeightMult) scale relative to bar dimensions
		Setting any Atlas/Texture to nil will hide that element
		For minimalist themes, use "Interface\\buttons\\white8x8" as a solid color base
		--]]
	end
end

EventUtil.ContinueOnAddOnLoaded("DragonRider", OnAddonLoaded);
```

</details>
