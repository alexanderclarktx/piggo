local Piggo = {}
local MainMenu = require "piggo-client.ui.MainMenu"
local socket = require "socket"
local ripple = require "lib.ripple"

if love.system.getOS() == "web" then require "lib.js" end

local load, update, draw, handleKeyPressed, handleMousePressed, handleMouseMoved

local defaultCursorColor = {1, 1, 1}

-- local beep = ripple.newSound(love.audio.newSource('res/sound/beep.mp3', 'stream'), {
    -- loop = true
-- })

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
            end,
            cursorColor = defaultCursorColor
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
    -- if JS then
    --     socket.sleep(1)
    --     JS.newRequest("`${window.innerWidth}:${window.innerHeight}`",
    --         function(wh)
    --             local w, h = wh:match("(%d*):(%d*)")
    --             love.window.setMode(w * .9, h * .85)
    --         end
    --     )
    --     JS.retrieveData(.01)
    -- end

    -- load the menu
    self.state:setScene(MainMenu.new())
    self.state.scene:load()
end

function update(self, dt)
    if JS then JS.retrieveData(dt) end

    self.state.scene:update(dt, self.state)
end

function draw(self)
    self.state.scene:draw()

    -- cursor
    local mouseX, mouseY = love.mouse.getPosition()
    love.graphics.setColor(self.state.cursorColor)
    love.graphics.circle("fill", mouseX, mouseY, 3)
    love.graphics.setColor(defaultCursorColor)
    love.graphics.circle("line", mouseX, mouseY, 4)
    love.graphics.circle("line", mouseX, mouseY, 5)
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
