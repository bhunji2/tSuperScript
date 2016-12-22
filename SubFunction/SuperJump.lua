---------------------------------------------------------------------------------------------------------------------------
-- Super Jump
if SuperJump == 2 then
	PlayerStandard._perform_jump = function(self, jump_vec)
		local v = math.UP * 470
		if self._running then v = math.UP * 2000 end 
		self._unit:mover():set_velocity( v )
	end
elseif SuperJump == 3 then -- Super jump (when running, you jump 1.5x high)
	function PlayerStandard:_perform_jump(jump_vec)
	   local v = math.UP * 470
	   if self._running then v = math.UP * 470 * 1.5 end
	   self._unit:mover():set_velocity( v )
	end
end