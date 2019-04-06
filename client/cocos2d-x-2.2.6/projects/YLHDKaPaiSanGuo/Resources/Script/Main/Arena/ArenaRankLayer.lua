module("ArenaRankLayer", package.seeall)

local m_lyArenaRecorder = nil
local m_lvTempRank = nil

local function CreateRankListWidget(  )
	local RankWidget = m_lvTempRank:clone()    
    local peer = tolua.getpeer(m_lvTempRank)   
    tolua.setpeer(RankWidget, peer)
    return RankWidget
end

local function CreataRankList(pListView)
	for i=1,10 do
		pListView:pushBackCustomItem(CreateRankListWidget(  ))
	end
end

function createArenaRankLayer( pListView )

	m_lvTempRank = GUIReader:shareReader():widgetFromJsonFile("Image/ArenRankTemp.json")

	CreataRankList(pListView)
end