dofile(tSuperScript.Dir .. "/tCommon.lua")
log("tScript TEST")

--managers.infamy:aquire_point()
--[[
dohttpreq( "http://tast.banner.tw/Steam/PayDay2Blt/CHT_MOD/mod_overrides.zip",
    function(data, id)
        log( "Retrieved server data:\n" .. tostring(data))
		
		local file = io.open( "mods/downloads/mod_overrides_CHT.zip", "wb+" )
		if file then file:write( data ) file:close() end
		
		local zip = "mods/downloads/mod_overrides_CHT.zip"
		local mods_folder = "mods/downloads"
		unzip( zip, mods_folder )
    end,
    function(id, bytes, total_bytes)
        log( id .. " downloaded " .. tostring(bytes) .. " / " .. tostring(total_bytes) .. " bytes")
    end
)
]]
--managers.skilltree:_set_points(5000)

-- core\lib\system\corepatchengine.lua
--log(Idstring("english"):s())

--[[
for i, unit in pairs(World:find_units_quick("all")) do
	log("//unit " .. tostring(unit:id()))
	if unit:id() ~= -1 then
		(unit)
		return
	end
end  
]]

local IgnoreList = { 
	  "sc_tape_loop" 	--干擾監視器?
	, "access_camera"	--觀看監視器
	, "bag_zipline"		--袋子滑索
	, "hostage_move"	--人質移動
	, "intimidate"		--威嚇
	, "hostage_stay"	--人質趴下
	, "driving_drive"	--開車
	, "ammo_bag"		--彈藥包
	, "doctor_bag"		--醫療包
	, "grenade_crate"	--榴彈包
	, "player_zipline"	--玩家滑索
	, "alaska_plane"	--阿拉司卡飛機?
	, "grenade_briefcase"--爆炸物品箱
	, "bodybags_bag"	--屍袋
	, "push_button"		--互動按鈕
	, "button_infopad"	--儀表版?
	, "money_wrap_single_bundle" --金錢傳送道?
	, "money_wrap"		--金錢傳送道?
	, "sentry_gun"		--機槍塔
	, "sentry_gun_fire_mode" --機槍塔開火模式
	
	, "are_turn_on_tv"	--未知
	, "open_slash_close"--未知
	, "open_slash_close_act"--未知
}
for _,v in pairs(managers.interaction._interactive_units) do
	if not table.contains(IgnoreList, v:interaction().tweak_data) then
		log(tostring(v:interaction().tweak_data))
	end
end





























if managers.hud then managers.hud:show_hint( { text = "Function Tested" } ) end 