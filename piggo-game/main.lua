-- local PiggoClient = require "piggo-client.PiggoClient"
local Logger = require "piggo-core.util.Logger"
local Batto = require "piggo-contrib.ecs.batto.Batto"

local game = Batto.new()

function love.load(arg)
    -- default render mode
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- initialize logging
    log = Logger.new(arg[1] and arg[1] == "--debug")

    -- load the game
    game:load()

    -- disable the OS mouse
    love.mouse.setVisible(false)
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end

-- function love.keypressed(key, scancode, isrepeat)
--     piggo:handleKeyPressed(key, scancode, isrepeat)
-- end

-- function love.mousepressed(x, y, mouseButton)
--     piggo:handleMousePressed(x, y, mouseButton)
-- end

-- function love.mousemoved(x, y, dx, dy)
--     piggo:handleMouseMoved(x, y)
-- end

function love.resize(w, h)
    print(("Window resized to width: %d and height: %d."):format(w, h))
end
