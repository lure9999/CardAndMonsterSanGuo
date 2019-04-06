--测试脚本 针对lua创建多次的测试

module("TestLua", package.seeall)

--测试本地变量
local m_Test_0 = nil
local m_Test_1 = nil
local m_Test_2 = nil


--增加一个创建button的接口来实现重复代码

local function CreatAnimation_Button_( layout_Size, Texture_N, Texture_S, Texture_Disable, ButonPos ,FunTouchEvent)
	
	local layout = Layout:create()	
	layout:setSize(layout_Size)	
	layout:setTouchEnabled(true)		
	local btn_Temp = Button:create()	
	btn_Temp:setTouchEnabled(true)	
	btn_Temp:loadTextures(Texture_N,Texture_S,Texture_Disable)	
	btn_Temp:setPosition(ButonPos)	
	btn_Temp:setScale(1)
	btn_Temp:addTouchEventListener(FunTouchEvent)	
	layout:addChild(btn_Temp)
	
	return layout
	
end


function CreatTestLua_1( test_0, test_1 , test_2)

	m_Test_0 = test_0
	m_Test_1 = test_1
	m_Test_2 = test_2
	

	local function _Button_Click_CallBack(sender, eventType)

		if eventType == TouchEventType.ended then
		
			
			local btn = tolua.cast(sender,"Button")			
			
			print("test_0 = " .. test_0)
			print("test_1 = " .. test_1)
			print("test_2 = " .. test_2)
			
			PrintData()

		end
	end
	
	local layout = CreatAnimation_Button_(CCSize(200, 75),"Image/button/btn_01_n.png","Image/button/btn_01_h.png","",ccp(0, 0),_Button_Click_CallBack)
	return layout
	
end

function PrintData()
	print("m_Test_0 = " .. m_Test_0)
	print("m_Test_1 = " .. m_Test_1)
	print("m_Test_2 = " .. m_Test_2)
end

local function PrintData_Ptr(self)
	print("m_Test_0 = " .. self.m_Test_0)
	print("m_Test_1 = " .. self.m_Test_1)
	print("m_Test_2 = " .. self.m_Test_2)
	
end

local function GetUiPtr(self)
	return self.m_layout
end


function CreatTestLua_2( test_0, test_1 , test_2)

	local TestInterFace = {}
	
	TestInterFace.m_Test_0 = test_0	
	TestInterFace.m_Test_1 = test_1
	TestInterFace.m_Test_2 = test_2
	TestInterFace.PrintData = PrintData_Ptr
	TestInterFace.GetUiPtr = GetUiPtr
	

	local function _Button_Click_CallBack(sender, eventType)

		if eventType == TouchEventType.ended then
		
			
			local btn = tolua.cast(sender,"Button")			
			
			print("test_0 = " .. test_0)
			print("test_1 = " .. test_1)
			print("test_2 = " .. test_2)
			
			TestInterFace:PrintData()

		end
	end
	
	local layout = CreatAnimation_Button_(CCSize(200, 75),"Image/button/btn_01_n.png","Image/button/btn_01_h.png","",ccp(0, 0),_Button_Click_CallBack)
	
	TestInterFace.m_layout = layout
	return TestInterFace
	
end


function RegisterObserver( self ,key,fCallBack)
	local tableL = {}
	tableL.t_key = key
	tableL.Observer_callBack = fCallBack
	table.insert(self.tableTest,fCallBack)
	table.insert(self.tableObserver,tableL)
end
local function Update(table_Observer)
	if table_Observer~=nil then
		--print(#table_Observer)
		--Pause()
	end
	if table_Observer~=nil then
		for key,value in pairs (table_Observer) do 
			value.Observer_callBack()
		end
		
	end
end

function Notify(self)
	
	Update(self.tableObserver)
	for k,v in pairs(self.tableTest) do 
		v()
	end
end
function CreatTestLua_3()
	local Observer = {
		table_data = { },
		tableObserver = {},
		RegisterObserver = RegisterObserver,
		tableTest = {},
		Notify   = Notify
	}
	return Observer
end

function CreateTestLuaCallBack(i)
	
	local function CallBack()
		print(i)
	end
	return CallBack
end


