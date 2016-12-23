
------------------------------------------------------------------------------------------------------------------------
--InGame State Mask Off
if IngameMaskOffState ~= nil then
	if not _IngameMaskOffStateEnter then _IngameMaskOffStateEnter = IngameMaskOffState.at_enter end
	function IngameMaskOffState:at_enter()
		_IngameMaskOffStateEnter(self)
		ExecuteScript()
	end
end
------------------------------------------------------------------------------------------------------------------------
--InGame State Standard
if IngameStandardState ~= nil then
	if not _IngameStandardStateEnter then _IngameStandardStateEnter = IngameStandardState.at_enter end
	function IngameStandardState:at_enter()
		_IngameStandardStateEnter(self)
		ExecuteScript()
	end
end
------------------------------------------------------------------------------------------------------------------------
--InGame State Clean
if IngameCleanState ~= nil then
	if not _IngameCleanState_at_enter then _IngameCleanState_at_enter = IngameCleanState.at_enter end
	function IngameCleanState:at_enter()
		_IngameCleanState_at_enter(self)
		ExecuteScript()
	end
end
------------------------------------------------------------------------------------------------------------------------
--InGame State Civilian
if IngameCivilianState ~= nil then
	if not _IngameCivilianState_at_enter then _IngameCivilianState_at_enter = IngameCivilianState.at_enter end
	function IngameCivilianState:at_enter()
		_IngameCivilianState_at_enter(self)
		ExecuteScript()
	end
end
--[[
--InGame State Fatal
if IngameFatalState ~= nil then
	if not _IngameFatalState_at_enter then _IngameFatalState_at_enter = IngameFatalState.at_enter end
	function IngameFatalState:at_enter()
		_IngameFatalState_at_enter(self)
		--ExecuteScript()
		if managers.hud then managers.hud:show_hint( { text = "IngameFatalState" } ) end 
	end
end
]]
--InGame State Incapacitated
--[[
if IngameIncapacitatedState ~= nil then
	if not _IngameIncapacitatedState_at_enter then _IngameIncapacitatedState_at_enter = IngameIncapacitatedState.at_enter end
	function IngameFatalState:at_enter()
		_IngameIncapacitatedState_at_enter(self)
		--ExecuteScript()
		if managers.hud then managers.hud:show_hint( { text = "IngameIncapacitatedState" } ) end 
	end
end
]]
------------------------------------------------------------------------------------------------------------------------
--InGame Auto Script
function ExecuteScript()
	if not _G.tSuperScriptState then
		dofile(tSuperScript.Dir .. "/tSuperScript.lua")
		_G.tSuperScriptState = true
	end
end

