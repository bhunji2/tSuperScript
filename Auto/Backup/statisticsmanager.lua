function StatisticsManager:publish_to_steam(session, success, completion)
	if Application:editor() or not managers.criminals:local_character_name() then
		return
	end
	local max_ranks = 25
	local max_specializations = tweak_data.statistics:statistics_specializations()
	local session_time_seconds = self:get_session_time_seconds()
	local session_time_minutes = session_time_seconds / 60
	local session_time = session_time_minutes / 60
	if session_time_seconds == 0 or session_time_minutes == 0 or session_time == 0 then
		return
	end
	local level_list, job_list, mask_list, weapon_list, melee_list, grenade_list, enemy_list, armor_list, character_list = tweak_data.statistics:statistics_table()
	local stats = self:check_version()
	self._global.play_time.minutes = math.ceil(self._global.play_time.minutes + session_time_minutes)
	local current_time = math.floor(self._global.play_time.minutes / 60)
	local time_found = false
	local play_times = {
		1000,
		500,
		250,
		200,
		150,
		100,
		80,
		40,
		20,
		10,
		0
	}
	for _, play_time in ipairs(play_times) do
		if not time_found and current_time >= play_time then
			stats["player_time_" .. play_time .. "h"] = {
				type = "int",
				method = "set",
				value = 1
			}
			time_found = true
		else
			stats["player_time_" .. play_time .. "h"] = {
				type = "int",
				method = "set",
				value = 0
			}
		end
	end
	local current_level = managers.experience:current_level()
	stats.player_level = {
		type = "int",
		method = "set",
		value = current_level
	}
	for i = 0, 100, 10 do
		stats["player_level_" .. i] = {
			type = "int",
			method = "set",
			value = 0
		}
	end
	local level_range = current_level >= 100 and 100 or math.floor(current_level / 10) * 10
	stats["player_level_" .. level_range] = {
		type = "int",
		method = "set",
		value = 1
	}
	local current_rank = managers.experience:current_rank()
	local current_rank_range = max_ranks < current_rank and max_ranks or current_rank
	for i = 0, max_ranks do
		stats["player_rank_" .. i] = {
			type = "int",
			method = "set",
			value = 0
		}
	end
	stats["player_rank_" .. current_rank_range] = {
		type = "int",
		method = "set",
		value = 1
	}
	for i = 1, max_specializations do
		local specialization = managers.skilltree:get_specialization_value(i)
		if specialization and type(specialization) == "table" and specialization.tiers and specialization.tiers.current_tier then
			stats["player_specialization_" .. i] = {
				type = "int",
				method = "set",
				value = managers.skilltree:digest_value(specialization.tiers.current_tier)
			}
		end
	end
	local current_cash = managers.money:offshore()
	local cash_found = false
	local cash_amount = 1000000000
	current_cash = current_cash / 1000
	for i = 0, 9 do
		if not cash_found and cash_amount <= current_cash then
			stats["player_cash_" .. cash_amount .. "k"] = {
				type = "int",
				method = "set",
				value = 1
			}
			cash_found = true
		else
			stats["player_cash_" .. cash_amount .. "k"] = {
				type = "int",
				method = "set",
				value = 0
			}
		end
		cash_amount = cash_amount / 10
	end
	stats.player_cash_0k = {
		type = "int",
		method = "set",
		value = cash_found and 0 or 1
	}
	stats.gadget_used_ammo_bag = {
		type = "int",
		value = session.misc.deploy_ammo or 0
	}
	stats.gadget_used_doctor_bag = {
		type = "int",
		value = session.misc.deploy_medic or 0
	}
	stats.gadget_used_trip_mine = {
		type = "int",
		value = session.misc.deploy_trip or 0
	}
	stats.gadget_used_sentry_gun = {
		type = "int",
		value = session.misc.deploy_sentry or 0
	}
	stats.gadget_used_ecm_jammer = {
		type = "int",
		value = session.misc.deploy_jammer or 0
	}
	stats.gadget_used_first_aid = {
		type = "int",
		value = session.misc.deploy_firstaid or 0
	}
	stats.gadget_used_body_bag = {
		type = "int",
		value = session.misc.deploy_bodybag or 0
	}
	stats.gadget_used_armor_bag = {
		type = "int",
		value = session.misc.deploy_armorbag or 0
	}
	if completion then
		for weapon_name, weapon_data in pairs(session.shots_by_weapon) do
			if 0 < weapon_data.total and table.contains(weapon_list, weapon_name) then
				stats["weapon_used_" .. weapon_name] = {type = "int", value = 1}
				stats["weapon_shots_" .. weapon_name] = {
					type = "int",
					value = weapon_data.total
				}
				stats["weapon_hits_" .. weapon_name] = {
					type = "int",
					value = weapon_data.hits
				}
			end
		end
		local melee_name = managers.blackmarket:equipped_melee_weapon()
		if table.contains(melee_list, melee_name) then
			stats["melee_used_" .. melee_name] = {type = "int", value = 1}
		end
		local grenade_name = managers.blackmarket:equipped_grenade()
		if table.contains(grenade_list, grenade_name) then
			stats["grenade_used_" .. grenade_name] = {type = "int", value = 1}
		end
		local mask_id = managers.blackmarket:equipped_mask().mask_id
		if table.contains(mask_list, mask_id) then
			stats["mask_used_" .. mask_id] = {type = "int", value = 1}
		end
		local armor_id = managers.blackmarket:equipped_armor()
		if table.contains(armor_list, armor_id) then
			stats["armor_used_" .. armor_id] = {type = "int", value = 1}
		end
		local character_id = managers.network:session() and managers.network:session():local_peer():character()
		if table.contains(character_list, character_id) then
			stats["character_used_" .. character_id] = {type = "int", value = 1}
		end
		stats["difficulty_" .. Global.game_settings.difficulty] = {type = "int", value = 1}
		local specialization = managers.skilltree:get_specialization_value("current_specialization")
		if specialization >= 0 and max_specializations >= specialization then
			stats["specialization_used_" .. specialization] = {type = "int", value = 1}
		end
	end
	for weapon_name, weapon_data in pairs(session.killed_by_weapon) do
		if 0 < weapon_data.count and table.contains(weapon_list, weapon_name) then
			stats["weapon_kills_" .. weapon_name] = {
				type = "int",
				value = weapon_data.count
			}
		end
	end
	for melee_name, melee_kill in pairs(session.killed_by_melee) do
		if melee_kill > 0 and table.contains(melee_list, melee_name) then
			stats["melee_kills_" .. melee_name] = {type = "int", value = melee_kill}
		end
	end
	for grenade_name, grenade_kill in pairs(session.killed_by_grenade) do
		if grenade_kill > 0 and table.contains(grenade_list, grenade_name) then
			stats["grenade_kills_" .. grenade_name] = {type = "int", value = grenade_kill}
		end
	end
	for enemy_name, enemy_data in pairs(session.killed) do
		if 0 < enemy_data.count and enemy_name ~= "total" and table.contains(enemy_list, enemy_name) then
			stats["enemy_kills_" .. enemy_name] = {
				type = "int",
				value = enemy_data.count
			}
		end
	end
	if completion == "win_begin" then
		if Network:is_server() then
			if Global.game_settings.kick_option == 1 then
				stats.option_decide_host = {type = "int", value = 1}
			elseif Global.game_settings.kick_option == 2 then
				stats.option_decide_vote = {type = "int", value = 1}
			elseif Global.game_settings.kick_option == 0 then
				stats.option_decide_none = {type = "int", value = 1}
			end
			stats.info_playing_win_host = {type = "int", value = 1}
		else
			stats.info_playing_win_client = {type = "int", value = 1}
		end
	elseif completion == "win_dropin" then
		if not Network:is_server() then
			stats.info_playing_win_client_dropin = {type = "int", value = 1}
		end
	elseif completion == "fail" then
		if Network:is_server() then
			stats.info_playing_fail_host = {type = "int", value = 1}
		else
			stats.info_playing_fail_client = {type = "int", value = 1}
		end
	end
	if completion == "win_begin" or completion == "win_dropin" then
		stats.heist_success = {type = "int", value = 1}
	elseif completion == "fail" then
		stats.heist_failed = {type = "int", value = 1}
	end
	stats.info_playing_pc = {
		type = "int",
		method = "set",
		value = 1
	}
	local level_id = managers.job:current_level_id()
	if completion then
		if table.contains(level_list, level_id) then
			stats["level_" .. level_id] = {type = "int", value = 1}
		end
		if level_id == "election_day_2" then
			local stealth = managers.groupai and managers.groupai:state():whisper_mode()
			print("[StatisticsManager]: Election Day 2 Voting: " .. (stealth and "Swing Vote" or "Delayed Vote"))
			stats["stats_election_day_" .. (stealth and "s" or "n")] = {type = "int", value = 1}
		end
	end
	local job_id = managers.job:current_job_id()
	if table.contains(job_list, job_id) then
		stats["job_" .. job_id] = {type = "int", value = 1}
		if completion == "win_begin" then
			stats["contract_" .. job_id .. "_win"] = {type = "int", value = 1}
		elseif completion == "win_dropin" then
			stats["contract_" .. job_id .. "_win_dropin"] = {type = "int", value = 1}
		elseif completion == "fail" then
			stats["contract_" .. job_id .. "_fail"] = {type = "int", value = 1}
		end
	end
	if session.mission_stats then
		for name, count in pairs(session.mission_stats) do
			print("Mission Statistics: mission_" .. name, count)
			stats["mission_" .. name] = {type = "int", value = count}
		end
	end
	managers.network.account:publish_statistics(stats)
end
function StatisticsManager:publish_level_to_steam()
	if Application:editor() then
		return
	end
	local max_ranks = 25
	local stats = {}
	local current_level = managers.experience:current_level()
	stats.player_level = {
		type = "int",
		method = "set",
		value = current_level
	}
	for i = 0, 100, 10 do
		stats["player_level_" .. i] = {
			type = "int",
			method = "set",
			value = 0
		}
	end
	local level_range = current_level >= 100 and 100 or math.floor(current_level / 10) * 10
	stats["player_level_" .. level_range] = {
		type = "int",
		method = "set",
		value = 1
	}
	local current_rank = managers.experience:current_rank()
	local current_rank_range = max_ranks < current_rank and max_ranks or current_rank
	for i = 0, max_ranks do
		stats["player_rank_" .. i] = {
			type = "int",
			method = "set",
			value = 0
		}
	end
	stats["player_rank_" .. current_rank_range] = {
		type = "int",
		method = "set",
		value = 1
	}
	managers.network.account:publish_statistics(stats)
end
function StatisticsManager:publish_custom_stat_to_steam(name, value)
	if Application:editor() then
		return
	end
	local stats = {}
	stats[name] = {type = "int"}
	if value then
		stats[name].value = value
	else
		stats[name].method = "set"
		stats[name].value = 1
	end
	managers.network.account:publish_statistics(stats)
end
function StatisticsManager:_table_contains(list, item)
	for index, name in pairs(list) do
		if name == item then
			return index
		end
	end
end
function StatisticsManager:publish_equipped_to_steam()
	if Application:editor() then
		return
	end
	local stats = {}
	local level_list, job_list, mask_list, weapon_list, melee_list, grenade_list, enemy_list, armor_list, character_list, deployable_list = tweak_data.statistics:statistics_table()
	local mask_name = managers.blackmarket:equipped_mask().mask_id
	local mask_index = self:_table_contains(mask_list, mask_name)
	if mask_index then
		stats.equipped_mask = {
			type = "int",
			method = "set",
			value = mask_index
		}
	end
	local primary_name = managers.blackmarket:equipped_primary().weapon_id
	local primary_index = self:_table_contains(weapon_list, primary_name)
	if primary_index then
		stats.equipped_primary = {
			type = "int",
			method = "set",
			value = primary_index
		}
	end
	local secondary_name = managers.blackmarket:equipped_secondary().weapon_id
	local secondary_index = self:_table_contains(weapon_list, secondary_name)
	if secondary_index then
		stats.equipped_secondary = {
			type = "int",
			method = "set",
			value = secondary_index
		}
	end
	local melee_name = managers.blackmarket:equipped_melee_weapon()
	local melee_index = self:_table_contains(melee_list, melee_name)
	if melee_index then
		stats.equipped_melee = {
			type = "int",
			method = "set",
			value = melee_index
		}
	end
	local grenade_name = managers.blackmarket:equipped_grenade()
	local grenade_index = self:_table_contains(grenade_list, grenade_name)
	if grenade_index then
		stats.equipped_grenade = {
			type = "int",
			method = "set",
			value = grenade_index
		}
	end
	local armor_name = managers.blackmarket:equipped_armor()
	local armor_index = self:_table_contains(armor_list, armor_name)
	if armor_index then
		stats.equipped_armor = {
			type = "int",
			method = "set",
			value = armor_index
		}
	end
	local character_name = managers.blackmarket:get_preferred_character()
	local character_index = self:_table_contains(character_list, character_name)
	if character_index then
		stats.equipped_character = {
			type = "int",
			method = "set",
			value = character_index
		}
	end
	local deployable_name = managers.blackmarket:equipped_deployable()
	local deployable_index = self:_table_contains(deployable_list, deployable_name)
	if deployable_index then
		stats.equipped_deployable = {
			type = "int",
			method = "set",
			value = deployable_index
		}
	end
	managers.network.account:publish_statistics(stats)
end
function StatisticsManager:publish_skills_to_steam(skip_version_check)
	if Application:editor() then
		return
	end
	local stats = skip_version_check and {} or self:check_version()
	local skill_amount = {}
	local skill_data = tweak_data.skilltree.skills
	local tree_data = tweak_data.skilltree.trees
	for tree_index, tree in ipairs(tree_data) do
		if tree.statistics ~= false then
			skill_amount[tree_index] = 0
			for _, tier in ipairs(tree.tiers) do
				for _, skill in ipairs(tier) do
					if skill_data[skill].statistics ~= false then
						local skill_points = managers.skilltree:next_skill_step(skill)
						local skill_bought = skill_points > 1 and 1 or 0
						local skill_aced = skill_points > 2 and 1 or 0
						stats["skill_" .. tree.skill .. "_" .. skill] = {
							type = "int",
							method = "set",
							value = skill_bought
						}
						stats["skill_" .. tree.skill .. "_" .. skill .. "_ace"] = {
							type = "int",
							method = "set",
							value = skill_aced
						}
						skill_amount[tree_index] = skill_amount[tree_index] + skill_bought + skill_aced
					end
				end
			end
		end
	end
	for tree_index, tree in ipairs(tree_data) do
		if tree.statistics ~= false then
			stats["skill_" .. tree.skill] = {
				type = "int",
				method = "set",
				value = skill_amount[tree_index]
			}
			for i = 0, 35, 5 do
				stats["skill_" .. tree.skill .. "_" .. i] = {
					type = "int",
					method = "set",
					value = 0
				}
			end
			local skill_count = math.ceil(skill_amount[tree_index] / 5) * 5
			if skill_count > 35 then
				skill_count = 35
			end
			stats["skill_" .. tree.skill .. "_" .. skill_count] = {
				type = "int",
				method = "set",
				value = 1
			}
		end
	end
	local specialization = managers.skilltree:get_specialization_value("current_specialization")
	stats.player_specialization_active = {
		type = "int",
		method = "set",
		value = specialization or 0
	}
	managers.network.account:publish_statistics(stats)
end