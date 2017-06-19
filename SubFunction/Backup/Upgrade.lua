
if not PlayerManager return end
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
	,["intimidate_aura"]					= 1
}

if not _Hasupgrade then _Hasupgrade = PlayerManager.has_category_upgrade end
function PlayerManager:has_category_upgrade( category, upgrade )
	upgrade_valueDebugger(category,upgrade,"nil")
	if category == "player" and AR_upgradePlayer[upgrade] ~= nil then return true end
	return _Hasupgrade(self, category, upgrade)
	--return true
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