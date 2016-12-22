local Auto_setup_mission_assets_original 	= MissionAssetsManager._setup_mission_assets
local Auto_sync_load_original 				= MissionAssetsManager.sync_load
local Auto_init_finalize_original 			= MissionAssetsManager.init_finalize
local Auto_unlock_asset_original 			= MissionAssetsManager.unlock_asset

function MissionAssetsManager:_setup_mission_assets()
	Auto_setup_mission_assets_original(self)
	self:check_all_assetsAuto()
end

function MissionAssetsManager:sync_load(data)
	Auto_sync_load_original(self, data)
	self:check_all_assetsAuto()
end

function MissionAssetsManager:init_finalize()
	Auto_init_finalize_original(self)
	self:check_all_assetsAuto()
end

--[[
function MissionAssetsManager:unlock_asset(asset_id)
	self:check_all_assetsAuto()
	return Auto_unlock_asset_original(self, asset_id)
end
]]
function MissionAssetsManager:asset_is_buyable(asset)
	return 		asset.id ~= "buy_all_assets" 
		and 	asset.show 
		and not asset.unlocked 
		and ((	Network:is_server() 
		and 	asset.can_unlock) 
		or  (	Network:is_client() 
		and 	self:get_asset_can_unlock_by_id(asset.id)))
end

function MissionAssetsManager:AutoUnlockAll()
	log("AutoUnlockAll")
	--_G.PrintTable( self._global.assets )
	for _, asset in ipairs(self._global.assets) do
		_G.PrintTable( asset )
		--if MissionAssetsManager:is_asset_unlockable(asset.id) then
			--managers.chat:_receive_message(1, "tUnlock", tostring(asset), tweak_data.system_chat_color)
			--MissionAssetsManager:unlock_asset(asset)
		--end
	end
end

function MissionAssetsManager:check_all_assetsAuto()
	--log("check_all_assetsAuto")
	if not game_state_machine and self:mission_has_preplanning() then return end
	
	-- Free assets
	function MoneyManager:on_buy_mission_asset( asset_id ) 			return 0 end
	function MoneyManager:get_mission_asset_cost() 					return 0 end
	function MoneyManager:get_mission_asset_cost_by_stars( stars ) 	return 0 end
	function MoneyManager:get_mission_asset_cost_by_id( id ) 		return 0 end
	
	--log(tostring(game_state_machine))
	--log(tostring(self:mission_has_preplanning()))
	--[[
	for _, asset in ipairs(self._global.assets) do
		if self:is_asset_unlockable(asset.id)
		and asset.can_unlock == true 
		and not self:get_asset_unlocked_by_id(asset.id) then
			--_G.PrintTable( asset )
			--managers.chat:_receive_message(1, "tUnlock", tostring(asset), tweak_data.system_chat_color)
			self:unlock_asset(asset.id)
		end
	end
	]]
	
	
	--for _, asset in ipairs(self._global.assets) do
		--if MissionAssetsManager:is_asset_unlockable(asset) then
			--managers.chat:_receive_message(1, "tUnlock", tostring(asset), tweak_data.system_chat_color)
			--MissionAssetsManager:unlock_asset(asset.id)
			--_G.PrintTable( asset )
			--MissionAssetsManager:unlock_asset(asset)
			--[[
			if MissionAssetsManager:get_asset_can_unlock_by_id(asset) then
				MissionAssetsManager:unlock_asset(asset)
				--MissionAssetsManager.sync_unlock_asset(self,asset)
				managers.chat:_receive_message(1, "tUnlock", tostring(asset), tweak_data.system_chat_color)
			end
			]]
		--end
	--end

	--[[
		if game_state_machine and not self:mission_has_preplanning() then
			for _, asset in ipairs(self._global.assets) do
				if self:asset_is_buyable(asset) then
					MissionAssetsManager.sync_unlock_asset(self,asset)
					managers.chat:_receive_message(1, "tUnlock", tostring(asset), tweak_data.system_chat_color)
					log("Unlock:"..tostring(asset))
					--return
				end
			end
	]]
			--[[
			if not self._all_assets_bought then
				self._tweak_data.buy_all_assets.money_lock = 0
				self._all_assets_bought = true
				unlock_asset_original(self, "buy_all_assets")
			end
			]]
		--end
end