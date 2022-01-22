local IAbility = {}

local update, draw

-- function IAbility.new(abilityName) return IAbility.new(abilityName, cast, update, draw, 10) end

function IAbility.new(abilityName, abilityCast, abilityUpdate, abilityDraw, abilityCd)
    local iAbility = {
        cast = cast, update = update, draw = draw,

        name = abilityName, cd = abilityCd, dt = abilityCd,
        abilityCast = abilityCast, abilityUpdate = abilityUpdate, abilityDraw = abilityDraw, ability
    }

    assert(iAbility.name and iAbility.cast and iAbility.update and iAbility.draw and iAbility.cd and iAbility.dt)

    return iAbility
end

function cast(self, character)
    assert(character)

    -- cd check
    if self.dt >= self.cd then
        debug("CAST " .. self.name)
        self:abilityCast(character)

        -- reset time delta
        self.dt = 0
    else
        debug("CASTCD " .. self.name)
    end
end

function update(self, dt)
    self.dt = self.dt + dt
    self.abilityUpdate(self)

    -- handle abilities with charges
    if self.charges and self.maxCharges then

        -- recharge
        if self.chargeDt >= self.chargeCd then
            self.charges = self.charges + 1
            self.chargeDt = 0
        end

        -- increment chargeDt if not at max
        if self.charges < self.maxCharges then
            self.chargeDt = self.chargeDt + dt
        end
    end
end

function draw(self)
    self.abilityDraw(self)
end

return IAbility
