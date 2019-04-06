require "Script/Common/Common"
require "Script/Main/Wujiang/GeneralBaseData"
require "Script/Main/Wujiang/GeneralListLogic"
require "Script/Main/Wujiang/GeneralRelationLogic"
require "Script/Main/Wujiang/GeneralOptLayer"
require "Script/Main/Wujiang/GeneralRelationData"
require "Script/Main/Wujiang/GeneralCallLayer"
require "Script/Main/Wujiang/GeneralItem"

module("GeneralListLayer", package.seeall)

local SINGLROWITEMCOUNT = 2
local COUNTPERPAGE = 8
local m_nPos = nil
local m_nType = nil

local m_plyGeneralList = nil
local m_lvGeneralList = nil
local m_btnBack = nil
local m_pListItemTemp = nil
local m_chbCur = nil
local m_chbAll = nil
local m_chbFront = nil
local m_chbMid = nil
local m_chbBehind = nil
local m_chbHuFa = nil

local m_pImgAll = nil
local m_pImgFront = nil
local m_pImgMid = nil
local m_pImgBehind = nil
local m_pItemTab = nil
local m_nCurLine = nil

local GetTempIdByGrid								= server_generalDB.GetTempIdByGrid
local GetGridByTempId								= server_generalDB.GetGridByTempId
local GetGeneralGridListByTypeAndPos				= GeneralListLogic.GetGeneralGridListByTypeAndPos
local MakeGeneraListByRule 							= GeneralListLogic.MakeGeneraListByRule

local MakeHeadIcon									= UIInterface.MakeHeadIcon
local GetGeneralName								= GeneralBaseData.GetGeneralName
local GetGeneralNameByTempId						= GeneralBaseData.GetGeneralNameByTempId
local GetGeneralHeadIcon							= GeneralBaseData.GetGeneralHeadIcon
local GetGeneralTypeIconByTempId					= GeneralBaseData.GetGeneralTypeIconByTempId
local GetGeneralColorIcon							= GeneralBaseData.GetGeneralColorIcon
local GetGeneralCountryIcon							= GeneralBaseData.GetGeneralCountryIcon
local GetGeneralCountryIconByTempId					= GeneralBaseData.GetGeneralCountryIconByTempId
local GetDanYaoLvText								= GeneralBaseData.GetDanYaoLvText
local GetGeneralTypeByGrid							= GeneralBaseData.GetGeneralTypeByGrid
local GetGeneralPos 								= GeneralBaseData.GetGeneralPos
local GetBlogData									= GeneralBaseData.GetBlogData
local GetItemIDByGeneralID							= GeneralBaseData.GetItemIDByGeneralID

local GetRelationData								= GeneralRelationLogic.GetRelationData
local SortRelationStateTab							= GeneralRelationLogic.SortRelationStateTab
local GetItemGridByTempID							= server_itemDB.GetGird

local RunListAction 								= UIInterface.RunListAction

local function InitVars(  )
	m_plyGeneralList = nil
	m_lvGeneralList = nil
	m_btnBack = nil
	m_pListItemTemp = nil
	m_chbCur = nil
	m_chbAll = nil
	m_chbFront = nil
	m_chbMid = nil
	m_chbBehind = nil
	m_chbHuFa = nil

	m_pImgAll = nil
	m_pImgFront = nil
	m_pImgMid = nil
	m_pImgBehind = nil
	m_nPos = nil
	m_nType = nil
	m_pItemTab = nil
	m_nCurLine = nil
end

local function CreateLabel( text, size, color, fontName, pos )
	local label	  = Label:create()
	label:setFontSize(size)
	label:setColor(color)
	label:setFontName(fontName)
	label:setPosition(pos)
	label:setText(text)
	return label
end

local function CreateGeneralWidget( pGeneralListItemTemp )
    local pGeneralListItem = pGeneralListItemTemp:clone()
    local peer = tolua.getpeer(pGeneralListItemTemp)
    tolua.setpeer(pGeneralListItem, peer)
    return pGeneralListItem
end

local function UpdateRelationCount( tabState, pControl )
	local tabSortState = SortRelationStateTab(tabState)
	local pImgRelationBg = tolua.cast(pControl:getChildByName("yf_bg"), "ImageView")
	for i=1, GeneralRelationData.MAX_RELATION_COUNT do
		local  pImgRelation = tolua.cast(pImgRelationBg:getChildByName("img_"..tostring(i)), "ImageView")
		if i<=#tabSortState then
			if tabSortState[i]==GeneralRelationData.RelationState.Solidified then
				pImgRelation:loadTexture("Image/imgres/wujiang/yf_n.png")
			elseif tabSortState[i]==GeneralRelationData.RelationState.Solidifying then
				pImgRelation:loadTexture("Image/imgres/wujiang/yf_l.png")
			end
		else
			pImgRelation:setVisible(false)
		end
	end
end

local function _Img_Head_GeneralList_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		MainScene.ShowLeftInfo(false)
		MainScene.ClearRootBtn()
		MainScene.DeleteUILayer(GeneralOptLayer.GetUIControl())
		local pLayerOperate = GeneralOptLayer.CreateGeneralOptLayer(sender:getTag(), m_nType, m_nPos, UpdateGeneralListView, 0)
		if pLayerOperate~=nil then
			local pSceneGame =  CCDirector:sharedDirector():getRunningScene()
			pSceneGame:addChild(pLayerOperate, layerWujiangOperate_Tag, layerWujiangOperate_Tag)
			MainScene.PushUILayer(pLayerOperate)
		end
	end
end

local function _CallGeneral_CallBack( sender, eventType)
	if eventType == TouchEventType.ended then
		local pCallLayer = GeneralCallLayer.CreateGeneralCallLayer(sender:getTag(), m_nType, m_nPos, UpdateGeneralListView)
		if pCallLayer~=nil then
			local pRunningScene = CCDirector:sharedDirector():getRunningScene()
			pRunningScene:addChild(pCallLayer, layerWujiangOperate_Tag, layerWujiangOperate_Tag)
		end
	end
end

local function SetGeneralName( pControl, strName )
	local pLbName = tolua.cast(pControl:getChildByName("label_name"), "Label")
	pLbName:setFontName(CommonData.g_FONT1)
	pLbName:setText(strName)
end

local  function SetGeneralCountryIcon( pControl, strIconPath )
	local pImgCountry = tolua.cast(pControl:getChildByName("img_country"), "ImageView")
	local pSpriteCountry = tolua.cast(pImgCountry:getVirtualRenderer(), "CCSprite")
	pImgCountry:loadTexture(strIconPath)
end

local function SwitchGeneralOrHuFaData( pGeneralLayer, pHuFaLayer, pProgressLayer,  bGeneral, bHuFa, bProgress )
	pGeneralLayer:setVisible(bGeneral)
	pHuFaLayer:setVisible(bHuFa)
	pProgressLayer:setVisible(bProgress)
end

local function UpdateGeneralWidgetByGrid( nGrid, pControl )
	-- 头像信息
	local pImgHead = tolua.cast(pControl:getChildByName("img_head_item_wj"), "ImageView")
	local nGeneralId = GetTempIdByGrid(nGrid)
	local pHeadControl = MakeHeadIcon(pImgHead, ICONTYPE.GENERAL_ICON, nGeneralId, nGrid)
	pHeadControl:setTouchEnabled(false)
	pControl:setTag(nGrid)
	pControl:addTouchEventListener(_Img_Head_GeneralList_CallBack)

	-- 名字
	SetGeneralName(pControl, GetGeneralName(nGrid))

	-- 阵营
	SetGeneralCountryIcon(pControl, GetGeneralCountryIcon(nGrid))

	local pLayer = tolua.cast(pControl:getChildByName("Panel_General"), "Layout")
	local pLbDesc = tolua.cast(pControl:getChildByName("Label_Desc"), "Label")
	local pProgressLayer = tolua.cast(pControl:getChildByName("Panel_Progress"), "Layout")
	local nType = GetGeneralTypeByGrid(nGrid)
	if nType~=GeneralType.HuFa then
		SwitchGeneralOrHuFaData(pLayer, pLbDesc, pProgressLayer, true, false, false)
		-- 丹药
		local pLbDanYaoLv = tolua.cast(pLayer:getChildByName("label_lv"),"Label")
		pLbDanYaoLv:setFontName(CommonData.g_FONT1)
		pLbDanYaoLv:setText(GetDanYaoLvText(nGrid))
	else
		SwitchGeneralOrHuFaData(pLayer, pLbDesc, pProgressLayer, false, true, false)
		pLbDesc:setText(GetBlogData(nGeneralId))
	end

	-- 缘分
	local tabState = {}
	local tabRelationData = GetRelationData(nGrid)

	for i=1, #tabRelationData do
		if tabRelationData[i].State~=GeneralRelationData.RelationState.NotActivted then
			table.insert( tabState, tabRelationData[i].State )
		end
	end

	UpdateRelationCount(tabState, pLayer)
end

local function MakeGeneralHeadIcon( pControl, nGeneralId )
	-- 底图
	local pImgIcon = tolua.cast(pControl:getChildByName("img_head_item_wj"), "ImageView")
	pImgIcon:loadTexture("Image/imgres/equip/icon/bottom.png")
	local pSpriteIcon = tolua.cast(pImgIcon:getVirtualRenderer(), "CCSprite")
	SpriteSetGray(pSpriteIcon, 1)
	local strColorPath = GetGeneralColorIcon(nGeneralId)
	local pColorSprite = CCSprite:create(strColorPath)
	SpriteSetGray(pColorSprite,1)
	pImgIcon:addNode(pColorSprite, 0, 1)
	local strHeadIconPath = GetGeneralHeadIcon(nGeneralId)
	local pHeadSprite = CCSprite:create(strHeadIconPath)
	pHeadSprite:setPosition(ccp(6, 17))
	SpriteSetGray(pHeadSprite,1)
	pImgIcon:addNode(pHeadSprite)
	local strAttrIcon = GetGeneralTypeIconByTempId(nGeneralId)
	local pAttrSprite = CCSprite:create(strAttrIcon)
	pAttrSprite:setPosition(ccp(48,49))
	pImgIcon:addNode(pAttrSprite)
end

local function UpdateGeneralWidgetByGeneralId( tabGeneralData, pControl )
	local nGeneralId = tabGeneralData["GeneralId"]
	pControl:setTag(tabGeneralData["ItemId"])

	SetGeneralName(pControl, GetGeneralNameByTempId(nGeneralId))

	SetGeneralCountryIcon(pControl, GetGeneralCountryIconByTempId(nGeneralId))

	MakeGeneralHeadIcon(pControl, nGeneralId)

	local pGeneralLayer = tolua.cast(pControl:getChildByName("Panel_General"), "Layout")
	local pProgressLayer = tolua.cast(pControl:getChildByName("Panel_Progress"), "Layout")
	local pLbDesc = tolua.cast(pControl:getChildByName("Label_Desc"), "Label")

	SwitchGeneralOrHuFaData(pGeneralLayer, pLbDesc, pProgressLayer,  false, false, true)

	local pImgCall = tolua.cast(pProgressLayer:getChildByName("Image_Call"), "ImageView")
	local nHaveNum = tabGeneralData["Info02"]["HaveNum"]
	local nNeedNum = tabGeneralData["Info02"]["NeedNum"]

	local pImgProBg = tolua.cast(pProgressLayer:getChildByName("Image_ProBg"), "ImageView")
	local pProgressBar = tolua.cast(pImgProBg:getChildByName("ProgressBar_Collection"), "LoadingBar")
	local pLbProgress = tolua.cast(pProgressLayer:getChildByName("Label_Progress"), "Label")
	pProgressBar:setPercent((nHaveNum/nNeedNum)*100)
	if nHaveNum >= nNeedNum then
		pImgCall:setVisible(true)
		pControl:setTouchEnabled(true)
		pLbProgress:setVisible(false)
		pControl:addTouchEventListener(_CallGeneral_CallBack)
	else
		pImgCall:setVisible(false)
		pControl:setTouchEnabled(false)
		pLbProgress:setVisible(true)
		pLbProgress:setText(tostring(nHaveNum).."/"..tostring(nNeedNum))
	end
end

local function UpdateGeneralWidgetByGeneralId_New( tabGeneralData, pControl, NotOwnedIndex, pHeight )

	if tabGeneralData == nil then return end

	local nGeneralId = tabGeneralData["GeneralId"]

	local pHeadSp_Bg = CCSprite:create("Image/imgres/common/bottom.png") 										--64是标题间隔高度
	pHeadSp_Bg:setPosition(ccp( 110 * (NotOwnedIndex % 6) + 100, pHeight -math.floor((NotOwnedIndex / 6)) * 108 - 84 ))
	pHeadSp_Bg:setScale(0.78)
	pControl:addNode( pHeadSp_Bg )

	local nColorPath = GetGeneralColorIcon(nGeneralId)
	local pColor = CCSprite:create(nColorPath)
	pColor:setPosition(ccp(55, 55))
	pHeadSp_Bg:addChild( pColor )

	local nHeadPath = GetGeneralHeadIcon(nGeneralId)
	local pHead = CCSprite:create(nHeadPath)
	pHead:setPosition(ccp(60, 68))
	pHeadSp_Bg:addChild( pHead )

	local nHaveNum = tabGeneralData["Info02"]["HaveNum"]
	local nNeedNum = tabGeneralData["Info02"]["NeedNum"]
	local nProessLabel = CreateLabel(nHaveNum.."/"..nNeedNum, 26, ccc3(255,255,255), CommonData.g_FONT1, ccp(55,12))
	pHeadSp_Bg:addChild( nProessLabel )

	SpriteSetGray(pHeadSp_Bg,1)
	SpriteSetGray(pColor,1)
	SpriteSetGray(pHead,1)


	local Btn_Node = Widget:create()

	Btn_Node:setEnabled(true)
	Btn_Node:setTouchEnabled(true)
	Btn_Node:ignoreContentAdaptWithSize(false)
    Btn_Node:setSize(CCSize(pHeadSp_Bg:getContentSize().width, pHeadSp_Bg:getContentSize().height))
	Btn_Node:setPosition(ccp(pHeadSp_Bg:getPositionX(), pHeadSp_Bg:getPositionY()))
	Btn_Node:setVisible(false)
	pControl:addChild(Btn_Node,1300)

	local pGuideManager = GuideRegisterManager.RegisterGuideManager()
	pGuideManager:RegisteGuide(Btn_Node,GetItemIDByGeneralID(nGeneralId),GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_ITEM)
	pGuideManager = nil


end

local function InsertLayout(  )

	local pLayout = Layout:create()
	pLayout:setSize(CCSize(750, 30))
	m_lvGeneralList:pushBackCustomItem(pLayout)	

end

local function InsertCutText(  )
	local strText = nil
	if m_chbHuFa:getSelectedState()==true then
		strText = "以下护法尚未召唤"
	else
		strText = "以下英雄尚未召唤"
	end
	local pLabel = LabelLayer.createStrokeLabel(20, CommonData.g_FONT1, strText, ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
	m_lvGeneralList:pushBackCustomItem(pLabel)
end

local function InsertNotOwnedLayout( nType, nPos, OwnNum )
	--InsertLayout()

	local pItemCount = m_lvGeneralList:getItems():count()

	-- 未召唤的英雄
	local pHeight = 30
	local pLayout = Layout:create()

	local tabGeneral = MakeGeneraListByRule(nType, nPos)

	local tabNotOwned = {}

	local NotOwnedIndex = 1

	for i=1,table.getn( tabGeneral ) do

		if tabGeneral[i]["State"] == 0 then

			tabNotOwned[NotOwnedIndex] = tabGeneral[i]

			NotOwnedIndex = NotOwnedIndex + 1

		end

	end

	if NotOwnedIndex <= 0 then 
		print("没有未召唤的武将")
		return 
	end

	local pCount = 0

	for i=1,table.getn( tabNotOwned ) do
		if (i - 1) % 6 == 0 then
			pCount = pCount + 1
		end
	end

	pHeight = pCount * 108 + 84

	pLayout:setSize(CCSize(750, pHeight))

	m_lvGeneralList:pushBackCustomItem(pLayout)

	local strText = nil
	if m_chbHuFa:getSelectedState()==true then
		strText = "以下护法尚未召唤"
	else
		strText = "以下英雄尚未召唤"
	end
	local pLabel = LabelLayer.createStrokeLabel(20, CommonData.g_FONT1, strText, ccp(375, pHeight), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
	pLabel:setAnchorPoint(ccp(0.5, 0.5))
	pLayout:addChild( pLabel )

	--四个边角

	local pIndex = 1

	local function InsertNotOwned(  )
		UpdateGeneralWidgetByGeneralId_New( tabNotOwned[pIndex], pLayout, pIndex-1, pHeight, pTureLine )
		pIndex = pIndex + 1
		if tabNotOwned[pIndex] == nil then
			m_lvGeneralList:stopAllActions()
			return
		end

	end

	local pActionArrayRefresh = CCArray:create()
	pActionArrayRefresh:addObject(CCCallFunc:create(InsertNotOwned))
	pActionArrayRefresh:addObject(CCDelayTime:create(0.06))
	m_lvGeneralList:runAction(CCRepeatForever:create(CCSequence:create(pActionArrayRefresh)))

end

local function UpdateGeneralListItem( tabGeneral, nBeginIdx, nEndIdx)
	local pListItemTemp = GUIReader:shareReader():widgetFromJsonFile("Image/ItemWujiangList.json")
	for i=nBeginIdx, nEndIdx do
		-- 第一行空出30高度
		if i%SINGLROWITEMCOUNT==0 then
			if i==2 then
				InsertLayout()
			end
			if tabGeneral[i-1]["State"]==-1 and tabGeneral[i]["State"]==-1 then
				InsertCutText()
			else
				local pGeneralWidget = CreateGeneralWidget(pListItemTemp)
				m_lvGeneralList:pushBackCustomItem(pGeneralWidget)
				local pControl_1 = tolua.cast(pGeneralWidget:getChildByName("img_item0_wj"),"ImageView")
				if tabGeneral[i-1]["State"]==1 then
					UpdateGeneralWidgetByGrid(tabGeneral[i-1]["Grid"], pControl_1)
				elseif tabGeneral[i-1]["State"]==0 or tabGeneral[i-1]["State"]==2  then
					UpdateGeneralWidgetByGeneralId(tabGeneral[i-1], pControl_1)
				end

				local pControl_2 = tolua.cast(pGeneralWidget:getChildByName("img_item1_wj"),"ImageView")
				if tabGeneral[i]["State"]==1 then
					UpdateGeneralWidgetByGrid(tabGeneral[i]["Grid"], pControl_2)
				elseif tabGeneral[i]["State"]==0 or tabGeneral[i]["State"]==2  then
					UpdateGeneralWidgetByGeneralId(tabGeneral[i], pControl_2)
				elseif tabGeneral[i]["State"]==-1 then
					pControl_2:setVisible(false)
					InsertCutText()
				end
			end
		elseif (i%SINGLROWITEMCOUNT~=0) and (i==(#tabGeneral)) then
			-- 第一行空出30高度
			if i==1 then
				InsertLayout()
			end
			local pGeneralWidget = CreateGeneralWidget(pListItemTemp)
			m_lvGeneralList:pushBackCustomItem(pGeneralWidget)
			local pControl_1 = tolua.cast(pGeneralWidget:getChildByName("img_item0_wj"),"ImageView")
			if tabGeneral[i]["State"]==1 then
				UpdateGeneralWidgetByGrid(tabGeneral[i]["Grid"], pControl_1)
			elseif tabGeneral[i]["State"]==0 then -- or tabGeneral[i]["State"]==0  then
				UpdateGeneralWidgetByGeneralId(tabGeneral[i], pControl_1)
			end
			local pControl_2 = tolua.cast(pGeneralWidget:getChildByName("img_item1_wj"),"ImageView")
			if pControl_2~=nil then
				pControl_2:setVisible(false)
				pControl_2:setEnabled(false)
			end
		end
	end
end

local function UpdateForntItem( nIndex, nCallBack )

	for i=nIndex, 2, -2 do
		local pCheckItem = m_pItemTab[i]
		if pCheckItem ~= nil and pCheckItem:GetVisible() == false then
			print("i = "..i)
			nCallBack( i )
		end
	end

end

local function CheckListInnerPos(  )
	--一个listview显示3行item,行间距为30，每一行行高算为 item height + 30 = 175, 每五行做一次
	if m_lvGeneralList == nil then return end
	local pInner = m_lvGeneralList:getInnerContainer()
	local pDiff = m_lvGeneralList:getInnerContainerSize().height + pInner:getPositionY()
	local pNowNum = math.floor( pDiff / 175 )
	local bForntCheck = false

	if pNowNum - m_nCurLine > 1 then
		print(pNowNum, m_nCurLine)
		bForntCheck = true
	end 

	m_nCurLine = pNowNum

	local function _Init( Num )
		local pItemInit = m_pItemTab[Num]
		if pItemInit == nil then 
			local pp = Num
			print(pp.."为空")
			return 
		end

		local tabGeneral = MakeGeneraListByRule(m_nType, m_nPos)	

		local bOwned = pItemInit:InitItem( tabGeneral, Num )
		if bOwned == false then
			return
		end
		pItemInit:SetVisible( true )
	end

	if bForntCheck == true and m_nCurLine * 2 >= table.maxn( m_pItemTab ) then
		print("EndCheck")
		UpdateForntItem( m_nCurLine * 2, _Init )
	end

	--加载新的资源
	--如果当前显示的item的下一个item的显示状态为false，这时init下下一个item
	--print("pNowNum = "..pNowNum)
	local pCheckNumUp   = pNowNum + 1
	local pItemUp 		= m_pItemTab[pCheckNumUp * 2 + 4] 
	if pItemUp == nil then return end

	if pItemUp:GetVisible() == false then

		_Init( pCheckNumUp * 2 + 4 )
	
	end
	--继续检测前面有没有漏创建的item
	if bForntCheck == true then
		print("CheckCheck")
		UpdateForntItem( pCheckNumUp * 2 + 4, _Init )
	end

end

function UpdateGeneralListView( nType, nPos )

	--state = 2 : 已收集齐随便未召唤
	--state = 1 : 已召唤
	--state = 0 : 未收集齐 未召唤

	if m_lvGeneralList ~= nil then
		m_lvGeneralList:stopAllActions()
		m_lvGeneralList:removeAllItems()

		m_pItemTab = {}

		local pActionArrayRefresh = CCArray:create()
		pActionArrayRefresh:addObject(CCCallFunc:create(CheckListInnerPos))
		pActionArrayRefresh:addObject(CCDelayTime:create(0.01))
		m_plyGeneralList:runAction(CCRepeatForever:create(CCSequence:create(pActionArrayRefresh)))

	end

	if m_plyGeneralList ~=nil then

		local tabGeneral = MakeGeneraListByRule(nType, nPos)

		--获得已召唤或者可召唤的武将
		local tabOwned = {}

		local OwnedIndex = 1

		for i=1,table.getn( tabGeneral ) do

			if tabGeneral[i]["State"] == 1 or tabGeneral[i]["State"] == 2 then

				tabOwned[OwnedIndex] = tabGeneral[i]

				OwnedIndex = OwnedIndex + 1

			end

		end

		for i=1,table.getn( tabOwned ) do

			if i%SINGLROWITEMCOUNT==0 then
				if i==2 then
					InsertLayout()
				end

				local pItem = GeneralItem.Create()
				pItem:CreateItem(nType, nPos, UpdateGeneralListView)
				if i <= 10 then
					local bOwned = pItem:InitItem(tabOwned, i )
					pItem:SetVisible( true )
					if bOwned == false then
						break
					end
				end
				m_pItemTab[i] = pItem
				m_lvGeneralList:pushBackCustomItem(pItem:GetItem())

			elseif (i%SINGLROWITEMCOUNT~=0) and (i==table.getn(tabOwned)) then
				if i==1 then
					InsertLayout()
				end
				local pItem = GeneralItem.Create()
				pItem:CreateItem(nType, nPos, UpdateGeneralListView)
				local bOwned = pItem:InitItem(tabOwned, i, true)
				pItem:SetVisible( true )
				if bOwned == false then
					break
				end
				m_pItemTab[i] = pItem
				m_lvGeneralList:pushBackCustomItem(pItem:GetItem())
			end

		end

		InsertLayout()
		--未拥有的武将
		InsertNotOwnedLayout(nType, nPos, table.getn(tabOwned))

	end
end

local function UpdateGeneralListLayer( curCheckBox )
	if curCheckBox:getTag()==m_chbAll:getTag() then
		m_nType = GeneralType.General
		m_nPos = GeneralPos.All
	elseif curCheckBox:getTag()==m_chbFront:getTag() then
		m_nType = GeneralType.General
		m_nPos = GeneralPos.Front
	elseif curCheckBox:getTag()==m_chbMid:getTag()then
		m_nType = GeneralType.General
		m_nPos = GeneralPos.Middle
	elseif curCheckBox:getTag()==m_chbBehind:getTag() then
		m_nType = GeneralType.General
		m_nPos = GeneralPos.Behind
	elseif curCheckBox:getTag()==m_chbHuFa:getTag()then
		m_nType = GeneralType.HuFa
		m_nPos = GeneralPos.All
	end
	m_lvGeneralList:jumpToTop()
	UpdateGeneralListView(m_nType, m_nPos)
end
local function CreateLabelBox(strBtnName,pParent,bFirst)
	local label = nil
	if bFirst == true then
		if pParent:getChildByTag(1)~=nil then
			 pParent:getChildByTag(1):removeFromParentAndCleanup(true)
		end
		
		label = LabelLayer.createStrokeLabel(25,CommonData.g_FONT1,strBtnName,ccp(10,2),ccc3(41,22,10),COLOR_White,true,ccp(0,-2),2)
	else
		if pParent:getSelectedState() == true then
			if pParent:getChildByTag(1)~=nil then
				 pParent:getChildByTag(1):removeFromParentAndCleanup(true)
			end
			
			label = LabelLayer.createStrokeLabel(25,CommonData.g_FONT1,strBtnName,ccp(10,2),ccc3(41,22,10),COLOR_White,true,ccp(0,-2),2)
		else
			label = Label:create()
			label:setFontName(CommonData.g_FONT1)
			label:setFontSize(25)
			label:setColor(ccc3(199,136,86))
			label:setPosition(ccp(10,2))
			label:setText(strBtnName)
		end
	end
	
	
	AddLabelImg(label,1,pParent)
	return label
end
local function UpdateLabelByBox(pBox)
	local box = tolua.cast(pBox,"CheckBox")
	local label = box:getChildByTag(1)
	if label~=nil then
		local strBtnName = nil
		if box:getSelectedState() == false then
			strBtnName = LabelLayer.getText(label)
			
		else
			strBtnName =label:getStringValue()
		end
		label:removeFromParentAndCleanup(true)
		CreateLabelBox(strBtnName,pBox)
	end
end
local function _CheckBox_GeneralList__CallBack(sender, eventType)
	-- 获取当前点击的CheckBox
	local curCheckBox = tolua.cast(sender,"CheckBox")
	if eventType == CheckBoxEventType.selected then
		if m_chbCur~=curCheckBox then
			m_chbCur:setSelectedState(false)
			if curCheckBox==m_chbHuFa then
				m_chbHuFa:setScale(1.2)
			else
				m_chbHuFa:setScale(1.0)
			end
			UpdateLabelByBox(m_chbCur)
			UpdateLabelByBox(curCheckBox)
			m_chbCur = curCheckBox
			--UpdateCheckBoxState(m_chbAll, m_chbFront, m_chbMid, m_chbBehind)
			UpdateGeneralListLayer(m_chbCur)
		end
	else
		if curCheckBox:getSelectedState() == false then
			curCheckBox:setSelectedState(true)
			if m_chbCur==nil then
				m_chbCur = curCheckBox
			end
			--UpdateCheckBoxState(m_chbAll, m_chbFront, m_chbMid, m_chbBehind)
			UpdateGeneralListLayer(m_chbCur)
		end
	end
end

local function _BtnBack_GeneralList_CallBack(sender, eventType)
    if eventType == TouchEventType.ended then
    	m_btnBack:setScale(1.0)
		local pBarManager = MainScene.GetBarManager()
		pBarManager:Delete(CoinInfoBarManager.EnumLayerType.EnumLayerType_General)
    	m_plyGeneralList:removeFromParentAndCleanup(true)
    	InitVars()
    	MainScene.PopUILayer()
   		--local tabGeneral = MakeGeneraListByRule(m_nType, m_nPos)
		--UpdateGeneralListItem( tabGeneral, 1, 8 )
    elseif  eventType == TouchEventType.began then
		m_btnBack:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		m_btnBack:setScale(1.0)
    end
end

local function InitWidgets(  )
	m_lvGeneralList = tolua.cast(m_plyGeneralList:getWidgetByName("listview_wujianglist"),"ListView")
	if m_lvGeneralList==nil then
		print("m_lvGeneralList is nil")
		return false
	else
		m_lvGeneralList:setClippingType(1)
		m_lvGeneralList:setItemsMargin(30)
	end

	m_btnBack = tolua.cast(m_plyGeneralList:getWidgetByName("btn_wujianglist_back"),"Button")
	if m_btnBack==nil then
		print("m_btnBack is nil")
		return false
	else
		m_btnBack:addTouchEventListener(_BtnBack_GeneralList_CallBack)
	end

	m_chbAll = tolua.cast(m_plyGeneralList:getWidgetByName("box_wujianglist_all"),"CheckBox")
	--m_chbAll:setSelectedState(true)
	m_chbCur = m_chbAll
	if m_chbAll==nil then
		print("m_chbAll is nil")
		return false
	else
		m_chbAll:addEventListenerCheckBox(_CheckBox_GeneralList__CallBack)
		--改成不是图片，是文字了
		m_pImgAll = CreateLabelBox("全部",m_chbAll,true)
		
		if m_pImgAll==nil then
			print("m_pImgAll is nil")
			return false
		end
	end

	m_chbFront = tolua.cast(m_plyGeneralList:getWidgetByName("box_wujianglist_before"),"CheckBox")
	if m_chbFront==nil then
		print("m_chbFront is nil")
		return false
	else
		m_chbFront:addEventListenerCheckBox(_CheckBox_GeneralList__CallBack)
		m_pImgFront = CreateLabelBox("前排",m_chbFront)
		if m_pImgFront==nil then
			print("m_pImgFront is nil")
			return false
		end
	end

	m_chbMid = tolua.cast(m_plyGeneralList:getWidgetByName("box_wujianglist_mid"),"CheckBox")
	if m_chbMid==nil then
		print("m_chbMid is nil")
		return false
	else
		m_chbMid:addEventListenerCheckBox(_CheckBox_GeneralList__CallBack)
		m_pImgMid =  CreateLabelBox("中排",m_chbMid)
		if m_pImgMid==nil then
			print("m_pImgMid is nil")
			return false
		end
	end

	m_chbBehind = tolua.cast(m_plyGeneralList:getWidgetByName("box_wujianglist_after"),"CheckBox")
	if m_chbBehind==nil then
		print("m_chbBehind is nil")
		return false
	else
		m_chbBehind:addEventListenerCheckBox(_CheckBox_GeneralList__CallBack)
		m_pImgBehind =  CreateLabelBox("后排",m_chbBehind)
		if m_pImgBehind==nil then
			print("m_pImgBehind is nil")
			return false
		end
	end

	m_chbHuFa = tolua.cast(m_plyGeneralList:getWidgetByName("box_wujianglist_hufa"),"CheckBox")
	if m_chbHuFa==nil then
		print("m_chbHuFa is nil")
		return false
	else
		m_chbHuFa:addEventListenerCheckBox(_CheckBox_GeneralList__CallBack)
	end

	m_pListItemTemp = GUIReader:shareReader():widgetFromJsonFile("Image/ItemWujiangList.json")
	if m_pListItemTemp==nil then
		print("m_pListItemTemp is nil")
		return false
	end

	return true
end

function CreateGeneralListLayer(  )
	InitVars()
	m_plyGeneralList = TouchGroup:create()
	m_plyGeneralList:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/WujiangListLayer.json" ) )

	m_pItemTab = {}

	m_nCurLine = 0

	if InitWidgets()==false then
		return
	end
	local pBarManager = MainScene.GetBarManager()
	if pBarManager~=nil then
		pBarManager:Create(m_plyGeneralList,CoinInfoBarManager.EnumLayerType.EnumLayerType_General)
	end
	--将主界面按钮重新加载一次
    require "Script/Main/MainBtnLayer"
    local temp = MainBtnLayer.createMainBtnLayer()
    m_plyGeneralList:addChild(temp, layerMainBtn_Tag, layerMainBtn_Tag)

	_CheckBox_GeneralList__CallBack(m_chbAll, CheckBoxEventType.unselected)
	
	return m_plyGeneralList
end

function GetUIControl(  )
	return m_plyGeneralList
end