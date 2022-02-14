local Piggo = {}
local MainMenu = require "src.piggo.ui.MainMenu"
local Client = require "src.piggo.net.Client"
local Server = require "src.piggo.net.Server"
local Aram = require "src.contrib.aram.Aram"

local load, update, draw, handleKeyPressed, handleMousePressed, startServerThread

-- top level application controller
function Piggo.new()
    local piggo = {
        state = {
            scene = MainMenu.new(),
            setScene = function(self, scene)
                assert(scene)
                love.graphics.setNewFont(12)
                scene:load()
                self.scene = scene
            end
        },
        load = load, update = update, draw = draw,
        handleKeyPressed = handleKeyPressed,
        handleMousePressed = handleMousePressed,
    }

    return piggo
end

function load(self)
    self.state.scene:load()

    startServerThread("src.contrib.aram.Aram") -- TODO
end

function update(self, dt)
    self.state.scene:update(dt, self.state)
    -- TODO server/client healthchecks?
end

function draw(self)
    self.state.scene:draw()
end

function handleKeyPressed(self, key, scancode, isrepeat)
    if key == "space" then
        love.event.quit()
    end

    self.state.scene:handleKeyPressed(key, scancode, isrepeat, self.state)
end

function handleMousePressed(self, x, y, mouseButton)
    self.state.scene:handleMousePressed(x, y, mouseButton, self.state)
end

function startServerThread(gameFile)
    assert(gameFile)
    local thread = love.thread.newThread([[
        local t = require "love.timer"
        local Server = require "src.piggo.net.Server"
        log = require("src.piggo.util.Logger").new(false)

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

return Piggo
