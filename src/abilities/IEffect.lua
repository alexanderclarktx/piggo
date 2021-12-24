local IEffect = {}

local update, draw

-- function IEffect.new(effectName) return IEffect.new(effectName, cast, update, draw, 10) end

-- IEffect is a state effect attached to a character
function IEffect.new(effectName, effectCast, effectUpdate, effectDraw, effectCd)
    local iEffect = {
        cast = cast, update = update, draw = draw,

        name = effectName, cd = effectCd, dt = effectCd,
        effectCast = effectCast, effectUpdate = effectUpdate, effectDraw = effectDraw,
        -- effect
    }

    assert(iEffect.name)
    assert(iEffect.cast)
    assert(iEffect.update)
    assert(iEffect.draw)
    assert(iEffect.cd)
    assert(iEffect.dt)

    return iEffect
end

function cast(self, character)
    assert(character)

    -- cd check
    if self.dt >= self.cd then
        debug("CAST " .. self.name)
        self:effectCast(character)
    else
        debug("CASTCD " .. self.name)
    end

    -- reset time delta
    self.dt = 0
end

function update(self, dt)
    self.dt = self.dt + dt / 1000.0
    -- self.effectUpdate(self)
end

function draw(self)
    -- self.effectDraw(self)
end

return IEffect
