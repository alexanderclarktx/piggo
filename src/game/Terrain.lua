local Terrain = {}

local update, draw

function Terrain.new(poly)
    assert(#poly % 2 == 0)
    return {
        poly = poly,
        update = update, draw = draw
    }
end

-- maybe some terrain destruction
function update(self, dt)
    --
end

function draw(self)
    love.graphics.setColor(0.4, 0.2, 0.15)
    love.graphics.polygon("fill", self.poly)

    love.graphics.setColor(0.2, 0.6, 0.2, 0.5)
    love.graphics.polygon("line", self.poly)

    if debug() then
        for i=1, #self.poly, 2 do
            local debugVertices = "%d,%d"

            -- print the corner coordinates
            love.graphics.setColor(1, 1, 1)            
            love.graphics.print(
                debugVertices:format(self.poly[i], self.poly[i+1]),
                self.poly[i], self.poly[i+1] - 5
            )
        end
    end
end

return Terrain
