dofile("mods/tSuperScript/tCommon.lua")
local IgnoreList = { 
	  "sc_tape_loop" 	--干擾監視器?
	, "access_camera"	--觀看監視器
	, "bag_zipline"		--袋子長條拉勾
	, "hostage_move"	--人質移動
	, "intimidate"		--威嚇
	, "hostage_stay"	--人質趴下
	, "open_slash_close"--未知
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

local InteractionCounter = 0
for _,v in pairs(managers.interaction._interactive_units) do
	if not table.contains(IgnoreList, v:interaction().tweak_data) then
        --log(tostring(v:interaction().tweak_data))
		InteractionCounter = InteractionCounter + 1
		v:interaction():interact(managers.player:player_unit()) 
    end
end
showH(tostring(InteractionCounter) .. " : InteractionCounter") 

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