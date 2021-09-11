local Minion = require 'src.character.Minion'
local Sion = require 'src.character.Sion'
local Player = require 'src.player.Player'
local GameState = require 'src.game.GameState'
local IGame = require 'src.game.IGame'

local Aram = {}

local load, update, draw

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

function draw(self) end

return Aram
