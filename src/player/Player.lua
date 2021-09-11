local DrawUtils = require 'src.util.DrawUtils'

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
    DrawUtils.drawHealthbar(self.character.meta.pos, self.character.meta.size, self.character.meta.hp, self.character.meta.maxhp)

    -- draw character
    self.character:draw()
end

return Player
