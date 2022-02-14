local IGame = {}
local DamageController = require "src.piggo.core.DamageController"
local p = require 'love.physics'

local load, update, draw, addPlayer, handlePlayerCommands

-- IGame is a baseclass for all games, controlling game logic, gui, player interfaces
-- the state must be initialized with a first player
function IGame.new(gameLoad, gameUpdate, gameDraw)
    assert(gameLoad and gameUpdate and gameDraw)

    local damageController = DamageController.new()

    local iGame = {
        gameLoad = gameLoad, gameUpdate = gameUpdate, gameDraw = gameDraw,
        load = load, update = update, draw = draw,
        handlePlayerCommands = handlePlayerCommands,
        damageController = damageController,
        addPlayer = addPlayer,
        state = {
            players = {}, npcs = {}, hurtboxes = {}, objects = {}, terrains = {},
            world = p.newWorld(),
            frame = 0
        }
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
function handlePlayerCommands(self, playerName, commands)
    for _, command in ipairs(commands) do
        log.debug("command ", playerName, command.action, command.frame, self.state.frame)
        if command.action == "stop" then
            self.state.players[playerName].character.state.marker = nil
            self.state.players[playerName].character.state.target = nil
            self.state.players[playerName].character.body:setLinearVelocity(0, 0)
        elseif command.action == "move" then
            assert(command.marker)
            self.state.players[playerName].character.state.marker = command.marker
        end
    end
end

function addPlayer(self, playerName, player)
    assert(playerName and player)
    self.state.players[playerName] = player
end

return IGame
