local Server = {}
local socket = require "socket"

local json = require "lib.json"
-- local hero = require "lib.hero"

local Player = require "src.piggo.core.Player"
local Skelly = require "src.contrib.aram.characters.Skelly"

local update, gameTick, openSocket, createGameTickPayload, createPlayerTickPayload, connectPlayer
local defaultPort = 12345

-- ref https://love2d.org/wiki/Tutorial:Networking_with_UDP
-- ref https://web.archive.org/web/20200415042448/http://w3.impa.br/~diego/software/luasocket/udp.html
function Server.new(game, port)
    assert(game)

    -- open the server socket
    local udp = openSocket(port or defaultPort)

    game:load()

    local server = {
        update = update, gameTick = gameTick,
        createGameTickPayload = createGameTickPayload,
        createPlayerTickPayload = createPlayerTickPayload,
        connectPlayer = connectPlayer,
        udp = udp, -- udp socket
        game = game, -- game object
        dt = 0, -- millis since server start
        tick = 0, -- current tick
        lastTick = 0,
        tickrate = 64, -- server ticks per second
        connectedPlayers = {}
    }

    return server
end

function update(self, dt)
    -- debug("players connected: " .. tostring(#self.connectedPlayers))
    self.dt = self.dt + dt

    local playerCommand, msgOrIp, portOrNil

    -- buffer all data received from the players
    while true do
        -- check for data from players, breaking when nothing's left to receive
        playerCommandsJson, msgOrIp, portOrNil = self.udp:receivefrom()
        if playerCommandsJson == nil then break end
        assert(msgOrIp and portOrNil)

        -- if this player has no record, create their player/character and add them
        local playerName = "KetoMojito" -- TODO get from player's connect payload
        if not self.connectedPlayers[playerName] then
            self:connectPlayer(playerName, playerCommand, msgOrIp, portOrNil)
        end

        -- handle all player commands
        local playerCommands = json:decode(playerCommandsJson)
        for _, playerCommand in ipairs(playerCommands) do
            -- add command to player's command buffer
            if playerCommand.action ~= nil then
                if playerCommand.action == "stop" then
                    debug("adding stop command to player.commands")
                    table.insert(self.connectedPlayers[playerName].commands, playerCommand)
                end
            end
        end
    end

    -- server tick
    if self.lastTick == 0 or (self.dt - self.lastTick >= 1.0/self.tickrate) then
        -- game tick
        self:gameTick(dt)

        -- create game tick payload
        local gameTickPayload = self:createGameTickPayload()

        -- send everyone the game and player states
        for _, player in pairs(self.connectedPlayers) do
            -- create player tick payload
            local playerTickPayload = self:createPlayerTickPayload(player)

            -- send the tick payloads
            self.udp:sendto(json:encode({
                gameTickPayload = gameTickPayload,
                playerTickPayload = playerTickPayload
            }), player.ip, player.port)
        end
    end
end

-- connect a new player
function connectPlayer(self, playerName, playerCommand, msgOrIp, portOrNil)
    -- add the player to the game
    local player = Player.new(playerName, Skelly.new(self.game.state.world, 500, 250, 500))
    self.game:addPlayer(playerName, player)
    player.character.body:setLinearVelocity(200, 0)

    -- add player to connectedPlayers
    self.connectedPlayers[playerName] = {
        player = player,
        ip = msgOrIp,
        port = portOrNil,
        commands = {}
    }
end

-- prepare data for all players
function createGameTickPayload(self)
    local gameTickPayload = {
        players = {},
        abilities = {},
        attacks = {},
        effects = {},
        damage = {}
    }

    for playerName, player in pairs(self.connectedPlayers) do
        local velocityX, velocityY = player.player.character.body:getLinearVelocity()

        gameTickPayload.players[playerName] = {
            x = player.player.character.body:getX(),
            y = player.player.character.body:getY(),
            velocity = {
                x = velocityX,
                y = velocityY
            }
        }
    end

    return gameTickPayload
end

-- prepare data for the individual player
function createPlayerTickPayload(self, player)
    local playerTickPayload = {
        -- cds = player.cooldowns
    }
    return playerTickPayload
end

-- run the game tick
function gameTick(self, dt)
    -- increment tick number
    self.tick = self.tick + 1

    -- handle all the buffered player commands
    self.game:handlePlayerCommands(self.connectedPlayers)

    -- reset tick state
    for _, player in pairs(self.connectedPlayers) do
        player.commands = {}
    end

    -- update the game
    self.game:update(dt)

    -- record the last tick time
    self.lastTick = self.dt
end

-- open server socket
function openSocket(port)
    local udp = socket.udp()
    udp:settimeout(0)
    udp:setsockname("*", port)
    return udp
end

return Server
