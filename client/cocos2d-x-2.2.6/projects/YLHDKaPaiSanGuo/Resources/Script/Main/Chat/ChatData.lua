require "Script/serverDB/server_ChatDB"
require "Script/serverDB/server_mainDB"
require "Script/serverDB/globedefine"
require "Script/serverDB/item"
module("ChatData", package.seeall)


function GetChatListData()
	return server_ChatDB.GetCopyTable()
end

function GetUserName()
	return server_mainDB.getMainData("name")
end

function GetTypeChatMess(nTypeID)
	return server_ChatDB.GetTypeChatMess(nTypeID)
end

function GetGamerInfo()
	return server_GamerInfoDB.GetCopyTable()
end

function GetConsumInfo(  )
	local tab = globedefine.getDataById("WordChatCons")
	local cur_Tnum = server_itemDB.GetItemNumberByTempId(tonumber(tab[2]))
	return cur_Tnum,tab[1]
end

function GetConsumName( nItem )
	return item.getFieldByIdAndIndex(nItem,"name")
end

function GetConsumItem(  )
	return globedefine.getFieldByIdAndIndex("WordChatCons","Para_2")
end
