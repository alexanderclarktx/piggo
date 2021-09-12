local Minion = require 'src.character.Minion'
local Sion = require 'src.character.Sion'
local Player = require 'src.player.Player'
local GameState = require 'src.game.GameState'
local IGame = require 'src.game.IGame'
local Terrain = require 'src.game.Terrain'

local Aram = {}

local load, update, draw, spawnTerrain

-- rules:
--   * single lane
--   * no recalling
--   * outer tower, inhib tower, inhib, 2 nexus towers, nexus
function Aram.new()
    local state = GameState.new()

    -- spawn the main player
    table.insert(state.players,
        Player.new("player1", Sion.new({x = 600, y = 300}, 500))
    )

    return IGame.new(load, update, draw, state)
end

function load(self)
    -- love.graphics.setBackgroundColor(0.8, 0.7, 0.65)
    love.graphics.setBackgroundColor(0.4, 0.35, 0.35)

    -- create the terrain
    spawnTerrain(self)
end

function update(self, dt)
    -- kill all npcs that are dead :)
    for i, npc in ipairs(state.npcs) do
        if npc.meta.hp <= 0 then
            table.remove(state.npcs, i)
        end
    end

    -- if there are no npcs, spawn one
    if #state.npcs == 0 then
        table.insert(state.npcs, Minion.new(math.ceil(math.random() * 300), {
            x = math.ceil(math.random() * love.graphics.getWidth()),
            y = math.ceil(math.random() * love.graphics.getHeight()),
        }))
    end
end

function draw(self) end

function spawnTerrain(self)
    state.terrains = {
        Terrain.new({
            300, 150,
            500, 150,
            500, 200,
            200, 200,
        }),
        Terrain.new({
            750, 150,
            900, 150,
            1000, 200,
            750, 200,
        }),
        Terrain.new({ -- top wall
            0, 0,
            0, 50,
            1400, 50,
            1400, 0,
        }),
        Terrain.new({ -- bottom wall
            0, 700,
            0, 750,
            1400, 750,
            1400, 700,
        })
    }
end

return Aram
