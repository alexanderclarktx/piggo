local Character = {}
-- character metadata and validation

local posvalidate

function Character.new(pos, hp, maxhp, speed, size)
    assert(
        pos.x ~= nil and pos.x > 0,
        pos.y ~= nil and pos.y > 0,
        hp ~= nil and hp > 0,
        maxhp ~= nil and maxhp > 0,
        speed ~= nil and speed > 0,
        size ~= nil and size > 0
    )
    return {
        pos = pos, hp = hp, maxhp = maxhp, speed = speed, size = size,
        canMove = true,
    }
end

local function testCharacterNew()
    assert(Character.new(
        {x = 15, y = 15},
        15,
        20,
        300,
        20
    ))
end
testCharacterNew()

return Character
