

function LootManager:add_trigger(id, type, amount, callback)
	self._triggers[type] = self._triggers[type] or {}
	self._triggers[type][id] = {amount = amount, callback = callback}
	--_G.SaveTable(callback,"callback.ini")
	
	--log(tostring(callback))
	
	--log(string.dump(callback,true))
	
	--callback
	local CB = callback
	
end