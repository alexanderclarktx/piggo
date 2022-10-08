local Component = {}

function Component.new(ctype, component)
    assert(ctype)
    assert(component)

    component.ctype = ctype
    return component
end

function Component.debug(component)
    for k,v in pairs(component) do
        print(k, v)
    end
end

return Component
