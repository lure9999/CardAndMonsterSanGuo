--攻城战战队的管理类 celina


module("AtkCityManager", package.seeall)


local GetTimeOneAction = AtkCitySceneLogic.GetTimeOneAction
local GetDamagePerAction = AtkCitySceneLogic.GetDamagePerAction

local GetResID         = CreateRoleData.GetResID


--播放打斗 攻击动作的替换时间
local function ShowAtkAction(self,nNum)
	if nNum == 1 then
		self.pObjectEffect:playSkill(self.pObjectEffect:GetAnimate())
	end
	if nNum ==2 then
		self.pObjectEffect:playManualSkill(self.pObjectEffect:GetAnimate())
	end
	if nNum ==3 then
		self.pObjectEffect:playAttack(self.pObjectEffect:GetAnimate())
	end
end
--创建场上的打斗的人 正在打斗人的数据，是否翻转，要显示的父类的对象
local function CreateShower(self,tabCurData,bFlix,pParent)
	self.pObjectEffect = UIEffectManager.CreateUIEffectObj()
	--[[printTab(tabCurData)
	Pause()]]--
	self.tabWJData = tabCurData
	self.pParent = pParent
	self.pObjectEffect:Create(tonumber(self.tabWJData.nImageID),bFlix,self.pParent)
	
end
--获得打斗的对象
local function GetShower(self)
	return self.pObjectEffect
end
--删除对象
local function DeleteShower(self)
	self.pObjectEffect:Destroy()
	self.pObjectEffect = nil
end
--对象死亡播放死亡动作
local function ShowDead(self)
	self.pObjectEffect:playAnimation(GetAniName_Res_ID(GetResID(self.tabWJData.nImageID),Ani_Def_Key.Ani_die))
end
--对象播放胜利的动作
local function ShowWin(self)
	self.pObjectEffect:playAnimation(GetAniName_Res_ID(GetResID(self.tabWJData.nImageID),Ani_Def_Key.Ani_cheers))
end
function CreateAtkManager()
	local pAtkManager = {}
	pAtkManager.CreateShower = CreateShower
	pAtkManager.GetShower = GetShower
	pAtkManager.DeleteShower = DeleteShower
	pAtkManager.ShowDead = ShowDead
	pAtkManager.ShowWin = ShowWin
	pAtkManager.ShowAtkAction = ShowAtkAction
	return pAtkManager
end