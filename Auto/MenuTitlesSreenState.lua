--https://www.unknowncheats.me/forum/payday-2-a/125276-extra-perk-whateverthefucktheyrecalled.html

--[[ * Use all extra perk things whateverthefucktheyrecalled at once v2
	 *
	 * Changelog: 
	 *		v1: Initial release
	 *		v2: Blacklisted bad perks
	 *
	 *	Not for use in Pirate Perfagtion Trainer]]
if not tSuperScriptSet["ForcePerkSkills"] then return end
_atEnter = _atEnter or MenuTitlescreenState.at_enter
function MenuTitlescreenState:at_enter()
	_atEnter(self)
	for _,specialization in ipairs(tweak_data.skilltree.specializations) do
		for _,tree in ipairs(specialization) do
			if ( tree.upgrades ) then
				for _,upgrade in ipairs(tree.upgrades) do
					if ( (not upgrade:find("loss")) and (not upgrade:find("penalty")) ) then
						managers.upgrades:aquire(upgrade,false)
					end
				end
			end
		end
	end
end


-- https://www.unknowncheats.me/forum/1077613-post64.html
--[[
function SkillTreeManager:enable_all_perks()
    local specialization_tweak = tweak_data.skilltree.specializations
    local points, points_left, data
    local current_specialization = self:digest_value(self._global.specializations.current_specialization, false)
    for tree, data in ipairs(self._global.specializations) do
        if specialization_tweak[tree] then
            points = self:digest_value(data.points_spent, false)
            points_left = points
            for tier, spec_data in ipairs(specialization_tweak[tree]) do
                if points_left >= spec_data.cost then
                    points_left = points_left - spec_data.cost
                    for _, upgrade in ipairs(spec_data.upgrades) do
                        managers.upgrades:aquire(upgrade, true, UpgradesManager.AQUIRE_STRINGS[3] .. tostring(current_specialization))
                    end
                    if tier == #specialization_tweak[tree] then
                        data.tiers.current_tier = self:digest_value(tier, true)
                        data.tiers.max_tier = self:digest_value(#specialization_tweak[tree], true)
                        data.tiers.next_tier_data = false
                    end
                else
                    data.tiers.current_tier = self:digest_value(tier - 1, true)
                    data.tiers.max_tier = self:digest_value(#specialization_tweak[tree], true)
                    data.tiers.next_tier_data = {
                        current_points = self:digest_value(points_left, true),
                        points = self:digest_value(spec_data.cost, true)
                    }
                    points_left = 0
                    break
                end
            end
            data.points_spent = self:digest_value(points - points_left, true)
        end
    end
end
managers.skilltree:enable_all_perks()
]]