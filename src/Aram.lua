local Minion = require 'src.Minion'
local Player = require 'src.Player'
local Sion = require 'src.Sion'
local GameState = require 'src.GameState'
local IGame = require 'src.IGame'

local Aram = {}

local load, update, draw

-- Aram is an IGame (technically, IGame wraps Aram)
-- features:
--   * single lane
--   * no recalling
--   * outer tower, inhib tower, 2 base towers
function Aram.new()
    local state = GameState.new()

    -- spawn the main player
    table.insert(state.players,
        Player.new("player1", Sion.new({x = 600, y = 300}, 500))
    )

    return IGame.new(load, update, draw, state)
end

function load(self)
    love.graphics.setBackgroundColor(0.1,0.1,0.1)
end

function update(self, dt)
    -- kill all npcs that are dead :)
    for i, npc in ipairs(self.state.npcs) do
        if npc.meta.hp <= 0 then
            table.remove(self.state.npcs, i)
        end
    end

    -- if there are no npcs, spawn one
    if #self.state.npcs == 0 then
        table.insert(self.state.npcs, Minion.new(math.ceil(math.random() * 300), {
            x = math.ceil(math.random() * love.graphics.getWidth()),
            y = math.ceil(math.random() * love.graphics.getHeight()),
        }))
    end
end

function draw(self)
    --
end

return Aram
