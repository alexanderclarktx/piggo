local Minion = require 'src.Minion'
local Player = require 'src.Player'
local Sion = require 'src.Sion'

local Aram = {}

local load, update, draw

-- Aram is an IGameController
-- features:
--   * single lane
--   * no recalling
--   * outer tower, inhib tower, 2 base towers
function Aram.new()
    return IGameController.new(self, GameState.new(), Player.new("player1", Sion.new({x = 600, y = 300}, 500, self.damageController)))
end

-- set up all assets, place characters, start timers, set up callbacks
function load(self)
    -- spawn all players
    table.insert(self.state.players,
        
    )



    -- love.graphics.setBackgroundColor(1, 1, 1)
    love.graphics.setBackgroundColor(0.1,0.1,0.1)
end

function update(self, dt)
    -- kill all npcs that are dead :)
    for i, npc in ipairs(self.state.npcs) do
        if npc.hp <= 0 then
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

-- function draw(self)
--     print("draw")
-- end

return Aram
