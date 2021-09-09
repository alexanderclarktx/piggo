local drawutils = require 'src.drawutils'

local Player = {}

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
    drawutils.drawHealthbar(self.character.cmeta.pos, self.character.cmeta.size, self.character.cmeta.hp, self.character.cmeta.maxhp)

    -- draw character
    self.character:draw()
end

return Player
