module("CorpsFunctionTipLayer",package.seeall)

local m_CorpsBuyLayer = nil
local m_CorpsShangjiaLayer = nil

function CreateBuyThingLayer(  )
	if m_CorpsBuyLayer == nil then
		m_CorpsBuyLayer = TouchGroup:create()									-- 背景层
	    m_CorpsBuyLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CorpsShanghui_3.json") )
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		scenetemp:addChild(m_CorpsBuyLayer, layerTip_Tag, layerTip_Tag)
	end
	-----------iten--------------------------------------------------------------------------------------------------------
	local image_item = tolua.cast(m_CorpsBuyLayer:getWidgetByName("Image_item"),"ImageView")
	-------------Label-------------------------------------------------------------------------------------------------
	local label_name = tolua.cast(m_CorpsBuyLayer:getWidgetByName("Label_name"),"Label")
	local label_word = tolua.cast(m_CorpsBuyLayer:getWidgetByName("Label_word3"),"Label")
	local img_own = tolua.cast(m_CorpsBuyLayer:getWidgetByName("Image_23"),"Image")
	local img_buy = tolua.cast(m_CorpsBuyLayer:getWidgetByName("Image_25"),"Image")
	local label_num = tolua.cast(m_CorpsBuyLayer:getWidgetByName("Label_num"),"Label")
	local label_price = tolua.cast(m_CorpsBuyLayer:getWidgetByName("Label_price"),"Label")

	------------button-----------------------------------------------------------------------------------------------------------
	------------返回按钮----------------
	local function _Click_return_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			m_CorpsBuyLayer:setVisible(false)
			m_CorpsBuyLayer:removeFromParentAndCleanup(true)
			m_CorpsBuyLayer = nil
		end
	end
	local btn_return = tolua.cast(m_CorpsBuyLayer:getWidgetByName("Button_return"),"Button")
	btn_return:addTouchEventListener(_Click_return_CallBack)

	----------购买按钮------------
	local function _Click_Buy_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			print("购买按钮")
		end
	end
	local btn_buy = tolua.cast(m_CorpsBuyLayer:getWidgetByName("Button_buy"),"Button")

	----------左右按钮，一次，十次------------------
	local function _Click_Add_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			print("增加一个")
		end
	end
	local btn_add = tolua.cast(m_CorpsBuyLayer:getWidgetByName("Button_right1"),"Button")
	btn_add:addTouchEventListener(_Click_Add_CallBack)

	local function _Click_Sub_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			print("减少一个")
		end
	end
	local btn_sub = tolua.cast(m_CorpsBuyLayer:getWidgetByName("Button_left2"),"Button")
	btn_sub:addTouchEventListener(_Click_Sub_CallBack)

	local function _Click_AddTen_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			print("增加十个")
		end
	end
	local btn_addTen = tolua.cast(m_CorpsBuyLayer:getWidgetByName("Button_left1"),"Button")
	btn_addTen:addTouchEventListener(_Click_AddTen_CallBack)

	local function _Click_SubTen_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			print("减少十个")
		end
	end
	local btn_subTen = tolua.cast(m_CorpsBuyLayer:getWidgetByName("Button_right2"),"Button")
	btn_subTen:addTouchEventListener(_Click_SubTen_CallBack)


end