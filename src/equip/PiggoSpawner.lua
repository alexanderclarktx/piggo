local IAbility = require 'src.equip.IAbility'
local ShapeUtils = require 'src.util.ShapeUtils'

local PiggoSpawner = {}

local cast, update, draw

local rgb = {
    {1, 0, 0, debug() and 0.3 or 0.6},
    {1, 1, 0, debug() and 0.3 or 0.6},
    {0, 1, 0, debug() and 0.3 or 0.6},
    {0, 1, 1, debug() and 0.3 or 0.6},
}

function PiggoSpawner.new()
    local piggoSpawner = IAbility.new("Sion Axe", cast, update, draw, 2)

    piggoSpawner.charges = 4
    piggoSpawner.maxCharges = 4
    piggoSpawner.chargeCd = 1
    piggoSpawner.chargeDt = 0

    return piggoSpawner
end
