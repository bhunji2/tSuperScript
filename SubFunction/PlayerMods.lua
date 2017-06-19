dofile(tSuperScript.Dir .. "/tCommon.lua")

-- God Mode
if _G.tSuperScriptSet["GodMode"] == true then
	managers.player:player_unit():character_damage():set_invulnerable( true )
end

------------------------------------------------------------------------------------------------------------------------
-- Player Armor
if _G.tSuperScriptSet["PlayerArmor"] == true then
	PlayerDamage.get_real_armor = function(self)
		--return Application:digest_value( 999, false )
		return 999
	end 
end

--Move walking Speed
function PlayerManager:movement_speed_multiplier(speed_state, bonus_multiplier, upgrade_level, health_ratio)
	return _G.tSuperScriptSet["MoveSpeed"]
end

if _G.tSuperScriptSet["PlayerMods"] == true then
-- http://forum.cheatengine.org/viewtopic.php?p=5491462&sid=2dd0338f0868865ae553ec57a699fda5
function PlayerMovement:_change_stamina( value ) end											--Infinite stamina
--PlayerInventory . remove_selection 				= function(self, selection_index, instant) end 	--cause shutdown
PlayerManager	. spread_multiplier 			= function(self) return 0 end 					--cause shutdown??
PlayerStandard	._can_run_directional 			= function(self) return true 	end
PlayerStandard	._get_walk_headbob 				= function(self) return 0 		end
PlayerStandard	._can_stand 					= function(self) return true 	end
PlayerMovement	. is_stamina_drained 			= function(self) return false 	end
--PlayerManager	. remove_equipment 				= function(self, equipment_id) 	end
PlayerManager	. selected_equipment_deploy_timer = function(self) return 0.1 	end
PlayerManager	. chk_minion_limit_reached 		= function(self) return false 	end

-- Instant interaction Bug with Drive?
--if not _getTimer then _getTimer = BaseInteractionExt._get_timer end
function BaseInteractionExt:_get_timer() 
	--showD(self.tweak_data)
	--showD(self._tweak_data.timer)
	--return _getTimer(self)
	if self.tweak_data == "driving_drive" then return 0.1 end
	return 0
end

PlayerManager.body_armor_movement_penalty = function(self) return 1.5 end 
-- No movement penalty, change to a larger value than 1 for an increase in speed

function CoreEnvironmentControllerManager:set_flashbang( flashbang_pos, line_of_sight, travel_dis, linear_dis ) end 
-- No flashbangs

-- Don't taze me bro
--[[
function PlayerTased:enter( state_data, enter_data )
	PlayerTased.super.enter( self, state_data, enter_data )
	self._next_shock = Application:time() + 10
	self._taser_value = 1
	self._recover_delayed_clbk = "PlayerTased_recover_delayed_clbk"
	managers.enemy:add_delayed_clbk( self._recover_delayed_clbk, callback( self, self, "clbk_exit_to_std" ), Application:time() )
end
]]
end

if _G.tSuperScriptSet["NoEXPshake"] == true then
-- No any screen shake by Explosion
-- \lib\managers\explosionmanager.lua
function ExplosionManager:player_feedback(position, normal, range, custom_params) end
end



