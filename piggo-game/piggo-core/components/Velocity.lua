local Velocity = {}

function Velocity.new(speed, direction)
    local velocity = {
        type = "velocity",
        speed = speed or 1,
        direction = direction or 0
    }

    return velocity
end

return Velocity
