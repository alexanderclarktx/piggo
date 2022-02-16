local IGame = {}
local physics = require 'love.physics'
local DamageController = require "src.piggo.core.DamageController"

local load, update, draw
local addPlayer, handlePlayerCommand, serialize, apply

-- IGame is a baseclass for all games, controlling game logic, gui, player interfaces
-- the state must be initialized with a first player
function IGame.new(gameLoad, gameUpdate, gameDraw)
    assert(gameLoad and gameUpdate and gameDraw)

    local damageController = DamageController.new()

    local iGame = {
        state = {
            players = {}, npcs = {}, hurtboxes = {}, objects = {}, terrains = {},
            world = physics.newWorld(),
            frame = 0
        },
        gameLoad = gameLoad, gameUpdate = gameUpdate, gameDraw = gameDraw,
        load = load, update = update, draw = draw,
        handlePlayerCommand = handlePlayerCommand,
        damageController = damageController,
        addPlayer = addPlayer,
        serialize = serialize,
        apply = apply,
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
    self.damageController:update(self.state)

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

-- validate/process every player's commands
function handlePlayerCommand(self, playerName, command)
    if command.action == "stop" then
        self.state.players[playerName].character.state.marker = nil
        self.state.players[playerName].character.state.target = nil
        self.state.players[playerName].character.body:setLinearVelocity(0, 0)
    elseif command.action == "move" then
        assert(command.marker)
        self.state.players[playerName].character.state.marker = command.marker
    end
end

function addPlayer(self, playerName, player)
    assert(playerName and player)
    self.state.players[playerName] = player
end

-- serialize into a single table ready for json encoding
function serialize(self)
    local framedata = {
        players = {},
        abilities = {},
        attacks = {},
        effects = {},
        damage = {}
    }

    for playerName, player in pairs(self.state.players) do
        local velocityX, velocityY = player.character.body:getLinearVelocity()

        framedata.players[playerName] = {
            x = player.character.body:getX(),
            y = player.character.body:getY(),
            velocity = {
                x = velocityX,
                y = velocityY
            }
        }
    end

    return framedata
end

function apply(self, state)
    for playerName, player in pairs(state.players) do
        self.state.players[playerName]:setPosition(
            player.x,
            player.y,
            player.velocity
        )
    end
end

return IGame
