local Piggo = {}
local MainMenu = require "src.piggo.ui.MainMenu"
local Client = require "src.piggo.net.Client"
local Server = require "src.piggo.net.Server"
local Aram = require "src.contrib.aram.Aram"

local load, update, draw, handleKeyPressed, startServerThread

-- top level application controller
function Piggo.new()
    local piggo = {
        load = load, update = update, draw = draw,
        handleKeyPressed = handleKeyPressed,
        state = {
            scenes = {
                MainMenu.new(),
                Client.new(Aram.new()),
            },
            currentScene = 1,
            setScene = function(self, sceneNumber)
                assert(sceneNumber and sceneNumber <= #self.scenes and sceneNumber ~= self.currentScene)

                love.graphics.setNewFont(12)
                self.scenes[sceneNumber]:load()
                self.currentScene = sceneNumber
            end
        }
    }

    return piggo
end

function load(self)
    self.state.scenes[self.state.currentScene]:load()

    startServerThread("src.contrib.aram.Aram")
end

function update(self, dt)
    self.state.scenes[self.state.currentScene]:update(dt, self.state)
    -- TODO server/client healthchecks?
end

function draw(self)
    self.state.scenes[self.state.currentScene]:draw()
end

function handleKeyPressed(self, key, scancode, isrepeat)
    if key == "space" then
        love.event.quit()
    end

    self.state.scenes[self.state.currentScene]:handleKeyPressed(key, scancode, isrepeat)
end

function startServerThread(gameFile)
    assert(gameFile)
    local thread = love.thread.newThread([[
        local t = require "love.timer"
        local Server = require "src.piggo.net.Server"
        debug = require "src.piggo.util.debug"

        local game = require(...)
        assert(game)

        local server = Server.new(game.new())
        while true do
            server:update(.05)
            t.sleep(0.05)
        end
    ]])
    thread:start(gameFile)
    return thread
end

return Piggo
