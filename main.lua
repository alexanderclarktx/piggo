local Aram = require 'src.game.Aram'

local game = Aram.new()
local printDebug

function love.load(arg)
    love.graphics.setDefaultFilter("nearest", "nearest")
    if arg[1] and arg[1] == "--debug" then
        debug = printDebug
    else
        debug = function() return false end
    end
    game:load()
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end

function love.keypressed(key, scancode, isrepeat)
    game:keypressed(key, scancode, isrepeat)
end

function printDebug(...)
    if ... then
        io.write("[debug] ")
        print(...)
    end
    return true
end
