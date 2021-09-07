const = require 'src.const'
local Sion = require 'src.sion'
local Minion = require 'src.minion'
local Player = require 'src.player'
local Gui = require 'src.gui'

gs = {
    players = {
        Player.new("player1", Sion.new({x = 600, y = 300}, 500)),
    },
    npcs = {},
    hurtboxes = {} -- name, damage, poly
}

-- https://love2d.org/wiki/polypoint
function polyCheck(vertices,px,py)
    local collision = false
    local next = 1
        for current = 1, #vertices do
        next = current + 1
        if (next > #vertices) then
            next = 1
        end
        local vc = vertices[current]
        local vn = vertices[next]
        if (((vc.y >= py and vn.y < py) or (vc.y < py and vn.y >= py)) and
                (px < (vn.x-vc.x)*(py-vc.y) / (vn.y-vc.y)+vc.x)) then
            collision = not(collision)
        end
        end
    return collision
end
   

function love.load()
    -- love.graphics.setBackgroundColor(1, 1, 1)
    love.graphics.setBackgroundColor(0,0,0)
    gs.gui = Gui.new(gs.players[1])
end

function love.draw()
    for _, player in pairs(gs.players) do
        player:draw()
    end

    for _, npc in pairs(gs.npcs) do 
        npc:draw()
    end

    gs.gui:draw()
end

function love.keypressed(key, scancode, isrepeat)
    if key == "space" then
        love.event.quit()
    end

    if key == "q" then
        -- print("q")
        gs.players[1].character:q()
    end
    if key == "w" then
        -- print("w")
        gs.players[1].character:w()
    end
    if key == "e" then
        -- print("e")
        gs.players[1].character:e()
    end
    if key == "r" then
        -- print("r")
        gs.players[1].character:r()
    end
end

function love.update(dt)
    -- player movement
    if love.mouse.isDown(2) then
        mouseX = love.mouse.getX()
        mouseY = love.mouse.getY()

        gs.players[1].character.cmeta.marker = {x = mouseX, y = mouseY}
    end

    -- update all internal states
    for _, player in pairs(gs.players) do
        player:update(dt)
    end

    -- update all npcs
    for index, npc in pairs(gs.npcs) do
        npc:update(dt, index)
    end

    -- if there are no npcs, spawn one
    print("#gs.npcs", #gs.npcs)
    if #gs.npcs == 0 then
        table.insert(gs.npcs, Minion.new(math.ceil(math.random() * 300), {
            x = math.ceil(math.random() * love.graphics.getWidth()),
            y = math.ceil(math.random() * love.graphics.getHeight()),
        }))
    end

    -- for _, object in pairs(gs.objects) do
    --     object:update(dt)
    -- end

    -- apply all hurtboxes
    for _, hurtbox in pairs(gs.hurtboxes) do
        for _, npc in pairs(gs.npcs) do
            if polyCheck(hurtbox.poly, npc.pos.x, npc.pos.y) then
                npc.hp = npc.hp - hurtbox.damage
            end
        end
    end
end
