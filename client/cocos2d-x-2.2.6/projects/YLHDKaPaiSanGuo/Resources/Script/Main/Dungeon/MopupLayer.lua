require "Script/Common/Common"
require "Script/Common/CommonData"
require "Script/Main/Dungeon/DungeonBaseData"
require "Script/serverDB/server_MopupDB"

module("MopupLayer", package.seeall)

local m_pLayerMopup = nil
local m_pListViewReward = nil
local m_InvelTime = nil

local nLayouHeight = nil
local nLayouWidth = nil
local m_ListInnerHeight = nil
local CreateStrokeLabel 					= LabelLayer.createStrokeLabel
local SetStrokeLabelText					= LabelLayer.setText

local function InitVars(  )
	m_pLayerMopup = nil
	m_pListViewReward = nil
	nLayouHeight = 0
	nLayouWidth = nil
	m_ListInnerHeight = nil
	m_InvelTime = nil
end

local function _Btn_Close_Mopup_CallBack(  )
	m_pLayerMopup:removeFromParentAndCleanup(true)
	InitVars()
	EnterPointLayer.UpdateLeftTimes()
end

local function GetMoneyIconByType( nMoneyType )
	local nResId = tonumber(coin.getFieldByIdAndIndex(nMoneyType, "ResID"))
	return resimg.getFieldByIdAndIndex(nResId, "icon_path")
end

local function NeedToScale( nMoneyType )
	if nMoneyType==ConsumeType.Sliver
	   or nMoneyType==ConsumeType.Gold
	   or nMoneyType==ConsumeType.Tili
	   or nMoneyType==ConsumeType.Naili then
	   	return true
	else
		return false
	end
end

local function AddTitle( pLayout, nIndex )
	local pImageTitle = ImageView:create()
	pImageTitle:loadTexture("Image/imgres/equip/title_bg.png")
	pImageTitle:setSize(CCSize(480, 33))
	pImageTitle:setPosition(ccp(nLayouWidth/2, nLayouHeight + 20))
	local pLabelTitle = CreateStrokeLabel(30, CommonData.g_FONT1, "第"..tostring(nIndex).."战", ccp(0, 0), COLOR_Black, ccc3(255, 233, 131), true, ccp(0, -2), 2)
	pImageTitle:addChild(pLabelTitle)
	pLayout:addChild(pImageTitle)
	nLayouHeight = nLayouHeight + 40
end

local function AddMoneyData( pLayout, tabMoneyData )
	for k, v in pairs(tabMoneyData) do
		local pMoneyIcon = ImageView:create()
		pMoneyIcon:loadTexture(GetMoneyIconByType(v["Type"]))
		pMoneyIcon:setAnchorPoint(ccp(1, 0.5))
		pMoneyIcon:setPosition(ccp((k-1)*120+50,  nLayouHeight - 25 ))
		if NeedToScale(v["Type"]) then
			pMoneyIcon:setScale(0.4)
		end
		pLayout:addChild(pMoneyIcon)

		local pLabelNum = Label:create()
		pLabelNum:setText(v["Number"])
		pLabelNum:setColor(ccc3(143, 86, 32))
		pLabelNum:setFontSize(18)
		pLabelNum:setPosition(ccp(pMoneyIcon:getPositionX()+20, pMoneyIcon:getPositionY()))
		pLayout:addChild(pLabelNum)
	end
end

local function AddItemData( pLayout, tabItemData )
	nLayouHeight = nLayouHeight + math.ceil(#tabItemData/6)*100 + 70
	local pImageItemBg = ImageView:create()
	pImageItemBg:loadTexture("Image/imgres/equip/d_down_bg.png")
	pImageItemBg:setPosition(ccp(nLayouWidth/2, (math.ceil(#tabItemData/6)*100 + 60)/2))
	pImageItemBg:ignoreContentAdaptWithSize(true)
	pImageItemBg:setSize(CCSize(nLayouWidth, 97))
	pLayout:addChild(pImageItemBg)
	local nplusTime = 0.1
	for k, v in pairs(tabItemData) do
		local pImageIcon = ImageView:create()
		--pImageIcon:setScale(0.68)
		pImageIcon:setScale(0)
		pImageIcon:setPosition(ccp( (k-1)*100+50, nLayouHeight -math.ceil(k/6)*100))

		local pNewImageIcon = UIInterface.MakeHeadIcon(pImageIcon, ICONTYPE.ITEM_ICON, v["Id"], nil)

		local pLabelNum = Label:create()
		pLabelNum:setColor(COLOR_White)
		pLabelNum:setFontSize(22)
		pLabelNum:setPosition(ccp(-35,-40))
		pLabelNum:setText("x"..v["Number"])
		pNewImageIcon:addChild(pLabelNum)
		pLayout:addChild(pImageIcon)

		local array_action = CCArray:create()
		array_action:addObject(CCDelayTime:create(0.3 + k * nplusTime))
		array_action:addObject(CCScaleTo:create(0.1,1))
		array_action:addObject(CCScaleTo:create(0.1,0.68))
		pImageIcon:runAction(CCSequence:create(array_action))
		m_InvelTime = 0.3 + k * nplusTime
	end
end

local function AddBottomLine( pLayout )
	local pImageBottom = ImageView:create()
	pImageBottom:loadTexture("Image/imgres/equip/line_bg.png")
	pImageBottom:setPosition(ccp(nLayouWidth/2, 20))
	nLayouHeight = 5 + pImageBottom:getSize().height
	pLayout:addChild(pImageBottom)
end

local function CreateRewardLayout( nIndex, tabRewardData )
	local pLayout = Layout:create()
	AddBottomLine(pLayout)
	AddItemData(pLayout, tabRewardData["Item"])
	AddMoneyData(pLayout, tabRewardData["Money"])
	AddTitle(pLayout, nIndex)
	pLayout:setSize(CCSize(nLayouWidth, nLayouHeight))
	m_ListInnerHeight = m_ListInnerHeight + pLayout:getSize().height
	m_pListViewReward:setInnerContainerSize(CCSizeMake(m_pListViewReward:getInnerContainerSize().width,m_ListInnerHeight))
	m_pListViewReward:scrollToBottom(0.2,true)
	return pLayout
end

local function AddItemInList( nBeginIndex,nEndIndex ,nData)
	local pBoxItemWidgetTemp = GUIReader:shareReader():widgetFromJsonFile("Image/PataRewardItemLayer.json")
	for i=nBeginIndex,nEndIndex do
		m_pListViewReward:pushBackCustomItem(CreateRewardLayout(i, nData[i]))
	end
end

local function UpdateRewardData(  )
	local MAIL_ADD_NUM = 1
	local MAIL_ADD_NUM_INSERT = 1
	local count_now_add = 0
	local count_now_begin = 1

	m_pListViewReward:removeAllItems()
	nLayouWidth = m_pListViewReward:getSize().width
	local tabReward = server_MopupDB.GetCopyTable()
	local tabNum = table.getn(tabReward)

	local function GetActionArray(callback)
		local array_action = CCArray:create()
		array_action:addObject(CCDelayTime:create(m_InvelTime + 0.3))
		array_action:addObject(CCCallFunc:create(callback))
		local action_list = CCSequence:create(array_action)
		array_action:removeAllObjects()
		array_action = nil 
		return action_list
	end	

	local function RunAddItemAction( pAction ,AddItemCallBack )
		pAction:stopAllActions()
		count_now_add = 0
		AddItemCallBack(count_now_begin,MAIL_ADD_NUM ,tabReward)
		count_now_add = MAIL_ADD_NUM
		local function listCheckCallBack()
			pAction:stopAllActions()
			if tabNum > count_now_add then
				if (count_now_add + MAIL_ADD_NUM_INSERT) > tabNum then
					AddItemCallBack(count_now_add + 1,count_now_add + (tabNum - count_now_add),tabReward)
				else
					AddItemCallBack(count_now_add + 1,(MAIL_ADD_NUM_INSERT + count_now_add),tabReward)
					count_now_add = count_now_add + MAIL_ADD_NUM_INSERT
					pAction:runAction(CCRepeatForever:create(GetActionArray(listCheckCallBack))) 
				end
			else
				local pImageSuccess = ImageView:create()
				pImageSuccess:loadTexture("Image/imgres/dungeon/mopup_comp.png")
				m_pListViewReward:pushBackCustomItem(pImageSuccess)
				m_ListInnerHeight = m_ListInnerHeight + pImageSuccess:getContentSize().height
				m_pListViewReward:setInnerContainerSize(CCSizeMake(m_pListViewReward:getInnerContainerSize().width,m_ListInnerHeight))
				m_pListViewReward:scrollToBottom(0.2,true)
			end
		end
		pAction:runAction(CCRepeatForever:create(GetActionArray(listCheckCallBack))) 
	end
	RunAddItemAction(m_pListViewReward , AddItemInList)
end

local function InitWidgets(  )
	m_pLayerMopup = TouchGroup:create()
	m_pLayerMopup:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/MopupLayer.json"))
	m_ListInnerHeight = 0
	m_InvelTime	= 0.0


	local pBtnClose = tolua.cast(m_pLayerMopup:getWidgetByName("Button_Close"),"Button")
	if pBtnClose==nil then
		print("pBtnClose is nil")
		return false
	else
		CreateBtnCallBack(pBtnClose, nil, nil, _Btn_Close_Mopup_CallBack)
	end

	m_pListViewReward = tolua.cast(m_pLayerMopup:getWidgetByName("ListView_Reward"),"ListView")
	if m_pListViewReward==nil then
		print("m_pListViewReward is nil")
		return false
	else
		m_pListViewReward:setClippingType(1)
	end
	return true
end

function CreateMopupLayer(  )
	InitVars()
	if InitWidgets()==false then
		return
	end
	UpdateRewardData()
	return m_pLayerMopup
end