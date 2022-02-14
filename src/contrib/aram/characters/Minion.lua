local Minion = {}
local ShapeUtils = require "src.piggo.util.shapeutils"
local ICharacter = require "src.piggo.core.ICharacter"

local update, draw

function Minion.new(world, x, y, hp, marker, team)
    assert(type(x) == "number")
    assert(type(y) == "number")
    assert(type(hp) == "number")
    assert(marker.x and marker.y)

    local minion = ICharacter.new(
        world,
        update, draw,
        x, y, hp, 300, 200, 15,
        {}
    )

    minion.animationFrame = 1
    minion.frameLast = 0
    minion.framecd = 7
    minion.defaultMarker = marker
    minion.state.marker = marker
    minion.state.color = {team == 2 and 1 or 0, team == 1 and 1 or 0, 0}
    minion.state.team = team
    minion.fixture:setFriction(1)

    return minion
end

function update(self, state)
    assert(state)
    -- check surroundings for things to attack (minions, champions, structures)

    local target = nil
    for _, character in pairs(state.npcs) do
        if character.state.team ~= self.state.team then
            -- log.debug(string.format("me team %s checking team %s", self.state.team, character.state.team))
            if ShapeUtils.pointInCircle(character.body:getX(), character.body:getY(),
                self.body:getX(), self.body:getY(), 200) then
                    target = character
                    break
            end
        end
    end
    self.state.target = target

    -- if nothing nearby, move on toward defaultMarker
    if self.state.marker == nil then
        -- self.state.marker = self.defaultMarker
    end

    -- update animation frame
    if self.frame - self.frameLast > self.framecd then
        self.frameLast = self.frame
        self.animationFrame = (self.frame + 1) % 3 + 1
    end
end

function draw(self)
    if self.image == nil then
        self.image = love.graphics.newArrayImage({
            "res/piggo/piggo1.png",
            "res/piggo/piggo2.png",
            "res/piggo/piggo3.png",
        })
        self.image:setFilter("nearest", "nearest")
    end

    love.graphics.setColor(self.state.color)
    love.graphics.drawLayer(
        self.image, self.animationFrame,
        self.body:getX(), self.body:getY(),
        0, 3 * self.state.facingRight, 3, 8, 7
    )
end

return Minion
