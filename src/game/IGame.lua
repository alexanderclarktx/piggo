local IGame = {}
local DamageController = require "src.game.DamageController"

local load, update, draw, addPlayer

-- IGame is a baseclass for all games, controlling game logic, gui, player interfaces
-- the state must be initialized with a first player
function IGame.new(gameLoad, gameUpdate, gameDraw)
    assert(gameLoad and gameUpdate and gameDraw)

    local damageController = DamageController.new()

    return {
        gameLoad = gameLoad, gameUpdate = gameUpdate, gameDraw = gameDraw,
        load = load, update = update, draw = draw,
        damageController = damageController,
        addPlayer = addPlayer,
        state = {
            players = {}, npcs = {}, hurtboxes = {}, objects = {}, terrains = {},
            world = love.physics.newWorld(),
            dt = 0
        }
    }
end

function load(self)
    self:gameLoad()
    -- assert(#self.state.players >= 1 and self.state.camera and self.state.world)
end

function update(self, dt)
    -- increment state time
    self.state.dt = self.state.dt + dt

    -- update damage controller
    self.damageController:update(dt, self.state)

    -- update all internal states
    for _, player in pairs(self.state.players) do player:update(dt, self.state) end

    -- update all npcs
    for index, npc in pairs(self.state.npcs) do npc:update(dt, self.state) end

    -- handle non-player non-npc objects
    for _, object in pairs(self.state.objects) do object:update(dt) end

    -- update game loop
    self.gameUpdate(self)

    -- collisions
    self.state.world:update(dt)
end

function draw(self)
    self.gameDraw()
end

function addPlayer(self, player)
    assert(player)
    table.insert(self.state.players, player)
end

return IGame
