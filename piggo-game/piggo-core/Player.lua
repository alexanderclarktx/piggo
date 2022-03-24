local Player = {}

local update, draw, serialize

function Player.new(name, character)
    assert(name and character)
    return {
        state = {
            name = name,
            character = character,
        },
        update = update,
        draw = draw,
        serialize = serialize
    }
end

function update(self, state)
    assert(state)
    self.state.character:update(state)
end

function draw(self)
    self.state.character:draw()
end

function serialize(self)
    return {
        character = self.state.character:serialize()
    }
end

return Player
