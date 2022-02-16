local ICharacter = {}
local ShapeUtils = require "src.piggo.util.ShapeUtils"
local DrawUtils = require "src.piggo.util.DrawUtils"

local update, draw, submitHurtboxPoly, submitHurtboxCircle

function ICharacter.new(world, charUpdate, charDraw, x, y, hp, maxhp, speed, size, abilities)
    assert(world)
    assert(type(x) == "number")
    assert(type(y) == "number")
    assert(type(hp) == "number")
    assert(maxhp ~= nil and maxhp > 0)
    assert(speed ~= nil and speed > 0)
    assert(size ~= nil and size > 0)
    assert(abilities ~= nil)
    -- TODO if #abilities then assert(abilities.q)

    local body = love.physics.newBody(world, x, y, "dynamic")
    local fixture = love.physics.newFixture(body, love.physics.newCircleShape(size))

    local character = {
        state = {
            hp = hp, maxhp = maxhp,
            speed = speed, canMove = true, speedfactor = 1,
            marker = nil, target = nil,
            defaultColor = {0.7, 0.5, 0}, color = {0.7, 0.5, 0},
            ranged = false, range = 50,
            team = 2,
            size = size,
            facingRight = 1,
        },
        frame = 0,
        charUpdate = charUpdate, charDraw = charDraw,
        update = update, draw = draw,
        submitHurtboxPoly = submitHurtboxPoly,
        submitHurtboxCircle = submitHurtboxCircle,
        abilities = abilities,
        body = body, fixture = fixture,
        effects = {},
        hurtboxes = {},
    }

    return character
end

function update(self, state)
    self.frame = self.frame + 1

    if self.body:isDestroyed() then return end
    assert(state)
    self.charUpdate(self, state)

    if self.target ~= nil and self.target.body == nil then
        self.state.target = nil
    end

    -- velocity to 0
    self.body:setLinearVelocity(0, 0)

    -- if i'm targeting, check if i can auto attack them
    if self.target ~= nil then
        -- remove marker since we are in range
        self.state.marker = nil

        if ShapeUtils.circleInCircle(
            self.target.body:getX(), self.target.body:getY(), self.target.state.size,
            self.body:getX(), self.body:getY(), self.state.range
        ) then
            self.body:setLinearVelocity(0, 0)

            if self.state.ranged then
                log:debug("create ranged auto attack")
                -- table.insert(state.objects, AutoAttack.new(self.state.range, 70))
            else
                log:debug("create melee auto attack")
                self.target.state.hp = self.target.state.hp - 1
            end
        else -- walk toward the target
            self.state.marker = {x = self.target.body:getX(), y = self.target.body:getY()}
        end
    end

    -- move toward marker
    if self.state.marker and self.state.canMove then
        -- x and y distances to the marker
        local xDiff = self.state.marker.x - self.body:getX()
        local yDiff = self.state.marker.y - self.body:getY()

        -- if we're close enough, snap to the marker
        if math.abs(xDiff) <= 4 then
            self.body:setX(self.state.marker.x)
            xDiff = 0
        end
        if math.abs(yDiff) <= 4 then
            self.body:setY(self.state.marker.y)
            yDiff = 0
        end

        -- move toward marker or reset it
        if math.abs(xDiff) <= 1 and math.abs(yDiff) <= 1 then
            self.state.marker = nil
        else
            local xRatio = .0 + xDiff / (math.abs(xDiff) + math.abs(yDiff))
            local yRatio = .0 + yDiff / (math.abs(xDiff) + math.abs(yDiff))

            local xComponent = self.state.speed * self.state.speedfactor * xRatio
            local yComponent = self.state.speed * self.state.speedfactor * yRatio

            self.body:setLinearVelocity(xComponent, yComponent)
        end
    end

    -- update where character is facing
    if self.state.marker and self.state.marker.x < self.body:getX() then
        self.state.facingRight = -1
    elseif self.state.marker and self.state.marker.x > self.body:getX() then
        self.state.facingRight = 1
    end

    -- update each ability
    for i, ability in pairs(self.abilities) do
        ability:update()
    end

    -- update each effect
    for i, effect in pairs(self.effects) do
        effect.frame = effect.frame + 1

        for _, segment in pairs(effect.segments) do
            if not segment.done and segment.time <= effect.frame then
                segment:cast(self, effect)
                segment.done = true
            end
        end

        if effect.frame > effect.duration then
            table.remove(self.effects, i)
        end
    end
end

function draw(self)
    -- draw line to marker
    if debug then
        love.graphics.setColor(0.6, 0.6, 0.6)
        if self.state.marker then
            love.graphics.line(
                self.body:getX(), self.body:getY(),
                self.state.marker.x, self.state.marker.y
            )
        end
    end

    -- draw line to targeted enemy
    -- if debug then
    --     love.graphics.setColor(self.state.team == 1 and 1 or 0, self.state.team == 2 and 1 or 0, 0)
    --     if self.target ~= nil and self.target.body ~= nil then
    --         love.graphics.line(
    --             self.body:getX(), self.body:getY(),
    --             self.target.body:getX(), self.target.body:getY()
    --         )
    --     end
    -- end

    -- draw each effect
    for _, effect in pairs(self.effects) do
        if effect.drawable then
            effect:draw(self)
        end
    end

    -- draw healthbar
    DrawUtils.drawHealthbar(
        self.body:getX(), self.body:getY(),
        self.state.size, self.state.hp, self.state.maxhp
    )

    self.charDraw(self)

    if debug then
        love.graphics.setColor(0, 0, 1, 0.6)
        love.graphics.circle("line", self.body:getX(), self.body:getY(), self.state.size)
    end
end

function submitHurtboxPoly(self, name, damage, poly)
    table.insert(self.hurtboxes,
        {type = "poly", name = name, damage = damage, poly = poly}
    )
end

function submitHurtboxCircle(self, name, damage, x, y, radius)
    table.insert(self.hurtboxes,
        {type = "circle", name = name, damage = damage, x = x, y = y, radius = radius}
    )
end

return ICharacter
