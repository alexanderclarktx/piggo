local Aram = require 'src.Aram'

local game = Aram.new()
local printDebug
debug = function() end

function love.load(arg)
    if arg[1] and arg[1] == "--debug" then
        debug = printDebug
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
    io.write("[debug] ")
    print(...)
end
