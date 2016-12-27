
if not tSuperScriptFuncAuto:Get("CustomSafehouse") then return end

function CustomSafehouseManager:can_afford_room_tier(room_id, tier) return true end
function CustomSafehouseManager:can_afford_tier(tier) 				return true end
function CustomSafehouseManager:get_next_upgrade_cost(room_id)		return 0	end
function CustomSafehouseManager:get_upgrade_cost(room_id, tier)		return 0	end
function CustomSafehouseManager:can_afford_any_upgrade()			return true end
function CustomSafehouseManager:is_trophy_unlocked(id)				return true end

--[[ * Give All Challenges v1 by gir489
	 *
	 * Changelog: 
	 *		v1: Initial release
	 *
	 *	Not for use in Pirate Perfagtion Trainer]]
local doYouLikeHurtingPeople = doYouLikeHurtingPeople or ChallengeManager.activate_challenge
function ChallengeManager:activate_challenge(id, key, category)
	if self:has_active_challenges(id, key) then
		local active_challenge = self:get_active_challenge(id, key)
		active_challenge.completed = true
		active_challenge.category = category
		return true
	end
	return doYouLikeHurtingPeople(self, id, key, category)
end

function CustomSafehouseManager:set_active_daily(id)
	if self:get_daily_challenge() and self:get_daily_challenge().id ~= id then
		self:generate_daily(id)
	end

	--Autocomplete Daily Safehouse Challenge
	self:complete_daily(id)

	--Bonus: Autocomplete Trophy
	for idx, trophy in pairs(self._global.trophies) do
		if not trophy.completed then
			for obj_idx, objective in pairs(trophy.objectives) do
				objective.progress = objective.max_progress
				objective.completed = true
			end
			self:complete_trophy(trophy.id)
		end
	end
end