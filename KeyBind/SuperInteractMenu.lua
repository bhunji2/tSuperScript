dofile(tSuperScript.Dir .. "/tCommon.lua")

function RunInteraction(typeID,DoInteraction)
	local InteractionCounter = 0
	for _,v in pairs(managers.interaction._interactive_units) do
		if not table.contains(tSuperScript.InteractIgnoreList, v:interaction().tweak_data) then
			if typeID and v:interaction().tweak_data == typeID or not typeID then
				InteractionCounter = InteractionCounter + 1
				if DoInteraction then v:interaction():interact(managers.player:player_unit()) end
			end
		end
	end
	return InteractionCounter
end

function InteractionMenuBack(data)
	if data == "Cancel" then return end
	local InteractionCounter 		= RunInteraction(data,true)
	local InteractionCounterLeft 	= RunInteraction(data,false)
	showH(tostring(InteractionCounter) .. " / " .. tostring(InteractionCounterLeft) .. " : InteractionCounter : " .. tostring(data)) 
	InteractionMenu()
end

function InteractionMenu()
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
		if not table.contains(tSuperScript.InteractIgnoreList, v:interaction().tweak_data) then
			if not TypeList[v:interaction().tweak_data] then
				TypeList[v:interaction().tweak_data] = true
				table.insert(TypeData, {
					 text 		= v:interaction().tweak_data
					,data 		= v:interaction().tweak_data
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
	
	if tSuperScriptSet["Debug"] then 
		log("//InteractionMenu----------")
		PrintTable(TypeList) 
		log("//InteractionMenu----------")
	end
end
InteractionMenu()






