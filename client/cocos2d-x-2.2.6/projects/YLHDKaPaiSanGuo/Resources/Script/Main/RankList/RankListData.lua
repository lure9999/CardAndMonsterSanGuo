require "Script/serverDB/server_rankDB"
require "Script/serverDB/arena"
module("RankListData", package.seeall)

function GetRankData( )
	return server_rankDB.GetCopyTable()
end

function GetMainRank( )
	local data = server_rankDB.GetCopyTable()
	return data.Ranking
end

function GetRankMatrix( )
	return server_rankMatrixDB.GetCopyTable()
end

function GetMatrixIconByResId( nResId )
	if nResId>-1 then
		return resimg.getFieldByIdAndIndex(nResId, "icon_path")
	else
		return nil
	end
end

function GetGeneralColourByTempId( nTmpID )
	return general.getFieldByIdAndIndex(nTmpID, "Colour")
end

function GetRankNameByID( nID )
	local tabTotal = {}
	for i=1,29 do
		local tab = arena.getDataById(i)
		table.insert(tabTotal,tab)
	end
	return tabTotal
end
