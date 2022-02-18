local Piggo = require "src.piggo.Piggo"
local Logger = require "src.piggo.util.Logger"

local piggo = Piggo.new()

function love.load(arg)
    -- default render mode
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- initialize logging
    log = Logger.new(arg[1] and arg[1] == "--debug")

    -- load the game
    piggo:load()
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
