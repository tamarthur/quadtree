local QuadTree = {}
QuadTree.__index = QuadTree

local MIN_SIZE = 1
local CAPACITY = 2

function QuadTree.visualizePoint(pt,color)
	local part = Instance.new("Part",workspace)
	part.Shape = Enum.PartType.Ball
	part.Size = Vector3.new(.5,.5,.5)
	part.Material = Enum.Material.Neon
	part.Anchored = true
	part.Transparency = .5
	part.Position = Vector3.new(pt.X,1,pt.Y)
	if color then part.Color = color end
	return part
end

function QuadTree.visualizeSquare(square,color)
	local center = (square.Min+square.Max)/2
	local part = Instance.new("Part",workspace)
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = 1
	part.Size = Vector3.new(square.Width,1,square.Height)
	part.Position = Vector3.new(center.X,2,center.Y)
	local box = script.SelectionBox:Clone()
	if color then box.Color3 = color end
	box.Adornee = part
	box.Parent = part
end

function QuadTree.new(p1,p2,parent)
	QuadTree.visualizeSquare(Rect.new(p1,p2))
	return setmetatable({
		Bounds = Rect.new(p1,p2);
		Parent = parent;
		Points = {};
		Children = {};
	},QuadTree)
end

function QuadTree:Contains(p,range)
	return p.X <= range.Max.X and
		p.X >= range.Min.X and
		p.Y <= range.Max.Y and
		p.Y >= range.Min.Y 
end

function QuadTree:Intersects(range)
	local bounds = self.Bounds
	return bounds.Min.X < range.Max.X and 
		bounds.Max.X > range.Min.X and 
		bounds.Max.Y > range.Min.Y and 
		bounds.Min.Y < range.Max.Y
end

function QuadTree:Insert(p,moved)
	local newThread = coroutine.wrap(function(self,p,moved)
		if not self:Contains(p,self.Bounds) then return end
		if self.Bounds.Height <= MIN_SIZE and self.Bounds.Width <= MIN_SIZE then 
			table.insert(self.Points,p)
			return
		end
		if #self.Points < CAPACITY then
			table.insert(self.Points,p)
			return
		end

		local bounds = self.Bounds
		local center = (bounds.Min+bounds.Max)/2
		local halfX = Vector2.new(bounds.Width/2,0)
		local halfY = Vector2.new(0,bounds.Height/2)
		--[[
			TopLeft == 0;
			TopRight == 1;
			BottomLeft == 2;
			BottomRight == 3;
		]]
		if p.Y>=center.Y then
			if p.X<center.X then
				if not self.Children[0] then
					self.Children[0] = QuadTree.new(center-halfX,center+halfY)
				end
				self.Children[0]:Insert(p)
			else
				if not self.Children[1] then
					self.Children[1] = QuadTree.new(center,bounds.Max)
				end
				self.Children[1]:Insert(p)
			end
		else
			if p.X<center.X then
				if not self.Children[2] then
					self.Children[2] = QuadTree.new(bounds.Min,center)
				end
				self.Children[2]:Insert(p)
			else
				if not self.Children[3] then
					self.Children[3] = QuadTree.new(center-halfY,center+halfX)
				end
				self.Children[3]:Insert(p)
			end
		end
		
		if moved then return end
	
		for i,v in pairs(self.Points) do
			self:Insert(v,true)
		end
		self.Points = {}

		return
	end)
	return newThread(self,p,moved)
end

function QuadTree:Locate(p)
	if not self:Contains(p) then return end
	
	for i,v in pairs(self.Points) do
		if v.X == p.X and v.Y == p.Y then return v end
	end
	
	local bounds = self.Bounds
	local center = (bounds.Min+bounds.Max)/2
	if p.Y>=center.Y then
		if p.X<center.X then
			return self.Children[0] and self.Children[0]:Locate(p)
		else
			return self.Children[1] and self.Children[1]:Locate(p)
		end
	else
		if p.X<center.X then
			return self.Children[2] and self.Children[2]:Locate(p)
		else
			return self.Children[3] and self.Children[3]:Locate(p)
		end
	end
	
end

function QuadTree:Query(range,point)
	local found = {}
	
	if self:Intersects(range) then
		for _,p in pairs(self.Points) do
			if point and point.UserData==p.UserData then continue end
			if self:Contains(p,range) then
				table.insert(found,p)
			end
		end

		for _,quad in pairs(self.Children) do
			for _,v in pairs(quad:Query(range,point)) do
				table.insert(found,v)
			end
		end
	end
	
	return found
end

function QuadTree:Merge()
	
end

function QuadTree:Remove(p)
	
end

return QuadTree
