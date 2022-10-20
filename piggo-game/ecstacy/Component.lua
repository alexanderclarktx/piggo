local Component = {}

function Component.new(ctype, value)
    assert(ctype)
    assert(value)
    local component = {
        ctype = ctype,
        value = value
    }
    return component
end

function Component.debug(component)
    keypairs = {}
    for k,v in pairs(component) do
        table.insert(keypairs, string.format("%s:%s", k, v))
    end
    keypairsString = table.concat(keypairs, ", ")

    return string.format("{%s}", keypairsString)
end

return Component
