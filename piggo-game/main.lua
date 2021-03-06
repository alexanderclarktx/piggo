local PiggoClient = require "piggo-client.PiggoClient"
local Logger = require "piggo-core.util.Logger"

local piggo = PiggoClient.new()

function love.load(arg)
    -- default render mode
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- initialize logging
    log = Logger.new(arg[1] and arg[1] == "--debug")

    -- load the game
    piggo:load()

    -- disable the OS mouse
    love.mouse.setVisible(false)
end

function love.update(dt)
    piggo:update(dt)
end

function love.draw()
    piggo:draw()
end

function love.keypressed(key, scancode, isrepeat)
    piggo:handleKeyPressed(key, scancode, isrepeat)
end

function love.mousepressed(x, y, mouseButton)
    piggo:handleMousePressed(x, y, mouseButton)
end

function love.mousemoved(x, y, dx, dy)
    piggo:handleMouseMoved(x, y)
end

function love.resize(w, h)
    print(("Window resized to width: %d and height: %d."):format(w, h))
end
