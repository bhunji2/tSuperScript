--lib\units\contourext.lua

--Stealth Suite Beta Release v0.3
--https://www.unknowncheats.me/forum/downloads.php?do=file&id=11670
function isHostage(unit)
	if unit and alive(unit) and
		((unit.brain and unit:brain().is_hostage and unit:brain():is_hostage()) or
		(unit.anim_data and (unit:anim_data().tied or unit:anim_data().hands_tied))) then
		return true
	end
	return false
end

function IsTied(unit) return unit:brain():is_tied() end

function AddContour(unit,typeText)
	if not unit.contour then return end
	unit:contour():add( typeText ) 		
end
function RemoveContour(unit,typeText,sync) 
	if not unit.contour then return end
	unit:contour():remove( typeText,sync) 	
end

--https://www.unknowncheats.me/forum/payday-2-a/117823-standalone-xray-lua.html
   function markEnemies()
      if not toggleMark then return end
      -- MARK CAMERAS
      if LuaNetworking:IsHost() then
         for u_key, u_data in pairs( managers.groupai:state()._security_cameras ) do
            if u_data.contour then u_data:contour():add( "mark_unit" ) end
         end
      else
         for _, unit in ipairs( SecurityCamera.cameras ) do
            if unit and unit:contour() and unit:enabled() and unit:base() and not unit:base():destroyed() then
               unit:contour():add( "mark_unit" )
            end
         end
      end
      -- MARK ENEMIES
      for u_key,u_data in pairs(managers.enemy:all_enemies()) do
         if u_data.unit.contour and alive(u_data.unit) then
            u_data.unit:contour():add( "mark_enemy" )
         end
      end
      -- MARK CIVS
	  
      for u_key,u_data in pairs(managers.enemy:all_civilians()) do
		--u_data.unit:contour():add( "highlight" )
		if alive(u_data.unit) then AddContour(u_data.unit,"hostage_trade") end
		
		--[[
		if IsTied(u_data.unit) 			then 
			RemoveContour(u_data.unit,"hostage_trade",true)	
			AddContour(u_data.unit,"friendly")
		end
		
		if not IsTied(u_data.unit) 		then u_data.unit:contour():add( "hostage_trade" )	 end
		if not alive(u_data.unit) 		then u_data.unit:contour():remove( "hostage_trade" ) end
		]]
      end
   end
	
   function UnitNetworkHandler:mark_enemy( unit, marking_strength, sender ) end
   if GameSetup then
      if not _gameUpdate then _gameUpdate = GameSetup.update end
      local _gameUpdateLastMark
      function GameSetup:update(t, dt)
         _gameUpdate(self, t, dt)
         if not _gameUpdateLastMark or t - _gameUpdateLastMark > 2 then
            _gameUpdateLastMark = t
            markData()
         end
      end
   end
   
   function markData() markEnemies() end

   function markClear()
      if not inGame() then return end
      for u_key, u_data in pairs(managers.groupai:state()._security_cameras) do
         if u_data.contour then u_data:contour():remove( "mark_unit" ) end
      end
      for u_key,u_data in pairs(managers.enemy:all_enemies()) do
         if u_data.unit.contour then u_data.unit:contour():remove( "mark_enemy" ) end
      end
      for u_key,u_data in pairs(managers.enemy:all_civilians()) do
         if u_data.unit.contour then u_data.unit:contour():remove( "mark_enemy" ) end
      end
   end
   
   toggleMark = true
   markEnemies()
	--[[
   function markToggle(toggleSync)
      if not inGame() then return end
      if toggleSync then
         syncMark = not syncMark
      else
         toggleMark = not toggleMark
         if not toggleMark then markClear() end
      end
      markData()
   end

   if not toggleMark then toggleMark = false end
   if not syncMark then syncMark = false end
   markToggle()
	]]

--[[
function mark_enemies()
   local units = World:find_units_quick( "all", 3, 16, 21, managers.slot:get_mask( "enemies" ) )
   for i,unit in ipairs( units ) do
      -- Check if we are undetected still
      --if managers.groupai:state():whisper_mode() then
         -- Check if unit is not a civ
         if tweak_data.character[ unit:base()._tweak_table ].silent_priority_shout then
            managers.game_play_central:add_enemy_contour( unit, false )
            managers.network:session():send_to_peers_synched( "mark_enemy", unit, false )
         end
      --end
   end
end
 
if managers.hud then -- Check if in-game, otherwise, GameSetup class isn't prepared yet and code fails
   if not _gameUpdate then _gameUpdate = GameSetup.update end
   do
      local _gameUpdateLastMark
      function GameSetup:update( t, dt )
         _gameUpdate(self, t, dt);
       
         if not _gameUpdateLastMark or t - _gameUpdateLastMark > 9 then
            _gameUpdateLastMark = t
            mark_enemies()
         end
      end
   end
end
]]