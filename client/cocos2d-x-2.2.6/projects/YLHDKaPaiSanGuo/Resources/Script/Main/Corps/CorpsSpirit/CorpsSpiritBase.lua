module("CorpsSpiritBase",package.seeall)
require "Script/Main/Corps/CorpsSpirit/CorpsSpiritData"
local GetCityType            = CorpsSpiritData.GetCityType
local GetCityName            = CorpsSpiritData.GetCityName
local tanHand = {}

local function SetValue( self,value )
	self.TabItem = value
end

local function GetValue( self )
	return self.TabItem
end

local function ComminuteText(str)
    local list = {}
    local len = string.len(str)
    local i = 1 
    while i <= len do
        local c = string.byte(str, i)
        local shift = 1
        if c > 0 and c <= 127 then
            shift = 1
        elseif (c >= 192 and c <= 223) then
            shift = 2
        elseif (c >= 224 and c <= 239) then
            shift = 3
        elseif (c >= 240 and c <= 247) then
            shift = 4
        end
        local char = string.sub(str, i, i + shift - 1)
        i = i + shift
        table.insert(list, char)
    end
	return table.getn(list)
end

--listView item点击进入国战回调
local function _Click_PanelItem_CallBack( sender,eventType )
	
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		local n_CountryTag = sender:getTag()
       	CorpsSpiritlayer.GOTO_PanelItem_CallBack(n_CountryTag)
	elseif eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function CreateItemWidget( pItemTemps )
    local pItem = pItemTemps:clone()
    local peer = tolua.getpeer(pItemTemps)
    tolua.setpeer(pItem, peer)
    return pItem
end

local function GetItem( self )
	if self.pItemTemp ~= nil then
		return self.pItemTemp
	end
end

local function DeleteHandTime( self )
	if self.n_handTime ~= nil then
		self.pItemTemp:getScheduler():unscheduleScriptEntry(self.n_handTime)
		self.n_handTime = nil
	end
end

local function ShowListCityItem( self,pTemp,ItemTab )
	self.TabItem = ItemTab

	self.pItemTemp = CreateItemWidget(pTemp)
	local pControlbg = tolua.cast(self.pItemTemp:getChildByName("Image_bg"),"ImageView")
	local l_nameType = tolua.cast(pControlbg:getChildByName("Label_title"),"Label")
	local img_nameCity = tolua.cast(pControlbg:getChildByName("Image_name"),"ImageView")
	local l_nameCity = tolua.cast(img_nameCity:getChildByName("Label_name"),"Label")
	local img_itemCity = tolua.cast(pControlbg:getChildByName("Image_item"),"ImageView")

	local nCityID = 246
	
	
	local n_handTime = nil

	if self.TabItem ~= nil then
		nCityID = self.TabItem["nCountryID"]
	end
	local nCityType = GetCityType(nCityID)
	local pCityTab = CorpsSpiritData.GetCityInfo(nCityID)
	if pCityTab ~= nil then
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pCityTab["AniPath"])
		local pArmature = CCArmature:create(pCityTab["AniName"])
		pArmature:getAnimation():play(pCityTab["AniAct"])
		pArmature:setPosition(ccp(-80,-30))
		if tonumber(nCityType) == 5 then
			pArmature:setScale(0.6)
		end
		pControlbg:addNode(pArmature,99)
	end
	local l_spiritType = "未知"

	
	if self.TabItem ~= nil then
		if tonumber(self.TabItem["nType"]) == 1 then
			l_spiritType="青龙之魂"
		elseif tonumber(self.TabItem["nType"]) == 2 then
			l_spiritType="白虎之魂"
		elseif tonumber(self.TabItem["nType"]) == 3 then
			l_spiritType="朱雀之魂"
		elseif tonumber(self.TabItem["nType"]) == 4 then
			l_spiritType="玄武之魂"
		elseif tonumber(self.TabItem["nType"]) == 5 then
			l_spiritType="巴哈姆特"
		else
			l_spiritType="未知"
		end
		local t_name = GetCityName(nCityID)
		local length = ComminuteText(t_name)
		local lengthPos = length * 25
		local line = AddLine(ccp(0 - lengthPos / 2,-15),ccp(lengthPos / 2,-15), ccc3(99,216,53),1,255)
		line:setVisible(false)
		l_nameCity:addNode(line)
		pControlbg:setTag(nCityID)
		local function SetDelayTime(nSecend)
			if nSecend < 0 then return end
			
			local nDelayTime = nSecend
			local strM = math.floor(nSecend/60)
			local strS = math.floor(nSecend%60)
			local strTemp = ""
			if tonumber(strM) < 10 then strM = "0" .. strM end
			if tonumber(strS) < 10 then strS = "0" .. strS end

			if self.pItemTemp == nil then
				return
			end
			--[[local pControlbg = tolua.cast(self.pItemTemp:getChildByName("Image_bg"),"ImageView")
			local l_nameType = tolua.cast(pControlbg:getChildByName("Label_title"),"Label")
			local img_nameCity = tolua.cast(pControlbg:getChildByName("Image_name"),"ImageView")
			local l_nameCity = tolua.cast(img_nameCity:getChildByName("Label_name"),"Label")
			local img_itemCity = tolua.cast(pControlbg:getChildByName("Image_item"),"ImageView")]]--

			l_nameCity:setText(strM .. ":" .. strS.." ".."后刷新")
			local function tick(dt)
				if nDelayTime == 0 then
					if n_handTime ~= nil then
					self.pItemTemp:getScheduler():unscheduleScriptEntry(n_handTime)
					n_handTime = nil
					end
					l_nameCity:setText("")
					line:setVisible(true)
					if l_nameCity:getChildByTag(100) ~= nil then
						LabelLayer.setText(l_nameCity:getChildByTag(100),t_name)
					else
						local labelNameText = LabelLayer.createStrokeLabel(20, CommonData.g_FONT3, t_name, ccp(0, 0), COLOR_Black, ccc3(99,216,53), true, ccp(0, -2), 2)
						l_nameCity:addChild(labelNameText,100,100)
					end
					pControlbg:setTouchEnabled(true)
					pControlbg:addTouchEventListener(_Click_PanelItem_CallBack)
				end
				nDelayTime = nDelayTime -1
				SetDelayTime(nDelayTime)
			end
			if n_handTime == nil then
				n_handTime = self.pItemTemp:getScheduler():scheduleScriptFunc(tick, 1, false)
			end
			
		end
		
		if tonumber(self.TabItem["nTime"]) == tonumber(self.TabItem["nTotalTime"]) then
			local labelNameText = LabelLayer.createStrokeLabel(20, CommonData.g_FONT3, t_name, ccp(0, 0), COLOR_Black, ccc3(99,216,53), true, ccp(0, -2), 2)
			l_nameCity:addChild(labelNameText,100,100)
			
			line:setVisible(true)
			pControlbg:setTouchEnabled(true)
			pControlbg:addTouchEventListener(_Click_PanelItem_CallBack)
		else
			local closeTime = tonumber(self.TabItem["nTime"])
			local strM = math.floor(closeTime/60)
			local strS = math.floor(closeTime%60)
			if tonumber(strM) < 10 then strM = "0" .. strM end
			if tonumber(strS) < 10 then strS = "0" .. strS end
				
			l_nameCity:setText(strM .. ":" .. strS)
			SetDelayTime(self.TabItem["nTime"])
			table.insert(tanHand,n_handTime)
			self.n_handTime = n_handTime
		end
		
	else

	end
	l_nameType:setText(l_spiritType)	
end

function Create(  )
	local tab = {
		ShowListCityItem = ShowListCityItem,
		SetValue = SetValue,
		GetValue = GetValue,
		GetItem = GetItem,
		DeleteHandTime = DeleteHandTime,
	}
	return tab
end