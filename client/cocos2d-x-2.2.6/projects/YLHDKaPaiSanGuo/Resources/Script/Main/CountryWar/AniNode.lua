--重写Animation对象，用于播放完毕后自动删除动画的单独逻辑
module("AniNode", package.seeall)

local function Destory( self )
	self.RoadPtAni:removeFromParentAndCleanup(true)
	self.RoadPtAni = nil
end

local function PlayAni( self, nAnimationName )
	local function onMovementEvent( armatureBack,movementType,movementID )
		if movementType == 1 then
			Destory(self)
		end
	end	
	self.RoadPtAni:getAnimation():play(nAnimationName)
	self.RoadPtAni:getAnimation():setMovementEventCallFunc(onMovementEvent)
end

local function CreateAniNode( self, nptX, nptY, nAngle )
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/countrywar/Animation/Scene_guozhan_ludian01/Scene_guozhan_ludian01.ExportJson")
	self.RoadPtAni = CCArmature:create("Scene_guozhan_ludian01")
	self.RoadPtAni:getAnimation():play("Animation1")
	self.RoadPtAni:setRotation(nAngle)	
	self.RoadPtAni:setPosition(ccp(nptX, nptY))
	self.PlayScale = self.RoadPtAni:getAnimation():getSpeedScale()
end

local function GetAniNode( self )
	return self.RoadPtAni
end

local function SetActSpeed( self, nSpeed )
	self.RoadPtAni:setActionTimeScale(nSpeed)
end

local function AddParent( self, nBase, nTag )
	nBase:addChild(self.RoadPtAni,1,nTag)
end

function Create(  )
	local tab = {
		CreateAniNode = CreateAniNode,
		GetAniNode	  = GetAniNode,
		AddParent 	  = AddParent,
		PlayAni 	  = PlayAni,
		Destory 	  = Destory,
		SetActSpeed   = SetActSpeed,
	}

	return tab
end

