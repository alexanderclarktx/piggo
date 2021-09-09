local mlib = require 'lib.mlib'

local ShapeUtils = {}

function ShapeUtils.pointInCircle(pointx, pointy, circleX, circleY, radius)
    return mlib.circle.checkPoint(pointx, pointy, circleX, circleY, radius)
end

return ShapeUtils
