local Signal = {}
Signal.__index = Signal

function Signal.new()
	return setmetatable({},Signal)
end

function Signal:Connect(Listener)
	self[1] = Listener
end

function Signal:Fire(...)
	if not self[1] then return end 

	local newThread = coroutine.create(self[1])
	coroutine.resume(newThread, ...)
end

function Signal:Delete()
	self[1] = nil
end

return Signal
