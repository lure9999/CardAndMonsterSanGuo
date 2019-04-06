require "Script/Main/Dungeon/DungeonBaseData"
require "Script/Main/Dungeon/EliteDungeonData"
require "Script/Main/Dungeon/DungeonLogic"
require "Script/Main/Dungeon/EnterPointLayer"

module("DungeonBaseUILogic", package.seeall)

local GetPointId					= DungeonBaseData.GetPointId
local GetMonsterList				= DungeonBaseData.GetMonsterList
local GetMonsterResId				= DungeonBaseData.GetMonsterResId
local GetPointImageByType			= DungeonLogic.GetPointImageByType
local GetSceneIdx					= EliteDungeonData.GetSceneIdx
local GetSceneType 					= DungeonBaseData.GetSceneType

function UpdatePointStars( pStarLayout, nStars )
	if nStars<1 then
		pStarLayout:setVisible(false)
		return
	else
		pStarLayout:setPosition(ccp(pStarLayout:getPositionX(), pStarLayout:getPositionY()-(pStarLayout:getSize().height/2)))
		pStarLayout:setVisible(true)
	end

	for i=1, 3 do
		local pImgStar =  tolua.cast(pStarLayout:getChildByTag(i),"ImageView")
		-- 复位星星位置
		pImgStar:setPosition(ccp((i-1)*26-27, 0))
		if pImgStar~=nil then
			if i<=nStars then
				local nPosX = pImgStar:getPositionX() + (3-nStars)/2*(pImgStar:getContentSize().width+2)
				pImgStar:setPositionX(nPosX)
				pImgStar:setVisible(true)
			else
				pImgStar:setVisible(false)
			end
		end
	end
end

local function  CreateStar( nStarIdx )
	local pImageStar = ImageView:create()
	pImageStar:loadTexture("Image/imgres/common/star.png")
	pImageStar:setTag(nStarIdx)
	return pImageStar
end

function CreateStarLayout( pImgPoint, nPointidx )
	local pStarLayout = Layout:create()
	pStarLayout:setName("star_Layout"..tostring(nPointidx))
	pStarLayout:setAnchorPoint(ccp(0.5,0.5))
	pStarLayout:setPosition(ccp(pImgPoint:getPositionX(), pImgPoint:getPositionY()-pImgPoint:getSize().height/2))
    pStarLayout:setTouchEnabled(false)
	for i=1,3 do
		local  pImageStar = CreateStar(i)
		pStarLayout:addChild(pImageStar, 0, i)
	end
	return pStarLayout
end

local function CreateBossArmature( nBossId )
	local nAniId = GetMonsterResId(nBossId)
	local pArmature = UIInterface.CreatAnimateByResID(nAniId)
	pArmature:setScaleX(-0.7)
	pArmature:setScaleY(0.7)
	pArmature:setTag(nAniId)
	return pArmature
end

-- 创建怪物动作层
function CreateBossAniLayout( pImgPoint, nSceneIdx, nPointIdx, funCallBack )
	local nPointId = GetPointId(nSceneIdx, nPointIdx)
	local tabMonsterList = GetMonsterList(nPointId)
	if #tabMonsterList<1 then
		return nil
	end

	local nBossId = tabMonsterList[#tabMonsterList].MonsterId
	
	print("CreateBossAniLayout " )	
	print("nPointId = " .. nPointId)	
	print("nBossId = " .. nBossId)
	--Pause()
	
	if nBossId~=nil and nBossId>0 then
		local pAniLayout = Layout:create()
		pAniLayout:setName("pointLayout_"..nPointIdx)
		pAniLayout:setAnchorPoint(ccp(0.5, 0.5))
		pAniLayout:setTouchEnabled(true)
		if funCallBack~=nil then
			pAniLayout:addTouchEventListener(funCallBack)
		end
		if pAniLayout:getNodeByTag(nBossId)~=nil then
			pAniLayout:removeNodeByTag(nBossId)
		end
		local pArmature = CreateBossArmature(nBossId)
		local pRect = pArmature:boundingBox()
		pArmature:setPosition(ccp(pRect.size.width/2, 0))
		pAniLayout:addNode(pArmature)
		pAniLayout:setSize(CCSize(pRect.size.width, pRect.size.height))
		pAniLayout:setPosition(ccp(pImgPoint:getPositionX(), pImgPoint:getPositionY()+pImgPoint:getSize().height/4+pRect.size.height/2))
		return pAniLayout
	else
		return nil
	end
end

-- 创建每一个关卡
function CreatePoint( nType, nPointIdx, ptPos, funCallBack )
	local pImagePoint = ImageView:create()
	pImagePoint:setTouchEnabled(true)
	pImagePoint:setAnchorPoint(ccp(0.5,0.5))
	pImagePoint:setPosition(ptPos)
	if funCallBack~=nil then
		pImagePoint:addTouchEventListener(funCallBack)
	end
	pImagePoint:loadTexture(GetPointImageByType(nType))
	pImagePoint:setTag(nPointIdx)
	pImagePoint:setName("pointImg_"..nPointIdx)
	--创建未通关的小箱子
	local pBoxImg = ImageView:create()
	pBoxImg:loadTexture("Image/imgres/Fight/UI/box.png")
	pBoxImg:setPosition(ccp(-3, 14))
	pBoxImg:setScale(0.8)
	pBoxImg:setVisible(false)
	pImagePoint:addChild(pBoxImg,1,99)
	return pImagePoint
end

-- 打开进入关卡界面
function OpenEnterPointLayer(nSceneIdx, nPointIdx)
	local pRunningScene = CCDirector:sharedDirector():getRunningScene()
	local pLayerEnterPoint = pRunningScene:getChildByTag(layerFightLevel_Tag)
	if pLayerEnterPoint == nil then
		local pLayerEnterPoint = EnterPointLayer.CreateEnterPointLayer(nSceneIdx, nPointIdx)
		pRunningScene:addChild(pLayerEnterPoint,layerActivitySelTag+1,layerFightLevel_Tag)
	end
end

function _Point_Click_CallBack_( sender, eventType, pControl, nSceneIdx )
	if eventType==TouchEventType.ended then
		sender:setScale(1.0)
		if pControl~= nil then
			pControl:setScale(1.0)
		end
		OpenEnterPointLayer(nSceneIdx, sender:getTag())
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
		if pControl~= nil then
			pControl:setScale(0.9)
		end
		if eventType==TouchEventType.began then
			AudioUtil.PlayBtnClick()
		end
	elseif  eventType == TouchEventType.canceled then
		sender:setScale(1.0)
		if pControl~= nil then
			pControl:setScale(1.0)
		end
	end
end

-- 关卡图标回调
function _Point_Img_CallBack( sender, eventType, pParent, nSceneIdx )
	local pControl = pParent:getChildByName("pointLayout_"..sender:getTag())
	_Point_Click_CallBack_(sender, eventType, pControl, nSceneIdx)
end

-- 关卡动作回调
function _Point_Layout_CallBack( sender, eventType, pParent, nSceneIdx )
	local pControl = pParent:getChildByName("pointImg_"..sender:getTag())
	_Point_Click_CallBack_(sender, eventType, pControl, nSceneIdx)
end

--根据战役ID获得当前的战役类型
function GetSceneTypeBySceneID( nSceneID )
	local pSceneIdx = DungeonLogic.GetSceneIdxById( nSceneID )
	return GetSceneType( pSceneIdx )
end
