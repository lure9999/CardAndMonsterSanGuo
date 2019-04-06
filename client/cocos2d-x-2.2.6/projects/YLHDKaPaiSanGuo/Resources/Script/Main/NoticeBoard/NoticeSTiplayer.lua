module("NoticeSTiplayer",package.seeall)
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
local m_nHanderss    = nil
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
	m_nHanderss      = nil
end

--直接弹屏慕式的公告
function showNoticeScale( strText,name,m_name,nScrollView,n_mtype)
	local pText = nil
	local pPopTipLayer = CCLayer:create()
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	nScrollView:addChild(pPopTipLayer, 200, 200)

	--pText = LabelLayer.createStrokeLabel(size,CommonData.g_FONT1,strText,pos,COLOR_Black,color,false,ccp(0,-2),2)
	pText = Label:create()
	pText:setPosition(ccp(CommonData.g_sizeVisibleSize.width/2, CommonData.g_sizeVisibleSize.height-100))
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
		-- actionArray2:addObject(CCMoveBy:create(1, ccp(0, 200)))
		actionArray2:addObject(CCDelayTime:create(2.5))
		actionArray2:addObject(CCCallFunc:create(hide_callback))
		actionArray2:addObject(CCFadeOut:create(1))
		pText:stopAllActions()
		-- pText:setOpacity(255)
		pText:runAction(CCSequence:create(actionArray2))
	end
end

local function ShowCommonNotice( tabs )
	tabNotice = tabs
	local nID = tabNotice["id"]
	local nName = tabNotice["name"]
	local n_type = tabNotice["nType"] -- 0表示需要客户端自己拼接 1表示直接显示服务器发送的字符串
	-- local m_name = tabNotice["nextName"]
	local m_nType = GetNoticeType(nID) -- 公告显示的方式
	local m_message = nil
	tab = GetNoticeInfoDataByID(nID)
	
	local n_Root = NoticeScrollLogic.GetTipTypeAndID(tabNotice)
	if n_Root == nil then
		n_time = 1
		return
	end
	local tabMess = {}
	if tonumber(n_type) == 1 then
		m_name = 1
		m_message = nName
	else
		m_message = GetNoticeInfoByID(nID)
		m_name = GetPointItemName(tabNotice)
	end
		
	showNoticeScale(m_message,nName,m_name,n_Root,n_type)
end



function StopSNotice(  )
	if m_nHanderss ~= nil then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_nHanderss)
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
				if m_nHanderss ~= nil then
					CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_nHanderss)
					m_nHanderss = nil
				end
			end
			
		end
	end
end

function GetNoticesDataStack( tabData )
	if m_staNoticeStack ~= nil then
		m_staNoticeStack:PushStack(tabData)
		if m_nHanderss == nil then
			m_nHanderss  = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(UpdateNotice, 0.1, false)
		end
	end
end

function createsNotice(  )
	init()
	m_staNoticeStack = simulationStl.creatStack_First()
end