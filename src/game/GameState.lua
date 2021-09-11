local GameState = {}

function GameState.new()
    return {
        players = {}, npcs = {}, hurtboxes = {}, objects = {}, terrains = {}
    }
end

return GameState
