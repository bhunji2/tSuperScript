
if true return end

function ASP() managers.skilltree:_set_points(1000) end

function SkillTreeManager:skill_unlocked(tree, skill_id, switch_data) return true end
function SkillTreeManager:can_unlock_skill_switch(selected_skill_switch) return true, {"success"} end
function SkillTreeManager:has_skill_switch_name(skill_switch) return true end

function SkillTreeManager:reset() ASP() end
function SkillTreeManager:infamy_reset() ASP() end
function SkillTreeManager:reset_skilltrees() ASP() end
function SkillTreeManager:reset_specializations() ASP() end
function SkillTreeManager:_verify_loaded_data(points_aquired_during_load) ASP() end
function SkillTreeManager:version_reset_skilltrees(points_aquired_during_load) ASP() end






