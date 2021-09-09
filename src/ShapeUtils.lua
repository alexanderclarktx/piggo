local mlib = require 'lib.mlib'

local ShapeUtils = {}

function ShapeUtils.pointInCircle(pointX, pointY, circleX, circleY, radius)
    return mlib.circle.checkPoint(pointX, pointY, circleX, circleY, radius)
end

-- https://love2d.org/wiki/polypoint
function ShapeUtils.pointInPolygon(pointX, pointY, vertices)
    local collision = false
    local next = 1
        for current = 1, #vertices do
        next = current + 1
        if (next > #vertices) then
            next = 1
        end
        local vc = vertices[current]
        local vn = vertices[next]
        if (((vc.y >= pointY and vn.y < pointY) or (vc.y < pointY and vn.y >= pointY)) and
                (pointX < (vn.x-vc.x)*(pointY-vc.y) / (vn.y-vc.y)+vc.x)) then
            collision = not(collision)
        end
        end
    return collision
end

return ShapeUtils
