local MainMenu = {}
local IMenu = require "src.piggo.ui.IMenu"
local Aram = require "src.contrib.aram.Aram"
local Client = require "src.piggo.net.Client"

function MainMenu.new()
    local menu = IMenu.new({
        love.graphics.newFont("res/fonts/Hussar.otf", 100),
        love.graphics.newFont(25)
    })
    local windowWidth, _ = love.graphics.getDimensions()

    -- title
    menu:addText("Piggo", 0, 100, windowWidth, 1)

    -- start button
    menu:addButton("start", windowWidth/2 - 100, 300, 200, 50, 2, onclickStart)

    -- settings button
    menu:addButton("settings", windowWidth/2 - 100, 375, 200, 50, 2, onclickSettings)

    return menu
end

-- start the game
function onclickStart(state)
    log:debug("start")
    state:setScene(Client.new(Aram.new()))
end

-- TODO open the settings overlay
function onclickSettings(state)
    log:debug("settings")
end

return MainMenu