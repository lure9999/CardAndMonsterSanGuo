require "Script/Common/Common"
require "Script/Audio/AudioUtil"
require "Script/serverDB/general"
require "Script/Common/CommonData"
require "Script/serverDB/server_equipDB"


module("MatrixWujiangListLogic", package.seeall)
local TipLayer_createTimeLayer = TipLayer.createTimeLayer


function GetWujiangTableByType( nType, nPos)
	local WujiangTable = {}
	local nTempID = nil
	local nGeneralType = nil
	local nWujiangTableTemp = server_generalDB.GetCopyTable()
	--printTab(nWujiangTableTemp)
	for key, value in pairs(nWujiangTableTemp) do
		nTempID = value["ItemID"]
		nGeneralType = tonumber(general.getFieldByIdAndIndex(nTempID, "Type"))
		if nType==nGeneralType then
			if server_matrixDB.IsShangZhen(value["Grid"]) == true and value["Grid"] ~= m_curWuGrid then
				print("已上阵")
			else
				if nPos==GeneralPos.All then
					table.insert(WujiangTable, value["Grid"])
				else
					if nPos==tonumber(general.getFieldByIdAndIndex(value["ItemID"], "Pos")) then
						table.insert(WujiangTable, value["Grid"])
					end
				end
			end
		end
	end
	return WujiangTable
end

function CheckSelectWuJiang(nWuGrid)
   
    local tmpGeneralTab = server_generalDB.GetTableByGrid(nWuGrid)
    if tmpGeneralTab ~= nil and tonumber(tmpGeneralTab["Info02"]["MainStay"])==1 then
        TipLayer_createTimeLayer("主将不能下阵", 2) 
        return false
    end

   return true

end


--距离排序服务器做了
--[[
function DisSort()
	-- 按攻击距离排序
	local tableNew = {}
	local tableNone = {}
	local bGridCheng = false
    require "Script/serverDB/general"

    local nG_Count = 0
    local nE_Count = 1

    local tableOld = server_matrixDB.GetCopyTable()

	for j = 1, 5 do
		local nWjGrid = tableOld[j]["Info01"]["generalgrid"]
		if tonumber(nWjGrid) > 0 then
			nG_Count = nG_Count + 1
		end
	end

	for j = 1, 5 do
		local tableMaxDix = nil
		local nMaxDis = -1
		local nIndex = 0
		for i = 1, 5 do
			if tableOld[i] ~= nil then
				if tableOld[i]["Grid"] ~= 6 then
			    	local nWjGrid = tableOld[i]["Info01"]["generalgrid"]
			    	local tableGeneralTemp = server_generalDB.GetTableByGrid(nWjGrid)
			    	if tableGeneralTemp ~= nil then
				        --local nTempId = tableGeneralTemp["Info02"]["TempID"]
				        local nTempId = tableGeneralTemp["ItemID"]

				        local dis = general.getFieldByIdAndIndex(nTempId, "dis")
				        if tonumber(dis) >= nMaxDis then
				        	tableMaxDix = tableOld[i]
				        	nIndex = i
				        	nMaxDis = tonumber(dis)
				        end
				    else
                        if tonumber(nWjGrid) == -1 and tableMaxDix == nil then
                            tableMaxDix = tableOld[i]
                            nIndex = i
                        else
					    	tableNone = tableOld[i]
	                        if tableMaxDix == nil then
	                            nIndex = i
	                        end
                        end
			    	end
			    end
			end
		end

		if tableMaxDix ~= nil then

			if nG_Count == 0 then
				tableMaxDix["Grid"] = nE_Count
				tableNew[nE_Count] = copyTab(tableMaxDix)
			else
				tableMaxDix["Grid"] = 6 - nG_Count
				tableNew[6 - nG_Count] = copyTab(tableMaxDix)
			end

			table.remove(tableOld, nIndex)
		else

			if nG_Count == 0 then
				tableNone["Grid"] = nE_Count
				tableNew[nE_Count] = copyTab(tableNone)
			else
				tableNone["Grid"] = 6 - nG_Count
				tableNew[6 - nG_Count] = copyTab(tableNone)
			end

			table.remove(tableOld, nIndex)
		end

		if nG_Count ~= 0 then
			nG_Count = nG_Count - 1
		else
			nE_Count = nE_Count + 1
		end
	end

	for k,v in pairs(tableOld) do
		if v["Grid"] == 6 then
			table.insert(tableNew, 6, v)
		end
		
		if v["Info01"]["generalgrid"] == m_curWuGrid then
			m_nCurGrid = v["Grid"]
		end
	end
	
	for k,v in pairs(tableNew) do
		if v["Info01"]["generalgrid"] == m_curWuGrid then
			m_nCurGrid = v["Grid"]
		end
	end

	tableOld = tableNew

	require "Script/serverDB/server_matrixDB"
	server_matrixDB.SetTable(tableOld)

end
--]]