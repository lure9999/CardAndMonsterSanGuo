require "Script/Common/Common"
require "Script/Main/RankList/RankListData"

module("RankListTipLayer", package.seeall)

local m_pRankItemLayer = nil

local function CreateLabel( text, size, color, fontName, pos )
	local label	  = Label:create()	
	label:setFontSize(size)
	label:setColor(color)
	label:setFontName(fontName)
	label:setPosition(pos)
	label:setText(text)
	return label
end

function CreateRankListTip( nType ,nTab, tabFont, tabMatrix )
	local GetMatrixIconByResId     = RankListData.GetMatrixIconByResId
	local GetGeneralColourByTempId = RankListData.GetGeneralColourByTempId
	if m_pRankItemLayer == nil then
		m_pRankItemLayer = TouchGroup:create()									-- 背景层
	    m_pRankItemLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/RankingListItemTipLayer.json") )
	end
	local Image_Bg = tolua.cast(m_pRankItemLayer:getWidgetByName("Image_TipBg"), "ImageView")
	local Image_Click = tolua.cast(m_pRankItemLayer:getWidgetByName("Image_Click"), "ImageView")
	local Panel_Common = tolua.cast(m_pRankItemLayer:getWidgetByName("Panel_Common"), "Layout")
	local Image_HeadBg = tolua.cast(Panel_Common:getChildByName("Image_HeadBg"), "ImageView")
	local Image_LevelBg = tolua.cast(Panel_Common:getChildByName("Image_LevelBg"), "ImageView")

	local function _Click_Close_Callfunc( sender, eventType )
		if eventType == TouchEventType.ended then
			m_pRankItemLayer:removeFromParentAndCleanup(false)
			m_pRankItemLayer = nil
		elseif eventType == TouchEventType.began then
		elseif eventType == TouchEventType.canceled then
		end
	end
	local function CreateHeadMatrix( nTab, nBase, index, maxNum )
		if nTab.FaceID == 0 then return end
		--创建阵容头像
		local diff = 88
		local bg = ImageView:create()
		bg:loadTexture("Image/imgres/common/bottom.png")
		bg:setScale(0.68)
		if index <= 5 then 
			bg:setPosition(ccp(-215 + ((maxNum-1) - (index-1)) * diff + 20,-30))
		else
			bg:setPosition(ccp(-215 + ((maxNum-1) - (index-1)) * diff,-30))
		end
		nBase:addChild(bg)

		local color = ImageView:create()
		local nColorNum = GetGeneralColourByTempId(nTab.FaceID)
		local nColorPath = string.format("Image/imgres/common/color/wj_pz%d.png",nColorNum)
		color:loadTexture(nColorPath)
		bg:addChild(color)

		local head = ImageView:create()
		local nPath = GetMatrixIconByResId(nTab.FaceID)
		head:setPosition(ccp(4, 15))
		head:loadTexture(nPath)
		bg:addChild(head)

		for i=1, nTab.Star do
			local star = ImageView:create()
			star:loadTexture("Image/imgres/common/star.png")
			star:setPosition(ccp(-45 + (i-1) * 22, -56))
			star:setFlipX(false)
			bg:addChild(star)
		end
	end
	Image_Click:addTouchEventListener(_Click_Close_Callfunc)
	local function InitTipDataCommon( )
		local pControl = UIInterface.MakeHeadIcon(Image_HeadBg, ICONTYPE.HEAD_ICON, nil, nil,nil,nTab.FaceID,nil)
		--名字
		local Label_Name =  LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, nTab.Name, ccp(Image_LevelBg:getPositionX()+35, Image_LevelBg:getPositionY()), COLOR_Black, ccc3(255,232,79), false, ccp(0, 0), 2)
		Panel_Common:addChild(Label_Name)
		--等級
		local labelLevel = CreateLabel(nTab.Level,20,COLOR_White,CommonData.g_FONT1,ccp(0, 0))
		Image_LevelBg:addChild(labelLevel)	
	end
	if nType == RANKING_LIST_TYPE.RANKING_LIST_ATHLETICS then
		Image_Bg:setSize(CCSize(610, 270))
		Panel_Common:setPosition(ccp(-300,Image_Bg:getContentSize().height - 50))
		--战斗力
		local labelPower = CreateLabel("战斗力 : ",22,ccc3(255,232,79),CommonData.g_FONT1,ccp(130, 40))
		labelPower:setAnchorPoint(ccp(0,0))
		Panel_Common:addChild(labelPower)
		local labelPowerNum = CreateLabel(nTab.Power,22,ccc3(219,179,117),CommonData.g_FONT1,ccp(labelPower:getPositionX() + labelPower:getContentSize().width, 40))
		labelPowerNum:setAnchorPoint(ccp(0,0))
		Panel_Common:addChild(labelPowerNum)		
		--排名
		local labelRank = CreateLabel("排名 : ",22,ccc3(255,232,79),CommonData.g_FONT1,ccp(labelPower:getPositionX() + 220, 40))
		labelRank:setAnchorPoint(ccp(0,0))
		Panel_Common:addChild(labelRank)
		local labelRankNum = LabelBMFont:create()
		labelRankNum:setFntFile("Image/imgres/common/num/num_rank.fnt")
		labelRankNum:setText(nTab.Rank)
		labelRankNum:setAnchorPoint(ccp(0,0))
		labelRankNum:setPosition(ccp(labelRank:getPositionX() + labelRank:getContentSize().width, 30))
		Panel_Common:addChild(labelRankNum)	
		--称号
		--[[local ImageTitleBg = ImageView:create()
		ImageTitleBg:loadTexture("Image/imgres/rankingList/nameBg.png")
		ImageTitleBg:setPosition(ccp(200, 100))
		Image_Bg:addChild(ImageTitleBg)
		local labelTitle = LabelBMFont:create()
		labelTitle:setFntFile("Image/imgres/common/num/num_title.fnt")
		labelTitle:setText(tabFont.bmdys)
		labelTitle:setPosition(ccp(0,0))
		AddLabelImg(labelTitle,1000,ImageTitleBg)]]
		--阵容列表
		for i=1,table.getn(tabMatrix) do
			CreateHeadMatrix(tabMatrix[i], Image_Bg, i, table.getn(tabMatrix))
		end
		--帮会信息
		local nCorpsStr  = "未加入军团"
		local labelCorps = nil
		if nTab.Corps ~= "" then
			labelCorps = CreateLabel("来自帮会 : "..nTab.Corps,22,ccc3(255,232,79),CommonData.g_FONT1,ccp(305, -100))
		else
			labelCorps = CreateLabel("未加入军团",22,ccc3(255,232,79),CommonData.g_FONT1,ccp(305, -100))
		end
		labelCorps:setAnchorPoint(ccp(0.5,0.5))
		Panel_Common:addChild(labelCorps)
	elseif nType == RANKING_LIST_TYPE.RANKING_LIST_FIGHT or nType == RANKING_LIST_TYPE.RANKING_LIST_LEVEL then
		--战斗力
		local labelPower = CreateLabel("最强阵容战斗力："..nTab.Power,22,ccc3(255,232,79),CommonData.g_FONT1,ccp(130, 40))
		labelPower:setAnchorPoint(ccp(0,0))
		Panel_Common:addChild(labelPower)

		local nCorpsStr  = "未加入军团"
		local labelCorps = nil
		if nTab.Corps ~= "" then
			labelCorps = CreateLabel("来自帮会 : "..nTab.Corps,22,ccc3(255,232,79),CommonData.g_FONT1,ccp(200, 0))
		else
			labelCorps = CreateLabel("未加入军团",22,ccc3(255,232,79),CommonData.g_FONT1,ccp(200, 0))
		end
		labelCorps:setAnchorPoint(ccp(0.5,0.5))
		Panel_Common:addChild(labelCorps)
	end 

	InitTipDataCommon()

	return m_pRankItemLayer
end