local IAbility = require 'src.equip.IAbility'
local ShapeUtils = require 'src.util.ShapeUtils'

local SionShield = {}

local cast, update, draw

local rgb = {1, 0, 0, debug() and 0.3 or 0.6}

function SionShield.new()
    local sionShiled = IAbility.new("Piggo Spawner")

    sionShiled.charges = 4
    sionShiled.maxCharges = 4
    sionShiled.chargeCd = 1
    sionShiled.chargeDt = 0

    return sionShiled
end

function cast(self) 
end

function update(self, dt)

end

function draw()

end
