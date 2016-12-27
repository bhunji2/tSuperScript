dofile(tSuperScript.Dir .. "/tCommon.lua")

local MenuFiles = 
{
	 "MainOptions"
	,"PlayerMods"
	,"StealthMods"
	,"WeaponMods"
	,"AdvOptions"
	,"OtherSet"
}

Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_tSuperScript", function(menu_manager)
	MenuCallbackHandler.tSS_Close_Options = function(this) end
	
	MenuCallbackHandler.callback_tSS_ValueSet = function(this, item)
		--_G.SaveTable(_G.tSuperScriptSet,"MenuTest3.ini")
		local k = item:name():sub(5)
		local v = item:value()
		if 		v == "on" then v = true  end
		if 		v == "off"then v = false end
		_G.tSuperScriptSet[k] = v
		_G.tSuperScriptFunc.Save()
		--log(tostring(k)..":"..tostring(v))
		if k == "Lang" then LocReload() end
	end
	
	MenuCallbackHandler.Config_Reset = function(this, item)
		local title 	= GetLocText("MSG_BOX_ResetDefaultTitle")
		local message 	= GetLocText("MSG_BOX_ResetDefaultMSG")
		local options 	= {
			 [1] = { text = GetLocText("MSG_BOX_ResetDefault_Yes"),data = "ResetYes", callback 	= ResetDefault}
			,[2] = { text = GetLocText("MSG_BOX_ResetDefault_No") ,is_cancel_button 			= true		  }
		}
		QuickMenu:new(title, message, options, true)
	end
	
	for Fs,Fn in pairs(MenuFiles) do 
		MenuHelper:LoadFromJsonFile(tSuperScript.Dir .. "/ConfigMenu/"..Fn..".txt", _G.tSuperScriptFunc, _G.tSuperScriptSet)
	end
end)

function ResetDefault() _G.tSuperScriptFunc:Reset() end

function LocReload()
	local AR_Loc  = { "english" , "Tchinese" , "Schinese" }
	local LocFile = AR_Loc[_G.tSuperScriptSet["Lang"]]
	LocalizationManager:load_localization_file(tSuperScript.Dir .. "/Localization/"..LocFile..".txt")
end

--[[
local MenuTable = 
{
	 ["MainOptions"] = {
	,"PlayerMods"
	,"StealthMods"
	,"WeaponMods"
	,"AdvOptions"
	,"OtherSet"
}
]]