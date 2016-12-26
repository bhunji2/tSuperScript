dofile(tSuperScript.Dir .. "/tCommon.lua")
_G.tSuperScriptSet = _G.tSuperScriptSet or _G.tSuperScriptSet_Default
------------Main Control------------
local InfiniteCableTies	= _G.tSuperScriptSet["InfiniteCableTies"]	
local InfiniteEquipment	= _G.tSuperScriptSet["InfiniteEquipment"]		
local DoctorBag			= _G.tSuperScriptSet["DoctorBag"]
local FastDrilling		= _G.tSuperScriptSet["FastDrilling"]
local DeadCiviNone		= _G.tSuperScriptSet["DeadCiviNone"]		
local NoArrested		= _G.tSuperScriptSet["NoArrested"]
local NoCustody			= _G.tSuperScriptSet["NoCustody"]
local InstantMask		= _G.tSuperScriptSet["InstantMask"]
local InteractRange		= _G.tSuperScriptSet["InteractRange"]
local JobShow			= _G.tSuperScriptSet["JobShow"]
--[[--------------------------------------------------------------------------------------------------------------------
	^全自動觸發功能^
1.	免費購買任務契約(離岸金額需求無)
2.	欲置計畫不限物件數量及金額、幫助
3.	任務輔助物品無花費
4.	安全屋升級無花費(不包括成就相關)
--]]--------------------------------------------------------------------------------------------------------------------
local SkillPoints		= 0
--設定技能點(0 = 關閉 , 1 ~ 自訂數字)
local AddMoney			= 0
--設定金錢(0 = 關閉 , -負數扣錢 ~ 正數加錢)
local AddOffshore		= 0
--設定離岸金錢(0 = 關閉 , -負數扣錢 ~ 正數加錢) - 尚未測試
local SetLevel			= 0
--設定等級(0 = 關閉 , 1 ~ 100)
local Perks				= 0
--設定職業技能點(0 = 關閉 , 1 ~ 100)
---------------------------------------------------------------------------------------------------------------------------
--Super script Integrated by Tast
--New Version：http://bbs.3dmgame.com/thread-5324774-1-1.html
--OLD Version：http://bbs.3dmgame.com/thread-4008414-1-1.html
---------------------------------------------------------------------------------------------------------------------------
if SkillPoints 	> 0 	then managers.skilltree		:_set_points(SkillPoints) 		 	end
if AddMoney 	~=0 	then managers.money			:_add_to_total(AddMoney) 		 	end
if AddOffshore 	~=0 	then MoneyManager			:add_to_offshore(AddOffshore) 		end
if SetLevel 	> 0 	then thenmanagers.experience:_set_current_level (SetLevel) 	 	end
if Perks 		> 0 	then managers.skilltree._global.specializations.points = Perks  end
--managers.money:_set_offshore(9999)
---------------------------------------------------------------------------------------------------------------------------
local SubPath = tSuperScript.Dir .. "/SubFunction/"
if IsInGame() and IsPlaying() then
	if _G.tSuperScriptSet["MaskOff"		] == true then dofile(SubPath.."PlayerMaskOffstarter.lua") 	end
	if _G.tSuperScriptSet["MarkEnemies"	] == true then dofile(SubPath.."MarkEnemies.lua") 			end
	if _G.tSuperScriptSet["Carrymods"	] == true then dofile(SubPath.."CarryMods.lua") 			end
	if _G.tSuperScriptSet["SecureBag"	] == true then dofile(SubPath.."SecureBag.lua") 			end
	if _G.tSuperScriptSet["MarkObject"	] == true then dofile(SubPath.."waypoints.lua") 			end
	dofile(SubPath.."WeaponMods.lua")
	dofile(SubPath.."PlayerMods.lua")
	dofile(SubPath.."SuperJump.lua")
	dofile(SubPath.."StealthMods.lua")
	dofile(SubPath.."SentryGun.lua")
	dofile(SubPath.."ItemFinder.lua")
	dofile(SubPath.."JobMapFunc.lua")
end

---------------------------------------------------------------------------------------------------------------------------

tSuperScript.InteractIgnoreList = { 
	  "sc_tape_loop" 	--干擾監視器?
	, "access_camera"	--觀看監視器
	, "access_camera_y_axis"--觀看監視器
	, "bag_zipline"		--袋子滑索
	, "hostage_move"	--人質移動
	, "intimidate"		--威嚇
	, "hostage_stay"	--人質趴下
	, "driving_drive"	--開車
	, "ammo_bag"		--彈藥包
	, "doctor_bag"		--醫療包
	, "grenade_crate"	--榴彈包
	, "player_zipline"	--玩家滑索
	, "alaska_plane"	--阿拉司卡飛機?
	, "grenade_briefcase"--爆炸物品箱
	, "bodybags_bag"	--屍袋
	, "push_button"		--互動按鈕
	, "button_infopad"	--儀表版?
	, "sentry_gun"		--機槍塔
	, "sentry_gun_fire_mode" --機槍塔開火模式
	, "red_open_shutters"--百葉窗
	, "red_close_shutters"--百葉窗
	, "are_turn_on_tv"	--未知
	, "open_slash_close"--大垃圾箱
	, "open_slash_close_act"--未知
	, "big_computer_not_hackable"
	, "place_flare"		--爆燃 ( 毒師 )
	, "open_from_inside"--裡面開門?
}

function LootManager:_present(carry_id, multiplier)
	local real_value 	= 0
	local is_small_loot = not not tweak_data.carry.small_loot[carry_id]
	if is_small_loot then
			real_value 	= self:get_real_value(carry_id, multiplier)
	else	real_value 	= managers.money:get_secured_bonus_bag_value(carry_id, multiplier) end
	local carry_data 	= tweak_data.carry[carry_id]
	local title 		= managers.localization:text("hud_loot_secured_title")
	local type_text 	= carry_data.name_id and managers.localization:text(carry_data.name_id)
	local text 			= managers.localization:text("hud_loot_secured", {
		CARRY_TYPE 		= type_text,
		AMOUNT 			= managers.experience:cash_string(real_value)
	})
	showH(text)
end

-- http://www.unknowncheats.me/forum/payday-2/122896-re-enable-crazy-firerate-grenade-launcher.html
-- Removes grenade's launcher silly delay. Crazy firerate enabled again (though it will work only on host side)
-- function GrenadeBase:check_time_cheat() return true end 
-- Not Working

-- No fall damage (useless if you have god mode on) 
function PlayerDamage:damage_fall( data ) end 

--Follow Player's limiter
tweak_data.player.max_nr_following_hostages = 500

-- Infinite interact distance (except on cameras, shaped charges, body bags, burn money & place camera [Firestarters job], or trip mines)
function BaseInteractionExt:interact_distance()
	if self.tweak_data 				== "access_camera"
	or self.tweak_data 				== "shaped_sharge"
	or tostring(self._unit:name()) 	== "Idstring(@ID14f05c3d9ebb44b6@)"
	or self.tweak_data 				== "burning_money"
	or self.tweak_data 				== "stn_int_place_camera" 
	or self.tweak_data 				== "trip_mine" then
		return self._tweak_data.interact_distance or tweak_data.interaction.INTERACT_DISTANCE
	end
	return InteractRange -- default is 200
end

--[[
if not _convert_to_criminal then _convert_to_criminal = CopBrain.convert_to_criminal end
function CopBrain:convert_to_criminal(mastermind_criminal)
	--log(tostring(mastermind_criminal))
	_convert_to_criminal(self,mastermind_criminal)
end

if not _set_objective then _set_objective = CopBrain.set_objective end
function CopBrain:set_objective(new_objective)
	_set_objective(self,new_objective)
	--log(tostring(new_objective.type))
	--if new_objective == "surrender"
	--self:convert_to_criminal(nil)
end

if not _surrender then _surrender = CopLogicIdle._surrender end
function CopLogicIdle._surrender(data, amount, aggressor_unit)
	_surrender(data, amount, aggressor_unit)
	--local params = {effect = amount, aggressor_unit = aggressor_unit}
	--data.brain:set_objective({type = "surrender", params = params})
end
]]
--[[
Hooks:PreHook( CopLogicIdle, "on_intimidated", "TestPrePlayerManagerInit22", function( data, amount, aggressor_unit )
    --log("PlayerManager Pre-initialized")
	showD("on_intimidated")
	CopLogicIdle._surrender( data, amount, aggressor_unit)
end )
]]
--[[
-- Unlimited [500 actually, but who cares] & instant intimidations
--if not _onIntimidated then _onIntimidated = CopLogicIdle.on_intimidated end
function CopLogicIdle:on_intimidated( data, amount, aggressor_unit ) 
	--CopLogicIdle:_surrender( data, amount, aggressor_unit) 
	--showD("on_intimidated")
	log("CopLogicIdle on_intimidated")
	return true
end
]]
--[[
CopLogicAttack.on_intimidated = CopLogicIdle.on_intimidated
CopLogicArrest.on_intimidated = CopLogicIdle.on_intimidated
CopLogicSniper.on_intimidated = CopLogicIdle.on_intimidated
]]

-- No hit disorientation not working
function CoreEnvironmentControllerManager:hit_feedback_front() end
function CoreEnvironmentControllerManager:hit_feedback_back	() end
function CoreEnvironmentControllerManager:hit_feedback_right() end
function CoreEnvironmentControllerManager:hit_feedback_left	() end
function CoreEnvironmentControllerManager:hit_feedback_up	() end
function CoreEnvironmentControllerManager:hit_feedback_down	() end
function CoreEnvironmentControllerManager:set_concussion_grenade(flashbang_pos, line_of_sight, travel_dis, linear_dis, duration) end

if not _onIntimidated then _onIntimidated = CopLogicIdle.on_intimidated end
function CopLogicIdle.on_intimidated( data, amount, aggressor_unit )
	if aggressor_unit == managers.player:player_unit() then
		--CopLogicIdle._surrender( data, amount )
		managers.groupai:state():on_criminal_suspicion_progress(nil, data.unit, nil) 
		-- 轉換罪犯
		managers.groupai:state():convert_hostage_to_criminal( data.unit )
		managers.groupai:state():sync_converted_enemy( data.unit )
		return true
	else
		return _onIntimidated(data, amount, aggressor_unit)	
	end
end
CopLogicAttack.on_intimidated = CopLogicIdle.on_intimidated
CopLogicArrest.on_intimidated = CopLogicIdle.on_intimidated
CopLogicSniper.on_intimidated = CopLogicIdle.on_intimidated

-- Setup logic for shields to be able to be intimidated
CopBrain._logic_variants.shield.intimidated = CopLogicIntimidated
if not _onIIntimidated then _onIIntimidated = CopLogicIntimidated.on_intimidated end
function CopLogicIntimidated.on_intimidated( data, amount, aggressor_unit )
	--showS("on_intimidated")
	-- If shield we skip animations, go straight to conversion & spawn a new shield since it was destroyed during intimidation
	if data.unit:base()._tweak_table == "shield" then
		CopLogicIntimidated._do_tied( data, aggressor_unit )
		CopInventory._chk_spawn_shield( data.unit:inventory(), nil )
	else _onIIntimidated(data, amount, aggressor_unit) end
end

-- Setup a proper sniper-rifle for snipers (100% accuracy, no spread)
CopBrain._logic_variants.sniper = clone( CopBrain._logic_variants.security )
CopBrain._logic_variants.sniper.attack = CopLogicSniper
if not _onSniperEnter then _onSniperEnter = CopLogicSniper.enter end
function CopLogicSniper.enter( data, new_logic_name, enter_params )
	if data.unit:brain()._logic_data and data.unit:brain()._logic_data.objective and data.unit:brain()._logic_data.objective.type == "follow" then
	data.char_tweak.weapon[ data.unit:inventory():equipped_unit():base():weapon_tweak_data().usage ] = tweak_data.character.presets.weapon.sniper.m4
	data.char_tweak.weapon[ data.unit:inventory():equipped_unit():base():weapon_tweak_data().usage ].spread = 0
	-- Get dat 100% accuracy
	for distance=1, 3 do
		for interpolate=1,2 do
			data.char_tweak.weapon[ data.unit:inventory():equipped_unit():base():weapon_tweak_data().usage ].FALLOFF[distance].acc[interpolate] = 1
		end
	end
end
	_onSniperEnter(data, new_logic_name, enter_params)
end

function GodBlessYou()
	managers.player:set_player_state( "standard" )
	showH("v(^=.=^)v God Bless You v(^=.=^)v")
	local player = managers.player:player_unit()
	if not player then return end
	player:base():replenish()
end

--coregamestatemachine.lua
if not _GameStateMachine_change_state then _GameStateMachine_change_state = GameStateMachine.change_state end
function GameStateMachine:change_state(state, params)
	_GameStateMachine_change_state(self,state, params) 
	--showS(self._current_state:name())
	--showS("state change:"..state._name)
	--ingame_fatal			未知：??
	
	if 	NoArrested  ~= true then return end
	if 	state._name == "ingame_arrested"		or 		-- 逮捕上銬
		state._name == "ingame_bleed_out" 		or 		-- 彌留之際
		state._name == "ingame_electrified" 	or 		-- 電擊痙攣
		state._name == "ingame_incapacitated" 	then 	-- 踢倒在地
			GodBlessYou()
	end
end

--No Custody
if NoCustody == true then function PlayerManager:on_enter_custody(_player) GodBlessYou() end end

-- Instant mask on
if InstantMask == true then tweak_data.player.put_on_mask_time = 0.01 end

-- Infinite Cable Ties
if InfiniteCableTies == true then
	--if not _rmSpecial then _rmSpecial = PlayerManager.remove_special end
	function PlayerManager:remove_special( name ) --[[showS("remove_special:"..name)]] end
end

-- Infinite Equipment
if InfiniteEquipment == true then
--if not _rmEquipment then _rmEquipment = PlayerManager.remove_equipment end
function PlayerManager:remove_equipment( equipment_id ) --[[showS( "remove_equipment:"..tostring(equipment_id )) ]] end
-- Infinite Equipment (Not Host)
function PlayerManager:remove_equipment_possession( peer_id, equipment ) --[[showS( "remove_equipment_possession:"..tostring(equipment )) ]] end
--Infinite BodyBags
function PlayerManager:_set_body_bags_amount(body_bags_amount) self._local_player_body_bags = 2 end
--function PlayerManager:on_used_body_bag() end
end

-- Credits goes to different UC members !
if DoctorBag == true then
function DoctorBagBase:_take( unit )
	--local taken = 1 - unit:character_damage():health_ratio()
	local taken = 0 --set taken or not
	
	self._amount = self._amount
	unit:character_damage():recover_health() -- replenish()
	return taken
end
end
---------------------------------------------------------------------------------------------------------------------------
--http://pastebin.com/WbagaxP7
--Fast Drilling
if FastDrilling == true then
function TimerGui:_set_jamming_values() return end
function TimerGui:start( timer )--showD("TimerGui:start - "..tostring(timer))
	timer = 1.0
	if 		self._jammed 	then self:_set_jammed( false ) return end
	if not 	self._powered 	then self:_set_powered( true ) return end
	if 		self._started 	then return end
	self:_start( timer )
	if 	managers.network:session() then
		managers.network:session():send_to_peers_synched( "start_timer_gui", self._unit, timer )
	end
end
end
--END

--DEAD CIVI NONE
if DeadCiviNone == true then
	MoneyManager.get_civilian_deduction = function(self) return 0 end
	function MoneyManager.civilian_killed() return end
end
--END

---------------------------------------------------------------------------------------------------------------------------
-- add c4
--managers.player:add_special( { name = "c4" } ) --no need

---------------------------------------------------------------------------------------------------------------------------
--JobShow
--http://www.cheatengine.org/forum/viewtopic.php?p=5493041&sid=2a730f8873e14153ffde43b19c9424eb
if JobShow then
	managers.crimenet._debug_mass_spawning = true --??
	managers.crimenet._NEW_JOB_MIN_TIME = JobShow
	managers.crimenet._NEW_JOB_MAX_TIME = JobShow
end

-- Message On Screen
local tVersion = GetMetaData("version",tSuperScript.Dir)
showH("Super Script v"..tVersion.." By Tast for BLT version")
showS("Super Script v"..tVersion.." By Tast ( BLT )")

---------------------------------------------------------------------------------------------------------------------------
--https://bitbucket.org/YaPh1l/payday-2-lua/downloads
--http://adminjustforfun.blogspot.tw/2016/05/how-to-payday2-files-notepad.html

--KeyBinds
--https://msdn.microsoft.com/en-us/library/windows/desktop/dd375731(v=vs.85).aspx

--Interception.Backup(PlayerManager, "upgrade_value")
--http://www.unknowncheats.me/forum/payday-2/104388-strange-function-backup-restore-crash-using-interception-lua.html

--Коллекция скриптов .Lua
--http://zhyk.ru/forum/showthread.php?t=907342

--My collection of LUA script snippets
--http://www.unknowncheats.me/forum/payday-2/98503-my-collection-lua-script-snippets.html

--Any way to remove offshore money?
--https://www.reddit.com/r/paydaytheheist/comments/332b46/any_way_to_remove_offshore_money/

--PayDay 2:Custom PlayerMaskOff state and more
--https://www.unknowncheats.me/wiki/PayDay_2:Custom_PlayerMaskOff_state_and_more

--Quick Melee Charge (Near Instant)
--http://www.unknowncheats.me/forum/payday-2/120656-quick-melee-charge-near-instant.html