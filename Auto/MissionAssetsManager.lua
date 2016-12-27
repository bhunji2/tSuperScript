
if not tSuperScriptFuncAuto:Get("MissionAssets") then return end

function MissionAssetsManager:is_asset_unlockable(id) 			return true end
function MissionAssetsManager:is_unlock_asset_allowed()			return true end
function MissionAssetsManager:get_asset_can_unlock_by_id(id) 	return true end