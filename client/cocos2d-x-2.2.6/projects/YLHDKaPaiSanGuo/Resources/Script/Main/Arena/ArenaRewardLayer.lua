module("ArenaRewardLayer", package.seeall)

local g_model_reward = nil
local g_listView_reward = nil


--玩家当前的排名
local g_rank_player = nil

--玩家分档的存储
local array_rank = nil

local function initData()
	g_rank_player = 80
	array_rank = CCArray:create()
	array_rank:retain()
	array_rank:addObject(CCString:create("11-50"))
	array_rank:addObject(CCString:create("51-225"))
	array_rank:addObject(CCString:create("226-475"))
	array_rank:addObject(CCString:create("476-825"))
	array_rank:addObject(CCString:create("826-1250"))
	array_rank:addObject(CCString:create("1251-1650"))
	array_rank:addObject(CCString:create("1651-2250"))
	array_rank:addObject(CCString:create("2251-3250"))
	array_rank:addObject(CCString:create("3251-4250"))
	array_rank:addObject(CCString:create("4251-5000"))
	array_rank:addObject(CCString:create("5001-6250"))
	array_rank:addObject(CCString:create("6251-8000"))
	array_rank:addObject(CCString:create("8001-9999"))
end

--拷贝模板
local function copyModelReward()
	local model_copy = g_model_reward:clone()    
    local peer = tolua.getpeer(g_model_reward)   
    tolua.setpeer(model_copy, peer)
    return model_copy
end

--参数说明，item_clone模板 l_tag 当前是第几个
local function initRewardInfo(item_clone,l_tag)
	local img_left_reward = tolua.cast(item_clone:getChildByName("img_left_reward"),"ImageView")
	local img_right_reward = tolua.cast(item_clone:getChildByName("img_right_reward"),"ImageView")
	
	local img_icon_left = tolua.cast(img_left_reward:getChildByName("img_reward_icon_left"),"ImageView")
	local img_rank_left = tolua.cast(img_left_reward:getChildByName("img_reward_rank_left"),"ImageView")
	
	local img_rank_right = tolua.cast(img_right_reward:getChildByName("img_reward_rank_right"),"ImageView")
	local img_icon_right = tolua.cast(img_right_reward:getChildByName("img_reward_icon_right"),"ImageView")
	
	if l_tag == 2 then
		--左边显示第三名
		img_icon_left:loadTexture("Image/arena/icon_num_3.png")
		img_rank_left:loadTexture("Image/arena/reword_3.png")
		
		img_rank_right:removeFromParentAndCleanup(true)
		img_icon_right:loadTexture("Image/arena/icon_num_general.png")
		img_icon_right:setPosition(ccp(img_icon_right:getPositionX(),img_icon_right:getPositionY()-15))
		local labelRank_right = LabelAtlas:create()
		labelRank_right:setProperty("4-10", "Image/common/reward_num.png", 16, 20, "-")
		labelRank_right:setPosition(ccp(-106,54))
		img_right_reward:addChild(labelRank_right)
	elseif (l_tag>2) and (l_tag< 9)then
		--图标
		img_icon_left:loadTexture("Image/arena/icon_num_general.png")
		img_icon_right:loadTexture("Image/arena/icon_num_general.png")
		--排名
		img_rank_left:removeFromParentAndCleanup(true)
		img_rank_right:removeFromParentAndCleanup(true)
		local labelRank_left = LabelAtlas:create()
		local str_left = array_rank:objectAtIndex(l_tag*2-6):getCString()
		labelRank_left:setProperty(str_left, "Image/common/reward_num.png", 16, 20, "-")
		labelRank_left:setPosition(ccp(-106,54))
		labelRank_left:setTag(1000)
		img_left_reward:addChild(labelRank_left)
		
		local labelRank_right = LabelAtlas:create()
		local str_right = array_rank:objectAtIndex(l_tag*2-5):getCString()
		labelRank_right:setTag(1001)
		labelRank_right:setProperty(str_right, "Image/common/reward_num.png", 16, 20, "-")
		labelRank_right:setPosition(ccp(-106,54))
		img_right_reward:addChild(labelRank_right)
	elseif l_tag== 9 then
		img_right_reward:removeFromParentAndCleanup(true)
		--图标
		img_icon_left:loadTexture("Image/arena/icon_num_general.png")
		--排名
		img_rank_left:removeFromParentAndCleanup(true)
		local labelRank_left = LabelAtlas:create()
		labelRank_left:setTag(1000)
		local str_left = array_rank:objectAtIndex(l_tag*2-6):getCString()
		labelRank_left:setProperty(str_left, "Image/common/reward_num.png", 16, 20, "-")
		labelRank_left:setPosition(ccp(-106,54))
		img_left_reward:addChild(labelRank_left)
	end
	--插入玩家的排名
	if l_tag>2 and l_tag<9 then
		local str_l = array_rank:objectAtIndex(l_tag*2-6):getCString()
		local ss_l = string.find(str_l,"-")
		local new_sub_low_l = string.sub(str_l,0,ss_l-1)
		local new_sub_high_l = string.sub(str_l,ss_l+1,string.len(str_l))
		if (g_rank_player>=tonumber(new_sub_low_l) ) and (g_rank_player<=tonumber(new_sub_high_l)) then
			img_left_reward:loadTexture("Image/arena/player_reward_bg.png")
		end
		local str_r = array_rank:objectAtIndex(l_tag*2-5):getCString()
		local ss_r = string.find(str_r,"-")
		local new_sub_low_r = string.sub(str_r,0,ss_r-1)
		local new_sub_high_r = string.sub(str_r,ss_r+1,string.len(str_r))
		if (g_rank_player>=tonumber(new_sub_low_r) ) and (g_rank_player<=tonumber(new_sub_high_r)) then
			img_right_reward:loadTexture("Image/arena/player_reward_bg.png")
			local lable_player = img_right_reward:getChildByTag(1001)
			lable_player:setProperty(g_rank_player, "Image/common/player_reward_num.png", 19, 27, "0")
			local str_rank_player = Label:create()
			str_rank_player:setColor(ccc3(1,237,239))
			str_rank_player:setFontSize(18)
			str_rank_player:setPosition(ccp(-115,-55))
			str_rank_player:setText("您当前的排名")
			img_right_reward:addChild(str_rank_player)
		end
	end
	
	
end
local function initUI()
	
	for i=1,9 do
		local l_model_reward = copyModelReward()
		initRewardInfo(l_model_reward,i)
		g_listView_reward:pushBackCustomItem(l_model_reward)
	end
end
--参数说明，传入列表
function createArenaRewardLayer(l_listView)
	g_listView_reward = l_listView
	g_model_reward = GUIReader:shareReader():widgetFromJsonFile("Image/ArenRewardView.json")
	initData()
	initUI()
end