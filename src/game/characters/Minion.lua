local Minion = {}
local ShapeUtils = require "src.util.shapeutils"
local ICharacter = require "src.game.characters.ICharacter"

local update, draw

local image = love.graphics.newArrayImage({
    "res/piggo/piggo1.png",
    "res/piggo/piggo2.png",
    "res/piggo/piggo3.png",
})
image:setFilter("nearest", "nearest")

function Minion.new(world, x, y, hp, marker, team)
    assert(type(x) == "number")
    assert(type(y) == "number")
    assert(type(hp) == "number")
    assert(marker.x and marker.y)

    local minion = ICharacter.new(
        world,
        update, draw,
        x, y, hp, 300, 300, 15,
        {}
    )
    minion.frame = 1
    minion.frameLast = 0
    minion.framecd = 0.13
    minion.defaultMarker = marker
    minion.meta.marker = marker
    minion.color = {r = team == 2 and 1 or 0, g = team == 1 and 1 or 0, b = 0}
    minion.team = team
    minion.fixture:setFriction(1)

    return minion
end

function update(self, dt, state)
    assert(state)
    -- check surroundings for things to attack (minions, champions, structures)

    local target = nil
    for _, character in pairs(state.npcs) do
        if character.team ~= self.team then
            -- debug(string.format("me team %s checking team %s", self.team, character.team))
            if ShapeUtils.pointInCircle(character.body:getX(), character.body:getY(),
                self.body:getX(), self.body:getY(), 200) then
                    target = character
                    break
            end
        end
    end
    self.target = target

    -- if nothing nearby, move on toward defaultMarker
    if self.meta.marker == nil then
        -- self.meta.marker = self.defaultMarker
    end

    -- update animation frame
    if self.dt - self.frameLast > self.framecd then
        self.frameLast = self.dt
        self.frame = (self.frame + 1) % 3 + 1
    end
end

function draw(self)
    love.graphics.setColor(self.color.r, self.color.g, self.color.b)
    love.graphics.drawLayer(
        image, self.frame,
        self.body:getX(), self.body:getY(),
        0, 3 * self.facingRight, 3, 8, 7
    )
end

return Minion
