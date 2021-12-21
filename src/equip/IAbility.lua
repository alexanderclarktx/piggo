local IAbility = {}

local update, draw

function IAbility.new(abilityName) return IAbility.new(abilityName, cast, update, draw, 100) end

function IAbility.new(abilityName, abilityCast, abilityUpdate, abilityDraw, abilityCd)
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

    return iAbility
end

function cast(self, character)
    assert(character)

    -- cd check
    if self.dt >= self.cd then
        debug("casting " .. self.name)
        self:abilityCast(character)
    end
end

function update(self, dt)
    -- self.abilityUpdate(self)
end

function draw(self)
    -- self.abilityDraw(self)
end

return IAbility
