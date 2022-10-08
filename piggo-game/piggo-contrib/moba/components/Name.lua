local Name = {}

function Name.new(name)
    local name = {
        type = "name",
        name = name or "anon"
    }

    return name
end

return Name
