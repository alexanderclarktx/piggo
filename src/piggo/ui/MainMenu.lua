local MainMenu = {}
local IMenu = require "src.piggo.ui.IMenu"
local Aram = require "src.contrib.aram.Aram"
local Arena = require "src.contrib.arena.Arena"
local AutoChess = require "src.contrib.autochess.AutoChess"
local Client = require "src.piggo.net.Client"

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
    startServerThread("src.contrib.aram.Aram")
end

function onclickArena(state)
    log:info("Arena")
    state:setScene(Client.new(Arena.new()))
    startServerThread("src.contrib.arena.Arena")
end

function onclickAutoChess(state)
    log:info("AutoChess")
    state:setScene(Client.new(AutoChess.new()))
    startServerThread("src.contrib.autochess.AutoChess")
end

-- TODO settings overlay
function onclickSettings(state)
    log:info("settings")
end

function startServerThread(gameFile)
    assert(gameFile)
    local thread = love.thread.newThread([[
        local t = require "love.timer"
        local Server = require "src.piggo.net.Server"
        log = require("src.piggo.util.Logger").new(true)

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
