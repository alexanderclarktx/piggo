local Ability = require 'src.ability'
local Cmeta = require 'src.cmeta'

local Sion = {}

function Sion.new(pos, hp)
    local sion = {
        cmeta = Cmeta.new(pos, hp, 1000, 300),
        effects = {},
        abilities = {
            q = {
                cd = 2,
                dt = 2,
            },
            w = {
                cd = 3,
                dt = 3,
            },
            e = {
                cd = 3,
                dt = 3,
            },
            r = {
                cd = 5,
                dt = 5,
            }
        },
        q = function(self)
            if self.abilities.q.dt > self.abilities.q.cd then
                print("sion axe")
                self.abilities.q.dt = 0
                table.insert(self.effects, {
                    name = "Axe",
                    drawable = true,
                    duration = 0.5,
                    dt = 0,
                    segments = {
                        {
                            time = 0,
                            done = false,
                            run = function(self, me)
                                me.cmeta.canMove = false
                            end
                        },
                        {
                            time = 0.5,
                            done = false,
                            run = function(self, me)
                                Ability.heal(me, 100)
                            end
                        }
                    },
                    -- update = function(self, me)
                    --     me.hp = me.hp + 100
                    -- end,
                    draw = function(self, me)
                        love.graphics.setColor(1, 0.5, 0)
                        love.graphics.polygon("fill",
                            {
                                pos.x, pos.y + 10, pos.x - 50, pos.y + 75, pos.x + 50, pos.y + 75
                            }
                        )
                    end
                })
            else
                print("sion axe on cooldown")
            end
        end,
        w = function(self)
        end,
        e = function(self)
        end,
        r = function(self)
        end,
        update = function(self, dt)
            for i, ability in pairs(self.abilities) do
                ability.dt = ability.dt + dt
            end

            for i, effect in pairs(self.effects) do
                effect.dt = effect.dt + dt
                
                for _, segment in pairs(effect.segments) do
                    if not segment.done and segment.time <= effect.dt then
                        segment:run(self)
                    end
                end

                if effect.dt > effect.duration then
                    table.remove(self.effects, i)
                end
            end
        end,
        draw = function(self)
            love.graphics.setColor(0, 1, 0.4)
            love.graphics.circle("fill", self.cmeta.pos.x, self.cmeta.pos.y, 10)

            for _, effect in pairs(self.effects) do
                if effect.drawable then
                    -- print("draw effect:", effect.name)
                    effect:draw(self)
                end
            end
        end
    }
    return sion
end

return Sion
