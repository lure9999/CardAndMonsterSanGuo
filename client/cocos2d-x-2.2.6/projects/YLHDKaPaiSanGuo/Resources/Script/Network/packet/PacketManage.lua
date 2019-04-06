--add by sxin 所有包管理逻辑处理分发


local m_tableSaveData = {}

function GetNetWorkSaveData(TypeID, LogicID)

    for key, value in pairs(m_tableSaveData) do
    	if value["TypeID"] == TypeID and value["LogicID"] == LogicID then			
    		return value["PacketData"]
    	end
    end
	print("GetNetWorkSaveData error TypeID=" .. TypeID .. "LogicID =" ..LogicID)
    return nil
end

function DeleteNetWorkSaveData(TypeID, LogicID)
	local nIndex = 0
    for key, value in pairs(m_tableSaveData) do
        nIndex = nIndex + 1
    	if value["TypeID"] == TypeID and value["LogicID"] == LogicID then
            table.remove(m_tableSaveData, nIndex)
            return
    	end
    end
	print("DeleteNetWorkSaveData error TypeID=" .. TypeID .. "LogicID =" ..LogicID)
end

function UpdataNetWorkSaveData(TypeID, LogicID, Ex_Id01, Ex_Id02, nSocket, nLen, PacketData)
	local nIndex = 0
    for key, value in pairs(m_tableSaveData) do     
    	if value["TypeID"] == TypeID and value["LogicID"] == LogicID then
    		-- 找到了之前的数据,更新
			--Ex_Id01 要小于前一个
			if tonumber(Ex_Id01) == 0 then			
				value["PacketData"] = value["PacketData"] .. PacketData   
				value["nLen"]	= tonumber(value["nLen"]) + tonumber(nLen)	
				value["Ex_Id01"] = Ex_Id01
				value["Ex_Id02"] = Ex_Id02			
			else 
				if tonumber(value["Ex_Id01"]) == (tonumber(Ex_Id01) -1) then
					value["PacketData"] = value["PacketData"] .. PacketData   
					value["nLen"]	= tonumber(value["nLen"]) + tonumber(nLen)	
					value["Ex_Id01"] = Ex_Id01
					value["Ex_Id02"] = Ex_Id02
				else
					value["TypeID"] = TypeID
					value["LogicID"] = LogicID
					value["Ex_Id01"] = Ex_Id01
					value["Ex_Id02"] = Ex_Id02
					value["nSocket"] = nSocket
					value["nLen"] = nLen
					value["PacketData"] = PacketData
					--说明包错了
					print("UpdataNetWorkSaveData error TypeID=" .. TypeID .. "LogicID =" ..LogicID)
					
				end
			end
			
    		return
    	end
    end
    
    -- 之前没有数据，新加入
	local tableSaveData = {}
	tableSaveData["TypeID"] = TypeID
	tableSaveData["LogicID"] = LogicID
	tableSaveData["Ex_Id01"] = Ex_Id01
	tableSaveData["Ex_Id02"] = Ex_Id02
	tableSaveData["nSocket"] = nSocket
	tableSaveData["nLen"] = nLen
	tableSaveData["PacketData"] = PacketData
	table.insert(m_tableSaveData, tableSaveData)
end

-- 请求网络事件回调函数借口 接收网络数据
function luarecv_org(TypeID, LogicID, Ex_Id01, Ex_Id02, nSocket, nLen, PacketData)
	
	UpdataNetWorkSaveData(TypeID, LogicID, Ex_Id01, Ex_Id02, nSocket, nLen, PacketData)
	if Ex_Id01 == 0 then		
		PacketManage.Excute(TypeID,LogicID,GetNetWorkSaveData(TypeID, LogicID))	
		DeleteNetWorkSaveData(TypeID, LogicID)
	end
	
end
--引用netstream
require "Script/Network/packet/NetStream"
module("PacketManage", package.seeall)
 
require "Script/Network/packet/PacketCmd"

local m_PacketInterFaceTable = {}	

function RegistPacketFun( TypeID, LogicID , Fun)
	local key = "TYPE_" .. TypeID
	local TypeTable = m_PacketInterFaceTable[key]	
	
	if TypeTable == nil then 
		
		TypeTable = {}
		m_PacketInterFaceTable[key] = TypeTable
	
	else	
		if TypeTable[LogicID+1] ~= nil then 
			print("RegistPacketFun error LogicID have fun  LogicID = " .. LogicID)
			return	
		end
		
	end
	
	TypeTable[LogicID+1] = Fun
end


require "Script/Network/packet/PacketRequire"
local function GetPacketFun( TypeID, LogicID )
	
	if TypeID ~= NET_MSG_TYPE_ID.TYPE_GS_C and TypeID ~= NET_MSG_TYPE_ID.TYPE_MS_C then 
		
		print("GetPacketFun TypeID Error : TypeID = " .. TypeID)
		return nil		
	end
	
	local key = "TYPE_" .. TypeID		
	
	local TypeTable = m_PacketInterFaceTable[key]	
	
	if TypeTable == nil then 
		
		print("GetPacketFun Error : TypeTable == nil " )
		return nil	
	end
	
	return TypeTable[LogicID+1]
	
end 

--解析包逻辑
function Excute( TypeID, LogicID, PacketData)
	
	local fun = GetPacketFun(TypeID,LogicID)
	print("TypeID " ..  TypeID)
	print("LogicID " ..  LogicID)
	if fun == nil then 	
		print("Excute error fun = nil ")
	else
		fun(PacketData)		
	end
	
end


