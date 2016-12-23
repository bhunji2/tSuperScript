dofile("mods/tSuperScript/tCommon.lua")
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
for _,v in pairs(managers.interaction._interactive_units) do
    log(tostring(v:interaction().tweak_data))
end



























if managers.hud then managers.hud:show_hint( { text = "Function Tested" } ) end 