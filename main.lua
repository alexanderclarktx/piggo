local Sion = require 'src.sion'
local Minion = require 'src.minion'
local Player = require 'src.player'
local Gui = require 'src.gui'
local PlayerController = require 'src.playercontroller'

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
    love.graphics.setBackgroundColor(0.1,0.1,0.1)
    gs.gui = Gui.new(gs.players[1])
    gs.playerController = PlayerController.new(gs.players[1])
end

function love.draw()
    for _, player in pairs(gs.players) do
        player:draw()
    end

    for _, npc in pairs(gs.npcs) do 
        npc:draw()
    end

    gs.gui:draw()

    gs.playerController:draw()
end

function love.keypressed(key, scancode, isrepeat)
    gs.playerController:keypressed(key, scancode, isrepeat)
end

function love.update(dt)
    -- update player controller
    gs.playerController:update(dt)

    -- update damage controller
    -- gs.damageController:update(dt)

    -- apply all hurtboxes
    for i, hurtbox in ipairs(gs.hurtboxes) do
        for _, npc in pairs(gs.npcs) do
            if polyCheck(hurtbox.poly, npc.pos.x, npc.pos.y) then
                npc.hp = npc.hp - hurtbox.damage
            end
        end
    end
    gs.hurtboxes = {}
    if #gs.hurtboxes > 0 then print('there are hurtboxes') end

    -- update all internal states
    for _, player in pairs(gs.players) do
        player:update(dt)
    end

    -- update all npcs
    for index, npc in pairs(gs.npcs) do
        npc:update(dt, index)
    end

    -- if there are no npcs, spawn one
    if #gs.npcs == 0 then
        table.insert(gs.npcs, Minion.new(math.ceil(math.random() * 300), {
            x = math.ceil(math.random() * love.graphics.getWidth()),
            y = math.ceil(math.random() * love.graphics.getHeight()),
        }))
    end

    -- for _, object in pairs(gs.objects) do
    --     object:update(dt)
    -- end
end
