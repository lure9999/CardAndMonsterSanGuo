

module("ServerChooseLayer", package.seeall)


---变量
local m_layerServerChoose = nil 
local m_listview_server = nil 
local m_list_item = nil --模板（列表容器的item）
local m_count_server = nil 


--逻辑
local getSelecedName = LoginLogic.getServerName
local getServerCount = LoginLogic.getServerListCount
local getSNameByID = LoginLogic.getServerNameByID
local saveSelectName = LoginLogic.saveServerName


--通用的接口
--描边
local outLine  = LabelLayer.createStrokeLabel



local function InitVars()
	m_layerServerChoose = nil 
	m_listview_server = nil 
	m_list_item = nil 
	m_count_server = nil 
end
--传入字号，颜色创建lable 返回
local function createLabel(fontSize,fontColor)
	local l_label = Label:create()
	l_label:setFontSize(fontSize)
	l_label:setColor(fontColor)
	return l_label
end
function deleteMySelf()
	m_layerServerChoose:removeFromParentAndCleanup(true)
	m_layerServerChoose = nil 
end
local function _Label_Exit_CallBack(sender, eventType)
	if eventType == TouchEventType.ended then
		deleteMySelf()
	end
end
local function initData()
	local l_img_name_bg = tolua.cast(m_layerServerChoose:getWidgetByName("img_name_bg"),"ImageView")
	local l_label_name = outLine(24,CommonData.g_FONT1,"所有服务器",ccp(0,4),COLOR_Black,COLOR_White,true,ccp(0,-2),2)
	if l_img_name_bg:getChildByTag(2)~=nil then
		l_img_name_bg:getChildByTag(2):setVisible(false)
		l_img_name_bg:getChildByTag(2):removeFromParentAndCleanup(true)
	end
	l_img_name_bg:addChild(l_label_name,2,2)
	
	--上次登录服务器的名字
	local img_bg_s_name = tolua.cast(m_layerServerChoose:getWidgetByName("img_selected_bg"),"ImageView")
	local l_label_last_name = createLabel(20,ccc3(75,46,31))
	l_label_last_name:setText(getSelecedName())
	l_label_last_name:setPosition(ccp(0,0))
	if img_bg_s_name:getChildByTag(1)~=nil then
		img_bg_s_name:getChildByTag(1):setVisible(false)
		img_bg_s_name:getChildByTag(1):removeFromParentAndCleanup(true)
	end
	img_bg_s_name:addChild(l_label_last_name,1,1)
	img_bg_s_name:setTouchEnabled(true)
	img_bg_s_name:addTouchEventListener(_Label_Exit_CallBack)
	
	--服务器列表
	m_listview_server = tolua.cast(m_layerServerChoose:getWidgetByName("listView_server"),"ListView")
	
	m_list_item =  GUIReader:shareReader():widgetFromJsonFile("Image/Server_list_item.json")
	
	
	m_listview_server:setItemsMargin(15)
	
	m_count_server = getServerCount()
end
local function _Select_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		local tag = sender:getTag()
		saveSelectName(getSNameByID(tag-100))
		LoginLayer.updateSelectServerName()
		deleteMySelf()
	end
end
--次序l_id,模板l_model
local function initListItems(l_id,l_model,l_col,bLast)
	local name = getSNameByID(l_id)
	local item_model = tolua.cast(l_model:getChildByName("img_item"..l_col),"ImageView")
	if bLast== true then
		local l_item_model = tolua.cast(l_model:getChildByName("img_item2"),"ImageView")
		l_item_model:removeFromParentAndCleanup(true)
	end
	if m_count_server<2 then
		local l_item_model = tolua.cast(l_model:getChildByName("img_item2"),"ImageView")
		l_item_model:removeFromParentAndCleanup(true)
	end
	item_model:setTag(100+l_id)
	item_model:setTouchEnabled(true)
	item_model:addTouchEventListener(_Select_CallBack)
	
	local label_s_name_i = createLabel(20,ccc3(75,46,31))
	label_s_name_i:setText(name)
	label_s_name_i:setPosition(ccp(0,0))
	if item_model:getChildByTag(1)~=nil then
		item_model:getChildByTag(1):setVisible(false)
		item_model:getChildByTag(1):removeFromParentAndCleanup(true)
	end
	item_model:addChild(label_s_name_i,1,1)
end
local function getCloneItem()
	local new_item = m_list_item:clone()
	local peer = tolua.getpeer(m_list_item)
	tolua.setpeer(new_item,peer)
	
	return new_item
end
local function showUI()
	--显示所有的服务器
	local nRow = 0
	local nCol  = 0 
	if m_count_server>2 then
		nRow = m_count_server/2
		nCol = 2
	else
		nRow = 1
		nCol = m_count_server
	end

	for i=1,nRow  do 
		local item_clone_i = getCloneItem()
		for j=1,nCol do 
			initListItems((i-1)*2+j,item_clone_i,j,false)
		end
		m_listview_server:pushBackCustomItem(item_clone_i)
	end
	if m_count_server>2 then
		if (m_count_server%2) ~= 0 then
			local item_clone_last = getCloneItem()
			initListItems(m_count_server,item_clone_last,1,true)
			m_listview_server:pushBackCustomItem(item_clone_last)
		end
	end
end
function createServerChooseLayer()
	InitVars()
	m_layerServerChoose = TouchGroup:create()
	m_layerServerChoose:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/ServerChooseLayer.json" ) )
	initData()
	showUI()
	return m_layerServerChoose
end