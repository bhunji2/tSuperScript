local AmmoHealth		= 1		-- 子彈生命手動補滿

-- Ammo and Health
local player = managers.player:player_unit()
if alive(player) then
	player:base():replenish()
	if managers.hud then managers.hud:show_hint( { text = "replenished" } ) end
end

-- Replenish Ammo
--[[
local player_unit = managers.player:player_unit()
    for id,weapon in pairs( player_unit:inventory():available_selections() ) do
        if alive(weapon.unit) then
            weapon.unit:base():replenish()
            managers.hud:set_ammo_amount( id, weapon.unit:base():ammo_info() )
        end
        -- ADD 3 GRENADES TO INVENTORY
        managers.player:add_grenade_amount(3)
end
]]