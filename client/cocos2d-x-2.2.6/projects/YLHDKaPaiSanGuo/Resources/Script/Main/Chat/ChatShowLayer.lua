module("ChatShowLayer",package.seeall)
--require "Script/Main/Chat/ChatLayer"

local m_ChatShowLayer = nil
local m_ListInnerHeight = 0.0
local button  = nil
local m_root = nil
local List_Chat = nil

local function initVar( ... )
	m_ChatShowLayer = nil
	button  = nil
	m_root = nil
	List_Chat = nil

end

function UpDateChatList(nMessDB)
	-- print("聊天界面显示内容")
	if m_ChatShowLayer == nil then
		return 
	end
	local function CreateMessItemWidget( pMessItemTemp )
	    local pMessItem = pMessItemTemp:clone()
	    local peer = tolua.getpeer(pMessItemTemp)
	    tolua.setpeer(pMessItem, peer)
	    return pMessItem
	end
	local List_Chat	= tolua.cast(m_ChatShowLayer:getWidgetByName("ListView_Chat"), "ListView")
	local data = nMessDB
   	require "Script/Main/Chat/ChatLogic"
   	local nMessText = ChatLogic.UpdateTypeTextColor(nMessDB,server_mainDB.getMainData("name"))
   	local pTextWidth = 340
   	require "Script/Common/RichLabel"
	local messContentItem = RichLabel.Create(nMessText,pTextWidth,nil,nil,0.6)
   	local messNumArr = List_Chat:getItems()
	local messNums = messNumArr:count()
	--print("messNums = "..messNums)
	if messNums > 5 then
		Log("Del First Mess")
		List_Chat:removeItem(0)
	end
	--判断聊天框是展开状态还是收缩状态
   	List_Chat:pushBackCustomItem(messContentItem) 
   	m_ListInnerHeight = m_ListInnerHeight + (messContentItem:getContentSize().height + 5)
    List_Chat:setInnerContainerSize(CCSizeMake(List_Chat:getInnerContainerSize().width,m_ListInnerHeight))
	List_Chat:jumpToBottom()
	-- List_Chat:jumpToTop()	
end

function OpenChatLayer(  )
	local scenetemp = CCDirector:sharedDirector():getRunningScene()
	local temp = scenetemp:getChildByTag(150)
	if temp ~= nil then --m_ChatShowLayer:getChildByTag(18880)
		temp:removeFromParentAndCleanup(false)
	else
		scenetemp:setVisible(true)
		scenetemp:addChild(m_pChatLayer,150,150)	
		ChatLayer.ResetCLippingType()
	end	
end

local function initWidget( mRootLayer )
	--偏移量
	local nOff_W = CommonData.g_nDeginSize_Width - CommonData.g_sizeVisibleSize.width
	local nOff_H = CommonData.g_nDeginSize_Height - CommonData.g_sizeVisibleSize.height
	local nOff_X = CommonData.g_Origin.x
	local nOff_Y = CommonData.g_Origin.y

	--聊天 按钮  
	
	local function _Click_Chat_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			sender:setScale(1.0)
			OpenChatLayer()
		elseif  eventType == TouchEventType.began then
			sender:setScale(0.9)
		elseif eventType == TouchEventType.canceled then
			sender:setScale(1.0)
		end
	end
    local Image_Chat = tolua.cast(m_ChatShowLayer:getWidgetByName("Image_ChatBtn"), "ImageView")
    Image_Chat:setZOrder(1000)
    Image_Chat:addTouchEventListener(_Click_Chat_CallBack)

    -------------------------------------------------------------------------------------------------------------------------------------------------

    --聊天框
    local Panel_Chat 	  = tolua.cast(m_ChatShowLayer:getWidgetByName("Panel_Chatl"), "Layout")
    local Panel_CutList	  = tolua.cast(m_ChatShowLayer:getWidgetByName("Panel_ChatCutList"), "Layout")
    local Image_ChatFrame = tolua.cast(m_ChatShowLayer:getWidgetByName("Image_Chat"), "ImageView")
    List_Chat		  = tolua.cast(m_ChatShowLayer:getWidgetByName("ListView_Chat"), "ListView")
    List_Chat:setClippingType(1)
    List_Chat:setItemsMargin(5)

    local Image_ShowChatBtn= tolua.cast(m_ChatShowLayer:getWidgetByName("Image_ShowChat"), "ImageView")
    Image_ShowChatBtn:setTouchEnabled(true)
    Image_ShowChatBtn:setZOrder(1001)

	local function _Click_ShowChat_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
			sender:setScale(1.0)
			AudioUtil.PlayBtnClick()
			if m_pShowChatFrame then 
				m_pShowChatFrame = false
				Panel_CutList:setSize(CCSizeMake(Panel_CutList:getSize().width,Panel_CutList:getSize().height - 50))
				Image_ChatFrame:setSize(CCSizeMake(Image_ChatFrame:getSize().width,Image_ChatFrame:getSize().height - 50))
				Image_Chat:setPosition(ccp(Image_Chat:getPositionX() ,Image_Chat:getPositionY() - 50 - nOff_Y)) 
				List_Chat:setSize(CCSizeMake(List_Chat:getSize().width,List_Chat:getSize().height - 50))
				Image_ShowChatBtn:setRotation(0)
				--Image_ChatFrame:setTouchEnabled(true)
				--Panel_CutList:setTouchEnabled(true)
				--List_Chat:setTouchEnabled(true)
			else
				m_pShowChatFrame = true
				if List_Chat:getSize().height <= 150 then
					List_Chat:setSize(CCSizeMake(List_Chat:getSize().width,List_Chat:getSize().height + 50))
				else
					--print("ListView尺寸无需再变化")
				end
				Panel_CutList:setSize(CCSizeMake(Panel_CutList:getSize().width,Panel_CutList:getSize().height + 50))
				Image_ChatFrame:setSize(CCSizeMake(Image_ChatFrame:getSize().width,Image_ChatFrame:getSize().height + 50))
				Image_Chat:setPosition(ccp(Image_Chat:getPositionX(),Image_Chat:getPositionY() + 50 - nOff_Y)) 
				Image_ShowChatBtn:setRotation(180)
			end	
		List_Chat:jumpToBottom()
		Image_ShowChatBtn:setPosition(ccp(Image_ShowChatBtn:getPositionX(),Image_ChatFrame:getSize().height - Image_ShowChatBtn:getSize().height))	
		elseif  eventType == TouchEventType.began then
			sender:setScale(0.9)
		elseif eventType == TouchEventType.canceled then
			sender:setScale(1.0)
		end
	end
    
    Image_ShowChatBtn:addTouchEventListener(_Click_ShowChat_CallBack) 
    List_Chat:setSize(CCSizeMake(List_Chat:getSize().width,List_Chat:getSize().height - 50))
    Image_ChatFrame:setSize(CCSizeMake(Image_ChatFrame:getSize().width,Image_ChatFrame:getSize().height - 50))
    Image_ShowChatBtn:setPosition(ccp(Image_ShowChatBtn:getPositionX(),Image_ChatFrame:getSize().height - Image_ShowChatBtn:getSize().height))
   	
	Image_Chat:setPosition(ccp(Image_Chat:getPositionX() ,Image_Chat:getPositionY() - 50 ))  
	Panel_Chat:setPosition(ccp(Panel_Chat:getPositionX() ,Panel_Chat:getPositionY()))
	

    if m_pShowChatFrame then 
    	Image_ShowChatBtn:setRotation(180)
    else
    	Image_ShowChatBtn:setRotation(0)
    end
end

function ShowChatlayer( mRootLayer )
	if m_ChatShowLayer ~= nil and mRootLayer ~= nil then
		m_ChatShowLayer:removeFromParentAndCleanup(false)
		mRootLayer:addChild(m_ChatShowLayer,10,10)
		List_Chat:jumpToBottom()
		if mRootLayer:getTag() == layerMainRoot_Tag then
			m_ChatShowLayer:setPosition(ccp(2 ,0)) --- CommonData.g_Origin.x
		else
			m_ChatShowLayer:setPosition(ccp(2 + CommonData.g_Origin.x ,0))
		end
		List_Chat:jumpToBottom()
	end
end

function CreateShowChatLayer( nRootLayer )
	initVar()
	m_ChatShowLayer = TouchGroup:create()
	m_ChatShowLayer:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/ChatSceneLayer.json"))
	nRootLayer:addChild(m_ChatShowLayer,10,10)

	m_pChatLayer = ChatLayer.CreateChatLayer(E_CHAT_TYPE.E_CHAT_WORLD)
	m_pChatLayer:retain()
	m_ChatShowLayer:retain()
	-- m_ChatShowLayer:setPosition(ccp(2 + CommonData.g_Origin.x,0))
	initWidget(nRootLayer)
end