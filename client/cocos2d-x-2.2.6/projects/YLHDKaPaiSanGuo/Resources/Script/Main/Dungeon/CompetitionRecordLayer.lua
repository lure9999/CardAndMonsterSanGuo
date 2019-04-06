


module("CompetitionRecordLayer", package.seeall)

require "Script/Main/Dungeon/CompetitionSharedLayer"
--变量
local m_competitionRecordLayer = nil 
--数据
local GetRecordData = CompetitionData.GetRecordData
--逻辑
local GetHoursByScends = CompetitionLogic.GetHoursByScends
local ToSeeRecord      = CompetitionLogic.ToSeeRecord
--界面
local GetSharedLayer = CompetitionSharedLayer.ShowCompetitionSharedSelectLayer
local ToSharedLayer = CompetitionLogic.AddAnotherLayer

local function InitVars()
	m_competitionRecordLayer = nil 
end
local function getCloneItemRecord(mCloneItem)
	local mCloneItemRecord = mCloneItem:clone()
    local peer = tolua.getpeer(mCloneItem)
    tolua.setpeer(mCloneItemRecord, peer)
    return mCloneItemRecord

end
local function _Btn_Shared_CallBack()
	--具体看服务器需要什么参数再设置形参
	
	
	ToSharedLayer(m_competitionRecordLayer,GetSharedLayer(),1000)
end
local function _Btn_Record_CallBack(nID)
	--查看记录
	CompetitionLayer.SetFlushTime(false)
	--[[if CompetitionUnderLayer.GetTime()~= 0 then
		CompetitionLogic.SaveCompeteTime()
	end]]--
	ToSeeRecord(nID)
end
local function ShowUI()
	local img_record_namebg = tolua.cast(m_competitionRecordLayer:getWidgetByName("img_name_bg"),"ImageView")
	local label_record = LabelLayer.createStrokeLabel(26,CommonData.g_FONT1,"对战记录",ccp(0,4),COLOR_Black,ccc3(239,193,55),true,ccp(0,-3),3)
	AddLabelImg(label_record,10,img_record_namebg)
	
	local nRecordCount = table.getn(GetRecordData())
	
	local listView_record = tolua.cast(m_competitionRecordLayer:getWidgetByName("ListView_11"),"ListView")
	listView_record:setClippingType(1)
	local pListItemRecord = GUIReader:shareReader():widgetFromJsonFile("Image/CompeteRecordItem.json")
	for key ,value in pairs(GetRecordData()) do 
		
		local pRecordWidget = getCloneItemRecord(pListItemRecord)
		listView_record:pushBackCustomItem(pRecordWidget)
		local img_Item = tolua.cast(pRecordWidget:getChildByName("img_item"),"ImageView")
		--胜利或者失败
		local imgWinLose = tolua.cast(img_Item:getChildByName("img_win"),"ImageView")
		--下降或者上升
		local img_up = tolua.cast(img_Item:getChildByName("img_up"),"ImageView")
		
		local label_rank = nil 
		
		--等级
		local img_level_bg = tolua.cast(img_Item:getChildByName("img_bg_level"),"ImageView")
		local lable_level = tolua.cast(img_level_bg:getChildByName("Label_level"),"Label")
		lable_level:setText(value.nLevel)
		
		if tonumber(value.nResult)~= 0 then
			imgWinLose:loadTexture("Image/imgres/compete_bw/compete_win.png")
		end
		if tonumber(value.nRanking)>0 then
			--提升
			img_up:loadTexture("Image/imgres/common/arrow_up.png")
			label_rank = LabelLayer.createStrokeLabel(20,CommonData.g_FONT1,"+"..value.nRanking,ccp(0,4),ccc3(81,113,39),ccc3(0,255,79),true,ccp(0,-2),2)
		else
			img_up:loadTexture("Image/imgres/common/arrow_down.png")
			label_rank = LabelLayer.createStrokeLabel(20,CommonData.g_FONT1,value.nRanking,ccp(0,4),ccc3(110,21,0),ccc3(0,255,79),true,ccp(0,-2),2)
		end
		if tonumber(value.nRanking)==0 then
			img_up:setVisible(false)
		end
		label_rank:setPosition(ccp(-230,0))
		AddLabelImg(label_rank,100,img_Item)
		local img_bg_item = tolua.cast(img_Item:getChildByName("img_name_bg"),"ImageView")
		local label_name = tolua.cast(img_bg_item:getChildByName("Label_Name"),"Label")
		label_name:setText(value.sName)
		local lable_hour = tolua.cast(img_bg_item:getChildByName("Label_time"),"Label")
		lable_hour:setText(GetHoursByScends(value.nTime))
		
		--分享按钮
		local btn_shared = tolua.cast(img_Item:getChildByName("btn_shared"),"Button")
		CreateBtnCallBack(btn_shared,nil,nil,_Btn_Shared_CallBack,nil,nil,nil,nil)
		--查看记录
		local btn_record = tolua.cast(img_Item:getChildByName("btn_record"),"Button")
		CreateBtnCallBack(btn_record,nil,nil,_Btn_Record_CallBack,nil,nil,value.nID,nil)
	end

end
local function _Btn_Colse_Record_CallBack()
	m_competitionRecordLayer:removeFromParentAndCleanup(true)
end

function ShowCompetitionRecord()
	InitVars()
	
	m_competitionRecordLayer =  TouchGroup:create()
	m_competitionRecordLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/CompeteLayer_Record.json" ) )
	ShowUI()
	--关闭按钮
	local btn_close_record = tolua.cast(m_competitionRecordLayer:getWidgetByName("btn_close_record"),"Button")
	CreateBtnCallBack(btn_close_record,nil,nil,_Btn_Colse_Record_CallBack,nil,nil,nil,nil)
	
	return m_competitionRecordLayer
end