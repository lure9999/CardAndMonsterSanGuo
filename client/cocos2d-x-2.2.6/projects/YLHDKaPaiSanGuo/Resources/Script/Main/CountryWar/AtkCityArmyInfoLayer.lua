--攻城战战队信息的的UI celina


module("AtkCityArmyInfoLayer", package.seeall)


--变量
local m_armyInfoLayer  = nil 
local n_type_cur = 0
local n_curPage = 0 
local n_type_war = 0
--数据
local GetListTabData = AtkCityData.GetListTabData
local GetTeamNum     = AtkCityData.GetTeamNum
local GetCurListPageNum = AtkCityData.GetCurListPageNum
local GetColorByType = AtkCityData.GetColorByType



local function InitVars()
	m_armyInfoLayer = nil
	n_type_cur = 0
	n_type_war = 0
end
local function GetCloneInfo()
	local mCloneInfo = GUIReader:shareReader():widgetFromJsonFile("Image/InfoItem.json")
	local new_Info = mCloneInfo:clone()
	local peer = tolua.getpeer(mCloneInfo)
	tolua.setpeer(new_Info,peer)
	return new_Info 
end
local function InitListViewInfo(listView,tabTeamInfo)
	for i=0,#tabTeamInfo-1 do
		local infoItem = GetCloneInfo()
		local img_info_bg = tolua.cast(infoItem:getChildByName("img_item_bg"),"ImageView")
		local label_Order = tolua.cast(img_info_bg:getChildByName("lable_num"),"Label")
		label_Order:setText(tostring(i+1)*n_curPage)
		local label_lv = tolua.cast(img_info_bg:getChildByName("lable_lv"),"Label")
		label_lv:setText("Lv:"..tabTeamInfo[i+1].lv)
		local label_teamName = tolua.cast(img_info_bg:getChildByName("lable_name"),"Label")
		label_teamName:setText(tabTeamInfo[i+1].nameTeam)
		local label_ownName = tolua.cast(img_info_bg:getChildByName("lable_name_own"),"Label")
		label_ownName:setText(tabTeamInfo[i+1].nameSelf)
		label_ownName:setColor(GetColorByType(tabTeamInfo[i+1].nType))
		local label_state = tolua.cast(img_info_bg:getChildByName("lable_state"),"Label")
		label_state:setText(AtkCitySceneLogic.GetStateStr(tabTeamInfo[i+1].state))
		listView:pushBackCustomItem(infoItem)
	end
end
local function _Panel_Army_CallBack()
	--MainScene.GetObserver():DeleteObserverByKey(OBSERVER_REGISTER_TYPE.OBSERVER_REGISTER_ATKSCENE_ARMYINFO)
	m_armyInfoLayer:removeFromParentAndCleanup(true)
	InitVars()
	
end

local function _Img_PageL_CallBack()
	--等于一不再左翻页
	if n_curPage == 1 then
		return 
	end
	local function UpdateListL()
		n_curPage = GetCurListPageNum()
		UpdateArmyInfo()
	end
	--请求下一页的数据
	AtkCitySceneLogic.ToGetNextPageData(n_type_war,n_type_cur,n_curPage-1,UpdateListL)
end

local function _Img_PageR_CallBack()
	if n_curPage == tonumber(AtkCitySceneLogic.GetPageTotal(GetTeamNum())) then
		return 
	end
	local function UpdateListR()
		n_curPage = GetCurListPageNum()
		UpdateArmyInfo()
	end
	--请求下一页的数据
	AtkCitySceneLogic.ToGetNextPageData(n_type_war,n_type_cur,n_curPage+1,UpdateListR)
end

local function InitUI(nType)
	local label_title = tolua.cast(m_armyInfoLayer:getWidgetByName("label_title"),"Label")
	local img_bg = tolua.cast(m_armyInfoLayer:getWidgetByName("img_bg_atk"),"ImageView") --红蓝条
	local img_icon = tolua.cast(m_armyInfoLayer:getWidgetByName("img_atk_icon"),"ImageView") --攻守方的标志
	if nType==TEAM_TYPE.TEAM_TYPE_ATK then
		label_title:setText("攻方兵力")
		img_bg:loadTexture("Image/imgres/countrywar/war_atk_bg.png")
		img_icon:loadTexture("Image/imgres/countrywar/war_atk_icon.png")
	else
		label_title:setText("守方兵力")
		img_bg:loadTexture("Image/imgres/countrywar/war_defense_bg.png")
		img_icon:loadTexture("Image/imgres/countrywar/war_defense_icon.png")
	end
	local tabArmyInfoData = GetListTabData()
	--队伍的数量
	local lable_aryNum = tolua.cast(m_armyInfoLayer:getWidgetByName("label_num"),"Label")
	lable_aryNum:setText(GetTeamNum())
	
	--页数
	local lable_page = tolua.cast(m_armyInfoLayer:getWidgetByName("Label_page"),"Label")
	--一开始肯定是第一页
	lable_page:setText(n_curPage.."/"..AtkCitySceneLogic.GetPageTotal(GetTeamNum()))
	
	local listView_army = tolua.cast(m_armyInfoLayer:getWidgetByName("listview_war"),"ListView")
	listView_army:setClippingType(1)
	listView_army:setItemsMargin(6)
	InitListViewInfo(listView_army,tabArmyInfoData)
	local Panel_info = tolua.cast(m_armyInfoLayer:getWidgetByName("Panel_war_info"),"Layout")
	Panel_info:setTouchEnabled(true)
	CreateItemCallBack(Panel_info,false,_Panel_Army_CallBack,nil)
	
	local pageL = tolua.cast(m_armyInfoLayer:getWidgetByName("img_page_l"),"ImageView")
	local pageR = tolua.cast(m_armyInfoLayer:getWidgetByName("img_page_r"),"ImageView")
	pageL:setTouchEnabled(true)
	pageR:setTouchEnabled(true)
	
	CreateItemCallBack(pageL,false,_Img_PageL_CallBack,nil)
	CreateItemCallBack(pageR,false,_Img_PageR_CallBack,nil)
end

function UpdateArmyInfo()
	if n_type_cur==0 then
		return 
	end
	if m_armyInfoLayer == nil then
		return 
	end
	local listView_army = tolua.cast(m_armyInfoLayer:getWidgetByName("listview_war"),"ListView")
	listView_army:removeAllItems()
	InitUI(n_type_cur)
end
--1表示攻击方
--2表示防守方
--nWarType表示普通观战还是迷雾观战
function CreateArmyInfoLayer(nType,nWarType)
	InitVars()
	n_type_cur = nType
	n_type_war = nWarType
	n_curPage = 1
	m_armyInfoLayer = TouchGroup:create()
	m_armyInfoLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/AtkCityWarInfoLayer.json" ) )
	--MainScene.GetObserver():RegisterObserver(OBSERVER_REGISTER_TYPE.OBSERVER_REGISTER_ATKSCENE_ARMYINFO,UpdateArmyInfo)
	InitUI(nType)
	
	return m_armyInfoLayer
end