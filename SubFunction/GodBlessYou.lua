
if not tSuperScriptFuncAuto:Get("GodBlessYou") then return end

--coregamestatemachine.lua
_GameStateMachine_change_state = _GameStateMachine_change_state or GameStateMachine.change_state
function GameStateMachine:change_state(state, params)
	_GameStateMachine_change_state(self,state, params) 
	--showS(self._current_state:name())
	--showS("state change:"..state._name)
	
	if 	NoArrested  ~= true then return end
			GodBlessYou()
	end
end

function GodBlessYou()
	managers.player:set_player_state( "standard" )
	showH("v(^=.=^)v God Bless You v(^=.=^)v")
	local player = managers.player:player_unit()
	if not player then return end
	player:base():replenish()
end