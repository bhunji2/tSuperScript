function PlayerManager:can_pickup_equipment(name) return true end --避免有些重複撿拾的任務物品無法拿取卡BUG

if _G.tSuperScriptSet["WeaponMods"] == true then
-- Weapon Mods
NewRaycastWeaponBase._get_spread 				= function(self) return 0,0 end -- cause shutdown! new version is 0,0
NewRaycastWeaponBase. recoil_multiplier 		= function(self) return 0 end
NewRaycastWeaponBase. reload_speed_multiplier 	= function(self) return 5000 end
NewRaycastWeaponBase. fire_rate_multiplier 		= function(self) return 10 end
NewRaycastWeaponBase. damage_multiplier 		= function(self) return 5000 end
BaseInteractionExt	. can_interact 				= function(self, player) return true end
BaseInteractionExt	._has_required_upgrade 		= function(self) return true end
BaseInteractionExt	._has_required_deployable 	= function(self) return true end
PlayerStandard		._get_swap_speed_multiplier	= function(self) return 5000 end
end

-- Infinite Ammo Clip
--function NewRaycastWeaponBase:update_reloading(t, dt, time_left) return true end
if not _fireWep then _fireWep = NewRaycastWeaponBase.fire end
function NewRaycastWeaponBase:fire( from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, target_unit )
	--_G.SaveTable(tweak_data.weapon[self._name_id],"NewRaycastWeaponBase.ini")
	--_G.SaveTable(self._use_shotgun_reload,"NewRaycastWeaponBase.ini")
	if _G.tSuperScriptSet["ShootShield"]	 == true then self._can_shoot_through_shield = true end
	if _G.tSuperScriptSet["ShootEnemy"] 	 == true then self._can_shoot_through_enemy  = true end
	if _G.tSuperScriptSet["ShootWall"] 		 == true then self._can_shoot_through_wall   = true end
	if _G.tSuperScriptSet["ShieldKnock"] 	 == true then self._shield_knock   			 = true end
	if _G.tSuperScriptSet["ShootStagger"] 	 == true then self._stagger   				 = true end
	if _G.tSuperScriptSet["ShootSuppression"]== true then 
		self._suppression 				= 1		-- 開槍震撼敵人(僅限於部分敵人種類)
		self._panic_suppression_chance 	= 1  	-- 開槍震撼敵人的機率
	end
	
	--[[ 警報類?
	self._alert_size = 0
	self._alert_events = nil
	self._alert_fires = {}
	]]
	
	--[[ --好像不需要用到
	--self._movement_penalty = 3.0 -- 攜帶武器的走路速度
	self._fire_mode = "auto"
	
	self._recoil = 0
	self._knock_down = 0.25
	
	self._deploy_speed_multiplier = 10
	tweak_data.weapon[self._name_id].fire_mode_data.fire_rate = 10
	tweak_data.weapon[self._name_id].single.fire_rate = 10
	tweak_data.weapon[self._name_id].CLIP_AMMO_MAX = 100
	--self._spread_moving = 0
	--self._use_shotgun_reload = nil
	--if self._setup.timer then showS(tostring(self._setup.time)) end
	--showS(tostring(self._next_fire_allowed))
	--self._next_fire_allowed = -1000
	]]
	
	local ray_res = _fireWep(self, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, target_unit )
	if _G.tSuperScriptSet["InfiniteAmmoClip"] == true then
		if managers.player:player_unit() == self._setup.user_unit then self.set_ammo(self, 1.0) end
	end
	if not _G.tSuperScriptSet["NoRecoil"] then return ray_res end
end







