--攻城战的战斗结算界面 celina


module("AtkCityResultLayer", package.seeall)



--变量
local m_atkWarResultLayer = nil 
local m_UI_Type = 0
local m_fCallBack = nil 
--数据
local GetResultBWin       = AtkCityData.GetResultBWin
local GetResultMaxLS      = AtkCityData.GetResultMaxLS
local GetResultHP         = AtkCityData.GetResultHP
local GetResultLostHP     = AtkCityData.GetResultLostHP
local GetResultRewardData = AtkCityData.GetResultRewardData
local GetImgPathByID = AtkCityData.GetImgPathByID


TYPE_RESULT = {
	TYPE_RESULT_ENDWAR = 1,--国战的总结算
	TYPE_RESULT_SINGLE = 2,--单挑的结算
	
}
local function InitVars()
	m_atkWarResultLayer = nil 
	m_fCallBack = nil 
	m_UI_Type = 0
end
local function _Panel_Result_CallBack(sender,eventType)
	m_atkWarResultLayer:removeFromParentAndCleanup(true)
	if m_UI_Type== 1 then
		AtkCityScene.CloseAtkCityScene()
	end
	if m_UI_Type ==2 then
		if m_fCallBack~=nil then	
			CountryWarScene.SetIsBackFromSingle( true )
			m_fCallBack()
		end
	end
	if m_UI_Type ==3 then
		--血战结果界面
		
	end
end
--胜利或者失败
local function ShowWinOrLose()
	local img_wen = tolua.cast(m_atkWarResultLayer:getWidgetByName("img_wen"),"ImageView")
	
	if GetResultBWin(m_UI_Type)==0 then
		--失败
		local function End(pAnimation)
			--AddLabelImg(pAnimation,100,img_wen)
			pAnimation:play("Animation11")
		end
		CommonInterface.GetAnimationToPlay("Image/Fight/UI/Animation/Fight_Win_001_lq.ExportJson",
					"Fight_Win_001_lq", 
					"Animation11",
					img_wen, 
					ccp(0, 30),
					End)
	elseif GetResultBWin(m_UI_Type)==1 then
		local function End(pAnimation)
			--AddLabelImg(pAnimation,100,img_wen)
			pAnimation:play("Animation10")
		end
		CommonInterface.GetAnimationToPlay("Image/Fight/UI/Animation/Fight_Win_001_lq.ExportJson",
					"Fight_Win_001_lq", 
					"Animation9",
					img_wen, 
					ccp(0, 30),
					End)
	else
		--血战结束
		local img_xz = ImageView:create()
		img_xz:loadTexture("Image/imgres/countrywar/xz_over.png")
		img_xz:setPosition(ccp(0,30))
		AddLabelImg(img_xz,500,img_wen)
	end
end
local function InitUI()
	ShowWinOrLose()
	
	local img_bg = tolua.cast(m_atkWarResultLayer:getWidgetByName("img_bg_result"),"ImageView")
	--最大连杀
	local labelLS = LabelBMFont:create()
	labelLS:setFntFile("Image/imgres/common/num/number_warresult.fnt")
	labelLS:setText(GetResultMaxLS(m_UI_Type))
	labelLS:setAnchorPoint(ccp(0,0))
	labelLS:setPosition(ccp(-30, 62))
	img_bg:addChild(labelLS)	
	--歼敌血量
	local labelHP  = LabelLayer.createStrokeLabel(22,"微软雅黑",GetResultHP(m_UI_Type),ccp(0,4),COLOR_Black,ccc3(99,216,53),true,ccp(0,-2),2)
	labelHP:setPosition(ccp(150,98))
	AddLabelImg(labelHP,500,img_bg)
	local labelLostHP = LabelLayer.createStrokeLabel(22,"微软雅黑",GetResultLostHP(m_UI_Type),ccp(0,4),COLOR_Black,ccc3(255,87,35),true,ccp(0,-2),2)
	labelLostHP:setPosition(ccp(150,63))
	AddLabelImg(labelLostHP,501,img_bg)
	
	local tabReward = GetResultRewardData(m_UI_Type)
	local ScrollView_Reward = tolua.cast(m_atkWarResultLayer:getWidgetByName("ScrollView_jl"),"ScrollView")
	--道具奖励
	local count = 0
	local nItemCount = 0
	if tabReward.ItemReWard ~=nil then
		for  i=1,#tabReward.ItemReWard do 
			local tab  = tabReward.ItemReWard[i]
			if tab.ItemID~=nil  then
				nItemCount = nItemCount+1
				local imgItem = ImageView:create()
				UIInterface.MakeHeadIcon(imgItem,ICONTYPE.ITEM_COLOR_ICON,tab.ItemID,nil,nil,nil,nil)
				imgItem:setPosition(ccp(i*120-10,80))
				AddLabelImg(imgItem,10+i,ScrollView_Reward)
			end
		end
	end
	local img_coin1 = tolua.cast(m_atkWarResultLayer:getWidgetByName("img_r1"),"ImageView")
	local posXCoin =  img_coin1:getPositionX()
	
	--基础奖励
	
	
	for i=1 ,3 do 
		local img_bg_reward = tolua.cast(m_atkWarResultLayer:getWidgetByName("img_r"..i),"ImageView")
		local img_icon = tolua.cast(m_atkWarResultLayer:getWidgetByName("img_r"..i.."1"),"ImageView")
		if i>#tabReward.BaseReward then
			img_bg_reward:setVisible(false)
		else
			if nItemCount == 0 then
				img_bg_reward:setPosition(ccp(posXCoin+78,img_bg_reward:getPositionY()))
			else
				img_bg_reward:setPosition(ccp(posXCoin,img_bg_reward:getPositionY()))
			end
			count = count+1
			img_icon:loadTexture(GetImgPathByID(tabReward.BaseReward[i].Type))
			local labelReward  = LabelLayer.createStrokeLabel(22,"微软雅黑",tabReward.BaseReward[i].Num,ccp(0,4),COLOR_Black,ccc3(99,216,53),true,ccp(0,-2),2)
			AddLabelImg(labelReward,10+i,img_bg_reward)
		end
	end
	if count == 0 then
		--说明没有货币奖励，修改为写死银币和EXP 显示为0
		for i=1 ,3 do 
			local img_bg_reward = tolua.cast(m_atkWarResultLayer:getWidgetByName("img_r"..i),"ImageView")
			local img_icon = tolua.cast(m_atkWarResultLayer:getWidgetByName("img_r"..i.."1"),"ImageView")
			img_bg_reward:setVisible(true)
			if i==1  then
				img_icon:loadTexture("Image/imgres/common/heroexp.png")
			end
			if nItemCount == 0 then
				img_bg_reward:setPosition(ccp(posXCoin+78,img_icon:getPositionY()))
			else
				img_bg_reward:setPosition(ccp(posXCoin,img_icon:getPositionY()))
			end
			if i<3 then
				local labelReward  = LabelLayer.createStrokeLabel(22,"微软雅黑",0,ccp(0,4),COLOR_Black,ccc3(99,216,53),true,ccp(0,-2),2)
				AddLabelImg(labelReward,10+i,img_bg_reward)
			
			end
			if i>2 then
				img_bg_reward:setVisible(false)
			end
		end
	end
	
	
	local label_info = tolua.cast(m_atkWarResultLayer:getWidgetByName("Label_20"),"Label")
	if count ==0 and nItemCount == 0 then
		for i=1 ,3 do 
			local img_bg_reward = tolua.cast(m_atkWarResultLayer:getWidgetByName("img_r"..i),"ImageView")
			img_bg_reward:setVisible(false)
		end
		label_info:setVisible(true)
	else
		label_info:setVisible(false)
	end
	local Panel_result = tolua.cast(m_atkWarResultLayer:getWidgetByName("Panel_WarResult"),"Layout")
	Panel_result:setTouchEnabled(true)
	CreateItemCallBack(Panel_result,false,_Panel_Result_CallBack,nil)
end

function CreateAtkWarResultLayer(nType,fCallBack)
	InitVars()
	m_atkWarResultLayer = TouchGroup:create()
	m_atkWarResultLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/AtkCityWarResultLayer.json" ) )
	m_UI_Type = nType
	m_fCallBack = fCallBack
	InitUI()
	return m_atkWarResultLayer
end