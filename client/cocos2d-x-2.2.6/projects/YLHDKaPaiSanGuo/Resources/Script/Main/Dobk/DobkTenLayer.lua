--掠夺十次的界面celina

module("DobkTenLayer", package.seeall)
require "Script/Common/RichLabel"
--变量
local m_layer_tenResult = nil

local m_callBack = nil --回调
local n_title_num = 0 --用来记录标题的数量
local m_tab_label= nil
local tabBase = nil --存储消耗
local n_labelNum = 0
--数据
local GetResultData = DobkData.GetResultData
local GetTenRewardData     = DobkData.GetTenRewardData
local GetBDobkWin    = DobkData.GetBDobkWin
--逻辑
--local GetItemAction = DobkLogic.GetItemAction
local function InitVars()
	m_layer_tenResult = nil 
	m_callBack = nil
	n_title_num = 0
	m_tab_label = nil
	tabBase = nil
	n_labelNum = 0
end
local function BackDobkLayer()
	if m_callBack~=nil then
		m_callBack()
	end	
	m_layer_tenResult:removeFromParentAndCleanup(true)
	if DobkLogic.CheckBDobk(DobkLayer.GetSelectSpID(),DobkLayer.GetSelectSpType()) == false then
		--回到合成界面
		if DobkSelectLayer.GetSelectLayer()~=nil then
			DobkSelectLayer.GetSelectLayer():removeFromParentAndCleanup(true)
			DobkLogic.GetDobkLayerData(DobkLayer.GetSelectSpType(),DobkLayer.UpdateDobkLayer)
		end
		
	end
end
local function _Btn_Back_Ten_CallBack()
	--[[if m_callBack~=nil then
		m_callBack()
	end	
	m_layer_tenResult:removeFromParentAndCleanup(true)
	if DobkLogic.CheckBDobk(DobkLayer.GetSelectSpID(),DobkLayer.GetSelectSpType()) == false then
		--回到合成界面
		if DobkSelectLayer.GetSelectLayer()~=nil then
			DobkSelectLayer.GetSelectLayer():removeFromParentAndCleanup(true)
			DobkLogic.GetDobkLayerData(DobkLayer.GetSelectSpType(),DobkLayer.UpdateDobkLayer)
		end
		
	end]]--
	local tabVIP =  MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_10)
	--printTab(tabVIP)
	--Pause()
	BackDobkLayer()
end
--基础奖励  
local function ShowBaseTenReward(panel,posX,posY)
	tabBase = DobkData.GetRewardTabData(DobkLayer.GetSelectSpType(),DobkLayer.GetSelectSpID())
	local totalCount = table.getn(tabBase)
	
	for i=1,table.getn(tabBase) do 
		local img_bg = ImageView:create()
		img_bg:loadTexture("Image/imgres/equip/bg_name_equiped.png")
		img_bg:setPosition(ccp(-posX/(2*totalCount)-120+(i-1)*200,posY))
		AddLabelImg(img_bg,1400+i,panel)
		local img_icon = ImageView:create()
		img_icon:loadTexture(tabBase[i].iconPath)
		img_icon:setPosition(ccp(-70,0))
		if tonumber(tabBase[i].coinType)==1 then
			img_icon:setScale(0.5)
		end
		AddLabelImg(img_icon,i,img_bg)
		local label_num = LabelLayer.createStrokeLabel(22,CommonData.g_FONT1,tabBase[i].coinNum,ccp(0,0),COLOR_Black,ccc3(99,216,53),true,ccp(0,-2),2)
		label_num:setVisible(true)
		AddLabelImg(label_num,i+1,img_bg)
		table.insert(m_tab_label,label_num)
	end
end

local function RunSPAction(itemID,key,imgBG,bHaveSP)
	local img_item = ImageView:create()
	UIInterface.MakeHeadIcon(img_item,ICONTYPE.ITEM_COLOR_ICON,itemID,nil,nil,nil,nil)
	--img_item:setScale(0.68)
	img_item:setPosition(ccp(-230+(key-1)*100,0))
	img_item:setScale(0.5)
	img_item:runAction(DobkLogic.GetItemAction())
	
	AddLabelImg(img_item,10+key,imgBG)	
	
	local img_ts = img_item:getChildByTag(1000)
	if bHaveSP == true then
		if key == 1 then
			local function EffectEnd()
				CommonInterface.GetAnimationByName("Image/imgres/effectfile/shoucitongguan_jiangli.ExportJson", 
				"shoucitongguan_jiangli", 
				"duobao_suipian", 
				img_ts, 
				ccp(0, 0),
				nil,
				12)
			end
			--[[local m_img_getSP = ImageView:create()
			m_img_getSP:loadTexture("Image/imgres/item/selected_xie_icon.png")
			AddLabelImg(m_img_getSP,1,img_item)]]--
			--加成特效
			CommonInterface.GetAnimationByName("Image/imgres/effectfile/shoucitongguan_jiangli.ExportJson", 
			"shoucitongguan_jiangli", 
			"duobao_shinianchou", 
			img_ts, 
			ccp(0, 0),
			EffectEnd,
			12)
		end
	end

end
local function RunActionItem(itemID,key,imgBG,bHaveSP,tabTitle)
	if key== 1 then
		n_title_num = n_title_num +1
		
		local function ActionEnd()
			RunSPAction(itemID,key,imgBG,bHaveSP)
		end
		local img_title = tolua.cast(tabTitle[n_title_num],"ImageView")
		img_title:setVisible(true)
		img_title:runAction(DobkLogic.GetTitleAction(ActionEnd))
		
		--[[local function LabelActionEnd(label)
			local str_Value = LabelLayer.getText(label)
			--printTab(tabBase[n_labelNum].coinNum)
			local nBaseCount = #tabBase
			local curValue =n_labelNum%nBaseCount
			if curValue ==0 then
				curValue = 3
			end
			print(tabBase[curValue].coinNum)
			print("=========================")
			if tonumber(str_Value) >=tonumber(tabBase[curValue].coinNum) then
				--LabelLayer.setText(label_num,1000)
				LabelLayer.setText(label,tabBase[curValue].coinNum)
				label:stopAllActions()
			else
				LabelLayer.setText(label,tonumber(str_Value)+20)
			end
		end
		for i=1,#tabBase do 
			n_labelNum = (n_title_num-1)*2+i
			local label_num = tolua.cast(m_tab_label[n_labelNum],"Layout")
			label_num:setVisible(true)
			label_num:runAction(DobkLogic.GetLabelAction(LabelActionEnd))
		end]]--
		
	else
		RunSPAction(itemID,key,imgBG,bHaveSP)
	end
	
	
end

local function AddReward(arrayImg,scrollView,tabImgTitle)
	local nTime = 0
	local beginIndex = 0
	local countPanel = 1
	local tabData = GetTenRewardData(countPanel,DobkLayer.GetSelectSpID())
	local endIndex = table.getn(tabData) 
	local imgBG = arrayImg:objectAtIndex(0)
	--local actionNum = 0
	
	local function GetForEverAction(fCallBack)
		local array_action = CCArray:create()
		array_action:addObject(CCDelayTime:create(nTime + 0.3))
		array_action:addObject(CCCallFunc:create(fCallBack))
		local action_list = CCSequence:create(array_action)
		array_action:removeAllObjects()
		array_action = nil 
		return action_list
	end
	
	local function actionEnd()
		
		beginIndex = beginIndex +1
		if beginIndex<= endIndex then
			if endIndex == 2 then
				RunActionItem(tabData[beginIndex].itemID,beginIndex,imgBG,true,tabImgTitle)
			else
				RunActionItem(tabData[beginIndex].itemID,beginIndex,imgBG,false,tabImgTitle)
			end
		end
		if beginIndex> endIndex then
			beginIndex = 0
			countPanel = countPanel +1 
			if countPanel>(table.getn(GetResultData())) then
				scrollView:stopAllActions()
				--Pause()
			else
				tabData = GetTenRewardData(countPanel,DobkLayer.GetSelectSpID())
				endIndex  = table.getn(tabData)
				imgBG = arrayImg:objectAtIndex(countPanel-1)
				--scrollView:scrollToBottom(11,false)
				if countPanel>=2 then
					if countPanel ~= arrayImg:count() then
						scrollView:scrollToPercentVertical(11.55*(countPanel-2),0.2,true)
					else
						if countPanel == 10 then
							scrollView:jumpToBottom()
						else
							scrollView:scrollToPercentVertical(11.55*(arrayImg:count()-1),0.2,true)
						end
					end
				end
			end
		end	
	end
	
	scrollView:runAction(CCRepeatForever:create(GetForEverAction(actionEnd)))
	
end
local function CreateLabel(color,fontSize,strInfo,pos,tag,pPanel,isAnchor)
	
	local label = Label:create()
	label:setColor(color)
	label:setFontSize(fontSize)
	--label:setFontName("微软雅黑")
	label:setPosition(pos)
	label:setText(strInfo)
	if isAnchor~=nil then
		label:setAnchorPoint(ccp(0,0))
	end
	AddLabelImg(label,tag,pPanel)	
end
--0731增加确定
local function _Btn_Sure_CallBack()
	BackDobkLayer()
end
local function InitUI()
	m_tab_label = {}
	local tabData = GetResultData()
	local tabTitleImg = {}
	local scrollView = tolua.cast(m_layer_tenResult:getWidgetByName("ScrollView_ten"),"ScrollView")
	scrollView:setClippingType(1)
	scrollView:setInnerContainerSize(CCSize(607,2651))
	local count = 0
	local nNum = 0 --碎片的数量
	local array_img = CCArray:create()
	array_img:retain()
	
	for key,value in pairs(tabData) do 
		local panel = Layout:create()
		panel:setSize(CCSize(612,241))
		panel:setPosition(ccp(607/2,2615-241*count))
		
		local img_titleBG = ImageView:create()
		img_titleBG:loadTexture("Image/imgres/equip/title_bg.png")
		img_titleBG:setScale9Enabled(true)
		img_titleBG:setSize(CCSize(325, 36))
		count = count+1
		--标题
		local color = nil
		local strTitle = nil
		if tonumber(value.fightResult) == 1 then
			color = ccc3(239,193,55)
			strTitle = "第"..count.."战，胜利！"
		else
			color = ccc3(143,130,109)
			strTitle = "第"..count.."战，失败！"
		end
		local label_title = LabelLayer.createStrokeLabel(26,CommonData.g_FONT1,strTitle,ccp(0,4),COLOR_Black,color,true,ccp(0,-2),2)
		label_title:setVisible(false)
		table.insert(tabTitleImg,label_title)
		AddLabelImg(label_title,key,img_titleBG)	
		AddLabelImg(img_titleBG,100+key,panel)	
		--基础奖励
		ShowBaseTenReward(panel,602-260,img_titleBG:getPositionY()-55)
		--奖励框
		local img_reward_bg = ImageView:create()
		img_reward_bg:loadTexture("Image/imgres/equip/d_down_bg.png")
		img_reward_bg:setScale9Enabled(true)
		img_reward_bg:setSize(CCSize(583, 97))
		img_reward_bg:setPosition(ccp(img_titleBG:getPositionX(),img_titleBG:getPositionY()-135))
		AddLabelImg(img_reward_bg,200+key,panel)
		
		array_img:addObject(img_reward_bg)
		--线
		local img_line = ImageView:create()
		img_line:loadTexture("Image/imgres/equip/line_bg.png")
		img_line:setPosition(ccp(img_reward_bg:getPositionX(),img_reward_bg:getPositionY()-63))
		AddLabelImg(img_line,300+key,panel)
		
		AddLabelImg(panel,100+key,scrollView)	
		if GetBDobkWin(key) == true then
			nNum = nNum +1
		end
		if key == table.getn(tabData) then
			if nNum ~=  0 then 
				local strSp = DobkData.GetItemName(DobkLayer.GetSelectSpID()) 
				
				--[[CreateLabel(ccc3(49,31,21),22,"恭喜你获得",ccp(-230,img_line:getPositionY()-50),400+key,panel)	
				--CreateLabel(ccc3(99,216,53),22,nNum,ccp(-160,img_line:getPositionY()-50),500+key,panel)
				local lable_num= LabelLayer.createStrokeLabel(22,CommonData.g_FONT1,nNum,ccp(0,4),COLOR_Black,ccc3(99,216,53),true,ccp(0,-2),2)
				lable_num:setPosition(ccp(-160,img_line:getPositionY()-50))
				AddLabelImg(lable_num,500+key,panel)
			
				CreateLabel(ccc3(49,31,21),22,"个",ccp(-130,img_line:getPositionY()-50),600+key,panel)	
				CreateLabel(ccc3(255,66,0),22,strSp,ccp(-115,img_line:getPositionY()-62),700+key,panel,true)	
				--CreateLabel(ccc3(49,31,21),22,"恭喜你获得",ccp(-250,img_line:getPositionY()-50),400+key,panel)	
				local cha = 1
				if string.len(strSp)>13 then 
					cha = cha*(string.len(strSp)-13)
				end]]--
				local str_rich = nil 
				if DobkLogic.CheckBDobk(DobkLayer.GetSelectSpID(),DobkLayer.GetSelectSpType()) == true then
					--CreateLabel(ccc3(49,31,21),22,"!",ccp(55,img_line:getPositionY()-50),800+key,panel)
					--CreateLabel(ccc3(49,31,21),22,"!",ccp(-115+string.len(strSp)*8-cha,img_line:getPositionY()-62),800+key,panel,true)
					--LabelLayer.CreateRichTextLabel("恭喜你获得"..nNum.."个"..strSp,1100)
					str_rich = "|size|24||color|49,31,21|".."恭喜你获得"..nNum.."|size|24||color|49,31,21|".."个 "--.."|color|255,66,0|"..strSp.."|color|49,31,21|".." !"
					
				else
					--130
					str_rich = "|size|24||color|49,31,21|".."恭喜你获得"..nNum.."|size|24||color|49,31,21|".."个 "--.."|color|255,66,0|"..strSp.."|color|49,31,21|".." 可以合成了！"
					--CreateLabel(ccc3(49,31,21),22,"!可以合成了！",ccp(-115+string.len(strSp)*8-cha,img_line:getPositionY()-62),1000+key,panel,true)
				end
				local img_item = ImageView:create()
				local icon = UIInterface.MakeHeadIcon(img_item,ICONTYPE.ITEM_COLOR_ICON,DobkLayer.GetSelectSpID(),nil,nil,nil,nil)
				--icon:getParent():setScale(0.68)
				local labelInfo = RichLabel.Create(str_rich,1100,1,ccp(0,0))
				labelInfo:setPosition(ccp(-250,img_line:getPositionY()-10))
				
				AddLabelImg(labelInfo,400+key,panel)
				RichLabel.AddCustomItem(icon:getParent(),0.68)
				
				if DobkLogic.CheckBDobk(DobkLayer.GetSelectSpID(),DobkLayer.GetSelectSpType()) == false then
					RichLabel.InsertRichLabelTextItem(1,"可以合成了",22,ccc3(49,31,21),"微软雅黑",nil)
				end
			else
				CreateLabel(ccc3(49,31,21),22,"很遗憾，没有获得碎片！",ccp(-170,img_line:getPositionY()-50),400+key,panel)
			end
			local imgEnd = ImageView:create()
			imgEnd:loadTexture("Image/imgres/dobk/dobkEnd.png")
			imgEnd:setPosition(ccp(0,img_line:getPositionY()-150))
			AddLabelImg(imgEnd,800,panel)
			
			--左边纹
			local imgLeftWen = ImageView:create()
			imgLeftWen:loadTexture("Image/imgres/dobk/dobk_wen.png")
			imgLeftWen:setPosition(ccp(imgEnd:getPositionX()-200,img_line:getPositionY()-150))
			AddLabelImg(imgLeftWen,801,panel)
			--右边纹
			local imgRightWen = ImageView:create()
			imgRightWen:loadTexture("Image/imgres/dobk/dobk_wen.png")
			imgRightWen:setPosition(ccp(imgEnd:getPositionX()+200,img_line:getPositionY()-150))
			AddLabelImg(imgRightWen,802,panel)
			--0721增加确定按钮
			local btn_sure = Button:create()
			btn_sure:loadTextures("Image/imgres/common/btn_bg.png","Image/imgres/common/btn_bg.png","")
			btn_sure:setPosition(ccp(0,imgEnd:getPositionY()-65))
			AddLabelImg(btn_sure,803,panel)
			CreateBtnCallBack(btn_sure,"确定",36,_Btn_Sure_CallBack)
		end
		
	end
	
	--添加奖励
	AddReward(array_img,scrollView,tabTitleImg)
	
end

function CreateDobkTenLayer(fCallBack)
	InitVars()
	m_layer_tenResult = TouchGroup:create()
	m_layer_tenResult:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/DobkTenLayer.json" ) )
	m_callBack = fCallBack
	InitUI()
	local btn_back_Ten = tolua.cast(m_layer_tenResult:getWidgetByName("btn_back"),"Button")
	CreateBtnCallBack(btn_back_Ten,nil,0,_Btn_Back_Ten_CallBack)
	
	return m_layer_tenResult
end