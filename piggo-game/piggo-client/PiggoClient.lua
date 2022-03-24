local Piggo = {}
local MainMenu = require "piggo-client.ui.MainMenu"
local socket = require "socket"

require "lib/js" -- JS

local load, update, draw, handleKeyPressed, handleMousePressed, handleMouseMoved

-- top level application controller
function Piggo.new()
    local piggo = {
        state = {
            scene = nil,
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
    -- get the screen size
    if JS then
        JS.newRequest("`${window.innerWidth}:${window.innerHeight}`",
            function(wh)
                local w, h = wh:match("(%d*):(%d*)")
                love.window.setMode(w * .9, h * .85)
                print(w)
                print(h)
            end
        )
        JS.retrieveData(.01)
    end

    -- load the menu
    self.state:setScene(MainMenu.new())
    self.state.scene:load()
end

function update(self, dt)
    JS.retrieveData(dt)

    self.state.scene:update(dt, self.state)
end

function draw(self)
    self.state.scene:draw()

    local mouseX, mouseY = love.mouse.getPosition()
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", mouseX, mouseY, 5)
end

function handleKeyPressed(self, key, scancode, isrepeat)
    self.state.scene:handleKeyPressed(key, scancode, isrepeat, self.state)
end

function handleMousePressed(self, x, y, mouseButton)
    self.state.scene:handleMousePressed(x, y, mouseButton, self.state)
end

function handleMouseMoved(self, x, y)
    self.state.scene:handleMouseMoved(x, y, self.state)
end

return Piggo
