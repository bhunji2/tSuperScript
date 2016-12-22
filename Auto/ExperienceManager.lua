
local TopXp = _G.tSuperScriptSet["GiveXP"] * 1000
if not _give_experience then _give_experience = ExperienceManager.give_experience end
function ExperienceManager:give_experience(xp)
	--log(tostring(xp))
	--if xp < TopXp then xp = TopXp end
	if xp < 1000 then xp = TopXp end
	
	local return_data = _give_experience(self,xp)
	
	--self:add_points(xp, true, false)
	--managers.skilltree:give_specialization_points(xp * 500)
	managers.upgrades:level_up() --人物等級
	managers.skilltree:level_up()
	return return_data
end