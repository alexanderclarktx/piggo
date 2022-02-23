local Blink = {}
local IAbility = require "src.piggo.core.IAbility"
local ShapeUtils = require "src.piggo.util.ShapeUtils"

local cast, update, draw

local rgb = {1, 0, 0, 0.6}

function Blink.new()
    local blink = IAbility.new("Blink", cast, update, draw, 300)

    return blink
end

function cast(self, character, mouseX, mouseY)
    character:setPosition(mouseX, mouseY, nil)
end

function update(self) end

function draw(self) end

return Blink
