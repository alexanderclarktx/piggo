local table = require 'lib.lua-websocket.ext.table'
local class = require 'lib.lua-websocket.ext.class'
local socket = require 'socket'
local mime = require 'mime'
local json = require 'lib.lua-websocket.json'
local ThreadManager = require 'lib.lua-websocket.threadmanager'
local WebSocketConn = require 'lib.lua-websocket.websocketconn'
local WebSocketHixieConn = require 'lib.lua-websocket.websockethixieconn'
local AjaxSocketConn = require 'lib.lua-websocket.ajaxsocketconn'
-- local digest = require 'lib.lua-websocket.digest'
local sha1 = require 'lib.sha1'
local sha2 = require 'lib.sha2'

local result
local bit = bit32
if not bit then
	result, bit = pcall(require, 'bit32')
end
if not bit then
	result, bit = pcall(require, 'bit')
end

-- coroutine function that blocks til it gets something
local function receiveBlocking(conn, waitduration, secondsTimerFunc)
	coroutine.yield()

	local endtime
	if waitduration then 
		endtime = secondsTimerFunc() + waitduration
	end
	local data
	repeat
		coroutine.yield()
		local reason
		data, reason = conn:receive('*l')
		if not data then
			if reason ~= 'timeout' then
				return nil, reason		-- error() ?
			end
			-- else continue
			if waitduration and secondsTimerFunc() > endtime then
				return nil, 'timeout'
			end
		end
	until data ~= nil

	return data
end

local function mustReceiveBlocking(conn, waitduration, secondsTimerFunc)
	local recv, reason = receiveBlocking(conn, waitduration, secondsTimerFunc)
	if not recv then error("Server waiting for handshake receive failed with error "..tostring(reason)) end
	return recv
end


local Server = class()

-- used for indexing conns, and mapping the Server.conns table keys
Server.nextConnUID = 1

-- class for instanciation of connections
Server.connClass = require 'lib.lua-websocket.simpleconn'

-- default port goes here
Server.port = 27000

-- TODO log levels
Server.logging = true

--[[
args:
	hostname - to be sent back via socket header
	threads = (optional) ThreadManager.  if you provide one then you have to update it manually.
	address (default is *)
	port (default is 27000)
	getTime (optional) = fraction-of-seconds-accurate timer function.  default requires either FFI or an external C binding or os.clock ... or you can provide your own.
--]]
function Server:init(args)
	args = args or {}
	self.port = args.port or 1234

	self.getTime = args.getTime or require 'lib.lua-websocket.gettimeofday'

	self.conns = table()
	self.ajaxConns = table()	-- mapped from sessionID

	-- self.threads = args.threads or 1
	self.threads = ThreadManager()
	self.ownThreads = true

	local address = args.address or '*'
	self.hostname = args.hostname or "local"
	if self.logging then
		log:info("hostname "..tostring(self.hostname))
		log:info("binding to "..tostring(address)..":"..tostring(self.port))	
	end
	self.socket = assert(socket.bind(address, self.port))
	self.socketaddr, self.socketport = self.socket:getsockname()
	if self.logging then
		log:info('listening '..self.socketaddr..':'..self.socketport)
	end
	self.socket:settimeout(0, 'b')
end

function Server:getNextConnUID()
	local uid = self.nextConnUID
	self.nextConnUID = self.nextConnUID + 1
	return uid
end


function Server:update()
	-- socket.sleep(.001)

	-- listen for new connections
	local client = self.socket:accept()
	if client then
		log:info('got connection!', client)
		log:info('connection from', client:getpeername())
		-- why is this accepting connections twice?
		-- is the browser really reconnecting, or is luasocket messing up?
		self.threads:add(self.connectRemoteCoroutine, self, client)
	end

	-- now handle connections
	for i,conn in pairs(self.conns) do
		if not conn:isActive() then
			-- only remove conns here ... using the following ...
			if conn.onRemove then
				conn:onRemove()
			end
			if AjaxSocketConn:isa(conn.socketImpl) then
				assert(self.ajaxConns[conn.socketImpl.sessionID] == conn)
				self.ajaxConns[conn.socketImpl.sessionID] = nil
				if self.logging then
					log:info(self.getTime(),'removing ajax conn',conn.socketImpl.sessionID)
				end
			else
				if self.logging then
					log:info(self.getTime(),'removing websocket conn')
				end
			end
			self.conns[i] = nil	
		else
			if conn.update then
				conn:update()
			end
		end
	end

	if self.ownThreads then
		self.threads:update()
	end
end

-- run loop
function Server:run()
	xpcall(function()
		while not self.done do
			self:update()
		end

		for _,conn in pairs(self.conns) do
			if conn.onRemove then
				conn:onRemove()
			end
			-- conn:close()	-- TODO should this be before onRemove() ?
		end
	end, function(err)
		self:traceback(err)
	end)
end

function Server:traceback(err)
	if err then io.stderr:write(err..'\n') end
	io.stderr:write(debug.traceback()..'\n')

	-- and all other threads?
	for _,thread in ipairs(self.threads.threads) do
		io.stderr:write('\n')
		io.stderr:write(tostring(thread)..'\n')
		io.stderr:write(debug.traceback(thread)..'\n')
	end
	
	io.stderr:flush()
end

function Server:delay(duration, callback, ...)
	local args = {...}
	local callingTrace = debug.traceback()
	self.threads:add(function()
		coroutine.yield()
		local thisTime = self.getTime()
		local startTime = thisTime 
		local endTime = thisTime + duration
		repeat
			coroutine.yield()
			thisTime = self.getTime()
		until thisTime > endTime
		xpcall(function()
			callback(table.unpack(args))
		end, function(err)
			io.stderr:write(tostring(err)..'\n')
			io.stderr:write(debug.traceback())
			io.stderr:write(callingTrace)
		end)
	end)
end

local function be32ToStr(n)
	local s = ''
	for i=1,4 do
		s = string.char(bit.band(n, 0xff)) .. s
		n = bit.rshift(n, 8)
	end
	return s
end

-- create a remote connection
function Server:connectRemoteCoroutine(client)
	client:settimeout(0, 'b')	-- for the benefit of coroutines ...
	client:setoption('keepalive', true)

	-- chrome has a bug where it connects and asks for a favicon even if there is none, or something, idk ...
	local firstLine, reason = receiveBlocking(client, 5, self.getTime)
	if self.logging then
		log:info(self.getTime(),client,'>>',firstLine,reason)
	end
	if not (firstLine == 'GET / HTTP/1.1' or firstLine == 'POST / HTTP/1.1') then
		if self.logging then
			log:info('got a non-http conn')
		end
		return
	end
	
	local header = table()
	while true do
		local recv = mustReceiveBlocking(client, 1, self.getTime)
		if self.logging then
			log:info(self.getTime(),client,'>>',recv)
		end
		if recv == '' then break end
		local k,v = recv:match('^(.-): (.*)$')
		k = k:lower()
		header[k] = v
	end
	-- TODO make sure you got the right keys

	local cookies = table()
	if header.cookie then
		for kv in header.cookie:gmatch('(.-);%s?') do 
			local k,v = kv:match('(.-)=(.*)')
			cookies[k] = v
		end
	end

	-- handle websockets
	-- IE doesn't give back an 'upgrade'
	if header.upgrade and header.upgrade:lower() == 'websocket' then
		-- RFC websockets
		local key = header['sec-websocket-key']
		local magic = key .. '258EAFA5-E914-47DA-95CA-C5AB0DC85B11'

		-- local sha1response = digest('sha1', magic, true)
		local sha1response = sha1.binary(magic)
		local response = mime.b64(sha1response)

		for _,line in ipairs{
			'HTTP/1.1 101 Switching Protocols\r\n',
			'Upgrade: websocket\r\n',
			'Connection: Upgrade\r\n',
			'server: lua\r\n',
			'Sec-WebSocket-Accept: '..response..'\r\n',
			'\r\n',
		} do
			log:info(self.getTime(),client,'<<'..line:match('^(.*)\r\n$'))
			client:send(line)
		end

		-- only add to Server.conns through *HERE*
		if self.logging then
			log:info(self.getTime(),'creating websocket conn')
		end
		local serverConn = self.connClass{
			server = self,
			socket = client,
			implClass = WebSocketConn,
		}
		if self.logging then
			log:info('constructing ServerConn',serverConn,'...')
		end
		self.lastActiveConnTime = self.getTime()
		return
	end

	-- handle ajax connections

	local serverConn 

	local body, err, partial = client:receive(tonumber(header['content-length']) or '*a')
	body = body or partial
	if self.logging then
		log:info(self.getTime(),client,'>>',body)
	end
	local receiveQueue = json:decode(body)
	local sessionID
	if not receiveQueue then
		if self.logging then
			log:info('failed to decode ajax body',body)
		end
		receiveQueue = {}
	else
		if #receiveQueue > 0 then
			local msg = receiveQueue[1]
			if msg:sub(1,10) == 'sessionID ' then
				table.remove(receiveQueue, 1)
				sessionID = msg:sub(11)
			end
		end
	end
	if self.logging then
		log:info('got session id', sessionID)
	end

	local newSessionID
	if sessionID then	-- if the client has a sessionID then ...
		-- see if the server has an ajax connection wrapper waiting ...
		serverConn = self.ajaxConns[sessionID]
		-- these are fake conn objects -- they merge multiple conns into one polling fake conn
		-- so headers and data need to be re-sent every time a new poll conn is made
	else
		newSessionID = true
		sessionID = mime.b64(digest('sha1', header:values():concat()..os.date(), true))
		if self.logging then
			log:info('generating session id', sessionID)
		end
	end
	-- no pre-existing connection? make a new one
	if serverConn then
		if self.logging then
			log:info(self.getTime(),'updating ajax conn')
		end
	else
		if self.logging then
			log:info(self.getTime(),'creating ajax conn',sessionID,newSessionID)
		end
		serverConn = self.connClass{
			server = self,
			implClass = AjaxSocketConn,
			sessionID = sessionID,
		}
		self.ajaxConns[sessionID] = serverConn
		self.lastActiveConnTime = self.getTime()
	end

	-- now hand it off to the serverConn to process sends & receives ...
	local responseQueue = serverConn.socketImpl:poll(receiveQueue)
	if newSessionID then
		table.insert(responseQueue, 1, 'sessionID '..sessionID)
	end
	local response = json:encode(responseQueue)
	
	if self.logging then
		log:info('sending ajax response size',#response,'body',response)
	end

	-- send response header
	local lines = table()
	lines:insert('HTTP/1.1 200 OK\r\n')
	lines:insert('Date '..os.date('!%a, %d %b %Y %T')..' GMT\r\n')
	lines:insert('Content-Type: text/plain\r\n') --droid4 default browser is mystery crashing... i suspect it cant handle json responses...
	lines:insert('Content-Length: '..#response..'\r\n')
	lines:insert('Access-Control-Allow-Origin: *\r\n')
	lines:insert('Connection: close\r\n')		-- IE needs this
	lines:insert('\r\n')
	lines:insert(response..'\r\n')
	
	for _,line in ipairs(lines) do
		if self.logging then
			log:info(client,'<<'..line:match('^(.*)\r\n$'))
		end
		client:send(line)
	end

	client:close()
end

return Server
