
module("GeneralItem", package.seeall)

local GetTempIdByGrid								= server_generalDB.GetTempIdByGrid
local GetGoOutByGrid      							= server_generalDB.GetGoOutByGrid

local GetGeneralHeadIcon  							= GeneralBaseData.GetGeneralHeadIcon
local GetGeneralColorIcon							= GeneralBaseData.GetGeneralColorIcon
local GetGeneralName								= GeneralBaseData.GetGeneralName
local GetGeneralCountryIcon							= GeneralBaseData.GetGeneralCountryIcon
local GetGeneralLv        							= GeneralBaseData.GetGeneralLv
local GetGeneralTypeIcon  							= GeneralBaseData.GetGeneralTypeIcon
local GetGeneralType      							= GeneralBaseData.GetGeneralType
local GetGeneralStar      							= GeneralBaseData.GetGeneralStar
local GetBlogData 									= GeneralBaseData.GetBlogData
local GetGeneralNameByTempId						= GeneralBaseData.GetGeneralNameByTempId
local GetGeneralCountryIconByTempId 				= GeneralBaseData.GetGeneralCountryIconByTempId
local GetGeneralTypeIconByTempId					= GeneralBaseData.GetGeneralTypeIconByTempId
local GetGeneralTypeByGrid							= GeneralBaseData.GetGeneralTypeByGrid
local GetDanYaoLvText								= GeneralBaseData.GetDanYaoLvText

local GetRelationData								= GeneralRelationLogic.GetRelationData
local SortRelationStateTab							= GeneralRelationLogic.SortRelationStateTab



local function CreateLabel( text, size, color, fontName, pos )
	local label	  = Label:create()
	label:setFontSize(size)
	label:setColor(color)
	label:setFontName(fontName)
	label:setPosition(pos)
	label:setText(text)
	return label
end

local function CreateCCLabel( text, size, color, fontName, pos, Dimensions )
	local label = CCLabelTTF:create()
	label:setFontName(fontName)
	label:setFontSize(size)
	label:setDimensions(Dimensions)
	label:setAnchorPoint(ccp(0,1))
	label:setColor(color)
	label:setPosition(pos)
	label:setString(text)
	return label
end

local function GetVisible( self )
	return self.isVisible
end

local function SetVisible( self, bVisible )
	self.isVisible = bVisible
end

local function ReleaseItem( self )
	if self.ParentLayout == nil then return end

	self.ParentLayout:removeAllChildrenWithCleanup( true )
end

local function UpdateGeneralWidgetByGrid( self, nGrid, pControl )
	--已召集的武将
	local pItem_Bg = CCScale9Sprite:create("Image/imgres/wujiang/common_bg.png")
	pItem_Bg:setContentSize(CCSize(343,145))
	pItem_Bg:setPosition(ccp( 0, 0 ))
	pControl:addNode(pItem_Bg)

	local nGeneralId = GetTempIdByGrid(nGrid)

	local nGeneralType = GetGeneralTypeByGrid(nGrid)

	local function CreateFrameBg(  )
		--花纹底图
		local pFrameBg = CCSprite:create("Image/imgres/wujiang/wj_bg_wen.png")
		pFrameBg:setTextureRect(CCRectMake(0.5, 0.5, 340, 91))
		pFrameBg:setPosition( ccp(-10, -17) )
		pControl:addNode( pFrameBg )	
	end

	local function CreateNameBg(  )
		--姓名底图
		local pNameBg = CCSprite:create("Image/imgres/wujiang/name_bg.png")
		pNameBg:setPosition(ccp(0, 46))
		pControl:addNode( pNameBg )	
	end

	local function CreateName(  )
		--姓名
		local nNameLabel = CreateLabel(GetGeneralName(nGrid), 24, ccc3(255,255,255), CommonData.g_FONT1, ccp(37,48))
		pControl:addChild( nNameLabel )
	end

	local function CreateHead(  )
		-- 头像信息
		local pHeadSp_Bg_Left = CCSprite:create("Image/imgres/common/bottom.png")
		pHeadSp_Bg_Left:setPosition(ccp(-102, 15))
		pHeadSp_Bg_Left:setScale(0.9)
		pControl:addNode( pHeadSp_Bg_Left )
	end

	local function CreateColor(  )
		local nColorPath = GetGeneralColorIcon(nGeneralId)
		local pColor = CCSprite:create(nColorPath)
		pColor:setScale(0.9)
		pColor:setPosition(ccp(-102, 15))
		pControl:addNode( pColor )
	end

	local function CreateHeadBg(  )
		local nHeadPath = GetGeneralHeadIcon(nGeneralId)
		local pHead = CCSprite:create(nHeadPath)
		pHead:setScale(0.9)
		pHead:setPosition(ccp(-98, 28))
		pControl:addNode( pHead )
	end

	local function CreateLevel(  )
		--人物等级
		local nLevelLabel = CreateLabel("Lv."..GetGeneralLv(nGrid), 20, ccc3(255,255,255), CommonData.g_FONT1, ccp(-120,-23))
		pControl:addChild( nLevelLabel )	
	end

	local function CreateZhenY(  )
		--人物阵营
		local nZhenYPath = GetGeneralTypeIcon(nGrid)
		local pZhenY= CCSprite:create(nZhenYPath)
		pZhenY:setPosition(ccp(-55, 55))
		pControl:addNode( pZhenY )
	end

	local function CreateCountry(  )
		--人物标识
		local nCountryPath = GetGeneralCountryIcon( nGrid )
		local pCountry = CCSprite:create(nCountryPath)
		pCountry:setPosition(ccp(141, 47))
		pControl:addNode( pCountry )
	end

	local function CreateStar(  )
		--人物天命星级
		local texture = CCTextureCache:sharedTextureCache():addImage("Image/imgres/common/star.png")
		if GetGeneralType(nGeneralId) ~= 5 then 
			for i=1 ,6 do 
				local pStar = CCSprite:create("Image/imgres/common/star_black.png")
				pStar:setPosition(ccp(-170 + i * 21, -53))
				if pControl:getNodeByTag(100 + i) ~= nil then
					pControl:getNodeByTag(100 + i):setVisible(false)
					pControl:getNodeByTag(100 + i):removeFromParentAndCleanup(true)
				end
				pControl:addNode(pStar, 0, 100 + i)
			end
			for i = 1, GetGeneralStar(nGrid) do
				if pControl:getNodeByTag(100 + i)~= nil then
					pControl:getNodeByTag(100 + i):setTexture(texture)
				end
			end
		end
	end

	local function CreateBlog(  )
		--人物说明
		local pBlog = GetBlogData( nGeneralId )
		local nBlogLabel = CreateCCLabel(pBlog, 18, ccc3(0,0,0), CommonData.g_FONT1, ccp(-30,25), CCSize(180, 100))
		pControl:addNode( nBlogLabel )
	end

	local function CreateGeneralInfo(  )

		self.YFIndex = 0

		-- 丹药
		local plbDanYaoTitle = CreateLabel("金丹:", 22, ccc3(49,31,21), CommonData.g_FONT3, ccp(0,-14))
		plbDanYaoTitle:setAnchorPoint(ccp(0,0))
		pControl:addChild( plbDanYaoTitle )

		local pSpDanYao = CCSprite:create("Image/imgres/wujiang/kindan.png")
		pSpDanYao:setPosition(ccp(-15, -5))
		pControl:addNode( pSpDanYao )		

		local pLbDanYaoLv = CreateLabel(GetDanYaoLvText(nGrid), 22, ccc3(49,31,21), CommonData.g_FONT1, ccp(55,-14))
		pLbDanYaoLv:setAnchorPoint(ccp(0,0))
		pControl:addChild( pLbDanYaoLv )

		--缘分
		local plbYuanFenTitle = CreateLabel("缘分:", 22, ccc3(49,31,21), CommonData.g_FONT3, ccp(0,-44))
		plbYuanFenTitle:setAnchorPoint(ccp(0,0))
		pControl:addChild( plbYuanFenTitle )

		local pSpYufen = CCSprite:create("Image/imgres/wujiang/yf_icon.png")
		pSpYufen:setPosition(ccp(-15, -35))
		pControl:addNode( pSpYufen )

		local pSpYufenBg = CCSprite:create("Image/imgres/wujiang/yf_pro_bg.png")
		pSpYufenBg:setAnchorPoint(ccp(0,0))
		pSpYufenBg:setPosition(ccp(55, -44))
		pControl:addNode( pSpYufenBg )

		local tabState = {}
		local tabRelationData = GetRelationData(nGrid)

		for i=1, #tabRelationData do
			if tabRelationData[i].State~=GeneralRelationData.RelationState.NotActivted then
				table.insert( tabState, tabRelationData[i].State )
			end
		end

		local function CreateYFSp( nPath )
			local pSp = CCSprite:create(nPath)
			pSp:setPosition(ccp(12 + self.YFIndex * 16, 11))
			pSpYufenBg:addChild( pSp )	
			self.YFIndex = self.YFIndex + 1

		end

		local tabSortState = SortRelationStateTab(tabState)
		
		for i=1, GeneralRelationData.MAX_RELATION_COUNT do
			if i<=#tabSortState then
				if tabSortState[i]==GeneralRelationData.RelationState.Solidified then
					CreateYFSp("Image/imgres/wujiang/yf_n.png")					
				elseif tabSortState[i]==GeneralRelationData.RelationState.Solidifying then
					CreateYFSp("Image/imgres/wujiang/yf_l.png")
				end
			end
		end

	end

	local function CreateIsMatrix(  )
		-- 是否上阵
		if tonumber(GetGoOutByGrid(nGrid)) == 1 then
			local pSpMatrix = CCSprite:create("Image/imgres/wujiang/up.png")
			pSpMatrix:setPosition(ccp(-140, 47))
			pControl:addNode( pSpMatrix )
		end
	end

	local function CreateClickCallBack(  )

		local function _Click_Item_CallBack( sender, eventType )
			if eventType == TouchEventType.ended then
				MainScene.ShowLeftInfo(false)
				MainScene.ClearRootBtn()
				MainScene.DeleteUILayer(GeneralOptLayer.GetUIControl())
				local pLayerOperate = GeneralOptLayer.CreateGeneralOptLayer(sender:getTag(), self.nType, self.nPos, self.CallBack, 0)
				if pLayerOperate~=nil then
					local pSceneGame =  CCDirector:sharedDirector():getRunningScene()
					pSceneGame:addChild(pLayerOperate, layerWujiangOperate_Tag, layerWujiangOperate_Tag)
					MainScene.PushUILayer(pLayerOperate)
				end
			end
		end

		local Btn_Node = Widget:create()
		Btn_Node:setEnabled(true)
		Btn_Node:setTouchEnabled(true)
		Btn_Node:ignoreContentAdaptWithSize(false)
	    Btn_Node:setSize(CCSize(340, 140))
		Btn_Node:setTag(nGrid)
		Btn_Node:addTouchEventListener(_Click_Item_CallBack)
		Btn_Node:setPosition(ccp(0,0))
		Btn_Node:setVisible(false)
		pControl:addChild(Btn_Node,1300)
	end


	local pActionArrayRefresh = CCArray:create()

	pActionArrayRefresh:addObject(CCCallFunc:create(CreateFrameBg))

	pActionArrayRefresh:addObject(CCCallFunc:create(CreateNameBg))

	pActionArrayRefresh:addObject(CCCallFunc:create(CreateName))

	pActionArrayRefresh:addObject(CCCallFunc:create(CreateHead))

	pActionArrayRefresh:addObject(CCCallFunc:create(CreateColor))

	pActionArrayRefresh:addObject(CCCallFunc:create(CreateHeadBg))

	pActionArrayRefresh:addObject(CCCallFunc:create(CreateLevel))

	pActionArrayRefresh:addObject(CCCallFunc:create(CreateZhenY))

	pActionArrayRefresh:addObject(CCCallFunc:create(CreateCountry))

	pActionArrayRefresh:addObject(CCCallFunc:create(CreateStar))

	if nGeneralType == GeneralType.HuFa then

		pActionArrayRefresh:addObject(CCCallFunc:create(CreateBlog))

	else

		pActionArrayRefresh:addObject(CCCallFunc:create(CreateGeneralInfo))

	end

	pActionArrayRefresh:addObject(CCCallFunc:create(CreateIsMatrix))

	pActionArrayRefresh:addObject(CCCallFunc:create(CreateClickCallBack))

	pControl:runAction(CCSequence:create(pActionArrayRefresh))


end

local function UpdateGeneralWidgetByGeneralId( self, tabGeneralData, pControl )
	local nGeneralId = tabGeneralData["GeneralId"]

	--已召集的武将
	local pItem_Bg = CCScale9Sprite:create("Image/imgres/wujiang/common_bg.png")
	pItem_Bg:setContentSize(CCSize(343,145))
	pItem_Bg:setPosition(ccp( 0, 0 ))
	pControl:addNode(pItem_Bg)

	local function CreateFrameBg(  )
		--花纹底图
		local pFrameBg = CCSprite:create("Image/imgres/wujiang/wj_bg_wen.png")
		pFrameBg:setTextureRect(CCRectMake(0.5, 0.5, 340, 91))
		pFrameBg:setPosition( ccp(-10, -17) )
		pControl:addNode( pFrameBg )	
	end

	local function CreateNameBg(  )
		--姓名底图
		local pNameBg = CCSprite:create("Image/imgres/wujiang/name_bg.png")
		pNameBg:setPosition(ccp(0, 46))
		pControl:addNode( pNameBg )	
	end

	local function CreateName(  )
		--姓名
		local nNameLabel = CreateLabel(GetGeneralNameByTempId(nGeneralId), 24, ccc3(255,255,255), CommonData.g_FONT1, ccp(37,48))
		pControl:addChild( nNameLabel )
	end

	local function CreateHead(  )
		-- 头像信息
		local pHeadSp_Bg_Left = CCSprite:create("Image/imgres/common/bottom.png")
		pHeadSp_Bg_Left:setPosition(ccp(-102, 15))
		pHeadSp_Bg_Left:setScale(0.9)
		pControl:addNode( pHeadSp_Bg_Left )

		SpriteSetGray(pHeadSp_Bg_Left,1)

	end

	local function CreateColor(  )
		local nColorPath = GetGeneralColorIcon(nGeneralId)
		local pColor = CCSprite:create(nColorPath)
		pColor:setScale(0.9)
		pColor:setPosition(ccp(-102, 15))
		pControl:addNode( pColor )

		SpriteSetGray(pColor,1)
	end

	local function CreateHeadBg(  )
		local nHeadPath = GetGeneralHeadIcon(nGeneralId)
		local pHead = CCSprite:create(nHeadPath)
		pHead:setScale(0.9)
		pHead:setPosition(ccp(-98, 28))
		pControl:addNode( pHead )

		SpriteSetGray(pHead,1)
	end

	local function CreateCallSp(  )
		local pCall = CCSprite:create("Image/imgres/wujiang/cancall.png")
		pCall:setPosition(ccp(52, 0))
		pControl:addNode( pCall )		
	end

	local function CreateProcess(  )
		--进度条背景
		local pProBg = CCSprite:create("Image/imgres/wujiang/progress_bg.png")
		pProBg:setPosition(ccp(52, -30))
		pControl:addNode( pProBg )	

		--进度条
		local loadingBar_Collection = LoadingBar:create()
		loadingBar_Collection:loadTexture("Image/imgres/wujiang/progress.png")
		loadingBar_Collection:setDirection(0)
		loadingBar_Collection:setPercent(100)
		loadingBar_Collection:setPosition(ccp(52, -30))
		pControl:addChild( loadingBar_Collection, 1 )				
	end

	local function CreateZhenY(  )
		--人物阵营
		local nZhenYPath = GetGeneralTypeIconByTempId(nGeneralId)
		local pZhenY= CCSprite:create(nZhenYPath)
		pZhenY:setPosition(ccp(-55, 55))
		pControl:addNode( pZhenY )
	end

	local function CreateCountry(  )
		--人物标识
		local nCountryPath = GetGeneralCountryIconByTempId(nGeneralId)
		local pCountry = CCSprite:create(nCountryPath)
		pCountry:setPosition(ccp(141, 47))
		pControl:addNode( pCountry )
	end

	local function CreateClickCallBack(  )

		local function _Click_General_CallBack( sender, eventType )
			if eventType == TouchEventType.ended then
				local pCallLayer = GeneralCallLayer.CreateGeneralCallLayer(sender:getTag(), self.nType, self.nPos, self.CallBack)
				if pCallLayer~=nil then
					local pRunningScene = CCDirector:sharedDirector():getRunningScene()
					pRunningScene:addChild(pCallLayer, layerWujiangOperate_Tag, layerWujiangOperate_Tag)
				end
			end
		end


		local Btn_Node = Widget:create()
		Btn_Node:setEnabled(true)
		Btn_Node:setTouchEnabled(true)
		Btn_Node:ignoreContentAdaptWithSize(false)
	    Btn_Node:setSize(CCSize(340, 140))
		Btn_Node:setTag(tabGeneralData["ItemId"])
		Btn_Node:addTouchEventListener(_Click_General_CallBack)
		Btn_Node:setPosition(ccp(0,0))
		Btn_Node:setVisible(false)
		pControl:addChild(Btn_Node,1300)
	end

	local pActionArrayRefresh = CCArray:create()

	pActionArrayRefresh:addObject(CCCallFunc:create(CreateFrameBg))

	pActionArrayRefresh:addObject(CCCallFunc:create(CreateNameBg))

	pActionArrayRefresh:addObject(CCCallFunc:create(CreateName))

	pActionArrayRefresh:addObject(CCCallFunc:create(CreateHead))

	pActionArrayRefresh:addObject(CCCallFunc:create(CreateColor))

	pActionArrayRefresh:addObject(CCCallFunc:create(CreateHeadBg))

	pActionArrayRefresh:addObject(CCCallFunc:create(CreateCallSp))

	pActionArrayRefresh:addObject(CCCallFunc:create(CreateProcess))

	pActionArrayRefresh:addObject(CCCallFunc:create(CreateZhenY))

	pActionArrayRefresh:addObject(CCCallFunc:create(CreateCountry))

	pActionArrayRefresh:addObject(CCCallFunc:create(CreateClickCallBack))

	pControl:runAction(CCSequence:create(pActionArrayRefresh))


end

local function InitItem( self, tabData, index, isEnd )

	if self.ParentLayout == nil then return end

	if isEnd == nil then

		if tabData[index-1]["State"] == 0 or tabData[index]["State"] == 0 then
			return false
		end

	else

		if tabData[index]["State"] == 0 then
			return false
		end		

	end

	local pLayout_Left = Layout:create()
	pLayout_Left:setAnchorPoint(ccp( 0, 0 ))
	pLayout_Left:setSize(CCSizeMake(343,145))
	pLayout_Left:setPosition(ccp( 195, 67 ))

	self.ParentLayout:addChild( pLayout_Left )

	local pLayout_Right = Layout:create()
	pLayout_Right:setAnchorPoint(ccp( 0, 0 ))
	pLayout_Right:setSize(CCSizeMake(343,145))
	pLayout_Right:setPosition(ccp( 555, 67 ))

	self.ParentLayout:addChild( pLayout_Right )

	--Left
	local function InitLeft(  )
		local pIndex = index-1
		if isEnd == true then
			pIndex = index
		end
		if tabData[pIndex]["State"] == 1 then
			UpdateGeneralWidgetByGrid( self, tabData[pIndex]["Grid"],  pLayout_Left )
		elseif tabData[pIndex]["State"]== 2 then
			UpdateGeneralWidgetByGeneralId( self, tabData[pIndex],  pLayout_Left )
		end
	end

	--Right
	local function InitRight(  )
		if tabData[index]["State"]== 1 then
			UpdateGeneralWidgetByGrid( self, tabData[index]["Grid"],  pLayout_Right )
		elseif tabData[index]["State"]== 2 then
			UpdateGeneralWidgetByGeneralId( self, tabData[index],  pLayout_Right )
		elseif tabData[index]["State"] == -1 then
			pLayout_Right:setVisible(false)
		end
	end

	--initover
	local function InitOver(  )
		self.bInit = true
	end

	local pActionArrayInit = CCArray:create()
	pActionArrayInit:addObject(CCCallFunc:create(InitLeft))
	if isEnd == nil then
		pActionArrayInit:addObject(CCCallFunc:create(InitRight))
	end
	pActionArrayInit:addObject(CCCallFunc:create(InitOver))

	self.ParentLayout:runAction(CCSequence:create(pActionArrayInit))


	return true
end

local function GetInitState( self )
	return self.bInit
end

local function CreateItem( self, nType, nPos, nCallBack )
	self.ParentLayout = Layout:create()
	self.ParentLayout:setSize( CCSizeMake( 750, 140 ) )

	self.nType = nType

	self.nPos  = nPos

	self.CallBack = nCallBack

	self.isVisible = false

	self.YFIndex = 0

	self.bInit = false 				--是否初始化完成
end

local function GetItem( self )
	if self.ParentLayout ~= nil then
		return self.ParentLayout
	end
end


function Create(  )
	local tab = {
		CreateItem 			= CreateItem,
		InitItem 			= InitItem,
		GetItem 			= GetItem,
		SetVisible 			= SetVisible,
		GetVisible 			= GetVisible,
		ReleaseItem 		= ReleaseItem,
		GetInitState 		= GetInitState,
	}

	return tab
end

