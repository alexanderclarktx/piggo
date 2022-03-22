local PiggoServer = require "piggo-server.src.PiggoServer"
local Logger = require "piggo-core.util.Logger"

local piggo = PiggoServer.new()

function love.load(arg)
    -- initialize logging
    log = Logger.new(arg[1] and arg[1] == "--debug")

    -- load the game
    piggo:load()

    love.mouse.setVisible(false)
end

function love.update(dt)
    piggo:update(dt)
end

function love.draw() end

function love.keypressed(key, scancode, isrepeat)
    -- piggo:handleKeyPressed(key, scancode, isrepeat)
end

function love.mousepressed(x, y, mouseButton)
    -- piggo:handleMousePressed(x, y, mouseButton)
end

function love.mousemoved(x, y, dx, dy)
    -- piggo:handleMouseMoved(x, y)
end
