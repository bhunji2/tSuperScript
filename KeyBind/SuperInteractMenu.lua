dofile(tSuperScript.Dir .. "/tCommon.lua")

local WarpToDebug = false
if not tSuperScriptSet["Debug"] then WarpToDebug = false end

-- lib/managers/ObjectInteractionManager
function RunInteraction(typeID,DoInteraction)
	local InteractionCounter = 0
	for _,v in pairs(managers.interaction._interactive_units) do
		if typeID and v:interaction().tweak_data == typeID or not typeID then
			if WarpToDebug then
				managers.player:warp_to(v:position(), managers.player:player_unit():camera():rotation())
				return 0
			end	
				
			InteractionCounter = InteractionCounter + 1
			if DoInteraction then v:interaction():interact(managers.player:player_unit()) end
		end
	end
	return InteractionCounter
end

function InteractionMenuBack(data)
	if data == "Cancel" then return end
	local InteractionCounter 		= RunInteraction(data,true)
	local InteractionCounterLeft 	= RunInteraction(data,false)
	showH(tostring(InteractionCounter) .. " / " .. tostring(InteractionCounterLeft) .. " : InteractionCounter : " .. tostring(data)) 
	DelayedCalls:Add( "InteractionMenu", 0.3, InteractionMenu )
end

function InteractionMenu()
	if tSuperScriptSet["Debug"] then
		LocalizationManager:load_localization_file(tSuperScript.Dir .. "/Localization/Tchinese.txt")
	end
	
	if _InteractionMenu then _InteractionMenu:Hide() end
	
	local title 	= "Super Interaction"
	local message 	= "Choose a type to interact"
	local TypeList  = {}
	local TypeData	= {}
	
	table.insert(TypeData, {
		 text 		= "Cancel"
		,data 		= "Cancel"
		,callback 	= InteractionMenuBack
		,is_cancel_button = true
	})
	
	for _,v in pairs(managers.interaction._interactive_units) do
		local InteractName = v:interaction().tweak_data
		if not table.contains(tSuperScript.InteractIgnoreList, InteractName) then
			if not TypeList[InteractName] then
				TypeList[InteractName] = true
				local text = GetLocText(InteractName)
				if not text 
					or text == "" 
					or text == "unknow" 
					or text:match("ERROR:") 
					or tSuperScriptSet["Lang"] == 1 then 
						text = "　　　　"
						if tSuperScriptSet["Debug"] then log(InteractName) end
				end
				text = InteractName .. "  - " .. text
				table.insert(TypeData, {
					 text 		= text
					,data 		= InteractName
					,callback 	= InteractionMenuBack
				})
			end
		end
	end
	
	if #TypeData == 1 then
		showH("No objects.")
		return
	end
	
	_InteractionMenu = QuickMenu:new(title, message, TypeData, true)
	--[[
	if tSuperScriptSet["Debug"] then 
		log("//InteractionMenu----------")
		PrintTable(TypeList) 
		log("//InteractionMenu----------")
	end
	]]
end
InteractionMenu()






