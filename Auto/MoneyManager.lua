
-- deduct Forbidden
function MoneyManager:deduct_from_offshore(amount) 	end
function MoneyManager:_deduct_from_offshore(amount) end
function MoneyManager:deduct_from_spending(amount)	end
function MoneyManager:_deduct_from_total(amount)	end
function MoneyManager:deduct_from_total(amount)		end

-- Free job purchase
if tSuperScriptFuncAuto:Get("ProJob") then
	function MoneyManager:get_cost_of_premium_contract(job_id, difficulty_id) return 0 end
end

-- Free Preplanning
if tSuperScriptFuncAuto:Get("Preplanning") then
	function MoneyManager:on_buy_preplanning_types() 		end
	function MoneyManager:on_buy_preplanning_votes() 		end
	function MoneyManager:get_preplanning_type_cost(type) 	return 0 end
	function MoneyManager:get_preplanning_votes_cost() 		return 0 end
	function MoneyManager:get_preplanning_types_cost()		return 0 end
	function MoneyManager:can_afford_preplanning_type(type) return true end
end

-- Mission Asset
if tSuperScriptFuncAuto:Get("MissionAssets") then
	function MoneyManager:can_afford_mission_asset(asset_id) 	return true end
	--function MoneyManager:on_buy_mission_asset(asset_id) 		return 0 end
	function MoneyManager:get_mission_asset_cost()				return 0 end
	function MoneyManager:get_mission_asset_cost_by_stars(stars)return 0 end
	function MoneyManager:get_mission_asset_cost_by_id(id)		return 0 end
end

--[[???
function MoneyManager:get_skillpoint_cost(tree, tier, points) return 0 end
function MoneyManager:get_skilltree_tree_respec_cost(tree, forced_respec_multiplier) return 0 end
]]