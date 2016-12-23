dofile(tSuperScript.Dir .. "/tCommon.lua")

local IgnoreList = { 
	  "sc_tape_loop" 	--干擾監視器?
	, "access_camera"	--觀看監視器
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
	, "money_wrap_single_bundle" --金錢傳送道?
	, "money_wrap"		--金錢傳送道?
	, "sentry_gun"		--機槍塔
	, "sentry_gun_fire_mode" --機槍塔開火模式
	, "red_open_shutters"--百葉窗
	, "red_close_shutters"
	, "are_turn_on_tv"	--未知
	, "open_slash_close"--未知
	, "open_slash_close_act"--未知
	, "invisible_interaction_open"
}


-- lib/managers/ObjectInteractionManager
--https://www.unknowncheats.me/forum/payday-2-a/133804-revive-players-characters.html
do_interaction_by_type = do_interaction or function(interact_types)
    local objects = {}
    
    --for _,v in pairs(managers.interaction._interactive_objects) do
	for _,v in pairs(managers.interaction._interactive_units) do
		log(tostring(v:interaction().tweak_data))
        if table.contains(interact_types, v:interaction().tweak_data) then
            table.insert(objects, v:interaction())
        end
		
		if string.find(v:interaction().tweak_data, "pickup") then
			table.insert(objects, v:interaction())
			log("//pickup:" .. tostring(v:interaction().tweak_data))
		end
		--[[
		if tweak_data.carry[v:interaction().tweak_data] then
			table.insert(objects, v:interaction())
		end
		]]
    end
    
    for _,v in ipairs(objects) do 
        v:interact(managers.player:player_unit()) 
    end 
end

if tSuperScriptSet["Debug"] then log("//SuperInteract:Start") end

local InteractionCounter = 0
for _,v in pairs(managers.interaction._interactive_units) do
	if not table.contains(IgnoreList, v:interaction().tweak_data) then
		if tSuperScriptSet["Debug"] then log("//" .. tostring(v:interaction().tweak_data)) end
		InteractionCounter = InteractionCounter + 1
		v:interaction():interact(managers.player:player_unit()) 
    end
end

local InteractionCounterLeft = 0
for _,v in pairs(managers.interaction._interactive_units) do
	if not table.contains(IgnoreList, v:interaction().tweak_data) then
		InteractionCounterLeft = InteractionCounterLeft + 1
    end
end

showH(tostring(InteractionCounter) .. " / " .. InteractionCounterLeft .. " : InteractionCounter") 

if tSuperScriptSet["Debug"] then log("//SuperInteract:End") end
--[[
--Revive/free all:
do_interaction_by_type({ 
	  "free"
	, "revive" 
	, "gen_pku_jewelry" 
	,"carry_drop" 
	,"gage_assignment" 
	,"hold_take_painting" 
	, "corpse_dispose" 
	, "painting_carry_drop" 
	, "key"
	, "use_computer"
})
]]