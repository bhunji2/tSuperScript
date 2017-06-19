dofile(tSuperScript.Dir .. "/tCommon.lua")
--if not tSuperScriptFuncAuto:Get("GodBlessYou") then return end

local AR_GodBlessYou = 
{
	 ["arrested"] 		= true -- 逮捕上銬
	,["bleed_out"] 		= true -- 彌留之際
	,["electrified"] 	= true -- 電擊痙攣
	,["incapacitated"] 	= true -- 踢倒在地
	,["fatal"] 			= true -- 致命死亡 ( 生命數用完 )
}

function GodBlessYou() 
	showH("v(^=.=^)v God Bless You v(^=.=^)v")
	local player = managers.player:player_unit()
	if not player then return end
	player:base():replenish()
	managers.player:set_player_state( "standard" )
end

-- coregamestatemachine.lua
_GameStateMachine_change_state = _GameStateMachine_change_state or GameStateMachine.change_state
function GameStateMachine:change_state(state, params)
	_GameStateMachine_change_state(self,state, params) 
	--showD("state change: ".. self._current_state:name() .. " -> " .. state._name)
	
	if tSuperScriptSet["NoArrested"] == true and AR_GodBlessYou[state._name:sub(8)] == true then 
		GodBlessYou()
	end
end

--No Custody
if tSuperScriptSet["NoCustody"] then 
	function PlayerManager:on_enter_custody(_player, already_dead)
		--showD("on_enter_custody")
		GodBlessYou()
	end 
end
