local ShapeUtils = {}
local mlib = require "lib.mlib"
local math = require "love.math"

-- point is inside rectangle
function ShapeUtils.pointInPolygon(pointX, pointY, ...)
    return mlib.polygon.checkPoint(pointX, pointY, ...)
end

-- point is inside a circle
function ShapeUtils.pointInCircle(pointX, pointY, circleX, circleY, radius)
    return mlib.circle.checkPoint(pointX, pointY, circleX, circleY, radius)
end

-- c2 is the larger circle
function ShapeUtils.circleInCircle(c1X, c1Y, c1Radius, c2X, c2Y, c2Radius)
    return mlib.circle.getCircleIntersection(c1X, c1Y, c1Radius, c2X, c2Y, c2Radius) or
        mlib.circle.checkPoint(c1X, c1Y, c2X, c2Y, c2Radius)
end

-- circle intersects or is within polygon
function ShapeUtils.circleInPolygon(circleX, circleY, radius, vertices)
    assert(vertices)
    return mlib.circle.isCircleInsidePolygon(circleX, circleY, radius, unpack(vertices)) or
        mlib.circle.getPolygonIntersection(circleX, circleY, radius, unpack(vertices))
end

-- returns the rotated vertices
function ShapeUtils.rotate(vertices, angle, originx, originy, scale)
    assert(#vertices > 0 and #vertices % 2 == 0)
    local t = math.newTransform(originx or 0, originy or 0, angle, scale or 1, scale or 1)

    local result = {}
    for i=1, #vertices, 2 do
        local newx, newy = t:transformPoint(vertices[i], vertices[i+1])
        table.insert(result, newx)
        table.insert(result, newy)
    end
    return result
end

return ShapeUtils
