require "Script/Main/Equip/EquipOperateData"
require "Script/Common/ConsumeLogic"



module("EquipStrengthenLogic", package.seeall)


--数据
local GetCurLvByGird     = EquipListData.GetCurLvByGird
local GetBaseIDByGridStr = EquipListData.GetBaseIDByGridStr
local GetTempID          = EquipListData.GetTempID
local GetBaseAddValue    = EquipListData.GetBaseAddValue
local GetBaseValueByGrid = EquipListData.GetBaseValueByGrid
local GetBaseMethodByBaseID = EquipListData.GetBaseMethodByBaseID
local GetQHConsumeIDByGrid = EquipListData.GetQHConsumeIDByGrid
local GetQHUnlockLv        = EquipListData.GetQHUnlockLv
local GetTypeByGrid      = EquipListData.GetTypeByGrid
local GetValueByLvID     = EquipListData.GetValueByLvID
local GetEquipIconPathByGrid = EquipListData.GetEquipIconPathByGrid
local GetJinLExpByGrid   = EquipListData.GetJinLExpByGrid
local GetJLConsumeIDByGrid = EquipListData.GetJLConsumeIDByGrid
local GetStarLvByGrid    = EquipListData.GetStarLvByGrid
local GetHighestLvByGrid = EquipListData.GetHighestLvByGrid
local GetValueRefineByLvID = EquipListData.GetValueRefineByLvID
local GetEquipNameByGrid = EquipListData.GetEquipNameByGrid
local GetQHLimitLvByGrid = EquipOperateData.GetQHLimitLvByGrid

local GetConsumeItemData = ConsumeLogic.GetConsumeItemData
local GetConsumeTab        = ConsumeLogic.GetConsumeTab

 local CheckBEquipedByGird = EquipListData.CheckBEquipedByGird


--变量
local m_unlock_lv  = nil 
local m_bEffectOver = false

E_STRENGTHEN_TYPE = {
	E_STRENGTHEN_TYPE_NORMAL = 0,--强化
	E_STRENGTHEN_TYPE_AUTO   = 1 --自动强化

}

function GetBRefineLimit(nGrid)
	if tonumber(GetStarLvByGrid(nGrid)) == 10 then
		return true
	end
	return false
end
function GetBLimitLayerByGrid(nGrid,nCurLv)
	if nCurLv~=nil then
		if tonumber(nCurLv) == GetHighestLvByGrid(nGrid) then
			return true
		end
	else
		if tonumber(GetCurLvByGird(nGrid)) == GetHighestLvByGrid(nGrid) then
			return true
		end
	end
	
	return false
end

function GetBHaveBaseByGrid(nGrid,strBase)
	if tonumber(GetBaseIDByGridStr(nGrid,strBase)) ~= -1 then
		return true
	end
	return false
end

--传入基础属性的值，以及当前的等级，以及需要重置的对象isAdd是否要显示加号1,显示，2不显示 非叠加值
function GetBaseValueNoAdd(nGird,strBase,cur_lv,base_object,isAdd)
	local baseID = GetBaseIDByGridStr(nGird,strBase)
	local base_value = nil
	if tonumber(cur_lv)==0 then
		base_value = tonumber(GetBaseValueByGrid(nGird,strBase))
	else
		local str_d = string.format("Inc_Att_%d",cur_lv)
		base_value = tonumber( GetBaseAddValue(baseID,str_d) )
	end
	local type_add = GetBaseMethodByBaseID(baseID)--得到类型0、2不是百分比，1、3、4是百分比显示
	if ( tonumber(type_add) == 0 ) or 
		( tonumber(type_add) == 2 )  then
		if add_id == 1 then 
			base_object:setText("+"..base_value)
		else
			base_object:setText(base_value)
		end
	else
		--print((value_sum*100).."==============")
		if add_id == 1 then 
			base_object:setText("+"..(base_value*100).."%")
		else
			base_object:setText((base_value*100).."%")
		end
	end

end
local function GetExpendDataByGrid(nGrid,curLv)
	return  GetConsumeTab(5,GetQHConsumeIDByGrid(nGrid),curLv,1)
end
--nCount 总共的数量，nCurOrder当前第几个
local function ShowExpendByType(nGrid,imgColorPath,imgPath,nConsumeNeedNum,nConsumeOwnNum,bEnough,nCount,nCurOrder,nCosumeID)
	local m_layer = nil 
	if tonumber(GetTypeByGrid(nGrid)) == E_BAGITEM_TYPE.E_BAGITEM_TYPE_LINGBAO then
		m_layer =  LingBaoStrengthen.GetLingBaoStrengthenUI()
		
	elseif tonumber(GetTypeByGrid(nGrid)) == E_BAGITEM_TYPE.E_BAGITEM_TYPE_TREASURE then
		--宝物精炼的时候才调用
		m_layer = TreasureRefine.GetRefineUI()
	end
	--添加到的背景
	print("3===========")
	local img_select_bg = tolua.cast(m_layer:getWidgetByName("img_bg_select"),"ImageView")
	local width = img_select_bg:getContentSize().width
	--背景
	local img_icon_bg = ImageView:create()
	img_icon_bg:loadTexture("Image/imgres/equip/icon/bottom.png")
	
	local l_posL = -width/2
	img_icon_bg:setPosition(ccp(l_posL+((width-(nCount-1)*112)/2)+(nCurOrder-2)*112,-1))
	img_icon_bg:setScale(0.68)
	img_select_bg:addChild(img_icon_bg,nCurOrder,nCurOrder)
	--道具或者装备
	local img_xh_icon = ImageView:create()
	img_xh_icon:loadTexture(imgPath)
	img_icon_bg:addChild(img_xh_icon)
	--品质框
	local img_color_icon = ImageView:create()
	img_color_icon:loadTexture(imgColorPath)
	img_icon_bg:addChild(img_color_icon)
	--添加指引
	local pGuideXH = GuideRegisterManager.RegisterGuideManager()
	pGuideXH:RegisteGuide(img_color_icon,nCosumeID,GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_ITEM)
	pGuideXH = nil
	local img_num_bg = ImageView:create()
	img_num_bg:loadTexture("Image/imgres/wujiang/lv_bg.png")
	img_num_bg:setPosition(ccp(img_icon_bg:getPositionX(),img_icon_bg:getPositionY()-25))
	img_num_bg:setScale(1.4)
	img_select_bg:addChild(img_num_bg)
	local label_num_xh = nil 
	local posNum = ccp(img_num_bg:getPositionX()+2,img_num_bg:getPositionY())
	if bEnough == true then
		label_num_xh = LabelLayer.createStrokeLabel(18,CommonData.g_FONT1,nConsumeOwnNum.."/"..nConsumeNeedNum,posNum,COLOR_Black,ccc3(99,216,53),true,ccp(0,-2),2)
	else
		label_num_xh = LabelLayer.createStrokeLabel(18,CommonData.g_FONT1,nConsumeOwnNum.."/"..nConsumeNeedNum,posNum,ccc3(23,5,5),ccc3(255,87,35),true,ccp(0,-2),2)
	end
	EquipCommon.AddStrokeLabel(label_num_xh,100+nCurOrder,img_select_bg)
end
local function GetExpendJLDataByGrid(nGrid,curLv)
	return  GetConsumeTab(5,GetJLConsumeIDByGrid(nGrid),curLv,1)
end
local function GetExpendXLDataByID(nXLID,curLv)
	print("GetExpendXLDataByID")
	print(nXLID,curLv)
	--Pause()
	return  GetConsumeTab(5,nXLID,curLv,1)
end
--消耗多个不同物品的逻辑nType 0表示强化，1表示精炼
function ExpendCommon(nGrid,curLv,nType)
	local tableExpend = nil 
	if nType==1 then
		--说明是精炼
		tableExpend = GetExpendJLDataByGrid(nGrid,curLv)
		--printTab(tableExpend)
		--Pause()
	end
	if nType==0 then
		--表示是强化
		tableExpend = GetExpendDataByGrid(nGrid,curLv)
	end
	for i=1,#tableExpend do 
		local tableExpendData = GetConsumeItemData(tableExpend[i].ConsumeID,tableExpend[i].nIdx,tableExpend[i].ConsumeType,tableExpend[i].IncType,curLv,1,nGrid)
		if tableExpendData.ConsumeType ~= 1 then
			local ownNum = tableExpendData.ItemNum
			if EquipPropertyLayer.GetLayerType() == E_LAYER_TYPE.E_LAYER_TYPE_ZHENRONG then
				local nSelfId = GetTempID(nGrid)
				if tonumber(tableExpendData.ItemId) == tonumber(nSelfId) then
					if CheckBEquipedByGird(nGrid) == false then
						ownNum = ownNum +1 
					end
				end
			end
			if ownNum>= tonumber(tableExpendData.ItemNeedNum) then
				tableExpendData.Enough = true
			else
				tableExpendData.Enough = false
			end
			--暂时先固定一定会消耗银币，所以总个数减掉一个
			ShowExpendByType(nGrid,tableExpendData.ColorIcon,tableExpendData.IconPath,tableExpendData.ItemNeedNum,ownNum,tableExpendData.Enough,#tableExpend-1,i,tableExpendData.ItemId)
		else
			--消耗银币
			if tableExpendData.Enough == false then
				EquipOperateLogic.SetSliverNum(tableExpendData.ItemNeedNum,2)
			else
				EquipOperateLogic.SetSliverNum(tableExpendData.ItemNeedNum,1)
			end
		end
	end
end
--洗炼的显示
local function ShowExpendXL(nItemID,mLayerXl,nConsumeNeedNum,bEnough,nType,imgPath,tag)
	local imgSliver = tolua.cast(mLayerXl:getWidgetByName("img_sliver"),"ImageView")
	local imgXL     = tolua.cast(mLayerXl:getWidgetByName("img_bs"),"ImageView")
	local mPanelXl = tolua.cast(mLayerXl:getWidgetByName("Panel_xl_before"),"Layout")
	--引导部分
	if tag == 2 then
		local consumeType2 = 0
		local consunmeItemID2 =0
		
		if tonumber(nType) == 0 then
			consunmeItemID2 = nItemID
			consumeType2 = GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_ITEM
		else
			consumeType2 = GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_COIN
			consunmeItemID2 = nType
		end
		--[[print("===")
		print(consumeType2)
		print(consunmeItemID2)
		Pause()]]--
		imgXL:setVisible(true)
		imgXL:setScale(0.7)
		imgXL:loadTexture(imgPath)
		local pGuideXL2 = GuideRegisterManager.RegisterGuideManager()
		pGuideXL2:RegisteGuide(imgXL,consunmeItemID2,consumeType2)
		pGuideXL2 = nil
	else
		local consumeType1 = 0
		local consunmeItemID1 =0
		if tonumber(nType) == 0 then
			consunmeItemID1 = nItemID
			consumeType1 = GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_ITEM
		else
			consumeType1 = GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_COIN
			consunmeItemID1 = nType
		end
		imgSliver:loadTexture(imgPath)
		local pGuideXL1 = GuideRegisterManager.RegisterGuideManager()
		pGuideXL1:RegisteGuide(imgSliver,consunmeItemID1,consumeType1)
		pGuideXL1 = nil
		imgXL:setVisible(false)
	end
	if mPanelXl:getChildByTag(1002)~=nil then
		mPanelXl:getChildByTag(1002):removeFromParentAndCleanup(true)
	end
	local label_num_xh = nil 
	local posNum = nil
	if tag ==1 then
		posNum = ccp(400,26)
	else
		posNum = ccp(520,26)
	end
	if bEnough == true then
		label_num_xh = LabelLayer.createStrokeLabel(20,CommonData.g_FONT1,nConsumeNeedNum,posNum,COLOR_Black,ccc3(99,216,53),false,ccp(0,-2),2)
	else
		label_num_xh = LabelLayer.createStrokeLabel(20,CommonData.g_FONT1,nConsumeNeedNum,posNum,ccc3(23,5,5),ccc3(255,87,35),false,ccp(0,-2),2)
	end
	EquipCommon.AddStrokeLabel(label_num_xh,1000+tag,mPanelXl)
end
function ExpendXL(nGrid,nXLID,nTimes,mLayerXl)
	print(nXLID,GetCurLvByGird(nGrid))
	--Pause()
	local tableXLExpend = GetExpendXLDataByID(nXLID,GetCurLvByGird(nGrid))
	for i=1,#tableXLExpend do 
		local tableExpendData = GetConsumeItemData(tableXLExpend[i].ConsumeID,tableXLExpend[i].nIdx,tableXLExpend[i].ConsumeType,tableXLExpend[i].IncType,curLv,1,nGrid)
		local nNeed = tonumber(tableExpendData.ItemNeedNum)
		local bEnough = tableExpendData.Enough
		nNeed = nNeed*nTimes
		local nOwn = tonumber(tableExpendData.ItemNum)
		if nOwn>=nNeed then
			bEnough = true 
		else
			bEnough = false
		end
		ShowExpendXL(tableExpendData.ItemId,mLayerXl,tableExpendData.ItemNeedNum,bEnough,tableXLExpend[i].ConsumeType,tableExpendData.IconPath,i)
	end
end
function GetXLExpendTableByXLID(nGrid,nXLID)
	local tableXLExpend = GetExpendXLDataByID(nXLID,GetCurLvByGird(nGrid))
	local tableGet = {}
	for i=1,#tableXLExpend do 
		local tableExpendData = GetConsumeItemData(tableXLExpend[i].ConsumeID,tableXLExpend[i].nIdx,tableXLExpend[i].ConsumeType,tableXLExpend[i].IncType,curLv,1,nGrid)
		table.insert(tableGet,tableExpendData)
	end
	return tableGet
end
function GetExpendXLNum(nGrid,nXLID)
	local tableXLExpend = GetExpendXLDataByID(nXLID,GetCurLvByGird(nGrid))
	local tableNeedNum = {}
	for i=1,#tableXLExpend do 
		local tableExpendData = GetConsumeItemData(tableXLExpend[i].ConsumeID,tableXLExpend[i].nIdx,tableXLExpend[i].ConsumeType,tableXLExpend[i].IncType,curLv,1,nGrid)
		local tableNeedOwn = {}
		tableNeedOwn.needNum = tableExpendData.ItemNeedNum
		tableNeedOwn.ownNum  = tableExpendData.ItemNum
		table.insert(tableNeedNum,tableNeedOwn)
	end
	return tableNeedNum
end
--消耗的金钱
function ShowExpendMoney(nGrid,curLv)
	local tableExpend = GetExpendDataByGrid(nGrid,curLv)
	local needValue = 0 
	for i=1,#tableExpend do 
		local tableExpendData = GetConsumeItemData(tableExpend[i].ConsumeID,tableExpend[i].nIdx,tableExpend[i].ConsumeType,tableExpend[i].IncType,curLv,1)
		if tableExpendData.Enough == false then
			EquipOperateLogic.SetSliverNum(tableExpendData.ItemNeedNum,2)
		else
			EquipOperateLogic.SetSliverNum(tableExpendData.ItemNeedNum,1)
		end
	end
end
local function BEnough(tableExpend,nCurLv,nGrid)
	for i=1,#tableExpend do 
		local tableExpendData = GetConsumeItemData(tableExpend[i].ConsumeID,tableExpend[i].nIdx,tableExpend[i].ConsumeType,tableExpend[i].IncType,nCurLv,1,nGrid)
		local ownNum = tableExpendData.ItemNum
		if EquipPropertyLayer.GetLayerType() == E_LAYER_TYPE.E_LAYER_TYPE_ZHENRONG then
			local nSelfId = GetTempID(nGrid)
			if tonumber(tableExpendData.ItemId) == tonumber(nSelfId) then
				if CheckBEquipedByGird(nGrid) == false then
					ownNum = ownNum +1 
				end
			end
		end
		if ownNum>= tonumber(tableExpendData.ItemNeedNum) then
			tableExpendData.Enough = true
		end
		if tableExpendData.Enough == false then
			return false
		end
	end
	return true
end
local function CheckBMoneyEnough(nGrid)
	local tableExpendMoney = GetExpendDataByGrid(nGrid,GetCurLvByGird(nGrid))	
	return BEnough(tableExpendMoney,GetCurLvByGird(nGrid),nGrid)
end
--检测精炼消耗
function CheckBExpendRefine(nGrid)
	local tableExpendRefine = GetExpendJLDataByGrid(nGrid,GetStarLvByGrid(nGrid))
	
	return BEnough(tableExpendRefine,GetStarLvByGrid(nGrid),nGrid)
end
function CheckBCanStrengthen(nGrid)
	local pTips = TipCommonLayer.CreateTipLayerManager()
	if GetCurLvByGird(nGrid) >= GetQHLimitLvByGrid(nGrid) then
		--TipLayer.createTimeLayer("当前装备已达到等级上限", 2)
		--TipCommonLayer.CreateTipsLayer(6,TIPS_TYPE.TIPS_TYPE_EQUIP,nGrid,nil)
		pTips:ShowCommonTips(101,nil,GetEquipNameByGrid(nGrid))
		pTips = nil 
		return false
	end
	if CheckBMoneyEnough(nGrid) == false then
		if GetTypeByGrid(nGrid) == E_BAGITEM_TYPE.E_BAGITEM_TYPE_LINGBAO then
			TipLayer.createTimeLayer("您的消耗品不足", 2)
			return false
		else
			--TipLayer.createTimeLayer("您的钱币不足", 2)
			local function ToShop(bSure)
				--暂时没有征收功能直接都按取消处理
				pTips = nil 
				return false
			end
			pTips:ShowCommonTips(1003,ToShop)
			return false
		end
		
	end
	pTips = nil 
	return true
end
function GetUnlockState(nGrid)
	for i=1,4 do 
		local lvUnlock = GetQHUnlockLv(nGrid,"QiangHLv_"..i)
		local curLv = GetCurLvByGird(nGrid)
		if tonumber(curLv)>= tonumber(lvUnlock) then
			return true
		end
	end
	return false
end
--[[local function AddStrengthenEffect(nLevel)
	local nCur_S_Lv = nil
	if nLevel ~= nil then
		nCur_S_Lv = nLevel
	else
		nCur_S_Lv = server_equipDB.GetLevelByGrid(m_equip_server_id)
	end
end]]--

function Post_Packet_Strengthen(nGrid,nTagStrengthen,fCallBack,bGuide)
	local function strengthenOver(tTable)
		if bGuide==nil then
			NetWorkLoadingLayer.loadingHideNow()
		end
		if nTagStrengthen == E_STRENGTHEN_TYPE.E_STRENGTHEN_TYPE_AUTO then
			--自动强化
			
			fCallBack(tTable)
		else
			fCallBack(nil)
		end
		
	end
	if bGuide~=nil then
		Packet_StrengthenEquip.SetSuccessCallBack(strengthenOver)
		NewGuideManager.PostPacket(NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_15,nGrid, nTagStrengthen)
	else
		Packet_StrengthenEquip.SetSuccessCallBack(strengthenOver)
		network.NetWorkEvent(Packet_StrengthenEquip.CreatPacket(nGrid, nTagStrengthen))
		NetWorkLoadingLayer.loadingShow(true)
	end
end
function GetStrengthenInfoByGrid(nGrid)
	local m_label_info = ""
	if tonumber(GetTypeByGrid(nGrid)) == E_BAGITEM_TYPE.E_BAGITEM_TYPE_EQUIP then
		m_label_info="这件装备已达顶级了哦"
	elseif tonumber(GetTypeByGrid(nGrid)) == E_BAGITEM_TYPE.E_BAGITEM_TYPE_TREASURE then
		m_label_info="这件宝物已达顶级了哦"
	elseif tonumber(GetTypeByGrid(nGrid)) == E_BAGITEM_TYPE.E_BAGITEM_TYPE_LINGBAO then
		m_label_info="这件灵宝已达顶级了哦"
	end
	
	return m_label_info
end
local function GetExpData(nGrid,lv)
	
	local tableExpend = GetExpendDataByGrid(nGrid,GetCurLvByGird(nGrid))
	local valueNeedExp = 0 
	local ownExp = 0
	if lv== nil then
		lv = 1 
	end
	--只有一个
	for key,value in pairs(tableExpend) do 
		local tableExpendData = GetConsumeItemData(value.ConsumeID,value.nIdx,value.ConsumeType,value.IncType,GetCurLvByGird(nGrid),lv,nGrid)
		return tableExpendData
	end
end
local function GetNeedExpend(nGrid)
	local dataNeed = GetExpData(nGrid)
	
	return dataNeed.ItemNeedNum
end
local function GetOwnExpend(nGrid)
	local dataOwn = GetExpData(nGrid)
	return dataOwn.ItemNum
end
--得到当前经验和需要经验的百分比
function GetExpPercent(nGrid)
	--得到强化消耗的ID
	local ownExp = GetOwnExpend(nGrid) 
	local needExp = GetNeedExpend(nGrid)
	local cur_percent = (ownExp/needExp)*100 
	if tonumber(cur_percent)>100 then
		cur_percent = 100
	end
	return cur_percent
end
function GetExpInfo(nGrid)
	return GetOwnExpend(nGrid).."/"..GetNeedExpend(nGrid)
end	
function GetExpPercentByExp(nGrid,expNow)
	local needExp = GetNeedExpend(nGrid)
	local ownExp = GetOwnExpend(nGrid) 
	local nowOwnExp = tonumber(expNow)+tonumber(ownExp)
	local cur_percent = (nowOwnExp/needExp)*100 
	if tonumber(cur_percent)>100 then
		cur_percent = 100
	end
	return cur_percent
end
--添加了宝物以后更新显示的文字
function GetExpAdd(nGrid,expNow)
	local needExp = GetNeedExpend(nGrid)
	local ownExp = GetOwnExpend(nGrid) 
	local nowOwnExp = tonumber(expNow)+tonumber(ownExp)
	return nowOwnExp.."/"..needExp
end
--获得经验
function GetNeedExpByGirdLv(nGrid,upLv)
	local dataNeed = GetExpData(nGrid,upLv)
	
	return dataNeed.ItemNeedNum
end
function GetHeapExpByGrid(nGrid,nowHighLv)
	local backExp = 0 
	if nowHighLv == 0 then
		backExp = GetJinLExpByGrid(nGrid)
	end
	for i=1,nowHighLv do 
		local tableExpend = GetExpendDataByGrid(nGrid,i)
		--只有一个
		for key,value in pairs(tableExpend) do 
			local tableExpendData = GetConsumeItemData(value.ConsumeID,value.nIdx,value.ConsumeType,value.IncType,i-1,1,nGrid)
			backExp = backExp + tableExpendData.ItemNeedNum
		end
	end
	if nowHighLv>0 then
		backExp = backExp + GetJinLExpByGrid(nGrid)
	end
	return backExp
end
function GetSelecExp(tableExp)
	local exp_total = 0 
	for key,value in pairs(tableExp) do
		exp_total = exp_total + GetHeapExpByGrid(value.m_grid,GetCurLvByGird(value.m_grid))
	end
	local needMoney = tonumber(exp_total)/5
	local my_sliver = CommonData.g_MainDataTable["silver"]
	if tonumber(my_sliver)<tonumber(needMoney) then
		--说明我的钱不够
		EquipOperateLogic.SetSliverNum(needMoney,2)
	else
		EquipOperateLogic.SetSliverNum(needMoney,1)
	end
	return exp_total
end

--冒字的特效
function RunActionArrTip(orgLv,curLv,nGrid)
	local base_table = GetValueByLvID(nGrid,orgLv,curLv)
	for i=1,#base_table do 
		--[[TipLayer.createPopTipLayer( base_table[i].baseName.. "+" ..base_table[i].addValue , 32, 
			COLOR_Green, ccp(816/2+50, 500/2 - (i-1)*30))]]--
	end
	
end
--精炼冒字的特效
function RunActionArrTipRefine(orgLv,curLv,nGrid)
	local base_table = GetValueRefineByLvID(nGrid,orgLv,curLv)
	for i=1,#base_table do 
		--[[TipLayer.createPopTipLayer( base_table[i].baseName.. "+" ..base_table[i].addValue , 32, 
			COLOR_Green, ccp(816/2+50, 500/2 - (i-1)*30))]]--
	end
end
--升级特效
function ShowUpLvEffect(m_layer,str_path1,str_path2,lv,callBack)
	local img_1 = ImageView:create()
	img_1:loadTexture(str_path1)
	img_1:setPosition(ccp(750/2-img_1:getContentSize().width+48,540/2-10))
	
	local m_lv_num = LabelBMFont:create()
	m_lv_num:setText(lv)
	--m_lv_num:setAnchorPoint(ccp(0,0.5))
	m_lv_num:setFntFile("Image/imgres/effect/num.fnt")
	m_lv_num:setPosition(ccp(750/2+12,540/2-10))
	
	local img_2 = ImageView:create()
	img_2:loadTexture(str_path2)
	img_2:setPosition(ccp(750/2+img_1:getContentSize().width-60,540/2-10))
	
	local layout_now = Layout:create()
	
	layout_now:addChild(img_1)
	layout_now:addChild(m_lv_num)
	layout_now:addChild(img_2)
	if m_layer:getChildByTag(1001) ~=nil then
		m_layer:getChildByTag(1001):removeFromParentAndCleanup(true)
	end
	m_layer:addChild(layout_now,1001,1001)
	local function EffectCallback()
		layout_now:removeFromParentAndCleanup(true)
		--print("================1010898888================")
		if callBack~=nil then
			--print("================898888================")
			callBack()
		end
	end
	local effect_array = CCArray:create()
	effect_array:addObject(CCDelayTime:create(0.5))
	effect_array:addObject(CCFadeOut:create(1))
	effect_array:addObject(CCCallFunc:create(EffectCallback))
	local e_action = CCSequence:create(effect_array)
	layout_now:runAction(e_action)
	effect_array:removeAllObjects()
	effect_array = nil
end
local function GetActionStrengthen(fCallBack,imgIcon)
	local TagIcon = EquipOperateLayer.getImgIcon()
	local action1 = CCMoveTo:create(0.5,ccp(-160,300))
	local action2 = CCCallFuncN:create(fCallBack)
	local action12 = CCFadeOut:create(0.3)
	local action13 = CCScaleTo:create(0.3, 0)
	local action3 = CCSpawn:createWithTwoActions(action12,action13)
	
	
	local actionArray1 = CCArray:create()
	actionArray1:addObject(action1)
	actionArray1:addObject(action2)
	actionArray1:addObject(action3)
	return actionArray1
end
local function RunTreasureAction(nCurLv,nOrgLv)
	-- 加特效
	--print("RunTreasureAction")
	--Pause()
	local m_lyTreasureStrengthen = TreasureStrengthen.GetTreasureUI()
	local Image_20 = EquipOperateLayer.getImgIcon():getChildByTag(50)--tolua.cast(m_lyTreasureStrengthen:getWidgetByName("img_exp"),"ImageView")
	local ImageExp = tolua.cast(m_lyTreasureStrengthen:getWidgetByName("img_pro_bg"),"ImageView")
	local function effect_02()
		-- 判断是否满了。如果满了加特效
		if tonumber(nCurLv) > tonumber(nOrgLv) then
		
			local function effect_04()
				--fActionCallBack()
			end
			
			CommonInterface.CreateRunAnimationByJsonPath("Image/imgres/effectfile/qianghua04.ExportJson", 
					"qianghua04", 
					0, 
					ImageExp, 
					ccp(0, 0),
					effect_04,
					10)
		else
			--fActionCallBack()
		end
	end
	CommonInterface.GetAnimationByName("Image/imgres/effectfile/StrengthenEquip_effect_01.ExportJson", 
		"StrengthenEquip_effect_01", 
		"qianghua02", 
		Image_20, 
		ccp(0, 0),
		effect_02,
		10)
end	
function RunActionTableData(table_select,nOrgLv,nCurLv,nGrid)
	local indexAction = 0
	for key,value in pairs(table_select) do 
		local imgIcon = StrengthenNarmalLayer.GetIconByOrderID(key)
		local function ActionCallBack()
			indexAction =indexAction+1
			if indexAction == #table_select then
				RunTreasureAction(nCurLv,nOrgLv)
			end
			
			imgIcon:removeFromParentAndCleanup(true)
			imgIcon = nil
		end
		imgIcon:runAction(CCSequence:create(GetActionStrengthen(ActionCallBack)))
	end
	
	
end
function GetUnlockLvNow(nGrid)
	local tableInfoUnlock = EquipPropertyData.GetUnLockValueInfo(nGrid)
	if tonumber(GetCurLvByGird(nGrid))>=tonumber(tableInfoUnlock[1].f_lv) and
		tonumber(GetCurLvByGird(nGrid))<tonumber(tableInfoUnlock[2].f_lv) then
		m_unlock_lv = tonumber(tableInfoUnlock[2].f_lv)
	else
		m_unlock_lv = tonumber(tableInfoUnlock[1].f_lv)
	end
	if tonumber(GetCurLvByGird(nGrid))>=tonumber(tableInfoUnlock[2].f_lv) and
		tonumber(GetCurLvByGird(nGrid))<tonumber(tableInfoUnlock[3].f_lv) then
		m_unlock_lv = tonumber(tableInfoUnlock[3].f_lv)
	end
	if tonumber(GetCurLvByGird(nGrid))>=tonumber(tableInfoUnlock[3].f_lv) and
		tonumber(GetCurLvByGird(nGrid))<tonumber(tableInfoUnlock[4].f_lv) then
		m_unlock_lv = tonumber(tableInfoUnlock[4].f_lv)
	end
	if tonumber(GetCurLvByGird(nGrid))>=tonumber(tableInfoUnlock[4].f_lv) then
		m_unlock_lv = 100
	end
	
end
local function CheckBUnLock(nLv)
	
	if tonumber(nLv)>=  m_unlock_lv then
		return true 
	end
	return false
end
local function CheckBaoJi(nOrgLv,nCurLv)
	if tonumber(nCurLv)-tonumber(nOrgLv)>1 then
		return true
	end
	return false
end
local function GetImgByPath(pos,img_path)
	local img_now = ImageView:create()
	img_now:loadTexture(img_path)
	img_now:setAnchorPoint(ccp(0.5,0.5))
	img_now:setPosition(pos)
	return img_now
end
local function RunBaojiEffect(img_path1,img_path2 ,img_path3,mLayer)

	
	
	local img_bg = ImageView:create()
	img_bg:loadTexture("Image/imgres/common/common_empty.png")
	
	
	local img_1 = GetImgByPath(ccp(img_bg:getContentSize().width/2-180,img_bg:getContentSize().height),img_path1)
	
	local img_2 = GetImgByPath(ccp(img_bg:getContentSize().width/2-90,img_bg:getContentSize().height),img_path2)
	local img_3 = GetImgByPath(ccp(img_bg:getContentSize().width/2+65,img_bg:getContentSize().height),img_path3)
	
	img_bg:setOpacity(0)
	img_bg:addChild(img_1)
	img_bg:addChild(img_2)
	img_bg:addChild(img_3)
	img_bg:setPosition(ccp(750/2,640/2))
	if mLayer:getChildByTag(1000)~=nil then
		mLayer:getChildByTag(1000):removeFromParentAndCleanup(true)
	end
	mLayer:addChild(img_bg,1000,1000)
	local function ActionCallback()
		img_bg:removeFromParentAndCleanup(true)
	end
	img_bg:setScale(0.5)
	local baoji_array = CCArray:create()
	baoji_array:addObject(CCScaleTo:create(0.1,1.2))
	baoji_array:addObject(CCScaleTo:create(0.1,1.0))
	baoji_array:addObject(CCDelayTime:create(1))
	baoji_array:addObject(CCFadeOut:create(1))
	baoji_array:addObject(CCCallFunc:create(ActionCallback))
	local action = CCSequence:create(baoji_array)
	img_bg:runAction(action)
	baoji_array:removeAllObjects()
	baoji_array = nil 
end
local function RunActionUnlock(nGrid,mLayer)
	local nImgBack = ImageView:create()
	nImgBack:setSize(CCSizeMake(CommonData.g_nDeginSize_Width, CommonData.g_nDeginSize_Height))
	nImgBack:setPosition(ccp(CommonData.g_nDeginSize_Width/2, CommonData.g_nDeginSize_Height/2))
	local function _Click_CallBack(sender,eventType)
		if eventType == TouchEventType.ended then
			nImgBack:removeFromParentAndCleanup(true)
			nImgBack = nil
		end
	end
	nImgBack:loadTexture("Image/imgres/common/all_empty.png")
	nImgBack:setEnabled(true)
	nImgBack:setTouchEnabled(true)
	nImgBack:addTouchEventListener(_Click_CallBack)
	mLayer:addWidget(nImgBack)
	local function effect_04()
		CommonInterface.GetAnimationByName("Image/imgres/effectfile/StrengthenEquip_effect_01.ExportJson", 
			"StrengthenEquip_effect_01", 
			"qianghuajiesuo02", 
			nImgBack, 
			ccp(-220, 0),
			nil,
			10)
		local labelLock = Label:create()
		labelLock:setFontName(CommonData.g_FONT1)
		labelLock:setFontSize(26)
		labelLock:setColor(ccc3(38,17,11))
		labelLock:setPosition(ccp(-225,-83))
		labelLock:setText(EquipPropertyData.GetUnlockDesByGridLv(nGrid))
		nImgBack:addChild(labelLock,10000,10000)
		GetUnlockLvNow(nGrid)
	end
	CommonInterface.GetAnimationByName("Image/imgres/effectfile/StrengthenEquip_effect_01.ExportJson", 
		"StrengthenEquip_effect_01", 
		"qianghuajiesuo01", 
		nImgBack, 
		ccp(-220, 0),
		effect_04,
		10)

end
--装备强化升级特效
local function ShowEquipStrengthenEffect(nGrid,nLv,nOrgLv,mLayer)
	--冒字的特效
	RunActionArrTip(nOrgLv,nLv,nGrid)
	if CheckBaoJi(nOrgLv,nLv) == true then
		--显示暴击的特效
		RunBaojiEffect("Image/imgres/effect/word_luck.png","Image/imgres/effect/dot.png","Image/imgres/effect/word_bj.png",mLayer)
	end
	--升级的特效
	ShowUpLvEffect(mLayer,"Image/imgres/effect/word_up.png","Image/imgres/effect/word_ji.png",tonumber(nLv)-tonumber(nOrgLv),nil)
	
	if CheckBUnLock(nLv) == true then
		--显示解锁特效
		--print("去显示解锁特效")
		RunActionUnlock(nGrid,mLayer)
	end
	
end

function RunActionEquipStrengthen(nOrgLv,nGrid,nCurLv,mLayer)
	--[[print(nOrgLv,nGrid,nCurLv)
	print(GetCurLvByGird(nGrid))
	Pause()]]--
	if nCurLv == nil then
		EquipStrengthen.UpdateEquipStrengthen(nGrid,GetCurLvByGird(nGrid))
	else
		EquipStrengthen.UpdateEquipStrengthen(nGrid,nCurLv)
		
	end
	
	EquipCommon.Update(ENUM_TYPE_BOX.ENUM_TYPE_BOX_EQUIP,nGrid)
	
	if m_unlock_lv == nil  then
		GetUnlockLvNow(nGrid)
	end
	local function effect_02()
		m_bEffectOver = true
		CommonInterface.GetAnimationByName("Image/imgres/effectfile/StrengthenEquip_effect_01.ExportJson", 
			"StrengthenEquip_effect_01", 
			"qianghua02", 
			EquipOperateLayer.getImgIcon():getChildByTag(50), 
			ccp(0, 0),
			effect_03,
			10)
	end
	CommonInterface.GetAnimationByName("Image/imgres/effectfile/StrengthenEquip_effect_01.ExportJson", 
		"StrengthenEquip_effect_01", 
		"qianghua01", 
		EquipOperateLayer.getImgIcon():getChildByTag(50), 
		ccp(0, 0),
		effect_02,
		10)
	--显示特效
	if nCurLv == nil then
		ShowEquipStrengthenEffect(nGrid,GetCurLvByGird(nGrid),nOrgLv,mLayer)
	else
		ShowEquipStrengthenEffect(nGrid,nCurLv,nOrgLv,mLayer)
	end
end

function RunAutoStrengthenAction(objectAction,nGrid,tableLv,orgLv)
	if m_unlock_lv == nil  then
		GetUnlockLvNow(nGrid)
	end
	--[[if CheckBCanStrengthen(nGrid)== false then
		objectAction:stopAllActions()
		return 
	end]]--
	local nIndex = 1
	local orgLvNow = orgLv
	m_bEffectOver = true 
	local function settick()
		if m_bEffectOver == true then
			m_bEffectOver = false
			if tableLv[nIndex] ~= nil then	
				RunActionEquipStrengthen(orgLvNow,nGrid,tonumber(orgLvNow) + tonumber(tableLv[nIndex]),objectAction)
				orgLvNow = tonumber(orgLvNow) + tonumber(tableLv[nIndex])
				nIndex = nIndex + 1
				if (nIndex-1) == #tableLv then
					if CheckBCanStrengthen(nGrid)== false then
						m_bEffectOver = false
						objectAction:stopAllActions()
						return 
					end
				end
			else
				objectAction:stopAllActions()
			end
		end
		
	end

	local array_action = CCArray:create()
	array_action:addObject(CCCallFunc:create(settick))
	local action_item = CCRepeatForever:create(CCSequence:create(array_action))
	objectAction:runAction(action_item)
end
local function CheckBLingBao(nGrid)
	return CheckBCanStrengthen(nGrid)

end
local function RunLingBaoStrengthenAction(nGrid,orgLv,curLv)
	RunActionArrTip(orgLv,curLv,nGrid)
	ShowUpLvEffect(LingBaoStrengthen:GetLingBaoStrengthenUI(),"Image/imgres/effect/word_up.png","Image/imgres/effect/word_ji.png",tonumber(curLv)-tonumber(orgLv),nil)
end
function ToLingBaoStrengthen(nGrid,oldLv,fCallBack)
	if CheckBLingBao(nGrid) == false then
		return 
	end
	local function LingBaoOver()
		NetWorkLoadingLayer.loadingHideNow()
		RunLingBaoStrengthenAction(nGrid,oldLv,GetCurLvByGird(nGrid))
		if fCallBack~=nil then
			fCallBack()
		end
	end
	Packet_LingBaoStrengthen.SetSuccessCallBack(LingBaoOver)
	network.NetWorkEvent(Packet_LingBaoStrengthen.CreatPacket(nGrid))
	NetWorkLoadingLayer.loadingShow(true)
end
function CheckBAutoQH(pBtn)
	local tabVIP_AutoQH = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_7)
	if tonumber(tabVIP_AutoQH.vipLimit) == 0 then
		AddVIPImage(pBtn,tabVIP_AutoQH.vipLevel,ccp(-pBtn:getContentSize().width/2+20,pBtn:getContentSize().height/2-20))
	end
end