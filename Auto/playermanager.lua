if not _G.tSuperScriptSet["Upgrade"] then return end

dofile("mods/tSuperScript/tCommon.lua")
--http://www.se7ensins.com/forums/threads/help-me-get-a-script-in-payday-2-plz.1046856/
--	https://steamcommunity.com/app/218620/discussions/15/364042262874462999/

--Hidden/Unused Skills
--	https://www.reddit.com/r/paydaytheheist/comments/2c4hty/hiddenunused_skills/
local AR_upgradePlayer = {
	-- 100% Dodge
	 ["passive_dodge_chance"] 				= 1
	,["run_dodge_chance"] 					= 1
	-- Unlimited [500 actually, but who cares] & instant intimidations
	,["convert_enemies"] 					= true
	,["convert_enemies_max_minions"] 		= 500
	,["convert_enemies_health_multiplier"] 	= 0.25
	,["convert_enemies_damage_multiplier"] 	= 4.5
	--XP?
	,["xp_multiplier"] 						= 10
	,["passive_xp_multiplier"] 				= 10
	,["secured_bags_money_multiplier"]		= 10
	-- Small loot value multiplier (extra jewelry cash value in jewelry store, deposit boxes in bank heist, etc)
	,["small_loot_multiplier"] 				= 10
	--???
	,["civ_harmless_melee"]					= false
	,["civ_harmless_bullets"]				= false
	,["intimidate_aura"]					= 1000
	--https://www.unknowncheats.me/forum/payday-2-a/172324-upgrade-modifications.html
	,["additional_lives"] 					= 5
	,["armor_multiplier"] 					= 2
	,["buy_bodybags_asset"] 				= true
	,["buy_spotter_asset"] 					= true
	,["camouflage_bonus"] 					= 0.2
	,["cheat_death_chance"] 				= 0.5
	,["civ_intimidation_mul"] 				= 15
	,["convert_enemies"] 					= true
	,["convert_enemies_interaction_speed_multiplier"] = 0.1
	,["corpse_dispose_amount"] 				= 50
	,["damage_dampener"] 					= 0.5
	,["detection_risk_add_crit_chance"] 	= { 0.03, 1, "below", 60, 0.3 }
	,["detection_risk_add_dodge_chance"] 	= { 0.01, 1, "below", 60, 0.1 }
	,["drill_autorepair"] 					= 1
	,["drill_fix_interaction_speed_multiplier"] = 0.5
	,["drill_speed_multiplier"] 			= 0.5
	,["electrocution_resistance_multiplier"]= 0.1
	,["empowered_intimidation_mul"] 		= 5
	,["extra_corpse_dispose_amount"] 		= 10
	,["flashbang_multiplier"] 				= 0.1
	,["interacting_damage_multiplier"] 		= 0.2
	,["intimidate_enemies"] 				= true
	,["intimidate_range_mul"] 				= 5
	,["long_dis_revive"] 					= 1
	,["loot_drop_multiplier"] 				= 5
	,["melee_damage_multiplier"] 			= 3
	,["melee_kill_snatch_pager_chance"] 	= 1.0
	,["melee_knockdown_mul"] 				= 3
	,["non_special_melee_multiplier"] 		= 2
	,["passive_concealment_modifier"] 		= 20
	,["passive_convert_enemies_damage_multiplier"] = 2
	,["passive_convert_enemies_health_multiplier"] = 0.1
	,["passive_dodge_chance"] 				= 1.0
	,["passive_intimidate_range_mul"] 		= 2
	,["passive_suppression_multiplier"] 	= 2
	,["pick_lock_easy_speed_multiplier"] 	= 0.6
	,["pick_up_ammo_multiplier"] 			= 3
	,["pick_up_ammo_multiplier_1"] 			= 2
	,["pick_up_ammo_multiplier_2"] 			= 2
	,["pistol_revive_from_bleed_out"] 		= 5
	,["run_dodge_chance"] 					= 1.0
	,["run_speed_multiplier"] 				= 1.3
	,["saw_speed_multiplier"] 				= 1.5
	,["silent_kill"] 						= 1
	,["small_loot_multiplier"] 				= 2
	,["stamina_multiplier"] 				= 3
	,["suppression_multiplier"] 			= 5
	,["suspicion_multiplier"] 				= 0.1
	,["tape_loop_duration"] 				= 30
	,["tape_loop_interact_distance_mul"] 	= 2
	,["xp_multiplier"] 						= 2
}

if not _Hasupgrade then _Hasupgrade = PlayerManager.has_category_upgrade end
function PlayerManager:has_category_upgrade( category, upgrade )
	--log(category..":"..upgrade)
	upgrade_valueDebugger(category,upgrade,"nil")
	if category == "player" and AR_upgradePlayer[upgrade] ~= nil then return true end
	--return true
	return _Hasupgrade(self, category, upgrade)
end

if not _upgrade then _upgrade = PlayerManager.upgrade_value end
function PlayerManager:upgrade_value( category, upgrade, default )
	--upgrade_valueDebugger(category,upgrade,default)
	if 		category == "player" and AR_upgradePlayer[upgrade] then return AR_upgradePlayer[upgrade]
	--elseif 	category == "weapon" and AR_upgradeWeapon[upgrade] then return AR_upgradeWeapon[upgrade]
	else 	return _upgrade(self, category, upgrade, default) end
end

local UpgradeTemper = {}
function upgrade_valueDebugger(category,upgrade,default)
	--Debugger
	if _G.tDebuger == 1 then
	local checked = 0
	for i,v in ipairs(UpgradeTemper) do
		if v == upgrade then 
			checked = 1
			break
		end
	end
	
	if checked == 0 then 
		table.insert( UpgradeTemper, upgrade )
		local Texts = tostring(category.." - "..upgrade.." - Def:"..tostring(default))
		showD(Texts)
	end
	end
end

if not _uvlSmallLoot then _uvlSmallLoot = PlayerManager.upgrade_value_by_level end 
function PlayerManager:upgrade_value_by_level( category, upgrade, level, default ) 
	if category == "player" and upgrade == "small_loot_multiplier" then return 10
	else return _uvlSmallLoot(self, category, upgrade, level, default) end 
end