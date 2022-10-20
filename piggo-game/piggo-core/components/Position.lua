local Position = {}

function Position.new(x, y)
    local position = {
        type = "position",
        x = x or 0,
        y = y or 0
    }

    return position
end

return Position
