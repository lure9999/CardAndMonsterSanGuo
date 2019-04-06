--时间管理类
--celina

module("TimeManager", package.seeall)














local function SaveTime(self)
	self.exitTime = os.time()
	
end

--exitUITime 离开界面的时候还剩下的时间
local function GetStayTime(self,exitUITime)
	local nowTime = os.time()
	local pastTime = nowTime - self.exitTime
	 
	if tonumber(pastTime)>= tonumber(exitUITime) then
		--说明不用倒计时了
		return 0 
	end
	return ( tonumber(exitUITime)-tonumber(pastTime) )
end




function CreateTimeManager()
	local TimeManagerObj = {}
	TimeManagerObj.SaveTime = SaveTime
	TimeManagerObj.GetStayTime = GetStayTime
	
	return TimeManagerObj
end