
--玩家设置形象界面 celina


module("UserSettingChangeImage", package.seeall)

--变量

local m_layer_changeImage = nil 
local m_org_select_ID = nil
local m_actionObject = nil 
local m_imgSelectIcon = nil
--数据
local GetUserID         = UserSettingData.GetUserID
local GetUserHeadID  = UserSettingData.GetUserHeadID
--逻辑
local GetUserActionByID = UserSettingLogic.GetUserActionByID
local AddWJHeadIcon     = UserSettingLogic.AddWJHeadIcon
local GetImageData_layer = UserSettingLogic.GetImageData
local AddWJHeadIcon_layer  = UserSettingLogic.AddWJHeadIcon
local GetGerneralRow_layer = UserSettingLogic.GetGerneralRow
local GetScrollViewHeight  = UserSettingLogic.GetScrollViewHeight
local ToSaveImage = UserSettingLogic.ToSaveImage

local function InitVars()
	m_layer_changeImage = nil
	m_org_select_ID = nil
	m_actionObject = nil 
	m_imgSelectIcon = nil
end

local function _Btn_Close_CallBack()
	m_layer_changeImage:removeFromParentAndCleanup(true)
	InitVars()
	UserSettingLayer.UpdateImage()
end
local function _Btn_Save_Image_CallBack()
	ToSaveImage(m_org_select_ID,GetUserHeadID())
end
local function AddActionImage(nTempID)
	--local nTempID = GetGerneralTempID(nGrid)
	local panel_right = tolua.cast(m_layer_changeImage:getWidgetByName("Panel_right_image"),"Layout")
	if m_actionObject~=nil then
		m_actionObject:removeFromParentAndCleanup(true)
	end
	m_actionObject = GetUserActionByID(nTempID)
	m_actionObject:setPosition(ccp(130,30))
	m_org_select_ID = nTempID
	m_actionObject:setScale(2.0)
	panel_right:addNode(m_actionObject,TAG_GRID_ADD,TAG_GRID_ADD)
end
local function ShowRightImage()
	if tonumber(GetUserID()) == 0 then
		AddActionImage(80011)
	else
		AddActionImage(GetUserID())
	end
	--Btn
	local _bant_save_image = tolua.cast(m_layer_changeImage:getWidgetByName("btn_save_image"),"Button")
	CreateBtnCallBack(_bant_save_image,"保存形象",36,_Btn_Save_Image_CallBack,nil,nil,nil,nil)
end
local function AddSelectIcon(nTempID)
	local scrollview = tolua.cast(m_layer_changeImage:getWidgetByName("ScrollView_image"),"ScrollView")
	scrollview:setClippingType(1)
	local img_select = scrollview:getChildByTag(TAG_GRID_ADD+tonumber(nTempID))
	local posX = img_select:getPositionX()
	local posY = img_select:getPositionY()
	if m_imgSelectIcon == nil then
		m_imgSelectIcon = ImageView:create()
		m_imgSelectIcon:setScale(0.68)
		m_imgSelectIcon:loadTexture("Image/imgres/item/selected_icon.png")
		m_imgSelectIcon:setPosition(ccp(posX,posY))
		scrollview:addChild(m_imgSelectIcon,0,TAG_GRID_ADD+tonumber(nTempID))
	else
		m_imgSelectIcon:setPosition(ccp(posX,posY))
	end
end
local function _Image_Select_CallBack(headID)
	AddSelectIcon(headID)
	if tonumber(m_org_select_ID)~= tonumber(headID) then
		
		AddActionImage(headID)
	end
end
local function ShowSelectImage()
	--标题
	local img_wen = tolua.cast(m_layer_changeImage:getWidgetByName("img_wen_image"),"ImageView")
	local label_title = LabelLayer.createStrokeLabel(24,CommonData.g_FONT1,"请选择要设置的玩家形象",ccp(0,2),COLOR_Black,COLOR_White,true,ccp(0,-2),2)
	label_title:setPosition(ccp(-130,20))
	AddLabelImg(label_title,1,img_wen)
	--添加可选择的形象的头像
	local m_scrollview = tolua.cast(m_layer_changeImage:getWidgetByName("ScrollView_image"),"ScrollView")
	local tabSelectHead = GetImageData_layer()
	local height = m_scrollview:getInnerContainerSize().height
	m_scrollview:setClippingType(1)
	local nRow = GetGerneralRow_layer(table.getn(tabSelectHead),4)
	--一屏显示三行左右,
	local height = GetScrollViewHeight(nRow)
	m_scrollview:setInnerContainerSize(CCSize(390,height))
	AddWJHeadIcon_layer(m_scrollview,tabSelectHead,50,height-60,_Image_Select_CallBack,4,false)
end
local function ShowUI()
	--左边的可选择的形象
	ShowSelectImage()
	--右边的选中的形象展示
	ShowRightImage()
end

function ShowChangeImageLayer()
	InitVars()
	m_layer_changeImage =  TouchGroup:create()
	m_layer_changeImage:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/UserSettingChangeImage.json" ) )
	
	
	ShowUI()
	local btn_close = tolua.cast(m_layer_changeImage:getWidgetByName("btn_close"),"Button")
	CreateBtnCallBack(btn_close,nil,nil,_Btn_Close_CallBack,nil,nil,nil,nil)
	return m_layer_changeImage

end