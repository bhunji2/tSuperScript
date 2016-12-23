dofile(tSuperScript.Dir .. "/tCommon.lua")
-- http://www.unknowncheats.me/forum/payday-2/115775-big-oil-correct-fusion-engine-revealer.html
-- REVEAL CORRECT FUSION ENGINE v0.1 by B1313 [HOST ONLY]
if managers.job:current_level_id() == "welcome_to_the_jungle_2" then
    local EngineList = 
    {
		["103717"] = "12",
		["103716"] = "11",
		["103715"] = "10",
		["103714"] = "09",
		["103711"] = "08",
		["103709"] = "07",
		["103708"] = "06",
		["103707"] = "05",
		["103706"] = "04",
		["103705"] = "03",
		["103704"] = "02",
		["103703"] = "01"
	}
    
	local EngineID = tostring(managers.mission:script("default")._elements[103718]._values.on_executed[1].id)
	if EngineID then 
		DelayedCalls:Add( "Big Oil Engine", 5, function()
			showS("Correct Engine : " .. EngineList[EngineID]) 
			showM("Correct Engine : " .. EngineList[EngineID] , "tSuperScript",4) 
			showH("Correct Engine : " .. EngineList[EngineID])
		end)
	end
end