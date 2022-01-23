local MainMenu = {}
local IMenu = require "src.application.ui.IMenu"

function MainMenu.new()
    local menu = IMenu.new({
        love.graphics.newFont("res/fonts/Hussar.otf", 100),
        love.graphics.newFont(25)
    })
    local windowWidth, _ = love.graphics.getDimensions()

    -- title
    menu:addText("Piggo", 0, 100, windowWidth, 1)

    -- start button
    menu:addButton("start", windowWidth/2 - 100, 300, 200, 50, 2, onStart)

    -- settings button
    menu:addButton("settings", windowWidth/2 - 100, 375, 200, 50, 2, onSettings)

    return menu
end

-- start the game
function onStart()
    debug("start")
    piggo:setScene(2)
end

-- TODO open the settings overlay
function onSettings()
    debug("settings")
end

return MainMenu
