local ShapeUtils = require 'src.util.ShapeUtils'

local DamageController = {}

local update, draw

function DamageController.new()
    return {
        hurtboxes = {},
        update = update, draw = draw
    }
end

function update(self, dt)
    -- add all submitted hurtboxes
    for _, player in pairs(state.players) do
        for i, hurtbox in ipairs(player.character.hurtboxes) do
            assert(hurtbox.name, hurtbox.damage, hurtbox.poly)
            table.insert(self.hurtboxes, hurtbox)
        end
        player.character.hurtboxes = {}
    end

    -- TODO non-damage effects (hurtbox:hit(npc))
    -- apply all damage from hurtboxes
    for i, hurtbox in ipairs(self.hurtboxes) do
        for _, npc in pairs(state.npcs) do
            if hurtbox.type == "poly" then
                if ShapeUtils.circleInPolygon(
                        npc.meta.pos.x, npc.meta.pos.y, npc.meta.size, hurtbox.poly) then
                    npc.meta.hp = npc.meta.hp - hurtbox.damage
                end
            elseif hurtbox.type == "circle" then
                if ShapeUtils.circleInCircle(
                        npc.meta.pos.x, npc.meta.pos.y, npc.meta.size, hurtbox.x, hurtbox.y, hurtbox.radius) then
                    npc.meta.hp = npc.meta.hp - hurtbox.damage
                end
            end
        end
    end
    self.hurtboxes = {}
end

function draw(self, dt)
    -- draw damage text
end

return DamageController
