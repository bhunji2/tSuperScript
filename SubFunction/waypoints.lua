--https://bitbucket.org/gir489/pd2-hecks/src/5807d0e273c20771750bd61599fbab9b3cfdeb18/Waypoints/?at=master

if not tSuperScriptSet["MarkObject"] then return end

-----------------------------------------
---     Waypoints by gir489 v2.7      ---
-----------------------------------------
--Credits: zephirot for Waypoints - All In One v11.2.5.
--           Sirgoodsmoke for an updated version for MVP.
--
--Changelog:    v1.0: Initial Release
--              v1.1: Fixed cash bags on Miami Heat Day 1 being too dark to see.
--                    Fixed error showing in the console when using showHUDMessages = false
--              v1.2: Fixed crash related to showHUDMessages = false when finishing a job.
--              v1.3: Removed duplicate code block for 8th index since we're no longer doing that stupid nonsense. (Forgot to do this in 1.1 and 1.2)
--                    Added Murky Station waypoints.
--                    Refactored the way doors are shown as waypoints.
--                    Refactored thermite waypoint to be on every map.
--                    Added option to show where the camera computers were as a waypoint.
--                    Refactored redundant current_level_id calls with a local level variable.
--              v1.4: Refactored Add/Remove waypoint logic to use a look up table instead of a bunch of or statements.
--                    Fixed some Door waypoints not respecting showDoors.
--                    Added Aftershock waypoints.
--              v1.5: Refactored the entire project to use additive waypoints. This will reduce flicker and increase performance.
--              v1.6: Fixed keycards attached to Civilians not being removed.
--                    Removed unncessary for loop in remove_waypoint.
--                    Fixed some special events in remove_unit callback not properly refreshing.
--                    Fixed torch/thermite not showing if the civilian was frightened or cuffed.
--             v1.61: Reverted Civilian alive check since it didn't work.
--             v1.62: Fixed civilian keycard waypoint not working.
--             v1.63: Fixed civilian keycard waypoint not being removed properly when cuffing them.
--              v1.7: Added drills for the showDrills boolean.
--             v1.71: Fixed chems not working.
--             v1.72: Fixed dockyard causing a crash.
--              v1.8: Fixed Big Bank showing too many keyboards for the host.
--                    Fixed hard drive place location still showing on Murky Station after placing the hard drive.
--                    Fixed Framing Frame Day 3 waypoints not working properly.
--                    Added pig for slaughterhouse.
--              v1.9: Reduxed Alesso heist C4 waypoint in to an X icon where the doors are.
--                    Fixed remove_all_waypoints using a redundant waypoint member when it could've been using it from the for loop variables.
--              v2.0: Added door waypoint to Alesso heist instead of a cross that removes itself when you open the door.
--                    Added Counterfeit waypoints.
--                    Fixed spelling errors in the changelog.
--              v2.1: Added support to see the goats on Day 1 Goat Simulator heist if you are the host.
--            v2.1.1: Added support to see the goats on Day 1 Goat Simulator heist when the user is a client.
--              v2.2: Fixed garbage Meltdown waypoints from predecessor.
--                    Fixed a crash with Big Oil Day 2 when not the host.
--                    Added code to update the waypoint of a vehicle as it moves.
--                    Added more meaningful comments.
--              v2.3: Added support for Beneath The Mountain.
--                    Fixed some waypoints showing as money when they were mission items.
--                    Genericized some waypoints to only look for a partial name.
--              v2.4: Fixed carpet waypoint on Miami Heat Day 1.
--                    Genericized gas can waypoint.
--              v2.5: Fixed Miami Heat Day 1 showing the door and Big Bank showing the keyboard after it was relevant.
--                    Changed some crosshair icons to relevant icons.
--              v2.6: Added support to show where the voting machines for Election Day 2 are at the cost of everyone seeing them.
--                    Added sheaterNewb boolean which will let the user determine if they want to be risque with Goat Simulator/Election Day 2.
--                    Added comments next to the configuration booleans.
--                    Fixed some grammatical errors with the comments and change log.
--              v2.7: Removed The Diamond stepping stone waypoints since they didn't work at all for me.
--                    Refactored some of the logic to ignore ungrabbales from The Diamond.
--                    Fixed a crash when the user was the host on Big Oil Day 2 and they dropped the engine.
--Configuration
local showDistance        = false --Show distance below waypoint icon.
local showGagePackages    = true --Show gage packages.
local showPlanks          = true --Show wood planks you put on the windows.
local showSmallLoot       = true --Show small loot.
local showCrates          = true --Show loot crates as waypoints.
local showDoors           = true --Show doors,
local showCameraComputers = true --Show where the camera interface terminals are.
local showDrills          = true --Show all drill locations on the map.
local showThermite        = true --Show thermite use locations
local showSewerManhole    = true --Show sewer manhole covers on maps that use them.
local showHUDMessages     = false --Display a message on the HUD with information pertaining to the waypoints.
local makeNoise           = false --Make a tick noise when you toggle the script.
local iterativeToggle     = true --Setting this to false will make it show all the waypoints when initially turned on. Setting it to true will try to group it.
local sheaterNewb         = true --This means you are willing to do some extra things that everyone can see, but will help you see certain mission elements

--Define various colors
local alpha_value   = 200    -- (0->255)
local white         = Color(         100, 255, 255, 255 ) / 255
local bone_white    = Color( alpha_value, 255, 238, 151 ) / 255
local magenta       = Color( alpha_value, 255, 000, 255 ) / 255
local purple        = Color( alpha_value, 154, 068, 220 ) / 255
local matte_purple  = Color( alpha_value, 107, 084, 144 ) / 255
local pink          = Color( alpha_value, 255, 122, 230 ) / 255
local light_gray    = Color( alpha_value, 191, 191, 191 ) / 255
local gray          = Color( alpha_value, 128, 128, 128 ) / 255
local dark_gray     = Color( alpha_value, 064, 064, 064 ) / 255
local orange        = Color( alpha_value, 255, 094, 015 ) / 255
local light_brown   = Color( alpha_value, 204, 115, 035 ) / 255
local bright_yellow = Color( alpha_value, 255, 207, 076 ) / 255
local brown         = Color( alpha_value, 128, 070, 013 ) / 255
local gold          = Color(         255, 255, 215, 000 ) / 255
local yellow        = Color( alpha_value, 255, 255, 000 ) / 255
local warm_yellow   = Color( alpha_value, 250, 157, 007 ) / 255
local red           = Color( alpha_value, 255, 000, 000 ) / 255
local blood_red     = Color( alpha_value, 138, 017, 009 ) / 255
local coral_red     = Color( alpha_value, 213, 036, 053 ) / 255
local dark_red      = Color( alpha_value, 110, 015, 022 ) / 255
local blue          = Color( alpha_value, 000, 000, 255 ) / 255
local gray_blue     = Color( alpha_value, 012, 068, 084 ) / 255
local navy_blue     = Color( alpha_value, 040, 052, 086 ) / 255
local matte_blue    = Color( alpha_value, 056, 097, 168 ) / 255
local light_blue    = Color( alpha_value, 126, 198, 238 ) / 255
local cobalt_blue   = Color( alpha_value, 000, 093, 199 ) / 255
local turquoise     = Color( alpha_value, 000, 209, 157 ) / 255
local cyan          = Color( alpha_value, 000, 255, 255 ) / 255
local green         = Color( alpha_value, 000, 255, 000 ) / 255
local lime_green    = Color( alpha_value, 000, 166, 081 ) / 255
local leaf_green    = Color( alpha_value, 104, 191, 054 ) / 255
local olive_green   = Color( alpha_value, 072, 090, 050 ) / 255
local dark_green    = Color( alpha_value, 007, 061, 009 ) / 255
local toxic_green   = Color( alpha_value, 167, 248, 087 ) / 255

-- INGAME CHECK
function inGame()
	if not game_state_machine then return false end
	return string.find(game_state_machine:current_state_name(), "game")
end

-- IS PLAYING CHECK
function isPlaying()
	if not BaseNetworkHandler then return false end
	return BaseNetworkHandler._gamestate_filter.any_ingame_playing[ game_state_machine:last_queued_state_name() ]
end

-- HOST CHECK
function isHost()
	if not Network then return false end
	return not Network:is_client()
end

-- CLIENT CHECK
function isClient()
	if not Network then return false end
	return Network:is_client()
end

-- BEEP
function beep()
	if managers and managers.menu_component and makeNoise then
		managers.menu_component:post_event("menu_enter")
	end
end

function RefreshTest()
	if pcall(RefreshItemWaypoints) then
		-- no errors
	else
		managers.chat:_receive_message(1, "AN ERROR OCCURRED.", "...", Color.red)
	end
end

function add_waypoint(unit, prefab, appendage, icon)
	if ( unit:interaction()._waypoint_id == nil ) then
		local waypoint_id = prefab .. appendage
		managers.hud:add_waypoint( waypoint_id, { icon = icon, distance = showDistance, position = unit:interaction():interact_position(), no_sync = true, present_timer = 0, state = "present", radius = 800, color = Color.white, blend_mode = "add" }  )
		unit:interaction()._waypoint_id = tostring(waypoint_id)
		local waypoint = managers.hud._hud.waypoints[waypoint_id]
		if ( waypoint ) then
			waypoint._unit = unit
		end
	end
end

function remove_waypoint(unit)
	local waypoint_id = unit:interaction()._waypoint_id
	local waypoint = managers.hud._hud.waypoints[waypoint_id]
	if ( waypoint and waypoint._unit ) then
		waypoint._unit:interaction()._waypoint_id = nil
		managers.hud:remove_waypoint( waypoint_id )
	end
end

function remove_all_waypoints()
	for id,waypoint in pairs( managers.hud._hud.waypoints ) do
		id = tostring(id)
		if id:sub(1,5) == 'hudz_' then
			if ( waypoint._unit ) then
				waypoint._unit:interaction()._waypoint_id = nil
			end
			managers.hud:remove_waypoint( id )
		end
	end
end

function RefreshMsg()
	local level = managers.job:current_level_id()
	if _toggleWaypointAIO2 > 0 and showHUDMessages == true then
		local xval = RenderSettings.resolution.x
		local yval = RenderSettings.resolution.y
		local txtsize = 10
		if xval >= 600 and xval < 800 then txtsize = 10 elseif xval >= 800 and xval < 1024 then txtsize = 15 elseif xval >= 1024 and xval < 1280 then txtsize = 20 elseif xval >= 1280 and xval < 1360 then txtsize = 25 elseif xval >= 1360 and xval < 1440 then txtsize = 30 elseif xval >= 1440 and xval < 1600 then txtsize = 35 elseif xval >= 1600 and xval < 1920 then txtsize = 40 elseif xval >= 1920 and xval < 2400 then	txtsize = 45 else txtsize = 40 end
		if not _HDmsg then
			_HDmsg = {}
			_HDmsg.ws = Overlay:newgui():create_screen_workspace()
			_HDmsg.lbl = _HDmsg.ws:panel():text{ name="lbl_1", x = -(RenderSettings.resolution.x / 2.1) + 0.5 * RenderSettings.resolution.x, y = -(RenderSettings.resolution.y / 4) + 6.1/9 * RenderSettings.resolution.y, text = "", font = tweak_data.menu.pd2_large_font, font_size = txtsize, color = Color.white:with_alpha(0.7), layer = 1 }
			_HDmsg.lbl2 = _HDmsg.ws:panel():text{ name="lbl_2", x = -(RenderSettings.resolution.x / 2.1) + 0.5 * RenderSettings.resolution.x, y = -(RenderSettings.resolution.y / 4) + 5.6/9 * RenderSettings.resolution.y, text = "Waypoint", font=tweak_data.menu.pd2_large_font, font_size = txtsize, color = Color.green:with_alpha(0.7), layer = 1 }
			_HDmsg.lbl:show()
			_HDmsg.lbl2:show()
		end
		local mess = ""
		if _toggleWaypointAIO2 == 1 then
			local unit_list = World:find_units_quick( "all" )
			local count = 0
			for _,unit in ipairs( unit_list ) do
				if ( tostring(unit:name()) == "Idstring(@IDe8088e3bdae0ab9e@)" or	--Yellow Package
				tostring(unit:name()) == "Idstring(@ID05956ff396f3c58e@)" or		--Blue Package
				tostring(unit:name()) == "Idstring(@IDc90378ad89058c7d@)" or		--Purple Package
				tostring(unit:name()) == "Idstring(@ID96504ebd40f8cf98@)" or		--Red Package
				tostring(unit:name()) == "Idstring(@IDb3cc2abe1734636c@)" ) then 	--Green Package
					count = count + 1
				end
			end
			mess = "[1/8] PACKAGE : "..tostring(count)
			_HDmsg.lbl:set_text(mess)
		elseif _toggleWaypointAIO2 == 2 then
			mess = "[2/8] KEYCARD/SECURITY DOOR"
			_HDmsg.lbl:set_text(mess)
		elseif _toggleWaypointAIO2 == 3 then
			mess = "[3/8] WEAPON/COKE"
			_HDmsg.lbl:set_text(mess)
		elseif _toggleWaypointAIO2 == 4 then
			mess = "[4/8] PLANK/DRILL"
			_HDmsg.lbl:set_text(mess)
		elseif _toggleWaypointAIO2 == 5 then
			mess = "[5/8] CRATE/CROWBAR"
			_HDmsg.lbl:set_text(mess)
		elseif _toggleWaypointAIO2 == 6 then
			if level == "framing_frame_1" or level == "gallery" then
				mess = "[6/8] PAINTING"
			elseif level == "framing_frame_3" then
				mess = "[6/8] INTEL"
			elseif level == "alex_1" then
				mess = "[6/8] CHEMICAL"
			elseif level == "alex_2" then
				mess = "[6/8] SAFE"
			elseif level == "election_day_1" then
				mess = "[6/8] COMPUTER/TRUCK"
			elseif level == "big" then
				mess = "[6/8] KEYBOARD/SERVER"
			elseif level == "firestarter_2" then
				mess = "[6/8] SECURITY BOX"
			elseif level == "welcome_to_the_jungle_1" then
				mess = "[6/8] INTEL"
			elseif level == "kosugi" then
				mess = "[6/8] MANHOLE/ITEM"
			elseif level == "welcome_to_the_jungle_2" then
				mess = "[6/8] ENGINE/SERVER ROOM"
			elseif level == "arm_for" then
				mess = "[6/8] TURRET"
			elseif level == "election_day_3_skip1" then
				mess = "[6/8] KEYBOARD"
			elseif level == "ukrainian_job" then
				mess = "[6/8] POWER/TIARA"
			elseif level == "mus" then
				mess = "[6/8] BOX/PATH/SECURITY"
			else
				mess = "[6/8] WAYPOINTS"
			end
			_HDmsg.lbl:set_text(mess)
		elseif _toggleWaypointAIO2 == 7 then
			mess = "[7/8] MONEY"
			_HDmsg.lbl:set_text(mess)
		elseif _toggleWaypointAIO2 == 8 then
			mess = "[8/8] ALL"
			_HDmsg.lbl:set_text(mess)
		end
	end
end

if inGame() and isPlaying() then
	local level = managers.job:current_level_id()
	--Setup custom icons for extra 420 dank memeage. (IF you know what I meme.)
	if ( tweak_data.hud_icons.pd2_nuke == nil ) then
		tweak_data.hud_icons.pd2_nuke = {
			texture = "guis/textures/pd2/lootscreen/loot_cards",
			texture_rect = {
				48,
				56,
				30,
				66
			}
		}
		tweak_data.hud_icons.padlock = {
		texture = "guis/textures/pd2/hud_icon_padlockbox",
		texture_rect = {
			5,
			4,
			23,
			25
			}
		}
	end
	if not _toggleWaypointAIO2 then _toggleWaypointAIO2 = 0 end
	if iterativeToggle == false then
		if ( _toggleWaypointAIO2 < 8 ) then
			_toggleWaypointAIO2 = 8
		else
			_toggleWaypointAIO2 = _toggleWaypointAIO2 + 1
		end
	else
		_toggleWaypointAIO2 = _toggleWaypointAIO2 + 1
	end
	_keyboard_used = _keyboard_used or false
	_engine_used = _engine_used or false
	_intel_used = _intel_used or false
	bo_boxes = bo_boxes or {}
	SecBox1 = SecBox1
	SecBox2 = SecBox2
	correct_id = correct_id or nil
	engine_pos = engine_pos or nil
	values = values or nil
	_box1_used = _box1_used or false
	_box2_used = _box2_used or false
	_drill1_used = _drill1_used or false
	_drill2_used = _drill2_used or false
	_drill3_used = _drill3_used or false
	_tiara_used = _tiara_used or false
	_FF1_msg = _FF1_msg or false
	_FF3_used = _FF3_used or false
	_gps_used = _gps_used or false
	_comp_used = _comp_used or false
	_bomb_ok = _bomb_ok or false
	_bomb_pos = _bomb_pos or nil
	_bomb_used = _bomb_used or 0
	_uldatabase_found = _uldatabase_found or false
	_script_activated = _script_activated or 0
	tabclk = tabclk or {}
	clientBox = clientBox or {}
	clientSucceed = clientSucceed or 0
	cm = managers.controller
	nb = nb or 0
	lp = lp or false
	Color.orange = Color("FF8800")
	if (showHUDMessages == true) then
		if not _HDmsg then
			_HDmsg = {}
			_HDmsg.ws = Overlay:newgui():create_screen_workspace()
			local xval = RenderSettings.resolution.x
			local yval = RenderSettings.resolution.y
			local txtsize = 10
			if xval >= 600 and xval < 800 then txtsize = 10 elseif xval >= 800 and xval < 1024 then txtsize = 15 elseif xval >= 1024 and xval < 1280 then txtsize = 20 elseif xval >= 1280 and xval < 1360 then txtsize = 25 elseif xval >= 1360 and xval < 1440 then txtsize = 30 elseif xval >= 1440 and xval < 1600 then txtsize = 35 elseif xval >= 1600 and xval < 1920 then txtsize = 40 elseif xval >= 1920 and xval < 2400 then	txtsize = 45 else txtsize = 40 end
			_HDmsg.lbl = _HDmsg.ws:panel():text{ name="lbl_1", x = -(RenderSettings.resolution.x / 2.1) + 0.5 * RenderSettings.resolution.x, y = -(RenderSettings.resolution.y / 4) + 6.1/9 * RenderSettings.resolution.y, text = "", font = tweak_data.menu.pd2_large_font, font_size = txtsize, color = Color.white:with_alpha(0.7), layer = 1 }
			_HDmsg.lbl2 = _HDmsg.ws:panel():text{ name="lbl_2", x = -(RenderSettings.resolution.x / 2.1) + 0.5 * RenderSettings.resolution.x, y = -(RenderSettings.resolution.y / 4) + 5.6/9 * RenderSettings.resolution.y, text = "Waypoint", font=tweak_data.menu.pd2_large_font, font_size = txtsize, color = Color.green:with_alpha(0.7), layer = 1 }
			_HDmsg.lbl3 = _HDmsg.ws:panel():text{ name="lbl_3", x = -(RenderSettings.resolution.x / 2.1) + 0.5 * RenderSettings.resolution.x, y = -(RenderSettings.resolution.y / 4) + 6.6/9 * RenderSettings.resolution.y, text = "", font=tweak_data.menu.pd2_large_font, font_size = txtsize, color = Color.white:with_alpha(0.7), layer = 1 }
			_HDmsg.lbl4 = _HDmsg.ws:panel():text{ name="lbl_4", x = -(RenderSettings.resolution.x / 2.1) + 0.5 * RenderSettings.resolution.x, y = -(RenderSettings.resolution.y / 4) + 7.1/9 * RenderSettings.resolution.y, text = "", font=tweak_data.menu.pd2_large_font, font_size = txtsize, color = Color.red:with_alpha(0.7), layer = 1 }
			_HDmsg.lbl:show()
			_HDmsg.lbl2:show()
			_HDmsg.lbl3:show()
			_HDmsg.lbl4:show()
		end
	end
	keyboard = Input:keyboard()
	if keyboard:pressed() ~= nil then
		beep()
		_script_activated = os.clock()
		-- Framing Frame Day 1
		if level == 'framing_frame_1' or level == "gallery" then
			if _FF1_msg == false then
				local unit_list = World:find_units_quick( "all" )
				local count = 0
				for _,unit in ipairs( unit_list ) do
					if unit:carry_data() then --or unit:base() then
						if (unit:interaction():active() == true) then
							count = count + 1
						end
					end
				end
				if count == 9 then
					managers.chat:_receive_message(1, "Bain", "Guys, I have detected "..count.." paintings in the gallery. That's great. Maximum profits!", tweak_data.system_chat_color)
				elseif count == 8 then
					managers.chat:_receive_message(1, "Bain", "Guys, there are "..count.." paintings in the gallery.", tweak_data.system_chat_color)
				elseif count == 7 then
					managers.chat:_receive_message(1, "Bain", "Guys, "..count.." paintings are in the gallery. Not much compared with last time!", tweak_data.system_chat_color)
				elseif count == 6 or count < 6 then
					managers.chat:_receive_message(1, "Bain", "Guys, only "..count.." paintings detected in the gallery this time.. Better than nothing!", tweak_data.system_chat_color)
				end
				_FF1_msg = true
			end
		end
	end

	--Replace the color of the waypoint varying on the title of the ID.
	managers.hud.__update_waypoints = managers.hud.__update_waypoints or managers.hud._update_waypoints
	function HUDManager:_update_waypoints( t, dt )
		local result = self:__update_waypoints(t,dt)
		for id,data in pairs( self._hud.waypoints ) do
			id = tostring(id)
			data.move_speed = 0.01
			if ( id:sub(1,9) == 'hudz_car_' ) then
				data.position = data._unit:interaction():interact_position() --[[This will keep the waypoint on the vehicle]]
				data.bitmap:set_color( white )
			end
			local LSD 			= 	Color(1,math.sin(140 * os.clock() + 0) / 2 + 0.5, math.sin(140 * os.clock() + 60) / 2 + 0.5, math.sin(140 * os.clock() + 120) / 2 + 0.5)
			local FIRE 			= 	Color(1,math.sin(135 * os.clock() + 0) / 2 + 1.5, math.sin(140 * os.clock() + 60) / 2 + 0.5, 0)
			----------- COLORED WAYPOINTS ---------------

			if id:sub(1,10) == 'hudz_base_' or id:sub(1,9) == 'hudz_box_' then
				data.bitmap:set_color( white )
			end
			-- KEYCARD FLOOR
			if id:sub(1,9) == 'hudz_key_' then
				data.bitmap:set_color( yellow )
			end
			-- KEYCARD CIV
			if id:sub(1,9) == 'hudz_civ_' then
				data.bitmap:set_color( orange )
			end
			-- KEYCARD COP
			if id:sub(1,9) == 'hudz_cop_' then
				data.bitmap:set_color( cobalt_blue )
			end
			-- WEAPON
			if id:sub(1,9) == 'hudz_wpn_' then
				data.bitmap:set_color( magenta )
			end
			-- GOLD/JEWEL
			if id:sub(1,10) == 'hudz_gold_' then
				data.bitmap:set_color( gold )
			end
			-- SMALL LOOT
			if id:sub(1,10) == 'hudz_cash_' then
				data.bitmap:set_color( dark_green )
			end
			-- MONEY (BAG)
			if id:sub(1,11) == 'hudz_cashB_' then
				data.bitmap:set_color( green )
			end
			-- COKE
			if id:sub(1,10) == 'hudz_coke_' then
				data.bitmap:set_color( LSD )
			end
			-- PAINTING
			if id:sub(1,9) == 'hudz_ptn_' then
				data.bitmap:set_color( green )
			end
			-- PACKAGE
			if id:sub(1,10) == 'hudz_pkgY_' then
				data.bitmap:set_color( yellow )
			elseif id:sub(1,10) == 'hudz_pkgB_' then
				data.bitmap:set_color( blue )
			elseif id:sub(1,10) == 'hudz_pkgP_' then
				data.bitmap:set_color( magenta )
			elseif id:sub(1,10) == 'hudz_pkgR_' then
				data.bitmap:set_color( red )
			elseif id:sub(1,10) == 'hudz_pkgG_' then
				data.bitmap:set_color( green )
			end
			-- PLANK
			if id:sub(1,9) == 'hudz_plk_' then
				data.bitmap:set_color( green )
			end
			-- METHLAB
			if id:sub(1,11) == 'hudz_coke1_' then
				data.bitmap:set_color( white )
			elseif id:sub(1,11) == 'hudz_coke2_' then
				data.bitmap:set_color( green )
			elseif id:sub(1,11) == 'hudz_coke3_' then
				data.bitmap:set_color( yellow )
			end
			-- THERMITE/GASCAN/SECURITYDOOR
			if id:sub(1,10) == 'hudz_fire_' then
				data.bitmap:set_color( FIRE )
			end
			-- ATM
			if id:sub(1,9) == 'hudz_atm_' then
				data.bitmap:set_color( blood_red )
			end
			-- DOOR
			if id:sub(1,10) == 'hudz_door_' then
				data.bitmap:set_color( cyan )
			end
			if id:sub(1,10) == 'hudz_Robj_' then
				data.bitmap:set_color( green )
			end
			if id:sub(1,10) == 'hudz_Wobj_' then
				data.bitmap:set_color( red )
			end
		end
		return result
	end

	function RefreshItemWaypoints(doRemove)
		if inGame() and isPlaying() then
			--clear all created waypoints
			if ( doRemove ) then
				remove_all_waypoints()
			end
			if _toggleWaypointAIO2 > 0 then
				local level = managers.job:current_level_id()
				--create new waypoints for remaining items
				local missionId = nil
				for i,_ in pairs(managers.objectives:get_active_objectives()) do
					local missionString = tostring(i)
					if ( missionId == nil ) then
						missionId = tonumber(string.match(missionString, "%d+"))
					end
				end
				if ( level == "dark" ) then
					local unit_list = World:find_units_quick( "all" )
					for key,unit in ipairs( unit_list ) do
						if _toggleWaypointAIO2 == 2 or _toggleWaypointAIO2 == 8 then
							if ( tostring(unit:name()) == "Idstring(@ID5422d8b99c7c1b57@)" ) then --Keycard
								if ( unit:interaction()._is_selected == nil ) then
									add_waypoint(unit, 'hudz_key_', key, 'equipment_bank_manager_key')
								end
							end
							if ( tostring(unit:name()) == "Idstring(@ID9c0e4f7e2193a163@)" ) then --Hard drive place point
								local foundUnits = World:find_units_quick( "sphere", unit:interaction():interact_position(), 35, managers.slot:get_mask("all") )
								for _,camera in ipairs( foundUnits ) do
									if ( camera:interaction() and camera:interaction():active() == true and camera:interaction().tweak_data == 'access_camera_y_axis' )then
										if (unit:interaction():active() == true) then
											add_waypoint(unit, 'hudz_door_', key, 'equipment_harddrive')
										end
									end
								end
							end
						end
						if _toggleWaypointAIO2 == 6 or _toggleWaypointAIO2 == 8 then
							if ( tostring(unit:name()) == "Idstring(@IDc93d932bbb0d9d13@)" ) then 	--Blow torch
								local foundUnits = World:find_units_quick( "sphere", unit:interaction():interact_position(), 100, managers.slot:get_mask("civilians") )
								for _,civilian in ipairs( foundUnits ) do
									if (civilian:brain():is_active()) then
										if ( unit:interaction()._is_selected == nil ) then
											add_waypoint(unit, 'hudz_pkgB_', key, 'equipment_blow_torch')
										end
									end
								end
							end
							if ( tostring(unit:name()) == "Idstring(@ID29c64eba7ea1bb4f@)" ) then 	--Thermite
								local foundUnits = World:find_units_quick( "sphere", unit:interaction():interact_position(), 100, managers.slot:get_mask("civilians") )
								for _,civilian in ipairs( foundUnits ) do
									if (civilian:brain():is_active()) then
										if ( unit:interaction()._is_selected == nil ) then
											add_waypoint(unit, 'hudz_base_', key, 'equipment_thermite')
										end
									end
								end
							end
						end
					end
				end
				--ALESSO HEIST
				if ( level == 'arena' ) then
					local unit_list = World:find_units_quick( "all" )
					for key,unit in ipairs( unit_list ) do
						if _toggleWaypointAIO2 == 6 or _toggleWaypointAIO2 == 8 then
							if ( tostring(unit:name()) == "Idstring(@IDcbae338a885f1432@)") then --X mark on the wall near the mission doors
								local foundUnits = World:find_units_quick( "sphere", unit:position(), 200, managers.slot:get_mask("all") )
								for _,foundUnit in ipairs( foundUnits ) do
									if ( foundUnit:interaction() and foundUnit:interaction().tweak_data == "pick_lock_hard_no_skill_deactivated" ) then
										if (foundUnit:interaction()._active == true) then
											add_waypoint(foundUnit, 'hudz_pkgR_', key, 'wp_door')
											showDoors = false --Don't show the regular doors despite what the client wants, because it would be too much information.
										end
									end
								end
							end
						end
					end
				end
				--GOAT SIMULATOR
				if ( level == 'peta' and sheaterNewb ) then
					if _toggleWaypointAIO2 == 6 or _toggleWaypointAIO2 == 8 then
						for _, script in pairs(managers.mission:scripts()) do
							for _,element in pairs(script:elements()) do
								local name = element:editor_name()
								if ( name == "show_outlines" ) then
									--The follow code highlights the goat so a waypoint can be placed.
									if ( isHost() ) then
										element:on_executed(managers.player:player_unit())
									else
										managers.network:session():send_to_host("to_server_mission_element_trigger", element:id(), managers.player:player_unit())
									end
								end
							end
						end
					end
				end
				--ELECTION DAY 2 (WAREHOUSE)
				if ( level == 'election_day_2' and sheaterNewb ) then
					if _toggleWaypointAIO2 == 6 or _toggleWaypointAIO2 == 8 then
						for _, script in pairs(managers.mission:scripts()) do
							for _,element in pairs(script:elements()) do
								local name = element:editor_name()
								if ( string.find(name, "crate_opened" ) ) then
									--This mission script has code to unhide the voting machines.
									if ( isHost() ) then
										element:on_executed(managers.player:player_unit())
									else
										managers.network:session():send_to_host("to_server_mission_element_trigger", element:id(), managers.player:player_unit())
									end
									showCrates = false
								end
							end
						end
					end
				end
				--MELTDOWN
				if ( level == 'shoutout_raid' ) then
					local unit_list = World:find_units_quick( "all" )
					for key,unit in ipairs( unit_list ) do
						if _toggleWaypointAIO2 == 6 or _toggleWaypointAIO2 == 8 then
							if ( tostring(unit:name()) == "Idstring(@IDaec3f706a76625a8@)") then --Nuke boxes
								add_waypoint(unit, 'hudz_pkgR_', key, 'pd2_nuke')
							end
						end
					end
				end
				--BENEATH THE MOUNTAIN
				if ( level == 'pbr' ) then
					local unit_list = World:find_units_quick( "all" )
					for key,unit in ipairs( unit_list ) do
						if _toggleWaypointAIO2 == 6 or _toggleWaypointAIO2 == 8 then
							if ( tostring(unit:name()) == "Idstring(@IDf11234ccd3e2d814@)") then --Bars in front of the paintings
								local foundUnits = World:find_units_quick( "sphere", unit:position(), 200, managers.slot:get_mask("all") )
								for foundKey,foundUnit in ipairs( foundUnits ) do
									if ( foundUnit:interaction() and foundUnit:interaction().tweak_data == "hold_take_painting" ) then
										add_waypoint(foundUnit, 'hudz_ptn_', foundKey, 'equipment_ticket')
									end
								end
							end
						end
					end
				end
				--HOTLINE MIAMI
				if ( level == 'mia_1' and missionId ) then
					if ( missionId == 19 or missionId < 6 ) then
						local unit_list = World:find_units_quick( "all" )
						local carpetAlreadyFound = false
						for key,unit in ipairs( unit_list ) do
							if _toggleWaypointAIO2 == 6 or _toggleWaypointAIO2 == 8 then
								if (unit:interaction() and unit:interaction().tweak_data == "hlm_roll_carpet" ) then
									carpetAlreadyFound = true
								end
								if ( tostring(unit:name()) == "Idstring(@ID0ff3ba27d5862ba2@)" and carpetAlreadyFound == false ) then --Hatch
									local foundUnits = World:find_units_quick( "sphere", unit:position(), 200, managers.slot:get_mask("all") )
									for foundKey,foundUnit in ipairs( foundUnits ) do
										if ( tostring(foundUnit:name()) == "Idstring(@ID2c1e5738c0ad2f85@)") then --Door
											managers.hud:add_waypoint( 'hudz_base_hlm1door', { icon = 'pd2_door', distance = showDistance, position = foundUnit:position(), no_sync = true, present_timer = 0, state = "present", radius = 800, color = Color.white, blend_mode = "add" }  )
										end
									end
								end
							end
						end
					end
				end
				if _toggleWaypointAIO2 == 2 or _toggleWaypointAIO2 == 8 then
					-- CIVS WITH KEYCARDS
					for u_key,u_data in pairs(managers.enemy:all_civilians()) do
						local player_pos = Vector3(0,0,0)  -- managers.player:player_unit():camera():position()
						local unit_pos = u_data.unit:movement():m_head_pos()
						if isHost() and (u_data.unit.contour and alive(u_data.unit)) and u_data.unit:character_damage():pickup() then
							local ray = World:raycast("ray", player_pos, unit_pos, "slot_mask", managers.slot:get_mask( "AI_visibility" ), "ray_type", "ai_vision", "ignore_unit", { u_data.unit } )
							if (ray and ray.unit) then
								local cHealth = u_data.unit:character_damage() and u_data.unit:character_damage()._health
								if cHealth then
									local full = u_data.unit:character_damage()._HEALTH_INIT
									if full and (cHealth > 0.6) then -- ALIVE
										if ( level == "jolly" ) then --AFTERSHOCK
											managers.hud:add_waypoint( 'hudz_civ_'..tostring(unit_pos), { icon = 'equipment_briefcase', distance = showDistance, position = unit_pos, no_sync = true, present_timer = 0, state = "present", radius = 800, color = orange, blend_mode = "add" }  )
										else
											managers.hud:add_waypoint( 'hudz_civ_'..tostring(unit_pos), { icon = 'equipment_bank_manager_key', distance = showDistance, position = unit_pos, no_sync = true, present_timer = 0, state = "present", radius = 800, color = orange, blend_mode = "add" }  )
										end
									end
								end
							end
						end
					end
					-- COPS WITH KEYCARDS
					for u_key, u_data in pairs(managers.enemy:all_enemies()) do
						local player_pos = Vector3(0,0,0) -- managers.player:player_unit():camera():position()
						local unit_pos = u_data.unit:movement():m_head_pos()
						if isHost() and u_data.unit.contour and alive(u_data.unit) and u_data.unit:character_damage():pickup() and u_data.unit:character_damage():pickup() ~= "ammo" then
							local ray = World:raycast("ray", player_pos, unit_pos, "slot_mask", managers.slot:get_mask( "AI_visibility" ), "ray_type", "ai_vision", "ignore_unit", { u_data.unit } )
							if (ray and ray.unit) then
								local cHealth = u_data.unit:character_damage() and u_data.unit:character_damage()._health
								if cHealth then
									local full = u_data.unit:character_damage()._HEALTH_INIT
									if full and (cHealth > 0.6) then -- ALIVE
										managers.hud:add_waypoint( 'hudz_cop_'..tostring(unit_pos), { icon = 'equipment_bank_manager_key', distance = showDistance, position = unit_pos, no_sync = true, present_timer = 0, state = "present", radius = 800, color = cobalt_blue, blend_mode = "add" }  )
									end
								end
							end
						end
					end
				end
				for k,v in pairs(managers.interaction._interactive_units) do
	------1---------
					if _toggleWaypointAIO2 == 1 or _toggleWaypointAIO2 == 8 then
						if v:interaction().tweak_data == 'gage_assignment' and showGagePackages then
							if level == 'hox_2' and v:interaction():interact_position() == Vector3(-200, -200, 4102.5) then
							else
								 --[[Yellow]]
								if tostring(v:name()) == "Idstring(@IDe8088e3bdae0ab9e@)" then
									add_waypoint(v, 'hudz_pkgY_', k, 'interaction_christmas_present')
								 --[[Blue]]
								elseif tostring(v:name()) == "Idstring(@ID05956ff396f3c58e@)" then
									add_waypoint(v, 'hudz_pkgB_', k, 'interaction_christmas_present')
								 --[[Purple]]
								elseif tostring(v:name()) == "Idstring(@IDc90378ad89058c7d@)" then
									add_waypoint(v, 'hudz_pkgP_', k, 'interaction_christmas_present')
								--[[Red]]
								elseif tostring(v:name()) == "Idstring(@ID96504ebd40f8cf98@)" then
									add_waypoint(v, 'hudz_pkgR_', k, 'interaction_christmas_present')
								 --[[Green]]
								elseif tostring(v:name()) == "Idstring(@IDb3cc2abe1734636c@)" then
									add_waypoint(v, 'hudz_pkgG_', k, 'interaction_christmas_present')
								else
									add_waypoint(v, 'hudz_base_', k, 'interaction_christmas_present')
								end
							end
						end
	------2---------
					end
					if (_toggleWaypointAIO2 == 2 or _toggleWaypointAIO2 == 8) then
						-- Keycard
						if ( level ~= "dark" ) then
							if v:interaction().tweak_data == 'pickup_keycard' then
								if level == 'roberts' and v:position() == Vector3(250, 6750, -64.2354) then
								elseif level == 'big' and v:position() == Vector3(3000, -3500, 949.99) then
								elseif level == 'firestarter_2' and v:position() == Vector3(-1800, -3600, 400) then
								else
									add_waypoint(v, 'hudz_key_', k, 'equipment_bank_manager_key')
								end
							end
						end
						-- big bank keys
						if (v:interaction().tweak_data == 'invisible_interaction_open' or v:interaction().tweak_data == 'take_keys') and level == 'big' then
							add_waypoint(v, 'hudz_key_', k, 'equipment_chavez_key')
						end
						-- security door
						if showDoors then
							if (v:interaction().tweak_data == 'key' or v:interaction().tweak_data == 'key_double' or v:interaction().tweak_data == 'hold_close_keycard' or
								v:interaction().tweak_data == 'numpad_keycard' or v:interaction().tweak_data == 'timelock_panel' or v:interaction().tweak_data == 'hack_suburbia') then
								if (v:interaction()._active == true) then
									add_waypoint(v, 'hudz_door_', k, 'padlock')
								end
							end
							if (v:interaction().tweak_data == 'open_train_cargo_door' or v:interaction().tweak_data == 'pick_lock_hard_no_skill_deactivated') then
								if (v:interaction()._active == true) then
									add_waypoint(v, 'hudz_door_', k, 'wp_door')
								end
							end
						end
						if ((level == "dark" and v:interaction().tweak_data == 'hold_open') or v:interaction().tweak_data == 'drk_hold_hack_computer') then --Computer
							add_waypoint(v, 'hudz_key_', k, 'pd2_computer')
						end
						if showCameraComputers then
							if ( v:interaction().tweak_data == 'access_camera' or v:interaction().tweak_data == 'access_camera_y_axis' )then
								add_waypoint(v, 'hudz_door_', k, 'pd2_computer')
							end
						end
					end
	------3---------
					if _toggleWaypointAIO2 == 3 or _toggleWaypointAIO2 == 8 then
						-- weapons
						if v:interaction().tweak_data == 'weapon_case' or v:interaction().tweak_data == 'take_weapons' then
							if ( level == "dark" ) then
								local name = tostring(v:name())
								if ( name == "Idstring(@ID86c151669b930ef0@)" or name == "Idstring(@ID814d28338da0dcdc@)" ) then
									add_waypoint(v, 'hudz_wpn_', k, 'hk21')
								else
									add_waypoint(v, 'hudz_wpn_', k, 'glock')
								end
							else
								add_waypoint(v, 'hudz_wpn_', k, 'ak')
							end
						-- coke
						elseif v:interaction().tweak_data == 'gen_pku_cocaine' then
							add_waypoint(v, 'hudz_coke_', k, 'wp_vial')
						end
					end
	------4---------
					if _toggleWaypointAIO2 == 4 or _toggleWaypointAIO2 == 8 then
						-- planks
						if ( showPlanks ) then
							if v:interaction().tweak_data == 'stash_planks_pickup' then
								add_waypoint(v, 'hudz_plk_', k, 'equipment_planks')
							elseif v:interaction().tweak_data == 'pickup_boards' then
								add_waypoint(v, 'hudz_plk_', k, 'equipment_planks')
							end
						end
						if ( showDrills ) then
							if v:interaction().tweak_data == 'drill' then
								add_waypoint(v, 'hudz_plk_', k, 'pd2_drill')
							end
						end
					end
	------5---------
					if _toggleWaypointAIO2 == 5 or _toggleWaypointAIO2 == 8 then
						-- crowbar
						if v:interaction().tweak_data == 'gen_pku_crowbar' then
							add_waypoint(v, 'hudz_base_', k, 'equipment_crowbar')
						-- shadow raid crates location
						elseif (string.find(v:interaction().tweak_data, 'crate_loot') and showCrates) then
							add_waypoint(v, 'hudz_base_', k, 'pd2_lootdrop')
						end
					end
	------6---------
					if _toggleWaypointAIO2 == 6 or _toggleWaypointAIO2 == 8 then
						-- framing frame/gallery paintings
						if level == 'framing_frame_1' or level == 'gallery' then
							if v:interaction().tweak_data == 'hold_take_painting' then
								add_waypoint(v, 'hudz_ptn_', k, 'equipment_ticket')
							end
						end
						if level == 'framing_frame_3' then
							-- framing frame day 3 computer location
							if v:interaction().tweak_data == 'use_computer' then
								add_waypoint(v, 'hudz_base_', k, 'laptop_objective')
							-- framing frame day 3 phone location
							elseif v:interaction().tweak_data == 'pickup_phone' then
								add_waypoint(v, 'hudz_base_', k, 'pd2_phone')
							-- framing frame day 3 tablet location
							elseif v:interaction().tweak_data == 'pickup_tablet' then
								add_waypoint(v, 'hudz_base_', k, 'equipment_hack_ipad')
							-- framing frame day 3 servers location
							elseif (v:interaction().tweak_data == 'hold_take_server' or v:interaction().tweak_data == 'stash_server_pickup') and level == "framing_frame_3" then
								add_waypoint(v, 'hudz_base_', k, 'equipment_harddrive')
							end
						end
						-- Framing Frame day 3 server
						if level == 'framing_frame_3' then
							if isHost() then
								local servers =
								{
									["105507"] = "Server Room 1",
									["105508"] = "Server Room 2",
									["100650"] = "Server Room 3"
								}
								local keyboard =
								{
									["105507"] = "58cb6c4c6221c415",
									["105508"] = "58cb6c4c6221c415",
									["100650"] = "58cb6c4c6221c415"
								}
								local server_vectors =
								{
									["105507"] = Vector3(-3937.26, 5644.73, 3474.5), -- Office
									["105508"] = Vector3(-3169.57, 4563.03, 3074.5), -- Hallway
									["100650"] = Vector3(-4920, 3737, 3074.5)    -- Living Room
								}
								local svectors = tostring(managers.mission:script("default")._elements[105506]._values.on_executed[1].id)
								-- WAYPOINT SERVER
								if _FF3_used == false then
									managers.hud:add_waypoint( 'hudz_base_'..svectors, { icon = 'interaction_keyboard', distance = showDistance, position = server_vectors[svectors], no_sync = true, present_timer = 0, state = "present", radius = 800, color = Color.white, blend_mode = "add" }  )
								end
							end
						end
						
						if v:interaction().tweak_data == 'caustic_soda' then
							add_waypoint(v, 'hudz_coke1_', k, 'pd2_methlab')
						elseif v:interaction().tweak_data == 'hydrogen_chloride' then
							add_waypoint(v, 'hudz_coke2_', k, 'pd2_methlab')
						elseif v:interaction().tweak_data == 'muriatic_acid' then
							add_waypoint(v, 'hudz_coke3_', k, 'pd2_methlab')
						end
						-- rats day 2
						if level == 'alex_2' then
							if isHost() then
								local values =
								{
									["103805"] = "Intel Revealer: Safe_01",
									["103806"] = "Intel Revealer: Safe_02",
									["103807"] = "Intel Revealer: Safe_03",
									["103808"] = "Intel Revealer: Safe_04",
									["103809"] = "Intel Revealer: Safe_05",
									["103810"] = "Intel Revealer: Safe_06",
									["103811"] = "Intel Revealer: Safe_07",
									["103812"] = "Intel Revealer: Safe_08",
									["103813"] = "Intel Revealer: Safe_09",
									["103814"] = "Intel Revealer: Safe_10",
									["103815"] = "Intel Revealer: Safe_11",
									["103816"] = "Intel Revealer: Safe_12",
									["103817"] = "Intel Revealer: Safe_13",
									["103818"] = "Intel Revealer: Safe_14",
									["103819"] = "Intel Revealer: Safe_15",
									["103820"] = "Intel Revealer: Safe_16"
								}
								local bo_safes = {
									["103805"] = Vector3(791, 1426, 50),
									["103806"] = Vector3(326, 1673, 50),
									["103807"] = Vector3(365, 2022, 103.2),
									["103808"] = Vector3(560, 2175, 127.603),
									["103809"] = Vector3(2220, 1273, 82.103),
									["103810"] = Vector3(2079, 1013, 117.503),
									["103811"] = Vector3(2502, 1015, 50),
									["103812"] = Vector3(2332, 1100, 50),
									["103813"] = Vector3(3162, 2742, 82.1028),
									["103814"] = Vector3(2704, 2342, 114.325),
									["103815"] = Vector3(3400,2662,117.285),
									["103816"] = Vector3(2440, 2747, 50),
									["103817"] = Vector3(2474, 3414, 250),
									["103818"] = Vector3(3181, 3696, 250),
									["103819"] = Vector3(2625, 4003, 250),
									["103820"] = Vector3(2755, 3901, 250)
								}
								local bo_intel = tostring(managers.mission:script("default")._elements[103759]._values.on_executed[1].id)
								if _intel_used == false then
									managers.hud:add_waypoint( 'hudz_base_'..bo_intel, { icon = 'interaction_patientfile', distance = showDistance, position = bo_safes[bo_intel], no_sync = true, present_timer = 0, state = "present", radius = 800, color = Color.white, blend_mode = "add" }  )
								end
							elseif isClient() then
								--managers.chat:_receive_message(1, "*WARNING*", "Intel Revealer is unavailable for you. Host ONLY.",  Color.red)
								-- 2 safes
								if (v:interaction().tweak_data == 'drill' or v:interaction().tweak_data == 'take_confidential_folder') then
									add_waypoint(v, 'hudz_coke3_', k, 'pd2_methlab')
								end
							end
						end
						-- Ukrainian Job Power
						if level == "ukrainian_job" then
							if v:interaction().tweak_data == 'circuit_breaker' then
								add_waypoint(v, 'hudz_base_', k, 'wp_powersupply')
							end
						end
						-- Ukrainian Job Tiara location
						if level == "ukrainian_job" and _tiara_used == false then
							if isHost() or isClient() then
								local unit_list = World:find_units_quick( "all" )
								for key,unit in ipairs( unit_list ) do
									if unit:base() and tostring(unit:name()) == "Idstring(@ID077636ce1f33c8d0@)" --[[TIARA]] then
										add_waypoint(v, 'hudz_Robj_', key, 'pd2_loot')
									end
								end
							end
						end
						-- election day 1, computer location
						if level == 'election_day_1' and v:interaction().tweak_data == 'uload_database' then
							add_waypoint(v, 'hudz_uload', k, 'pd2_computer')
						end
						-- Election Day 1 Truck
						if level == 'election_day_1' then
							if isHost() then
								local trucks =
								{
									["100636"] = "1",
									["100633"] = "2",
									["100637"] = "3",
									["100634"] = "4",
									["100639"] = "5",
									["100635"] = "6"
								}
								local truckid =
								{
									["100633"] = "3b0947a2434bdc93",
									["100634"] = "3b0947a2434bdc93",
									["100635"] = "3b0947a2434bdc93",
									["100636"] = "3b0947a2434bdc93",
									["100637"] = "3b0947a2434bdc93",
									["100639"] = "3b0947a2434bdc93"
								}
								local truck_vectors =
								{
									["100636"] = Vector3(150, -3900, 0), -- 1st
									["100633"] = Vector3(878.392, -3360.24, 0), --2nd
									["100637"] = Vector3(149.999, -2775, 0), --3rd
									["100634"] = Vector3(828.07, -2222.45, 0), --4th
									["100639"] = Vector3(149.998, -1625, 0), --5th
									["100635"] = Vector3(848.961, -1084.9, 0) --6th
								}
								local truckv = tostring(managers.mission:script("default")._elements[100631]._values.on_executed[1].id)
								-- WAYPOINT SERVER
								if _gps_used == false then
									managers.hud:add_waypoint( 'hudz_Robj_'..truckv, { icon = 'equipment_ecm_jammer', distance = showDistance, position = truck_vectors[truckv], no_sync = true, present_timer = 0, state = "present", radius = 800, color = Color.white, blend_mode = "add" }  )
								end
							else
							end
						end
						-- election day 2, machines
						if v:interaction().tweak_data == 'votingmachine2' then
							add_waypoint(v, 'hudz_base_', k, 'pd2_computer')
						end
						-- election day 3, keyboard
						if level == 'election_day_3_skip1' and v:interaction().tweak_data == 'security_station_keyboard' then
							add_waypoint(v, 'hudz_base_', k, 'interaction_keyboard')
						end
						-- firestarter day 2 security boxes location
						if v:interaction().tweak_data == 'open_slash_close_sec_box' and managers.groupai:state():whisper_mode() and level == 'firestarter_2' then
							if isHost() then
								bo_boxes = {
									["105819"] = Vector3(-2710, -2830, 552), -- Box 001
									["105794"] = Vector3(-1840, -3195, 552), -- Box 002
									["105810"] = Vector3(-1540, -2195, 552), -- Box 003
									["105824"] = Vector3(-1005, -3365, 552), -- Box 004
									["105837"] = Vector3(-635, -1705, 552),	-- Box 005
									["105851"] = Vector3(-1095, -210, 152),	-- Box 006
									["106183"] = Vector3(-1230, 1510, 152),	-- Box 007
									["106529"] = Vector3(-1415, -795, 152),	-- Box 008
									["106543"] = Vector3(-1160, 395, 152),	-- Box 009
									["106556"] = Vector3(-5, 735, 152),	-- Box 010
									["106581"] = Vector3(1360, 5, 552),	-- Box 011
									["106594"] = Vector3(795, -898, 552),	-- Box 012
									["106607"] = Vector3(795, -3240, 552),	-- Box 013
									["106620"] = Vector3(1060, -2195, 552),	-- Box 014
									["106633"] = Vector3(204, 540, 578),	-- Box 015
									["106646"] = Vector3(-1085, -1205, 552), -- Box 016
									["106659"] = Vector3(-2135, 395, 552),	-- Box 017
									["106672"] = Vector3(-2405, -840, 552),	-- Box 018
									["106685"] = Vector3(-2005, -1640, 552), -- Box 019
									["106698"] = Vector3(-2715, -1595, 552), -- Box 020
									["106711"] = Vector3(-500, -650, 1300),	-- Box 021
									["106724"] = Vector3(-400, -650, 1300),	-- Box 022
									["106737"] = Vector3(-300, -650, 1300),	-- Box 023		UNAVAILABLE
									["106750"] = Vector3(-200, -650, 1300),	-- Box 024
									["106763"] = Vector3(-100, -650, 1300),	-- Box 025
									["106776"] = Vector3(-635, -1205, 152),	-- Box 026
									["106789"] = Vector3(-1040, -95, 552),	-- Box 027
									["106802"] = Vector3(615, 395, 152),	-- Box 028
									["106815"] = Vector3(1890, -1805, 152),	-- Box 029
									["106828"] = Vector3(215, -1805, 152)	-- Box 030
								}
								SecBox1 = tostring(managers.mission:script("default")._elements[106836]._values.on_executed[1].id)
								SecBox2 = tostring(managers.mission:script("default")._elements[106836]._values.on_executed[2].id)
								if _box1_used == false then
									managers.hud:add_waypoint( 'hudz_Robj_'..SecBox1, { icon = 'interaction_wirecutter', distance = showDistance, position = bo_boxes[SecBox1], no_sync = true, present_timer = 0, state = "present", radius = 800, color = Color.white, blend_mode = "add" }  )
								end
								if _box2_used == false then
									managers.hud:add_waypoint( 'hudz_Robj_'..SecBox2, { icon = 'interaction_wirecutter', distance = showDistance, position = bo_boxes[SecBox2], no_sync = true, present_timer = 0, state = "present", radius = 800, color = Color.white, blend_mode = "add" }  )
								end
							elseif isClient() then
								nb = nb + 1
								if clientBox[nb] ~= 0 then
									clientBox[nb] = v:position()
									-- managers.chat:_receive_message(1, "Box_Client"..nb, tostring(clientBox[nb]),  Color.green)
									add_waypoint(v, 'hudz_box_', k, 'interaction_wirecutter')
								end
							end
						end
						if nb == 5 then nb = 0 end
						-- Big Oil day 1 intel
						if v:interaction().tweak_data == 'hold_take_blueprints' then
							add_waypoint(v, 'hudz_base_', k, 'pd2_loot')
						elseif v:interaction().tweak_data == 'take_confidential_folder' then
							add_waypoint(v, 'hudz_base_', k, 'pd2_loot')
						elseif v:interaction().tweak_data == 'pickup_asset' then
							add_waypoint(v, 'hudz_key_', k, 'equipment_chavez_key')
						end
						-- Big Oil day 1 Safe
						if level == "welcome_to_the_jungle_1" and v:interaction().tweak_data == 'drill' then
							add_waypoint(v, 'hudz_Robj_', k, 'pd2_drill')
						end
						-- Big Oil day 2 engine + server
						if level == 'welcome_to_the_jungle_2' then
							if isHost() then
								values =
								{
									["103703"] = "engine_01",
									["103704"] = "engine_02",
									["103705"] = "engine_03",
									["103706"] = "engine_04",
									["103707"] = "engine_05",
									["103708"] = "engine_06",
									["103709"] = "engine_07",
									["103711"] = "engine_08",
									["103714"] = "engine_09",
									["103715"] = "engine_10",
									["103716"] = "engine_11",
									["103717"] = "engine_12"
								}
								engine_pos =
								{
									['103703'] = Vector3(-1830,-2182,-313.49200439453),  			-- 1
									['103704'] = Vector3(-1200,-2050,-313.49200439453), 			-- 2
									['103705'] = Vector3(-1849,-1869,-313.49200439453), 			-- 3
									['103706'] = Vector3(-1200,-1735,-313.49200439453), 			-- 4
									['103707'] = Vector3(-1849,-1429,-313.49200439453), 			-- 5
									['103708'] = Vector3(-1200,-1415,-313.49200439453), 			-- 6

									['103709'] = Vector3(-175,-2025,-313.49200439453), 				-- 7
									['103711'] = Vector3(-24.999900817871,-1350,-313.49200439453), 	-- 8
									['103714'] = Vector3(-175,-1675,-313.49200439453), 				-- 9
									['103715'] = Vector3(35,-1733,-314), 							-- 10
									['103716'] = Vector3(-175,-1350,-313.49200439453), 				-- 11
									['103717'] = Vector3(25,-2050,-313.49200439453) 				-- 12
								}
								local srooms =
								{
									["101865"] = "Server Room Revealer: 1st floor, Back of the property",
									["101866"] = "Server Room Revealer: 1st floor, Front of the property",
									["101915"] = "Server Room Revealer: Ground floor"
								}
								local keyboard_id =
								{
									["101865"] = "8efe34cd3f706348",
									["101866"] = "8efe34cd3f706348",
									["101915"] = "8efe34cd3f706348"
								}
								local bo_servers =
								{
									["101865"] = Vector3(-662, -2142, 475),	-- Room 1
									["101866"] = Vector3(-2129, 391, 475), -- Room 2
									["101915"] = Vector3(-384, -96, 75) -- Room 3
								}
								local bo_keyboard = tostring(managers.mission:script("default")._elements[101916]._values.on_executed[1].id)
								correct_id = tostring(managers.mission:script('default')._elements[103718]._values.on_executed[1].id)
								if lp == false then
									-- CHAT
									if _keyboard_used == false then
										managers.chat:_receive_message(1, "Server Room", srooms[tostring(managers.mission:script("default")._elements[101916]._values.on_executed[1].id)],  tweak_data.system_chat_color)
									end
									if _engine_used == false then
										managers.chat:_receive_message(1, "Big Oil", values[tostring(managers.mission:script("default")._elements[103718]._values.on_executed[1].id)],  tweak_data.system_chat_color)
									end
									lp = true
								end
								-- WAYPOINT SERVER
								if _keyboard_used == false then
									managers.hud:add_waypoint( 'hudz_base_'..bo_keyboard, { icon = 'interaction_keyboard', distance = showDistance, position = bo_servers[bo_keyboard], no_sync = true, present_timer = 0, state = "present", radius = 800, color = Color.white, blend_mode = "add" }  )
								end
								-- WAYPOINT	ENGINE
								if _engine_used == false then
									managers.hud:add_waypoint( 'hudz_Robj_'..correct_id, { icon = 'pd2_loot', distance = showDistance, position = engine_pos[correct_id], no_sync = true, present_timer = 0, state = 'present', radius = 800, color = Color.green, blend_mode = 'add' }  )
								end
							end
						end
						-- shadow raid server
						if (v:interaction().tweak_data == 'hold_take_server' or v:interaction().tweak_data == 'stash_server_pickup') then
							add_waypoint(v, 'hudz_base_', k, 'equipment_stash_server')
						-- shadow raid paintings
						elseif v:interaction().tweak_data == 'hold_take_painting' then
							add_waypoint(v, 'hudz_ptn_', k, 'pd2_loot')
						-- shadow raid statue inside crate
						elseif string.find(v:interaction().tweak_data, 'gen_pku_artifact') or v:interaction().tweak_data == 'samurai_armor' then
							if v:interaction().tweak_data == 'gen_pku_artifact_painting' then
								if level ~= "mus" or (v:unit_data() and v:unit_data().unit_id ~= 300047) then --[[Painting that can't be grabbed from The Diamond]]
									add_waypoint(v, 'hudz_ptn_', k, 'equipment_ticket')
								end
							else					
								add_waypoint(v, 'hudz_cashB_', k, 'wp_scrubs')
							end
						-- shadow raid sewer manhole
						elseif v:interaction().tweak_data == 'sewer_manhole' and showSewerManhole then
							add_waypoint(v, 'hudz_door_', k, 'interaction_open_door')
						-- thermite
						elseif v:interaction().tweak_data == 'apply_thermite_paste' and showThermite then
							add_waypoint(v, 'hudz_fire_', k, 'equipment_thermite')
						elseif v:interaction().tweak_data == 'hold_blow_torch' then
							add_waypoint(v, 'hudz_fire_', k, 'equipment_blow_torch')
						end
						-- intel train heist
						if (level == 'arm_hcm' or level == 'arm_cro' or level == 'arm_fac' or level == 'arm_par' or level == 'arm_und')
							and v:interaction().tweak_data == 'take_confidential_folder_event' then
							add_waypoint(v, 'hudz_base_', k, 'interaction_patientfile')
						end
						-- train heist turret
						if v:interaction().tweak_data == 'disassemble_turret' and level == "arm_for" then
							add_waypoint(v, 'hudz_base_', k, 'equipment_sentry')
						end
						if level == "arm_for" then
							if isHost() then
								local vault1 = tostring(managers.mission:script("default")._elements[104736]._values.on_executed[1].id)
								local vault2 = tostring(managers.mission:script("default")._elements[104737]._values.on_executed[1].id)
								local vault3 = tostring(managers.mission:script("default")._elements[104738]._values.on_executed[1].id)
								if _drill1_used == false then
									if vault1 == '104731' then
										managers.hud:add_waypoint( 'hudz_base_'..vault1, { icon = 'wp_target', distance = showDistance, position = Vector3(-2710, -1152, 666), no_sync = true, present_timer = 0, state = "present", radius = 800, color = Color.green, blend_mode = "add" }  )
									elseif vault1 == '104729' then
										managers.hud:add_waypoint( 'hudz_base_'..vault1, { icon = 'wp_target', distance = showDistance, position = Vector3(-1707, -1157, 667), no_sync = true, present_timer = 0, state = "present", radius = 800, color = Color.green, blend_mode = "add" }  )
									end
								end
								if _drill2_used == false then
									if vault2 == '104732' then
										managers.hud:add_waypoint( 'hudz_base_'..vault2, { icon = 'wp_target', distance = showDistance, position = Vector3(-192, -1152, 668), no_sync = true, present_timer = 0, state = "present", radius = 800, color = Color.orange, blend_mode = "add" }  )
									elseif vault2 == '104733' then
										managers.hud:add_waypoint( 'hudz_base_'..vault2, { icon = 'wp_target', distance = showDistance, position = Vector3(794, -1161, 668), no_sync = true, present_timer = 0, state = "present", radius = 800, color = Color.orange, blend_mode = "add" }  )
									end
								end
								if _drill3_used == false then
									if vault3 == '104734' then
										managers.hud:add_waypoint( 'hudz_base_'..vault3, { icon = 'wp_target', distance = showDistance, position = Vector3(2291, -1155, 667), no_sync = true, present_timer = 0, state = "present", radius = 800, color = Color.red, blend_mode = "add" }  )
									elseif vault3 == '104735' then
										managers.hud:add_waypoint( 'hudz_base_'..vault3, { icon = 'wp_target', distance = showDistance, position = Vector3(3308, -1151, 667), no_sync = true, present_timer = 0, state = "present", radius = 800, color = Color.red, blend_mode = "add" }  )
									end
								end
							end
						end
						-- big bank server
						if ( missionId ) then
							if ( missionId == 28 or missionId < 4) then
								if level == 'big' and v:interaction().tweak_data == 'big_computer_server' then
									add_waypoint(v, 'hudz_base_', k, 'pd2_computer')
								end
								-- big bank keyboards location
								if isHost() and (v:interaction().tweak_data == 'big_computer_hackable' or v:interaction().tweak_data == 'big_computer_server') and level == 'big' then
									local big1 = tostring(managers.mission:script("default")._elements[103246]._original_on_executed[1].id)
									local big1 = tostring(managers.mission:script("default")._elements[103246]._values.on_executed[1].id)
									local stfcmpts = {
										["103250"] = Vector3(2754, 1420, -923),
										["103229"] = Vector3(2083, 1412, -922.772),
										["103569"] = Vector3(1941, 1345, -922.772),
										["103604"] = Vector3(1589, 1419, -922.772),
										["103647"] = Vector3(2558, 1847, -922.772),
										["103709"] = Vector3(2448.08, 1849.07, -922.772),
										["103749"] = Vector3(1859.2, 1832.25, -922.772),
										["103788"] = Vector3(1732, 1812, -923),
										["103898"] = Vector3(1090, 1220, -522.772),
										["103916"] = Vector3(1293.46, 1221.04, -522.772),
										["103927"] = Vector3(1909, 1389, -522.762),
										["103948"] = Vector3(1917.69, 1583.79, -522.762),
										["103966"] = Vector3(2318, 1608, -522.762),
										["103984"] = Vector3(2319.79, 1407.8, -522.762),
										["104006"] = Vector3(2716, 1220, -522.772),
										["104024"] = Vector3(2895.76, 1782.56, -522.772),
										["104042"] = Vector3(2922, 1218.89, -522.772),
										["104080"] = nil,
										["104127"] = nil,
										["104315"] = nil
									}
									if tostring(stfcmpts[big1]) ~= 'nil' then
										managers.hud:add_waypoint( 'hudz_Robj_'..'big1', { icon = 'interaction_keyboard', distance = showDistance, position = stfcmpts[big1], no_sync = true, present_timer = 0, state = "present", radius = 800, color = Color.yellow, blend_mode = "add" }  )
									end
								else
									if v:interaction().tweak_data == 'big_computer_hackable' then
										add_waypoint(v, 'hudz_base_', k, 'interaction_keyboard')
									end
								end
							end
						end
						-- Hotline miami day 1
						if v:interaction().tweak_data == 'hold_take_gas_can' then
							add_waypoint(v, 'hudz_fire_', k, 'equipment_thermite')
						end
						-- Hotline miami day 2
						if level == 'mia_2' then
							if v:interaction().tweak_data == 'disarm_bomb' then
								add_waypoint(v, 'hudz_base_', k, 'wp_target')
							end
							if v:interaction().tweak_data == 'hold_hlm_open_circuitbreaker' or v:interaction().tweak_data == 'hold_remove_cover' or v:interaction().tweak_data == 'hold_cut_cable' then
								add_waypoint(v, 'hudz_base_', k, 'wp_powersupply')
							end
							if v:interaction().tweak_data == 'c4_mission_door' then
								add_waypoint(v, 'hudz_base_', k, 'equipment_c4')
							end
						end
						-- HOXTON BREAKOUT DAY 1
						if level == 'hox_1' and _comp_used == false then
							if isHost() then
								local hox1 = tostring(managers.mission:script("default")._elements[101519]._original_on_executed[1].id)
								local hox1 = tostring(managers.mission:script("default")._elements[101519]._values.on_executed[1].id)
								local srvrooms = {
									["101520"] = Vector3(9458.71, 5680, -2690),
									["101523"] = Vector3(12966.3, 8320, -2690),
									["101524"] = Vector3(9741.29, 8520, -2590),
									["101525"] = Vector3(11341.3, 8520, -2390),
									["101527"] = Vector3(8233.71, 5880, -2290),
									["101528"] = Vector3(9741.29, 8520, -2190),
									["101529"] = Vector3(11341.3, 8520, -1990),
									["101531"] = Vector3(8741.29, 8195, -1890),
									["101806"] = Vector3(10558.7, 6130, -1890),
									["101807"] = Vector3(12258.7, 4280, -2290)
								}
								if tostring(srvrooms[hox1]) ~= 'nil' then
									managers.hud:add_waypoint( 'hudz_Robj_'..'hox1', { icon = 'interaction_keyboard', distance = showDistance, position = srvrooms[hox1], no_sync = true, present_timer = 0, state = "present", radius = 800, color = Color.yellow, blend_mode = "add" }  )
								end
							else
								if v:interaction().tweak_data == 'shaped_sharge' then
									add_waypoint(v, 'hudz_Wobj_', k, 'interaction_keyboard')
								end
							end
						end
						-- Hox day 2
						if level == 'hox_2' then
							if v:interaction().tweak_data == 'firstaid_box' or v:interaction().tweak_data == 'invisible_interaction_open' then
								add_waypoint(v, 'hudz_base_', k, 'equipment_doctor_bag')
							end
							if v:interaction().tweak_data == 'grenade_crate' or v:interaction().tweak_data == 'ammo_bag' then
								add_waypoint(v, 'hudz_base_', k, 'equipment_ammo_bag')
							end
							if v:interaction().tweak_data == 'hold_download_keys' then
								add_waypoint(v, 'hudz_base_', k, 'interaction_keyboard')
							end
							if v:interaction().tweak_data == 'invisible_interaction_gathering' then
								add_waypoint(v, 'hudz_base_', k, 'equipment_evidence')
							end
							-- Files
							if v:interaction().tweak_data == 'search_files_false' then
								add_waypoint(v, 'hudz_Wobj_', k, 'equipment_files')
							end
							-- Correct file
							if v:interaction().tweak_data == 'invisible_interaction_searching' then
								add_waypoint(v, 'hudz_Robj_', k, 'equipment_files')
							end
							if v:interaction().tweak_data == 'grab_server' then
								add_waypoint(v, 'hudz_base_', k, 'equipment_stash_server')
							end
						end
						-- White Xmas
						if level == 'pines' then
							-- xmas presents
							if v:interaction().tweak_data == 'hold_open_xmas_present' then
								add_waypoint(v, 'hudz_base_', k, 'interaction_christmas_present')
							end
							-- coke
							if v:interaction().tweak_data == 'gen_pku_cocaine_pure' then
								add_waypoint(v, 'hudz_coke_', k, 'wp_vial')
							end
							-- Almir's Toast
							if v:interaction().tweak_data == 'gen_pku_sandwich' then
								add_waypoint(v, 'hudz_base_', k, 'pd2_loot')
							end
						end
						-- The Diamond
						if level == 'mus' then
							-- electric box
							if (v:interaction().tweak_data == 'invisible_interaction_open' or v:interaction().tweak_data == 'rewire_electric_box') and v:interaction():interact_position() ~= Vector3(6150, 549, -500) then
								add_waypoint(v, 'hudz_base_', k, 'wp_powersupply')
							end							
						end
						-- THE BOMB : DOCKYARD
						if level == 'crojob2' then
							-- computers
							if v:interaction().tweak_data == 'uload_database' and _uldatabase_found == false then
								add_waypoint(v, 'hudz_uload', k, 'pd2_computer')
							end
							-- right position of the bomb
							if v:interaction().tweak_data == 'hold_pku_disassemble_cro_loot' and _bomb_ok == false then
								_bomb_pos = v:position()
								_bomb_ok = true
							end
							-- 4 positions of the bomb + right position
							if v:interaction().tweak_data == 'hold_pku_disassemble_cro_loot'
							and _bomb_ok == true and _bomb_used > 3 and _bomb_used <= 8
							then
								managers.hud:remove_waypoint( 'hudz_Robj_'..'bomb' )
								add_waypoint(v, 'hudz_Robj_', k, 'pd2_nuke')
							end
							if v:interaction().tweak_data == 'hold_open_bomb_case' and (_bomb_used == 4 or _bomb_used == 3) then
								if v:position() == _bomb_pos then
									managers.hud:add_waypoint( 'hudz_Robj_'..'bomb', { icon = 'pd2_nuke', distance = showDistance, position = _bomb_pos, no_sync = true, present_timer = 0, state = "present", radius = 1000, color = Color.green, blend_mode = "add" }  )
								else
									add_waypoint(v, 'hudz_Wobj_', k, 'pd2_nuke')
								end
							elseif v:interaction().tweak_data == 'hold_open_bomb_case' and _bomb_used > 3 then
								add_waypoint(v, 'hudz_Wobj_', k, 'pd2_nuke')
							end
						end
						-- THE BOMB : FOREST
						if level == 'crojob3' then
							-- Ladder
							if v:interaction().tweak_data == 'pick_lock_easy_no_skill' or v:interaction().tweak_data == 'hold_remove_ladder' then
								add_waypoint(v, 'hudz_base_', k, 'pd2_ladder')
							end
							-- Chainsaw
							if v:interaction().tweak_data == 'take_chainsaw' then
								add_waypoint(v, 'hudz_base_', k, 'pd2_chainsaw')
							end
							if v:interaction().tweak_data == 'use_chainsaw' then
								add_waypoint(v, 'hudz_base_', k, 'pd2_chainsaw')
							end
						end
						-- CAR SHOP
						if level == 'cage' then
							--security_station_keyboard
							if (v:interaction().tweak_data == 'security_station_keyboard' or v:interaction().tweak_data == 'gage_assignment') and _comp_used == false and isHost() then
								local cage1 = tostring(managers.mission:script("default")._elements[104929]._original_on_executed[1].id)
								local cage1 = tostring(managers.mission:script("default")._elements[104929]._values.on_executed[1].id)
								local cmpts = {
									["104797"] = Vector3(2465.98, 660.75, -149.996),
									["104804"] = Vector3(2615.98, 660.75, -149.996),
									["104811"] = Vector3(2890.98, 660.75, -149.996),
									["104818"] = Vector3(3040.98, 660.75, -149.996),
									["104826"] = Vector3(3045.98, 405.75, -149.996),
									["104833"] = Vector3(2887.98, 407.75, -149.996),
									["104841"] = Vector3(2615.98, 410.75, -149.996),
									["104848"] = Vector3(2465.98, 407.75, -149.996),
									["104857"] = Vector3(1077.98, 255.751, 250.004),
									["104866"] = Vector3(924.978, 255.75, 250.004),
									["104873"] = Vector3(617.978, 255.75, 250.004),
									["104880"] = Vector3(468.978, 255.749, 250.004),
									["104887"] = Vector3(423.024, 142.249, 250.004),
									["104899"] = Vector3(590.024, 142.25, 250.004),
									["104907"] = Vector3(880.024, 142.25, 250.004),
									["104919"] = Vector3(1049.02, 142.251, 250.004),
									["104927"] = Vector3(254.75, -1490.98, 249.503)
								}
								managers.hud:add_waypoint( 'hudz_Robj_'..'cage', { icon = 'interaction_keyboard', distance = showDistance, position = cmpts[cage1], no_sync = true, present_timer = 0, state = "present", radius = 800, color = Color.white, blend_mode = "add" }  )
							end
						end
						-- HOXTON REVENGE
						if level == 'hox_3' then
							if v:interaction().tweak_data == 'gen_pku_evidence_bag' then
								add_waypoint(v, 'hudz_Robj_', k, 'equipment_evidence')
							end
							if v:interaction().tweak_data == 'mcm_fbi_taperecorder' then
								add_waypoint(v, 'hudz_base_', k, 'pd2_talk')
							end
							if v:interaction().tweak_data == 'mcm_panicroom_keycard_1' then
								add_waypoint(v, 'hudz_door_', k, 'wp_powerbutton')
							end
							if v:interaction().tweak_data == 'mcm_panicroom_keycard_2' then
								add_waypoint(v, 'hudz_door_', k, 'wp_powerbutton')
							end
							if v:interaction().tweak_data == 'mcm_break_planks' then
								add_waypoint(v, 'hudz_base_', k, 'equipment_planks')
							end
							if v:interaction().tweak_data == 'open_slash_close_sec_box' or v:interaction().tweak_data == 'hospital_security_cable' then
								add_waypoint(v, 'hudz_Robj_', k, 'pd2_wirecutter')
							end
							if v:interaction().tweak_data == 'invisible_interaction_open' or v:interaction().tweak_data == 'rewire_electric_box' or v:interaction().tweak_data == 'use_server_device' then
								add_waypoint(v, 'hudz_Robj_', k, 'wp_target')
							end
							if v:interaction().tweak_data == 'mcm_laptop' then
								add_waypoint(v, 'hudz_Robj_', k, 'laptop_objective')
							end
							local hox3 = tostring(managers.mission:script("default")._elements[101779]._values.on_executed[1].id)
							local phone_poles =
							{
								["101764"] = Vector3(3058.81, -103.151, -4),
								["101765"] = Vector3(3040.08, 1912.44, 1141),
								["101766"] = Vector3(-3563.02, 1813.98, -164.391),
								["101776"] = Vector3(-3041.99, -2321.82, -23.1596),
								["101780"] = Vector3(-236.471, -2545, 262.968)
							}
							managers.hud:add_waypoint( 'hudz_Robj_'..'hox3', { icon = 'pd2_phone', distance = showDistance, position = phone_poles[hox3], no_sync = true, present_timer = 0, state = "present", radius = 800, color = Color.yellow, blend_mode = "add" }  )
						end
						-- MELTDOWN
						if level == 'shoutout_raid' then
							if v:interaction().tweak_data == 'driving_drive' then
								if (v:interaction()._ray_object_names[6]) then --[[Muscle car]]
									add_waypoint(v, 'hudz_car_', k, 'pd2_car')
								else --[[Forklift]]
									add_waypoint(v, 'hudz_car_', k, 'equipment_ejection_seat')
								end
							end
							if v:interaction().tweak_data == 'gen_pku_crowbar' then
								add_waypoint(v, 'hudz_Robj_', k, 'equipment_crowbar')
							end
						end
						-- THE ALESSO HEIST
						if level == 'arena' then
							-- Bag shortcuts
							if v:interaction().tweak_data == 'push_button' then
								add_waypoint(v, 'hudz_base_', k, 'pd2_ladder')
							end
							-- Forklift
							if v:interaction().tweak_data == 'driving_drive' then
								add_waypoint(v, 'hudz_car_', k, 'equipment_ejection_seat')
							end
							-- Extinguisher
							if v:interaction().tweak_data == 'hold_take_fire_extinguisher' then
								add_waypoint(v, 'hudz_fire_', k, 'pd2_fire')
							end
							-- Cutter
							if v:interaction().tweak_data == 'hold_circle_cutter' then
								add_waypoint(v, 'hudz_base_', k, 'equipment_cutter')
							end
						end

						-- GOAT SIMULATOR
						if level == 'peta' then
							-- GOAT
							if v:interaction().tweak_data == 'hold_grab_goat' then
								add_waypoint(v, 'hudz_cashB_', k, 'equipment_briefcase')
							end
						end

						--AFTERSHOCK
						if (v:interaction().tweak_data == 'gen_int_saw') then
							add_waypoint(v, 'hudz_base_', k, 'equipment_saw')
						end
						
						--COUNTERFEIT
						if (v:interaction().tweak_data == 'press_printer_ink') then
							add_waypoint(v, 'hudz_base_', k, 'equipment_printer_ink')
							
						end
						if (v:interaction().tweak_data == 'press_printer_paper') then
							add_waypoint(v, 'hudz_base_', k, 'equipment_paper_roll')
						end

						-- BOILING POINT
						if level == 'mad' then
							if v:interaction().tweak_data == 'gen_pku_body' then --Body
								add_waypoint(v, 'hudz_base_', k, 'wp_bag')
							end
							if v:interaction().tweak_data == 'hold_turn_off_gas' then --Gas canister leaking in to vents
								add_waypoint(v, 'hudz_coke2_', k, 'pd2_methlab')
							end
							if v:interaction().tweak_data == 'hold_pku_briefcase' then --Breifcase
								add_waypoint(v, 'hudz_base_', k, 'equipment_briefcase')
							end
							if v:interaction().tweak_data == 'hold_remove_hand' then --Hand
								add_waypoint(v, 'hudz_cop_', k, 'equipment_hand')
							end
						end
						
						if v:interaction().tweak_data == 'pku_pig' then --Pig
							add_waypoint(v, 'hudz_cashB_', k, 'equipment_briefcase')
						end

						-- MURKY STATION
						if level == 'dark' then
							if v:interaction().tweak_data == 'hold_pku_drk_bomb_part' then --Bomb
								add_waypoint(v, 'hudz_base_', k, 'pd2_nuke')
							end
							if v:interaction().tweak_data == 'pickup_harddrive' then --Hard Drive
								add_waypoint(v, 'hudz_base_', k, 'equipment_harddrive')
							end
						end
					end
	------7---------
					if _toggleWaypointAIO2 == 7 or _toggleWaypointAIO2 == 8 then
						-- Money
						if v:interaction().tweak_data == 'money_wrap_updating' then
							add_waypoint(v, 'hudz_cashB_', k, 'equipment_money_bag')
						end
						-- money
						if v:interaction().tweak_data == 'money_wrap_single_bundle' and showSmallLoot then
							add_waypoint(v, 'hudz_cash_', k, 'interaction_money_wrap')
						elseif v:interaction().tweak_data == 'cash_register' and showSmallLoot then
							if level == "jewelry_store" or level == "ukrainian_job" then
								if v:position() == Vector3(1844, 665, 117.732) then
								else
									add_waypoint(v, 'hudz_cash_', k, 'interaction_money_wrap')
								end
							else
								add_waypoint(v, 'hudz_cash_', k, 'interaction_money_wrap')
							end
						elseif v:interaction().tweak_data == 'money_small' then
							add_waypoint(v, 'hudz_cashB_', k, 'interaction_money_wrap')
						elseif v:interaction().tweak_data == 'money_wrap' then
							if level == "arm_for" then
								if v:position().z > -1500 then
									add_waypoint(v, 'hudz_cashB_', k, 'equipment_money_bag')
								end
							elseif level == "welcome_to_the_jungle_1" then
								if v:position() ~= Vector3(9200, -4300, 100) then
									add_waypoint(v, 'hudz_cashB_', k, 'equipment_money_bag')
								end
							elseif level == "family" then
								if v:position() ~= Vector3(1400, 200, 1100) then
									add_waypoint(v, 'hudz_cashB_', k, 'equipment_money_bag')
								end
							elseif level == "mia_1" then
								if v:position() ~= Vector3(5400, 1400, -300) then
									add_waypoint(v, 'hudz_cashB_', k, 'equipment_money_bag')
								end
							else
								add_waypoint(v, 'hudz_cashB_', k, 'equipment_money_bag')
							end
						-- gold
						elseif v:interaction().tweak_data == 'gold_pile' then
							if level == "welcome_to_the_jungle_1" then
								if v:position() ~= Vector3(9200, -4400, 100) then
									add_waypoint(v, 'hudz_gold_', k, 'interaction_gold')
								end
							else
								add_waypoint(v, 'hudz_gold_', k, 'interaction_gold')
							end
						-- diamonds/jewels
						elseif v:interaction().tweak_data == 'diamond_pickup' and showSmallLoot then
							add_waypoint(v, 'hudz_gold_', k, 'interaction_diamond')
						elseif v:interaction().tweak_data == 'gen_pku_jewelry' then
							add_waypoint(v, 'hudz_cashB_', k, 'wp_bag')
						-- ATMS
						elseif v:interaction().tweak_data == 'requires_ecm_jammer_atm' then
							add_waypoint(v, 'hudz_atm_', k, 'equipment_ecm_jammer')
						-- safe loot
						elseif v:interaction().tweak_data == 'safe_loot_pickup' and showSmallLoot then
							if level == "family" then
								if v:position().z < 1000 then	-- Vector3(1400, 100, 1100)
									add_waypoint(v, 'hudz_cash_', k, 'interaction_money_wrap')
								end
							else
								add_waypoint(v, 'hudz_cash_', k, 'interaction_money_wrap')
							end
						end
						-- train heist ammo
						if v:interaction().tweak_data == 'take_ammo' and level == "arm_for" then
							add_waypoint(v, 'hudz_base_', k, 'equipment_sentry')
						end
					end
					-- THE BOMB : DOCKYARD - Save the position of the bomb
					if ( _bomb_ok == false ) then
						if level == 'crojob2' and v:interaction().tweak_data == 'hold_pku_disassemble_cro_loot' then
							_bomb_pos = v:position()
							_bomb_ok = true
						end
					end
				end

				local i = 0
				for id,_ in pairs( managers.hud._hud.waypoints ) do
					id = tostring(id)
					if id:sub(1,5) == 'hudz_' then
						i = i + 1
					end
				end
				if i == 0 then
					_toggleWaypointAIO2 = _toggleWaypointAIO2 + 1
					if _toggleWaypointAIO2 > 8 then
						_toggleWaypointAIO2 = 0
						-- managers.hud:show_hint( { text = "LOCATOR DISABLED" } )
						if (showHUDMessages == true) then
							managers.hud:present_mid_text( { text = "LOCATOR DISABLED", title = "WAYPOINT", time = 1 } )
							Overlay:gui():destroy_workspace( _HDmsg.ws)
							_HDmsg = nil
						end
					end
					RefreshItemWaypoints(false)
					return
				end
				RefreshMsg()
			end
		end
	end

	-- initialize waypoints
	RefreshItemWaypoints(true)
	
	--This function is called when an item is removed from the session.
	managers.interaction._remove_unit = managers.interaction._remove_unit or managers.interaction.remove_unit
	function ObjectInteractionManager:remove_unit( unit )
		local interacted = unit:interaction().tweak_data
		local result = self:_remove_unit(unit)
		local position = unit:position()
		local position2 = unit:interaction():interact_position()
		local level = managers.job:current_level_id()
		
		if game_state_machine:current_state_name() == "victoryscreen" or string.find(game_state_machine:current_state_name(), "victoryscreen")
		or game_state_machine:current_state_name() == "gameoverscreen" or string.find(game_state_machine:current_state_name(), "gameoverscreen") then
			_toggleWaypointAIO2 = 0
			if ( showHUDMessages ) then
				if _HDmsg then
					_HDmsg.lbl:set_text("")
					_HDmsg.lbl2:set_text("")
					_HDmsg.lbl3:set_text("")
					_HDmsg.lbl4:set_text("")
				end
			end
			return result
		end
		
		--Special cases

		-- Big Bank check if server used.
		if (level == 'big' and interacted == 'big_computer_server') then
			RefreshItemWaypoints(true)
		end

		-- BIG OIL DAY 2
		if ((_toggleWaypointAIO2 == 6 or _toggleWaypointAIO2 == 8) and (level == 'welcome_to_the_jungle_2' and interacted == 'security_station_keyboard')) then
			_keyboard_used = true
			RefreshItemWaypoints(false)
		end
		if ( isHost() ) then
			if ((_toggleWaypointAIO2 == 6 or _toggleWaypointAIO2 == 8) and (level == 'welcome_to_the_jungle_2' and (interacted == 'gen_pku_fusion_reactor' or interacted == 'carry_drop'))) then
				if position == engine_pos[correct_id] then
					_engine_used = true
				end
				RefreshItemWaypoints(true)
			end
		end
		-- RATS 2
		if ((_toggleWaypointAIO2 == 6 or _toggleWaypointAIO2 == 8) and (level == 'alex_2' and interacted == 'take_confidential_folder')) then
			_intel_used = true
			RefreshItemWaypoints(true)
		end
		-- TIARA
		if ((_toggleWaypointAIO2 == 6 or _toggleWaypointAIO2 == 8) and (level == 'ukrainian_job' and interacted == 'tiara_pickup')) then
			_tiara_used = true
			RefreshItemWaypoints(true)
		end
		-- STATE 6 TRAIN HEIST
		if ((_toggleWaypointAIO2 == 6 or _toggleWaypointAIO2 == 8) and (level == 'arm_for' and interacted == 'lance')) then
			if position == Vector3(-1750, -1200, 685) or position == Vector3(-2650, -1100, 685) then
			_drill1_used = true -- GREEN
			elseif position == Vector3(-150, -1100, 685) or position == Vector3(750, -1200, 685) then
			_drill2_used = true -- ORANGE
			elseif position == Vector3(3250, -1200, 685) or position == Vector3(2350, -1100, 685) then
			_drill3_used = true -- RED
			end
			RefreshItemWaypoints(true)
		end
		-- STATE 6 FRAMING FRAME DAY 3 SERVER ROOM
		if ((_toggleWaypointAIO2 == 6 or _toggleWaypointAIO2 == 8) and (level == 'framing_frame_3' and interacted == 'security_station_keyboard')) then
			_FF3_used = true
			RefreshItemWaypoints(true)
		end
		-- STATE 6 ELECTION DAY 1 TRUCK
		if ((_toggleWaypointAIO2 == 6 or _toggleWaypointAIO2 == 8) and (level == 'election_day_1' and interacted == 'hold_place_gps_tracker')) then
			_gps_used = true
			RefreshItemWaypoints(true)
		end
		-- STATE 6 FIRESTARTER DAY 2
		if ((_toggleWaypointAIO2 == 6 or _toggleWaypointAIO2 == 8) and (level == 'firestarter_2')) then
			if isHost() then
				if interacted == 'hospital_security_cable' then
					tabclk[1] = os.clock()
				elseif interacted == 'open_slash_close_sec_box' then
					tabclk[2] = os.clock()
				end

				if (tabclk[1] ~= nil and tabclk[2] ~= nil) or (tabclk[1] == nil and tabclk[2] ~= nil) then
					if tabclk[1] == nil then tabclk[1] = 0 end -- to prevent a nil value if you want to cut the first cable
					local test = tabclk[2] - tabclk[1]

					if test < 0.5 and test > 0 or test < 0 and test > -0.5 then
						-- CLOSING THE BOX
					else
						-- CUTTING THE CABLE OR OPENING THE BOX
						if interacted == 'hospital_security_cable' and position == bo_boxes[SecBox1] then
							_box1_used = true
							RefreshItemWaypoints(true)
						elseif interacted == 'hospital_security_cable' and position == bo_boxes[SecBox2] then
							_box2_used = true
							RefreshItemWaypoints(true)
						end
					end
				end
				if not managers.groupai:state():whisper_mode() then
					_box1_used = true
					_box2_used = true
					RefreshItemWaypoints(true)
				end
			elseif isClient() then
				if not managers.groupai:state():whisper_mode() then
					_box1_used = true
					_box2_used = true
					RefreshItemWaypoints(true)
				end
				if interacted == 'hospital_security_cable' then
					local vecX = position2.x
					local vecY = position2.y
					-- local vecZ = position2.z

					for k, v in pairs(clientBox) do
						if clientBox[k] ~= 0 then
							if
								(vecX < clientBox[k].x + 50 and vecX > clientBox[k].x - 50)
							and
								(vecY < clientBox[k].y + 50 and vecY > clientBox[k].y - 50)
							then
								clientBox[k] = 0
								clientSucceed = clientSucceed + 1
								RefreshItemWaypoints(true)
							end
						end
						if clientSucceed == 2 then
							clientBox[1] = 0
							clientBox[2] = 0
							clientBox[3] = 0
							clientBox[4] = 0
							clientBox[5] = 0
							RefreshItemWaypoints(true)
						end
					end
				end
			end
		end
		
		-- CAR SHOP
		if (level == 'cage' and interacted == 'security_station_keyboard') then
			_comp_used = true
			RefreshItemWaypoints(true)
		end
		-- HOX DAY 1
		if (level == 'hox_1' and interacted == 'security_station_keyboard') then
			_comp_used = true
			RefreshItemWaypoints(true)
		end
		
		if ( unit:interaction() and unit:interaction()._waypoint_id ~= nil ) then
			remove_waypoint(unit)
		end

		return result
	end
	
	managers.interaction._add_unit = managers.interaction._add_unit or managers.interaction.add_unit
	function ObjectInteractionManager:add_unit( unit )
		local spawned = unit:interaction().tweak_data
		local result = self:_add_unit(unit)
		local level = managers.job:current_level_id()
		
		if ( spawned == "hostage_move" or spawned == "intimidate" ) then
			return result
		end
		
		if spawned == "hlm_roll_carpet" then
			managers.hud:remove_waypoint( "hudz_base_hlm1door" )
			return result
		end
		
		-- KEYCARD COP/CIV : REMOVE WAYPOINT OF THE UNIT WHEN KEYCARD IS DROPPED
		if spawned == 'pickup_keycard' or spawned == 'hold_pku_knife' then
			for id,_ in pairs( managers.hud._hud.waypoints ) do
				id = tostring(id)
				if id:sub(1,9) == 'hudz_civ_' or id:sub(1,9) == 'hudz_cop_' then
					managers.hud:remove_waypoint( id )
					return result
				end
			end
		end

		-- THE BOMB : DOCKYARD
		if spawned == 'hold_pku_disassemble_cro_loot' then
			RefreshItemWaypoints(true)
			_bomb_used = _bomb_used + 1
		end
		if spawned == 'hold_call_captain' then
			for id,_ in pairs( managers.hud._hud.waypoints ) do
				id = tostring(id)
				if id:sub(1,10) == 'hudz_uload' then
					managers.hud:remove_waypoint( id )
				end
			end
			_uldatabase_found = true
		end
		
		DelayedCalls:Add( "RefreshItemWaypoints", 1.0, function() 
			RefreshItemWaypoints(false)
		end )
		
		return result
	end
end