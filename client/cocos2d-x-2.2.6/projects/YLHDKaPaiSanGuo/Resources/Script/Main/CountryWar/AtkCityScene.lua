--攻城战的场景 celina


module("AtkCityScene", package.seeall)

require "Script/Main/CountryWar/AtkCitySceneLogic"
require "Script/Common/TimeManager"
require "Script/Main/CountryWar/AtkCityAvatarLayer"
require "Script/Main/CountryWar/AtkCityResultLayer"
--变量
local n_curHeadIndex = 0
local m_pSceneUI = nil 
--local tableBtn= {"撤退","突进","单挑","强攻","分身"}
local tableBtn= {"撤退","突进","单挑","分身"}
local war_scene_callBack = nil
local nSceneds = 0 
local m_nCityID = nil --城市的ID
local nGZType = nil --进入观战的类型

local m_pMyObject = nil 
local m_pOtherObject = nil 
local nMyCount = 0
local nOtherCount = 0
local bFight = false

local tabMyList = nil --我的队列
local tabOtherList = nil --对方的队列
local isBWin = nil
--local tabCityInfoData = nil 
local tabWJAtk = nil
local nNextAtkPos = 0
local nNextDefencePos = 0
local tabNowFightWJData = nil --现在正在战斗的武将的数据


local pTimeManager = nil 

local bUpdateList = false
local aCount = 0
local dCount = 0
local tabBlood = nil
local bResult = false --到结果结算界面
local bAtkTeam = nil  --是true 攻击方，还是false防守方

local bOpenResult = true --打开结果界面的标识
--local bSingled = false --是否点击了单挑
local bHaveResult = false --是否出了结果
local nBloodTimesAtk = nil  --记录掉血的次数
local nBloodTimesDef = nil

local bGuanZhan = false 
--逻辑
local CheckBHaveBtn = AtkCitySceneLogic.CheckBHaveBtn
local GetWarListPlayer = AtkCitySceneLogic.GetWarListPlayer
local AddWarAction = AtkCitySceneLogic.AddWarAction
local GetTimeAction = AtkCitySceneLogic.GetTimeAction
--local GetBrithAction = AtkCitySceneLogic.GetBrithAction
local GetTimeOneAction = AtkCitySceneLogic.GetTimeOneAction
--local GetCountryImgPathByName = AtkCitySceneLogic.GetCountryImgPathByName
local ToGetWarTCList = ClickCityLogic.ToGetWarTCList
local GetPersonRowAndCol = AtkCitySceneLogic.GetPersonRowAndCol
local InitTeamList = AtkCitySceneLogic.InitTeamList

local CheckIndex = AtkCitySceneLogic.CheckIndex --检测索引
local GetBloodTimes = AtkCitySceneLogic.GetBloodTimes --掉几次血

local CheckBAtk = AtkCitySceneLogic.CheckBAtk
local ExitGuanZhan = AtkCitySceneLogic.ExitGuanZhan

--local CheckNewBufferData = AtkCitySceneLogic.CheckNewBufferData

local DealAddPersonToList = AtkCitySceneLogic.DealAddPersonToList
local GetTimeShowText = AtkCitySceneLogic.GetTimeShowText


local GetResID         = CreateRoleData.GetResID
local CreateAtkWarResultLayer = AtkCityResultLayer.CreateAtkWarResultLayer

--数据
local GetWarTime = AtkCityData.GetWarTime
local GetMyResult   = AtkCityData.GetMyResult
local GetAtkData = AtkCityData.GetAtkData
local GetCurAtkWJ = AtkCityData.GetCurAtkWJ --得到当前打斗的人的数据信息
local GetMyNum = AtkCityData.GetMyNum
local GetEnemyNum = AtkCityData.GetEnemyNum
local GetWJNameByID = AtkCityData.GetWJNameByID
local GetCountryType = AtkCityData.GetCountryType 
local GetCountryArmyNum = AtkCityData.GetCountryArmyNum 
local GetTeamNum = AtkCityData.GetTeamNum
local DeleteFightedDB = AtkCityData.DeleteFightedDB
local GetBloodPercend = AtkCityData.GetBloodPercend
local GetWarCTData   = AtkCityData.GetWarCTData
local DeleteAllBufferData =AtkCityData.DeleteAllBufferData
local GetAllBufferTableDB = AtkCityData.GetAllBufferTableDB
local GetCityNameByCityID = AtkCityData.GetCityNameByCityID
local GetCountryAndNum = AtkCityData.GetCountryAndNum
local GetCountryPathByTag = AtkCityData.GetCountryPathByTag

local GetGeneralHeadIcon  = GeneralBaseData.GetGeneralHeadIcon


--逻辑
local ToShowArmyInfo = AtkCitySceneLogic.ToShowArmyInfo
local GetDamageMy = AtkCitySceneLogic.GetDamageMy
local GetDamageOther = AtkCitySceneLogic.GetDamageOther
local GetFirstBlood = AtkCitySceneLogic.GetFirstBlood
local ToWarFight  = AtkCitySceneLogic.ToWarFight
--local CheckBSub = AtkCitySceneLogic.CheckBSub
--local ToSubAnimation  = AtkCitySceneLogic.ToSubAnimation
local SetWarHeadState = AtkCitySceneLogic.SetWarHeadState
local CheckBHaveWJ = AtkCitySceneLogic.CheckBHaveWJ
--local GetCountryNameByType = AtkCitySceneLogic.GetCountryNameByType
local GetCountryNameByIndex = AtkCitySceneLogic.GetCountryNameByIndex
local ToTellSingleFihgt = AtkCitySceneLogic.ToTellSingleFihgt
local GetTabIndexByType = AtkCitySceneLogic.GetTabIndexByType
local ToAvatar   = AtkCitySceneLogic.ToAvatar
local CoverTeamList = AtkCitySceneLogic.CoverTeamList --补位
local ChangeTeamNum = AtkCitySceneLogic.ChangeTeamNum
local GetTeamNumByTab  = AtkCitySceneLogic.GetTeamNumByTab
local DealRemovePersonOnList = AtkCitySceneLogic.DealRemovePersonOnList
local GetStayHPByTime = AtkCitySceneLogic.GetStayHPByTime

--跳出动画
local PathBrith = "Image/imgres/countrywar/Animation/brith_all_001/brith_all_001.ExportJson"
local BrithName = "brith_all_001"
local TAG_BLOOD = 6000


TAG_SCENE = 1
local MyPos = ccp(418,198)
local OtherPos = ccp(722,198)
local m_pastAtkHP = 0
local m_pastDefHP = 0
local function InitVars()
	m_pSceneUI = nil
	war_scene_callBack = nil
	nSceneds = 0
	m_pMyObject = nil 
	m_pOtherObject = nil
	isBWin = nil
	--tabCityInfoData = nil 
	tabWJAtk = nil
	nNextAtkPos = 0
	nNextDefencePos = 0
	pTimeManager = nil 
	n_curHeadIndex = 0
	tabNowFightWJData = nil 
	bUpdateList = false
	aCount = 0
	dCount = 0
	bFight = false
	tabBlood = nil
	bResult = false
	m_nCityID = nil
	bAtkTeam = false 
	bOpenResult = true
	--bSingled = false
	bHaveResult = false
	bGuanZhan = false
	nBloodTimesAtk = nil
	nBloodTimesDef = nil
	m_pastAtkHP = 0
	m_pastDefHP = 0
end
--是否进入观战
function GetBIntoGuanZhan()
	return bGuanZhan
end
function SetUpdateList(bUpdate)
	bUpdateList = bUpdate
end
function GetAtkCityScene()
	return m_pSceneUI
end
local function GetScorllView()
	local scrollView = tolua.cast(m_pSceneUI:getWidgetByName("ScrollView_city"),"ScrollView")
	return scrollView
end
local function BHideHeadBtn(nHide)
	local panel_btn = tolua.cast(m_pSceneUI:getWidgetByName("Panel_btn"),"Layout")
	panel_btn:setVisible(not nHide)
	for i=1,4 do 
		local btn_i = tolua.cast(m_pSceneUI:getWidgetByName("btn_"..i),"Button")
		btn_i:setTouchEnabled(not nHide)
		btn_i:setVisible(not nHide)
	end
end

local function ShowInfoNoWJ(bShow)
	local label_no_wj = tolua.cast(m_pSceneUI:getWidgetByName("Label_8"),"Label")
	label_no_wj:setVisible(bShow)
end

local function UpdateAtkTeamNum(tabAtkCountry)
	--[[if #tabAtkCountry == 0 then
		for i=1 ,2 do 
			local img_city_my = tolua.cast(m_pSceneUI:getWidgetByName("img_city_red_"..i),"ImageView")
			local label_my = tolua.cast(m_pSceneUI:getWidgetByName("label_num_red_"..i),"Label")
			label_my:setVisible(false)
			img_city_my:setVisible(false)
		end
	end
	if #tabAtkCountry== 1 then
		local img_red_bg = tolua.cast(m_pSceneUI:getWidgetByName("img_bg_red_2"),"ImageView")
		img_red_bg:setVisible(false)
	end]]--
	for i=1 ,#tabAtkCountry do 
		local img_bg_red = tolua.cast(m_pSceneUI:getWidgetByName("img_bg_red_"..i),"ImageView")
		local img_city_my = tolua.cast(m_pSceneUI:getWidgetByName("img_city_red_"..i),"ImageView")
		local label_my = tolua.cast(m_pSceneUI:getWidgetByName("label_num_red_"..i),"Label")
		img_bg_red:setVisible(true)
		label_my:setVisible(true)
		img_city_my:setVisible(true)
		label_my:setText(tabAtkCountry[i][2])
		img_city_my:loadTexture(GetCountryPathByTag(tabAtkCountry[i][1]))
	end
	local nNum = #tabAtkCountry+1
	for i=nNum ,3 do 
		local img_bg_red = tolua.cast(m_pSceneUI:getWidgetByName("img_bg_red_"..i),"ImageView")
		local img_city_my = tolua.cast(m_pSceneUI:getWidgetByName("img_city_red_"..i),"ImageView")
		local label_my = tolua.cast(m_pSceneUI:getWidgetByName("label_num_red_"..i),"Label")
		label_my:setVisible(false)
		img_city_my:setVisible(false)
		img_bg_red:setVisible(false)
	end
	
end
local function UpdateDefenceNum(nDefenceCountry,nDNum)
	local img_country_defence = tolua.cast(m_pSceneUI:getWidgetByName("img_city_blue"),"ImageView")
	local numOther = tolua.cast(m_pSceneUI:getWidgetByName("label_num_blue"),"Label")
	numOther:setText(nDNum)
	img_country_defence:loadTexture(GetCountryPathByTag(nDefenceCountry))
end
local function ChangeHeadInfo(nType)
	
	--始终将最前面一个换成当前的，减掉后面的
	--隐藏掉最后面的一个
	local hide_Panel= tolua.cast(m_pSceneUI:getWidgetByName("Panel_"..n_curHeadIndex),"Layout")
	hide_Panel:setVisible(false)
	
	--将所有的都上移
	table.remove(tabWJAtk,GetTabIndexByType(tabWJAtk,nType))
	
	n_curHeadIndex = n_curHeadIndex +1
	local nCount = 0 
	for k,v in pairs (tabWJAtk) do 
		nCount = nCount +1
		local per_Panel= tolua.cast(m_pSceneUI:getWidgetByName("Panel_"..(4-(k-1))),"Layout")
		per_Panel:setPosition(ccp(per_Panel:getPositionX()-12,per_Panel:getPositionY()))
		--当前的
		local cur_headImg= tolua.cast(m_pSceneUI:getWidgetByName("head_"..(4-(k-1))),"ImageView")
		if cur_headImg~=nil then
			cur_headImg:loadTexture(GetGeneralHeadIcon(v.itemID))
		end
	end
	if nCount == 0 then
		ShowInfoNoWJ(true)
		local panel_btn = tolua.cast(m_pSceneUI:getWidgetByName("Panel_btn"),"Layout")
		panel_btn:setVisible(false)
		BHideHeadBtn(true)
	end
	
end
--需要知道单挑的人的排位，暂时写为，队伍尾的一个消失(当前的)
--[[local function SubPersonAnimation()
	--单挑两边都要
	DealRemovePersonOnList(tabMyList,1)
	DealRemovePersonOnList(tabOtherList,1)
end]]--
--去单挑
local function ToSingled()
	--先去通知服务器去单挑
	local function ToTellOK(nState,list)
		if nState ==1 then
			--设置国战主界面的相应的武将状态为单挑（点击头像则进入pvp场景）
			--bSingled = true
			SetWarHeadState(list[1])
			--下面的头像需要换下一个
			ChangeHeadInfo(list[1])
		else
			TipLayer.createTimeLayer("没有可以单挑的人选",2)
		end
	end
	ToTellSingleFihgt(m_nCityID,ToTellOK)
	
end
--退出
local function ExitAtkScene()
	ExitGuanZhan(nGZType)
	DeleteAllBufferData()
	m_pSceneUI:removeFromParentAndCleanup(true)
	InitVars()
	ChatShowLayer.ShowChatlayer(CountryUILayer.GetControlUI())
	MainScene.GetObserver():DeleteObserverByKey(OBSERVER_REGISTER_TYPE.OBSERVER_REGISTER_ATKSCENE)
end

--去到突进或者撤退
local function ToTuJinCT(nType)
	local function GetTJWJ()
		local tabWJData= GetWarCTData()
		if #tabWJData ==0	then
			if nType ==PlayerState.E_PlayerState_Dart then
				TipLayer.createTimeLayer("没有可突进的队伍",2)
			else
				TipLayer.createTimeLayer("没有可撤退的队伍",2)
			end
		else
			
			if nType ==PlayerState.E_PlayerState_Dart then
				if war_scene_callBack.tujin~=nil then
					war_scene_callBack.tujin(true)
				end
			else
				if war_scene_callBack.chetui~=nil then
					war_scene_callBack.chetui(true)
				end
			end
			ExitAtkScene()
		end
		
	end
	--ToGetWarTCList(nType,CountryWarScene.GetCurWJCityTag(tabCityInfoData.nCityTag),GetTJWJ)
	ToGetWarTCList(nType,CountryWarScene.GetCurWJCityTag(m_nCityID),GetTJWJ)
end

--检测是否有武将回来或者死了l_wjType 0123,
function UpdateHeadWJData(l_wjType,l_cityID)
	--if bSingled == true then
		--print("UpdateHeadWJData")
		if tabWJAtk == nil then
			return 
		end
		local n_wjTypwe = l_wjType +1
		if tonumber(l_cityID) ~= tonumber(m_nCityID) then
			for k,v in pairs(tabWJAtk) do 
				if tonumber(n_wjTypwe) == tonumber(v.Type) then
					ChangeHeadInfo(n_wjTypwe)
				end
			end
		else
			--在这个城市
			local bHave = false
			for k,v in pairs(tabWJAtk) do 
				if tonumber(n_wjTypwe) == tonumber(v.Type) then
					bHave = true
				end
			end
			if bHave ==  false then
				local lTab = CountryWarData.GetTeamTab()
				local new_tab = {}
				for k,v in pairs(lTab) do 
					if tonumber(k) == l_wjType then
						local nTab = {}
						nTab.Type = k
						nTab.itemID = v.TeamRes
						nTab.level = v.TeamLevel
						if tabWJAtk==nil then
							tabWJAtk = {}
						end
						table.insert(tabWJAtk,nTab)
					end
				end
				UpdateWJHead()
			end
		end
	--end
end
local function _Btn_CallBack(tag)
	
	--if tag == 4 or tag ==5 then
	--没有强攻
	if tag == 4 then
		local btn_i = tolua.cast(m_pSceneUI:getWidgetByName("btn_"..tag),"Button")
		btn_i:getChildByTag(TAG_LABEL_BUTTON):removeFromParentAndCleanup(true)
		local label_box = LabelLayer.createStrokeLabel(30,CommonData.g_FONT1,tableBtn[tag],ccp(0,-30),COLOR_Black,ccc3(255,217,7),true,ccp(0,-2),2)
		AddLabelImg(label_box,TAG_LABEL_BUTTON,btn_i)
		if tag ==4 then
			--分身 去到分身选择界面
			ToAvatar(m_pSceneUI,AtkCityAvatarLayer.CreateAvatarLayer(tabWJAtk,m_nCityID))
		end
	else
		if tag == 3 then
			ToSingled()
		end
		if tag == 2 then
			--去突进
			ToTuJinCT(PlayerState.E_PlayerState_Dart)
		end
		if tag ==1 then
			--去撤退
			ToTuJinCT(PlayerState.E_PlayerState_Give_Way)
		end
		--点击的前三个按钮，暂时写为退出界面(从上往下)
		--[[m_pSceneUI:removeFromParentAndCleanup(true)
		if war_scene_callBack~=nil then
			war_scene_callBack(true,tag,tabCityInfoData.nCityTag)
		end
		InitVars()
		
		MainScene.GetObserver():DeleteObserverByKey(OBSERVER_REGISTER_TYPE.OBSERVER_REGISTER_ATKSCENE)]]--
	end
end
local function _CheckBox_CallBack(sender, eventType)
	local CheckBox = tolua.cast(sender, "CheckBox")
	local label_word = CheckBox:getChildByTag(10)
	local tag = CheckBox:getTag()-TAG_GRID_ADD
	if eventType == CheckBoxEventType.selected then
		label_word:removeFromParentAndCleanup(true)
		local label_box = LabelLayer.createStrokeLabel(30,CommonData.g_FONT1,tableBtn[tag],ccp(0,-30),COLOR_Black,ccc3(255,217,7),true,ccp(0,-2),2)
		AddLabelImg(label_box,10,CheckBox)
	elseif eventType == CheckBoxEventType.unselected then
		
	end
end
local function _Img_Army_CallBack(tag,sender)
	--直接拿后台数据
	if sender:getName()== "img_red" then
		ToShowArmyInfo(1,m_pSceneUI,nGZType)
		--AddLabelImg(CreateArmyInfoLayer(1),200,m_pSceneUI)
	else
		ToShowArmyInfo(2,m_pSceneUI,nGZType)
		--
	end
end
local function SetFightFalse(bVisible)
	local btn_fight = tolua.cast(m_pSceneUI:getWidgetByName("btn_fight"),"Button")
	btn_fight:setVisible(bVisible)
	btn_fight:setTouchEnabled(bVisible)
	local time_img = tolua.cast(m_pSceneUI:getWidgetByName("img_time_bg"),"ImageView")
	time_img:setVisible(bVisible)
end
function SetBFight(bCurFight)
	bFight = bCurFight
end
local function SetBtnBack(bClick)
	if m_pSceneUI~=nil then
		local _btn_back = tolua.cast(m_pSceneUI:getWidgetByName("btn_back"),"Button")
		_btn_back:setTouchEnabled(bClick)	
	end
end
local function InToFight()
	bFight = true
	SetBtnBack(false)
	--ToWarFight(pTimeManager,tabCityInfoData.nCityTag)
	SetFightFalse(false)
	bOpenResult = false 
	ToWarFight(pTimeManager,m_nCityID,nGZType)
end

function UpdateWJHead()
	--下面的名字显示
	n_curHeadIndex = 1
	if CheckBHaveWJ(#tabWJAtk)==true then
		--头像
		--print("现在的头像")
		--printTab(tabWJAtk)
		--print("******************")
		--Pause()
		for i=0,#tabWJAtk-1 do 
			local panel_head = tolua.cast(m_pSceneUI:getWidgetByName("Panel_"..(#tabWJAtk-i)),"Layout")
			panel_head:setVisible(true)
			local headImg= tolua.cast(m_pSceneUI:getWidgetByName("head_"..(#tabWJAtk-i)),"ImageView")
			--print("显示的头像："..(#tabWJAtk-i))
			--[[print(#tabWJAtk-i)
			print(i+1)
			Pause()]]--
			headImg:loadTexture(GetGeneralHeadIcon(tabWJAtk[i+1].itemID))
		end
		for i=(#tabWJAtk+1),4 do 
			--print("不显示的："..i)
			--Pause()
			local panel_head = tolua.cast(m_pSceneUI:getWidgetByName("Panel_"..i),"Layout")
			panel_head:setVisible(false)
		end
		ShowInfoNoWJ(false)
		BHideHeadBtn(false)
	else
		for i=1,4 do 
			local panel_head = tolua.cast(m_pSceneUI:getWidgetByName("Panel_"..i),"Layout")
			panel_head:setVisible(false)
		end
		ShowInfoNoWJ(true)
		local panel_btn = tolua.cast(m_pSceneUI:getWidgetByName("Panel_btn"),"Layout")
		panel_btn:setVisible(false)
		BHideHeadBtn(true)
	end
	if nGZType == 2 then
		BHideHeadBtn(true)
	end
end
local function InitBtn()
	
	local panel_btn = tolua.cast(m_pSceneUI:getWidgetByName("Panel_btn"),"Layout")
	--添加适配
	panel_btn:setPosition(ccp(panel_btn:getPositionX()-CommonData.g_Origin.x,panel_btn:getPositionY()))
	if CheckBHaveBtn(nGZType) == false then
		panel_btn:setVisible(false)
		BHideHeadBtn(false)
	else
		for i=1,4 do 
			local btn_i = tolua.cast(m_pSceneUI:getWidgetByName("btn_"..i),"Button")
			btn_i:setTag(TAG_GRID_ADD+i)
			CreateBtnCallBack( btn_i,tableBtn[i],30,_Btn_CallBack,COLOR_Black,COLOR_White,i,nil )
			btn_i:getChildByTag(TAG_LABEL_BUTTON):setPosition(ccp(0,-30))
		end
	end
	
	--战斗信息的button
	local img_red_army = tolua.cast(m_pSceneUI:getWidgetByName("img_red"),"ImageView")
	--print(CommonData.g_Origin.x)
	img_red_army:setPosition(ccp(img_red_army:getPositionX()+CommonData.g_Origin.x,img_red_army:getPositionY()))
	img_red_army:setTouchEnabled(true)
	CreateItemCallBack(img_red_army,true,_Img_Army_CallBack,nil)
	local img_blue_army = tolua.cast(m_pSceneUI:getWidgetByName("img_blue"),"ImageView")
	img_blue_army:setTouchEnabled(true)
	img_blue_army:setPosition(ccp(img_blue_army:getPositionX()-CommonData.g_Origin.x,img_blue_army:getPositionY()))
	CreateItemCallBack(img_blue_army,true,_Img_Army_CallBack,nil)
	
	--进入战斗按钮
	local btn_fight = tolua.cast(m_pSceneUI:getWidgetByName("btn_fight"),"Button")
	
	CreateBtnCallBack( btn_fight,nil,nil,InToFight,nil,nil,nil,nil )
	
	
	UpdateWJHead()
	
	
end
local function ShowTitle()
	--标题
	local img_title = tolua.cast(m_pSceneUI:getWidgetByName("img_title"),"ImageView")
	local lable_title = LabelLayer.createStrokeLabel(60,CommonData.g_FONT1,"世界攻城战",ccp(0,28),ccc3(126,14,12),ccc3(255,235,151),true,ccp(0,-2),2)
	AddLabelImg(lable_title,1,img_title)
	--地点
	local lable_pos = tolua.cast(m_pSceneUI:getWidgetByName("label_name_city"),"Label")
	--[[if tabCityInfoData.sName~=nil then
		lable_pos:setText("地点："..tabCityInfoData.sName)
	end]]--
	lable_pos:setText("地点："..GetCityNameByCityID(m_nCityID))
	--local img_atk = tolua.cast(m_pSceneUI:getWidgetByName("img_red"),"ImageView")
	--local img_defence = tolua.cast(m_pSceneUI:getWidgetByName("img_blue"),"ImageView")
	--攻守方
	local tabAtkNum ,nDCountry,nDeNum= GetCountryAndNum()
	--防守方
	local img_city_other = tolua.cast(m_pSceneUI:getWidgetByName("img_city_blue"),"ImageView")
	--左边永远是攻，右边永远是守
	--label_other:setText(nDeNum)
	local l_country  = CountryWarData.GetPlayerCountry()
	if tabAtkNum==nil then
		local function GetData()
			local tabAtkNum ,nDCountry,nDeNum= GetCountryAndNum()
			if tabAtkNum~=nil then
				img_city_other:stopAllActions()
				if tonumber(nDCountry) == tonumber(l_country) then
					bAtkTeam = false
				else
					bAtkTeam = true
				end
				UpdateAtkTeamNum(tabAtkNum)
				UpdateDefenceNum(nDCountry,nDeNum)
			end
		end
		local actionArray = CCArray:create()
		actionArray:addObject(CCDelayTime:create(0.01))
		actionArray:addObject(CCCallFuncN:create(GetData))
		img_city_other:runAction(CCSequence:create(actionArray))
	else
		if tonumber(nDCountry) == tonumber(l_country) then
			bAtkTeam = false
		else
			bAtkTeam = true
		end
		UpdateAtkTeamNum(tabAtkNum)
		UpdateDefenceNum(nDCountry,nDeNum)
	end
	
	
	
end
local function SetBlood(nType,nHurt)
	local bar_blood = tolua.cast(tabBlood[nType],"LoadingBar")
	local now_percent = bar_blood:getPercent()
	local nCurPercent = now_percent-GetBloodPercend(nHurt,tabNowFightWJData[nType].nTotalHP)
	if nCurPercent<0 then
		nCurPercent = 0
	end
	bar_blood:setPercent(nCurPercent)
end
local function SetLastBloodPercent(nType)
	
	local bar_blood = tolua.cast(tabBlood[nType],"LoadingBar")
	if bar_blood==nil then
		return 
	end
	local now_percent = bar_blood:getPercent()
	if tabNowFightWJData==nil then
		return 
	end
	local nCurPercent = GetBloodPercend(tabNowFightWJData[nType].nCurHP,tabNowFightWJData[nType].nTotalHP)
	if nCurPercent<0 then
		nCurPercent = 0
	end
	bar_blood:setPercent(nCurPercent)
end
local function ChangeMyAction()
	--掉血tabNowFightWJData[1].nHPConsume/nSceneds,
	m_pMyObject:AddBloodEffect(GetDamageMy(tonumber(tabNowFightWJData[1].nHPConsume)-m_pastAtkHP),GetScorllView())
	if nBloodTimesAtk~=nil then
		nBloodTimesAtk = nBloodTimesAtk+1
		--print("nBloodTimesAtk:"..nBloodTimesAtk)
		--print("GetBloodTimes():"..GetBloodTimes())
		if nBloodTimesAtk == GetBloodTimes() then
			SetLastBloodPercent(1)
		else
			SetBlood(1,GetDamageMy(tonumber(tabNowFightWJData[1].nHPConsume)-m_pastAtkHP))
		end
	end
	
	
	nMyCount = nMyCount +1
	if nMyCount == 1 then
		m_pMyObject:playSkill(m_pOtherObject:GetAnimate())
	end
	if nMyCount == 2 then
		m_pMyObject:playManualSkill(m_pOtherObject:GetAnimate())
	end
	if nMyCount == 3 then
		m_pMyObject:playAttack(m_pOtherObject:GetAnimate())
	end
	if nMyCount==3 then
		nMyCount = 0
	end
end
local function ChangeOtherAction()
	local n_HP = tonumber(tabNowFightWJData[2].nHPConsume)
	m_pOtherObject:AddBloodEffect(GetDamageOther(n_HP-m_pastDefHP),GetScorllView())
	if nBloodTimesDef~=nil then
		nBloodTimesDef = nBloodTimesDef+1
		if nBloodTimesDef == GetBloodTimes() then
			
			SetLastBloodPercent(2)
		else
			SetBlood(2,GetDamageOther(n_HP-m_pastDefHP))
		end
	end
	
	nOtherCount = nOtherCount +1
	if nOtherCount == 1 then
		m_pOtherObject:playSkill(m_pMyObject:GetAnimate())
	end
	if nOtherCount == 2 then
		m_pOtherObject:playManualSkill(m_pMyObject:GetAnimate())
	end
	if nOtherCount == 3 then
		m_pOtherObject:playAttack(m_pMyObject:GetAnimate())
	end
	if nOtherCount==3 then
		nOtherCount = 0
	end
end
local function RunMyFirstAction()

	--print("RunMyFirstAction")
	m_pMyObject:GetAnimate():stopAllActions()
	if tabNowFightWJData== nil then
		return 
	end
	--[[print("RunMyFirstAction")
	print(GetDamageMy(tabNowFightWJData[1].nHPConsume))
	print("end RunMyFirstAction")]]--
	--m_pMyObject:AddBloodEffect(GetDamageMy(tabNowFightWJData[1].nHPConsume),GetScorllView())
	local n_hp = tonumber(tabNowFightWJData[1].nHPConsume) - m_pastAtkHP
	m_pMyObject:AddBloodEffect(GetFirstBlood(n_hp),GetScorllView())
	--SetBlood(1,GetDamageMy(tabNowFightWJData[1].nHPConsume))
	SetBlood(1,GetFirstBlood(n_hp))
	if nBloodTimesAtk~=nil then
		nBloodTimesAtk = 1
	end
	m_pMyObject:playAttack(m_pOtherObject:GetAnimate())
	m_pMyObject:GetAnimate():runAction(GetTimeAction(3,ChangeMyAction))
end
local function RunOtherFirstAction()
	--print("RunOtherFirstAction")
	--Pause()
	m_pOtherObject:GetAnimate():stopAllActions()
	if tabNowFightWJData== nil then
		--Pause()
		return 
	end
	if nBloodTimesDef~=nil then
		nBloodTimesDef = 1
	end
	local n_hp = tonumber(tabNowFightWJData[2].nHPConsume) - m_pastDefHP
	--m_pOtherObject:AddBloodEffect(GetDamageOther(tabNowFightWJData[2].nHPConsume),GetScorllView())
	m_pOtherObject:AddBloodEffect(GetFirstBlood(n_hp),GetScorllView())
	--SetBlood(2,GetDamageOther(tabNowFightWJData[2].nHPConsume))
	SetBlood(2,GetFirstBlood(n_hp))
	m_pOtherObject:playAttack(m_pOtherObject:GetAnimate())
	m_pOtherObject:GetAnimate():runAction(GetTimeAction(3,ChangeOtherAction))
end

local function CreateWJIconWideget( pAtkTemp )
    local pCloneAtk = pAtkTemp:clone()
    local peer = tolua.getpeer(pAtkTemp)
    tolua.setpeer(pCloneAtk, peer)
    return pCloneAtk
end
local function AddWJIcon(tabWJId)
	local pAtkInfo = GUIReader:shareReader():widgetFromJsonFile("Image/AteCityInfo.json")
	tabBlood = {}
	for i=1,2 do 
		local pClone = CreateWJIconWideget(pAtkInfo)
		local img_bg = tolua.cast(pClone:getChildByName("img_city_info"),"ImageView")
		local label_name = tolua.cast(img_bg:getChildByName("label_name"),"Label")
		label_name:setText(tabWJId[i].strName)
		local label_lv = tolua.cast(img_bg:getChildByName("label_lv"),"Label")
		--[[if i==1 then
			label_lv:setText("【"..GetCountryNameByType(tabCityInfoData.sCounty).."】Lv:"..tabWJId[i].nLv)
		else
			label_lv:setText("【"..GetCountryNameByType(tabCityInfoData.sEnemyCounty).."】Lv:"..tabWJId[i].nLv)
		end]]--
		label_lv:setText("【"..GetCountryNameByIndex(tabWJId[i].nCountry).."】Lv:"..tabWJId[i].nLv)
		if i==1 then
			pClone:setPosition(ccp(m_pMyObject:GetAnimate():getPositionX()-60,m_pMyObject:GetAnimate():getPositionY()+170))
		else
			pClone:setPosition(ccp(m_pOtherObject:GetAnimate():getPositionX()-60,m_pOtherObject:GetAnimate():getPositionY()+170))
		end
		local img_barBG = tolua.cast(pClone:getChildByName("img_bar_bg"),"ImageView")
		local bar_blood = tolua.cast(img_barBG:getChildByName("bar_blood"),"LoadingBar")
		local nCurHP = tabWJId[i].nCurHP
		--printTab(tabWJId)
		local nConsumeHP = tabWJId[i].nHPConsume
		--一开始的血量应该是当前血量加上消耗血量 减掉这场战斗已经打的血量
		if i==1 then
			m_pastAtkHP = GetStayHPByTime(tonumber(nConsumeHP))
			--print(m_pastAtkHP)
		else
			m_pastDefHP = GetStayHPByTime(tonumber(nConsumeHP))
			--print(m_pastDefHP)
		end
		--Pause()
		local nHP = tonumber(nCurHP)+tonumber(nConsumeHP)-GetStayHPByTime(tonumber(nConsumeHP))
		table.insert(tabBlood,bar_blood)
		--print("*******************************:"..i)
		--print(nCurHP,nConsumeHP,tabWJId[i].nTotalHP)
		--Pause()
		--if tonumber(nCurHP) ~=0 then
			if i==1 then
				nBloodTimesAtk = 0
			else
				nBloodTimesDef = 0
			end
		--end
		bar_blood:setPercent(GetBloodPercend(nHP,tabWJId[i].nTotalHP))
		AddLabelImg(pClone,TAG_BLOOD+i,GetScorllView())
	end 
	
end
local function ShowActionNow(tabData,l_atk_ID,l_defence_ID)
	--从数据中得到当前正在打斗的两个人
	--Show
	--[[ShowActionAtk()
	ShowActionDefence()]]--

	local tabWjWar = tabData
	if tabWjWar ==nil then
		return 
	end
	if l_atk_ID ~=nil then
		if l_atk_ID~= tonumber(tabWjWar[1].nImageID) then
			--说明变身了
			if m_pMyObject~=nil then
				m_pMyObject:Destroy()
				m_pMyObject = nil 
			end
		end
	end
	if l_defence_ID ~=nil then
		if l_defence_ID~= tonumber(tabWjWar[2].nImageID) then
			--说明变身了
			if m_pOtherObject~=nil then
				m_pOtherObject:Destroy()
				m_pOtherObject = nil 
			end
		end
	end
	if m_pMyObject==nil then
		m_pMyObject = UIEffectManager.CreateUIEffectObj()
		m_pMyObject:Create(tonumber(tabWjWar[1].nImageID),false,GetScorllView())
		m_pMyObject:GetAnimate():setPosition(MyPos)
		m_pMyObject:GetAnimate():setZOrder(3001)
	end
	if m_pOtherObject == nil then
		m_pOtherObject = UIEffectManager.CreateUIEffectObj()
		m_pOtherObject:Create(tonumber(tabWjWar[2].nImageID),true,GetScorllView())
		m_pOtherObject:GetAnimate():setPosition(OtherPos)
		m_pOtherObject:GetAnimate():setZOrder(3000)
	end

	
	--m_pMyObject:playAttack(m_pOtherObject:GetAnimate())
	--m_pMyObject:playManualSkill(m_pOtherObject:GetAnimate())
	m_pMyObject:GetAnimate():runAction(GetTimeOneAction(2,RunMyFirstAction))
	--m_pOtherObject:playAttack(m_pMyObject:GetAnimate())
	m_pOtherObject:GetAnimate():runAction(GetTimeOneAction(2,RunOtherFirstAction))
	AddWJIcon( tabWjWar )
end

--攻方的列表
--[[local function ShowMySide(nNumMy)
	
	if tabMyList~=nil then
		--大于12个人列表不做变化
		if nNumMy>=12 then 
			return 
		end
	end
	aCount = 0
	if tabMyList~=nil then
		for key,value in pairs(tabMyList) do 
			for key1,value1 in pairs(value) do 
				local pPlayerAtk = tolua.cast(value1,"CCArmature")
				if pPlayerAtk~=nil then
					pPlayerAtk:removeFromParentAndCleanup(true)
					pPlayerAtk = nil
				end
			end
		end
	end
	tabMyList = {}
	--将数据分成三排保存
	for i=1,3 do 
		tabMyList[i] = {}
	end
	for i=1,4 do 
		local tabNum = {}
		for j=1,3 do 
			aCount = aCount +1
			
			if aCount>nNumMy then
				return 
			end
			local pWarPlayerAtk = GetWarListPlayer("ren0"..j.."_stand")
			if GetScorllView():getNodeByTag(1000+aCount)~= nil then
				GetScorllView():removeNodeByTag(1000+aCount)
			end
			pWarPlayerAtk:setPosition(ccp(233-(j-1)*23-(i-1)*125,365-(j-1)*98))
			GetScorllView():addNode(pWarPlayerAtk,1000+aCount,1000+aCount)
			
			
			table.insert(tabMyList[j],pWarPlayerAtk)
		end
	end
	
end]]--
--守方的列表
--[[local function ShowOtherSide(nNumOther)
	
	if tabOtherList~=nil then
		--大于12个人列表不做变化
		if nNumOther>=12 and #tabOtherList== 12  then 
			return 
		end
	end
	dCount = 0 
	if tabOtherList~=nil then
		for key,value in pairs(tabOtherList) do 
			for key1,value1 in pairs(value) do 
				local pPlayerD = tolua.cast(value1,"CCArmature")
				if pPlayerD~=nil then
					pPlayerD:removeFromParentAndCleanup(true)
					pPlayerD = nil
				end
			end
		end
	end
	tabOtherList = {}
	--讲数据分成三排保存
	for i=1,3 do 
		tabOtherList[i] = {}
	end
	for i=1,4 do 
		for j=1,3 do 
			dCount = dCount+1
			if dCount>nNumOther then
				return 
			end
			local pWarPlayerDefence = GetWarListPlayer("ren0"..j.."_stand")
			if GetScorllView():getNodeByTag(2000+dCount)~= nil then
				GetScorllView():removeNodeByTag(2000+dCount)
			end
			pWarPlayerDefence:setScaleX(-1.0)
			pWarPlayerDefence:setPosition(ccp(911+(j-1)*23+(i-1)*125,365-(j-1)*98))
			GetScorllView():addNode(pWarPlayerDefence,2000+dCount,2000+dCount)
			
			table.insert(tabOtherList[j],pWarPlayerDefence)
		end
	end
	
end]]--
--战队列表
--[[local function ShowWarList(nNumMyTeam,nNumEnemyTeam)
	--攻方列表(左边)
	ShowMySide(nNumMyTeam)
	--守方的列表（右边）
	ShowOtherSide(nNumEnemyTeam)
	
end]]--
--初始化战队列表
local function InitWarList(nAtkTeamNum,nDefenceTeamNum)
	tabMyList = InitTeamList(tabMyList,nAtkTeamNum,true,GetScorllView())
	tabOtherList = InitTeamList(tabOtherList,nDefenceTeamNum,false,GetScorllView())
end


--下一组开始
local function RunActionEnd()
	SetFightFalse(true)
	if isBWin == false then
		m_pMyObject:GetAnimate():setVisible(true)
		if GetScorllView():getChildByTag(TAG_BLOOD+1)~= nil then
			GetScorllView():getChildByTag(TAG_BLOOD+1):setVisible(true)
		end
	else
		m_pOtherObject:GetAnimate():setVisible(true)
	
		if GetScorllView():getChildByTag(TAG_BLOOD+2)~= nil then
			GetScorllView():getChildByTag(TAG_BLOOD+2):setVisible(true)
		end	
	end
	ShowTime()
end
local function MyListRun(nIndex)
	if MyListRun==nil then
		return 
	end
	if tabMyList== nil then 
		return 
	end
	local runMyTab = tabMyList[nIndex]
	if #runMyTab == 0 then
		if GetTeamNumByTab(tabMyList)>0 then
			for i=1,#tabMyList do 
				if #tabMyList[i]>0 then
					nIndex = i
					runMyTab = tabMyList[i]
				end
			end
		end
	end
	local removePlayer = tolua.cast(runMyTab[1],"CCArmature")
	if runMyTab[#runMyTab]== nil then
		return 
	end
	--记录最后一个的位置
	local posX = runMyTab[#runMyTab]:getPositionX()
	local posY = runMyTab[#runMyTab]:getPositionY()
	local col = nIndex --记录列数
	if nIndex>3 then
		print("出错")
		printTab(runMyTab)
		print(GetMyNum())
		--Pause()
		return 
	end
	if removePlayer~=nil then
		removePlayer:setVisible(false)
		removePlayer:removeFromParentAndCleanup(true)
		--print("删掉runMyTab1")
		table.remove(runMyTab,1)
	end
	for key,value in pairs(runMyTab) do 
		value:setPosition(ccp(value:getPositionX()+125,value:getPositionY()))
		value:getAnimation():play("ren0"..nIndex.."_run")
		local function onMovementEvent(armatureBack,movementType,movementID)
			if movementType == 1 then
				value:getAnimation():play("ren0"..nIndex.."_stand")
				if key == #runMyTab then
					if GetMyNum()>=12  then
						--print("增加攻击人员")
						--CoverTeamList(col,#runMyTab+1,posX,posY,tabMyList,true,GetScorllView())
					end
				end
			end
			
		end
		value:getAnimation():setMovementEventCallFunc(onMovementEvent)
	end
	--[[print("攻方修改之后")
	printTab(tabMyList)
	print("攻方修改之后")]]--
end
local function OtherListRun(nIndex)	
	--[[print("OtherListRun")
	print(nIndex)]]--
	if tabOtherList==nil then
		--Pause()
		return 
	end
	local runOtherTab = tabOtherList[nIndex]
	if #runOtherTab == 0 then
		if GetTeamNumByTab(tabOtherList)>0 then
			for i=1,#tabOtherList do 
				if #tabOtherList[i]>0 then
					nIndex = i
					runOtherTab = tabOtherList[i]
				end
			end
		end
	end
	local col  = nIndex
	if runOtherTab[#runOtherTab]== nil then
		return 
	end
	local posX = runOtherTab[#runOtherTab]:getPositionX()
	local posY = runOtherTab[#runOtherTab]:getPositionY()
	if nIndex>3 then
		printTab(runOtherTab)
		print(nIndex)
		print(GetEnemyNum())
		--Pause()
		--print("出错")
		return 
	end
	if runOtherTab==nil then
		print("没有人了。。。。")
		return 
	end
	if runOtherTab~=nil then
		if runOtherTab[1]~=nil then
			runOtherTab[1]:removeFromParentAndCleanup(true)
			table.remove(runOtherTab,1)
			for key,value in pairs(runOtherTab) do 
				value:setPosition(ccp(value:getPositionX()-125,value:getPositionY()))
				value:getAnimation():play("ren01_run")
				local function onMovementEvent(armatureBack,movementType,movementID)
					if movementType == 1 then
						value:getAnimation():play("ren0"..nIndex.."_stand")
						if key == #runOtherTab then
							if GetEnemyNum()>=12  then
								--CoverTeamList(col,#runOtherTab+1,posX,posY,tabOtherList,false,GetScorllView())
							end
						end
					end
					
				end
				value:getAnimation():setMovementEventCallFunc(onMovementEvent)
			end
		end
		
	end
	--[[print("守方修改之后")
	printTab(tabOtherList)
	print("守方修改之后")]]--
end
local function ToResult( )
	--print("ToResult")
	bHaveResult = true 
	--print(bOpenResult)
	if bOpenResult == true then
		--print("结果")
		AddLabelImg(CreateAtkWarResultLayer(1),1,m_pSceneUI)
	end
end
function SetOpenResult()
	--print("SetOpenResult")
	SetBtnBack(true)
	bOpenResult = true
	CommonData.g_CountryWarLayer:setVisible(true)
	if bHaveResult == true  then
		ToResult()
	end
end
local function BloodVisible(bVisible,nTag)
	if GetScorllView():getChildByTag(TAG_BLOOD+nTag)~= nil then
		GetScorllView():getChildByTag(TAG_BLOOD+nTag):setVisible(bVisible)
	end
end
local function CheckList()
	if isBWin == true then
		if #tabOtherList[nNextDefencePos]==0 and dCount~=0 then
			for key,value in pairs(tabOtherList) do 
				if #value~=0 then
					nNextDefencePos = key
				end
			end
		end
	else
		if #tabMyList[nNextAtkPos]==0 and aCount~=0 then
			for key,value in pairs(tabMyList) do 
				if #value~=0 then
					nNextAtkPos = key
				end
			end
		end
	end
end
local function GetAtkNumByTitle()
	local nANum = 0
	local img_read_1 = tolua.cast(m_pSceneUI:getWidgetByName("img_bg_red_1"),"ImageView")
	if img_read_1:isVisible() == true then
		local label_1 = tolua.cast(m_pSceneUI:getWidgetByName("label_num_red_1"),"Label")
		nANum = tonumber(label_1:getStringValue())
	end
	local img_read_2 = tolua.cast(m_pSceneUI:getWidgetByName("img_bg_red_2"),"ImageView")
	if img_read_2:isVisible() == true then
		local label_2 = tolua.cast(m_pSceneUI:getWidgetByName("label_num_red_2"),"Label")
		nANum = nANum + tonumber(label_2:getStringValue())
	end
	return nANum
end
local function GetDefenceNumByTitle()
	local label_blue = tolua.cast(m_pSceneUI:getWidgetByName("label_num_blue"),"Label")
	return tonumber(label_blue:getStringValue())
end
local function WinAndLoseAction()
	--播放完动作以后输的一方后面队列发生变化重新跳出一组
	--监测是否满足打斗的条件，
	--重新请求以后刷新列表
	--武将列表的数量只用来变化队列
	nBloodTimesAtk = nil 
	nBloodTimesDef = nil 
	if isBWin == true then
		--说明攻方胜利
		nNextDefencePos = nNextDefencePos +1
		
	else
		nNextAtkPos = nNextAtkPos + 1
	end
	
	if nNextDefencePos>3 then
		nNextDefencePos = 1
	end
	if nNextAtkPos>3 then
		nNextAtkPos = 1
	end
	--删除已经用掉的数据
	local l_org_atk_ID = tonumber(tabNowFightWJData[1].nImageID)
	local l_org_defence_ID = tonumber(tabNowFightWJData[2].nImageID)
	
	DeleteFightedDB()
	local nANum = GetAtkNumByTitle()
	local nDNum = GetDefenceNumByTitle()
	if CheckBAtk(nANum,nDNum,isBWin)== true then
		--得到下一组数据
		
		tabNowFightWJData = GetCurAtkWJ()
		
		local function StartNextWar()
			tabNowFightWJData = GetCurAtkWJ()
			if tabNowFightWJData == nil then
				return 
			else
				m_pSceneUI:stopAllActions()
			end
			
			if isBWin == false then
				--如果我输掉了，那么攻击方的列表要发生变化
				--[[print("********攻击方*********")
				printTab(tabMyList)
				print("********攻击方**********")]]--
				nNextAtkPos = CheckIndex(nNextAtkPos,tabMyList)
				MyListRun(nNextAtkPos)
			else
				--[[print("******防守方***********")
				printTab(tabOtherList)
				print("********防守方***********")]]--
				nNextDefencePos = CheckIndex(nNextDefencePos,tabOtherList)
				OtherListRun(nNextDefencePos)
			end
			ChangeTeamNum(tabMyList,GetMyNum(),true,GetScorllView())
			ChangeTeamNum(tabOtherList,GetEnemyNum(),false,GetScorllView())
			--跳出来的动画
			local stringActionName = nil
			if nNextAtkPos == 1 or nNextDefencePos == 1 then
				stringActionName = "Animation6"
			end
			if nNextAtkPos == 2 or nNextDefencePos == 2 then
				stringActionName = "Animation5"
			end
			if nNextAtkPos == 3 or nNextDefencePos == 3 then
				stringActionName = "Animation7"
			end
			--先创建动画
			ShowActionNow(tabNowFightWJData,l_org_atk_ID,l_org_defence_ID)
			if isBWin == false then
				m_pMyObject:GetAnimate():setVisible(false)
				BloodVisible(false,1)
				m_pMyObject:PlayEffect(PathBrith,BrithName,stringActionName,false,RunActionEnd)
			else
				m_pOtherObject:GetAnimate():setVisible(false)
				BloodVisible(false,2)
				m_pOtherObject:PlayEffect(PathBrith,BrithName,stringActionName,true,RunActionEnd)
			end
		end
		if tabNowFightWJData == nil then
			m_pSceneUI:runAction(CCRepeatForever:create(GetTimeAction(0.001,StartNextWar)))
		else
			StartNextWar()
		end
		
	end
	
end
local function DeleteBloodByTag(nTag)
	--删除血条
	if GetScorllView():getChildByTag(TAG_BLOOD+nTag)~= nil then
		GetScorllView():getChildByTag(TAG_BLOOD+nTag):removeFromParentAndCleanup(true)
	end
end

--攻击方处理胜利和失败的结果
local function AtkDealResult()
	
	--[[print("AtkDealResult")
	printTab(tabMyList)]]--
	if isBWin== false then
		--说明我失败了
		--对象执行跳出效果 20160307修改为不跳出
		--m_pMyObject:PlayEffect(PathBrith,BrithName,"Animation4",true,WinAndLoseAction)
		m_pMyObject:Destroy()
		m_pMyObject = nil 
		--删除血条
		DeleteBloodByTag(1)
		WinAndLoseAction()
		
	end
end
--防守方对对战结果的处理
local function DefenceDealResult()
	if isBWin== true then
		--说明防守失败了
		--对象执行跳出效果20160307修改为不跳出
		--m_pOtherObject:PlayEffect(PathBrith,BrithName,"Animation4",true,WinAndLoseAction)
		m_pOtherObject:Destroy()
		m_pOtherObject = nil
		--删除血条
		DeleteBloodByTag(2)
		WinAndLoseAction()
		
	end
	--[[if isBWin == false then
		m_pOtherObject:GetAnimate():stopAllActions()
	end]]--
end

local function DealStopActions()
	if isBWin== false then 
		--说明我失败了
		if m_pOtherObject~=nil then
			m_pOtherObject:GetAnimate():stopAllActions()
		end
	else
		if m_pMyObject~=nil then
			m_pMyObject:GetAnimate():stopAllActions()
		end
	end
	
	
end
--胜利者消失修改为胜利者呼吸待机等待下一个对手
local function WinnerStaty()
	--isBWin false说明我失败了 重新跳出一对数据
	--print("WinnerStaty")
	if bResult == true then	
		DealStopActions()
		bHaveResult = true
		ToResult()
		bResult = false 
		return 
	end
	if bResult == false then
		local nANum = GetAtkNumByTitle()
		local nDNum = GetDefenceNumByTitle()
		if CheckBAtk(nANum,nDNum,isBWin)== false then
			DealStopActions()
			ToResult()
			bHaveResult = true
			bResult = false 
			return
		end
		
	end
	
	
	
end
function CloseAtkCityScene()
	if m_pSceneUI~=nil then
		--退出去的时候要把缓存的数据清理掉
		ExitGuanZhan(nGZType)
		DeleteAllBufferData()
		if war_scene_callBack.guanzhan~=nil then
			--Pause()
			war_scene_callBack.guanzhan(true)
		end
		m_pSceneUI:removeFromParentAndCleanup(true)
		
		InitVars()
		ChatShowLayer.ShowChatlayer(CountryUILayer.GetControlUI())
		MainScene.GetObserver():DeleteObserverByKey(OBSERVER_REGISTER_TYPE.OBSERVER_REGISTER_ATKSCENE)
	end
end
local function DealDied()
	AtkDealResult()
	DefenceDealResult()
	nMyCount = 0 
	nOtherCount = 0

end

--胜利或者死亡
local function PlayWinAndLose()
	--得到之前的
	--Ani_die
	--[[print("PlayWinAndLose")
	printTab(tabMyList)]]--
	if m_pMyObject== nil then
		return 
	end
	if m_pOtherObject==nil then
		return 
	end
	m_pMyObject:GetAnimate():stopAllActions()
	m_pOtherObject:GetAnimate():stopAllActions()
	if GetMyResult()==0 then
		--说明我失败了
		isBWin = false
		m_pMyObject:playAnimation(GetAniName_Res_ID(GetResID(tabNowFightWJData[1].nImageID),Ani_Def_Key.Ani_die),DealDied)
		m_pOtherObject:playAnimation(GetAniName_Res_ID(GetResID(tabNowFightWJData[2].nImageID),Ani_Def_Key.Ani_cheers))
		m_pOtherObject:GetAnimate():runAction(GetTimeAction(4,WinnerStaty))
		
	else
		--说明我胜利
		isBWin = true
		m_pMyObject:playAnimation(GetAniName_Res_ID(GetResID(tabNowFightWJData[1].nImageID),Ani_Def_Key.Ani_cheers))
		m_pOtherObject:playAnimation(GetAniName_Res_ID(GetResID(tabNowFightWJData[2].nImageID),Ani_Def_Key.Ani_die),DealDied)
		
		m_pMyObject:GetAnimate():runAction(GetTimeAction(4,WinnerStaty))
		
		
	end
end
--时间到了以后的处理
local function DealTimeOut()
	--播放死亡和胜利动画
	PlayWinAndLose()
	
end

local function FlushWarTime()
	local label_time = tolua.cast(m_pSceneUI:getWidgetByName("label_time"),"Label")
	if nSceneds == 0 then
		--战斗不可见
		SetFightFalse(false)
		label_time:stopAllActions()
		--播死亡胜利动画，队列转换
		DealTimeOut()
		return 
	end
	nSceneds = nSceneds-1
	label_time:setText(GetTimeShowText(nSceneds))
end
function ShowTime()
	nSceneds = GetWarTime()
	
	local label_time = tolua.cast(m_pSceneUI:getWidgetByName("label_time"),"Label")
	--label_time:setText("00:"..nSceneds)
	label_time:setText(GetTimeShowText(nSceneds))
	label_time:runAction(GetTimeAction(1,FlushWarTime))
end


local function ShowWJInfo()
	tabNowFightWJData = GetCurAtkWJ()
	--[[printTab(tabNowFightWJData)
	Pause()]]--
	ShowActionNow(tabNowFightWJData)
	--ShowWarList(GetMyNum(),GetEnemyNum())
	InitWarList(GetMyNum(),GetEnemyNum())
end
local function GetResult()
	--说明城池的战斗结束 判断最后一场是否结束，如果没有直接播死亡动作
	
	if nSceneds>2 then
		nSceneds = 2
	end
	--到结果结算界面
	bResult = true
	--[[print("到结算")
	Pause()]]--
	ToResult()
	--[[if aCount == 0 or dCount ==0 then
		ToResult()
	end]]--
	
end
local function InitUI()
	--GetAtkData()--调用一下模拟得到数据
	Packet_GetCountryWarResult.SetSuccessCallBack(GetResult)
	local Img_Name_Bg= tolua.cast(m_pSceneUI:getWidgetByName("img_name_bg"),"ImageView")
	Img_Name_Bg:setPosition(ccp(Img_Name_Bg:getPositionX()-CommonData.g_Origin.x,Img_Name_Bg:getPositionY()))
	InitBtn()
	ShowTitle()
	ShowWJInfo()
	ShowTime()
end
local function _Btn_Back_CallBack()
	--ExitGuanZhan(nGZType)
	CloseAtkCityScene()
end
local function DeleteOrgPerson()
	if m_pMyObject ==nil or m_pOtherObject ==nil then
		return 
	end
	m_pMyObject:Destroy()
	m_pMyObject = nil
	--删除血条
	DeleteBloodByTag(1)
	m_pOtherObject:Destroy()
	m_pOtherObject = nil
	--删除血条
	DeleteBloodByTag(2)
end
--直接播死亡等待下一组的数据
local function DealBufferDataDied(tableNowData)
	local bAtkWin = tableNowData[1].nWin 
	SetLastBloodPercent(1)
	SetLastBloodPercent(2)
	DeleteFightedDB()
	--直接播死亡的动画
	DeleteOrgPerson()
	tabNowFightWJData = GetCurAtkWJ()
	
	
	nNextAtkPos = 0
	nNextDefencePos= 0
	ShowActionNow(tabNowFightWJData)
	
	nSceneds = tableNowData[1].statyTime
	ShowTime()
	if nSceneds == 0 then
		SetFightFalse(false)
	end
end
--直接播下一场缓存的数据
local function DealBufferDataNext(tableBData)
	local bAtkWin = tableBData[1].nWin 
	SetLastBloodPercent(1)
	SetLastBloodPercent(2)
	--DeleteFightedDB()
	--直接播死亡的动画
	DeleteOrgPerson()
	--tabNowFightWJData = tableBData[#tableBData]
	nNextAtkPos = 0
	nNextDefencePos= 0
	ShowActionNow(tabNowFightWJData)
	
	nSceneds = tableBData[1].statyTime
	ShowTime()
	if nSceneds == 0 then
		SetFightFalse(false)
	end
end
local function UpdateAtkScene()
	if m_pSceneUI~=nil then
		if bFight == true then
			bFight = false
			SetBtnBack(true)
			nSceneds = pTimeManager:GetStayTime(nSceneds)
			
			--判断缓存数据，如果是两组那么，看最新一组的时间
			local tab = GetAllBufferTableDB()
			if #tab >= 2 then
				
				--if nStayBufferTime==0 then
					DealBufferDataDied(tab)
				--else
					--DealBufferDataNext(tab)
				--end
			else
				local label_time = tolua.cast(m_pSceneUI:getWidgetByName("label_time"),"Label")
				label_time:setText("00:"..nSceneds)
				if nSceneds == 0 then
					--直接播死亡的动画
					SetLastBloodPercent(1)
					SetLastBloodPercent(2)
					label_time:stopAllActions()
					--播死亡胜利动画，队列转换
					DealTimeOut()
					SetFightFalse(false)
				end
			end
		end
	end
end


--更新攻守方的数量信息，左上角以及右上角的，实时更新，和实际的左右两边的队列更新无关
function UpdateTeamNum(tabAtk,nDefenceCountry,nDefenceNum)
	if m_pSceneUI== nil then
		return 
	end
	if #tabAtk ~= 0 then	
		--Pause()
		UpdateAtkTeamNum(tabAtk)
	else
		for i=1 ,2 do 
			local img_city_my = tolua.cast(m_pSceneUI:getWidgetByName("img_city_red_"..i),"ImageView")
			local label_my = tolua.cast(m_pSceneUI:getWidgetByName("label_num_red_"..i),"Label")
			if label_my:isVisible() == true then
				label_my:setText(0)
			end
		end
	end
	UpdateDefenceNum(nDefenceCountry,nDefenceNum)
end

--观战的类型 nGType 1,观战，2迷雾战
function CreateAtkCity(fCallBack,nCityID,nGType,l_tabWJData)
	InitVars()
	
	m_pSceneUI = TouchGroup:create()
	m_pSceneUI:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/AtkCityWarScene.json" ) )
	--tabCityInfoData = tabData
	bGuanZhan = true --用来标识观战界面已经开启
	m_nCityID = nCityID
	tabWJAtk = l_tabWJData
	nGZType = nGType
	war_scene_callBack =  fCallBack
	pTimeManager = TimeManager.CreateTimeManager()

	MainScene.GetObserver():RegisterObserver(OBSERVER_REGISTER_TYPE.OBSERVER_REGISTER_ATKSCENE,UpdateAtkScene)
	--得到ScrollView
	local scrollView = tolua.cast(m_pSceneUI:getWidgetByName("ScrollView_city"),"ScrollView")
	
	--挂接场景
	local scene_node  = SceneReader:sharedSceneReader():createNodeWithSceneFile("publish/Scene_guozhan01.json")--CCScene:create()	
	if scrollView:getNodeByTag(1000)~= nil then
		scrollView:removeNodeByTag(1000)
	end
	scene_node:setPosition(ccp(-285,0))
	scrollView:addNode(scene_node,1000,1000)

	ChatShowLayer.ShowChatlayer(m_pSceneUI)
	
	scrollView:ignoreAnchorPointForPosition(true)
    scrollView:setPosition(ccp(0,0))
	scrollView:setBounceEnabled(true)
	InitUI()
	--返回按钮
	
	local _btn_back = tolua.cast(m_pSceneUI:getWidgetByName("btn_back"),"Button")
	_btn_back:setPosition(ccp(_btn_back:getPositionX()-CommonData.g_Origin.x,_btn_back:getPositionY()))
	CreateBtnCallBack( _btn_back,nil,nil,_Btn_Back_CallBack,nil,nil,nil,nil )
	return m_pSceneUI
end