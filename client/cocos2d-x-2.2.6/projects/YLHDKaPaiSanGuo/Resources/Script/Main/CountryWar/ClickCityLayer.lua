
--点击城市，呼出界面 celina


module("ClickCityLayer", package.seeall)
require "Script/Main/CountryWar/AtkCityData"
require "Script/Main/CountryWar/ClickCityLogic"
require "Script/Main/CountryWar/AtkCityScene"


--变量
local m_layer_clickCity = nil 
local tabInfoData = nil 
local tab_CallBack = nil 
local tabWJImg = nil
local tabWordBtnName= nil 
local tabCountryName = {"魏","蜀","吴"}
--逻辑
local GetActionBG = ClickCityLogic.GetActionBG
local GetActionBtn = ClickCityLogic.GetActionBtn
local GetWJPosTabByNum = ClickCityLogic.GetWJPosTabByNum
local GetCityAction = ClickCityLogic.GetCityAction
local ToGuanZhan = ClickCityLogic.ToGuanZhan
local SetBtnState = ClickCityLogic.SetBtnState
local ToGetFightInfoData = ClickCityLogic.ToGetFightInfoData
local ToGetWarTCList = ClickCityLogic.ToGetWarTCList
local GetSelf = ClickCityLogic.GetSelf
--数据
local GetCityArmyData = AtkCityData.GetCityArmyData
local GetCityState    = CountryWarData.GetCityState

 function InitVars()
	m_layer_clickCity = nil 
	--tabInfoData = nil 
	--tab_CallBack = nil 
	--tabWJImg  = nil
	--tabWordBtnName = nil 
	
end
function InitStartVars()
	m_layer_clickCity = nil 
	tabInfoData = nil 
	tab_CallBack = nil 
	tabWJImg  = nil
	tabWordBtnName = nil 
end
local function _Btn_GZ_CallBack()

	local function ShowWarCity()
		if tab_CallBack.guanzhan~=nil then
			local tabWJ = tab_CallBack.guanzhan(false,nil,tabInfoData.nCityTag)
			--到观战场景
			if AtkCityScene.GetAtkCityScene()== nil then
				AddLabelImg(AtkCityScene.CreateAtkCity(tab_CallBack,tabInfoData.nCityTag,1,tabWJ),layerAtkWar_Tag,CountryWarScene.GetCountryMapPanel())
			end
		end
	
	end
	ToGuanZhan(tabInfoData.nCityTag,ShowWarCity)
	
	
end
local function _Btn_ZJ_CallBack()
	if tab_CallBack.zhaoji~=nil then
		tab_CallBack.zhaoji()
	end
end
local function _Btn_JS_CallBack()
	--坚守
	if tab_CallBack.jianshou~=nil then
		tab_CallBack.jianshou()
	end
end

local function _Btn_XZ_CallBack()
	--血战
	if tab_CallBack.xuezhan~=nil then
		tab_CallBack.xuezhan(tabInfoData.nCityTag)
	end
end
local function UpdateTableBtn(tableBtn)
	local btn_gz = tolua.cast(tableBtn[2],"Button")
	--坚守或者血战 
	local btn_js_xz = tolua.cast(tableBtn[3],"Button")
	--突进
	local btn_tj = tolua.cast(tableBtn[4],"Button")
	--撤退
	local btn_ct = tolua.cast(tableBtn[5],"Button")
	
	
	local _btn_guanzhan = tolua.cast(btn_gz:getVirtualRenderer(), "CCSprite")
	local img_gz = tolua.cast(m_layer_clickCity:getWidgetByName("img_gz"),"ImageView")
	local _img_guanzhan = tolua.cast(img_gz:getVirtualRenderer(), "CCSprite")
	if tabInfoData.nState ==COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_PEACE then
		--和平状态的观战修改为显示，但是为灰色
		--SetBtnState(btn_gz,false)
		
		SpriteSetGray(_btn_guanzhan,1)	
		btn_gz:setTouchEnabled(false)
		SpriteSetGray(_img_guanzhan,1)
		if tabInfoData.nSelf == 0 then
			SetBtnState(btn_js_xz,true)
		else
			SetBtnState(btn_js_xz,false)
		end
		if btn_tj~=nil then 
			SetBtnState(btn_tj,false)
		end
		if btn_ct~=nil then
			SetBtnState(btn_ct,false)
		end
	else
		--激战状态
		--SetBtnState(btn_gz,true)
		SpriteSetGray(_btn_guanzhan,0)
		SpriteSetGray(_img_guanzhan,0)
		
		SetBtnState(btn_js_xz,true)
		btn_gz:setTouchEnabled(true)
		if btn_tj~=nil then 
			SetBtnState(btn_tj,true)
		end
		if btn_ct~=nil then
			SetBtnState(btn_ct,true)
		end
	end
	
end
--突进按钮
local function _Btn_TJ_CallBack()
	local function GetTJWJ()
		if tab_CallBack.tujin~=nil then
			tab_CallBack.tujin()
		end
	end
	ToGetWarTCList(PlayerState.E_PlayerState_Dart,CountryWarScene.GetCurWJCityTag(tabInfoData.nCityTag),GetTJWJ)
	
end
--撤退按钮
local function _Btn_CT_CallBack()
	
	local function GetCTWJ()
		if tab_CallBack.chetui~=nil then
			tab_CallBack.chetui()
		end
	end
	ToGetWarTCList(PlayerState.E_PlayerState_Give_Way,CountryWarScene.GetCurWJCityTag(tabInfoData.nCityTag),GetCTWJ)
end
local function GetShowBtnObject()
	--战斗状态的城市才有观战
	local tableBtn = {}
	--召集
	local btn_zj = tolua.cast(m_layer_clickCity:getWidgetByName("btn_zj"),"Button")
	--观战
	local btn_gz = tolua.cast(m_layer_clickCity:getWidgetByName("btn_gz"),"Button")
	
	--坚守
	local btn_js = tolua.cast(m_layer_clickCity:getWidgetByName("btn_js"),"Button")
	--突进
	local btn_tj = tolua.cast(m_layer_clickCity:getWidgetByName("btn_tj"),"Button")
	--撤退
	local btn_ct = tolua.cast(m_layer_clickCity:getWidgetByName("btn_ct"),"Button")
	
	CreateBtnCallBack(btn_gz,nil,nil,_Btn_GZ_CallBack,nil,nil,nil,nil)
	CreateBtnCallBack(btn_zj,nil,nil,_Btn_ZJ_CallBack,nil,nil,nil,nil)
	table.insert(tableBtn,btn_zj)
	table.insert(tableBtn,btn_gz)
	table.insert(tableBtn,btn_js)
	--敌方的都是血战
	if tabInfoData.nSelf == 0 then
		CreateBtnCallBack(btn_js,nil,nil,_Btn_XZ_CallBack,nil,nil)
	else
		--自己方的激战
		if tabInfoData.nState == 2 then
			CreateBtnCallBack(btn_js,nil,nil,_Btn_JS_CallBack,nil,nil)
		end
	end
	
	table.insert(tableBtn,btn_tj)
	table.insert(tableBtn,btn_ct)
	CreateBtnCallBack(btn_tj,nil,nil,_Btn_TJ_CallBack,nil,nil)
	CreateBtnCallBack(btn_ct,nil,nil,_Btn_CT_CallBack,nil,nil)
	UpdateTableBtn(tableBtn)
	return tableBtn
end
--[[local function VSActionEnd()
	local label_my = tolua.cast(m_layer_clickCity:getWidgetByName("label_my_num"),"Label")
	local label_enemy = tolua.cast(m_layer_clickCity:getWidgetByName("label_enemy_num"),"Label")
	label_my:setVisible(true)
	label_enemy:setVisible(true)
end]]--
local function EnemyCityActionEnd()
	--[[local img_vs = tolua.cast(m_layer_clickCity:getWidgetByName("img_vs"),"ImageView")
	img_vs:runAction(GetCityAction(VSActionEnd))]]--
	local label_my = tolua.cast(m_layer_clickCity:getWidgetByName("label_my_num_1"),"Label")
	local label_enemy = tolua.cast(m_layer_clickCity:getWidgetByName("label_enemy_num"),"Label")
	label_my:setVisible(true)
	label_enemy:setVisible(true)
end


local function SetMyCityVisibel(bVisbel)
	if tabInfoData.nState ~= COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_PEACE then
		local tabAtkAData = GetCityArmyData(1)
		if tabAtkAData==nil then
			return 
		end
		local nAtkCityCount = #tabAtkAData
		if nAtkCityCount >3 then
			nAtkCityCount = 3
		end
		for i=1,nAtkCityCount do 
			local label_my = tolua.cast(m_layer_clickCity:getWidgetByName("label_my_num_"..i),"Label")
			local img_my_city = tolua.cast(m_layer_clickCity:getWidgetByName("img_my_city_"..i),"ImageView")
			img_my_city:setVisible(bVisbel)
			if bVisbel== false then
				img_my_city:setScale(0)
			end
			label_my:setVisible(bVisbel)
		end
		for i=nAtkCityCount+1 ,3 do 
			local label_my = tolua.cast(m_layer_clickCity:getWidgetByName("label_my_num_"..i),"Label")
			local img_my_city = tolua.cast(m_layer_clickCity:getWidgetByName("img_my_city_"..i),"ImageView")
			img_my_city:setVisible(false)
			img_my_city:setScale(0)
			label_my:setVisible(false)
		end
	end
end
local function SetEnemyCityVisbel(bVisbel)
	print("SetEnemyCityVisbel")
	local label_enemy = tolua.cast(m_layer_clickCity:getWidgetByName("label_enemy_num"),"Label")
	local img_enemy_city = tolua.cast(m_layer_clickCity:getWidgetByName("img_anemy_city"),"ImageView")
	
	label_enemy:setVisible(bVisbel)
	img_enemy_city:setVisible(bVisbel)
	img_enemy_city:setScale(0)
end
local function RunEnemyAction()
	SetEnemyCityVisbel(true)
	local img_enemy_city = tolua.cast(m_layer_clickCity:getWidgetByName("img_anemy_city"),"ImageView")
	img_enemy_city:runAction(GetCityAction(EnemyCityActionEnd))
end
local function MyCityActionEndThree()
	RunEnemyAction()
end
local function MyCityActionEndTwo()
	local tabAData =  GetCityArmyData(1)
	if #tabAData>2 then
		local img_my_city = tolua.cast(m_layer_clickCity:getWidgetByName("img_my_city_3"),"ImageView")
		img_my_city:runAction(GetCityAction(MyCityActionEndThree))
	else
		RunEnemyAction()
	end
	
	
end

local function MyCityActionEnd()
	if  tabInfoData.nState == 1 then
		RunEnemyAction()
	else
		local tabAData =  GetCityArmyData(1)
		if #tabAData>1 then
			local img_my_city = tolua.cast(m_layer_clickCity:getWidgetByName("img_my_city_2"),"ImageView")
			img_my_city:runAction(GetCityAction(MyCityActionEndTwo))
		else
			RunEnemyAction()
		end
	end
	
end
local function AddWJInfo()
	local img_BG = tolua.cast(m_layer_clickCity:getWidgetByName("img_click_bg"),"ImageView")
	
	for key,value in pairs(tabWJImg) do 
		local img_wj = tolua.cast(value,"ImageView")
		if img_wj == nil then
			return 
		end
		local img_qu = ImageView:create()
		img_qu:loadTexture("Image/imgres/wujiang/wj_up_bg.png")
		img_qu:setPosition(ccp(img_wj:getPositionX()+35,img_wj:getPositionY()-30))
		local strNum = nil 
		if tonumber(tabInfoData.wj[key].Type)==1 then
			strNum = "主"
		else
			strNum = tonumber(tabInfoData.wj[key].Type)-1
		end
		local label_Num = LabelLayer.createStrokeLabel(24,CommonData.g_FONT1,strNum,ccp(0,0),COLOR_Black,COLOR_White,true,ccp(0,-2),2)
		--label_Num:setScale(1.8)
		AddLabelImg(label_Num,key,img_qu)
		AddLabelImg(img_qu,200+key,img_BG)
		
		local label_lv = LabelLayer.createStrokeLabel(20,CommonData.g_FONT1,tabInfoData["wj"][key].level,ccp(-46,-40),COLOR_Black,COLOR_White,false,ccp(0,-2),2)
		label_lv:setPosition(ccp(img_wj:getPositionX()-35,img_wj:getPositionY()-28))
		AddLabelImg(label_lv,1000+key,img_BG)
	end
end
local function BtnActionEnd()
	if tabInfoData.nState ~= 1 then
		SetMyCityVisibel(true)
		local img_my_city = tolua.cast(m_layer_clickCity:getWidgetByName("img_my_city_1"),"ImageView")
		img_my_city:runAction(GetCityAction(MyCityActionEnd))
	end
	
	AddWJInfo()
	
end
local function AddBtnWord(nKey,sender)
	if nKey == 3 then
		--是敌方的无论什么状态都是血战
		--and tabInfoData.nState == COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_PEACE
		if tabInfoData.nSelf == 0   then
			tabWordBtnName[nKey] = "血战"
		
		end
		if tabInfoData.nState == COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_BURN then
			if tabInfoData.nSelf == 1 then
				tabWordBtnName[nKey] = "坚守"
			end
		end
	end
	local label_btn_word = nil
	if nKey == 2 then
		if tabInfoData.nState ==COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_PEACE then
			label_btn_word = LabelLayer.createStrokeLabel(30,CommonData.g_FONT1,tabWordBtnName[nKey],ccp(-27,-35),COLOR_Black,ccc3(128,128,128),false,ccp(0,-3),3)
		else
			label_btn_word = LabelLayer.createStrokeLabel(30,CommonData.g_FONT1,tabWordBtnName[nKey],ccp(-27,-35),COLOR_Black,COLOR_White,false,ccp(0,-3),3)
		end
	else
		label_btn_word = LabelLayer.createStrokeLabel(30,CommonData.g_FONT1,tabWordBtnName[nKey],ccp(-27,-35),COLOR_Black,COLOR_White,false,ccp(0,-3),3)
	end
	AddLabelImg(label_btn_word,10,sender)
end
local function BtnAction()
	local tabBtn = GetShowBtnObject()
	for key,value in pairs(tabBtn) do 
		--添加按钮文字
		AddBtnWord(key,value)
		local btn = tolua.cast(value,"Button")
		btn:setPosition(ccp(111,132))
	end
	for key,value in pairs(tabBtn) do 
		local btn = tolua.cast(value,"Button")
		local pos = ccp(0,0)
		if key==1 then
			pos = ccp(111,132)
		
		elseif key == 2 then
			pos = ccp(-6,75)
		elseif key== 3 then
			pos = ccp(64,4)
		elseif key== 4 then
			pos = ccp(162,4)
		elseif key== 5 then
			pos = ccp(232,75)
		end
		--if key~=3 then
			btn:runAction(CCMoveTo:create(0.2,pos))
		--else
			--btn:runAction(GetActionBtn(pos,BtnActionEnd))
		--end
		
	end
end
local function WJ_CallBack(Type)
	--[[if zj_callBack~=nil then
		zj_callBack(nTempID)
	end]]--
	tab_CallBack.PlayerMove(Type)
end
local function WJAction(bAction)
	local img_BG = tolua.cast(m_layer_clickCity:getWidgetByName("img_click_bg"),"ImageView")
	local tabWJData = tabInfoData.wj
	if tabWJData==nil then
		return 
	end
	local tabPosData = GetWJPosTabByNum(img_BG,table.getn(tabWJData))
	for key,value in pairs(tabWJData) do 
		if value == nil then
			return 
		end
		local img_wj = ImageView:create()
		local pControl = UIInterface.MakeHeadIcon(img_wj,ICONTYPE.HEAD_ICON,value.itemID,nil,nil,nil,nil,value.level)
		pControl:setTag(TAG_GRID_ADD+value.Type)
		CreateItemCallBack(pControl,true,WJ_CallBack,nil)
		if bAction == true then
			img_wj:setPosition(ccp(0,0))
		else
			img_wj:setPosition(tabPosData[key])
		end
		img_wj:setScale(0.68)
		AddLabelImg(img_wj,100+key,img_BG)
		table.insert(tabWJImg,img_wj)
		if bAction == true then
			if key~= table.getn(tabWJData) then
				img_wj:runAction(CCMoveTo:create(0.2,tabPosData[key]))
			else
				img_wj:runAction(GetActionBtn(tabPosData[key],BtnActionEnd))
			end
		end
		
	end
	if bAction == true then
		if #tabWJData == 0 then
			BtnActionEnd()
		end
	end
end
local function VS_Action_End()
	WJAction(true)
	
	
end
local function VSAction()
	local img_vs_bg = tolua.cast(m_layer_clickCity:getWidgetByName("img_country_bg_info"),"ImageView")
	if tabInfoData.nState == COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_PEACE then
		img_vs_bg:setVisible(false)
		WJAction(true)
	else
		img_vs_bg:setVisible(true)
		local tabAtkArmyData = GetCityArmyData(1)
		--左边攻方
		for key,value in pairs(tabAtkArmyData) do 
			local img_my_city = tolua.cast(m_layer_clickCity:getWidgetByName("img_my_city_"..key),"ImageView")
			local nPngIndex = tonumber(value.nCityState)
			img_my_city:setVisible(true)
			if nPngIndex>=5  and nPngIndex<8 then
				nPngIndex = 5
			end
			if nPngIndex>8 then
				nPngIndex =5 
			end
			img_my_city:loadTexture("Image/imgres/common/country/country_"..nPngIndex..".png")
			local lable_num = tolua.cast(m_layer_clickCity:getWidgetByName("label_my_num_"..key),"Label")
			lable_num:setText(value.nCityNum)
		end
		--守方
		local tabDefenceArmyData = GetCityArmyData(2)
		local imgDefenceCity = tolua.cast(m_layer_clickCity:getWidgetByName("img_anemy_city"),"ImageView")
		local nPngDIndex = tonumber(tabDefenceArmyData[1].nCityState)
		if nPngDIndex >= 5 and nPngDIndex<8 then
			nPngDIndex = 5
		end
		if nPngDIndex>8 then
			nPngDIndex =5 
		end
		imgDefenceCity:loadTexture("Image/imgres/common/country/country_"..nPngDIndex..".png")
		local lable_num_defence = tolua.cast(m_layer_clickCity:getWidgetByName("label_enemy_num"),"Label")
		lable_num_defence:setText(tabDefenceArmyData[1].nCityNum)
		
		local img_vs = tolua.cast(m_layer_clickCity:getWidgetByName("img_vs"),"ImageView")
		img_vs:setScale(0)
		img_vs:runAction(GetCityAction(VS_Action_End))
	end
	
end
local function InitUIBaseInfo()
	local label_cityName  = tolua.cast(m_layer_clickCity:getWidgetByName("label_cityName"),"Label")
	if tabInfoData.nSelf == 0 then
		--表示是敌方的城池
		label_cityName:setText("【"..tabCountryName[tabInfoData.sEnemyCounty].."】"..tabInfoData.sName)
	else
		label_cityName:setText("【"..tabCountryName[tabInfoData.sEnemyCounty].."】"..tabInfoData.sName)
	end
	
end
local function InitUI(bUpdate)
	--local PanelWar = tolua.cast(m_layer_clickCity:getWidgetByName("Panel_war"),"Layout")
	--PanelWar:setVisible(false)
	tabWordBtnName = {"召集","观战","坚守","突进","撤退"}
	
	
	--基本信息
	InitUIBaseInfo()
	--武将等的先隐藏
	if bUpdate == false then
		SetMyCityVisibel(false)
		print("1====")
		SetEnemyCityVisbel(false)
		--Pause()
		--背景
		local img_bg = tolua.cast(m_layer_clickCity:getWidgetByName("img_click_bg"),"ImageView")
		img_bg:setScale(0.0)
		img_bg:runAction(GetActionBG())
		BtnAction()
		VSAction()
	else
		SetMyCityVisibel(true)
		SetEnemyCityVisbel(true)
	end
end
local function UpdateWJ(tabWJNow)
	local nWJNum=  #tabWJNow
	for i=1,4 do 
		local img_BG = tolua.cast(m_layer_clickCity:getWidgetByName("img_click_bg"),"ImageView")
		if img_BG:getChildByTag(100+i)~=nil then
			img_BG:getChildByTag(100+i):removeFromParentAndCleanup(true)
		end
		if img_BG:getChildByTag(200+i)~=nil then
			img_BG:getChildByTag(200+i):removeFromParentAndCleanup(true)
		end
		if img_BG:getChildByTag(1000+i)~=nil then
			img_BG:getChildByTag(1000+i):removeFromParentAndCleanup(true)
		end
	end
	WJAction(false)
	AddWJInfo()

end
--点击城市呼出界面，如果此时状态改变，需要更新界面信息
function UpdateCityUI()
	print("UpdateCityUI")
	if m_layer_clickCity~=nil then
		local nCityTag  = tabInfoData.nCityTag
		tabInfoData.nSelf = GetSelf(nCityTag)
		tabInfoData.nState = GetCityState(nCityTag)--状态
		tabInfoData.wj = CountryWarScene.GetWJByCity(nCityTag)
		InitUI(true)
		GetShowBtnObject()
		UpdateWJ(tabInfoData.wj)
	end
end
--tabCityData 城池的数据
--tabCityData.nCityTag 城池的ID
--tabCityData.nSelf = 0,1,城池的所属，0表示敌方，1表示自己
--tabCityData.nState = 1,2 城池的状态，1表示和平，2表示激战
--tabCityData.sName = 城池的名字
--tabCityData.sCounty = 自己所属的国家名称
--tabCityData.sEnemyCounty = 敌方所属的国家名称
--tabCityData.nNumMine = 我方的人数

--tabCityData.nNumEnemy = 敌方的人数
--tabCityData.wj.itemID = 空闲武将的ID
--tabCityData.wj.level = 空闲武将的等级
--tabCityData.wj.Type = 空闲武将的类型
--clickCallBack 召集的回到主城的回调table
function CreateClickCityLayer(tabCityData,clickCallBack)
	InitStartVars()
	m_layer_clickCity = TouchGroup:create()
	m_layer_clickCity:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/ClickCityLayer.json" ) )
	tabInfoData = tabCityData
	tab_CallBack = clickCallBack
	tabWJImg = {}
	InitUI(false)
	return m_layer_clickCity
	
	
end