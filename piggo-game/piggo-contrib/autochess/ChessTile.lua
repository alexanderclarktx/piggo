local ChessTile = {}
local Clickable = require "piggo-core.Clickable"

local update, draw, handleMouseMoved

local tileSize = 125
local bgColor = {0.45, 0.35, 0.45}

function ChessTile.new(i, j)
    local poly = {
        0 + tileSize*i, 0 + tileSize*j,
        0 + tileSize*i, tileSize + tileSize*j,
        tileSize + tileSize*i, tileSize + tileSize*j,
        tileSize + tileSize*i, 0 + tileSize*j,
    }
    local tile = {
        state = {
            poly = poly,
            color = bgColor,
            i = i, j = j,
            clickable = Clickable.new(
                poly,
                function(this)
                    this.state.color = {0, 1, 0}
                end,
                function(this)
                    this.state.color = bgColor
                end,
                nil
            )
        },
        update = update, draw = draw,
        handleMouseMoved = handleMouseMoved,
    }
    return tile
end

function update(self)

end

function draw(self)
    love.graphics.setColor(self.state.color)
    love.graphics.polygon(
        "fill",
        unpack(self.state.poly)
    )
    self.state.clickable:draw()
end

function handleMouseMoved(self, x, y, state)
    self.state.clickable:handleMouseMoved(x, y, state, self)
end

return ChessTile
