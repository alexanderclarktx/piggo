local Server = {}
local socket = require "socket"
local json = require "lib.json"
local hero = require "lib.hero"
local Player = require "src.game.Player"
local Skelly = require "src.game.characters.Skelly"

local update, gameTick
local defaultPort = 12345
local tickrate = 64

-- ref https://love2d.org/wiki/Tutorial:Networking_with_UDP
-- ref https://web.archive.org/web/20200415042448/http://w3.impa.br/~diego/software/luasocket/udp.html
function Server.new(game, port)
    assert(game)
    local udp = socket.udp()
    udp:settimeout(0)
    udp:setsockname("*", port or defaultPort)

    game:load()

    local server = {
        update = update, gameTick = gameTick,
        port = port or defaultPort, udp = udp,
        game = game, dt = 0,
        lastTick = 0, tickrate = 64,
        tickClientDataBuffer = {},
        connectedClients = {}
    }

    return server
end

local function deepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            v = deepCopy(v)
        end
        copy[k] = v
    end
    return copy
end

function update(self, dt)
    -- debug(#self.connectedClients)
    self.dt = self.dt + dt

    local clientData, msgOrIp, portOrNil

    -- buffer all data received from the clients
    while true do
        clientData, msgOrIp, portOrNil = self.udp:receivefrom()
        if clientData == nil then break end

        -- get the client's name (ip;port)
        local clientIpPort = string.format("%s;%s", tostring(msgOrIp), tostring(portOrNil))

        -- if this client has no record, create their player/character and add them
        if not self.connectedClients[clientIpPort] then
            self.game:addPlayer(Player.new(clientIpPort, Skelly.new(self.game.state.world, 500, 250, 500)))
            self.connectedClients[clientIpPort] = "a"
            self.tickClientDataBuffer[clientIpPort] = {}
        end

        -- buffer this input
        table.insert(self.tickClientDataBuffer[clientIpPort], clientData)
    end
    -- print(#self.connectedClients)

    -- server tick
    if self.lastTick == 0 or (self.dt - self.lastTick >= 1.0/self.tickrate) then
        -- print("gametick")
        self:gameTick(dt)
        -- TODO always send to existing clients, not just those who have sent a message this tick
        for ipAndPort, _ in pairs(self.tickClientDataBuffer) do
            -- print("server send")
            local ip, port = ipAndPort:match("([%w:]+);(%w+)")

            self.game.state.world = hero.save(self.game.state.world)
            self.udp:sendto(json:encode(self.game.state.world), ip, port)
            self.game.state.world = hero.load(self.game.state.world)
                -- {
                -- players = deepCopy(self.game.state.players),
                -- npcs = self.game.state.npcs,
                -- hurtboxes = self.game.state.hurtboxes,
                -- objects = self.game.state.objects,
                -- terrains = deepCopy(self.game.state.terrains),
                -- dt = self.game.state.dt,
                -- world = hero.save(self.game.state.world)
            -- }), ip, port)
            -- self.udp:sendto("hello mr client", ip, port)
        end
        -- self.tickClientDataBuffer = {}
    end
end

-- TODO maintain list of validated clients & their IPs
function gameTick(self, dt)
    -- self.game:update(dt, self.tickClientDataBuffer)
    self.game:update(dt)
    self.lastTick = self.dt
end

return Server
