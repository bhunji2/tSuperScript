dofile(tSuperScript.Dir .. "/tCommon.lua")
log("tScript TEST")

--[[
dohttpreq( "https://github.com/bhunji2/tSuperScript/archive/master.zip",
    function(data, id)
        log( "Retrieved server data:\n" .. tostring(data))
		
		local file = io.open( "mods/downloads/master.zip", "wb+" )
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
	if not table.contains(tSuperScript.InteractIgnoreList, v:interaction().tweak_data) then
		log(tostring(v:interaction().tweak_data))
	end
end


--dofile(tSuperScript.Dir .. "Auto/update_mod.lua")

--PrintTable(LuaModUpdates:GetModTable( "CHT_MOD" ))
























if managers.hud then managers.hud:show_hint( { text = "Function Tested" } ) end 