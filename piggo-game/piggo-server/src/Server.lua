local Server = {}
local socket = require "socket"
local json = require "lib.json"
local wsserver = require "lib.lua-websocket.wsserver"
local Player = require "piggo-core.Player"
local Skelly = require "piggo-contrib.characters.Skelly"

local update, runFrame, openSocket, bufferPlayerInputs
local createPlayerFramePayload, connectPlayer
local defaultPort = 12345

function Server.new(game, port)
    assert(game)

    game:load()

    local server = {
        state = {
            connectedPlayers = {},
            dt = 0,
            framerate = 100,
            game = game,
            nextFrameTime = 0,
            -- udp = udp,
        },
        bufferPlayerInputs = bufferPlayerInputs,
        connectPlayer = connectPlayer,
        createPlayerFramePayload = createPlayerFramePayload,
        runFrame = runFrame,
        update = update,
    }

    openSocket(port or defaultPort, server)

    return server
end

function update(self, dt)
    -- increment time
    self.state.dt = self.state.dt + dt

    wsserver:update()

    -- buffer all data received from the players
    -- while self:bufferPlayerInputs() do end

    -- run game frame on 100fps schedule
    if self.state.dt - self.state.nextFrameTime > 0 then
        if self.state.nextFrameTime == 0 then self.state.nextFrameTime = self.state.dt end
        self.state.nextFrameTime = self.state.nextFrameTime + 1.0/self.state.framerate

        self:runFrame()
    end
end

function bufferPlayerInputs(self, playerCommands)
    -- if this player has no record, create their player/character and add them
    -- assert(msgOrIp and portOrNil)
    -- local playerName = "KetoMojito" -- TODO get from player's connect payload
    -- if not self.state.connectedPlayers[playerName] then
    --     self:connectPlayer(playerName, msgOrIp, portOrNil)
    -- end

    -- buffer all player commands
    -- local playerCommands = json:decode(playerCommandsJson)
    log:info(type(playerCommands))
    assert(playerCommands.name ~= nil)
    for _, playerCommand in ipairs(playerCommands.commands) do
        if playerCommand.action ~= nil then
            table.insert(self.state.connectedPlayers[playerCommands.name].commands, playerCommand)
        end
    end

    return true
end

-- run the game frame
function runFrame(self)
    -- handle all the buffered player commands
    for playerName, player in pairs(self.state.connectedPlayers) do
        local iToRemove = {}

        -- handle commands for this frame
        for i, command in ipairs(player.commands) do
            if command.frame < self.state.game.state.frame then
                table.insert(iToRemove, i)
            elseif command.frame == self.state.game.state.frame then
                log:debug("handling", playerName, command.action)
                self.state.game:handlePlayerCommand(playerName, command)
            end
        end

        -- clear old commands
        for _, i in ipairs(iToRemove) do
            table.remove(player.commands, i)
        end
    end

    -- update the game
    self.state.game:update()

    -- create game frame payload
    local gameFramePayload = self.state.game:serialize()

    -- send everyone the game and player states
    for _, player in pairs(self.state.connectedPlayers) do
        -- create player frame payload

        -- send the frame payloads
        self.state.udp:sendto(json:encode({
            gameFramePayload = gameFramePayload,
            -- playerFramePayload = createPlayerFramePayload(player),
            frame = self.state.game.state.frame
        }), player.ip, player.port)
    end
end

-- connect a new player
function connectPlayer(self, playerName, msgOrIp, portOrNil)
    log:info("connecting player", playerName)

    -- add the player to the game
    local player = Player.new(playerName, Skelly.new(self.state.game.state.world, 500, 250, 500))
    self.state.game:addPlayer(playerName, player)
    -- player.state.character.state.body:setLinearVelocity(200, 0)

    -- add player to connectedPlayers
    self.state.connectedPlayers[playerName] = {
        player = player,
        ip = msgOrIp,
        port = portOrNil,
        commands = {}
    }
end

-- prepare data for the individual player
function createPlayerFramePayload(player)
    local playerFramePayload = {
        player = {
            -- state = player.player.state,
            character = {
                state = player.player.state.character.state
            }
        }
    }
    return playerFramePayload
end

-- open server socket
function openSocket(port, s)
    wsserver:init({
        port = 12345,
        hostname = "localhost"
    })
    wsserver.s = s
    wsserver.connClass.received = function(self, data)
        log:info(data)
        self.server.s:bufferPlayerInputs(data)
        -- log:info(#wsserver.conns)
    end
    -- local udp = socket.tcp()
    -- udp:settimeout(0)
    -- udp:setsockname("*", port)
    -- return udp
end

return Server
