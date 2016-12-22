
if _G.tSuperScriptSet["Debug"] == true then return end
_G.tSuperScriptSet["Debug"] = true
_G.tSuperScriptFunc:Save()

log("tScript Debug On--")

if managers.hud then managers.hud:show_hint( { text = "tScript Debug On--" } ) end
if managers.chat then
	managers.chat:_receive_message(1, "tSuperScript", "tScript Debug On--", tweak_data.system_chat_color) 
end