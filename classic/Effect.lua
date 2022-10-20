local Effect = {}

local update

-- class for stateful effects on a character
function Effect.new(effectUpdate, effectDraw)
    local effect = {
        update = update, draw = effectDraw,
        effectUpdate = effectUpdate
    }

    assert(effect.update)
    assert(effect.draw)

    return effect
end

function update(self, dt)
    log:debug("Effect update")
    self.effectUpdate(self, dt)
end
