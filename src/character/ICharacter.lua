local ICharacter = {}

local update, draw, submitHurtbox

function ICharacter.new(charUpdate, charDraw, pos, hp, maxhp, speed, size, abilities)
    assert(
        pos.x ~= nil and pos.x > 0,
        pos.y ~= nil and pos.y > 0,
        hp ~= nil and hp > 0,
        maxhp ~= nil and maxhp > 0,
        speed ~= nil and speed > 0,
        size ~= nil and size > 0
    )

    return {
        meta = {
            pos = pos, hp = hp, maxhp = maxhp, speed = speed, size = size,
            canMove = true, marker = nil
        },
        charUpdate = charUpdate, charDraw = charDraw,
        update = update, draw = draw,
        submitHurtbox = submitHurtbox,
        abilities = abilities, effects = {}, hurtboxes = {}, facingRight = 1
    }
end

function update(self, dt)
    -- move toward marker
    if self.meta.marker and self.meta.canMove then
        local xdiff = self.meta.marker.x - self.meta.pos.x
        local ydiff = self.meta.marker.y - self.meta.pos.y

        if math.abs(xdiff) <= 1 and math.abs(ydiff) <= 1 then
            self.meta.marker = nil
        end

        local xRatio = .0 + xdiff / (math.abs(xdiff) + math.abs(ydiff))
        local yRatio = .0 + ydiff / (math.abs(xdiff) + math.abs(ydiff))

        local xComponent = dt * self.meta.speed * xRatio
        local yComponent = dt * self.meta.speed * yRatio

        self.meta.pos.x = self.meta.pos.x + xComponent
        self.meta.pos.y = self.meta.pos.y + yComponent
    end

    -- update where character is facing
    if self.meta.marker and self.meta.marker.x < self.meta.pos.x then
        self.facingRight = -1
    elseif self.meta.marker and self.meta.marker.x > self.meta.pos.x then
        self.facingRight = 1
    end

    -- increment ability dt
    for i, ability in pairs(self.abilities) do
        ability.dt = ability.dt + dt

        -- handle abilities with charges
        if ability.charges and ability.maxCharges then

            -- recharge
            if ability.chargeDt >= ability.chargeCd then
                ability.charges = ability.charges + 1
                ability.chargeDt = 0
            end

            -- increment chargeDt if not at max
            if ability.charges < ability.maxCharges then
                ability.chargeDt = ability.chargeDt + dt
            end
        end
    end

    -- update each effect
    for i, effect in pairs(self.effects) do
        effect.dt = effect.dt + dt

        for _, segment in pairs(effect.segments) do
            if not segment.done and segment.time <= effect.dt then
                segment:run(self, effect)
                segment.done = true
            end
        end

        if effect.dt > effect.duration then
            table.remove(self.effects, i)
        end
    end

    self.charUpdate(self)
end

function draw(self)
    -- draw line from me to marker
    if debug() then
        love.graphics.setColor(0.6, 0.6, 0.6)
        if self.meta.marker then
            love.graphics.line(
                self.meta.pos.x, self.meta.pos.y,
                self.meta.marker.x, self.meta.marker.y
            )
        end
    end

    -- draw each effect
    for _, effect in pairs(self.effects) do
        if effect.drawable then
            effect:draw(self)
        end
    end

    self.charDraw(self)
end

function submitHurtbox(self, name, damage, poly)
    table.insert(self.hurtboxes,
        {name = name, damage = damage, poly = poly}
    )
end

return ICharacter
