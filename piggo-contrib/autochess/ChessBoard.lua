local ChessBoard = {}

local update, draw

function ChessBoard.new()
    local chessBoard = {
        state = {
            rows = {
                {{}, {}, {}, {}, {}, {}, {}, {}},
                {{}, {}, {}, {}, {}, {}, {}, {}},
                {{}, {}, {}, {}, {}, {}, {}, {}},
                {{}, {}, {}, {}, {}, {}, {}, {}},
                {{}, {}, {}, {}, {}, {}, {}, {}},
                {{}, {}, {}, {}, {}, {}, {}, {}},
                {{}, {}, {}, {}, {}, {}, {}, {}},
                {{}, {}, {}, {}, {}, {}, {}, {}},
            },
            dim = {
                boardSize = 1000,
                cellSize = 1000 / 8,
            }
        },
        update = update, draw = draw
    }
    return chessBoard
end

function draw(self)
    -- draw the board
    love.graphics.setColor(.8, .6, 1, .4)
    love.graphics.rectangle("fill", 0, 0, self.state.dim.boardSize, self.state.dim.boardSize)

    -- draw each cell
    love.graphics.setColor(0, 0, 0, .4)
    for i, row in ipairs(self.state.rows) do
        -- love.graphics.setColor(.7, .1 * i, .7, .8)
        for j, cell in ipairs(row) do
            love.graphics.rectangle(
                "line",
                self.state.dim.cellSize * (j - 1),
                self.state.dim.cellSize * (i - 1),
                self.state.dim.cellSize,
                self.state.dim.cellSize
            )
        end
    end
end

return ChessBoard
