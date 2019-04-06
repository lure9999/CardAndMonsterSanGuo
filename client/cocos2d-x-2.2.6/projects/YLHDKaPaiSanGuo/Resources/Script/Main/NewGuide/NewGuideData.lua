
--新手引导的数据celina
module("NewGuideData", package.seeall)



--获得当前没有完成的第一个步骤号
function GetCurServerProcess()
	local nGuide = server_mainDB.getMainData("Guide")
	local pArray = CCArray:create()
	IntTrans(tonumber(nGuide), 1, 1, pArray)
	local nCount = pArray:count()
	
	for i=(nCount-1), 0 , -1 do 
		local n_object = tolua.cast(pArray:objectAtIndex(i),"CCInteger")
		local n_objectNum = n_object:getValue()
		if tonumber(n_objectNum)==1 then
			return i+2
		end
	end
	return 1
end