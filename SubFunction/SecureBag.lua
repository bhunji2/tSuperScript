--Secure Bags 

--Host use Police no pickup
--_G.PrintTable( tweak_data.carry ) -- Host Only
for k, v in next, tweak_data.carry do
	--log(tostring(tostring(k).." - "..tostring(v)))
	if tweak_data.carry[tostring(k)].AI_carry == nil
	or tweak_data.carry[tostring(k)].AI_carry.SO_category == nil then 
	elseif tweak_data.carry[tostring(k)].AI_carry.SO_category == "enemies" then 
		tweak_data.carry[tostring(k)].AI_carry.SO_category = ""
		--log(tostring(tostring(k).." - "..tostring(v)))
		--showS(tostring(k))
	end
end

--Mulitplayer
--[[
if not _BaseInteractionExt_interact then _BaseInteractionExt_interact = BaseInteractionExt.interact end
function BaseInteractionExt:interact(player)
	_BaseInteractionExt_interact(self,player)
	if self._unit:carry_data() then SecureBag(self._unit:carry_data()._carry_id) end
end
]]

--Not working Good Buggy
function SecureBag(name) 
	local BagValue = managers.money:get_bag_value( name )
	if BagValue then managers.loot:secure( name, BagValue ,true ) end
	--showS(name.." = "..tostring(BagValue))
end
--[[
--_G.SaveTable(managers.loot:get_mandatory_bags_data(),"get_mandatory_bags_data.ini")
--_G.SaveTable(managers.loot:get_distribute(),"distribute.ini")
--_G.SaveTable(managers.loot:get_secured_mandatory_bags_amount(),"get_secured_mandatory_bags_amount.ini")
_G.SaveTable(Global.loot_manager,"Global.loot_manager.ini")
_G.SaveTable(managers.loot,"managers.loot.ini")
_G.SaveTable(managers.loot:get_mandatory_bags_data(),"get_mandatory_bags_data.ini")
_G.SaveTable(managers.loot._global.distribute,"distribute.ini")
_G.SaveTable(managers.loot:get_secured_mandatory_bags_amount(),"get_secured_mandatory_bags_amount.ini")
]]
--local get_mandatory_bags_data = managers.loot:get_mandatory_bags_data()
--if get_mandatory_bags_data then SecureBag(get_mandatory_bags_data.carry_id) end

--[[
SecureBag("money") -- (Cash)
SecureBag("gold")
SecureBag("diamonds")
SecureBag("coke")
SecureBag("meth")
SecureBag("weapons")
SecureBag("painting")
]]