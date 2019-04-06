-- create by:jjc time:2014.7.16
-- 此文件定义全局数据。


module("CommonData", package.seeall)

--g_GSIP = "127.0.0.1"
--g_GSIP = "192.168.0.103"
g_GSPort = 12175
--g_GSPort = 12176
--234公服

g_GSIP = "192.168.0.234" 

--师磊
--g_GSIP = "192.168.0.233" 
--g_GSIP = "123.56.226.254"
--g_GSIP = "192.168.0.178"

--外网地址
--g_GSIP = "123.56.226.254"
--g_GSPort = 12175

--外网地址2
--g_GSIP = "123.56.207.79"
--g_GSPort = 12175

--冰轮测试
--g_GSIP = "121.69.19.62" 
--g_GSIP = "192.168.0.200" 

--小海测试
--g_GSIP = "192.168.0.143" 

g_nGlobalID	   = 0 			-- 记录该账户在服务器数据中的唯一id
g_nDynamicGSID = 0		-- 认证服务器动态分配id
g_nDynamicMSID = 0		-- 逻辑服务器动态分配ID
g_szToken	   = ""			-- 记录服务器分配给客户端的唯一串码
g_nCurServerIndex = 1 		-- 当前选择的服务器
g_nCurServerMapID = 0  --当前服务器的ID

g_nNetUpdataTime = 0.1		-- 网络更新时间

g_CountryWarLayer = nil 		--国战层
g_IsUnlockCountryWar = false	--国战是否开启
g_IsPaTaIng = false				--是否在爬塔页面
g_BloodOrDefenseTime = -1 		--血战或者坚守时间
g_GuildeManager = nil 			--界面跳转管理

g_szFtpUrl		= "ftp://192.168.0.234"
g_MYKEY_OF_VERSION = "current-version-code"
g_CUR_VERSION = "1.3"

g_SDK_Version = 1
g_SDK_Dataeye = 1
g_SDK_UserID = nil
g_SDK_ChannelId = nil
OPEN_GUIDE = 0
 

g_HeartTime = 200

g_nDeginSize_Width = 1140
g_nDeginSize_Height = 640

g_sizeVisibleSize = CCEGLView:sharedOpenGLView():getVisibleSize()
g_Origin = CCDirector:sharedDirector():getVisibleOrigin()

g_fScreenScale = (g_sizeVisibleSize.width/g_sizeVisibleSize.height)/(g_nDeginSize_Width/g_nDeginSize_Height)

-- print("g_fScreenScale = " .. g_fScreenScale)

g_FONT1 = "fonts/HYn3gj.ttf"
g_FONT2 = "fonts/HYn3gj.ttf"
g_FONT3 = "微软雅黑"

g_ServerListTable = {}		-- 服务器列表
g_MainDataTable = {}		-- 用户的基础信息
g_WujiangTable = {}			-- 武将列表
g_WujiangFragmenttable = {} -- 武将碎片列表
g_EquipUsedTable = {}		-- 使用过的装备列表
g_EquipBaseTable = {}		-- 未使用可以叠加装备
g_EquipFragmentTable = {}   -- 装备碎片
g_EquipTable = {}			-- 装备列表
g_ItemTable = {}			-- 物品列表
g_ShopTable = {}			-- 商店列表
g_MatrixTable = {}			-- 角色阵容信息表

g_MainZhuanJingTable = {} 	-- 专精

function IsAnySDK()
	if g_SDK_Version == 1 and GetPlatform()== CC_PLATFORM_TYPE.CC_PLATFORM_ANDROID then
		return true
	else
		return false
	end
end

function IsDataeye()
	if g_SDK_Dataeye == 1 and GetPlatform()== CC_PLATFORM_TYPE.CC_PLATFORM_ANDROID then
		return true
	else
		return false
	end
end
