require "Script/Common/RichLabel"
require "Script/Common/ItemTipLayer"
module("ChargeVIPLayer",package.seeall)
require "Script/Main/ChargeVIP/ChargeVIPData"
require "Script/Main/ChargeVIP/ChargeVIPLogic"

local GetChargeInfo        	= ChargeVIPData.GetChargeInfo
local GetChargeInfoByIndex 	= ChargeVIPData.GetChargeInfoByIndex
local GetVIPAllData 		= ChargeVIPData.GetVIPAllData
local GetVIPDataByIndex 	= ChargeVIPData.GetVIPDataByIndex
local GetPathByID           = ChargeVIPData.GetPathByID
local GetReChargeData       = ChargeVIPData.GetReChargeData
local GetVIPRewardInfoByVIP = ChargeVIPData.GetVIPRewardInfoByVIP
local GetLabelText          = ChargeVIPData.GetLabelText
local cleanListView         = ChargeVIPLogic.cleanListView
local GetRewardStatus       = ChargeVIPData.GetRewardStatus
local ShowRewardLayer       = ChargeVIPLogic.ShowRewardLayer
local CreateItemTipLayer 	= ItemTipLayer.CreateItemTipLayer
local DeleteItemTipLayer	= ItemTipLayer.DeleteItemTipLayer
local GetRewardByServer     = ChargeVIPData.GetRewardByServer
local GetFirstChargeStatus  = ChargeVIPData.GetFirstChargeStatus

local nKeys = {
	nKey = "|",
}

--add by sxin 增加商品支付信息
--[[
local ProductList = {
					 {pProduct_Id = "1",pProduct_Price = "30",pProduct_Name = "300元宝",Product_Count = "1"},
					 {pProduct_Id = "2",pProduct_Price = "98",pProduct_Name = "980元宝",Product_Count = "1"},
					 {pProduct_Id = "3",pProduct_Price = "298",pProduct_Name = "2980元宝",Product_Count = "1"},
					 {pProduct_Id = "4",pProduct_Price = "698",pProduct_Name = "6980元宝",Product_Count = "1"},
					 {pProduct_Id = "5",pProduct_Price = "25",pProduct_Name = "凤卡",Product_Count = "1"},
					 {pProduct_Id = "6",pProduct_Price = "50",pProduct_Name = "龙卡",Product_Count = "1"},
					}	
]]	
local ProductList = {
					 {pProduct_Id = "1",pProduct_Price = "5",pProduct_Name = "50元宝",Product_Count = "1"},
					 {pProduct_Id = "2",pProduct_Price = "20",pProduct_Name = "200元宝",Product_Count = "1"},
					 {pProduct_Id = "3",pProduct_Price = "50",pProduct_Name = "500元宝",Product_Count = "1"},
					 {pProduct_Id = "4",pProduct_Price = "128",pProduct_Name = "1280元宝",Product_Count = "1"},
					 {pProduct_Id = "5",pProduct_Price = "3",pProduct_Name = "凤卡",Product_Count = "1"},
					 {pProduct_Id = "6",pProduct_Price = "6",pProduct_Name = "龙卡",Product_Count = "1"},
					}	
	
	

local SINGLROWITEMCOUNT = 2
local DAY_SECOND        = 86400
local IMGREWARDITEM = "Image/imgres/equip/icon/danyao/xian/DYao90.png"
local IMGCARDA = "Image/imgres/VIPCharge/goldCardbtom.png"
local IMGCARDB = "Image/imgres/VIPCharge/silverCardBtom.png"
local MARK_DISCOUNT = "Image/imgres/VIPCharge/mark1.png"
local MARK_HOT = "Image/imgres/VIPCharge/mark2.png"
local MARK_RECD = "Image/imgres/VIPCharge/mark3.png"
local MARK_RERA = "Image/imgres/VIPCharge/mark4.png"
local m_chargeVIPLayer  = nil
local m_listView 		= nil
local m_listViewItem 	= nil
local m_PanelTop 		= nil
local m_PanelTe 		= nil
local m_PanelCharge 	= nil
local label_VIPText     = nil
local label_leftText    = nil
local label_VIPlibao    = nil
local label_rightText   = nil
local pcur_Text         = nil
local pnext_Text        = nil
local progress_bar      = nil
local label_charge      = nil
local img_gold          = nil
local img_nextVip       = nil
local label_bar         = nil
local label_word        = nil
local nTypeScene        = nil
local img_barBottom     = nil
local btn_charge        = nil
local label_chargeNum   = nil
local img_curVIP        = nil
local img_visible       = nil
local label_mostVIP     = nil
local pre_VipLevel      = 0
local pre_vip           = 0
local up_VipLevel       = 0
local function InitData(  )
	m_chargeVIPLayer 	= nil
	m_listViewItem 		= nil
	m_listView 			= nil
	m_PanelCharge       = nil
	m_PanelTe           = nil
	img_curVIP          = nil
	m_PanelTop          = nil
	label_VIPText       = nil
	label_leftText      = nil
	label_rightText     = nil
	label_VIPlibao      = nil
	pcur_Text           = nil
	pnext_Text          = nil
	progress_bar        = nil
	label_charge        = nil
	img_gold            = nil
	img_nextVip         = nil
	label_bar           = nil
	nTypeScene          = nil
	label_word          = nil
	img_barBottom       = nil
	btn_charge          = nil
	label_chargeNum     = nil
	img_visible         = nil
	label_mostVIP       = nil
	up_VipLevel         = 0
	pre_VipLevel        = 0
	pre_vip             = 0
end
local function _Click_return_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		m_chargeVIPLayer:removeFromParentAndCleanup(true)
		m_chargeVIPLayer = nil

		if tonumber(nTypeScene) == 1 then
			local function GetSuccessCallback(  )
				MainScene.PopUILayer()
				local vip_level = server_mainDB.getMainData("vip")
				if (tonumber(vip_level) - tonumber(pre_vip)) > 0 then
					MainScene.SetVip(vip_level,2)
				end
				MainScene.JudgeVIPStatus(nil)
			end
			Packet_VIPRewardStatus.SetSuccessCallBack(GetSuccessCallback)
			network.NetWorkEvent(Packet_VIPRewardStatus.CreatePacket())
			
		elseif tonumber(nTypeScene) == 2 then
			-- CorpsScene.CorpsPopLayer()
			CorpsScene.ReturnPresentLayer()
		elseif tonumber(nTypeScene) == 3 then
			CorpsScene.ReturnHallLayer()
		end
	end
end

local function CloneItemWidget( pListView )
	local pListViewItem = pListView:clone()
	local peer = tolua.getpeer(pListView)
	tolua.setpeer(pListViewItem,peer)
	return pListViewItem
end

local function loadListViewItem(  )
	local list_infoWidget = GUIReader:shareReader():widgetFromJsonFile("")
	m_listViewItem = CloneItemWidget(list_infoWidget)
	m_listView:pushBackCustomItem(m_listViewItem)
	m_listView:jumpToTop()
end

local function loadTopPanel(  )
	img_curVIP = tolua.cast(m_PanelTop:getChildByName("Image_cueVip"),"ImageView")
	img_nextVip = tolua.cast(m_PanelTop:getChildByName("Image_nextVip"),"ImageView")
	img_gold = tolua.cast(m_PanelTop:getChildByName("Image_gold"),"ImageView")
	label_charge = tolua.cast(m_PanelTop:getChildByName("Label_chargeword"),"Label")
	img_barBottom = tolua.cast(m_PanelTop:getChildByName("Image_43"),"ImageView")
	label_word = tolua.cast(m_PanelTop:getChildByName("Label_word"),"Label")
	img_visible = tolua.cast(m_PanelTop:getChildByName("Image_36"),"ImageView")
	label_mostVIP = tolua.cast(m_PanelTop:getChildByName("Label_rich"),"Label")
	label_mostVIP:setVisible(false)
	label_mostVIP:removeAllChildrenWithCleanup(true)
	-- img_visible:setVisible(false)
	local strVIPMost = "|color|53,25,13||size|22|".."已达到最高VIP等级，获得所有权限"
	local l_mostVIPtext = RichLabel.Create(strVIPMost,450,1,nil,1)
	l_mostVIPtext:setPosition(ccp(-120,8))	
	label_mostVIP:addChild(l_mostVIPtext)

	local label_yuanword = LabelBMFont:create()
	label_yuanword:setFntFile("Image/imgres/common/num/charge_money.fnt")
	label_yuanword:setText("0")
	label_yuanword:setPosition(ccp(10,0))
	AddLabelImg(label_yuanword,10,img_gold)
	img_gold:setOpacity(0)
	img_gold:setScale(1)

	label_chargeNum = LabelBMFont:create()
	label_chargeNum:setFntFile("Image/imgres/common/num/charge_vip.fnt")
	
	label_chargeNum:setPosition(ccp(55,0))
	AddLabelImg(label_chargeNum,10,label_charge)
	
	local cur_vip = nil
	cur_vip = server_mainDB.getMainData("vip")
	pcur_Text  = nil
	pcur_Text = LabelBMFont:create()
	pcur_Text:setFntFile("Image/imgres/common/num/vipNum.fnt")
	pcur_Text:setPosition(ccp(45,1))
	pcur_Text:setText(cur_vip) 
	img_curVIP:addChild(pcur_Text,0,10)

	local next_vip = cur_vip + 1
	pnext_Text = LabelBMFont:create()
	pnext_Text:setFntFile("Image/imgres/common/num/vipNum.fnt")
	pnext_Text:setPosition(ccp(45,1))
	pnext_Text:setAnchorPoint(ccp(0.5,0.5))
	pnext_Text:setText(next_vip)
	img_nextVip:addChild(pnext_Text,0,1000)

	local cur_vipexp = server_mainDB.getMainData("VIPExp")--当前VIP经验值
	local dq_VIPExp = 0
	if tonumber(cur_vip) > 0 then
		for i=tonumber(cur_vip),1,-1 do
			local dq_VIPExpDB = GetVIPDataByIndex(i)
			dq_VIPExp = tonumber(dq_VIPExpDB["VipExp"]) + dq_VIPExp
		end
		
	end
	curD_value = tonumber(cur_vipexp) - tonumber(dq_VIPExp)
	if curD_value <= 0 then
		curD_value = 0
	end
	local cur_bar = 0
	local nextVIPExp = nil
	if cur_vip > 12 then
		
		img_nextVip:setVisible(false)
		label_charge:setVisible(false)
		img_gold:setVisible(false)
		label_word:setVisible(false)
		label_mostVIP:setVisible(true)
		local cur_VipTab = GetVIPDataByIndex(cur_vip)
		local VipTab = {}
		nextVIPExp = cur_VipTab["VipExp"]
		cur_bar = 1
	else
		local VipTab = {}
		VipTab = GetVIPDataByIndex(next_vip)
		nextVIPExp = VipTab["VipExp"]
		local d_valueExp = nextVIPExp - curD_value
		local n_money = tonumber(d_valueExp)/10
		label_charge:setText("再充值")
		label_chargeNum:setText(n_money)
		cur_bar = tonumber(curD_value)/tonumber(nextVIPExp)

	end
	
	local to1 = CCProgressTo:create(0.0001, cur_bar*100)
	progress_bar = CCProgressTimer:create(CCSprite:create("Image/imgres/dungeon/bar_green.png"))
	progress_bar:setType(kCCProgressTimerTypeBar)
	progress_bar:setMidpoint(CCPointMake(0, 0))
	progress_bar:setBarChangeRate(CCPointMake(1, 0))
	progress_bar:setPosition(ccp(0, 0))
	img_barBottom:addNode(progress_bar)
	progress_bar:runAction(to1)

	label_bar = Label:create()
	label_bar:setPosition(ccp(0,1))
	label_bar:setFontSize(18)
	label_bar:setName("LabelNum")
	label_bar:setAnchorPoint(ccp(0.5, 0.5))
	img_barBottom:addChild(label_bar)
	
	if nextVIPExp == nil then
		if tonumber(cur_vip) > 12 then
			label_bar:setText(nextVIPExp.."/"..nextVIPExp)
		else
			label_bar:setText(curD_value.."/"..curD_value)
		end
	else
		if tonumber(cur_vip) > 12 then
			label_bar:setText(nextVIPExp.."/"..nextVIPExp)
		else
			label_bar:setText(curD_value.."/"..nextVIPExp)
		end
	end
	

end

local function UpdateCurVIPLevel(  )
	local cur_vip = tonumber(server_mainDB.getMainData("vip"))
	local next_vip = cur_vip + 1

	local TestText = btn_charge:getChildByTag(TAG_LABEL_BUTTON)
	LabelLayer.setText(TestText,"领取")
	local cur_bar = 0

	---经验值变化时的动画回调函数
	--得到 vip差值
	local nextVIPExp = nil
	local d_valueLevel = tonumber(cur_vip) - tonumber(pre_VipLevel)
	local function actionCallBack(  )
		--获取数值
		pnext_Text:setText("")
		pcur_Text:setText("")
		pcur_Text:setText(pre_VipLevel)
		pnext_Text:setText(tonumber(pre_VipLevel)+1)
		local per_exp = GetVIPDataByIndex(pre_VipLevel)
		if cur_vip > 12 then
				
			img_nextVip:setVisible(false)
			label_charge:setVisible(false)
			img_gold:setVisible(false)
			label_word:setVisible(false)
			label_mostVIP:setVisible(true)
			label_mostVIP:removeAllChildrenWithCleanup(true)
			local strVIPMost = "|color|53,25,13||size|22|".."已达到最高VIP等级，获得所有权限"
			local l_mostVIPtext = RichLabel.Create(strVIPMost,450,1,nil,1)
			l_mostVIPtext:setPosition(ccp(-120,8))	
			label_mostVIP:addChild(l_mostVIPtext)

			label_bar:setText(per_exp["VipExp"].."/"..per_exp["VipExp"])
			cur_bar = 1
		else
			local cur_vipexp = server_mainDB.getMainData("VIPExp")--当前VIP经验值
			local VipTab = GetVIPDataByIndex(tonumber(pre_VipLevel)+1)
			local dq_VIPExp = 0
			if tonumber(pre_VipLevel) > 0 then
				for i=tonumber(pre_VipLevel),1,-1 do
					local dq_VIPExpDB = GetVIPDataByIndex(i)
					dq_VIPExp = tonumber(dq_VIPExpDB["VipExp"]) + dq_VIPExp
				end
				
			end
			curD_value = tonumber(cur_vipexp) - tonumber(dq_VIPExp)
			if curD_value <= 0 then
				curD_value = 0
			end
			nextVIPExp = VipTab["VipExp"]
			local d_valueExp = nil
			if tonumber(curD_value) <= tonumber(nextVIPExp) then
				d_valueExp = tonumber(nextVIPExp) - tonumber(curD_value)
			else
				d_valueExp = tonumber(nextVIPExp) - tonumber(per_exp["VipExp"])
			end
			local n_money = tonumber(d_valueExp)/10
			label_bar:setText(curD_value.."/"..nextVIPExp)
			-- label_charge:setText("再充值"..d_valueExp)
			label_chargeNum:setText(n_money)
			if tonumber(curD_value) < tonumber(nextVIPExp) then
				cur_bar = tonumber(curD_value)/tonumber(nextVIPExp)
			else
				cur_bar = tonumber(curD_value)/tonumber(nextVIPExp)
			end
		end
		if cur_bar >= 1 then
			cur_bar = 1
		end
		local actionArray1 = CCArray:create()
		local function _CallBack_(  )
			--vip升级时的特效
			
			--在动画播放完毕后走这个方法
			local function _ClickTouchBack(  )
				local function _VIP_UpGrade_CallBack(  )
					if img_curVIP:getChildByTag(100) ~= nil then
						img_curVIP:getChildByTag(100):removeFromParentAndCleanup(true)
					end

					progress_bar:stopAllActions()
					pre_VipLevel = pre_VipLevel + 1 
					if pre_VipLevel > cur_vip then
						pre_VipLevel = cur_vip
					elseif pre_VipLevel <= cur_vip then
						local to3 = CCProgressTo:create(0.001, 0)
						progress_bar:runAction(to3)
						actionCallBack()
					end
				end
				if img_visible:getChildByTag(100) ~= nil then
					img_visible:getChildByTag(100):removeFromParentAndCleanup(true)
				end
				if btn_charge:getChildByTag(100) == nil then
					-- btn_charge:getChildByTag(100):removeFromParentAndCleanup(true)
					ChargeVIPLogic.GetAnimationByName("Image/imgres/effectfile/VIP_anniu/VIP_anniu.ExportJson", 
						"VIP_anniu", 
						"Animation1", 
						btn_charge, 
						ccp(0, 0),
						nil,
						100)
				end
				
				
				ChargeVIPLogic.GetAnimationByName("Image/imgres/effectfile/VIP_anniu/VIP_anniu.ExportJson", 
						"VIP_anniu", 
						"Animation3", 
						img_curVIP, 
						ccp(0, 0),
						_VIP_UpGrade_CallBack,
						100)

				local actionVIP1 = CCArray:create()
				actionVIP1:addObject(CCScaleTo:create(0.1, 1.2))
				actionVIP1:addObject(CCDelayTime:create(0.05))
				actionVIP1:addObject(CCScaleTo:create(0.1, 1))
				img_curVIP:runAction(CCSequence:create(actionVIP1))
				
			end
			if pre_VipLevel < cur_vip then
				ChargeVIPLogic.GetAnimationByName("Image/imgres/effectfile/VIP_anniu/VIP_anniu.ExportJson", 
					"VIP_anniu", 
					"Animation2", 
					img_visible, 
					ccp(-250, 0),
					_ClickTouchBack,
					100)
			end
		end
		if pre_VipLevel == cur_vip then
			local per_exp = GetVIPDataByIndex(pre_VipLevel)
			if nextVIPExp == nil then
				nextVIPExp = per_exp["VipExp"]
			end
			if tonumber(curD_value) ~= 0 then
				local to2 = CCProgressTo:create(0.5, (tonumber(curD_value)/tonumber(nextVIPExp))*100) --1
				actionArray1:addObject(to2)
				actionArray1:addObject(CCCallFunc:create(_CallBack_))
			else
				local to2 = CCProgressTo:create(0, (tonumber(curD_value)/tonumber(nextVIPExp))*100)
				actionArray1:addObject(to2)
				actionArray1:addObject(CCCallFunc:create(_CallBack_))
			end
			
		else
			local t1 = (1-cur_bar)*2+1
			local to1 = CCProgressTo:create(0.5, 100) --t1
			actionArray1:addObject(to1)
			actionArray1:addObject(CCCallFunc:create(_CallBack_))
		end
		progress_bar:stopAllActions()
		progress_bar:runAction(CCSequence:create(actionArray1))
			
	end
		
	if d_valueLevel >= 1 then
		actionCallBack()
	else
		local cur_vipexp = server_mainDB.getMainData("VIPExp")--当前VIP经验值
		local VipsTab = GetVIPDataByIndex(tonumber(pre_VipLevel)+1)
		
		local dq_VIPExp = 0
		if tonumber(pre_VipLevel) > 0 then
			for i=tonumber(pre_VipLevel),1,-1 do
				local dq_VIPExpDB = GetVIPDataByIndex(i)
				dq_VIPExp = tonumber(dq_VIPExpDB["VipExp"]) + dq_VIPExp
			end
			
		end

		curD_value = tonumber(cur_vipexp) - tonumber(dq_VIPExp)
				
		nextsVIPExp = VipsTab["VipExp"]
		if tonumber(pre_VipLevel) < 13 then
			local d_valueExp = tonumber(nextsVIPExp) - tonumber(curD_value)
			local n_money = tonumber(d_valueExp)/10
			label_bar:setText(curD_value.."/"..nextsVIPExp)
			-- label_charge:setText("再充值"..d_valueExp)
			label_chargeNum:setText(n_money)
			cur_bar = tonumber(curD_value)/tonumber(nextsVIPExp)
			t4 = (1 - cur_bar)*2 
			local to4 = CCProgressTo:create(0.5, cur_bar*100) --t4
			progress_bar:runAction(to4)
		else
			local d_valueExp = tonumber(nextsVIPExp) - tonumber(nextsVIPExp)
			local n_money = tonumber(d_valueExp)/10
			label_bar:setText(nextsVIPExp.."/"..nextsVIPExp)
			label_chargeNum:setText(n_money)
			cur_bar = tonumber(nextsVIPExp)/tonumber(nextsVIPExp)
			t5 = (1 - cur_bar)*2 
			local to5 = CCProgressTo:create(0.5, cur_bar*100) --t5
			progress_bar:runAction(to5)
		end
	end
end

local function InitItemInfo( pControl,tabItem,n_vipStatus )

	local img_btom = tolua.cast(pControl:getChildByName("Image_bottom"),"ImageView")
	local img_coin = tolua.cast(img_btom:getChildByName("Image_item"),"ImageView")
	local img_lv = tolua.cast(pControl:getChildByName("Image_3"),"ImageView")
	local img_path = GetPathByID(tabItem["ResImg"])
	img_coin:loadTexture(img_path)

	local label_gold = tolua.cast(pControl:getChildByName("Label_gold"),"Label")
	local label_addgold = tolua.cast(pControl:getChildByName("Label_add"),"Label")
	local label_money = tolua.cast(pControl:getChildByName("Label_money"),"Label")
	local label_describe = tolua.cast(pControl:getChildByName("Label_describe"),"Label")
	local label_goldWord = tolua.cast(pControl:getChildByName("Label_word"),"Label")
	local img_mark = tolua.cast(pControl:getChildByName("Image_mark"),"ImageView")
	local label_time = tolua.cast(pControl:getChildByName("Label_time"),"Label")
	local label_tWord1 = tolua.cast(pControl:getChildByName("Label_39"),"Label")
	local label_tWord2 = tolua.cast(pControl:getChildByName("Label_41"),"Label")
	local label_yuan = tolua.cast(pControl:getChildByName("Label_yuan"),"Label")
	local img_type = tolua.cast(pControl:getChildByName("Image_type"),"ImageView")
	local label_first = tolua.cast(pControl:getChildByName("Label_first"),"Label")
	label_first:setVisible(false)
	label_tWord1:setVisible(false)
	label_tWord2:setVisible(false)
	label_addgold:setVisible(true)

	local label_mark = Label:create()
	label_mark:setFontSize(18)
	label_mark:setRotation(-45)
	label_mark:setPosition(ccp(-12,14))
	if tonumber(tabItem["Tag"]) == 0 then
		img_mark:setVisible(false)
	elseif tonumber(tabItem["Tag"]) == 1 then
		img_mark:loadTexture(MARK_HOT)
	elseif tonumber(tabItem["Tag"]) == 2 then
		img_mark:loadTexture(MARK_DISCOUNT)
	elseif tonumber(tabItem["Tag"]) == 3 then
		img_mark:loadTexture(MARK_RECD)
	elseif tonumber(tabItem["Tag"]) == 4 then
		img_mark:loadTexture(MARK_RERA)
	end
	img_mark:addChild(label_mark)

	local str_num = string.find(tabItem["Name"],nKeys.nKey,1)
	local lengths = string.len(tabItem["Name"])
	local str_word = nil
	local str_word2 = nil
	if str_num ~= nil then
		str_word = string.sub(tabItem["Name"],1,str_num-1)
		str_word2 = string.sub(tabItem["Name"],str_num+1,lengths)
	else
		str_word2 = tabItem["Name"]
		label_goldWord:setPosition(ccp(-30,48))
	end
	

	local l_VIPNum = LabelBMFont:create()
	l_VIPNum:setFntFile("Image/imgres/common/num/charge_vip.fnt")
	l_VIPNum:setPosition(ccp(0,1))
	l_VIPNum:setText(str_word)
	label_gold:addChild(l_VIPNum)
	local label_yuanword = LabelBMFont:create()
	label_yuanword:setFntFile("Image/imgres/common/num/charge_money.fnt")
	label_yuanword:setText("0")
	label_yuanword:setPosition(ccp(0,0))
	AddLabelImg(label_yuanword,1000,label_yuan)

	local l_VIPNumM = LabelBMFont:create()
	l_VIPNumM:setFntFile("Image/imgres/common/num/charge_vip.fnt")
	l_VIPNumM:setPosition(ccp(0,1))
	l_VIPNumM:setText(tabItem["Price"])
	label_money:addChild(l_VIPNumM)

	local str_text  = ""
	if tonumber(tabItem["Type"]) == 1 or tonumber(tabItem["Type"]) == 2 then
		str_text = "购买赠送 "..tabItem["AddGold"]
	else
		str_text = "额外赠送 "..tabItem["AddGold"]
	end
	local label_addText = nil
	if tonumber(n_vipStatus) == 0 then -- n_vipStatus 1 代表未购买 0代表已经购买首冲
		label_addText = LabelLayer.createStrokeLabel(18, CommonData.g_FONT3, str_text, ccp(-17, 0), ccc3(0,0,0), ccc3(0,255,79), true, ccp(0, -2), 2)		
	else
		label_addText = LabelLayer.createStrokeLabel(18, CommonData.g_FONT3, "首冲奖励 "..tabItem["FristCharge"], ccp(-17, 0), ccc3(0,0,0), ccc3(254,251,10), true, ccp(0, -2), 2)		
	end
	label_describe:setText(string.format(tabItem["Text"],tabItem["Gold"]) )
	
	if tonumber(tabItem["AddGold"]) ~= 0 then
		label_addgold:addChild(label_addText)
		
	end
	local monthA = server_mainDB.getMainData("MonthCardA")  
	local monthB = server_mainDB.getMainData("MonthCardB")

	local timeA = math.ceil(monthA/DAY_SECOND)
	local timeB = math.ceil(monthB/DAY_SECOND)

	print(monthA,monthB,timeA,timeB)
	

	if tonumber(tabItem["Type"]) == 1 then
		img_type:setOpacity(255)
		label_gold:setPosition(ccp(label_gold:getPositionX()-10,label_gold:getPositionY()))
		label_goldWord:setPosition(ccp(label_goldWord:getPositionX()+20,label_goldWord:getPositionY()))
		
		img_type:loadTexture(IMGCARDA)
		img_lv:setVisible(false)
		img_mark:setPosition(ccp(-155,40))
		if tonumber(monthA) ~= 0 then
			label_addgold:setVisible(false)
			label_tWord1:setVisible(true)
			label_tWord2:setVisible(true)
			label_describe:setText("")
			label_time:setText(timeA)
			label_describe:setText(string.format(tabItem["AfterText"],tonumber(timeA)) )
		end

		local img_long = ImageView:create()
		img_long:loadTexture("Image/imgres/VIPCharge/long.png")
		img_long:setPosition(ccp(0,0))
		AddLabelImg(img_long,1000,label_goldWord)
	elseif tonumber(tabItem["Type"]) == 2 then
		img_type:setOpacity(255)
		label_gold:setPosition(ccp(label_gold:getPositionX()-10,label_gold:getPositionY()))
		label_goldWord:setPosition(ccp(label_goldWord:getPositionX()+20,label_goldWord:getPositionY()))
		img_type:loadTexture(IMGCARDB)
		img_lv:setVisible(false)
		img_mark:setPosition(ccp(-155,40))
		if tonumber(monthB) ~= 0 then
			label_addgold:setVisible(false)
			label_tWord1:setVisible(true)
			label_tWord2:setVisible(true)
			label_time:setText(timeB)
			label_describe:setText("")
			label_describe:setText(string.format(tabItem["AfterText"],tonumber(timeB)) )
		end
		local img_feng = ImageView:create()
		img_feng:loadTexture("Image/imgres/VIPCharge/feng.png")
		img_feng:setPosition(ccp(0,0))
		AddLabelImg(img_feng,1000,label_goldWord)
	else
		label_goldWord:setPosition(ccp(label_goldWord:getPositionX()+10,label_goldWord:getPositionY()))
		label_addgold:setPosition(ccp(label_addgold:getPositionX()+10,label_addgold:getPositionY()))
		local label_goldWordText = LabelBMFont:create()
		label_goldWordText:setFntFile("Image/imgres/common/num/charge_money.fnt")
		label_goldWordText:setText("0123")
		label_goldWordText:setPosition(ccp(25,0))
		AddLabelImg(label_goldWordText,1000,label_goldWord)
	end
end

--add by sxin 修改支付

local function AngSDKPay( iPayIndex )
	
	local function GetSuccessCallBack()
			
			cleanListView(m_listView)						
			TipLayer.createTimeLayer("购买成功",2)
			UpdateCurVIPLevel()
			UpdateListItem()
	end
	Packet_RechargeVIP.SetSuccessCallBack(GetSuccessCallBack)
	
	local pProduct_Price = ProductList[iPayIndex].pProduct_Price
	local pProduct_Id = ProductList[iPayIndex].pProduct_Id
	local pProduct_Name = ProductList[iPayIndex].pProduct_Name
	local pServer_Id = CommonData.g_nCurServerMapID
	local Product_Count = ProductList[iPayIndex].Product_Count
	
	local pRole_Id = CommonData.g_nGlobalID
	local pRole_Name = server_mainDB.getMainData("name")
	local pRole_Grade = server_mainDB.getMainData("level")
	local pRole_Balance = "0"
	AnySDKpay(pProduct_Price,pProduct_Id,pProduct_Name,pServer_Id,Product_Count,pRole_Id,pRole_Name,pRole_Grade,pRole_Balance)
		
end

local function TestPay( iPayIndex )
	
		local function GetSuccessCallBack()
			NetWorkLoadingLayer.loadingHideNow()
			cleanListView(m_listView)
						
			TipLayer.createTimeLayer("购买成功",2)
			UpdateCurVIPLevel()
			UpdateListItem()
		end
		Packet_RechargeVIP.SetSuccessCallBack(GetSuccessCallBack)
		network.NetWorkEvent(Packet_RechargeVIP.CreatePacket(iPayIndex))
		NetWorkLoadingLayer.loadingShow(true)
end

local function _Click_Recharge_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		local ptag = sender:getTag()
		AudioUtil.PlayBtnClick()
		if CommonData.IsAnySDK() == false then
			TestPay(ptag)
		else
			AngSDKPay(ptag)
		end
	end
end

function UpdateListItem(  )
	-------------------------------------------------------------------------
	local tabVIPStatus = GetFirstChargeStatus()

	local function InitItemControl( pControl,tabItem ,tag,nVipSt)
		
		pControl:setTouchEnabled(true)
		pControl:setTag(tag)
		pControl:addTouchEventListener(_Click_Recharge_CallBack)
		InitItemInfo(pControl,tabItem,nVipSt)
	end
	--数据------------------------------------------------------------------------
	local tab = {}
	tab = GetReChargeData()
	local list_infoWidget = GUIReader:shareReader():widgetFromJsonFile("Image/VIPChargeItem.json")
	for i=1,#tab do
		if i%SINGLROWITEMCOUNT == 0 then
			m_listViewItem = CloneItemWidget(list_infoWidget)
			local pControl_1 = tolua.cast(m_listViewItem:getChildByName("Image_item1"),"ImageView")
			InitItemControl(pControl_1,tab[i-1],i-1,tabVIPStatus[i-1])
			local pControl_2 = tolua.cast(m_listViewItem:getChildByName("Image_item1_0"),"ImageView")
			InitItemControl(pControl_2,tab[i],i,tabVIPStatus[i])
			-- m_listView:setItemsMargin(4)
			m_listView:pushBackCustomItem(m_listViewItem)
		elseif (i%SINGLROWITEMCOUNT ~= 0) and (i == (#tab)) then
			local m_listViewItem = CloneItemWidget(list_infoWidget) 
			local pControl_1 = tolua.cast(m_listViewItem:getChildByName("Image_item1"),"ImageView")
			InitItemControl(pControl_1,tab[i],i,tabVIPStatus[i])

			local pControl_2 = tolua.cast(m_listViewItem:getChildByName("Image_item1_0"),"ImageView")
			if pControl_2 ~= nil then
				pControl_2:setVisible(false)
				pControl_2:setEnabled(false)
			end
			-- m_listView:setItemsMargin(4)
			m_listView:pushBackCustomItem(m_listViewItem)
		end
	end
end

local function UpdatePanelTeData( num )
	label_leftText:setText("")
	label_rightText:setText("")
	label_VIPText:setText("")
	label_VIPlibao:setText("")
	local cur_VipTab = GetVIPDataByIndex(num)
	local leftVip = num - 1
	local rightVip = num + 1
	label_VIPText:setText(num)
	label_VIPlibao:setText("VIP"..num.."等级特权")
	label_leftText:setText(leftVip)
	label_rightText:setText(rightVip)
end

local function _Click_TipsItem_CallBack( sender,eventType )
	local p_tag = sender:getTag()
	
	if eventType == TouchEventType.ended then
		DeleteItemTipLayer()
	elseif eventType == TouchEventType.began then
		CreateItemTipLayer(m_chargeVIPLayer, sender, TipType.Item, sender:getTag(), TipPosType.RightTop)
		
	elseif eventType == TouchEventType.canceled then
		DeleteItemTipLayer()
	end
end

local function _Click_TipsCoin_CallBack( sender,eventType )
	local p_tag = sender:getTag()
	if eventType == TouchEventType.ended then
		DeleteItemTipLayer()
	elseif eventType == TouchEventType.began then
		CreateItemTipLayer(m_chargeVIPLayer, sender, 10, sender:getTag(), TipPosType.RightTop)
	elseif eventType == TouchEventType.canceled then
		DeleteItemTipLayer()
	end
end

function loadTePanel( num )
	if num <= 0 then
		num = 1
	end
	m_PanelTe  = tolua.cast(m_chargeVIPLayer:getWidgetByName("Panel_special"),"Layout")
	img_title = tolua.cast(m_PanelTe:getChildByName("Image_title"),"ImageView")
	scrollView_word = tolua.cast(m_PanelTe:getChildByName("ScrollView_word"),"ScrollView")
	label_left = tolua.cast(m_PanelTe:getChildByName("Label_left"),"Label")
	label_right = tolua.cast(m_PanelTe:getChildByName("Label_right"),"Label")
	btn_left = tolua.cast(m_PanelTe:getChildByName("Button_left"),"Button")
	btn_right = tolua.cast(m_PanelTe:getChildByName("Button_right"),"Button")
	img_word = tolua.cast(m_PanelTe:getChildByName("Image_38"),"ImageView")
	img_libao = tolua.cast(m_PanelTe:getChildByName("Image_37"),"ImageView")
	local VIPGrade = tolua.cast(img_title:getChildByName("Image_vipGrade"),"ImageView")
	local img_left = tolua.cast(btn_left:getChildByName("Image_left"),"ImageView")
	local img_right = tolua.cast(btn_right:getChildByName("Image_right"),"ImageView")
	local img_rewardBotom = tolua.cast(m_PanelTe:getChildByName("Image_bottom"),"ImageView")
	local listView_Item = tolua.cast(img_rewardBotom:getChildByName("ListView_item"),"ListView")
	m_PanelTe:setZOrder(5)
	m_PanelTe:setVisible(true)
	m_PanelTe:setTouchEnabled(true)
	img_libao:setOpacity(0)
	if scrollView_word ~= nil then
		scrollView_word:setClippingType(1)
	end
	if listView_Item ~= nil then
		listView_Item:setClippingType(1)
	end
	scrollView_word:jumpToTop()
	cleanListView(listView_Item)
	scrollView_word:removeAllChildrenWithCleanup(true)
	img_word:removeAllChildrenWithCleanup(true)
	img_libao:removeAllChildrenWithCleanup(true)
	img_left:removeAllChildrenWithCleanup(true)
	img_right:removeAllChildrenWithCleanup(true)
	VIPGrade:removeAllChildrenWithCleanup(true)
	-- local tab = GetVIPAllData()

	local cur_VipTab = GetVIPDataByIndex(num)
	
	local tabGrid_reward = {}
	if tonumber(cur_VipTab["VipRew"]) > 0 then
		tabGrid_reward = RewardLogic.GetRewardTable(cur_VipTab["VipRew"])
		
	end
	local tab_rewardDB = {}
	if #tabGrid_reward ~= 0 then
		if #tabGrid_reward[1] ~= 0 then
			for key,value in pairs(tabGrid_reward[1]) do
				table.insert(tab_rewardDB,value)
			end
		end
		if #tabGrid_reward[2] ~= 0 then
			for key,value in pairs(tabGrid_reward[2]) do
				table.insert(tab_rewardDB,value)
			end
		end
	end
	if #tab_rewardDB ~= 0 then
		for key,value in pairs(tab_rewardDB) do
			local img_reward = ImageView:create()
			img_reward:setScale(0.8)
			
			if value["ItemID"] == nil then
				local pControls = UIInterface.MakeHeadIcon(img_reward,ICONTYPE.COIN_ICON,value["CoinID"],nil,nil,nil,nil,nil)
				pControls:setTag(value["CoinID"])
				pControls:setTouchEnabled(true)
				
				pControls:addTouchEventListener(_Click_TipsCoin_CallBack)
			else
				local pControls = UIInterface.MakeHeadIcon(img_reward,ICONTYPE.ITEM_ICON,value["ItemID"],nil,nil,nil,nil,nil)
				pControls:setTag(value["ItemID"])
				pControls:setTouchEnabled(true)
			
				pControls:addTouchEventListener(_Click_TipsItem_CallBack)
			end
			listView_Item:pushBackCustomItem(img_reward)
			listView_Item:jumpToLeft()
			
		end
	end
	local s_size = scrollView_word:getContentSize()
	---测试富文本图片
	local vipTest1 = "|img|Image/imgres/chat/Simlface.png|".."|color|42,23,18||size|22|".."测试测试测试测试测试测试测试".."|n|1|".."|img|Image/imgres/chat/cutLine.png|".."|n|1||n|1|".."|color|250,0,0||size|22|".."测试测试测试测试测试".."|n|1|".."|img|Image/imgres/chat/cutLine.png|"
	
	local vipExplain = "|color|42,23,18||size|22|"..cur_VipTab["VipText"]
	local VIPContentItem = RichLabel.Create(vipExplain,500,1,nil,1)
	scrollView_word:setInnerContainerSize(CCSizeMake(scrollView_word:getInnerContainerSize().width,VIPContentItem:getContentSize().height))
	
	local PosY = 0
	if tonumber(VIPContentItem:getContentSize().height) > 300 and tonumber(VIPContentItem:getContentSize().height) < 320 then
		PosY = s_size.height/2+185
	elseif tonumber(VIPContentItem:getContentSize().height) > 320 then
		PosY = s_size.height/2+215
	else
		PosY = s_size.height/2+150
	end
	VIPContentItem:setPosition(ccp(s_size.width/2-210,PosY))		--150
	
	scrollView_word:addChild(VIPContentItem)
	-- local label_VIPText = cur_vip + 1
	label_VIPText = LabelBMFont:create()
	label_VIPText:setFntFile("Image/imgres/common/num/vipNum.fnt")
	label_VIPText:setPosition(ccp(45,1))
	label_VIPText:setAnchorPoint(ccp(0.5,0.5))
	label_VIPText:setText("")
	label_VIPText:setText(num)
	VIPGrade:addChild(label_VIPText,0,1000)


	label_VIPlibao = Label:create()
	label_VIPlibao:setFontSize(18)
	label_VIPlibao:setColor(ccc3(42,23,18))
	label_VIPlibao:setText("")
	label_VIPlibao:setText("VIP"..num.."等级特权")
	img_word:addChild(label_VIPlibao)
	local leftVip = num - 1
	local rightVip = num + 1
	
	label_leftText = LabelBMFont:create()
	label_leftText:setFntFile("Image/imgres/common/num/vipNum.fnt")
	label_leftText:setPosition(ccp(45,1))
	label_leftText:setAnchorPoint(ccp(0.5,0.5))
	label_leftText:setText("")
	label_leftText:setText(leftVip)
	img_left:addChild(label_leftText,0,1000)

	label_rightText = LabelBMFont:create()
	label_rightText:setFntFile("Image/imgres/common/num/vipNum.fnt")
	label_rightText:setPosition(ccp(45,1))
	label_rightText:setAnchorPoint(ccp(0.5,0.5))
	label_rightText:setText("")
	label_rightText:setText(rightVip)
	img_right:addChild(label_rightText,0,1000)

	
	--奖励列表

	local tabGiftBag = {}
	local tabMoneyBag  ={}
	local tabItemBag = {}
	local tabItemIndex = {}
	local tabCoinIndex = {}
	local tabItemS = {}
	local tabCoinS = {}
	
	if num ~= 0 then
		tabGiftBag = GetVIPRewardInfoByVIP(num)
		tabMoneyBag = tabGiftBag[1]
		tabItemBag = tabGiftBag[2]
		tabItemIndex = ChargeVIPData.GetVIPItemIndex(num)
		tabCoinIndex = ChargeVIPData.GetVIPCoinIndex(num)
		if #tabMoneyBag ~= 0 and #tabItemBag == 0 then
			for key,value in pairs(tabMoneyBag) do
				local tabChild = {}
				tabChild[1] = value["CoinID"]
				tabChild[2] = value["CoinNum"]
				table.insert(tabCoinS,tabChild)
			end
		elseif #tabMoneyBag ~= 0 and #tabItemBag ~= 0 then
			for key,value in pairs(tabMoneyBag) do
				local tabChild = {}
				tabChild[1] = value["CoinID"]
				tabChild[2] = value["CoinNum"]
				table.insert(tabCoinS,tabChild)
			end
			for key,value in pairs(tabItemBag) do
				local tabChild = {}
				tabChild[1] = value["ItemID"]
				tabChild[2] = value["ItemNum"]
				table.insert(tabItemS,tabChild)
			end
		elseif #tabMoneyBag == 0 and #tabItemBag ~= 0 then
			
			for key,value in pairs(tabItemBag) do
				local tabChild = {}
				tabChild[1] = value["ItemID"]
				tabChild[2] = value["ItemNum"]
				table.insert(tabItemS,tabChild)
			end
		end
	else
		img_rewardBotom:setVisible(false)
	end
	local VIPStatus = GetRewardStatus(num) -- 0 表示已经领取过 ，1 表示还没领取，2表示没资格领取
	local function _Click_gainReward_CallBack( sender,eventType )
		AudioUtil.PlayBtnClick()
		if eventType == TouchEventType.ended then
			sender:setScale(1.0)
			local function GetSuccessCallback(  )
				NetWorkLoadingLayer.loadingHideNow()
				local function _ClickTouch(  )
					
				end
				local function ShowReward(  )
					if table.getn(tabItemS) > 0 and table.getn(tabCoinS) == 0 then
						ShowRewardLayer(tabItemS,nil,_ClickTouch)
					elseif table.getn(tabItemS) == 0 and table.getn(tabCoinS) > 0 then
						ShowRewardLayer(nil,tabCoinS,_ClickTouch)
					elseif table.getn(tabItemS) > 0 and table.getn(tabCoinS) > 0 then
						ShowRewardLayer(tabItemS,tabCoinS,_ClickTouch)
					end
				end
				

				local function EffectOver()
					ChargeVIPLogic.GetAnimationByName("Image/imgres/effectfile/VIPbox.ExportJson", 
						"VIPbox", 
						"Animation1", 
						sender, 
						ccp(0, 0),
						ShowReward,
						10)
					
				end
				ChargeVIPLogic.GetAnimationByName("Image/imgres/effectfile/VIPbox/VIPbox.ExportJson", 
					"VIPbox", 
					"Animation2", 
					sender, 
					ccp(0, 0),
					ShowReward,
					10)

			end
			Packet_VIPReward.SetSuccessCallBack(GetSuccessCallback)
			network.NetWorkEvent(Packet_VIPReward.CreatePacket(num))
			NetWorkLoadingLayer.loadingShow(true)
			
		elseif eventType == TouchEventType.began then
			sender:setScale(0.9)

		end
	end
	
	if num ~= 0 then
		img_rewardBotom:setVisible(true)
		img_word:setVisible(true)
		img_libao:setVisible(true)
		
		if img_libao:getChildByTag(10) ~= nil then
			img_libao:getChildByTag(10):removeFromParentAndCleanup(true)
		end
		if tonumber(VIPStatus) == 0 then
			ChargeVIPLogic.CreateRunAnimationByJsonPath("Image/imgres/effectfile/VIPbox/VIPbox.ExportJson", 
					"VIPbox", 
					1, 
					img_libao, 
					ccp(0, 0),
					nil,
					10)
		elseif tonumber(VIPStatus) == 1 then
			local function EffectOver()
				ChargeVIPLogic.GetAnimationByName("Image/imgres/effectfile/VIPbox.ExportJson", 
					"VIPbox", 
					"Animation2", 
					img_libao, 
					ccp(0, 0),
					nil,
					10)
				
			end
			ChargeVIPLogic.GetAnimationByName("Image/imgres/effectfile/VIPbox/VIPbox.ExportJson", 
				"VIPbox", 
				"Animation1", 
				img_libao, 
				ccp(0, 0),
				nil,
				10)
			
		elseif tonumber(VIPStatus) == 2 then
			ChargeVIPLogic.GetAnimationByName("Image/imgres/effectfile/VIPbox/VIPbox.ExportJson", 
				"VIPbox", 
				"Animation3", 
				img_libao, 
				ccp(0, 0),
				nil,
				10)
		end
		img_libao:setTouchEnabled(true)
		img_libao:addTouchEventListener(_Click_gainReward_CallBack)
	else
		img_libao:setVisible(false)
		img_libao:setTouchEnabled(false)
		img_word:setVisible(false)

	end

	local function _Click_Left_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			if num <= 1 then
				btn_left:setVisible(false)
				btn_left:setTouchEnabled(false)
				label_leftText:setText("")
			else
				
				local function GetSuccessCallback(  )
					label_leftText:setText("")
					label_rightText:setText("")
					label_VIPText:setText("")
					label_VIPlibao:setText("")
					num = num - 1
					loadTePanel(num)
				end
				Packet_VIPRewardStatus.SetSuccessCallBack(GetSuccessCallback)
				network.NetWorkEvent(Packet_VIPRewardStatus.CreatePacket())
			end
		end
	end
	local function _Click_Right_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			if num >= 13 then
				btn_right:setVisible(false)
				btn_right:setTouchEnabled(false)
				label_rightText:setText("")
			else
				
				local function GetSuccessCallback(  )
					label_leftText:setText("")
					label_rightText:setText("")
					label_VIPText:setText("")
					label_VIPlibao:setText("")
					num = num + 1
					loadTePanel(num)
				end
				Packet_VIPRewardStatus.SetSuccessCallBack(GetSuccessCallback)
				network.NetWorkEvent(Packet_VIPRewardStatus.CreatePacket())
			end
		end
	end
	if num <= 1 then
		btn_left:setVisible(false)
		btn_left:setTouchEnabled(false)
		btn_right:setVisible(true)
		btn_right:setTouchEnabled(true)
		label_leftText:setText("")
	elseif num >= 13 then
		btn_left:setVisible(true)
		btn_left:setTouchEnabled(true)
		btn_right:setVisible(false)
		btn_right:setTouchEnabled(false)
		label_rightText:setText("")
	else
		btn_left:setVisible(true)
		btn_left:setTouchEnabled(true)
		btn_right:setVisible(true)
		btn_right:setTouchEnabled(true)
	end
	btn_left:addTouchEventListener(_Click_Left_CallBack)
	btn_right:addTouchEventListener(_Click_Right_CallBack)
end

function UpdatePanelTe(  )
	local cur_vips = server_mainDB.getMainData("vip")
	if m_chargeVIPLayer == nil then
		return
	end
	-- loadTePanel(cur_vips)
	UpdatePanelTeData(cur_vips)
end

local function loadChargePanel(  )
	m_listView = tolua.cast(m_PanelCharge:getChildByName("ListView_vipItem"),"ListView")
	if m_listView ~= nil then m_listView:setClippingType(1) end
	UpdateListItem()
end

local function _Click_Change_CallBack( sender,eventType )
	local btn_changes = tolua.cast(sender,"Button")
	btn_child = btn_changes:getChildByTag(TAG_LABEL_BUTTON)
	local btn_word = LabelLayer.getText(btn_child)
	local str_char = "充值"
	local ani_tag = btn_changes:getChildByTag(100)
	
	
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		if ani_tag ~= nil then
			ani_tag:removeFromParentAndCleanup(true)
		end
		if btn_word == str_char then
			
			local function GetSuccessCallback(  )
				
				m_PanelCharge:setVisible(true)
				m_PanelCharge:setTouchEnabled(true)
				m_PanelCharge:setZOrder(5)
				m_PanelTe:setZOrder(0)
				m_PanelTe:setVisible(false)
				m_PanelTe:setTouchEnabled(false)
				local s_vipstatus = server_VIPRewardStatusDB.GetGetVIPStatus()
				if s_vipstatus == true then
					LabelLayer.setText(btn_child,"领取")
					if ani_tag == nil then
					ChargeVIPLogic.GetAnimationByName("Image/imgres/effectfile/VIP_anniu/VIP_anniu.ExportJson", 
						"VIP_anniu", 
						"Animation1", 
						btn_changes, 
						ccp(0, 0),
						nil,
						100)
					end
				else
					LabelLayer.setText(btn_child,"特权")
				end
			end
			Packet_VIPRewardStatus.SetSuccessCallBack(GetSuccessCallback)
			network.NetWorkEvent(Packet_VIPRewardStatus.CreatePacket())
		else
			
			local function GetSuccessCallback( )
				local cur_vips = server_mainDB.getMainData("vip")
				local tabStatus = GetRewardByServer()
				for key,value in pairs(tabStatus) do
					if tonumber(value) == 1 then
						cur_vips = key
						break
					else
						cur_vips = server_mainDB.getMainData("vip")
					end
				end
				m_PanelCharge:setVisible(false)
				m_PanelCharge:setTouchEnabled(false)
				m_PanelCharge:setZOrder(0)
				LabelLayer.setText(btn_child,"充值")
				loadTePanel(cur_vips)
			end
			Packet_VIPRewardStatus.SetSuccessCallBack(GetSuccessCallback)
			network.NetWorkEvent(Packet_VIPRewardStatus.CreatePacket())
		end
	end
end

local function InitUI(  )
	m_PanelTop = tolua.cast(m_chargeVIPLayer:getWidgetByName("Panel_top"),"Layout")
	m_PanelTe  = tolua.cast(m_chargeVIPLayer:getWidgetByName("Panel_special"),"Layout")
	m_PanelCharge = tolua.cast(m_chargeVIPLayer:getWidgetByName("Panel_charge"),"Layout")
	btn_charge = tolua.cast(m_PanelTop:getChildByName("Button_charge"),"Button")
	local cur_vips = server_mainDB.getMainData("vip")
	pre_VipLevel = tonumber(cur_vips)
	pre_vip = tonumber(cur_vips)
	local str = ""
	btn_charge:removeAllChildrenWithCleanup(true)
	local s_vipstatus = server_VIPRewardStatusDB.GetGetVIPStatus()
	if s_vipstatus == true then
		str = "领取"
		
		ChargeVIPLogic.GetAnimationByName("Image/imgres/effectfile/VIP_anniu/VIP_anniu.ExportJson", 
			"VIP_anniu", 
			"Animation1", 
			btn_charge, 
			ccp(0, 0),
			nil,
			100)
	else
		str = "特权"
	end
	local label_TeText = nil
	label_TeText = LabelLayer.createStrokeLabel(20, CommonData.g_FONT3, str, ccp(0, 0), ccc3(33,28,2), ccc3(255,245,126), true, ccp(0, -2), 2)	
	m_PanelCharge:setVisible(true)
	m_PanelCharge:setTouchEnabled(true)
	m_PanelCharge:setZOrder(5)
	m_PanelTe:setZOrder(0)
	m_PanelTe:setVisible(false)
	m_PanelTe:setTouchEnabled(false)
	btn_charge:addChild(label_TeText,TAG_LABEL_BUTTON,TAG_LABEL_BUTTON)
	btn_charge:addTouchEventListener(_Click_Change_CallBack)
		
	loadTopPanel()
	-- loadTePanel(cur_vips)
	loadChargePanel()
end

function CreateVIPLayer( nType )
	InitData()
	if m_chargeVIPLayer == nil then
		m_chargeVIPLayer = TouchGroup:create()
		m_chargeVIPLayer:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/VIPChargeLayer.json"))
	end
	nTypeScene = nType
	InitUI()
	if tonumber(nType) == 1 then
	--local pMainBtns = MainBtnLayer.createMainBtnLayer()
	--m_chargeVIPLayer:addChild(pMainBtns, layerMainBtn_Tag, layerMainBtn_Tag)
	end
	local btn_return = tolua.cast(m_chargeVIPLayer:getWidgetByName("Button_return"),"Button")
	btn_return:addTouchEventListener(_Click_return_CallBack)
	return m_chargeVIPLayer
end
