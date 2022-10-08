local Card = {}

local Entity = require "piggo-core.ecs.Entity"
local SuperTypes = require "piggo-contrib.ecs.batto.components.SuperTypes"
local SubTypes = require "piggo-contrib.ecs.batto.components.SubTypes"
local Attack = require "piggo-contrib.ecs.batto.components.Attack"
local Defense = require "piggo-contrib.ecs.batto.components.Defense"
local Abilities = require "piggo-contrib.ecs.batto.components.Abilities"

function Card.new(superTypes, subTypes, attack, defense, abilities)
    local card = {
        superTypes = SuperTypes.new(superTypes),
        subTypes = SubTypes.new(subTypes),
        attack = Attack.new(attack),
        defense = Defense.new(defense),
        abilities = Abilities.new(abilities)
    }
    return Entity.new("card", card)
end

return Card
