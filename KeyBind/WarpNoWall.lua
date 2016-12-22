-- Penetrative warp to crosshair
local PENETRATE = nil -- set to 'nil' instead of 'true' if you don't want it to penetrate through walls, etc
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
	managers.player:warp_to(col_ray.hit_position, player_unit:rotation())
end
--[[
-- Warp to bullet
if not _lastBullet then _lastBullet = nil end
if _lastBullet then managers.player:warp_to(_lastBullet, managers.player:player_unit():rotation()) end
if not _bulletCollision then _bulletCollision = InstantBulletBase.on_collision end
function InstantBulletBase:on_collision( col_ray, weapon_unit, user_unit, damage, blank )
	if user_unit == managers.player:player_unit() then
		_lastBullet = col_ray.hit_position
	end
	return _bulletCollision(self, col_ray, weapon_unit, user_unit, damage, blank)
end
]]