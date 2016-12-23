dofile(tSuperScript.Dir .. "/tCommon.lua")

--https://www.unknowncheats.me/forum/payday-2-a/116345-unit-name-crosshair.html
--local camera = managers.player:player_unit():movement()._current_state._ext_camera
--[[
local player_unit = managers.player:player_unit()
local camera = player_unit:camera()
local mvec_to = Vector3()
local from_pos = camera:position()
mvector3.set( mvec_to, camera:forward() )
mvector3.multiply( mvec_to, 20000 )
mvector3.add( mvec_to, from_pos )
local col_ray = World:raycast( "ray", from_pos, mvec_to, "slot_mask", managers.slot:get_mask( "all" ) )
if col_ray then
	io.stderr:write(string.sub(tostring(tostring(col_ray.unit:name():t()), 1, 10), 1, 10))
	managers.hud:show_hint( { text = string.sub(tostring(col_ray.unit:name():t()), 1, 10) } )
end
]]

if not managers.player:player_unit() then return end
if _showUnit then return end
_showUnit = true
DelayedCalls:Add( "ShowUnitTest", 1, function() _showUnit = false end)

local PENETRATE = true -- set to 'nil' instead of 'true' if you don't want it to penetrate through walls, etc
local player_unit = managers.player:player_unit()
local camera = player_unit:camera()
local mvec_to = Vector3()
local from_pos = camera:position()
mvector3.set( mvec_to, camera:forward() )
mvector3.multiply( mvec_to, 20000 )
mvector3.add( mvec_to, from_pos )
local col_ray = World:raycast( "ray", from_pos, mvec_to, "slot_mask", managers.slot:get_mask( "bullet_impact_targets" ) )
if col_ray then
	if PENETRATE then
		local offset = Vector3()
		mvector3.set(offset, camera:forward())
		mvector3.multiply(offset, 100)
		mvector3.add(col_ray.hit_position, offset)
	end
	if _lastUnitIDS == col_ray.unit:name() then return end
	_lastUnitIDS = col_ray.unit:name()
	showH(tostring(col_ray.unit:name():key()) .. " : " .. tostring(col_ray.unit:id()))
end





