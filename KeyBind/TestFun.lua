dofile(tSuperScript.Dir .. "/tCommon.lua")
log("tScript TEST")




for k, v in pairs(tweak_data.vehicle) do
	showD(k)
	
	
	tweak_data.vehicle[k].max_speed = 99000
	tweak_data.vehicle[k].max_rpm = 99000
	
	showD(v.max_speed)
	showD(v.max_rpm)
end










if managers.hud then managers.hud:show_hint( { text = "Function Tested" } ) end 