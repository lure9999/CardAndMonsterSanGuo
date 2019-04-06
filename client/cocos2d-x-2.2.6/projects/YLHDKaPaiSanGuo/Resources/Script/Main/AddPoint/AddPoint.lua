module("AddPoint",package.seeall)

local function DeleteRedPoint( self,nTag )
	if self.pControlPoint ~= nil then
		if self.pControlPoint:getChildByTag(self.nTag) ~= nil then
			self.pControlPoint:getChildByTag(self.nTag):removeFromParentAndCleanup(true)
		end
	end
end

local function ShowRedPoint( self,nTag,pControl,PosX,PosY )
	self.nTag = nTag
	self.pControlPoint = pControl
	local img_Point = ImageView:create()
	-- img_Point:loadTexture("Image/imgres/mail/prompt.png")
	img_Point:loadTexture("Image/imgres/mission/redPoint.png")
	img_Point:setPosition(ccp(PosX,PosY))
	if self.pControlPoint:getChildByTag(nTag) == nil then
		self.pControlPoint:addChild(img_Point,nTag,nTag)
	end
	
end

function CreateAddPoint(  )
	local tab = {
		ShowRedPoint = ShowRedPoint,
		DeleteRedPoint = DeleteRedPoint,
	}
	return tab
end