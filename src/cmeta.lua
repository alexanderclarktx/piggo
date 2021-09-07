local Cmeta = {}
-- character metadata and validation

local posvalidate

function Cmeta.new(pos, hp, maxhp, speed)
    assert(pos.x ~= nil and pos.x > 0)
    assert(pos.y ~= nil and pos.y > 0)
    assert(hp ~= nil and hp > 0)
    assert(maxhp ~= nil and maxhp > 0)
    assert(speed ~= nil and speed > 0)

    local cmeta = {
        pos = pos,
        canMove = true,
        hp = hp,
        maxhp = maxhp,
        speed = speed
    }

    return cmeta
end

local function testCmetaNew()
    assert(Cmeta.new(
        {x = 15, y = 15},
        15,
        20,
        300
    ))
end
testCmetaNew()

return Cmeta
