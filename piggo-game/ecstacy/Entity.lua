local Entity = {}

local Component = require "ecstacy.Component"

function Entity.new(type, components)
    local entity = {
        type = type or "",
        components = components or {},
        ctypes = {},
    }
    for _, component in ipairs(components) do
        if entity.ctypes[component.type] then
            log:warn("invalid entity. duplicate component type")
            love.event.quit()
        end
        table.insert(entity.ctypes, component.type)
    end
    return entity
end

function Entity.debug(entity)
    components = {}
    for _, component in ipairs(entity.components) do
        table.insert(components, Component.debug(component))
    end
    componentsString = table.concat(components, ", ")

    return string.format("{type:%s, components:[%s]}", entity.type, componentsString)
end

-- function Entity.contains(entity, types)
--     for type in types do
--         for 
--     end

return Entity
