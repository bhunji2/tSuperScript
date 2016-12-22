dofile("mods/tSuperScript/tCommon.lua")
--http://www.unknowncheats.me/forum/payday-2-a/170053-simple-auto-message.html
--https://github.com/JamesWilko/Payday-2-BLT-Lua/blob/master/mods/base/req/quick_menu.lua
function SmallQuickMenu()
	local title 	= GetLocText("tSS_QuickMenu_Title")
	local message 	= GetLocText("tSS_QuickMenu_Message")
	local options 	= 
	{	
		 [1] = { text = GetLocText("tSS_QuickMenu_Cancel")		,is_cancel_button 	= true				}
		,[2] = { text = GetLocText("tSS_QuickMenu_Restart")		,data = 1, callback = SmallQuickMenuBack}
		,[3] = { text = GetLocText("tSS_QuickMenu_EndMission")	,data = 2, callback = SmallQuickMenuBack}
		,[4] = { text = GetLocText("tSS_QuickMenu_Nuke")		,data = 3, callback = SmallQuickMenuBack}
		,[5] = { text = GetLocText("tSS_QuickMenu_Replenish")	,data = 4, callback = SmallQuickMenuBack}
		,[6] = { text = GetLocText("tSS_QuickMenu_UnlockThings"),data = 5, callback = SmallQuickMenuBack}
		,[7] = { text = GetLocText("tSS_QuickMenu_Insert")		,data = 6, callback = SmallQuickMenuBack}
		,[8] = { text = GetLocText("tSS_QuickMenu_Convert")		,data = 7, callback = SmallQuickMenuBack}
		,[9] = { text = GetLocText("tSS_QuickMenu_Interact")	,data = 8, callback = SmallQuickMenuBack}
	}
	QuickMenu:new(title, message, options, true)
end

function SmallQuickMenuBack(data)
	if data == 1 then managers.game_play_central:restart_the_game()			end
	if data == 2 then dofile("mods/tSuperScript/KeyBind/EndMission.lua") 	end
	if data == 3 then dofile("mods/tSuperScript/KeyBind/NukeUnit.lua") 		end
	if data == 4 then dofile("mods/tSuperScript/KeyBind/replenish.lua") 	end
	if data == 5 then dofile("mods/tSuperScript/KeyBind/UnlockThing.lua") 	end
	if data == 6 then dofile("mods/tSuperScript/tSuperScript.lua") 			end
	if data == 7 then dofile("mods/tSuperScript/KeyBind/Convert.lua") 		end
	if data == 8 then dofile("mods/tSuperScript/KeyBind/SuperInteract.lua") end
end

SmallQuickMenu()