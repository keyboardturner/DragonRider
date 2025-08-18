local _, DR = ...

local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:RegisterEvent("ADDON_LOADED")

local buffedTargets = {}

local function GetCreatureIDFromGUID(guid)
	if not guid then return nil end
	local npcID = select(6, strsplit("-", guid))
	return tonumber(npcID)
end

local NPCGroups = {
	[238717] = "Demonfly", [238852] = "Demonfly", [238900] = "Demonfly", [244779] = "Demonfly",
	[238786] = "Darkglare", [244781] = "Darkglare",
	[238865] = "FelSpreader",
	[244780] = "Felbat", [238712] = "Felbat",
	[239089] = "Felbomber",
	[238713] = "Skyterror",
	[244782] = "EyeOfGreed", [239186] = "EyeOfGreed",
}

local TrackingSpellID = 1250230;
local killBuffDetected = false;
if not DragonRider_DB.Timerunner then
	DragonRider_DB.Timerunner = {};
end
local KillCounter = DragonRider_DB.Timerunner;


f:SetScript("OnEvent", function()

	local _, subevent, _, 
		  sourceGUID, _, _, _, 
		  destGUID, _, _, _, 
		  spellId
		= CombatLogGetCurrentEventInfo()

	if (subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH" or subevent == "SPELL_AURA_APPLIED_DOSE") then
		if spellId == TrackingSpellID then
			if sourceGUID == UnitGUID("player") then
				if destGUID then
					buffedTargets[destGUID] = GetTime();
					killBuffDetected = true;
				end
			end
		end
	end

	if subevent == "UNIT_DIED" and destGUID then
		local npcID = GetCreatureIDFromGUID(destGUID)
		--print("NPC death:", npcID)
		local groupKey = NPCGroups[npcID]
		if groupKey and killBuffDetected then
			KillCounter[groupKey] = (KillCounter[groupKey] or 0) + 1
			print("Tracked Kill: "..groupKey.." | Total: "..KillCounter[groupKey]);
			
			buffedTargets[destGUID] = nil;
			C_Timer.After(1, function() killBuffDetected = false; end)
		end
	end
end)
