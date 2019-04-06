-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("warai", package.seeall)


keys = {
	"﻿Index", "WarAIGroupID", "Object", "State", "TriggerOdds", "GoOn", "AIType", "CondPara1", "CondPara2", "CondPara3", "CondPara4", "CondPara5", "CondPara6", "CondPara7", "CondPara8", "CondPara9", "CondPara10", "AIPara1", "AIPara2", "AIPara3", "AIPara4", "AIPara5", "AIPara6", "AIPara7", "AIPara8", "AIPara9", "AIPara10", 
}

waraiTable = {
    id_1 = {"1", "3", "3", "1", "1", "1", "0", "1", "-1", "-1", "0", "1", nil, nil, nil, nil, "10101", "20101", "30101", "3", nil, nil, nil, nil, nil, nil, },
    id_2 = {"1", "3", "3", "1", "1", "1", "1", "2", "-1", "-1", "0", "1", nil, nil, nil, nil, "10102", "20102", "30102", "3", nil, nil, nil, nil, nil, nil, },
    id_3 = {"1", "3", "3", "1", "1", "1", "2", "3", "-1", "-1", "0", "1", nil, nil, nil, nil, "10103", "20103", "30103", "3", nil, nil, nil, nil, nil, nil, },
    id_4 = {"1", "3", "3", "1", "1", "1", "3", "4", "-1", "-1", "0", "1", nil, nil, nil, nil, "10104", "20104", "30104", "3", nil, nil, nil, nil, nil, nil, },
    id_5 = {"1", "3", "3", "1", "1", "1", "4", "5", "-1", "-1", "0", "1", nil, nil, nil, nil, "10105", "20105", "30105", "3", nil, nil, nil, nil, nil, nil, },
    id_6 = {"1", "3", "3", "1", "1", "1", "5", "6", "-1", "-1", "0", "1", nil, nil, nil, nil, "10106", "20106", "30106", "3", nil, nil, nil, nil, nil, nil, },
    id_7 = {"1", "3", "3", "1", "1", "1", "6", "7", "-1", "-1", "0", "1", nil, nil, nil, nil, "10107", "20107", "30107", "3", nil, nil, nil, nil, nil, nil, },
    id_8 = {"1", "3", "3", "1", "1", "1", "7", "8", "-1", "-1", "0", "1", nil, nil, nil, nil, "10108", "20108", "30108", "3", nil, nil, nil, nil, nil, nil, },
    id_9 = {"1", "3", "3", "1", "1", "1", "8", "9", "-1", "-1", "0", "1", nil, nil, nil, nil, "10109", "20109", "30109", "3", nil, nil, nil, nil, nil, nil, },
    id_10 = {"1", "3", "3", "1", "0", "1", "9", "10", "-1", "-1", "0", "1", nil, nil, nil, nil, "10110", "20110", "30110", "3", nil, nil, nil, nil, nil, nil, },
    id_11 = {"1", "3", "2", "1", "1", "1", "0", "1", "600", "-1", "180", "5", nil, nil, nil, nil, "10201", "20201", "30201", "3", nil, nil, nil, nil, nil, nil, },
    id_12 = {"1", "3", "2", "1", "1", "1", "1", "2", "600", "-1", "180", "5", nil, nil, nil, nil, "10202", "20202", "30202", "3", nil, nil, nil, nil, nil, nil, },
    id_13 = {"1", "3", "2", "1", "1", "1", "2", "3", "600", "-1", "180", "5", nil, nil, nil, nil, "10203", "20203", "30203", "3", nil, nil, nil, nil, nil, nil, },
    id_14 = {"1", "3", "2", "1", "1", "1", "3", "4", "600", "-1", "180", "5", nil, nil, nil, nil, "10204", "20204", "30204", "3", nil, nil, nil, nil, nil, nil, },
    id_15 = {"1", "3", "2", "1", "1", "1", "4", "5", "600", "-1", "180", "5", nil, nil, nil, nil, "10205", "20205", "30205", "3", nil, nil, nil, nil, nil, nil, },
    id_16 = {"1", "3", "2", "1", "1", "1", "5", "6", "600", "-1", "180", "5", nil, nil, nil, nil, "10206", "20206", "30206", "3", nil, nil, nil, nil, nil, nil, },
    id_17 = {"1", "3", "2", "1", "1", "1", "6", "7", "600", "-1", "180", "5", nil, nil, nil, nil, "10207", "20207", "30207", "3", nil, nil, nil, nil, nil, nil, },
    id_18 = {"1", "3", "2", "1", "1", "1", "7", "8", "600", "-1", "180", "5", nil, nil, nil, nil, "10208", "20208", "30208", "3", nil, nil, nil, nil, nil, nil, },
    id_19 = {"1", "3", "2", "1", "1", "1", "8", "9", "600", "-1", "180", "5", nil, nil, nil, nil, "10209", "20209", "30209", "3", nil, nil, nil, nil, nil, nil, },
    id_20 = {"1", "3", "2", "1", "1", "1", "9", "10", "600", "-1", "180", "5", nil, nil, nil, nil, "10210", "20210", "30210", "3", nil, nil, nil, nil, nil, nil, },
    id_21 = {"1", "3", "2", "1", "1", "1", "0", "1", "1200", "-1", "180", "5", nil, nil, nil, nil, "10301", "20301", "30301", "3", nil, nil, nil, nil, nil, nil, },
    id_22 = {"1", "3", "2", "1", "1", "1", "1", "2", "1200", "-1", "180", "5", nil, nil, nil, nil, "10302", "20302", "30302", "3", nil, nil, nil, nil, nil, nil, },
    id_23 = {"1", "3", "2", "1", "1", "1", "2", "3", "1200", "-1", "180", "5", nil, nil, nil, nil, "10303", "20303", "30303", "3", nil, nil, nil, nil, nil, nil, },
    id_24 = {"1", "3", "2", "1", "1", "1", "3", "4", "1200", "-1", "180", "5", nil, nil, nil, nil, "10304", "20304", "30304", "3", nil, nil, nil, nil, nil, nil, },
    id_25 = {"1", "3", "2", "1", "1", "1", "4", "5", "1200", "-1", "180", "5", nil, nil, nil, nil, "10305", "20305", "30305", "3", nil, nil, nil, nil, nil, nil, },
    id_26 = {"1", "3", "2", "1", "1", "1", "5", "6", "1200", "-1", "180", "5", nil, nil, nil, nil, "10306", "20306", "30306", "3", nil, nil, nil, nil, nil, nil, },
    id_27 = {"1", "3", "2", "1", "1", "1", "6", "7", "1200", "-1", "180", "5", nil, nil, nil, nil, "10307", "20307", "30307", "3", nil, nil, nil, nil, nil, nil, },
    id_28 = {"1", "3", "2", "1", "1", "1", "7", "8", "1200", "-1", "180", "5", nil, nil, nil, nil, "10308", "20308", "30308", "3", nil, nil, nil, nil, nil, nil, },
    id_29 = {"1", "3", "2", "1", "1", "1", "8", "9", "1200", "-1", "180", "5", nil, nil, nil, nil, "10309", "20309", "30309", "3", nil, nil, nil, nil, nil, nil, },
    id_30 = {"1", "3", "2", "1", "0", "1", "9", "10", "1200", "-1", "180", "5", nil, nil, nil, nil, "10310", "20310", "30310", "3", nil, nil, nil, nil, nil, nil, },
    id_31 = {"2", "5", "1", "1", "1", "2", "0", "0", nil, nil, nil, nil, nil, nil, nil, nil, "1021", "59", "1021", "38", "1021", "40", "-1", "-1", "-1", "-1", },
    id_32 = {"2", "5", "1", "1", "1", "2", "0", "0", nil, nil, nil, nil, nil, nil, nil, nil, "1021", "125", "1021", "126", "1021", "127", "-1", "-1", "-1", "-1", },
    id_33 = {"2", "5", "1", "1", "0", "2", "0", "0", nil, nil, nil, nil, nil, nil, nil, nil, "1021", "231", "1021", "224", "1021", "226", "-1", "-1", "-1", "-1", },
    id_34 = {"2", "5", "1", "1", "1", "2", "1", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1022", "59", "1022", "38", "1022", "40", "1022", "39", "-1", "-1", },
    id_35 = {"2", "5", "1", "1", "1", "2", "1", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1022", "125", "1022", "126", "1022", "127", "1022", "128", "-1", "-1", },
    id_36 = {"2", "5", "1", "1", "0", "2", "1", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1022", "231", "1022", "224", "1022", "226", "1022", "225", "-1", "-1", },
    id_37 = {"2", "5", "1", "1", "1", "2", "2", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1023", "59", "1023", "38", "1023", "40", "1023", "39", "1023", "44", },
    id_38 = {"2", "5", "1", "1", "1", "2", "2", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1023", "125", "1023", "126", "1023", "127", "1023", "128", "1023", "152", },
    id_39 = {"2", "5", "1", "1", "0", "2", "2", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1023", "231", "1023", "224", "1023", "226", "1023", "225", "1023", "130", },
    id_40 = {"2", "5", "1", "1", "1", "2", "3", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1024", "59", "1024", "38", "1024", "40", "1024", "39", "1024", "44", },
    id_41 = {"2", "5", "1", "1", "1", "2", "3", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1024", "47", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_42 = {"2", "5", "1", "1", "1", "2", "3", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1024", "125", "1024", "126", "1024", "127", "1024", "128", "1024", "152", },
    id_43 = {"2", "5", "1", "1", "1", "2", "3", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1024", "131", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_44 = {"2", "5", "1", "1", "1", "2", "3", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1024", "231", "1024", "224", "1024", "226", "1024", "225", "1024", "130", },
    id_45 = {"2", "5", "1", "1", "0", "2", "3", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1024", "233", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_46 = {"2", "5", "1", "1", "1", "2", "4", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1025", "59", "1025", "38", "1025", "40", "1025", "39", "1025", "44", },
    id_47 = {"2", "5", "1", "1", "1", "2", "4", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1025", "47", "1025", "54", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_48 = {"2", "5", "1", "1", "1", "2", "4", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1025", "125", "1025", "126", "1025", "127", "1025", "128", "1025", "152", },
    id_49 = {"2", "5", "1", "1", "1", "2", "4", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1025", "131", "1025", "124", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_50 = {"2", "5", "1", "1", "1", "2", "4", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1025", "231", "1025", "224", "1025", "226", "1025", "225", "1025", "130", },
    id_51 = {"2", "5", "1", "1", "0", "2", "4", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1025", "233", "1025", "232", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_52 = {"2", "5", "1", "1", "1", "2", "5", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1026", "59", "1026", "38", "1026", "40", "1026", "39", "1026", "44", },
    id_53 = {"2", "5", "1", "1", "1", "2", "5", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1026", "47", "1026", "54", "1026", "58", "-1", "-1", "-1", "-1", },
    id_54 = {"2", "5", "1", "1", "1", "2", "5", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1026", "125", "1026", "126", "1026", "127", "1026", "128", "1026", "152", },
    id_55 = {"2", "5", "1", "1", "1", "2", "5", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1026", "131", "1026", "124", "1026", "104", "-1", "-1", "-1", "-1", },
    id_56 = {"2", "5", "1", "1", "1", "2", "5", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1026", "231", "1026", "224", "1026", "226", "1026", "225", "1026", "130", },
    id_57 = {"2", "5", "1", "1", "0", "2", "5", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1026", "233", "1026", "232", "1026", "228", "-1", "-1", "-1", "-1", },
    id_58 = {"3", "5", "1", "1", "1", "2", "0", "0", nil, nil, nil, nil, nil, nil, nil, nil, "1031", "59", "1031", "38", "1031", "40", "-1", "-1", "-1", "-1", },
    id_59 = {"3", "5", "1", "1", "1", "2", "0", "0", nil, nil, nil, nil, nil, nil, nil, nil, "1031", "125", "1031", "126", "1031", "127", "-1", "-1", "-1", "-1", },
    id_60 = {"3", "5", "1", "1", "0", "2", "0", "0", nil, nil, nil, nil, nil, nil, nil, nil, "1031", "231", "1031", "224", "1031", "226", "-1", "-1", "-1", "-1", },
    id_61 = {"3", "5", "1", "1", "1", "2", "1", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1032", "59", "1032", "38", "1032", "40", "1032", "39", "-1", "-1", },
    id_62 = {"3", "5", "1", "1", "1", "2", "1", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1032", "125", "1032", "126", "1032", "127", "1032", "128", "-1", "-1", },
    id_63 = {"3", "5", "1", "1", "0", "2", "1", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1032", "231", "1032", "224", "1032", "226", "1032", "225", "-1", "-1", },
    id_64 = {"3", "5", "1", "1", "1", "2", "2", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1033", "59", "1033", "38", "1033", "40", "1033", "39", "1033", "44", },
    id_65 = {"3", "5", "1", "1", "1", "2", "2", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1033", "125", "1033", "126", "1033", "127", "1033", "128", "1033", "152", },
    id_66 = {"3", "5", "1", "1", "0", "2", "2", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1033", "231", "1033", "224", "1033", "226", "1033", "225", "1033", "130", },
    id_67 = {"3", "5", "1", "1", "1", "2", "3", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1034", "59", "1034", "38", "1034", "40", "1034", "39", "1034", "44", },
    id_68 = {"3", "5", "1", "1", "1", "2", "3", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1034", "47", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_69 = {"3", "5", "1", "1", "1", "2", "3", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1034", "125", "1034", "126", "1034", "127", "1034", "128", "1034", "152", },
    id_70 = {"3", "5", "1", "1", "1", "2", "3", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1034", "131", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_71 = {"3", "5", "1", "1", "1", "2", "3", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1034", "231", "1034", "224", "1034", "226", "1034", "225", "1034", "130", },
    id_72 = {"3", "5", "1", "1", "0", "2", "3", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1034", "233", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_73 = {"3", "5", "1", "1", "1", "2", "4", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1035", "59", "1035", "38", "1035", "40", "1035", "39", "1035", "44", },
    id_74 = {"3", "5", "1", "1", "1", "2", "4", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1035", "47", "1035", "54", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_75 = {"3", "5", "1", "1", "1", "2", "4", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1035", "125", "1035", "126", "1035", "127", "1035", "128", "1035", "152", },
    id_76 = {"3", "5", "1", "1", "1", "2", "4", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1035", "131", "1035", "124", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_77 = {"3", "5", "1", "1", "1", "2", "4", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1035", "231", "1035", "224", "1035", "226", "1035", "225", "1035", "130", },
    id_78 = {"3", "5", "1", "1", "0", "2", "4", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1035", "233", "1035", "232", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_79 = {"3", "5", "1", "1", "1", "2", "5", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1036", "59", "1036", "38", "1036", "40", "1036", "39", "1036", "44", },
    id_80 = {"3", "5", "1", "1", "1", "2", "5", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1036", "47", "1036", "54", "1036", "58", "-1", "-1", "-1", "-1", },
    id_81 = {"3", "5", "1", "1", "1", "2", "5", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1036", "125", "1036", "126", "1036", "127", "1036", "128", "1036", "152", },
    id_82 = {"3", "5", "1", "1", "1", "2", "5", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1036", "131", "1036", "124", "1036", "104", "-1", "-1", "-1", "-1", },
    id_83 = {"3", "5", "1", "1", "1", "2", "5", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1036", "231", "1036", "224", "1036", "226", "1036", "225", "1036", "130", },
    id_84 = {"3", "5", "1", "1", "0", "2", "5", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1036", "233", "1036", "232", "1036", "228", "-1", "-1", "-1", "-1", },
    id_85 = {"4", "5", "1", "1", "1", "2", "0", "0", nil, nil, nil, nil, nil, nil, nil, nil, "1041", "59", "1041", "38", "1041", "40", "-1", "-1", "-1", "-1", },
    id_86 = {"4", "5", "1", "1", "1", "2", "0", "0", nil, nil, nil, nil, nil, nil, nil, nil, "1041", "125", "1041", "126", "1041", "127", "-1", "-1", "-1", "-1", },
    id_87 = {"4", "5", "1", "1", "0", "2", "0", "0", nil, nil, nil, nil, nil, nil, nil, nil, "1041", "231", "1041", "224", "1041", "226", "-1", "-1", "-1", "-1", },
    id_88 = {"4", "5", "1", "1", "1", "2", "1", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1042", "59", "1042", "38", "1042", "40", "1042", "39", "-1", "-1", },
    id_89 = {"4", "5", "1", "1", "1", "2", "1", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1042", "125", "1042", "126", "1042", "127", "1042", "128", "-1", "-1", },
    id_90 = {"4", "5", "1", "1", "0", "2", "1", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1042", "231", "1042", "224", "1042", "226", "1042", "225", "-1", "-1", },
    id_91 = {"4", "5", "1", "1", "1", "2", "2", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1043", "59", "1043", "38", "1043", "40", "1043", "39", "1043", "44", },
    id_92 = {"4", "5", "1", "1", "1", "2", "2", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1043", "125", "1043", "126", "1043", "127", "1043", "128", "1043", "152", },
    id_93 = {"4", "5", "1", "1", "0", "2", "2", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1043", "231", "1043", "224", "1043", "226", "1043", "225", "1043", "130", },
    id_94 = {"4", "5", "1", "1", "1", "2", "3", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1044", "59", "1044", "38", "1044", "40", "1044", "39", "1044", "44", },
    id_95 = {"4", "5", "1", "1", "1", "2", "3", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1044", "47", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_96 = {"4", "5", "1", "1", "1", "2", "3", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1044", "125", "1044", "126", "1044", "127", "1044", "128", "1044", "152", },
    id_97 = {"4", "5", "1", "1", "1", "2", "3", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1044", "131", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_98 = {"4", "5", "1", "1", "1", "2", "3", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1044", "231", "1044", "224", "1044", "226", "1044", "225", "1044", "130", },
    id_99 = {"4", "5", "1", "1", "0", "2", "3", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1044", "233", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_100 = {"4", "5", "1", "1", "1", "2", "4", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1045", "59", "1045", "38", "1045", "40", "1045", "39", "1045", "44", },
    id_101 = {"4", "5", "1", "1", "1", "2", "4", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1045", "47", "1045", "54", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_102 = {"4", "5", "1", "1", "1", "2", "4", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1045", "125", "1045", "126", "1045", "127", "1045", "128", "1045", "152", },
    id_103 = {"4", "5", "1", "1", "1", "2", "4", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1045", "131", "1045", "124", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_104 = {"4", "5", "1", "1", "1", "2", "4", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1045", "231", "1045", "224", "1045", "226", "1045", "225", "1045", "130", },
    id_105 = {"4", "5", "1", "1", "0", "2", "4", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1045", "233", "1045", "232", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_106 = {"4", "5", "1", "1", "1", "2", "5", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1046", "59", "1046", "38", "1046", "40", "1046", "39", "1046", "44", },
    id_107 = {"4", "5", "1", "1", "1", "2", "5", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1046", "47", "1046", "54", "1046", "58", "-1", "-1", "-1", "-1", },
    id_108 = {"4", "5", "1", "1", "1", "2", "5", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1046", "125", "1046", "126", "1046", "127", "1046", "128", "1046", "152", },
    id_109 = {"4", "5", "1", "1", "1", "2", "5", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1046", "131", "1046", "124", "1046", "104", "-1", "-1", "-1", "-1", },
    id_110 = {"4", "5", "1", "1", "1", "2", "5", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1046", "231", "1046", "224", "1046", "226", "1046", "225", "1046", "130", },
    id_111 = {"4", "5", "1", "1", "0", "2", "5", "60", nil, nil, nil, nil, nil, nil, nil, nil, "1046", "233", "1046", "232", "1046", "228", "-1", "-1", "-1", "-1", },
    id_112 = {"1021", "5", "1", "1", "1", "3", "1", "1", "2", nil, nil, nil, nil, nil, nil, nil, "50201", "10", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_113 = {"1021", "5", "1", "1", "1", "3", "1", "3", "4", nil, nil, nil, nil, nil, nil, nil, "50202", "15", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_114 = {"1021", "5", "1", "1", "1", "3", "1", "5", "6", nil, nil, nil, nil, nil, nil, nil, "50203", "25", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_115 = {"1021", "5", "1", "1", "1", "3", "1", "7", "8", nil, nil, nil, nil, nil, nil, nil, "50204", "35", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_116 = {"1021", "5", "1", "1", "0", "3", "1", "9", "10", nil, nil, nil, nil, nil, nil, nil, "50205", "50", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_117 = {"1022", "5", "1", "1", "1", "3", "1", "1", "2", nil, nil, nil, nil, nil, nil, nil, "50201", "10", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_118 = {"1022", "5", "1", "1", "1", "3", "1", "3", "4", nil, nil, nil, nil, nil, nil, nil, "50202", "15", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_119 = {"1022", "5", "1", "1", "1", "3", "1", "5", "6", nil, nil, nil, nil, nil, nil, nil, "50203", "25", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_120 = {"1022", "5", "1", "1", "1", "3", "1", "7", "8", nil, nil, nil, nil, nil, nil, nil, "50204", "35", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_121 = {"1022", "5", "1", "1", "0", "3", "1", "9", "10", nil, nil, nil, nil, nil, nil, nil, "50205", "50", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_122 = {"1023", "5", "1", "1", "1", "3", "1", "1", "2", nil, nil, nil, nil, nil, nil, nil, "50201", "10", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_123 = {"1023", "5", "1", "1", "1", "3", "1", "3", "4", nil, nil, nil, nil, nil, nil, nil, "50202", "15", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_124 = {"1023", "5", "1", "1", "1", "3", "1", "5", "6", nil, nil, nil, nil, nil, nil, nil, "50203", "25", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_125 = {"1023", "5", "1", "1", "1", "3", "1", "7", "8", nil, nil, nil, nil, nil, nil, nil, "50204", "35", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_126 = {"1023", "5", "1", "1", "0", "3", "1", "9", "10", nil, nil, nil, nil, nil, nil, nil, "50205", "50", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_127 = {"1024", "5", "1", "1", "1", "3", "1", "1", "2", nil, nil, nil, nil, nil, nil, nil, "50201", "10", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_128 = {"1024", "5", "1", "1", "1", "3", "1", "3", "4", nil, nil, nil, nil, nil, nil, nil, "50202", "15", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_129 = {"1024", "5", "1", "1", "1", "3", "1", "5", "6", nil, nil, nil, nil, nil, nil, nil, "50203", "25", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_130 = {"1024", "5", "1", "1", "1", "3", "1", "7", "8", nil, nil, nil, nil, nil, nil, nil, "50204", "35", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_131 = {"1024", "5", "1", "1", "0", "3", "1", "9", "10", nil, nil, nil, nil, nil, nil, nil, "50205", "50", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_132 = {"1025", "5", "1", "1", "1", "3", "1", "1", "2", nil, nil, nil, nil, nil, nil, nil, "50201", "10", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_133 = {"1025", "5", "1", "1", "1", "3", "1", "3", "4", nil, nil, nil, nil, nil, nil, nil, "50202", "15", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_134 = {"1025", "5", "1", "1", "1", "3", "1", "5", "6", nil, nil, nil, nil, nil, nil, nil, "50203", "25", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_135 = {"1025", "5", "1", "1", "1", "3", "1", "7", "8", nil, nil, nil, nil, nil, nil, nil, "50204", "35", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_136 = {"1025", "5", "1", "1", "0", "3", "1", "9", "10", nil, nil, nil, nil, nil, nil, nil, "50205", "50", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_137 = {"1026", "5", "1", "1", "1", "3", "1", "1", "2", nil, nil, nil, nil, nil, nil, nil, "50201", "10", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_138 = {"1026", "5", "1", "1", "1", "3", "1", "3", "4", nil, nil, nil, nil, nil, nil, nil, "50202", "15", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_139 = {"1026", "5", "1", "1", "1", "3", "1", "5", "6", nil, nil, nil, nil, nil, nil, nil, "50203", "25", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_140 = {"1026", "5", "1", "1", "1", "3", "1", "7", "8", nil, nil, nil, nil, nil, nil, nil, "50204", "35", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_141 = {"1026", "5", "1", "1", "0", "3", "1", "9", "10", nil, nil, nil, nil, nil, nil, nil, "50205", "50", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_142 = {"1031", "5", "1", "1", "1", "3", "2", "1", "2", nil, nil, nil, nil, nil, nil, nil, "60201", "10", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_143 = {"1031", "5", "1", "1", "1", "3", "2", "3", "4", nil, nil, nil, nil, nil, nil, nil, "60202", "15", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_144 = {"1031", "5", "1", "1", "1", "3", "2", "5", "6", nil, nil, nil, nil, nil, nil, nil, "60203", "25", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_145 = {"1031", "5", "1", "1", "1", "3", "2", "7", "8", nil, nil, nil, nil, nil, nil, nil, "60204", "35", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_146 = {"1031", "5", "1", "1", "0", "3", "2", "9", "10", nil, nil, nil, nil, nil, nil, nil, "60205", "50", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_147 = {"1032", "5", "1", "1", "1", "3", "2", "1", "2", nil, nil, nil, nil, nil, nil, nil, "60201", "10", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_148 = {"1032", "5", "1", "1", "1", "3", "2", "3", "4", nil, nil, nil, nil, nil, nil, nil, "60202", "15", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_149 = {"1032", "5", "1", "1", "1", "3", "2", "5", "6", nil, nil, nil, nil, nil, nil, nil, "60203", "25", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_150 = {"1032", "5", "1", "1", "1", "3", "2", "7", "8", nil, nil, nil, nil, nil, nil, nil, "60204", "35", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_151 = {"1032", "5", "1", "1", "0", "3", "2", "9", "10", nil, nil, nil, nil, nil, nil, nil, "60205", "50", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_152 = {"1033", "5", "1", "1", "1", "3", "2", "1", "2", nil, nil, nil, nil, nil, nil, nil, "60201", "10", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_153 = {"1033", "5", "1", "1", "1", "3", "2", "3", "4", nil, nil, nil, nil, nil, nil, nil, "60202", "15", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_154 = {"1033", "5", "1", "1", "1", "3", "2", "5", "6", nil, nil, nil, nil, nil, nil, nil, "60203", "25", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_155 = {"1033", "5", "1", "1", "1", "3", "2", "7", "8", nil, nil, nil, nil, nil, nil, nil, "60204", "35", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_156 = {"1033", "5", "1", "1", "0", "3", "2", "9", "10", nil, nil, nil, nil, nil, nil, nil, "60205", "50", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_157 = {"1034", "5", "1", "1", "1", "3", "2", "1", "2", nil, nil, nil, nil, nil, nil, nil, "60201", "10", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_158 = {"1034", "5", "1", "1", "1", "3", "2", "3", "4", nil, nil, nil, nil, nil, nil, nil, "60202", "15", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_159 = {"1034", "5", "1", "1", "1", "3", "2", "5", "6", nil, nil, nil, nil, nil, nil, nil, "60203", "25", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_160 = {"1034", "5", "1", "1", "1", "3", "2", "7", "8", nil, nil, nil, nil, nil, nil, nil, "60204", "35", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_161 = {"1034", "5", "1", "1", "0", "3", "2", "9", "10", nil, nil, nil, nil, nil, nil, nil, "60205", "50", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_162 = {"1035", "5", "1", "1", "1", "3", "2", "1", "2", nil, nil, nil, nil, nil, nil, nil, "60201", "10", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_163 = {"1035", "5", "1", "1", "1", "3", "2", "3", "4", nil, nil, nil, nil, nil, nil, nil, "60202", "15", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_164 = {"1035", "5", "1", "1", "1", "3", "2", "5", "6", nil, nil, nil, nil, nil, nil, nil, "60203", "25", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_165 = {"1035", "5", "1", "1", "1", "3", "2", "7", "8", nil, nil, nil, nil, nil, nil, nil, "60204", "35", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_166 = {"1035", "5", "1", "1", "0", "3", "2", "9", "10", nil, nil, nil, nil, nil, nil, nil, "60205", "50", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_167 = {"1036", "5", "1", "1", "1", "3", "2", "1", "2", nil, nil, nil, nil, nil, nil, nil, "60201", "10", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_168 = {"1036", "5", "1", "1", "1", "3", "2", "3", "4", nil, nil, nil, nil, nil, nil, nil, "60202", "15", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_169 = {"1036", "5", "1", "1", "1", "3", "2", "5", "6", nil, nil, nil, nil, nil, nil, nil, "60203", "25", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_170 = {"1036", "5", "1", "1", "1", "3", "2", "7", "8", nil, nil, nil, nil, nil, nil, nil, "60204", "35", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_171 = {"1036", "5", "1", "1", "0", "3", "2", "9", "10", nil, nil, nil, nil, nil, nil, nil, "60205", "50", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_172 = {"1041", "5", "1", "1", "1", "3", "3", "1", "2", nil, nil, nil, nil, nil, nil, nil, "70201", "10", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_173 = {"1041", "5", "1", "1", "1", "3", "3", "3", "4", nil, nil, nil, nil, nil, nil, nil, "70202", "15", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_174 = {"1041", "5", "1", "1", "1", "3", "3", "5", "6", nil, nil, nil, nil, nil, nil, nil, "70203", "25", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_175 = {"1041", "5", "1", "1", "1", "3", "3", "7", "8", nil, nil, nil, nil, nil, nil, nil, "70204", "35", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_176 = {"1041", "5", "1", "1", "0", "3", "3", "9", "10", nil, nil, nil, nil, nil, nil, nil, "70205", "50", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_177 = {"1042", "5", "1", "1", "1", "3", "3", "1", "2", nil, nil, nil, nil, nil, nil, nil, "70201", "10", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_178 = {"1042", "5", "1", "1", "1", "3", "3", "3", "4", nil, nil, nil, nil, nil, nil, nil, "70202", "15", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_179 = {"1042", "5", "1", "1", "1", "3", "3", "5", "6", nil, nil, nil, nil, nil, nil, nil, "70203", "25", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_180 = {"1042", "5", "1", "1", "1", "3", "3", "7", "8", nil, nil, nil, nil, nil, nil, nil, "70204", "35", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_181 = {"1042", "5", "1", "1", "0", "3", "3", "9", "10", nil, nil, nil, nil, nil, nil, nil, "70205", "50", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_182 = {"1043", "5", "1", "1", "1", "3", "3", "1", "2", nil, nil, nil, nil, nil, nil, nil, "70201", "10", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_183 = {"1043", "5", "1", "1", "1", "3", "3", "3", "4", nil, nil, nil, nil, nil, nil, nil, "70202", "15", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_184 = {"1043", "5", "1", "1", "1", "3", "3", "5", "6", nil, nil, nil, nil, nil, nil, nil, "70203", "25", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_185 = {"1043", "5", "1", "1", "1", "3", "3", "7", "8", nil, nil, nil, nil, nil, nil, nil, "70204", "35", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_186 = {"1043", "5", "1", "1", "0", "3", "3", "9", "10", nil, nil, nil, nil, nil, nil, nil, "70205", "50", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_187 = {"1044", "5", "1", "1", "1", "3", "3", "1", "2", nil, nil, nil, nil, nil, nil, nil, "70201", "10", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_188 = {"1044", "5", "1", "1", "1", "3", "3", "3", "4", nil, nil, nil, nil, nil, nil, nil, "70202", "15", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_189 = {"1044", "5", "1", "1", "1", "3", "3", "5", "6", nil, nil, nil, nil, nil, nil, nil, "70203", "25", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_190 = {"1044", "5", "1", "1", "1", "3", "3", "7", "8", nil, nil, nil, nil, nil, nil, nil, "70204", "35", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_191 = {"1044", "5", "1", "1", "0", "3", "3", "9", "10", nil, nil, nil, nil, nil, nil, nil, "70205", "50", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_192 = {"1045", "5", "1", "1", "1", "3", "3", "1", "2", nil, nil, nil, nil, nil, nil, nil, "70201", "10", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_193 = {"1045", "5", "1", "1", "1", "3", "3", "3", "4", nil, nil, nil, nil, nil, nil, nil, "70202", "15", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_194 = {"1045", "5", "1", "1", "1", "3", "3", "5", "6", nil, nil, nil, nil, nil, nil, nil, "70203", "25", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_195 = {"1045", "5", "1", "1", "1", "3", "3", "7", "8", nil, nil, nil, nil, nil, nil, nil, "70204", "35", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_196 = {"1045", "5", "1", "1", "0", "3", "3", "9", "10", nil, nil, nil, nil, nil, nil, nil, "70205", "50", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_197 = {"1046", "5", "1", "1", "1", "3", "3", "1", "2", nil, nil, nil, nil, nil, nil, nil, "70201", "10", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_198 = {"1046", "5", "1", "1", "1", "3", "3", "3", "4", nil, nil, nil, nil, nil, nil, nil, "70202", "15", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_199 = {"1046", "5", "1", "1", "1", "3", "3", "5", "6", nil, nil, nil, nil, nil, nil, nil, "70203", "25", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_200 = {"1046", "5", "1", "1", "1", "3", "3", "7", "8", nil, nil, nil, nil, nil, nil, nil, "70204", "35", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_201 = {"1046", "5", "1", "1", "0", "3", "3", "9", "10", nil, nil, nil, nil, nil, nil, nil, "70205", "50", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_202 = {"9", "5", "1", "1", "1", "4", "0", "-1", "-1", nil, nil, nil, nil, nil, nil, nil, "1", "10", "145", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_203 = {"9", "5", "1", "1", "1", "4", "-1", "-1", "-1", nil, nil, nil, nil, nil, nil, nil, "2", "11", "143", "203", "83", "-1", "-1", "-1", "-1", "-1", },
    id_204 = {"9", "5", "1", "1", "0", "4", "-1", "-1", "-1", nil, nil, nil, nil, nil, nil, nil, "0", "11", "84", "204", "202", "144", "142", "82", "-1", "-1", },
    id_205 = {"10", "5", "1", "1", "1", "5", "0", "1", "2", nil, nil, nil, nil, nil, nil, nil, "80201", "100", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_206 = {"10", "5", "1", "1", "1", "5", "0", "3", "4", nil, nil, nil, nil, nil, nil, nil, "80202", "100", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_207 = {"10", "5", "1", "1", "1", "5", "0", "5", "6", nil, nil, nil, nil, nil, nil, nil, "80203", "100", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_208 = {"10", "5", "1", "1", "1", "5", "0", "7", "8", nil, nil, nil, nil, nil, nil, nil, "80204", "100", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_209 = {"10", "5", "1", "1", "0", "5", "0", "9", "10", nil, nil, nil, nil, nil, nil, nil, "80205", "100", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_210 = {"11", "5", "1", "1", "1", "5", "0", "1", "2", nil, nil, nil, nil, nil, nil, nil, "80201", "30", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_211 = {"11", "5", "1", "1", "1", "5", "0", "3", "4", nil, nil, nil, nil, nil, nil, nil, "80202", "30", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_212 = {"11", "5", "1", "1", "1", "5", "0", "5", "6", nil, nil, nil, nil, nil, nil, nil, "80203", "30", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_213 = {"11", "5", "1", "1", "1", "5", "0", "7", "8", nil, nil, nil, nil, nil, nil, nil, "80204", "30", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_214 = {"11", "5", "1", "1", "0", "5", "0", "9", "10", nil, nil, nil, nil, nil, nil, nil, "80205", "30", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
}


function getDataById(key_id)
    local id_data = waraiTable["id_" .. key_id]
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

    for k, v in pairs(waraiTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return waraiTable
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

    for k, v in pairs(waraiTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["warai"] = nil
    package.loaded["warai"] = nil
end
