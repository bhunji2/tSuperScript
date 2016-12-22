-- Free job purchase
function MoneyManager:get_cost_of_premium_contract(job_id, difficulty) return 0 end

-- Free Preplanning
function MoneyManager:on_buy_preplanning_types() 		end
function MoneyManager:on_buy_preplanning_votes() 		end
function MoneyManager:get_preplanning_type_cost(type) 	return 0 end
function MoneyManager:get_preplanning_votes_cost() 		return 0 end
function MoneyManager:get_preplanning_types_cost()		return 0 end
function MoneyManager:can_afford_preplanning_type(type) return true end

-- Mission Asset
function MoneyManager:can_afford_mission_asset(asset_id) 	return true end
--function MoneyManager:on_buy_mission_asset(asset_id) 		return 0 end
function MoneyManager:get_mission_asset_cost()				return 0 end
function MoneyManager:get_mission_asset_cost_by_stars(stars)return 0 end
function MoneyManager:get_mission_asset_cost_by_id(id)		return 0 end


--[[???
function MoneyManager:get_skillpoint_cost(tree, tier, points) return 0 end
function MoneyManager:get_skilltree_tree_respec_cost(tree, forced_respec_multiplier) return 0 end
]]