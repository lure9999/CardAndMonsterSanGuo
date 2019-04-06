module("server_NoticeCustomDB",package.seeall)

m_tabNoticeInfo = {}
local id = nil
local name = nil
function SetTableBuffer( buffer )
	m_tabNoticeInfo = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	id 			 = pNetStream:Read()
	name 	     = pNetStream:Read()
	m_tabNoticeInfo["id"] = id
	m_tabNoticeInfo["name"] = name
	m_tabNoticeInfo["nType"] = 1
	RefreshNotice()
	pNetStream = nil

end

function GetCopyTable(  )
    return copyTab(m_tabNoticeInfo)
end

function GetserverID(  )
	return id
end

function GetcopyInfo(  )
	return name
end

function GetPlayType( nIndex )
	require "Script/serverDB/announcement"
	local tab = announcement.getDataById(nIndex)
	return tab[2],tab[4]
end

function RefreshNotice(  )
	local tabNotice = GetCopyTable()
	local nid = tabNotice["id"]
	local nname = tabNotice["name"]

	-- require "Script/Main/NoticeBoard/NoticeScrollLayer"
	-- require "Script/Main/NoticeBoard/NoticeSTiplayer"
	-- require "Script/Main/Chat/ChatLayer"
	-- require "Script/Main/Chat/ChatShowLayer"

	local nType1,nType2 = GetPlayType(nid)
	if tonumber(nType1) == 1 then
		
		if tonumber(nType2) == 2 then
			tabNotice["is_type"] = 0
			local tabMess = NoticeScrollData.ChatSystemNotice(nil,nname,nil,nid,tabNotice["is_type"])
		    ChatLayer.LoadList(tabMess)
			ChatShowLayer.UpDateChatList(tabMess)
		elseif tonumber(nType2) == 3 then
			tabNotice["is_type"] = 0
			NoticeSTiplayer.GetNoticesDataStack(tabNotice)
		end
		tabNotice["is_type"] = 1
		NoticeScrollLayer.GetNoticeDataStack(tabNotice)
		
	elseif tonumber(nType1) == 3 then
		tabNotice["is_type"] = 1
		NoticeSTiplayer.GetNoticesDataStack(tabNotice)
	elseif tonumber(nType1) == 2 then
		tabNotice["is_type"] = 1
		local tabMess = NoticeScrollData.ChatSystemNotice(nil,nname,nil,nid,tabNotice["is_type"])
		
	    ChatLayer.LoadList(tabMess)
		
		ChatShowLayer.UpDateChatList(tabMess)

		if tonumber(nType2) == 3 then
			tabNotice["is_type"] = 0
			
			NoticeSTiplayer.GetNoticesDataStack(tabNotice)
		elseif tonumber(nType2) == 1 then
			tabNotice["is_type"] = 0
			NoticeScrollLayer.GetNoticeDataStack(tabNotice)
		end
		
		
	end


end

function release()
	m_tabNoticeInfo = nil
	package.loaded["server_NoticeCustomDB"] = nil
end