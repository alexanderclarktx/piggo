local Aram = {}
local Minion = require "src.game.characters.Minion"
local IGame = require "src.game.IGame"
local Terrain = require "src.game.Terrain"

local load, update, draw, spawnMinions, spawnTerrain

local backgroundColor = {0.05, 0.05, 0.15}

-- rules:
--   * single lane
--   * no recalling
--   * outer tower, inhib tower, inhib, 2 nexus towers, nexus
function Aram.new()
    local aram = IGame.new(load, update, draw)

    aram.timers = {
        minionSpawn = {
            cd = 10,
            lastRun = 0,
            run = spawnMinions
        }
    }
    aram.spawnMinions = spawnMinions
    aram.spawnTerrain = spawnTerrain

    return aram
end

function load(self)
    -- love.graphics.setBackgroundColor(0.8, 0.7, 0.65)
    -- love.graphics.setBackgroundColor(0.4, 0.35, 0.35)
    love.graphics.setBackgroundColor(backgroundColor)

    -- create the terrain
    self:spawnTerrain()

    -- spawn first minion waves
    self:spawnMinions()
end

function update(self, dt)
    -- kill all npcs that are dead :)
    for i, npc in ipairs(self.state.npcs) do
        if npc.meta.hp <= 0 then
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
        if self.state.dt - timer.lastRun >= timer.cd then
            timer.run(self)
            timer.lastRun = self.state.dt
        end
    end
end

function draw(self) end

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
