require "Script/Main/Dungeon/DungeonBaseData"

module("ItemTipLayer", package.seeall)

local m_pLayerItemTip = nil
local GetItemNameByTempID 		= ItemData.GetNameByTempId
local GetItemPathByTempID 		= ItemData.GetItemPathByTempID
local GetItemNumberByTempId		= server_itemDB.GetItemNumberByTempId
local GetAllItemNumByTempId 	= server_itemDB.GetAllItemNumByTempId
local GetEquipNumberByTempId	= server_equipDB.GetEquipNumberByTempId
local GetItemDescByTempID		= ItemData.GetItemDescByTempID
local GetMonsterName			= DungeonBaseData.GetMonsterName
local GetMonsterIcon			= DungeonBaseData.GetMonsterIcon
local GetMonsterMilitary		= DungeonBaseData.GetMonsterMilitary
local GetMonsterLevel			= DungeonBaseData.GetMonsterLevel
local GetMonsterDesc			= DungeonBaseData.GetMonsterDesc
local GetCoinPath               = DungeonBaseData.GetCoinPath
local GetCoinNum                = DungeonBaseData.GetCoinNum

local function UpdateItemInfo( pItemControl, nTipType, nItemId )
	local pLbName =  LabelLayer.createStrokeLabel(26, CommonData.g_FONT1, "名称", ccp(-66, 70), COLOR_Black, ccc3(255,192,55), false, ccp(0, -2), 2)
	local pImgBg = tolua.cast(pItemControl:getWidgetByName("Image_BG"), "ImageView")
	pImgBg:addChild(pLbName)

	local pImgIcon = tolua.cast(pItemControl:getWidgetByName("Image_Icon"), "ImageView")

	local pLbDesc = tolua.cast(pItemControl:getWidgetByName("Label_Desc"), "Label")

	local pLbText = tolua.cast(pItemControl:getWidgetByName("Label_Text"), "Label")

	if nTipType == TipType.Item then

		nTipType = tonumber(item.getFieldByIdAndIndex(nItemId,"item_type"))

	elseif nTipType == TipType.Monster then

		nTipType = 11  -- 原来为4

	end
	if nTipType <= 3 then
		LabelLayer.setText(pLbName, GetItemNameByTempID(nItemId))
		pImgIcon:loadTexture(GetItemPathByTempID(nItemId))
		pLbDesc:setText(GetItemDescByTempID(nItemId))
		pLbText:setText("持有:"..tostring(GetAllItemNumByTempId(nItemId)))
	elseif nTipType == 4 or nTipType == 5 then
		--[[LabelLayer.setText(pLbName, GetMonsterName(nItemId).."("..GetMonsterMilitary(nItemId)..")")
		pImgIcon:loadTexture(GetMonsterIcon(nItemId))
		pLbDesc:setText(GetMonsterDesc(nItemId))
		pLbText:setText("LV."..tostring(GetMonsterLevel(nItemId)))]]--
		LabelLayer.setText(pLbName, GetItemNameByTempID(nItemId))
		pImgIcon:loadTexture(GetItemPathByTempID(nItemId))
		pLbDesc:setText(GetItemDescByTempID(nItemId))
		local num = 0
		local is_cunzai = server_generalDB.GetIsHaveWJ(nItemId)
		if is_cunzai == true then
			num = 1
		else
			num = 0
		end
		pLbText:setText("持有:"..tostring(num)) --tostring(GetAllItemNumByTempId(nItemId))
	elseif nTipType >= 6 and nTipType <= 9 then
		LabelLayer.setText(pLbName, equipt.getFieldByIdAndIndex(nItemId,"Name"))
		pImgIcon:loadTexture(GetItemPathByTempID(nItemId))
		pLbDesc:setText(GetItemDescByTempID(nItemId))
		pLbText:setText("持有:"..tostring(GetEquipNumberByTempId(nItemId)))
	elseif nTipType == 10 then
		
		LabelLayer.setText(pLbName, coin.getFieldByIdAndIndex(nItemId,"Name"))
		pImgIcon:loadTexture(GetCoinPath(nItemId))
		pLbDesc:setText("可购买其他东西")
		pLbText:setText("持有:"..tostring(GetCoinNum(nItemId)))
	elseif nTipType == 11 then
		LabelLayer.setText(pLbName, GetMonsterName(nItemId).."("..GetMonsterMilitary(nItemId)..")")
		pImgIcon:loadTexture(GetMonsterIcon(nItemId))
		pLbDesc:setText(GetMonsterDesc(nItemId))
		pLbText:setText("LV."..tostring(GetMonsterLevel(nItemId)))
	end
end

local function GetOffSizeByAnchorPoint( pReferenceControl, nPosType )
	local fAncPointX = pReferenceControl:getAnchorPoint().x
	local fAncPointY = pReferenceControl:getAnchorPoint().y

	local nOffWidth   = pReferenceControl:getSize().width
	local nOffHeight  = pReferenceControl:getSize().height

	if nPosType == TipPosType.LeftTop then
		if fAncPointX==0 then
			nOffWidth = nOffWidth/2
		elseif fAncPointX==0.5 then
			nOffWidth = 0
		elseif fAncPointX==1 then
			nOffWidth = -nOffWidth/2
		end

		if fAncPointY==0 then
			nOffHeight = nOffHeight
		elseif fAncPointY==0.5 then
			nOffHeight = nOffHeight/2
		elseif fAncPointY==1 then
			nOffHeight = 0
		end
	elseif nPosType==TipPosType.RightTop then
		if fAncPointX==0 then
			nOffWidth = nOffWidth/2
		elseif fAncPointX==0.5 then
			nOffWidth = 0
		elseif fAncPointX==1 then
			nOffWidth = -nOffWidth/2
		end

		if fAncPointY==0 then
			nOffHeight = nOffHeight
		elseif fAncPointY==0.5 then
			nOffHeight = nOffHeight/2
		elseif fAncPointY==1 then
			nOffHeight = 0
		end
	elseif nPosType==TipPosType.RightBottom then
		if fAncPointX==0 then
			nOffWidth = nOffWidth/2
		elseif fAncPointX==0.5 then
			nOffWidth = 0
		elseif fAncPointX==1 then
			nOffWidth = -nOffWidth/2
		end

		if fAncPointY==0 then
			nOffHeight = 0
		elseif fAncPointY==0.5 then
			nOffHeight = nOffHeight/2
		elseif fAncPointY==1 then
			nOffHeight = nOffHeight
		end
	elseif nPosType==TipPosType.LeftBottom then
		if fAncPointX==0 then
			nOffWidth = nOffWidth/2
		elseif fAncPointX==0.5 then
			nOffWidth = 0
		elseif fAncPointX==1 then
			nOffWidth = -nOffWidth/2
		end

		if fAncPointY==0 then
			nOffHeight = 0
		elseif fAncPointY==0.5 then
			nOffHeight = nOffHeight/2
		elseif fAncPointY==1 then
			nOffHeight = nOffHeight
		end
	end

	return nOffWidth, nOffHeight
end

local function SetTipPosition( pTipLayer, pReferenceControl, nPosType )
	local nRefPosX = pReferenceControl:getWorldPosition().x
	local nRefPosY = pReferenceControl:getWorldPosition().y

	local pPanelTip = tolua.cast(pTipLayer:getWidgetByName("Panel_ItemTip"), "Layout")
	local nTipLayerWidth = pPanelTip:getSize().width
	local nTipLayerHeight = pPanelTip:getSize().height

	local nOffWidth, nOffHeight = GetOffSizeByAnchorPoint(pReferenceControl, nPosType)
	if nPosType == TipPosType.LeftTop then
		pTipLayer:setPosition(ccp(nRefPosX+nOffWidth-nTipLayerWidth, nRefPosY+nOffHeight))
	elseif nPosType == TipPosType.RightTop then
		pTipLayer:setPosition(ccp(nRefPosX+nOffWidth, nRefPosY+nOffHeight))
	elseif nPosType == TipPosType.RightBottom then
		pTipLayer:setPosition(ccp(nRefPosX+nOffWidth, nRefPosY-nOffHeight-nTipLayerHeight))
	elseif nPosType == TipPosType.LeftBottom then
		pTipLayer:setPosition(ccp(nRefPosX+nOffWidth-nTipLayerWidth, nRefPosY-nOffHeight-nTipLayerHeight))
	end
end

function DeleteItemTipLayer( )
	m_pLayerItemTip:removeFromParentAndCleanup(true)
	m_pLayerItemTip = nil
end

function CreateItemTipLayer( pParentControl, pReferenceControl, nTipType, nItemId, nPosType )
	if m_pLayerItemTip==nil then
		m_pLayerItemTip = TouchGroup:create()									-- 背景层
		m_pLayerItemTip:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/ItemTipLayer.json") )
		pParentControl:addChild(m_pLayerItemTip, layerTip_Tag, layerTip_Tag)
	else
		DeleteItemTipLayer()
	end

	UpdateItemInfo(m_pLayerItemTip, nTipType, nItemId)

	SetTipPosition(m_pLayerItemTip, pReferenceControl, nPosType)
end

function DeleteItemTipLayer( )
	if m_pLayerItemTip~=nil then
		m_pLayerItemTip:removeFromParentAndCleanup(true)
		m_pLayerItemTip = nil
	end
end