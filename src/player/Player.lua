local Player = {}
local DrawUtils = require 'src.util.DrawUtils'

local update, draw

function Player.new(name, character)
    return {
        name = name,
        character = character,
        update = update,
        draw = draw
    }
end

function update(self, dt)
    -- update character
    self.character:update(dt)
end

function draw(self)
    -- draw character
    self.character:draw()
end

return Player
