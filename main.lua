local Piggo = require 'src.Piggo'

function love.load(arg)
    piggo = Piggo.new() -- piggo is in global scope
    piggo:load()

    -- debug flag
    love.graphics.setDefaultFilter("nearest", "nearest")
    if arg[1] and arg[1] == "--debug" then
        debug = printDebug
    else
        debug = function() return false end
    end
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
