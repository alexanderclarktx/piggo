local Minion = require 'src.Minion'
local Player = require 'src.Player'
local Sion = require 'src.Sion'

local Aram = {}

local load, update, draw

-- aram is a game mode with a single lane
function Aram.new()
    return {
        state = nil,
        damageController = nil,
        load = load,
        update = update,
        draw = draw
    }
end

-- set up all assets, place characters, start timers, set up callbacks
function load(self, state, damageController)
    assert(state)
    assert(damageController)
    self.state = state
    self.damageController = damageController

    -- spawn all players
    table.insert(self.state.players,
        Player.new("player1", Sion.new({x = 600, y = 300}, 500, self.damageController))
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
