--require "Script/Common/Common"
require "Script/Main/Chat/ChatData"
require "Script/Main/Chat/ChatLogic"
require "Script/Common/LabelLayer"
require "Script/Main/Chat/ChatFaceLayer"
require "Script/Main/Chat/ChatShowLayer"
require "Script/Common/RichLabel"
module("ChatLayer", package.seeall)
require "Script/Main/Corps/CorpsLayer"

local SYSTEMIMG = "Image/imgres/chat/horn.png"
local StrokeLabel_createStrokeLabel 	= LabelLayer.createStrokeLabel

local GetChatListData					=	ChatData.GetChatListData
local GetUserName						=	ChatData.GetUserName
local GetTypeChatMess					=   ChatData.GetTypeChatMess
local GetGamerInfo						=   ChatData.GetGamerInfo
local GetConsumInfo                     =   ChatData.GetConsumInfo
local GetConsumName                     =   ChatData.GetConsumName
local GetConsumItem                     =   ChatData.GetConsumItem

m_ChatPanel 	     = nil
m_ChatFacePanel      = nil
m_BoxChatWorld       = nil
m_BoxChatGuild       = nil
m_BoxChatTeam        = nil
m_BoxChatPrivate     = nil
m_InputTextField     = nil
m_CurrentType	 	 = nil
m_ContentBg		  	 = nil
m_InputNameTextField = nil
m_InputPriTextField  = nil
m_ListInnerHeight    = 0.0
m_SendMessSpaceNum	 = 0
m_nHanderTime		 = nil
btn_Face             = nil
m_LabelFree          = nil
m_LabelNum           = nil
local isSend 		 = true
local nfaceId        = 1
local StrokeLabel_Text_Tag = 1000
local SendMessSpaceMaxNum  = 60
local SendFreeNum    = 10
local m_pChatFaceLayer = nil
local word_line      = nil
SendFreeLabel        = nil
sendTime             = 60
m_labelTime          = nil
m_labelCoolTime      = nil
local function InitVars()
	m_ChatPanel 	     = nil
	m_ChatFacePanel      = nil
	m_BoxChatWorld       = nil
	m_BoxChatGuild       = nil
	m_BoxChatTeam        = nil
	m_BoxChatPrivate     = nil
	m_InputTextField     = nil
	m_InputPriTextField  = nil
	m_CurrentType	     = nil
	m_InputNameTextField = nil
	m_ListInnerHeight    = 0.0
	m_SendMessSpaceNum	 = 0
	isSend				 = true
	nfaceId				 = 1
	btn_Face             = nil	
	m_LabelFree          = nil
	m_LabelNum           = nil	
	SendFreeLabel        = nil    
    m_labelTime          = nil
    m_labelCoolTime      = nil
    sendTime             = 60   
    word_line            = nil 
    SendFreeNum          = 10
end

--Return Main
local function _Click_Return_ChatLayer_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		sender:setScale(1.0)
		if m_nHanderTime ~= nil then
			m_ChatPanel:getScheduler():unscheduleScriptEntry(m_nHanderTime)
			m_nHanderTime = nil
		end
		-- m_ChatPanel:setVisible(false)
		m_ChatPanel:removeFromParentAndCleanup(false)
		-- m_ChatPanel = nil
		
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function RequstLastMess( nTypeID )
	local nTypeMessDB = GetTypeChatMess(m_CurrentType)
	local maxNum = table.getn(nTypeMessDB)
end

function ChangeType( nTypeID )
	
end

local function InitStatus( )
	m_BoxChatWorld:setSelectedState(false)
	m_BoxChatGuild:setSelectedState(false)
	m_BoxChatTeam:setSelectedState(false)
	m_BoxChatPrivate:setSelectedState(false)
	m_BoxChatWorld:setZOrder(0)
	m_BoxChatGuild:setZOrder(0)
	m_BoxChatTeam:setZOrder(0)
	m_BoxChatPrivate:setZOrder(0)
	m_BoxChatWorld:setTouchEnabled(true)
	m_BoxChatGuild:setTouchEnabled(true)
	m_BoxChatTeam:setTouchEnabled(true)
	m_BoxChatPrivate:setTouchEnabled(true)
	m_ContentBg:setSize(CCSizeMake(460,510))
	if m_InputNameTextField~=nil and m_InputPriTextField ~= nil then
		m_InputNameTextField:setVisible(false)
		m_InputNameTextField:setTouchEnabled(false)
		m_InputPriTextField:setVisible(false)
		m_InputPriTextField:setTouchEnabled(false)
	end
end

function ResetCLippingType()
	if m_ChatPanel == nil then
		return
	end
	local Image_Bg	     = tolua.cast(m_ChatPanel:getWidgetByName("Image_ChatBg"), "ImageView")

	local Panel_World	 = tolua.cast(m_ChatPanel:getWidgetByName("Panel_1"), "Layout")
	local pChatWorldList = tolua.cast(Panel_World:getChildByName("ListView_1"), "ListView")
	if pChatWorldList ~= nil then pChatWorldList:setClippingType(1) end

	local Panel_Guild	 = tolua.cast(m_ChatPanel:getWidgetByName("Panel_2"), "Layout")
	local pChatGuildList = tolua.cast(Panel_Guild:getChildByName("ListView_2"), "ListView")
	if pChatGuildList ~= nil then pChatGuildList:setClippingType(1) end

	local Panel_Team	 = tolua.cast(m_ChatPanel:getWidgetByName("Panel_3"), "Layout")
	local pChatTeamList = tolua.cast(Panel_Team:getChildByName("ListView_3"), "ListView")
	if pChatTeamList ~= nil then pChatTeamList:setClippingType(1) end

	local Panel_Private	 = tolua.cast(m_ChatPanel:getWidgetByName("Panel_4"), "Layout")
	local pChatPriList = tolua.cast(Panel_Private:getChildByName("ListView_4"), "ListView")
	if pChatPriList ~= nil then pChatPriList:setClippingType(1) end
	pChatWorldList:jumpToBottom()
	pChatGuildList:jumpToBottom()
	pChatTeamList:jumpToBottom()
	pChatPriList:jumpToBottom()

end

local function _Click_AddCorps_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		m_ChatPanel:removeFromParentAndCleanup(false)
		CorpsLayer.CreateCorpsLayer(E_Corps_Type.E_Corps_Add)
	end
end


local function InitChatPanelState(nCurrentType)
	local Panel_World	  = tolua.cast(m_ChatPanel:getWidgetByName("Panel_1"), "Layout")
	local Panel_Guild	  = tolua.cast(m_ChatPanel:getWidgetByName("Panel_2"), "Layout")
	local Panel_Team	  = tolua.cast(m_ChatPanel:getWidgetByName("Panel_3"), "Layout")
	local Panel_Private	  = tolua.cast(m_ChatPanel:getWidgetByName("Panel_4"), "Layout")
	local Image_Bg	      = tolua.cast(m_ChatPanel:getWidgetByName("Image_ChatBg"), "ImageView")		

    m_LabelFree           = tolua.cast(Image_Bg:getChildByName("Label_Free"),"Label")
	m_LabelNum            = tolua.cast(Image_Bg:getChildByName("Label_num"),"Label")	
	m_labelCoolTime       = tolua.cast(Image_Bg:getChildByName("Label_cool"),"Label")
	m_labelTime           = tolua.cast(Image_Bg:getChildByName("Label_time"),"Label")

	word_line = tolua.cast(m_ChatPanel:getWidgetByName("Image_9"),"ImageView")
	word_line:setVisible(false)

	Panel_World:setVisible(false)
	Panel_World:setTouchEnabled(false)
	Panel_World:setZOrder(2)
	Panel_Guild:setVisible(false)
	Panel_Guild:setTouchEnabled(false)
	Panel_Guild:setZOrder(2)
	Panel_Team:setVisible(false)
	Panel_Team:setTouchEnabled(false)
	Panel_Team:setZOrder(2)
	Panel_Private:setVisible(false)
	Panel_Private:setTouchEnabled(false)
	Panel_Private:setZOrder(2)
	m_LabelFree:setVisible(false)
	m_LabelNum:setVisible(false)
	m_labelCoolTime:setVisible(false)
	m_labelTime:setVisible(false)
	      
	local isCorps = tonumber(server_mainDB.getMainData("nCorps"))
    local guildSize = Panel_Guild:getSize()

	if nCurrentType == E_CHAT_TYPE.E_CHAT_WORLD then
		Panel_World:setVisible(true)
		Panel_World:setTouchEnabled(true)
		Panel_World:setZOrder(5)
		m_LabelNum:setVisible(true)
		m_LabelFree:setVisible(true)		
		m_CurrentType = E_CHAT_TYPE.E_CHAT_WORLD
		local free_num = server_mainDB.getMainData("ChatNum")
        m_LabelNum:setText(free_num)	
       	word_line:setVisible(true)
       	local itemID = GetConsumItem()  
		local consumName = GetConsumName(itemID)
       	if tonumber(free_num) <= 0 then
       		m_LabelFree:setText("发言消耗：")
			m_LabelNum:setText(consumName)
       	end
		Log("show world Chat")	
	elseif nCurrentType == E_CHAT_TYPE.E_CHAT_GUILD then
		Panel_Guild:setVisible(true)
		Panel_Guild:setTouchEnabled(true)
		Panel_Guild:setZOrder(5)
		m_CurrentType = E_CHAT_TYPE.E_CHAT_GUILD
		if isCorps > 0 then
			m_labelCoolTime:setVisible(false)
			m_labelTime:setVisible(false)
		else
			m_labelCoolTime:setVisible(false)
			m_labelTime:setVisible(false)
   		end
		isSend = true
		
		Log("show guild Chat")	
	elseif nCurrentType == E_CHAT_TYPE.E_CHAT_TEAM then
		Panel_Team:setVisible(true)
		Panel_Team:setTouchEnabled(true)
		Panel_Team:setZOrder(5)
		m_CurrentType = E_CHAT_TYPE.E_CHAT_TEAM
		m_labelCoolTime:setVisible(false)
		m_labelTime:setVisible(false)
		isSend = true
		Log("show team Chat")	
	elseif nCurrentType == E_CHAT_TYPE.E_CHAT_PRIVATE then
		Panel_Private:setVisible(true)
		Panel_Private:setTouchEnabled(true)
		Panel_Private:setZOrder(5)
		m_CurrentType = E_CHAT_TYPE.E_CHAT_PRIVATE	
		m_labelCoolTime:setVisible(false)
		m_labelTime:setVisible(false)
		isSend = true	
		Log("show private Chat")	
	end		

	ResetCLippingType()
end

function CheckBoxState( nCurrentIndex )
	InitStatus()
	-- m_InputTextField:setPosition(ccp(200,550))
	if nCurrentIndex == E_CHAT_TYPE.E_CHAT_WORLD then
		--当前显示世界聊天页面
		m_BoxChatWorld:setSelectedState(true)
		m_BoxChatWorld:setZOrder(2)
		m_InputTextField:setText("")	
		m_InputTextField:setVisible(true)
		m_InputTextField:setTouchEnabled(true)					
	elseif nCurrentIndex == E_CHAT_TYPE.E_CHAT_GUILD then
		--当前显示帮会聊天页面
		m_BoxChatGuild:setSelectedState(true)
		m_BoxChatGuild:setZOrder(2)	
		m_InputTextField:setText("")	
		m_InputTextField:setVisible(true)
		m_InputTextField:setTouchEnabled(true)				
	elseif nCurrentIndex == E_CHAT_TYPE.E_CHAT_TEAM then
		--当前显示队伍聊天页面
		m_BoxChatTeam:setSelectedState(true)	
		m_BoxChatTeam:setZOrder(2)	
		m_InputTextField:setText("")
		m_InputTextField:setVisible(true)
		m_InputTextField:setTouchEnabled(true)	
	elseif nCurrentIndex == E_CHAT_TYPE.E_CHAT_PRIVATE then
		--当前显示私聊页面
		m_BoxChatPrivate:setSelectedState(true)	
		m_BoxChatPrivate:setZOrder(2)
		m_ContentBg:setSize(CCSizeMake(460,510))
		m_InputTextField:setText("")
		if m_InputNameTextField~=nil and m_InputPriTextField ~= nil  then --
			m_InputNameTextField:setVisible(true)
			m_InputNameTextField:setTouchEnabled(true)
			m_InputPriTextField:setVisible(true)
			m_InputPriTextField:setTouchEnabled(true)
			m_InputTextField:setVisible(false)
			m_InputTextField:setTouchEnabled(false)
		end
	end
	m_CurrentType = nCurrentIndex
	InitChatPanelState(nCurrentIndex)
end

function SetPrivateName( nName )
	if m_InputPriTextField ~= nil then
		m_InputNameTextField:setText(nName)
	end
end

local function _Click_Show_GamerInfo_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		--sender:setScale(1.0)
		AudioUtil.PlayBtnClick()
		local function ShowGamerInfo()
			local currDB = GetGamerInfo()
			if currDB.name == GetUserName() then
				Log("click yourself")
			else
				local function ReceiveOver( nAction )
					if nAction then
						--去私聊
						m_CurrentType = E_CHAT_TYPE.E_CHAT_PRIVATE
						CheckBoxState(m_CurrentType) 
						m_InputNameTextField:setText(currDB.name)
					else
						--加为好友
						Log("add my Friendsssssss !!")
					end
				end
				TipLayer.createGamerInfoLayer(currDB,ReceiveOver)
			end
		end
		Packet_GetGamerInfo.SetSuccessCallBack(ShowGamerInfo)
		network.NetWorkEvent(Packet_GetGamerInfo.CreatPacket(sender:getTag()))
	elseif  eventType == TouchEventType.began then
		--sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		--sender:setScale(1.0)
	end
end


local function CreateMessItemWidget( pMessItemTemp )
    local pMessItem = pMessItemTemp:clone()
    local peer = tolua.getpeer(pMessItemTemp)
    tolua.setpeer(pMessItem, peer)
    return pMessItem
end


local function CreateTalkMessage(pMessItem,messData,pParentList,nType)
	local color = ""
	if messData.SenderName == GetUserName() then	
		color = "|color|51,22,5||size|20|" --255,182,91
	else
		color = "|color|159,49,37||size|20|"  --255,232,173
	end
	--add Head
	
	local Image_Info	= tolua.cast(pMessItem:getChildByName("Image_HeroInfo"), "ImageView")
	Image_Info:setScale(0.45)
	if tonumber(messData.ColorType) == 1 then
		Image_Info:loadTexture(SYSTEMIMG)
		Image_Info:setScale(1)
		if tonumber(messData.ChatType) == 1 then
			color = "|color|216,26,26||size|20|"
		else
			color = "|color|51,22,5||size|20|"
		end
	else
		if tonumber(messData.ChannelID) == 0 then
			Image_Info:loadTexture(SYSTEMIMG)
			Image_Info:setScale(1)
		else
			UIInterface.MakeHeadIcon(Image_Info,ICONTYPE.DISPLAY_ICON,nil,nil,nil,messData.ResIMGID,7)
		end
	end
	

	Image_Info:addTouchEventListener(_Click_Show_GamerInfo_CallBack)
	Image_Info:setTag(messData.SenderID)
	
	local nTimeDB = os.date("*t", messData.Time)
	if tonumber(nTimeDB.min) < 10 then
		nTimeDB.min = "0"..nTimeDB.min
	end
	local nTimeStr = nTimeDB.hour..":"..nTimeDB.min

	local nNameStr = ""
	if nType == E_CHAT_TYPE.E_CHAT_PRIVATE then
		if messData.SenderName == GetUserName() then
			nNameStr = "       对 "..m_InputNameTextField:getText().."说:"
		else
			nNameStr = messData.SenderName
		end
	else
		nNameStr = messData.SenderName
	end
	-- local StrokeLabel_Level = StrokeLabel_createStrokeLabel(20, CommonData.g_FONT1, "Lv."..messData.Level, ccp(-25, -45), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
	local StrokeLabel_Level = Label:create()
	StrokeLabel_Level:setPosition(ccp(-50,-45))
	StrokeLabel_Level:setFontSize(18)
	StrokeLabel_Level:setName("LabelNum")
	StrokeLabel_Level:setAnchorPoint(ccp(0, 0.5))
	StrokeLabel_Level:setText("Lv."..messData.Level)
	-- nGamerInfoBg:addChild(StrokeLabel_Level)

	local StrokeLabel_Name = Label:create()
	StrokeLabel_Name:setFontSize(20)
	StrokeLabel_Name:setFontName(CommonData.g_FONT3)
	StrokeLabel_Name:setColor(ccc3(151,49,37))
	StrokeLabel_Name:setPosition(ccp(120, 80))
	StrokeLabel_Name:setText(nNameStr)

	local StrokeLabel_Time = Label:create()
	StrokeLabel_Time:setFontSize(20)
	StrokeLabel_Time:setFontName(CommonData.g_FONT1)
	StrokeLabel_Time:setColor(ccc3(151,49,37))
	StrokeLabel_Time:setPosition(ccp(340, 80))
	StrokeLabel_Time:setText(nTimeStr)


	--富文本添加
	
	local richText = RichLabel.Create(color..messData.ChatMsg,320,nil,nil,1)
	richText:setPosition(ccp(StrokeLabel_Name:getPositionX() - 30,StrokeLabel_Name:getPositionY() - StrokeLabel_Time:getSize().height )) --  - 15
	local beginHeight = pMessItem:getSize().height - richText:getSize().height
	local richTextHeight = richText:getSize().height
	if richTextHeight > 40 then
		pMessItem:setSize(CCSizeMake(pMessItem:getSize().width,pMessItem:getSize().height +richTextHeight - 40))--+ 
	end

	local oldPosX = Image_Info:getPositionX()
	local oldNamePosX = StrokeLabel_Name:getPositionX()
	if messData.SenderName == GetUserName() then	
		Image_Info:setPositionX(pMessItem:getSize().width - Image_Info:getSize().width * 0.7)
		local function changePosX( pSender )
			pSender:setPositionX(oldPosX - Image_Info:getSize().width * 0.4)
		end  
		local function changePosXx( pSender )
			pSender:setPositionX(oldPosX )
		end
		changePosXx(StrokeLabel_Name)
		changePosX(richText)
		local diffX = oldNamePosX - StrokeLabel_Name:getPositionX()
		StrokeLabel_Time:setPositionX(StrokeLabel_Time:getPositionX() - diffX)
	end

	--分界线
	local pImgLine = ImageView:create()
	pImgLine:loadTexture("Image/imgres/chat/cutLine.png")
	pImgLine:setAnchorPoint(ccp(0,0))
	pImgLine:setScaleX(2.0)
	pImgLine:setOpacity(60)
	pImgLine:setPosition(ccp(0,0))
	local richHeight  = richTextHeight - 40
	if richTextHeight > 40 then
		StrokeLabel_Name:setPosition(ccp(StrokeLabel_Name:getPositionX(),StrokeLabel_Name:getPositionY()+richHeight))
		StrokeLabel_Time:setPosition(ccp(StrokeLabel_Time:getPositionX(),StrokeLabel_Time:getPositionY()+richHeight))
		Image_Info:setPosition(ccp(Image_Info:getPositionX(),Image_Info:getPositionY() +richHeight))
		richText:setPosition(ccp(richText:getPositionX(),richText:getPositionY() +richHeight))
	end
	pMessItem:addChild(StrokeLabel_Name)
	pMessItem:addChild(StrokeLabel_Time)
	pMessItem:addChild(richText)
	pMessItem:addChild(pImgLine)
	StrokeLabel_Level:setScale(1.4)
	if tonumber(messData.ChannelID) ~= 0 then
		if tonumber(messData.ColorType) == 0 then
			Image_Info:addChild(StrokeLabel_Level,1001)
		end
	end

	local messNumArr = pParentList:getItems()
	local messNums = messNumArr:count()
	--print("messNums = "..messNums)
	
	if messNums > 49 then
		Log("Del First Mess")
		pParentList:removeItem(0)
	end

	pParentList:pushBackCustomItem(pMessItem)
	--m_MessDBID = m_MessDBID + 1
	m_ListInnerHeight = m_ListInnerHeight + pMessItem:getSize().height
	pParentList:setInnerContainerSize(CCSizeMake(pParentList:getInnerContainerSize().width,m_ListInnerHeight))
	--pParentList:scrollToBottom(0.2,true)
	pParentList:jumpToBottom()
	--pParentList:jumpToTop()

end

function LoadList(nMessDB)
	if m_ChatPanel == nil then
		return 
	end
	local data  		= nMessDB
	local nType 		= nMessDB.ChannelID
	if nType == "0" then nType = "1" end
	local Image_Bg	    = tolua.cast(m_ChatPanel:getWidgetByName("Image_ChatBg"), "ImageView")
	local Panel_Chat	= tolua.cast(m_ChatPanel:getWidgetByName("Panel_"..nType), "Layout")
	local pChatList 	= tolua.cast(Panel_Chat:getChildByName("ListView_"..nType), "ListView")
	if pChatList ~= nil then
		pChatList:setClippingType(1)
	end

	local pMessItemTemp = GUIReader:shareReader():widgetFromJsonFile("Image/TalkMessLayer.json")
	local pMessItem = CreateMessItemWidget(pMessItemTemp)
	CreateTalkMessage(pMessItem,data,pChatList,nType)
end

function CountSendText( str )   
	--计算当前发送的字如果超过30个字就切掉，只发送前30个
    local list = {}
    local len = string.len(str)
    local i = 1 
    while i <= len do
        local c = string.byte(str, i)
        local shift = 1
        if c > 0 and c <= 127 then
            shift = 1
        elseif (c >= 192 and c <= 223) then
            shift = 2
        elseif (c >= 224 and c <= 239) then
            shift = 3
        elseif (c >= 240 and c <= 247) then
            shift = 4
        end
        local char = string.sub(str, i, i+shift-1)
        i = i + shift
        table.insert(list, char)
    end
    return list, len	
end

function SendMessageSpace( m_SendMessSpaceNums )
	if m_ChatPanel == nil then
		return
	end
	sendTime = m_SendMessSpaceNums
	local function tick( dt )

		m_SendMessSpaceNum = m_SendMessSpaceNum + 1
		sendTime = sendTime - 1
		if m_SendMessSpaceNum >= SendMessSpaceMaxNum  then
			--大于60s停止计时，可发送
			m_ChatPanel:getScheduler():unscheduleScriptEntry(m_nHanderTime)
			m_nHanderTime = nil
			isSend = true
			m_SendMessSpaceNum = 0
			
		end
		if m_CurrentType == E_CHAT_TYPE.E_CHAT_WORLD then
			if sendTime > 0 then
				m_labelCoolTime:setVisible(true)   
				m_labelTime:setVisible(true)     		        		
     			m_labelTime:setText(string.format("%d",sendTime)) 
     		elseif sendTime <= 0 then
     			m_labelCoolTime:setVisible(false)
     			m_labelTime:setVisible(false)
     			sendTime = 0
			end
		end		 
	end
	if m_nHanderTime == nil then
		m_nHanderTime = m_ChatPanel:getScheduler():scheduleScriptFunc(tick, 1, false)
	end		
end

--发送函数
local function _Click_SendMessageFace_CallBack()  
	local n_chatType = 0
	if m_CurrentType == E_CHAT_TYPE.E_CHAT_WORLD then
		n_chatType = 1
	elseif m_CurrentType == E_CHAT_TYPE.E_CHAT_TEAM then
		n_chatType = 2
	elseif m_CurrentType == E_CHAT_TYPE.E_CHAT_GUILD then
		n_chatType = 3
	elseif m_CurrentType == E_CHAT_TYPE.E_CHAT_PRIVATE then
		n_chatType = 4
	end
	if m_CurrentType ~= E_CHAT_TYPE.E_CHAT_PRIVATE then		
		if m_InputTextField:getText() == "" then
			server_ChatDB.errorTip(1104)
			return
		end
	else
		if m_InputNameTextField:getText() == ""  and m_InputPriTextField:getText() == "" then --
			server_ChatDB.errorTip(1104)
			return 
		end
	end
	if m_CurrentType == E_CHAT_TYPE.E_CHAT_WORLD then
		local ConsumNum = GetConsumInfo()
		local free_nums = server_mainDB.getMainData("ChatNum")
		if tonumber(free_nums) <= 0 then
			if tonumber(ConsumNum) <= 0 then
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1023,nil)
				pTips = nil
				return 
			end
		end
	end
	local inputText = nil
	if m_CurrentType == E_CHAT_TYPE.E_CHAT_PRIVATE then
		inputText = m_InputPriTextField:getText()
	else
		inputText = m_InputTextField:getText()
	end
		
	local list,len = CountSendText(inputText)
	local nCutStr = ""
	local nMaxNum = table.getn(list)
	if nMaxNum >= 30 then
		for i=1,30 do
			nCutStr = nCutStr..list[i]
		end
	else
		nCutStr = inputText
	end
	m_InputTextField:setText(nCutStr)
	if m_CurrentType == E_CHAT_TYPE.E_CHAT_GUILD then
		local is_Corps = server_mainDB.getMainData("nCorps")
		if tonumber(is_Corps) > 0 then
			m_InputTextField:setText("")
			local n_MessDB = {}
			local cur_time = os.time()
			n_MessDB["ChannelID"] = 2
			n_MessDB["SenderID"] = server_mainDB.getMainData("nHeadID")
			n_MessDB["SenderName"] = server_mainDB.getMainData("name")
			n_MessDB["VIPLevel"] = server_mainDB.getMainData("vip")
			n_MessDB["Level"] = server_mainDB.getMainData("level")
			n_MessDB["Time"] = cur_time
			n_MessDB["ResIMGID"] = server_mainDB.getMainData("nHeadID")
			n_MessDB["Color"] = 0
			n_MessDB["ChatMsg"] = nCutStr
			LoadList(n_MessDB)
			ChatShowLayer.UpDateChatList(n_MessDB)
		else  
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1060,nil)
			pTips = nil
			return
		end
	end
	local function SendSuccess()	    
		local messDB = GetChatListData()
		m_InputTextField:setText("")
		m_InputPriTextField:setText("")
		--发送完毕开启计时
		SendFreeNum = server_mainDB.getMainData("ChatNum")
		if m_CurrentType == E_CHAT_TYPE.E_CHAT_WORLD then
			if tonumber(SendFreeNum) > 0 then
				isSend = false
				-- if isSend == false then SendMessageSpace(nil) end	
			end
		end
				            
		-- --免费发送次数及使用完后显示所消耗      
		  
		local itemID = GetConsumItem()  
		local consumName = GetConsumName(itemID)

		m_LabelNum:setText(SendFreeNum) 
		if tonumber(SendFreeNum) <= 0 then
			m_LabelFree:setText("发言消耗：")
			m_LabelNum:setText(consumName)
		end  
    		
	end
	Packet_GetChatInfo.SetSuccessCallBack(SendSuccess)
	if m_CurrentType == E_CHAT_TYPE.E_CHAT_PRIVATE then 
	--私聊的时候 
		local nReceiveName = m_InputNameTextField:getText()
		local nNamelist,nNamelen = CountSendText(nReceiveName)
		local nNameMaxNum = table.getn(list)
		local nNameCutStr = m_InputPriTextField:getText()
		
		network.NetWorkEvent(Packet_GetChatInfo.CreatPacket(m_CurrentType,nReceiveName,nNameCutStr))
	else
		
		network.NetWorkEvent(Packet_GetChatInfo.CreatPacket(m_CurrentType,"",nCutStr))	--sender:getTag()-nCurStr
	end
	nfaceId = 1                                    	
end

function GetPrivateName()
	local receiveName = m_InputNameTextField:getText()
	if receiveName ~= "" then
		return receiveName
	else
		Log("none Private Chat Gamer")
	end
end

local function _Btn_ClickType_ChatType_CallBack(sender,eventType)
	AudioUtil.PlayBtnClick()
	local ChatType_Sender = tolua.cast(sender,"CheckBox")
	CheckBoxState(ChatType_Sender:getTag()) 
end

function ReceiveContentInput( str) 		
	m_InputTextField:setText(str) 
	m_InputPriTextField:setText(str)	
 	ChatFaceLayer.SetEditName(str)		
end  

function SendInput( )	     
	_Click_SendMessageFace_CallBack()    	
end
--加载表情画布
local function ChatFaceShow_CallBack(sender,eventType )    
	if eventType == TouchEventType.ended then	       
		AudioUtil.PlayBtnClick()
		local str = m_InputTextField:getText()      
		ChatFaceLayer.createFaceTipLayer(m_InputTextField,str,ReceiveContentInput,SendInput)   	    	
    end
end

--Init Widgets
local function InitChatWidgets(nCurrentType)
	local nOff_W = CommonData.g_nDeginSize_Width - CommonData.g_sizeVisibleSize.width
	local nOff_H = CommonData.g_nDeginSize_Height - CommonData.g_sizeVisibleSize.height
	local nOff_X = CommonData.g_Origin.x
	local nOff_Y = CommonData.g_Origin.y

	local Image_Bg	   = tolua.cast(m_ChatPanel:getWidgetByName("Image_ChatBg"), "ImageView")
	local Image_SendMess = tolua.cast(Image_Bg:getChildByName("Image_SendMessage"), "ImageView")
	m_ContentBg = tolua.cast(m_ChatPanel:getWidgetByName("Image_ContentBg"), "ImageView")
	Image_Bg:setZOrder(0)

	m_BoxChatWorld     = tolua.cast(m_ChatPanel:getWidgetByName("Box_Chat_World"), "CheckBox")
	m_BoxChatGuild	   = tolua.cast(m_ChatPanel:getWidgetByName("Box_Chat_Guild"), "CheckBox")
	m_BoxChatTeam  	   = tolua.cast(m_ChatPanel:getWidgetByName("Box_Chat_Team"), "CheckBox")
	m_BoxChatPrivate   = tolua.cast(m_ChatPanel:getWidgetByName("Box_Chat_Private"), "CheckBox")

	Image_Bg:setPosition(ccp(Image_Bg:getPositionX() ,Image_Bg:getPositionY() ))
	m_BoxChatWorld:setPosition(ccp(m_BoxChatWorld:getPositionX() ,m_BoxChatWorld:getPositionY()))
	m_BoxChatGuild:setPosition(ccp(m_BoxChatGuild:getPositionX(),m_BoxChatGuild:getPositionY() ))
	m_BoxChatTeam:setPosition(ccp(m_BoxChatTeam:getPositionX() ,m_BoxChatTeam:getPositionY() ))
	m_BoxChatPrivate:setPosition(ccp(m_BoxChatPrivate:getPositionX() ,m_BoxChatPrivate:getPositionY() ))

	m_BoxChatWorld:setTag( E_CHAT_TYPE.E_CHAT_WORLD)
	m_BoxChatGuild:setTag( E_CHAT_TYPE.E_CHAT_GUILD)
	m_BoxChatTeam:setTag( E_CHAT_TYPE.E_CHAT_TEAM)
	m_BoxChatPrivate:setTag( E_CHAT_TYPE.E_CHAT_PRIVATE)

	m_BoxChatWorld:addEventListenerCheckBox(_Btn_ClickType_ChatType_CallBack)
	m_BoxChatGuild:addEventListenerCheckBox(_Btn_ClickType_ChatType_CallBack)
	m_BoxChatTeam:addEventListenerCheckBox(_Btn_ClickType_ChatType_CallBack)
	m_BoxChatPrivate:addEventListenerCheckBox(_Btn_ClickType_ChatType_CallBack)

	
	local pWorldText = Label:create()
	pWorldText:setFontSize(30)
	pWorldText:setFontName(CommonData.g_FONT1)
	pWorldText:setColor(ccc3(127,55,35))
	pWorldText:setText("世界")

	local pGuildText = Label:create()
	pGuildText:setFontSize(30)
	pGuildText:setFontName(CommonData.g_FONT1)
	pGuildText:setColor(ccc3(127,55,35))
	pGuildText:setText("军团")

	local pTeamText = Label:create()
	pTeamText:setFontSize(30)
	pTeamText:setFontName(CommonData.g_FONT1)
	pTeamText:setColor(ccc3(127,55,35))
	pTeamText:setText("国家")

	local pPrivateText = Label:create()
	pPrivateText:setFontSize(30)
	pPrivateText:setFontName(CommonData.g_FONT1)
	pPrivateText:setColor(ccc3(127,55,35))
	pPrivateText:setText("私聊")

	m_BoxChatWorld:addChild(pWorldText)
	m_BoxChatGuild:addChild(pGuildText)
	m_BoxChatTeam:addChild(pTeamText)
	m_BoxChatPrivate:addChild(pPrivateText)


	--添加表情
	local pFace = tolua.cast(m_ChatPanel:getWidgetByName("Button_Expression"), "Button") 
	pFace:addTouchEventListener(ChatFaceShow_CallBack)

	InitChatPanelState(nCurrentType)
end

local function InitEditBox()
	--输入框消息响应
	local scenetemp = CCDirector:sharedDirector():getRunningScene()
	local temp  = scenetemp:getChildByTag(layerChatFaceTag)
	local nTopNum = 0
	local edit = nil
	local function editBoxTextEventHandle(strEventName,pSender)
		edit = tolua.cast(pSender,"CCEditBox")
		if strEventName == "began" then	
			-- print("began")
		elseif strEventName == "ended" then	
			-- print("ended")
		elseif strEventName == "return" then
			-- print("return")
	  	    _Click_SendMessageFace_CallBack()      	    			
		elseif strEventName == "changed" then	
			-- print("changed")
		end
	end
    
	--昵称输入框
	m_InputNameTextField = CCEditBox:create(CCSizeMake(140,50),CCScale9Sprite:create("Image/imgres/chat/Box_chat.png"))
	m_InputNameTextField:setPosition(ccp(90 ,547))
	m_InputNameTextField:setMaxLength(20)
	m_InputNameTextField:setPlaceholderFontColor(ccc3(147,54,33))
	m_InputNameTextField:setPlaceholderFontSize(18)
	m_InputNameTextField:setFontColor(ccc3(75,46,31))
	m_InputNameTextField:setFontSize(20)
	m_InputNameTextField:setReturnType(kKeyboardReturnTypeSend)
	m_InputNameTextField:setInputFlag(kEditBoxInputFlagInitialCapsWord)
	m_InputNameTextField:setInputMode(kEditBoxInputModeSingleLine)
	m_InputNameTextField:registerScriptEditBoxHandler(editBoxTextEventHandle)
	m_InputNameTextField:setTouchPriority(0)
	m_InputNameTextField:setPlaceHolder("私聊昵称")
	if m_ChatPanel:getChildByTag(201)~=nil then
		m_ChatPanel:getChildByTag(201):setVisible(false)
		m_ChatPanel:getChildByTag(201):removeFromParentAndCleanup(true)
	end
	m_InputNameTextField:setFontName(CommonData.g_FONT3)
	m_ChatPanel:addChild(m_InputNameTextField,0,201)    

    --私聊输入框
	m_InputPriTextField = CCEditBox:create(CCSizeMake(240,50),CCScale9Sprite:create("Image/imgres/chat/Box_chat.png"))--370
	m_InputPriTextField:setPosition(ccp(280 ,547))
	m_InputPriTextField:setMaxLength(30)
	m_InputPriTextField:setPlaceholderFontColor(ccc3(117,159,139))
	m_InputPriTextField:setPlaceholderFontSize(20)
	m_InputPriTextField:setFontColor(ccc3(51,22,5))
	m_InputPriTextField:setFontSize(24)
	m_InputPriTextField:setReturnType(kKeyboardReturnTypeSend)
	m_InputPriTextField:setInputFlag(kEditBoxInputFlagInitialCapsWord)
	m_InputPriTextField:setInputMode(kEditBoxInputModeSingleLine)
	m_InputPriTextField:registerScriptEditBoxHandler(editBoxTextEventHandle)
	m_InputPriTextField:setTouchPriority(0)
	m_InputPriTextField:setFontName(CommonData.g_FONT3)
	m_InputPriTextField:setPlaceHolder("最多可输入51个字")
	if m_ChatPanel:getChildByTag(202)~=nil then
		m_ChatPanel:getChildByTag(202):setVisible(false)
		m_ChatPanel:getChildByTag(202):removeFromParentAndCleanup(true)
	end	
	m_ChatPanel:addChild(m_InputPriTextField,0,202)

	--世界军团国家消息发送框	
	m_InputTextField = CCEditBox:create(CCSizeMake(370,50),CCScale9Sprite:create("Image/imgres/chat/Box_chat.png"))--370
	m_InputTextField:setPosition(ccp(200 ,547))
	m_InputTextField:setMaxLength(30)
	m_InputTextField:setPlaceholderFontColor(ccc3(117,159,139))
	m_InputTextField:setPlaceholderFontSize(20)
	m_InputTextField:setFontColor(ccc3(51,22,5))
	m_InputTextField:setFontSize(24)
	m_InputTextField:setReturnType(kKeyboardReturnTypeSend)
	m_InputTextField:setInputFlag(kEditBoxInputFlagInitialCapsWord)
	m_InputTextField:setInputMode(kEditBoxInputModeSingleLine)
	m_InputTextField:registerScriptEditBoxHandler(editBoxTextEventHandle)
	m_InputTextField:setTouchPriority(0)
	m_InputTextField:setPlaceHolder("最多可输入51个字")
	m_InputTextField:setFontName(CommonData.g_FONT3)
	if m_ChatPanel:getChildByTag(200)~=nil then
		m_ChatPanel:getChildByTag(200):setVisible(false)
		m_ChatPanel:getChildByTag(200):removeFromParentAndCleanup(true)
	end	
	m_ChatPanel:addChild(m_InputTextField,0,200)
	
end

local function _Button_Action_ChatLayer_CallBack( )
	--local pBtnAction = tolua.cast(m_ChatPanel:getWidgetByName("Button_Chat_Action"), "Button")
end

--create entrance
function CreateChatLayer(nIndex)
	InitVars()
	m_ChatPanel = TouchGroup:create()
	m_ChatPanel:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/ChatLayer.json"))

	m_ChatPanel:setPosition(ccp(m_ChatPanel:getPositionX() + CommonData.g_Origin.x,0))
	 
    --根据传进来的nIndex来决定当前打开哪个类型的页面
    local pBoxCurrent_Type = nIndex
    m_CurrentType = pBoxCurrent_Type
    --初始化页面
	InitChatWidgets(pBoxCurrent_Type)
    --返回按钮
    local pBtnReturn = tolua.cast(m_ChatPanel:getWidgetByName("Image_Return"), "ImageView")
    pBtnReturn:addTouchEventListener(_Click_Return_ChatLayer_CallBack)
	--初始化輸入框
	InitEditBox()
    --检测当前聊天类型
	CheckBoxState(pBoxCurrent_Type)

    -- m_ChatPanel:setTouchPriority(-288)
 
	return m_ChatPanel
end