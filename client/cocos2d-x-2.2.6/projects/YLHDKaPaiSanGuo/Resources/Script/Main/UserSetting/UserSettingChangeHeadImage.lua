
--玩家修改头像界面 celina


module("UserSettingChangeHeadImage", package.seeall)


--变量
local m_layer_changeHeadImage  = nil 
--local m_scrollview   = nil
local IMG_PATH_TITLE = "Image/imgres/equip/title_bg.png"
local IMG_PATH_LINE = "Image/imgres/equip/line_bg.png"
--数据
local GetUserHeadID_layer = UserSettingData.GetUserHeadID
local GetUserSex_layer = UserSettingData.GetUserSex
local GetHeadIDByPart_layer = UserSettingData.GetHeadIDByPart


local GetUniqueHead_layer = UserSettingData.GetUniqueHead  --获得特殊头像（全部先置灰）
local GetUniqueHeadIDByKey = UserSettingData.GetUniqueHeadIDByKey
local GetUniqueHeadCount = UserSettingData.GetUniqueHeadCount
local GetHeadIDByIndex = UserSettingData.GetHeadIDByIndex
local GetHeadData      = UserSettingData.GetHeadData
local GetDesByIndex = UserSettingData.GetDesByIndex
local GetUserID    = UserSettingData.GetUserID
--逻辑
local GetImageData_layer = UserSettingLogic.GetImageData
local AddWJHeadIcon_layer  = UserSettingLogic.AddWJHeadIcon
local GetGerneralRow     = UserSettingLogic.GetGerneralRow
local GetGerneralCol = UserSettingLogic.GetGerneralCol
local ToSaveImage = UserSettingLogic.ToSaveImage

local function InitVars()
	m_layer_changeHeadImage = nil 
	--m_scrollview = nil
end
--通用添加标题
local function AddTitle(strName,img_bg,addTag)
	local label_title = LabelLayer.createStrokeLabel(24,CommonData.g_FONT1,strName,ccp(0,2),COLOR_Black,COLOR_White,true,ccp(0,-2),2)
	AddLabelImg(label_title,addTag,img_bg)
end
local function _Head_CallBack(headID)
	--选中返回
	local function ChangeOK()
		m_layer_changeHeadImage:removeFromParentAndCleanup(true)
		InitVars()
		UserSettingLayer.UpdateImage()
	end
	
	ToSaveImage(GetUserID(),headID,ChangeOK)
	
end
--添加基础头像
local function AddBaseHead(mScrollview)
	--local img_head = tolua.cast(m_layer_changeHeadImage:getWidgetByName("img_head_1"),"ImageView")
	--local pControl = UIInterface.MakeHeadIcon(img_head, ICONTYPE.HEAD_ICON, nil, nil,nil,GetUserHeadID_layer(),nil)
	if tonumber(GetUserSex_layer()) == 1 then
		--表示是男的取前三个
		for i=1,3 do 
			local img_head = tolua.cast(m_layer_changeHeadImage:getWidgetByName("img_head_"..i),"ImageView")
			local pControl = UIInterface.MakeHeadIcon(img_head, ICONTYPE.HEAD_ICON, nil, nil,nil,GetHeadIDByPart_layer("Para_"..i),nil)
			pControl:setTag(TAG_GRID_ADD+tonumber(GetHeadIDByPart_layer("Para_"..i)))
			CreateItemCallBack(pControl,false,_Head_CallBack,nil)
		end
	else
		--表示是女的头像
		for i=4,6 do 
			local img_head = tolua.cast(m_layer_changeHeadImage:getWidgetByName("img_head_"..(i-3)),"ImageView")
			local pControl = UIInterface.MakeHeadIcon(img_head, ICONTYPE.HEAD_ICON, nil, nil,nil,GetHeadIDByPart_layer("Para_"..i),nil)
			pControl:setTag(TAG_GRID_ADD+tonumber(GetHeadIDByPart_layer("Para_"..i)))
			CreateItemCallBack(pControl,false,_Head_CallBack,nil)
		end
	end
end
local function AddWJHead(m_scrollview)
	local tabGerneral = GetImageData_layer()
	AddWJHeadIcon_layer(m_scrollview,tabGerneral,51,715,_Head_CallBack,5,true)
end

local function _Click_Head_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		local p_tag = sender:getTag()
		local p_data = GetHeadData(p_tag)
		local cur_vip = server_mainDB.getMainData("vip")
		local historyTure = server_mainDB.getMainData("historyTour")
		if tonumber(p_data[4]) == 1 then
			if tonumber(p_data[5]) < tonumber(cur_vip) then
				_Head_CallBack(tonumber(GetHeadIDByIndex(p_tag)))
			else
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1645,nil)
				pTips = nil
			end
		else
			if tonumber(p_data[5]) == tonumber(historyTure) then
				_Head_CallBack(tonumber(GetHeadIDByIndex(p_tag)))
			else
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1645,nil)
				pTips = nil
			end
		end
	end
end
--添加特殊头像
local function InitUniqueHead(m_scrollview,nIndex,row,col,height)
	local img_uniqueHead = ImageView:create()
	img_uniqueHead:setPosition(ccp(46+(col-1)*240,height-(row-1)*99))
	img_uniqueHead:setScale(0.68)
		
	local headData = GetHeadData(nIndex)
	local pControl = nil
	if tonumber(headData[2]) == 0 then
		pControl = UIInterface.MakeHeadIcon(img_uniqueHead, ICONTYPE.HEAD_ICON, nil, nil,nil,GetHeadIDByIndex(nIndex),nil)
	else
		if tonumber(server_mainDB.getMainData("gender")) == 2 then
			pControl = UIInterface.MakeHeadIcon(img_uniqueHead, ICONTYPE.HEAD_ICON, nil, nil,nil,GetHeadIDByIndex(nIndex+1),nil)
		else
			pControl = UIInterface.MakeHeadIcon(img_uniqueHead, ICONTYPE.HEAD_ICON, nil, nil,nil,GetHeadIDByIndex(nIndex),nil)
		end
	end		
	
	
	local img_icon = img_uniqueHead:getChildByTag(1000)
	local _Img_Icon_sprite = tolua.cast(img_icon:getVirtualRenderer(), "CCSprite")
	
	local img_icon_kuang = img_uniqueHead:getChildByTag(50)
	local img_icon_kuang = tolua.cast(img_icon_kuang:getVirtualRenderer(), "CCSprite")
	
	pControl:setTag(nIndex)
	pControl:addTouchEventListener(_Click_Head_CallBack)
	local cur_vip = server_mainDB.getMainData("vip")
	local historyTure = server_mainDB.getMainData("historyTour")

	local img_lock = ImageView:create()
	img_lock:loadTexture("Image/imgres/matrix/lock_common.png")
	img_lock:setPosition(ccp(58,-50))
	AddLabelImg(img_lock,1001,img_uniqueHead)
	
	if tonumber(headData[4]) == 1 then
		if tonumber(headData[5]) < tonumber(cur_vip) then
			SpriteSetGray(_Img_Icon_sprite,0)
			SpriteSetGray(img_icon_kuang,0)
			img_lock:setVisible(false)
		else
			SpriteSetGray(_Img_Icon_sprite,1)
			SpriteSetGray(img_icon_kuang,1)
			img_lock:setVisible(true)
		end
	elseif tonumber(headData[4]) == 2 then
		if tonumber(historyTour) == tonumber(headData[4]) then
			SpriteSetGray(_Img_Icon_sprite,0)
			SpriteSetGray(img_icon_kuang,0)
			img_lock:setVisible(false)
		else
			SpriteSetGray(_Img_Icon_sprite,1)
			SpriteSetGray(img_icon_kuang,1)
			img_lock:setVisible(true)
		end
	end
	
	
	
	local label_des = Label:create()
	label_des:setPosition(ccp(img_uniqueHead:getPositionX()+120,img_uniqueHead:getPositionY()))
	label_des:setColor(ccc3(51,25,13))
	label_des:setFontSize(20)
	--label_des:setFontName("微软雅黑")
	label_des:setText(GetDesByIndex(nIndex))
	
	m_scrollview:addChild(label_des)
	m_scrollview:addChild(img_uniqueHead)
end
local function AddUniqueHeadAndDes(m_scrollview,nRow,nCol,height)
	for i=1,nRow-1 do 
		for j=1,nCol do 
			InitUniqueHead(m_scrollview,2*i+j-2,i,j,height)
		end
	end
	--[[if nRow>1 then
		if (GetUniqueHeadCount())%2 ~= 0 then
			for i=1,(GetUniqueHeadCount())%2 do 
				InitUniqueHead(m_scrollview,(nRow-1)*2+0+i,nRow,i,height)
			end
		end
	end]]--
end
local function AddUniqueHead(m_scrollview)
	--添加标题
	--线
	local row = GetGerneralRow(table.getn(GetImageData_layer()),5)
	local img_line_unique = ImageView:create()
	img_line_unique:loadTexture(IMG_PATH_LINE)
	img_line_unique:setScale9Enabled(true)
	img_line_unique:setSize(CCSize(470,5))
	img_line_unique:setPosition(ccp(241,710-99*(row-1)-60))
	AddLabelImg(img_line_unique,100,m_scrollview)
	
	
	local img_titleUnique = ImageView:create()
	img_titleUnique:loadTexture(IMG_PATH_TITLE)
	img_titleUnique:setScale9Enabled(true)
	img_titleUnique:setSize(CCSize(290,33))
	img_titleUnique:setPosition(ccp(241,710-99*row+12))
	AddLabelImg(img_titleUnique,101,m_scrollview)
	AddTitle("特殊头像",img_titleUnique,1)
	--文字
	local label_info_unique = Label:create()
	label_info_unique:setText("完成一定任务可以获得特殊头像")
	label_info_unique:setPosition(ccp(241,710-99*row-30))
	label_info_unique:setColor(ccc3(51,25,13))
	label_info_unique:setFontSize(20)
	--label_info_unique:setFontName("微软雅黑")
	AddLabelImg(label_info_unique,102,m_scrollview)
	
	local height = 710-99*row-100
	--头像
	local tabUniqueHead = GetUniqueHead_layer()
	
	local nRow = GetGerneralRow(GetUniqueHeadCount(),2)
	local nCol = GetGerneralCol(GetUniqueHeadCount(),2)
	
	AddUniqueHeadAndDes(m_scrollview,nRow,nCol,height)
end
local function ShowUI()
	--标题
	local img_baseTitle = tolua.cast(m_layer_changeHeadImage:getWidgetByName("img_base_head"),"ImageView")
	AddTitle("基础头像",img_baseTitle,1)
	local img_wjTitle = tolua.cast(m_layer_changeHeadImage:getWidgetByName("img_wj_head"),"ImageView")
	AddTitle("武将头像",img_wjTitle,1)
	
	local m_scrollview = tolua.cast(m_layer_changeHeadImage:getWidgetByName("scrollview_head"),"ScrollView")
	m_scrollview:setClippingType(1)
	--m_scrollview:setInnerContainerSize(CCSize(500,1000))
	AddBaseHead(m_scrollview)
	AddWJHead(m_scrollview)
	AddUniqueHead(m_scrollview)
end
local function _Layer_Click_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		m_layer_changeHeadImage:removeFromParentAndCleanup(true)
	end
end

function ShowChangeHeadImageLayer()
	InitVars()
	m_layer_changeHeadImage =  TouchGroup:create()
	m_layer_changeHeadImage:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/UserSettingChangeHead.json" ) )
	
	local panel_bg = tolua.cast(m_layer_changeHeadImage:getWidgetByName("Panel_changeHead"),"Layout")
	panel_bg:addTouchEventListener(_Layer_Click_CallBack)
	ShowUI()
	return m_layer_changeHeadImage
end