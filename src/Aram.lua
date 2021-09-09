local Aram = {}

local load, update, draw

-- aram is a game mode with a single lane
function Aram.new(gameState)
    return {
        gameState = gameState,
        load = load,
        update = update,
    }
end

function update(self, dt)
    print("abc")
    print(self.gameState)
end

-- aram:load()
-- sets up all assets, places characters, starts timers, sets up callbacks


local gs = {
    players = {
        -- Player.new("player1", Sion.new({x = 600, y = 300}, 500)),
    },
    npcs = {},
    hurtboxes = {} -- name, damage, poly
}
local a = Aram.new(gs)
a:update(0.02)

