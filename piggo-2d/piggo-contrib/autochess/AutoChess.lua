local AutoChess = {}
local IGame = require "piggo-core.IGame"
local Terrain = require "piggo-core.Terrain"
local ChessBoard = require "piggo-contrib.autochess.ChessBoard"

local backgroundColor = {78/256.0, 144/256.0, 244/256.0}

local load, update, draw, handleMouseMoved, spawnTerrain

function AutoChess.new()
    local autoChess = IGame.new(load, update, draw, handleMouseMoved)

    autoChess.state.chessboard = ChessBoard.new()

    return autoChess
end

function load(self) end

function update(self) end

function draw(self)
    love.graphics.setBackgroundColor(backgroundColor)
    self.state.chessboard:draw()
end

function handleMouseMoved(self, x, y, state)
    self.state.chessboard:handleMouseMoved(x, y, state)
end

return AutoChess
