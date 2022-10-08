local Entity = {}

local Component = "piggo-game.piggo-core.ecs.Component"

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
        entity.ctypes.add(component.type)
    end
    return entity
end

function Entity.debug(entity)
    return string.format("{type: %s, components: [%s]}", entity.type, "nothing")
    -- print("type", entity.type)
    -- for _, component in ipairs(entity.components) do
    --     Component.debug(component)
    -- end
end

-- function Entity.contains(entity, types)
--     for type in types do
--         for 
--     end

return Entity
