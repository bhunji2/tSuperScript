--dofile("mods/tSuperScript/tCommon.lua")
if not _G.tSuperScriptNukeNum then _G.tSuperScriptNukeNum = 0 end

function nukeunit(pawn)
	local col_ray 		= { }
	col_ray.ray 		= Vector3(1, 0, 0)
	col_ray.position 	= pawn.unit:position()
	local action_data 	= {}
	action_data.variant = "explosion"
	action_data.damage 	= 999999
	action_data.attacker_unit = managers.player:player_unit()
	action_data.col_ray = col_ray
	pawn.unit:character_damage():damage_explosion(action_data)
end

function NukeStart()
	if not managers.platform:presence() == "Playing" 	then return end
	if not _G.tSuperScriptNuke 							then return end
	-- civilians
	local total_civilians = 0
	for u_key,u_data in pairs(managers.enemy:all_civilians()) do 
		nukeunit(u_data) 
		total_civilians = total_civilians + 1
		_G.tSuperScriptNukeNum = _G.tSuperScriptNukeNum + 1
	end
	-- enemies
	local total_enemies = 0
	for u_key,u_data in pairs(managers.enemy:all_enemies()) do
		u_data.char_tweak.has_alarm_pager = nil
		nukeunit(u_data)
		total_enemies = total_enemies + 1
		_G.tSuperScriptNukeNum = _G.tSuperScriptNukeNum + 1
	end

	local total = total_civilians + total_enemies
	--[[
	if total > 0 then
		managers.chat:_receive_message(1, "Nuke", "Total:"..tostring(_G.tSuperScriptNukeNum).." - ".."Killed:"..tostring(total), tweak_data.system_chat_color)
	end
	]]

	if managers.hud then managers.hud:show_hint( { text = "Killed:"..tostring(_G.tSuperScriptNukeNum).."+"..tostring(total) } ) end

	if _G.tSuperScriptNuke == true then
		DelayedCalls:Add( "NukeStarting", 4.0, NukeStart )
	end
end

function ToggleNuke()
	_G.tSuperScriptNuke = not _G.tSuperScriptNuke
	
	if _G.tSuperScriptNuke then DelayedCalls:Add( "NukeStarting", 0.1, NukeStart )
	else 
		DelayedCalls:Remove( "NukeStarting" )
		if managers.hud then managers.hud:show_hint( { text = "Nuke stopped:"..tostring(_G.tSuperScriptNukeNum ) } ) end
	end
end
ToggleNuke()
