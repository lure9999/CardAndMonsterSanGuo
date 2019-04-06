module("PrisonCellList",package.seeall)

local function GetItem( self )
	if self.pItemTemp ~= nil then
		return self.pItemTemp
	end
end

local function ShowPrisonItem( self,ItemTab )
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
	-- img_bg:setOpacity(0)
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
		local nMessText = ""
		nMessText = "|color|253,235,200||size|20|"..nTimeStr.."    ".."|color|255,234,19||size|20|"..value["name"].."|color|53,25,13||size|20|".."被你抓捕为囚犯"

		local messContentItem = RichLabel.Create(nMessText,400,nil,nil,1)
		messContentItem:setPosition(ccp(50,layout:getContentSize().height-30 - key*40))
		layout:addChild(messContentItem)

	end

end

function CreateManger(  )
	local tab = {
		GetItem = GetItem,
		ShowPrisonItem = ShowPrisonItem,
	}
	return tab
end