local QuadTree = require(game.ServerStorage.QuadTree)
local size = Vector2.new(128,128)
local tree = QuadTree.new(-size,size)

for i = 1, 50 do
	local x = Random.new():NextNumber(1,5)
	local y = Random.new():NextNumber(1,5)
	tree:Insert(Vector2.new(x,y))
	QuadTree.visualizePoint(Vector2.new(x,y))
end
