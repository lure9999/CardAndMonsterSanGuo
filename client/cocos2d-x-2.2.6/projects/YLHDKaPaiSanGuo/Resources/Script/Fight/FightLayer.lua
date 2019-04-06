
module("FightLayer", package.seeall)

require "Script/Common/Common"
require "Script/Audio/AudioUtil"
require "Script/Common/LabelLayer"

---add by sxin 增加场景调用接口针对ui层不需要知道真正的场景脚本只需要调用接口
local m_ScenceInterface = nil

local layerFight = nil

local textDelay = nil
local textAround = nil
local textMoney = nil
local textBox = nil

local nDelayTime = nil
local nHanderTime = nil

local tableHeroIndex = {}
local nHeroCount = 0

local tableAllBox = {}
local nBoxCount = 1
local function MakeNewIconPos()
-- 700
-- x: 619 y:105
	if nHeroCount == 1 then
		local Image_Icon = tolua.cast(layerFight:getWidgetByName("Image_Icon_01"), "ImageView")
		Image_Icon:setPosition(ccp(700/2, 105))
		return
	end
	if nHeroCount == 2 then
		local Image_Icon = tolua.cast(layerFight:getWidgetByName("Image_Icon_01"), "ImageView")
		Image_Icon:setPosition(ccp(700/2+700/2/2, 105))
		local Image_Icon = tolua.cast(layerFight:getWidgetByName("Image_Icon_02"), "ImageView")
		Image_Icon:setPosition(ccp(700/2-700/2/2, 105))
		return
	end
	if nHeroCount == 3 then
		local Image_Icon = tolua.cast(layerFight:getWidgetByName("Image_Icon_01"), "ImageView")
		Image_Icon:setPosition(ccp(700/2+700/2/2, 105))
		local Image_Icon = tolua.cast(layerFight:getWidgetByName("Image_Icon_02"), "ImageView")
		Image_Icon:setPosition(ccp(700/2, 105))
		local Image_Icon = tolua.cast(layerFight:getWidgetByName("Image_Icon_03"), "ImageView")
		Image_Icon:setPosition(ccp(700/2-700/2/2, 105))
		return
	end
	if nHeroCount == 4 then
		local Image_Icon = tolua.cast(layerFight:getWidgetByName("Image_Icon_01"), "ImageView")
		Image_Icon:setPosition(ccp(620, 105))
		local Image_Icon = tolua.cast(layerFight:getWidgetByName("Image_Icon_02"), "ImageView")
		Image_Icon:setPosition(ccp(445, 105))
		local Image_Icon = tolua.cast(layerFight:getWidgetByName("Image_Icon_03"), "ImageView")
		Image_Icon:setPosition(ccp(255, 105))
		local Image_Icon = tolua.cast(layerFight:getWidgetByName("Image_Icon_04"), "ImageView")
		Image_Icon:setPosition(ccp(80, 105))
		return
	end
	if nHeroCount == 5 then
		local Image_Icon = tolua.cast(layerFight:getWidgetByName("Image_Icon_01"), "ImageView")
		Image_Icon:setPosition(ccp(620, 105))
		local Image_Icon = tolua.cast(layerFight:getWidgetByName("Image_Icon_02"), "ImageView")
		Image_Icon:setPosition(ccp(485, 105))
		local Image_Icon = tolua.cast(layerFight:getWidgetByName("Image_Icon_03"), "ImageView")
		Image_Icon:setPosition(ccp(350, 105))
		local Image_Icon = tolua.cast(layerFight:getWidgetByName("Image_Icon_04"), "ImageView")
		Image_Icon:setPosition(ccp(215, 105))
		local Image_Icon = tolua.cast(layerFight:getWidgetByName("Image_Icon_05"), "ImageView")
		Image_Icon:setPosition(ccp(80, 105))
		return
	end
end

-- 收起全部宝箱
function TakeAllBox()
	--print("TakeAllBox = " .. table.maxn(tableAllBox))
	for key,value in pairs(tableAllBox) do
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
				local ptDes = ccp(visibleSize.width-50, visibleSize.height - 50)
				local actionCur = CCArray:create()
				actionCur:addObject(CCScaleTo:create(0.05, 1.2))
				actionCur:addObject(CCDelayTime:create(0.2))
				actionCur:addObject(CCMoveTo:create(0.5, ptDes))
				actionCur:addObject(CCScaleTo:create(0.5, 0))
				local function HideSelf()
					_Panel_1:setVisible(false)
					--local strText = textBox:getStringValue()
					local strText = LabelLayer.getText(textBox)
					local nCount = tonumber(strText)
					nCount = nCount + 1
					if nCount > nBoxCount then nCount = nBoxCount end
					SetFightTitleBox(nCount)
				end
				actionCur:addObject(CCCallFuncN:create(HideSelf))
				_Panel_1:stopAllActions()
				_Panel_1:runAction(CCSequence:create(actionCur))
			end
		end
	end
	tableAllBox = {}
end

-- 添加掉落宝箱
function AddBox(ptBoxPos, nItemId)
	local _Panel_1 = Layout:create()
	local _Img_bk_1 = ImageView:create()
	_Img_bk_1:loadTexture("Image/Fight/UI/box_light.png")
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
			local imgPath = resimg.getFieldByIdAndIndex(item.getFieldByIdAndIndex(nItemId, "res_id"), "icon_path")
			if imgPath ~= nil then
				local _Img_icon = ImageView:create()
				_Img_icon:loadTexture(imgPath)
				_Panel_1:getChildByTag(50):removeFromParentAndCleanup(true)
				_Panel_1:getChildByTag(100):removeFromParentAndCleanup(true)
				_Panel_1:addChild(_Img_icon)
			end
			
			local ptDes = ccp(visibleSize.width-50, visibleSize.height - 50)
			local actionCur = CCArray:create()
			actionCur:addObject(CCScaleTo:create(0.05, 1.2))
			actionCur:addObject(CCDelayTime:create(0.2))
			actionCur:addObject(CCMoveTo:create(0.5, ptDes))
			actionCur:addObject(CCScaleTo:create(0.5, 0))
			local function HideSelf()
				_Panel_1:setVisible(false)
				--local strText = textBox:getStringValue()
				local strText = LabelLayer.getText(textBox)
				local nCount = tonumber(strText)
				nCount = nCount + 1
				if nCount > nBoxCount then nCount = nBoxCount end
				SetFightTitleBox(nCount)
			end
			actionCur:addObject(CCCallFuncN:create(HideSelf))
			_Panel_1:stopAllActions()
			_Panel_1:runAction(CCSequence:create(actionCur))
		end
	end
	
	local _btn_Box = Button:create()
	_btn_Box:loadTextureNormal("Image/Fight/UI/box.png")
	_btn_Box:loadTexturePressed("Image/Fight/UI/box.png")
	_btn_Box:setTouchEnabled(true)
	_btn_Box:setEnabled(true)
	_btn_Box:addTouchEventListener(_Click_Btn_CallBack)
	_Panel_1:addChild(_btn_Box, 1, 100)
	_Panel_1:setTouchEnabled(true)
	
	_Panel_1:setPosition(ptBoxPos)
	if math.random(1, 2) == 1 then
		_Panel_1:runAction(CCJumpTo:create(0.5, ccp(ptBoxPos.x-50, ptBoxPos.y-50), 25, 2))
	else
		_Panel_1:runAction(CCJumpTo:create(0.5, ccp(ptBoxPos.x+50, ptBoxPos.y-50), 25, 2))
	end
	layerFight:addWidget(_Panel_1)
	tableAllBox[nBoxCount] = {["nItemId"] = nItemId, ["Layout"] = _Panel_1}
	nBoxCount = nBoxCount + 1
end

-- 是否自动战斗
function FightAutoFightClick(bFight)
	
	m_ScenceInterface:SetFightAuto(bFight)
end

-- 使用英雄技能 nIndex为索引
function FightSkillBtnClick(nIndex)
	-- 调C++
	local nRealIndex = 0
	for key,value in pairs(tableHeroIndex) do
		if value == nIndex then
			nRealIndex = key
			break
		end
	end
	--print("技能" .. nRealIndex)
	
	--Res_FightUseSkill(nRealIndex)
	--TakeAllBox()
	if m_ScenceInterface:IsPKScene() == false then 
		
		if m_ScenceInterface:CanUseEngineSkill(nRealIndex) == true then
			m_ScenceInterface:UseEngineSkill(nRealIndex)
		end
		
	end
end

-- 设置技能进度血量等 参数：nIndex英雄索引（1-5） nHp英雄血量（百分比） nPower英雄能量（百分比）
function SetFightHp(nIndex, nHp, imgPath)
	if nHp > 100 or nHp < 0 then return end
	if tableHeroIndex[nIndex] == nil then
		nHeroCount = nHeroCount + 1
		tableHeroIndex[nIndex] = nHeroCount
		local Image_Icon = tolua.cast(layerFight:getWidgetByName("Image_Icon_0" .. nHeroCount), "ImageView")
		Image_Icon:setVisible(true)
		MakeNewIconPos()
	end
	
	if imgPath ~= nil then
		local Image_Icon = tolua.cast(layerFight:getWidgetByName("Image_Icon_0" .. tableHeroIndex[nIndex]), "ImageView")
		Image_Icon:loadTexture(imgPath)
	end
	
	local ProgressBar_Hp = tolua.cast(layerFight:getWidgetByName("ProgressBar_Hp_0" .. tableHeroIndex[nIndex]), "LoadingBar")
	ProgressBar_Hp:setPercent(nHp)
	if nHp == 0 then
		-- 死了。变灰
		--print("死了。变灰" .. tableHeroIndex[nIndex] .. " " .. nIndex .. " " .. nHp)
		local Image_Icon = tolua.cast(layerFight:getWidgetByName("Image_Icon_0" .. tableHeroIndex[nIndex]), "ImageView")
		local _Img_head_sprite_1 = tolua.cast(Image_Icon:getVirtualRenderer(), "CCSprite")
		SpriteSetGray(_Img_head_sprite_1,1)	
		local ProgressBar_Power = tolua.cast(layerFight:getWidgetByName("ProgressBar_Power_0" .. tableHeroIndex[nIndex]), "LoadingBar")
		ProgressBar_Power:setPercent(0)
		local Image_Action = tolua.cast(layerFight:getWidgetByName("Image_Action_0" .. tableHeroIndex[nIndex]), "ImageView")
		Image_Action:setVisible(false)
		Image_Action:setTouchEnabled(false)
	end
end

-- 设置技能进度血量等 参数：nIndex英雄索引（1-5） nHp英雄血量（百分比） nPower英雄能量（百分比）
function SetFightPower(nIndex, nPower, imgPath)
	if nPower > 100 or nPower < 0 then return end
	
	if tableHeroIndex[nIndex] == nil then
		nHeroCount = nHeroCount + 1
		tableHeroIndex[nIndex] = nHeroCount
		local Image_Icon = tolua.cast(layerFight:getWidgetByName("Image_Icon_0" .. nHeroCount), "ImageView")
		Image_Icon:setVisible(true)
		MakeNewIconPos()
	end
	
	if imgPath ~= nil then
		local Image_Icon = tolua.cast(layerFight:getWidgetByName("Image_Icon_0" .. tableHeroIndex[nIndex]), "ImageView")
		Image_Icon:loadTexture(imgPath)
	end
	
	local ProgressBar_Power = tolua.cast(layerFight:getWidgetByName("ProgressBar_Power_0" .. tableHeroIndex[nIndex]), "LoadingBar")
	ProgressBar_Power:setPercent(nPower)
	if nPower == 100 then
		--print("Power")
		local Image_Action = tolua.cast(layerFight:getWidgetByName("Image_Action_0" .. tableHeroIndex[nIndex]), "ImageView")
		Image_Action:setVisible(true)
		Image_Action:setTouchEnabled(true)
		ActionManager:shareManager():playActionByName("FightUILayer.json","Animation0" .. tableHeroIndex[nIndex])
	else
		local Image_Action = tolua.cast(layerFight:getWidgetByName("Image_Action_0" .. tableHeroIndex[nIndex]), "ImageView")
		Image_Action:setVisible(false)
		Image_Action:setTouchEnabled(false)
		ActionManager:shareManager():getActionByName("FightUILayer.json","Animation0" .. tableHeroIndex[nIndex]):stop()
	end
end

-- 设置回合数、金币数、宝箱数等
function SetFightTitleAround(strAround)
	--textAround:setText(strAround)
	LabelLayer.setText(textAround, strAround)
end

function SetFightTitleMoney(nMoney)
	--textMoney:setText(nMoney)
	LabelLayer.setText(textMoney, nMoney)
end

function SetFightTitleBox(nBox)
	--textBox:setText(nBox)
	LabelLayer.setText(textBox, nBox)
end
-- 停止计时
function StopFightDelayTime()
	if nHanderTime ~= nil then
		layerFight:getScheduler():unscheduleScriptEntry(nHanderTime)
		nHanderTime = nil
	end
end
-- 设置倒记时时间，单位秒
function SetFightDelayTime(nSecend)
	if nSecend < 0 then return end
	
	nDelayTime = nSecend
	local strM = math.floor(nSecend/60)
	local strS = math.floor(nSecend%60)
	local strTemp = ""
	if tonumber(strM) < 10 then strM = "0" .. strM end
	if tonumber(strS) < 10 then strS = "0" .. strS end
	
	--textDelay:setText(strM .. ":" .. strS)
	LabelLayer.setText(textDelay, strM .. ":" .. strS)
	local function tick(dt)
		if nDelayTime == 0 then
		-- 时间到了。战斗结束
		--	print("时间到了。战斗结束")
			layerFight:getScheduler():unscheduleScriptEntry(nHanderTime)
			nHanderTime = nil
			-- 调C++
			m_ScenceInterface:OnTimeOver()
		end
		nDelayTime = nDelayTime -1
		SetFightDelayTime(nDelayTime)
	end
	if nHanderTime == nil then
		nHanderTime = layerFight:getScheduler():scheduleScriptFunc(tick, 1, false)
	end
	
end

-- 显示或隐藏战斗界面
function ShowFightLayer(bShow)	
	layerFight:setVisible(bShow)
	layerFight:setTouchEnabled(bShow)
end

function DeleteLayer()
	
end

local function InitVars()
	layerFight = nil

	textDelay = nil
	textAround = nil
	textMoney = nil
	textBox = nil

	nDelayTime = nil
	if nHanderTime ~= nil and layerFight ~= nil then
		layerFight:getScheduler():unscheduleScriptEntry(nHanderTime)
	end
	nHanderTime = nil

	tableHeroIndex = {}
	nHeroCount = 0
end
-- 创建战斗界面。创建后显示出来。
function CreateFightLayer(node, pScenceInterface)
	InitVars()
	layerFight = node	
	----add by sxin 初始化接口
	m_ScenceInterface = pScenceInterface
	--layerFight = TouchGroup:create()	

	-- 背景层
    layerFight:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/FightUILayer.json") )
	
	--local runningScene = CCDirector:sharedDirector():getRunningScene()
	--runningScene:addChild(layerFight, layerFightUI_Tag, layerFightUI_Tag)
	--node:addChild(layerFight,-1)

	local function selectedEvent(sender, eventType)
        if eventType == CheckBoxEventType.selected then
		--	print("自动战斗")
			FightAutoFightClick(true)
        elseif eventType == CheckBoxEventType.unselected then
		--	print("不自动战斗")
			FightAutoFightClick(false)
        end
		
	end
    local CheckBox_AutoFight = tolua.cast(layerFight:getWidgetByName("CheckBox_10"), "CheckBox")
	CheckBox_AutoFight:addEventListenerCheckBox(selectedEvent)
	
    local Image_Action_01 = tolua.cast(layerFight:getWidgetByName("Image_Action_01"), "ImageView")
	Image_Action_01:setVisible(false)
	Image_Action_01:setTouchEnabled(false)
    local Image_Action_02 = tolua.cast(layerFight:getWidgetByName("Image_Action_02"), "ImageView")
	Image_Action_02:setVisible(false)
	Image_Action_02:setTouchEnabled(false)
    local Image_Action_03 = tolua.cast(layerFight:getWidgetByName("Image_Action_03"), "ImageView")
	Image_Action_03:setVisible(false)
	Image_Action_03:setTouchEnabled(false)
    local Image_Action_04 = tolua.cast(layerFight:getWidgetByName("Image_Action_04"), "ImageView")
	Image_Action_04:setVisible(false)
	Image_Action_04:setTouchEnabled(false)
    local Image_Action_05 = tolua.cast(layerFight:getWidgetByName("Image_Action_05"), "ImageView")
	Image_Action_05:setVisible(false)
	Image_Action_05:setTouchEnabled(false)
	
	local Image_Icon1 = tolua.cast(layerFight:getWidgetByName("Image_Icon_01"), "ImageView")
	Image_Icon1:setVisible(false)
	local Image_Icon2 = tolua.cast(layerFight:getWidgetByName("Image_Icon_02"), "ImageView")
	Image_Icon2:setVisible(false)
	local Image_Icon3 = tolua.cast(layerFight:getWidgetByName("Image_Icon_03"), "ImageView")
	Image_Icon3:setVisible(false)
	local Image_Icon4 = tolua.cast(layerFight:getWidgetByName("Image_Icon_04"), "ImageView")
	Image_Icon4:setVisible(false)
	local Image_Icon5 = tolua.cast(layerFight:getWidgetByName("Image_Icon_05"), "ImageView")
	Image_Icon5:setVisible(false)
		
	local function _Image_Action_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
			if sender == Image_Action_01 then
				-- 使用英雄技能1 第一个英雄的
				FightSkillBtnClick(1)
			end
			if sender == Image_Action_02 then
				-- 使用英雄技能2
				FightSkillBtnClick(2)
			end
			if sender == Image_Action_03 then
				-- 使用英雄技能3
				FightSkillBtnClick(3)
			end
			if sender == Image_Action_04 then
				-- 使用英雄技能4
				FightSkillBtnClick(4)
			end
			if sender == Image_Action_05 then
				-- 使用英雄技能5
				FightSkillBtnClick(5)
			end
		end
	end
	Image_Action_01:addTouchEventListener(_Image_Action_CallBack)
	Image_Action_02:addTouchEventListener(_Image_Action_CallBack)
	Image_Action_03:addTouchEventListener(_Image_Action_CallBack)
	Image_Action_04:addTouchEventListener(_Image_Action_CallBack)
	Image_Action_05:addTouchEventListener(_Image_Action_CallBack)
	
	--textDelay = Label:create()
	--textDelay:setText("倒计时")
	--textDelay:setFontSize(28)
	--textDelay:setColor(COLOR_White)
	--textDelay:setPosition(ccp(-15, 0))
    local Image_Delay = tolua.cast(layerFight:getWidgetByName("Image_7"), "ImageView")
	--Image_Delay:addChild(textDelay)
	textDelay = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, "倒计时", ccp(-10, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
	Image_Delay:addChild(textDelay)
	
	
	--textAround = Label:create()
	--textAround:setText("回合")
	--textAround:setFontSize(28)
	--textAround:setColor(COLOR_White)
    local Image_51 = tolua.cast(layerFight:getWidgetByName("Image_51"), "ImageView")
	--Image_51:addChild(textAround)
	
	textAround = LabelLayer.createStrokeLabel(26, CommonData.g_FONT1, "回合", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
	Image_51:addChild(textAround)
	
	--textMoney = Label:create()
	--textMoney:setText("金钱")
	--textMoney:setFontSize(28)
	--textMoney:setColor(COLOR_White)
	--textMoney:setPosition(ccp(-25, 0))
    local Image_Money = tolua.cast(layerFight:getWidgetByName("Image_8"), "ImageView")
	--Image_Money:addChild(textMoney)
	textMoney = LabelLayer.createStrokeLabel(26, CommonData.g_FONT1, "金钱", ccp(-15, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
	Image_Money:addChild(textMoney)
	
	--textBox = Label:create()
	--textBox:setText("宝箱")
	--textBox:setFontSize(28)
	--textBox:setColor(COLOR_White)
	--textBox:setPosition(ccp(-25, 0))
    local Image_Box = tolua.cast(layerFight:getWidgetByName("Image_9"), "ImageView")
	--Image_Box:addChild(textBox)
	textBox = LabelLayer.createStrokeLabel(26, CommonData.g_FONT1, "宝箱", ccp(-15, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
	Image_Box:addChild(textBox)
	
    local function selectedEvent(sender,eventType)
        if eventType == CheckBoxEventType.selected then
			--暂停游戏
			
			require "Script/Fight/FightPauseLayer"
			FightPauseLayer.CreateFightPauseLayer(layerFight,m_ScenceInterface)
			local _checkbox_ = tolua.cast(sender,"CheckBox")
			_checkbox_:setSelectedState(false)
			BaseSceneLogic.OnPause()
        elseif eventType == CheckBoxEventType.unselected then
		
        end
    end
    local CheckBox_Pause = tolua.cast(layerFight:getWidgetByName("CheckBox_Pause"), "CheckBox")
	CheckBox_Pause:addEventListenerCheckBox(selectedEvent) 

end

