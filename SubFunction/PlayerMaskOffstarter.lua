--function PlayerMaskOffstarter()

function IsInGame() 
  if not game_state_machine then return false end 
	return string.find(game_state_machine:current_state_name(), "game") 
end 

function IsPlaying()
	if IsInGame() and managers.platform:presence() == "Playing" then return true end
	return false
end

if not IsPlaying() then return end

function PlayerMaskOff:_update_check_actions( t, dt )
	local input = self:_get_input()

	self:_update_interaction_timers( t )
	self._stick_move = self._controller:get_input_axis( "move" )

	if mvector3.length( self._stick_move ) < 0.1 then
		self._move_dir = nil
	else
		local cam_flat_rot = Rotation( self._cam_fwd_flat, math.UP )
	
		self._move_dir = mvector3.copy( self._stick_move )
		mvector3.rotate_with( self._move_dir, cam_flat_rot )
	end

	self:_update_start_standard_timers( t )

	if input.btn_stats_screen_press then
		self._unit:base():set_stats_screen_visible( true )
	elseif input.btn_stats_screen_release then
		self._unit:base():set_stats_screen_visible( false )
	end
	
	self:_update_foley( t, input )
	
	local new_action
	
	if not new_action then new_action = self:_check_use_item( t, input ) end
	if not new_action then new_action = self:_check_action_interact( t, input ) end
	self:_check_action_jump( t, input )
	self:_check_action_duck( t, input )
end

function PlayerMaskOff:_check_action_interact( t, input )
	local new_action,timer,interact_object
	local interaction_wanted = input.btn_interact_press

	if interaction_wanted then
		local action_forbidden = self._unit:base():stats_screen_visible() 
																		or self:_interacting() 
																		or self._ext_movement:has_carry_restriction()
																		or self:is_deploying()
	 	if not action_forbidden then	
			new_action,timer,interact_object = managers.interaction:interact( self._unit )
						
			if timer then
				new_action = true
				
				self:_start_action_interact( t, input, timer, interact_object )
			end
			
			new_action = new_action or self:_start_action_intimidate( t )
		end
	end
	
	if input.btn_interact_release then
		self:_interupt_action_interact()
	end
	
	return new_action
end

function PlayerStandard:_start_action_interact( t, input, timer, interact_object )
	self._interact_expire_t = t + timer
	self._interact_params = { object = interact_object, timer = timer, tweak_data = interact_object:interaction().tweak_data }
	
	managers.hud:show_interaction_bar( 0, timer )
	self._unit:base():set_detection_multiplier( "interact", 0.5 )
	
	managers.network:session():send_to_peers_loaded( "sync_teammate_progress", 1, true, self._interact_params.tweak_data, timer, false )
end

function PlayerMaskOff:_end_action_interact()
	self:_interupt_action_interact( nil, nil, true )
	managers.interaction:end_action_interact( self._unit )
	
	self._unit:base():set_detection_multiplier( "interact", nil )
end

function PlayerMaskOff:_interupt_action_interact( t, input, complete )
	if self._interact_expire_t then
		self._interact_expire_t = nil
		
		if alive( self._interact_params.object ) then
			self._interact_params.object:interaction():interact_interupt( self._unit, complete )
		end
		
		managers.interaction:interupt_action_interact( self._unit )
		managers.network:session():send_to_peers_loaded( "sync_teammate_progress", 1, false, self._interact_params.tweak_data, 0, complete and true or false )
		
		self._interact_params = nil
		managers.hud:hide_interaction_bar( complete )
		self._unit:base():set_detection_multiplier( "interact", nil )
	end

	self._unit:base():set_slot( self._unit, 4 )
end

function PlayerMaskOff:_update_interaction_timers( t )
	if self._interact_expire_t then
		if not alive( self._interact_params.object ) or
			self._interact_params.object ~= managers.interaction:active_object() or 
			self._interact_params.tweak_data ~= self._interact_params.object:interaction().tweak_data
		then
			self:_interupt_action_interact( t )
		else
			managers.hud:set_interaction_bar_width( self._interact_params.timer-(self._interact_expire_t - t), self._interact_params.timer )
			if self._interact_expire_t <= t then
				self:_end_action_interact( t )
				self._interact_expire_t = nil
			end
		end
	end
end

function PlayerMaskOff:_interacting()
	return self._interact_expire_t
end

function PlayerMaskOff:is_deploying()
	return self._use_item_expire_t and true or false
end

function PlayerMaskOff:_check_action_jump( t, input )
	local new_action
	local action_wanted = input.btn_jump_press
		
	if action_wanted then
		local action_forbidden = self._jump_t and self._jump_t + 0.55 > t
		action_forbidden = action_forbidden or self._unit:base():stats_screen_visible() or self._state_data.in_air or self:_interacting()
		
		if not action_forbidden then
				local action_start_data = {}
				local jump_vel_z = tweak_data.player.movement_state.standard.movement.jump_velocity.z
				
				action_start_data.jump_vel_z = jump_vel_z
				
				if self._move_dir then
					local jump_vel_xy = tweak_data.player.movement_state.standard.movement.jump_velocity.xy[ "run" or "walk" ]
					
					action_start_data.jump_vel_xy = jump_vel_xy
				end
				
				new_action = self:_start_action_jump( t, action_start_data )
		end
	end
end

function PlayerMaskOff:_start_action_jump( t, action_start_data )
	local jump_vec = action_start_data.jump_vel_z * math.UP
	
	self._jump_t = t
	self._unit:mover():jump()

	if self._move_dir then
		local move_dir_clamp = self._move_dir:normalized() * math.min( 1, self._move_dir:length() )
		
		self._last_velocity_xy = move_dir_clamp * action_start_data.jump_vel_xy
		self._jump_vel_xy = mvector3.copy( self._last_velocity_xy )
	else
		self._last_velocity_xy = Vector3()
	end
	
	self._unit:mover():set_velocity( jump_vec )
end

function PlayerMaskOff:_can_stand()
	local offset = 50
	local radius = 30
	local hips_pos = self._obj_com:position() + math.UP * offset
	local up_pos = math.UP * (160-offset)
	
	mvector3.add( up_pos, hips_pos )
	local ray = World:raycast( "ray", hips_pos, up_pos , "slot_mask",  self._slotmask_gnd_ray, "ray_type", "body mover", "sphere_cast_radius", radius, "bundle", 20 )
	if ray then
		managers.hint:show_hint( "cant_stand_up", 2 )
		return false
	end
	return true
end

function PlayerMaskOff:_check_action_duck( t, input )
	if self._setting_hold_to_duck and input.btn_duck_release then
		if self._state_data.ducking then
			self:_end_action_ducking( t )
		end
	elseif input.btn_duck_press then
		if not self._unit:base():stats_screen_visible() then
			if not self._state_data.ducking then
				self:_start_action_ducking( t )
			elseif self._state_data.ducking then
				self:_end_action_ducking( t )
			end
		end
	end
end

function PlayerMaskOff:_start_action_ducking( t )
	if self:_interacting() then
		return
	end
	
	self._state_data.ducking = true
	self:_stance_entered()
	
	local velocity = self._unit:mover():velocity()
	
	self._unit:kill_mover()
	self._unit:activate_mover( Idstring( "duck" ), velocity )
	self._ext_network:send( "set_pose", 2 )
end

function PlayerMaskOff:_end_action_ducking( t )
	if not self:_can_stand() then
		return
	end
	
	self._state_data.ducking = false
	self:_stance_entered()
	
	local velocity = self._unit:mover():velocity()
	
	self._unit:kill_mover()
	self._unit:activate_mover( PlayerStandard.MOVER_STAND, velocity )
	self._ext_network:send( "set_pose", 1 )	--stand
end

function PlayerMaskOff:_interupt_action_ducking( t )
	if self._state_data.ducking then
		self:_end_action_ducking( t )
	end
end

function PlayerMaskOff:_stance_entered( unequipped )
	local stance_standard = tweak_data.player.stances.default[ managers.player:current_state() ] or tweak_data.player.stances.default.standard
	local head_stance = self._state_data.ducking and tweak_data.player.stances.default.crouched.head or stance_standard.head
	
	local weapon_id
	local stance_mod = { translation = Vector3( 0,0,0 ) }
	
	if not unequipped then
		weapon_id = self._equipped_unit:base():get_name_id()
		
		if self._state_data.in_steelsight then
			stance_mod = (self._equipped_unit:base().stance_mod and self._equipped_unit:base():stance_mod()) or stance_mod
		end
	end
		
	local stances = tweak_data.player.stances[ weapon_id ] or tweak_data.player.stances.default
	local misc_attribs = 	(self._state_data.in_steelsight and stances.steelsight) or (self._state_data.ducking and stances.crouched or stances.standard)
	local duration = tweak_data.player.TRANSITION_DURATION + (self._equipped_unit:base():transition_duration() or 0)
	local duration_multiplier = self._state_data.in_steelsight and 1/self._equipped_unit:base():enter_steelsight_speed_multiplier() or 1
	
	local new_fov = self:get_zoom_fov( misc_attribs ) + 0
	self._camera_unit:base():clbk_stance_entered( misc_attribs.shoulders, head_stance, misc_attribs.vel_overshot, new_fov, misc_attribs.shakers, stance_mod, duration_multiplier, duration )

	managers.menu:set_mouse_sensitivity( new_fov < (misc_attribs.FOV or 75) )
end

function PlayerMaskOff:get_zoom_fov( stance_data )
	local fov = stance_data and stance_data.FOV or 75
	
	local fov_multiplier = managers.user:get_setting( "fov_multiplier" )
	if( self._state_data.in_steelsight ) then
		fov = self._equipped_unit:base():zoom()
		fov_multiplier = 1 + (fov_multiplier - 1)/2
	end

	return fov * fov_multiplier
end

function PlayerMaskOff:interaction_blocked()
	return false
end


--managers.chat:_receive_message(1, "tSuperScript", "PlayerMaskOff Functioning", tweak_data.system_chat_color)

--end