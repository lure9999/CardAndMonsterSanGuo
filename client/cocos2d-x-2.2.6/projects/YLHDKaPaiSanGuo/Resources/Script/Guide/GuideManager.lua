module("GuideManager", package.seeall)

require "Script/serverDB/guidedata"
require "Script/Guide/guide"
require "Script/Common/Common"

--当前引导的ID
local g_guideID = nil
--引导的属性 1强制 0 非强制
local g_guideProperty = nil
--存放引导的区域 CCRect类型
local g_guideRect = nil
--引导是否结束的标识
local g_guideEnd = nil
--按钮所属的UI的Tag
local g_uiTag    = nil
--按钮的名字
local g_buttonName = nil

local g_curScene = nil
local g_array_guide = nil
local function initData(initArray)
	g_array_guide = initArray
	g_array_guide:retain()
	local i_ID = tolua.cast(initArray:objectAtIndex(0),"CCInteger")
	g_guideID = i_ID:getValue()
	g_guideProperty = guidedata.getFieldByIdAndIndex(g_guideID,"Property")
	g_uiTag   =  guidedata.getFieldByIdAndIndex(g_guideID,"UTag")
	g_buttonName = guidedata.getFieldByIdAndIndex(g_guideID,"BName")
	--[[local rectX = guidedata.getFieldByIdAndIndex(g_guideID,"PosX")
	local rectY = guidedata.getFieldByIdAndIndex(g_guideID,"PosY")
	local rectW = guidedata.getFieldByIdAndIndex(g_guideID,"Width")
	local rectH = guidedata.getFieldByIdAndIndex(g_guideID,"Height")]]--
	local rectX = 0
	local rectY = 0
	local rectW = 0
	local rectH = 0
	g_curScene = CCDirector:sharedDirector():getRunningScene()
	--print("g_uiTag"..tonumber(g_uiTag))
	local cur_layer = g_curScene:getChildByTag(tonumber(g_uiTag))
	local cur_btn = nil
	if cur_layer ~= nil then
		cur_btn = tolua.cast(cur_layer:getWidgetByName(g_buttonName),"Button")
		
		rectW = cur_btn:getContentSize().width
		rectH = cur_btn:getContentSize().height
		
		rectX = cur_btn:getPositionX() - rectW/2
		rectY = cur_btn:getPositionY() - rectH/2
	else 
		print("cur_btn")
	end
	
	g_guideRect = CCRectMake(rectX,rectY,rectW,rectH)
	
	g_guideEnd = false
	--
end
--参数说明，array_guide 存放一整条引导的ID
function  createManager(array_guide)	
	initData(array_guide)
	local layerGuide = guide.mainImpl(g_guideRect)
	return layerGuide
end
local function updateGuideInfo(array_n)
	local i_ID = tolua.cast(array_n:objectAtIndex(0),"CCInteger")
	g_guideID = i_ID:getValue()
	g_guideProperty = guidedata.getFieldByIdAndIndex(g_guideID,"Property")
	g_uiTag   =  guidedata.getFieldByIdAndIndex(g_guideID,"UTag")
	g_buttonName = guidedata.getFieldByIdAndIndex(g_guideID,"BName")
	--print("g_buttonName"..g_buttonName)
	local rectX = 0
	local rectY = 0
	local rectW = 0
	local rectH = 0
	g_curScene = CCDirector:sharedDirector():getRunningScene()
	--print("g_uiTag"..g_uiTag)
	local cur_layer = g_curScene:getChildByTag(tonumber(g_uiTag))
	local cur_btn = nil
	if cur_layer ~= nil then
		cur_btn = tolua.cast(cur_layer:getWidgetByName(g_buttonName),"Button")
		rectW = cur_btn:getContentSize().width
		rectH = cur_btn:getContentSize().height
		--local point_o = cur_btn:convertToNodeSpace(cur_btn:getPosition())
		--print("point_o:"..point_o.x)
		local add_btn = cur_btn:getParent()
		rectX = add_btn:getPositionX()+ cur_btn:getPositionX()- rectW/2
		rectY = add_btn:getPositionY()+ cur_btn:getPositionY() - rectH/2
		--print("Name"..g_buttonName..rectW..":"..rectH..":"..rectX..":"..rectY)
	else 
		--print("pppppppppppppppppppppp")
	end
	g_guideRect = CCRectMake(rectX,rectY,rectW,rectH)
end
local function showNextGuideID(array_now)
	
	g_curScene = CCDirector:sharedDirector():getRunningScene()
	g_curScene:removeChildByTag(layerGuide_Tag,true)
	--print("showNextGuideID")
	updateGuideInfo(array_now)
	g_curScene:addChild(guide.mainImpl(g_guideRect,tonumber(g_guideProperty)),layerGuide_Tag,layerGuide_Tag)
	
end
local function endGuide()
	
	g_curScene = CCDirector:sharedDirector():getRunningScene()
	local layer_ll = g_curScene:getChildByTag(400)
	if layer_ll~=nil then
		--print("endGuide")
		
	end
	g_curScene:removeChildByTag(layerGuide_Tag,true)
	require "Script/Main/MainScene"
	MainScene.isGuide = false
end
function checkGuideEnd()
	g_array_guide:removeObjectAtIndex(0)
	local count_array = g_array_guide:count()
	--print("count_array"..count_array)
	if count_array ~= 0 then
		showNextGuideID(g_array_guide)
	else 
		endGuide()
	end
end
