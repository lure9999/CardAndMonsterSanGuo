--add by sxin 发包流的封装，对外只关心数据 不关心发包数据的实现原理隐藏jason实现
local cjson	= require "json"

local szToken_index = 1
--z针对包数据的串行化
local function NetStreamWrite( self, data )
	self.m_index = self.m_index + 1
	--前3个必须是标准的int类型的
	if self.m_index == 1 then
		self.m_Packet.m_TypeID = data
	elseif self.m_index == 2 then
		self.m_Packet.m_LogicID = data
	elseif self.m_index == 3 then
		self.m_Packet.m_nEx_ID01 = data
	elseif self.m_index == 4 then
		self.m_Packet.m_nEx_ID02 = data
	else
		----自动合成的逻辑数据
		--判断数据类型 
		if type(data) == "table" then	
			self.m_TableData[self.m_index - 4] = copyTab(data)
		else
			self.m_TableData[self.m_index - 4] = data
		end
	end	
end



--真对包数据的读取
local function NetStreamRead( self )

	--读取用的时候不关心包的逻辑id只关心jason数据
	self.m_index = self.m_index + 1	
	local data = nil
	if type(self.m_TableData[self.m_index]) == "table" then	
		data = copyTab(self.m_TableData[self.m_index])
	else
		data = self.m_TableData[self.m_index]
	end	
	
	return data
end

--数据转化成jason格式的char
local function NetStreamEncode( self )
	
	if self.m_bHasGet == 0 then
		self.m_Packet.m_PacketData = cjson.encode(self.m_TableData)
		self.m_bHasGet = 1
	end

	--self.m_TableData = nil
	
	return self.m_Packet
end

local function NetStreamDecode( self , jasonchar )
		
	if self.m_bHasSet == 0 then
		self.m_TableData = cjson.decode(jasonchar)
		self.m_bHasSet = 1
	end
	
end

--重置Token数据只给重连用
local function NetStreamRestToken( self, szToken )
	
	self.m_TableData[szToken_index] = szToken	
	
end

function NetStream( )

		
	local Packet = {}
	Packet.m_TypeID = 0
	Packet.m_LogicID = 0
	Packet.m_nEx_ID01 = 0
	Packet.m_nEx_ID02 = 0
	Packet.m_PacketData = ""
	
	local pPacketDataTable = {}
	
	
	local PNetStream = {
			--方法
			Write 					= NetStreamWrite,
			Read 					= NetStreamRead,
			GetPacket 				= NetStreamEncode,
			SetPacket     			= NetStreamDecode,
			RestToken 				= NetStreamRestToken,
			--变量
			m_index 				= 0,
			m_TableData 			= pPacketDataTable,	
			m_Packet 				= Packet,
			m_bHasGet				= 0,
			m_bHasSet				= 0,			
	}		
	
	return PNetStream
end

function NetStream_Packet( Packet)
		
	local pPacketDataTable = {}
	
	local PNetStream = {
			--方法
			Write 					= NetStreamWrite,
			Read 					= NetStreamRead,
			GetPacket 				= NetStreamEncode,
			SetPacket     			= NetStreamDecode,
			RestToken 				= NetStreamRestToken,
			--变量
			m_index 				= 0,
			m_TableData 			= pPacketDataTable,	
			m_Packet 				= Packet,
			m_bHasGet				= 0,
			m_bHasSet				= 0,			
	}		
	
	PNetStream:SetPacket(Packet.m_PacketData)
	return PNetStream
end


