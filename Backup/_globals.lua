if not tSuperScriptInitialized then
	tSuperScriptInitialized = true
	
	function inGame()
		if not game_state_machine then return false end
		return string.find(game_state_machine:current_state_name(), "game")
	end
	
	function ExecuteTscript()
		if managers.hud then 
			managers.hud:show_hint( { text = "TExecuteTscript" } ) 
		end
		
		dofile("tSuperScript.lua")
	end
end