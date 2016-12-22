


--Free Favors
function PrePlanningManager:get_type_budget_cost(type, default)	return 0 end
--No limit for elements
function PrePlanningManager:can_reserve_mission_element(type, peer_id) return true, 4 end
--No limit for disabled
function PrePlanningManager:is_type_disabled(type) return false end
--??
function PrePlanningManager:_get_type_cost(type) return 0 end
--[[
function PrePlanningManager:can_vote_on_plan(type, peer_id) return true end

function PrePlanningManager:can_edit_preplan() return true end

function PrePlanningManager:can_reserve_mission_element(type, peer_id) return true,4 end
]]