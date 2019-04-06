-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("expendition", package.seeall)


keys = {
	"﻿Index", "Etype", "CountryID", "CounLvl", "ArmyID", "ArmyNum", "RefreshType", "RefreshPara", "MoveCD", "Action", "ActionPara1", "ActionPara2", "AResImgID", "RResImgID", "LResImgID", "ExpenOrMons", 
}

expenditionTable = {
    id_1 = {"1", "1", "1", "10301", "20", "1", "1", "30", "1", "0", "4", "10101", "1", "10055", "1", },
    id_2 = {"1", "1", "1", "10301", "20", "1", "2", "30", "1", "0", "4", "10101", "2", "10055", "1", },
    id_3 = {"1", "1", "1", "10301", "20", "1", "3", "30", "1", "0", "4", "10101", "3", "10055", "1", },
    id_4 = {"1", "1", "1", "10301", "20", "1", "4", "30", "1", "0", "4", "10101", "5", "10055", "1", },
    id_5 = {"1", "2", "1", "20301", "20", "1", "5", "30", "1", "0", "4", "10102", "1", "10056", "1", },
    id_6 = {"1", "2", "1", "20301", "20", "1", "6", "30", "1", "0", "4", "10102", "2", "10056", "1", },
    id_7 = {"1", "2", "1", "20301", "20", "1", "7", "30", "1", "0", "4", "10102", "3", "10056", "1", },
    id_8 = {"1", "2", "1", "20301", "20", "1", "8", "30", "1", "0", "4", "10102", "5", "10056", "1", },
    id_9 = {"1", "3", "1", "30301", "20", "1", "9", "30", "1", "0", "4", "10103", "1", "10057", "1", },
    id_10 = {"1", "3", "1", "30301", "20", "1", "10", "30", "1", "0", "4", "10103", "2", "10057", "1", },
    id_11 = {"1", "3", "1", "30301", "20", "1", "11", "30", "1", "0", "4", "10103", "3", "10057", "1", },
    id_12 = {"1", "3", "1", "30301", "20", "1", "12", "30", "1", "0", "4", "10103", "5", "10057", "1", },
    id_13 = {"1", "1", "2", "10302", "20", "1", "1", "30", "1", "0", "4", "10101", "1", "10055", "1", },
    id_14 = {"1", "1", "2", "10302", "20", "1", "2", "30", "1", "0", "4", "10101", "2", "10055", "1", },
    id_15 = {"1", "1", "2", "10302", "20", "1", "3", "30", "1", "0", "4", "10101", "3", "10055", "1", },
    id_16 = {"1", "1", "2", "10302", "20", "1", "4", "30", "1", "0", "4", "10101", "5", "10055", "1", },
    id_17 = {"1", "2", "2", "20302", "20", "1", "5", "30", "1", "0", "4", "10102", "1", "10056", "1", },
    id_18 = {"1", "2", "2", "20302", "20", "1", "6", "30", "1", "0", "4", "10102", "2", "10056", "1", },
    id_19 = {"1", "2", "2", "20302", "20", "1", "7", "30", "1", "0", "4", "10102", "3", "10056", "1", },
    id_20 = {"1", "2", "2", "20302", "20", "1", "8", "30", "1", "0", "4", "10102", "5", "10056", "1", },
    id_21 = {"1", "3", "2", "30302", "20", "1", "9", "30", "1", "0", "4", "10103", "1", "10057", "1", },
    id_22 = {"1", "3", "2", "30302", "20", "1", "10", "30", "1", "0", "4", "10103", "2", "10057", "1", },
    id_23 = {"1", "3", "2", "30302", "20", "1", "11", "30", "1", "0", "4", "10103", "3", "10057", "1", },
    id_24 = {"1", "3", "2", "30302", "20", "1", "12", "30", "1", "0", "4", "10103", "5", "10057", "1", },
    id_25 = {"1", "1", "3", "10303", "20", "1", "1", "30", "1", "0", "4", "10101", "1", "10055", "1", },
    id_26 = {"1", "1", "3", "10303", "20", "1", "2", "30", "1", "0", "4", "10101", "2", "10055", "1", },
    id_27 = {"1", "1", "3", "10303", "20", "1", "3", "30", "1", "0", "4", "10101", "3", "10055", "1", },
    id_28 = {"1", "1", "3", "10303", "20", "1", "4", "30", "1", "0", "4", "10101", "5", "10055", "1", },
    id_29 = {"1", "2", "3", "20303", "20", "1", "5", "30", "1", "0", "4", "10102", "1", "10056", "1", },
    id_30 = {"1", "2", "3", "20303", "20", "1", "6", "30", "1", "0", "4", "10102", "2", "10056", "1", },
    id_31 = {"1", "2", "3", "20303", "20", "1", "7", "30", "1", "0", "4", "10102", "3", "10056", "1", },
    id_32 = {"1", "2", "3", "20303", "20", "1", "8", "30", "1", "0", "4", "10102", "5", "10056", "1", },
    id_33 = {"1", "3", "3", "30303", "20", "1", "9", "30", "1", "0", "4", "10103", "1", "10057", "1", },
    id_34 = {"1", "3", "3", "30303", "20", "1", "10", "30", "1", "0", "4", "10103", "2", "10057", "1", },
    id_35 = {"1", "3", "3", "30303", "20", "1", "11", "30", "1", "0", "4", "10103", "3", "10057", "1", },
    id_36 = {"1", "3", "3", "30303", "20", "1", "12", "30", "1", "0", "4", "10103", "5", "10057", "1", },
    id_37 = {"1", "1", "4", "10304", "20", "1", "1", "30", "1", "0", "4", "10101", "1", "10055", "1", },
    id_38 = {"1", "1", "4", "10304", "20", "1", "2", "30", "1", "0", "4", "10101", "2", "10055", "1", },
    id_39 = {"1", "1", "4", "10304", "20", "1", "3", "30", "1", "0", "4", "10101", "3", "10055", "1", },
    id_40 = {"1", "1", "4", "10304", "20", "1", "4", "30", "1", "0", "4", "10101", "5", "10055", "1", },
    id_41 = {"1", "2", "4", "20304", "20", "1", "5", "30", "1", "0", "4", "10102", "1", "10056", "1", },
    id_42 = {"1", "2", "4", "20304", "20", "1", "6", "30", "1", "0", "4", "10102", "2", "10056", "1", },
    id_43 = {"1", "2", "4", "20304", "20", "1", "7", "30", "1", "0", "4", "10102", "3", "10056", "1", },
    id_44 = {"1", "2", "4", "20304", "20", "1", "8", "30", "1", "0", "4", "10102", "5", "10056", "1", },
    id_45 = {"1", "3", "4", "30304", "20", "1", "9", "30", "1", "0", "4", "10103", "1", "10057", "1", },
    id_46 = {"1", "3", "4", "30304", "20", "1", "10", "30", "1", "0", "4", "10103", "2", "10057", "1", },
    id_47 = {"1", "3", "4", "30304", "20", "1", "11", "30", "1", "0", "4", "10103", "3", "10057", "1", },
    id_48 = {"1", "3", "4", "30304", "20", "1", "12", "30", "1", "0", "4", "10103", "5", "10057", "1", },
    id_49 = {"1", "1", "5", "10305", "20", "1", "1", "30", "1", "0", "4", "10101", "1", "10055", "1", },
    id_50 = {"1", "1", "5", "10305", "20", "1", "2", "30", "1", "0", "4", "10101", "2", "10055", "1", },
    id_51 = {"1", "1", "5", "10305", "20", "1", "3", "30", "1", "0", "4", "10101", "3", "10055", "1", },
    id_52 = {"1", "1", "5", "10305", "20", "1", "4", "30", "1", "0", "4", "10101", "5", "10055", "1", },
    id_53 = {"1", "2", "5", "20305", "20", "1", "5", "30", "1", "0", "4", "10102", "1", "10056", "1", },
    id_54 = {"1", "2", "5", "20305", "20", "1", "6", "30", "1", "0", "4", "10102", "2", "10056", "1", },
    id_55 = {"1", "2", "5", "20305", "20", "1", "7", "30", "1", "0", "4", "10102", "3", "10056", "1", },
    id_56 = {"1", "2", "5", "20305", "20", "1", "8", "30", "1", "0", "4", "10102", "5", "10056", "1", },
    id_57 = {"1", "3", "5", "30305", "20", "1", "9", "30", "1", "0", "4", "10103", "1", "10057", "1", },
    id_58 = {"1", "3", "5", "30305", "20", "1", "10", "30", "1", "0", "4", "10103", "2", "10057", "1", },
    id_59 = {"1", "3", "5", "30305", "20", "1", "11", "30", "1", "0", "4", "10103", "3", "10057", "1", },
    id_60 = {"1", "3", "5", "30305", "20", "1", "12", "30", "1", "0", "4", "10103", "5", "10057", "1", },
    id_61 = {"1", "1", "6", "10306", "20", "1", "1", "30", "1", "0", "4", "10101", "1", "10055", "1", },
    id_62 = {"1", "1", "6", "10306", "20", "1", "2", "30", "1", "0", "4", "10101", "2", "10055", "1", },
    id_63 = {"1", "1", "6", "10306", "20", "1", "3", "30", "1", "0", "4", "10101", "3", "10055", "1", },
    id_64 = {"1", "1", "6", "10306", "20", "1", "4", "30", "1", "0", "4", "10101", "5", "10055", "1", },
    id_65 = {"1", "2", "6", "20306", "20", "1", "5", "30", "1", "0", "4", "10102", "1", "10056", "1", },
    id_66 = {"1", "2", "6", "20306", "20", "1", "6", "30", "1", "0", "4", "10102", "2", "10056", "1", },
    id_67 = {"1", "2", "6", "20306", "20", "1", "7", "30", "1", "0", "4", "10102", "3", "10056", "1", },
    id_68 = {"1", "2", "6", "20306", "20", "1", "8", "30", "1", "0", "4", "10102", "5", "10056", "1", },
    id_69 = {"1", "3", "6", "30306", "20", "1", "9", "30", "1", "0", "4", "10103", "1", "10057", "1", },
    id_70 = {"1", "3", "6", "30306", "20", "1", "10", "30", "1", "0", "4", "10103", "2", "10057", "1", },
    id_71 = {"1", "3", "6", "30306", "20", "1", "11", "30", "1", "0", "4", "10103", "3", "10057", "1", },
    id_72 = {"1", "3", "6", "30306", "20", "1", "12", "30", "1", "0", "4", "10103", "5", "10057", "1", },
    id_73 = {"1", "1", "7", "10307", "20", "1", "1", "30", "1", "0", "4", "10101", "1", "10055", "1", },
    id_74 = {"1", "1", "7", "10307", "20", "1", "2", "30", "1", "0", "4", "10101", "2", "10055", "1", },
    id_75 = {"1", "1", "7", "10307", "20", "1", "3", "30", "1", "0", "4", "10101", "3", "10055", "1", },
    id_76 = {"1", "1", "7", "10307", "20", "1", "4", "30", "1", "0", "4", "10101", "5", "10055", "1", },
    id_77 = {"1", "2", "7", "20307", "20", "1", "5", "30", "1", "0", "4", "10102", "1", "10056", "1", },
    id_78 = {"1", "2", "7", "20307", "20", "1", "6", "30", "1", "0", "4", "10102", "2", "10056", "1", },
    id_79 = {"1", "2", "7", "20307", "20", "1", "7", "30", "1", "0", "4", "10102", "3", "10056", "1", },
    id_80 = {"1", "2", "7", "20307", "20", "1", "8", "30", "1", "0", "4", "10102", "5", "10056", "1", },
    id_81 = {"1", "3", "7", "30307", "20", "1", "9", "30", "1", "0", "4", "10103", "1", "10057", "1", },
    id_82 = {"1", "3", "7", "30307", "20", "1", "10", "30", "1", "0", "4", "10103", "2", "10057", "1", },
    id_83 = {"1", "3", "7", "30307", "20", "1", "11", "30", "1", "0", "4", "10103", "3", "10057", "1", },
    id_84 = {"1", "3", "7", "30307", "20", "1", "12", "30", "1", "0", "4", "10103", "5", "10057", "1", },
    id_85 = {"1", "1", "8", "10308", "20", "1", "1", "30", "1", "0", "4", "10101", "1", "10055", "1", },
    id_86 = {"1", "1", "8", "10308", "20", "1", "2", "30", "1", "0", "4", "10101", "2", "10055", "1", },
    id_87 = {"1", "1", "8", "10308", "20", "1", "3", "30", "1", "0", "4", "10101", "3", "10055", "1", },
    id_88 = {"1", "1", "8", "10308", "20", "1", "4", "30", "1", "0", "4", "10101", "5", "10055", "1", },
    id_89 = {"1", "2", "8", "20308", "20", "1", "5", "30", "1", "0", "4", "10102", "1", "10056", "1", },
    id_90 = {"1", "2", "8", "20308", "20", "1", "6", "30", "1", "0", "4", "10102", "2", "10056", "1", },
    id_91 = {"1", "2", "8", "20308", "20", "1", "7", "30", "1", "0", "4", "10102", "3", "10056", "1", },
    id_92 = {"1", "2", "8", "20308", "20", "1", "8", "30", "1", "0", "4", "10102", "5", "10056", "1", },
    id_93 = {"1", "3", "8", "30308", "20", "1", "9", "30", "1", "0", "4", "10103", "1", "10057", "1", },
    id_94 = {"1", "3", "8", "30308", "20", "1", "10", "30", "1", "0", "4", "10103", "2", "10057", "1", },
    id_95 = {"1", "3", "8", "30308", "20", "1", "11", "30", "1", "0", "4", "10103", "3", "10057", "1", },
    id_96 = {"1", "3", "8", "30308", "20", "1", "12", "30", "1", "0", "4", "10103", "5", "10057", "1", },
    id_97 = {"1", "1", "9", "10309", "20", "1", "1", "30", "1", "0", "4", "10101", "1", "10055", "1", },
    id_98 = {"1", "1", "9", "10309", "20", "1", "2", "30", "1", "0", "4", "10101", "2", "10055", "1", },
    id_99 = {"1", "1", "9", "10309", "20", "1", "3", "30", "1", "0", "4", "10101", "3", "10055", "1", },
    id_100 = {"1", "1", "9", "10309", "20", "1", "4", "30", "1", "0", "4", "10101", "5", "10055", "1", },
    id_101 = {"1", "2", "9", "20309", "20", "1", "5", "30", "1", "0", "4", "10102", "1", "10056", "1", },
    id_102 = {"1", "2", "9", "20309", "20", "1", "6", "30", "1", "0", "4", "10102", "2", "10056", "1", },
    id_103 = {"1", "2", "9", "20309", "20", "1", "7", "30", "1", "0", "4", "10102", "3", "10056", "1", },
    id_104 = {"1", "2", "9", "20309", "20", "1", "8", "30", "1", "0", "4", "10102", "5", "10056", "1", },
    id_105 = {"1", "3", "9", "30309", "20", "1", "9", "30", "1", "0", "4", "10103", "1", "10057", "1", },
    id_106 = {"1", "3", "9", "30309", "20", "1", "10", "30", "1", "0", "4", "10103", "2", "10057", "1", },
    id_107 = {"1", "3", "9", "30309", "20", "1", "11", "30", "1", "0", "4", "10103", "3", "10057", "1", },
    id_108 = {"1", "3", "9", "30309", "20", "1", "12", "30", "1", "0", "4", "10103", "5", "10057", "1", },
    id_109 = {"1", "1", "10", "10310", "20", "1", "1", "30", "1", "0", "4", "10101", "1", "10055", "1", },
    id_110 = {"1", "1", "10", "10310", "20", "1", "2", "30", "1", "0", "4", "10101", "2", "10055", "1", },
    id_111 = {"1", "1", "10", "10310", "20", "1", "3", "30", "1", "0", "4", "10101", "3", "10055", "1", },
    id_112 = {"1", "1", "10", "10310", "20", "1", "4", "30", "1", "0", "4", "10101", "5", "10055", "1", },
    id_113 = {"1", "2", "10", "20310", "20", "1", "5", "30", "1", "0", "4", "10102", "1", "10056", "1", },
    id_114 = {"1", "2", "10", "20310", "20", "1", "6", "30", "1", "0", "4", "10102", "2", "10056", "1", },
    id_115 = {"1", "2", "10", "20310", "20", "1", "7", "30", "1", "0", "4", "10102", "3", "10056", "1", },
    id_116 = {"1", "2", "10", "20310", "20", "1", "8", "30", "1", "0", "4", "10102", "5", "10056", "1", },
    id_117 = {"1", "3", "10", "30310", "20", "1", "9", "30", "1", "0", "4", "10103", "1", "10057", "1", },
    id_118 = {"1", "3", "10", "30310", "20", "1", "10", "30", "1", "0", "4", "10103", "2", "10057", "1", },
    id_119 = {"1", "3", "10", "30310", "20", "1", "11", "30", "1", "0", "4", "10103", "3", "10057", "1", },
    id_120 = {"1", "3", "10", "30310", "20", "1", "12", "30", "1", "0", "4", "10103", "5", "10057", "1", },
    id_121 = {"2", "1", "1", "90201", "20", "2", "2", "600", "1", "0", "10", "10114", "1", "10113", "2", },
    id_122 = {"2", "1", "2", "90202", "20", "2", "2", "600", "1", "0", "10", "10114", "1", "10113", "2", },
    id_123 = {"2", "1", "3", "90203", "20", "2", "2", "600", "1", "0", "10", "10114", "1", "10113", "2", },
    id_124 = {"2", "1", "4", "90204", "20", "2", "2", "600", "1", "0", "10", "10114", "1", "10113", "2", },
    id_125 = {"2", "1", "5", "90205", "20", "2", "2", "600", "1", "0", "10", "10114", "1", "10113", "2", },
    id_126 = {"2", "1", "6", "90206", "20", "2", "2", "600", "1", "0", "10", "10114", "1", "10113", "2", },
    id_127 = {"2", "1", "7", "90207", "20", "2", "2", "600", "1", "0", "10", "10114", "1", "10113", "2", },
    id_128 = {"2", "1", "8", "90208", "20", "2", "2", "600", "1", "0", "10", "10114", "1", "10113", "2", },
    id_129 = {"2", "1", "9", "90209", "20", "2", "2", "600", "1", "0", "10", "10114", "1", "10113", "2", },
    id_130 = {"2", "1", "10", "90210", "20", "2", "2", "600", "1", "0", "10", "10114", "1", "10113", "2", },
    id_131 = {"3", "1", "1", "90211", "20", "2", "2", "600", "1", "0", "10", "10115", "1", "10113", "2", },
    id_132 = {"3", "1", "2", "90212", "20", "2", "2", "600", "1", "0", "10", "10115", "1", "10113", "2", },
    id_133 = {"3", "1", "3", "90213", "20", "2", "2", "600", "1", "0", "10", "10115", "1", "10113", "2", },
    id_134 = {"3", "1", "4", "90214", "20", "2", "2", "600", "1", "0", "10", "10115", "1", "10113", "2", },
    id_135 = {"3", "1", "5", "90215", "20", "2", "2", "600", "1", "0", "10", "10115", "1", "10113", "2", },
    id_136 = {"3", "1", "6", "90216", "20", "2", "2", "600", "1", "0", "10", "10115", "1", "10113", "2", },
    id_137 = {"3", "1", "7", "90217", "20", "2", "2", "600", "1", "0", "10", "10115", "1", "10113", "2", },
    id_138 = {"3", "1", "8", "90218", "20", "2", "2", "600", "1", "0", "10", "10115", "1", "10113", "2", },
    id_139 = {"3", "1", "9", "90219", "20", "2", "2", "600", "1", "0", "10", "10115", "1", "10113", "2", },
    id_140 = {"3", "1", "10", "90220", "20", "2", "2", "600", "1", "0", "10", "10115", "1", "10113", "2", },
    id_141 = {"4", "1", "1", "90221", "20", "2", "2", "600", "1", "0", "10", "10116", "1", "10113", "2", },
    id_142 = {"4", "1", "2", "90222", "20", "2", "2", "600", "1", "0", "10", "10116", "1", "10113", "2", },
    id_143 = {"4", "1", "3", "90223", "20", "2", "2", "600", "1", "0", "10", "10116", "1", "10113", "2", },
    id_144 = {"4", "1", "4", "90224", "20", "2", "2", "600", "1", "0", "10", "10116", "1", "10113", "2", },
    id_145 = {"4", "1", "5", "90225", "20", "2", "2", "600", "1", "0", "10", "10116", "1", "10113", "2", },
    id_146 = {"4", "1", "6", "90226", "20", "2", "2", "600", "1", "0", "10", "10116", "1", "10113", "2", },
    id_147 = {"4", "1", "7", "90227", "20", "2", "2", "600", "1", "0", "10", "10116", "1", "10113", "2", },
    id_148 = {"4", "1", "8", "90228", "20", "2", "2", "600", "1", "0", "10", "10116", "1", "10113", "2", },
    id_149 = {"4", "1", "9", "90229", "20", "2", "2", "600", "1", "0", "10", "10116", "1", "10113", "2", },
    id_150 = {"4", "1", "10", "90230", "20", "2", "2", "600", "1", "0", "10", "10116", "1", "10113", "2", },
    id_151 = {"5", "1", "1", "90231", "20", "2", "2", "600", "1", "0", "10", "10117", "1", "10113", "2", },
    id_152 = {"5", "1", "2", "90232", "20", "2", "2", "600", "1", "0", "10", "10117", "1", "10113", "2", },
    id_153 = {"5", "1", "3", "90233", "20", "2", "2", "600", "1", "0", "10", "10117", "1", "10113", "2", },
    id_154 = {"5", "1", "4", "90234", "20", "2", "2", "600", "1", "0", "10", "10117", "1", "10113", "2", },
    id_155 = {"5", "1", "5", "90235", "20", "2", "2", "600", "1", "0", "10", "10117", "1", "10113", "2", },
    id_156 = {"5", "1", "6", "90236", "20", "2", "2", "600", "1", "0", "10", "10117", "1", "10113", "2", },
    id_157 = {"5", "1", "7", "90237", "20", "2", "2", "600", "1", "0", "10", "10117", "1", "10113", "2", },
    id_158 = {"5", "1", "8", "90238", "20", "2", "2", "600", "1", "0", "10", "10117", "1", "10113", "2", },
    id_159 = {"5", "1", "9", "90239", "20", "2", "2", "600", "1", "0", "10", "10117", "1", "10113", "2", },
    id_160 = {"5", "1", "10", "90240", "20", "2", "2", "600", "1", "0", "10", "10117", "1", "10113", "2", },
    id_161 = {"2", "2", "1", "100201", "20", "2", "2", "600", "1", "0", "10", "10119", "1", "10118", "2", },
    id_162 = {"2", "2", "2", "100202", "20", "2", "2", "600", "1", "0", "10", "10119", "1", "10118", "2", },
    id_163 = {"2", "2", "3", "100203", "20", "2", "2", "600", "1", "0", "10", "10119", "1", "10118", "2", },
    id_164 = {"2", "2", "4", "100204", "20", "2", "2", "600", "1", "0", "10", "10119", "1", "10118", "2", },
    id_165 = {"2", "2", "5", "100205", "20", "2", "2", "600", "1", "0", "10", "10119", "1", "10118", "2", },
    id_166 = {"2", "2", "6", "100206", "20", "2", "2", "600", "1", "0", "10", "10119", "1", "10118", "2", },
    id_167 = {"2", "2", "7", "100207", "20", "2", "2", "600", "1", "0", "10", "10119", "1", "10118", "2", },
    id_168 = {"2", "2", "8", "100208", "20", "2", "2", "600", "1", "0", "10", "10119", "1", "10118", "2", },
    id_169 = {"2", "2", "9", "100209", "20", "2", "2", "600", "1", "0", "10", "10119", "1", "10118", "2", },
    id_170 = {"2", "2", "10", "100210", "20", "2", "2", "600", "1", "0", "10", "10119", "1", "10118", "2", },
    id_171 = {"3", "2", "1", "100211", "20", "2", "2", "600", "1", "0", "10", "10120", "1", "10118", "2", },
    id_172 = {"3", "2", "2", "100212", "20", "2", "2", "600", "1", "0", "10", "10120", "1", "10118", "2", },
    id_173 = {"3", "2", "3", "100213", "20", "2", "2", "600", "1", "0", "10", "10120", "1", "10118", "2", },
    id_174 = {"3", "2", "4", "100214", "20", "2", "2", "600", "1", "0", "10", "10120", "1", "10118", "2", },
    id_175 = {"3", "2", "5", "100215", "20", "2", "2", "600", "1", "0", "10", "10120", "1", "10118", "2", },
    id_176 = {"3", "2", "6", "100216", "20", "2", "2", "600", "1", "0", "10", "10120", "1", "10118", "2", },
    id_177 = {"3", "2", "7", "100217", "20", "2", "2", "600", "1", "0", "10", "10120", "1", "10118", "2", },
    id_178 = {"3", "2", "8", "100218", "20", "2", "2", "600", "1", "0", "10", "10120", "1", "10118", "2", },
    id_179 = {"3", "2", "9", "100219", "20", "2", "2", "600", "1", "0", "10", "10120", "1", "10118", "2", },
    id_180 = {"3", "2", "10", "100220", "20", "2", "2", "600", "1", "0", "10", "10120", "1", "10118", "2", },
    id_181 = {"4", "2", "1", "100221", "20", "2", "2", "600", "1", "0", "10", "10121", "1", "10118", "2", },
    id_182 = {"4", "2", "2", "100222", "20", "2", "2", "600", "1", "0", "10", "10121", "1", "10118", "2", },
    id_183 = {"4", "2", "3", "100223", "20", "2", "2", "600", "1", "0", "10", "10121", "1", "10118", "2", },
    id_184 = {"4", "2", "4", "100224", "20", "2", "2", "600", "1", "0", "10", "10121", "1", "10118", "2", },
    id_185 = {"4", "2", "5", "100225", "20", "2", "2", "600", "1", "0", "10", "10121", "1", "10118", "2", },
    id_186 = {"4", "2", "6", "100226", "20", "2", "2", "600", "1", "0", "10", "10121", "1", "10118", "2", },
    id_187 = {"4", "2", "7", "100227", "20", "2", "2", "600", "1", "0", "10", "10121", "1", "10118", "2", },
    id_188 = {"4", "2", "8", "100228", "20", "2", "2", "600", "1", "0", "10", "10121", "1", "10118", "2", },
    id_189 = {"4", "2", "9", "100229", "20", "2", "2", "600", "1", "0", "10", "10121", "1", "10118", "2", },
    id_190 = {"4", "2", "10", "100230", "20", "2", "2", "600", "1", "0", "10", "10121", "1", "10118", "2", },
    id_191 = {"5", "2", "1", "100231", "20", "2", "2", "600", "1", "0", "10", "10122", "1", "10118", "2", },
    id_192 = {"5", "2", "2", "100232", "20", "2", "2", "600", "1", "0", "10", "10122", "1", "10118", "2", },
    id_193 = {"5", "2", "3", "100233", "20", "2", "2", "600", "1", "0", "10", "10122", "1", "10118", "2", },
    id_194 = {"5", "2", "4", "100234", "20", "2", "2", "600", "1", "0", "10", "10122", "1", "10118", "2", },
    id_195 = {"5", "2", "5", "100235", "20", "2", "2", "600", "1", "0", "10", "10122", "1", "10118", "2", },
    id_196 = {"5", "2", "6", "100236", "20", "2", "2", "600", "1", "0", "10", "10122", "1", "10118", "2", },
    id_197 = {"5", "2", "7", "100237", "20", "2", "2", "600", "1", "0", "10", "10122", "1", "10118", "2", },
    id_198 = {"5", "2", "8", "100238", "20", "2", "2", "600", "1", "0", "10", "10122", "1", "10118", "2", },
    id_199 = {"5", "2", "9", "100239", "20", "2", "2", "600", "1", "0", "10", "10122", "1", "10118", "2", },
    id_200 = {"5", "2", "10", "100240", "20", "2", "2", "600", "1", "0", "10", "10122", "1", "10118", "2", },
    id_201 = {"2", "3", "1", "110201", "20", "2", "2", "600", "1", "0", "10", "10124", "1", "10123", "2", },
    id_202 = {"2", "3", "2", "110202", "20", "2", "2", "600", "1", "0", "10", "10124", "1", "10123", "2", },
    id_203 = {"2", "3", "3", "110203", "20", "2", "2", "600", "1", "0", "10", "10124", "1", "10123", "2", },
    id_204 = {"2", "3", "4", "110204", "20", "2", "2", "600", "1", "0", "10", "10124", "1", "10123", "2", },
    id_205 = {"2", "3", "5", "110205", "20", "2", "2", "600", "1", "0", "10", "10124", "1", "10123", "2", },
    id_206 = {"2", "3", "6", "110206", "20", "2", "2", "600", "1", "0", "10", "10124", "1", "10123", "2", },
    id_207 = {"2", "3", "7", "110207", "20", "2", "2", "600", "1", "0", "10", "10124", "1", "10123", "2", },
    id_208 = {"2", "3", "8", "110208", "20", "2", "2", "600", "1", "0", "10", "10124", "1", "10123", "2", },
    id_209 = {"2", "3", "9", "110209", "20", "2", "2", "600", "1", "0", "10", "10124", "1", "10123", "2", },
    id_210 = {"2", "3", "10", "110210", "20", "2", "2", "600", "1", "0", "10", "10124", "1", "10123", "2", },
    id_211 = {"3", "3", "1", "110211", "20", "2", "2", "600", "1", "0", "10", "10125", "1", "10123", "2", },
    id_212 = {"3", "3", "2", "110212", "20", "2", "2", "600", "1", "0", "10", "10125", "1", "10123", "2", },
    id_213 = {"3", "3", "3", "110213", "20", "2", "2", "600", "1", "0", "10", "10125", "1", "10123", "2", },
    id_214 = {"3", "3", "4", "110214", "20", "2", "2", "600", "1", "0", "10", "10125", "1", "10123", "2", },
    id_215 = {"3", "3", "5", "110215", "20", "2", "2", "600", "1", "0", "10", "10125", "1", "10123", "2", },
    id_216 = {"3", "3", "6", "110216", "20", "2", "2", "600", "1", "0", "10", "10125", "1", "10123", "2", },
    id_217 = {"3", "3", "7", "110217", "20", "2", "2", "600", "1", "0", "10", "10125", "1", "10123", "2", },
    id_218 = {"3", "3", "8", "110218", "20", "2", "2", "600", "1", "0", "10", "10125", "1", "10123", "2", },
    id_219 = {"3", "3", "9", "110219", "20", "2", "2", "600", "1", "0", "10", "10125", "1", "10123", "2", },
    id_220 = {"3", "3", "10", "110220", "20", "2", "2", "600", "1", "0", "10", "10125", "1", "10123", "2", },
    id_221 = {"4", "3", "1", "110221", "20", "2", "2", "600", "1", "0", "10", "10126", "1", "10123", "2", },
    id_222 = {"4", "3", "2", "110222", "20", "2", "2", "600", "1", "0", "10", "10126", "1", "10123", "2", },
    id_223 = {"4", "3", "3", "110223", "20", "2", "2", "600", "1", "0", "10", "10126", "1", "10123", "2", },
    id_224 = {"4", "3", "4", "110224", "20", "2", "2", "600", "1", "0", "10", "10126", "1", "10123", "2", },
    id_225 = {"4", "3", "5", "110225", "20", "2", "2", "600", "1", "0", "10", "10126", "1", "10123", "2", },
    id_226 = {"4", "3", "6", "110226", "20", "2", "2", "600", "1", "0", "10", "10126", "1", "10123", "2", },
    id_227 = {"4", "3", "7", "110227", "20", "2", "2", "600", "1", "0", "10", "10126", "1", "10123", "2", },
    id_228 = {"4", "3", "8", "110228", "20", "2", "2", "600", "1", "0", "10", "10126", "1", "10123", "2", },
    id_229 = {"4", "3", "9", "110229", "20", "2", "2", "600", "1", "0", "10", "10126", "1", "10123", "2", },
    id_230 = {"4", "3", "10", "110230", "20", "2", "2", "600", "1", "0", "10", "10126", "1", "10123", "2", },
    id_231 = {"5", "3", "1", "110231", "20", "2", "2", "600", "1", "0", "10", "10127", "1", "10123", "2", },
    id_232 = {"5", "3", "2", "110232", "20", "2", "2", "600", "1", "0", "10", "10127", "1", "10123", "2", },
    id_233 = {"5", "3", "3", "110233", "20", "2", "2", "600", "1", "0", "10", "10127", "1", "10123", "2", },
    id_234 = {"5", "3", "4", "110234", "20", "2", "2", "600", "1", "0", "10", "10127", "1", "10123", "2", },
    id_235 = {"5", "3", "5", "110235", "20", "2", "2", "600", "1", "0", "10", "10127", "1", "10123", "2", },
    id_236 = {"5", "3", "6", "110236", "20", "2", "2", "600", "1", "0", "10", "10127", "1", "10123", "2", },
    id_237 = {"5", "3", "7", "110237", "20", "2", "2", "600", "1", "0", "10", "10127", "1", "10123", "2", },
    id_238 = {"5", "3", "8", "110238", "20", "2", "2", "600", "1", "0", "10", "10127", "1", "10123", "2", },
    id_239 = {"5", "3", "9", "110239", "20", "2", "2", "600", "1", "0", "10", "10127", "1", "10123", "2", },
    id_240 = {"5", "3", "10", "110240", "20", "2", "2", "600", "1", "0", "10", "10127", "1", "10123", "2", },
}


function getDataById(key_id)
    local id_data = expenditionTable["id_" .. key_id]
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

    for k, v in pairs(expenditionTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return expenditionTable
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

    for k, v in pairs(expenditionTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["expendition"] = nil
    package.loaded["expendition"] = nil
end