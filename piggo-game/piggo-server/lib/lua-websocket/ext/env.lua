local table = require 'lib.lua-websocket.ext.table'
return function(env)
	env = env or _G
	env.math = require 'lib.lua-websocket.ext.math'
	env.table = table
	env.string = require 'lib.lua-websocket.ext.string'
	env.coroutine = require 'lib.lua-websocket.ext.coroutine'
	env.io = require 'lib.lua-websocket.ext.io'
	env.os = require 'lib.lua-websocket.ext.os'
	env.file = require 'lib.lua-websocket.ext.file'
	env.tolua = require 'lib.lua-websocket.ext.tolua'
	env.fromlua = require 'lib.lua-websocket.ext.fromlua'
	env.class = require 'lib.lua-websocket.ext.class'
	env.reload = require 'lib.lua-websocket.ext.reload'
	env.range = require 'lib.lua-websocket.ext.range'
	env.timer = require 'lib.lua-websocket.ext.timer'
	env.op = require 'lib.lua-websocket.ext.op'
	env.getCmdline = require 'lib.lua-websocket.ext.cmdline'
	env.cmdline = env.getCmdline(table.unpack(arg or {}))
	env._ = os.execute
	-- requires ffi
	--env.gcnew = require 'lib.lua-websocket.ext.gcmem'.new
	--env.gcfree = require 'lib.lua-websocket.ext.gcmem'.free
end
