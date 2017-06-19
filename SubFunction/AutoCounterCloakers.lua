dofile(tSuperScript.Dir .. "/tCommon.lua")

--[[
function GodBlessYou()
	managers.player:set_player_state( "standard" )
	showH("v(^=.=^)v God Bless You v(^=.=^)v")
	local  player = managers.player:player_unit()
	if not player then return end
	player:base():replenish()
end

if PlayerMovement and tSuperScriptSet["NoArrested"] then
	function PlayerMovement:downed() 
		--showD("PlayerMovement:downed")
		--GodBlessYou()
	end
end
]]
-- https://www.unknowncheats.me/forum/payday-2/127398-auto-counter-cloakers-bots-too.html
-- https://www.unknowncheats.me/forum/payday-2-a/179764-auto-taze-tazer.html
-- lib/units/beings/player/PlayerMovement
if PlayerMovement and tSuperScriptSet["CounterPlayer"] then
	pm__on_SPOOCed = pm__on_SPOOCed or PlayerMovement.on_SPOOCed
	function PlayerMovement:on_SPOOCed(enemy_unit) 
		if not randomChange(tSuperScriptSet["CounterChance"]) then 
			return pm__on_SPOOCed(self,enemy_unit)
		end
		return "countered" 
	end
end

-- lib/units/player_team/teamaimovement
if TeamAIMovement and tSuperScriptSet["CounterBOT"] then
	taim__on_SPOOCed = taim__on_SPOOCed or TeamAIMovement.on_SPOOCed
	function TeamAIMovement:on_SPOOCed(enemy_unit) 
		if not randomChange(tSuperScriptSet["CounterChance"]) then 
			return taim__on_SPOOCed(self,enemy_unit)
		end
		return "countered" 
	end
end

