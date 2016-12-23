-- NoClip mod
-- Author: Simplity
-- Genericized by gir489

--https://bitbucket.org/gir489/pd2-hecks/src/5807d0e273c2/Teleporting%20(NoClip)/?at=master

if  _tSS_Noclip_Toggle == nil then 
	_tSS_Noclip_Toggle = true
	 tSS_Noclip_Toggle = true 
	 return
end

if not managers.player:player_unit() then
	return
end

local axis_move 	= { x = 0, y = 0 }
local kb 			= Input:keyboard()
local kb_down 		= kb.down
local zero_rot 		= Rotation(0, 0, 0)

local M_player 		= managers.player
local player 		= M_player:player_unit()
local camera 		= player:camera()
local camera_rot 	= camera:rotation()
local speed 		= 2

function update_position()
	local move_dir 		= camera_rot:x() * axis_move.y + camera_rot:y() * axis_move.x
	local move_delta 	= move_dir * 10
	local pos_new 		= player:position() + move_delta
	--M_player:warp_to( pos_new, zero_rot )
	M_player:warp_to( pos_new, camera:rotation() )
end

axis_move.x = kb_down( kb, Idstring("w") ) and speed or kb_down( kb, Idstring("s") ) and -speed or 0
axis_move.y = kb_down( kb, Idstring("d") ) and speed or kb_down( kb, Idstring("a") ) and -speed or 0

update_position()