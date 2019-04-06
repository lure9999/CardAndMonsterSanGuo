
--新手引导的管理 celina
module("NewGuideManager", package.seeall)


require "Script/Main/NewGuide/NewGuideData"
require "Script/Main/NewGuide/NewGuideLayer"
require "Script/Main/NewGuide/ServerOne/NewGuideServerOne"
require "Script/Main/NewGuide/ServerTwo/NewGuideServerTwo"
require "Script/Main/NewGuide/ServerThree/NewGuideServerThree"
require "Script/Main/NewGuide/ServerFour/NewGuideServerFour"
require "Script/Main/NewGuide/ServerFive/NewGuideServerFive"
require "Script/Main/NewGuide/ServerSix/NewGuideServerSix"
require "Script/Main/NewGuide/ServerSeven/NewGuideServerSeven"
require "Script/Main/NewGuide/ServerEight/NewGuideServerEight"
require "Script/Main/NewGuide/ServerNine/NewGuideServerNine"
require "Script/Main/NewGuide/ServerTen/NewGuideServerTen"
require "Script/Main/NewGuide/ServerEleven/NewGuideServerEleven"
require "Script/Main/NewGuide/ServerTwelve/NewGuideServerTwelve"
require "Script/Main/NewGuide/ServerThirteen/NewGuideServerThirteen"
require "Script/Main/NewGuide/ServerFourteen/NewGuideServerFourteen"
require "Script/Main/NewGuide/ServerFifteen/NewGuideServerFifteen"

--数据
local GetCurServerProcess = NewGuideData.GetCurServerProcess

--界面
local GetNewGuideTouchGroup = NewGuideLayer.GetNewGuideTouchGroup
local CreateGuideLayer = NewGuideLayer.CreateNewGuideLayer
local DeleteNewGuideTouchGroup  = NewGuideLayer.DeleteNewGuideTouchGroup


Enum_NewGuide_Type = {
	Enum_NewGuide_Type_1 = 1,
	Enum_NewGuide_Type_2 = 2,
	Enum_NewGuide_Type_3 = 3,
	Enum_NewGuide_Type_4 = 4,
	Enum_NewGuide_Type_5 = 5,
	Enum_NewGuide_Type_6 = 6,
	Enum_NewGuide_Type_7 = 7,
	Enum_NewGuide_Type_8 = 8,
	Enum_NewGuide_Type_9 = 9,
	Enum_NewGuide_Type_10 = 10,
	Enum_NewGuide_Type_11 = 11,
	Enum_NewGuide_Type_12 = 12,
	Enum_NewGuide_Type_13 = 13,
	Enum_NewGuide_Type_14 = 14,
	Enum_NewGuide_Type_15 = 15,
}

local function SwitchNewGuide(nProcessNow)
	if nProcessNow == tonumber(Enum_NewGuide_Type.Enum_NewGuide_Type_1) then
		--新手引导的第一大步骤
		NewGuideServerOne.CreateServerOne()
	end
	if nProcessNow == tonumber(Enum_NewGuide_Type.Enum_NewGuide_Type_2) then
		--新手引导的第二大步骤
		NewGuideServerTwo.CreateServerTwo()
	end
	if nProcessNow == tonumber(Enum_NewGuide_Type.Enum_NewGuide_Type_3) then
		--新手引导的第三大步骤
		NewGuideServerThree.CreateServerThree()
	end
	if nProcessNow == tonumber(Enum_NewGuide_Type.Enum_NewGuide_Type_4) then
		--新手引导的第四大步骤
		NewGuideServerFour.CreateServerFour()
	end
	if nProcessNow == tonumber(Enum_NewGuide_Type.Enum_NewGuide_Type_5) then
		--新手引导的第五大步骤
		print("到第五步")
		NewGuideServerFive.CreateServerFive()
	end
	if nProcessNow == tonumber(Enum_NewGuide_Type.Enum_NewGuide_Type_6) then
		--新手引导的第六大步骤
		NewGuideServerSix.CreateServerSix()
	end
	if nProcessNow == tonumber(Enum_NewGuide_Type.Enum_NewGuide_Type_7) then
		--新手引导的第七大步骤
		NewGuideServerSeven.CreateServerSeven()
	end
	if nProcessNow == tonumber(Enum_NewGuide_Type.Enum_NewGuide_Type_8) then
		--新手引导的第八大步骤
		NewGuideServerEight.CreateServerEight()
	end
	if nProcessNow == tonumber(Enum_NewGuide_Type.Enum_NewGuide_Type_9) then
		--新手引导的第九大步骤
		NewGuideServerNine.CreateServerNine()
	end
	if nProcessNow == tonumber(Enum_NewGuide_Type.Enum_NewGuide_Type_10) then
		--新手引导的第十大步骤
		NewGuideServerTen.CreateServerTen()
	end
	if nProcessNow == tonumber(Enum_NewGuide_Type.Enum_NewGuide_Type_11) then
		--新手引导的第十一大步骤
		NewGuideServerEleven.CreateServerEleven()
	end
	if nProcessNow == tonumber(Enum_NewGuide_Type.Enum_NewGuide_Type_12) then
		--新手引导的第十二大步骤
		NewGuideServerTwelve.CreateServerTwelve()
	end
	if nProcessNow == tonumber(Enum_NewGuide_Type.Enum_NewGuide_Type_13) then
		--新手引导的第十三大步骤
		NewGuideServerThirteen.CreateServerThirteen()
	end
	if nProcessNow == tonumber(Enum_NewGuide_Type.Enum_NewGuide_Type_14) then
		--新手引导的第十四大步骤
		NewGuideServerFourteen.CreateServerFourteen()
	end
	if nProcessNow == tonumber(Enum_NewGuide_Type.Enum_NewGuide_Type_15) then
		--新手引导的第十五大步骤
		NewGuideServerFifteen.CreateServerFifteen()
	end
end

function UpdateNewGuideProcess(nProcessNow)
	SwitchNewGuide(nProcessNow)
end

local function CheckGuide()
	--得到服务器的Guide的步骤
	local nProcess = GetCurServerProcess()
	--nProcess = 7
	--[[Packet_SetNewGuide.CreatPacket(0)
	Pause()
	print("CheckGuide")
	print(nProcess)
	Pause()]]--
	
	if nProcess == 0 or nProcess >= 16 then
		--说明14个全部完成
		if GetNewGuideTouchGroup() ~=nil then
			--删除新手引导
			DeleteNewGuideTouchGroup()
		end
	else
		--开始第N个新手引导
		if GetNewGuideTouchGroup() ==nil then
			CreateGuideLayer()
			SwitchNewGuide(nProcess)
		end
	end

end
function GetBGuide()
	if CommonData.OPEN_GUIDE == 0 then
		return false
	end
	local nProcess = GetCurServerProcess()
	if nProcess == 0 or nProcess >= 16 then
		return false
	end
	return true
end
function PostPacket(nType,n1,n2,n3)
	
	if tonumber(nType) == Enum_NewGuide_Type.Enum_NewGuide_Type_1 then
		network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(0))
	end
	if tonumber(nType) == Enum_NewGuide_Type.Enum_NewGuide_Type_2 then
		--银币酒馆
		local tab = {}
		tab[1] = 0
		tab[2] = 1
		network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(1,tab))
		
	end
	if tonumber(nType) == Enum_NewGuide_Type.Enum_NewGuide_Type_3 then
		--金币酒馆
		local tab = {}
		tab[1] = 1
		tab[2] = 1
		network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(2,tab))
	end
	if tonumber(nType) == Enum_NewGuide_Type.Enum_NewGuide_Type_4 then
		--上阵武将1
		local tab= {}
		tab[1] = MatrixLayer.GetMatrixByNewGuilde(10)
		network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(3,tab))
	end
	if tonumber(nType) == Enum_NewGuide_Type.Enum_NewGuide_Type_5 then
		--上阵武将2
		local tab= {}
		tab[1] = MatrixLayer.GetMatrixByNewGuilde(10)
		network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(4,tab))
	end
	if tonumber(nType) == Enum_NewGuide_Type.Enum_NewGuide_Type_6 then
		--使用杜康酒 格子和数量
		local tab = {}
		tab[1] = ItemData.GetItemGridByID(208)
		tab[2] = 1
		tab[3] = 208
		network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(5,tab))
	end
	if tonumber(nType) == Enum_NewGuide_Type.Enum_NewGuide_Type_7 then
		--武将升级
		local tab = {}
		tab[1] = GeneralBaseUILogic.GetCurGeneralGrid()
		tab[2] = 1
		network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(6,tab))
	end
	if tonumber(nType) == Enum_NewGuide_Type.Enum_NewGuide_Type_8 then
		--领取日常银币酒馆
		local tab = {}
		tab[1] = 3
		network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(7,tab))
	end
	if tonumber(nType) == Enum_NewGuide_Type.Enum_NewGuide_Type_9 then
		--领取日常金币酒馆
		local tab = {}
		tab[1] =4
		network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(8,tab))
		
	end
	if tonumber(nType) == Enum_NewGuide_Type.Enum_NewGuide_Type_10 then
		--征战副本1
		local tab = {}
		tab[1] = n1
		tab[2] = n2
		tab[3] = n3
		network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(9,tab))
	end
	if tonumber(nType) == Enum_NewGuide_Type.Enum_NewGuide_Type_11 then
		--征战副本2
		local tab = {}
		tab[1] = n1
		tab[2] = n2
		tab[3] = n3
		network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(10,tab))
	end
	if tonumber(nType) == Enum_NewGuide_Type.Enum_NewGuide_Type_12 then
		--征战副本3
		local tab = {}
		tab[1] = n1
		tab[2] = n2
		tab[3] = n3
		network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(11,tab))
	end
	if tonumber(nType) == Enum_NewGuide_Type.Enum_NewGuide_Type_13 then
		--领取主线通关任务奖励
		local tab = {}
		tab[1] =1
		network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(12,tab))
		
	end
	if tonumber(nType) == Enum_NewGuide_Type.Enum_NewGuide_Type_14 then
		--装备断浪甲
		local tab = {}
		tab[1] = EquipLogic.GetEquipGuideTab()
		network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(13,tab))
	end
	if tonumber(nType) == Enum_NewGuide_Type.Enum_NewGuide_Type_15 then
		--强化断浪甲
		local tab = {}
		tab[1] = n1
		tab[2] = n2
		network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(14,tab))
	end
end
--创建新手引导的管理类
function CreateNewGuideManager()
	CheckGuide()
end