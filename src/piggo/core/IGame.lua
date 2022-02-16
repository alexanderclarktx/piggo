local IGame = {}
local physics = require 'love.physics'
local DamageController = require "src.piggo.core.DamageController"

local load, update, draw
local addPlayer, handlePlayerCommand, serialize, deserialize

-- IGame is a baseclass for all games, controlling game logic, gui, player interfaces
-- the state must be initialized with a first player
function IGame.new(gameLoad, gameUpdate, gameDraw)
    assert(gameLoad and gameUpdate and gameDraw)

    local damageController = DamageController.new()

    local iGame = {
        state = {
            players = {}, npcs = {}, hurtboxes = {}, objects = {}, terrains = {},
            world = physics.newWorld(),
            frame = 0,
            damageController = damageController,
        },
        gameLoad = gameLoad, gameUpdate = gameUpdate, gameDraw = gameDraw,
        load = load, update = update, draw = draw,
        handlePlayerCommand = handlePlayerCommand,
        addPlayer = addPlayer,
        serialize = serialize,
        deserialize = deserialize,
    }

    return iGame
end

function load(self)
    self:gameLoad()
    -- assert(#self.state.players >= 1 and self.state.camera and self.state.world)
end

function update(self)
    -- increment frame and dt
    self.state.frame = self.state.frame + 1

    -- update damage controller
    self.state.damageController:update(self.state)

    -- update all internal states
    for _, player in pairs(self.state.players) do player:update(self.state) end

    -- update all npcs
    for index, npc in pairs(self.state.npcs) do npc:update(self.state) end

    -- handle non-player non-npc objects
    for _, object in pairs(self.state.objects) do object:update() end

    -- update game loop
    self.gameUpdate(self)

    -- collisions
    self.state.world:update(1.0/100)
end

function draw(self)
    self.gameDraw()
end

-- validate/process a player command
function handlePlayerCommand(self, playerName, command)
    local player = self.state.players[playerName]
    if command.action == "stop" then
        player.state.character.state.marker = nil
        player.state.character.state.target = nil
        player.state.character.state.body:setLinearVelocity(0, 0)
    elseif command.action == "move" then
        assert(command.marker)
        player.state.character.state.marker = command.marker
    elseif command.action == "cast" then
        assert(command.ability and command.mouseX and command.mouseY)
        player.state.character.state.abilities[command.ability]:cast(player.state.character, command.mouseX, command.mouseY)
    end
end

function addPlayer(self, playerName, player)
    assert(playerName and player)
    self.state.players[playerName] = player
end

-- serialize into a single table ready for json encoding
function serialize(self)
    local framedata = {
        players = {}
    }

    for playerName, player in pairs(self.state.players) do
        framedata.players[playerName] = player:serialize()
    end

    for _, npc in pairs(self.state.npcs) do

    end

    return framedata
end

function deserialize(self, state)
    for playerName, player in pairs(state.players) do
        self.state.players[playerName]:setPosition(
            player.character.x,
            player.character.y,
            player.character.velocity
        )
    end
end

return IGame
