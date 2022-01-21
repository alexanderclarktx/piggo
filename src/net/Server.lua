local socket = require "socket"

local Server = {}

local update
local defaultPort = 12345

-- ref https://love2d.org/wiki/Tutorial:Networking_with_UDP
function Server.new(port)
    local udp = socket.udp()
    udp:settimeout(0)
    udp:setsockname("*", port or defaultPort)

    local server = {
        update = update,
        port = port or defaultPort,
        udp = udp,
    }

    return server
end

function update(self, dt)
    data, msgOrIp, portOrNil = self.udp:receivefrom()
    if data then
        debug(data, msgOrIp, portOrNil)
    end
end

return Server
