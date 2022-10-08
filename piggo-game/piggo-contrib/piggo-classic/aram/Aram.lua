local Aram = {}
local Game = require "piggo-core.Game"
local Terrain = require "piggo-core.Terrain"
local Minion = require "piggo-contrib.characters.Minion"
local sti = require "lib.sti.init"

local load, update, draw, spawnMinions, spawnTerrain
local backgroundColor = {78/256.0, 144/256.0, 244/256.0}
local map = nil

-- rules:
--   * single lane
--   * no recalling
--   * outer tower, inhib tower, inhib, 2 nexus towers, nexus
function Aram.new()
    local aram = Game.new(load, update, draw)
    aram.timers = {
        minionSpawn = {
            cd = 1000,
            lastRun = -800,
            run = spawnMinions
        }
    }
    aram.spawnMinions = spawnMinions
    aram.spawnTerrain = spawnTerrain

    return aram
end

function load(self) end

function update(self)
    -- kill all npcs that are dead :)
    for name, npc in pairs(self.state.npcs) do
        if npc.state.hp <= 0 then
            self.state.npcs[name] = nil
            npc.state.body:destroy()
        end
    end

    -- run timer callbacks
    for _, timer in pairs(self.timers) do
        assert(
            timer.cd ~= nil and timer.cd > 0 and
            timer.lastRun ~= nil and type(timer.lastRun) == "number" and
            timer.run ~= nil and type(timer.run) == "function"
        )
        if self.state.frame - timer.lastRun >= timer.cd then
            timer.run(self)
            timer.lastRun = self.state.frame
        end
    end
end

function draw(self, x, y)
    love.graphics.setColor(1, 1, 1)
    if map == nil then map = sti("res/map/map.lua") end
    map:draw(-x, -y)
end

function spawnMinions(self)
    -- spawn team 1 minions
    for i = 1, 5, 1 do
        self:addNpc(
            Minion.new(self.state.world, 2000 - 10 * i, 100, math.random(300), {x = 0, y = 100}, 1)
        )
    end

    -- spawn team 2 minions
    for i = 1, 5, 1 do
        self:addNpc(
            Minion.new(self.state.world, -400 - 10 * i, 100, math.random(300), {x = 1400, y = 100}, 2)
        )
    end
end

function spawnTerrain(self)
    self.state.terrains = {
        -- top wall
        Terrain.new(self.state.world, -400, -600, {
            0, 0,
            0, 500,
            3400, 500,
            3400, 0,
        }),
        -- top alcove
        Terrain.new(self.state.world, 650, -100, {
            -50, 0,
            350, 0,
            300, 50,
            000, 50,
        }),
        -- bottom alcove
        Terrain.new(self.state.world, 650, 450, {
            0, 0,
            300, 0,
            300, 50,
            000, 50,
        }),
        -- bottom walls
        Terrain.new(self.state.world, -400, 500, { -- left
            0, 0,
            0, 500,
            700, 500,
            700, 0,
        }),
        Terrain.new(self.state.world, 300, 500, { -- left curve
            0, 0,
            0, 500,
            400, 500,
            400, 200,
        }),
        Terrain.new(self.state.world, 700, 700, { -- bottom bottom
            0, 0,
            0, 300,
            200, 300,
            200, 0,
        }),
        Terrain.new(self.state.world, 900, 500, { -- right curve
            0, 200,
            0, 500,
            400, 500,
            400, 0,
        }),
        Terrain.new(self.state.world, 1300, 500, { -- right
            0, 0,
            0, 500,
            700, 500,
            700, 0,
        })
    }
end

return Aram
