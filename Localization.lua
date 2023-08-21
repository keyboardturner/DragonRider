local DragonRider, L = ...; -- Let's use the private table passed to every .lua 

local function defaultFunc(L, key)
 -- If this function was called, we have no localization for this key.
 -- We could complain loudly to allow localizers to see the error of their ways, 
 -- but, for now, just return the key as its own localization. This allows you to—avoid writing the default localization out explicitly.
 return key;
end
setmetatable(L, {__index=defaultFunc});

local LOCALE = GetLocale()

if LOCALE == "enUS" then
	-- The EU English game client also
	-- uses the US English locale code.
	L["ToggleModelsName"] = "Show Vigor Models"
	L["ToggleModelsTT"] = "Display the swirling model effect on the vigor bubbles."
	L["SpeedPosPointName"] = "Speedometer Position"
	L["SpeedPosPointTT"] = "Adjusts where the speedometer is anchored to relative to the vigor bar."
	L["Top"] = "Top"
	L["Bottom"] = "Bottom"
	L["Left"] = "Left"
	L["Right"] = "Right"
	L["SpeedPosXName"] = "Speedometer Horizontal Position"
	L["SpeedPosXTT"] = "Adjust the horizontal position of the speedometer."
	L["SpeedPosYName"] = "Speedometer Vertical Position"
	L["SpeedPosYTT"] = "Adjust the vertical position of the speedometer."
	L["SpeedScaleName"] = "Speedometer Scale"
	L["SpeedScaleTT"] = "Adjust the scale of the speedometer."
	L["UnitYards"] = "yds/s"
	L["Yards"] = "Yards"
	L["UnitMiles"] = "mph"
	L["Miles"] = "Miles"
	L["UnitMeters"] = "m/s"
	L["Meters"] = "Metres"
	L["UnitKilometers"] = "km/h"
	L["Kilometers"] = "Kilometres"
	L["UnitPercent"] = "%"
	L["Percentage"] = "Percentage"


return end

if LOCALE == "esES" or LOCALE == "esMX" then -- official translation (thanks to twitter @RomanValoppi )
	-- Spanish translations go here

return end

if LOCALE == "deDE" then
	-- German translations go here

return end

if LOCALE == "frFR" then -- official translation (thanks to twitter @Solanya_ )
	-- French translations go here

return end

if LOCALE == "itIT" then
	-- French translations go here

return end

if LOCALE == "ptBR" then
	-- Brazilian Portuguese translations go here

	-- Note that the EU Portuguese WoW client also
	-- uses the Brazilian Portuguese locale code.
return end

if LOCALE == "ruRU" then
	-- Russian translations go here

return end

if LOCALE == "koKR" then
	-- Korean translations go here

return end

if LOCALE == "zhCN" then -- official translation (thanks to github @EKE00372)
	-- Simplified Chinese translations go here

return end

if LOCALE == "zhTW" then -- official translation (thanks to github @EKE00372)
	-- Traditional Chinese translations go here

return end
