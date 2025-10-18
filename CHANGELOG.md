# 0.6.4

11.2.7 has removed the vigor bar. Dragon Rider has now implemented its own custom Vigor bar, now with additional color settings, size, wrapping, row/column, spacing, and orientation options.

# 0.6.3

Changed tooltip format in journal to have a spaced left/right format

Added extra effects for timerunners in the journal.

Temporarily disabled the unused guide/settings tab in the journal for now.

RaceData restructuring - if an addon ever used the global variables to access this, it needs to be rewritten.

Slightly reworked journal formatting - Widgets at the top now stay in a top margin, separate from the scrollable race scores.

11.2.5 toc update

# 0.6.2

Fixes to the fix to timerunning thing

# 0.6.1

Eastern Kingdoms & Kalimdor Cup Silver times now in journal for those who haven't done the races.

Fixes to Timerunning features and fresh start character profile being established.

K'aresh's Ecological Succession race data now implemented, POI point directs player to Ecological Succession POI

# 0.6.0

Legion Remix feature (only available to timerunning characters) - icon in journal will now show tracked relevant legion remix stats

# 0.5.9

11.2.0 toc update, small adjustment to yes/no confirm dialog to be localized, added K'aresh race

# 0.5.8

11.1.7 toc update

# 0.5.7

11.1.5 toc update & addon category


# 0.5.6

Temporarily remove option to fade the speedometer as it causes conflicts with the drive system frame. The speedometer will now always fade when dismounted / landing after dragonriding as it was originally designed to.

# 0.5.5

Make frame hide when dismounting from drive vehicle if the option to fade frame isn't chosen

# 0.5.4

Added data for Undermine races to the journal.

# 0.5.3

Fixed issue where vigor swirly models would persist in Undermine for some reason

# 0.5.2

11.1.0 toc update

Added (work-in-progress) speedometer for DRIVE system (probably more to come soon-ish)

# 0.5.1

11.0.7 toc update

# 0.5.0

11.0.5 toc update

# 0.4.9

Avoid map-related taint issue with frame fader (where it said something about "protected function SetPassThroughButtons" etc.)

# 0.4.8

Clean up library files

# 0.4.7

Removed minimap button

# 0.4.6

Vigor model fix, Minimap button, Open talents button, (maybe) fix to map pin click in journal (this one is a bit of an anomaly, for some reason it just doesn't set until reload but it's hard to reproduce)

# 0.4.5

Fix to Storm's Watch Survey Reverse gold time, reworked how Charge/Model frames are attached to the vigor bar

 - if you have an addon that rescales the widget manager (encounter bar), particularly in different conditions during dragonriding and solely for the vigor bar, it probably will misalign either the charges/models. i'm not fixing this, an addon shouldn't be doing it like that. Tell Blizzard to add options to scale the encounter bar or overhaul widgets instead or something.

# 0.4.4

maybe potentially fixed widget being persistent especially after entering a BG who knows the NA realms went down before i could test it so good luck

# 0.4.3

(Maybe) fixed issue where the vigor bar would move kinda sometimes at "random" (reproducable with the emerald dream portal).

 - this was caused by a function that intended to fix some older blizz bugs where the vigor bar stayed persistent.
 - if the double vigor bar bug happens again, it's because i removed this function, but idk how to reproduce that bug.
 - the function would hide the secondary vigor bar and force the widgets to update, clearing out widgets to produce the proper one.

# 0.4.2

German translations thanks to Cirez (this was actually added in 0.4.1 but I forgot to add it until literally right after pushing the update)

Added global accessible `DRStatusBar` for the speedometer frame for other addons to access.

Hopefully maybe fixed taint issue that occurred when opening edit mode?

# 0.4.1

Added Global API (`DragonRider_API`), Fade Journal functionality, Added POI Supertrack to journal, Updated TWW Journal Data, Fix to Percentage speed unit text

Fixes by [Ghost](https://github.com/keyboardturner/DragonRider/pull/1) and implementation of LibAdvFlight

* Clean up color picking

* Whitespace

* More whitespace

* Set deez

* Add LibAdvFlight

nepotism wins again

* fix

* Fix tooltipping

* Move these back because calamity

* Fix lightning rush

# 0.4.0

Fixes to journal if all race data is nil, fixes for 11.0.2 (beta)

# 0.3.9

beta bild 55824 compatibility

# 0.3.8

Updated Simplified Chinese zhCN localizations (https://github.com/nanjuekaien1/DragonRider-zhCN/blob/main/zhCN.lua)

# 0.3.7

War Within TOC update, Added in new themes for the speedometer: Algari, Minimalist, Alliance, Horde.

<details>
<summary> ► Older Updates</summary>

# 0.3.6

Minor logic fix to function that "fixes" persistent blizz dragon riding frame

# 0.3.5

Added Nokhud Offensive to properly display 100 yd/s speed cap (was 80)

# 0.3.4

Attempts to once again fix persistent Blizzard dragon riding frame

Updates to zhCN locale

# 0.3.3

Fix to zone check function

# 0.3.2

Fixes for Options Menu API changes in The War Within Beta

# 0.3.1

Fixed swirly smoke effects on the vigor bubbles appearing after collecting bronze orbs in the timeless isle / isle of thunder which additionally restore vigor

# 0.3.0

Adjustments for checking dragonriding speed cap based upon map ID / dragon race buff rather than Riding Abroad, as that buff is now gone in The War Within.

# 0.2.9

fix Forbidden Reach Rush normal score placement in journal

# 0.2.8

nil check for journal, toc bump to 10.2.7

# 0.2.7

added Northrend silver/gold times, handle cleanup of SVs that are temp data when duplicate DRRaceData.lua already exists, updated zhCN locale entries for MuteVigorSound_Settings + TT

# 0.2.6

Added option to mute the vigor sound when gaining vigor naturally.

Future-proof the Lightning Rush / charges ability to no long require the Algarian Stormrider, instead only displaying charges when at least 1 buff stack is present.

(This version should technically be compatible with The War Within Alpha)

# 0.2.5

toc bump to 10.2.6

# 0.2.4

Added some extra translations for [zhCN](https://legacy.curseforge.com/wow/addons/dragon-rider#c48)

# 0.2.3

Dragonriding World Quest tracking can now be found in the journal. Various localizations for "Storm" were missing and now added. [Updates to zhCN](https://legacy.curseforge.com/wow/addons/dragon-rider#c43)

# 0.2.2

Quick fix to "attempt ot compare nil with number" error

# 0.2.1

Added a Dragonriding Journal feature, displaying all character scores in a journal accessible with the command /dragonrider, or by using the Addon Compartment Frame on the minimap.

Some fixes to the Static Charge orbs on the Algarian Stormrider

Slightly reworked some Tooltip code.


# 0.2.0

Added zhCN translations - [枫聖御雷](https://legacy.curseforge.com/wow/addons/dragon-rider#c33)

# 0.1.9

Code cleanup from fade vigor functions

# 0.1.8

Removed fading vigor functionality and option.

# 0.1.7

Added option for adjustment of camera field of view based on gliding speed

# 0.1.6

Experimental fix to the widget frames, hopefully this will make sure only dragonriding widgets will be hidden

# 0.1.5

Code cleanup, color picker updates

# 0.1.4

Quick fix to Vigor Fade

# 0.1.3

Added new frames for the Algarian Stormrider's Static Charges.

# 0.1.2

Added new options to fade the vigor bar and speedometer, an option to toggle the tooltip on the vigor bar that occurs during mouseover, and a fix to the double vigor bar Blizzard bug.

# 0.1.1

Font Fixes - hopefully should fix for russian and maybe other localizations

# 0.1.0

PTR 85% old world flight cap

# 0.0.9

Revert experimental bugfix option for hiding vigor bar as this was unintentionally hiding other bars that were attached to it.

# 0.0.8

Adjustments for 10.2.5 world dragonriding changes with 80% max speed change for [Riding Abroad](https://www.wowhead.com/ptr/spell=432503/riding-abroad)

Modelscene changes when mounted on the Algarian Stormrider, which now display as lightning effects over vigor gems rather than the default swirling wind effects.

Added an experimental bugfix option to hide vigor when dismounted.

# 0.0.7

Fix "assertion failed" issue in 10.2

# 0.0.6

Packager Testing

Added option to toggle the side art "wings" attached to the Vigor.

Minor localization fixes.

</details>

