if not _G.tSuperScriptSet["SecureBodyBag"] then return end
-----------------------------------
--- SECURE BODYBAGS FOR CASH v2 ---
------ Original By: Harfatus ------
---- Fix/Redo By: Sirgoodsmoke ----
--- Secure All Maps By: UC-User ---
-----------------------------------
--http://www.unknowncheats.me/forum/payday-2-a/126452-secure-bodybags-cash-v2.html

local BodyBagValue = 100 -- SET VALUE HERE
function bodybagsecure()
	if not LuaNetworking:IsHost() then return end
    -- ADDS BODY BAGS TO SECURE
	local project_instigators_original = ElementAreaTrigger.project_instigators
	function ElementAreaTrigger:project_instigators()
		project_instigators_original(self)
		if Network:is_client() then return project_instigators_original(self) end
		local instigators = project_instigators_original(self)
		if self._values.instigator == "loot" or self._values.instigator == "unique_loot" then
			local all_found = World:find_units_quick("all", 14)
			local filter_func
			if self._values.instigator == "loot" then
                    function filter_func(carry_data)
                        local carry_id = carry_data:carry_id()
						if 	carry_id == "person" or 
							carry_id == "special_person" or 
							carry_id == "gold" or 
							carry_id == "present" or 
							carry_id == "money" or 
							carry_id == "diamonds" or 
							carry_id == "coke" or 
							carry_id == "coke_pure" or 
							carry_id == "sandwich" or 
							carry_id == "weapon" or 
							carry_id == "painting" or 
							carry_id == "circuit" or 
							carry_id == "diamonds" or 
							carry_id == "engine_01" or 
							carry_id == "engine_02" or 
							carry_id == "engine_03" or 
							carry_id == "engine_04" or 
							carry_id == "engine_05" or 
							carry_id == "engine_06" or 
							carry_id == "engine_07" or 
							carry_id == "engine_08" or 
							carry_id == "engine_09" or 
							carry_id == "engine_10" or 
							carry_id == "engine_11" or 
							carry_id == "engine_12" or 
							carry_id == "meth" or 
							carry_id == "lance_bag" or 
							carry_id == "lance_bag_large" or 
							carry_id == "grenades" or 
							carry_id == "ammo" or 
							carry_id == "cage_bag" or 
							carry_id == "turret" or 
							carry_id == "artifact_statue" or 
							carry_id == "samurai_suit" or 
							carry_id == "equipment_bag" or 
							carry_id == "cro_loot1" or 
							carry_id == "cro_loot2" or 
							carry_id == "ladder_bag" or 
							carry_id == "hope_diamond" or 
							carry_id == "mus_artifact" or 
							carry_id == "mus_artifact_paint" or 
							carry_id == "winch_part" or 
							carry_id == "winch_part_e3" or 
							carry_id == "fireworks" or 
							carry_id == "evidence_bag" or 
							carry_id == "watertank_empty" or 
							carry_id == "watertank_full" or 
							carry_id == "warhead" or 
							carry_id == "paper_roll" or 
							carry_id == "counterfeit_money" or 
							carry_id == "unknown" or 
							carry_id == "safe_wpn" or 
							carry_id == "safe_ovk" or 
							carry_id == "nail_muriatic_acid" or 
							carry_id == "nail_caustic_soda" or 
							carry_id == "nail_hydrogen_chloride" or 
							carry_id == "nail_euphadrine_pills" or 
							carry_id == "safe_secure_dummy" or 
							carry_id == "din_pig" or 
							carry_id == "meth_half" or 
							carry_id == "parachute" or 
							carry_id == "equipment_bag_global_event" or 
							carry_id == "prototype" or 
							carry_id == "master_server" or 
							carry_id == "lost_artifact" or 
							carry_id == "breaching_charges" or 
							carry_id == "masterpiece_painting" then
							return true
						end
					end
                else
                    function filter_func(carry_data)
                        if tweak_data.carry[carry_data:carry_id()].is_unique_loot then return true end
                    end
                end
				
                for _, unit in ipairs(all_found) do
                    local carry_data = unit:carry_data()
                    if carry_data and filter_func(carry_data) then table.insert(instigators, unit) end
                end
            end
            return instigators
        end
        
        -- ENABLE BODY BAG SECURE ON ALL MAPS
        local on_executed_original = ElementCarry.on_executed
        function ElementCarry:on_executed(instigator)        
            if not self._values.enabled or not alive(instigator) then return end
            
            if self._values.type_filter and self._values.type_filter ~= "none" then
                if managers.loot.h_saved_filter_type == nil then managers.loot.h_saved_filter_type = self._values.type_filter end 
				--new - protect from double item remove -> crash
                local carry_ext = instigator:carry_data()
                if carry_ext ~= nil then
                    local carry_id = carry_ext:carry_id()
                    local disable_f = false
                    if carry_id == "person" and managers.loot.h_saved_filter_type == self._values.type_filter then
                        disable_f = true
                    end
                    if not disable_f then
                        if carry_id ~= self._values.type_filter then
                            return
                        end
                    end
                end
            end
            if self._values.operation == "remove" then
                if Network:is_server() then
                    local carry_ext = instigator:carry_data()
                    if carry_ext:carry_id() ~= "person" then 
							instigator:set_slot(0)
                    else	instigator:set_slot(0)	end
                end                                
            elseif self._values.operation == "add_to_respawn" then
                if Network:is_server() then
                    local carry_ext = instigator:carry_data()
                    if carry_ext ~= nil then
                        local carry_id = carry_ext:carry_id()
                        local multiplier = carry_ext:multiplier()
                        managers.loot:add_to_respawn(carry_id, multiplier)
                        instigator:set_slot(0)
                    end
                end
            elseif self._values.operation == "freeze" then
                if instigator:damage():has_sequence("freeze") then
                    instigator:damage():run_sequence_simple("freeze")
                else
                    log("[ElementCarry:on_executed] instigator missing freeze sequence"..instigator)
                end
            elseif self._values.operation == "secure" or self._values.operation == "secure_silent" then                    
                if instigator:carry_data() then
                    local carry_ext = instigator:carry_data()
                    carry_ext:disarm()
                    if Network:is_server() then
                        local silent = self._values.operation == "secure_silent"
                        local carry_id = carry_ext:carry_id()
                        local multiplier = carry_ext:multiplier()
                        managers.loot:secure(carry_id, multiplier, silent)
                    end
                    carry_ext:set_value(0)
                    if instigator:damage():has_sequence("secured") then
                        instigator:damage():run_sequence_simple("secured")
                    else
                        log("[ElementCarry:on_executed] instigator missing secured sequence"..instigator)
                    end    
                else
                    log("[ElementCarry:on_executed] instigator missing carry_data extension"..instigator)
                end
            end            
            ElementCarry.super.on_executed(self, instigator)
        end
		
        local get_bag_value_original = MoneyManager.get_bag_value
        function MoneyManager:get_bag_value(carry_id, multiplier)    
            if carry_id == "person" or carry_id == "special_person" then return BodyBagValue end        
            return get_bag_value_original(self, carry_id, multiplier)
        end
end
-- END OF SECURE BODY BAGS
-----------------------------------------------------------------------------------------------------------------------------------------
IngameWaitingForPlayersState_at_exit = IngameWaitingForPlayersState_at_exit or IngameWaitingForPlayersState.at_exit
function IngameWaitingForPlayersState:at_exit()
    IngameWaitingForPlayersState_at_exit(self)
	--[[
	--local job_id = managers.job:current_job
	local job_id = managers.job:current_real_job_id()
	if job_id ~= "framing_frame_prof" then bodybagsecure() 	end
	]]
	
	if managers.job:current_level_id() ~= "framing_frame_1" then bodybagsecure() end
end






