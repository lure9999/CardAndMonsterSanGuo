

module("simulationStl", package.seeall)


function PushStack( self, Vel )

	if self.m_beginIndex == 0 then 
		self.m_beginIndex = 1
	end
	
	self.m_endIndex = self.m_endIndex + 1	
	
	self["list_"..self.m_endIndex] = Vel	
		
	
end

function empty_Stack( self , vel)

	local i = self.m_beginIndex	
	
	for i= self.m_beginIndex , self.m_endIndex , 1 do	
	
		if self["list_"..i] == vel then 
			
			self["list_"..i] = "empty"
			
		end 
		
	end
		
end
-- 目前只支持一层table表
function delete_node( self , vel)

	local i = self.m_beginIndex	
	
	for i= self.m_beginIndex , self.m_endIndex , 1 do	
	
		if type(self["list_"..i]) == "table" then
    		for key, value in pairs(self["list_"..i]) do
    			if value == vel then
					self["list_"..i] = "empty"
    			end
    		end

    	else
			if self["list_"..i] == vel then 
				self["list_"..i] = "empty"
				
			end 
		end

		
	end
	--[[print("delete_node")
	print(self.m_endIndex)
	Pause()]]--
end

function clearStack( self )	
	
	local i = self.m_beginIndex	
	
	for i= self.m_beginIndex , self.m_endIndex , 1 do	
	
		self["list_"..i] = nil	
		
	end
	
    self.m_beginIndex = 0	
	self.m_endIndex = 0	
end


function PopStack_First( self )

	if self.m_beginIndex == 0 then 
		--print("555555555555555555555555555555")
		--Pause()
		return nil
	end 
	

	local vel = self["list_"..self.m_beginIndex]
	
	self["list_"..self.m_beginIndex] = nil
	
	if self.m_beginIndex < self.m_endIndex then	
		
		self.m_beginIndex = self.m_beginIndex + 1
	
	else
		
		self.m_beginIndex = 0	
		self.m_endIndex = 0	
		
	end		
	
	if vel == "empty" then 		
		
		return self:PopStack()
	else		
		return vel
	end
end

function GetCurStack_First( self , times)
	
	if times == nil then 
		times = 0
	end
		
	if self.m_beginIndex == 0 then 
		--print("566666")
		--Pause()
		return nil
	end 	

	local vel = self["list_"..(self.m_beginIndex + times)]	
	
	if vel == "empty" then 		
		
		return self:GetCurStack(times+1)
	else		
		return vel
	end
end

function PopStack_Last( self )

	if self.m_endIndex == 0 then 
		--print("66666666")
		--Pause()
		return nil
	end 
	

	local vel = self["list_"..self.m_endIndex]
	
	self["list_"..self.m_endIndex] = nil
	
	if self.m_beginIndex < self.m_endIndex then	
		
		self.m_endIndex = self.m_endIndex - 1
	
	else
		
		self.m_beginIndex = 0	
		self.m_endIndex = 0	
		
	end		
	
	if vel == "empty" then 		
		
		return self:PopStack()
	else		
		return vel
	end
end


function PopStack_GetLast( self )
	

	if self.m_endIndex == 0 then 
		
		return nil
	end 
	

	local vel = self["list_"..self.m_endIndex]		
	
	
	if vel == "empty" then 		
		self.m_endIndex = self.m_endIndex -1
		return self:GetLastStack()
	else		
		return vel
	end
end


function creatStack_First()

	local Stack =  {
					m_beginIndex = 0,
					m_endIndex = 0,
					PushStack = PushStack,					
					clearStack = clearStack,
					empty_Stack = empty_Stack,
					delete_node = delete_node,
					PopStack = PopStack_First,
					GetCurStack = GetCurStack_First,
				  }
	
	return Stack
	
end


function creatStack_Last()

	local Stack =  {
					m_beginIndex = 0,
					m_endIndex = 0,
					PushStack = PushStack,					
					clearStack = clearStack,
					empty_Stack = empty_Stack,
					delete_node = delete_node,
					PopStack = PopStack_Last,
					GetLastStack = PopStack_GetLast,
				  }
	
	return Stack
	
end
