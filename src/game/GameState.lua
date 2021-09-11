local GameState = {}

function GameState.new()
    return {
        players = {},
        npcs = {},
        hurtboxes = {},
        objects = {}
    }
end

return GameState
