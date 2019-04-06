module("NoticeScrollLayer",package.seeall)
require "Script/Main/NoticeBoard/NoticeScrollLogic"
require "Script/Main/NoticeBoard/NoticeScrollData"
require "Script/Fight/simulationStl"
local GetNoticeType = NoticeScrollData.GetNoticeType
local GetNoticeInfoByID = NoticeScrollData.GetNoticeInfoByID
local GetNoticeInfoDataByID = NoticeScrollData.GetNoticeInfoDataByID
local GetNitoceTriByID = NoticeScrollData.GetNitoceTriByID
local GetPointItemName = NoticeScrollData.GetPointItemName
local ChatSystemNotice = NoticeScrollData.ChatSystemNotice
local GetSceneByTypeAndID = NoticeScrollLogic.GetSceneByTypeAndID

local m_scroll 		= nil
local m_label 		= nil
local m_staNoticeStack = nil
local is_autoscroll = false
local tab 			= {}
local tabNotice     = {}
local pPMask        = nil
local m_nHanders    = nil
local n_time        = 1

local NOTICELAYER_TYPE = {
	NOTICELAYER_TYPE_ONE       	= 1,
	NOTICELAYER_TYPE_TWO 			= 2,
	NOTICELAYER_TYPE_THREE 			= 3,
}

local function init(  )
	m_scroll 		= nil
	is_autoscroll 	= false
	m_label			= nil
	pPMask          = nil
	m_staNoticeStack = nil
	m_nHanders      = nil
end

--循环滚动
function ShowScrollowLayer( strText,nRoot,PosX,PosY )
	local pText = Label:create()
    pText:setText(strText)
    pText:setFontSize(24)
    -- pText:setColor(ccc3(58,25,13))
	pText:setFontName(CommonData.g_FONT3)

	local labelWidth = pText:getContentSize().width   
    local time = 5 -- 这里可以根据label多长动态计算时间   
    local scrollViewLayer = Label:create()
    scrollViewLayer:setPosition(ccp(0,0))   
    scrollViewLayer:setContentSize(pText:getContentSize()) 

    local scrollView1 = CCScrollView:create()   
    if nil ~= scrollView1 then   
        scrollView1:setViewSize(CCSize(250, 30))   
        scrollView1:setPosition(ccp(PosX, PosY)) --  -130  220    
        scrollView1:setClippingToBounds(true)   
        scrollView1:setBounceable(true)  
        scrollView1:setTouchEnabled(false)   
    end   
    scrollView1:addChild(pText)   
    nRoot:addNode(scrollView1)   
  	local scrollSize = scrollView1:getContentSize().width
  	--label的位置
  	pText:setPosition(ccp(250,0)) --scrollView1:getPositionX()*1.2+
    if nil ~= scrollViewLayer_ then   
        scrollView1:setInnerContainerSize(scrollViewLayer)   
        scrollView1:updateInset()   
    end   

    local function MoveCallBack(  )
    	if tonumber(pText:getPositionX()) <= -500 then
    		pText:setPosition(ccp(labelWidth,0))
    	end
    end

    local actionArray3 = CCArray:create()
	actionArray3:addObject(CCMoveBy:create(3.5,ccp(-labelWidth/2,0)))
	actionArray3:addObject(CCCallFunc:create(MoveCallBack))
	pText:stopAllActions()
	pText:setOpacity(255)
	local sequ = CCSequence:create(actionArray3)
	pText:runAction(CCRepeatForever:create(sequ))

end

--滚动式公告
function showNoticeScrollLayer( strText,name,m_name,nScrollView,n_mtype )
	local pText = nil
	local time = 3
	local pScrollTipLayer = CCLayer:create()
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	nScrollView:addChild(pScrollTipLayer, 800, 800) --layerTip_Tag

	pText = Label:create()
	pText:setFontSize(20)
	pText:setFontName(CommonData.g_FONT3)
	
	pText:setColor(COLOR_Red)
	if tonumber(n_mtype) == 0 then
		pText:setText(string.format(tab["text"],name,m_name))
	else
		pText:setText(strText)
	end

	local img_bg = ImageView:create()
	img_bg:loadTexture("Image/imgres/common/noticeDark.png")
	img_bg:setScaleX(0.68)
	img_bg:setPosition(ccp(CommonData.g_sizeVisibleSize.width/2+50, CommonData.g_sizeVisibleSize.height*4/5))
	if img_bg~=nil then
		AddLabelImg(img_bg,10,pScrollTipLayer)
	end
    local labelWidth = pText:getContentSize().width     
    local scrollViewLayer = Label:create()
    scrollViewLayer:setPosition(ccp(0,0))   
    scrollViewLayer:setContentSize(pText:getContentSize())   
  
  
    local scrollView1 = CCScrollView:create()   
    if nil ~= scrollView1 then   
        scrollView1:setViewSize(CCSize(500, 100))   
        scrollView1:setPosition(ccp(CommonData.g_sizeVisibleSize.width/4+70, CommonData.g_sizeVisibleSize.height*4/5-10))     
        scrollView1:setClippingToBounds(true)   
        scrollView1:setBounceable(true)  
        scrollView1:setTouchEnabled(false)   
    end   
    scrollView1:addChild(pText)   
    pScrollTipLayer:addChild(scrollView1)   
  	local scrollSize = scrollView1:getContentSize().width
  	--label的位置
  	pText:setPosition(ccp(scrollView1:getPositionX()*1+labelWidth/2-20,-2)) --1.2
    if nil ~= scrollViewLayer_ then   
        scrollView1:setInnerContainerSize(scrollViewLayer)   
        scrollView1:updateInset()   
    end   
    --print("尺寸",labelWidth,scrollSize,scrollView1:getPositionX(),scrollView1:getPositionY(),labelWidth/2+scrollSize)
    -- Pause()
    --根据label的长度计算time时间
    if labelWidth <= 500 then
    	time = 5
    else
    	time = (300 + labelWidth)*time/400 + 2

    end
	local function DeleteSelf()
        pScrollTipLayer:setVisible(false)
        pScrollTipLayer:removeFromParentAndCleanup(true)
        pScrollTipLayer = nil
        n_time = 1
	end

	local function hide_callback()
		local actionArray1 = CCArray:create()
		actionArray1:addObject(CCDelayTime:create(time+2)) -- 2
		actionArray1:addObject(CCCallFuncN:create(DeleteSelf))
		pText:runAction(CCSequence:create(actionArray1))
	end

	if pScrollTipLayer ~= nil then
		local actionArray2 = CCArray:create()
		actionArray2:addObject(CCDelayTime:create(time))
		actionArray2:addObject(CCCallFunc:create(hide_callback))
		-- actionArray2:addObject(CCFadeOut:create(5))
		pScrollTipLayer:stopAllActions()
		pScrollTipLayer:runAction(CCSequence:create(actionArray2))
	end
	if labelWidth > 10 then
		local actionArray3 = CCArray:create()
		actionArray3:addObject(CCMoveBy:create(time,ccp(-(labelWidth/2+350),0)))
		pText:stopAllActions()
		pText:setOpacity(255)
		local sequ = CCSequence:create(actionArray3)
		pText:runAction(CCRepeatForever:create(sequ))
	else
		local actionArray3 = CCArray:create()
		actionArray3:addObject(CCDelayTime:create(time))
		actionArray3:addObject(CCFadeOut:create(1))
		pText:stopAllActions()
		pText:setOpacity(255)
		local sequ = CCSequence:create(actionArray3)
		pText:runAction(CCRepeatForever:create(sequ))
	end
end

--直接弹屏慕式的公告
function showNoticeScale( strText,name,m_name,nScrollView,n_mtype)
	local pText = nil
	local pPopTipLayer = CCLayer:create()
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	scenetemp:addChild(pPopTipLayer, 300, 300)

	--pText = LabelLayer.createStrokeLabel(size,CommonData.g_FONT1,strText,pos,COLOR_Black,color,false,ccp(0,-2),2)
	pText = Label:create()
	pText:setPosition(ccp(CommonData.g_sizeVisibleSize.width/2, CommonData.g_sizeVisibleSize.height/2+50))
	pText:setFontSize(25)
	pText:setFontName(CommonData.g_FONT3)
	pText:setColor(COLOR_Red)
	if tonumber(n_mtype) == 0 then
		pText:setText(string.format(tab["text"],name,m_name))
	else
		pText:setText(strText)
	end
	
	-- Pause()
	if pText ~= nil then
		pPopTipLayer:addChild(pText)
	end

	local function DeleteSelf()
        pPopTipLayer:setVisible(false)
        pPopTipLayer:removeFromParentAndCleanup(true)
        pPopTipLayer = nil
        n_time = 1
	end

	local function hide_callback()
		local actionArray1 = CCArray:create()
		-- actionArray1:addObject(CCMoveBy:create(1, ccp(0, 200)))
		--actionArray1:addObject(CCScaleTo:create(1, 0.3))
		actionArray1:addObject(CCDelayTime:create(2.5))
		actionArray1:addObject(CCCallFuncN:create(DeleteSelf))
		pText:runAction(CCSequence:create(actionArray1))
	end

	if pText ~= nil then
		pText:setScale(0.7)
		local actionArray2 = CCArray:create()
		actionArray2:addObject(CCScaleTo:create(0, 0.5))
		actionArray2:addObject(CCScaleTo:create(0.25, 1.2))
		actionArray2:addObject(CCScaleTo:create(0.25, 1.0))
		actionArray2:addObject(CCMoveBy:create(1, ccp(0, 200)))
		actionArray2:addObject(CCDelayTime:create(2.5))
		actionArray2:addObject(CCCallFunc:create(hide_callback))
		actionArray2:addObject(CCFadeOut:create(1))
		pText:stopAllActions()
		-- pText:setOpacity(255)
		pText:runAction(CCSequence:create(actionArray2))
	end
end

function ShowCommonNotice( tabs )
	tabNotice = tabs
	local nID = tabNotice["id"]
	local nName = tabNotice["name"]
	local n_type = tabNotice["nType"] -- 0表示需要客户端自己拼接 1表示直接显示服务器发送的字符串
	-- local m_name = tabNotice["nextName"]

	local m_nType = GetNoticeType(nID) -- 公告显示的方式
	local m_message = nil
	tab = GetNoticeInfoDataByID(nID)
	
	local n_Root = GetSceneByTypeAndID(tabNotice)
	if n_Root == nil then
		n_time = 1
		return
	end
	local m_name = ""
	local tabMess = {}
	if tonumber(n_type) == 1 then
		m_name = 1
		m_message = nName
	else
		m_message = GetNoticeInfoByID(nID)
		m_name = GetPointItemName(tabNotice)
	end
	showNoticeScrollLayer(m_message,nName,m_name,n_Root,n_type)
	
end

function StopSNotice(  )
	if m_nHanders ~= nil then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_nHanders)
	end

end

local function UpdateNotice( dt )
	if n_time == 1 then
		if m_staNoticeStack ~= nil then
			local noticeInfo = m_staNoticeStack:PopStack()
			if noticeInfo ~= nil then
				n_time = 0
				ShowCommonNotice(noticeInfo)
				-- m_staNoticeStack:empty_Stack(noticeInfo)
			else
				if m_nHanders ~= nil then
					CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_nHanders)
					m_nHanders = nil
				end
			end
		end
	end
end

function GetNoticeDataStack( tabData )
	if m_staNoticeStack ~= nil then
		m_staNoticeStack:PushStack(tabData)
		if m_nHanders == nil then
			m_nHanders  = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(UpdateNotice, 0.1, false)
		end
	end
end

function createNotice(  )
	init()
	m_staNoticeStack = simulationStl.creatStack_First()
end