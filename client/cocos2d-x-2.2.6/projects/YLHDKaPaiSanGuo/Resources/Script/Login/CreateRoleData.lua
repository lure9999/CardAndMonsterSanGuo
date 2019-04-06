

require "Script/DB/AnimationData"
require "Script/serverDB/txt"
require "Script/serverDB/globedefine"
module("CreateRoleData", package.seeall)


function GetResID(nID)
	local ResID = general.getFieldByIdAndIndex(nID, "ResID")
	return ResID
end

function GetRoleAnimationFileName(id)
	return AnimationData.getFieldByIdAndIndex(GetResID(id),"AnimationfileName")
end
function GetRoleAnimationName(id)
	return AnimationData.getFieldByIdAndIndex(GetResID(id),"AnimationName")
end
function GetPersonInfo(nSexID)
	--[[print(nSexID)
	Pause()]]--
	local nTxtID = globedefine.getFieldByIdAndIndex("RoleDesc","Para_"..nSexID)
	local strInfo = txt.getFieldByIdAndIndex(nTxtID,"Txt")
	local n1 = string.find(strInfo,"\n")
	--暂时先写死解两个\n
	local tableInfo = {}
	if n1~=nil then
		table.insert(tableInfo,string.sub(strInfo,0,n1))
		local newStr = string.sub(strInfo,n1+1,string.len(strInfo))
		local n2 = string.find(newStr,"\n")
		if n2~=nil then
			table.insert(tableInfo,string.sub(newStr,0,n2))
		end
		local newStr3 = string.sub(newStr,n2+1,string.len(newStr))
		local n3 = string.find(newStr3,"\n")
		if n3== nil then
			table.insert(tableInfo,newStr3)
		end
	end
	return tableInfo
end