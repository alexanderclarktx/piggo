local Piggo = {}
local MainMenu = require "src.piggo.ui.MainMenu"

local load, update, draw, handleKeyPressed, handleMousePressed, handleMouseMoved

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
        handleMouseMoved = handleMouseMoved,
    }

    return piggo
end

function load(self)
    self.state.scene:load()
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

function handleMouseMoved(self, x, y)
    self.state.scene:handleMouseMoved(x, y, self.state)
end

return Piggo
