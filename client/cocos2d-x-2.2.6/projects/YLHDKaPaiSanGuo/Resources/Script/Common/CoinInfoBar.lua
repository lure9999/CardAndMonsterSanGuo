--最上面的各种货币心思提示条 celina

module("CoinInfoBar", package.seeall)

require "Script/Common/CoinInfoBarLogic"
-- require "Script/Main/Corps/CorpsScene"

--逻辑

local GetCoinPathByID = CoinInfoBarLogic.GetCoinPathByID
local GetCoinNum = CoinInfoBarLogic.GetCoinNum

local m_pBarLayer = nil



local function InitVars()
	m_pBarLayer = nil 
end
--更新值 nIndex需要更新第几个
local function SetNum(nIndex,nType)
	--得到Label
	local img_bg = tolua.cast(m_pBarLayer:getWidgetByName("img_icon_bg"..nIndex),"ImageView")
	local label_num = img_bg:getChildByTag(1000)
	if label_num~=nil then
		local nCoinNum = 0
		--银币
		if nType == 1 then
			nCoinNum = GetCoinNum("silver")
		elseif nType == 2 then
			nCoinNum = GetCoinNum("gold")
		elseif nType == 3 then
			nCoinNum = GetCoinNum("tili").. "/" ..GetCoinNum("max_tili") 
		elseif nType == 4 then
			nCoinNum = GetCoinNum("naili").."/"..GetCoinNum("max_naili")
		elseif nType == 5 then
			nCoinNum = GetCoinNum("exp") 
		elseif nType == 6 then
			nCoinNum = GetCoinNum("GeneralExpPool") 
		--[[elseif nType == 8 then
			nCoinNum = GetCoinNum("naili") ]]--
		elseif nType == 9 then
			nCoinNum = GetCoinNum("BiWu_Prestige") 
		elseif nType == 10 then
			nCoinNum = GetCoinNum("Family_Prestige")
		elseif nType == 13 then
			--军团币添加
			nCoinNum = CorpsScene.GetCorpsMoney()
		--[[elseif nType == 12 then
			nCoinNum = GetCoinNum("naili")
		elseif nType == 13 then
		nCoinNum = GetCoinNum("naili")
		elseif nType == 14 then
		nCoinNum = GetCoinNum("naili")
		elseif nType == 17 then
		nCoinNum = GetCoinNum("naili")]]--
		end
		LabelLayer.setText(label_num, nCoinNum)
	end
	

end
--传入要显示的货币类型值,有无战斗力
function UpdateCoinBar(tabCoinType,bFight)
	--要显示的个数，，
	local nShowCoinNum = #tabCoinType
	if nShowCoinNum<4 then
		for i=1,4-nShowCoinNum do 
			local img_icon_bg = tolua.cast(m_pBarLayer:getWidgetByName("img_icon_bg"..i),"ImageView")
			img_icon_bg:setVisible(false)
		end
	
	end
	local nStartNum = 4-nShowCoinNum+1
	local count = 0
	for i=nStartNum,nShowCoinNum do 
		count = count+1
		local img_coin = tolua.cast(m_pBarLayer:getWidgetByName("img_coin"..i),"ImageView")
		local sPath = GetCoinPathByID(tabCoinType[count])
		if sPath~=nil then
			img_coin:loadTexture(sPath)
		end
		if tonumber(tabCoinType[count]) == 9 then
			img_coin:setScale(1.0)
		else
			img_coin:setScale(0.5)
		end
		SetNum(i,tonumber(tabCoinType[count]))
	end
	local img_fight =  tolua.cast(m_pBarLayer:getWidgetByName("img_fight_bg"),"ImageView")
	img_fight:setVisible(bFight)
end
function UpdateFightNum(nNum)
	if m_pBarLayer==nil then
		return 
	end
	local img_fight_bg = tolua.cast(m_pBarLayer:getWidgetByName("img_fight_bg"),"ImageView")
	local label_fight_num = tolua.cast(img_fight_bg:getChildByTag(1000),"LabelBMFont")
	if label_fight_num~=nil then
		label_fight_num:setText(nNum)
	end
end
local function InitUI()
	for i=1,4 do 
		local img_icon_bg = tolua.cast(m_pBarLayer:getWidgetByName("img_icon_bg"..i),"ImageView")
		local text = LabelLayer.createStrokeLabel(20, "微软雅黑", "", ccp(-25, 0), COLOR_Black, ccc3(206,147,91), false, ccp(0, -2), 2)
		img_icon_bg:addChild(text,  0, 1000)
	end
	local img_fight_bg = tolua.cast(m_pBarLayer:getWidgetByName("img_fight_bg"),"ImageView")
	local pFgihtNum = LabelBMFont:create()
	pFgihtNum:setFntFile("Image/imgres/main/fight.fnt")
	pFgihtNum:setPosition(ccp(-10,-20))
	pFgihtNum:setAnchorPoint(ccp(0,0.5))
	pFgihtNum:setText(GetCoinNum("power"))
	img_fight_bg:addChild(pFgihtNum,0,1000)
end

function ShowHideBar(bShow)
	for i=1,4 do 
		local img_icon_bg = tolua.cast(m_pBarLayer:getWidgetByName("img_icon_bg"..i),"ImageView")
		img_icon_bg:setVisible(bShow)
	end
	local img_fight_bg = tolua.cast(m_pBarLayer:getWidgetByName("img_fight_bg"),"ImageView")
	img_fight_bg:setVisible(bShow)
end
function AddCoinBar(pParent)
	m_pBarLayer = TouchGroup:create()
	m_pBarLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/TipsCoinBar.json" ) )
	m_pBarLayer:setPosition(ccp(260,590))
	
	InitUI()
	pParent:addChild(m_pBarLayer, layerCoinBar_Tag, layerCoinBar_Tag)
end