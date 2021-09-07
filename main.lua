const = require 'src.const'
local Sion = require 'src.sion'
local Minion = require 'src.minion'
local Player = require 'src.player'
local Gui = require 'src.gui'

local gs = {
    players = {
        Player.new("player1", Sion.new({x = 600, y = 300}, 500)),
    },
    npc = {
        Minion.new() -- hp, size, pos
    }
}

function love.load()
    -- love.graphics.setBackgroundColor(1, 1, 1)
    love.graphics.setBackgroundColor(0,0,0)
    gs.gui = Gui.new(gs.players[1])
end

function love.draw()
    for _, player in pairs(gs.players) do
        player:draw()
    end

    for _, npc in pairs(gs.npc) do 
        npc:draw()
    end

    gs.gui:draw()
end

function love.keypressed(key, scancode, isrepeat)
    if key == "space" then
        love.event.quit()
    end

    if key == "q" then
        print("q")
        gs.players[1].character:q()
    end
    if key == "w" then
        print("w")
        gs.players[1].character:w()
    end
    if key == "e" then
        print("e")
        gs.players[1].character:e()
    end
    if key == "r" then
        print("r")
        gs.players[1].character:r()
    end
end

function love.update(dt)
    -- player movement
    if love.mouse.isDown(1) then
        mouseX = love.mouse.getX()
        mouseY = love.mouse.getY()
        characterX = gs.players[1].character.cmeta.pos.x
        characterY = gs.players[1].character.cmeta.pos.y

        if characterX < mouseX then
            gs.players[1].character.cmeta.pos.x = characterX + 1
        elseif characterX > mouseX then
            gs.players[1].character.cmeta.pos.x = characterX - 1
        end

        if characterY < mouseY then
            gs.players[1].character.cmeta.pos.y = characterY + 1
        elseif characterY > mouseY then
            gs.players[1].character.cmeta.pos.y = characterY - 1
        end
    end

    -- update all internal states
    for _, player in pairs(gs.players) do
        player:update(dt)
    end
    -- for _, object in pairs(gs.objects) do
    --     object:update(dt)
    -- end
end
