require "Script/Common/Common"
require "Script/Main/Mail/MailData"
require "Script/Main/Mail/MailLogic"

module("MailLayer", package.seeall)

local m_MailId = nil
local m_BgMail = nil
local m_BgMailItem = nil
local m_BgMailContent = nil
local m_CurrentStatus = nil

local function InitVars()
	m_MailId = nil
	m_BgMail = nil
	m_BgMailItem = nil
	m_BgMailContent = nil
	m_CurrentStatus = nil
end

--local JudgeMailIsOverFlow  			= MailLogic.SystemAutoDelete
local SortMailList					= MailLogic.SortMailList
local DateFormatConversion			= MailLogic.DateFormatConversion
local UpdateMailItemShowStatus		= MailLogic.UpdateMailItemShowStatus
local removeSingerMail				= MailLogic.RemoveSingerMail
local UpdateListItem				= MailLogic.UpdateListItem
local ShowGoodsLayer				= MailLogic.ShowGoodsLayer

local GetMailDataContent			= MailData.GetMailInfo
local GetMailDataReward				= MailData.GetSingerMainRewardInfo
local GetMainDataChild				= MailData.GetMainDataChild
local GetMailHeadIcon				= MailData.GetItemHeadIcon
local judgeMailBoxStatus			= MailData.judgeMailBoxStatus


local createTimeLayer				= TipLayer.createTimeLayer
local secondNum = 2
--Return Main

--copy item
local function CreateMailItemWidget( pMailItemTemp )
    local pMailItem = pMailItemTemp:clone()
    local peer = tolua.getpeer(pMailItemTemp)
    tolua.setpeer(pMailItem, peer)
    return pMailItem
end

local function _Button_Return_MailLayer_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
        --刷新邮件数据
        sender:setScale(1.0)
        local function refreshOver()
        	--刷新主城信箱
        	if m_CurrentStatus == true	then	--如果邮箱初始状态为有未读邮件
				local mailBoxStatus = judgeMailBoxStatus()
				if mailBoxStatus then
					print("还有未读邮件，不刷新")
				else
					if MainScene.GetControlUI() ~= nil then
						MainScene.ClearMailPromptBtn()
					end
				end
			else
				print("邮箱状态没有未读邮件不需要刷新")
			end
			m_BgMail:removeFromParentAndCleanup(true)
   			InitVars()
        	MainScene.PopUILayer()
        end
        refreshOver()
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function UpdateMailItemStatus( pMailItemImg,mailStatus)
	local pSpriteMailItem = tolua.cast(pMailItemImg:getVirtualRenderer(), "CCScale9Sprite")

	local pMailItemFigure = tolua.cast(pMailItemImg:getChildByName("MailItem_Figure"), "ImageView")
	local pSpriteMailFigure = tolua.cast(pMailItemFigure:getVirtualRenderer(), "CCSprite")

	local pMailItemLogo = tolua.cast(pMailItemImg:getChildByName("MailItem_Logo"), "ImageView")
	local pSpriteMailLogo = tolua.cast(pMailItemLogo:getVirtualRenderer(), "CCSprite")

	local pMailItemLine = tolua.cast(pMailItemImg:getChildByName("MailItem_Line"), "ImageView")
	local pSpriteMailLine = tolua.cast(pMailItemLine:getVirtualRenderer(), "CCSprite")
	
	local pMailHead = tolua.cast(pMailItemImg:getChildByName("MailItem_Head"), "Layout")
	local pMailItemHeadImg = tolua.cast(pMailHead:getChildByName("Image_MailHead"), "ImageView")
	local pSpriteMailHeadImg = tolua.cast(pMailItemHeadImg:getVirtualRenderer(), "CCSprite")

	if mailStatus == true then 
	SpriteSetGray(pSpriteMailFigure,1)
	SpriteSetGray(pSpriteMailLogo,1)
	SpriteSetGray(pSpriteMailLine,1)
	SpriteSetGray(pSpriteMailHeadImg,1)
	Scale9SpriteSetGray(pSpriteMailItem,1)
	else
	SpriteSetGray(pSpriteMailFigure,0)
	SpriteSetGray(pSpriteMailLogo,0)
	SpriteSetGray(pSpriteMailLine,0)
	SpriteSetGray(pSpriteMailHeadImg,0)
	Scale9SpriteSetGray(pSpriteMailItem,0)
	end

end

local function InitItemWidgets(pItemParent,pData,mailIndex)
		--邮件内容设置
		local pMailDataSingle = pData[mailIndex]
		local m_MailList= tolua.cast(m_BgMail:getWidgetByName("ListView_Mail"), "ListView")
		if m_MailList ~= nil then m_MailList:setClippingType(1) end
		local pMailItemImg =  tolua.cast(pItemParent:getChildByName("mail_Item"), "ImageView")	
		pMailItemImg:setTag(100 + mailIndex)
		local pMailItemTitle  = tolua.cast(pMailItemImg:getChildByName("MailItem_Title"), "Label")
		pMailItemTitle:setText(pMailDataSingle["Title"])

		local pMailItemSender = tolua.cast(pMailItemImg:getChildByName("MailItem_Sender"), "Label")
		pMailItemSender:setText(pMailDataSingle["SenderName"])

		local strDate = DateFormatConversion(pMailDataSingle)
		local pMailItemDate = tolua.cast(pMailItemImg:getChildByName("MailItem_Date"), "Label")
		pMailItemDate:setText(strDate)

		local pMailHead = tolua.cast(pMailItemImg:getChildByName("MailItem_Head"), "Layout")
		local pMailHeadIcon = tolua.cast(pMailHead:getChildByName("Image_MailHead"), "ImageView")
		local imgHeadPath = GetMailHeadIcon(pMailDataSingle["ResIMG"])
		pMailHeadIcon:loadTexture(imgHeadPath)

		local function ReceiveOver( pData_Child, isClose)
			for key,value in pairs(pData) do
				if value["ID"] == pData_Child["ID"] then
					if value["Status"] ~= 2 and value["hasReward"] ~= 1 then 
						value["Status"] = 2
						print("设置文本邮件显示状态")
						network.NetWorkEvent(Packet_GetMailList.CreatPacket()) 		--同步列表数据
						local itemShowStatus = UpdateMailItemShowStatus(value["Status"])
						UpdateMailItemStatus(pMailItemImg,itemShowStatus)
					end
				end
			end
			--有奖励更新状态并且是通过关闭和领取返回的
			if isClose == true then 
				print("邮件有更新")
				network.NetWorkEvent(Packet_GetMailList.CreatPacket()) 		--同步列表数据
				if pData_Child["hasReward"] == 1 then 
					removeSingerMail(pData)

					local pRewardCoin = pData_Child["RewardCoin"]
					local pRewardItem = pData_Child["RewardItem"]

					local tabCoin = {}
					for key,value in pairs( pRewardCoin ) do

						if value[1] > 0 then
							local tabChild = {}
							tabChild[1] = value[1]
							tabChild[2] = value[2]
							table.insert(tabCoin,tabChild)
						end

					end

					local tabItem = {}
					for key,value in pairs( pRewardItem ) do

						if value[1] > 0 then
							local tabChild = {}
							tabChild[1] = value[1]
							tabChild[2] = value[2]
							table.insert(tabItem,tabChild)
						end

					end

					if table.getn(tabItem) > 0 and table.getn(tabCoin) == 0 then
						print("只有道具奖励")	
						ShowGoodsLayer(tabItem, nil, nil)
					elseif table.getn(tabItem) == 0 and table.getn(tabCoin) > 0 then
						print("只有货币奖励")	
						ShowGoodsLayer(nil, tabCoin, nil)
					elseif table.getn(tabItem) > 0 and table.getn(tabCoin) > 0 then
						print("道具货币奖励都有")	
						ShowGoodsLayer(tabItem, tabCoin, nil)						
					else
					end

				end
				--刷新list数据
				local NewData = SortMailList(pData)
				local pMailItemTemp = GUIReader:shareReader():widgetFromJsonFile("Image/MailItemListLayer.json")
				if m_MailList ~= nil then m_MailList:removeAllItems() end
				for i = 1, #NewData do
					local pMailItemWidget = CreateMailItemWidget(pMailItemTemp)
					InitItemWidgets(pMailItemWidget,NewData,i)		--设置每个Item的属性内容
					m_MailList:pushBackCustomItem(pMailItemWidget)
				end
				m_MailList:refreshView()
			else
				print("邮件无更新")
			end
		end

		--邮件点击设置
		local function _Image_Read_MailLayer_CallBack(sender, eventType)
			if eventType == TouchEventType.ended then
			--点击邮件发送请求具体邮件信息
				local function MailInfoReceiveOver(  )
					NetWorkLoadingLayer.loadingHideNow()
					local childData = GetMainDataChild()
					local RewardData = {}
					if childData["hasReward"] == 1 then 
						RewardData = GetMailDataReward(childData) 
					end
					TipLayer.createMailContentLayer(childData,sender:getTag(),RewardData,ReceiveOver)
					sender:setTouchEnabled(true)
				end
				sender:setTouchEnabled(false)
				NetWorkLoadingLayer.loadingShow(true)
				Packet_GetMailInfo.SetSuccessCallBack(MailInfoReceiveOver)
				network.NetWorkEvent(Packet_GetMailInfo.CreatPacket(pMailDataSingle["ID"]))
			end
		end
		pMailItemImg:addTouchEventListener(_Image_Read_MailLayer_CallBack)
		--Pause()
			--print("邮件名 = "..pMailDataSingle["Title"].." | 邮件状态 = "..pMailDataSingle["Status"].." | 邮件奖励 = "..pMailDataSingle["hasReward"])
		--Pause()
		if pMailDataSingle["hasReward"] == 0 then 		
			local itemShowStatus = UpdateMailItemShowStatus(pMailDataSingle["Status"])		--设置显示状态
			UpdateMailItemStatus(pMailItemImg,itemShowStatus)
		end
end

local mnum = 0
local isFresh = false
--[[local function _Scroll_CallFunc( sender,eventType )
	if eventType == 0 then
		if isFresh == false then
			mnum = mnum + 1
			print("mnum = "..mnum)
			if mnum >= 8 then
				print("--------------")
				mnum = 0
				isFresh = true
			end
		end
	end
end

local function _Touch_CallFunc( sender,eventType )
	if eventType == TouchEventType.began then
	elseif eventType == TouchEventType.moved then
	elseif eventType == TouchEventType.ended then
	print("bibiibibb")
		mnum = 0
	end
end]]

--Init Widgets
local function InitMailWidgets(pParent)
	local m_mailBg = tolua.cast(pParent:getWidgetByName("Image_Bg"),"ImageView")
	local m_MailList= tolua.cast(pParent:getWidgetByName("ListView_Mail"), "ListView")

	--m_MailList:addTouchEventListener(_Touch_CallFunc)
	--m_MailList:addEventListenerScrollView(_Scroll_CallFunc)
	

	local pMailTitle = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "邮件", ccp(0, 225), COLOR_Black, COLOR_White, true, ccp(0, 0), 2)
	m_mailBg:addChild(pMailTitle,2,1000)
	
	local data = SortMailList(nil)
	local function loadlMailCallBack( loadMailNumStart,loadMailNumEnd )
		local pMailItemTemp = GUIReader:shareReader():widgetFromJsonFile("Image/MailItemListLayer.json")
		for i = loadMailNumStart, loadMailNumEnd do
			--print(loadMailNumStart.."--------------->"..loadMailNumEnd)
			local pMailItemWidget = CreateMailItemWidget(pMailItemTemp)
			InitItemWidgets(pMailItemWidget,data,i)		--设置每个Item的属性内容
			m_MailList:pushBackCustomItem(pMailItemWidget)
		end
	end
	UpdateListItem(data,loadlMailCallBack,m_MailList)
	--邮件内容层
	m_BgMailContent = GUIReader:shareReader():widgetFromJsonFile("Image/MailContentLayer.json")
end

--create entrance
function CreateMailLayer()
	InitVars()
	m_BgMail = TouchGroup:create()
	m_BgMail:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/MailLayer.json"))
	InitMailWidgets(m_BgMail)

	m_CurrentStatus = judgeMailBoxStatus()

	--将主界面按钮重新加载一次
    local pMainBtns = MainBtnLayer.createMainBtnLayer()
    if m_BgMail:getChildByTag(layerMainBtn_Tag) ~= nil then 
    	m_BgMail:removeChildByTag(layerMainBtn_Tag)
    end
    m_BgMail:addChild(pMainBtns, layerMainBtn_Tag, layerMainBtn_Tag)

    	--按钮事件设置
    local m_mailChild_Back = tolua.cast(m_BgMail:getWidgetByName("mailChild_Back"),"ImageView")
	if m_mailChild_Back == nil then
		print("m_mailChild_Back is nil")
		return false
	else
		m_mailChild_Back:addTouchEventListener(_Button_Return_MailLayer_CallBack)
	end
    
	return  m_BgMail
end