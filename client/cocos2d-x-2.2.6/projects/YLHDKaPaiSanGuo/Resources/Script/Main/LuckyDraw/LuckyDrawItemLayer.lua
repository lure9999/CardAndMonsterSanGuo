require "Script/Common/Common"
require "Script/Audio/AudioUtil"
require "Script/serverDB/server_LuckyDrawItemDB"
require "Script/Main/Item/ItemData"
require "Script/Main/Wujiang/GeneralBaseUILogic"
require "Script/Main/Wujiang/GeneralBaseData"
require "Script/serverDB/server_generalDB"
require "Script/serverDB/general"

module("LuckyDrawItemLayer", package.seeall)

local m_pLayerLuckyDrawItem = nil
local m_pPanelBtns = nil
local m_PPanelItems = nil
local m_pPanelShow = nil
local m_pPanelEffect = nil
local m_pBtnConfirm = nil
local m_pBtnBuyAgain = nil
local m_pImageSuccess = nil
local m_pLabelBtnText = nil
local m_FreeTimes = nil
local m_FreeTimesLabel = nil

local m_funcUpdateTimes = nil
local m_tabItem = {}
local m_nIndex = nil
local m_nItemCount = nil
local m_nColNum = nil
local m_nBasePosX = nil
local m_nPubType = nil
local m_NewGuildeCallBack_1 = nil
local m_NewGuildeCallBack_2 = nil
local m_tabOldGeneral = {}

local OFF_X = 120
local OFF_Y = 100

local CreateStrokeLabel 					= LabelLayer.createStrokeLabel
local SetStrokeLabelText					= LabelLayer.setText
local getMainData							= server_mainDB.getMainData
local GetItemTypeByTempID 					= ItemData.GetItemTypeByTempID
local GetItemEventParaC						= ItemData.GetItemEventParaC
local GetPubIndex							= LuckyDrawLogic.GetPubIndex
local GetConsumeResult						= LuckyDrawLogic.GetConsumeResult
local GetGeneralQuality						= GeneralBaseData.GetGeneralQuality
local IsHaveGeneral							= LuckyDrawLogic.IsHaveGeneral
local HandleTipLayer						= LuckyDrawLogic.HandleTipLayer
local PlayGeneralAnimationByGeneralId		= GeneralBaseUILogic.PlayGeneralAnimationByGeneralId

local function InitVars(  )
	m_pLayerLuckyDrawItem = nil
	m_pPanelBtns = nil
	m_PPanelItems = nil
	m_pPanelShow = nil
	m_pPanelEffect = nil
	m_pBtnConfirm = nil
	m_pBtnBuyAgain = nil
	m_pImageSuccess = nil
	m_pLabelBtnText = nil
	m_tabItem = {}
	m_nIndex = nil
	m_nItemCount = nil
	m_nColNum = nil
	m_nBasePosX = nil
	m_nPubType = nil
	m_funcUpdateTimes = nil
	m_FreeTimes = nil
	m_FreeTimesLabel = nil
	m_tabOldGeneral = {}
end

local function _BtnConfirm_LuckyDrawItem_CallBack(  )
	m_pLayerLuckyDrawItem:removeFromParentAndCleanup(true)
	InitVars()
	--CoinInfoBar.ShowHideBar(true)
end

local function HandleShowPanelClickEvent(  )
	m_pPanelShow:removeAllChildrenWithCleanup(true)
	m_pPanelShow:removeAllNodes()
	m_pPanelShow:setVisible(false)
	m_pPanelShow:setTouchEnabled(false)
	RunItemActiion(m_nIndex, m_nItemCount, m_nColNum, m_PPanelItems, m_tabItem, m_nBasePosX)
end

local function CreateItemAction( nIndex, nItemCount, nColNum, nBasePosX)
	local nColInedx =  (nIndex%nColNum)+ math.floor((nColNum - (nIndex-math.floor(nIndex/nColNum)*nColNum))/nColNum)*nColNum
	local nPosY = 472-(math.ceil(nIndex/nColNum))*OFF_Y
	local nPosX = nBasePosX +(nColInedx-3)*OFF_X + CommonData.g_Origin.x
	-- 抽一次，物品的水平位置
	if nItemCount<5 then
		nPosX = nBasePosX + (nIndex-1)*OFF_X + CommonData.g_Origin.x
	end
	--抽10次以上
	-- 免费物品的的位置
	if nIndex==nItemCount then
		local nRowNum = math.ceil(nItemCount/nColNum)
		nPosX = CommonData.g_sizeVisibleSize.width/2 + CommonData.g_Origin.x
		if nColInedx== 1 then
			nPosY = 472-nRowNum*OFF_Y
		else
			nPosY = 472-(nRowNum+1)*OFF_Y
		end
	end
	local pArrAction1 = CCArray:create()
	local pMoveTo = CCMoveTo:create(0.3, ccp(nPosX, nPosY))
	pArrAction1:addObject(pMoveTo)
	local pScaleTo = CCScaleTo:create(0.3, 0.68)
	pArrAction1:addObject(pScaleTo)
	pArrAction1:addObject(CCRotateBy:create(0.3, 360))
	local pSpawn = CCSpawn:create(pArrAction1)
	local pArrAction2 = CCArray:create()
	pArrAction2:addObject(pSpawn)
	return pArrAction2
end

local function GetAniNameByGeneralId( nGeneralId )
	local nColor = GetGeneralQuality(nGeneralId)
	if nColor<=3 then
		return "wujiangchouqubeijin_l"
	elseif nColor>=5 then
		return "wujiangchouqubeijin_c"
	else
		return "wujiangchouqubeijin_z"
	end
end

function CutText(str)
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

local function AddHeroName( nParent, nGeneralID ,nColor ,nZOrder)
	local pNameBg = ImageView:create()
	pNameBg:loadTexture("Image/imgres/luckydraw/nameBg.png")
	pNameBg:setPosition(ccp(CommonData.g_sizeVisibleSize.width/2 - 180 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height/2 + 50))
	
	local name = general.getFieldByIdAndIndex(nGeneralID,"Name")
	local nameTab = CutText(name)
	local nBeginNum = 1
	if nameTab[1] == "护" then
		nBeginNum = 4
	end
	local jNum = -32
	local nIndexNum = 1
	local nAddNum = 12
	for i=nBeginNum,table.getn(nameTab) do
		if table.getn(nameTab) == 2 or table.getn(nameTab) - 3 == 2 then
			jNum = -46
			nAddNum = 15
		end
		local nameLabel = Label:create()
		nameLabel:setPosition(ccp(-2,jNum * (nIndexNum - 1)))
		nameLabel:setFontSize(30)
		nameLabel:setTag(i)
		nameLabel:setFontName(CommonData.g_FONT1)
		nameLabel:setText(nameTab[i])
		if tonumber(nColor) == 3 then
			nameLabel:setColor(ccc3(0,219,255))
		elseif tonumber(nColor) == 4 then
			nameLabel:setColor(ccc3(175,0,255))
		elseif tonumber(nColor) == 5 then
			nameLabel:setColor(ccc3(255,166,0))
		end
		pNameBg:addChild(nameLabel)
		nIndexNum = nIndexNum + 1
	end
	--优化坐标
	local nPtNum = table.getn(nameTab)
	if nBeginNum ~= 1 then
		nPtNum = table.getn(nameTab) - 4
		nBeginNum = 4
	end
	for i=nBeginNum,table.getn(nameTab) do
		if pNameBg:getChildByTag(i) ~= nil then
			pNameBg:getChildByTag(i):setPosition(ccp(-2,pNameBg:getChildByTag(i):getPositionY() + nAddNum * nPtNum))
		end
	end
	nParent:addChild(pNameBg ,nZOrder)
end

local function AddGratzImage( pPanelShow, nZOrder, nGeneralID ,nColor ,nType)
	local str
	if tonumber(nType) == 5 then
		str = "Image/imgres/luckydraw/tip_hufa.png"
	else
		str = "Image/imgres/luckydraw/tip_wj.png"
	end
	local pImageGratz = ImageView:create()
	pImageGratz:loadTexture("Image/imgres/luckydraw/gratz.png")
	pImageGratz:setPosition(ccp(CommonData.g_sizeVisibleSize.width/2 - 80 + CommonData.g_Origin.x, 540))
	local pGernalType = ImageView:create()
	pGernalType:loadTexture(str)
	pGernalType:setPosition(ccp((pImageGratz:getPositionX() + pImageGratz:getContentSize().width * 0.5) + pGernalType:getContentSize().width * 0.5 + 20, 540))
	pPanelShow:addChild(pImageGratz, nZOrder, nZOrder)
	pPanelShow:addChild(pGernalType, nZOrder, nZOrder)
end

local function AddTipLabel( pPanelShow, nGeneralId, nZOrder )
	local nNum = GetItemEventParaC(nGeneralId)
	local pLabelNumTip = CreateStrokeLabel(30, CommonData.g_FONT1, "已拥有此英雄，为你转换成将魂"..tostring(nNum).."个", ccp(CommonData.g_sizeVisibleSize.width/2 + CommonData.g_Origin.x, 150), COLOR_Black, ccc3(254,244,84), true, ccp(0, -2), 2)
	pPanelShow:addChild(pLabelNumTip, nZOrder, nZOrder)
	local pLabelTip = CreateStrokeLabel(30, CommonData.g_FONT1, "将魂可用于武将升星", ccp(CommonData.g_sizeVisibleSize.width/2 + CommonData.g_Origin.x, 110), COLOR_Black, ccc3(254,244,84), true, ccp(0, -2), 2)
	pPanelShow:addChild(pLabelTip, nZOrder, nZOrder)
end

local function _BtnOK_LuckyDrawItem_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		HandleShowPanelClickEvent()
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif  eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function AddConfirmBtn( pPanelShow, nZOrder )
	local pBtnConfirm = Button:create()
	pBtnConfirm:loadTextures("Image/imgres/common/btn_bg.png","Image/imgres/common/btn_bg.png","")
	local pLabel = CreateStrokeLabel(36, CommonData.g_FONT1, "确定", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
	pBtnConfirm:addChild(pLabel)
	pBtnConfirm:setName("BtnOk")
	pBtnConfirm:setPosition(ccp(CommonData.g_sizeVisibleSize.width/2 + CommonData.g_Origin.x, 120))
	pBtnConfirm:setVisible(true)
	pBtnConfirm:setTouchEnabled(true)
	pBtnConfirm:addTouchEventListener(_BtnOK_LuckyDrawItem_CallBack)
	pPanelShow:addChild(pBtnConfirm, nZOrder, nZOrder)
end

function HideWJShow(  )
	if m_pLayerLuckyDrawItem ~= nil then
		m_pPanelShow:setVisible(false)
		HandleShowPanelClickEvent()
	end
end

local function ShowGeneralAction( nGeneralId )
	m_pPanelShow:setVisible(true)
	local nZOrder = nGeneralId+100
	local nColor  = general.getFieldByIdAndIndex(nGeneralId,"Colour")
	local nType   = general.getFieldByIdAndIndex(nGeneralId,"Type")
	AddGratzImage(m_pPanelShow, nZOrder,nGeneralId ,nColor,nType)

	--[[for key, value in pairs(m_tabOldGeneral) do
		print(value["ItemID"])
	end
	print("----------------")
	print("nGeneralId = "..nGeneralId)
	Pause()]]
	if IsHaveGeneral( m_tabOldGeneral, nGeneralId)==true then
		m_pPanelShow:setTouchEnabled(true)
		AddTipLabel(m_pPanelShow, nGeneralId, nZOrder)
	else
		m_pPanelShow:setTouchEnabled(false)
		AddConfirmBtn(m_pPanelShow, nZOrder)
	end

	CommonInterface.GetAnimationByName( "Image/imgres/effectfile/wujiangchouqubeijing.ExportJson",
										"wujiangchouqubeijing",GetAniNameByGeneralId(nGeneralId), m_pPanelShow,
										ccp(CommonData.g_sizeVisibleSize.width/2 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height/2),
										nil, nGeneralId)
	PlayGeneralAnimationByGeneralId(nGeneralId, m_pPanelShow, Ani_Def_Key.Ani_attack, 1/2, 1/3, 1.8)
	AddHeroName(m_pPanelShow, nGeneralId ,nColor ,nZOrder)

	--print("展示武将")

	if m_NewGuildeCallBack_1 ~= nil then
		m_NewGuildeCallBack_1()
		m_NewGuildeCallBack_1 = nil
	end

end

-- 递归播放物品动画
function RunItemActiion( nIndex, nItemCount, nColNum, pPanelItem, tabItem, nBasePosX )
	if nIndex>nItemCount then
		if m_NewGuildeCallBack_2 ~= nil then
			m_NewGuildeCallBack_2()
			m_NewGuildeCallBack_2 = nil
		end
		m_pPanelBtns:setVisible(true)
		m_pPanelBtns:setTouchEnabled(true)
		m_pBtnConfirm:setTouchEnabled(true)
		m_pBtnBuyAgain:setTouchEnabled(true)
		return
	else
		local pItemIcon = tolua.cast(pPanelItem:getChildByName("Item_"..nIndex), "ImageView")
		pItemIcon:setPosition(ccp(pItemIcon:getPositionX(), pItemIcon:getPositionY() + 80))
		pItemIcon:setVisible(true)
		local pArrAction = CreateItemAction(nIndex, nItemCount, nColNum, nBasePosX)
		local function RunOver(  )
			if nIndex>nItemCount then
				return
			end
			local nItemId = tabItem[nIndex]["ItemId"]
			local nItemType = GetItemTypeByTempID(nItemId)
			if nItemType== E_BAGITEM_TYPE.E_BAGITEM_TYPE_GENERAL
				or nItemType== E_BAGITEM_TYPE.E_BAGITEM_TYPE_DANWAN then
				ShowGeneralAction(nItemId)
				m_nIndex = nIndex + 1
				return
			end
			RunItemActiion(nIndex+1, nItemCount, nColNum, pPanelItem, tabItem, nBasePosX)
		end
		pArrAction:addObject(CCCallFunc:create(RunOver))
		pItemIcon:runAction(CCSequence:create(pArrAction))
	end
end

local function CraeteItemIcon( strIconName, nItemId, nItemNum )
	local pImageIcon = ImageView:create()
	pImageIcon:setVisible(false)
	pImageIcon:setName(strIconName)
	pImageIcon:setScale(0)
	pImageIcon:setPosition(ccp( CommonData.g_sizeVisibleSize.width/2 + CommonData.g_Origin.x, 480))

	local pNewImageIcon = UIInterface.MakeHeadIcon(pImageIcon, ICONTYPE.ITEM_ICON, nItemId, nil)

	--[[local pLabelNum = Label:create()
	pLabelNum:setColor(COLOR_White)
	pLabelNum:setFontSize(22)
	pLabelNum:setPosition(ccp(-35 + CommonData.g_Origin.x,-40))
	pLabelNum:setText(nItemNum)
	pNewImageIcon:addChild(pLabelNum)]]
	local pLabelNum = CreateStrokeLabel(25, CommonData.g_FONT3, nItemNum, ccp(-35 + CommonData.g_Origin.x,-40), COLOR_Black, COLOR_White, true, ccp(0, 0), 1)
	pNewImageIcon:addChild(pLabelNum)
	return pImageIcon
end

local function UpdateLayerData(  )
	m_tabItem = {}
	-- 把送的物品放到table末尾
	local _BaseRewardID = server_LuckyDrawItemDB.GetBaseRewardID()
	for k, v in pairs(server_LuckyDrawItemDB.GetCopyTable()["ItemArrs"]) do
		if v["ItemId"]~=tonumber(_BaseRewardID) then
			-- 拆分叠加物品
			for i=1, v["ItemNum"] do
				local tabTemp = {}
				tabTemp["ItemId"] = v["ItemId"]
				tabTemp["ItemNum"] = 1
				table.insert(m_tabItem, tabTemp)
			end
		end
	end

	for k, v in pairs(server_LuckyDrawItemDB.GetCopyTable()["ItemArrs"]) do
		if v["ItemId"]==tonumber(_BaseRewardID) then
			-- 将基础奖励塞进table末尾
			local tabTemp = {}
			tabTemp["ItemId"] = v["ItemId"]
			tabTemp["ItemNum"] = v["ItemNum"]
			table.insert(m_tabItem, tabTemp)
		end
	end


	for k, v in pairs(m_tabItem) do
		m_PPanelItems:addChild(CraeteItemIcon("Item_"..k, tonumber(v["ItemId"]), "x"..v["ItemNum"]), tonumber(v["ItemId"]), tonumber(v["ItemId"]))
	end

	m_nItemCount = table.getn(m_tabItem)
	if m_nItemCount<5 then
		m_nColNum = m_nItemCount
	else
		m_nColNum = 5
	end

	m_nBasePosX = CommonData.g_sizeVisibleSize.width/2
	if m_nItemCount<5 then
		m_nBasePosX = CommonData.g_sizeVisibleSize.width/2 - (m_nItemCount-1)/2*OFF_X + OFF_X/2
	end

	m_nIndex = 1

end

local function RunAllItemAction(  )
	RunItemActiion(m_nIndex, m_nItemCount, m_nColNum, m_PPanelItems, m_tabItem, m_nBasePosX)
end

local function EffectCallbackFunc(  )
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/effectfile/chouka_men.ExportJson")
    local pArmature = CCArmature:create("chouka_men")
    pArmature:setPosition(ccp(CommonData.g_sizeVisibleSize.width/2 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height/2 - CommonData.g_Origin.y))

    local  pArrAction = CCArray:create()
    pArrAction:addObject(CCMoveTo:create(0.5, ccp(CommonData.g_sizeVisibleSize.width/2 + CommonData.g_Origin.x , 550)))
    pArrAction:addObject(CCScaleTo:create(0.5, 0.5))
    local function RunOver( )
    	m_pImageSuccess:setVisible(true)
        RunAllItemAction()
    end
    local strAniName = nil
    if m_nPubType==PubType.Sliver then
    	strAniName = "Animation2"
    else
    	strAniName = "Animation4"
    end
    pArmature:getAnimation():play(strAniName)

    pArrAction:addObject(CCCallFunc:create(RunOver))
    pArmature:runAction(CCSpawn:create(pArrAction))
	m_pPanelEffect:addNode(pArmature)
end

local function PlayEffect(  )
	local strAniName = nil
	if m_nPubType==PubType.Sliver then
		strAniName = "Animation1"
	else
		strAniName = "Animation3"
	end

	CommonInterface.GetAnimationByName( "Image/imgres/effectfile/chouka_men.ExportJson",
		"chouka_men",strAniName, m_pLayerLuckyDrawItem,
		ccp(CommonData.g_sizeVisibleSize.width/2 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height/2 - CommonData.g_Origin.y),
		EffectCallbackFunc, m_nPubType)
end

local function UpdateTimesDataByType( strType )
	local pImageNumBg = tolua.cast(m_pLayerLuckyDrawItem:getWidgetByName("Image_NumBg"), "ImageView")
	local nFreeTimes = nil
	if strType == "nLuckydrawNSliver" then
		nFreeTimes = getMainData("nLuckydrawNum_Sliver")
	else
		nFreeTimes = getMainData("nLuckydrawNum_Gold")
	end
	m_FreeTimesLabel:setText("免费次数:"..nFreeTimes)
	if m_pBtnBuyAgain:getTag()==1 then
		if nFreeTimes>0  then
			SetStrokeLabelText(m_pLabelBtnText, "免费")
			pImageNumBg:setVisible(false)
			m_FreeTimesLabel:setVisible(true)
		else
			SetStrokeLabelText(m_pLabelBtnText, "买一次")
			pImageNumBg:setVisible(true)
			m_FreeTimesLabel:setVisible(false)
		end
	end
end

local function UpdateTimesData(  )
	if m_nPubType == PubType.Sliver then
		UpdateTimesDataByType("nLuckydrawNSliver")
	else
		UpdateTimesDataByType("nLuckydrawNum_Gold")
	end
end

local function _BtnBuy_LuckyDrawItem_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		--判断是否还有免费次数 如果有则继续使用免费次数，没有则判断消耗
		local pConsStr = "nLuckydrawNum_Sliver"
		if m_nPubType == PubType.Sliver then
			pConsStr = "nLuckydrawNum_Sliver"
		else
			pConsStr = "nLuckydrawNum_Gold"
		end		
		if getMainData(pConsStr) <= 0 then
			local bEnough, nItemNeedNum = GetConsumeResult(GetPubIndex(m_nPubType), sender:getTag(), m_nPubType)
			if bEnough==false then
				HandleTipLayer(m_nPubType)
				return
			end
		end

		local function BuyOver()
			m_pPanelEffect:removeAllNodes()
			m_PPanelItems:removeAllChildrenWithCleanup(true)
			m_pPanelBtns:setVisible(false)
			m_pPanelBtns:setTouchEnabled(false)
			m_pBtnConfirm:setTouchEnabled(false)
			m_pBtnBuyAgain:setTouchEnabled(false)
			m_pImageSuccess:setVisible(false)

			NetWorkLoadingLayer.loadingHideNow()
			UpdateLayerData()
			UpdateTimesData()
			if m_funcUpdateTimes~=nil then
				m_funcUpdateTimes()
			end
			PlayEffect()
		end

		m_tabOldGeneral = server_generalDB.GetCopyTable()

		Packet_LuckyDraw.SetSuccessCallBack(BuyOver)
		network.NetWorkEvent(Packet_LuckyDraw.CreatPacket(m_nPubType, sender:getTag()))
		NetWorkLoadingLayer.loadingShow(true)

	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif  eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _PanelShow_LuckyDrawItem_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		HandleShowPanelClickEvent()
	end
end


local function InitWidgets( nPubType, nCount )
	m_pLayerLuckyDrawItem = TouchGroup:create()
	m_pLayerLuckyDrawItem:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/BuyCardItemLayer.json" ) )

 	m_pBtnConfirm = tolua.cast(m_pLayerLuckyDrawItem:getWidgetByName("Button_Confirm"), "Button")
	if m_pBtnConfirm==nil then
		print("m_pBtnConfirm is nil")
		return false
	else
		m_pBtnConfirm:setTouchEnabled(false)
		CreateBtnCallBack(m_pBtnConfirm, "确定", "36", _BtnConfirm_LuckyDrawItem_CallBack)
	end

	m_pBtnBuyAgain = tolua.cast(m_pLayerLuckyDrawItem:getWidgetByName("Button_BuyTen"), "Button")
	if m_pBtnBuyAgain==nil then
		print("m_pBtnBuyAgain is nil")
		return false
	else
		m_pBtnBuyAgain:setTag(nCount)
		if nCount == 10 then
			m_pLabelBtnText = CreateStrokeLabel(36, CommonData.g_FONT1, "再买十次", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
		else
			m_pLabelBtnText = CreateStrokeLabel(36, CommonData.g_FONT1, "再买一次", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
		end
		m_pBtnBuyAgain:addChild(m_pLabelBtnText)
		m_pBtnBuyAgain:setTouchEnabled(false)
		m_pBtnBuyAgain:addTouchEventListener(_BtnBuy_LuckyDrawItem_CallBack)
	end

	m_pPanelBtns = tolua.cast(m_pLayerLuckyDrawItem:getWidgetByName("Panel_Btns"), "Layout")
	if m_pPanelBtns==nil then
		print("m_pPanelBtns is nil")
		return false
	else
		m_pPanelBtns:setVisible(false)
		m_pPanelBtns:setTouchEnabled(false)
	end

	m_PPanelItems = tolua.cast(m_pLayerLuckyDrawItem:getWidgetByName("Panel_Item"), "Layout")
	if m_PPanelItems==nil then
		print("m_PPanelItems is nil")
		return false
	end

	m_pPanelEffect = tolua.cast(m_pLayerLuckyDrawItem:getWidgetByName("Panel_Effect"), "Layout")
	if m_pPanelEffect==nil then
		print("m_pPanelEffect is nil")
		return false
	else
		m_pPanelEffect:setTouchEnabled(false)
	end

	m_pPanelShow = tolua.cast(m_pLayerLuckyDrawItem:getWidgetByName("Panel_Show"), "Layout")
	if m_pPanelShow==nil then
		print("m_pPanelShow is nil")
		return false
	else
		m_pPanelShow:setVisible(false)
		m_pPanelShow:setTouchEnabled(false)
		m_pPanelShow:addTouchEventListener(_PanelShow_LuckyDrawItem_CallBack)

	end

	m_pImageSuccess = tolua.cast(m_pLayerLuckyDrawItem:getWidgetByName("Image_Success"), "ImageView")
	if m_pImageSuccess==nil then
		print("m_pImageSuccess is nil")
		return false
	else
		if nPubType==PubType.Sliver then
			m_pImageSuccess:loadTexture("Image/imgres/luckydraw/success_sliver.png")
		else
			m_pImageSuccess:loadTexture("Image/imgres/luckydraw/success_gold.png")
		end
		m_pImageSuccess:setVisible(false)
		m_pImageSuccess:setPosition(ccp(m_pImageSuccess:getPositionX(), m_pImageSuccess:getPositionY() - 140))
	end

	local pImageCoin = tolua.cast(m_pLayerLuckyDrawItem:getWidgetByName("Image_Coin"), "ImageView")
	if pImageCoin==nil then
		print("pImageCoin is nil")
		return false
	else
		if nPubType==PubType.Sliver then
			pImageCoin:loadTexture("Image/imgres/common/silver.png")
		else
			pImageCoin:loadTexture("Image/imgres/common/yuanbao.png")
		end
	end

	local pLabelCost = tolua.cast(m_pLayerLuckyDrawItem:getWidgetByName("Label_Cost"), "Label")
	if pLabelCost==nil then
		print("pLabelCost is nil")
		return false
	else
		local bEnough, nItemNeedNum = GetConsumeResult(GetPubIndex(nPubType), nCount, nPubType)
		pLabelCost:setText(nItemNeedNum)
	end

	m_FreeTimesLabel = tolua.cast(m_pLayerLuckyDrawItem:getWidgetByName("Label_FreeTimes"), "Label")
	m_FreeTimesLabel:setPositionX(m_FreeTimesLabel:getPositionX() - 5)
	if m_FreeTimesLabel == nil then
		print("m_FreeTimesLabel is nil")
		return false
	else
		if m_FreeTimes > 0 then
			m_FreeTimesLabel:setText("免费次数:"..m_FreeTimes)
			if m_pBtnBuyAgain:getTag() == 1 then
				m_FreeTimesLabel:setVisible(true)
			else
				m_FreeTimesLabel:setVisible(false)
			end
		else
			m_FreeTimesLabel:setVisible(false)
		end
	end

	return true
end

function ExitShowList(  )
	if m_pLayerLuckyDrawItem ~= nil then
		m_pLayerLuckyDrawItem:removeFromParentAndCleanup(true)
		InitVars()
	end
end

function SetNewGuildeCallBack( nCallBack_1, nCallBack_2 )
	if nCallBack_1 ~= nil then
		m_NewGuildeCallBack_1 = nCallBack_1
	end

	if nCallBack_2 ~= nil then
		m_NewGuildeCallBack_2 = nCallBack_2
	end

end

function CreateLuckyDrawLayer( nPubType, nCount, tabOldGeneral, funcUpdateTimes, nFreeTimes, pGeneralTab )
	InitVars()
	m_FreeTimes = nFreeTimes
	if InitWidgets(nPubType, nCount)==false then
		return
	end
	m_nPubType = nPubType
	m_tabOldGeneral = pGeneralTab

	if funcUpdateTimes~=nil then
		m_funcUpdateTimes = funcUpdateTimes
	end
	UpdateLayerData()
	UpdateTimesData()
	PlayEffect()

	--CoinInfoBar.ShowHideBar(false)

	return m_pLayerLuckyDrawItem
end