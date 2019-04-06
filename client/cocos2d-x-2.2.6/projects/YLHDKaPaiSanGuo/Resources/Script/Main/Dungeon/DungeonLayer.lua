require "Script/Common/Common"
require "Script/Common/CommonData"
require "Script/Main/Dungeon/DungeonBaseData"
require "Script/Main/Dungeon/DungeonLogic"
require "Script/Main/Dungeon/EnterPointLayer"
require "Script/Main/Dungeon/DungeonBaseUILogic"

module("DungeonLayer", package.seeall)


local MAXPOINTCOUNT = 15

-- 普通副本数量
local m_nSceneCount = nil
-- 每一章的关卡数量
local m_nPointCount = nil
-- 当前页面的场景ID
local m_nSceneId = nil
-- 能开放的场景索引, 控制箭头显示
local m_nCurSceneIdx = nil
-- 当前场景的索引
local m_nSceneIdx = nil
-- 创建出来最后的场景索引
local m_nLastSceneIdx = nil
-- 可战斗的关卡索引
local m_nCurPointIdx = nil
local m_pLayerDungeon = nil
local m_pLabelName = nil
local m_pPageViewDungeon = nil
local m_pBtnLfet = nil
local m_pBtnRight = nil
local m_isCreateNext = nil

local CreateStrokeLabel				= LabelLayer.createStrokeLabel
local SetStrokeLabelText			= LabelLayer.setText

local CreateTimeLayer				= TipLayer.createTimeLayer
local GetSceneId					= DungeonBaseData.GetSceneId
local GetMapImage 					= DungeonBaseData.GetMapImage
local GetMapName					= DungeonBaseData.GetMapName
local GetMonsterList				= DungeonBaseData.GetMonsterList
local GetPointType 					= DungeonBaseData.GetPointType
local GetPointCount 			 	= DungeonBaseData.GetPointCount
local GetSceneRuleId				= DungeonBaseData.GetSceneRuleId
local GetPointRuleId				= DungeonBaseData.GetPointRuleId
local GetSceneType					= DungeonBaseData.GetSceneType

local MakePointPos					= DungeonLogic.MakePointPos
local GetPointImage					= DungeonLogic.GetPointImage
local IsOnly						= DungeonLogic.IsOnly
local SceneCanCreate				= DungeonLogic.SceneCanCreate
local SceneCanOpen					= DungeonLogic.SceneCanOpen
local GetErrorCodeText				= DungeonLogic.GetErrorCodeText
local GetSceneCount					= DungeonLogic.GetSceneCount
local CheckPointIsBoss				= DungeonLogic.CheckPointIsBoss
local GetLastSceneIdxAndPointIdxByElite	= DungeonLogic.GetLastSceneIdxAndPointIdxByElite

local GetPointId					= DungeonBaseData.GetPointId

local GetMonsterResId				= DungeonBaseData.GetMonsterResId
local GetPointImageByType			= DungeonLogic.GetPointImageByType

local GetLastSceneIdxAndPointIdx	= DungeonLogic.GetLastSceneIdxAndPointIdx

local CreatePoint 					= DungeonBaseUILogic.CreatePoint
local CreateBossAniLayout			= DungeonBaseUILogic.CreateBossAniLayout
local CreateStarLayout 				= DungeonBaseUILogic.CreateStarLayout
local UpdatePointStars				= DungeonBaseUILogic.UpdatePointStars
local _Point_Img_CallBack			= DungeonBaseUILogic._Point_Img_CallBack
local _Point_Layout_CallBack		= DungeonBaseUILogic._Point_Layout_CallBack
local OpenEnterPointLayer 			= DungeonBaseUILogic.OpenEnterPointLayer

local function InitVars( )
	m_nLastSceneIdx = nil
	m_nSceneCount = nil
	m_nPointCount = nil
	m_nSceneId = nil
	m_nCurSceneIdx = nil
	m_nSceneIdx = nil
	m_nCurPointIdx = nil
	m_pLayerDungeon = nil
	m_pLabelName = nil
	m_pPageViewDungeon = nil
	m_pBtnLfet = nil
	m_pBtnRight = nil
	m_isCreateNext = nil
end

-- 关卡图标回调
local function _Point_Img_Click_CallBack( sender, eventType )
	AudioUtil.PlayBtnClick()
	if m_pPageViewDungeon:getPage(m_nSceneIdx-1):getNodeByTag(1990) ~= nil then
		m_pPageViewDungeon:getPage(m_nSceneIdx-1):getNodeByTag(1990):removeFromParentAndCleanup(true)
	end
	_Point_Img_CallBack(sender, eventType,sender:getParent(), m_nSceneIdx)
end

-- 关卡动作回调
local function _Point_Layout_Click_CallBack( sender, eventType )
	_Point_Layout_CallBack(sender, eventType, sender:getParent(), m_nSceneIdx)
end

local function HandlePointEffect( pCurPage, pImagePoint, nEffectTag )
	local pEffect = pImagePoint:getChildByTag(nEffectTag)
	if pEffect~=nil then
		pImagePoint:removeChild(pEffect, true)
	end

	pCurSceneIdx, pCurPointIdx = GetLastSceneIdxAndPointIdx(DungeonsType.Normal)

	if m_nCurPointIdx == nEffectTag  and m_nSceneIdx==m_nLastSceneIdx  then

		CommonInterface.GetAnimationByName("Image/imgres/effectfile/fuben_zhengzhan.ExportJson",
									"fuben_zhengzhan", "fuben_zhengzhan",
									pImagePoint, ccp(0,0), nil, nEffectTag)
	end
end

local function EnableWidget( pWidget, bVisible, bEnable )
	if pWidget~=nil then
		pWidget:setVisible(bVisible)
		pWidget:setTouchEnabled(bEnable)
	end
end

local function EnablePointBoxImg( pPoint, bVisible )
	if pPoint:getChildByTag(99) ~= nil then
		pPoint:getChildByTag(99):setVisible(bVisible)
	end
end

local function EnableSmallPoint( pPoint, bVisible, bEnable )
	if pPoint ~= nil then
		pPoint:setVisible(bVisible)
		pPoint:setTouchEnabled(bEnable)
	end
end

-- 处理小关卡状态
local function HnadleSmallPointState( pImagePoint, nStars, bOnly, bCanFight )
	local pSprite = tolua.cast(pImagePoint:getVirtualRenderer(), "CCSprite")
	if nStars>-1  then -- 已通关的关卡
		if bOnly==true then --关卡是唯一的
			--EnableWidget(pImagePoint, false, false)
			EnableSmallPoint(pImagePoint, true, false)
			SpriteSetGray(pSprite,1)
			EnablePointBoxImg(pImagePoint, false)
		else -- 关卡不是唯一的
			EnableWidget(pImagePoint, true, true)
			EnablePointBoxImg(pImagePoint, false)
		end
	else -- 未通关的关卡
		if bCanFight==true then -- 能战斗的关卡
			EnableWidget(pImagePoint, true, true)
			EnablePointBoxImg(pImagePoint, true)
			SpriteSetGray(pSprite,0)
		else -- 不能战斗的关卡
			EnablePointBoxImg(pImagePoint, false)
			EnableWidget(pImagePoint, true, false)
			SpriteSetGray(pSprite,1)
		end
	end
end

-- 处理关卡怪物动作
local function HandleMonsterAction( pLayoutPoint, bCanFight )
	if pLayoutPoint~=nil then
		local pArrArmature = pLayoutPoint:getNodes()
		local pArmature = pArrArmature:objectAtIndex(0)
		if bCanFight==true then
			CCArmatureSharder(pArmature,SharderKey.E_SharderKey_Normal)
			pArmature:getAnimation():play(GetAniName_Res_ID(pArmature:getTag(),  Ani_Def_Key.Ani_stand))
		else
			CCArmatureSharder(pArmature,SharderKey.E_SharderKey_SpriteGray)
			pArmature:getAnimation():stop()
		end
	end
end

-- 处理大关卡状态
local function HnadleBigPointState( pImagePoint, pLayoutPoint, pStarLayout, nStars, bOnly,  bCanFight )
	local pSprite = tolua.cast(pImagePoint:getVirtualRenderer(), "CCSprite")
		if nStars >-1 then -- 已经通关的关卡
			if bOnly ==true then -- 关卡是唯一的, 禁用关卡控件
				EnableWidget(pImagePoint, false, false)
				EnableWidget(pLayoutPoint, false, false)
				EnableWidget(pStarLayout, false, false)
			else -- 关卡不是唯一的
				EnableWidget(pImagePoint, true, true)
				EnableWidget(pLayoutPoint, true, true)
				EnableWidget(pStarLayout, true, false)
				HandleMonsterAction(pLayoutPoint, bCanFight)
			end
		else -- 未通关可战斗的关卡
			if bCanFight==true then
				EnableWidget(pImagePoint, true, true)
				EnableWidget(pLayoutPoint, true, true)
				EnableWidget(pStarLayout, true, false)
				SpriteSetGray(pSprite,0)
			else -- 未通关不可战斗的关卡
				EnableWidget(pImagePoint, true, false)
				EnableWidget(pLayoutPoint, true, false)
				EnableWidget(pStarLayout, false, false)
				SpriteSetGray(pSprite,1)
			end
			HandleMonsterAction(pLayoutPoint, bCanFight)
		end
end

local function UpdateAllPointState( pCurPage, nSceneIdx, bOrder )
	local nCurPointIdx = m_nCurPointIdx
	if pCurPage:getTag()~= m_nCurSceneIdx then
		nCurPointIdx = m_nPointCount
	end
	for i=1, m_nPointCount do
		local pImagePoint = tolua.cast(pCurPage:getChildByName("pointImg_"..i), "ImageView")

		HandlePointEffect(pCurPage, pImagePoint, i)

		local nStars = server_fubenDB.GetPointStars(GetSceneType(nSceneIdx), m_nSceneId, i)
		local nPointId = GetPointId(nSceneIdx, i)
		local nPointRuleId = GetPointRuleId(nPointId)
		local nPointType = GetPointType(nSceneIdx, i)
		local bOnly = IsOnly(nPointRuleId)
		if nPointType == PointType.Small then-- 小关卡
			if bOrder==true then
				if i<=nCurPointIdx then
					HnadleSmallPointState(pImagePoint, nStars, bOnly, true)
				else
					HnadleSmallPointState(pImagePoint, nStars, bOnly,  false)
				end
			else
				HnadleSmallPointState(pImagePoint, nStars, bOnly, true)
			end
		else -- 大关卡
			local pLayoutPoint = tolua.cast(pCurPage:getChildByName("pointLayout_"..i), "Layout")
			local pStarLayout = tolua.cast(pCurPage:getChildByName("star_Layout"..i), "Layout")
			if bOrder==true then

				if i<=nCurPointIdx then
					-- print()
					HnadleBigPointState(pImagePoint, pLayoutPoint, pStarLayout, nStars, bOnly, true)
				else
					HnadleBigPointState(pImagePoint, pLayoutPoint, pStarLayout, nStars, bOnly, false)
				end
			else
				HnadleBigPointState(pImagePoint, pLayoutPoint, pStarLayout, nStars, bOnly, true)
			end
			UpdatePointStars(pStarLayout, nStars)
		end
	end
end
-- 更新关卡信息
local function UpdatePointsState( pCurPage )
	if m_pPageViewDungeon==nil or pCurPage==nil then
		return
	end
	local nSceneIdx = pCurPage:getTag()
	--if GetSceneRuleId(m_nSceneIdx) == 1 then
	--	UpdateAllPointState(pCurPage, nSceneIdx, false)
	--else
		UpdateAllPointState(pCurPage, nSceneIdx, true)
	--end
end

-- 创建关卡地图
local function LoadMapIamge( nSceneIdx )
	local pImageMap = ImageView:create()
	pImageMap:setTouchEnabled(false)
	pImageMap:setAnchorPoint(ccp(0.0,0.0))
	pImageMap:loadTexture(GetMapImage(nSceneIdx))
	return pImageMap
end

-- 创建所有关卡
local function CreateAllPoint( pvLayout, nSceneIdx )
	if pvLayout==nil then
		print("pvLayout is nil ")
		return
	end
	pvLayout:addChild(LoadMapIamge(nSceneIdx))
	for i=1, m_nPointCount do
		local nType = GetPointType(nSceneIdx, i)
		local ptPos = MakePointPos(nSceneIdx, i)
		local pImagePoint = CreatePoint(nType, i, ptPos, _Point_Img_Click_CallBack)
		pvLayout:addChild(pImagePoint, pvLayout:getSize().height-ptPos.y, i)
		if nType~=PointType.Small then
			local pAniLayout = CreateBossAniLayout( pImagePoint, nSceneIdx, i, _Point_Layout_Click_CallBack)
			if pAniLayout~=nil then
				pvLayout:addChild(pAniLayout,  pvLayout:getSize().height-ptPos.y, i)
			end
			local pStarLayout = CreateStarLayout(pImagePoint, i)
			pvLayout:addChild(pStarLayout, 999, i)
		end
	end
end

-- 更换地图名称
local function ChangeMapName( nSceneIdx )
	local strSceneName = GetMapName(nSceneIdx)
	m_pLabelName:setText(strSceneName)
	local pParent = m_pLabelName:getParent()
	pParent:setSize(CCSize(m_pLabelName:getContentSize().width, pParent:getSize().height))
end

local function ChangeSceneIdx( nInc )
	m_nCurSceneIdx, m_nCurPointIdx = GetLastSceneIdxAndPointIdx(DungeonsType.Normal)
	if m_nSceneIdx>=1 and m_nSceneIdx<=m_nCurSceneIdx then
		m_nSceneIdx = m_nSceneIdx + nInc
		if m_nCurSceneIdx==1 then
			if m_nSceneIdx <= m_nCurSceneIdx then
				m_nSceneIdx=1
				EnableWidget(m_pBtnLfet, false, false)
			else
				EnableWidget(m_pBtnLfet, true, true)
				EnableWidget(m_pBtnRight, false, false)
			end
		else
			--print(m_nSceneIdx, m_nCurSceneIdx)
			--Pause()
			if m_nSceneIdx<=1 then
				m_nSceneIdx=1
				EnableWidget(m_pBtnLfet, false, false)
				EnableWidget(m_pBtnRight, true, true)
			elseif m_nSceneIdx>=m_nCurSceneIdx then
				m_nSceneIdx = m_nCurSceneIdx
				EnableWidget(m_pBtnLfet, true, true)
				EnableWidget(m_pBtnRight, false, false)
			else
				EnableWidget(m_pBtnLfet, true, true)
				EnableWidget(m_pBtnRight, true, true)
			end
		end
	end
end

-- 更新副本数据和状态
local function UpdateSceneStaticData( nSceneIdx )
	local pSceneIndex = m_nSceneIdx
	if nSceneIdx ~= nil then
		pSceneIndex = nSceneIdx
	end
	m_nPointCount = GetPointCount(pSceneIndex)
	m_nSceneId = GetSceneId(pSceneIndex)
	ChangeMapName(pSceneIndex)
end

local function CalcLastSceneIdx( )
	-- 获取通关的最后场景索引和关卡索引
	m_nCurSceneIdx, m_nCurPointIdx = GetLastSceneIdxAndPointIdx(DungeonsType.Normal)

	-- 判断本章地图是否能创建
	local nCurErrorCode = SceneCanCreate(m_nCurSceneIdx, m_nSceneCount)
	if nCurErrorCode~=0 then
		m_nLastSceneIdx = m_nCurSceneIdx - 1
	else
		m_nLastSceneIdx = m_nCurSceneIdx
		-- 如果本章地图能够创建, 判断下章地图是否能创建
		local nNextErrorCode = SceneCanCreate(m_nCurSceneIdx+1, m_nSceneCount)
		if nNextErrorCode==0 then --and  m_nPointCount==m_nCurPointIdx then
			m_nCurSceneIdx = m_nCurSceneIdx+1
		end
	end
	--Log("m_nCurSceneIdx = "..m_nCurSceneIdx.."\tm_nLastSceneIdx = "..m_nLastSceneIdx.."\tm_nCurPointIdx = "..m_nCurPointIdx)
end

local function UpdatePointZOrder( pCurPage )
	for i=1, m_nPointCount do

	end
end

-- 创建空地图
local function CreateMapLayout( nSceneIdx )
	local pvLayout = Layout:create()
	pvLayout:setTag(nSceneIdx)
	pvLayout:setTouchEnabled(false)
	pvLayout:setSize(CCSize(1140, 640))
	m_pPageViewDungeon:addPage(pvLayout)
end

-- 处理地图数据
local function HandleSceneData( nCurSceneIdx )
	local pCurPage = m_pPageViewDungeon:getPage(nCurSceneIdx-1)
	if pCurPage==nil then -- 页面没有被创建, 创建页面和关卡
		CreateMapLayout(nCurSceneIdx)
		CreateAllPoint(m_pPageViewDungeon:getPage(nCurSceneIdx-1), nCurSceneIdx)
	else -- 页面已经被创建过
		if pCurPage:getChildrenCount()==0 then -- 页面上没有控件, 创建关卡
			CreateAllPoint(pCurPage, nCurSceneIdx)
		end
	end
	UpdatePointsState(m_pPageViewDungeon:getPage(nCurSceneIdx-1))
	m_pPageViewDungeon:scrollToPage(nCurSceneIdx-1)
end

local function HandleErrorState( nErrorCode )
	local strError = GetErrorCodeText(nErrorCode)
	CreateTimeLayer(strError, 2)
end

-- 更新每一张地图的信息
function UpdateMapData( nSceneIdx, nPointIdx )
	local pCurPage = m_pPageViewDungeon:getPage(m_pPageViewDungeon:getCurPageIndex())
	if pCurPage==nil then
		return
	end
	local isScroll = false
	if nSceneIdx ~= nil and nPointIdx ~= nil then
		if nSceneIdx == m_nCurSceneIdx then
			isScroll = true
		end
	end
	CalcLastSceneIdx()
	ChangeSceneIdx(0)
	UpdateSceneStaticData()
	UpdatePointsState(pCurPage)
	--print(isScroll, nSceneIdx, m_nCurSceneIdx)
	--print("isScroll, nSceneIdx, m_nCurSceneIdx")
	--Pause()
	if nSceneIdx ~= nil and nPointIdx ~= nil then
		if isScroll == true then
			local nErrorCode = SceneCanCreate(nSceneIdx + 1, m_nSceneCount, m_nSceneId)
			--如果这关是boss关，并且等级符合要求则进行翻页
			if CheckPointIsBoss(nSceneIdx, nPointIdx) == true and nErrorCode==0 then
				ChangeSceneIdx(1)
				UpdateSceneStaticData()
				HandleSceneData(m_nSceneIdx)
			end
		end
	end
end

local function _Btn_Left_Dungeon_CallBack(  )
	m_nCurSceneIdx, m_nCurPointIdx = GetLastSceneIdxAndPointIdx(DungeonsType.Normal)
	ChangeSceneIdx(-1)
	UpdateSceneStaticData()
	HandleSceneData(m_nSceneIdx)
end

local function _Btn_Right_Dungeon_CallBack( )
	-- 先检测下一关开放条件是否满足
	m_nCurSceneIdx, m_nCurPointIdx = GetLastSceneIdxAndPointIdx(DungeonsType.Normal)
	local nErrorCode = SceneCanCreate(m_nSceneIdx + 1, m_nSceneCount, m_nSceneId)
	if nErrorCode==0 then
		ChangeSceneIdx(1)
		UpdateSceneStaticData()
		HandleSceneData(m_nSceneIdx)
	else
		HandleErrorState(nErrorCode)
		--Pause()
	end
end

local function InitWidgets(  )
	m_pLayerDungeon = GUIReader:shareReader():widgetFromJsonFile("Image/DungeonLayer.json")

	m_pBtnLfet = tolua.cast(m_pLayerDungeon:getChildByName("Button_Left"),"Button")
	if m_pBtnLfet==nil then
		print("m_pBtnLfet is nil")
		return false
	else
		CreateBtnCallBack(m_pBtnLfet, nil, nil, _Btn_Left_Dungeon_CallBack)
	end

	m_pBtnRight = tolua.cast(m_pLayerDungeon:getChildByName("Button_Right"),"Button")
	if m_pBtnRight==nil then
		print("m_pBtnRight is nil")
		return false
	else
		CreateBtnCallBack(m_pBtnRight, nil, nil, _Btn_Right_Dungeon_CallBack)
	end

	local pImageName = tolua.cast(m_pLayerDungeon:getChildByName("Image_Name"), "ImageView")
	m_pLabelName = Label:create()
	if m_pLabelName==nil then
		print("m_pLabelName is nil")
		return false
	else
		m_pLabelName:setPosition(ccp(0,0))
		m_pLabelName:setFontSize(25)
		m_pLabelName:setFontName(CommonData.g_FONT1)
		pImageName:addChild(m_pLabelName)
	end

	m_pPageViewDungeon = tolua.cast(m_pLayerDungeon:getChildByName("PageView_Dungeon"), "PageView")
	if m_pPageViewDungeon==nil then
		print("m_pPageViewDungeon is nil")
		return false
	end

	return true
end

--GotoManager CallFunc
function GoToManagerCallFuncByNormal( nSceneIdx, nPointIdx )
	--取当前的最后关卡
	if m_nCurSceneIdx ~= nil and m_nCurPointIdx ~= nil then

		local pSceneIndex = m_nCurSceneIdx   		--取最后通关场景

		local pPointIndex = m_nCurPointIdx			--取最后通关关卡

		if nSceneIdx ~= 0 and nPointIdx ~= 0 then

			if nSceneIdx < m_nCurSceneIdx then
				--如果当前要跳转的场景比最后通关场景小，则调用Left_Btn功能
				ChangeSceneIdx(-1)
				UpdateSceneStaticData()
				HandleSceneData(m_nSceneIdx)

				--[[ChangeSceneIdx(nSceneIdx)
				UpdateSceneStaticData(nSceneIdx)
				HandleSceneData(nSceneIdx+1)]]

				pSceneIndex = nSceneIdx

				pPointIndex = nPointIdx

			elseif nSceneIdx > m_nSceneIdx then
				--如果当前要跳转的场景比最后通关场景要大，则直接使用最后通关场景,不做任何操作

			elseif nSceneIdx == m_nSceneIdx then
				--如果当前要跳转的场景和最后通关场景一样，则判断关卡
				if nPointIdx < m_nCurPointIdx then

					pSceneIndex = nSceneIdx

					pPointIndex = nPointIdx

				else

					pPointIndex = m_nCurPointIdx

				end

			end
			
		end

		--点击指引效果
		if m_pPageViewDungeon:getPage(pSceneIndex-1):getNodeByTag(1990) ~= nil then
			m_pPageViewDungeon:getPage(pSceneIndex-1):getNodeByTag(1990):removeFromParentAndCleanup(true)
		end

		local GuideAnimation = CommonData.g_GuildeManager:GetGuildeAni()

		--获取战役关卡坐标
		local nPt = MakePointPos(pSceneIndex, pPointIndex)

		GuideAnimation:setPosition(ccp(nPt.x, nPt.y + 10))

		m_pPageViewDungeon:getPage(pSceneIndex-1):addNode(GuideAnimation, 1990, 1990)

		--[[local pSceneIndex = m_nCurSceneIdx

		local pPointIndex = m_nCurPointIdx

		if nSceneIdx <= m_nCurSceneIdx and nSceneIdx ~= 0 then

			pSceneIndex = nSceneIdx

			pPointIndex = nPointIdx

		end

		UpdateSceneStaticData( pSceneIndex )
		HandleSceneData(pSceneIndex)

		--点击指引效果
		if m_pPageViewDungeon:getPage(pSceneIndex-1):getNodeByTag(1990) ~= nil then
			m_pPageViewDungeon:getPage(pSceneIndex-1):getNodeByTag(1990):removeFromParentAndCleanup(true)
		end

		local GuideAnimation = CommonData.g_GuildeManager:GetGuildeAni()

		--获取战役关卡坐标
		local nPt = MakePointPos(pSceneIndex, pPointIndex)

		GuideAnimation:setPosition(ccp(nPt.x, nPt.y + 10))

		m_pPageViewDungeon:getPage(pSceneIndex-1):addNode(GuideAnimation, 1990, 1990)]]

	end

end

function GetDungeonByNewGuilde( nType, nSceneIdx, nPointIdx, nCallBack )
	if nType == 0 then
		--打开战役详情界面
		OpenEnterPointLayer(nSceneIdx, nPointIdx)
		if nCallBack ~= nil then
			nCallBack()
		end
	elseif nType == 1 then
		--待定
	end
end

function CreateDungeonLayer( nSceneIdx )
	InitVars()
	if InitWidgets()==false then
		return
	end
	m_nSceneCount = GetSceneCount(DungeonsType.Normal)
	CalcLastSceneIdx()
	if nSceneIdx ~= nil then

		m_nLastSceneIdx = 3

	end
	m_nSceneIdx = m_nLastSceneIdx
	--Log("\tm_nSceneIdx = "..m_nSceneIdx)

	ChangeSceneIdx(0)
	UpdateSceneStaticData()
	for i=1, m_nLastSceneIdx do
		CreateMapLayout(i)
	end

	HandleSceneData(m_nSceneIdx)
	return m_pLayerDungeon
end