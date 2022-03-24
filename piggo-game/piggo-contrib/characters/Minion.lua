local Minion = {}
local ShapeUtils = require "piggo-core.util.ShapeUtils"
local ICharacter = require "piggo-core.ICharacter"

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
    minion.state.fixture:setFriction(0)

    minion.image = {
        love.graphics.newImage("res/piggo/piggo1.png"),
        love.graphics.newImage("res/piggo/piggo2.png"),
        love.graphics.newImage("res/piggo/piggo3.png")
    }

    return minion
end

function update(self, state)
    assert(state)
    -- check surroundings for things to attack (minions, champions, structures)

    -- local target = nil
    -- for _, character in pairs(state.npcs) do
    --     if character.state.team ~= self.state.team then
    --         -- log:debug(string.format("me team %s checking team %s", self.state.team, character.state.team))
    --         if ShapeUtils.pointInCircle(character.state.body:getX(), character.state.body:getY(),
    --             self.state.body:getX(), self.state.body:getY(), 200) then
    --                 target = character
    --                 break
    --         end
    --     end
    -- end
    -- self.state.target = target

    -- if nothing nearby, move on toward defaultMarker
    if self.state.marker == nil then
        -- self.state.marker = self.defaultMarker
    end

    -- update animation frame
    if self.state.frame - self.frameLast > self.framecd then
        self.frameLast = self.state.frame
        self.animationFrame = (self.state.frame + 1) % 3 + 1
    end
end

function draw(self)
    -- pick animation frame
    local frameToDraw = self.animationFrame
    local velocity = {self.state.body:getLinearVelocity()}
    if 0 == velocity[1] and 0 == velocity[2] then
        frameToDraw = 1
    end

    love.graphics.setColor(self.state.color)
    love.graphics.draw(
        self.image[frameToDraw],
        self.state.body:getX(), self.state.body:getY(),
        0, 3 * self.state.facingRight, 3, 8, 7
    )
end

return Minion
