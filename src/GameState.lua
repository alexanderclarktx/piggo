local GameState = {}

function GameState.new()
    return {
        players = {},
        npcs = {},
        hurtboxes = {},
        objects = {}
    }
end

-- delete characters here?
-- function update(self)
-- end

return GameState
