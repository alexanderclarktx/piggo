local GameController = require 'src.GameController'
local Aram = require 'src.Aram'

local gameController = GameController.new(Aram.new())

function love.load()
    gameController:load()
end

function love.update(dt)
    gameController:update(dt)
end

function love.draw()
    gameController:draw()
end

function love.keypressed(key, scancode, isrepeat)
    gameController:keypressed(key, scancode, isrepeat)
end
