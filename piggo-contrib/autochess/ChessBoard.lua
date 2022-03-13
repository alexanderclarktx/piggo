local ChessBoard = {}
local ChessTile = require "piggo-contrib.autochess.ChessTile"

local update, draw, handleMouseMoved

function ChessBoard.new()
    local chessBoard = {
        state = {
            tiles = {
                {ChessTile.new(0, 0), ChessTile.new(0, 1), ChessTile.new(0, 2), ChessTile.new(0, 3), ChessTile.new(0, 4), ChessTile.new(0, 5), ChessTile.new(0, 6), ChessTile.new(0, 7)},
                {ChessTile.new(1, 0), ChessTile.new(1, 1), ChessTile.new(1, 2), ChessTile.new(1, 3), ChessTile.new(1, 4), ChessTile.new(1, 5), ChessTile.new(1, 6), ChessTile.new(1, 7)},
                {ChessTile.new(2, 0), ChessTile.new(2, 1), ChessTile.new(2, 2), ChessTile.new(2, 3), ChessTile.new(2, 4), ChessTile.new(2, 5), ChessTile.new(2, 6), ChessTile.new(2, 7)},
                {ChessTile.new(3, 0), ChessTile.new(3, 1), ChessTile.new(3, 2), ChessTile.new(3, 3), ChessTile.new(3, 4), ChessTile.new(3, 5), ChessTile.new(3, 6), ChessTile.new(3, 7)},
                {ChessTile.new(4, 0), ChessTile.new(4, 1), ChessTile.new(4, 2), ChessTile.new(4, 3), ChessTile.new(4, 4), ChessTile.new(4, 5), ChessTile.new(4, 6), ChessTile.new(4, 7)},
                {ChessTile.new(5, 0), ChessTile.new(5, 1), ChessTile.new(5, 2), ChessTile.new(5, 3), ChessTile.new(5, 4), ChessTile.new(5, 5), ChessTile.new(5, 6), ChessTile.new(5, 7)},
                {ChessTile.new(6, 0), ChessTile.new(6, 1), ChessTile.new(6, 2), ChessTile.new(6, 3), ChessTile.new(6, 4), ChessTile.new(6, 5), ChessTile.new(6, 6), ChessTile.new(6, 7)},
                {ChessTile.new(7, 0), ChessTile.new(7, 1), ChessTile.new(7, 2), ChessTile.new(7, 3), ChessTile.new(7, 4), ChessTile.new(7, 5), ChessTile.new(7, 6), ChessTile.new(7, 7)},
            },
        },
        update = update, draw = draw,
        handleMouseMoved = handleMouseMoved
    }
    return chessBoard
end

function draw(self)
    -- draw the board
    -- love.graphics.setColor(.8, .6, 1, .4)
    -- love.graphics.rectangle("fill", 0, 0, self.state.dim.boardSize, self.state.dim.boardSize)

    -- draw each cell
    -- love.graphics.setColor(0, 0, 0, .4)
    for i, row in ipairs(self.state.tiles) do
        for j, tile in ipairs(row) do
            tile:draw()
        end
    end
end

function handleMouseMoved(self, x, y, state)
    for i, row in ipairs(self.state.tiles) do
        for j, tile in ipairs(row) do
            tile:handleMouseMoved(x, y, state)
        end
    end
end

return ChessBoard
