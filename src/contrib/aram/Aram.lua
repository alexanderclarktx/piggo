local Aram = {}
local IGame = require "src.piggo.core.IGame"
local Terrain = require "src.piggo.core.Terrain"
local Minion = require "src.contrib.aram.characters.Minion"
local load, update, draw, spawnMinions, spawnTerrain

local backgroundColor = {0, 0.1, 0.3}

-- rules:
--   * single lane
--   * no recalling
--   * outer tower, inhib tower, inhib, 2 nexus towers, nexus
function Aram.new()
    local aram = IGame.new(load, update, draw)
    aram.timers = {
        minionSpawn = {
            cd = 1000,
            lastRun = 0,
            run = spawnMinions
        }
    }
    aram.spawnMinions = spawnMinions
    aram.spawnTerrain = spawnTerrain

    return aram
end

function load(self)
    -- create the terrain
    self:spawnTerrain()

    -- spawn first minion waves
    self:spawnMinions()
end

function update(self)
    -- kill all npcs that are dead :)
    for i, npc in ipairs(self.state.npcs) do
        if npc.state.hp <= 0 then
            table.remove(self.state.npcs, i)
            npc.body:destroy()
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

function draw(self)
    love.graphics.setBackgroundColor(backgroundColor)
end

function spawnMinions(self)
    -- spawn team 1 minions
    for i = 1, 5, 1 do
        table.insert(self.state.npcs,
            Minion.new(self.state.world,
                2000 - 10 * i, 100, math.random(300), {x = 0, y = 100}, 1)
        )
    end

    -- spawn team 2 minions
    for i = 1, 5, 1 do
        table.insert(self.state.npcs,
            Minion.new(self.state.world,
                -400 - 10 * i, 100, math.random(300), {x = 1400, y = 100}, 2)
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
