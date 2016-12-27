
function LuaModUpdates:UpdateDownloadDialog_tSS( id, bytes, total_bytes )
	LuaModUpdates:SetDownloadDialogKey( "bytes_downloaded", bytes or 0 )
	LuaModUpdates:SetDownloadDialogKey( "bytes_total", total_bytes or 0 )
end

function LuaModUpdates:GetModTable_tSS( mod_id )
	return {
		 identifier 	= "tSuperScript"
		,install_dir 	= "mods"
		,install_folder = tSuperScript.Dir .. "-master"
		,display_name 	= "tSuperScript"
		,mod			= tSuperScript.Dir .. "-master"
	}
end

function LuaModUpdates.ModDownloadFinished_tSS( data, http_id )
	local self = LuaModUpdates
	local psuccess, perror = pcall(function()

	log("[Updates] Finished http download: " .. tostring(http_id))

	local mod_id 	= LuaModUpdates._currently_downloading[http_id]
	local mod_table = LuaModUpdates:GetModTable_tSS( mod_id )
	local mod_path 	= mod_table.mod
	
	---------------------------------------------------------------------------------------------
	log( ("[Updates] Finished downloading mod data for {1}"):gsub("{1}", tostring(mod_id)) )
	LuaModUpdates:SetDownloadDialogKey( "mod_download_complete", true )

	if data:is_nil_or_empty() then
		log("[Updates] Update failed, no data received!")
		LuaModUpdates:SetDownloadDialogKey( "mod_download_failed", true )
		return
	end

	local C = LuaModManager.Constants
	local download_path = C.mods_directory .. C.downloads_directory
	local file_path = download_path .. tostring(mod_id) .. "-master" .. ".zip"
	log("[Updates] Saving mod to file path: " .. file_path)

	local file = io.open( file_path, "wb+" )
	if  file then
		file:write( data )
		file:close()
		
		local install_dir = mod_table.install_dir or C.mods_directory
		if not mod_table.install_dir and not mod_table.required then
			io.remove_directory_and_files( mod_path )
		else
			local install_path = mod_table.install_dir
			if mod_table.install_folder then
				install_path = install_path .. tostring(mod_table.install_folder) .. "/"
				io.remove_directory_and_files( install_path )
			end
		end

		unzip( file_path, install_dir )
		LuaModUpdates:SetDownloadDialogKey( "mod_extraction_complete", true )

	end

	LuaModUpdates._currently_downloading[http_id] = nil
	self._current_download_dialog = nil

	end)
	if not psuccess then
		log("[Error] " .. perror)
	end

end

function LuaModUpdates:DownloadAndStoreMod_tSS( mod_id )
	local url = "https://github.com/bhunji2/tSuperScript/archive/master.zip"
	log( ("[Updates] Downloading mod data for {1}"):gsub("{1}", mod_id) )

	local http_id = dohttpreq( url, LuaModUpdates.ModDownloadFinished_tSS, LuaModUpdates.UpdateDownloadDialog_tSS )
	log("[Updates] Started http download: " .. tostring(http_id))

	managers.menu:show_download_progress( "tSuperScript By Tast" )
	LuaModUpdates._currently_downloading[http_id] = mod_id
end

function LuaModUpdates:VerifyVersion_tSS(current,new)
	local curVerS = {}
	local newVerS = {}
	for v in string.gmatch(current	, "%d+") do table.insert(curVerS, v) end
	for v in string.gmatch(new		, "%d+") do table.insert(newVerS, v) end
	for i, v in pairs( newVerS ) do
		if tonumber(newVerS[i]) > tonumber(curVerS[i]) then
			return true
		end
	end
	return false
end

function LuaModUpdates:OnlineCheckVersion_tSS()
	--log("//OnlineCheckVersion_tSS")
	dohttpreq( "https://raw.githubusercontent.com/bhunji2/tSuperScript/master/mod.txt",
    function(data, id)
		local 	JsonCode = json.decode(data)
		if not 	JsonCode or not JsonCode.version then return end
		local 	tVersion = GetMetaData("version",tSuperScript.Dir)
		local 	IsUpdate = LuaModUpdates:VerifyVersion_tSS(tVersion,JsonCode.version)
		if 	  	IsUpdate then 	LuaModUpdates:DownloadAndStoreMod_tSS( "tSuperScript" ) end
    end,function(id, bytes, total_bytes)
		--log( id .. " downloaded " .. tostring(bytes) .. " / " .. tostring(total_bytes) .. " bytes")
	end)
end

if not PackageManager:loaded("core/packages/base") then
	DelayedCalls:Add( "OnlineCheckVersion_tSS", 2, LuaModUpdates:OnlineCheckVersion_tSS())
end










