local Gui = {}

local function drawDebug()
    local debugFPS = "FPS: %d"

    love.graphics.setColor(0, 1, 0, 0.7)
    love.graphics.print(debugFPS:format(love.timer.getFPS()), 10, 10)
end

local function drawConsole(player)
    -- outlines
    love.graphics.setColor(.7, .7, .2)
    love.graphics.rectangle("line", 500, 600, 50, 50)
    love.graphics.rectangle("line", 555, 600, 50, 50)
    love.graphics.rectangle("line", 610, 600, 50, 50)
    love.graphics.rectangle("line", 665, 600, 50, 50)

    -- cooldown indicator
    if player.character.abilities.q.dt < player.character.abilities.q.cd then
        love.graphics.setColor(.3, .3, .3)
        -- love.graphics.setColor(1, 1, 0)
        love.graphics.stencil(function() love.graphics.rectangle("fill", 500, 600, 50, 50, .5) end)
        love.graphics.setStencilTest("greater", 0)
        love.graphics.arc( "fill", "pie", 525, 625, 40, 4.71, 10.99 - 6.28 * (player.character.abilities.q.dt / player.character.abilities.q.cd) )
        love.graphics.setStencilTest()
    end

    -- keybinds
    love.graphics.setColor(.7, .7, .2)
    love.graphics.print("q", 505, 630)
    love.graphics.print("w", 560, 630)
    love.graphics.print("e", 615, 630)
    love.graphics.print("r", 670, 630)
end

function Gui.new(player)
    local gui = {
        player = player,
        draw = function(self)
            drawDebug()
            drawConsole(self.player)
        end,
    }
    return gui
end

return Gui
