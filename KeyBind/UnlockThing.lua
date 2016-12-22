------------Main Control------------
local SteamAchievements = 0		--解鎖Steam成就(不建議)
local WeaponsUnlocked	= 1		--解鎖所有武器
local UnlockMasks		= 1		--解鎖面具
local WeaponColorVinyls = 1		--解鎖武器掛件、面具色彩、材質(假如開著，載入小LAG)
---------------------------------------------------------------------------------------------------------------------------

-- Steam Achievements 
if SteamAchievements == 1 then
if managers.achievment then
	for id,_ in pairs(managers.achievment.achievments) do managers.achievment:award(id) end
end
end

-- All Weapons Unlocked
if WeaponsUnlocked == 1 then
local wep_arr = {
   'new_m4', 'glock_17', 'mp9', 'r870', 'glock_18c', 'amcar', 'm16', 'olympic', 'ak74', 'akm', 'akmsu', 'saiga', 'ak5', 'aug', 'g36', 'p90', 'new_m14', 'deagle', 'new_mp5', 'colt_1911', 'mac10', 'serbu', 'huntsman', 'b92fs', 'new_raging_bull',  'saw'
}
for i, name in ipairs(wep_arr) do
   if not managers.upgrades:aquired(name) then
      managers.upgrades:aquire(name)
   end
end 
end

-- Unlock All Masks
if UnlockMasks == 1 then

-- gold and santa mask
--managers.network.account._masks["santa"] = true
--managers.network.account._masks["gold"]  = true

managers.blackmarket:_setup_masks()
for mask_id,_ in pairs(tweak_data.blackmarket.masks) do
Global.blackmarket_manager.masks[mask_id].unlocked = true
managers.blackmarket:add_to_inventory("normal", "masks", mask_id, false)
end
require "lib/managers/BlackMarketManager"

MaskExt = MaskExt or class()
local mvec1 = Vector3()
local mvec2 = Vector3()

function MaskExt:init( unit )
	self._unit = unit
	self._blueprint = {}
	
	Application:debug( "MaskExt:new()" )
end

function MaskExt:apply_blueprint( blueprint )
	if not blueprint then
		return
	end
	-- local material_texture, reflection_texture = managers.blackmarket:apply_mask_craft_on_unit( self._unit, blueprint )
	
	
	-- see managers.blackmarket:apply_mask_craft_on_unit( self._unit, blueprint )
	local materials = self._unit:get_objects_by_type( Idstring( "material" ) )
	local material = materials[ #materials ]
	
	local tint_color_a = mvec1
	local tint_color_b = mvec2
	
	
	local pattern_id = blueprint.pattern.id
	local material_id = blueprint.material.id
	local color_data = tweak_data.blackmarket.colors[ blueprint.color.id ]
	
	mvector3.set_static( tint_color_a, color_data.colors[1]:unpack() )
	mvector3.set_static( tint_color_b, color_data.colors[2]:unpack() )
	
	material:set_variable( Idstring( "tint_color_a" ), tint_color_a )
	material:set_variable( Idstring( "tint_color_b" ), tint_color_b )
	
	local old_pattern = self._blueprint[1]
	local pattern = tweak_data.blackmarket.textures[ pattern_id ].texture
	if old_pattern ~= Idstring( pattern ) then
		local pattern_texture = TextureCache:retrieve( pattern, "normal" )
		material:set_texture( "material_texture", pattern_texture )
	end
	
	
	local old_reflection = self._blueprint[2]
	local reflection = tweak_data.blackmarket.materials[ material_id ].texture
	if old_reflection ~= Idstring( reflection ) then
		local reflection_texture = TextureCache:retrieve( reflection, "normal" )
		material:set_texture( "reflection_texture", reflection_texture )
	end
	
	
	local material_amount = tweak_data.blackmarket.materials[ material_id ].material_amount or 1
	material:set_variable( Idstring( "material_amount" ), material_amount )
	
	
	local new_blueprint = { Idstring(pattern), Idstring(reflection) }
	self:unretrieve_blueprint( new_blueprint )
	self._blueprint = new_blueprint
end

function MaskExt:unretrieve_blueprint( new_blueprint )
	-- print( "UNRETRIEVING", inspect( self._blueprint ) )
	
	if self._blueprint then
		for index, texture_ids in pairs( self._blueprint ) do
			if new_blueprint and new_blueprint[index] == texture_ids then
				-- print( "no need to unretrieve this one", texture_ids)
			else
				TextureCache:unretrieve( texture_ids )
			end
		end
	end
	
	self._blueprint = {}
end


function MaskExt:destroy( unit )
	print("MaskExt:destroy")
	self:unretrieve_blueprint()
end

function MaskExt:pre_destroy( unit )
	print("MaskExt:pre_destroy")
	self:unretrieve_blueprint()
end
end

-- Weapon Accessories, Color Palettes, and Mask Vinyls
if WeaponColorVinyls == 1 then
	for i=1, 7 do managers.lootdrop:debug_drop( 1000, true, i ) end
end


