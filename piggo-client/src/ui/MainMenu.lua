local MainMenu = {}
local Client = require "piggo-client.src.Client"
local IMenu = require "piggo-client.src.ui.IMenu"
local Aram = require "piggo-contrib.aram.Aram"
local Arena = require "piggo-contrib.arena.Arena"
local AutoChess = require "piggo-contrib.autochess.AutoChess"

local onclickARAM, onclickArena, onclickSettings, startServerThread

function MainMenu.new()
    local menu = IMenu.new({
        love.graphics.newFont("res/fonts/Hussar.otf", 100),
        love.graphics.newFont(25)
    })
    local windowWidth, _ = love.graphics.getDimensions()

    -- title
    menu:addText("Piggo", 0, 100, windowWidth, 1)

    -- ARAM button
    menu:addButton("ARAM", windowWidth/2 - 100, 300, 200, 50, 2, onclickARAM)

    -- Arena button
    menu:addButton("Arena", windowWidth/2 - 100, 375, 200, 50, 2, onclickArena)

    -- AutoChess button
    menu:addButton("AutoChess", windowWidth/2 - 100, 450, 200, 50, 2, onclickAutoChess)

    -- settings button
    menu:addButton("Settings", windowWidth/2 - 100, 525, 200, 50, 2, onclickSettings)

    return menu
end

-- start the game
function onclickARAM(state)
    log:info("ARAM")
    state:setScene(Client.new(Aram.new()))
    -- startServerThread("piggo-contrib.aram.Aram")
end

function onclickArena(state)
    log:info("Arena")
    state:setScene(Client.new(Arena.new()))
    -- startServerThread("piggo-contrib.arena.Arena")
end

function onclickAutoChess(state)
    log:info("AutoChess")
    state:setScene(Client.new(AutoChess.new()))
    -- startServerThread("piggo-contrib.autochess.AutoChess")
end

-- TODO settings overlay
function onclickSettings(state)
    log:info("settings")
end

function startServerThread(gameFile)
    assert(gameFile)
    local thread = love.thread.newThread([[
        local t = require "love.timer"
        local Server = require "piggo-core.net.Server"
        log = require("piggo-core.util.Logger").new(true)

        local game = require(...)
        assert(game)

        local server = Server.new(game.new())

        local lastFrameTime = love.timer.getTime()
        while true do
            local time = love.timer.getTime()
            server:update(time - lastFrameTime)
            lastFrameTime = time
            t.sleep(0.0001)
        end
    ]])
    thread:start(gameFile)
    return thread
end

return MainMenu
