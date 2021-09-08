local Ability = require 'src.ability'
local Cmeta = require 'src.cmeta'

local Sion = {}

local sionQ, sionW, sionE, sionR

function Sion.new(pos, hp)
    local sion = {
        cmeta = Cmeta.new(pos, hp, 1000, 340, 10),
        effects = {},
        abilities = {
            q = {cd = 2, dt = 2}, w = {cd = 4, dt = 4}, e = { cd = 3, dt = 3}, r = {cd = 5, dt = 5}
        },
        q = function(self, mousePos)
            if self.abilities.q.dt > self.abilities.q.cd then sionQ(self, mousePos) end
        end,
        w = function(self)
            if self.abilities.w.dt > self.abilities.w.cd then sionW(self) end
        end,
        e = function(self)
            if self.abilities.e.dt > self.abilities.e.cd then sionE(self) end
        end,
        r = function(self)
            if self.abilities.r.dt > self.abilities.r.cd then sionR(self) end
        end,
        update = function(self, dt)
            -- update position
            if self.cmeta.marker and self.cmeta.canMove then
                local xdiff = self.cmeta.marker.x - self.cmeta.pos.x
                local ydiff = self.cmeta.marker.y - self.cmeta.pos.y

                if math.abs(xdiff) <= 1 and math.abs(ydiff) <= 1 then
                    self.cmeta.marker = nil
                end

                local xRatio = .0 + xdiff / (math.abs(xdiff) + math.abs(ydiff))
                local yRatio = .0 + ydiff / (math.abs(xdiff) + math.abs(ydiff))

                local xComponent = dt * self.cmeta.speed * xRatio
                local yComponent = dt * self.cmeta.speed * yRatio

                self.cmeta.pos.x = self.cmeta.pos.x + xComponent
                self.cmeta.pos.y = self.cmeta.pos.y + yComponent
            end

            -- increment ability dt
            for i, ability in pairs(self.abilities) do
                ability.dt = ability.dt + dt
            end

            -- update each effect
            for i, effect in pairs(self.effects) do
                effect.dt = effect.dt + dt
                
                for _, segment in pairs(effect.segments) do
                    if not segment.done and segment.time <= effect.dt then
                        segment:run(self, effect)
                        segment.done = true
                    end
                end

                if effect.dt > effect.duration then
                    table.remove(self.effects, i)
                end
            end
        end,
        draw = function(self)
            -- draw my character
            love.graphics.setColor(0, 1, 0.4)
            love.graphics.circle("fill", self.cmeta.pos.x, self.cmeta.pos.y, self.cmeta.size)

            -- draw line from me to marker
            love.graphics.setColor(0.6, 0.6, 0.6)
            if self.cmeta.marker then
                love.graphics.line(
                    self.cmeta.pos.x, self.cmeta.pos.y,
                    self.cmeta.marker.x, self.cmeta.marker.y
                )
            end

            -- draw each effect
            for _, effect in pairs(self.effects) do
                if effect.drawable then
                    effect:draw(self)
                end
            end
        end
    }
    return sion
end

function sionQ(me, mousePos)
    me.abilities.q.dt = 0
    table.insert(me.effects, {
        name = "Axe",
        drawable = true,
        duration = 0.5,
        dt = 0,
        hitboxDistance = 200,
        hitboxAngle = math.pi/8,
        hitboxStyle = "line",
        segments = {
            {
                time = 0,
                done = false,
                run = function(self, me)
                    me.cmeta.canMove = false
                    me.cmeta.marker = nil
                end
            },
            {
                time = 0.47,
                done = false,
                run = function(self, me, effect)
                    -- TODO contention here (CC from other effects)
                    me.cmeta.canMove = true
                    effect.hitboxStyle = "fill"

                    -- damage
                    Ability.hurtbox(self, "axe", 140, effect.hitboxPoints)
                end
            }
        },
        draw = function(self, me)
            local xdiff = mousePos.x - me.cmeta.pos.x
            local ydiff = mousePos.y - me.cmeta.pos.y
            local xRatio = .0 + xdiff / (math.abs(xdiff) + math.abs(ydiff))
            local yRatio = .0 + ydiff / (math.abs(xdiff) + math.abs(ydiff))

            -- first point is on edge of character
            local p1 = {me.cmeta.pos.x + me.cmeta.size * xRatio, me.cmeta.pos.y + me.cmeta.size * yRatio}

            -- outer points of triangle
            local p2 = rotate({xRatio, yRatio}, -self.hitboxAngle, p1[1], p1[2], self.hitboxDistance)
            local p3 = rotate({xRatio, yRatio}, self.hitboxAngle, p1[1], p1[2], self.hitboxDistance)

            love.graphics.setColor(1, 0, 1)
            love.graphics.polygon(self.hitboxStyle, {
                p1[1], p1[2],
                p2[1], p2[2],
                p3[1], p3[2]
            })

            self.hitboxPoints = {{x = p1[1], y = p1[2]}, {x = p2[1], y = p2[2]}, {x = p3[1], y = p3[2]}}
        end
    })
end

-- rotate({1, 1, 2, 2}, math.pi/2)
function rotate(vertices, angle, originx, originy, scale)
    assert(#vertices > 0 and #vertices % 2 == 0)
    local t = love.math.newTransform(originx or 0, originy or 0, angle, scale or 1, scale or 1)

    local result = {}
    for i=1, #vertices, 2 do
        local newx, newy = t:transformPoint(vertices[i], vertices[i+1])
        table.insert(result, newx)
        table.insert(result, newy)
    end
    return result
end

function sionW(me)
    me.abilities.w.dt = 0
    table.insert(me.effects, {
        name = "Shield",
        drawable = true,
        duration = 3,
        dt = 0,
        shield = {
            color = {r = 0.8, g = 0.8, b = 0.8, alpha = 1},
            radius = 2,
            width = 4
        },
        segments = {
            {
                time = 2.9,
                done = false,
                run = function(self, me, effect)
                    effect.shield = {
                        color = {r = 1, g = 0, b = 0, alpha = 0.2},
                        radius = 25,
                        width = 50
                    }
                end
            },
            {
                time = 2,
                done = false,
                run = function(self, me)
                    -- AoE damage
                end
            }
        },
        draw = function(self, me)
            love.graphics.setColor(self.shield.color.r, self.shield.color.g, self.shield.color.b)
            love.graphics.setLineWidth(self.shield.width)
            love.graphics.circle("line", me.cmeta.pos.x, me.cmeta.pos.y, me.cmeta.size + self.shield.radius)
            love.graphics.setLineWidth(1)
        end
    })
end

function sionE(me)

end

function sionR(me)

end

return Sion
