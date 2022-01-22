local Client = {}
local socket = require "socket"

local update
local defaultHost = "localhost"
local defaultPort = 12345

-- ref https://love2d.org/wiki/Tutorial:Networking_with_UDP
function Client.new(host, port)
    local udp = socket.udp()
    udp:settimeout(0)
    udp:setpeername(host or defaultHost, port or defaultPort)

    local client = {
        update = update,
        host = host or defaultHost,
        port = port or defaultPort,
        udp = udp,
    }

    return client
end

function update(self, dt)
    self.udp:send("hello world")
end

return Client
