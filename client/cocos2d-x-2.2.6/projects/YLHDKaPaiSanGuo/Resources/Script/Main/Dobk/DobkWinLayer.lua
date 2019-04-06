--结果胜利界面celina

module("DobkWinLayer", package.seeall)


--变量
local m_layer_DobkWin = nil
local m_fCallBack = nil 
local m_eID = nil
local m_modelID = nil
local m_times = nil
--数据
local GetRewardData = DobkData.GetRewardData
local GetChouZhongItemID = DobkData.GetChouZhongItemID
local GetBDobkWin = DobkData.GetBDobkWin
--逻辑
--local CheckBEnoughByItemID = DobkLogic.CheckBEnoughByItemID


local function InitVars()
	m_layer_DobkWin = nil
	m_eID = nil
	m_modelID = nil 
	m_times = nil
end

--上面的动画
local function TopAction()
	local img_wen = tolua.cast(m_layer_DobkWin:getWidgetByName("img_wen"),"ImageView")
	if DobkLogic.GetBWin() == true then
		if GetBDobkWin(1)== false then
			--没有获得碎片
			local function EndNo(pAnimation)
				--AddLabelImg(pAnimation,100,img_wen)
				pAnimation:play("Animation8")
			end
			CommonInterface.GetAnimationToPlay("Image/Fight/UI/Animation/Fight_Win_001_lq.ExportJson",
						"Fight_Win_001_lq", 
						"Animation8",
						img_wen, 
						ccp(0, 30),
						EndNo)
		else
			local function ActionEnd()
				if img_wen:getChildByTag(10)~=nil then
					img_wen:getChildByTag(10):removeFromParentAndCleanup(true)
				end
				CommonInterface.GetAnimationByName("Image/Fight/UI/Animation/Fight_Win_001_lq.ExportJson", 
					"Fight_Win_001_lq", 
					"Animation7", 
					img_wen, 
					ccp(0, 30),
					nil,
					10)
			end
			CommonInterface.GetAnimationByName("Image/Fight/UI/Animation/Fight_Win_001_lq.ExportJson", 
				"Fight_Win_001_lq", 
				"Animation6", 
				img_wen, 
				ccp(0, 30),
				ActionEnd,
				10)
		
		end
		
	else
		--local _Img_CD_sprite = tolua.cast(img_wen:getVirtualRenderer(), "CCSprite")
		--SpriteSetGray(_Img_CD_sprite,1)
		--添加战斗失败
		local function End(pAnimation)
			--AddLabelImg(pAnimation,100,img_wen)
			pAnimation:play("Animation5")
		end
		CommonInterface.GetAnimationToPlay("Image/Fight/UI/Animation/Fight_Win_001_lq.ExportJson",
					"Fight_Win_001_lq", 
					"Animation5",
					img_wen, 
					ccp(0, 30),
					End)
	end
end
--基础奖励
local function ShowBaseReward()
	local tabBase = DobkData.GetRewardTabData(DobkLayer.GetSelectSpType(),DobkLayer.GetSelectSpID())
	local img_baseBg = tolua.cast(m_layer_DobkWin:getWidgetByName("img_bg_win"),"ImageView")
	local totalCount = table.getn(tabBase)
	
	for i=1,table.getn(tabBase) do 
		local img_bg = ImageView:create()
		img_bg:loadTexture("Image/imgres/equip/bg_name_equiped.png")
		img_bg:setPosition(ccp(-(760-260)/(2*totalCount)+(i-1)*230-130,135))
		AddLabelImg(img_bg,100+i,img_baseBg)
		local img_icon = ImageView:create()
		img_icon:loadTexture(tabBase[i].iconPath)
		img_icon:setPosition(ccp(-70,0))
		if tonumber(tabBase[i].coinType)==1 then
			img_icon:setScale(0.5)
		end
		AddLabelImg(img_icon,i,img_bg)
		local label_num = LabelLayer.createStrokeLabel(22,CommonData.g_FONT1,tabBase[i].coinNum,ccp(0,0),COLOR_Black,ccc3(99,216,53),true,ccp(0,-2),2)
		AddLabelImg(label_num,i+1,img_bg)
	end
end
local function SetTouchEnabled()
	for i=1,5 do 
		local img_box = tolua.cast(m_layer_DobkWin:getWidgetByName("img_"..i),"ImageView")
		img_box:setTouchEnabled(false)
	end
end
local function OtherRunAciton(nIndex,imgBG)
	local tabData = GetRewardData(1)
	local count = 1
	for i=1,5 do 
		if i~= nIndex then
			count = count+1
			local img_box = tolua.cast(m_layer_DobkWin:getWidgetByName("img_"..i),"ImageView")
			CommonInterface.GetAnimationByName("Image/imgres/effectfile/shoucitongguan_jiangli.ExportJson", 
				"shoucitongguan_jiangli", 
				"shoucitongguan_jiangli", 
				imgBG, 
				ccp(img_box:getPositionX(), img_box:getPositionY()),
				nil,
				nil)
			UIInterface.MakeHeadIcon(img_box,ICONTYPE.ITEM_COLOR_ICON,tabData[count].itemID,nil,nil,nil,nil)
			
		end
	end

end
local function _Img_Box_CallBack(nIndex,sender)
	--点击了一个箱子
	local img_box = tolua.cast(sender,"ImageView")
	--设置所有的不能点击
	SetTouchEnabled()
	
	--可以点击
	local btn_hc = tolua.cast(m_layer_DobkWin:getWidgetByName("btn_hc"),"Button")
	btn_hc:setVisible(true)
	btn_hc:setTouchEnabled(true)
	local btn_back_Win = tolua.cast(m_layer_DobkWin:getWidgetByName("btn_close"),"Button")
	btn_back_Win:setVisible(true)
	btn_back_Win:setTouchEnabled(true)
	
	local img_bg = tolua.cast(m_layer_DobkWin:getWidgetByName("img_mid"),"ImageView")
	local function ActionEnd()
		--添加一个选中框
		local m_img_getSP = ImageView:create()
		m_img_getSP:loadTexture("Image/imgres/common/lq.png")
		m_img_getSP:setRotation(-15)
		m_img_getSP:setPosition(ccp(img_box:getPositionX()-15,img_box:getPositionY()))
		AddLabelImg(m_img_getSP,500,img_bg)
		--将所有的都转过来
		OtherRunAciton(nIndex,img_bg)
	end
	CommonInterface.GetAnimationByName("Image/imgres/effectfile/shoucitongguan_jiangli.ExportJson", 
		"shoucitongguan_jiangli", 
		"shoucitongguan_jiangli", 
		img_bg, 
		ccp(img_box:getPositionX(), img_box:getPositionY()),
		ActionEnd,
		100)
	UIInterface.MakeHeadIcon(img_box,ICONTYPE.ITEM_COLOR_ICON,GetChouZhongItemID(1),nil,nil,nil,nil)
	
end
local function ExtractReward()
	--先都显示成背面的
	for i=1,5 do 
		local img_box = tolua.cast(m_layer_DobkWin:getWidgetByName("img_"..i),"ImageView")
		img_box:setTouchEnabled(true)
		img_box:setTag(TAG_GRID_ADD+i)
		CreateItemCallBack(img_box,false,_Img_Box_CallBack,nil)
	end

end
local function ShowInfo()
	local label_info = tolua.cast(m_layer_DobkWin:getWidgetByName("Label_info"),"Label")
	if DobkLogic.GetBWin() == true then
		if GetBDobkWin(1)== false then
			label_info:setText("很遗憾没有抢到碎片")
		else
			--抢到碎片监测符不符合合成
			if DobkLogic.CheckBEnoughByItemID(DobkLayer.GetSelectSpID(),DobkLayer.GetSelectSpType()) == false then
				label_info:setText("成功掠到碎片，再抢"..DobkLogic.GetNeedSpNum(DobkLayer.GetSelectSpID(),DobkLayer.GetSelectSpType()).."个就可以合成啦！")
			end
		end
	else
		label_info:setText("战斗失败还想拿碎片？随便抽个奖就得了。")
	end
end
local function _Btn_Back_Win_CallBack()
	m_layer_DobkWin:removeFromParentAndCleanup(true)
	InitVars()
	m_fCallBack()
	if DobkLogic.CheckBEnoughByItemID(DobkLayer.GetSelectSpID(),DobkLayer.GetSelectSpType()) == true then
		DobkSelectLayer.GetSelectLayer():removeFromParentAndCleanup(true)
		--刷新数据
		DobkLayer.UpdateDobkLayer()
	end
end

local function _Btn_Dobk_CallBack()
	--再抢一次 修改为确定
	--if DobkLogic.CheckNaiLi(1) == true then
		m_fCallBack()
		--AddLabelImg(DobkStartLayer.CreateDobkFightLayer(m_eID,m_modelID,m_times),100,DobkSelectLayer.GetSelectLayer())
		m_layer_DobkWin:removeFromParentAndCleanup(true)
		InitVars()
	--[[else
		TipLayer.createTimeLayer("耐力不足", 2)	
		m_fCallBack()
		m_layer_DobkWin:removeFromParentAndCleanup(true)
		DobkSelectLayer.GetSelectLayer():removeFromParentAndCleanup(true)
		--刷新数据
		DobkLayer.UpdateDobkLayer()
		InitVars()
	end]]--
end

local function _Btn_HC_CallBack()
	--ToSPHC 去合成到首界面
	m_fCallBack()
	m_layer_DobkWin:removeFromParentAndCleanup(true)
	InitVars()
	DobkSelectLayer.GetSelectLayer():removeFromParentAndCleanup(true)
	--刷新数据
	DobkLayer.UpdateDobkLayer()
end
local function InitUI()
	TopAction()
	ShowBaseReward()
	ExtractReward()
	--显示的信息
	ShowInfo()
	--按钮暂时为返回
	local btn_hc = tolua.cast(m_layer_DobkWin:getWidgetByName("btn_hc"),"Button")
	btn_hc:setVisible(false)
	btn_hc:setTouchEnabled(false)
	if DobkLogic.CheckBEnoughByItemID(DobkLayer.GetSelectSpID(),DobkLayer.GetSelectSpType()) == true then
		CreateBtnCallBack(btn_hc,"去合成",36,_Btn_HC_CallBack)
	else
		--0731策划将再抢一次修改为确定
		--CreateBtnCallBack(btn_hc,"再抢一次",36,_Btn_Dobk_CallBack)
		CreateBtnCallBack(btn_hc,"确定",36,_Btn_Dobk_CallBack)
	end
end
function CreateDobkWinLayer(fCallBack,eID,modelID,nTimes)
	InitVars()
	m_layer_DobkWin = TouchGroup:create()
	m_layer_DobkWin:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/DobkWinLayer.json" ) )
	m_fCallBack = fCallBack
	m_eID = eID
	m_modelID = modelID
	m_times = nTimes
	InitUI()
	local btn_back_Win = tolua.cast(m_layer_DobkWin:getWidgetByName("btn_close"),"Button")
	btn_back_Win:setVisible(false)
	btn_back_Win:setTouchEnabled(false)
	CreateBtnCallBack(btn_back_Win,nil,0,_Btn_Back_Win_CallBack)
	
	return m_layer_DobkWin
end