local Ability = {}

local update, draw

-- function Ability.new(abilityName) return Ability.new(abilityName, cast, update, draw, 10) end

function Ability.new(abilityName, abilityCast, abilityUpdate, abilityDraw, abilityCd)
    local iAbility = {
        cast = cast, update = update, draw = draw,
        name = abilityName, cd = abilityCd, frame = abilityCd,
        abilityCast = abilityCast, abilityUpdate = abilityUpdate, abilityDraw = abilityDraw,
    }

    assert(iAbility.name and iAbility.cast and iAbility.update and iAbility.draw and iAbility.cd and iAbility.frame)

    return iAbility
end

function cast(self, character, mouseX, mouseY)
    assert(character and mouseX and mouseY)

    -- cd check
    if self.frame >= self.cd then
        log:debug("CAST " .. self.name)
        self:abilityCast(character, mouseX, mouseY)

        -- reset time delta
        self.frame = 0
    else
        log:debug("CASTCD " .. self.name)
    end
end

function update(self)
    self.frame = self.frame + 1
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
            self.chargeDt = self.chargeDt + 1
        end
    end
end

function draw(self)
    self.abilityDraw(self)
end

return Ability
