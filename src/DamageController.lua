local ShapeUtils = require 'src.ShapeUtils'

local DamageController = {}

local update, draw, submitHurtbox

function DamageController.new(state)
    return {
        state = state,
        hurtboxes = {},
        submitHurtbox = submitHurtbox,
        update = update,
        draw = draw
    }
end

function submitHurtbox(self, name, damage, poly)
    table.insert(self.hurtboxes, {
        name = name,
        damage = damage,
        poly = poly
    })
end

function update(self, dt)
    -- apply all hurtboxes
    for i, hurtbox in ipairs(self.hurtboxes) do
        for _, npc in pairs(self.state.npcs) do
            if ShapeUtils.circleInPolygon(npc.pos.x, npc.pos.y, npc.size, hurtbox.poly) then
                npc.hp = npc.hp - hurtbox.damage

                -- TODO non-damage effects
                -- hurtbox:hit(npc)
            end
        end
    end
    self.hurtboxes = {}
end

function draw(self, dt)
    -- draw damage text
end

return DamageController
