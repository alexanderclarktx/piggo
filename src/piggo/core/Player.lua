local Player = {}

local update, draw

function Player.new(name, character)
    assert(name and character)
    return {
        name = name,
        character = character,
        update = update,
        draw = draw
    }
end

function update(self, dt, state)
    assert(state)
    self.character:update(dt, state)
end

function draw(self)
    self.character:draw()
end

return Player
