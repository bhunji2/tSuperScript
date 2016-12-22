-- Support all Carry types
for name, i in pairs(tweak_data.carry.types) do
	--showD(tostring(k).. " : " ..tostring(v))
	tweak_data.carry.types[ name ].throw_distance_multiplier 	= 3.5
	tweak_data.carry.types[ name ].move_speed_modifier 			= 1
	tweak_data.carry.types[ name ].jump_modifier 				= 1
	tweak_data.carry.types[ name ].can_run 						= true
end
--[[
_server_drop_carry = _server_drop_carry or PlayerManager.server_drop_carry
function PlayerManager:server_drop_carry(carry_id, carry_multiplier, dye_initiated, has_dye_pack, dye_value_multiplier, position, rotation, dir, throw_distance_multiplier_upgrade_level, zipline_unit, peer)
	dir = Vector3(0, 0, 0)
	--carry_multiplier = 1.0
	_server_drop_carry(self,carry_id, carry_multiplier, dye_initiated, has_dye_pack, dye_value_multiplier, position, rotation, dir, throw_distance_multiplier_upgrade_level, zipline_unit, peer)
end

function UnitNetworkHandler:server_drop_carry(carry_id, carry_multiplier, dye_initiated, has_dye_pack, dye_value_multiplier, position, rotation, dir, throw_distance_multiplier_upgrade_level, zipline_unit, sender)
	PrintTable({UnitNetworkHandler_sender = sender})
	local peer = self._verify_sender(sender)
	if not self._verify_gamestate(self._gamestate_filter.any_ingame) or not peer then
		return
	end
	managers.player:server_drop_carry(carry_id, carry_multiplier, dye_initiated, has_dye_pack, dye_value_multiplier, position, rotation, dir, throw_distance_multiplier_upgrade_level, zipline_unit, peer)
end
]]

function PlayerManager:sync_carry_data(unit, carry_id, carry_multiplier, dye_initiated, has_dye_pack, dye_value_multiplier, position, dir, throw_distance_multiplier_upgrade_level, zipline_unit, peer_id)
	local throw_distance_multiplier = self:upgrade_value_by_level("carry", "throw_distance_multiplier", throw_distance_multiplier_upgrade_level, 1)
	local carry_type = tweak_data.carry[carry_id].type
	throw_distance_multiplier = throw_distance_multiplier * tweak_data.carry.types[carry_type].throw_distance_multiplier
	
	if peer_id == 0 then throw_distance_multiplier = 1.0 end
	
	unit:carry_data():set_carry_id(carry_id)
	unit:carry_data():set_multiplier(carry_multiplier)
	unit:carry_data():set_value(managers.money:get_bag_value(carry_id, carry_multiplier))
	unit:carry_data():set_dye_pack_data(dye_initiated, has_dye_pack, dye_value_multiplier)
	unit:carry_data():set_latest_peer_id(peer_id)
	if alive(zipline_unit) then
		zipline_unit:zipline():attach_bag(unit)
	else
		unit:push(100, dir * 600 * throw_distance_multiplier)
	end
	unit:interaction():register_collision_callbacks()
end

-- Remove cooldown between picking up bags
function PlayerManager:carry_blocked_by_cooldown()  return false end

-- Driving can carry ( lib\units\interactions\interactionext.lua )
function DrivingInteractionExt:can_interact(player) return true end	






