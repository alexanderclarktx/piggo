local Server = {}
local socket = require "socket"

local json = require "lib.json"

local Player = require "src.piggo.core.Player"
local Skelly = require "src.contrib.aram.characters.Skelly"

local update, runFrame, openSocket, bufferPlayerInputs
local createGameFramePayload, createPlayerFramePayload, connectPlayer
local defaultPort = 12345

-- ref https://love2d.org/wiki/Tutorial:Networking_with_UDP
-- ref https://web.archive.org/web/20200415042448/http://w3.impa.br/~diego/software/luasocket/udp.html
function Server.new(game, port)
    assert(game)

    -- open the server socket
    local udp = openSocket(port or defaultPort)

    game:load()

    local server = {
        update = update,
        runFrame = runFrame,
        bufferPlayerInputs = bufferPlayerInputs,
        createGameFramePayload = createGameFramePayload,
        createPlayerFramePayload = createPlayerFramePayload,
        connectPlayer = connectPlayer,
        udp = udp, -- udp socket
        game = game, -- game object
        dt = 0, -- millis since server start
        nextFrameTarget = 0,
        framerate = 100, -- server frames per second
        connectedPlayers = {}
    }

    return server
end

function update(self, dt)
    -- log.debug("players connected: " .. tostring(#self.connectedPlayers))
    self.dt = self.dt + dt

    -- buffer all data received from the players
    while self:bufferPlayerInputs() do end

    -- server frame
    if self.dt - self.nextFrameTarget > 0 then
        if self.nextFrameTarget == 0 then self.nextFrameTarget = self.dt end
        self.nextFrameTarget = self.nextFrameTarget + 1.0/self.framerate

        self:runFrame(dt)
    end
end

function bufferPlayerInputs(self)
    -- check for data from players, breaking when nothing's left to receive
    local playerCommandsJson, msgOrIp, portOrNil = self.udp:receivefrom()
    if playerCommandsJson == nil then return false end

    -- if this player has no record, create their player/character and add them
    assert(msgOrIp and portOrNil)
    local playerName = "KetoMojito" -- TODO get from player's connect payload
    if not self.connectedPlayers[playerName] then
        self:connectPlayer(playerName, msgOrIp, portOrNil)
    end

    -- buffer all player commands
    local playerCommands = json:decode(playerCommandsJson)
    for _, playerCommand in ipairs(playerCommands) do
        if playerCommand.action ~= nil then
            table.insert(self.connectedPlayers[playerName].commands, playerCommand)
        end
    end

    return true
end

-- run the game frame
function runFrame(self, dt)
    -- handle all the buffered player commands
    for playerName, player in pairs(self.connectedPlayers) do
        self.game:handlePlayerCommands(playerName, player.commands)
    end

    -- clear command buffer
    for _, player in pairs(self.connectedPlayers) do
        player.commands = {}
    end

    -- update the game
    self.game:update(dt)

    -- create game frame payload
    local gameFramePayload = self:createGameFramePayload()

    -- send everyone the game and player states
    for _, player in pairs(self.connectedPlayers) do
        -- create player frame payload
        local playerFramePayload = createPlayerFramePayload(player)

        -- send the frame payloads
        self.udp:sendto(json:encode({
            gameFramePayload = gameFramePayload,
            playerFramePayload = playerFramePayload,
            frame = self.game.state.frame
        }), player.ip, player.port)
    end
end

-- connect a new player
function connectPlayer(self, playerName, msgOrIp, portOrNil)
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
function createGameFramePayload(self)
    local gameFramePayload = {
        players = {},
        abilities = {},
        attacks = {},
        effects = {},
        damage = {}
    }

    for playerName, player in pairs(self.connectedPlayers) do
        local velocityX, velocityY = player.player.character.body:getLinearVelocity()

        gameFramePayload.players[playerName] = {
            x = player.player.character.body:getX(),
            y = player.player.character.body:getY(),
            velocity = {
                x = velocityX,
                y = velocityY
            }
        }
    end

    return gameFramePayload
end

-- prepare data for the individual player
function createPlayerFramePayload(player)
    local playerFramePayload = {
        player = {
            state = player.player.state,
            character = {
                state = player.player.character.state
            }
        }
    }
    return playerFramePayload
end

-- open server socket
function openSocket(port)
    local udp = socket.udp()
    udp:settimeout(0)
    udp:setsockname("*", port)
    return udp
end

return Server
