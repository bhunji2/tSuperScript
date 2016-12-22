--dofile("mods/tSuperScript/tCommon.lua")

function SentryGunWeapon:out_of_ammo()
	if self._ammo_total then 
			return self._ammo_total == 9999
	else 	return self._ammo_ratio == 1 	end
end

--function SentryGunWeapon:can_auto_reload() return true end
--self._owner = setup_data.user_unit

if not _SentryGWfire then _SentryGWfire = SentryGunWeapon.fire end
function SentryGunWeapon:fire(blanks, expend_ammo, shoot_player, target_unit)
	--[[
	self._auto_reload = 1
	self._current_damage_mul = 5
	self._damage_multiplier = 5
	]]
	
	if self._owner ~= managers.player:player_unit() then 
		return _SentryGWfire(self,blanks, expend_ammo, shoot_player, target_unit)
	end
	
	if _G.tSuperScriptSet["SentryGunSpread"] == true then self._spread_mul = 0 end
	local ray_res = _SentryGWfire(self,blanks, expend_ammo, shoot_player, target_unit)
	
	if _G.tSuperScriptSet["SentryGunAmmo"] == true then self:change_ammo(1) end -- this is with sync
	if not _G.tSuperScriptSet["SentryGunFireRate"] then return ray_res end
end


--[[ -- this is old fire func
function SentryGunWeapon:fire( blanks, expend_ammo )
	if expend_ammo then
		if self._ammo_total <= 0 then
			return
		end
		self._ammo_total = self._ammo_total - 0

		local ammo_percent = self._ammo_total / self._ammo_total
		if ammo_percent == 0 or math.abs( ammo_percent - self._ammo_sync ) >= self._ammo_sync_resolution then
			self._ammo_sync = ammo_percent
			self._unit:network():send( "sentrygun_ammo", math.ceil( ammo_percent / self._ammo_sync_resolution ) )
		end
	end
	
	local fire_obj = self._effect_align[ self._interleaving_fire ]
	local from_pos = fire_obj:position()
	local direction = fire_obj:rotation():y()
	-- mvector3.negate( direction )
	mvector3.spread( direction, tweak_data.weapon[ self._name_id ].SPREAD * self._spread_mul )
	World:effect_manager():spawn( self._muzzle_effect_table[ self._interleaving_fire ] ) -- , normal = col_ray.normal } )
	if self._use_shell_ejection_effect then
		World:effect_manager():spawn( self._shell_ejection_effect_table ) 
	end
	local ray_res = self:_fire_raycast( from_pos, direction, blanks )
	if self._alert_events and ray_res.rays then
		RaycastWeaponBase._check_alert( self, ray_res.rays, from_pos, direction, self._unit )
	end
	
	self._unit:movement():give_recoil()
	
	return ray_res
end
]]



-- player: sentry_gun
-- Emeny: swat_van_turret_module
-- lib\units\equipment\sentry_gun\sentrygundamage.lua

if not _damage_bullet then _damage_bullet = SentryGunDamage.damage_bullet end
function SentryGunDamage:damage_bullet( attack_data )
	--log(tostring(self._unit:base():get_name_id()))
	--if self._stats_name == "swat_turret" then _damage_bullet(self,attack_data)
	--else return end
	
	--if self._owner ~= managers.player:player_unit() then return _damage_bullet(self,attack_data) end
	
	if _G.tSuperScriptSet["SentryGunGodMode"] == true then
		if self._unit:base():get_name_id() == "sentry_gun" then return end
	end
	
	_damage_bullet(self,attack_data)
	
	--print( "[SentryGunDamage:damage_bullet]", inspect( attack_data ) )
	--[[
	if self._dead or self._invulnerable or PlayerDamage:_look_for_friendly_fire( attack_data.attacker_unit ) then
		return
	end
	]]
	
	--[[
	if self._dead or self._invulnerable or Network:is_client() and self._ignore_client_damage or PlayerDamage.is_friendly_fire(self, attack_data.attacker_unit) then
		return
	end
	
	local hit_shield = attack_data.col_ray.body and attack_data.col_ray.body:name() == self._shield_body_name
	local hit_bag = attack_data.col_ray.body and attack_data.col_ray.body:name() == self._bag_body_name
	local dmg_adjusted = attack_data.damage * ( hit_shield and tweak_data.weapon.sentry_gun.SHIELD_DMG_MUL or 1 ) * ( hit_bag and tweak_data.weapon.sentry_gun.BAG_DMG_MUL or 1 )
	-- print( "hit_shield", hit_shield, "hit_bag", hit_bag, "damage", attack_data.damage, "dmg_adjusted", dmg_adjusted  )
	if dmg_adjusted >= self._health then
		self:die()
	else
		self._health = self._health
	end
	
	local health_percent = self._health / self._health_max
	if health_percent == 0 or math.abs( health_percent - self._health_sync ) >= self._health_sync_resolution then
		self._health_sync = health_percent
		self._unit:network():send( "sentrygun_health", math.ceil( health_percent / self._health_sync_resolution ) )
	end
	]]
end