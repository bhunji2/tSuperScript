-- Guards and Camera
function GroupAIStateBase	:_clbk_switch_enemies_to_not_cool() 	end
function PlayerMovement		:on_suspicion( observer_unit, status ) 	end
function GroupAIStateBase	:on_criminal_suspicion_progress( u_suspect, u_observer, status ) end
function GroupAIStateBase	:criminal_spotted( unit ) 				end
function GroupAIStateBase	:report_aggression( unit ) 				end
function PlayerMovement		:on_uncovered( enemy_unit ) 			end
function SecurityCamera		:_upd_suspicion( t ) 					end
function SecurityCamera		:_sound_the_alarm( detected_unit ) 		end -- Make cameras not trigger the alarm
function SecurityCamera		:_set_suspicion_sound( suspicion_level )end -- Gets rid of the sound of the camera seeing you
function SecurityCamera		:clbk_call_the_police() 				end
function CopMovement		:anim_clbk_police_called( unit ) 		end
function GroupAIStateBase	:sync_event( event_id, blame_id ) 		end
function GroupAIStateBase	:on_police_called( called_reason ) 		end -- Makes guards & people in general stop calling the cops
function GroupAIStateBase	:on_police_weapons_hot( called_reason ) end
function GroupAIStateBase	:on_gangster_weapons_hot( called_reason ) end
function GroupAIStateBase	:on_enemy_weapons_hot( is_delayed_callback ) end
function GroupAIStateBase	:_clbk_switch_enemies_to_not_cool() 	end
function CopLogicArrest._upd_enemy_detection( data ) 				end
function CopLogicArrest._call_the_police( data, my_data, paniced ) 	end
function CopLogicIdle.on_alert( data, alert_data ) 					end
function CopLogicBase._get_logic_state_from_reaction( data, reaction ) return "idle" end

---------------New
function CivilianLogicFlee.clbk_chk_call_the_police( ignore_this, data ) end -- Stops civs from reporting you
function CopLogicArrest._say_call_the_police( data, my_data ) end -- Stops police from saying they are calling the police all the time
-- Prevents panic buttons & intel burning (intercepting the 'run' action is the only way; 
--for example, if you intercept events such as 'e_so_alarm_under_table' to prevent intel burning, the animation will not happen but the fire will still appear)
if not _actionRequest then _actionRequest = CopMovement.action_request end
function CopMovement:action_request( action_desc )
	-- action_desc.variant == "e_so_alarm_under_table": gangsters lighting intel on fire in Big Oil Day 1, etc
	-- action_desc.variant == "cmf_so_press_alarm_wall": civilian in Bank Heist pressing panic button, etc
	-- action_desc.variant == "cmf_so_press_alarm_table": tellers in Bank Heist pressing panic button, etc
	-- action_desc.variant == "cmf_so_call_police": civilians calling the police
	-- action_desc.variant == "arrest_call": cops saying they are calling the police

	-- Stops panic buttons & intel burning
	if action_desc.variant == "run" then return false end

	return _actionRequest(self, action_desc)
end