local mlib = require 'lib.mlib'

local ShapeUtils = {}

-- point is inside a circle
function ShapeUtils.pointInCircle(pointX, pointY, circleX, circleY, radius)
    return mlib.circle.checkPoint(pointX, pointY, circleX, circleY, radius)
end

-- circle intersects or is within polygon
function ShapeUtils.circleInPolygon(circleX, circleY, radius, vertices)
    return mlib.circle.isCircleInsidePolygon(circleX, circleY, radius, unpack(vertices)) or
        mlib.circle.getPolygonIntersection(circleX, circleY, radius, unpack(vertices))
end

-- returns the rotated vertices
function ShapeUtils.rotate(vertices, angle, originx, originy, scale)
    assert(#vertices > 0 and #vertices % 2 == 0)
    local t = love.math.newTransform(originx or 0, originy or 0, angle, scale or 1, scale or 1)

    local result = {}
    for i=1, #vertices, 2 do
        local newx, newy = t:transformPoint(vertices[i], vertices[i+1])
        table.insert(result, newx)
        table.insert(result, newy)
    end
    return result
end

return ShapeUtils
