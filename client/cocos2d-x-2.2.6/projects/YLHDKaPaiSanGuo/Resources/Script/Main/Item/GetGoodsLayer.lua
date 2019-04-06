
require "Script/Common/Common"
require "Script/serverDB/item"
require "Script/serverDB/resimg"
require "Script/Main/LuckyDraw/ShowGeneral"


module("GetGoodsLayer", package.seeall)

require "Script/serverDB/server_itemDB"
require "Script/serverDB/coin"

local m_layer_getGoods = nil 
local m_table_goods = nil
local m_table_coin  = nil --(炼化的时候才有)
local m_count_coin = nil
--scrollview 滚动层
local m_scroll_view = nil 
--获得物品的数量
local m_count_goods = nil 
--默认的一个选中框
local m_img_icon_1 = nil
--装载物品框
local m_array_icon = nil 

--中间的层
local panel_mid = nil 

local panel_action = nil

local mid_height = nil 
local mid_bg_height = 0

local m_CallBack = nil 

local m_tabShowGeneral = nil

--传入扩大的倍数
local function updatePosition(l_num)
	--print(l_num..":l_num")
	--[[if l_num == 1 then
		l_num = l_num+0.1
	elseif l_num== 2  then
		l_num = l_num+0.3
	elseif l_num>=3 then
		l_num = l_num+0.4
	end]]--
	--print("panel_mid:getPositionY()"..panel_mid:getPositionY())
	local l_r = math.floor(m_count_goods/4)
	local nStay = m_count_goods%4
	if nStay>0 then
		l_r = l_r +1
	end 
	if l_num ==2 then
		panel_mid:setSize(CCSizeMake(panel_mid:getContentSize().width,(mid_height-80)*l_num))
	elseif l_num ==3 then
		panel_mid:setSize(CCSizeMake(panel_mid:getContentSize().width,(mid_height-100)*l_num))
	end
	m_scroll_view:setPosition(ccp(m_scroll_view:getPositionX(),m_scroll_view:getPositionY()-120*(l_num+2)))
	
	local img_wai_kuang = tolua.cast(m_layer_getGoods:getWidgetByName("img_kuang"),"ImageView")
	local img_nei = tolua.cast(m_layer_getGoods:getWidgetByName("img_bg_nei"),"ImageView")
	local img_wen = tolua.cast(m_layer_getGoods:getWidgetByName("img_wen"),"ImageView")
	local img_up_line = tolua.cast(m_layer_getGoods:getWidgetByName("img_line_up"),"ImageView")
	local img_d_line = tolua.cast(m_layer_getGoods:getWidgetByName("img_line_down"),"ImageView")
	
	if l_r<=3 then
		m_scroll_view:setSize(CCSize(m_scroll_view:getContentSize().width,120*l_num))
		m_scroll_view:setInnerContainerSize(CCSize(m_scroll_view:getContentSize().width,120*l_num))		
	else
		m_scroll_view:setSize(CCSize(m_scroll_view:getContentSize().width,120*l_num))
		m_scroll_view:setInnerContainerSize(CCSize(m_scroll_view:getContentSize().width,130*l_r+(l_r-1)*14))
		
	end
	if l_num==2 then
		
		img_wai_kuang:setSize(CCSizeMake(panel_mid:getContentSize().width,(mid_height-80)*l_num))
		img_wai_kuang:setPosition(ccp(img_wai_kuang:getPositionX(),img_wai_kuang:getPositionY()+55))
		
		
		img_nei:setSize(CCSizeMake(panel_mid:getContentSize().width,(mid_bg_height-25)*l_num))
		img_nei:setPosition(ccp(img_nei:getPositionX(),img_nei:getPositionY()+55))
		
		
		img_wen:setPosition(ccp(-1,-83))
		
		img_d_line:setPosition(ccp(-1,-122))
		img_up_line:setPosition(ccp(-1,137))
		
		m_scroll_view:setPosition(ccp(m_scroll_view:getPositionX(),m_scroll_view:getPositionY()-20))
	elseif l_num==3 then
		img_wai_kuang:setSize(CCSizeMake(panel_mid:getContentSize().width,(mid_height-90)*l_num-10*l_num))
		img_wai_kuang:setPosition(ccp(img_wai_kuang:getPositionX(),img_wai_kuang:getPositionY()+55*2+18))
		
		
		img_nei:setSize(CCSizeMake(panel_mid:getContentSize().width,(mid_bg_height-25)*l_num))
		img_nei:setPosition(ccp(img_nei:getPositionX(),img_nei:getPositionY()+55*2+15))
		
		
		img_wen:setPosition(ccp(-1,-83-73))
		
		img_d_line:setPosition(ccp(-1,-122-73))
		img_up_line:setPosition(ccp(-1,137+68))
		m_scroll_view:setPosition(ccp(m_scroll_view:getPositionX(),m_scroll_view:getPositionY()-40))
	
	end
	
end

--根据传入的物品ID获得物品的名字和资源路径
local function getGoodsInfo(l_id)
	local l_lable_name = item.getFieldByIdAndIndex(l_id,"name")
	local l_res_id = item.getFieldByIdAndIndex(l_id,"res_id")
	local l_path = resimg.getFieldByIdAndIndex(l_res_id,"icon_path")
	return l_path,l_lable_name

end
local function GetCoinName(l_id)
	return coin.getFieldByIdAndIndex(l_id,"Name")
end

local function ShowGeneralAction( nItemTab, nNum )
	local pGeneralTab = {}
	for i=1,table.getn(nItemTab) do
		local pItemType = tonumber(item.getFieldByIdAndIndex(nItemTab[i],"item_type"))
		if pItemType == E_BAGITEM_TYPE.E_BAGITEM_TYPE_GENERAL or pItemType == E_BAGITEM_TYPE.E_BAGITEM_TYPE_DANWAN then
			table.insert(pGeneralTab, nItemTab[i])
		end
	end
	

	if table.getn(pGeneralTab) > 0 then
		local pGenerlShow = ShowGeneral.Create()
		local pPanelShow = pGenerlShow:CreateGerenelLayer(pGeneralTab, nNum)
		m_layer_getGoods:addChild( pPanelShow,9999 )
		print("show general")
	end
end

local function DoGeneralAction(  )

	ShowGeneralAction(m_tabShowGeneral, 1)

end

--nType:是道具还是货币 ,tempID,strName(名字),nNum(数量)
local function AddGoodsNow(nType,tempID,strName,nNum,nIndex)
	local l_lable = Label:create()
	local l_object = m_array_icon:objectAtIndex(nIndex)
	--l_object:loadTexture(l_str_path)
	l_object:setScale(0.68)
	
	local img_icon = UIInterface.MakeHeadIcon(l_object, nType, tempID, nil)
	
	--[[local img_name_bg = ImageView:create()
	img_name_bg:loadTexture("Image/imgres/equip/bg_name_equiped.png")
	img_name_bg:setPosition(ccp(l_object:getPositionX(),l_object:getPositionY()-60))
	
	m_scroll_view:addChild(img_name_bg)]]--
	
	l_lable:setColor(ccc3(74,42,31))
	l_lable:setFontSize(20)
	l_lable:setText(strName)
	l_lable:setPosition(ccp(l_object:getPositionX(),l_object:getPositionY()-60))
	local strNum = nil 
	if nType == ICONTYPE.ITEM_ICON then
		strNum = "x"..nNum
	elseif nType == ICONTYPE.COIN_ICON then
		strNum = tostring(nNum)
	end
	local l_lable_num = LabelLayer.createStrokeLabel(22,CommonData.g_FONT1,strNum,ccp(l_object:getPositionX()-32,l_object:getPositionY()-24),COLOR_Black,COLOR_White,false,ccp(0,-2),2)
	AddLabelImg(l_lable_num,1000+nIndex,m_scroll_view)
	--img_name_bg:addChild(l_lable)
	m_scroll_view:addChild(l_lable)

end
--加载获得的物品的信息
local function loadGoodsInfo()
	--print("m_array_icon:.."..m_array_icon:count())
	m_tabShowGeneral = {}
	local pIndex = 1 
	
	for i=0,m_count_goods-1 do 
		if m_count_coin~=0 then
			--添加货币
			if i<m_count_coin then
				AddGoodsNow(ICONTYPE.COIN_ICON,m_table_coin[i+1][1],GetCoinName(m_table_coin[i+1][1]),m_table_coin[i+1][2],i)
			else
				if m_table_goods~=nil then
					local l_str_path,l_name = getGoodsInfo(m_table_goods[i-m_count_coin+1][1])
					AddGoodsNow(ICONTYPE.ITEM_ICON,m_table_goods[i-m_count_coin+1][1],l_name,m_table_goods[i-m_count_coin+1][2],i)
					m_tabShowGeneral[pIndex] = {}
					m_tabShowGeneral[pIndex] = m_table_goods[i-m_count_coin+1][1]
					pIndex = pIndex + 1
				end
		end
			
		else
			if m_table_goods~=nil then
				local l_str_path,l_name = getGoodsInfo(m_table_goods[i+1][1])
				AddGoodsNow(ICONTYPE.ITEM_ICON,m_table_goods[i+1][1],l_name,m_table_goods[i+1][2],i)
				m_tabShowGeneral[pIndex] = {}
				m_tabShowGeneral[pIndex] = m_table_goods[i+1][1]
				pIndex = pIndex + 1
			end
		end
	end

	if table.getn(m_tabShowGeneral) > 0 then
		DoGeneralAction()
	end
end
--设置icon的位置 只有大于1小于5的时候才调用
local function setIconPosition()
	local size_view = m_scroll_view:getInnerContainerSize()
	if m_count_goods == 2 then
		m_img_icon_1:setPosition(ccp( size_view.width/2-140/2,m_img_icon_1:getPositionY() ))
	elseif m_count_goods == 3 then
		m_img_icon_1:setPosition(ccp( size_view.width/2-140,m_img_icon_1:getPositionY() ))
	elseif m_count_goods == 4 then
		m_img_icon_1:setPosition(ccp( size_view.width/2-140*1.5,m_img_icon_1:getPositionY() ))
	else
		m_img_icon_1:setPosition(ccp( size_view.width/2-140*1.5,size_view.height-m_img_icon_1:getContentSize().height/2-10 ))
	end
	
	
	m_array_icon:addObject(m_img_icon_1)
	local posX = m_img_icon_1:getPositionX()
	local posY = m_img_icon_1:getPositionY()
	for i=1,m_count_goods-1 do
		--print("----------------"..i)
		local l_img_icon = ImageView:create()
		l_img_icon:loadTexture("Image/imgres/common/kuang_getgoods.png")
		local l_row = math.floor(i/4)+1
		--print("(l_row-1)*140:"..l_row)
		l_img_icon:setPosition(ccp(posX+(i%4)*140,posY-(l_row-1)*135))
		m_scroll_view:addChild(l_img_icon)
		m_array_icon:addObject(l_img_icon)
		--print("l_img_icon:"..l_img_icon:getPositionX())
		--print("位置.."..l_img_icon:getPositionY())
	end 
end
--加载获得的物品
local function loadGoods()
	local size_scrollview = m_scroll_view:getInnerContainerSize()
	--print("size_scrollview"..size_scrollview.width)
	if m_count_goods <= 4 then
		m_scroll_view:setInertiaScrollEnabled(false)
		if m_count_goods == 1 then
			m_img_icon_1:setPosition(ccp(size_scrollview.width/2,m_img_icon_1:getPositionY()))
			m_array_icon:addObject(m_img_icon_1)
		else
			setIconPosition()
		end
		loadGoodsInfo()
	else
		--local row = (m_count_goods-1)/4+1
		--updatePosition(row+0.1)
		setIconPosition()
		loadGoodsInfo()
	end

end

--动作回调
local function actionEndCallBack()
	m_scroll_view:setVisible(true)
	--m_img_icon_1:setVisible(true)
	loadGoods()


	local img_caidai = tolua.cast(m_layer_getGoods:getWidgetByName("img_caidai"),"ImageView")
	local img_up_goods = tolua.cast(m_layer_getGoods:getWidgetByName("Panel_action"),"Layout")

	local function effect_01()
	
		CommonInterface.GetAnimationByName("Image/imgres/effectfile/StrengthenEquip_effect_01.ExportJson", 
			"StrengthenEquip_effect_01", 
			"huodejianli01_02", 
			img_caidai, 
			ccp(0, -5),
			nil,
			0)
	end
	local function effect_02()

		CommonInterface.GetAnimationByName("Image/imgres/effectfile/StrengthenEquip_effect_01.ExportJson", 
			"StrengthenEquip_effect_01", 
			"huodejianli02_02", 
			img_up_goods, 
			ccp(img_caidai:getPositionX(), img_caidai:getPositionY()-20),
			nil,
			0)
	end

	CommonInterface.GetAnimationByName("Image/imgres/effectfile/StrengthenEquip_effect_01.ExportJson", 
		"StrengthenEquip_effect_01", 
		"huodejianli01_01", 
		img_caidai, 
		ccp(0, -5),
		effect_01,
		0)

	CommonInterface.GetAnimationByName("Image/imgres/effectfile/StrengthenEquip_effect_01.ExportJson", 
		"StrengthenEquip_effect_01", 
		"huodejianli02_01", 
		img_up_goods, 
		ccp(img_caidai:getPositionX(), img_caidai:getPositionY()-20),
		effect_02,
		0)

end
local function runLayerAction()
	
	panel_action:setAnchorPoint(ccp(0.5,0.5))
	local l_row = math.floor((m_count_goods-1)/4)+1
	if l_row>=3 then
		--print("l_row......."..l_row)
		panel_action:setPosition(ccp(visibleSize.width/2,visibleSize.height/2+50))
	elseif l_row == 1 then
		panel_action:setPosition(ccp(visibleSize.width/2,visibleSize.height/2-50))
	else
		panel_action:setPosition(ccp(visibleSize.width/2,visibleSize.height/2))
	end
	m_scroll_view:setPosition(ccp(visibleSize.width/2- m_scroll_view:getContentSize().width/2,m_scroll_view:getPositionY()/2+300))
	panel_action:setScale(0.4)
	WidgetSetOpacity(panel_action, 100)
	panel_action:setBackGroundImageScale9Enabled(true)
	
	local array_action = CCArray:create()
	array_action:addObject(CCScaleTo:create(0.2,1.2))
	array_action:addObject(CCScaleTo:create(0.1,1.0))
	array_action:addObject(CCCallFunc:create(actionEndCallBack))
	
	local action = CCSequence:create(array_action)
	panel_action:runAction(CCFadeIn:create(0.3))
	panel_action:runAction(action)

end

local function _Btn_Confirm_CallBack()
	m_layer_getGoods:removeFromParentAndCleanup(true)
	m_layer_getGoods = nil 
	if m_CallBack~=nil then
		m_CallBack()
	end
end

function DeleteForGuide()
	if m_layer_getGoods~=nil then
		m_layer_getGoods:removeFromParentAndCleanup(true)
		m_layer_getGoods = nil 
	end
end
local function initData()
	m_count_coin = 0
	if m_table_coin ~=nil then
		m_count_coin = #m_table_coin
	end
	local count = 0
	if m_table_goods~=nil then
		count = #m_table_goods
	end
	m_count_goods = count+m_count_coin
	m_scroll_view = tolua.cast(m_layer_getGoods:getWidgetByName("sv_goods"),"ScrollView")
	
	mid_bg_height = 160
	
	m_array_icon = CCArray:create()
	m_array_icon:retain()
end
local function initUI()
	panel_action = tolua.cast(m_layer_getGoods:getWidgetByName("Panel_action"),"Layout")
	local l_row = math.floor((m_count_goods-1)/4)+1
	
	
	
	local btn_ok = tolua.cast(m_layer_getGoods:getWidgetByName("btn_confirm"),"Button")
	--[[local btn_word = LabelLayer.createStrokeLabel(36,CommonData.g_FONT1,"确定",ccp(0,3),COLOR_Black,COLOR_White,true,ccp(0,-3),3)
	if btn_ok:getChildByTag(1)~=nil then
		btn_ok:getChildByTag(1):setVisible(false)
		btn_ok:getChildByTag(1):removeFromParentAndCleanup(true)
	end
	btn_ok:addChild(btn_word,0,1)
	btn_ok:addTouchEventListener(_Btn_Confirm_CallBack)]]--
	CreateBtnCallBack( btn_ok,"确定",36,_Btn_Confirm_CallBack,COLOR_Black,COLOR_White,nil,nil,nil )
	m_img_icon_1 = tolua.cast(m_layer_getGoods:getWidgetByName("img_icon1"),"ImageView")
	--m_down_bg = tolua.cast(m_layer_getGoods:getWidgetByName("img_down"),"ImageView")
	panel_mid = tolua.cast(m_layer_getGoods:getWidgetByName("Panel_mid"),"Layout")
	panel_mid:setBackGroundImageScale9Enabled(true)
	
	
	panel_mid:setAnchorPoint(ccp(0.5,1))
	panel_mid:setPosition(ccp(panel_mid:getContentSize().width*0.6+17,panel_mid:getPositionY()*2+45))
	
	--[[local tableFixControl = {
		{
			["off_x"] = panel_action:getContentSize().width/8,
			["off_y"] = 0,
			["control"] = panel_action,
		},
	}
	CommonInterface.PControlPos(tableFixControl)]]--
	mid_height = panel_mid:getContentSize().height
	
	--m_scroll_view:setAnchorPoint(ccp(0.5,1))
	m_scroll_view:setClippingType(1)
	m_scroll_view:setVisible(false)
	--print(l_row.."l_row")
	if l_row>3 then
		l_row = 3
	end
	updatePosition(l_row)
end

--传入table表 lh_table:炼化的时候分成了道具表和货币表
function createGetGoods(l_table,lh_table,fCallBack)
	--[[local test_label = { {150001,1},
	                     {150002,1},
						 {150003,1},
						 {150004,1},
						 {150005,1},
						 {150005,1},
						 {150005,1},
						 {150005,1},
						 {150005,1},
						 {150005,1},
						 {150005,1},
						 {150005,1},
						 {150005,1},
					   }]]--
	--print("============================")
	local testCoin = {
		{1,100000}
	
	}
	m_CallBack = fCallBack
	m_table_goods = l_table--test_label --l_table
	m_table_coin = lh_table--testCoin--lh_table
	
	if m_layer_getGoods == nil then	
		m_layer_getGoods = TouchGroup:create()
		m_layer_getGoods:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/GetGoodsLayer.json"))
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		scenetemp:addChild(m_layer_getGoods, layerGetGoodsTag, layerGetGoodsTag)
		
	end
	
	initData()
	initUI()
	runLayerAction()

    CommonInterface.MakeUIToCenter(m_layer_getGoods)

end