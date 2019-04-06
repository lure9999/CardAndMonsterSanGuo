module("NoticeTipLayer",package.seeall)

function ShowNoticeTipLayer( strText, size, color, pos )
	local pText = nil
	local pPopTipLayer = CCLayer:create()
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	scenetemp:addChild(pPopTipLayer, layerTip_Tag, layerTip_Tag)

	--[[pText = CCLabelTTF:create()
	pText:setPosition(pos)
	pText:setString(strText)
	pText:setColor(color)
	pText:setFontSize(size)
	pText:setFontName(CommonData.g_FONT1)]]--
	pText = LabelLayer.createStrokeLabel(size,CommonData.g_FONT1,strText,pos,COLOR_Black,color,false,ccp(0,-2),2)
	
	if pText ~= nil then
		pPopTipLayer:addChild(pText)
	end

	local function DeleteSelf()
        pPopTipLayer:setVisible(false)
        pPopTipLayer:removeFromParentAndCleanup(true)
        pPopTipLayer = nil
	end

	local function hide_callback()
		local actionArray1 = CCArray:create()
		actionArray1:addObject(CCMoveBy:create(1, ccp(0, 200)))
		--actionArray1:addObject(CCScaleTo:create(1, 0.3))
		actionArray1:addObject(CCDelayTime:create(2.5))
		actionArray1:addObject(CCCallFuncN:create(DeleteSelf))
		pText:runAction(CCSequence:create(actionArray1))
	end

	if pText ~= nil then
		pText:setScale(0.7)
		local actionArray2 = CCArray:create()
		actionArray2:addObject(CCScaleTo:create(0, 0.5))
		actionArray2:addObject(CCScaleTo:create(0.25, 1.2))
		actionArray2:addObject(CCScaleTo:create(0.25, 1.0))
		-- actionArray2:addObject(CCDelayTime:create(2.5))
		actionArray2:addObject(CCCallFunc:create(hide_callback))
		actionArray2:addObject(CCFadeOut:create(1))
		pText:stopAllActions()
		pText:setOpacity(255)
		pText:runAction(CCSequence:create(actionArray2))
	end

end
