local Camera = require 'lib.Camera'

local GameState = {}

function GameState.new()
    return {
        players = {}, npcs = {}, hurtboxes = {}, objects = {}, terrains = {},
        camera = Camera()
    }
end

return GameState
