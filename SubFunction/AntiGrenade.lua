dofile(tSuperScript.Dir .. "/tCommon.lua")

-- https://www.unknowncheats.me/forum/payday-2-a/178679-disable-smoke-flash-grenade.html
-- lib/units/weapons/grenades/quickflashgrenade
if QuickFlashGrenade and tSuperScriptSet["AntiFlashGrenade"] == true then
	--showD("QuickFlashGrenade")
	function QuickFlashGrenade:_activate(state, timer, position, duration)
		--showD("QuickFlashGrenade:_activate")
		self:destroy_unit()
	end
end

-- lib/units/weapons/grenades/quicksmokegrenade
if QuickSmokeGrenade and tSuperScriptSet["AntiSmokeGrenade"] == true then
	--showD("QuickSmokeGrenade")
	function QuickSmokeGrenade:_activate(state, timer, position, duration)
		--showD("QuickSmokeGrenade:_activate")
		self:destroy()
		self._unit:set_slot(0)
	end
end