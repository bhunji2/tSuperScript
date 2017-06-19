------------------------------------------------------------------------------------------------------------------------
--Message Show Hint
function showH(textInput) 
	if managers.hud then managers.hud:show_hint( { text = textInput } ) end 
end

--Say String
--https://www.pirateperfection.com/topic/3266-map-id/
function showS(textInput)
	if not managers.chat then return end
	managers.chat:_receive_message(1, "tSuperScript", textInput, tweak_data.system_chat_color) 
end

--Say String Debug
function showD(textInput) 
	if not _G.tSuperScriptSet["Debug"] then return false end
	textInput = tostring(textInput)
	if managers.chat then
			managers.chat:_receive_message(1, "tScriptDebug", textInput, tweak_data.system_chat_color)
	else 	log(textInput) end
end

--Message Show MidText
function showM(textInput,title,timer) 
	if managers.hud then
		managers.hud:present_mid_text({text = textInput or "NoText" ,title = title or "",time = timer or 2})
	end
end
--managers.chat:send_message(ChatManager.GAME, managers.network.account:username() or "offline","test")
------------------------------------------------------------------------------------------------------------------------
--Common Functions of Game
function IsInGame() 
	if not game_state_machine then return false end 
	return string.find(game_state_machine:current_state_name(), "game") 
end 
function IsPlaying() 
	if IsInGame() and managers.platform:presence() == "Playing" then return true end 
	return false 
end
function IsServer()
	if Network:is_server() then return true end
	return false
end
------------------------------------------------------------------------------------------------------------------------
--Common Functions of Localization
function GetLocText(Input)
	if managers.localization then
		return managers.localization:text(Input)
	end
end
------------------------------------------------------------------------------------------------------------------------
--Common Functions of Mod Meta Data
function GetMetaData(VarName,path)
	local filePath
	if path then	filePath = path
	else 			filePath = ModPath end
	
	local file = io.open(filePath.."mod.txt", "r")
	if not file then 
		log("GetMetaData: Error:Can't read mod.txt file.")
		return "v1.0" 
	end
	
	local JsonCode = json.decode(file:read("*all"))
	return JsonCode[VarName]
end

------------------------------------------------------------------------------------------------------------------------
--Random Chance to choose
--math.randomseed(os.time())
--n = math.random(10)
-- https://stackoverflow.com/questions/2986179/lua-random-percentage
function randomChange(percent) 				-- returns true a given percentage of calls
	assert(percent >= 0 and percent <= 100) -- sanity check
	return percent >= math.random(1, 100)   
	-- 1 succeeds 1%, 50 succeeds 50%, 100 always succeeds, 0 always fails
end








