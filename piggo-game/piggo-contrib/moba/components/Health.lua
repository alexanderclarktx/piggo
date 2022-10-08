local Health = {}

function Health.new(current, max)
    local health = {
        type = "health",
        current = current or 100,
        max = max or 100
    }

    return health
end

return Health
