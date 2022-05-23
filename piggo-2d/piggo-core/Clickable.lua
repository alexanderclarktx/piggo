local Clickable = {}
local ShapeUtils = require "piggo-core.util.ShapeUtils"

local update, draw, handleMouseMoved

function Clickable.new(poly, onHover, onNotHover, onClick)
    local clickable = {
        state = {
            poly = poly
        },
        update = update, draw = draw,
        onHover = onHover, onNotHover = onNotHover, onClick = onClick,
        handleMouseMoved = handleMouseMoved,
    }
    return clickable
end

function handleMouseMoved(self, x, y, _, callbackhandle)
    if ShapeUtils.pointInPolygon(x, y, self.state.poly) then
        self.onHover(callbackhandle)
    else
        self.onNotHover(callbackhandle)
    end
end

function draw(self)
    love.graphics.setColor(1, 1, 1)
    love.graphics.polygon("line", self.state.poly)
end

return Clickable
