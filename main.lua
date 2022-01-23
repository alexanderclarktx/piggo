local Piggo = require "src.application.Piggo"

local piggo = Piggo.new()

function love.load(arg)
    -- handle debug flag
    love.graphics.setDefaultFilter("nearest", "nearest")
    if arg[1] and arg[1] == "--debug" then
        debug = printDebug
    else
        debug = function() return false end
    end

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

function printDebug(...)
    if ... then
        io.write("[debug] ")
        print(...)
    end
    return true
end
