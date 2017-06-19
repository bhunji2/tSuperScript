dofile(tSuperScript.Dir .. "/tCommon.lua")
log("tScript TEST")

for u_key,u_data in pairs(managers.enemy:all_enemies()) do
	--log(tostring(u_data.unit.play_redirect))
	--SaveTable( u_data.unit, "u_data.ini" )
	u_data.unit.play_redirect(Idstring("light_hurt"),nil)
	return
end

log("play_state")

























if managers.hud then managers.hud:show_hint( { text = "Function Tested" } ) end 