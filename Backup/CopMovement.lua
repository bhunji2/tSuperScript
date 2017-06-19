--[[
local AR_play_redirect = {}
function CopMovement:play_redirect(redirect_name, at_time)
	if not AR_play_redirect[redirect_name] then 
		log("play_state:state_name: "	..redirect_name .. " - at_time: "..tostring(at_time))
		AR_play_redirect[redirect_name] = 1
	end
	
	local result = self._unit:play_redirect(Idstring(redirect_name), at_time)
	return result ~= Idstring("") and result
end

local AR_play_state = {}
function CopMovement:play_state(state_name, at_time)
	if not AR_play_state[state_name] then 
		log("play_state:state_name: "	..state_name .. " - at_time: "..tostring(at_time))
		AR_play_state[state_name] = 1
	end
	
	local result = self._unit:play_state(Idstring(state_name), at_time)
	return result ~= Idstring("") and result
end
]]
--[[
local AR_type = {}
_action_request = _action_request or CopMovement.action_request
function CopMovement:action_request(action_desc)
	if not AR_type[action_desc["type"]] --[[		then 				
		local action_desc2 = { ["action_desc"] = action_desc }
		PrintTable(action_desc2)
		AR_type[action_desc["type"]] --[[ = action_desc["type"]	
	end
	
	_action_request(self,action_desc)
end
]]

--[[
01:55:11 AM Lua: play_state:state_name: civilian/spawn/loop
01:55:11 AM Lua: play_state:at_time: nil
01:55:11 AM Lua: play_redirect:state_name: cf_sp_sms_phone_var1
01:55:11 AM Lua: play_redirect:at_time: nil
01:55:11 AM Lua: play_redirect:state_name: cm_sp_stand_arms_crossed
01:55:11 AM Lua: play_redirect:at_time: nil
01:55:11 AM Lua: play_redirect:state_name: cf_sp_stand_idle_var1
01:55:11 AM Lua: play_redirect:at_time: nil
01:55:11 AM Lua: play_redirect:state_name: cm_sp_phone1
01:55:11 AM Lua: play_redirect:at_time: nil
01:55:11 AM Lua: play_redirect:state_name: cm_sp_standing_talk1
01:55:11 AM Lua: play_redirect:at_time: nil
01:55:11 AM Lua: play_redirect:state_name: cf_sp_stand_look_up
01:55:11 AM Lua: play_redirect:at_time: nil
01:55:11 AM Lua: play_redirect:state_name: cm_sp_stand_idle
01:55:11 AM Lua: play_redirect:at_time: nil
01:55:11 AM Lua: play_redirect:state_name: exit
01:55:11 AM Lua: play_redirect:at_time: nil
01:55:12 AM Lua: play_redirect:state_name: walk_fwd
01:55:12 AM Lua: play_redirect:at_time: nil
01:55:12 AM Lua: play_redirect:state_name: walk_l
01:55:12 AM Lua: play_redirect:at_time: nil
01:55:12 AM Lua: play_redirect:state_name: walk_r
01:55:12 AM Lua: play_redirect:at_time: nil
01:55:12 AM Lua: play_redirect:state_name: walk_bwd
01:55:12 AM Lua: play_redirect:at_time: nil
01:55:12 AM Lua: play_redirect:state_name: turn_l
01:55:12 AM Lua: play_redirect:at_time: nil
01:55:19 AM Lua: play_redirect:state_name: walk_turn_r_lf
01:55:19 AM Lua: play_redirect:at_time: nil
01:55:58 AM Lua: play_redirect:state_name: walk_turn_l_rf
01:55:58 AM Lua: play_redirect:at_time: nil
01:55:59 AM Lua: play_redirect:state_name: walk_turn_l_lf
01:55:59 AM Lua: play_redirect:at_time: nil
01:56:04 AM Lua: play_redirect:state_name: equip
01:56:04 AM Lua: play_redirect:at_time: nil
01:56:04 AM Lua: play_redirect:state_name: up_idle
01:56:04 AM Lua: play_redirect:at_time: nil
01:56:04 AM Lua: play_redirect:state_name: surprised
01:56:04 AM Lua: play_redirect:at_time: nil
01:56:04 AM Lua: play_redirect:state_name: death
01:56:04 AM Lua: play_redirect:at_time: nil
01:56:04 AM Lua: play_redirect:state_name: panic
01:56:04 AM Lua: play_redirect:at_time: nil
01:56:05 AM Lua: play_redirect:state_name: drop
01:56:05 AM Lua: play_redirect:at_time: nil
01:56:06 AM Lua: play_redirect:state_name: crouch
01:56:06 AM Lua: play_redirect:at_time: nil
01:56:06 AM Lua: play_redirect:state_name: turn_r
01:56:06 AM Lua: play_redirect:at_time: nil
01:56:06 AM Lua: play_redirect:state_name: run_start_r
01:56:06 AM Lua: play_redirect:at_time: nil
01:56:07 AM Lua: play_redirect:state_name: arrest_call
01:56:07 AM Lua: play_redirect:at_time: nil
01:56:07 AM Lua: play_redirect:state_name: stand
01:56:07 AM Lua: play_redirect:at_time: nil
01:56:07 AM Lua: play_redirect:state_name: run_start_l
01:56:07 AM Lua: play_redirect:at_time: nil
01:56:09 AM Lua: play_redirect:state_name: run_start_fwd
01:56:09 AM Lua: play_redirect:at_time: nil
01:56:11 AM Lua: [1] tScriptDebug: set_whisper_mode:false
01:56:12 AM Lua: play_redirect:state_name: run_start_turn_bwd
01:56:12 AM Lua: play_redirect:at_time: nil
01:56:13 AM Lua: play_redirect:state_name: run_start_bwd
01:56:13 AM Lua: play_redirect:at_time: nil
01:56:21 AM Lua: play_redirect:state_name: run_start_turn_r
01:56:21 AM Lua: play_redirect:at_time: nil
01:56:30 AM Lua: play_redirect:state_name: e_sp_car_exit_to_cbt_front_l_var2
01:56:30 AM Lua: play_redirect:at_time: nil
01:56:31 AM Lua: play_redirect:state_name: e_sp_car_exit_to_cbt_front_r_var2
01:56:31 AM Lua: play_redirect:at_time: nil
01:56:43 AM Lua: play_redirect:state_name: e_sp_car_exit_to_cbt_front_l
01:56:43 AM Lua: play_redirect:at_time: nil
01:56:47 AM Lua: play_redirect:state_name: run_l
01:56:47 AM Lua: play_redirect:at_time: nil
01:56:48 AM Lua: play_redirect:state_name: run_fwd
01:56:48 AM Lua: play_redirect:at_time: 0.12469551712275
01:56:51 AM Lua: play_redirect:state_name: e_sp_down_12m
01:56:51 AM Lua: play_redirect:at_time: nil
01:56:52 AM Lua: play_redirect:state_name: run_bwd
01:56:52 AM Lua: play_redirect:at_time: nil
01:56:53 AM Lua: play_redirect:state_name: run_r
01:56:53 AM Lua: play_redirect:at_time: 0.039314925670624
01:56:54 AM Lua: play_redirect:state_name: run_start_turn_l
01:56:54 AM Lua: play_redirect:at_time: nil
01:56:57 AM Lua: play_redirect:state_name: recoil_auto
01:56:57 AM Lua: play_redirect:at_time: nil
01:56:59 AM Lua: play_redirect:state_name: recoil_single
01:56:59 AM Lua: play_redirect:at_time: nil
01:57:01 AM Lua: play_redirect:state_name: run_stop_fwd
01:57:01 AM Lua: play_redirect:at_time: nil
01:57:02 AM Lua: play_redirect:state_name: sprint_fwd
01:57:02 AM Lua: play_redirect:at_time: 0
01:57:02 AM Lua: play_redirect:state_name: sprint_l
01:57:02 AM Lua: play_redirect:at_time: nil
01:57:05 AM Lua: play_redirect:state_name: sprint_bwd
01:57:05 AM Lua: play_redirect:at_time: 0.47724372148514
01:57:05 AM Lua: play_redirect:state_name: suppressed_reaction
01:57:05 AM Lua: play_redirect:at_time: nil
01:57:05 AM Lua: play_redirect:state_name: heavy_hurt
01:57:05 AM Lua: play_redirect:at_time: nil
01:57:08 AM Lua: play_redirect:state_name: e_sp_clk_3_5m_dwn_vent
01:57:08 AM Lua: play_redirect:at_time: nil
01:57:10 AM Lua: play_redirect:state_name: reload
01:57:10 AM Lua: play_redirect:at_time: nil
01:57:11 AM Lua: play_redirect:state_name: e_so_sup_fumble_inplace
01:57:11 AM Lua: play_redirect:at_time: nil
01:57:19 AM Lua: play_redirect:state_name: heavy_run
01:57:19 AM Lua: play_redirect:at_time: nil
01:57:19 AM Lua: play_redirect:state_name: light_hurt
01:57:19 AM Lua: play_redirect:at_time: nil
01:57:23 AM Lua: play_redirect:state_name: recoil
01:57:23 AM Lua: play_redirect:at_time: nil
]]

--[[
02:07:56 AM Lua: ["action_desc"] = table
02:07:56 AM Lua: "body_part" = 1
02:07:56 AM Lua: "type" = idle
02:07:56 AM Lua: [1] tSuperScript: Super Script v1.72.257.25 By Tast ( BLT )
02:07:57 AM Lua: ["action_desc"] = table
02:07:57 AM Lua: "body_part" = 1
02:07:57 AM Lua: "type" = act
02:07:57 AM Lua: "align_sync" = true
02:07:57 AM Lua: "variant" = cf_sp_stand_idle_var1
02:07:57 AM Lua: ["action_desc"] = table
02:07:57 AM Lua: "type" = walk
02:07:57 AM Lua: ["nav_path"] = table
02:07:57 AM Lua: "1" = Vector3(-3675, 7650, 25)
02:07:57 AM Lua: "2" = Vector3(-3475, 7600, 47.1267)
02:07:57 AM Lua: "3" = Vector3(-3300, 7500, 47.1214)
02:07:57 AM Lua: "4" = Vector3(-3300, 6425, 49.0133)
02:07:57 AM Lua: "5" = Vector3(-3275, 6075, 51.2304)
02:07:57 AM Lua: "6" = Vector3(-3275, 5975, 54.7532)
02:07:57 AM Lua: "7" = Vector3(-3300, 5725, 47.5001)
02:07:57 AM Lua: "8" = Vector3(-3300, 4950, 47.2938)
02:07:57 AM Lua: "9" = Vector3(-3300, 4225, 49.2001)
02:07:57 AM Lua: "10" = Vector3(-3275, 4075, 54.9603)
02:07:57 AM Lua: "11" = Vector3(-3275, 3975, 54.7531)
02:07:57 AM Lua: "12" = Vector3(-3250, 3250, 46.7365)
02:07:57 AM Lua: "13" = Vector3(-3225, 3250, 46.3218)
02:07:57 AM Lua: "14" = Vector3(-3200, 3250, 15.1889)
02:07:57 AM Lua: "15" = Vector3(-3200, 2825, 20.6702)
02:07:57 AM Lua: "16" = Vector3(-3200, 2750, 25.9184)
02:07:57 AM Lua: "17" = Vector3(-3200, 2675, 27.7327)
02:07:57 AM Lua: "18" = Vector3(-3300, 2675, 38.3406)
02:07:57 AM Lua: "19" = Vector3(-3300, 2700, 25)
02:07:57 AM Lua: "body_part" = 2
02:07:57 AM Lua: "end_rot" = Rotation(-90, 0, -0)
02:07:57 AM Lua: "variant" = walk
02:08:00 AM Lua: ["action_desc"] = table
02:08:00 AM Lua: "type" = turn
02:08:00 AM Lua: "angle" = 135.86737060547
02:08:00 AM Lua: "body_part" = 2
02:08:11 AM Lua: ["action_desc"] = table
02:08:11 AM Lua: "type" = hurt
02:08:11 AM Lua: "body_part" = 1
02:08:11 AM Lua: "hit_pos" = Vector3(265.778, 573.866, 114.621)
02:08:11 AM Lua: "direction_vec" = Vector3(0.968128, 0.113209, -0.22341)
02:08:11 AM Lua: ["blocks"] = table
02:08:11 AM Lua: "action" = -1
02:08:11 AM Lua: "act" = -1
02:08:11 AM Lua: "tase" = -1
02:08:11 AM Lua: "aim" = -1
02:08:11 AM Lua: "walk" = -1
02:08:11 AM Lua: "death_type" = normal
02:08:11 AM Lua: "variant" = explosion
02:08:11 AM Lua: "hurt_type" = death
02:08:11 AM Lua: "block_type" = death
02:08:11 AM Lua: "attacker_unit" = [Unit '@ID77184fc479876808@' Vector3(461.678, 1930.78, 13.1) 83242E80]
02:08:11 AM Lua: ["action_desc"] = table
02:08:11 AM Lua: "body_part" = 3
02:08:11 AM Lua: "type" = shoot
02:08:16 AM Lua: [1] tScriptDebug: set_whisper_mode:false
02:08:54 AM Lua: ["action_desc"] = table
02:08:54 AM Lua: "body_part" = 4
02:08:54 AM Lua: "type" = crouch
02:08:57 AM Lua: ["action_desc"] = table
02:08:57 AM Lua: "body_part" = 4
02:08:57 AM Lua: "type" = stand
02:09:18 AM Lua: ["action_desc"] = table
02:09:18 AM Lua: "body_part" = 3
02:09:18 AM Lua: "type" = tase
]]