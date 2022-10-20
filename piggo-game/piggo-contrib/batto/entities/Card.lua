local Card = {}

local Entity = require "ecstacy.Entity"
local SuperTypes = require "piggo-contrib.batto.components.SuperTypes"
local SubTypes = require "piggo-contrib.batto.components.SubTypes"
local Attack = require "piggo-contrib.batto.components.Attack"
local Defense = require "piggo-contrib.batto.components.Defense"
local Abilities = require "piggo-contrib.batto.components.Abilities"

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
