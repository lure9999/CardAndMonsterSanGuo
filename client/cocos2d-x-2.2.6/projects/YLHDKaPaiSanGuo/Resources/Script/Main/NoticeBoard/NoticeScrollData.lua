require "Script/serverDB/announcementquote"
require "Script/serverDB/announcement"
require "Script/serverDB/item"
require "Script/serverDB/point"
-- require "Script/serverDB/server_NoticeDB"
module("NoticeScrollData",package.seeall)

--从服务器获取公告ID
function GetServerNoticeID(  )
	return server_NoticeDB.GetserverID()
end

--获得公告触发表的信息
function GetNoticeTriggerData(  )
	return announcementquote.getTable()
end

--通过ID获取公告触发表信息
function GetNitoceTriByID( nIndex )
	-- local nID = GetServerNoticeID()
	local tab = {}
	local tabNoticeQuote = {}
	tab = announcementquote.getArrDataByField("AnnouncementID",nIndex)
	tabNoticeQuote["type"] = tab[1][1]
	tabNoticeQuote["para1"] = tab[1][2]
	tabNoticeQuote["AnnouncementID"] = tab[1][3]
	return tabNoticeQuote
end

--获取名字
function GetPointItemName( tab )
	
	local m_name = nil
	local tabPIT = {}
	-- tabPIT = GetNitoceTriByID(tab[""])
	if tonumber(tab["is_item"]) == 1 then
		m_name = point.getFieldByIdAndIndex(tab["typeID"],"Name")
	elseif tonumber(tab["is_item"]) == 2 then
		m_name = item.getFieldByIdAndIndex(tab["typeID"],"name")
	end
	return m_name
end

--得到公告信息表
function GetNoticeInfoData(  )
	return announcement.getTable()
end

--通过ID获取公告信息表
function GetNoticeInfoDataByID( nIndex )
	local tab = {}
	local tabInfo = {}
	tab = announcement.getDataById(nIndex)
	tabInfo["order"] = tab[1]
	tabInfo["mode1"] = tab[2]
	tabInfo["para1"] = tab[3]
	tabInfo["mode2"] = tab[4]
	tabInfo["para2"] = tab[5]
	tabInfo["text"]  = tab[6]
	return tabInfo
end

--获取公告类型
function GetNoticeType( nIndex )
	return announcement.getFieldByIdAndIndex(nIndex,"mode1")
end
--公告的所有类型
function GetNoticePlayType( nIndex )
	local tab = announcement.getDataById(nIndex)
	return tab[2],tab[4]
end

--获取公告文本
function GetNoticeInfoByID( nIndex )
	return announcement.getFieldByIdAndIndex(nIndex,"text")
end

function GetNoticeChatByID( nIndex )
	return announcement.getDataById(nIndex)
end

--获取登录游戏时的公告提示
function GetChatMessByID( nIndex )
	local txtTab = GetNoticeChatByID(nIndex)
	local strMesg = nil
	local cur_time = os.time()
	local m_tableChatDB = {}
	m_tableChatDB["ChannelID"]   =  txtTab[3]
    m_tableChatDB["SenderID"]    =  "141"
    m_tableChatDB["SenderName"]  =  ""
    m_tableChatDB["VIPLevel"]    =  0
    m_tableChatDB["Level"]       =  0
    m_tableChatDB["Time"]        =  cur_time
    m_tableChatDB["ResIMGID"]    =  "141"
    m_tableChatDB["Color"]       =  "|color|51,22,5||size|20|"
    m_tableChatDB["ChatMsg"]     =  txtTab[6]
    m_tableChatDB["ChatType"]     =  1
    m_tableChatDB["ColorType"]     =  1

    return m_tableChatDB
end

--获取公告方式参数
function GetNoticePara1ByID( nIndex )
	return announcement.getDataById(nIndex)
end

function  GetNoticeThingByID( nIndex )
	
end

--得到聊天提示信息
function ChatSystemNotice( tab,nName,m_name,n_ID,n_Type)
	local strMesg = nil
	local cur_time = os.time()
	local m_tableChatDB = {}
	local tabDB = GetNoticeInfoDataByID(n_ID)
	if tab ~= nil then
		-- strMesg = string.format(tab["text"],nName,m_name)
		strMesg = nName
		if tonumber(n_Type) == 1 then
			m_tableChatDB["ChannelID"]   =  tab["para1"]
		else
			m_tableChatDB["ChannelID"]   =  tab["para2"]
		end
	else
		strMesg = nName
		if tonumber(n_Type) == 1 then
			m_tableChatDB["ChannelID"]   =  tabDB["para1"]
		else
			m_tableChatDB["ChannelID"]   =  tabDB["para2"]
		end
	end

	--[[if tonumber(n_ID) == 1000 then
		m_tableChatDB["ChannelID"]   =  "0"
	end]]--


    m_tableChatDB["SenderID"]    =  "141"
    m_tableChatDB["SenderName"]  =  ""
    m_tableChatDB["VIPLevel"]    =  0
    m_tableChatDB["Level"]       =  0
    m_tableChatDB["Time"]        =  cur_time
    m_tableChatDB["ResIMGID"]    =  "141"
    m_tableChatDB["Color"]       =  0
    m_tableChatDB["ChatMsg"]     =  strMesg
    m_tableChatDB["ChatType"]     =  0
    m_tableChatDB["ColorType"]     =  1
    return m_tableChatDB
end



