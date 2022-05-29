--[[
thread manager for whoever
threads are added through add and updated through update
--]]

local table = require 'lib.lua-websocket.ext.table'
local class = require 'lib.lua-websocket.ext.class'
local coroutine = require 'lib.lua-websocket.ext.coroutine'

local ThreadManager = class()

function ThreadManager:init()
	self.threads = table()
	self.mainLoopCalls = table()
end

function ThreadManager:add(f, ...)
	local th = coroutine.create(f)
	self.threads:insert(th)
	local res, err = coroutine.resume(th, ...)	-- initial arguments
	-- TODO this is the same as 'safehandle' within 'assertresume'
	-- it is basically 'assertresume' except that has an extra status check
	if not res then
		-- don't remove it just yet -- it'll be gathered on next loop cycle
		print(err)
		print(debug.traceback(th))
	end
	return th
end

function ThreadManager:addMainLoopCall(f, ...)
	self.mainLoopCalls:insert{f, ...}
end

function ThreadManager:update()
	-- update threads
	local i = 1
	while i <= #self.threads do
		local thread = self.threads[i]
		if not coroutine.assertresume(thread) then
			self.threads:remove(i)
		else
			i = i + 1
		end
	end
	
	-- update main loop calls
	if #self.mainLoopCalls > 0 then
		local lastMainLoopCalls = self.mainLoopCalls
		self.mainLoopCalls = table()	-- reset, in case someone wants to add to this mid-callback
		
		for _,call in ipairs(lastMainLoopCalls) do
			local f = table.remove(call, 1)
			f(unpack(call))
		end		
	end
end

return ThreadManager
