local IAbility = {}

local update, draw

-- function IAbility.new(abilityName) return IAbility.new(abilityName, cast, update, draw, 10) end

function IAbility.new(abilityName, abilityCast, abilityUpdate, abilityDraw, abilityCd)
    assert(abilityDraw)
    assert(abilityCd)
    local iAbility = {
        cast = cast, update = update, draw = draw,

        name = abilityName, cd = abilityCd, dt = abilityCd,
        abilityCast = abilityCast, abilityUpdate = abilityUpdate, abilityDraw = abilityDraw, ability
    }

    assert(iAbility.name)
    assert(iAbility.cast)
    assert(iAbility.update)
    assert(iAbility.draw)
    assert(iAbility.cd)
    assert(iAbility.dt)

    return iAbility
end

function cast(self, character)
    assert(character)

    -- cd check
    if self.dt >= self.cd then
        debug("CAST " .. self.name)
        self:abilityCast(character)
    else
        debug("CASTCD " .. self.name)
    end

    -- reset time delta
    self.dt = 0
end

function update(self, dt)
    self.dt = self.dt + dt / 1000.0
    -- self.abilityUpdate(self)
end

function draw(self)
    -- self.abilityDraw(self)
end

return IAbility
