--指引管理类 celina


module("GuideTotalManager", package.seeall)

require "Script/Guide/GuideTotalLayer"


local CreateTotalLayer_Manager = GuideTotalLayer.CreateTotalLayer


--去往不同的子界面
local function GuideToSubLayer(nIndex)
	--点击的第几个

end

local function AddGuideManagerLayer(pUILayer)
	local scene_now = CCDirector:getRUn
	layerGuide_Tag
end

--需要物品的类型，是道具还是货币
local function Create_Manager(self,nType,nItemID)
	local tab = {}
	tab.itemID = nItemID
	tab.nType  = nType
	local self.pUI = CreateTotalLayer(tab,GuideToSubLayer)
	AddGuideManagerLayer(self.pUI)
end

function CreateGuideToTalManager()
	local pManager = {}
	pManager.Create = Create_Manager
	
	
	return pManager


end