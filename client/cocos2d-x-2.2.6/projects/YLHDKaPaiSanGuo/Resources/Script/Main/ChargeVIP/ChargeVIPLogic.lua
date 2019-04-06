module("ChargeVIPLogic",package.seeall)
require "Script/Main/Item/GetGoodsLayer"

function cleanListView( pListView )
	if pListView:getItems():count()~=0 then
		pListView:removeAllItems()
	end 
end

function ShowRewardLayer( nTab1, nTab2, nCallBack )
	GetGoodsLayer.createGetGoods(nTab1, nTab2, nCallBack)
end

function GetAnimationByName(strJsonPath, strJsonName, strPlayName, pParentUI, ptPos, callBackFun, nTag,bReturn )
	
    CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(strJsonPath)
    local PayArmature = CCArmature:create(strJsonName)
	PayArmature:setPosition(ptPos)  
	--先临时写一下
	if bReturn ~=nil then
		PayArmature:setScale(1.35)
	end
	local layout = Layout:create()
	layout:setTouchEnabled(false)
	layout:addNode(PayArmature)	

    local function onMovementEvent(armatureBack,movementType,movementID)
        if movementType == 1 then
            -- layout:removeFromParentAndCleanup(true)    
            if callBackFun ~= nil then
                callBackFun()
				callBackFun = nil
				
            end
		elseif movementType == 2 then
			
        end
		if strJsonName ==  "brith_all_001" then
			print(movementID)
			
		end
    end
	
    PayArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)
	PayArmature:getAnimation():play(strPlayName)
    if nTag ~= nil then
		if pParentUI:getChildByTag(nTag)~=nil then
			pParentUI:getChildByTag(nTag):removeFromParentAndCleanup(true)
		end
        pParentUI:addChild(layout, nTag, nTag)
    else
		
        pParentUI:addChild(layout, 1)
    end
	return PayArmature
end

function CreateRunAnimationByJsonPath(strJsonPath, strJsonName, playIndex, pParentUI, ptPos, callBackFun, nTag)

	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(strJsonPath)
    local PayArmature = CCArmature:create(strJsonName)
	
	PayArmature:getAnimation():playWithIndex(playIndex)
	PayArmature:getAnimation():gotoAndPlay(34)
    PayArmature:setPosition(ptPos)   
	--add by sxin 因为外层调用都是Widget 用的getchilebytag所以只能加个layout了不然找不到！！！！！
	local layout = Layout:create()
	layout:setTouchEnabled(false)
	layout:addNode(PayArmature)
	
    local function onMovementEvent(armatureBack,movementType,movementID)
        if movementType == 1 then
            -- layout:removeFromParentAndCleanup(true)
          
            if callBackFun ~= nil then
                callBackFun()
				callBackFun = nil
            end
        end
		
    end

    PayArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)
	
    if nTag ~= nil then
		
        pParentUI:addChild(layout, 1, nTag)
    else
		
        pParentUI:addChild(layout,1)
    end
end