local Arena = {}
local Game = require "piggo-core.Game"
local Terrain = require "piggo-core.Terrain"

local backgroundColor = {78/256.0, 144/256.0, 244/256.0}

local load, update, draw, handleMouseMoved, spawnTerrain

function Arena.new()
    local arena = Game.new(load, update, draw, handleMouseMoved)

    arena.spawnTerrain = spawnTerrain

    return arena
end

function load(self)
    self:spawnTerrain()
end

function update(self)

end

function draw(self)
    love.graphics.setBackgroundColor(backgroundColor)
end

function handleMouseMoved(self, x, y, state)
    for _, terrain in ipairs(self.state.terrains) do
        terrain:handleMouseMoved(x, y, state)
    end
end

function spawnTerrain(self)
    self.state.terrains = {
        Terrain.new(self.state.world, 0, 0, {
            0, 0,
            0, 100,
            1000, 100,
            1000, 0,
        }),
        Terrain.new(self.state.world, 0, 0, {
            1000, 100,
            1000, 0,
            1600, 600,
            1500, 600,
        }),
        Terrain.new(self.state.world, 0, 0, {
            0, 100,
            0, 0,
            -600, 600,
            -500, 600,
        }),
        Terrain.new(self.state.world, 0, 0, {
            -600, 600,
            -500, 600,
            -500, 1600,
            -600, 1600,
        }),
        Terrain.new(self.state.world, 0, 0, {
            -500, 1600,
            -600, 1600,
            0, 2300,
            0, 2200,
        }),
        Terrain.new(self.state.world, 0, 0, {
            0, 2300,
            0, 2200,
            1000, 2200,
            1000, 2300,
        }),
        Terrain.new(self.state.world, 0, 0, {
            1000, 2200,
            1000, 2300,
            1600, 1600,
            1500, 1600,
        }),
        Terrain.new(self.state.world, 0, 0, {
            1600, 1600,
            1500, 1600,
            1500, 600,
            1600, 600,
        })
    }
end

return Arena
