-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_generalDB", package.seeall)

local m_tableGeneralDB = {}

local Server_Cmd = {
    Grid            = 1, 
    Info01          = 2,
    ItemID          = 3,
    Info02          = 4,
    Info03          = 5,
    Info04          = 6,
    Info05          = 7,
}

local Info01_Cmd = {Serial = 1, Server = 2, World = 3}
local Info02_Cmd = {
    MainStay        = 1, 
    GoOut           = 2, 
    TempID          = 3, 
    PoweType        = 4, 
    Quality         = 5, 
    HitDis          = 6, 
    Init_Lift       = 7, 
    Init_gongji     = 8, 
    Init_wufang     = 9,
    Init_fafang     = 10,
    Init_duoshan    = 11,
    Init_crit       = 12,
    Init_shipo      = 13,
    Init_anger      = 14,
    Init_engine     = 15,
    back_Lift       = 16,
    back_engine     = 17,
    add_gongji      = 18,
    add_fangyu      = 19,
    WuLi            = 20,
    ZhiLi           = 21,
    TiLi            = 22,
    Star            = 23,
    Colour          = 24,
    Turn            = 25,
    Lv              = 26,
    danyaoLv        = 27,
    danyaoindex     = 28,
}
local Info03_Cmd = {
    TalentID        = 1,
    HurtRatio       = 2,
    PyhDefRatio     = 3,
    MagicDefRatio   = 4,
    BloodRatio      = 5,
    DodgeRatio      = 6,
    FatalRatio      = 7,
    MagicDiscovery  = 8,
    HitRatio        = 9,
}
local Info04_Cmd = {
    ID                  = 1,
    ResID               = 2,
    Skill_hurt_type     = 3,
    Skill_power_type    = 4,
    Skill_site          = 5,
    Skill_type          = 6,
    Skill_paramete      = 7,
    Skill_ratio         = 8,
    Skill_timecd        = 9,
    Skill_anger_back    = 10,
    Skill_engine_back   = 11,
    Skill_dis           = 12,
    Skill_buff_times    = 13,
    Skill_buff_cd       = 14,
    Skill_buff_chance   = 15,
}
local Info05_Cmd = {
    fate_1              = 1,
    fate_2              = 2,
    fate_3              = 3,
    fate_4              = 4,
    fate_5              = 5,
}

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_tableGeneralDB = {}
    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()
    local list = pNetStream:Read()

    for key, value in pairs(list) do
        m_tableGeneralDB[key] = {}
        m_tableGeneralDB[key]["Grid"] = value[Server_Cmd.Grid]
        m_tableGeneralDB[key]["Info01"] = {}
        m_tableGeneralDB[key]["Info01"]["Serial"] = value[Server_Cmd.Info01][Info01_Cmd.Serial]
        m_tableGeneralDB[key]["Info01"]["Server"] = value[Server_Cmd.Info01][Info01_Cmd.Server]
        m_tableGeneralDB[key]["Info01"]["World"] = value[Server_Cmd.Info01][Info01_Cmd.World]
        m_tableGeneralDB[key]["ItemID"] = value[Server_Cmd.ItemID]

        m_tableGeneralDB[key]["Info02"] = {}
        m_tableGeneralDB[key]["Info02"]["MainStay"] = value[Server_Cmd.Info02][Info02_Cmd.MainStay]
        m_tableGeneralDB[key]["Info02"]["GoOut"] = value[Server_Cmd.Info02][Info02_Cmd.GoOut]
        m_tableGeneralDB[key]["Info02"]["TempID"] = value[Server_Cmd.Info02][Info02_Cmd.TempID]
        m_tableGeneralDB[key]["Info02"]["PoweType"] = value[Server_Cmd.Info02][Info02_Cmd.PoweType]
        m_tableGeneralDB[key]["Info02"]["Quality"] = value[Server_Cmd.Info02][Info02_Cmd.Quality]
        m_tableGeneralDB[key]["Info02"]["HitDis"] = value[Server_Cmd.Info02][Info02_Cmd.HitDis]
        m_tableGeneralDB[key]["Info02"]["Init_Lift"] = value[Server_Cmd.Info02][Info02_Cmd.Init_Lift]
        m_tableGeneralDB[key]["Info02"]["Init_gongji"] = value[Server_Cmd.Info02][Info02_Cmd.Init_gongji]
        m_tableGeneralDB[key]["Info02"]["Init_wufang"] = value[Server_Cmd.Info02][Info02_Cmd.Init_wufang]
        m_tableGeneralDB[key]["Info02"]["Init_fafang"] = value[Server_Cmd.Info02][Info02_Cmd.Init_fafang]
        m_tableGeneralDB[key]["Info02"]["Init_duoshan"] = value[Server_Cmd.Info02][Info02_Cmd.Init_duoshan]
        m_tableGeneralDB[key]["Info02"]["Init_crit"] = value[Server_Cmd.Info02][Info02_Cmd.Init_crit]
        m_tableGeneralDB[key]["Info02"]["Init_shipo"] = value[Server_Cmd.Info02][Info02_Cmd.Init_shipo]
        m_tableGeneralDB[key]["Info02"]["Init_anger"] = value[Server_Cmd.Info02][Info02_Cmd.Init_anger]
        m_tableGeneralDB[key]["Info02"]["Init_engine"] = value[Server_Cmd.Info02][Info02_Cmd.Init_engine]
        m_tableGeneralDB[key]["Info02"]["back_Lift"] = value[Server_Cmd.Info02][Info02_Cmd.back_Lift]
        m_tableGeneralDB[key]["Info02"]["back_engine"] = value[Server_Cmd.Info02][Info02_Cmd.back_engine]
        m_tableGeneralDB[key]["Info02"]["add_gongji"] = value[Server_Cmd.Info02][Info02_Cmd.add_gongji]
        m_tableGeneralDB[key]["Info02"]["add_fangyu"] = value[Server_Cmd.Info02][Info02_Cmd.add_fangyu]
        m_tableGeneralDB[key]["Info02"]["WuLi"] = value[Server_Cmd.Info02][Info02_Cmd.WuLi]
        m_tableGeneralDB[key]["Info02"]["ZhiLi"] = value[Server_Cmd.Info02][Info02_Cmd.ZhiLi]
        m_tableGeneralDB[key]["Info02"]["TiLi"] = value[Server_Cmd.Info02][Info02_Cmd.TiLi]
        m_tableGeneralDB[key]["Info02"]["Star"] = value[Server_Cmd.Info02][Info02_Cmd.Star]
        m_tableGeneralDB[key]["Info02"]["Colour"] = value[Server_Cmd.Info02][Info02_Cmd.Colour]
        m_tableGeneralDB[key]["Info02"]["Turn"] = value[Server_Cmd.Info02][Info02_Cmd.Turn]
        m_tableGeneralDB[key]["Info02"]["Lv"] = value[Server_Cmd.Info02][Info02_Cmd.Lv]
        m_tableGeneralDB[key]["Info02"]["danyaoLv"] = value[Server_Cmd.Info02][Info02_Cmd.danyaoLv]
        m_tableGeneralDB[key]["Info02"]["danyaoindex"] = value[Server_Cmd.Info02][Info02_Cmd.danyaoindex]

        m_tableGeneralDB[key]["Info03"] = {}
        m_tableGeneralDB[key]["Info03"]["TalentID"] = value[Server_Cmd.Info03][Info03_Cmd.TalentID]
        m_tableGeneralDB[key]["Info03"]["HurtRatio"] = value[Server_Cmd.Info03][Info03_Cmd.HurtRatio]
        m_tableGeneralDB[key]["Info03"]["PyhDefRatio"] = value[Server_Cmd.Info03][Info03_Cmd.PyhDefRatio]
        m_tableGeneralDB[key]["Info03"]["MagicDefRatio"] = value[Server_Cmd.Info03][Info03_Cmd.MagicDefRatio]
        m_tableGeneralDB[key]["Info03"]["BloodRatio"] = value[Server_Cmd.Info03][Info03_Cmd.BloodRatio]
        m_tableGeneralDB[key]["Info03"]["DodgeRatio"] = value[Server_Cmd.Info03][Info03_Cmd.DodgeRatio]
        m_tableGeneralDB[key]["Info03"]["FatalRatio"] = value[Server_Cmd.Info03][Info03_Cmd.FatalRatio]
        m_tableGeneralDB[key]["Info03"]["MagicDiscovery"] = value[Server_Cmd.Info03][Info03_Cmd.MagicDiscovery]
        m_tableGeneralDB[key]["Info03"]["HitRatio"] = value[Server_Cmd.Info03][Info03_Cmd.HitRatio]

        m_tableGeneralDB[key]["Info04"] = {}
        m_tableGeneralDB[key]["Info04"]["ID"] = value[Server_Cmd.Info04][Info04_Cmd.ID]
        m_tableGeneralDB[key]["Info04"]["ResID"] = value[Server_Cmd.Info04][Info04_Cmd.ResID]
        m_tableGeneralDB[key]["Info04"]["Skill_hurt_type"] = value[Server_Cmd.Info04][Info04_Cmd.Skill_hurt_type]
        m_tableGeneralDB[key]["Info04"]["Skill_power_type"] = value[Server_Cmd.Info04][Info04_Cmd.Skill_power_type]
        m_tableGeneralDB[key]["Info04"]["Skill_site"] = value[Server_Cmd.Info04][Info04_Cmd.Skill_site]
        m_tableGeneralDB[key]["Info04"]["Skill_type"] = value[Server_Cmd.Info04][Info04_Cmd.Skill_type]
        m_tableGeneralDB[key]["Info04"]["Skill_paramete"] = value[Server_Cmd.Info04][Info04_Cmd.Skill_paramete]
        m_tableGeneralDB[key]["Info04"]["Skill_ratio"] = value[Server_Cmd.Info04][Info04_Cmd.Skill_ratio]
        m_tableGeneralDB[key]["Info04"]["Skill_timecd"] = value[Server_Cmd.Info04][Info04_Cmd.Skill_timecd]
        m_tableGeneralDB[key]["Info04"]["Skill_anger_back"] = value[Server_Cmd.Info04][Info04_Cmd.Skill_anger_back]
        m_tableGeneralDB[key]["Info04"]["Skill_engine_back"] = value[Server_Cmd.Info04][Info04_Cmd.Skill_engine_back]
        m_tableGeneralDB[key]["Info04"]["Skill_dis"] = value[Server_Cmd.Info04][Info04_Cmd.Skill_dis]
        m_tableGeneralDB[key]["Info04"]["Skill_buff_times"] = value[Server_Cmd.Info04][Info04_Cmd.Skill_buff_times]
        m_tableGeneralDB[key]["Info04"]["Skill_buff_cd"] = value[Server_Cmd.Info04][Info04_Cmd.Skill_buff_cd]
        m_tableGeneralDB[key]["Info04"]["Skill_buff_chance"] = value[Server_Cmd.Info04][Info04_Cmd.Skill_buff_chance]

        m_tableGeneralDB[key]["Info05"] = {}
        m_tableGeneralDB[key]["Info05"]["fate_1"] = value[Server_Cmd.Info05][Info05_Cmd.fate_1]
        m_tableGeneralDB[key]["Info05"]["fate_2"] = value[Server_Cmd.Info05][Info05_Cmd.fate_2]
        m_tableGeneralDB[key]["Info05"]["fate_3"] = value[Server_Cmd.Info05][Info05_Cmd.fate_3]
        m_tableGeneralDB[key]["Info05"]["fate_4"] = value[Server_Cmd.Info05][Info05_Cmd.fate_4]
        m_tableGeneralDB[key]["Info05"]["fate_5"] = value[Server_Cmd.Info05][Info05_Cmd.fate_5]
    end

    pNetStream = nil
    -- print("m_tableGeneralDBm_tableGeneralDBm_tableGeneralDB")
    -- printTab(m_tableGeneralDB)
end

-- 更新数据
function UpdataTableBuffer(buffer)

    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()
    local list = pNetStream:Read()
    

    for key, value in pairs(list) do
        if GetTableByGrid(list[key][Server_Cmd.Grid]) ~= nil then
            UpdataNode(tonumber(list[key][Server_Cmd.Grid]), value)
        else
            AddNode(value)
        end
    end
end

-- 添加表数据，拼包时调用
function AddTableBuffer(buffer)
    local tableTemp = cjson.decode(buffer)

    for key, value in pairs(tableTemp) do
        AddNode(value)
    end
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
    return copyTab(m_tableGeneralDB)
end

-- 添加一个武将。
function AddNode(item)
    local tableGeneralTemp = {}

    tableGeneralTemp["Grid"] = item[Server_Cmd.Grid]
    tableGeneralTemp["Info01"] = {}
    tableGeneralTemp["Info01"]["Serial"] = item[Server_Cmd.Info01][Info01_Cmd.Serial]
    tableGeneralTemp["Info01"]["Server"] = item[Server_Cmd.Info01][Info01_Cmd.Server]
    tableGeneralTemp["Info01"]["World"] = item[Server_Cmd.Info01][Info01_Cmd.World]
    tableGeneralTemp["ItemID"] = item[Server_Cmd.ItemID]

    tableGeneralTemp["Info02"] = {}
    tableGeneralTemp["Info02"]["MainStay"] = item[Server_Cmd.Info02][Info02_Cmd.MainStay]
    tableGeneralTemp["Info02"]["GoOut"] = item[Server_Cmd.Info02][Info02_Cmd.GoOut]
    tableGeneralTemp["Info02"]["TempID"] = item[Server_Cmd.Info02][Info02_Cmd.TempID]
    tableGeneralTemp["Info02"]["PoweType"] = item[Server_Cmd.Info02][Info02_Cmd.PoweType]
    tableGeneralTemp["Info02"]["Quality"] = item[Server_Cmd.Info02][Info02_Cmd.Quality]
    tableGeneralTemp["Info02"]["HitDis"] = item[Server_Cmd.Info02][Info02_Cmd.HitDis]
    tableGeneralTemp["Info02"]["Init_Lift"] = item[Server_Cmd.Info02][Info02_Cmd.Init_Lift]
    tableGeneralTemp["Info02"]["Init_gongji"] = item[Server_Cmd.Info02][Info02_Cmd.Init_gongji]
    tableGeneralTemp["Info02"]["Init_wufang"] = item[Server_Cmd.Info02][Info02_Cmd.Init_wufang]
    tableGeneralTemp["Info02"]["Init_fafang"] = item[Server_Cmd.Info02][Info02_Cmd.Init_fafang]
    tableGeneralTemp["Info02"]["Init_duoshan"] = item[Server_Cmd.Info02][Info02_Cmd.Init_duoshan]
    tableGeneralTemp["Info02"]["Init_crit"] = item[Server_Cmd.Info02][Info02_Cmd.Init_crit]
    tableGeneralTemp["Info02"]["Init_shipo"] = item[Server_Cmd.Info02][Info02_Cmd.Init_shipo]
    tableGeneralTemp["Info02"]["Init_anger"] = item[Server_Cmd.Info02][Info02_Cmd.Init_anger]
    tableGeneralTemp["Info02"]["Init_engine"] = item[Server_Cmd.Info02][Info02_Cmd.Init_engine]
    tableGeneralTemp["Info02"]["back_Lift"] = item[Server_Cmd.Info02][Info02_Cmd.back_Lift]
    tableGeneralTemp["Info02"]["back_engine"] = item[Server_Cmd.Info02][Info02_Cmd.back_engine]
    tableGeneralTemp["Info02"]["add_gongji"] = item[Server_Cmd.Info02][Info02_Cmd.add_gongji]
    tableGeneralTemp["Info02"]["add_fangyu"] = item[Server_Cmd.Info02][Info02_Cmd.add_fangyu]
    tableGeneralTemp["Info02"]["WuLi"] = item[Server_Cmd.Info02][Info02_Cmd.WuLi]
    tableGeneralTemp["Info02"]["ZhiLi"] = item[Server_Cmd.Info02][Info02_Cmd.ZhiLi]
    tableGeneralTemp["Info02"]["TiLi"] = item[Server_Cmd.Info02][Info02_Cmd.TiLi]
    tableGeneralTemp["Info02"]["Star"] = item[Server_Cmd.Info02][Info02_Cmd.Star]
    tableGeneralTemp["Info02"]["Colour"] = item[Server_Cmd.Info02][Info02_Cmd.Colour]
    tableGeneralTemp["Info02"]["Turn"] = item[Server_Cmd.Info02][Info02_Cmd.Turn]
    tableGeneralTemp["Info02"]["Lv"] = item[Server_Cmd.Info02][Info02_Cmd.Lv]
    tableGeneralTemp["Info02"]["danyaoLv"] = item[Server_Cmd.Info02][Info02_Cmd.danyaoLv]
    tableGeneralTemp["Info02"]["danyaoindex"] = item[Server_Cmd.Info02][Info02_Cmd.danyaoindex]

    tableGeneralTemp["Info03"] = {}
    tableGeneralTemp["Info03"]["TalentID"] = item[Server_Cmd.Info03][Info03_Cmd.TalentID]
    tableGeneralTemp["Info03"]["HurtRatio"] = item[Server_Cmd.Info03][Info03_Cmd.HurtRatio]
    tableGeneralTemp["Info03"]["PyhDefRatio"] = item[Server_Cmd.Info03][Info03_Cmd.PyhDefRatio]
    tableGeneralTemp["Info03"]["MagicDefRatio"] = item[Server_Cmd.Info03][Info03_Cmd.MagicDefRatio]
    tableGeneralTemp["Info03"]["BloodRatio"] = item[Server_Cmd.Info03][Info03_Cmd.BloodRatio]
    tableGeneralTemp["Info03"]["DodgeRatio"] = item[Server_Cmd.Info03][Info03_Cmd.DodgeRatio]
    tableGeneralTemp["Info03"]["FatalRatio"] = item[Server_Cmd.Info03][Info03_Cmd.FatalRatio]
    tableGeneralTemp["Info03"]["MagicDiscovery"] = item[Server_Cmd.Info03][Info03_Cmd.MagicDiscovery]
    tableGeneralTemp["Info03"]["HitRatio"] = item[Server_Cmd.Info03][Info03_Cmd.HitRatio]

    tableGeneralTemp["Info04"] = {}
    tableGeneralTemp["Info04"]["ID"] = item[Server_Cmd.Info04][Info04_Cmd.ID]
    tableGeneralTemp["Info04"]["ResID"] = item[Server_Cmd.Info04][Info04_Cmd.ResID]
    tableGeneralTemp["Info04"]["Skill_hurt_type"] = item[Server_Cmd.Info04][Info04_Cmd.Skill_hurt_type]
    tableGeneralTemp["Info04"]["Skill_power_type"] = item[Server_Cmd.Info04][Info04_Cmd.Skill_power_type]
    tableGeneralTemp["Info04"]["Skill_site"] = item[Server_Cmd.Info04][Info04_Cmd.Skill_site]
    tableGeneralTemp["Info04"]["Skill_type"] = item[Server_Cmd.Info04][Info04_Cmd.Skill_type]
    tableGeneralTemp["Info04"]["Skill_paramete"] = item[Server_Cmd.Info04][Info04_Cmd.Skill_paramete]
    tableGeneralTemp["Info04"]["Skill_ratio"] = item[Server_Cmd.Info04][Info04_Cmd.Skill_ratio]
    tableGeneralTemp["Info04"]["Skill_timecd"] = item[Server_Cmd.Info04][Info04_Cmd.Skill_timecd]
    tableGeneralTemp["Info04"]["Skill_anger_back"] = item[Server_Cmd.Info04][Info04_Cmd.Skill_anger_back]
    tableGeneralTemp["Info04"]["Skill_engine_back"] = item[Server_Cmd.Info04][Info04_Cmd.Skill_engine_back]
    tableGeneralTemp["Info04"]["Skill_dis"] = item[Server_Cmd.Info04][Info04_Cmd.Skill_dis]
    tableGeneralTemp["Info04"]["Skill_buff_times"] = item[Server_Cmd.Info04][Info04_Cmd.Skill_buff_times]
    tableGeneralTemp["Info04"]["Skill_buff_cd"] = item[Server_Cmd.Info04][Info04_Cmd.Skill_buff_cd]
    tableGeneralTemp["Info04"]["Skill_buff_chance"] = item[Server_Cmd.Info04][Info04_Cmd.Skill_buff_chance]

    tableGeneralTemp["Info05"] = {}
    tableGeneralTemp["Info05"]["fate_1"] = item[Server_Cmd.Info05][Info05_Cmd.fate_1]
    tableGeneralTemp["Info05"]["fate_2"] = item[Server_Cmd.Info05][Info05_Cmd.fate_2]
    tableGeneralTemp["Info05"]["fate_3"] = item[Server_Cmd.Info05][Info05_Cmd.fate_3]
    tableGeneralTemp["Info05"]["fate_4"] = item[Server_Cmd.Info05][Info05_Cmd.fate_4]
    tableGeneralTemp["Info05"]["fate_5"] = item[Server_Cmd.Info05][Info05_Cmd.fate_5]
    table.insert(m_tableGeneralDB, tableGeneralTemp)
end

-- 删除一个武将。
function DeleteNodeByIndex(nIndex)
    table.remove(m_tableGeneralDB, nIndex)
end

-- 更新一个物品。
function UpdataNode(nGrid, item)
    local nIndex = 0

    for key, value in pairs(m_tableGeneralDB) do
        nIndex = nIndex + 1
        if value["Grid"] == nGrid then
            table.remove(m_tableGeneralDB, nIndex)

            local tableGeneralTemp = {}

            tableGeneralTemp["Grid"] = item[Server_Cmd.Grid]
            tableGeneralTemp["Info01"] = {}
            tableGeneralTemp["Info01"]["Serial"] = item[Server_Cmd.Info01][Info01_Cmd.Serial]
            tableGeneralTemp["Info01"]["Server"] = item[Server_Cmd.Info01][Info01_Cmd.Server]
            tableGeneralTemp["Info01"]["World"] = item[Server_Cmd.Info01][Info01_Cmd.World]
            tableGeneralTemp["ItemID"] = item[Server_Cmd.ItemID]

            tableGeneralTemp["Info02"] = {}
            tableGeneralTemp["Info02"]["MainStay"] = item[Server_Cmd.Info02][Info02_Cmd.MainStay]
            tableGeneralTemp["Info02"]["GoOut"] = item[Server_Cmd.Info02][Info02_Cmd.GoOut]
            tableGeneralTemp["Info02"]["TempID"] = item[Server_Cmd.Info02][Info02_Cmd.TempID]
            tableGeneralTemp["Info02"]["PoweType"] = item[Server_Cmd.Info02][Info02_Cmd.PoweType]
            tableGeneralTemp["Info02"]["Quality"] = item[Server_Cmd.Info02][Info02_Cmd.Quality]
            tableGeneralTemp["Info02"]["HitDis"] = item[Server_Cmd.Info02][Info02_Cmd.HitDis]
            tableGeneralTemp["Info02"]["Init_Lift"] = item[Server_Cmd.Info02][Info02_Cmd.Init_Lift]
            tableGeneralTemp["Info02"]["Init_gongji"] = item[Server_Cmd.Info02][Info02_Cmd.Init_gongji]
            tableGeneralTemp["Info02"]["Init_wufang"] = item[Server_Cmd.Info02][Info02_Cmd.Init_wufang]
            tableGeneralTemp["Info02"]["Init_fafang"] = item[Server_Cmd.Info02][Info02_Cmd.Init_fafang]
            tableGeneralTemp["Info02"]["Init_duoshan"] = item[Server_Cmd.Info02][Info02_Cmd.Init_duoshan]
            tableGeneralTemp["Info02"]["Init_crit"] = item[Server_Cmd.Info02][Info02_Cmd.Init_crit]
            tableGeneralTemp["Info02"]["Init_shipo"] = item[Server_Cmd.Info02][Info02_Cmd.Init_shipo]
            tableGeneralTemp["Info02"]["Init_anger"] = item[Server_Cmd.Info02][Info02_Cmd.Init_anger]
            tableGeneralTemp["Info02"]["Init_engine"] = item[Server_Cmd.Info02][Info02_Cmd.Init_engine]
            tableGeneralTemp["Info02"]["back_Lift"] = item[Server_Cmd.Info02][Info02_Cmd.back_Lift]
            tableGeneralTemp["Info02"]["back_engine"] = item[Server_Cmd.Info02][Info02_Cmd.back_engine]
            tableGeneralTemp["Info02"]["add_gongji"] = item[Server_Cmd.Info02][Info02_Cmd.add_gongji]
            tableGeneralTemp["Info02"]["add_fangyu"] = item[Server_Cmd.Info02][Info02_Cmd.add_fangyu]
            tableGeneralTemp["Info02"]["WuLi"] = item[Server_Cmd.Info02][Info02_Cmd.WuLi]
            tableGeneralTemp["Info02"]["ZhiLi"] = item[Server_Cmd.Info02][Info02_Cmd.ZhiLi]
            tableGeneralTemp["Info02"]["TiLi"] = item[Server_Cmd.Info02][Info02_Cmd.TiLi]
            tableGeneralTemp["Info02"]["Star"] = item[Server_Cmd.Info02][Info02_Cmd.Star]
            tableGeneralTemp["Info02"]["Colour"] = item[Server_Cmd.Info02][Info02_Cmd.Colour]
            tableGeneralTemp["Info02"]["Turn"] = item[Server_Cmd.Info02][Info02_Cmd.Turn]
            tableGeneralTemp["Info02"]["Lv"] = item[Server_Cmd.Info02][Info02_Cmd.Lv]
            tableGeneralTemp["Info02"]["danyaoLv"] = item[Server_Cmd.Info02][Info02_Cmd.danyaoLv]
            tableGeneralTemp["Info02"]["danyaoindex"] = item[Server_Cmd.Info02][Info02_Cmd.danyaoindex]

            tableGeneralTemp["Info03"] = {}
            tableGeneralTemp["Info03"]["TalentID"] = item[Server_Cmd.Info03][Info03_Cmd.TalentID]
            tableGeneralTemp["Info03"]["HurtRatio"] = item[Server_Cmd.Info03][Info03_Cmd.HurtRatio]
            tableGeneralTemp["Info03"]["PyhDefRatio"] = item[Server_Cmd.Info03][Info03_Cmd.PyhDefRatio]
            tableGeneralTemp["Info03"]["MagicDefRatio"] = item[Server_Cmd.Info03][Info03_Cmd.MagicDefRatio]
            tableGeneralTemp["Info03"]["BloodRatio"] = item[Server_Cmd.Info03][Info03_Cmd.BloodRatio]
            tableGeneralTemp["Info03"]["DodgeRatio"] = item[Server_Cmd.Info03][Info03_Cmd.DodgeRatio]
            tableGeneralTemp["Info03"]["FatalRatio"] = item[Server_Cmd.Info03][Info03_Cmd.FatalRatio]
            tableGeneralTemp["Info03"]["MagicDiscovery"] = item[Server_Cmd.Info03][Info03_Cmd.MagicDiscovery]
            tableGeneralTemp["Info03"]["HitRatio"] = item[Server_Cmd.Info03][Info03_Cmd.HitRatio]

            tableGeneralTemp["Info04"] = {}
            tableGeneralTemp["Info04"]["ID"] = item[Server_Cmd.Info04][Info04_Cmd.ID]
            tableGeneralTemp["Info04"]["ResID"] = item[Server_Cmd.Info04][Info04_Cmd.ResID]
            tableGeneralTemp["Info04"]["Skill_hurt_type"] = item[Server_Cmd.Info04][Info04_Cmd.Skill_hurt_type]
            tableGeneralTemp["Info04"]["Skill_power_type"] = item[Server_Cmd.Info04][Info04_Cmd.Skill_power_type]
            tableGeneralTemp["Info04"]["Skill_site"] = item[Server_Cmd.Info04][Info04_Cmd.Skill_site]
            tableGeneralTemp["Info04"]["Skill_type"] = item[Server_Cmd.Info04][Info04_Cmd.Skill_type]
            tableGeneralTemp["Info04"]["Skill_paramete"] = item[Server_Cmd.Info04][Info04_Cmd.Skill_paramete]
            tableGeneralTemp["Info04"]["Skill_ratio"] = item[Server_Cmd.Info04][Info04_Cmd.Skill_ratio]
            tableGeneralTemp["Info04"]["Skill_timecd"] = item[Server_Cmd.Info04][Info04_Cmd.Skill_timecd]
            tableGeneralTemp["Info04"]["Skill_anger_back"] = item[Server_Cmd.Info04][Info04_Cmd.Skill_anger_back]
            tableGeneralTemp["Info04"]["Skill_engine_back"] = item[Server_Cmd.Info04][Info04_Cmd.Skill_engine_back]
            tableGeneralTemp["Info04"]["Skill_dis"] = item[Server_Cmd.Info04][Info04_Cmd.Skill_dis]
            tableGeneralTemp["Info04"]["Skill_buff_times"] = item[Server_Cmd.Info04][Info04_Cmd.Skill_buff_times]
            tableGeneralTemp["Info04"]["Skill_buff_cd"] = item[Server_Cmd.Info04][Info04_Cmd.Skill_buff_cd]
            tableGeneralTemp["Info04"]["Skill_buff_chance"] = item[Server_Cmd.Info04][Info04_Cmd.Skill_buff_chance]

            tableGeneralTemp["Info05"] = {}
            tableGeneralTemp["Info05"]["fate_1"] = item[Server_Cmd.Info05][Info05_Cmd.fate_1]
            tableGeneralTemp["Info05"]["fate_2"] = item[Server_Cmd.Info05][Info05_Cmd.fate_2]
            tableGeneralTemp["Info05"]["fate_3"] = item[Server_Cmd.Info05][Info05_Cmd.fate_3]
            tableGeneralTemp["Info05"]["fate_4"] = item[Server_Cmd.Info05][Info05_Cmd.fate_4]
            tableGeneralTemp["Info05"]["fate_5"] = item[Server_Cmd.Info05][Info05_Cmd.fate_5]
            
            table.insert(m_tableGeneralDB, nIndex, tableGeneralTemp)
            return
        end
    end
end

-- 根据key返回一个表数据，也就是返回一个武将的数据
function GetTableByKey(key)
    return m_tableGeneralDB[key]
end

-- 根据Grid返回一个表数据，也就是返回一个武将的数据
function GetTableByGrid(nGrid)
    for key, value in pairs(m_tableGeneralDB) do
        if value["Grid"] == nGrid then
            return copyTab(value)
        end
    end
    return nil
end

-- 根据nTempId返回一个表数据，也就是返回一个武将的数据
function GetTableByTempId(nTempId)
    for key, value in pairs(m_tableGeneralDB) do
        if tonumber(value["ItemID"]) == tonumber(nTempId) then
            return copyTab(value)
        end
    end
    return nil
end


-- 根据Grid返回一个表数据，也就是返回一个武将的模版id
function GetTempIdByGrid(nGrid)
    for key, value in pairs(m_tableGeneralDB) do
        if value["Grid"] == nGrid then
            --return value["Info02"]["TempID"]
            return value["ItemID"]
            
        end
    end
    return nil
end

-- 根据武将模板ID获得武将格子
function GetGridByTempId(nTempId)
    for key, value in pairs(m_tableGeneralDB) do
        if value["ItemID"] == nTempId then
            return value["Grid"]
        end
    end
    return nil
end
--获得格子
function GetGridByIndex(nIndex)
	--[[print("m_tableGeneralDB:")
	printTab(m_tableGeneralDB)
	print("m_tableGeneralDB"..nIndex..":"..m_tableGeneralDB[nIndex]["Grid"])]]--
    return m_tableGeneralDB[nIndex]["Grid"]
end

-- 获得模版ID
function GetTempId(nIndex)
    --return m_tableGeneralDB[nIndex]["Info02"]["TempID"]
    return m_tableGeneralDB[nIndex]["ItemID"]

end
--检测是否有该武将
function GetIsHaveWJ(nTempId)
	--print("nTempId.."..nTempId)
	 for key, value in pairs(m_tableGeneralDB) do
        if tonumber(value["ItemID"]) == tonumber(nTempId) then
			--print("value.."..value["ItemID"])
            return true
        end
    end
    return false
end

function GetRelationSolidTab( nGrid )
    local tabGeneral = GetTableByGrid(nGrid)
    return tabGeneral["Info05"]
end

function GetRelationSolidValue ( tabSolidValue, nIndex )
    return tabSolidValue["fate_"..tostring(nIndex)][1]
end

--根据格子返回上阵信息
function GetGoOutByGrid(nGrid)
	return m_tableGeneralDB[nGrid]["Info02"]["GoOut"]
end
-- 是否是主将
function IsMainGeneral( nGrid )
   for key, value in pairs(m_tableGeneralDB) do
        if value["Grid"] == nGrid then
           -- printTab(value)
           if value["Info02"]["MainStay"]==1 then
               return true
            else
               return false
            end
        end
    end
    return false
end
function IsMainGeneralByTempID( tempID )
   for key, value in pairs(m_tableGeneralDB) do
        if tonumber(value["ItemID"]) == tempID then
           if value["Info02"]["MainStay"]==1 then
               return true
            else
               return false
            end
        end
    end
    return false
end
-- 获得数量
function GetCount()
    return table.getn(m_tableGeneralDB)
end

-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_tableGeneralDB = tTable
end

-- 删除。释放
function release()
    m_tableGeneralDB = nil
    package.loaded["server_generalDB"] = nil
end