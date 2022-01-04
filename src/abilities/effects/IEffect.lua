
-- class for stateful effects on a character
local IEffect = {}

local update

function IEffect.new(effectUpdate, effectDraw)
    local effect = {
        update = update, draw = effectDraw,
        effectUpdate = effectUpdate
    }

    assert(effect.update)
    assert(effect.draw)

    return effect
end

function update(self, dt)
    debug("IEffect update")
    self.effectUpdate(self, dt)
end
