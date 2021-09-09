local Sion = require 'src.Sion'
local Minion = require 'src.Minion'
local Player = require 'src.Player'
local Gui = require 'src.Gui'
local PlayerController = require 'src.PlayerController'
local ShapeUtils = require 'src.ShapeUtils'

gs = {
    players = {
        Player.new("player1", Sion.new({x = 600, y = 300}, 500)),
    },
    npcs = {},
    hurtboxes = {} -- name, damage, poly,
}

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
    gs.playerController:handleKeyPressed(key, scancode, isrepeat)
end

function love.update(dt)
    -- update player controller
    gs.playerController:update(dt)

    -- update damage controller
    -- gs.damageController:update(dt)

    -- apply all hurtboxes
    for i, hurtbox in ipairs(gs.hurtboxes) do
        for _, npc in pairs(gs.npcs) do
            if ShapeUtils.pointInPolygon(npc.pos.x, npc.pos.y, hurtbox.poly) then
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
