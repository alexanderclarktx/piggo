local DamageController = {}
local ShapeUtils = require "piggo-core.util.ShapeUtils"

local update, draw

function DamageController.new()
    return {
        hurtboxes = {},
        update = update, draw = draw
    }
end

function update(self, state)
    assert(state)
    -- add all submitted hurtboxes
    for _, player in pairs(state.players) do
        for i, hurtbox in ipairs(player.state.character.state.hurtboxes) do
            assert(hurtbox.name and hurtbox.damage and (hurtbox.type == "poly" or hurtbox.type == "circle"))
            table.insert(self.hurtboxes, hurtbox)
        end
        player.state.character.state.hurtboxes = {}
    end

    -- TODO non-damage effects (hurtbox:hit(npc))
    -- apply all damage from hurtboxes
    for i, hurtbox in ipairs(self.hurtboxes) do
        for _, npc in pairs(state.npcs) do
            if hurtbox.type == "poly" then
                if ShapeUtils.circleInPolygon(
                        npc.state.body:getX(), npc.state.body:getY(), npc.state.size, hurtbox.poly) then
                    npc.state.hp = npc.state.hp - hurtbox.damage
                end
            elseif hurtbox.type == "circle" then
                if ShapeUtils.circleInCircle(
                        npc.state.body:getX(), npc.state.body:getY(), npc.state.size, hurtbox.x, hurtbox.y, hurtbox.radius) then
                    npc.state.hp = npc.state.hp - hurtbox.damage
                end
            end
        end
    end
    self.hurtboxes = {}
end

function draw(self)
    -- draw damage text
end

return DamageController
