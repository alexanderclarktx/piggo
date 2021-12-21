local Terrain = {}

local update, draw

function Terrain.new(x, y, poly)
    assert(#poly % 2 == 0)

    local body = love.physics.newBody(state.world, x, y, "static")
    local fixture = love.physics.newFixture(body, love.physics.newPolygonShape(poly))

    return {
        poly = poly,
        update = update, draw = draw,
        body = body, fixture = fixture
    }
end

-- maybe some terrain destruction
function update(self, dt)
    --
end

function draw(self)
    -- draw terrain
    love.graphics.setColor(0.85, 0.65, 0.4, 0.3)
    love.graphics.polygon("fill", self.body:getWorldPoints(unpack(self.poly)))

    -- draw terrain outlines
    if debug() then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.polygon("line", self.body:getWorldPoints(unpack(self.poly)))
    end

    -- print the corner coordinates
    if debug() then
        for i=1, #self.poly, 2 do
            local debugVertices = "%d,%d"

            love.graphics.setColor(1, 1, 1, 0.3)
            love.graphics.print(
                debugVertices:format(self.body:getWorldPoints(self.poly[i], self.poly[i+1])),
                self.body:getWorldPoints(self.poly[i], self.poly[i+1] - 5)
            )
        end
    end
end

return Terrain
