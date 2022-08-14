local PiggoServer = require "piggo-server.src.PiggoServer"
local Logger = require "piggo-core.util.Logger"

local piggo = PiggoServer.new()

function love.load(arg)
    -- initialize logging
    log = Logger.new(arg[1] and arg[1] == "--debug")

    -- load the game
    piggo:load()
end

function love.update(dt)
    piggo:update(dt)
end

function love.draw() end

