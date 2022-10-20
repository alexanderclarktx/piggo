local Size = {}

function Size.new(width)
    local size = {
        type = "size",
        width = width or 5
    }

    return size
end

return Size
