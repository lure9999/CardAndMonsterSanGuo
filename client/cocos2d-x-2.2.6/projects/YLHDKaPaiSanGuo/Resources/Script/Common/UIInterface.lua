
require "Script/Common/LabelLayer"
require "Script/Common/CommonData"
require "Script/Main/Wujiang/GeneralBaseData"
require "Script/Main/Equip/EquipListData"
require "Script/Main/Item/ItemData"
require "Script/serverDB/server_itemDB"
require "Script/serverDB/coin"
require "Script/serverDB/resimg"
require "Script/Main/Corps/CorpsScienceUp/CorpsScienceData"

module("UIInterface", package.seeall)

--常量
ICON_BG_COMMON_PATH = "Image/imgres/equip/icon/bottom.png"
ICON_UP_PATH        = "Image/imgres/wujiang/up.png"
ICON_STAR_BLACK_PATH = "Image/imgres/common/star_black.png"
ICON_STAR_PATH      = "Image/imgres/common/star.png"
--------------武将数据

local GetGeneralHeadIcon  = GeneralBaseData.GetGeneralHeadIcon
--武将的类型icon
local GetGeneralTypeIcon  = GeneralBaseData.GetGeneralTypeIcon
--武将类型 
local GetGeneralType      = GeneralBaseData.GetGeneralType
--武将的品质
local GetGeneralColorIcon = GeneralBaseData.GetGeneralColorIcon
local GetGeneralLv        = GeneralBaseData.GetGeneralLv
local GetGoOutByGrid      = server_generalDB.GetGoOutByGrid
local GetGeneralStar      = GeneralBaseData.GetGeneralStar

-------------装备数据
local GetTypeByGrid       = EquipListData.GetTypeByGrid
local GetEquipIconPathByGrid = EquipListData.GetEquipIconPathByGrid
local GetEquipColorIconByGrid = EquipListData.GetEquipColorIconByGrid
local GetCurLvByGird          = EquipListData.GetCurLvByGird
local GetStarLvByGrid         = EquipListData.GetStarLvByGrid


--道具数据
local GetItemTypeByTempID = ItemData.GetItemTypeByTempID
local GetItemPathByTempID = ItemData.GetItemPathByTempID
local GetItemColorPathByTempID   = ItemData.GetItemColorPathByTempID
local GetStonePathByTempId       = ItemData.GetStonePathByTempId
local GetHunPathByTempID         = ItemData.GetHunPathByTempID
local GetScienceImg 			 = CorpsScienceData.GetScienceImg

--coin数据

local function GetCoinResID(nTempId)
	local resID = coin.getFieldByIdAndIndex(nTempId,"ResID")
	return resimg.getFieldByIdAndIndex(resID,"icon_path")
end

local function showGeneralIcon(pIconContrl,nTempId,nGrid)


	local _Img_icon_ = ImageView:create()
	_Img_icon_:loadTexture(GetGeneralHeadIcon(nTempId))
	_Img_icon_:setPosition(ccp(6, 17))
	
	if pIconContrl:getChildByTag(1000) ~= nil then
		pIconContrl:getChildByTag(1000):setVisible(false)
		pIconContrl:getChildByTag(1000):removeFromParentAndCleanup(true)
	end
	--pIconContrl:addChild(_Img_icon_, 0, 1000)

	
	local _Img_icon = ImageView:create()
	_Img_icon:loadTexture(GetGeneralColorIcon(nTempId))

	if pIconContrl:getChildByTag(50) ~= nil then
		pIconContrl:getChildByTag(50):setVisible(false)
		pIconContrl:getChildByTag(50):removeFromParentAndCleanup(true)
	end
	pIconContrl:addChild(_Img_icon, 0, 50)
	--add by sxin 根据美术修改位置
	pIconContrl:addChild(_Img_icon_, 0, 1000)
	
	local _Img_attribute = ImageView:create()
	_Img_attribute:loadTexture(GetGeneralTypeIcon(nGrid))
	_Img_attribute:setPosition(ccp(48,49))
	
	if pIconContrl:getChildByTag(53) ~= nil then
		pIconContrl:getChildByTag(53):setVisible(false)
		pIconContrl:getChildByTag(53):removeFromParentAndCleanup(true)
	end
	pIconContrl:addChild(_Img_attribute, 0, 53)
	-- 加等级
	local label_lv = LabelLayer.createStrokeLabel(20,CommonData.g_FONT3,string.format("Lv.%d",GetGeneralLv(nGrid)),ccp(-46,-40),COLOR_Black,COLOR_White,false,ccp(0,-2),2)
	--_Img_lv_bk:addChild(label_lv)

	if pIconContrl:getChildByTag(51) ~= nil then
		pIconContrl:getChildByTag(51):setVisible(false)
		pIconContrl:getChildByTag(51):removeFromParentAndCleanup(true)
	end
	pIconContrl:addChild(label_lv, 0, 51)

	-- 是否上阵
	
	if tonumber(GetGoOutByGrid(nGrid)) == 1 then
		local _Img_GoOut = ImageView:create()
		--_Img_GoOut:loadTexture("Image/wujiang/icon_state_up_r.png")
		_Img_GoOut:loadTexture(ICON_UP_PATH)
		_Img_GoOut:setPosition(ccp(-48, 45))
		if pIconContrl:getChildByTag(52) ~= nil then
			pIconContrl:getChildByTag(52):setVisible(false)
			pIconContrl:getChildByTag(52):removeFromParentAndCleanup(true)
		end
		pIconContrl:addChild(_Img_GoOut, 0, 52)
	else
		if pIconContrl:getChildByTag(52) ~= nil then
			pIconContrl:getChildByTag(52):setVisible(false)
			pIconContrl:getChildByTag(52):removeFromParentAndCleanup(true)
		end
	end
	--如果是护法不加星星
	if GetGeneralType(nTempId) ~= 5 then 
		-- 加星星
		for i=1 ,6 do 
			local _Img_star = ImageView:create()
			_Img_star:loadTexture(ICON_STAR_BLACK_PATH)
			_Img_star:setPosition(ccp(-76 + i*22, -70))
			if pIconContrl:getChildByTag(52 + 100 + i) ~= nil then
				pIconContrl:getChildByTag(52 + 100 + i):setVisible(false)
				pIconContrl:getChildByTag(52 + 100 + i):removeFromParentAndCleanup(true)
			end
			pIconContrl:addChild(_Img_star, 0, 52 + 100 + i)
		end
		for i = 1, GetGeneralStar(nGrid) do
			--[[local _Img_star = ImageView:create()
			_Img_star:loadTexture("Image/imgres/common/star_black.png")
			_Img_star:setPosition(ccp(-66 + i*22, -70))
			if pIconContrl:getChildByTag(52 + 100 + i) ~= nil then
				pIconContrl:getChildByTag(52 + 100 + i):setVisible(false)
				pIconContrl:getChildByTag(52 + 100 + i):removeFromParentAndCleanup(true)
			end
			pIconContrl:addChild(_Img_star, 0, 52 + 100 + i)]]--
			if pIconContrl:getChildByTag(52 + 100 + i)~= nil then
				pIconContrl:getChildByTag(52 + 100 + i):loadTexture(ICON_STAR_PATH)
			end
		end
	end
	-- 返回一个可以点击的控件，
	-- _Img_icon:setTouchEnabled(true)
	return pIconContrl
end
local function showItemIcon(pIconContrl,nTempId)
	local nItem_type = GetItemTypeByTempID(nTempId)


	local _Img_icon_ = ImageView:create()
	_Img_icon_:loadTexture(GetItemPathByTempID(nTempId))
	
	_Img_icon_:setPosition(ccp(0, 0))

	if pIconContrl:getChildByTag(1000) ~= nil then
		pIconContrl:getChildByTag(1000):setVisible(false)
		pIconContrl:getChildByTag(1000):removeFromParentAndCleanup(true)
	end
	pIconContrl:addChild(_Img_icon_, 0, 1000)

	--[[print("nItem_type = " .. nItem_type)
	Pause()]]--
	-- 添加品质框
	if tonumber(nItem_type) == 1 then -- 消耗品
		local _Img_head_sprite_1 = tolua.cast(pIconContrl:getVirtualRenderer(), "CCSprite")
		MakeMaskIcon(_Img_head_sprite_1, "Image/imgres/common/bottom.png", 0, 1, "Image/imgres/common/color/icon_mask.png")

		local _Img_head_sprite_1 = tolua.cast(_Img_icon_:getVirtualRenderer(), "CCSprite")
		MakeMaskIcon(_Img_head_sprite_1, GetItemPathByTempID(nTempId), 0, 1, "Image/imgres/common/color/icon_mask.png")

	elseif tonumber(nItem_type) == 2 then -- 碎片
		pIconContrl:loadTexture("Image/imgres/common/common_empty.png")
		local _Img_head_sprite_1 = tolua.cast(pIconContrl:getVirtualRenderer(), "CCSprite")
		MakeMaskIcon(_Img_head_sprite_1, "Image/imgres/common/bottom.png", 0, 1, "Image/imgres/common/color/jianghun_mask.png")

		_Img_icon_:loadTexture("Image/imgres/common/common_empty.png")
		local _Img_head_sprite_1 = tolua.cast(_Img_icon_:getVirtualRenderer(), "CCSprite")
		MakeMaskIcon(_Img_head_sprite_1, GetItemPathByTempID(nTempId), 0, 1, "Image/imgres/common/color/jianghun_mask.png")

	elseif tonumber(nItem_type) == 3 then -- 将魂
		pIconContrl:loadTexture("Image/imgres/common/common_empty.png")
		local _Img_head_sprite_1 = tolua.cast(pIconContrl:getVirtualRenderer(), "CCSprite")
		MakeMaskIcon(_Img_head_sprite_1, "Image/imgres/common/bottom.png", 0, 1, "Image/imgres/common/color/jianghun_mask.png")

		_Img_icon_:loadTexture("Image/imgres/common/common_empty.png")
		local _Img_head_sprite_1 = tolua.cast(_Img_icon_:getVirtualRenderer(), "CCSprite")
		MakeMaskIcon(_Img_head_sprite_1, GetItemPathByTempID(nTempId), 0, 1, "Image/imgres/common/color/jianghun_mask.png")
	else
		local _Img_head_sprite_1 = tolua.cast(pIconContrl:getVirtualRenderer(), "CCSprite")
		MakeMaskIcon(_Img_head_sprite_1, "Image/imgres/common/bottom.png", 0, 1, "Image/imgres/common/color/icon_mask.png")

		_Img_icon_:loadTexture("Image/imgres/common/common_empty.png")
		local _Img_head_sprite_1 = tolua.cast(_Img_icon_:getVirtualRenderer(), "CCSprite")
		MakeMaskIcon(_Img_head_sprite_1, GetItemPathByTempID(nTempId), 0, 1, "Image/imgres/common/color/icon_mask.png")
	end
	 
	local _Img_icon = ImageView:create()
	_Img_icon:loadTexture(GetItemColorPathByTempID(nTempId))
	
	if nItem_type == 4 then
		_Img_icon:loadTexture(GetGeneralColorIcon(nTempId))
	end
		
	if tonumber(nItem_type) == 2 then -- 碎片
		
		local img_stone = ImageView:create()
		img_stone:loadTexture(GetStonePathByTempId(nTempId))
		img_stone:setPosition(ccp(48,43))
		if _Img_icon:getChildByTag(1000) ~= nil then
			_Img_icon:getChildByTag(1000):setVisible(false)
			_Img_icon:getChildByTag(1000):removeFromParentAndCleanup(true)
		end
		_Img_icon:addChild(img_stone,0,1000)
	end
	if tonumber(nItem_type) == 3 then -- 将魂
		
		local img_hun = ImageView:create()
		img_hun:loadTexture(GetHunPathByTempID(nTempId))
		img_hun:setPosition(ccp(48,43))
		if _Img_icon:getChildByTag(1001) ~= nil then
			_Img_icon:getChildByTag(1001):setVisible(false)
			_Img_icon:getChildByTag(1001):removeFromParentAndCleanup(true)
		end
		_Img_icon:addChild(img_hun,0,1001)
	end
	if tonumber(nItem_type) == 7 then
		--加上特效
		if pIconContrl:getChildByTag(5000) ~= nil then
			pIconContrl:getChildByTag(5000):setVisible(false)
			pIconContrl:getChildByTag(5000):removeFromParentAndCleanup(true)
		end
		if pIconContrl:getChildByTag(5000) == nil then
			CommonInterface.GetAnimationByName("Image/imgres/effectfile/WJ-wuqikuang.ExportJson", 
				"WJ-wuqikuang", 
				"Animation1", 
				pIconContrl, 
				ccp(0, 0),
				nil,
				5000)
		end
	end
	if pIconContrl:getChildByTag(50) ~= nil then
		pIconContrl:getChildByTag(50):setVisible(false)
		pIconContrl:getChildByTag(50):removeFromParentAndCleanup(true)
	end
	pIconContrl:addChild(_Img_icon, 0, 50)
	-- 返回一个可以点击的控件，
	_Img_icon:setTouchEnabled(true)
	return _Img_icon
end
local function showEquipIcon(pIconContrl,nTempId,nGrid,nCurLv)
	--区分是装备还是宝物  2是宝物 3是套装
	local nType = GetTypeByGrid(nGrid)
	local strImgPath = GetEquipIconPathByGrid(nGrid)

	local _Img_icon_ = ImageView:create()
	_Img_icon_:loadTexture(strImgPath)
	_Img_icon_:setPosition(ccp(0, 0))
	if pIconContrl:getChildByTag(1000) ~= nil then
		pIconContrl:getChildByTag(1000):setVisible(false)
		pIconContrl:getChildByTag(1000):removeFromParentAndCleanup(true)
	end
	pIconContrl:addChild(_Img_icon_, 0, 1000)
	
	if tonumber(nType) == E_BAGITEM_TYPE.E_BAGITEM_TYPE_SUIT then -- 套装
		if pIconContrl:getChildByTag(10) == nil then
			CommonInterface.GetAnimationByName("Image/imgres/effectfile/WJ-wuqikuang.ExportJson", 
				"WJ-wuqikuang", 
				"Animation1", 
				pIconContrl, 
				ccp(0, 0),
				nil,
				10)
		end
	else
		if pIconContrl:getChildByTag(10) ~= nil then
			pIconContrl:getChildByTag(10):setVisible(false)
			pIconContrl:getChildByTag(10):removeFromParentAndCleanup(true)
		end
	end

	
	
	local _Img_icon = ImageView:create()
	_Img_icon:loadTexture(GetEquipColorIconByGrid(nGrid))

	if pIconContrl:getChildByTag(50) ~= nil then
		pIconContrl:getChildByTag(50):setVisible(false)
		pIconContrl:getChildByTag(50):removeFromParentAndCleanup(true)
	end
	pIconContrl:addChild(_Img_icon, 0, 50)

	-- 
	-- 加等级
	local nLv = 0
	if nCurLv~=nil then
		nLv = nCurLv
	else
		nLv = GetCurLvByGird(nGrid)
	end
	
	if tonumber(nType) == E_BAGITEM_TYPE.E_BAGITEM_TYPE_TREASURE then
		  -- 加星级
		
		local starLv = GetStarLvByGrid(nGrid)
		--print("ppppppppppppppppppp")
		-- print(starLv)
		if tonumber(starLv)>0 then
			local _Img_star = ImageView:create()
			_Img_star:loadTexture(ICON_STAR_PATH)
			_Img_star:setPosition(ccp(19, 41))
			if pIconContrl:getChildByTag(52 + 100 + 1)~=nil then
				pIconContrl:getChildByTag(52 + 100 + 1):setVisible(false)
				pIconContrl:getChildByTag(52 + 100 + 1):removeFromParentAndCleanup(true)
			end
			pIconContrl:addChild(_Img_star, 0, 52 + 100 + 1)
			local label_star = LabelLayer.createStrokeLabel(20,CommonData.g_FONT1,starLv,ccp(29,43),COLOR_Black,COLOR_White,false,ccp(0,-2),2)
			if pIconContrl:getChildByTag(52 + 100 + 2)~=nil then
				pIconContrl:getChildByTag(52 + 100 + 2):setVisible(false)
				pIconContrl:getChildByTag(52 + 100 + 2):removeFromParentAndCleanup(true)
			end
			pIconContrl:addChild(label_star, 0, 52 + 100 + 2)
		end
		
	
	end
	
	local label_lv = LabelLayer.createStrokeLabel(20,CommonData.g_FONT1,string.format("Lv.%d",nLv),ccp(-46,-40),COLOR_Black,COLOR_White,false,ccp(0,-2),2)
	if pIconContrl:getChildByTag(51) ~= nil then
		pIconContrl:getChildByTag(51):setVisible(false)
		pIconContrl:getChildByTag(51):removeFromParentAndCleanup(true)
	end
	pIconContrl:addChild(label_lv, 0, 51)

	-- 是否装备
	if server_matrixDB.IsShangZhenEquip(nGrid) == true then
		local _Img_GoOut = ImageView:create()
		_Img_GoOut:loadTexture("Image/imgres/common/icon_equiped.png")
		_Img_GoOut:setPosition(ccp(-42, 28))
		_Img_GoOut:setVisible(false)
		if pIconContrl:getChildByTag(52) ~= nil then
			pIconContrl:getChildByTag(52):setVisible(false)
			pIconContrl:getChildByTag(52):removeFromParentAndCleanup(true)
		end
		pIconContrl:addChild(_Img_GoOut, 1, 52)
	else
		if pIconContrl:getChildByTag(52) ~= nil then
			pIconContrl:getChildByTag(52):setVisible(false)
			pIconContrl:getChildByTag(52):removeFromParentAndCleanup(true)
		end
	end
	

	-- 返回一个可以点击的控件，
	_Img_icon:setTouchEnabled(true)
	return _Img_icon
end
local function showCoinIcon(pIconContrl,nTempId)
	
	local strImgPath = GetCoinResID(nTempId)
	local _Img_icon_ = ImageView:create()
	_Img_icon_:loadTexture(strImgPath)
	_Img_icon_:setPosition(ccp(0, 0))
	AddLabelImg(_Img_icon_,1000,pIconContrl)
	
	
	local _Side_icon = ImageView:create()
	_Side_icon:loadTexture("Image/imgres/common/color/wj_pz1.png")
	AddLabelImg(_Side_icon,50,pIconContrl)
	
	
	

	-- 返回一个可以点击的控件，
	_Side_icon:setTouchEnabled(true)
	return _Side_icon
end
--得到头像
local function GetHeadImgPath(nHeadID)
	--得到ID
	local headID = 0
	if nHeadID == nil then
		headID = server_mainDB.getMainData("nHeadID")
	else
		headID = nHeadID
	end
	
	return resimg.getFieldByIdAndIndex(headID,"icon_path")
end
local function GetHeadColorPath(nColorID)
	local gID = server_mainDB.getMainData("JobGeneralID")
	colorNum = 0
	if nColorID == nil then
		colorNum = tonumber(general.getFieldByIdAndIndex(gID,"Colour"))
	else
		colorNum = nColorID
	end
	local strColorPath = string.format("Image/imgres/common/color/wj_pz%d.png",colorNum)
	return strColorPath
end
local function showPlayerIcon(pIconContrl)
	local _Img_icon_ = ImageView:create()
	_Img_icon_:loadTexture(GetHeadImgPath())
	
	_Img_icon_:setPosition(ccp(6, 17))
	local _Side_icon = ImageView:create()
	--头像框固定为无品质的框
	local strColorPath = "Image/imgres/common/color/wj_pz7.png"
	--_Side_icon:loadTexture(GetHeadColorPath())
	_Side_icon:loadTexture(strColorPath)
	AddLabelImg(_Side_icon,50,pIconContrl)
	AddLabelImg(_Img_icon_,1000,pIconContrl)
	

	-- 返回一个可以点击的控件，
	_Side_icon:setTouchEnabled(true)
	return _Side_icon
end

local function showDisplayIcon( pIconContrl,nHeadID,nColorID )
	local _Img_icon_ = ImageView:create()
	_Img_icon_:loadTexture(GetHeadImgPath(nHeadID))
	_Img_icon_:setPosition(ccp(6, 17))
	
	local _Side_icon = ImageView:create()
	_Side_icon:loadTexture(GetHeadColorPath(nColorID))
	AddLabelImg(_Side_icon,50,pIconContrl)
	AddLabelImg(_Img_icon_,1000,pIconContrl)
	

	-- 返回一个可以点击的控件，
	_Side_icon:setTouchEnabled(false)
	_Img_icon_:setTouchEnabled(false)
	--return _Side_icon	
end
local function showGeneralCommonIcon(pIconContrl,nTempId)
	local _Img_icon_ = ImageView:create()
	_Img_icon_:loadTexture(GetGeneralHeadIcon(nTempId))
	_Img_icon_:setPosition(ccp(6, 17))
	
	if pIconContrl:getChildByTag(1000) ~= nil then
		pIconContrl:getChildByTag(1000):setVisible(false)
		pIconContrl:getChildByTag(1000):removeFromParentAndCleanup(true)
	end
	--pIconContrl:addChild(_Img_icon_, 0, 1000)

	
	local _Img_icon = ImageView:create()
	_Img_icon:loadTexture(GetGeneralColorIcon(nTempId))

	if pIconContrl:getChildByTag(50) ~= nil then
		pIconContrl:getChildByTag(50):setVisible(false)
		pIconContrl:getChildByTag(50):removeFromParentAndCleanup(true)
	end
	
	
	pIconContrl:addChild(_Img_icon, 0, 50)
	--add by sxin 根据美术修改位置
	pIconContrl:addChild(_Img_icon_, 0, 1000)
	return pIconContrl
end
local function showHeadCommonIcon(pIconContrl,nTempId,nHeadID,nLevel)
	local _Img_icon_ = ImageView:create()
	local _Side_icon = ImageView:create()
	if nTempId~=nil then
		_Img_icon_:loadTexture(GetGeneralHeadIcon(nTempId))
		
	else
		_Img_icon_:loadTexture(GetHeadImgPath(nHeadID))
	end
	_Img_icon_:setPosition(ccp(6, 17))
	_Side_icon:loadTexture("Image/imgres/common/color/wj_pz7.png")
	
	
	AddLabelImg(_Side_icon,50,pIconContrl)
	AddLabelImg(_Img_icon_,1000,pIconContrl)
	
	if nLevel~=nil then
		-- 加等级
		--local label_lv = LabelLayer.createStrokeLabel(20,CommonData.g_FONT1,nLevel,ccp(-46,-40),COLOR_Black,COLOR_White,false,ccp(0,-2),2)
		--AddLabelImg(label_lv,1001,pIconContrl)
	end

	-- 返回一个可以点击的控件，
	_Side_icon:setTouchEnabled(true)
	return _Side_icon
end
--道具碎片，只有品质框
local function ShowColorItemIcon(pIconContrl,nTempId)
	local _Img_icon_ = ImageView:create()
	_Img_icon_:loadTexture(GetItemPathByTempID(nTempId))
	_Img_icon_:setPosition(ccp(0, 0))

	AddLabelImg(_Img_icon_,1000,pIconContrl)
	local nItem_type = GetItemTypeByTempID(nTempId)
	-- 添加品质框
	if tonumber(nItem_type) == 1 then -- 消耗品
		local _Img_head_sprite_1 = tolua.cast(pIconContrl:getVirtualRenderer(), "CCSprite")
		MakeMaskIcon(_Img_head_sprite_1, "Image/imgres/common/bottom.png", 0, 1, "Image/imgres/common/color/icon_mask.png")

		local _Img_head_sprite_1 = tolua.cast(_Img_icon_:getVirtualRenderer(), "CCSprite")
		MakeMaskIcon(_Img_head_sprite_1, GetItemPathByTempID(nTempId), 0, 1, "Image/imgres/common/color/icon_mask.png")

	elseif tonumber(nItem_type) == 2 then -- 碎片
		--这里如果用原来的小底图，就会出现listview添加的初始坐标错误的情况
		pIconContrl:loadTexture("Image/imgres/common/bottom.png")
		local _Img_head_sprite_1 = tolua.cast(pIconContrl:getVirtualRenderer(), "CCSprite")
		MakeMaskIcon(_Img_head_sprite_1, "Image/imgres/common/bottom.png", 0, 1, "Image/imgres/common/color/jianghun_mask.png")

		_Img_icon_:loadTexture("Image/imgres/common/common_empty.png")
		local _Img_head_sprite_1 = tolua.cast(_Img_icon_:getVirtualRenderer(), "CCSprite")
		MakeMaskIcon(_Img_head_sprite_1, GetItemPathByTempID(nTempId), 0, 1, "Image/imgres/common/color/jianghun_mask.png")

	elseif tonumber(nItem_type) == 3 then -- 将魂
		pIconContrl:loadTexture("Image/imgres/common/common_empty.png")
		local _Img_head_sprite_1 = tolua.cast(pIconContrl:getVirtualRenderer(), "CCSprite")
		MakeMaskIcon(_Img_head_sprite_1, "Image/imgres/common/bottom.png", 0, 1, "Image/imgres/common/color/jianghun_mask.png")

		_Img_icon_:loadTexture("Image/imgres/common/common_empty.png")
		local _Img_head_sprite_1 = tolua.cast(_Img_icon_:getVirtualRenderer(), "CCSprite")
		MakeMaskIcon(_Img_head_sprite_1, GetItemPathByTempID(nTempId), 0, 1, "Image/imgres/common/color/jianghun_mask.png")
	else
		local _Img_head_sprite_1 = tolua.cast(pIconContrl:getVirtualRenderer(), "CCSprite")
		MakeMaskIcon(_Img_head_sprite_1, "Image/imgres/common/bottom.png", 0, 1, "Image/imgres/common/color/icon_mask.png")

		_Img_icon_:loadTexture("Image/imgres/common/common_empty.png")
		local _Img_head_sprite_1 = tolua.cast(_Img_icon_:getVirtualRenderer(), "CCSprite")
		MakeMaskIcon(_Img_head_sprite_1, GetItemPathByTempID(nTempId), 0, 1, "Image/imgres/common/color/icon_mask.png")
	end
	
	--[[--这里如果用原来的小底图，就会出现listview添加的初始坐标错误的情况
	pIconContrl:loadTexture("Image/imgres/common/bottom.png")
	local _Img_head_sprite_1 = tolua.cast(pIconContrl:getVirtualRenderer(), "CCSprite")
	MakeMaskIcon(_Img_head_sprite_1, "Image/imgres/common/bottom.png", 0, 1, "Image/imgres/common/color/jianghun_mask.png")

	_Img_icon_:loadTexture("Image/imgres/common/common_empty.png")
	local _Img_head_sprite_2 = tolua.cast(_Img_icon_:getVirtualRenderer(), "CCSprite")
	MakeMaskIcon(_Img_head_sprite_2, GetItemPathByTempID(nTempId), 0, 1, "Image/imgres/common/color/jianghun_mask.png")]]--
	
	local _Img_icon = ImageView:create()
	_Img_icon:loadTexture(GetItemColorPathByTempID(nTempId))
	--[[local img_stone = ImageView:create()
	img_stone:loadTexture(GetStonePathByTempId(nTempId))
	img_stone:setPosition(ccp(48,43))
	AddLabelImg(img_stone,1000,_Img_icon)]]--
	if tonumber(nItem_type) == 2 then -- 碎片
		
		local img_stone = ImageView:create()
		img_stone:loadTexture(GetStonePathByTempId(nTempId))
		img_stone:setPosition(ccp(48,43))
		AddLabelImg(img_stone,1000,_Img_icon)
	end
	if tonumber(nItem_type) == 3 then -- 将魂
		
		local img_hun = ImageView:create()
		img_hun:loadTexture(GetHunPathByTempID(nTempId))
		img_hun:setPosition(ccp(48,43))
		AddLabelImg(img_hun,1001,_Img_icon)
	end
	if tonumber(nItem_type) == 7 then
		--加上特效
		if pIconContrl:getChildByTag(5000) ~= nil then
			pIconContrl:getChildByTag(5000):setVisible(false)
			pIconContrl:getChildByTag(5000):removeFromParentAndCleanup(true)
		end
		if pIconContrl:getChildByTag(5000) == nil then
			CommonInterface.GetAnimationByName("Image/imgres/effectfile/WJ-wuqikuang.ExportJson", 
				"WJ-wuqikuang", 
				"Animation1", 
				pIconContrl, 
				ccp(0, 0),
				nil,
				5000)
		end
	end
	AddLabelImg(_Img_icon,1001,pIconContrl)
	-- 返回一个可以点击的控件，
	_Img_icon:setTouchEnabled(true)
	return _Img_icon
end

--军团科技
function ShowScienceItemIcon( pIconContrl,nTempId,nLv )
	local _Img_icon_ = ImageView:create()
	_Img_icon_:loadTexture(GetScienceImg(nTempId))
	_Img_icon_:setPosition(ccp(0, 0))
	--AddLabelImg(_Img_icon_,1000,pIconContrl)
	if nLv ~= nil then
		local label_lv = LabelLayer.createStrokeLabel(24,CommonData.g_FONT1,string.format("Lv.%d",nLv),ccp(-46,-40),COLOR_Black,COLOR_White,false,ccp(0,-2),2)
		if pIconContrl:getChildByTag(51) ~= nil then
			pIconContrl:getChildByTag(51):setVisible(false)
			pIconContrl:getChildByTag(51):removeFromParentAndCleanup(true)
		end
		pIconContrl:addChild(label_lv, 0, 51)
	end

	local _Img_head_sprite_1 = tolua.cast(pIconContrl:getVirtualRenderer(), "CCSprite")
	MakeMaskIcon(_Img_head_sprite_1, "Image/imgres/common/bottom.png", 0, 1, "Image/imgres/common/color/icon_mask.png")

	local _Img_head_sprite_1 = tolua.cast(_Img_icon_:getVirtualRenderer(), "CCSprite")
	MakeMaskIcon(_Img_head_sprite_1, GetScienceImg(nTempId), 0, 1, "Image/imgres/common/color/icon_mask.png")

	local _Img_icon = ImageView:create()
	_Img_icon:loadTexture("Image/imgres/common/color/wj_pz7.png")

	AddLabelImg(_Img_icon_,1000,_Img_icon)

	_Img_icon:setTouchEnabled(true)
	AddLabelImg(_Img_icon,1000,pIconContrl)

	return _Img_icon
end

--nCurLv 值不为空的时候，是自动强化需要
function MakeHeadIcon(pIconContrl, nIconType, nTempId, nGrid,nCurLv,nHeadID,nColorID,nLv)
	
	pIconContrl:loadTexture(ICON_BG_COMMON_PATH)
    if nIconType == ICONTYPE.GENERAL_ICON then
		
		return  showGeneralIcon(pIconContrl,nTempId,nGrid)
    end

    if nIconType == ICONTYPE.ITEM_ICON then
        --print("nTempId = " .. nTempId)
		return showItemIcon(pIconContrl,nTempId)
    end

    if nIconType == ICONTYPE.EQUIP_ICON then

		return showEquipIcon(pIconContrl,nTempId,nGrid,nCurLv)
    end
	if nIconType == ICONTYPE.COIN_ICON then
		return showCoinIcon(pIconContrl,nTempId)
	end
	if nIconType == ICONTYPE.PLAYER_ICON then
		return showPlayerIcon(pIconContrl)
	end
	if nIconType == ICONTYPE.DISPLAY_ICON then
		return showDisplayIcon(pIconContrl,nHeadID,nColorID)
	end
	--只有武将的头像和品质框
	if nIconType == ICONTYPE.GENERAL_COLOR_ICON then
		return showGeneralCommonIcon(pIconContrl,nTempId)
	end
	if nIconType == ICONTYPE.HEAD_ICON then
		return showHeadCommonIcon(pIconContrl,nTempId,nHeadID,nLv)
	end
	if nIconType == ICONTYPE.ITEM_COLOR_ICON then
		return ShowColorItemIcon(pIconContrl,nTempId)
	end
	if nIconType == ICONTYPE.SCIENCEUP_ICON then
		return ShowScienceItemIcon(pIconContrl,nTempId,nLv)
	end
end

--add by sxin 增加一个创建骨骼动画的接口 通过资源名字会自动创建动画返回指针
function CreatAnimateByResID( iResID )
	
	local strAnimationfileName = AnimationData.getFieldByIdAndIndex(iResID,"AnimationfileName")
	print("pAnimationfileNamepAnimationfileName = " .. strAnimationfileName)		
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(strAnimationfileName)

	local strAnimationName = AnimationData.getFieldByIdAndIndex(iResID,"AnimationName")
	print("pAnimationNamepAnimationName = " .. strAnimationName)
	local pPayArmature = CCArmature:create(strAnimationName)

	pPayArmature:getAnimation():play(GetAniName_Res_ID(iResID, Ani_Def_Key.Ani_stand))	
	
		
	return pPayArmature
	
end

--add by celina 增加创建动画的接口，需要传入图片的资源ID,以及动作的名称
function GetAnimateByIDAnimation( iResID,nType )
	local strAnimationfileName = AnimationData.getFieldByIdAndIndex(iResID,"AnimationfileName")
	--print("pAnimationfileNamepAnimationfileName = " .. strAnimationfileName)		
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(strAnimationfileName)

	local strAnimationName = AnimationData.getFieldByIdAndIndex(iResID,"AnimationName")
	--print("pAnimationNamepAnimationName = " .. strAnimationName)
	local pPayArmature = CCArmature:create(strAnimationName)

	pPayArmature:getAnimation():play(GetAniName_Res_ID(iResID, nType))	
		
	return pPayArmature
end

function RunListAction( pListView, tabData, nNumPerPage,  CallBackFun)
	if CallBackFun==nil then
		return
	end
	pListView:removeAllItems()
	pListView:stopAllActions()
	local nTimes = math.floor((#tabData)/nNumPerPage)
	local nCount = 1
	if #tabData<=nNumPerPage then
		CallBackFun( tabData,  nCount, #tabData  )
		return
	end
	CallBackFun( tabData,  nCount, nNumPerPage  )
	local function UpdateCallBack()
		nCount = nCount+1
		if nCount > nTimes+1 then
			return
		end
		CallBackFun( tabData,  (nCount-1)*nNumPerPage+1, (nCount)*nNumPerPage-math.floor((nCount*nNumPerPage)/(#tabData))*(nNumPerPage-#tabData%nNumPerPage))
	end
	local pActUpdate=CCArray:create()
	pActUpdate:addObject(CCCallFuncN:create(UpdateCallBack))
	pActUpdate:addObject(CCDelayTime:create(1/60))
	pListView:runAction(CCRepeat:create(CCSequence:create(pActUpdate), nTimes))
end









