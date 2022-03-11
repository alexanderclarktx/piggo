local Clickable = {}
local ShapeUtils = require "src.piggo.util.ShapeUtils"

local update, handleMouseMoved

function Clickable.new(poly, onHover, onNotHover, onClick)
    print("...")
    for i, j in ipairs(poly) do print(j) end
    local clickable = {
        state = {
            poly = poly
        },
        update = update,
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

return Clickable
