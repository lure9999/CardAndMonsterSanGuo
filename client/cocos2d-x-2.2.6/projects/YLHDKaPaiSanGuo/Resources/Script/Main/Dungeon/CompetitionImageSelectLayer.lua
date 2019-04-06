


module("CompetitionImageSelectLayer", package.seeall)

require "Script/Main/Wujiang/GeneralBaseData"
--变量
local m_imgSelectLayer = nil 
local m_imgSelectIcon = nil 
local m_org_select_ID = nil
local m_actionObject = nil 
--数据
local GetImageData = CompetitionLogic.GetImageData
local GetGerneralTempID = CompetitionData.GetGerneralTempID
local GetGeneralHeadIcon  = GeneralBaseData.GetGeneralHeadIcon
local GetRank           = CompetitionData.GetRank
local GetLevel          = CompetitionData.GetLevel
local GetPower          = CompetitionData.GetPower
local GetRoleID         = CompetitionData.GetRoleID
local GetGridGerneral   = CompetitionData.GetGridGerneral
--逻辑
local GetGerneralRow = CompetitionLogic.GetGerneralRow
local GetGerneralCol = CompetitionLogic.GetGerneralCol
local GetImageActionByID = CompetitionLogic.GetImageActionByID
local GetActionScale   = CompetitionLogic.GetActionScale  --获得动作的放大倍数
local ToSaveImage      = CompetitionLogic.ToSaveImage
--返回按钮
local function _Btn_Back_CallBack()
	m_imgSelectLayer:removeFromParentAndCleanup(true)
end

local function AddActionImage(nTempID)
	--local nTempID = GetGerneralTempID(nGrid)
	if m_actionObject~=nil then
		m_actionObject:removeFromParentAndCleanup(true)
	end
	m_actionObject = GetImageActionByID(nTempID)
	m_actionObject:setPosition(ccp(780,295))
	m_org_select_ID = nTempID
	m_actionObject:setScale(GetActionScale(nTempID))
	m_imgSelectLayer:addChild(m_actionObject,TAG_GRID_ADD,TAG_GRID_ADD)
end

local function AddSelectIcon(nTempID)
	local scrollview = tolua.cast(m_imgSelectLayer:getWidgetByName("ScrollView_choose"),"ScrollView")
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
local function _Btn_Icon_Gerneral_CallBack(nTempID,sender)
	
	AddSelectIcon(nTempID)
	if tonumber(m_org_select_ID)~= tonumber(nTempID) then
		
		AddActionImage(nTempID)
	end
end
local function InitGerneralImage(tableData,nIndex,nRow,nCol)
	--scrollview
	local scrollview = tolua.cast(m_imgSelectLayer:getWidgetByName("ScrollView_choose"),"ScrollView")
	local m_size_view = scrollview:getInnerContainerSize()
	scrollview:setClippingType(1)
	local tempID = tableData[nIndex].tempID
	local img_gerneral_bg = ImageView:create()
	--img_gerneral_bg:setTag(TAG_GRID_ADD+tonumber(m_gird))
	img_gerneral_bg:setPosition(ccp(42+(nCol-1)*97,m_size_view.height-60-(nRow-1)*99))
	img_gerneral_bg:setScale(0.68)
	--底
	local img_bg = ImageView:create()
	img_bg:loadTexture("Image/imgres/common/bottom.png")
	img_gerneral_bg:addChild(img_bg)
	--品质框
	local img_color_b = ImageView:create()
	img_color_b:loadTexture("Image/imgres/common/color/wj_pz1.png")
	img_gerneral_bg:addChild(img_color_b)
	--头像
	local img_head = ImageView:create()
	img_head:setPosition(ccp(6,17))
	img_head:loadTexture(GetGeneralHeadIcon(tempID))
	img_gerneral_bg:addChild(img_head)
	img_color_b:setTouchEnabled(true)
	img_color_b:setTag(TAG_GRID_ADD+tonumber(tempID))
	
	CreateItemCallBack(img_color_b,false,_Btn_Icon_Gerneral_CallBack,nil)
	
	scrollview:addChild(img_gerneral_bg,0,TAG_GRID_ADD+tonumber(tempID))
end

local function ShowGerneralsImage(tableGerneral)
	
	local nRow = GetGerneralRow(table.getn(tableGerneral))
	local nCol = GetGerneralCol(table.getn(tableGerneral))
	
	for i=1, nRow-1 do 
		for j=1,nCol do 
			InitGerneralImage(tableGerneral,4*i+j-4,i,j,0)
		end
	end
	if nRow>2 then
		if table.getn(tableGerneral)%4 ~= 0 then
			for i=1,table.getn(tableGerneral)%4 do 
				InitGerneralImage(tableGerneral,(nRow-1)*4+0+i,nRow,i,0)
			end
		end
	end
end
local function _Btn_Save_Image_CallBack()
	--ToSaveImage(m_org_select_ID)
end
local function ShowRightUI()
	local lableRank  = tolua.cast(m_imgSelectLayer:getWidgetByName("Label_rank"),"Label")
	lableRank:setText("排名："..GetRank())
	local lableLevel = tolua.cast(m_imgSelectLayer:getWidgetByName("Label_lv"),"Label")
	lableLevel:setText(GetLevel())
	local lableFight = tolua.cast(m_imgSelectLayer:getWidgetByName("Label_num_zdl"),"Label")
	lableFight:setText(GetPower())

	if tonumber(GetRoleID()) == 0 then
		AddActionImage(80011)
	else
		AddActionImage(GetRoleID())
	end
	
	
	--Btn
	local _bant_save_image = tolua.cast(m_imgSelectLayer:getWidgetByName("btn_save_image"),"Button")
	CreateBtnCallBack(_bant_save_image,"保存形象",36,_Btn_Save_Image_CallBack,nil,nil,nil,nil)
end
local function ShowUI()
	--得到可以设置形象的数据
	local lableTips = tolua.cast(m_imgSelectLayer:getWidgetByName("Label_none"),"Label")
	if table.getn(GetImageData()) == 0 then
		lableTips:setVisible(true)
	else
		lableTips:setVisible(false)
		ShowGerneralsImage(GetImageData())
		
	end
	--右边的形象80011
	ShowRightUI()
end
local function InitVars()
	m_imgSelectLayer = nil 
	m_imgSelectIcon  = nil 
	m_org_select_ID = nil
	m_actionObject = nil
end
function CreateCompetitionImageSelect()
	InitVars()
	m_imgSelectLayer =  TouchGroup:create()
	m_imgSelectLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/CompeteLayer_ChooseImage.json" ) )
	
	ShowUI()
	--返回按钮
	local _btn_back  = tolua.cast(m_imgSelectLayer:getWidgetByName("btn_close_choose"),"Button")
	CreateBtnCallBack(_btn_back,nil,nil,_Btn_Back_CallBack,nil,nil,nil,nil)
	return m_imgSelectLayer
end