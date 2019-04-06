module("NoticeScrollLogic",package.seeall)
require "Script/Main/NoticeBoard/NoticeScrollData"
require "Script/Main/Corps/CorpsScene"
require "Script/Main/CountryWar/CountryUILayer"
local GetNoticeType = NoticeScrollData.GetNoticeType
local GetNoticePara1ByID = NoticeScrollData.GetNoticePara1ByID

--获得聊天频道
local function GetChatNoticeType( nPara )
	local ChatType = nil
	if tonumber(nPara) == 1 then -- 世界频道
		ChatType = 1
	elseif tonumber(nPara) == 2 then -- 军团频道
		ChatType = 2
	elseif tonumber(nPara) == 3 then -- 国家频道
		ChatType = 3
	elseif tonumber(nPara) == 4 then -- 私聊频道
		ChatType = 4
	end
	return ChatType
end

--获得加载的场景
function GetSceneByTypeAndID( tabNotice )
	local tab = GetNoticePara1ByID(tabNotice["id"])
	local n_Para = nil
	if tonumber(tabNotice["is_type"]) == 1 then
		n_Para = tab[3]
	else
		n_Para = tab[5]
	end
	local m_scene = nil
	if tonumber(n_Para) == 0 then -- 全部场景
		
		m_scene =  CCDirector:sharedDirector():getRunningScene()
		print("全部场景")
	elseif tonumber(n_Para) == 1 then -- 国战场景
		m_scene =  CountryUILayer.GetControlUI()
		print("国战场景")
	elseif tonumber(n_Para) == 2 then -- 军团场景
		m_scene = CorpsScene.GetPScene()
		print("军团场景")
	elseif tonumber(n_Para) == 3 then -- 主场景
		m_scene = MainScene.GetControlUI()
		print("主场景")
	elseif tonumber(n_Para) == 4 then
		m_scene = CCDirector:sharedDirector():getRunningScene()
	end
	return m_scene
end

function GetTipTypeAndID( tabNotice )
	local tab = GetNoticePara1ByID(tabNotice["id"])
	local n_Para = nil
	if tonumber(tabNotice["is_type"]) == 1 then
		n_Para = tab[3]
	else
		n_Para = tab[5]
	end
	local m_scene = nil
	if tonumber(n_Para) == 0 then -- 全部场景
		m_scene =  CCDirector:sharedDirector():getRunningScene()
		print("全部场景")
	elseif tonumber(n_Para) == 1 then -- 国战场景
		print("国战场景")
		m_scene =  CountryUILayer.GetControlUI()
	elseif tonumber(n_Para) == 2 then -- 军团场景
		m_scene = CorpsScene.GetPScene()
		print("军团场景")
	elseif tonumber(n_Para) == 3 then -- 主场景
		m_scene = MainScene.GetControlUI()
		print("主场景")
	elseif tonumber(n_Para) == 4 then
		m_scene = CCDirector:sharedDirector():getRunningScene()
	end
	return m_scene
end