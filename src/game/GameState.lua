local Camera = require 'lib.Camera'

local GameState = {}

state = nil

-- places instance of GameState into global scope
function GameState.load()
    state = {
        players = {}, npcs = {}, hurtboxes = {}, objects = {}, terrains = {},
        camera = Camera(), world = love.physics.newWorld()
    }
end

return GameState
