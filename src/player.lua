local drawutils = require 'src.drawutils'

local Player = {}

function Player.new(name, character)
    local player = {
        name = name,
        character = character,
        update = function(self, dt)
            -- update character
            self.character:update(dt)
        end,
        draw = function(self)
            drawutils.drawHealthbar(self.character.cmeta.pos, self.character.cmeta.size, self.character.cmeta.hp, self.character.cmeta.maxhp)

            -- draw character
            self.character:draw()
        end,
    }
    return player
end

return Player
