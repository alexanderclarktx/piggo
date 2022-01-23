local Piggo = {}
local MainMenu = require "src.application.ui.MainMenu"
local Server = require "src.application.net.Server"
local Client = require "src.application.net.Client"
local Aram = require "src.game.Aram"

local load, update, draw, handleKeyPressed

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
        },
        server = Server.new(Aram.new())
    }
    return piggo
end

function load(self)
    self.state.scenes[self.state.currentScene]:load()
end

function update(self, dt)
    if self.server then
        self.server:update(dt, self.state)
    end
    self.state.scenes[self.state.currentScene]:update(dt, self.state)
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

return Piggo
