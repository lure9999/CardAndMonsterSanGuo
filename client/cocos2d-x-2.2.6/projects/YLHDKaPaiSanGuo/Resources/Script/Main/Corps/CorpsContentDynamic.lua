module("CorpsContentDynamic",package.seeall)

local function GetItem( self )
	if self.pItemTemp ~= nil then
		return self.pItemTemp
	end
end

local function ShowDynamicItem( self,ItemTab )
	self.TabItem = ItemTab
	local n_Count = #(self.TabItem)

	local layout = Layout:create()
	layout:setTouchEnabled(false)
	layout:setSize(CCSize(640,60+n_Count*40))
	self.pItemTemp = layout
	--添加标题
	local img_time = ImageView:create()
	img_time:loadTexture("Image/imgres/equip/title_bg.png")
	img_time:setPosition(ccp(300,layout:getContentSize().height-30))
	local cur_TimeDB = os.date("*t",self.TabItem[1]["time"])
				
	local labelTimeText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, cur_TimeDB["month"].."月"..cur_TimeDB["day"].."日", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
	AddLabelImg(labelTimeText,101,img_time)

	layout:addChild(img_time)

	local img_bg = ImageView:create()
	img_bg:setScale9Enabled(true)
	img_bg:loadTexture("Image/imgres/corps/squard.png")
	img_bg:setSize(CCSize(layout:getContentSize().width,layout:getContentSize().height-50))
	img_bg:setCapInsets(CCRectMake(20,20,1,1))
	img_bg:setPosition(ccp(layout:getContentSize().width/2,layout:getContentSize().height/2-25))
	layout:addChild(img_bg)

	

	for key,value in pairs(self.TabItem) do
		local nTimeDB = os.date("*t",value.time)
		if tonumber(nTimeDB.min) < 10 then
			nTimeDB.min = "0"..nTimeDB.min
		end
		local nTimeStr = nTimeDB.hour..":"..nTimeDB.min
		local color = "|color|51,22,5||size|20|"
		local colorTime = "|color|29,109,43||size|18|"
		local colorName = "|color|96,40,8||size|18|"
		local colorWord = "|color|49,31,21||size|18|"
		-- loadItemInfo(key,valueD)nMessText
		local nMessText = "加入军团"
		if tonumber(value["eventID"]) == 1 then
			nMessText = colorTime..nTimeStr.."    "..colorName..value["playerName"].." "..colorWord.."加入军团"
		elseif tonumber(value["eventID"]) == 2 then
			nMessText = colorTime..nTimeStr.."    "..colorName..value["playerName"].." "..colorWord.."退出军团"
		elseif tonumber(value["eventID"]) == 3 then
			nMessText = colorTime..nTimeStr.."  ".." "..colorWord.."军团升级"
		elseif tonumber(value["eventID"]) == 4 then
			if tonumber(value["eventParam1"]) == 1 then
				nMessText = colorTime..nTimeStr.."    "..colorName..value["playerName"].." "..colorWord.."被任命为".."|color|8,141,23||size|18|".."副将"
			elseif tonumber(value["eventParam1"]) == 2 then
				nMessText = colorTime..nTimeStr.."    "..colorName..value["playerName"].." "..colorWord.."被任命为".."|color|17,59,152||size|18|".."护法"
			elseif tonumber(value["eventParam1"]) == 3 then
				nMessText = colorTime..nTimeStr.."    "..colorName..value["playerName"].." "..colorWord.."被任命为".."|color|17,59,152||size|18|".."圣女"
			elseif tonumber(value["eventParam1"]) == 4 then
				nMessText = colorTime..nTimeStr.."    "..colorName..value["playerName"].." "..colorWord.."被撤为帮众"
			end
					
		elseif tonumber(value["eventID"]) == 5 then
			nMessText = colorTime..nTimeStr.."    "..colorName..value["playerName"].." "..colorWord.."被罢免军团职位"
		elseif tonumber(value["eventID"]) == 6 then
			if tonumber(value["eventParam1"]) > 0 then
				nMessText = colorTime..nTimeStr.."    "..colorName..value["playerName"].." "..colorWord.."捐献了军团贡献".." ".."|color|53,25,13||size|20|"..value["eventParam1"]
			else
				local eventParam1Num = math.abs(tonumber(value["eventParam1"]))
				nMessText = colorTime..nTimeStr.."    "..colorName..value["playerName"].." "..colorWord.."使用了军团贡献".." ".."|color|53,25,13||size|20|"..eventParam1Num
			end
		elseif tonumber(value["eventID"]) == 8 then
			nMessText = colorTime..nTimeStr.."    "..colorName..value["playerName"].." "..colorWord.."创建了军团"
		
		else
			nMessText = ""
		end

		local messContentItem = RichLabel.Create(nMessText,400,nil,nil,1)
		messContentItem:setPosition(ccp(50,layout:getContentSize().height-30 - key*40))
		layout:addChild(messContentItem)

	end

end

function CreateManger(  )
	local tab = {
		GetItem = GetItem,
		ShowDynamicItem = ShowDynamicItem,
	}
	return tab
end