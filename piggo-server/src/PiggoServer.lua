local PiggoServer = {}
local Server = require "piggo-core.net.Server"
local Aram = require "piggo-contrib.aram.Aram"
local Arena = require "piggo-contrib.arena.Arena"

local load, update

function PiggoServer.new()
    local piggoServer = {
        state = {
            -- game = "ARAM" -- TODO
        },
        load = load, update = update
    }
    return piggoServer
end

function load(self)
    -- self.state.server = Server.new(Aram.new())
    self.state.server = Server.new(Arena.new())
end

function update(self, dt)
    self.state.server:update(dt)
end

return PiggoServer
