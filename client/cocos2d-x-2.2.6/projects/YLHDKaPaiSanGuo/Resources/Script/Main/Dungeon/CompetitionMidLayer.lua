
--比武界面中间部分的信息 celina


module("CompetitionMidLayer", package.seeall)


--require "Script/Main/Dungeon/CompetitionImageSelectLayer"
require "Script/Main/Dungeon/CompetitionInfoLayer"
require "Script/Main/Dungeon/CompetitionRecordLayer"
require "Script/Main/Mall/ShopLayer"
--变量
local m_mideLayer = nil 
--逻辑

local ToImageSelectLayer = CompetitionLogic.AddAnotherLayer
--local CreateCompetitionImageSelect = CompetitionImageSelectLayer.CreateCompetitionImageSelect

local ShowCompetitionInfo = CompetitionInfoLayer.ShowCompetitionInfo

local ShowCompetitionRecord = CompetitionRecordLayer.ShowCompetitionRecord

local function _Btn_Image_CallBack()
	--到比武商店界面
	--TipLayer.createTimeLayer("功能未开发", 2)	
	--ToImageSelectLayer(m_mideLayer,CreateCompetitionImageSelect(),1000)
	local nShopId = 2
	local function OpenCorpsShop()
		NetWorkLoadingLayer.loadingHideNow()
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		local temp = scenetemp:getChildByTag(layerShopTag)

		if temp == nil then
		MainScene.ClearRootBtn()
		local pLayerShop = ShopLayer.CreateShopLayer(nShopId)
		scenetemp:addChild(pLayerShop,layerShopTag,layerShopTag)
		MainScene.PushUILayer(pLayerShop)
		else
		print("已经是商店界面了")
		end
	end
	NetWorkLoadingLayer.loadingShow(true)
	Packet_GetShopList.SetSuccessCallBack(OpenCorpsShop)
	network.NetWorkEvent(Packet_GetShopList.CreatPacket(nShopId))
end

local function _Btn_Gernal_CallBack()
	--TipLayer.createTimeLayer("功能未开发", 2)	
	MainScene.ShowRankList(RANKING_LIST_TYPE.RANKING_LIST_ATHLETICS)
end

local function _Btn_Record_CallBack()
	--得到数据
	local function GetRecordData()
		NetWorkLoadingLayer.loadingShow(false)
		ToImageSelectLayer(m_mideLayer,ShowCompetitionRecord(),4000)
	end
	Packet_GetPvPRecord.SetSuccessCallBack(GetRecordData)
	network.NetWorkEvent(Packet_GetPvPRecord.CreatPacket())
	NetWorkLoadingLayer.loadingShow(true)
	
end

local function _Btn_BWInfo_CallBack()
	ToImageSelectLayer(m_mideLayer,ShowCompetitionInfo(),3000)
end

function CompetitionMidInfo(mLayer)
	m_mideLayer = mLayer

	--奖励时间(固定)
	--设置形象
	local btn_image = tolua.cast(mLayer:getWidgetByName("btn_mid_image"),"Button")
	CreateBtnCallBack(btn_image,"比武商店",20,_Btn_Image_CallBack,ccc3(74,34,9),ccc3(255,245,133),nil,nil,CommonData.g_FONT3)
	
	local btn_gernal = tolua.cast(mLayer:getWidgetByName("btn_mid_gernal"),"Button")
	CreateBtnCallBack(btn_gernal,"比武排名",20,_Btn_Gernal_CallBack,ccc3(74,34,9),ccc3(255,245,133),nil,nil,CommonData.g_FONT3)
	
	local btn_record= tolua.cast(mLayer:getWidgetByName("btn_mid_record"),"Button")
	CreateBtnCallBack(btn_record,"对战记录",20,_Btn_Record_CallBack,ccc3(74,34,9),ccc3(255,245,133),nil,nil,CommonData.g_FONT3)
	
	local btn_info = tolua.cast(mLayer:getWidgetByName("btn_mid_info"),"Button")
	CreateBtnCallBack(btn_info,"比武说明",20,_Btn_BWInfo_CallBack,ccc3(74,34,9),ccc3(255,245,133),nil,nil,CommonData.g_FONT3)

end