local AutoChess = {}
local IGame = require "piggo-core.IGame"
local Terrain = require "piggo-core.Terrain"
local ChessBoard = require "piggo-contrib.autochess.ChessBoard"

local backgroundColor = {78/256.0, 144/256.0, 244/256.0}

local load, update, draw, handleMouseMoved, spawnTerrain

function AutoChess.new()
    local autoChess = IGame.new(load, update, draw, handleMouseMoved)

    -- autoChess.spawnTerrain = spawnTerrain
    autoChess.state.chessboard = ChessBoard.new()

    return autoChess
end

function load(self)
    -- self:spawnTerrain()
end

function update(self)

end

function draw(self)
    love.graphics.setBackgroundColor(backgroundColor)

    self.state.chessboard:draw()
end

function handleMouseMoved(self, x, y, state)
    -- for _, terrain in ipairs(self.state.terrains) do
    --     terrain:handleMouseMoved(x, y, state)
    -- end
    self.state.chessboard:handleMouseMoved(x, y, state)
end

function spawnTerrain(self)
    self.state.terrains = {
        Terrain.new(self.state.world, 0, 0, {
            0, -100,
            0, 0,
            1000, 0,
            1000, -100,
        }),
        Terrain.new(self.state.world, 0, 0, {
            1000, 0,
            1000, -100,
            1600, 600,
            1500, 600,
        }),
        Terrain.new(self.state.world, 0, 0, {
            0, 0,
            0, -100,
            -600, 600,
            -500, 600,
        }),
        Terrain.new(self.state.world, 0, 0, {
            -600, 600,
            -500, 600,
            -500, 1200,
            -600, 1200,
        }),
        Terrain.new(self.state.world, 0, 0, {
            -600, 1200,
            -600, 1300,
            1600, 1300,
            1600, 1200,
        }),
        Terrain.new(self.state.world, 0, 0, {
            1600, 1200,
            1500, 1200,
            1500, 600,
            1600, 600,
        })
    }
end

return AutoChess
