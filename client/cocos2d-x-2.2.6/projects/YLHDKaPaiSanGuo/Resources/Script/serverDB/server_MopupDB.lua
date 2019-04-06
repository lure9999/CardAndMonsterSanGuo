module("server_MopupDB", package.seeall)

local m_tabMopupDB = {}

local Server_Cmd = {
					Reward = 1,
					MonsterDrop = 2,
					}

local Monster_Cmd = {
					Item = 1,
					}

local Reward_Cmd = {
					Money = 1,
					Item = 2,
					}

local Money_Cmd = {
					MoneyType = 1,
					MoneyNum = 2,
					}

local Item_Cmd = {
					ItemId = 1,
					ItemNum = 2,
				}

local function FixItemNum(tableTemp)
	local tableRe = {}
	local nCount = 1
	for i = 1, #tableTemp do
		local nId = tableTemp[i].Id
		local nNumber = tableTemp[i].Number

		for j = i, #tableTemp do
			if j ~= i and tableTemp[i].Id == tableTemp[j].Id then
				nId = tableTemp[i].Id
				nNumber = nNumber + tableTemp[j].Number
				tableTemp[j].Number = 0
			end
		end

		if nNumber ~= 0 then
			table.insert(tableRe,  {["Id"] = nId, ["Number"] = nNumber,})
		end
	end
	return tableRe
end

function SetTableBuffer(pBuffer)
    local pNetStream = NetStream()
    pNetStream:SetPacket(pBuffer)
    local nState  = pNetStream:Read()
    local nResult = pNetStream:Read()
    local nTimes = pNetStream:Read()
    local tabData = pNetStream:Read()

    local tabTemp = {}
    for k, v in pairs(tabData) do
    	tabTemp[k] = {}

    	tabTemp[k]["Money"] = {}
    	for k1, v1 in pairs(v[Server_Cmd.Reward][Reward_Cmd.Money]) do
    		tabTemp[k]["Money"][k1] = {}
    		tabTemp[k]["Money"][k1]["Type"] = v1[Money_Cmd.MoneyType]
    		tabTemp[k]["Money"][k1]["Number"] = v1[Money_Cmd.MoneyNum]
    	end

    	tabTemp[k]["Item"] = {}
    	local nIndex = 1
    	for k1, v1 in pairs(v[Server_Cmd.Reward][Reward_Cmd.Item]) do
    		tabTemp[k]["Item"][nIndex] = {}
    		tabTemp[k]["Item"][nIndex]["Id"] = v1[Item_Cmd.ItemId]
    		tabTemp[k]["Item"][nIndex]["Number"] = v1[Item_Cmd.ItemNum]
    		nIndex = nIndex+1
    	end

    	if next(v[Server_Cmd.MonsterDrop])~=nil then
    		for k1, v1 in pairs(v[Server_Cmd.MonsterDrop]) do
    			if next(v1)~=nil then
		    		tabTemp[k]["Item"][nIndex] = {}
		    		tabTemp[k]["Item"][nIndex]["Id"] = v1[Monster_Cmd.Item][Item_Cmd.ItemId]
		    		tabTemp[k]["Item"][nIndex]["Number"] = v1[Monster_Cmd.Item][Item_Cmd.ItemNum]
		    		nIndex = nIndex + 1
		    	end
	    	end
    	end
    end

    -- 过滤相同物品
    m_tabMopupDB = {}
    for k, v in pairs(tabTemp) do
    	m_tabMopupDB[k] = {}
    	m_tabMopupDB[k]["Money"] = v["Money"]
    	m_tabMopupDB[k]["Item"] = FixItemNum(v["Item"])
    end

    -- printTab(m_tabMopupDB)
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
    return copyTab(m_tabMopupDB)
end