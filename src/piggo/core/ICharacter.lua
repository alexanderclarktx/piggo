local ICharacter = {}
local DrawUtils = require "src.piggo.util.DrawUtils"
local MathUtils = require 'src.piggo.util.MathUtils'
local ShapeUtils = require "src.piggo.util.ShapeUtils"

local update, draw, serialize, setPosition, submitHurtboxPoly, submitHurtboxCircle

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
            frame = 0,
            hp = hp, maxhp = maxhp,
            speed = speed, canMove = true, speedfactor = 1,
            marker = nil, target = nil,
            defaultColor = {0.7, 0.5, 0}, color = {1, 1, 1},
            ranged = false, range = 50,
            team = 2,
            size = size,
            facingRight = 1,
            abilities = abilities, effects = {},
            body = body, fixture = fixture,
            hurtboxes = {},
        },
        charUpdate = charUpdate, charDraw = charDraw,
        update = update, draw = draw,
        serialize = serialize,
        setPosition = setPosition,
        submitHurtboxPoly = submitHurtboxPoly,
        submitHurtboxCircle = submitHurtboxCircle,
    }

    return character
end

function update(self, state)
    self.state.frame = self.state.frame + 1

    if self.state.body:isDestroyed() then return end
    assert(state)
    self.charUpdate(self, state)

    if self.target ~= nil and self.target.body == nil then
        self.state.target = nil
    end

    -- velocity to 0
    self.state.body:setLinearVelocity(0, 0)
    self.state.body:setAngularVelocity(0)
    self.state.body:setInertia(0)
    self.state.body:setMass(0)
    self.state.body:setBullet(true)
    self.state.body:setFixedRotation(true)

    -- if i'm targeting, check if i can auto attack them
    if self.target ~= nil then
        -- remove marker since we are in range
        self.state.marker = nil

        if ShapeUtils.circleInCircle(
            self.target.body:getX(), self.target.body:getY(), self.target.state.size,
            self.state.body:getX(), self.state.body:getY(), self.state.range
        ) then
            self.state.body:setLinearVelocity(0, 0)

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
        local xDiff = self.state.marker.x - self.state.body:getX()
        local yDiff = self.state.marker.y - self.state.body:getY()

        -- if we're close enough, snap to the marker
        -- if math.abs(xDiff) <= 4 then
        --     self.state.body:setX(self.state.marker.x)
        --     xDiff = 0
        -- end
        -- if math.abs(yDiff) <= 4 then
        --     self.state.body:setY(self.state.marker.y)
        --     yDiff = 0
        -- end

        -- move toward marker or reset it
        if math.abs(xDiff) <= 1 and math.abs(yDiff) <= 1 then
            self.state.marker = nil
        else
            local xRatio = .0 + xDiff / (math.abs(xDiff) + math.abs(yDiff))
            local yRatio = .0 + yDiff / (math.abs(xDiff) + math.abs(yDiff))

            local xComponent = self.state.speed * self.state.speedfactor * xRatio
            local yComponent = self.state.speed * self.state.speedfactor * yRatio

            self.state.body:setLinearVelocity(xComponent, yComponent)
        end
    end

    -- update where character is facing
    if self.state.marker and self.state.marker.x < self.state.body:getX() then
        self.state.facingRight = -1
    elseif self.state.marker and self.state.marker.x > self.state.body:getX() then
        self.state.facingRight = 1
    end

    -- update each ability
    for i, ability in pairs(self.state.abilities) do
        ability:update()
    end

    -- update each effect
    for i, effect in pairs(self.state.effects) do
        effect:update(self)

        if effect.frame > effect.duration then
            table.remove(self.state.effects, i)
        end
    end
end

function draw(self)
    -- draw line to marker
    if debug then
        love.graphics.setColor(0.8, 0.8, 0.9)
        if self.state.marker then
            love.graphics.line(
                self.state.body:getX(), self.state.body:getY(),
                self.state.marker.x, self.state.marker.y
            )
        end
    end

    -- draw line to targeted enemy
    -- if debug then
    --     love.graphics.setColor(self.state.team == 1 and 1 or 0, self.state.team == 2 and 1 or 0, 0)
    --     if self.target ~= nil and self.target.body ~= nil then
    --         love.graphics.line(
    --             self.state.body:getX(), self.state.body:getY(),
    --             self.target.body:getX(), self.target.body:getY()
    --         )
    --     end
    -- end

    -- draw each effect
    for _, effect in pairs(self.state.effects) do
        if effect.drawable then
            effect:draw()
        end
    end

    -- draw healthbar
    DrawUtils.drawHealthbar(
        self.state.body:getX(), self.state.body:getY(),
        self.state.size, self.state.hp, self.state.maxhp
    )

    self.charDraw(self)

    if debug then
        love.graphics.setColor(0, 0, 1, 0.6)
        love.graphics.circle("line", self.state.body:getX(), self.state.body:getY(), self.state.size)
    end
end

function serialize(self)
    return {
        x = self.state.body:getX(),
        y = self.state.body:getY(),
        -- x = MathUtils.round(self.state.body:getX(), 2),
        -- y = MathUtils.round(self.state.body:getY(), 2),
        marker = self.state.marker
    }
end

function setPosition(self, x, y, marker)
    assert(x and y)

    self.state.body:setX(x)
    self.state.body:setY(y)
    if marker then self.state.marker = marker else self.state.marker = nil end
end

function submitHurtboxPoly(self, name, damage, poly)
    table.insert(self.state.hurtboxes,
        {type = "poly", name = name, damage = damage, poly = poly}
    )
end

function submitHurtboxCircle(self, name, damage, x, y, radius)
    table.insert(self.state.hurtboxes,
        {type = "circle", name = name, damage = damage, x = x, y = y, radius = radius}
    )
end

return ICharacter
