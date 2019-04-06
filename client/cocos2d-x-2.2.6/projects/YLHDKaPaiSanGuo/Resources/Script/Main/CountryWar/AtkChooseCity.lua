--选择突进或者撤退的城池 celina


module("AtkChooseCity", package.seeall)


local pChooseCityLayer = nil 

local tabWJData = nil 
local tabReturnData = nil
--数据
local GetGeneralHeadIcon  = GeneralBaseData.GetGeneralHeadIcon
local GetWarCTData   = AtkCityData.GetWarCTData
--逻辑
local UpdateTabData = AtkCitySceneLogic.UpdateTabData

local function InitVars()
	pChooseCityLayer = nil 
	tabWJData = nil
	tabReturnData = nil
end
local function _Img_Head_CallBack(nTag,sender)
	local nIndex = 0
	for k,v in pairs(tabWJData) do 
		if tonumber(v.Type) == tonumber(nTag) then
			nIndex = tonumber(k)
		end
	end
	local img_select = tolua.cast(pChooseCityLayer:getWidgetByName("img_select_"..nIndex),"ImageView")
	img_select:setVisible(not img_select:isVisible())
	tabReturnData = UpdateTabData(img_select:isVisible(),nTag,tabReturnData)
end

function GetChooseWJ()
	return tabReturnData
end
local function InitUI(nTag)
	local lable_info_city = tolua.cast(pChooseCityLayer:getWidgetByName("Label_info"),"Label")
	if nTag ~= CityEventState.E_CityEventState_Retreat then
		--撤退
		lable_info_city:setText("请选择突进城市")
		lable_info_city:setColor(ccc3(226,55,9))
	end
	for key,value in pairs(tabWJData) do 
		local img_headBg = tolua.cast(pChooseCityLayer:getWidgetByName("img_head_"..key),"ImageView")
		local img_head = tolua.cast(pChooseCityLayer:getWidgetByName("head_"..key),"ImageView")
		img_head:loadTexture(GetGeneralHeadIcon(CountryWarData.GetTeamRes(value.Type)))
		img_headBg:setTouchEnabled(true)
		img_headBg:setTag(TAG_GRID_ADD+value.Type)
		CreateItemCallBack(img_headBg,false,_Img_Head_CallBack)
	end
	for i=0,4-#tabWJData-1 do 
		local img_head_bg = tolua.cast(pChooseCityLayer:getWidgetByName("img_head_"..(4-i)),"ImageView")
		img_head_bg:setVisible(false)
	end
	
end
local function _Btn_Cancel_CallBack()
	CountryWarScene.RemoveAtkChooseLayer()
end


function ChooseAtkCity(nTag)
	
	InitVars()
	tabWJData = GetWarCTData()
	tabReturnData = GetWarCTData()
	if #tabWJData==0 then
		if tonumber(nTag) ==CityEventState.E_CityEventState_Retreat then
			TipLayer.createTimeLayer("没有可撤退的队伍",2)
		else
			TipLayer.createTimeLayer("没有可突进的队伍",2)
		end
		return nil
	end
	pChooseCityLayer = TouchGroup:create()
	pChooseCityLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/ChooseWJLayer.json" ) )
	
	InitUI(nTag)
	--取消
	local btn_cancel = tolua.cast(pChooseCityLayer:getWidgetByName("btn_cancel"),"Button")
	CreateBtnCallBack( btn_cancel,"取消",20,_Btn_Cancel_CallBack,ccc3(83,28,2),ccc3(255,245,126),nil,nil,"微软雅黑" )
	return pChooseCityLayer
end