
module("FightUILayer", package.seeall)

--require "Script/Common/Common"
require "Script/Audio/AudioUtil"
require "Script/Common/LabelLayer"

---add by sxin 增加场景调用接口针对ui层不需要知道真正的场景脚本只需要调用接口
local m_ScenceInterface = nil

local m_playerFightUI = nil

local m_ptextDelay = nil
local m_ptextAround = nil
local m_ptextMoney = nil
local m_ptextBox = nil

local m_nDelayTime = nil
local m_nHanderTime = nil
local m_playScene = nil

local m_tableHeroIndex = {}
local m_nHeroCount = 0

local m_tableAllBox = {}
local m_tableDeadHero = {}
local m_nBoxCount = 1


local m_bHide = true
local m_autoWarRecorderNum = nil
local m_tableEnemyIndex = {}
local m_nEnemyCount = 0

local StrokeLabel_createStrokeLabel 	= LabelLayer.createStrokeLabel
local StrokeLabel_setText 				= LabelLayer.setText
local StrokeLabel_getText 				= LabelLayer.getText

local StrokeLabel_hero_powerTag = 199
local StrokeLabel_minute_Tag = 299
local StrokeLabel_second_Tag = 300
local StrokeLabel_money_Tag = 301
local StrokeLabel_box_Tag = 302
local StrokeLabel_enemyLevel_Tag = 303

local SaveFightSet        = LoginLogic.SaveFightSet
local GetFightSet        = LoginLogic.GetFightSet

local function SizeOfTable(tb)
    local size=0
    for k,v in pairs(tb) do
    	if k < 10 then 
        	size=size+1
    	else 
    		break
    	end
    end
    return size
end

--开始战斗
function BeginFightByUI(  )
	m_playScene = true
	for i=1,SizeOfTable(m_tableHeroIndex) do
		--if m_tableDeadHero[i]~=nil then
			if m_tableDeadHero[i] ~=nil and m_tableDeadHero[i]["isDead"] == true then 
				--print(i.."英雄已死亡，不再显示技能")
				--continue
			else
				local Image_Click_0 = tolua.cast(m_playerFightUI:getWidgetByName("Image_Click_0" .. i), "ImageView")
				if Image_Click_0:getChildByTag(108) ~= nil then Image_Click_0:getChildByTag(108):setVisible(true) end
				--print("显示场上存活英雄循环动画   "..i)
			end
		--end
	end
	local Image_hufa_click = tolua.cast(m_playerFightUI:getWidgetByName("Image_hufa_click"), "ImageView")
	if Image_hufa_click:getChildByTag(108) ~= nil then Image_hufa_click:getChildByTag(108):setVisible(true) end
end

--结束战斗

function EndFightByUI(  )
	m_playScene = false
	for i=1,SizeOfTable(m_tableHeroIndex) do
		--if m_tableDeadHero[i]~=nil and m_tableDeadHero[i]["isDead"] == true then 
		--	break
		--else
			local Image_Click_0 = tolua.cast(m_playerFightUI:getWidgetByName("Image_Click_0" .. i), "ImageView")
			if Image_Click_0:getChildByTag(108) ~= nil then Image_Click_0:getChildByTag(108):setVisible(false) end
			--print("隐藏场上存活英雄循环动画   "..i)
		--end
		--d
	end
	local Image_hufa_click = tolua.cast(m_playerFightUI:getWidgetByName("Image_hufa_click"), "ImageView")
	if Image_hufa_click:getChildByTag(108) ~= nil then Image_hufa_click:getChildByTag(108):setVisible(false) end
end

-- 收起全部宝箱
function TakeAllBox()
	print("TakeAllBox = " .. table.maxn(m_tableAllBox))
	for key,value in pairs(m_tableAllBox) do
		local _Panel_1 = tolua.cast(value.Layout, "Layout")
		local nItemId = value.nItemId
		--print(_Panel_1)
		--print(nItemId)
		if _Panel_1 ~= nil then
			if _Panel_1:isVisible() == true then
				require "Script/serverDB/item"
				--require "Script/serverDB/resimg"
				--local imgPath = resimg.getFieldByIdAndIndex(item.getFieldByIdAndIndex(nItemId, "res_id"), "icon_path")
				--if imgPath ~= nil then
				--	local _Img_icon = ImageView:create()
				--	_Img_icon:loadTexture(imgPath)
				--	if _Panel_1:getChildByTag(50) ~= nil then
				--		_Panel_1:getChildByTag(50):removeFromParentAndCleanup(true)
				--	end
				--	if _Panel_1:getChildByTag(100) ~= nil then
				--		_Panel_1:getChildByTag(100):removeFromParentAndCleanup(true)
				--	end
				--	_Panel_1:addChild(_Img_icon)
				--end
				local ptDes = ccp(visibleSize.width-50-180, visibleSize.height - 50)
				local actionCur = CCArray:create()
				actionCur:addObject(CCScaleTo:create(0.05, 1.2))
				actionCur:addObject(CCDelayTime:create(0.2))
				actionCur:addObject(CCMoveTo:create(0.5, ptDes))
				actionCur:addObject(CCScaleTo:create(0.5, 0))
				local function HideSelf()
					_Panel_1:setVisible(false)

    				local Image_9 = tolua.cast(m_playerFightUI:getWidgetByName("Image_9"), "ImageView")
    				local strText = StrokeLabel_getText(Image_9:getChildByTag(StrokeLabel_box_Tag))
					local nCount = tonumber(strText)
					nCount = nCount + 1
					if nCount > m_nBoxCount then nCount = m_nBoxCount end
					SetFightTitleBox(nCount)
				end
				actionCur:addObject(CCCallFuncN:create(HideSelf))
				_Panel_1:stopAllActions()
				if _Panel_1:getChildByTag(50) ~= nil then
					_Panel_1:getChildByTag(50):setColor(COLOR_White)
				end
				if _Panel_1:getChildByTag(100) ~= nil then
					_Panel_1:getChildByTag(100):setColor(COLOR_White)
				end
				_Panel_1:runAction(CCSequence:create(actionCur))
			end
		end
	end
	m_tableAllBox = {}
end

function setFightContrlColor(color)
	for key,value in pairs(m_tableAllBox) do
		if value.Layout ~= nil then
			local _Panel_1 = tolua.cast(value.Layout, "Layout")
			if _Panel_1 ~= nil then
				if _Panel_1:getChildByTag(50) ~= nil then
					_Panel_1:getChildByTag(50):setColor(color)
				end
				if _Panel_1:getChildByTag(100) ~= nil then
					_Panel_1:getChildByTag(100):setColor(color)
				end
			end
		end
	end
end

-- 添加掉落宝箱
function AddBox(ptBoxPos, nItemId)
	local _Panel_1 = Layout:create()
	local _Img_bk_1 = ImageView:create()
	--_Img_bk_1:loadTexture("Image/Fight/UI/box_light.png")
	_Panel_1:addChild(_Img_bk_1, 0, 50)
	_Panel_1:setAnchorPoint(ccp(0,0))
	local actionCur = CCArray:create()
	actionCur:addObject(CCRotateTo:create(2, 180))
	actionCur:addObject(CCRotateTo:create(2, 360))
    _Img_bk_1:runAction(CCRepeatForever:create(CCSequence:create(actionCur)))
	local actionCur1 = CCArray:create()
	actionCur1:addObject(CCScaleTo:create(2, 0.5))
	actionCur1:addObject(CCScaleTo:create(2, 1))
    _Img_bk_1:runAction(CCRepeatForever:create(CCSequence:create(actionCur1)))
	
	local function _Click_Btn_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
			require "Script/serverDB/item"
			require "Script/serverDB/resimg"
			print("nItemId = " .. nItemId)
			local imgPath = resimg.getFieldByIdAndIndex(item.getFieldByIdAndIndex(nItemId, "res_id"), "icon_path")
			if imgPath ~= nil then
				local _Img_icon = ImageView:create()
				_Img_icon:setScale(0.68)
				_Img_icon:loadTexture(imgPath)
				_Panel_1:getChildByTag(50):removeFromParentAndCleanup(true)
				_Panel_1:getChildByTag(100):removeFromParentAndCleanup(true)
				_Panel_1:addChild(_Img_icon)
			end
			
			local ptDes = ccp(visibleSize.width-50-180, visibleSize.height - 50)
			local actionCur = CCArray:create()
			actionCur:addObject(CCScaleTo:create(0.05, 1.2))
			actionCur:addObject(CCDelayTime:create(0.2))
			actionCur:addObject(CCMoveTo:create(0.5, ptDes))
			actionCur:addObject(CCScaleTo:create(0.5, 0))
			local function HideSelf()
				_Panel_1:setVisible(false)

				local Image_9 = tolua.cast(m_playerFightUI:getWidgetByName("Image_9"), "ImageView")
    			local strText = StrokeLabel_getText(Image_9:getChildByTag(StrokeLabel_box_Tag))
				local nCount = tonumber(strText)
				nCount = nCount + 1

				if nCount > m_nBoxCount then nCount = m_nBoxCount end
				SetFightTitleBox(nCount)
			end
			actionCur:addObject(CCCallFuncN:create(HideSelf))
			_Panel_1:stopAllActions()
			_Panel_1:runAction(CCSequence:create(actionCur))
		end
	end
	
	local _btn_Box = Button:create()
	_btn_Box:loadTextureNormal("Image/imgres/Fight/UI/box.png")
	_btn_Box:loadTexturePressed("Image/imgres/Fight/UI/box.png")
	_btn_Box:setTouchEnabled(true)
	_btn_Box:setEnabled(true)
	_btn_Box:addTouchEventListener(_Click_Btn_CallBack)
	_Panel_1:addChild(_btn_Box, 1, 100)
	_Panel_1:setTouchEnabled(true)
	ptBoxPos.y = math.random(235, 255) 
	_Panel_1:setPosition(ptBoxPos)
	if math.random(1, 3) ~= 1 then
		_Panel_1:runAction(CCJumpTo:create(0.5, ccp(ptBoxPos.x-math.random(0, 300), ptBoxPos.y-25), 25, 2))
	else
		_Panel_1:runAction(CCJumpTo:create(0.5, ccp(ptBoxPos.x+math.random(0, 100), ptBoxPos.y-25), 25, 2))
	end
	m_playerFightUI:addWidget(_Panel_1)
	m_tableAllBox[m_nBoxCount] = {["nItemId"] = nItemId, ["Layout"] = _Panel_1}
	m_nBoxCount = m_nBoxCount + 1
end

-- 是否自动战斗
function FightAutoFightClick(bFight)
	m_ScenceInterface:SetFightAuto(bFight)
	local CheckBox_AutoFight = tolua.cast(m_playerFightUI:getWidgetByName("CheckBox_10"), "CheckBox")
	SaveFightSet(bFight)
end

local function Click_Skill_Action(nIndex)
	local Image_Click_0 = tolua.cast(m_playerFightUI:getWidgetByName("Image_Click_0" .. nIndex), "ImageView")
	local nType = Image_Click_0:getTag()
	if nType <= 0 or nType > 3 then return end
	if Image_Click_0:getChildByTag(108) ~= nil then
		Image_Click_0:removeChildByTag(108, true)
		--print("删除英雄"..nIndex.."号的循环动画")
	end

	local Image_hero_bk_01 = tolua.cast(m_playerFightUI:getWidgetByName("Image_hero_bk_0" .. nIndex), "ImageView")

	local array_action = CCArray:create()
	array_action:addObject(CCScaleTo:create(0.05, 1.12))
	array_action:addObject(CCScaleTo:create(0.05, 0.94))
	array_action:addObject(CCScaleTo:create(0.05, 1.06))
	array_action:addObject(CCScaleTo:create(0.05, 1.0))
	local actions = CCSequence:create(array_action)
	Image_hero_bk_01:runAction(actions)


	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/Fight/UI/Animation/Fight_Skill_001_lq.ExportJson")
	local PayArmature = CCArmature:create("Fight_Skill_001_lq")

	PayArmature:getAnimation():play("Animation2")
	PayArmature:setPosition(ccp(0, 0))
	local function onMovementEvent(armatureBack,movementType,movementID)
		if movementType == 1 then
			--判断是否存在爆炸动画，存在则删除（因为已经播放完毕）
			if Image_Click_0:getChildByTag(109) ~= nil then
				Image_Click_0:removeChildByTag(109, true)
				--print("删除英雄"..nIndex.."号的爆炸动画")
				Image_Click_0:setTag(0)
				local ProgressBar_Power = tolua.cast(m_playerFightUI:getWidgetByName("ProgressBar_hero_power_0"..nIndex),"LoadingBar")
				ProgressBar_Power:setTag(0 + nIndex)
				local pPowerText = ProgressBar_Power:getChildByTag(StrokeLabel_hero_powerTag)
				pPowerText:setVisible(false)
				StrokeLabel_setText(pPowerText,"X0")
			end
		end
	end

	PayArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)
	local layout = Layout:create()
	layout:setTouchEnabled(false)
	layout:addNode(PayArmature)
	--将爆炸动画添加到Image_Click_0上，Tag值为109
	Image_Click_0:addChild(layout, 10, 109)
end

-- 使用英雄技能 nIndex为索引
function FightSkillBtnClick(nIndex)
	if SizeOfTable(m_tableHeroIndex) < nIndex then return end
	local ProgressBar_hero_power = tolua.cast(m_playerFightUI:getWidgetByName("ProgressBar_hero_power_0" .. nIndex), "LoadingBar")
	if ProgressBar_hero_power ~= nil then
		if ProgressBar_hero_power:getPercent() + 100 <= 99 then  return end
	end
	-- 调C++
	local nRealIndex = 0
	for key,value in pairs(m_tableHeroIndex) do
		if value == nIndex then
			nRealIndex = key
			break
		end
	end

	if m_ScenceInterface:IsPKScene() == false then 
		if m_ScenceInterface:CanUseEngineSkill(nRealIndex) == true then
			m_ScenceInterface:UseEngineSkill(nRealIndex)
			Click_Skill_Action(nIndex)
		end
	end
end

-- 设置技能进度血量等 参数：nIndex英雄索引（1-5） nHp英雄血量（百分比） nPower英雄能量（百分比）
function SetFightHp(nIndex, nHp, imgPath, nPinZhi)
	if nHp > 100 or nHp < 0 then return end
	if m_tableHeroIndex[nIndex] == nil then
		m_nHeroCount = m_nHeroCount + 1
		m_tableHeroIndex[nIndex] = m_nHeroCount
		m_tableHeroIndex[nIndex+10] = imgPath
		local Image_Icon = tolua.cast(m_playerFightUI:getWidgetByName("Image_hero_bk_0" .. m_tableHeroIndex[nIndex]), "ImageView")
		Image_Icon:setVisible(true)
	
		local Image_head = tolua.cast(m_playerFightUI:getWidgetByName("Image_hero_bk_0" .. m_tableHeroIndex[nIndex]), "Layout")
		local Image_head_bottom = tolua.cast(Image_head:getChildByName("Image_bkFrame"), "ImageView")
		Image_head_bottom:loadTexture("Image/imgres/common/color/wj_pz" .. nPinZhi .. ".png")

		local Image_hero_hp_0 = tolua.cast(m_playerFightUI:getWidgetByName("Image_hero_hp_0" .. m_tableHeroIndex[nIndex]), "ImageView")
	    Image_hero_hp_0:setVisible(true)

	    local Image_hero_power_0 = tolua.cast(m_playerFightUI:getWidgetByName("Image_hero_power_0" .. m_tableHeroIndex[nIndex]), "ImageView")
	    Image_hero_power_0:setVisible(true)
	end
	
	if imgPath ~= nil then
		local root = tolua.cast(m_playerFightUI:getWidgetByName("Image_hero_bk_0" .. m_tableHeroIndex[nIndex]), "Layout")
		local Image_head_bottom = tolua.cast(root:getChildByName("Image_bkFrame"), "ImageView")		
		Image_head_bottom:loadTexture("Image/imgres/common/color/wj_pz" .. nPinZhi .. ".png")
		local Image_heroHead = tolua.cast(root:getChildByName("Image_HeroHead"), "ImageView")
		Image_heroHead:loadTexture(imgPath)
		if root:getVirtualRenderer():getChildByTag(100) ~= nil then
	    	root:getVirtualRenderer():removeChildByTag(100, true)
		end
		local Image_Click_0 = tolua.cast(m_playerFightUI:getWidgetByName("Image_Click_0" .. m_tableHeroIndex[nIndex]), "ImageView")
		Image_Click_0:setTouchEnabled(true)
	end
	
	local ProgressBar_Hp = tolua.cast(m_playerFightUI:getWidgetByName("ProgressBar_hero_hp_0" .. m_tableHeroIndex[nIndex]), "LoadingBar")
	ProgressBar_Hp:setPercent(nHp)
	if nHp <= 0 then
		-- 死了。变灰
		--print("死了。变灰" .. m_tableHeroIndex[nIndex] .. " " .. nIndex .. " " .. nHp)
		m_tableDeadHero[nIndex] = {}
		m_tableDeadHero[nIndex]["isDead"] = true
		local root = tolua.cast(m_playerFightUI:getWidgetByName("Image_hero_bk_0" .. m_tableHeroIndex[nIndex]), "ImageView")
		if root:getVirtualRenderer():getChildByTag(100) ~= nil then
	    	root:getVirtualRenderer():removeChildByTag(100, true)
		end
		local ProgressBar_hero_power = tolua.cast(m_playerFightUI:getWidgetByName("ProgressBar_hero_power_0" .. m_tableHeroIndex[nIndex]), "LoadingBar")
		local pPowerText = ProgressBar_hero_power:getChildByTag(StrokeLabel_hero_powerTag)
		ProgressBar_hero_power:setPercent(0)
		pPowerText:setVisible(false)

		--头像置灰
		local Image_heroHead = tolua.cast(root:getChildByName("Image_HeroHead"), "ImageView")
		local Image_heroHead_sprite = tolua.cast(Image_heroHead:getVirtualRenderer(), "CCSprite")
		SpriteSetGray(Image_heroHead_sprite,1)

		local Image_Click_0 = tolua.cast(m_playerFightUI:getWidgetByName("Image_Click_0" .. m_tableHeroIndex[nIndex]), "ImageView")
		if Image_Click_0:getChildByTag(108) ~= nil then
			Image_Click_0:removeChildByTag(108, true)
			--print("英雄"..nIndex.."已死，不再实现动画")
		end
	end
end


local function MakeEffect(nIndex, nPower, nLastPower)
	local nType = 0
	local Image_Click_0 = tolua.cast(m_playerFightUI:getWidgetByName("Image_Click_0" .. nIndex), "ImageView")
	local ProgressBar_Power = tolua.cast(m_playerFightUI:getWidgetByName("ProgressBar_hero_power_0"..nIndex),"LoadingBar")
	local pPowerText = ProgressBar_Power:getChildByTag(StrokeLabel_hero_powerTag)
	if nPower < 100 then
		pPowerText:setVisible(false)
		if Image_Click_0:getChildByTag(108) ~= nil then
			Image_Click_0:removeChildByTag(108, true)
		end
		if nLastPower ~= nil and nLastPower >= 100 and nLastPower > nPower then
			--print("英雄"..nIndex.."当前能量值为 ："..nPower.." || 上次记录的能量值为 ： "..nLastPower)
			Click_Skill_Action(nIndex)
		end
		return 
	end
	local powerStr = nil
	if nPower >= 100 and nPower < 200 then
	 	nType = 1 
	 	ProgressBar_Power:setTag(nPower)
	 	ProgressBar_Power:setPercent(nPower - 100)
		powerStr = "X1"
	end
	if nPower >= 200 and nPower < 300 then 
		nType = 2 
	 	ProgressBar_Power:setPercent(nPower - 200)
		powerStr = "X2"
	end
	if nPower >= 300 then 
		nType = 3 
	 	ProgressBar_Power:setPercent(100)
		powerStr = "X3"
	end
	pPowerText:setVisible(true)
	StrokeLabel_setText(pPowerText,powerStr)

	if Image_Click_0:getTag() == nType then return end
	local function onMovementEvent()
		--播放循环动画之前判断是否已存在，存在则先删除
		Image_Click_0:setTag(nType)
		if Image_Click_0:getChildByTag(108) ~= nil then return end
		
		local Image_Click_0 = tolua.cast(m_playerFightUI:getWidgetByName("Image_Click_0" .. nIndex), "ImageView")
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/Fight/UI/Animation/Fight_Skill_001_lq.ExportJson")
		local PayArmature = CCArmature:create("Fight_Skill_001_lq")

	  	local str = "Animation1"
	  	PayArmature:getAnimation():play(str)
	  	PayArmature:setPosition(ccp(0, 0))
	  	PayArmature:setTag(nIndex)
	  	--PayArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)

	  	local layout = Layout:create()
	  	layout:setTouchEnabled(false)
	  	layout:addNode(PayArmature)
	  	Image_Click_0:addChild(layout, 10, 108)
	  	if m_playScene then
	  		layout:setVisible(true)
	  	else
	  		layout:setVisible(false)
	  	end
	  	--print("英雄"..nIndex.."添加动画并显示咯~~~")
	end
	local array_action = CCArray:create()
	array_action:addObject(CCScaleTo:create(0.2,1.5))
	array_action:addObject(CCScaleTo:create(0.2,1))
	array_action:addObject(CCCallFunc:create(onMovementEvent))
	local action_item = CCSequence:create(array_action)
	pPowerText:runAction(action_item)
  	--Image_Click_0:setTag(nType)	
end

-- 设置技能进度血量等 参数：nIndex英雄索引（1-5） nHp英雄血量（百分比） nPower英雄能量（百分比）
function SetFightPower(nIndex, nPower, imgPath, nPinZhi)
	--print("英雄"..nIndex.." 能量值为 = "..nPower)
	if nPower < 0 or nPower > 300 then return end
	if m_tableHeroIndex[nIndex] == nil then
		m_nHeroCount = m_nHeroCount + 1
		m_tableHeroIndex[nIndex] = m_nHeroCount
		local Image_Icon = tolua.cast(m_playerFightUI:getWidgetByName("Image_hero_bk_0" .. m_tableHeroIndex[nIndex]), "ImageView")
		if nPinZhi ~= nil then
			local Image_head = tolua.cast(m_playerFightUI:getWidgetByName("Image_hero_bk_0" .. m_tableHeroIndex[nIndex]), "Layout")
			local Image_head_bottom = tolua.cast(Image_head:getChildByName("Image_bkFrame"), "ImageView")
			Image_head_bottom:loadTexture("Image/imgres/common/color/wj_pz" .. nPinZhi .. ".png")
		end
		Image_Icon:setVisible(true)
		local Image_hero_hp_0 = tolua.cast(m_playerFightUI:getWidgetByName("Image_hero_hp_0" .. m_tableHeroIndex[nIndex]), "ImageView")
	    Image_hero_hp_0:setVisible(true)
	    local Image_hero_power_0 = tolua.cast(m_playerFightUI:getWidgetByName("Image_hero_power_0" .. m_tableHeroIndex[nIndex]), "ImageView")
	    Image_hero_power_0:setVisible(true)
	    local ProgressBar_Power = tolua.cast(m_playerFightUI:getWidgetByName("ProgressBar_hero_power_0"..m_tableHeroIndex[nIndex]),"LoadingBar")
	   	ProgressBar_Power:setPercent(0) 
	end
	
	if imgPath ~= nil then
		local root = tolua.cast(m_playerFightUI:getWidgetByName("Image_hero_bk_0" .. m_tableHeroIndex[nIndex]), "ImageView")
		if nPinZhi ~= nil then
			--root:loadTexture("Image/common/pinzhi_icon/head_bk_0" .. nPinZhi .. ".png")
			local Image_head = tolua.cast(m_playerFightUI:getWidgetByName("Image_hero_bk_0" .. m_tableHeroIndex[nIndex]), "Layout")
			local Image_head_bottom = tolua.cast(Image_head:getChildByName("Image_bkFrame"), "ImageView")
			Image_head_bottom:loadTexture("Image/imgres/common/color/wj_pz" .. nPinZhi .. ".png")
		end
	end

	local Image_Icon = tolua.cast(m_playerFightUI:getWidgetByName("Image_hero_bk_0" .. m_tableHeroIndex[nIndex]), "ImageView")
	local nLastPower = 0

	--设置能量槽
	local ProgressBar_Power = tolua.cast(m_playerFightUI:getWidgetByName("ProgressBar_hero_power_0"..m_tableHeroIndex[nIndex]),"LoadingBar")
	if nPower >=0 and nPower <= 100 then 
		nLastPower = ProgressBar_Power:getTag()
		ProgressBar_Power:setPercent(nPower)
		if nPower == 100 then ProgressBar_Power:setPercent(0) end
	end

	if ProgressBar_Power:getChildByTag(StrokeLabel_hero_powerTag)~=nil then
		ProgressBar_Power:removeChildByTag(StrokeLabel_hero_powerTag,true)
	end
	local pPowerText = StrokeLabel_createStrokeLabel(20, CommonData.g_FONT1, "X0", ccp(0, 0), ccc3(38,29,19), COLOR_White, true, ccp(0, 0), 2)
	ProgressBar_Power:addChild(pPowerText, 1, StrokeLabel_hero_powerTag)
	pPowerText:setVisible(false)
		
	MakeEffect(m_tableHeroIndex[nIndex], nPower, nLastPower)
end

-- 设置回合数、金币数、宝箱数等
function SetFightTitleAround(cur, all)
    local AtlasLabel_cur = tolua.cast(m_playerFightUI:getWidgetByName("AtlasLabel_70"), "LabelAtlas")
	AtlasLabel_cur:setStringValue(cur)
	if tonumber(all) == 0 then
		all = 1
	end
    local AtlasLabel_all = tolua.cast(m_playerFightUI:getWidgetByName("AtlasLabel_71"), "LabelAtlas")
	AtlasLabel_all:setStringValue(all)
	--print("----------------cur = "..cur)
	for i=1,5 do
		--print(i.."set false")
		local Image_enemy = tolua.cast(m_playerFightUI:getWidgetByName("Image_enemy_0"..i), "ImageView")
		Image_enemy:setVisible(false)
	end
end

function SetFightTitleMoney(nMoney)
	local Image_8 = tolua.cast(m_playerFightUI:getWidgetByName("Image_8"), "ImageView")
	StrokeLabel_setText(Image_8:getChildByTag(StrokeLabel_money_Tag),nMoney)	
end

function SetFightTitleBox(nBox)
	local Image_9 = tolua.cast(m_playerFightUI:getWidgetByName("Image_9"), "ImageView")
	StrokeLabel_setText(Image_9:getChildByTag(StrokeLabel_box_Tag),nBox) 
end

-- 设置倒记时时间，单位秒
function SetFightDelayTime(nSecend)
	if nSecend < 0 then return end
	m_nDelayTime = nSecend
	local strM = math.floor(nSecend/60)
	local strS = math.floor(nSecend%60)
	local strTemp = ""
	if tonumber(strM) < 10 then strM = "0" .. strM end
	if tonumber(strS) < 10 then strS = "0" .. strS end

	local Image_HourBg = tolua.cast(m_playerFightUI:getWidgetByName("Image_HourBg"), "ImageView")
	StrokeLabel_setText(Image_HourBg:getChildByTag(StrokeLabel_minute_Tag),strM)
	StrokeLabel_setText(Image_HourBg:getChildByTag(StrokeLabel_second_Tag),strS)

	local function tick(dt)
		if m_nDelayTime == 0 then
		-- 时间到了。战斗结束
			--print("时间到了。战斗结束")
			m_playerFightUI:getScheduler():unscheduleScriptEntry(m_nHanderTime)
			m_nHanderTime = nil
			-- 调C++
			m_ScenceInterface:OnTimeOver()
		end
		if m_ScenceInterface:JudgeGamePause() == false then
			m_nDelayTime = m_nDelayTime -1
			SetFightDelayTime(m_nDelayTime)
		end
	end
	if m_nHanderTime == nil then
		m_nHanderTime = m_playerFightUI:getScheduler():scheduleScriptFunc(tick, 1, false)
	end
end
-- 停止计时
function StopFightDelayTime()
	if m_nHanderTime ~= nil then
		m_playerFightUI:getScheduler():unscheduleScriptEntry(m_nHanderTime)
		m_nHanderTime = nil
	end
end
-- 开始计时
function ContinueFightDelayTime()
	SetFightDelayTime(m_nDelayTime)
end

local function Click_Hufa_Action()
	
	local Image_hufa_click = tolua.cast(m_playerFightUI:getWidgetByName("Image_hufa_click"), "ImageView")

	if Image_hufa_click:getChildByTag(108) ~= nil then
		Image_hufa_click:removeChildByTag(108, true)
	end
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/Fight/UI/Animation/Fight_Skill_001_lq.ExportJson")
	local PayArmature = CCArmature:create("Fight_Skill_001_lq")
	PayArmature:getAnimation():play("Animation2")
	PayArmature:setPosition(ccp(0, 0))

	local function onMovementEvent(armatureBack,movementType,movementID)
		if movementType == 1 then
			if Image_hufa_click:getChildByTag(108) ~= nil then
				Image_hufa_click:removeChildByTag(108, true)
			end
		end
	end

	PayArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)
	local layout = Layout:create()
	layout:setTouchEnabled(false)
	layout:addNode(PayArmature)
	layout:setPosition(ccp(0, 0))
	Image_hufa_click:addChild(layout, 10, 108)
	Image_hufa_click:setTag(0)
end
-- 设置护法信息
function setHuFaInfo(nPower, imgPath, nPinZhi)
	if imgPath ~= nil then
		local Image_hufa_bk = tolua.cast(m_playerFightUI:getWidgetByName("Image_hufa_bk"), "ImageView")
		local Image_hufa_click = tolua.cast(m_playerFightUI:getWidgetByName("Image_hufa_click"), "ImageView")
		Image_hufa_bk:setPosition(ccp(Image_hufa_bk:getPositionX() + CommonData.g_Origin.x,Image_hufa_bk:getPositionY() - CommonData.g_Origin.y))
		Image_hufa_bk:setVisible(true)
		Image_hufa_click:setTouchEnabled(true)
		local Image_bkFrame_hufa = tolua.cast(m_playerFightUI:getWidgetByName("Image_bkFrame_hufa"), "ImageView")
		local Image_HeroHead_hufa = tolua.cast(m_playerFightUI:getWidgetByName("Image_HeroHead_hufa"), "ImageView")
		Image_bkFrame_hufa:loadTexture("Image/imgres/common/color/wj_pz" .. nPinZhi .. ".png")
		Image_HeroHead_hufa:loadTexture(imgPath)
	end
	----------------------------技能进度条
	local nLastPower = 0
	local ProgressBar_hufa_power = tolua.cast(m_playerFightUI:getWidgetByName("ProgressBar_hufa_power"), "LoadingBar")
	nLastPower = ProgressBar_hufa_power:getPercent()
	if nPower >= 100 then
		ProgressBar_hufa_power:setPercent(100)
	else
		ProgressBar_hufa_power:setPercent(nPower)
	end
	--print("nPower = "..nPower)
	--print("ProgressBar_hufa_power Percent = "..ProgressBar_hufa_power:getPercent())

	if nPower >= 100 then
		--print("Power满辣  创建动画辣")
		local Image_hufa_click = tolua.cast(m_playerFightUI:getWidgetByName("Image_hufa_click"), "ImageView")
		if Image_hufa_click:getTag() == nPower then return end

		if Image_hufa_click:getChildByTag(108) ~= nil then
			Image_hufa_click:removeChildByTag(108, true)
		end
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/Fight/UI/Animation/Fight_Skill_001_lq.ExportJson")
		local PayArmature = CCArmature:create("Fight_Skill_001_lq")
		PayArmature:getAnimation():play("Animation1")
		PayArmature:setPosition(ccp(0, 0))

		local function onMovementEvent(armatureBack,movementType,movementID)
			if movementType == 1 then
				if Image_hufa_click:getChildByTag(108) ~= nil then
					Image_hufa_click:removeChildByTag(108, true)
				end
				CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/Fight/UI/Animation/Fight_Skill_001_lq.ExportJson")
				local PayArmature = CCArmature:create("Fight_Skill_001_lq")
				PayArmature:getAnimation():play("Animation2")
				PayArmature:setPosition(ccp(0, 0))
				local layout = Layout:create()
				layout:setTouchEnabled(false)
				layout:addNode(PayArmature)
				layout:setPosition(ccp(0, 0))
				if m_playScene then
					PayArmature:setVisible(true)
				else
					PayArmature:setVisible(false)
				end
				Image_hufa_click:addChild(layout, 10, 108)
			end
		end

		PayArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)
		local layout = Layout:create()
		layout:setTouchEnabled(false)
		layout:addNode(PayArmature)
		layout:setPosition(ccp(0, 0))
		Image_hufa_click:addChild(layout, 10, 108)
		Image_hufa_click:setTag(nPower)
	else
		local Image_hufa_click = tolua.cast(m_playerFightUI:getWidgetByName("Image_hufa_click"), "ImageView")
		if Image_hufa_click:getChildByTag(108) ~= nil then
			Image_hufa_click:removeChildByTag(108, true)
		end
	end

	if nLastPower >= 100 and nLastPower > nPower then
		Click_Hufa_Action()
	end
end

local function DoAction( pRunner )
	if pRunner ~= nil then

		pRunner:stopAllActions()
		local actionArray2 = CCArray:create()
		actionArray2:addObject(CCScaleTo:create(0.1, 1.2))
		actionArray2:addObject(CCScaleTo:create(0.1, 1))
		CCSequence:create(actionArray2)
		pRunner:runAction( CCSequence:create(actionArray2) )

	end
end

-- 添加敌方信息
function addEnemyInfo(nIndex, level, imgPath, nPinZhi)
	if m_tableEnemyIndex[nIndex] == nil and imgPath ~= nil then
		m_nEnemyCount = m_nEnemyCount + 1
		m_tableEnemyIndex[nIndex] = {["imgPath"] = imgPath, ["level"] = level, ["m_nEnemyCount"] = m_nEnemyCount, ["nPinZhi"] = nPinZhi}
		local Image_enemy_0 = tolua.cast(m_playerFightUI:getWidgetByName("Image_enemy_0" .. m_tableEnemyIndex[nIndex].m_nEnemyCount), "ImageView")
		Image_enemy_0:setVisible(true)
		Image_enemy_0:setTag(nIndex)
		--print(m_tableEnemyIndex[nIndex].m_nEnemyCount.."set true")
	end


	local Image_enemy_0 = tolua.cast(m_playerFightUI:getWidgetByName("Image_enemy_0" .. m_tableEnemyIndex[nIndex].m_nEnemyCount), "ImageView")
	if Image_enemy_0:getVirtualRenderer():getChildByTag(100) ~= nil then
		Image_enemy_0:getVirtualRenderer():removeChildByTag(100, true)
	end

	--添加敌人等级
	if Image_enemy_0:getChildByTag(StrokeLabel_enemyLevel_Tag) ~= nil then
		Image_enemy_0:removeChildByTag(StrokeLabel_enemyLevel_Tag,true)
	end
	local StrokeLabel_money = StrokeLabel_createStrokeLabel(18, CommonData.g_FONT1, "LV."..m_tableEnemyIndex[nIndex].level, ccp(-5, -30), COLOR_Black, COLOR_White, true, ccp(0, 0), 2)
	Image_enemy_0:addChild(StrokeLabel_money,1,StrokeLabel_enemyLevel_Tag)

	local Image_enemy_head_0 = tolua.cast(m_playerFightUI:getWidgetByName("Image_enemy_head_0" .. m_tableEnemyIndex[nIndex].m_nEnemyCount), "ImageView")
	Image_enemy_head_0:loadTexture(m_tableEnemyIndex[nIndex].imgPath)

	local Image_enemy_frame_0 = tolua.cast(m_playerFightUI:getWidgetByName("Image_enemy_frame_0" .. m_tableEnemyIndex[nIndex].m_nEnemyCount), "ImageView")
	if nPinZhi ~= nil then
		Image_enemy_frame_0:loadTexture("Image/imgres/common/color/wj_pz" .. nPinZhi .. ".png")
	end

	local Image_icon_root_frame = tolua.cast(m_playerFightUI:getWidgetByName("Image_enemy_frame"), "ImageView")
	if nPinZhi ~= nil then
		Image_icon_root_frame:loadTexture("Image/imgres/common/color/wj_pz" .. nPinZhi .. ".png")
	end

    local function _Image_enemy_0_click_CallBack(sender,eventType)
		local Image = tolua.cast(sender, "ImageView")
    	if eventType == TouchEventType.ended then
    		if m_ScenceInterface:IsPKScene() == true then return end
    		if m_tableEnemyIndex[Image:getTag()] == nil then return end

    		m_ScenceInterface:SetEngineSkillTar(Image:getTag())
			--更改currentHead
			if nPinZhi ~= nil then
				Image_icon_root_frame:loadTexture("Image/imgres/common/color/wj_pz" .. nPinZhi .. ".png")
			end
			local Image_icon_root_head = tolua.cast(m_playerFightUI:getWidgetByName("Image_currentHead"), "ImageView")
			Image_icon_root_head:loadTexture(m_tableEnemyIndex[Image:getTag()].imgPath)
			if Image_icon_root_frame:getVirtualRenderer():getChildByTag(100) ~= nil then
				Image_icon_root_frame:getVirtualRenderer():removeChildByTag(100, true)
			end

			for i = 1, 5 do
				local Image_enemy = tolua.cast(m_playerFightUI:getWidgetByName("Image_enemy_0" .. i), "ImageView")
				if Image_enemy:getChildByTag(1000) ~= nil then
					Image_enemy:removeChildByTag(1000, true)
				end
			end
			local selectImg = ImageView:create()
			selectImg:loadTexture("Image/imgres/Fight/UI/sight.png")
			selectImg:setPosition(ccp(-40,0))
			Image:addChild(selectImg, 5, 1000)

			DoAction( Image_icon_root_head )
	    end
	end
	Image_enemy_0:setTouchEnabled(true)
    Image_enemy_0:addTouchEventListener(_Image_enemy_0_click_CallBack)
end

-- 设置默认目标
function setDefaultTag(nIndex)
	if nIndex == -1 then
		return 
	end
	-- 添加默认选择的一个
	local Image_enemy_frame_0 = tolua.cast(m_playerFightUI:getWidgetByName("Image_enemy_frame_0" .. m_tableEnemyIndex[nIndex].m_nEnemyCount), "ImageView")
	if nPinZhi ~= nil then
		Image_enemy_frame_0:loadTexture("Image/imgres/common/color/wj_pz" .. m_tableEnemyIndex[nIndex].nPinZhi .. ".png")
	end
	local Image_icon_root_head = tolua.cast(m_playerFightUI:getWidgetByName("Image_currentHead"), "ImageView")
	Image_icon_root_head:loadTexture(m_tableEnemyIndex[nIndex].imgPath)
	for i = 1, 5 do
		local Image_enemy = tolua.cast(m_playerFightUI:getWidgetByName("Image_enemy_0" .. i), "ImageView")
		if Image_enemy:getChildByTag(1000) ~= nil then
			Image_enemy:removeChildByTag(1000, true)
		end
	end	
	local Image_enemy_0 = tolua.cast(m_playerFightUI:getWidgetByName("Image_enemy_0" .. m_tableEnemyIndex[nIndex].m_nEnemyCount), "ImageView")
	local selectImg = ImageView:create()
	selectImg:loadTexture("Image/imgres/Fight/UI/sight.png")
	selectImg:setPosition(ccp(-40,0))
	Image_enemy_0:addChild(selectImg, 5, 1000)

	DoAction( Image_icon_root_head )
end

-- 设置目标死亡
function enemyDeadth(nIndex)

	local enemy = tolua.cast(m_playerFightUI:getWidgetByName("Image_enemy_0" .. m_tableEnemyIndex[nIndex].m_nEnemyCount), "ImageView")
	local enemy_head = tolua.cast(m_playerFightUI:getWidgetByName("Image_enemy_head_0" .. m_tableEnemyIndex[nIndex].m_nEnemyCount), "ImageView")
	--if enemy:getVirtualRenderer():getChildByTag(100) ~= nil then
    --	enemy:getVirtualRenderer():removeChildByTag(100, true)
    --end
    local Image_enemyHead_sprite = tolua.cast(enemy_head:getVirtualRenderer(), "CCSprite")
	SpriteSetGray(Image_enemyHead_sprite,1)
	enemy:setTouchEnabled(false)
end

-- 清除所有目标
function clearEnemy()
	for key,value in pairs(m_tableEnemyIndex) do
		local Image_enemy_0 = tolua.cast(m_playerFightUI:getWidgetByName("Image_enemy_0" .. value.m_nEnemyCount), "ImageView")
		local Image_enemy_frame_0 = tolua.cast(m_playerFightUI:getWidgetByName("Image_enemy_frame_0" .. value.m_nEnemyCount), "ImageView")
		Image_enemy_frame_0:loadTexture("Image/imgres/common/color/wj_pz1.png")
		--Image_enemy_frame_0:setVisible(false)
		StrokeLabel_setText(Image_enemy_0:getChildByTag(StrokeLabel_enemyLevel_Tag),"0")
		if Image_enemy_0:getVirtualRenderer():getChildByTag(100) ~= nil then
			Image_enemy_0:getVirtualRenderer():removeChildByTag(100, true)
		end
	end

	m_tableEnemyIndex = {}
	m_nEnemyCount = 0
	--local Image_currentHead = tolua.cast(m_playerFightUI:getWidgetByName("Image_currentHead"), "ImageView")
	--Image_currentHead:loadTexture("Image/common/common_empty.png")
end

-- 显示或隐藏战斗界面
function ShowFightLayer(bShow)	
	m_playerFightUI:setVisible(bShow)
	m_playerFightUI:setTouchEnabled(bShow)
end

function DeleteLayer()
	
end

local function InitVars()
	m_playerFightUI = nil

	m_ptextDelay = nil
	m_ptextAround = nil
	m_ptextMoney = nil
	m_ptextBox = nil
	m_playScene = nil

	m_nDelayTime = nil
	if m_nHanderTime ~= nil and m_playerFightUI ~= nil then
		m_playerFightUI:getScheduler():unscheduleScriptEntry(m_nHanderTime)
	end
	m_nHanderTime = nil

	m_tableHeroIndex = {}
	m_tableHeroSKillType = {}
	m_tableDeadHero = {}
	m_nHeroCount = 0

	m_tableEnemyIndex = {}
	m_nEnemyCount = 0
	m_bHide = true
    m_autoWarRecorderNum = 0

end

function SetPauseEnabled( nState )
	local CheckBox_Pause = tolua.cast(m_playerFightUI:getWidgetByName("CheckBox_Pause"), "CheckBox")
	if CheckBox_Pause ~= nil then
		CheckBox_Pause:setEnabled(nState)
	end
end

-- 创建战斗界面。创建后显示出来。
function CreateFightUILayer(node, pScenceInterface)
	InitVars()
	m_playerFightUI = node	
	----add by sxin 初始化接口
	m_ScenceInterface = pScenceInterface
	--m_playerFightUI = TouchGroup:create()	

	-- 背景层
    m_playerFightUI:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/FightUILayer.json") )
	
	--local runningScene = CCDirector:sharedDirector():getRunningScene()
	--runningScene:addChild(m_playerFightUI, m_playerFightUI_Tag, m_playerFightUI_Tag)
	--node:addChild(m_playerFightUI,-1)

	local function selectedEvent(sender, eventType)
		local CheckBox = tolua.cast(sender, "CheckBox")
        if eventType == CheckBoxEventType.selected then
			--print("自动战斗")
			--CheckBox:loadTextureFrontCross("Image/common/common_empty.png")
			--CheckBox:loadTextureBackGround("Image/Fight/UI/auto_fight_h.png")
			FightAutoFightClick(true)
        elseif eventType == CheckBoxEventType.unselected then
			--print("不自动战斗")
			--CheckBox:loadTextureBackGround("Image/Fight/UI/auto_fight_n.png")
			FightAutoFightClick(false)
        end
	end
    local CheckBox_AutoFight = tolua.cast(m_playerFightUI:getWidgetByName("CheckBox_10"), "CheckBox")
    CheckBox_AutoFight:setPosition(ccp(CheckBox_AutoFight:getPositionX() + CommonData.g_Origin.x,CheckBox_AutoFight:getPositionY() - CommonData.g_Origin.y))
    CheckBox_AutoFight:setSelectedState(GetFightSet())
    FightAutoFightClick(GetFightSet())
	CheckBox_AutoFight:addEventListenerCheckBox(selectedEvent)
	if m_ScenceInterface ~= nil and m_ScenceInterface:IsPKScene() == true then
		CheckBox_AutoFight:loadTextureFrontCross("Image/imgres/common/common_empty.png")
		CheckBox_AutoFight:loadTextureBackGround("Image/imgres/Fight/UI/autoBattle.png")
		CheckBox_AutoFight:setTouchEnabled(false)
	end

	local Image_Click_01 = tolua.cast(m_playerFightUI:getWidgetByName("Image_Click_01"), "ImageView")
	local Image_Click_02 = tolua.cast(m_playerFightUI:getWidgetByName("Image_Click_02"), "ImageView")
	local Image_Click_03 = tolua.cast(m_playerFightUI:getWidgetByName("Image_Click_03"), "ImageView")
	local Image_Click_04 = tolua.cast(m_playerFightUI:getWidgetByName("Image_Click_04"), "ImageView")
	local Image_Click_05 = tolua.cast(m_playerFightUI:getWidgetByName("Image_Click_05"), "ImageView")
	local function _Image_Action_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
			if m_ScenceInterface:IsPKScene() == true then return end
			if sender == Image_Click_01 then
				-- 使用英雄技能1 第一个英雄的
				FightSkillBtnClick(1)
			end
			if sender == Image_Click_02 then
				-- 使用英雄技能2
				FightSkillBtnClick(2)
			end
			if sender == Image_Click_03 then
				-- 使用英雄技能3
				FightSkillBtnClick(3)
			end
			if sender == Image_Click_04 then
				-- 使用英雄技能4
				FightSkillBtnClick(4)
			end
			if sender == Image_Click_05 then
				-- 使用英雄技能5
				FightSkillBtnClick(5)
			end
		end
	end
	Image_Click_01:addTouchEventListener(_Image_Action_CallBack)
	Image_Click_02:addTouchEventListener(_Image_Action_CallBack)
	Image_Click_03:addTouchEventListener(_Image_Action_CallBack)
	Image_Click_04:addTouchEventListener(_Image_Action_CallBack)
	Image_Click_05:addTouchEventListener(_Image_Action_CallBack)

	local Image_hufa_bk = tolua.cast(m_playerFightUI:getWidgetByName("Image_hufa_bk"), "ImageView")
	Image_hufa_bk:setVisible(false)
	--时间
	local Image_HourBg = tolua.cast(m_playerFightUI:getWidgetByName("Image_HourBg"), "ImageView")
	local StrokeLabel_minute = StrokeLabel_createStrokeLabel(18, CommonData.g_FONT1, "00", ccp(-20, 0), COLOR_Black, ccc3(248,158,80), true, ccp(0, 0), 1)
	Image_HourBg:addChild(StrokeLabel_minute,1,StrokeLabel_minute_Tag)
	local StrokeLabel_colon = StrokeLabel_createStrokeLabel(18, CommonData.g_FONT1, ":", ccp(0, 0), COLOR_Black, ccc3(248,158,80), true, ccp(0, 0), 1)
	Image_HourBg:addChild(StrokeLabel_colon,1)
	local StrokeLabel_second = StrokeLabel_createStrokeLabel(18, CommonData.g_FONT1, "00", ccp(20, 0), COLOR_Black, ccc3(248,158,80), true, ccp(0, 0), 1)
	Image_HourBg:addChild(StrokeLabel_second,1,StrokeLabel_second_Tag)

    local AtlasLabel_cur = tolua.cast(m_playerFightUI:getWidgetByName("AtlasLabel_70"), "LabelAtlas")
	AtlasLabel_cur:setStringValue("0")
    local AtlasLabel_all = tolua.cast(m_playerFightUI:getWidgetByName("AtlasLabel_71"), "LabelAtlas")
	AtlasLabel_all:setStringValue("0")
	
	--获得金钱和宝箱
	local Image_8 = tolua.cast(m_playerFightUI:getWidgetByName("Image_8"), "ImageView")
	local Image_9 = tolua.cast(m_playerFightUI:getWidgetByName("Image_9"), "ImageView")
	local StrokeLabel_money = StrokeLabel_createStrokeLabel(18, CommonData.g_FONT1, "0", ccp(0, 0), COLOR_Black, ccc3(248,158,80), true, ccp(0, 0), 1)
	Image_8:addChild(StrokeLabel_money,1,StrokeLabel_money_Tag)
	Image_8:setPosition(ccp(Image_8:getPositionX() - CommonData.g_Origin.x,Image_8:getPositionY() - CommonData.g_Origin.y))
	local StrokeLabel_box = StrokeLabel_createStrokeLabel(18, CommonData.g_FONT1, "0", ccp(0, 0), COLOR_Black, ccc3(248,158,80), true, ccp(0, 0), 1)
	Image_9:addChild(StrokeLabel_box,1,StrokeLabel_box_Tag)

	local Image_HourBg = tolua.cast(m_playerFightUI:getWidgetByName("Image_HourBg"), "ImageView")
	Image_HourBg:setPosition(ccp(Image_HourBg:getPositionX() + CommonData.g_Origin.x,Image_HourBg:getPositionY() - CommonData.g_Origin.y))
	--local Image_hufa_icon = tolua.cast(m_playerFightUI:getWidgetByName("Image_hufa_icon"), "ImageView")
	--Image_hufa_icon:setVisible(false)

	local Image_icon_root = tolua.cast(m_playerFightUI:getWidgetByName("Image_icon_root"), "ImageView")
	Image_icon_root:setPosition(ccp(Image_icon_root:getPositionX() - CommonData.g_Origin.x,Image_icon_root:getPositionY() - CommonData.g_Origin.y))
	--Image_icon_root:loadTexture("Image/common/common_empty.png")

	local enemyPanel = tolua.cast(m_playerFightUI:getWidgetByName("Panel_85"), "Layout")
	enemyPanel:setPosition(ccp(enemyPanel:getPositionX() - CommonData.g_Origin.x,enemyPanel:getPositionY() - CommonData.g_Origin.y))

	for i = 1, 5 do
		local root = tolua.cast(m_playerFightUI:getWidgetByName("Image_hero_bk_0" .. i), "ImageView")
		root:setPosition(ccp(root:getPositionX() + CommonData.g_Origin.x,root:getPositionY() - CommonData.g_Origin.y))
	    root:setVisible(false)
		local Image_enemy_0 = tolua.cast(m_playerFightUI:getWidgetByName("Image_enemy_0" .. i), "ImageView")
		--Image_enemy_0:setPosition(ccp(Image_enemy_0:getPositionX() - CommonData.g_Origin.x,Image_enemy_0:getPositionY() - CommonData.g_Origin.y))
	    Image_enemy_0:setVisible(false)
	    Image_enemy_0:setScale(0.0)
		local Image_hero_hp_0 = tolua.cast(m_playerFightUI:getWidgetByName("Image_hero_hp_0" .. i), "ImageView")
		Image_hero_hp_0:setPosition(ccp(Image_hero_hp_0:getPositionX() + CommonData.g_Origin.x,Image_hero_hp_0:getPositionY() - CommonData.g_Origin.y))
	    Image_hero_hp_0:setVisible(false)
	    local Image_hero_power_0 = tolua.cast(m_playerFightUI:getWidgetByName("Image_hero_power_0" .. i), "ImageView")
	    Image_hero_power_0:setPosition(ccp(Image_hero_power_0:getPositionX() + CommonData.g_Origin.x,Image_hero_power_0:getPositionY() - CommonData.g_Origin.y))
	    Image_hero_power_0:setVisible(false)
	end

    local function selectedEvent_2(sender,eventType)
        if eventType == CheckBoxEventType.selected then
			--暂停游戏
			require "Script/Fight/FightPauseLayer"
			FightPauseLayer.CreateFightPauseLayer(m_playerFightUI,m_ScenceInterface)
			local _checkbox_ = tolua.cast(sender,"CheckBox")
			_checkbox_:setSelectedState(false)
			BaseSceneLogic.OnPause()
        elseif eventType == CheckBoxEventType.unselected then
        end
    end
    local CheckBox_Pause = tolua.cast(m_playerFightUI:getWidgetByName("CheckBox_Pause"), "CheckBox")
    CheckBox_Pause:setPosition(ccp(CheckBox_Pause:getPositionX() + CommonData.g_Origin.x,CheckBox_Pause:getPositionY() - CommonData.g_Origin.y))
	CheckBox_Pause:addEventListenerCheckBox(selectedEvent_2) 

    local function _Image_hufa_click_CallBack(sender,eventType)
    	if eventType == TouchEventType.ended then
			local ProgressBar_hufa_power = tolua.cast(m_playerFightUI:getWidgetByName("ProgressBar_hufa_power"), "LoadingBar")
			local nP = ProgressBar_hufa_power:getPercent()
			if nP == 100 and m_ScenceInterface:IsPKScene() == false then
    			print("护法技能释放")
    			print(m_ScenceInterface:CanUseHufaSkill())
    			if m_ScenceInterface:CanUseHufaSkill() == true then
    				m_ScenceInterface:UseHufaSkill()
    			end
    			Click_Hufa_Action()   
			end
	    end
	end
	local Image_hufa_click = tolua.cast(m_playerFightUI:getWidgetByName("Image_hufa_click"), "ImageView")
	Image_hufa_click:setTouchEnabled(true)
    Image_hufa_click:addTouchEventListener(_Image_hufa_click_CallBack)


    local function _Image_enemy_click_CallBack(sender,eventType)
    	if eventType == TouchEventType.ended then
    		if table.maxn(m_tableEnemyIndex) > 0 and m_ScenceInterface:IsPKScene() == false then
				if m_bHide == false then
					ActionManager:shareManager():playActionByName("FightUILayer.json","Animation2")
					m_bHide = true
				else
					ActionManager:shareManager():playActionByName("FightUILayer.json","Animation1")
					m_bHide = false
				end
			end
	    end
	end
	local Image_enemy_click = tolua.cast(m_playerFightUI:getWidgetByName("Image_enemy_click"), "ImageView")
    Image_enemy_click:addTouchEventListener(_Image_enemy_click_CallBack)

    CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/Fight/UI/FightSmoke.ExportJson")
  	local PayArmature = CCArmature:create("FightSmoke")
    PayArmature:getAnimation():playWithIndex(0)
    PayArmature:setPosition(ccp(0, 0))

end

