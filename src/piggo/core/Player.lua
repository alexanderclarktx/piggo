local Player = {}

local update, draw

function Player.new(name, character)
    assert(name and character)
    return {
        state = {
            name = name
        },
        character = character,
        update = update,
        draw = draw,
        setPosition = setPosition
    }
end

function update(self, state)
    assert(state)
    self.character:update(state)
end

function draw(self)
    self.character:draw()
end

function setPosition(self, x, y, velocity)
    assert(x and y and velocity)

    self.character.body:setX(x)
    self.character.body:setY(y)
    self.character.body:setLinearVelocity(velocity.x, velocity.y)
end

return Player
