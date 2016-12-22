
for u_key,u_data in pairs(managers.enemy:all_enemies()) do
	u_data.char_tweak.has_alarm_pager = nil
	
	-- 去掉警示號
	managers.groupai:state():on_criminal_suspicion_progress(nil, u_data.unit, nil) 
	
	-- 轉換罪犯
	managers.groupai:state():convert_hostage_to_criminal( u_data.unit )
	managers.groupai:state():sync_converted_enemy( u_data.unit )
end



















