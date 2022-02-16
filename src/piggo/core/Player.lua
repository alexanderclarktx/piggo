local Player = {}

local update, draw, serialize, setPosition

function Player.new(name, character)
    assert(name and character)
    return {
        state = {
            name = name,
            character = character,
        },
        update = update,
        draw = draw,
        serialize = serialize,
        setPosition = setPosition
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
        name = self.state.name,
        character = self.state.character:serialize()
    }
end

function setPosition(self, x, y, velocity)
    assert(x and y and velocity)

    self.state.character.state.body:setX(x)
    self.state.character.state.body:setY(y)
    self.state.character.state.body:setLinearVelocity(velocity.x, velocity.y)
end

return Player
