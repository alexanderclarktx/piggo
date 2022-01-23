local Server = {}
local socket = require "socket"

local update, gameTick
local defaultPort = 12345
local tickrate = 64

-- ref https://love2d.org/wiki/Tutorial:Networking_with_UDP
-- ref https://web.archive.org/web/20200415042448/http://w3.impa.br/~diego/software/luasocket/udp.html
function Server.new(game, port)
    local udp = socket.udp()
    udp:settimeout(0)
    udp:setsockname("*", port or defaultPort)

    local server = {
        update = update, gameTick = gameTick,
        port = port or defaultPort, udp = udp,
        game = game, dt = 0,
        lastTick = 0, tickrate = 64,
        tickClientDataBuffer = {}
    }

    return server
end

function update(self, dt)
    self.dt = self.dt + dt

    local clientData, msgOrIp, portOrNil

    -- buffer all data received from the clients
    while true do
        clientData, msgOrIp, portOrNil = self.udp:receivefrom()
        if clientData == nil then break end

        -- if this client has no record, make an empty table
        if self.tickClientDataBuffer[string.format("%s;%s", tostring(msgOrIp), tostring(portOrNil))] == nil then
            self.tickClientDataBuffer[string.format("%s;%s", tostring(msgOrIp), tostring(portOrNil))] = {}
        end

        table.insert(
            self.tickClientDataBuffer[string.format("%s;%s", tostring(msgOrIp), tostring(portOrNil))],
            clientData
        )
    end

    -- server tick
    if self.lastTick == 0 or self.dt - self.lastTick <= 1.0/self.tickrate then
        -- self:gameTick(dt)
        for ipAndPort, _ in pairs(self.tickClientDataBuffer) do
            local ip, port = ipAndPort:match("([%w:]+);(%w+)")
            self.udp:sendto("hello mr client", ip, port)
        end
    end
end

-- TODO maintain list of validated clients & their IPs
function gameTick(self, dt)
    -- self.game:update(dt, self.tickClientDataBuffer)
    self.game:update(dt)
    self.lastTick = self.lastTick + dt
    self.tickClientDataBuffer = {}

    -- TODO remove all messages from buffer
end

return Server
