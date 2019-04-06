-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("vip", package.seeall)


keys = {
	"﻿VipID", "VipExp", "VipRew", "VipText", "baobaoSB", 
}

vipTable = {
    id_0 = {"0", "0", "请先购买VIP", "1", },
    id_1 = {"30", "401", "|n|1||img|Image/imgres/VIPCharge/glim.png||color|21,104,7|可获得VIP1超级礼包|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png||img|Image/imgres/VIPCharge/new.png||color|21,104,7|解锁通天塔【扫荡】|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png||img|Image/imgres/VIPCharge/new.png||color|21,104,7|解锁军团佣兵【第二格】|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png||img|Image/imgres/VIPCharge/new.png||color|21,104,7|解锁装备强化【自动强化】|color|42,23,18||n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|2|color|42,23,18|组【世界】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每次可以共领取|color|21,104,7|1.5|color|42,23,18|倍【军团神树】经验|n|1||img|Image/imgres/VIPCharge/underLine.png|", "1", },
    id_2 = {"60", "402", "|n|1||img|Image/imgres/VIPCharge/glim.png||color|21,104,7|可获得VIP2超级礼包|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png||img|Image/imgres/VIPCharge/new.png||color|21,104,7|解锁世界征战【战十次】|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png||img|Image/imgres/VIPCharge/new.png||color|21,104,7|解锁军团捐献【高级】|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png||img|Image/imgres/VIPCharge/new.png||color|21,104,7|解锁军团佣兵【第三格】|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png||img|Image/imgres/VIPCharge/new.png||color|21,104,7|解锁夺宝系统【掠十次】|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png||img|Image/imgres/VIPCharge/new.png|每日可以多购买2组【比武】次数|color|42,23,18||n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|2|color|42,23,18|组【世界】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每次可以共领取|color|21,104,7|1.5|color|42,23,18|倍【军团神树】经验|n|1||img|Image/imgres/VIPCharge/underLine.png|", "1", },
    id_3 = {"120", "403", "|n|1||img|Image/imgres/VIPCharge/glim.png||color|21,104,7|可获得VIP3超级礼包|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png||img|Image/imgres/VIPCharge/new.png||color|21,104,7|解锁军团食堂【高级】|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png||img|Image/imgres/VIPCharge/new.png||color|21,104,7|解锁装备洗炼【中级】|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png||img|Image/imgres/VIPCharge/new.png|每日可以多购买1组【军团捐献】次数|color|42,23,18||n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|3|color|42,23,18|组【世界】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|2|color|42,23,18|组【比武】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每次可以共领取|color|21,104,7|2.0|color|42,23,18|倍【军团神树】经验|n|1||img|Image/imgres/VIPCharge/underLine.png|", "1", },
    id_4 = {"240", "404", "|n|1||img|Image/imgres/VIPCharge/glim.png||color|21,104,7|可获得VIP4超级礼包|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png||img|Image/imgres/VIPCharge/new.png|每日可以多购买1组【军团食堂】次数|color|42,23,18||n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|3|color|42,23,18|组【世界】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|3|color|42,23,18|组【比武】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|1|color|42,23,18|组【军团捐献】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每次可以共领取|color|21,104,7|2.0|color|42,23,18|倍【军团神树】经验|n|1||img|Image/imgres/VIPCharge/underLine.png|", "1", },
    id_5 = {"480", "405", "|n|1||img|Image/imgres/VIPCharge/glim.png||color|21,104,7|可获得VIP5超级礼包|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png||img|Image/imgres/VIPCharge/new.png|解锁装备洗炼【高级】|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png||img|Image/imgres/VIPCharge/new.png|每日可以多购买1组【精英】关卡|color|42,23,18||n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|3|color|42,23,18|组【世界】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|3|color|42,23,18|组【比武】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|1|color|42,23,18|组【军团捐献】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|1|color|42,23,18|组【军团食堂】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每次可以共领取|color|21,104,7|2.5|color|42,23,18|倍【军团神树】经验|n|1||img|Image/imgres/VIPCharge/underLine.png|", "1", },
    id_6 = {"960", "406", "|n|1||img|Image/imgres/VIPCharge/glim.png||color|21,104,7|可获得VIP6超级礼包|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png||img|Image/imgres/VIPCharge/new.png|每日可以多购买1组【活动】关卡|color|42,23,18||n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|3|color|42,23,18|组【世界】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|1|color|42,23,18|组【精英】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|4|color|42,23,18|组【比武】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|2|color|42,23,18|组【军团捐献】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|1|color|42,23,18|组【军团食堂】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每次可以共领取|color|21,104,7|2.5|color|42,23,18|倍【军团神树】经验|n|1||img|Image/imgres/VIPCharge/underLine.png|", "1", },
    id_7 = {"1920", "407", "|n|1||img|Image/imgres/VIPCharge/glim.png||color|21,104,7|可获得VIP7超级礼包|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|3|color|42,23,18|组【世界】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|2|color|42,23,18|组【精英】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|1|color|42,23,18|组【活动】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|4|color|42,23,18|组【比武】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|2|color|42,23,18|组【军团捐献】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|2|color|42,23,18|组【军团食堂】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每次可以共领取|color|21,104,7|3.0|color|42,23,18|倍【军团神树】经验|n|1||img|Image/imgres/VIPCharge/underLine.png|", "1", },
    id_8 = {"3840", "408", "|n|1||img|Image/imgres/VIPCharge/glim.png||color|21,104,7|可获得VIP8超级礼包|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|3|color|42,23,18|组【世界】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|2|color|42,23,18|组【精英】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|2|color|42,23,18|组【活动】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|5|color|42,23,18|组【比武】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|2|color|42,23,18|组【军团捐献】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|2|color|42,23,18|组【军团食堂】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每次可以共领取|color|21,104,7|3.0|color|42,23,18|倍【军团神树】经验|n|1||img|Image/imgres/VIPCharge/underLine.png|", "1", },
    id_9 = {"7680", "409", "|n|1||img|Image/imgres/VIPCharge/glim.png||color|21,104,7|可获得VIP9超级礼包|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|3|color|42,23,18|组【世界】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|3|color|42,23,18|组【精英】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|2|color|42,23,18|组【活动】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|5|color|42,23,18|组【比武】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|2|color|42,23,18|组【军团捐献】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|2|color|42,23,18|组【军团食堂】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每次可以共领取|color|21,104,7|3.5|color|42,23,18|倍【军团神树】经验|n|1||img|Image/imgres/VIPCharge/underLine.png|", "1", },
    id_10 = {"15360", "410", "|n|1||img|Image/imgres/VIPCharge/glim.png||color|21,104,7|可获得VIP10超级礼包|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png||img|Image/imgres/VIPCharge/new.png|每日可以多购买1组【军团任务】次数|color|42,23,18||n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|3|color|42,23,18|组【世界】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|3|color|42,23,18|组【精英】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|3|color|42,23,18|组【活动】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|5|color|42,23,18|组【比武】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|2|color|42,23,18|组【军团捐献】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|2|color|42,23,18|组【军团食堂】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每次可以共领取|color|21,104,7|3.5|color|42,23,18|倍【军团神树】经验|n|1||img|Image/imgres/VIPCharge/underLine.png|", "1", },
    id_11 = {"30720", "411", "|n|1||img|Image/imgres/VIPCharge/glim.png||color|21,104,7|可获得VIP11超级礼包|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png||img|Image/imgres/VIPCharge/new.png|每日可以多重置1次【通天塔】记录|color|42,23,18||n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|3|color|42,23,18|组【世界】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|3|color|42,23,18|组【精英】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|3|color|42,23,18|组【活动】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|5|color|42,23,18|组【比武】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|2|color|42,23,18|组【军团捐献】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|2|color|42,23,18|组【军团食堂】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|1|color|42,23,18|组【军团任务】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每次可以共领取|color|21,104,7|3.5|color|42,23,18|倍【军团神树】经验|n|1||img|Image/imgres/VIPCharge/underLine.png|", "1", },
    id_12 = {"61440", "412", "|n|1||img|Image/imgres/VIPCharge/glim.png||color|21,104,7|可获得VIP12超级礼包|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|3|color|42,23,18|组【世界】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|3|color|42,23,18|组【精英】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|3|color|42,23,18|组【活动】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|5|color|42,23,18|组【比武】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多重置|color|21,104,7|1|color|42,23,18|次【通天塔】记录|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|2|color|42,23,18|组【军团捐献】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|2|color|42,23,18|组【军团食堂】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|2|color|42,23,18|组【军团任务】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每次可以共领取|color|21,104,7|3.5|color|42,23,18|倍【军团神树】经验|n|1||img|Image/imgres/VIPCharge/underLine.png|", "1", },
    id_13 = {"122880", "413", "|n|1||img|Image/imgres/VIPCharge/glim.png||color|21,104,7|可获得VIP13超级礼包|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|3|color|42,23,18|组【世界】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|3|color|42,23,18|组【精英】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|3|color|42,23,18|组【活动】关卡|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|5|color|42,23,18|组【比武】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多重置|color|21,104,7|2|color|42,23,18|次【通天塔】记录|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|2|color|42,23,18|组【军团捐献】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|2|color|42,23,18|组【军团食堂】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每日可以多购买|color|21,104,7|2|color|42,23,18|组【军团任务】次数|n|1||img|Image/imgres/VIPCharge/underLine.png||n|1||img|Image/imgres/VIPCharge/glim.png|每次可以共领取|color|21,104,7|3.5|color|42,23,18|倍【军团神树】经验|n|1||img|Image/imgres/VIPCharge/underLine.png|", "1", },
}


function getDataById(key_id)
    local id_data = vipTable["id_" .. key_id]
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

    for k, v in pairs(vipTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return vipTable
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

    for k, v in pairs(vipTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["vip"] = nil
    package.loaded["vip"] = nil
end
