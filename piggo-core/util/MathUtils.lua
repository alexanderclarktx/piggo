local MathUtils = {}

function MathUtils.round(number, decimals)
    local power = 10^decimals
    return math.floor(number * power) / power
end

return MathUtils
