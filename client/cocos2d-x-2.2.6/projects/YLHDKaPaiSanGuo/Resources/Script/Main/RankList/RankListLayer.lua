require "Script/Common/Common"
require "Script/Main/RankList/RankListLogic"
require "Script/Main/RankList/RankListData"
require "Script/Main/RankList/RankListTipLayer"
require "Script/serverDB/server_mainDB"

module("RankListLayer", package.seeall)

local GetRankData						=	RankListData.GetRankData
local GetMainRank						=	RankListData.GetMainRank
local GetRankMatrix 					=	RankListData.GetRankMatrix
local GetRankNameByID                   =   RankListData.GetRankNameByID

local UpdateListItem					= 	RankListLogic.UpdateListItem
local GetRankNameByData                 =   RankListLogic.GetRankNameByData
local StrokeLabel_createStrokeLabel 	= 	LabelLayer.createStrokeLabel

local MAX_RANK_NUM				= 10

local m_RankListLayer 			= nil
local tabRankList				= {}

local tab_font = {
	bmdys	= "01234",
}

local function InitVars( ... )
	m_RankListLayer 			= nil
	tabRankList					= {}
end

local function CreateRankItemWidget( pRankItemTemp )
    local pRankItem = pRankItemTemp:clone()
    local peer = tolua.getpeer(pRankItemTemp)
    tolua.setpeer(pRankItem, peer)
    return pRankItem
end

local function _Click_Return_RankList_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		m_RankListLayer:removeFromParentAndCleanup(false)
		InitVars()	
		MainScene.PopUILayer()
	elseif eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
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

local function InitGamerInfo( nGamerItem ,nTab, nRankingNum )
	local nRankingName = GetRankNameByData(nRankingNum)
	print(nRankingName)
	-- Pause()

	local function _Click_RankItem_CallFunc( sender, eventType )
		if eventType == TouchEventType.ended then
		local function OpenRank( )
			NetWorkLoadingLayer.loadingHideNow()
			local dataMatrix = GetRankMatrix()
			local tab = {}
			tab["FaceID"] = nTab.FaceID
			tab["Level"]  = nTab.Level
			tab["Name"]   = nTab.Name
			tab["Power"]  = nTab.Power
			tab["Rank"]   = nRankingNum
			tab["Corps"]   = nTab.Corps
			if tabRankList.CurType == RANKING_LIST_TYPE.RANKING_LIST_ATHLETICS then
				tab["Ranking"] = nTab.Ranking
			end
			--TipLayer.createRankItemTip(tabRankList.CurType,tab, tab_font, dataMatrix)
			local nTipLayer = RankListTipLayer.CreateRankListTip(tabRankList.CurType,tab, tab_font, dataMatrix)
			if nTipLayer ~= nil then
				m_RankListLayer:addChild(nTipLayer,99)
			end
		end
		Packet_RankMatrix.SetSuccessCallBack(OpenRank)
		network.NetWorkEvent(Packet_RankMatrix.CreatPacket(nRankingNum))
		NetWorkLoadingLayer.loadingShow(true)
		elseif eventType == TouchEventType.began then
		elseif eventType == TouchEventType.canceled then
		end
	end
	local Image_Bg = tolua.cast(nGamerItem:getChildByName("Image_Bg"), "ImageView")
	local Image_Click = tolua.cast(Image_Bg:getChildByName("Image_Click"), "ImageView")
	local Image_HeadBg = tolua.cast(Image_Bg:getChildByName("Image_HeadBg"), "ImageView")
	local Image_LevelBg = tolua.cast(Image_Bg:getChildByName("Image_LevelBg"), "ImageView")
	local Image_Ranking = tolua.cast(Image_Bg:getChildByName("Image_Ranking"), "ImageView")
	local Image_MR = tolua.cast(Image_Bg:getChildByName("Image_MR"), "ImageView")
	local LabelFight = tolua.cast(Image_Bg:getChildByName("Label_Fight"), "Label")
	local pControl = UIInterface.MakeHeadIcon(Image_HeadBg, ICONTYPE.HEAD_ICON, nil, nil,nil,nTab.FaceID,nil)
	--名字
	local labelName = CreateLabel(nTab.Name,22,ccc3(49,31,21),CommonData.g_FONT1,ccp(Image_LevelBg:getPositionX() + 80, Image_LevelBg:getPositionY()))
	Image_Bg:addChild(labelName)
	--等級
	local labelLevel = CreateLabel(nTab.Level,20,COLOR_White,CommonData.g_FONT1,ccp(Image_LevelBg:getPositionX(), Image_LevelBg:getPositionY()))
	Image_Bg:addChild(labelLevel)	
	if tonumber(nRankingNum) == 1 then
		Image_Ranking:loadTexture("Image/imgres/rankingList/1nc.png")
		Image_Bg:setColor(ccc3(255,170,171))
	elseif tonumber(nRankingNum) == 2 then
		Image_Ranking:loadTexture("Image/imgres/rankingList/2nc.png")
		Image_Bg:setColor(ccc3(255,195,196))
	elseif tonumber(nRankingNum) == 3 then
		Image_Ranking:loadTexture("Image/imgres/rankingList/3nc.png")	
		Image_Bg:setColor(ccc3(255,221,222))
	else
		Image_Ranking:setVisible(false)
		local labelRank = LabelBMFont:create()
		labelRank:setFntFile("Image/imgres/common/num/num_rank.fnt")
		labelRank:setText(nRankingNum)
		labelRank:setPosition(ccp(-305,2))
		AddLabelImg(labelRank,1000,Image_Bg)
	end
	--称谓
	--[[local labelTitle = LabelBMFont:create()
	labelTitle:setFntFile("Image/imgres/common/num/num_title.fnt")
	labelTitle:setText(tab_font.bmdys)
	labelTitle:setPosition(ccp(0,0))
	AddLabelImg(labelTitle,1000,Image_MR)]]--
	Image_MR:setVisible(false)
	--如果是战斗力排行榜
	if tabRankList.CurType == RANKING_LIST_TYPE.RANKING_LIST_FIGHT or
		
		 tabRankList.CurType == RANKING_LIST_TYPE.RANKING_LIST_LEVEL
	then
		LabelFight:setVisible(true)
		local LabelFightNum = CreateLabel(nTab.Power,20,ccc3(128,57,39),CommonData.g_FONT1,ccp(50, 0))
		LabelFightNum:setAnchorPoint(ccp(0,0.5))
		LabelFight:addChild(LabelFightNum)
	elseif tabRankList.CurType == RANKING_LIST_TYPE.RANKING_LIST_ATHLETICS then
		LabelFight:setVisible(false)
		Image_MR:setVisible(true)
		local LabelFightNum = LabelLayer.createStrokeLabel(18, CommonData.g_FONT1, nRankingName, ccp(0, 0), ccc3(83,1,1), ccc3(251,226,15), true, ccp(0, -3), 3)	
	
		Image_MR:addChild(LabelFightNum)
	end
	Image_Click:setTouchEnabled(true)
	Image_Click:addTouchEventListener(_Click_RankItem_CallFunc)
end

local function InitRankWidget()
	local data = GetRankData()
	if tabRankList.RankListView ~= nil then tabRankList.RankListView:removeAllItems() end
	local function InitRankListData( nstartNum,nEndNum) 
		local pRankItemTemp = GUIReader:shareReader():widgetFromJsonFile("Image/RankingListGamerLayer.json")
		for i=nstartNum,nEndNum do
			local pRankItemWidget = CreateRankItemWidget(pRankItemTemp)
			InitGamerInfo(pRankItemWidget,data[i],i)
			tabRankList.RankListView:pushBackCustomItem(pRankItemWidget)
		end
	end
	UpdateListItem(data,InitRankListData,tabRankList.RankListView)
end


local function _Click_Type_RankList_CallBack( sender, eventType )
	local pRankList_Select 	 = tolua.cast(m_RankListLayer:getWidgetByName("Image_Rank_Select"), "ImageView")
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		pRankList_Select:setScale(1.0)
		--print("tabRankList.CurType = "..tabRankList.CurType)
		if tabRankList.CurType == sender:getTag() then
			--no refresh
			print("no refresh")
		else 
			tabRankList.CurType  = sender:getTag()
			--if tabRankList.CurType == 0 or tabRankList.CurType == 2 then
			if tabRankList.CurType == RANKING_LIST_TYPE.RANKING_LIST_FIGHT or tabRankList.CurType == RANKING_LIST_TYPE.RANKING_LIST_ATHLETICS or 
				tabRankList.CurType == RANKING_LIST_TYPE.RANKING_LIST_LEVEL then
				local function RefreshList( )
					local pLabelRank = tolua.cast(m_RankListLayer:getWidgetByName("Label_Rank"), "Label")
					local Image_RankingList 	 = tolua.cast(m_RankListLayer:getWidgetByName("Image_RankingList"), "ImageView")
					if pLabelRank:getChildByTag(1000) ~=nil then
						local nRank = tolua.cast(pLabelRank:getChildByTag(1000), "LabelBMFont")
						local nNoRankImg = tolua.cast(Image_RankingList:getChildByTag(199), "ImageView")
						if tonumber(GetMainRank()) <= 0 then
							nRank:setVisible(false)
							nNoRankImg:setVisible(true)
						else
							nRank:setVisible(true)
							nNoRankImg:setVisible(false)
							if tabRankList.CurType == RANKING_LIST_TYPE.RANKING_LIST_FIGHT then
								nRank:setText(GetMainRank())
							else
								nRank:setText(GetMainRank())
							end
						end
					end
					NetWorkLoadingLayer.loadingHideNow()
					InitRankWidget()
				end
				print("tabRankList.CurType = "..tabRankList.CurType)
				Packet_GetRankData.SetSuccessCallBack(RefreshList, tabRankList.CurType)
				network.NetWorkEvent(Packet_GetRankData.CreatPacket(tabRankList.CurType))
				NetWorkLoadingLayer.loadingShow(true)
			else
				print("no data now")
			end
		end
	elseif eventType == TouchEventType.began then
		pRankList_Select:setPositionY(sender:getPositionY())
		sender:setScale(0.9)
		pRankList_Select:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
		pRankList_Select:setScale(1.0)
	end
end

function CreateRankList( nType )
	InitVars()
	m_RankListLayer = TouchGroup:create()
	m_RankListLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/RankingListLayer.json"))

	tabRankList.CurType 					= nType
	tabRankList.RankListView				= tolua.cast(m_RankListLayer:getWidgetByName("ListView_Rank"), "ListView")
	if tabRankList.RankListView ~= nil then tabRankList.RankListView:setClippingType(1) end
	local tab = {}
	tab[1] 			= "战斗力"
	tab[2] 			= "等级"
	tab[3] 			= "比武"
	tab[4] 			= "军团繁荣度"
	tab[5]   		= "军团总战力"
	tab[6] 			= "副本"
	tab[7] 			= "爬塔"

	local pRankListBg 	 	 = tolua.cast(m_RankListLayer:getWidgetByName("Image_RankingList"), "ImageView")
	local pRankList_Select 	 = tolua.cast(m_RankListLayer:getWidgetByName("Image_Rank_Select"), "ImageView")
	for i=1,7 do
		local pBtnClick 	 = tolua.cast(m_RankListLayer:getWidgetByName("Button_"..i), "Button")
		local pRankListName  = StrokeLabel_createStrokeLabel(20, CommonData.g_FONT1, tab[i], ccp(0, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, 0), 2)
   		pBtnClick:addChild(pRankListName)
   		pBtnClick:addTouchEventListener(_Click_Type_RankList_CallBack)
   		if nType == pBtnClick:getTag() then
   			pRankList_Select:setPositionY(pBtnClick:getPositionY())
   		end
   		if i == 4 or i == 5 or i == 6 or i == 7 then 
   			pBtnClick:setEnabled(false)
   		end
	end

	InitRankWidget()

	--主角信息
	local pHeadBg 	 = tolua.cast(m_RankListLayer:getWidgetByName("Image_HeroHeadBg"), "ImageView")
	local pLevelBg 	 = tolua.cast(m_RankListLayer:getWidgetByName("Image_HeroLevelBg"), "ImageView")
	local pTitleBg 	 = tolua.cast(m_RankListLayer:getWidgetByName("Image_HeroMR"), "ImageView")
	local pLabelRank = tolua.cast(m_RankListLayer:getWidgetByName("Label_Rank"), "Label")
	local pControl	 = UIInterface.MakeHeadIcon(pHeadBg, ICONTYPE.HEAD_ICON, nil, nil,nil,server_mainDB.getMainData("nHeadID"),nil)
	local pHeroName  = CreateLabel(server_mainDB.getMainData("name"),22,ccc3(49,31,21),CommonData.g_FONT1,ccp(90, 0))
	local pHeroLevel = CreateLabel(server_mainDB.getMainData("level"),20,COLOR_White,CommonData.g_FONT1,ccp(0, 0))
	pLevelBg:addChild(pHeroLevel)
	pLevelBg:addChild(pHeroName)

	local pNoRankImg = ImageView:create()
	pNoRankImg:loadTexture("Image/imgres/rankingList/noRank.png")
	pNoRankImg:setVisible(false)
	pNoRankImg:setPosition(ccp( 350, 192 ))
	pRankListBg:addChild(pNoRankImg,99,199)

	--[[local labelTitle = LabelBMFont:create()
	labelTitle:setFntFile("Image/imgres/common/num/num_title.fnt")
	labelTitle:setText(tab_font.bmdys)
	labelTitle:setPosition(ccp(0,0))
	AddLabelImg(labelTitle,1000,pTitleBg)]]--
	local nRankingName = GetRankNameByData(GetMainRank())
	local labelTitle = LabelLayer.createStrokeLabel(18, CommonData.g_FONT1, nRankingName, ccp(-5, 0), ccc3(83,1,1), ccc3(251,226,15), true, ccp(0, -3), 3)	
	
	pTitleBg:addChild(labelTitle,99,199)
	-- pTitleBg:setVisible(false)
	--排名
	local labelRank = LabelBMFont:create()
	labelRank:setAnchorPoint(ccp(0,0.5))
	labelRank:setFntFile("Image/imgres/common/num/num_rank.fnt")
	if nType == RANKING_LIST_TYPE.RANKING_LIST_FIGHT then
		labelRank:setText(GetMainRank() + 1)
	else
		labelRank:setText(GetMainRank())
	end
	labelRank:setPosition(ccp(60,0))
	AddLabelImg(labelRank,1000,pLabelRank)	

	--返回按钮
    local pBtnReturn = tolua.cast(m_RankListLayer:getWidgetByName("Button_Close"), "Button")
    pBtnReturn:addTouchEventListener(_Click_Return_RankList_CallBack)

	return m_RankListLayer
end