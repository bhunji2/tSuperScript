_G.tSuperScript = _G.tSuperScript or { Dir = ModPath }
------------------------------------------------------------------------------------------------------------------------
_G.tSuperScriptSet_Default = {
 ["Debug"] 				= false	-- 腳本除錯用
,["Lang"] 				= 1 	-- 語言設定(1 = 英文 , 2 = 繁體 , 3 = 簡體)
-- Player Mods
,["GodMode"]			= true	-- 上帝模式(自動模式還需要修正)
,["PlayerArmor"]		= false -- 無限護甲
,["PlayerMods"]			= true 	-- 玩家相關(不限站立、跑步不晃、即刻拆解、無限體力、強制拆解、無閃光彈)
,["SuperJump"]			= 3 	-- 超級跳(1 = 關閉 , 2 = 高級跳 , 3 = 低級跳)
,["MoveSpeed"] 			= 1.5	-- 平常走路速度(跑步會更快) 預設 1.0
,["NoArrested"] 		= true	-- 不會被逮捕
,["NoCustody"] 			= true	-- 不被關監獄(但會被逮捕等待讀秒)
,["Upgrade"]			= true 	-- 強制技能可用(不需設定)
,["NoEXPshake"]			= true	-- 炸類特效不會造成螢幕晃動
-- Stealth Mods
,["GuardsCamera"]		= true 	-- 不被發現(限於自己開房)
,["NoPager"]			= true	-- 殺死警衛不會觸發呼叫
,["InfiniteAnswer"]		= true 	-- 多數情況可裝袋屍體、回應無線電、互動(限於自己開房)
-- Weapon Mods
,["WeaponMods"]			= true	-- 超級武器(射速10倍、切槍無延遲、開槍無散射)
,["InfiniteAmmoClip"]	= true	-- 無限子彈(普通槍枝)
,["NoRecoil"]			= true	-- 開槍無後做力
,["ShootShield"]		= true	-- 子彈穿過盾牌
,["ShootEnemy"]			= true	-- 子彈穿過敵人
,["ShootWall"]			= true	-- 子彈穿過牆壁
,["ShieldKnock"]		= true	-- 盾牌擊退
,["ShootStagger"]		= true	-- 擊退效果擴大至倒地，包括近戰攻擊
,["ShootSuppression"]	= true	-- 開槍震撼敵人(僅限於部分敵人種類)

,["SentryGunGodMode"]	= true	-- 機槍塔無敵模式
,["SentryGunSpread"]	= true  -- 機槍塔關閉散射
,["SentryGunFireRate"]	= true	-- 機槍塔超快射速
,["SentryGunAmmo"]		= true 	-- 機槍塔無限子彈
-- Adv Mods
,["InfiniteCableTies"]	= true 	-- 無限綁手圈
,["InfiniteEquipment"]	= true 	-- 無限物品(限於自己開房)
,["DoctorBag"]			= true 	-- 無限醫療箱
,["FastDrilling"]		= true 	-- 鑽槍快速解鎖
,["DeadCiviNone"]		= true 	-- 殺死人質不扣錢(加強，限自己開房)
,["Carrymods"]			= true 	-- 負重控制(拿重物可奔跑、跳躍、丟更遠、不減速、無延遲)
,["SecureBag"] 			= true	-- 警察不拿包(限於自己開房)
,["InstantMask"] 		= true	-- 面具馬上戴上
,["MaskOff"] 			= true	-- 沒戴上面具時可用一些蹲跑跳及互動功能
,["InteractRange"] 		= 500	-- F互動功能最遠觸及距離(2萬以上等於無限) 預設 200
,["JobShow"] 			= 1.0	-- 任務出現速率(雜亂模式) 單位為秒
,["MarkEnemies"] 		= true	-- 標記警察、市民、監視器發亮
,["SecureBodyBag"]		= true	-- 屍袋可被確保換錢
,["MarkObject"]			= true	-- 任務物品標記 v2.7 ( 功能作者：gir489 ) 
-- Other Mods
,["TextUpper"]			= true	-- 關閉遊戲英文全部大寫
,["GiveXP"]				= 300	-- 強制過關獲得多少經驗：千單位倍數
,["GiveMoney"]			= 10000	-- 強制過關獲得多少金錢：萬元單位倍數
,["InGameMap"]			= true	-- 擁有前置計畫的地圖可顯示遊戲中小地圖
,["InGameMapRotate"]	= true	-- 遊戲中小地圖是否隨著視線轉向
,["InGameMapZoom"]		= 1.0	-- 遊戲中小地圖縮放大小，預設：1.0
}

-- %appdata%\..\Local\PAYDAY 2
-- %localappdata%\PAYDAY 2\

_G.tSuperScriptSet  = _G.tSuperScriptSet  or _G.tSuperScriptSet_Default
_G.tSuperScriptFunc = _G.tSuperScriptFunc or {}
------------------------------------------------------------------------------------------------------------------------
function tSuperScriptFunc:Check()
	for k, v in pairs(_G.tSuperScriptSet_Default) do
		local exists = false
		local vOld	 = nil
		for k2, v2 in pairs(_G.tSuperScriptSet) do
			if k == k2 then 
				--log(k.." - "..tostring(type(v))..":"..tostring(type(v2)))
				vOld 	= v2
				if type(v) == type(v2) then exists 	= true end
				break
			end
		end
		
		if exists == false then 
			_G.tSuperScriptSet[k] = v
			log("updated["..tostring(k).."]:"..tostring(vOld).." --> "..tostring(v))
		end
	end
	
	--log("tSuperScriptSet:"			..tostring(TabLen(_G.tSuperScriptSet)))
	--log("tSuperScriptSet_Default:"	..tostring(TabLen(_G.tSuperScriptSet_Default)))
	--log(tostring(TabLen(_G.tSuperScriptSet) == TabLen(_G.tSuperScriptSet_Default)))
	--return TabLen(_G.tSuperScriptSet) == TabLen(_G.tSuperScriptSet_Default)
	--_G.SaveTable( _G.tSuperScriptSet,"Table_Test.ini")
	--_G.SaveTable( _G.tSuperScriptSet_Default,"Table_Test2.ini")
	
	--if TabLen(_G.tSuperScriptSet) == TabLen(_G.tSuperScriptSet_Default) then return true end
end

function tSuperScriptFunc:Load()
	local file = io.open(SavePath.."tSuperScript.txt", "r")
	if not file then 
		log("tSuperScriptFunc:Load Error:Can't read from config file.")
		return false 
	end
	
	local JsonCode = json.decode(file:read("*all"))
	_G.tSuperScriptSet = JsonCode
	self:Check()
	file:close()
	return true
end

function tSuperScriptFunc:Save(VarName,VarValue)
	if VarName and VarValue then _G.tSuperScriptSet[VarName] = VarValue end
	
	local file = io.open(SavePath.."tSuperScript.txt", "w+")
	if not file then 
		log("tSuperScriptFunc:Save Error:Can't write to config file.")
		return false 
	end
	
	file:write(json.encode(_G.tSuperScriptSet))
	file:close()
	return true
end

function tSuperScriptFunc:Reset()
	_G.tSuperScriptSet  = _G.tSuperScriptSet_Default
	local success = self:Save()
	log("tScript Reset Status:" .. tostring(success))
end

function tSuperScriptFunc:GetData(VarName)
	if VarName then return _G.tSuperScriptSet[VarName] end
	return _G.tSuperScriptSet
end

tSuperScriptFunc:Load()

------------------------------------------------------------------------------------------------------------------------

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_tSuperScript", function(loc)
	local AR_Loc  = { "english" , "Tchinese" , "Schinese" }
	local LocFile = AR_Loc[_G.tSuperScriptSet["Lang"]]
	loc:load_localization_file(tSuperScript.Dir .. "/Localization/english.txt")
	loc:load_localization_file(tSuperScript.Dir .. "/Localization/"..LocFile..".txt")
end)

------------------------------------------------------------------------------------------------------------------------

if _G.tSuperScriptSet["TextUpper"] == true then utf8.to_upper = function(text) return text end end

------------------------------------------------------------------------------------------------------------------------

--[[
function TabLen(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end
]]


--local Table_Json = json.decode("{'text':854}")

--log(tostring(Table_Test))







--if true then return end