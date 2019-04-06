module("PrisonCellLayer",package.seeall)
require "Script/Main/PrisonCell/PrisonCellData"
require "Script/Main/PrisonCell/PrisonCellLogic"
require "Script/Main/PrisonCell/PrisonCatchList"
local GetBoxNum 		= PrisonCellData.GetBoxNum
local GetTPrisonInfo 	= PrisonCellData.GetTPrisonInfo
local GetGPrisonInfo 	= PrisonCellData.GetGPrisonInfo
local GetRewardInfo 	= PrisonCellData.GetRewardInfo
local GetRewardPrisonByID = PrisonCellData.GetRewardPrisonByID
local GetPrisonConsum   = PrisonCellData.GetPrisonConsum
local GetUseItemInfo    = PrisonCellData.GetUseItemInfo
local GetPropInfo       = PrisonCellData.GetPropInfo
local GetPrisonItemPath = PrisonCellData.GetPrisonItemPath
local GetPrisonGridByServer = PrisonCellData.GetPrisonGridByServer
local GetTotalPrisonNum   = PrisonCellData.GetTotalPrisonNum
local GetItemInfoByServer = PrisonCellData.GetItemInfoByServer
local GetBarLength      = PrisonCellData.GetBarLength
-- local GetUseItemInfo    = PrisonCellData.GetUseItemInfo
local cleanListView     = PrisonCellLogic.cleanListView
local GetRewardLayer    = PrisonCellLogic.GetRewardLayer
local ToGetGoods        = PrisonCellLogic.ToGetGoods
local GetCoinPath       = PrisonCellData.GetCoinPath
local GetCellDataByGlobe = PrisonCellData.GetCellDataByGlobe
local GetCatchListDB    = PrisonCellData.GetCatchListDB


local CheckBOpenBox 	= PrisonCellLogic.CheckBOpenBox -- 判断背包是否已满

local m_PrisonCellLayer 	= nil
local m_PropLayer           = nil
local bar_percent           = nil
local label_Dcontent        = nil
local m_PanelShade          = nil
local m_PanelItem           = nil
local p_listItem            = nil
local label_catchNum        = nil
local label_status          = nil
local m_PointManger         = nil
local p_personNum           = 0
local n_techCount 			= 0 -- 获取对应牢房信息的计数值
local m_tabScience = {}
local n_canGetNum = 0
local function Init(  )
	m_PrisonCellLayer 	= nil
	n_techCount     	= 0
	m_PropLayer         = nil
	label_Dcontent      = nil
	bar_percent         = nil
	m_PanelShade        = nil
	m_PanelItem         = nil
	p_listItem          = nil
	label_catchNum      = nil
	label_status        = nil
	m_PointManger       = nil
	p_personNum         = 0
	n_canGetNum         = 0
end

local function _Click_return_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		m_PrisonCellLayer:setVisible(false)
		m_PrisonCellLayer:removeFromParentAndCleanup(true)
		m_PrisonCellLayer = nil
		-- Init()
		if tonumber(GetBoxNum()) < 1 and n_canGetNum == 0 then
			CorpsScene.DeleteRedPoint(2)
		end
	end
end

local function CreatePrisonItemWidget( pShopItemTemp )
    local pShopItem = pShopItemTemp:clone()
    local peer = tolua.getpeer(pShopItemTemp)
    tolua.setpeer(pShopItem, peer)
    return pShopItem
end

--点击宝箱时的回调
local function _Img_Box_CallBack( tag,sender )
	--[[if CheckBOpenBox() == false then
		TipLayer.createTimeLayer("背包已满",2)
		return
	end]]--
	sender:setTouchEnabled(false)
	local img_bg = tolua.cast(sender,"ImageView")
	img_bg:removeAllChildrenWithCleanup(true)

	local function EffectEnd(  )
		CommonInterface.GetAnimationByName("Image/imgres/effectfile/pata_baoxiang01.ExportJson", 
			"pata_baoxiang01", 
			"Animation4", 
			sender, 
			ccp(0, 0),
			nil,
			12)
		if sender:getChildByTag(12) ~= nil then
			sender:getChildByTag(12):removeAllChildrenWithCleanup(true)
		end
		
		local function GetBoxRewardFull(  )
			NetWorkLoadingLayer.loadingHideNow()
			GetUpdateBox()
		end
		NetWorkLoadingLayer.loadingShow(true)
		Packet_GetPrisonBoxReward.SetSuccessCallBack(GetBoxRewardFull)
		network.NetWorkEvent(Packet_GetPrisonBoxReward.CreatePacket())
		sender:setTouchEnabled(true)
	end

	CommonInterface.GetAnimationByName("Image/imgres/effectfile/pata_baoxiang01.ExportJson", 
		"pata_baoxiang01", 
		"Animation3", 
		sender, 
		ccp(0, 0),
		EffectEnd,
		12)
	

end

--宝箱进度条及宝箱的开启
local function loadBoxInfo(  )
	if m_PrisonCellLayer == nil then
		return 
	end
	local pargress = tolua.cast(m_PrisonCellLayer:getWidgetByName("ProgressBar_box"),"LoadingBar")
	local img_box = tolua.cast(m_PrisonCellLayer:getWidgetByName("Image_animate"),"ImageView")
	local img_boxNum = tolua.cast(m_PrisonCellLayer:getWidgetByName("Image_boxNum"),"ImageView")
	local l_BoxNum = tolua.cast(m_PrisonCellLayer:getWidgetByName("Label_boxNum"),"Label")
	l_BoxNum:setText(GetBoxNum())


	pargress:setPercent(GetBarLength()*10)
	img_box:setTouchEnabled(false)
	img_box:removeAllChildrenWithCleanup(true)

	if tonumber(GetBoxNum()) > 0 then
		if img_box:getChildByTag(25) == nil then
			m_PointManger:ShowRedPoint(25,img_box,50,20)
		end
		img_box:setTouchEnabled(true)
		CreateItemCallBack(img_box,false,_Img_Box_CallBack,nil)
		if img_box:getChildByTag(1) ~= nil then
			img_box:getChildByTag(1):removeAllChildrenWithCleanup(true)
		end
		local function EffectOver(  )
			CommonInterface.GetAnimationByName("Image/imgres/effectfile/pata_baoxiang01.ExportJson", 
			"pata_baoxiang01", 
			"Animation2", 
			img_box, 
			ccp(0, 0),
			nil,
			10)
		end
		CommonInterface.GetAnimationByName("Image/imgres/effectfile/pata_baoxiang01.ExportJson", 
			"pata_baoxiang01", 
			"Animation1", 
			img_box, 
			ccp(0, 0),
			EffectOver,
			10)
	else
		img_box:setTouchEnabled(false)
		-- m_PointManger:DeleteRedPoint(25)
		if img_box:getChildByTag(25) ~= nil then
			img_box:getChildByTag(25):removeFromParentAndCleanup(true)
		end
		if img_box:getChildByTag(1) ~= nil then
			img_box:removeAllChildrenWithCleanup(true)
		end
		local function PlayOne( animation )
			animation:playWithIndex(0)
		end

		CommonInterface.GetAnimationToPlay("Image/imgres/effectfile/pata_baoxiang01.ExportJson", 
			"pata_baoxiang01", 
			"Animation1", 
			img_box, 
			ccp(0, 0),
			PlayOne)
	end

end

local function InitItemWidgetInfo( pControl,tabItem,nGrid )
	local img_itembg = tolua.cast(pControl:getChildByName("Image_item"),"ImageView")
	local img_itemWord = tolua.cast(pControl:getChildByName("Image_itemWord"),"ImageView")
	local img_shade = tolua.cast(pControl:getChildByName("Image_shade"),"ImageView")
	local img_getMark = tolua.cast(pControl:getChildByName("Image_11"),"ImageView")
	local img_lock = tolua.cast(pControl:getChildByName("Image_lock"),"ImageView")
	local btn_reward = tolua.cast(pControl:getChildByName("Button_btn"),"Button")
	label_status = tolua.cast(img_itemWord:getChildByName("Label_12"),"Label")
	local pSpriteReward = tolua.cast(btn_reward:getVirtualRenderer(), "CCScale9Sprite")
	local label_condition = tolua.cast(btn_reward:getChildByName("Label_conditionWord"),"Label")
	local label_reWord = tolua.cast(btn_reward:getChildByName("Label_reward"),"Label")
	local img_icon = tolua.cast(btn_reward:getChildByName("Image_money"),"ImageView")
	local label_reNum = tolua.cast(btn_reward:getChildByName("Label_rewardNum"),"Label")
 
	label_condition:setText(tabItem["OPenDesc"])
	label_condition:setVisible(false)
	label_reWord:setVisible(false)
	label_reNum:setVisible(false)
	img_icon:setVisible(false)
	img_itemWord:setVisible(false)
	img_shade:setVisible(false)
	img_lock:setVisible(false)
	img_getMark:setVisible(false)
	img_lock:setTouchEnabled(true)
	btn_reward:setTouchEnabled(true)
 	img_lock:setTag(nGrid)
	btn_reward:setTag(nGrid)

	local RewardID1,RewardIDNum1,nScale,coin_ItemID= GetRewardInfo(nGrid)
	img_icon:loadTexture(RewardID1)
	if tonumber(nScale) ~= 1 then
		img_icon:setScale(0.3)
	else
		local n_Scale = PrisonCellData.GetScaleNum(coin_ItemID)
		img_icon:setScale(n_Scale)
	end
	
	-- img_icon:setSize(CCSizeMake(10,10))
	label_reNum:setText(RewardIDNum1)

	--红点的添加 删除
	--[[if pControl:getChildByTag(nGrid) == nil then
		m_PointManger:ShowRedPoint(nGrid,pControl,55,55)
	end]]--

	local function UpdatePrisonGridStatus( m_nGrid,tabItems )
		local TotalPrison = GetPrisonGridByServer()
		local tabPrison = TotalPrison[m_nGrid]
		p_personNum = p_personNum + tonumber(tabPrison["cur_num"])
		-- label_catchNum:setText(p_personNum)
		local path = GetPrisonItemPath(tabItems["PrisonBG"])
		img_itembg:loadTexture(path)
		label_status:setText("囚犯"..tabPrison["cur_num"].."/"..tabItems["RewardCondition"])
		local PrisonCond = nil
		if tonumber(tabItems["OpenType"]) == 1 then -- 牢房科技相关
			--[[if tonumber(tabItems["ConditionPara"]) == 0 then
					label_reWord:setVisible(true)
					label_reNum:setVisible(true)
					img_icon:setVisible(true)
					img_itemWord:setVisible(true)
					img_lock:setTouchEnabled(false)
					if tonumber(tabPrison["cur_num"]) >= tonumber(tabItems["RewardCondition"]) then
						btn_reward:setTouchEnabled(true)
						-- Scale9SpriteSetGray(pSpriteReward,1)
					else
						btn_reward:setTouchEnabled(false)
						-- Scale9SpriteSetGray(pSpriteReward,1)
					end]]--
				
			--else
						if tonumber(tabPrison["is_open"]) == 1 then
							-- Scale9SpriteSetGray(pSpriteReward,0)
							label_reWord:setVisible(true)
							label_reNum:setVisible(true)
							label_condition:setVisible(false)
							img_icon:setVisible(true)
							img_lock:setVisible(false)
							img_itemWord:setVisible(true)
							img_lock:setTouchEnabled(false)
							img_shade:setVisible(false)
							if tonumber(tabPrison["is_get"]) == 1 then
								img_shade:setVisible(true)
								img_getMark:setVisible(true)
								btn_reward:setTouchEnabled(false)
								Scale9SpriteSetGray(pSpriteReward,0)
								label_status:setColor(ccc3(255,87,35))
								label_status:setText("已完成")
								img_itemWord:setVisible(false)
							else 
								if tonumber(tabPrison["cur_num"]) >= tonumber(tabItems["RewardCondition"]) then
								
									btn_reward:setTouchEnabled(true)
									Scale9SpriteSetGray(pSpriteReward,0)
									label_status:setColor(ccc3(99,216,53))
									label_status:setText("可领取")
									n_canGetNum = 1
									if img_itemWord:getChildByTag(26) == nil then
										m_PointManger:ShowRedPoint(26,img_itemWord,75,5)
									end
								else
									btn_reward:setTouchEnabled(false)
									-- m_PointManger:DeleteRedPoint(25)
									Scale9SpriteSetGray(pSpriteReward,0)
								end
							end
						elseif tonumber(tabPrison["is_open"]) == 0 then
							Scale9SpriteSetGray(pSpriteReward,1)
							btn_reward:setTouchEnabled(false)
							label_condition:setVisible(true)
							img_shade:setVisible(true)
							img_lock:setVisible(true)
							img_lock:setTouchEnabled(true)
						end
			--end
		elseif tonumber(tabItems["OpenType"]) == 2 then -- 金币相关
			--if tonumber(tabItems["ConditionPara"]) == 0 then
				--[[label_reWord:setVisible(true)
				label_reNum:setVisible(true)
				img_icon:setVisible(true)
				label_condition:setVisible(true)
				img_itemWord:setVisible(true)
				
				img_lock:setTouchEnabled(false)
				if tonumber(tabPrison["cur_num"]) >= tonumber(tabItems["RewardCondition"]) then
					btn_reward:setTouchEnabled(true)
					-- Scale9SpriteSetGray(pSpriteReward,1)
				else
					btn_reward:setTouchEnabled(false)
					-- Scale9SpriteSetGray(pSpriteReward,1)
				end]]--
			--else
				if tonumber(tabPrison["is_open"]) == 0 then
					Scale9SpriteSetGray(pSpriteReward,1)
					btn_reward:setTouchEnabled(false)
					label_condition:setVisible(true)
					img_shade:setVisible(true)
					img_lock:setVisible(true)
					img_lock:setTouchEnabled(true)
				elseif tonumber(tabPrison["is_open"]) == 1 then
					-- Scale9SpriteSetGray(pSpriteReward,0)
					label_reWord:setVisible(true)
					label_reNum:setVisible(true)
					img_icon:setVisible(true)
					img_lock:setVisible(false)
					img_shade:setVisible(false)
					img_itemWord:setVisible(true)
					img_lock:setTouchEnabled(false)
					label_condition:setVisible(false)
					if tonumber(tabPrison["is_get"]) == 1 then
						img_shade:setVisible(true)
						img_getMark:setVisible(true)
						label_status:setColor(ccc3(255,87,35))
						label_status:setText("已完成")
						img_itemWord:setVisible(false)
						btn_reward:setTouchEnabled(false)
						Scale9SpriteSetGray(pSpriteReward,0)
					else
						if tonumber(tabPrison["cur_num"]) >= tonumber(tabItems["RewardCondition"]) then
							
							btn_reward:setTouchEnabled(true)
							Scale9SpriteSetGray(pSpriteReward,0)
							label_status:setColor(ccc3(99,216,53))
							label_status:setText("可领取")
							n_canGetNum = 1
							if img_itemWord:getChildByTag(26) == nil then
								m_PointManger:ShowRedPoint(26,img_itemWord,75,5)
							end
						else
							-- m_PointManger:DeleteRedPoint(25)
							btn_reward:setTouchEnabled(false)
							Scale9SpriteSetGray(pSpriteReward,0)
						end
					end
				end
			--end
		end
	end
	UpdatePrisonGridStatus(nGrid,tabItem)
	
	local function OpenLockCall( n_nTag )
		print("解锁")
		local function GetSuccessFull(  )
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1498,nil)
			pTips = nil
			CorpsScene.GetConteobile(1)
			local function GetSuccessPrison(  )
				-- NetWorkLoadingLayer.loadingHideNow()
				cleanListView(p_listItem)
				for i=1,10 do
					UpdateListItem(i)
				end
			end
			-- NetWorkLoadingLayer.loadingShow(true)
			Packet_GetPrisonGridInfo.SetSuccessCallBack(GetSuccessPrison)
			network.NetWorkEvent(Packet_GetPrisonGridInfo.CreatePacket())
		end
		Packet_OpenPrisonGrid.SetSuccessCallBack(GetSuccessFull)
		network.NetWorkEvent(Packet_OpenPrisonGrid.CreatePacket(n_nTag))
		NetWorkLoadingLayer.loadingShow(true)
	end
	--牢房格子解锁回调
	local function _Click_JieLock_CallBack( sender,eventType )
		local nTag = sender:getTag()
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			if nTag > 5 then
				
				local n_name,n_consumn = GetPrisonConsum(nTag)
				if n_name == nil then
					OpenLockCall(nTag)
				else
				local function JieLockCallFull( isLock )
					if isLock == true then
						OpenLockCall(nTag)
					end
				end
				local ppTips = TipCommonLayer.CreateTipLayerManager()
				ppTips:ShowCommonTips(1496,JieLockCallFull, tonumber(n_consumn))
				ppTips = nil
			end
			else
				OpenLockCall(nTag)
			end
		
		end
	end
	--牢房任务提交回调
	local function _Click_TaskPay_CallBack( sender,eventType )
		local nTag = sender:getTag()
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			local function GetSuccessFull(  )
				NetWorkLoadingLayer.loadingHideNow()
				GetRewardLayer(nTag)
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1497,nil)
				pTips = nil
			end
			Packet_PrisonTaskPay.SetSuccessCallBack(GetSuccessFull)
			network.NetWorkEvent(Packet_PrisonTaskPay.CreatePacket(nTag))
			NetWorkLoadingLayer.loadingShow(true)
			
		end
	end
	
	img_lock:addTouchEventListener(_Click_JieLock_CallBack)
	btn_reward:addTouchEventListener(_Click_TaskPay_CallBack)
end

function UpdateListItem( nIndex )
	if nIndex > 5 then
		return
	end
	local pPrisonItem = GUIReader:shareReader():widgetFromJsonFile("Image/PrisonLayerItem.json")
	pPrisonItemWidget = CreatePrisonItemWidget(pPrisonItem)
	local pControl_1 = tolua.cast(pPrisonItemWidget:getChildByName("Image_item1"),"ImageView")
	local tabTData = GetTPrisonInfo()
	InitItemWidgetInfo(pControl_1,tabTData[nIndex],nIndex)
	local pControl_2 = tolua.cast(pPrisonItemWidget:getChildByName("Image_item1_0"),"ImageView")
	local tabGData = GetGPrisonInfo()
	InitItemWidgetInfo(pControl_2,tabGData[nIndex],nIndex+5)
	p_listItem:setItemsMargin(5)
	p_listItem:pushBackCustomItem(pPrisonItemWidget)
end

--道具
local function loadPropUI(  )
	if m_PrisonCellLayer == nil then
		return 
	end
	local img_eye = tolua.cast(m_PrisonCellLayer:getWidgetByName("Image_eye"),"ImageView")
	local img_hand = tolua.cast(m_PrisonCellLayer:getWidgetByName("Image_hand"),"ImageView")
	local img_bar = tolua.cast(m_PrisonCellLayer:getWidgetByName("Image_bar"),"ImageView")
	local label_eyeNum = tolua.cast(m_PrisonCellLayer:getWidgetByName("Label_eyenum"),"Label")
	local label_handNum = tolua.cast(m_PrisonCellLayer:getWidgetByName("Label_handnum"),"Label")
	local label_bar = tolua.cast(m_PrisonCellLayer:getWidgetByName("Label_bar"),"Label")
	local label_DNum = tolua.cast(m_PrisonCellLayer:getWidgetByName("Label_doubleNum"),"Label")
	bar_percent = tolua.cast(m_PrisonCellLayer:getWidgetByName("ProgressBar_bar"),"LoadingBar")
	local pSpriteName = tolua.cast(bar_percent:getVirtualRenderer(), "CCSprite")
	
	--获得道具的ID
	local T_imgID,D_imgID,TTab,DTab = GetPropInfo()
	--获得道具信息
	local tabItem = GetItemInfoByServer()
	
	label_eyeNum:setText(tabItem["nEyeValidNum"])
	label_handNum:setText(tabItem["nHandValidNum"])

	
	local b_pro = tonumber(GetCellDataByGlobe())/10
	local b_percentt = tonumber(tabItem["nEyeaddBar"])/10

	label_bar:setText("+"..b_percentt.."%")--b_pro
	bar_percent:setPercent(b_percentt*2) --tabItem["nEyeValidBar"]
	if tonumber(tabItem["nHandValidNum"]) == 0 then
		label_DNum:setText("1")
	else
		label_DNum:setText("2")
	end

	local cur_Tnum = server_itemDB.GetItemNumberByTempId(tonumber(T_imgID))
	local cur_Dnum = server_itemDB.GetItemNumberByTempId(tonumber(D_imgID))

	if tonumber(tabItem["nEyeValidNum"]) <= 0 then
		SpriteSetGray(pSpriteName,1)
	else
		SpriteSetGray(pSpriteName,0)
	end

	img_eye:setScale(0.68)
	img_hand:setScale(0.68)

	local pControl_1 = UIInterface.MakeHeadIcon(img_eye,ICONTYPE.ITEM_ICON,T_imgID,nil,nil,nil,6,nil)
	local pControl_2 = UIInterface.MakeHeadIcon(img_hand,ICONTYPE.ITEM_ICON,D_imgID,nil,nil,nil,7,nil)
	
	local pLbEyeNum = Label:create()
	pLbEyeNum:setPosition(ccp(-50,-42))
	pLbEyeNum:setFontSize(25)
	pLbEyeNum:setName("LabelNumEye")
	pLbEyeNum:setText(cur_Tnum)
	pLbEyeNum:setAnchorPoint(ccp(0, 0.5))
	pControl_1:addChild(pLbEyeNum)

	local pLbHandNum = Label:create()
	pLbHandNum:setPosition(ccp(-50,-42))
	pLbHandNum:setFontSize(25)
	pLbHandNum:setName("LabelNumHand")
	pLbHandNum:setText(cur_Dnum)
	pLbHandNum:setAnchorPoint(ccp(0, 0.5))
	pControl_2:addChild(pLbHandNum)
	
	--天眼通点击回调
	local function _Click_UseT_CallBack( sender,eventType )
		local pTtag = sender:getTag()
		if eventType == TouchEventType.ended then
			-- sender:setScale(1.0)
			AudioUtil.PlayBtnClick()
			local function GetSuccessFull(  )
				NetWorkLoadingLayer.loadingHideNow()
				local cur_Tnum1 = server_itemDB.GetItemNumberByTempId(tonumber(T_imgID))
				pLbEyeNum:setText(cur_Tnum1)
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1499,nil)
				pTips = nil
				local tabUseItem = GetUseItemInfo()
				if tonumber(tabUseItem["nType"]) == 1 then
					if tonumber(tabUseItem["nNum"]) <= 0 then
						SpriteSetGray(pSpriteName,1)
					else
						SpriteSetGray(pSpriteName,0)
					end
					label_eyeNum:setText(tonumber(tabUseItem["nNum"]))
				elseif tonumber(tabUseItem["nType"]) == 2 then
					print(tabUseItem["nType"],tabUseItem["nNum"])
					local p_percent = tonumber(tabUseItem["ba_percent"])/10
					if p_percent >= 100 then
						p_percent = 100
					end
					bar_percent:setPercent(p_percent*2)
					label_bar:setText("+"..p_percent.."%")
				elseif tonumber(tabUseItem["nType"]) == 3 then
					label_handNum:setText(tonumber(tabUseItem["nNum"]))
				end
			end
			Packet_UsePrisonItem.SetSuccessCallBack(GetSuccessFull)
			network.NetWorkEvent(Packet_UsePrisonItem.CreatePacket(tonumber(T_imgID),1))
			NetWorkLoadingLayer.loadingShow(true)
			
		elseif eventType == TouchEventType.began then
			-- sender:setScale(0.9)
		end
	end
	--无影手点击回调
	local function _Click_UseD_CallBack( sender,eventType )
		local pDtag = sender:getTag()
		if eventType == TouchEventType.ended then
			-- sender:setScale(1.0)
			AudioUtil.PlayBtnClick()
			local function GetSuccessHandFull(  )
				NetWorkLoadingLayer.loadingHideNow()
				local cur_Dnum1 = server_itemDB.GetItemNumberByTempId(tonumber(D_imgID))
				pLbHandNum:setText(cur_Dnum1)
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1500,nil)
				pTips = nil
				local tabUseItem = GetUseItemInfo()
				if tonumber(tabUseItem["nType"]) == 1 then
					label_eyeNum:setText(tonumber(tabUseItem["nNum"]))
				elseif tonumber(tabUseItem["nType"]) == 2 then
					local p_percent = tonumber(tabUseItem["nNum"])
					bar_percent:setPercent(p_percent)
					label_bar:setText("抓捕成功率:"..p_percent.."%")
				elseif tonumber(tabUseItem["nType"]) == 3 then
					label_handNum:setText(tonumber(tabUseItem["nNum"]))
					label_DNum:setText("2")
				end
			end
			Packet_UsePrisonItem.SetSuccessCallBack(GetSuccessHandFull)
			network.NetWorkEvent(Packet_UsePrisonItem.CreatePacket(tonumber(D_imgID),1))
			NetWorkLoadingLayer.loadingShow(true)
		elseif eventType == TouchEventType.began then
			-- sender:setScale(0.9)
		end
	end
	--获得物品的数量 如果数量为0 点击时弹出物品不足的提示信息

	
	pControl_1:setTouchEnabled(true)
	pControl_2:setTouchEnabled(true)
	pControl_1:addTouchEventListener(_Click_UseT_CallBack)
	pControl_2:addTouchEventListener(_Click_UseD_CallBack)

end

local function _Click_CatchList_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		local function SetCatchCallBack(  )
			NetWorkLoadingLayer.loadingHideNow()
			local p_CatchList = PrisonCatchList.loadPrisonListLayer()
			local scenetemp =  CCDirector:sharedDirector():getRunningScene()
			scenetemp:addChild(p_CatchList, layerPrisonCatchTag, layerPrisonCatchTag)
		end
		NetWorkLoadingLayer.loadingShow(true)
		Packet_CatchList.SetSuccessCallBack(SetCatchCallBack)
		network.NetWorkEvent(Packet_CatchList.CreatePacket())
	end
end

function GetUpdateBox(  )
	local function GetSuccessBoxFull(  )
		NetWorkLoadingLayer.loadingHideNow()
		loadBoxInfo()
	end
	Packet_GetPrisonBoxRewardInfo.SetSuccessCallBack(GetSuccessBoxFull)
	network.NetWorkEvent(Packet_GetPrisonBoxRewardInfo.CreatePacket())
	NetWorkLoadingLayer.loadingShow(true)
end

function loadWidgetUI(  )
	if m_PrisonCellLayer == nil then
		return
	end
	p_personNum = 0
	m_tabScience = {}
	local tabSciene = CorpsData.GetScienceLevel()
	
	m_tabScience = tabSciene[10]

	p_listItem = tolua.cast(m_PrisonCellLayer:getWidgetByName("ListView_prison"),"ListView")
	if p_listItem ~= nil then
		p_listItem:setClippingType(1)
	end
	local Img_Titlename = tolua.cast(m_PrisonCellLayer:getWidgetByName("Image_name"),"ImageView")
	local btn_catchlog = tolua.cast(m_PrisonCellLayer:getWidgetByName("Button_catch"),"Button")

	if btn_catchlog:getChildByTag(10) == nil then
		local label_logName = LabelLayer.createStrokeLabel(25, CommonData.g_FONT3, "抓捕记录", ccp(0, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, -2), 2)
		btn_catchlog:addChild(label_logName,10,10)
	end
	btn_catchlog:addTouchEventListener(_Click_CatchList_CallBack)

	local label_pName = Label:create()
  	label_pName:setFontName(CommonData.g_FONT3)
  	label_pName:setFontSize(24)
    label_pName:setColor(ccc3(255,245,126))
    label_pName:setText("牢房")
    if Img_Titlename:getChildByTag(10) == nil then
	   Img_Titlename:addChild(label_pName,10,10)
	end

    local tabPrisonNum = GetPrisonGridByServer()

    label_catchNum = tolua.cast(m_PrisonCellLayer:getWidgetByName("Label_catchnum"),"Label")
    local p_Num = GetTotalPrisonNum()
    label_catchNum:setText(p_Num)

    cleanListView(p_listItem)
	
	GetUpdateBox()
	for i=1,10 do
		UpdateListItem(i)
	end

	local function GetSuccessItemFull(  )
		NetWorkLoadingLayer.loadingHideNow()
		loadPropUI()
	end
	Packet_GetPrisonItemInfo.SetSuccessCallBack(GetSuccessItemFull)
	network.NetWorkEvent(Packet_GetPrisonItemInfo.CreatePacket())
	NetWorkLoadingLayer.loadingShow(true)
	
end

function GetPrisonLayer(  )
	return m_PrisonCellLayer
end

function ShowPrisonCellLayer(  )
	Init()
	--添加红点管理
	m_PointManger = AddPoint.CreateAddPoint()

	m_PrisonCellLayer = TouchGroup:create()
	m_PrisonCellLayer:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/PrisonLayer.json"))

	loadWidgetUI()

	local btn_return  = tolua.cast(m_PrisonCellLayer:getWidgetByName("Button_return"),"Button")
	btn_return:addTouchEventListener(_Click_return_CallBack)

	return m_PrisonCellLayer
end