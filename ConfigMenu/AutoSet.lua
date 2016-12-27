_G.tSuperScriptFuncAuto = tSuperScriptFuncAuto or {}
_G.tSuperScriptAutoSet  = tSuperScriptAutoSet  or {}
_G.tSuperScriptAutoDef	= {
	 "CustomSafehouse" 	-- 安全屋：無花費、完成每日任務、解鎖小飾品
	,"MissionAssets"	-- 任務輔助物品：無花費、可解鎖
	,"Preplanning"		-- 預置計畫：無花費、可解鎖
	,"ProJob"			-- 專家任務：不需花費離岸金額
	,"LootSecure"		-- 包裹確保：替換顯示訊息
	,"GodBlessYou"		-- 倒地复原：逮捕上銬、彌留之際、電擊痙攣、踢倒在地
}

local AutoFilePath = SavePath .. "tSuperScript.Auto.txt"
function tSuperScriptFuncAuto:Load()
	local  file = io.open(AutoFilePath, "r")
	if not file then return false end
	local  Text = file:read("*all")
	file:close()
	if 	   Text ~= "[]" then tSuperScriptAutoSet = json.decode(Text) end
end
tSuperScriptFuncAuto:Load()

function tSuperScriptFuncAuto:Save()
	local  file = io.open(AutoFilePath, "w+")
	if not file then return false end
	local jsonCode = json.encode(tSuperScriptAutoSet)
	file:write(jsonCode)
	file:close()
	if jsonCode == "[]" then SystemFS:delete_file(AutoFilePath) end
end

function tSuperScriptFuncAuto:Menu()
	for i,k in pairs(tSuperScriptAutoDef) do 
		local BasePrefix= "tSS_" .. k
		local v 		= tSuperScriptAutoSet[k]
		MenuHelper:AddToggle({
			 id 		= BasePrefix
			,title 		= BasePrefix .. "_AutoSet_T"
			,desc 		= BasePrefix .. "_AutoSet_D"
			,callback 	= "tSS_Auto_ValueSet"
			,value 		= v == nil and true or v
			,menu_id 	= "tSS_options_Auto"
			,priority 	= 100 - i
			,localized	= true
		})
	end
end

function tSuperScriptFuncAuto:Get(var)
	local 	var = tSuperScriptAutoSet[var]
	if 		var == nil then var = true end
	return 	var
end


Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_tSuperScriptAuto", function(menu_manager)
	MenuCallbackHandler.tSS_Close_Options = function(this) end
	MenuCallbackHandler.tSS_Auto_ValueSet = function(this, item)
		local k = item:name():sub(5)
		local v = item:value()
		if 		v == "on" 	then v = nil	end
		if 		v == "off"	then v = false	end
		--log("//tSuperScriptFuncAuto - " .. tostring(k) .. " : " .. tostring(v))
		tSuperScriptAutoSet[k] = v
		tSuperScriptFuncAuto:Save()
	end
	
	MenuHelper:LoadFromJsonFile(tSuperScript.Dir .. "/ConfigMenu/AutoSet.txt", tSuperScriptFuncAuto, tSuperScriptAutoSet)
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenus_tSuperScriptAuto", function( menu_manager, nodes )
	tSuperScriptFuncAuto:Menu()
end)





