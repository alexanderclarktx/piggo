local Piggo = {}
local MainMenu = require "src.application.ui.MainMenu"
local Server = require "src.application.net.Server"
local Client = require "src.application.net.Client"
local Aram = require "src.game.Aram"

local load, update, draw, handleKeyPressed, printDebug, setScene

-- top level application controller
function Piggo.new()
    local piggo = {
        load = load, update = update, draw = draw,
        setScene = setScene, handleKeyPressed = handleKeyPressed,
        state = {
            scenes = {
                MainMenu.new(),
                Client.new(Aram.new()),
            },
            currentScene = 1
        },
        server = Server.new(Aram.new())
    }
    return piggo
end

function load(self)
    self.state.scenes[self.state.currentScene]:load()
end

function update(self, dt)
    self.state.scenes[self.state.currentScene]:update(dt)
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

function setScene(self, scene)
    assert(scene and scene <= #self.state.scenes and scene ~= self.state.currentScene)

    love.graphics.setNewFont(12)
    self.state.scenes[scene]:load()
    self.state.currentScene = scene
end

return Piggo
