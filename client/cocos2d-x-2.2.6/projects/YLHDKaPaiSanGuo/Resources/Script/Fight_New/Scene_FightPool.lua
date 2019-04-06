
module("Scene_FightPool", package.seeall)

local function MakeNode( self, nVel )

	local pVelNode = {}

	pVelNode.Vel   = nVel

	pVelNode.Prev  = "Empty" 		--指向前驱节点

	pVelNode.Next  = "ListEnd" 		--指向后续节点


	if self.m_VelList.Size == 0 then

		if pVelNode ~= nil then

			self.m_VelList.Head	 =  pVelNode

			self.m_VelList.Tail  =  pVelNode

			self.m_VelList.Size  =  self.m_VelList.Size + 1

		end

	else

		local pTailNode  =  self.m_VelList.Tail

		pTailNode.Next   =  pVelNode

		pVelNode.Prev    =  pTailNode

		self.m_VelList.Tail = pVelNode

		self.m_VelList.Size  =  self.m_VelList.Size + 1

	end

end

local function ListSizeADD( self )
	if self.m_VelList ~= nil then

		self.m_VelList.Size = self.m_VelList.Size + 1
		--print("self.m_VelList.Size = "..self.m_VelList.Size)

	end
end

local function GetListSize( self )
	if self.m_VelList ~= nil then

		return tonumber(self.m_VelList.Size)

	end
end

local function GetListHead( self )
	if self.m_VelList ~= nil then

		return self.m_VelList.Head

	end
end

local function GetListTail( self )
	if self.m_VelList ~= nil then

		return self.m_VelList.Tail

	end
end

local function VisitNode( self, nVelNode )
	if nVelNode ~= nil then

		return nVelNode.Vel

	end
end

local function GetNextNode( self, _Node )
	if _Node ~= nil then

		return _Node.Next

	end
end

local function GetPrevNode( self, _Node )
	if _Node ~= nil then

		return _Node.Prev

	end
end

local function DelNode( self, _DelNode )

	if _DelNode == nil then
		return 
	end

	local PrevNode = _DelNode.Prev

	local NextNode = _DelNode.Next

	if PrevNode == "Empty" then
		--链表首个节点
		if NextNode == "ListEnd" then
			--只剩最后一个技能
			self.m_VelList.Head = _DelNode

			self.m_VelList.Tail = _DelNode

		else

			NextNode.Prev = "Empty"

			self.m_VelList.Head = NextNode

		end

	elseif NextNode == "ListEnd" then

		PrevNode.Next  = "ListEnd"

		self.m_VelList.Tail = PrevNode

	else

		NextNode.Prev  = PrevNode

		PrevNode.Next  = NextNode

	end

	_DelNode = nil

	self.m_VelList.Size = self.m_VelList.Size - 1

	--print("self.m_VelList.Size =================== "..self.m_VelList.Size)

end

--给技能专用的方法(通过技能索引找到节点)
local function Find_SkillListVel( self, pSKillIndex )
	local pNode_Head = GetListHead( self )

	local pNode = pNode_Head

	while ( pNode ~= nil )
	do
		local pVel = pNode.Vel
		local pSIndex = pVel:Fun_GetSkillIndex()

		--print(pSKillIndex, pSIndex, pVel:Fun_GetSkillID())
		--Pause()

		if pSIndex == pSKillIndex then
			--print("get it")
			--Pause()
			return pNode

		end

		pNode = pNode.Next
	end

	return nil

end

local function CreateFightPool( self, nMax )

	self.m_MaxVel 			=	nMax 						--链表最大长度

	self.m_VelList.Head 	=	"Empty" 					--链表头

	self.m_VelList.Tail 	=	"Empty" 					--链表尾

	self.m_VelList.Size 	=	0

end

function CreateBaseObj()

	local Obj = {
				Fun_CreateFightPool 		=	CreateFightPool,
				Fun_MakeNode 				=	MakeNode,
				Fun_GetListSize 			=	GetListSize,
				Fun_GetListHead				=	GetListHead,
				Fun_GetListTail 			=	GetListTail,
				Fun_VisitNode				=	VisitNode,
				Fun_DelNode					=	DelNode,
				Fun_Find_SkillListVel		=	Find_SkillListVel,
				Fun_GetNextNode				=	GetNextNode,
				Fun_GetPrevNode				=	GetPrevNode,
				Fun_ListSizeADD				=	ListSizeADD,

				--memeber
				m_VelList 					=	{},
				m_MaxVel 					=	nil,

			}
	return Obj
end










