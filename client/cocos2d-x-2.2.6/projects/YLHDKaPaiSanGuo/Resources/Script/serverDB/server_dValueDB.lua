module("server_dValueDB",package.seeall)

local m_tabGetInfo = {}
function SetTableBuffer( buffer )
	print(buffer)
	-- Pause()
	m_tabGetInfo = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	m_tabGetInfo[1] = pNetStream:Read()  -- 统御 ["m_nTiLi"]
	m_tabGetInfo[2] = pNetStream:Read()  -- 武力 ["m_nWuLi"]
	m_tabGetInfo[3] = pNetStream:Read() -- 智力 ["m_nZhiLi"]
	m_tabGetInfo[11] = pNetStream:Read() -- 穿透 ["m_n_add_gongji"]
	m_tabGetInfo[8] = pNetStream:Read() -- 法防 ["m_Init_fafang"]
	m_tabGetInfo[4] = pNetStream:Read() -- 生命 ["m_Init_life"]
	m_tabGetInfo[9] = pNetStream:Read() -- 闪避 ["m_Init_duoshan"]
	m_tabGetInfo[5] = pNetStream:Read() -- 攻击 ["m_Init_gongji"]
	m_tabGetInfo[10] = pNetStream:Read() -- 识破 ["m_Init_shipo"]
	m_tabGetInfo[6] = pNetStream:Read() -- 暴击 ["m_Init_crit"]
	m_tabGetInfo[12] = pNetStream:Read() -- 免伤 ["m_add_fangyu"]
	m_tabGetInfo[7] = pNetStream:Read() -- 物防 ["m_Init_wufang"]
	pNetStream = nil
	Attribute_D_Value(m_tabGetInfo)

end

function GetCopyTable(  )
    return copyTab(m_tabGetInfo)
end

function SortDataFromPriority( pData, SortWay )
	local function sortAsxType( a,b )
		if SortWay == true then
			return tonumber(a.nPriority) > tonumber(b.nPriority)
		else
			return tonumber(a.nPriority) < tonumber(b.nPriority)
		end
	end
	table.sort( pData, sortAsxType )
	return pData
end

function Attribute_D_Value( m_tabInfo )
	local tabAdd = {}
	local tabSub = {}
	local i = 1
	local j = 1
	for key,value in pairs(m_tabInfo) do
		
		if tonumber(value) > 0 then
			
			tabAdd[i] = {}
			-- tabAdd[key][key] = value
			table.insert(tabAdd[i],key)
			table.insert(tabAdd[i],value)
			i = i + 1
		elseif tonumber(value) < 0 then
			
			tabSub[j] = {}
			table.insert(tabSub[j],key)
			table.insert(tabSub[j],value)
			j = j + 1
		end
	end
	JieXi(tabAdd,tabSub)
end

function GetNameByID( nID )
	local n_name = nil
	if tonumber(nID) == 1 then
		n_name = "统御"
	elseif tonumber(nID) == 2 then
		n_name = "武力"
	elseif tonumber(nID) == 3 then
		n_name = "智力"
	elseif tonumber(nID) == 4 then
		n_name = "生命"
	elseif tonumber(nID) == 5 then
		n_name = "攻击"
	elseif tonumber(nID) == 6 then
		n_name = "暴击"
	elseif tonumber(nID) == 7 then
		n_name = "物防"
	elseif tonumber(nID) == 8 then
		n_name = "法防"
	elseif tonumber(nID) == 9 then
		n_name = "闪避"
	elseif tonumber(nID) == 10 then
		n_name = "识破"
	elseif tonumber(nID) == 11 then
		n_name = "穿透"
	elseif tonumber(nID) == 12 then
		n_name = "免伤"
	end
	return n_name
end

function JieXi( tableAdd,tableSub )
	local tabAddInfo = {}
	local tabSubInfo = {}
	local tabTotalInfo = {}
	for key,value in pairs(tableAdd) do
		tabAddInfo[key] = {}
		tabAddInfo[key]["nPriority"] = value[1]
		tabAddInfo[key]["nPriorityValue"] = value[2]
	end
	for key,value in pairs(tableSub) do
		tabSubInfo[key] = {}
		tabSubInfo[key]["nPriority"] = value[1]
		tabSubInfo[key]["nPriorityValue"] = value[2]
	end
	local tabSortAdd = SortDataFromPriority(tabAddInfo,true)
	local tabSortSub = SortDataFromPriority(tabSubInfo,true)
	AddTotalTab(tabSortAdd,tabSortSub)
end

function AddTotalTab( tabSortAdd,tabSortSub )
	local tabTotalInfo = {}
	local num_key = 1
	for key,value in pairs(tabSortAdd) do
		tabTotalInfo[num_key] = value
		num_key = num_key + 1
	end
	for key,value in pairs(tabSortSub) do
		tabTotalInfo[num_key] = value
		num_key = num_key + 1
	end
	UpdateTopText(tabTotalInfo)
end

function UpdateTopText( tabTotalInfo )
	local visible_Size = CCDirector:sharedDirector():getVisibleSize()
	local scene = CCDirector:sharedDirector():getRunningScene()
	if next(tabTotalInfo) ~= nil then
		local num_i = #tabTotalInfo
		for i=1,#tabTotalInfo do
			local n_name = GetNameByID(tabTotalInfo[i]["nPriority"])
			local n_nameStr = n_name
			if tonumber(tabTotalInfo[i]["nPriorityValue"]) > 0 then
				n_nameStr = n_nameStr.."+"
			elseif tonumber(tabTotalInfo[i]["nPriorityValue"]) < 0 then
				n_nameStr = n_nameStr
			end
			TipLayer.createPopTipLayerValue( n_nameStr..tabTotalInfo[i]["nPriorityValue"] , 32, 
				COLOR_Green, ccp(visible_Size.width/2-100, visible_Size.height/2+num_i*25 - i*30),1.5,300,true,true,tabTotalInfo[i]["nPriorityValue"])
		end --

	end
end

function UpdatePopTip( tabSortAdd, tabSortSub)
	local visible_Size = CCDirector:sharedDirector():getVisibleSize()
	
	local scene = CCDirector:sharedDirector():getRunningScene()
	local arrayItem = CCArray:create()
	local function AddObjectArrtr(  )
		if next(tabSortAdd) ~= nil then
			local num_i = #tabSortAdd
			for i=1,#tabSortAdd do
				local n_name = GetNameByID(tabSortAdd[i]["nPriority"])
				local n_nameStr = n_name
				if tonumber(tabSortAdd[i]["nPriorityValue"]) > 0 then
					n_nameStr = n_nameStr.."+"
				elseif tonumber(tabSortAdd[i]["nPriorityValue"]) < 0 then
					n_nameStr = n_nameStr
				end
				TipLayer.createPopTipLayerValue( n_nameStr..tabSortAdd[i]["nPriorityValue"] , 32, 
					COLOR_Green, ccp(visible_Size.width/2, visible_Size.height/2+num_i*30 - i*30),2,visible_Size.height/2-50,true,true,tabSortAdd[i]["nPriorityValue"])
			end

			--[[local num_i = 1
			local function addAttr(  )
				local arrayItem = CCArray:create()
				local function _CallBack_(  )
					if #tabSortAdd > 0 then
						local n_name = GetNameByID(tabSortAdd[num_i]["nPriority"])
						local n_nameStr = n_name
						if tonumber(tabSortAdd[num_i]["nPriorityValue"]) > 0 then
							n_nameStr = n_nameStr.."+"
						elseif tonumber(tabSortAdd[num_i]["nPriorityValue"]) < 0 then
							n_nameStr = n_nameStr
						end
						TipLayer.createPopTipLayerValue(n_nameStr..tabSortAdd[num_i]["nPriorityValue"] , 32, 
						COLOR_Green, ccp(visible_Size.width/2, visible_Size.height/2 ),3,visible_Size.height-50,false,true,tabSortAdd[num_i]["nPriorityValue"])
						table.remove(tabSortAdd,num_i)
						
						addAttr()
					end

				end
				arrayItem:addObject(CCDelayTime:create(1))
				arrayItem:addObject(CCCallFunc:create(_CallBack_))
				
				scene:runAction(CCSequence:create(arrayItem))
			end
			addAttr()]]--
			

		end
	end
	local function SubObjectAttr(  )
		if next(tabSortSub) ~= nil then
			local num_i = #tabSortSub
			for i=1,#tabSortSub do
				local n_name = GetNameByID(tabSortSub[i]["nPriority"])
				local n_nameStr = n_name
				if tonumber(tabSortSub[i]["nPriorityValue"]) > 0 then
					n_nameStr = n_nameStr.."+"
				elseif tonumber(tabSortSub[i]["nPriorityValue"]) < 0 then
					n_nameStr = n_nameStr
				end
				TipLayer.createPopTipLayerValue( n_nameStr..tabSortSub[i]["nPriorityValue"] , 32, 
					COLOR_Green, ccp(visible_Size.width/2, visible_Size.height/2-num_i*20-20 + i*30),2,-visible_Size.height/2+50,true,true,tabSortSub[i]["nPriorityValue"])
			end
			--[[local num_i = 1
			local function SubAttr(  )
				local arrayItem = CCArray:create()
				local function _CallBack_(  )
					if #tabSortSub > 0 then
						local n_name = GetNameByID(tabSortSub[num_i]["nPriority"])
						local n_nameStr = n_name
						if tonumber(tabSortSub[num_i]["nPriorityValue"]) > 0 then
							n_nameStr = n_nameStr.."+"
						elseif tonumber(tabSortSub[num_i]["nPriorityValue"]) < 0 then
							n_nameStr = n_nameStr
						end
						TipLayer.createPopTipLayerValue(n_nameStr..tabSortSub[num_i]["nPriorityValue"] , 32, 
						COLOR_Green, ccp(visible_Size.width/2, visible_Size.height/2-30 ),3,visible_Size.height-50,false,true,tabSortSub[num_i]["nPriorityValue"])
						table.remove(tabSortSub,num_i)
						SubAttr()
					end

				end
				arrayItem:addObject(CCDelayTime:create(1))
				arrayItem:addObject(CCCallFunc:create(_CallBack_))

				scene:runAction(CCSequence:create(arrayItem))
			end
			
			SubAttr()]]--
		end
	end
	arrayItem:addObject(CCCallFunc:create(AddObjectArrtr))
	arrayItem:addObject(CCDelayTime:create(0.5))
	arrayItem:addObject(CCCallFunc:create(SubObjectAttr))

	scene:runAction(CCSequence:create(arrayItem))
	
end

function release()
	m_tabGetInfo = nil
	package.loaded["server_dValueDB"] = nil
end