dofile(tSuperScript.Dir .. "/tCommon.lua")

--[[
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
		if tweak_data.carry[v:interaction().tweak_data] then
			table.insert(objects, v:interaction())
		end
    end
    
    for _,v in ipairs(objects) do 
        v:interact(managers.player:player_unit()) 
    end 
end
]]
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


if tSuperScriptSet["Debug"] then log("//SuperInteract:Start") end

local InteractionCounter = 0
for _,v in pairs(managers.interaction._interactive_units) do
	if not table.contains(tSuperScript.InteractIgnoreList, v:interaction().tweak_data) then
		if tSuperScriptSet["Debug"] then log("//" .. tostring(v:interaction().tweak_data)) end
		InteractionCounter = InteractionCounter + 1
		v:interaction():interact(managers.player:player_unit()) 
    end
end

local InteractionCounterLeft = 0
for _,v in pairs(managers.interaction._interactive_units) do
	if not table.contains(tSuperScript.InteractIgnoreList, v:interaction().tweak_data) then
		InteractionCounterLeft = InteractionCounterLeft + 1
    end
end

showH(tostring(InteractionCounter) .. " / " .. InteractionCounterLeft .. " : InteractionCounter") 

if tSuperScriptSet["Debug"] then log("//SuperInteract:End") end



















