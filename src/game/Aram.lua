local Minion = require 'src.character.Minion'
local Sion = require 'src.character.Sion'
local Player = require 'src.player.Player'
local GameState = require 'src.game.GameState'
local IGame = require 'src.game.IGame'
local Terrain = require 'src.game.Terrain'

local Aram = {}

local load, update, draw, spawnMinions, spawnTerrain

-- rules:
--   * single lane
--   * no recalling
--   * outer tower, inhib tower, inhib, 2 nexus towers, nexus
function Aram.new()
    GameState.load()

    -- spawn the main player
    table.insert(state.players,
        Player.new("player1", Sion.new(500, 250, 500))
    )

    local aram = IGame.new(load, update, draw, state)

    aram.timers = {
        minionSpawn = {
            cd = 10,
            last = 0,
            run = spawnMinions
        },
    }

    return aram
end

function load(self)
    -- love.graphics.setBackgroundColor(0.8, 0.7, 0.65)
    -- love.graphics.setBackgroundColor(0.4, 0.35, 0.35)
    love.graphics.setBackgroundColor(0.05, 0.05, 0.15)

    -- create the terrain
    spawnTerrain()

    -- spawn first minions
    spawnMinions()

    -- fade in the camera
    state.camera.fade_color = {0, 0, 0, 0.6}
    state.camera:fade(1.5, {0, 0, 0, 0})
end

function update(self, dt)
    -- kill all npcs that are dead :)
    for i, npc in ipairs(state.npcs) do
        if npc.meta.hp <= 0 then
            table.remove(state.npcs, i)
            npc.body:destroy()
        end
    end

    -- run timers
    for _, timer in pairs(self.timers) do
        assert(
            timer.cd ~= nil, timer.cd > 0,
            timer.last ~= nil, type(timer.last) == "number",
            timer.run ~= nil, type(timer.run) == "function"
        )
        if state.dt - timer.last >= timer.cd then
            -- run the callback
            timer.run(self)

            -- set last
            timer.last = state.dt
        end
    end
end

function draw(self) end

function spawnMinions()
    -- spawn team 1 minions
    for i = 1, 5, 1 do
        table.insert(state.npcs,
            Minion.new(2000 - 10 * i, 100, math.random(300), {x = 0, y = 100}, 1)
        )
    end

    -- spawn team 2 minions
    for i = 1, 5, 1 do
        table.insert(state.npcs,
            Minion.new(-400 - 10 * i, 100, math.random(300), {x = 1400, y = 100}, 2)
        )
    end
end

function spawnTerrain()
    state.terrains = {
        -- top wall
        Terrain.new(-400, -600, {
            0, 0,
            0, 500,
            3400, 500,
            3400, 0,
        }),
        -- top alcove
        Terrain.new(650, -100, {
            -50, 0,
            350, 0,
            300, 50,
            000, 50,
        }),
        -- bottom alcove
        Terrain.new(650, 450, {
            0, 0,
            300, 0,
            300, 50,
            000, 50,
        }),
        -- bottom walls
        Terrain.new(-400, 500, { -- left
            0, 0,
            0, 500,
            700, 500,
            700, 0,
        }),
        Terrain.new(300, 500, { -- left curve
            0, 0,
            0, 500,
            400, 500,
            400, 200,
        }),
        Terrain.new(700, 700, { -- bottom bottom
            0, 0,
            0, 300,
            200, 300,
            200, 0,
        }),
        Terrain.new(900, 500, { -- right curve
            0, 200,
            0, 500,
            400, 500,
            400, 0,
        }),
        Terrain.new(1300, 500, { -- right
            0, 0,
            0, 500,
            700, 500,
            700, 0,
        })
    }
end

return Aram
