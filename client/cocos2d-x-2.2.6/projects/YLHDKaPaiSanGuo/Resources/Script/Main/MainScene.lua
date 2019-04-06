-- for CCLuaEngine traceback

module("MainScene", package.seeall)


--require "Script/Network/network"
require "Script/Fight/simulationStl"
require "Script/Main/UserSetting/UserSettingLayer"
require "Script/Main/CountryWar/CountryWarScene"
require "Script/Main/Pata/PataLayer"
require "Script/Main/RankList/RankListLayer"
require "Script/Main/Chat/ChatLayer"
require "Script/Main/Corps/CorpsLayer"
require "Script/Main/Corps/CorpsLogic"
require "Script/Main/Chat/ChatShowLayer"
-- require "Script/Main/NoticeBoard/NoticeTipLayer"
-- require "Script/Main/NoticeBoard/NoticeScrollLayer"
-- require "Script/Main/NoticeBoard/NoticeSTiplayer"
-- require "Script/Main/NoticeBoard/NoticeScrollData"
require "Script/Main/Corps/CorpsScene"
require "Script/Main/CountryWar/CountryUILayer"
require "Script/Main/SignIn/SignInLayer"
require "Script/Main/UserSetting/UserSettingData"
require "Script/serverDB/server_CorpsGetInfoDB"
require "Script/serverDB/server_ShopOpenDB"
require "Script/serverDB/vipfunction"
require "Script/Main/CountryReward/CountryRewardBtn"
require "Script/Main/ChargeVIP/ChargeVIPLayer"
require "Script/Main/CoinBar/CoinInfoBarManager"
require "Script/Main/NewGuide/NewGuideManager"
require "Script/Main/HeroUpgrade/HeroUpGradeLayer"  
require "Script/Main/AddPoint/AddPoint"
-- require "Script/Main/Item/ItemListLayer"

local m_playerMainRoot = nil
local m_staUILayerStack = nil
local m_pSceneGame = nil
local m_bRootBtnState = true -- 保存快捷按扭状态
local m_pChatLayer = nil
local m_pShowChatFrame = false
local m_pArmyLayer = nil
local Button_Email = nil
local m_isCurMainScene = true --当前的场景是不是mainscene
local m_isClickCountryWar = false
--add celina
--[[local CurPos = {x = 0, y = 0}
local BeginPos = {x = 0, y = 0}]]--
local nOffX = 0
local m_LastPtX = 0 

local m_pObserver = nil --通知更新
local m_p_Back = nil
local m_p_Middle = nil
local m_p_Front = nil

local bRole = false
local m_pBarManager = nil --货币条的统一管理

local bScroolView = false --是否滑动了

function DeleteAllObjects()	
	
	if m_playerMainRoot~=nil then
		m_playerMainRoot = nil
	end
	if m_staUILayerStack~=nil  then
		m_staUILayerStack = nil
	end
	if m_p_Back~=nil  then
		m_p_Back = nil
	end
	if m_p_Middle~=nil  then
		m_p_Middle = nil
	end
	if m_p_Front~=nil  then
		m_p_Front = nil
	end
	if m_pSceneGame~=nil  then
		m_pSceneGame:removeAllChildrenWithCleanup(true)
		m_pSceneGame = nil
	end
	if m_bRootBtnState~=false  then
		m_bRootBtnState = false
	end
	if m_pChatLayer~=nil  then
		m_pChatLayer = nil
	end
	if m_pShowChatFrame==true  then
		m_pShowChatFrame = false
	end
	if m_pArmyLayer~=nil  then
		m_pArmyLayer = nil
	end
	if m_isClickCountryWar==true  then
		m_isClickCountryWar = false
	end
	if nOffX~=0 then
		nOffX = 0
	end
	if m_LastPtX~=0 then
		m_LastPtX = 0 
	end
	if m_pObserver~=nil then
		m_pObserver = nil --通知更新
	end
	if m_pBarManager ~=nil then
		m_pBarManager = nil 
	end
end

function GetStaUILayerStack()
	return m_staUILayerStack
end
function GetObserver()
	return m_pObserver
end	

function GetBarManager()
	return m_pBarManager
end

function Update()
	if m_pObserver~=nil then
		m_pObserver:Notify()
	end
end
function closeLayerByTag(tag_id)
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	local tempLayer = runningScene:getChildByTag(tag_id)
	if tempLayer ~= nil then
		runningScene:removeChildByTag(tag_id, true)
	else
		print("none this layer tag is" .. tag_id)
	end
end

function PushUILayer(control)
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	local child = scenetemp:getChildByTag(control:getTag())
	
	if m_staUILayerStack.m_endIndex~= 0  then
		local lastChild = m_staUILayerStack:GetLastStack().child
		--lastChild:setVisible(false)
		lastChild:retain()
		lastChild:removeFromParentAndCleanup(true)
		--lastChild:setPosition(ccp(lastChild:getPositionX()+10000,lastChild:getPositionY()+10000))
	end
	local tableChild = {}
	tableChild.child = child
	tableChild.rootBtn_S = m_bRootBtnState
	m_staUILayerStack:PushStack(tableChild)
	--[[if control ~= nil then
		control:setTag(layerMainCur_Tag)
	end]]--


end

function DeleteUILayer(control)
	m_bRootBtnState = MainBtnLayer.GetRootBtnState()
	if control ~= nil then
		--[[local child = tolua.cast(control, "TouchGroup")
		if child ~= nil then
	    	child:setVisible(false)
	    	child:setTouchEnabled(false)
	    	child:removeFromParentAndCleanup(true)
			
			--m_staUILayerStack:empty_Stack(control)
			m_staUILayerStack:delete_node(control)
			control:release()
			child = nil
		end]]--
		control:removeFromParentAndCleanup(true)
		m_staUILayerStack:delete_node(control)
		control:release()
		control = nil
	end
end

function SetClickStateByCountryWar( nState )
	m_isClickCountryWar = nState
end

function PopUILayer(bGuide)
	--local layerTemp = m_staUILayerStack:PopStack()
	local objext = m_staUILayerStack:PopStack()
	--[[if objext.child ~= nil then
		objext.child:removeFromParentAndCleanup(true)
		objext.child = nil 
	end]]--
	local tableChild = m_staUILayerStack:GetLastStack()
	
	local sceneNow = CCDirector:sharedDirector():getRunningScene()
	local layerTemp = nil
	if tableChild ~= nil then layerTemp = tableChild.child end
	if layerTemp ~= nil then
		--layerTemp:setVisible(true)
		--layerTemp:setTouchEnabled(true)
		--layerTemp:setPosition(ccp(layerTemp:getPositionX() - 10000, layerTemp:getPositionY() - 10000))
		if layerTemp:getTag() == layerEquipOperateTag then
			if bGuide==nil then
				if MainScene.GetObserver()~=nil then
					if EquipStrengthen.GetEquipStrengthenUI() ~= nil then
						if EquipStrengthen.GetEquipStrengthenUI():getChildByTag(1000)~= nil then
							--Pause()
							EquipStrengthen.GetEquipStrengthenUI():getChildByTag(1000):removeFromParentAndCleanup(true)
						end
						if EquipStrengthen.GetEquipStrengthenUI():getChildByTag(1001)~= nil then
							--Pause()
							EquipStrengthen.GetEquipStrengthenUI():getChildByTag(1001):removeFromParentAndCleanup(true)
						end
						EquipStrengthen.SetBUpdate(true)
					end
					
					
					MainScene.GetObserver():Notify()
				end
			end
		end
		
		sceneNow:addChild(layerTemp,layerTemp:getTag(),layerTemp:getTag())
		layerTemp:release()
		--layerTemp:setPosition(ccp(0, 0))
		--layerTemp:setTag(layerMainCur_Tag)
		local child = layerTemp:getChildByTag(layerMainBtn_Tag)
		if child ~= nil then
			local nX = child:getPositionX()
			local nY = child:getPositionY()
    		child:removeFromParentAndCleanup(true)
    		child = nil
			require "Script/Main/MainBtnLayer"
			local temp = MainBtnLayer.createMainBtnLayer()
			layerTemp:addChild(temp, layerMainBtn_Tag, layerMainBtn_Tag)
			temp:setPosition(ccp(nX, nY))
			--MainBtnLayer.SetRootBtnState(tableChild.rootBtn_S)
		end
		
	else
        AddSystemBtn(false)
        ShowLeftInfo(true)
	end
end

function ClearRootBtn()
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	local child = scenetemp:getChildByTag(layerMainBtn_Tag)
	if child ~= nil then
		-- child:setVisible(false)
	    -- child:setTouchEnabled(false)
    	child:removeFromParentAndCleanup(true)
    	-- child = nil
    else
    	print("ClearRootBtn = nil")
    end
end

local function GetMailParent()
	local pBackScene = m_pSceneGame:getChildByTag(layerMainBack)
    local m_p_Middle = pBackScene:getChildByTag(12000)
    local m_p_Mail = m_p_Middle:getChildByTag(12000):getChildByTag(14011)
    return m_p_Mail
end

function ShowNewMail()
	local m_p_Mail = GetMailParent()
    if m_p_Mail:getChildByTag(755) ~= nil then 
    	m_p_Mail:getChildByTag(755):setVisible(true) 
    end	
end

function ClearMailPromptBtn()
	local m_p_Mail = GetMailParent()
    if m_p_Mail:getChildByTag(755) ~= nil then 
    	m_p_Mail:getChildByTag(755):setVisible(false) 
    end	
end

function SetFightNumber(nNumber)

    local Image_fight = tolua.cast(m_playerMainRoot:getWidgetByName("Image_23"), "ImageView")
    if Image_fight:getChildByTag(1000) ~= nil then
    	local nTemp = tolua.cast(Image_fight:getChildByTag(1000), "LabelBMFont")
		nTemp:setText(nNumber)
    else
		local pText = LabelBMFont:create()
		pText:setFntFile("Image/imgres/main/fight.fnt")
		pText:setPosition(ccp(-10,-20))
		pText:setAnchorPoint(ccp(0,0.5))
		pText:setText(nNumber)
		Image_fight:addChild(pText,0,1000)
    end

end

function SetTili(nNumber)

    local Image_tili = tolua.cast(m_playerMainRoot:getWidgetByName("Image_25_1"), "ImageView")
    if Image_tili:getChildByTag(1000) ~= nil then
		LabelLayer.setText(Image_tili:getChildByTag(1000), nNumber)
    else
		text = LabelLayer.createStrokeLabel(20, "微软雅黑", nNumber, ccp(-40, 0), COLOR_Black, ccc3(206,147,91), false, ccp(0, -2), 2)
	  	Image_tili:addChild(text,  0, 1000)
    end

end

function SetNaili(nNumber)

    local Image_naili = tolua.cast(m_playerMainRoot:getWidgetByName("Image_25_0"), "ImageView")
    if Image_naili:getChildByTag(1000) ~= nil then
		LabelLayer.setText(Image_naili:getChildByTag(1000), nNumber)
    else
		text = LabelLayer.createStrokeLabel(20, "微软雅黑", nNumber, ccp(-40, 0), COLOR_Black, ccc3(206,147,91), false, ccp(0, -2), 2)
	  	Image_naili:addChild(text,  0, 1000)
    end
end

function SetGold(nNumber)

    local Image_gold = tolua.cast(m_playerMainRoot:getWidgetByName("Image_gold"), "ImageView")
    if Image_gold:getChildByTag(1000) ~= nil then
		LabelLayer.setText(Image_gold:getChildByTag(1000), nNumber)
    else
		text = LabelLayer.createStrokeLabel(20, "微软雅黑", nNumber, ccp(-40, 0), COLOR_Black, ccc3(206,147,91), false, ccp(0, -2), 2)
	  	Image_gold:addChild(text,  0, 1000)
    end
end

function SetSilver(nNumber)

    local Image_Silver = tolua.cast(m_playerMainRoot:getWidgetByName("Image_25_2"), "ImageView")
    if Image_Silver:getChildByTag(1000) ~= nil then
		LabelLayer.setText(Image_Silver:getChildByTag(1000), nNumber)
    else
		text = LabelLayer.createStrokeLabel(20, "微软雅黑", nNumber, ccp(-40, 0), COLOR_Black, ccc3(206,147,91), false, ccp(0, -2), 2)
	  	Image_Silver:addChild(text, 0, 1000)
    end
end

function SetExp( nExp )
	local nLevel = server_mainDB.getMainData("level")
	if nLevel == 100 then
		nLevel = 99
	end
	local nLvExp = UserSettingData.GetNextLvExp(nLevel)
	local nPer = nExp/nLvExp
	local ProgressBar_Exp = tolua.cast(m_playerMainRoot:getWidgetByName("ProgressBar_jingyan"),"LoadingBar")
	ProgressBar_Exp:setPercent(nPer*100)
end

function SetName(strName)
	local Image_left = tolua.cast(m_playerMainRoot:getWidgetByName("Image_left"), "ImageView")
    if Image_left:getChildByTag(1000) ~= nil then
		LabelLayer.setText(Image_left:getChildByTag(1000), strName)
    else
		text = LabelLayer.createStrokeLabel(20, "微软雅黑", strName, ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, 0), 0)
	  	Image_left:addChild(text,  0, 1000)
    end
end

function SetLevel(nlevel)
	local Image_levelBg = tolua.cast(m_playerMainRoot:getWidgetByName("Image_levelBg"), "ImageView")
    if Image_levelBg:getChildByTag(1000) ~= nil then
		LabelLayer.setText(Image_levelBg:getChildByTag(1000), nlevel)
    else
		text = LabelLayer.createStrokeLabel(23, "微软雅黑", nlevel, ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, 0), 0)
	  	Image_levelBg:addChild(text,  3, 1000)
    end
end

function SetVip(nVip,ntype)
    local Image_Vip = tolua.cast(m_playerMainRoot:getWidgetByName("Image_25"), "ImageView")
    Image_Vip:loadTexture("Image/imgres/VIPCharge/vip.png")
    Image_Vip:setScale(0.8)
	if Image_Vip:getChildByTag(99) ~= nil then
		Image_Vip:getChildByTag(99):removeFromParentAndCleanup(true)
	end
	local labelVipNum = LabelBMFont:create()
	labelVipNum:setFntFile("Image/imgres/common/num/vipNum.fnt")
	labelVipNum:setText(nVip)
	labelVipNum:setAnchorPoint(ccp(0,0.5))
	labelVipNum:setPosition(ccp(30, 0))
	Image_Vip:addChild(labelVipNum,1,99)
	if ntype ~= 1 then
		-- Image_Vip:setScale(0)
		local actionArray1 = CCArray:create()
		actionArray1:addObject(CCScaleTo:create(0.1, 1.2))
		actionArray1:addObject(CCDelayTime:create(0.1))
		actionArray1:addObject(CCScaleTo:create(0.1, 0.8))
		Image_Vip:runAction(CCSequence:create(actionArray1))
	end	
end
function _Head_Image_CallBack(sender,eventType)
	--到玩家设置界面
	if eventType == TouchEventType.ended then
		if m_pSceneGame:getChildByTag(layerUserSettingTag)~=nil then
			m_pSceneGame:getChildByTag(layerUserSettingTag):setVisible(false)
			 m_pSceneGame:getChildByTag(layerUserSettingTag):removeFromParentAndCleanup(true)
		end
		local userSettingLayer= UserSettingLayer.CreateUserSettingLayer()
		m_pSceneGame:addChild(userSettingLayer, layerUserSettingTag, layerUserSettingTag)
	end
end

function SetHead( nHeadId )
	local Image_heroHead = tolua.cast(m_playerMainRoot:getWidgetByName("Image_heroHead"), "ImageView")
	if nHeadId > 0 then
		require "Script/serverDB/resimg"
		local iconPath = resimg.getFieldByIdAndIndex(nHeadId, "icon_path")
		Image_heroHead:loadTexture(iconPath)
	end
	Image_heroHead:setTouchEnabled(true)
	Image_heroHead:addTouchEventListener(_Head_Image_CallBack)
end

function SetXingHun( nXingHun )
	local Image_XingHun = tolua.cast(m_playerMainRoot:getWidgetByName("Image_XingHun"), "ImageView")
	if Image_XingHun:getChildByTag(1000) ~= nil then
		LabelLayer.setText(Image_XingHun:getChildByTag(1000), nXingHun)
    else
    	print("nXingHun = "..nXingHun)
		local pText = LabelLayer.createStrokeLabel(20, "微软雅黑", nXingHun, ccp(-40, 0), COLOR_Black, ccc3(206,147,91), false, ccp(0, -2), 2)
	  	Image_XingHun:addChild(pText, 0, 1000)
    end
end

local function RefreshMailBoxStatus( pParent )
	require "Script/serverDB/server_mailDB"
	local mailBoxStatus = server_mailDB.JudgeUnReadMail()
	if pParent:getChildByTag(755) ~= nil then
		local nPromptImg = pParent:getChildByTag(755)
		nPromptImg:setVisible(mailBoxStatus)
	end
end

local function JudgeRewardStatus(  )
	require "Script/serverDB/server_RewardDB"
	local is_reward = server_RewardDB.JudgeIsOpen()
	--print(is_reward)
	-- Pause()
end

function GetSignInParent(  )
	local pBackScene = m_pSceneGame:getChildByTag(layerMainBack)
    local m_p_Middle = pBackScene:getChildByTag(12000)
    local m_p_Sign = m_p_Middle:getChildByTag(12000):getChildByTag(14010)
    return m_p_Sign
end

function DeleteSignInStatus(  )
	local m_p_Sign = GetSignInParent()
    if m_p_Sign:getChildByTag(760) ~= nil then 
    	m_p_Sign:getChildByTag(760):setVisible(false) 
    end	 
end

local function JudgeSignInStatus( pSignIn )
	require "Script/serverDB/server_SignInReward"
	local s_SignInStatus = server_SignInReward.JudgeUnSignInStatus()
	if pSignIn:getChildByTag(760) ~= nil then
		local n_PromptImg = pSignIn:getChildByTag(760)
		n_PromptImg:setVisible(s_SignInStatus)
	end
end

function JudgeVIPStatus( nVipSign )
	require "Script/serverDB/server_VIPRewardStatusDB"
	if Button_Email == nil then
		return
	end
	local s_vipstatus = server_VIPRewardStatusDB.GetGetVIPStatus()
	if Button_Email:getChildByTag(760) ~= nil then
		local n_PvipImg = Button_Email:getChildByTag(760)
		n_PvipImg:setVisible(s_vipstatus)
	end
end

function CheckLuckyDrawPoint(  )
	if m_p_Middle == nil then
		return
	end
	local m_FreeTime_1 = server_mainDB.getMainData("nLuckydrawNum_Sliver")
	local m_FreeTime_2 = server_mainDB.getMainData("nLuckydrawNum_Gold")
	local m_p_SignIn = m_p_Middle:getChildByTag(12000):getChildByTag(14008)
	local n_PromptImg = ImageView:create()
	n_PromptImg:loadTexture("Image/imgres/mail/prompt.png")
	n_PromptImg:setPosition(ccp(170,110))
    if m_p_SignIn:getChildByTag(800) == nil then
    	m_p_SignIn:addChild(n_PromptImg,10,800) 
 	end
 	if tonumber(m_FreeTime_1) >= 1 or tonumber(m_FreeTime_2) >= 1 then
 		n_PromptImg:setVisible(true)
 	else
 		n_PromptImg:setVisible(false)
 	end
	
end

function ChangeInfoBarState( nType )
	--[[local Image_tili = tolua.cast(m_playerMainRoot:getWidgetByName("Image_25_1"), "ImageView")
	local Image_naili = tolua.cast(m_playerMainRoot:getWidgetByName("Image_25_0"), "ImageView")
	local Image_gold = tolua.cast(m_playerMainRoot:getWidgetByName("Image_gold"), "ImageView")
	local Image_Silver = tolua.cast(m_playerMainRoot:getWidgetByName("Image_25_2"), "ImageView")
	local Image_XingHun = tolua.cast(m_playerMainRoot:getWidgetByName("Image_XingHun"), "ImageView")
	if nType==InfoBarType.Main then
		Image_tili:setVisible(true)
		Image_naili:setVisible(true)
		Image_gold:setVisible(true)
		Image_Silver:setVisible(true)
		Image_XingHun:setVisible(false)
	elseif nType==InfoBarType.XingHun then
		Image_tili:setVisible(false)
		Image_naili:setVisible(false)
		Image_gold:setVisible(false)
		Image_Silver:setVisible(false)
		Image_XingHun:setVisible(true)
	end]]--
end

function UpdataMainVars()
	--[[require "Script/serverDB/server_mainDB"
	SetFightNumber(server_mainDB.getMainData("power"))
	SetTili(server_mainDB.getMainData("tili") .. "/" .. server_mainDB.getMainData("max_tili"))
	SetNaili(server_mainDB.getMainData("naili") .. "/" .. server_mainDB.getMainData("max_naili"))
	SetGold(server_mainDB.getMainData("gold"))
	SetSilver(server_mainDB.getMainData("silver"))
	SetXingHun(server_mainDB.getMainData("XingHun"))
	SetName((server_mainDB.getMainData("name")))
	SetLevel(server_mainDB.getMainData("level"))
	SetVip(server_mainDB.getMainData("vip"))
	SetHead(server_mainDB.getMainData("nHeadID"))
	SetExp((server_mainDB.getMainData("exp")))]]--
	SetName((server_mainDB.getMainData("name")))
	SetLevel(server_mainDB.getMainData("level"))
	SetVip(server_mainDB.getMainData("vip"),1)
	SetHead(server_mainDB.getMainData("nHeadID"))
	SetExp((server_mainDB.getMainData("exp")))
	--货币更新
	if m_pBarManager~=nil then
		m_pBarManager:Update()
	end
	local pCorpsScene = CorpsScene.GetPScene()
	if pCorpsScene == nil then
	--金币，银币，耐力，体力，战斗力
		local tabType = {2,1,4,3}
		--CoinInfoBar.UpdateCoinBar(tabType,true)
		--CoinInfoBar.UpdateFightNum(server_mainDB.getMainData("power"))
	else
		local tabType = {2,1,10,13}
		--CoinInfoBar.UpdateCoinBar(tabType,true)
	end
	--爬塔功能开启检测
	UpdateCheckPataOpen()
	--检测夺宝和比武的功能
	UpdateCheckFunctionOpen()

	UpdateCheckCorpsOpen()
	--检测国战功能是否开启
	UodateCheckCountryWarOpen()

	JudgeVIPStatus(Button_Email)

	-- MainBtnLayer.SetBagPoint()

end

local function InitVars()
	m_staUILayerStack = simulationStl.creatStack_Last()
	m_pObserver = ObserverManager.CreateObserver()
	m_pObserver:RegisterObserver(OBSERVER_REGISTER_TYPE.OBSERVER_REGISTER_MAIN,UpdataMainVars)
	m_pSceneGame = nil
	
	m_pBarManager = CoinInfoBarManager.CreateShowBar()
	
end

function ShowLeftInfo( bShow )
	local Image_left = tolua.cast(m_playerMainRoot:getWidgetByName("Image_left"), "ImageView")
	Image_left:setVisible(bShow)
end

function AddSystemBtn(bFlag)
	require "Script/Main/MainBtnLayer"
	local temp = MainBtnLayer.createMainBtnLayer()
	MainBtnLayer.setBackTouch(false)
	MainBtnLayer.SetRootBtnState(bFlag)
	m_pSceneGame:addChild(temp, layerMainBtn_Tag, layerMainBtn_Tag)
end

function GetControlUI()
	return m_playerMainRoot
end

local m_ListInnerHeight = 0.0

--add celina 
local function UpdateNeedLayer()
	GetObserver():Notify()
end

function HideMain( nState )
	if m_pSceneGame:getChildByTag(layerMainBack) ~= nil then 
		m_pSceneGame:getChildByTag(layerMainBack):setVisible(nState)
	end
	if m_playerMainRoot ~= nil then
		m_playerMainRoot:setVisible(nState)
	end
end

--vip功能
function CheckVIPFunction( nIndex )
	local v_data = server_mainDB.getMainData("VIP_Limite")
	if v_data == nil then
		v_data = 1023
	end
	local tabVIPFunc = vipfunction.getDataById(nIndex)
	local cur_VIPLevel = server_mainDB.getMainData("vip")
	local tabConsum = {}
	local tabVIPConsum = {}
	if tonumber(tabVIPFunc[1]) == 1 then
		tabConsum = ConsumeLogic.GetExpendData(tabVIPFunc[2])
	end
	
	local nArray = CCArray:create()
	IntTrans(tonumber(v_data), 1, 1, nArray)
	local nCount = nArray:count()
	local tabVIP = {}
	for i=0,nCount-1 do
		local n_object = tolua.cast(nArray:objectAtIndex(i),"CCInteger")
		local n_objectNum = n_object:getValue()
		table.insert(tabVIP,n_objectNum)
	end
	for key,value in pairs(tabVIP) do
		if tonumber(nIndex) == tonumber(key) then
			if tonumber(tabVIPFunc[1]) ~= 0 then
				if tonumber(tabVIPFunc[1]) == 1 then
					local name = ConsumeLogic.GetConsumeTypeName(tabConsum.TabData[1]["ConsumeType"])
					tabVIPConsum["ConsumeType"] = tabConsum.TabData[1]["ConsumeType"]
					tabVIPConsum["IconPath"] = tabConsum.TabData[1]["IconPath"]
					tabVIPConsum["NeedNum"] = tabConsum.TabData[1]["ItemNeedNum"]
					tabVIPConsum["name"] = name
				end

				tabVIPConsum["vipLimit"] = value
				tabVIPConsum["level"] = tabVIPFunc[3]
				tabVIPConsum["levelNum"] = tabVIPFunc[4]
				tabVIPConsum["vipLevel"] = tabVIPFunc[5]
				
				tabVIPConsum["nType"] = 1
				if tonumber(cur_VIPLevel) >= tonumber(tabVIPFunc[13]) and tonumber(tabVIPFunc[13]) ~= -1 then
					tabVIPConsum["nextVIP"] = cur_VIPLevel
					tabVIPConsum["nextNum"] = tabVIPFunc[14]
					tabVIPConsum["cur_VIP"] = tabVIPFunc[13]
					tabVIPConsum["cur_Num"] = tabVIPFunc[14]
					if tonumber(tabVIPFunc[14]) <= 0 then
						tabVIPConsum["most_Tap"] = 0
					else
						tabVIPConsum["most_Tap"] = 1
					end
					return tabVIPConsum
				elseif tonumber(cur_VIPLevel) >= tonumber(tabVIPFunc[11])  and tonumber(tabVIPFunc[11])~= -1 then
					tabVIPConsum["nextVIP"] = tabVIPFunc[13]
					tabVIPConsum["nextNum"] = tabVIPFunc[14]
					tabVIPConsum["cur_VIP"] = tabVIPFunc[11]
					tabVIPConsum["cur_Num"] = tabVIPFunc[12]
					if tonumber(tabVIPFunc[13]) <= 0 then
						tabVIPConsum["most_Tap"] = 0
					else
						tabVIPConsum["most_Tap"] = 1
					end
					return tabVIPConsum
				elseif tonumber(cur_VIPLevel) >= tonumber(tabVIPFunc[9])  and tonumber(tabVIPFunc[9]) ~= -1 then
					tabVIPConsum["nextVIP"] = tabVIPFunc[11]
					tabVIPConsum["nextNum"] = tabVIPFunc[12]
					tabVIPConsum["cur_VIP"] = tabVIPFunc[9]
					tabVIPConsum["cur_Num"] = tabVIPFunc[10]
					if tonumber(tabVIPFunc[11]) <= 0 then
						tabVIPConsum["most_Tap"] = 0
					else
						tabVIPConsum["most_Tap"] = 1
					end
					return tabVIPConsum
				elseif tonumber(cur_VIPLevel) >= tonumber(tabVIPFunc[7])  and tonumber(tabVIPFunc[7]) ~= -1 then
					tabVIPConsum["nextVIP"] = tabVIPFunc[9]
					tabVIPConsum["nextNum"] = tabVIPFunc[10]
					tabVIPConsum["cur_VIP"] = tabVIPFunc[7]
					tabVIPConsum["cur_Num"] = tabVIPFunc[8]
					if tonumber(tabVIPFunc[9]) <= 0 then
						tabVIPConsum["most_Tap"] = 0
					else
						tabVIPConsum["most_Tap"] = 1
					end
					return tabVIPConsum
				elseif tonumber(cur_VIPLevel) >= tonumber(tabVIPFunc[5])  and tonumber(tabVIPFunc[5]) ~= -1 then
					tabVIPConsum["nextVIP"] = tabVIPFunc[7]
					tabVIPConsum["nextNum"] = tabVIPFunc[8]
					tabVIPConsum["cur_VIP"] = tabVIPFunc[5]
					tabVIPConsum["cur_Num"] = tabVIPFunc[6]
					if tonumber(tabVIPFunc[7]) <= 0 then
						tabVIPConsum["most_Tap"] = 0
					else
						tabVIPConsum["most_Tap"] = 1
					end
					return tabVIPConsum
				else
					tabVIPConsum["nextVIP"] = tabVIPFunc[5]
					tabVIPConsum["nextNum"] = tabVIPFunc[6]
					tabVIPConsum["cur_VIP"] = tabVIPFunc[5]
					tabVIPConsum["cur_Num"] = tabVIPFunc[6]
					if tonumber(tabVIPFunc[5]) <= 0 then
						tabVIPConsum["most_Tap"] = 0
					else
						tabVIPConsum["most_Tap"] = 1
					end
					return tabVIPConsum
				end
			elseif tonumber(tabVIPFunc[1]) == 2 then

			else
				tabVIPConsum["vipLimit"] = value
				tabVIPConsum["level"] = tabVIPFunc[3]
				tabVIPConsum["vipLevel"] = tabVIPFunc[5]
				tabVIPConsum["nType"] = 0
			end
			return tabVIPConsum
		end
	end
end

--暂时写一条测试数据
isGuide = true

function GetChatData( pChatLayer )
	return pChatLayer
end
--设置神秘商店的显示
function SetSecretShop(bVisible)
	--local m_p_Middle = pBackScene:getChildByTag(12000)
	if m_p_Middle==nil then
		return 
	end
	local pShopNode = m_p_Middle:getChildByTag(12000):getChildByTag(14019)
	pShopNode:setVisible(bVisible)
	-- TipLayer.createTimeLayer("随机商店出现",2)
end

--进入排行榜
function ShowRankList( nType )
	local function  openRankList()
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		local temp = scenetemp:getChildByTag(layerRankListTag)
		if temp == nil then
			MainScene.ShowLeftInfo(false)
			MainScene.ClearRootBtn()
			local ranklist = RankListLayer.CreateRankList(nType)
			scenetemp:addChild(ranklist,layerRankListTag,layerRankListTag)
			MainScene.PushUILayer(ranklist)
		else
			print("已经是排行榜界面了")
		end
		NetWorkLoadingLayer.loadingHideNow()
	end	
	Packet_GetRankData.SetSuccessCallBack(openRankList, nType)
	network.NetWorkEvent(Packet_GetRankData.CreatPacket(nType))
	NetWorkLoadingLayer.loadingShow(true)
end

--进入军团
function ShowCorpsScene(  )
	local isCorps = tonumber(server_mainDB.getMainData("nCorps"))

	if isCorps > 0 then
		local function GetSuccessCallback(  )
			-- NetWorkLoadingLayer.loadingHideNow()
			NetWorkLoadingLayer.ClearLoading()
			if CorpsScene.GetPScene() == nil then
				SetCurParent(false)
				CorpsScene.CreateCorpsScene()
			else
				print("已经是军团场景了")
				CorpsScene.ShowHideCoinBar(true)
			end
		end
		Packet_CorpsGetInfo.SetSuccessCallBack(GetSuccessCallback)
		network.NetWorkEvent(Packet_CorpsGetInfo.CreateStream())
		NetWorkLoadingLayer.loadingShow(true)
	else
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1507,nil)
		pTips = nil
		return false
	end
end

function OpenCountryWarMap( nParent, nCityID, nCallBack, nOpenCallBack )
	local temp = nParent:getChildByTag(layerCountryWarTag)
	local function CallFunc(  )
		MainScene.ClearRootBtn()
	end

	local bOpenTab = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_26)

	local function OpenCWar( nResult )
		NetWorkLoadingLayer.loadingShow(false)
		if nResult == 1 then
			if temp == nil then
				if CommonData.g_CountryWarLayer == nil then	
					local actionLeave= CCArray:create()
					actionLeave:addObject(CCCallFunc:create(CallFunc))																				
					CommonData.g_CountryWarLayer = CountryWarScene.CreateCountryScene(0, nCityID)
					CommonData.g_CountryWarLayer:retain()
					CountryWarScene.AddLoadingUI()
					if nCallBack ~= nil then
						CountryWarScene.SetComeInCallBack(nCallBack)
					end
					nParent:addChild(CommonData.g_CountryWarLayer, layerCountryWarTag, layerCountryWarTag)
					CommonData.g_CountryWarLayer:runAction(CCSequence:create(actionLeave))
					m_isClickCountryWar = true
				else
					if nCityID ~= nil then
						CountryWarScene.SetNewCity(nCityID)
					end
					if CommonData.g_CountryWarLayer:isVisible() == false then
						CommonData.g_CountryWarLayer:setPositionX(0)
					end
					local actionLeave= CCArray:create()
					if nCallBack ~= nil then
						CountryWarScene.SetComeInCallBack(nCallBack)
					end
					actionLeave:addObject(CCCallFunc:create(CountryWarScene.OpenCountryWarLayer))
					actionLeave:addObject(CCCallFunc:create(CallFunc))
					CommonData.g_CountryWarLayer:runAction(CCSequence:create(actionLeave))
					m_isClickCountryWar = true
				end

				if nOpenCallBack ~= nil then
					
					if tonumber(bOpenTab.vipLimit) == 0 then
						local pTips = TipCommonLayer.CreateTipLayerManager()
						pTips:ShowCommonTips(1643,nil,"国战",tonumber(bOpenTab.level))
						pTips = nil
						nOpenCallBack( 2 )
					else
						nOpenCallBack( 1 )
					end
					
				end

			else
				if nCityID ~= nil then
					CountryWarScene.SetNewCity(nCityID)
				end
				local actionLeave= CCArray:create()
				if CommonData.g_CountryWarLayer:isVisible() == false then
					--actionLeave:addObject(CCMoveTo:create(0.1,ccp(0,0)))
					CommonData.g_CountryWarLayer:setPositionX(0)
				end
				if nCallBack ~= nil then
					CountryWarScene.SetComeInCallBack(nCallBack)
				end
				actionLeave:addObject(CCCallFunc:create(CountryWarScene.OpenCountryWarLayer))
				actionLeave:addObject(CCCallFunc:create(CallFunc))
				CommonData.g_CountryWarLayer:runAction(CCSequence:create(actionLeave))
				print("进入国战 x = "..CommonData.g_CountryWarLayer:getPositionX().."------------------")
				m_isClickCountryWar = true

				if nOpenCallBack ~= nil then
					
					if tonumber(bOpenTab.vipLimit) == 0 then
						local pTips = TipCommonLayer.CreateTipLayerManager()
						pTips:ShowCommonTips(1643,nil,"国战",tonumber(bOpenTab.level))
						pTips = nil
						nOpenCallBack( 2 )
					else
						nOpenCallBack( 1 )
					end
					
				end
			end
		elseif nResult == 2 then
			--等级不足
			if tonumber(bOpenTab.vipLimit) == 0 then
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1643,nil,"国战",tonumber(bOpenTab.level))
				pTips = nil
			end
			m_isClickCountryWar = false
		elseif nResult == 3 then
			TipLayer.createTimeLayer("国战服未开启", 2)
			m_isClickCountryWar = false
		end
	end

	--发送协议判断是否可以进入国战
	NetWorkLoadingLayer.loadingShow(true)
	Packet_CountryWarLoadFinish.SetSuccessCallBack(OpenCWar)
	network.NetWorkEvent(Packet_CountryWarLoadFinish.CreatPacket(1))

end

--检测军团功能是否开启
function UpdateCheckCorpsOpen(  )
	local tabCorps = CheckVIPFunction(enumVIPFunction.eVipFunction_25)

	local pBackScene = m_pSceneGame:getChildByTag(layerMainBack)
    local m_p_Middle = pBackScene:getChildByTag(12000)
    local pCorpsNode = m_p_Middle:getChildByTag(12000):getChildByTag(14013)

	local pCorpsAniNodeF 	= tolua.cast(pCorpsNode:getComponent("CCArmature"),"CCComRender")
	local pCorpsAniNode 		= tolua.cast(pCorpsAniNodeF:getNode(),"CCArmature")
	
	if tonumber(tabCorps["vipLimit"]) == 1 then
		CCArmatureSharder(pCorpsAniNode, SharderKey.E_SharderKey_Normal)
	else
		CCArmatureSharder(pCorpsAniNode, SharderKey.E_SharderKey_SpriteGray)
	end
end

function GetPScene( )
	if m_pSceneGame ~= nil then
		return m_pSceneGame
	end
end

function SetCurParent( bParent )
	if bParent ~= nil then
		m_isCurMainScene = bParent
	end
end

function GetCurParent(  )
	if m_isCurMainScene ~= nil then
		return m_isCurMainScene
	end
end

--前往充值界面
function GoToVIPLayer( nType )
	local function GetSuccessCallback(  )
		NetWorkLoadingLayer.loadingHideNow()
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		local temp = scenetemp:getChildByTag(layerVIPCharge_tag)
		if temp == nil then
			
			local m_VIPLayer = ChargeVIPLayer.CreateVIPLayer(nType)
			scenetemp:addChild(m_VIPLayer,layerVIPCharge_tag,layerVIPCharge_tag)
			if tonumber(nType) == 1 then
				MainScene.ClearRootBtn()
				MainScene.PushUILayer(m_VIPLayer)
			elseif tonumber(nType) == 2 then
				-- CorpsScene.CorpsPushLayer(m_VIPLayer)
			end
		end
	end
	Packet_VIPRewardStatus.SetSuccessCallBack(GetSuccessCallback)
	network.NetWorkEvent(Packet_VIPRewardStatus.CreatePacket())
	NetWorkLoadingLayer.loadingShow(true)
end

--购买次数 参数 购买类型 (如果购买类型为11时nSceneID,nFight为场景ID,关卡ID) ,回调函数
function BuyCountFunction( nType,nSceneID,nFight,callFunc )
	local function GetSuccessCallback(  )
		NetWorkLoadingLayer.loadingHideNow()
		if callFunc ~= nil then
			callFunc()
		end
	end
	Packet_BuyVIPNum.SetSuccessCallBack(GetSuccessCallback)
	network.NetWorkEvent(Packet_BuyVIPNum.CreatePacket(nType,nSceneID,nFight))
	NetWorkLoadingLayer.loadingShow(true)
end

function UpdateCheckPataOpen(  )
	local bPataCheck = PataLayer.CheckPataOpen()
	local pPataNode  = m_p_Back:getChildByTag(14017)
	local pPataAniNodeF 	= tolua.cast(pPataNode:getComponent("CCArmature"),"CCComRender")
	local pPataAniNode 		= tolua.cast(pPataAniNodeF:getNode(),"CCArmature")
	
	if bPataCheck == true then
		CCArmatureSharder(pPataAniNode, SharderKey.E_SharderKey_Normal)
	else
		CCArmatureSharder(pPataAniNode, SharderKey.E_SharderKey_SpriteGray)
	end
end

function UodateCheckCountryWarOpen(  )
	local pBackScene = m_pSceneGame:getChildByTag(layerMainBack)
	local pCWarNode  = pBackScene:getChildByTag(14000):getChildByTag(14018)
	local pCWarAniNodeF 	= tolua.cast(pCWarNode:getComponent("CCArmature"),"CCComRender")
	local pCWarAniNode 		= tolua.cast(pCWarAniNodeF:getNode(),"CCArmature")
	local bVipTab = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_26)
	if tonumber(bVipTab.vipLimit) == 0 then
		CCArmatureSharder(pCWarAniNode, SharderKey.E_SharderKey_SpriteGray)
	else
		CCArmatureSharder(pCWarAniNode, SharderKey.E_SharderKey_Normal)
	end
end

--add celina 检测夺宝和比武功能的开启
local function UpdateCheckDobkOpen(  )
	require "Script/Main/Dobk/DobkLogic"
	local bDobkCheck = DobkLogic.CheckDobkOpen()
	local pDobkNode  = m_p_Middle:getChildByTag(12000):getChildByTag(14014)
	local pDobkAniNodeF 	= tolua.cast(pDobkNode:getComponent("CCArmature"),"CCComRender")
	local pDobkAniNode 		= tolua.cast(pDobkAniNodeF:getNode(),"CCArmature")
	
	if bDobkCheck == true then
		CCArmatureSharder(pDobkAniNode, SharderKey.E_SharderKey_Normal)
	else
		CCArmatureSharder(pDobkAniNode, SharderKey.E_SharderKey_SpriteGray)
	end
end
local function UpdateCheckBiWuOpen(  )
	require "Script/Main/Dungeon/CompetitionLogic"
	local bBiWuCheck = CompetitionLogic.CheckBiWuOpen()
	local pBiWuNode  = m_p_Middle:getChildByTag(12000):getChildByTag(14012)
	local pBiWuAniNodeF 	= tolua.cast(pBiWuNode:getComponent("CCArmature"),"CCComRender")
	local pBiWuAniNode 		= tolua.cast(pBiWuAniNodeF:getNode(),"CCArmature")
	
	if bBiWuCheck == true then
		CCArmatureSharder(pBiWuAniNode, SharderKey.E_SharderKey_Normal)
	else
		CCArmatureSharder(pBiWuAniNode, SharderKey.E_SharderKey_SpriteGray)
	end
end

function UpdateCheckFunctionOpen()
	UpdateCheckDobkOpen()
	UpdateCheckBiWuOpen()
end
--end add
function SetBRole()
	bRole = true
end

function GuideScroll(fCallBack)
	local ScrollView_22 = tolua.cast(m_playerMainRoot:getWidgetByName("ScrollView_22"), "ScrollView")
	local innerPtX = ScrollView_22:getInnerContainer():getPositionX()
	--[[local m_OffSetX = -640
	
	--local array = CCArray:create()
	
	if nil ~= innerPtX then
		if m_p_Back ~= nil then
			m_p_Back:runAction(CCMoveTo:create(1,ccp(m_p_Back:getPositionX() + m_OffSetX * 0.5,m_p_Back:getPositionY())))
		end
		if m_p_Middle ~= nil then
			m_p_Middle:runAction(CCMoveTo:create(1,ccp(m_p_Middle:getPositionX() + m_OffSetX ,m_p_Middle:getPositionY())))
		end
		if m_p_Front ~= nil then
			m_p_Front:runAction(CCMoveTo:create(1,ccp(m_p_Front:getPositionX() + m_OffSetX* 1.5 ,m_p_Front:getPositionY())))
		end
	end]]--
	ScrollView_22:scrollToPercentHorizontal(70,1.0,true)
	bScroolView = true
	if fCallBack~=nil then
		fCallBack()
	end
end
function BackScrollView()
	if bScroolView == true then
		bScroolView = false
		local ScrollView_22 = tolua.cast(m_playerMainRoot:getWidgetByName("ScrollView_22"), "ScrollView")
		ScrollView_22:scrollToPercentHorizontal(0,0.1,false)
	end
end
--登录游戏时的公告
local function GetChatMess(  )
	local tabMess = NoticeScrollData.GetChatMessByID(13)
	ChatLayer.LoadList(tabMess)
	ChatShowLayer.UpDateChatList(tabMess)
end



function createMainUI()
	InitVars()  
	m_pSceneGame = CCScene:create()

	local m_nHanderTime = nil
	local function NetUpdata(dt)
		UpNetWork()
	end	

	local function SceneEvent(tag)
		if tag == "enter" then	
			print("进入主场景 更新测试")
			Scence_OnBegin()
			m_nHanderTime  = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(NetUpdata, CommonData.g_nNetUpdataTime, false)
			AtkCityScene.SetBFight(true)
			UpdateNeedLayer()
			--国战场景检测
			if CommonData.g_CountryWarLayer ~= nil then
				if CountryWarScene.GetLevelSceneFromCountryWar() == true then
					--是从国战层离开的
					local function callFunc(  )	
						CountryWarScene.SetMapToLeavePt()
					end 
					local actionLeave= CCArray:create()
					actionLeave:addObject(CCCallFunc:create(callFunc))
					CommonData.g_CountryWarLayer:runAction(CCSequence:create(actionLeave))
				end
			else
				print("国战层还未在主场景创建")
			end
		end

		if tag == "enterTransitionFinish" then	
			--Scence_OnBegin()

			local ScrollView_22 = tolua.cast(m_playerMainRoot:getWidgetByName("ScrollView_22"), "ScrollView")
			--local curX= ScrollView_22:getInnerContainer():getPositionX()
			m_LastPtX = nOffX
			if math.abs(nOffX)~= 0 then
				local persent = (math.abs(nOffX)/math.abs(-960))*100
				ScrollView_22:jumpToPercentHorizontal(persent)
			end
			 CCUserDefault:sharedUserDefault():setBoolForKey("isMainScene",true)
			--场景加载完成后，对国战层的判断
			local function JudgeParent_ByMain( )
				print(CommonData.g_CountryWarLayer:getPositionX(), CommonData.g_CountryWarLayer:getPositionY())
				print("进入主场景，国战层存在，更换其到主场景")
				
				local nParent = CountryWarScene.GetCurParent()
				if nParent == 0 then
					--现在的国战父节点是自己,判断当前是否需要显示国战层
					print("国战层坐标:X = "..CommonData.g_CountryWarLayer:getPositionY())
					print(CommonData.g_CountryWarLayer:isVisible())
					print("nothing todo by main")
				elseif nParent == 1 or nParent == 2 then
					--不是自己进行摘挂
					print("国战层坐标:X = "..CommonData.g_CountryWarLayer:getPositionY())
					print(CommonData.g_CountryWarLayer:isVisible())
					print("change my parent by main")
					CountryWarScene.ChangeCurParentNode(m_pSceneGame, 0)
				end	
			end
			if CommonData.g_CountryWarLayer ~= nil then
				JudgeParent_ByMain()			--判断父节点
			end
			--add by sxin 播放cg测试
			--[[if bRole == true then
				require "Script/cg/cg_piantou"
				cg_piantou.playCg()
				bRole = false
			end]]--
			AudioUtil.playBgm("audio/bgm/music_z.mp3",true)
			print("playBgm audio/bgm/music_z.mp3",true)
			if CommonData.OPEN_GUIDE == 1 then
				NewGuideManager.CreateNewGuideManager()
			end
			CompetitionLayer.ShowUpTips()

			local scenetemp =  CCDirector:sharedDirector():getRunningScene()
			local temp = scenetemp:getChildByTag(layerPataTag)
			if temp == nil then
				--爬塔界面存在则不重新加载聊天界面
				ChatShowLayer.ShowChatlayer(m_playerMainRoot)
			end
		end	

		if tag == "exit" then	
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_nHanderTime)
			if m_playerMainRoot~=nil then
				local ScrollView_22 = tolua.cast(m_playerMainRoot:getWidgetByName("ScrollView_22"), "ScrollView")
				nOffX = ScrollView_22:getInnerContainer():getPositionX()
				--print(nOffX-)
			end
		end	

		if tag == "exitTransitionStart" then		
		end	

		if tag == "cleanup" then			
		end	
	end
	m_pSceneGame:registerScriptHandler(SceneEvent)

	m_playerMainRoot = TouchGroup:create()									-- 背景层
    m_playerMainRoot:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/MainRootLayer.json") )
	
    ChangeInfoBarState(InfoBarType.Main)
	
	--添加上面的货币显示条
	--CoinInfoBar.AddCoinBar(m_pSceneGame)
    if server_mainDB.getMainData("name") ~= nil then
		--UpdataMainVars()
    end	
    
	-- 充值界面回调
	local function _Button_Email_Btn_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
			sender:setScale(1)
			AudioUtil.PlayBtnClick()
			local function GetSuccessCallback(  )
				NetWorkLoadingLayer.loadingHideNow()
				local scenetemp =  CCDirector:sharedDirector():getRunningScene()
				local temp = scenetemp:getChildByTag(layerVIPCharge_tag)
				if temp == nil then
					-- MainScene.ShowLeftInfo(false)
					MainScene.ClearRootBtn()
					local pVIPLayer = ChargeVIPLayer.CreateVIPLayer(1)
					scenetemp:addChild(pVIPLayer,layerVIPCharge_tag,layerVIPCharge_tag)--layerVIPCharge_tag
					MainScene.PushUILayer(pVIPLayer)
				end
			end
			Packet_VIPRewardStatus.SetSuccessCallBack(GetSuccessCallback)
			network.NetWorkEvent(Packet_VIPRewardStatus.CreatePacket())
			NetWorkLoadingLayer.loadingShow(true)
		elseif  eventType == TouchEventType.began then
			sender:setScale(0.9)
		elseif eventType == TouchEventType.canceled then
			sender:setScale(1.0)
		end
	end
    Button_Email = tolua.cast(m_playerMainRoot:getWidgetByName("Button_Email"), "Button")
    Button_Email:addTouchEventListener(_Button_Email_Btn_CallBack)
    ------------------------------------------------------------------
	-- 礼包
	local function _Button_Award_Btn_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
			--EndTime()
			AudioUtil.PlayBtnClick()
			sender:setScale(1)
			-- TipLayer.createPopTipLayer("生命 +12", 24, COLOR_Green, ccp(CommonData.g_sizeVisibleSize.width/2, CommonData.g_sizeVisibleSize.height/2))
			-- TipLayer.createPopTipLayer("苏南 +12", 24, COLOR_Green, ccp(CommonData.g_sizeVisibleSize.width/2, CommonData.g_sizeVisibleSize.height/2 - 30))
			-- require "Script/Main/CountryReward/CountryRewardLayer"
			-- CountryRewardLayer.createRewardLayer(m_pSceneGame)
			-- local heroLevel = server_mainDB.getMainData("level")
			-- HeroUpGradeLayer.showUpLayer(5)
			--add by sxin 测试支付接口
			--[[
			if CommonData.IsAnySDK() == true then
				local pProduct_Price = "1"
				local pProduct_Id = "1"
				local pProduct_Name = "1元宝"
				local pServer_Id = CommonData.g_nCurServerMapID
				local Product_Count = "1"
				
				local pRole_Id = CommonData.g_nGlobalID
				local pRole_Name = server_mainDB.getMainData("name")
				local pRole_Grade = server_mainDB.getMainData("level")
				local pRole_Balance = "0"
				AnySDKpay(pProduct_Price,pProduct_Id,pProduct_Name,pServer_Id,Product_Count,pRole_Id,pRole_Name,pRole_Grade,pRole_Balance)							
			end
			]]--
		elseif  eventType == TouchEventType.began then
			sender:setScale(0.9)
		elseif eventType == TouchEventType.canceled then
			sender:setScale(1.0)
		end
	end
    local Button_Award = tolua.cast(m_playerMainRoot:getWidgetByName("Button_Award"), "Button")
    Button_Award:addTouchEventListener(_Button_Award_Btn_CallBack)
    ------------------------------------------------------------------

	m_pSceneGame:addChild(m_playerMainRoot, layerMainRoot_Tag, layerMainRoot_Tag)

	
	AddSystemBtn(false)
    CCDirector:sharedDirector():replaceScene(m_pSceneGame)
	
	local pBackScene = SceneReader:sharedSceneReader():createNodeWithSceneFile("publish/Scene_zhucheng.json")
	m_pSceneGame:addChild(pBackScene, layerMainBack, layerMainBack)

	m_p_Back = pBackScene:getChildByTag(13000)
	m_p_Middle = pBackScene:getChildByTag(12000)
	m_p_Front = pBackScene:getChildByTag(11000)

	local bClicked = false
	local nClickedCount = 0

	local nTagTab = {14008,14009,14010,14011,14012,14013,14014,14015,14016,14017,14018,14019}
	
	local function actionClick(sender, eventType)
		for key,value in pairs(nTagTab) do
			local nNode
			if key == 11 then
				nNode = pBackScene:getChildByTag(14000):getChildByTag(value)
			elseif key == 10 then
				nNode = pBackScene:getChildByTag(13000):getChildByTag(value)
			else
				nNode = m_p_Middle:getChildByTag(12000):getChildByTag(value)
			end

			if nNode ~= nil then
				local pCCNodeF = tolua.cast(nNode:getComponent("CCArmature"),"CCComRender")
				local pCCNode = tolua.cast(pCCNodeF:getNode(),"CCArmature")	
				local rect = pCCNode:boundingBox()					
    			local nWi = rect.size.width
    			local nHe = rect.size.height	
    			local fAncPointX = pCCNode:getAnchorPointInPoints().x
				local fAncPointY = pCCNode:getAnchorPointInPoints().y				
    			local ptPt = nil
    			if eventType == TouchEventType.began then
    				ptPt = sender:getTouchStartPos()
				elseif eventType == TouchEventType.moved then
    				ptPt = sender:getTouchMovePos()
				elseif eventType == TouchEventType.ended then
    				ptPt = sender:getTouchEndPos()
					AudioUtil.PlayBtnClick()
				end
				if ptPt ~= nil then 
					local convertPt = nNode:convertToNodeSpace(ccp(ptPt.x,ptPt.y))
					if rect:containsPoint(ccp(convertPt.x,convertPt.y)) then
						if eventType == TouchEventType.began then
							if nNode:isVisible()== false then
								return 
							end
							pCCNode:getAnimation():play("Animation2")
							bClicked = true
							nClickedCount = 0
							if key == 10 and PataLayer.CheckPataOpen() == false then
								local bOpen,nNeedLv = PataLayer.CheckPataOpen()
								local pTips = TipCommonLayer.CreateTipLayerManager()
								pTips:ShowCommonTips(1643,nil,"通天塔",tonumber(nNeedLv))
								pTips = nil								
								return
							end
			        elseif eventType == TouchEventType.moved then
			        	--print("nClickedCount = "..nClickedCount)
						if nNode:isVisible()== false then
							return 
						end
						nClickedCount = nClickedCount + 1
						if nClickedCount == 5 then
							bClicked = false
							if pCCNode:getAnimation():getCurrentMovementID() ~= "Animation1" then
								pCCNode:getAnimation():play("Animation1")
							end
						end
			        elseif eventType == TouchEventType.ended then
			        	AudioUtil.PlayBtnClick()
						if bClicked == true then
							pCCNode:getAnimation():play("Animation1")
							if key == 2 then
								local nShopId = 1
								local function OpenShop()
									NetWorkLoadingLayer.loadingHideNow()
									local scenetemp =  CCDirector:sharedDirector():getRunningScene()
									local temp = scenetemp:getChildByTag(layerMall_Tag)
									if temp == nil then
										MainScene.ShowLeftInfo(false)
										MainScene.ClearRootBtn()
										require "Script/Main/Mall/ShopLayer"
										local pLayerShop = ShopLayer.CreateShopLayer(nShopId)
										scenetemp:addChild(pLayerShop,layerMall_Tag,layerMall_Tag)
										MainScene.PushUILayer(pLayerShop)
									else
										print("已经是商店界面了")
									end
								end
								NetWorkLoadingLayer.loadingShow(true)
								Packet_GetShopList.SetSuccessCallBack(OpenShop)
								network.NetWorkEvent(Packet_GetShopList.CreatPacket(nShopId))
								return 	
							elseif key == 1 then
								--酒馆
								local scenetemp =  CCDirector:sharedDirector():getRunningScene()
								local temp = scenetemp:getChildByTag(layerSmithy_Tag)
								if temp == nil then 
									MainScene.ShowLeftInfo(false)
									MainScene.ClearRootBtn()
									require "Script/Main/LuckyDraw/LuckyDrawLayer"
									local pLayerLuckyDraw = LuckyDrawLayer.CreateLuckyDrawLayer()
									scenetemp:addChild(pLayerLuckyDraw,layerSmithy_Tag,layerSmithy_Tag)
									MainScene.PushUILayer(pLayerLuckyDraw)
								else
									print("已经是酒馆页面了")
								end		
								return 
							elseif key == 4 then
								--邮件信箱
								local function  openMail()
									local scenetemp =  CCDirector:sharedDirector():getRunningScene()
									local temp = scenetemp:getChildByTag(layerMail_Tag)
									if temp == nil then
										MainScene.ShowLeftInfo(false)
										MainScene.ClearRootBtn()
										require "Script/Main/Mail/MailLayer"
										local mail = MailLayer.CreateMailLayer()
										scenetemp:addChild(mail,layerMail_Tag,layerMail_Tag)
										MainScene.PushUILayer(mail)
									else
										print("已经是邮件界面了")
									end
								end	
								openMail()
								return 
							elseif key == 3 then
								--奖励页面		
								local function GetLuxSuccessCallBack(  )
									NetWorkLoadingLayer.loadingHideNow()
									local scenetemp = CCDirector:sharedDirector():getRunningScene()
									local temp = scenetemp:getChildByTag(30)
									if temp == nil then
										local pSignInlayer = SignInLayer.CreateSignLayer()
										scenetemp:addChild(pSignInlayer,30,30)--layerSignInLayer_Tag
										MainScene.ShowLeftInfo(false)
										MainScene.ClearRootBtn()
										MainScene.PushUILayer(pSignInlayer)
									else
										print("已经是签到界面了")
									end
								end
								Packet_SignInReward.SetSuccessCallBack(GetLuxSuccessCallBack)
								network.NetWorkEvent(Packet_SignInReward.CreatePacket())
								NetWorkLoadingLayer.loadingShow(true)
								return 
							elseif key == 5 then
								require "Script/Main/Dungeon/CompetitionLogic"
								local bBiWuCheck = CompetitionLogic.CheckBiWuOpen()
								if bBiWuCheck == true then 
									local scenetemp =  CCDirector:sharedDirector():getRunningScene()
									local tempCur = scenetemp:getChildByTag(layerCompetition_Tag)
									if tempCur ~= nil  then
										print("已经是比武界面了")
									else
										local function GetCompetitionData()
											NetWorkLoadingLayer.loadingShow(false)
											local pLayerCompetition = CompetitionLayer.CreateCompetitonLayer(DungeonsType.Normal)
											if pLayerCompetition==nil then
												print("pLayerDungeonManager is nil...")
												return
											end
											scenetemp:addChild(pLayerCompetition,layerCompetition_Tag,layerCompetition_Tag)
											MainScene.ShowLeftInfo(false)
											MainScene.ClearRootBtn()
											MainScene.PushUILayer(pLayerCompetition)
											--[[local tabType = {2,1,4,9}
											CoinInfoBar.UpdateCoinBar(tabType,true)]]--
										end
										Packet_GetCompetitionData.SetSuccessCallBack(GetCompetitionData)
										network.NetWorkEvent(Packet_GetCompetitionData.CreatPacket())
										NetWorkLoadingLayer.loadingShow(true)
									end
								else
									--提示错误
									local tabBiWu = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_27)
									local pTips = TipCommonLayer.CreateTipLayerManager()
									pTips:ShowCommonTips(1643,nil,"比武",tonumber(tabBiWu.level))
									pTips = nil
								end
								return 
							elseif key == 6 then
								--军团页面		
								local isCorps = tonumber(server_mainDB.getMainData("nCorps"))
								if isCorps > 0 then

									ShowCorpsScene()
								else
									local tabCorps = CheckVIPFunction(enumVIPFunction.eVipFunction_25)
									
									if tonumber(tabCorps["vipLimit"]) == 0 then
										local pTips = TipCommonLayer.CreateTipLayerManager()
										pTips:ShowCommonTips(1643,nil,"创建军团功能",tabCorps["level"])
										pTips = nil
									else
										local CorpsId = 1
										local scenetemp = CCDirector:sharedDirector():getRunningScene()
										local temp = scenetemp:getChildByTag(layerCorpsTag)
										if temp == nil then						
											local Corps = CorpsLayer.CreateCorpsLayer(E_Corps_Type.E_Corps_Add)
											scenetemp:addChild(Corps,layerCorpsTag,layerCorpsTag)
												
										else
											print("已经是创建军团界面了")
										end
									end
								end
								return 
							elseif key == 7 then
								--功能页面01
								require "Script/Main/Dobk/DobkLogic"
								local bDobkCheck = DobkLogic.CheckDobkOpen()
								if bDobkCheck == true then
									local scenetemp =  CCDirector:sharedDirector():getRunningScene()
									local tempCur = scenetemp:getChildByTag(layerDobk_Tag)
									if tempCur ~= nil  then
										print("已经是夺宝界面了")
									else
										local function GetDobkInfo()
											NetWorkLoadingLayer.loadingShow(false)
											local pLayerDobk = DobkLayer.CreateDobkLayer()
											if pLayerDobk==nil then
												print("pLayerDobk is nil...")
												return
											end
											scenetemp:addChild(pLayerDobk,layerDobk_Tag,layerDobk_Tag)
											MainScene.ShowLeftInfo(false)
											MainScene.ClearRootBtn()
											MainScene.PushUILayer(pLayerDobk)
										end
										Packet_DobkInfo.SetSuccessCallBack(GetDobkInfo)
										network.NetWorkEvent(Packet_DobkInfo.CreatPacket(DOBK_TYPE.DOBK_TYPE_SW))
										NetWorkLoadingLayer.loadingShow(true)
										
									end
								else
									--提示错误
									local tabDobk = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_28)
									local pTips = TipCommonLayer.CreateTipLayerManager()
									pTips:ShowCommonTips(1643,nil,"夺宝",tonumber(tabDobk.level))
									pTips = nil
								end
								return 									
							elseif key == 8 then
								--排行榜页面
								ShowRankList(RANKING_LIST_TYPE.RANKING_LIST_ATHLETICS)
								return 
							elseif key == 9 then
						    	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
								local tempCur = scenetemp:getChildByTag(lyaerActivityList_Tag)
								if tempCur ~= nil  then
								    print("已经是副本界面了")
								else
									MainScene.ShowLeftInfo(false)
									MainScene.ClearRootBtn()
									--MainScene.DeleteUILayer(DungeonManagerLayer.GetUIControl())
									local pLayerDungeonManager = DungeonManagerLayer.CreateDungeonManagerLayer(DungeonsType.Normal)
									if pLayerDungeonManager==nil then
										print("pLayerDungeonManager is nil...")
										return
									end
									scenetemp:addChild(pLayerDungeonManager,lyaerActivityList_Tag,lyaerActivityList_Tag)
									MainScene.PushUILayer(pLayerDungeonManager)
								end
								return 
							elseif key == 10 then
								--功能页面04
								local function  openPata()
									local scenetemp =  CCDirector:sharedDirector():getRunningScene()
									local temp = scenetemp:getChildByTag(layerPataTag)
									if temp == nil then
										MainScene.ShowLeftInfo(false)
										MainScene.ClearRootBtn()
										local pata = PataLayer.CreatePataLayer()
										scenetemp:addChild(pata,layerPataTag,layerPataTag)
										MainScene.PushUILayer(pata)
									else
										print("已经是爬塔界面了")
									end
									NetWorkLoadingLayer.loadingHideNow()
								end	
								if PataLayer.CheckPataOpen() == true then
									Packet_GetFuBenInfo.SetSuccessCallBack(openPata, DungeonsType.ClimbingTower)
									network.NetWorkEvent(Packet_GetFuBenInfo.CreatPacket(DungeonsType.ClimbingTower))
									NetWorkLoadingLayer.loadingShow(true)
								else
									print("功能未开启")
								end
								return 
							elseif key == 12 then
								if nNode:isVisible()== false then
									return 
								end
								--点击神秘商店的回调写在这里
								require "Script/serverDB/server_ShopOpenDB"
								local n_shopType = server_ShopOpenDB.GetSecretShopType()
								local n_shopID = server_ShopOpenDB.GetSecretShopID()
								if n_shopType == nil then
									return
								end
								local function OpenShop()
									NetWorkLoadingLayer.loadingHideNow()
									local scenetemp =  CCDirector:sharedDirector():getRunningScene()
									local temp = scenetemp:getChildByTag(layerMall_Tag)
									if temp == nil then
										MainScene.ShowLeftInfo(false)
										MainScene.ClearRootBtn()
										require "Script/Main/Mall/ShopLayer"
										local pLayerShop = ShopLayer.CreateShopLayer(n_shopID)
										scenetemp:addChild(pLayerShop,layerMall_Tag,layerMall_Tag)
										MainScene.PushUILayer(pLayerShop)
									else
										print("已经是商店界面了")
									end
								end
								Packet_GetShopList.SetSuccessCallBack(OpenShop)
								network.NetWorkEvent(Packet_GetShopList.CreatPacket(n_shopType))
								NetWorkLoadingLayer.loadingShow(true)
								return 
							elseif key == 11 then
								--国战
								if m_isClickCountryWar == false then
									OpenCountryWarMap(m_pSceneGame)
								end
								return 
								end	
							end					
				        else
							if pCCNode:getAnimation():getCurrentMovementID() ~= "Animation1" then
								pCCNode:getAnimation():play("Animation1")
							end
				    	end
				    	return
					end
				end
			else
				if pCCNode:getAnimation():getCurrentMovementID() ~= "Animation1" then
					pCCNode:getAnimation():play("Animation1")
				end
			end
		end
	end	

    local function onTouchEvent(sender, eventType)
        actionClick(sender, eventType)
	end
    local ScrollView_22 = tolua.cast(m_playerMainRoot:getWidgetByName("ScrollView_22"), "ScrollView")
    ScrollView_22:addTouchEventListener(onTouchEvent)


	m_LastPtX = ScrollView_22:getInnerContainer():getPositionX()
	local function SetTick(sender,eventType)
		if eventType == 4 then
			local innerPtX = sender:getInnerContainer():getPositionX()
			local m_OffSetX = innerPtX - m_LastPtX
			--print("*********************"..m_OffSetX)
			
			m_LastPtX = innerPtX
			if nil ~= innerPtX then
				if m_p_Back ~= nil then
					
					m_p_Back:setPositionX(m_p_Back:getPositionX() + m_OffSetX * 0.5)
				end
				if m_p_Middle ~= nil then
					m_p_Middle:setPositionX(m_p_Middle:getPositionX() + m_OffSetX)
				end
				if m_p_Front ~= nil then
					m_p_Front:setPositionX(m_p_Front:getPositionX() + m_OffSetX * 1.5)
				end
			end
		end
	end
	ScrollView_22:addEventListenerScrollView(SetTick)


    local nOff_W = CommonData.g_nDeginSize_Width - CommonData.g_sizeVisibleSize.width
    local nOff_H = CommonData.g_nDeginSize_Height - CommonData.g_sizeVisibleSize.height

    m_playerMainRoot:setPosition(ccp(nOff_W/2, nOff_H/2))

    local tableFixControl = {
    {
    	["off_x"] = 0,
    	["off_y"] = 0,
    	["control"] = tolua.cast(m_playerMainRoot:getWidgetByName("Panel_46"), "Layout"),
    },
}
	for key,value in pairs(tableFixControl) do
		if value["control"] ~= nil then
			local nWidth = value["control"]:getPositionX() - nOff_W + value["off_x"]
			local nHeight = value["control"]:getPositionY() - nOff_H + value["off_y"]
    		value["control"]:setPosition(ccp(nWidth, nHeight))
		end
	end
--[[
    --增加返回键监听
    local backClickLayer = CCLayer:create()
	m_pSceneGame:addChild(backClickLayer)
    local function KeypadHandler(strEvent)
        if "backClicked" == strEvent then
            CCDirector:sharedDirector():endToLua()
            elseif "menuClicked" == strEvent then
            CCDirector:sharedDirector():endToLua()
        end
    end
    backClickLayer:setKeypadEnabled(true)
    backClickLayer:registerScriptKeypadHandler(KeypadHandler)
    --]]
	
	--创建聊天
    ChatShowLayer.CreateShowChatLayer(m_playerMainRoot)
    NoticeScrollLayer.createNotice()
    NoticeSTiplayer.createsNotice()
    GetChatMess()
	local m_p_Mail = m_p_Middle:getChildByTag(12000):getChildByTag(14011)
	local nPromptImg = ImageView:create()
	nPromptImg:loadTexture("Image/imgres/mail/prompt.png")
	nPromptImg:setPosition(ccp(90,105))
    if m_p_Mail:getChildByTag(755) ~= nil then m_p_Mail:removeChildByTag(755) end
	m_p_Mail:addChild(nPromptImg,10,755)

	--判断当前是否有未读邮件
	RefreshMailBoxStatus(m_p_Mail)

	local m_p_SignIn = m_p_Middle:getChildByTag(12000):getChildByTag(14010)
	local n_PromptImg = ImageView:create()
	n_PromptImg:loadTexture("Image/imgres/mail/prompt.png")
	n_PromptImg:setPosition(ccp(150,110))
    if m_p_SignIn:getChildByTag(760) ~= nil then m_p_SignIn:removeChildByTag(760) end
	m_p_SignIn:addChild(n_PromptImg,10,760)

	--判断当前签到是否全签
	JudgeSignInStatus(m_p_SignIn)

	--判断vip领取状态
	local n_VipImg = ImageView:create()
	n_VipImg:loadTexture("Image/imgres/mail/prompt.png")
	n_VipImg:setPosition(ccp(58,-7))
    if Button_Email:getChildByTag(760) ~= nil then Button_Email:removeChildByTag(760) end
	Button_Email:addChild(n_VipImg,10,760)

	JudgeVIPStatus(Button_Email)

	--判断神秘商店是否出现
	local function UpShopOpen(  )
		local is_open = server_ShopOpenDB.GetSecretShopOpen()
		if tonumber(is_open) == 0 then 
			SetSecretShop(false)
		elseif tonumber(is_open) == 1 then
			SetSecretShop(true)
		else
			SetSecretShop(false)
		end
	end
	UpShopOpen()

	--检测爬塔功能开始
	UpdateCheckPataOpen()
	UpdateCheckFunctionOpen()
	--检测军团是否开启
	UpdateCheckCorpsOpen()
	--检测国战是否开启
	UodateCheckCountryWarOpen()
	CheckLuckyDrawPoint()
	-- MainBtnLayer.SetBagPoint()
	
	m_pBarManager:Create(m_playerMainRoot,CoinInfoBarManager.EnumLayerType.EnumLayerType_Main)

	--初始化界面跳转管理
	CommonData.g_GuildeManager = UIGotoManager.CreateUIGotoManager()
	CommonData.g_GuildeManager:CreateObj()
	
end


