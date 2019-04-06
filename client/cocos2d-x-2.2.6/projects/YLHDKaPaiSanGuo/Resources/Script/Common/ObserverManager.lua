--自动更新注册 celina


module("ObserverManager", package.seeall)

-- 返回值修改为表中的位置，用于移出
local function CheckBObserver(tableNow,nKey)
	for key,value in pairs(tableNow) do
		if tonumber(value.t_key) == tonumber(nKey) then
			return key
		end
	end
	return nil
end

function RegisterObserver( self ,key,fCallBack)
	if key==nil then
		return 
	end
	if CheckBObserver(self.tableObserver,key) == nil then
		local tableL = {}
		tableL.t_key = key
		tableL.Observer_callBack = fCallBack
		table.insert(self.tableObserver,tableL)
	end
end

local function Update(table_Observer)
	if table_Observer~=nil then
		for key,value in pairs (table_Observer) do
			value.Observer_callBack()
		end
	end
end

local function UpdateByKey( table_Observer, nkey, nIndex, nType )
	if table_Observer~=nil then
		for key,value in pairs (table_Observer) do
			if key == nKey then
				value.Observer_callBack(nIndex, nType)
				break
			end
		end
	end	
end

function Notify(self)
	Update(self.tableObserver)
end

function NotiFyByKey( self, key, nIndex, nType )
	UpdateByKey(self.tableObserver,key, nIndex, nType)
end

local function GetTablePosByKey( key )
	-- body
end

function DeleteObserverByKey(self,key)
	--检查有这个注册key 才删除
	local nTablePos = CheckBObserver(self.tableObserver, key)
	if nTablePos ~= nil then
		table.remove(self.tableObserver,nTablePos)
	end
	--printTab(self.tableObserver)
end
function CreateObserver()
	local Observer = {
		table_data = { },
		tableObserver = {},
		RegisterObserver = RegisterObserver,
		DeleteObserverByKey = DeleteObserverByKey,
		Notify   = Notify,
		NotiFyByKey = NotiFyByKey,
	}
	return Observer
end

