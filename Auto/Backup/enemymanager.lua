
if not _on_enemy_died then _on_enemy_died = EnemyManager.on_enemy_died end
function EnemyManager:on_enemy_died(dead_unit, damage_info)
	_G.PrintTable( dead_unit )
	dead_unit.char_tweak.has_alarm_pager = nil
	return _on_enemy_died(self,dead_unit, damage_info)
end