
--http://www.unknowncheats.me/forum/payday-2/115507-framing-frame-day-3-item-highlighter-finder.html
_ItemFinder = ItemFinder or false
function ItemFinder()
	if _ItemFinder then return end
	
	_ItemFinder = true
	for _, script in pairs(managers.mission:scripts()) do
		for id, element in pairs(script:elements()) do
			for _, trigger in pairs(element:values().trigger_list or {}) do
				if trigger.notify_unit_sequence == "state_outline_enabled" or trigger.notify_unit_sequence == "enable_outline" then
					element:on_executed()
				end
			end
		end
	end  
end

_runned_unit_sequence = _runned_unit_sequence or MissionManager.runned_unit_sequence
function MissionManager:runned_unit_sequence(unit, sequence, params)
	--PrintTable({ runned_unit_sequence = { unit = unit , sequence = sequence , params = params } })
	
	_runned_unit_sequence(self , unit , sequence , params)
	
	if not _ItemFinder and sequence ~= "state_outline_enabled" and sequence ~= "enable_outline" and sequence ~= "run_sequence" then
		DelayedCalls:Add( "ItemFinder" , 3, ItemFinder )
		DelayedCalls:Add( "ItemFinder2", 5, function()
			_ItemFinder = false
		end)
	end
end