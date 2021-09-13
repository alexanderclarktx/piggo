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
    GameState.load()

    -- spawn the main player
    table.insert(state.players,
        Player.new("player1", Sion.new(500, 250, 500))
    )

    return IGame.new(load, update, draw, state)
end

function load(self)
    -- love.graphics.setBackgroundColor(0.8, 0.7, 0.65)
    love.graphics.setBackgroundColor(0.4, 0.35, 0.35)

    -- create the terrain
    spawnTerrain()

    -- fade in the camera
    state.camera.fade_color = {0, 0, 0, 0.6}
    state.camera:fade(1.5, {0, 0, 0, 0})
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
        table.insert(state.npcs, Minion.new(
            math.random(love.graphics.getWidth()),
            math.random(love.graphics.getHeight()),
            math.random(300)
        ))
    end
end

function draw(self) end

function spawnTerrain()
    state.terrains = {
        Terrain.new(300, 150, {
            0, 0,
            300, 0,
            300, 50,
            100, 50,
        }),
        Terrain.new(750, 150, {
            0, 0,
            300, 0,
            300, 50,
            100, 50,
        }),
        Terrain.new(0, -50, { -- top wall
            0, 0,
            0, 50,
            1400, 50,
            1400, 0,
        }),
        Terrain.new(0, 600, { -- bottom wall
            0, 0,
            0, 50,
            1400, 50,
            1400, 0,
        })
    }
end

return Aram
