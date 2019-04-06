require "Script/Main/Dungeon/DungeonBaseData"
require "Script/Main/Dungeon/EliteDungeonData"
require "Script/Main/Dungeon/EnterPointLayer"
require "Script/Main/Dungeon/DungeonLogic"
require "Script/Main/Dungeon/DungeonBaseUILogic"

module("EliteDungeonLayer", package.seeall)

local GetPointPos 					= EliteDungeonData.GetPointPos
local GetPointId 					= DungeonBaseData.GetPointId
local GetSceneId 					= EliteDungeonData.GetSceneId
local GetPageWidth					= EliteDungeonData.GetPageWidth
local GetSceneIdx					= EliteDungeonData.GetSceneIdx
local GetSceneId 					= DungeonBaseData.GetSceneId
local GetSceneType					= DungeonBaseData.GetSceneType

local GetCloud_X 					= EliteDungeonData.GetCloud_X

local GetMonsterList				= DungeonBaseData.GetMonsterList
local GetMonsterResId				= DungeonBaseData.GetMonsterResId
local GetAnimationData				= GeneralBaseData.GetAnimationData
local GetCloudAniIdx				= EliteDungeonData.GetCloudAniIdx
local GetCloudOffX					= EliteDungeonData.GetCloudOffX
local GetCloudOffY					= EliteDungeonData.GetCloudOffY
local GetCloudScaleX				= EliteDungeonData.GetCloudScaleX
local GetCloudScaleY				= EliteDungeonData.GetCloudScaleY
local GetCloudRotation				= EliteDungeonData.GetCloudRotation
local GetElitePointCount			= EliteDungeonData.GetElitePointCount
local GetEliteTimes					= EliteDungeonData.GetEliteTimes

local GetLastSceneIdxAndPointIdx	= DungeonLogic.GetLastSceneIdxAndPointIdx
local GetLastSceneIdxAndPointIdxByElite	= DungeonLogic.GetLastSceneIdxAndPointIdxByElite
local GetSceneCount					= DungeonLogic.GetSceneCount
local CheckEliteDunOpen				= DungeonLogic.CheckEliteDunOpen

local CreatePoint 					= DungeonBaseUILogic.CreatePoint
local CreateBossAniLayout			= DungeonBaseUILogic.CreateBossAniLayout
local CreateStarLayout 				= DungeonBaseUILogic.CreateStarLayout
local UpdatePointStars				= DungeonBaseUILogic.UpdatePointStars
local _Point_Img_CallBack			= DungeonBaseUILogic._Point_Img_CallBack
local _Point_Layout_CallBack		= DungeonBaseUILogic._Point_Layout_CallBack
local GetEliteTimes					= EliteDungeonData.GetEliteTimes

local SetEliteFightedTimes 			= server_fubenDB.SetEliteFightedTimes

local CreateTimeLayer				= TipLayer.createTimeLayer
local m_pLayerEliteDungeon = nil
local m_pScrollViewElite = nil
local m_pLabelTimes = nil
local m_pBtnAddTimes = nil
local m_nPointCount = nil

local function InitVars( )
	m_pLayerEliteDungeon = nil
	m_pScrollViewElite = nil
	m_pLabelTimes = nil
	m_pBtnAddTimes = nil
	m_nPointCount = nil
end

-- 关卡图标回调
local function _Point_Img_Click_CallBack( sender, eventType )
	if eventType==TouchEventType.began then
		AudioUtil.PlayBtnClick()
	end
	if m_pScrollViewElite:getNodeByTag(1990) ~= nil then
		m_pScrollViewElite:getNodeByTag(1990):removeFromParentAndCleanup(true)
	end
	_Point_Img_CallBack(sender, eventType, m_pScrollViewElite, GetSceneIdx(sender:getTag()))
end

-- 关卡动作回调
local function _Point_Layout_Click_CallBack( sender, eventType )
	if eventType==TouchEventType.began then
		AudioUtil.PlayBtnClick()
	end
	_Point_Layout_CallBack(sender, eventType, m_pScrollViewElite, GetSceneIdx(sender:getTag()))
end

local function CreateCloudEffect( strJsonPath, strJsonName, strAniName, nPosX, nPosY,  fOffX, fOffY,  fScaleX, fScaleY, angRotation, nTag )
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(strJsonPath)
    local pArmature = CCArmature:create(strJsonName)
	pArmature:setPosition(ccp(nPosX+fOffX, nPosY+ fOffY))
	pArmature:setTag(nTag)
	pArmature:setScaleX(fScaleX)
	pArmature:setScaleY(fScaleY)
	pArmature:setRotation(angRotation)
	pArmature:getAnimation():play(strAniName)
	return pArmature
end

local function CreatePointLayout( pScrollView, nPointIdx, nStars )
	local pImagePoint = tolua.cast(pScrollView:getChildByName("pointImg_"..nPointIdx), "ImageView")
	pImagePoint = CreatePoint(PointType.Big, nPointIdx, GetPointPos(nPointIdx), _Point_Img_Click_CallBack)
	pScrollView:addChild(pImagePoint, 0, nPointIdx)
	local pAniLayout = CreateBossAniLayout( pImagePoint, GetSceneIdx(nPointIdx), nPointIdx, _Point_Layout_Click_CallBack)
	if pAniLayout~=nil then
		pScrollView:addChild(pAniLayout, 0, nPointIdx)
	end
	local pStarLayout = CreateStarLayout(pImagePoint, nPointIdx)
	pScrollView:addChild(pStarLayout)
end

local function HandlePointEffect( pScrollView, ptPos,  nPointIdx, pEliteSceneIdx, pNormalSceneIdx, pNormalPointIdx)
	local pArmature = pScrollView:getNodeByTag(nPointIdx)
	if pArmature~=nil then
		return
	else
		--根据每个精英关卡的开启rule判断是否解锁云
		
		if CheckEliteDunOpen(pEliteSceneIdx, pNormalSceneIdx, pNormalPointIdx, nPointIdx) == false then
			local nCloudAniIdx = GetCloudAniIdx(nPointIdx)
			if nCloudAniIdx < 0 then
				print("Don't need to add cloud")
				return
			end
			
			pArmature =  CreateCloudEffect("Image/imgres/effectfile/UI_yun.ExportJson", "UI_yun", "Animation"..tostring(nCloudAniIdx),
				ptPos.x, ptPos.y, GetCloudOffX(nPointIdx), GetCloudOffY(nPointIdx),
				GetCloudScaleX(nPointIdx), GetCloudScaleY(nPointIdx),
				GetCloudRotation(nPointIdx), nPointIdx)
			pArmature:getAnimation():play("Animation"..tostring(nCloudAniIdx))
			pScrollView:addNode(pArmature)
		else
			print("第"..nPointIdx.."个精英副本已开启")
			local pImagePoint = tolua.cast(pScrollView:getChildByName("pointImg_"..nPointIdx), "ImageView")
			local nSceneIdx = GetSceneIdx(nPointIdx)
			local nStars = server_fubenDB.GetPointStars(GetSceneType(nSceneIdx), GetSceneId(nSceneIdx), nPointIdx)
			if pImagePoint==nil then
				CreatePointLayout(pScrollView, nPointIdx, nStars)
			end
			-- 更新星星
			local  pStarLayout = pScrollView:getChildByName("star_Layout"..nPointIdx)
			if pStarLayout~=nil then
				UpdatePointStars(pStarLayout, nStars)
			end
			-- 删除云特效
			if pArmature~=nil then
				pArmature:removeFromParentAndCleanup(true)
				pArmature = nil
			end
		end
	end
end

local function HandlePointState( pScrollView, nPointCount )
	local nCurSceneIdx, nCurPointIdx = GetLastSceneIdxAndPointIdx(DungeonsType.Elite)
	local nCurNormalSceneIdx, nCurNormalPointIdx = GetLastSceneIdxAndPointIdxByElite(DungeonsType.Normal)
	--精英副本中PointIdx不需要自动+1
	for i=1, nPointCount do
		HandlePointEffect(pScrollView, GetPointPos(i), i, nCurSceneIdx, nCurNormalSceneIdx, nCurNormalPointIdx)
	end
	-- 更新m_pScrollViewElite内部尺寸
	local nWidth = GetPageWidth(nCurPointIdx)
	m_pScrollViewElite:setInnerContainerSize(CCSize(nWidth, 640))
end

local function CreateEliteMap( nIdx, nPointIdx )
	local pImageMap = ImageView:create()
	pImageMap:loadTexture("Image/imgres/dungeon/elite_"..tostring(nIdx)..".png")
	pImageMap:setAnchorPoint(ccp(0,0))
	pImageMap:setName("ImageBG_"..nIdx)
	pImageMap:setTag(GetSceneIdx(nPointIdx))
	return pImageMap
end

local function UdataeTimes(  )
	local nLeftTimes = GetEliteTimes() - server_fubenDB.GetEliteFightedTimes()
	m_pLabelTimes:setText(tostring(nLeftTimes))
	if nLeftTimes>0 then
		m_pLabelTimes:setColor(ccc3(99,216,53))
		m_pBtnAddTimes:setVisible(false)
		m_pBtnAddTimes:setTouchEnabled(false)
	else
		m_pLabelTimes:setColor(ccc3(255,87,35))
		m_pBtnAddTimes:setVisible(true)
		m_pBtnAddTimes:setTouchEnabled(true)
	end
end

function UpdateLeftTimesFull(  )
	-- 将剩余次数置满
	if m_pLabelTimes ~= nil then
		local nLeftTimes = GetEliteTimes()
		m_pLabelTimes:setText(tostring(nLeftTimes))
		if nLeftTimes>0 then
			m_pLabelTimes:setColor(ccc3(99,216,53))
			m_pBtnAddTimes:setVisible(false)
			m_pBtnAddTimes:setTouchEnabled(false)
		else
			m_pLabelTimes:setColor(ccc3(255,87,35))
			m_pBtnAddTimes:setVisible(true)
			m_pBtnAddTimes:setTouchEnabled(true)
		end
	end

	SetEliteFightedTimes( GetEliteTimes() - GetEliteTimes() )

end

function UpdateEliteMap( )
	HandlePointState(m_pScrollViewElite, m_nPointCount)
	UdataeTimes()
	
end

local function CretaeElitePoints( pScrollView, nPointCount )
	local nScrollViewInnerWidth = 0
	for i=1, nPointCount do
		-- 添加地图
		if i%5==1 then
			local pImageMap = CreateEliteMap(math.ceil(i/5), i)
			if i==1 then
				pImageMap:setPosition(ccp(0, 0))
			else
				pImageMap:setPosition(ccp(nScrollViewInnerWidth , 0))
			end
			nScrollViewInnerWidth = nScrollViewInnerWidth+pImageMap:getSize().width
			pScrollView:addChild(pImageMap)
		end
	end
	HandlePointState(pScrollView, nPointCount)
end

local function _Btn_AddTimes_EliteDungeon_CallBack(  )

	local bVipTab = MainScene.CheckVIPFunction( enumVIPFunction.eVipFunction_12 )

	if m_pSurPlusTimes > 0 then
		--弹出是否购买的Vip页面
		--printTab(bVipTab)
		--Pause()
		local function GoBuy( bState )
			if bState == true then
				if tonumber(server_mainDB.getMainData("gold")) < bVipTab.NeedNum then
					TipLayer.createTimeLayer("金币不足", 2)
					return
				end

				MainScene.BuyCountFunction( enumVIPFunction.eVipFunction_12, 0, 0, UpdateLeftTimesFull )
			end
		end
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1629,GoBuy,bVipTab.NeedNum, bVipTab.name, m_pSurPlusTimes)
		pTips = nil
	else
		--弹出去重置的vip页面
		print("m_pSurPlusTimes = "..m_pSurPlusTimes)
		local pTips = TipCommonLayer.CreateTipLayerManager()

		if tonumber(bVipTab.level) <= 0 then
			pTips:ShowCommonTips(1644,GotoVip,bVipTab.nextVIP, bVipTab.nextNum)
			pTips = nil
		else
			if tonumber( bVipTab.most_Tap ) == 0 then
				pTips:ShowCommonTips(1649,nil,bVipTab.nextVIP, bVipTab.nextNum)
				pTips = nil
			else
				pTips:ShowCommonTips(1506, GotoVip, bVipTab.nextVIP, bVipTab.nextNum)
				pTips = nil
			end	
		end
	end


end

local function InitWidgets(  )
	m_pLayerEliteDungeon = GUIReader:shareReader():widgetFromJsonFile("Image/DungeonEliteLayer.json")
	if m_pLayerEliteDungeon==nil then
		print("m_pLayerEliteDungeon is nil")
		return false
	end

	m_pScrollViewElite = tolua.cast(m_pLayerEliteDungeon:getChildByName("ScrollView_Elite"), "ScrollView")
	if m_pScrollViewElite==nil then
		print("m_pScrollViewElite is nil")
		return false
	else
		m_pScrollViewElite:setTouchEnabled(true)
	end

	local pImage = tolua.cast(m_pLayerEliteDungeon:getChildByName("Image_6"), "ImageView")
	m_pLabelTimes = Label:create()
	if pImage~= nil then
		if m_pLabelTimes==nil then
			print("m_pLabelTimes is nil")
			return false
		else
			m_pLabelTimes:setPosition(ccp(90,0))
			m_pLabelTimes:setFontSize(20)
			m_pLabelTimes:setFontName(CommonData.g_FONT3)
			pImage:addChild(m_pLabelTimes)
		end
	else
		print("pImage is nil")
		return false
	end

	m_pBtnAddTimes = tolua.cast(m_pLayerEliteDungeon:getChildByName("Button_AddTimes"), "Button")
	if m_pBtnAddTimes==nil then
		print("m_pBtnAddTimes is nil")
		return false
	else
		CreateBtnCallBack(m_pBtnAddTimes, nil, nil, _Btn_AddTimes_EliteDungeon_CallBack)
	end
	return true
end

local function GetPosByScenePoint( nSceneIdx, nPointIdx )
	
end

--GotoManager CallFunc
function GoToManagerCallFuncByElite( nPointIdx )

	local nCurSceneIdx, nCurPointIdx = GetLastSceneIdxAndPointIdx(DungeonsType.Elite)

	if nCurSceneIdx ~= nil and nCurPointIdx ~= nil then

		--点击指引效果
		if m_pScrollViewElite:getNodeByTag(1990) ~= nil then
			m_pScrollViewElite:getNodeByTag(1990):removeFromParentAndCleanup(true)
		end

	    local GuideAnimation = CommonData.g_GuildeManager:GetGuildeAni()

		--获取战役关卡坐标
		local nPt = GetPointPos( nCurPointIdx )

		GuideAnimation:setPosition(ccp(nPt.x, nPt.y))

		m_pScrollViewElite:addNode(GuideAnimation, 1990, 1990)

	end

end

function CreateEliteDungeonLayer(  )
	InitVars()

	m_pSurPlusTimes = server_mainDB.getMainData("VipFuben")

	if InitWidgets()==false then
		return
	end
	m_nPointCount = GetElitePointCount()

	CretaeElitePoints(m_pScrollViewElite, m_nPointCount)
	UdataeTimes()
	return m_pLayerEliteDungeon
end