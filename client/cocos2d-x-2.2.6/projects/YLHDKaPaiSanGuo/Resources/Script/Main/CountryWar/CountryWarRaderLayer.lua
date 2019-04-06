-- for CCLuaEngine traceback
require "Script/Common/Common"
require "Script/Fight/simulationStl"
require "Script/Main/CountryWar/CountryWarData"
require "Script/Main/CountryWar/CountryWarLogic"
require "Script/Main/CountryWar/ClickCityLayer"
require "Script/Main/CountryWar/PathFinding"
require "Script/Main/CountryWar/RaderPageManager"

module("CountryWarRaderLayer", package.seeall)

local StrokeLabel_createStrokeLabel 	= 	LabelLayer.createStrokeLabel 
local UIInterface_CreatAnimateByResID 	= 	UIInterface.CreatAnimateByResID

local numIsIntab						=	CountryWarLogic.numIsIntab
local CountCurPointIsInArea				=	CountryWarLogic.CountCurPointIsInArea
local JudgePtInEffectiveTab				=	CountryWarLogic.JudgePtInEffectiveTab

local GetPlayerCountry					=	CountryWarData.GetPlayerCountry
local GetPathByImageID					=	CountryWarData.GetPathByImageID
local GetGeneralHeadPath				=	CountryWarData.GetGeneralHeadPath
local GetAnimalBuffInfo					=	CountryWarData.GetAnimalBuffInfo
local GetSanGuoPattern					=	CountryWarData.GetSanGuoPattern
local GetCountryRes						=	CountryWarData.GetCountryRes
local GetTeamFace 						=	CountryWarData.GetTeamFace

local tab = {1,6,11,16,21,26,31,32,33,34,35,30,25,20,15,10,5,4,3,2,}
local tabVertex = {1,31,35,5}
local abs = math.abs
local max = math.max

local m_RaderLayer			=	nil
local m_Map					=	nil
local m_EventBg 			=	nil
local m_ScaleX				=	nil
local m_ScaleY				=	nil
local m_ScaleWorldX			=	nil
local m_ScaleWorldY			=	nil
local m_ScrollView			=	nil
local m_ScrollFunc			=	nil
local m_MoveScaleX			=	nil
local m_MoveScaleY			=	nil
local m_CurX				= 	nil
local m_CurY				=	nil
local m_RadarAni			=   nil
local m_BatchNodeAni		=	nil  
local m_imgPtBatchNode		=	nil 
local m_imgPtMainBNode 		= 	nil
local m_PageManager 		=	nil
local tabPos				=	{}
local m_TabAreaRader		= 	{}

RADER_WIDTH  = 763
RADER_HEIGHT = 600

local AnimalType = {
	Animal_QINGLONG 		= 1,
	Animal_BAIHU 	 		= 2,
	Animal_ZHUQUE 	 		= 3,
	Animal_XUANWU 	 		= 4,
	Animal_BAHAMUTE 	 	= 5,
}

local function InitVars( )
	m_PageManager 		=	nil
	--CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/countrywar/Animation/Scene_guozhan_ludian01/Scene_guozhan_ludian01.ExportJson")
end

function GetCurPtX( )
	if tabPos.ScrollX ~= nil then 
		return tabPos.ScrollX * m_ScaleWorldX
	end
	return 0
end
function GetCurPtY( )
	if tabPos.ScrollY ~= nil  then
		return tabPos.ScrollY * m_ScaleWorldY
	end
	return 0
end
--nActionState == true 添加动画
--nActionState == false 删除动画
function SetPtState( nState, nTag, nActionState )
	if nState == 1 then
		if nActionState == true then
			if m_BatchNodeAni:getChildByTag(500 + nTag) ~= nil then
				m_BatchNodeAni:getChildByTag(500 + nTag):setVisible(true)
			end
		end
	elseif nState == 0 then
		if nActionState == false then
			if m_BatchNodeAni:getChildByTag(500 + nTag) ~= nil then
				m_BatchNodeAni:getChildByTag(500 + nTag):setVisible(false)
			end
		end
	end
end


function SetPtEvent( nState, nType, nCTag, nResID, nGrid )
	local nParent = nil
	if nCTag == 100 or nCTag == 34 or nCTag == 190 then
		nParent = m_imgPtMainBNode
	else
		nParent = m_imgPtBatchNode
	end
	if nType == Country_EventType.BeAttack then
		if nState == true then
			--添加
			if m_Map:getChildByTag(6000 + nCTag) == nil then
				if nParent:getChildByTag(100 + nCTag) ~= nil then
					local nShowExpe = ImageView:create()
					nShowExpe:loadTexture("Image/imgres/countrywar/state_attack.png")
					local nPosx = nParent:getChildByTag(100 + nCTag):getPositionX()
					local nPosy = nParent:getChildByTag(100 + nCTag):getPositionY()
					nShowExpe:setPosition(ccp(nPosx, nPosy))
					m_Map:addChild(nShowExpe,2,6000 + nCTag)
				end
			end
		else
			--删除
			--print("删除城市"..nCTag.."上的数据")
			if m_Map:getChildByTag(6000 + nCTag) ~= nil then
				m_Map:getChildByTag(6000 + nCTag):removeFromParentAndCleanup(true)
			end
		end
	elseif nType == Country_EventType.AnExpeDition then
		if nState == true then
			--添加
			if nParent:getChildByTag(100 + nCTag) ~= nil then
				if m_EventBg:getChildByTag(nGrid) == nil then
					--print("在雷达城市"..nCTag.."上添加动态ID为"..nGrid.."的事件")
					local nPath   = GetPathByImageID(nResID)
					--print(nPath)
					local nShowExpe = ImageView:create()
					nShowExpe:loadTexture(nPath)
					local nPosx = nParent:getChildByTag(100 + nCTag):getPositionX()
					local nPosy = nParent:getChildByTag(100 + nCTag):getPositionY()
					nShowExpe:setPosition(ccp(nPosx, nPosy))
					m_EventBg:addChild(nShowExpe,4,nGrid)
				end
			end
		else
			--删除
			if m_EventBg:getChildByTag(nGrid) ~= nil then
				--print("在雷达城市"..nCTag.."上删除动态ID为"..nGrid.."的事件")
				m_EventBg:getChildByTag(nGrid):removeFromParentAndCleanup(true)
			end
		end
	end
end

function SetMistyState( nMistyTag, nState )
	local Image_Misty = tolua.cast(m_RaderLayer:getWidgetByName("Image_Misty"), "ImageView")
	if Image_Misty:getChildByTag( nMistyTag ) ~= nil then
		Image_Misty:getChildByTag( nMistyTag ):setVisible(nState)
	end
end

function InitPtData( nTag, nPosX, nPosY ,nCountry, iSpecial)
	local sprite = nil

	if iSpecial == nil then

		if nTag == 100 or nTag == 34 or nTag == 190 then
			--sprite = CCSprite:create("Image/imgres/countrywar/point_main.png")
			sprite = CCSprite:createWithTexture(m_imgPtMainBNode:getTexture())
			m_imgPtMainBNode:addChild(sprite,3, 100 + nTag)	
		else
			sprite = CCSprite:createWithTexture(m_imgPtBatchNode:getTexture())	
			m_imgPtBatchNode:addChild(sprite,3, 100 + nTag)
		end
		sprite:setPosition(ccp(nPosX * m_ScaleX,nPosY * m_ScaleY))
		if nCountry == COUNTRY_TYPE.COUNTRY_TYPE_WEI then
			sprite:setColor(ccc3(40,136,217))
		elseif nCountry == COUNTRY_TYPE.COUNTRY_TYPE_SHU then
			sprite:setColor(ccc3(227,72,36))
		elseif nCountry == COUNTRY_TYPE.COUNTRY_TYPE_WU then
			sprite:setColor(ccc3(38,196,116))
		elseif nCountry == COUNTRY_TYPE.COUNTRY_TYPE_QUN then
			sprite:setColor(ccc3(0,0,0))
		elseif nCountry == COUNTRY_TYPE.COUNTRY_TYPE_BEIDI then
			sprite:setColor(ccc3(120,29,111))
		elseif nCountry == COUNTRY_TYPE.COUNTRY_TYPE_XIRONG then
			sprite:setColor(ccc3(120,29,111))
		elseif nCountry == COUNTRY_TYPE.COUNTRY_TYPE_DONGYI then
			sprite:setColor(ccc3(120,29,111))
		elseif nCountry == COUNTRY_TYPE.COUNTRY_TYPE_HUANG then
			sprite:setColor(ccc3(202,189,39))
		else

		end
		--预先创建雷达动画资源
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/countrywar/Animation/Scene_guozhan_ludian01/Scene_guozhan_ludian01.ExportJson")
		local pAttckedAni = CCArmature:create("Scene_guozhan_ludian01")
		if nTag == 145 or nTag == 34 or nTag == 190 then
			pAttckedAni:getAnimation():play("Animation4")		--主城动画
		else
			pAttckedAni:getAnimation():play("Animation3")
		end
		pAttckedAni:setPosition(ccp(sprite:getPositionX(), sprite:getPositionY()))
		m_BatchNodeAni:addChild(pAttckedAni,4,500 + nTag)

	else

		--主城和军团的UI
		local pAniName = ""
		if nTag >= 257 then
			if nTag%2 == 0 then
				sprite = CCSprite:create("Image/imgres/countrywar/corps_"..nCountry..".png")
			else
				sprite = CCSprite:create("Image/imgres/countrywar/main_"..nCountry..".png")
			end
		end

		sprite:setPosition(ccp(nPosX * m_ScaleX,nPosY * m_ScaleY))

		m_Map:addNode(sprite)

	end
end

local function actionClick( sender, eventType ,nAreaImg )
	local ptPt = nil
	if eventType == TouchEventType.began then
		local pos = sender:getTouchStartPos()
		ptPt = m_Map:convertToNodeSpace(ccp(pos.x,pos.y))
	elseif eventType == TouchEventType.moved then
		local pos = sender:getTouchMovePos()
		ptPt = m_Map:convertToNodeSpace(ccp(pos.x,pos.y))
	elseif eventType == TouchEventType.ended then
		local pos = sender:getTouchEndPos()
		ptPt = m_Map:convertToNodeSpace(ccp(pos.x,pos.y))
	end
	local mapWidth = m_Map:getContentSize().width
	local mapHeight = m_Map:getContentSize().height
	local width = nAreaImg:getContentSize().width * 0.5
	local height = nAreaImg:getContentSize().height * 0.5
	
	if ptPt ~= nil then 
		if ptPt.x > width and ptPt.x <= mapWidth - width then
			if tabPos.initX < 0 then
				--tabPos.initX = math.abs(tabPos.initX)
				tabPos.initX = abs(tabPos.initX)
			end
			tabPos.ScrollX = (ptPt.x - width) - tabPos.initX 	
			local diffX = tabPos.ScrollX + width						
			nAreaImg:setPositionX(tabPos.initX + diffX)	
			m_ScrollFunc()
		else
			if ptPt.x <= width then
				nAreaImg:setPositionX(width)
				ptPt.x = width
				tabPos.ScrollX = (ptPt.x - width) - tabPos.initX 
			elseif ptPt.x >  mapWidth - width then
				nAreaImg:setPositionX(mapWidth - width)
				ptPt.x = mapWidth - width
				tabPos.ScrollX = (ptPt.x - width) - tabPos.initX 
			end
			m_ScrollFunc()
		end

		if ptPt.y > height and ptPt.y <= mapHeight - height then
			if tabPos.initY < 0 then
				--tabPos.initY = math.abs(tabPos.initY)
				tabPos.initY = abs(tabPos.initY)
			end
			tabPos.ScrollY = (ptPt.y - height) - tabPos.initY
			local diffY = tabPos.ScrollY + height
			nAreaImg:setPositionY(tabPos.initY + diffY)
			m_ScrollFunc()
		else
			if ptPt.y <= height then
				nAreaImg:setPositionY(height)
				ptPt.y = height
				tabPos.ScrollY = (ptPt.y - height) - tabPos.initY 
			elseif ptPt.y >  mapHeight - height then
				nAreaImg:setPositionY(mapHeight - height)
				ptPt.y = mapHeight - height
				tabPos.ScrollY = (ptPt.y - height) - tabPos.initY 
			end
			m_ScrollFunc()			
		end
	end
end

local function JumpToDes( nPt )
	local nFinalOffsetX = nPt.x
	local nFinalOffsetY = nPt.y
	if nPt.y <= 0 then nFinalOffsetY = max(nPt.y, RADER_HEIGHT/7 - RADER_HEIGHT) end
	if nPt.x <= 0 then nFinalOffsetX = max(nPt.x, RADER_WIDTH/5 - RADER_WIDTH) end
	return ccp(abs(nFinalOffsetX),abs(nFinalOffsetY))
end

local function ChangePtOffset( nPercent )
	local minY = RADER_HEIGHT/7 - RADER_HEIGHT
	local h = -minY
	local w = RADER_WIDTH - RADER_WIDTH/5
	return JumpToDes(ccp(-(nPercent.x * w / 100), minY + nPercent.y * h / 100))
end

function MoveToArea( nOffsetX,nOffsetY)
	local Image_Area = tolua.cast(m_RaderLayer:getWidgetByName("Image_area"), "ImageView")
	local width = Image_Area:getContentSize().width * 0.5
	local height = Image_Area:getContentSize().height * 0.5
	if nOffsetX ~= nil then
		Image_Area:setPositionX(-nOffsetX * m_ScaleX + width)
	end
	if nOffsetY ~= nil then
		Image_Area:setPositionY(-nOffsetY * m_ScaleY + height)
	end
end

function UpdateArea( nAreaNum , ntype , nPercentX, nPercentY, nStateX, nStateY)
	local mapWidth = m_Map:getContentSize().width
	local mapHeight = m_Map:getContentSize().height
	local Image_Area = tolua.cast(m_RaderLayer:getWidgetByName("Image_area"), "ImageView")
	local width = Image_Area:getContentSize().width * 0.5
	local height = Image_Area:getContentSize().height * 0.5
	local nPt = ChangePtOffset(ccp(nPercentX,nPercentY))
	--print(nPos.x * m_ScaleX,nPos.y * m_ScaleY)
	--print("--------------")
	--print(nPt.x, nPt.y)
	if ntype == City_Area.Eff_Normal then
		Image_Area:setPosition(ccp(nPt.x + width,nPt.y + height))
	elseif ntype == City_Area.NoEff_Left then
		if nStateX == false then
			Image_Area:setPositionX(m_TabAreaRader[nAreaNum].BeginX + width)
		else
			Image_Area:setPositionX(nPt.x + width)
		end
		Image_Area:setPositionY(nPt.y + height)
	elseif ntype == City_Area.NoEff_Right then
		if nStateX == false then
			Image_Area:setPositionX(m_TabAreaRader[nAreaNum].BeginX + width)
		else
			Image_Area:setPositionX(nPt.x + width)
		end
		Image_Area:setPositionY(nPt.y + height)	
	elseif ntype == City_Area.NoEff_Left_Bottom then
		if nStateX == false then
			Image_Area:setPositionX(m_TabAreaRader[nAreaNum].BeginX + width)
		else
			Image_Area:setPositionX(nPt.x + width)
		end
		if nStateY == false then
			Image_Area:setPositionY(m_TabAreaRader[nAreaNum].BeginY + height)
		else
			Image_Area:setPositionY(nPt.y + height)
		end
	elseif ntype == City_Area.NoEff_Left_Top then
		if nStateX == false then
			Image_Area:setPositionX(m_TabAreaRader[nAreaNum].BeginX + width)
		else
			Image_Area:setPositionX(nPt.x + width)
		end
		if nStateY == false then
			Image_Area:setPositionY(m_TabAreaRader[nAreaNum].BeginY + height)
		else
			Image_Area:setPositionY(nPt.y + height)
		end	
	elseif ntype == City_Area.NoEff_Right_Top then
		if nStateX == false then
			Image_Area:setPositionX(m_TabAreaRader[nAreaNum].BeginX + width)
		else
			Image_Area:setPositionX(nPt.x + width)
		end
		if nStateY == false then
			Image_Area:setPositionY(m_TabAreaRader[nAreaNum].BeginY + height)
		else
			Image_Area:setPositionY(nPt.y + height)
		end		
	elseif ntype == City_Area.NoEff_Right_Bottom then
		if nStateX == false then
			Image_Area:setPositionX(m_TabAreaRader[nAreaNum].BeginX + width)
		else
			Image_Area:setPositionX(nPt.x + width)
		end
		if nStateY == false then
			Image_Area:setPositionY(m_TabAreaRader[nAreaNum].BeginY + height)
		else
			Image_Area:setPositionY(nPt.y + height)
		end
	elseif ntype == City_Area.NoEff_Bottom then
		Image_Area:setPositionX(nPt.x + width)
		if nStateY == false then
			Image_Area:setPositionY(m_TabAreaRader[nAreaNum].BeginY + height)
		else
			Image_Area:setPositionY(nPt.y + height)
		end
	elseif ntype == City_Area.NoEff_Top then
		Image_Area:setPositionX(nPt.x + width)
		if nStateY == false then
			Image_Area:setPositionY(m_TabAreaRader[nAreaNum].BeginY + height)
		else
			Image_Area:setPositionY(nPt.y + height)
		end
	end
	tabPos.initX = Image_Area:getPositionX() - width
	tabPos.initY = Image_Area:getPositionY() - height		
	--print("tabPos.initX = "..tabPos.initX..", tabPos.initY = "..tabPos.initY)
end

local function _Click_Rader_Close_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(0.8)
		m_RaderLayer:removeFromParentAndCleanup(false)
		require "Script/Main/CountryWar/CountryUILayer"
		CountryUILayer.SetRadarBtnState(true)
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.7)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(0.8)
	end
end

function PlayRadarAni()
	m_RadarAni:getAnimation():play("Animation2")
end

function UpdateCountry( nCountry, nTag )
	local nParent = m_imgPtBatchNode
	if nTag == 100 or nTag == 34 or nTag == 190 then
		nParent = m_imgPtMainBNode
	end
	if nParent:getChildByTag(100 + nTag) ~= nil then 
		if nCountry == COUNTRY_TYPE.COUNTRY_TYPE_WEI then
			nParent:getChildByTag(100 + nTag):setColor(ccc3(40,136,217))
		elseif nCountry == COUNTRY_TYPE.COUNTRY_TYPE_SHU then
			nParent:getChildByTag(100 + nTag):setColor(ccc3(227,72,36))
		elseif nCountry == COUNTRY_TYPE.COUNTRY_TYPE_WU then
			nParent:getChildByTag(100 + nTag):setColor(ccc3(38,196,116))
		elseif nCountry == COUNTRY_TYPE.COUNTRY_TYPE_QUN then
			nParent:getChildByTag(100 + nTag):setColor(ccc3(0,0,0))
		elseif nCountry == COUNTRY_TYPE.COUNTRY_TYPE_BEIDI then
			nParent:getChildByTag(100 + nTag):setColor(ccc3(120,29,111))
		elseif nCountry == COUNTRY_TYPE.COUNTRY_TYPE_XIRONG then
			nParent:getChildByTag(100 + nTag):setColor(ccc3(120,29,111))
		elseif nCountry == COUNTRY_TYPE.COUNTRY_TYPE_DONGYI then
			nParent:getChildByTag(100 + nTag):setColor(ccc3(120,29,111))
		elseif nCountry == COUNTRY_TYPE.COUNTRY_TYPE_HUANG then
			nParent:getChildByTag(100 + nTag):setColor(ccc3(202,189,39))
		else

		end
	else
		print("雷达城池为空")
	end
end

local function CreateLabel( text, size, color, fontName, pos )
	local label	  = Label:create()
	label:setFontSize(size)
	label:setColor(color)
	label:setFontName(fontName)
	label:setPosition(pos)
	label:setText(text)
	return label
end
--更新神兽buff层数
function UpdateTeamAnimalBuff( nTeamIndex, nAnimalIndex, nAnimalNum )
	if m_RaderLayer ~= nil then

		if m_PageManager ~= nil then

			m_PageManager:Fun_UpdateCiFu_Buff( nTeamIndex, nAnimalIndex, nAnimalNum ) 

		end

	end
end

function DelRaderTeamUI( nIndex )
	if m_RaderLayer ~= nil then

		if m_PageManager ~= nil then

			m_PageManager:Fun_DelTeam( nIndex )

		end

	end
end

--更新三国格局
function UpdateSanGuoPattern( )
	--添加城市形象
	if m_RaderLayer == nil then

		return 

	end

	local tabStr = {}
	tabStr[1] = "三国鼎立"
	tabStr[2] = "吴蜀争霸"
	tabStr[3] = "吴魏争霸"
	tabStr[4] = "蜀魏争霸"
	tabStr[5] = "吴蜀联盟"
	tabStr[6] = "吴魏联盟"
	tabStr[7] = "蜀魏联盟"

	local ColorStr = "|color|230,180,114|"

	local Image_StateBg = tolua.cast(m_RaderLayer:getWidgetByName("Image_StateBg"), "ImageView")
	local Label_Info = tolua.cast(Image_StateBg:getChildByName("Label_Info"), "Label")

	local pParDB   = GetSanGuoPattern()
	local pCountry = GetPlayerCountry()
	local pLevel   = pParDB["CountryLevel"]
	local pCityNum = pParDB["CountryNum"]
	local pSGState = tonumber(pParDB["SanGuoState"])

	local pAniResTab = GetCountryRes(pCountry, pLevel)

	if pAniResTab ~= nil then

		if m_RaderLayer:getChildByTag(1990) == nil then

			CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pAniResTab["AniPath"])
		    local pArmature = CCArmature:create(pAniResTab["AniName"])
		    pArmature:getAnimation():play(pAniResTab["AniAct"])
		    pArmature:setPosition(ccp(1045 - CommonData.g_Origin.x, 60 - CommonData.g_Origin.y))
		    m_RaderLayer:addChild(pArmature, 0, 1990)

		    Label_Info:setText(tabStr[pSGState])

			--占有城池label
		    if Image_StateBg:getChildByTag(101) ~= nil then
		    	Image_StateBg:getChildByTag(101):removeFromParentAndCleanup(true)
			end
			local pCountryStr = "未知"
			if pCountry == COUNTRY_TYPE.COUNTRY_TYPE_WEI then
				pCountryStr = "魏国"
			elseif pCountry == COUNTRY_TYPE.COUNTRY_TYPE_SHU then
				pCountryStr = "蜀国"
			elseif pCountry == COUNTRY_TYPE.COUNTRY_TYPE_WU then
				pCountryStr = "吴国"
			end
			--local pCountryLabel = StrokeLabel_createStrokeLabel(20, CommonData.g_FONT3, pCountryStr.."    城" , ccp(0, 0), COLOR_Black, ccc3(228,199,67), true, ccp(0, 0), 2)
			local pCountryLabel = CreateLabel(pCountryStr.."    城" , 20, ccc3(228,199,67), CommonData.g_FONT3, ccp(0,0))
			pCountryLabel:setPosition(ccp(50,70))
			pCountryLabel:setRotation( -90 )
			Image_StateBg:addChild(pCountryLabel, 1, 101)
			--占有数量label
		    if Image_StateBg:getChildByTag(102) ~= nil then
		    	Image_StateBg:getChildByTag(102):setText(pCityNum)
		    else
				local pNumLabel = CreateLabel(pCityNum, 20, ccc3(25,254,235), CommonData.g_FONT1, ccp(0,0))
				pNumLabel:setPosition(ccp(50,80))
				pNumLabel:setRotation( -90 )
				Image_StateBg:addChild(pNumLabel, 1, 102)
			end

		else
			--占有数量label
		    if Image_StateBg:getChildByTag(102) ~= nil then
		    	Image_StateBg:getChildByTag(102):setText(pCityNum)
		    else
				local pNumLabel = CreateLabel(pCityNum, 20, ccc3(25,254,235), CommonData.g_FONT1, ccp(0,0))
				pNumLabel:setPosition(ccp(50,80))
				pNumLabel:setRotation( -90 )
				Image_StateBg:addChild(pNumLabel, 1, 102)
			end

		end

	end
end

local function _Button_Buff_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		local pMessage = TipsMessage.CreateTipsMessage()
		pMessage:CreateByStr( GetBuffStr(sender:getTag()), 354, ccp(sender:getPositionX() - 410, sender:getPositionY()) )
	end	
end

--更新雷达界面队伍信息
function UpdateRaderTeamUI( nTab, nType )

	if m_PageManager ~= nil then

		m_PageManager:Fun_UpdatePage_CiFu( nTab, nType )

	end

end

function UpdateCity_Move( nYzData )
	if m_PageManager ~= nil then

		m_PageManager:Fun_UpdateItem_YZ( nYzData )

	end
end

function UpdateCity_Del( nDelGrid )
	if m_PageManager ~= nil then

		m_PageManager:Fun_DelItem_YZ( nDelGrid )

	end
end

function UpdateCity_Add( nYzData )
	if m_PageManager ~= nil then

		m_PageManager:Fun_AddItem_YZ( nYzData )

	end
end

---------事件接口
--添加事件
function Update_SJ_Add( nCityID, nType )
	if m_PageManager ~= nil then

		m_PageManager:Fun_AddItem_SJ( nCityID, nType )

	end	
end
--删除事件
function Update_SJ_Del( nCityID, nType )
	if m_PageManager ~= nil then

		m_PageManager:Fun_DelItem_SJ( nCityID, nType )

	end	
end

function CreateRaderLayer(nParentWidth,nParentHeight, nCenterPt, scrollfunc, nUITab)
	InitVars() 
	m_RaderLayer = TouchGroup:create()
	m_RaderLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CountryWarRaderLayer.json"))

	tabPos["initX"] = 0
	tabPos["initY"] = 0
	tabPos["ScrollX"] = 0
	tabPos["ScrollY"] = 0
	m_EventBg 	=	tolua.cast(m_RaderLayer:getWidgetByName("Panel_Event"), "Layout")
	m_Map 	    = tolua.cast(m_RaderLayer:getWidgetByName("Image_MapBg"), "ImageView")
	--m_Map:setOpacity(100)
	--m_Map:setPosition(ccp(m_Map:getPositionX(),m_Map:getPositionY() - CommonData.g_Origin.y))
	m_ScaleX = m_Map:getContentSize().width / nParentWidth
	m_ScaleY = m_Map:getContentSize().height / nParentHeight
	m_ScaleWorldX = nParentWidth / RADER_WIDTH
	m_ScaleWorldY = nParentHeight / RADER_HEIGHT
	--雷达滚动层
	local Image_Area = tolua.cast(m_RaderLayer:getWidgetByName("Image_area"), "ImageView")
	--Image_Area:setAnchorPoint(ccp(0,0))
    local function onTouchEvent(sender, eventType)
        actionClick(sender, eventType,Image_Area)
	end
	m_ScrollView =	tolua.cast(m_RaderLayer:getWidgetByName("ScrollView_Map"), "ScrollView")
	m_ScrollView:addTouchEventListener(onTouchEvent)

	m_TabAreaRader = {}
	local nAreaDiffX = m_Map:getContentSize().width  / 5
	local nAreaDiffY = m_Map:getContentSize().height / 7
	local ptNumX = 0
	local ptNumY = 0
	for i=1,35 do
		m_TabAreaRader[i] 				= {}	
		if i % 5 == 1 then
			ptNumX = 0
		end	
		m_TabAreaRader[i]["BeginX"] 		= ptNumX * nAreaDiffX
		m_TabAreaRader[i]["BeginY"] 		= ptNumY * nAreaDiffY
		m_TabAreaRader[i]["CenterPointX"] = m_TabAreaRader[i]["BeginX"] + nAreaDiffX * 0.5
		m_TabAreaRader[i]["CenterPointY"] = m_TabAreaRader[i]["BeginY"] + nAreaDiffY * 0.5
		if i % 5 == 0 then
			ptNumY = ptNumY + 1
		end
		ptNumX = ptNumX + 1
	end
	--UpdateArea(nCenterPt)

	--世界地图滚动回调
	if scrollfunc ~= nil then
		m_ScrollFunc = scrollfunc
	end

    --雷达按钮响应
    local pRadarClick = tolua.cast(m_RaderLayer:getWidgetByName("Button_Radar"), "Button")
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/countrywar/Animation/Scene_guozhan_leida01/Scene_guozhan_leida01.ExportJson")
	m_RadarAni = CCArmature:create("Scene_guozhan_leida01")
	m_RadarAni:getAnimation():play("Animation1")
	m_RadarAni:setPosition(ccp(0,0))
	pRadarClick:setSize(CCSizeMake(m_RadarAni:getContentSize().width,m_RadarAni:getContentSize().height))
	pRadarClick:setPosition(ccp(pRadarClick:getPositionX() - CommonData.g_Origin.x,pRadarClick:getPositionY() - CommonData.g_Origin.y))
	pRadarClick:addNode(m_RadarAni,1,99)
	pRadarClick:addTouchEventListener(_Click_Rader_Close_CallBack)

	--国家标志
	local nCountryBg = ImageView:create()
	nCountryBg:loadTexture("Image/imgres/countrywar/countryBg.png")
	nCountryBg:setPosition(ccp(50,-50))
	pRadarClick:addChild(nCountryBg)

	--坐标适配
	for i=1,4 do
		local Image_Corn = tolua.cast(m_RaderLayer:getWidgetByName("Image_Corn_"..i), "ImageView")
		Image_Corn:setPosition(ccp(Image_Corn:getPositionX() - CommonData.g_Origin.x, Image_Corn:getPositionY() - CommonData.g_Origin.y ))
	end

	local Image_StateBg = tolua.cast(m_RaderLayer:getWidgetByName("Image_StateBg"), "ImageView")
	Image_StateBg:setPosition(ccp(Image_StateBg:getPositionX() - CommonData.g_Origin.x, Image_StateBg:getPositionY() - CommonData.g_Origin.y ))
	

	local nCamp = GetPlayerCountry()
	local nCountryLabel = nil
	if nCamp == COUNTRY_TYPE.COUNTRY_TYPE_WEI then
		nCountryLabel = CreateLabel("魏", 26, ccc3(27,150,255), CommonData.g_FONT1, ccp(0,0))
	elseif nCamp == COUNTRY_TYPE.COUNTRY_TYPE_SHU then
		nCountryLabel = CreateLabel("蜀", 26, ccc3(236,53,4), CommonData.g_FONT1, ccp(0,0))
	elseif nCamp == COUNTRY_TYPE.COUNTRY_TYPE_WU then
		nCountryLabel = CreateLabel("吴", 26, ccc3(3,209,5), CommonData.g_FONT1, ccp(0,0))
	else
		nCountryLabel = CreateLabel("魏", 26, ccc3(27,150,255), CommonData.g_FONT1, ccp(0,0))
	end

	nCountryBg:addChild(nCountryLabel)

	m_BatchNodeAni = CCBatchNode:create()
	m_Map:addNode(m_BatchNodeAni)

	m_imgPtBatchNode = CCSpriteBatchNode:create("Image/imgres/countrywar/point.png", 260)
	m_Map:addNode(m_imgPtBatchNode,3)

	m_imgPtMainBNode = CCSpriteBatchNode:create("Image/imgres/countrywar/point_main.png", 3)
	m_Map:addNode(m_imgPtMainBNode,3)

	local Image_TabPage = tolua.cast(m_RaderLayer:getWidgetByName("Image_TabPage"), "ImageView")
	Image_TabPage:setPosition( ccp(Image_TabPage:getPositionX() - CommonData.g_Origin.x, Image_TabPage:getPositionY() - CommonData.g_Origin.y) )

	m_PageManager 		=	RaderPageManager.Create()
	m_PageManager:Fun_InitPage( 1, Image_TabPage )

	--增加国战雷达图标说明

	local function CreateInfoImg( nPath, nName, nParent, PosY, nIndex )
		local pInfoSp = CCSprite:create(nPath)
		pInfoSp:setPosition( ccp( 15, PosY - nIndex * 30 ) )
		nParent:addNode( pInfoSp )

		local pPointSp = CCSprite:create("Image/imgres/countrywar/raderPoint.png")
		pPointSp:setPosition(ccp(pInfoSp:getPositionX() + 18,pInfoSp:getPositionY()))
		nParent:addNode( pPointSp )

		local pInfoLabel = CreateLabel(nName , 18, ccc3(233,180,114), CommonData.g_FONT1, ccp(pInfoSp:getPositionX() + 25,pInfoSp:getPositionY()))
		pInfoLabel:setAnchorPoint(ccp(0,0.5))
		nParent:addChild( pInfoLabel )
	end

	local pImgTop = tolua.cast(m_RaderLayer:getWidgetByName("Image_line_top"), "ImageView")
	local pImgBottom = tolua.cast(m_RaderLayer:getWidgetByName("Image_line_bottom"), "ImageView")

	pImgTop:setPosition( ccp( pImgTop:getPositionX() - CommonData.g_Origin.x, pImgTop:getPositionY() - CommonData.g_Origin.y ) )
	pImgBottom:setPosition( ccp( pImgBottom:getPositionX() - CommonData.g_Origin.x, pImgBottom:getPositionY() - CommonData.g_Origin.y ) )

	local ScrollView_Info 	=	tolua.cast(m_RaderLayer:getWidgetByName("ScrollView_Info"), "ScrollView")
	ScrollView_Info:setPosition( ccp( ScrollView_Info:getPositionX() - CommonData.g_Origin.x, ScrollView_Info:getPositionY() - CommonData.g_Origin.y ) )
	ScrollView_Info:setClippingType(1)
	local pInnerHeight = ScrollView_Info:getInnerContainerSize().height

	local pCountry = GetPlayerCountry()

	local pInfoPathTab = {}

	pInfoPathTab[1] = {}
	pInfoPathTab[1]["Path"] = "Image/imgres/countrywar/main_"..pCountry..".png"
	pInfoPathTab[1]["Name"] = "主城传送"
	pInfoPathTab[2] = {}
	pInfoPathTab[2]["Path"] = "Image/imgres/countrywar/corps_"..pCountry..".png"
	pInfoPathTab[2]["Name"] = "军团传送"
	pInfoPathTab[3] = {}
	pInfoPathTab[3]["Path"] = "Image/imgres/countrywar/war_round.png"
	pInfoPathTab[3]["Name"] = "激战城池"
	pInfoPathTab[4] = {}
	pInfoPathTab[4]["Path"] = "Image/imgres/countrywar/state1.png"
	pInfoPathTab[4]["Name"] = "攻城任务"
	pInfoPathTab[5] = {}
	pInfoPathTab[5]["Path"] = "Image/imgres/countrywar/state4.png"
	pInfoPathTab[5]["Name"] = "守城任务"
	pInfoPathTab[6] = {}
	pInfoPathTab[6]["Path"] = "Image/imgres/countrywar/yz_1.png"
	pInfoPathTab[6]["Name"] = "魏远征军"
	pInfoPathTab[7] = {}
	pInfoPathTab[7]["Path"] = "Image/imgres/countrywar/yz_2.png"
	pInfoPathTab[7]["Name"] = "蜀远征军"
	pInfoPathTab[8] = {}
	pInfoPathTab[8]["Path"] = "Image/imgres/countrywar/yz_3.png"
	pInfoPathTab[8]["Name"] = "吴远征军"
	pInfoPathTab[9] = {}
	pInfoPathTab[9]["Path"] = "Image/imgres/countrywar/wei_ls.png"
	pInfoPathTab[9]["Name"] = "魏国灵兽"
	pInfoPathTab[10] = {}
	pInfoPathTab[10]["Path"] = "Image/imgres/countrywar/shu_ls.png"
	pInfoPathTab[10]["Name"] = "蜀国灵兽"
	pInfoPathTab[11] = {}
	pInfoPathTab[11]["Path"] = "Image/imgres/countrywar/wu_ls.png"
	pInfoPathTab[11]["Name"] = "吴国灵兽"
	pInfoPathTab[12] = {}
	pInfoPathTab[12]["Path"] = "Image/imgres/countrywar/state_attack.png"
	pInfoPathTab[12]["Name"] = "黄巾部队"

	for i=1,table.getn( pInfoPathTab ) do
		CreateInfoImg( pInfoPathTab[i]["Path"],pInfoPathTab[i]["Name"], ScrollView_Info, pInnerHeight - 20, i-1  )
	end

    return m_RaderLayer
end