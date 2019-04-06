--最上面的各种货币心思提示条管理 celina

module("CoinInfoBarManager", package.seeall)
require "Script/Main/CoinBar/CoinInfoBarNew"


EnumLayerType = {
	EnumLayerType_Main = 1, --主城界面
	EnumLayerType_War = 2, --国战界面
	EnumLayerType_ReCharge = 3, --充值界面
	EnumLayerType_PalyerInfo = 4,--玩家信息界面
	EnumLayerType_GrogShop = 5, --酒馆界面
	EnumLayerType_Sign = 6,--签到界面
	EnumLayerType_Pata = 7,--重楼界面
	EnumLayerType_Shop = 8,--主界面商店界面
	EnumLayerType_Shop = 9,--主界面熊猫商店界面
	EnumLayerType_Mail = 10,--邮件界面
	EnumLayerType_Copy = 11,--征战界面
	EnumLayerType_Rank = 12,--排行榜界面
	EnumLayerType_Biwu = 13,--比武界面
	EnumLayerType_Dobk = 14,--夺宝界面
	EnumLayerType_Matrix = 15,--阵容界面
	EnumLayerType_General = 16,--武将主界面
	EnumLayerType_ZhuJiang_PeiYang = 17,--主将培养界面
	EnumLayerType_ZhuJiang_YuanFen = 18,--主将缘分界面
	EnumLayerType_ZhuJiang_ShuXing = 19,--主将属性界面
	EnumLayerType_General_PeiYang = 20,--武将将培养界面
	EnumLayerType_General_YuanFen = 21,--武将缘分界面
	EnumLayerType_General_ShuXing = 22,--武将属性界面
	EnumLayerType_Equip = 23,--装备主界面
	EnumLayerType_Treasure = 24,--宝物主界面
	EnumLayerType_LingBao = 25,--灵宝主界面
	EnumLayerType_EquipQH = 26,--装备强化界面
	EnumLayerType_EquipXiLian = 27,--装备洗练界面
	EnumLayerType_TreasureQH = 28,--宝物强化界面
	EnumLayerType_TreasureJL = 29,--宝物精炼界面
	EnumLayerType_Item = 30, --背包界面
	EnumLayerType_Log = 31, --日志界面
	EnumLayerType_CreateCrops = 32, --军团创建界面
	EnumLayerType_ShopBiWu = 33,--比武商店
}

local function CheckBHaveBar(tabBar,nKey)
	for key,value in pairs(tabBar) do
		if tonumber(value.nBarKey) == tonumber(nKey) then
			return key
		end
	end
	return nil
end
local function HideTabBar(tabBar,bHide)
	for key,value in pairs(tabBar) do 
		if value.pBar~=nil then
			local pLayer = tolua.cast(value.pBar.m_pCoinBarLayer,"Layout")
			pLayer:setVisible(not bHide)
		end
	end
end
--更新
local function Update_UI(self)
	for k,v in pairs (self.TabBarManager) do 
		if v.pBar~=nil then
			v.pBar:Update() 
		end
	end
end
--创建
local function Create_UI(self,pParent,nLayerType)
	if CheckBHaveBar(self.TabBarManager,nLayerType) == nil then
		--先将之前的Tab里的先都隐藏
		HideTabBar(self.TabBarManager,true)
		local pCoin = CoinInfoBarNew.AddCoinBar(nLayerType)
		local tabBar = {}
		tabBar.pBar = pCoin
		tabBar.nBarKey = nLayerType
		pParent:addChild(tabBar.pBar.m_pCoinBarLayer, layerCoinBar_Tag, layerCoinBar_Tag)
		table.insert(self.TabBarManager,tabBar)
	end
	
end

--隐藏
local function Hide_UI(self,nLayerType)
	local nTablePos = CheckBHaveBar(self.TabBarManager, nLayerType)
	local pHideBar = self.TabBarManager[nTablePos].pBar.m_pCoinBarLayer
	if pHideBar~=nil then
		pHideBar:setVisible(false)
	end
end
--显示
local function Show_UI(self,nLayerType)
	
	local nTablePos = CheckBHaveBar(self.TabBarManager, nLayerType)
	local pShowBar = self.TabBarManager[nTablePos].pBar.m_pCoinBarLayer
	
	if pShowBar~=nil then
		if pShowBar:getParent()~=nil then
			pShowBar:setVisible(true)
		end
	end
end
local function ShowBarLast(self)
	local nCount = #self.TabBarManager
	local pBar = self.TabBarManager[nCount]
	Show_UI(self,tonumber(pBar.nBarKey))
end
--删除
local function Delete_UI(self,nLayerType)
	--检查有这个注册key 才删除
	local nTablePos = CheckBHaveBar(self.TabBarManager, nLayerType)
	if nTablePos ~= nil then
		table.remove(self.TabBarManager,nTablePos)
		--表里最上面的要显示
		ShowBarLast(self)
	end
end
--更新

function CreateShowBar()
	local pTabBar = {}
	pTabBar.TabBarManager = {}
	pTabBar.Create = Create_UI
	pTabBar.Delete = Delete_UI
	pTabBar.Hide = Hide_UI
	pTabBar.Show= Show_UI
	pTabBar.Update= Update_UI
	return pTabBar
end