module("ArenaWarRecordLayer", package.seeall)




local g_model_record = nil
local g_listView_record = nil


--表示有多少条记录
local g_count_record = nil

local function initData()
	g_count_record = 10
end

--拷贝模板
local function copyModelRecord()
	local model_copy = g_model_record:clone()    
    local peer = tolua.getpeer(g_model_record)   
    tolua.setpeer(model_copy, peer)
    return model_copy
end

local function initUI()
	
	for i=0,g_count_record-1 do
		local l_model_reward = copyModelRecord()
		g_listView_record:pushBackCustomItem(l_model_reward)
	end
end
--参数说明，传入列表
function createArenaRecordLayer(l_listView)
	g_listView_record = l_listView
	g_model_record = GUIReader:shareReader():widgetFromJsonFile("Image/ArenWarRecord.json")
	initData()
	initUI()
end