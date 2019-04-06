-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("countryarmy", package.seeall)


keys = {
	"﻿ArmyID", "RobotType", "ArmyLv", "ArmyName", "ArmyTitle", "AIGroupID", "AILuaName", "DropOdds", "RewardType", "RewardPara", "BornState", 
}

countryarmyTable = {
    id_10101 = {"20101", "10", "魏国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_10102 = {"20102", "20", "魏国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_10103 = {"20103", "30", "魏国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_10104 = {"20104", "40", "魏国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_10105 = {"20105", "50", "魏国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_10106 = {"20106", "60", "魏国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_10107 = {"20107", "70", "魏国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_10108 = {"20108", "80", "魏国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_10109 = {"20109", "90", "魏国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_10110 = {"20110", "100", "魏国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_10201 = {"20111", "10", "魏国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_10202 = {"20112", "20", "魏国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_10203 = {"20113", "30", "魏国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_10204 = {"20114", "40", "魏国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_10205 = {"20115", "50", "魏国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_10206 = {"20116", "60", "魏国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_10207 = {"20117", "70", "魏国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_10208 = {"20118", "80", "魏国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_10209 = {"20119", "90", "魏国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_10210 = {"20120", "100", "魏国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_10301 = {"21101", "10", "魏国远征军", "守军", "0", "0", "100", "1", "3200", "1", },
    id_10302 = {"21102", "20", "魏国远征军", "守军", "0", "0", "100", "1", "3201", "1", },
    id_10303 = {"21103", "30", "魏国远征军", "守军", "0", "0", "100", "1", "3202", "1", },
    id_10304 = {"21104", "40", "魏国远征军", "守军", "0", "0", "100", "1", "3203", "1", },
    id_10305 = {"21105", "50", "魏国远征军", "守军", "0", "0", "100", "1", "3204", "1", },
    id_10306 = {"21106", "60", "魏国远征军", "守军", "0", "0", "100", "1", "3205", "1", },
    id_10307 = {"21107", "70", "魏国远征军", "守军", "0", "0", "100", "1", "3206", "1", },
    id_10308 = {"21108", "80", "魏国远征军", "守军", "0", "0", "100", "1", "3207", "1", },
    id_10309 = {"21109", "90", "魏国远征军", "守军", "0", "0", "100", "1", "3208", "1", },
    id_10310 = {"21110", "100", "魏国远征军", "守军", "0", "0", "100", "1", "3209", "1", },
    id_10311 = {"21101", "10", "魏国远征军", "守军", "0", "0", "100", "1", "3210", "1", },
    id_10312 = {"21102", "20", "魏国远征军", "守军", "0", "0", "100", "1", "3211", "1", },
    id_10313 = {"21103", "30", "魏国远征军", "守军", "0", "0", "100", "1", "3212", "1", },
    id_10314 = {"21104", "40", "魏国远征军", "守军", "0", "0", "100", "1", "3213", "1", },
    id_10315 = {"21105", "50", "魏国远征军", "守军", "0", "0", "100", "1", "3214", "1", },
    id_10316 = {"21106", "60", "魏国远征军", "守军", "0", "0", "100", "1", "3215", "1", },
    id_10317 = {"21107", "70", "魏国远征军", "守军", "0", "0", "100", "1", "3216", "1", },
    id_10318 = {"21108", "80", "魏国远征军", "守军", "0", "0", "100", "1", "3217", "1", },
    id_10319 = {"21109", "90", "魏国远征军", "守军", "0", "0", "100", "1", "3218", "1", },
    id_10320 = {"21110", "100", "魏国远征军", "守军", "0", "0", "100", "1", "3219", "1", },
    id_10321 = {"21101", "10", "魏国远征军", "守军", "0", "0", "100", "1", "3220", "1", },
    id_10322 = {"21102", "20", "魏国远征军", "守军", "0", "0", "100", "1", "3221", "1", },
    id_10323 = {"21103", "30", "魏国远征军", "守军", "0", "0", "100", "1", "3222", "1", },
    id_10324 = {"21104", "40", "魏国远征军", "守军", "0", "0", "100", "1", "3223", "1", },
    id_10325 = {"21105", "50", "魏国远征军", "守军", "0", "0", "100", "1", "3224", "1", },
    id_10326 = {"21106", "60", "魏国远征军", "守军", "0", "0", "100", "1", "3225", "1", },
    id_10327 = {"21107", "70", "魏国远征军", "守军", "0", "0", "100", "1", "3226", "1", },
    id_10328 = {"21108", "80", "魏国远征军", "守军", "0", "0", "100", "1", "3227", "1", },
    id_10329 = {"21109", "90", "魏国远征军", "守军", "0", "0", "100", "1", "3228", "1", },
    id_10330 = {"21110", "100", "魏国远征军", "守军", "0", "0", "100", "1", "3229", "1", },
    id_20101 = {"20201", "10", "蜀国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_20102 = {"20202", "20", "蜀国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_20103 = {"20203", "30", "蜀国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_20104 = {"20204", "40", "蜀国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_20105 = {"20205", "50", "蜀国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_20106 = {"20206", "60", "蜀国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_20107 = {"20207", "70", "蜀国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_20108 = {"20208", "80", "蜀国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_20109 = {"20209", "90", "蜀国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_20110 = {"20210", "100", "蜀国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_20201 = {"20211", "10", "蜀国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_20202 = {"20212", "20", "蜀国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_20203 = {"20213", "30", "蜀国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_20204 = {"20214", "40", "蜀国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_20205 = {"20215", "50", "蜀国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_20206 = {"20216", "60", "蜀国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_20207 = {"20217", "70", "蜀国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_20208 = {"20218", "80", "蜀国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_20209 = {"20219", "90", "蜀国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_20210 = {"20220", "100", "蜀国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_20301 = {"21201", "10", "蜀国远征军", "守军", "0", "0", "100", "1", "3200", "1", },
    id_20302 = {"21202", "20", "蜀国远征军", "守军", "0", "0", "100", "1", "3201", "1", },
    id_20303 = {"21203", "30", "蜀国远征军", "守军", "0", "0", "100", "1", "3202", "1", },
    id_20304 = {"21204", "40", "蜀国远征军", "守军", "0", "0", "100", "1", "3203", "1", },
    id_20305 = {"21205", "50", "蜀国远征军", "守军", "0", "0", "100", "1", "3204", "1", },
    id_20306 = {"21206", "60", "蜀国远征军", "守军", "0", "0", "100", "1", "3205", "1", },
    id_20307 = {"21207", "70", "蜀国远征军", "守军", "0", "0", "100", "1", "3206", "1", },
    id_20308 = {"21208", "80", "蜀国远征军", "守军", "0", "0", "100", "1", "3207", "1", },
    id_20309 = {"21209", "90", "蜀国远征军", "守军", "0", "0", "100", "1", "3208", "1", },
    id_20310 = {"21210", "100", "蜀国远征军", "守军", "0", "0", "100", "1", "3209", "1", },
    id_20311 = {"21201", "10", "蜀国远征军", "守军", "0", "0", "100", "1", "3210", "1", },
    id_20312 = {"21202", "20", "蜀国远征军", "守军", "0", "0", "100", "1", "3211", "1", },
    id_20313 = {"21203", "30", "蜀国远征军", "守军", "0", "0", "100", "1", "3212", "1", },
    id_20314 = {"21204", "40", "蜀国远征军", "守军", "0", "0", "100", "1", "3213", "1", },
    id_20315 = {"21205", "50", "蜀国远征军", "守军", "0", "0", "100", "1", "3214", "1", },
    id_20316 = {"21206", "60", "蜀国远征军", "守军", "0", "0", "100", "1", "3215", "1", },
    id_20317 = {"21207", "70", "蜀国远征军", "守军", "0", "0", "100", "1", "3216", "1", },
    id_20318 = {"21208", "80", "蜀国远征军", "守军", "0", "0", "100", "1", "3217", "1", },
    id_20319 = {"21209", "90", "蜀国远征军", "守军", "0", "0", "100", "1", "3218", "1", },
    id_20320 = {"21210", "100", "蜀国远征军", "守军", "0", "0", "100", "1", "3219", "1", },
    id_20321 = {"21201", "10", "蜀国远征军", "守军", "0", "0", "100", "1", "3220", "1", },
    id_20322 = {"21202", "20", "蜀国远征军", "守军", "0", "0", "100", "1", "3221", "1", },
    id_20323 = {"21203", "30", "蜀国远征军", "守军", "0", "0", "100", "1", "3222", "1", },
    id_20324 = {"21204", "40", "蜀国远征军", "守军", "0", "0", "100", "1", "3223", "1", },
    id_20325 = {"21205", "50", "蜀国远征军", "守军", "0", "0", "100", "1", "3224", "1", },
    id_20326 = {"21206", "60", "蜀国远征军", "守军", "0", "0", "100", "1", "3225", "1", },
    id_20327 = {"21207", "70", "蜀国远征军", "守军", "0", "0", "100", "1", "3226", "1", },
    id_20328 = {"21208", "80", "蜀国远征军", "守军", "0", "0", "100", "1", "3227", "1", },
    id_20329 = {"21209", "90", "蜀国远征军", "守军", "0", "0", "100", "1", "3228", "1", },
    id_20330 = {"21210", "100", "蜀国远征军", "守军", "0", "0", "100", "1", "3229", "1", },
    id_30101 = {"20301", "10", "吴国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_30102 = {"20302", "20", "吴国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_30103 = {"20303", "30", "吴国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_30104 = {"20304", "40", "吴国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_30105 = {"20305", "50", "吴国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_30106 = {"20306", "60", "吴国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_30107 = {"20307", "70", "吴国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_30108 = {"20308", "80", "吴国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_30109 = {"20309", "90", "吴国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_30110 = {"20310", "100", "吴国守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_30201 = {"20311", "10", "吴国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_30202 = {"20312", "20", "吴国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_30203 = {"20313", "30", "吴国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_30204 = {"20314", "40", "吴国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_30205 = {"20315", "50", "吴国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_30206 = {"20316", "60", "吴国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_30207 = {"20317", "70", "吴国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_30208 = {"20318", "80", "吴国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_30209 = {"20319", "90", "吴国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_30210 = {"20320", "100", "吴国精英守军", "守军", "0", "0", "100", "-1", "-1", "-1", },
    id_30301 = {"21301", "10", "吴国远征军", "守军", "0", "0", "100", "1", "3200", "1", },
    id_30302 = {"21302", "20", "吴国远征军", "守军", "0", "0", "100", "1", "3201", "1", },
    id_30303 = {"21303", "30", "吴国远征军", "守军", "0", "0", "100", "1", "3202", "1", },
    id_30304 = {"21304", "40", "吴国远征军", "守军", "0", "0", "100", "1", "3203", "1", },
    id_30305 = {"21305", "50", "吴国远征军", "守军", "0", "0", "100", "1", "3204", "1", },
    id_30306 = {"21306", "60", "吴国远征军", "守军", "0", "0", "100", "1", "3205", "1", },
    id_30307 = {"21307", "70", "吴国远征军", "守军", "0", "0", "100", "1", "3206", "1", },
    id_30308 = {"21308", "80", "吴国远征军", "守军", "0", "0", "100", "1", "3207", "1", },
    id_30309 = {"21309", "90", "吴国远征军", "守军", "0", "0", "100", "1", "3208", "1", },
    id_30310 = {"21310", "100", "吴国远征军", "守军", "0", "0", "100", "1", "3209", "1", },
    id_30311 = {"21301", "10", "吴国远征军", "守军", "0", "0", "100", "1", "3210", "1", },
    id_30312 = {"21302", "20", "吴国远征军", "守军", "0", "0", "100", "1", "3211", "1", },
    id_30313 = {"21303", "30", "吴国远征军", "守军", "0", "0", "100", "1", "3212", "1", },
    id_30314 = {"21304", "40", "吴国远征军", "守军", "0", "0", "100", "1", "3213", "1", },
    id_30315 = {"21305", "50", "吴国远征军", "守军", "0", "0", "100", "1", "3214", "1", },
    id_30316 = {"21306", "60", "吴国远征军", "守军", "0", "0", "100", "1", "3215", "1", },
    id_30317 = {"21307", "70", "吴国远征军", "守军", "0", "0", "100", "1", "3216", "1", },
    id_30318 = {"21308", "80", "吴国远征军", "守军", "0", "0", "100", "1", "3217", "1", },
    id_30319 = {"21309", "90", "吴国远征军", "守军", "0", "0", "100", "1", "3218", "1", },
    id_30320 = {"21310", "100", "吴国远征军", "守军", "0", "0", "100", "1", "3219", "1", },
    id_30321 = {"21301", "10", "吴国远征军", "守军", "0", "0", "100", "1", "3220", "1", },
    id_30322 = {"21302", "20", "吴国远征军", "守军", "0", "0", "100", "1", "3221", "1", },
    id_30323 = {"21303", "30", "吴国远征军", "守军", "0", "0", "100", "1", "3222", "1", },
    id_30324 = {"21304", "40", "吴国远征军", "守军", "0", "0", "100", "1", "3223", "1", },
    id_30325 = {"21305", "50", "吴国远征军", "守军", "0", "0", "100", "1", "3224", "1", },
    id_30326 = {"21306", "60", "吴国远征军", "守军", "0", "0", "100", "1", "3225", "1", },
    id_30327 = {"21307", "70", "吴国远征军", "守军", "0", "0", "100", "1", "3226", "1", },
    id_30328 = {"21308", "80", "吴国远征军", "守军", "0", "0", "100", "1", "3227", "1", },
    id_30329 = {"21309", "90", "吴国远征军", "守军", "0", "0", "100", "1", "3228", "1", },
    id_30330 = {"21310", "100", "吴国远征军", "守军", "0", "0", "100", "1", "3229", "1", },
    id_50201 = {"22101", "10", "北狄精英士兵", "守军", "0", "0", "100", "1", "3100", "5", },
    id_50202 = {"22102", "20", "北狄精英士兵", "守军", "0", "0", "100", "1", "3101", "5", },
    id_50203 = {"22103", "30", "北狄精英士兵", "守军", "0", "0", "100", "1", "3102", "5", },
    id_50204 = {"22104", "40", "北狄精英士兵", "守军", "0", "0", "100", "1", "3103", "5", },
    id_50205 = {"22105", "50", "北狄精英士兵", "守军", "0", "0", "100", "1", "3104", "5", },
    id_50206 = {"22106", "60", "北狄精英士兵", "守军", "0", "0", "100", "1", "3105", "5", },
    id_50207 = {"22107", "70", "北狄精英士兵", "守军", "0", "0", "100", "1", "3106", "5", },
    id_50208 = {"22108", "80", "北狄精英士兵", "守军", "0", "0", "100", "1", "3107", "5", },
    id_50209 = {"22109", "90", "北狄精英士兵", "守军", "0", "0", "100", "1", "3108", "5", },
    id_50210 = {"22110", "100", "北狄精英士兵", "守军", "0", "0", "100", "1", "3109", "5", },
    id_60201 = {"22201", "10", "西戎精英士兵", "守军", "0", "0", "100", "1", "3100", "6", },
    id_60202 = {"22202", "20", "西戎精英士兵", "守军", "0", "0", "100", "1", "3101", "6", },
    id_60203 = {"22203", "30", "西戎精英士兵", "守军", "0", "0", "100", "1", "3102", "6", },
    id_60204 = {"22204", "40", "西戎精英士兵", "守军", "0", "0", "100", "1", "3103", "6", },
    id_60205 = {"22205", "50", "西戎精英士兵", "守军", "0", "0", "100", "1", "3104", "6", },
    id_60206 = {"22206", "60", "西戎精英士兵", "守军", "0", "0", "100", "1", "3105", "6", },
    id_60207 = {"22207", "70", "西戎精英士兵", "守军", "0", "0", "100", "1", "3106", "6", },
    id_60208 = {"22208", "80", "西戎精英士兵", "守军", "0", "0", "100", "1", "3107", "6", },
    id_60209 = {"22209", "90", "西戎精英士兵", "守军", "0", "0", "100", "1", "3108", "6", },
    id_60210 = {"22210", "100", "西戎精英士兵", "守军", "0", "0", "100", "1", "3109", "6", },
    id_70201 = {"22301", "10", "东夷精英士兵", "守军", "0", "0", "100", "1", "3100", "7", },
    id_70202 = {"22302", "20", "东夷精英士兵", "守军", "0", "0", "100", "1", "3101", "7", },
    id_70203 = {"22303", "30", "东夷精英士兵", "守军", "0", "0", "100", "1", "3102", "7", },
    id_70204 = {"22304", "40", "东夷精英士兵", "守军", "0", "0", "100", "1", "3103", "7", },
    id_70205 = {"22305", "50", "东夷精英士兵", "守军", "0", "0", "100", "1", "3104", "7", },
    id_70206 = {"22306", "60", "东夷精英士兵", "守军", "0", "0", "100", "1", "3105", "7", },
    id_70207 = {"22307", "70", "东夷精英士兵", "守军", "0", "0", "100", "1", "3106", "7", },
    id_70208 = {"22308", "80", "东夷精英士兵", "守军", "0", "0", "100", "1", "3107", "7", },
    id_70209 = {"22309", "90", "东夷精英士兵", "守军", "0", "0", "100", "1", "3108", "7", },
    id_70210 = {"22310", "100", "东夷精英士兵", "守军", "0", "0", "100", "1", "3109", "7", },
    id_80201 = {"23101", "10", "黄巾精英士兵", "守军", "0", "0", "100", "1", "3110", "8", },
    id_80202 = {"23102", "20", "黄巾精英士兵", "守军", "0", "0", "100", "1", "3111", "8", },
    id_80203 = {"23103", "30", "黄巾精英士兵", "守军", "0", "0", "100", "1", "3112", "8", },
    id_80204 = {"23104", "40", "黄巾精英士兵", "守军", "0", "0", "100", "1", "3113", "8", },
    id_80205 = {"23105", "50", "黄巾精英士兵", "守军", "0", "0", "100", "1", "3114", "8", },
    id_80206 = {"23106", "60", "黄巾精英士兵", "守军", "0", "0", "100", "1", "3115", "8", },
    id_80207 = {"23107", "70", "黄巾精英士兵", "守军", "0", "0", "100", "1", "3116", "8", },
    id_80208 = {"23108", "80", "黄巾精英士兵", "守军", "0", "0", "100", "1", "3117", "8", },
    id_80209 = {"23109", "90", "黄巾精英士兵", "守军", "0", "0", "100", "1", "3118", "8", },
    id_80210 = {"23110", "100", "黄巾精英士兵", "守军", "0", "0", "100", "1", "3119", "8", },
    id_90201 = {"24101", "10", "魏国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "1", },
    id_90202 = {"24102", "20", "魏国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "1", },
    id_90203 = {"24103", "30", "魏国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "1", },
    id_90204 = {"24104", "40", "魏国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "1", },
    id_90205 = {"24105", "50", "魏国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "1", },
    id_90206 = {"24106", "60", "魏国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "1", },
    id_90207 = {"24107", "70", "魏国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "1", },
    id_90208 = {"24108", "80", "魏国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "1", },
    id_90209 = {"24109", "90", "魏国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "1", },
    id_90210 = {"24110", "100", "魏国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "1", },
    id_90211 = {"24101", "10", "魏国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "1", },
    id_90212 = {"24102", "20", "魏国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "1", },
    id_90213 = {"24103", "30", "魏国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "1", },
    id_90214 = {"24104", "40", "魏国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "1", },
    id_90215 = {"24105", "50", "魏国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "1", },
    id_90216 = {"24106", "60", "魏国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "1", },
    id_90217 = {"24107", "70", "魏国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "1", },
    id_90218 = {"24108", "80", "魏国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "1", },
    id_90219 = {"24109", "90", "魏国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "1", },
    id_90220 = {"24110", "100", "魏国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "1", },
    id_90221 = {"24101", "10", "魏国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "1", },
    id_90222 = {"24102", "20", "魏国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "1", },
    id_90223 = {"24103", "30", "魏国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "1", },
    id_90224 = {"24104", "40", "魏国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "1", },
    id_90225 = {"24105", "50", "魏国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "1", },
    id_90226 = {"24106", "60", "魏国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "1", },
    id_90227 = {"24107", "70", "魏国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "1", },
    id_90228 = {"24108", "80", "魏国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "1", },
    id_90229 = {"24109", "90", "魏国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "1", },
    id_90230 = {"24110", "100", "魏国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "1", },
    id_90231 = {"24101", "10", "魏国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "1", },
    id_90232 = {"24102", "20", "魏国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "1", },
    id_90233 = {"24103", "30", "魏国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "1", },
    id_90234 = {"24104", "40", "魏国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "1", },
    id_90235 = {"24105", "50", "魏国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "1", },
    id_90236 = {"24106", "60", "魏国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "1", },
    id_90237 = {"24107", "70", "魏国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "1", },
    id_90238 = {"24108", "80", "魏国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "1", },
    id_90239 = {"24109", "90", "魏国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "1", },
    id_90240 = {"24110", "100", "魏国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "1", },
    id_100201 = {"24201", "10", "蜀国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "2", },
    id_100202 = {"24202", "20", "蜀国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "2", },
    id_100203 = {"24203", "30", "蜀国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "2", },
    id_100204 = {"24204", "40", "蜀国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "2", },
    id_100205 = {"24205", "50", "蜀国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "2", },
    id_100206 = {"24206", "60", "蜀国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "2", },
    id_100207 = {"24207", "70", "蜀国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "2", },
    id_100208 = {"24208", "80", "蜀国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "2", },
    id_100209 = {"24209", "90", "蜀国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "2", },
    id_100210 = {"24210", "100", "蜀国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "2", },
    id_100211 = {"24201", "10", "蜀国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "2", },
    id_100212 = {"24202", "20", "蜀国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "2", },
    id_100213 = {"24203", "30", "蜀国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "2", },
    id_100214 = {"24204", "40", "蜀国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "2", },
    id_100215 = {"24205", "50", "蜀国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "2", },
    id_100216 = {"24206", "60", "蜀国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "2", },
    id_100217 = {"24207", "70", "蜀国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "2", },
    id_100218 = {"24208", "80", "蜀国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "2", },
    id_100219 = {"24209", "90", "蜀国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "2", },
    id_100220 = {"24210", "100", "蜀国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "2", },
    id_100221 = {"24201", "10", "蜀国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "2", },
    id_100222 = {"24202", "20", "蜀国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "2", },
    id_100223 = {"24203", "30", "蜀国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "2", },
    id_100224 = {"24204", "40", "蜀国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "2", },
    id_100225 = {"24205", "50", "蜀国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "2", },
    id_100226 = {"24206", "60", "蜀国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "2", },
    id_100227 = {"24207", "70", "蜀国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "2", },
    id_100228 = {"24208", "80", "蜀国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "2", },
    id_100229 = {"24209", "90", "蜀国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "2", },
    id_100230 = {"24210", "100", "蜀国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "2", },
    id_100231 = {"24201", "10", "蜀国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "2", },
    id_100232 = {"24202", "20", "蜀国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "2", },
    id_100233 = {"24203", "30", "蜀国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "2", },
    id_100234 = {"24204", "40", "蜀国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "2", },
    id_100235 = {"24205", "50", "蜀国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "2", },
    id_100236 = {"24206", "60", "蜀国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "2", },
    id_100237 = {"24207", "70", "蜀国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "2", },
    id_100238 = {"24208", "80", "蜀国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "2", },
    id_100239 = {"24209", "90", "蜀国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "2", },
    id_100240 = {"24210", "100", "蜀国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "2", },
    id_110201 = {"24301", "10", "吴国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "3", },
    id_110202 = {"24302", "20", "吴国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "3", },
    id_110203 = {"24303", "30", "吴国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "3", },
    id_110204 = {"24304", "40", "吴国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "3", },
    id_110205 = {"24305", "50", "吴国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "3", },
    id_110206 = {"24306", "60", "吴国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "3", },
    id_110207 = {"24307", "70", "吴国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "3", },
    id_110208 = {"24308", "80", "吴国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "3", },
    id_110209 = {"24309", "90", "吴国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "3", },
    id_110210 = {"24310", "100", "吴国青龙守军士兵", "守军", "0", "0", "100", "1", "3230", "3", },
    id_110211 = {"24301", "10", "吴国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "3", },
    id_110212 = {"24302", "20", "吴国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "3", },
    id_110213 = {"24303", "30", "吴国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "3", },
    id_110214 = {"24304", "40", "吴国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "3", },
    id_110215 = {"24305", "50", "吴国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "3", },
    id_110216 = {"24306", "60", "吴国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "3", },
    id_110217 = {"24307", "70", "吴国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "3", },
    id_110218 = {"24308", "80", "吴国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "3", },
    id_110219 = {"24309", "90", "吴国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "3", },
    id_110220 = {"24310", "100", "吴国白虎守军士兵", "守军", "0", "0", "100", "1", "3231", "3", },
    id_110221 = {"24301", "10", "吴国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "3", },
    id_110222 = {"24302", "20", "吴国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "3", },
    id_110223 = {"24303", "30", "吴国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "3", },
    id_110224 = {"24304", "40", "吴国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "3", },
    id_110225 = {"24305", "50", "吴国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "3", },
    id_110226 = {"24306", "60", "吴国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "3", },
    id_110227 = {"24307", "70", "吴国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "3", },
    id_110228 = {"24308", "80", "吴国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "3", },
    id_110229 = {"24309", "90", "吴国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "3", },
    id_110230 = {"24310", "100", "吴国朱雀守军士兵", "守军", "0", "0", "100", "1", "3232", "3", },
    id_110231 = {"24301", "10", "吴国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "3", },
    id_110232 = {"24302", "20", "吴国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "3", },
    id_110233 = {"24303", "30", "吴国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "3", },
    id_110234 = {"24304", "40", "吴国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "3", },
    id_110235 = {"24305", "50", "吴国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "3", },
    id_110236 = {"24306", "60", "吴国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "3", },
    id_110237 = {"24307", "70", "吴国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "3", },
    id_110238 = {"24308", "80", "吴国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "3", },
    id_110239 = {"24309", "90", "吴国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "3", },
    id_110240 = {"24310", "100", "吴国玄武守军士兵", "守军", "0", "0", "100", "1", "3233", "3", },
    id_120101 = {"25101", "15", "迷雾守军", "守军", "0", "0", "50", "1", "3000", "4", },
    id_120102 = {"25101", "15", "迷雾守军", "守军", "0", "0", "50", "1", "3001", "4", },
    id_120103 = {"25101", "15", "迷雾守军", "守军", "0", "0", "50", "1", "3002", "4", },
    id_120104 = {"25101", "15", "迷雾守军", "守军", "0", "0", "50", "1", "3003", "4", },
    id_120105 = {"25101", "15", "迷雾守军", "守军", "0", "0", "50", "1", "3004", "4", },
    id_120106 = {"25101", "15", "迷雾守军", "守军", "0", "0", "50", "1", "3005", "4", },
    id_120201 = {"25102", "20", "迷雾守军", "守军", "0", "0", "50", "1", "3000", "4", },
    id_120202 = {"25102", "20", "迷雾守军", "守军", "0", "0", "50", "1", "3001", "4", },
    id_120203 = {"25102", "20", "迷雾守军", "守军", "0", "0", "50", "1", "3002", "4", },
    id_120204 = {"25102", "20", "迷雾守军", "守军", "0", "0", "50", "1", "3003", "4", },
    id_120205 = {"25102", "20", "迷雾守军", "守军", "0", "0", "50", "1", "3004", "4", },
    id_120206 = {"25102", "20", "迷雾守军", "守军", "0", "0", "50", "1", "3005", "4", },
    id_120301 = {"25103", "30", "迷雾守军", "守军", "0", "0", "50", "1", "3000", "4", },
    id_120302 = {"25103", "30", "迷雾守军", "守军", "0", "0", "50", "1", "3001", "4", },
    id_120303 = {"25103", "30", "迷雾守军", "守军", "0", "0", "50", "1", "3002", "4", },
    id_120304 = {"25103", "30", "迷雾守军", "守军", "0", "0", "50", "1", "3003", "4", },
    id_120305 = {"25103", "30", "迷雾守军", "守军", "0", "0", "50", "1", "3004", "4", },
    id_120306 = {"25103", "30", "迷雾守军", "守军", "0", "0", "50", "1", "3005", "4", },
    id_130102 = {"26102", "20", "魏国迷雾守军", "守军", "0", "0", "100", "1", "3000", "1", },
    id_130103 = {"26103", "30", "魏国迷雾守军", "守军", "0", "0", "100", "1", "3000", "1", },
    id_130104 = {"26104", "40", "魏国迷雾守军", "守军", "0", "0", "100", "1", "3010", "1", },
    id_130105 = {"26105", "50", "魏国迷雾守军", "守军", "0", "0", "100", "1", "3010", "1", },
    id_130106 = {"26106", "60", "魏国迷雾守军", "守军", "0", "0", "100", "1", "3010", "1", },
    id_130107 = {"26107", "70", "魏国迷雾守军", "守军", "0", "0", "100", "1", "3020", "1", },
    id_130108 = {"26108", "80", "魏国迷雾守军", "守军", "0", "0", "100", "1", "3020", "1", },
    id_130109 = {"26109", "90", "魏国迷雾守军", "守军", "0", "0", "100", "1", "3020", "1", },
    id_130110 = {"26110", "100", "魏国迷雾守军", "守军", "0", "0", "100", "1", "3001", "1", },
    id_130201 = {"26101", "10", "蜀国迷雾守军", "守军", "0", "0", "100", "1", "3000", "2", },
    id_130202 = {"26102", "20", "蜀国迷雾守军", "守军", "0", "0", "100", "1", "3000", "2", },
    id_130203 = {"26103", "30", "蜀国迷雾守军", "守军", "0", "0", "100", "1", "3000", "2", },
    id_130204 = {"26104", "40", "蜀国迷雾守军", "守军", "0", "0", "100", "1", "3010", "2", },
    id_130205 = {"26105", "50", "蜀国迷雾守军", "守军", "0", "0", "100", "1", "3010", "2", },
    id_130206 = {"26106", "60", "蜀国迷雾守军", "守军", "0", "0", "100", "1", "3010", "2", },
    id_130207 = {"26107", "70", "蜀国迷雾守军", "守军", "0", "0", "100", "1", "3020", "2", },
    id_130208 = {"26108", "80", "蜀国迷雾守军", "守军", "0", "0", "100", "1", "3020", "2", },
    id_130209 = {"26109", "90", "蜀国迷雾守军", "守军", "0", "0", "100", "1", "3020", "2", },
    id_130210 = {"26110", "100", "蜀国迷雾守军", "守军", "0", "0", "100", "1", "3001", "2", },
    id_130301 = {"26101", "10", "吴国迷雾守军", "守军", "0", "0", "100", "1", "3000", "3", },
    id_130302 = {"26102", "20", "吴国迷雾守军", "守军", "0", "0", "100", "1", "3000", "3", },
    id_130303 = {"26103", "30", "吴国迷雾守军", "守军", "0", "0", "100", "1", "3000", "3", },
    id_130304 = {"26104", "40", "吴国迷雾守军", "守军", "0", "0", "100", "1", "3010", "3", },
    id_130305 = {"26105", "50", "吴国迷雾守军", "守军", "0", "0", "100", "1", "3010", "3", },
    id_130306 = {"26106", "60", "吴国迷雾守军", "守军", "0", "0", "100", "1", "3010", "3", },
    id_130307 = {"26107", "70", "吴国迷雾守军", "守军", "0", "0", "100", "1", "3020", "3", },
    id_130308 = {"26108", "80", "吴国迷雾守军", "守军", "0", "0", "100", "1", "3020", "3", },
    id_130309 = {"26109", "90", "吴国迷雾守军", "守军", "0", "0", "100", "1", "3020", "3", },
    id_130310 = {"26110", "100", "吴国迷雾守军", "守军", "0", "0", "100", "1", "3001", "3", },
}


function getDataById(key_id)
    local id_data = countryarmyTable["id_" .. key_id]
    if id_data == nil then
        return nil
    end
    return id_data
end

function getArrDataByField(fieldName, fieldValue)
    local arrData = {}
    local fieldNo = 1
    for i=1, #keys do
        if keys[i] == fieldName then
            fieldNo = i
            break
        end
    end

    for k, v in pairs(countryarmyTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return countryarmyTable
end


function getFieldByIdAndIndex(key_id, fieldName)
    local fieldNo = 0
    for i=1, #keys do
        if keys[i] == fieldName then
            fieldNo = i-1
            break
        end
    end
    return getDataById(key_id)[fieldNo]
end


function getIndexByField(fieldName)
    local fieldNo = 0
    for i=1, #keys do
        if keys[i] == fieldName then
            fieldNo = i-1
            break
        end
    end
    return fieldNo
end


function getArrDataBy2Field(fieldName1, fieldValue1, fieldName2, fieldValue2)
	local arrData = {}
	local fieldNo1 = 1
	local fieldNo2 = 1
	for i=1, #keys do
		if keys[i] == fieldName1 then
			fieldNo1 = i
		end
		if keys[i] == fieldName2 then
			fieldNo2 = i
		end
	end

    for k, v in pairs(countryarmyTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["countryarmy"] = nil
    package.loaded["countryarmy"] = nil
end
