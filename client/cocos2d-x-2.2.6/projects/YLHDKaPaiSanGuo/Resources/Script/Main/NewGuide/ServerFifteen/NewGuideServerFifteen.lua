--���������ķ����������ʮ�����
module("NewGuideServerFifteen", package.seeall)

require "Script/Main/NewGuide/ServerSix/NewGuideServerSix_MainSceneBtn"
require "Script/Main/NewGuide/ServerSix/NewGuideServerSix_Marix"
require "Script/Main/NewGuide/ServerFourteen/NewGuideServerFourteen_Marix"

local OpenMainBtn = NewGuideServerSix_MainSceneBtn.OpenItemBtn

local ShowMarix = NewGuideServerSix_Marix.ShowMarix
local GetGuideIcon = NewGuideLayer.GetGuideIcon
local DeleteGuide = NewGuideLayer.DeleteGuide
local AddGuideIcon = NewGuideLayer.AddGuideIcon
local ToFifteenMarix = NewGuideServerFourteen_Marix.CreateFourteenMarix
local DeleteNewGuideTouchGroup = NewGuideLayer.DeleteNewGuideTouchGroup

local pMarixAnimation = nil 

--��14���� �����14��15 14��ѡ��װ����15��ǿ����װ��
local function FinishMarix()
	--ȫ����ɣ�ɾ����������
	HeroTalkLayer.createHeroTalkUI(3036)
	local function FinishTalk()
		--network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(13))
		DeleteNewGuideTouchGroup()
	end
	HeroTalkLayer.SetGuideBackFun(FinishTalk)
	
end
local function EndMarix()
	ToFifteenMarix(FinishMarix,2)
end
local function ToOpenMatrix()
	ShowMarix(EndMarix)
end
function CreateServerFifteen()
	--�����ݽ��������˼�
	ToOpenMatrix()
end