local Gui = {}
local DrawUtils = require "piggo-core.util.DrawUtils"

local draw, drawDebug, drawAbilityBackground, drawAbilityOutline, drawCooldownIndicator, drawConsole, drawCharges

local boxWidth, boxHeight, consoleHeight = 50, 50, 0.95

local chargeCounter = "%d / %d"

function Gui.new(player)
    assert(player)
    return {
        -- game = game,
        player = player,
        draw = draw
    }
end

function draw(self)
    if true then drawDebug(self.player) end
    drawConsole(self.player)
end

function drawDebug(player)
    local debug = table.concat({
        "fps: %d",
        "hp: %s",
        "position: x=%d y=%d",
        "marker: x=%d y=%d",
        "velocity: x=%.2f y=%.2f",
        "effects: %d"
    }, "\n")

    local markerX, markerY = 0, 0
    if player.state.character.state.marker then
        markerX = player.state.character.state.marker.x
        markerY = player.state.character.state.marker.y
    end

    local velocityX, velocityY = player.state.character.state.body:getLinearVelocity()

    love.graphics.setColor(1, 1, 0, 0.7)
    love.graphics.print(debug:format(
        love.timer.getFPS(),
        player.state.character.state.hp,
        player.state.character.state.body:getX(), player.state.character.state.body:getY(),
        markerX, markerY,
        velocityX/100.0, velocityY/100.0,
        #player.state.character.state.effects
    ), 10, 10)
end

function drawConsole(player)
    local offset = 3 * 60
    for _, key in ipairs({"q", "e", "r", "z", "x", "c"}) do
        local ability = player.state.character.state.abilities[key]
        if ability then
            local x, y = love.graphics.getWidth() / 2 - offset, love.graphics.getHeight() * consoleHeight - boxHeight

            drawAbilityBackground(x, y)
            drawAbilityOutline(x, y, ability.frame, ability.cd)
            drawCooldownIndicator(x, y, boxWidth, boxHeight, ability.frame, ability.cd)

            love.graphics.print(key, x + 5, y + 30)
            offset = offset - 60
        end
    end
end

-- drawCharges(player.state.character.state.abilities.r, r.x + 18, r.y + 30)
function drawCharges(ability, x, y)
    if ability.charges then
        love.graphics.print(
            chargeCounter:format(ability.charges, ability.maxCharges),
            x, y
        )
    end
end

function drawAbilityBackground(x, y)
    love.graphics.setColor(.1, .3, .8, 0.4)
    love.graphics.rectangle("fill", x, y, boxWidth, boxHeight)
end

function drawAbilityOutline(x, y, dt, cd)
    if dt < cd then
        love.graphics.setColor(.8, .8, .2)
    else
        love.graphics.setColor(1, 1, 1)
    end
    DrawUtils.drawBox(x, y, boxWidth, boxHeight)
end

function drawCooldownIndicator(x, y, width, height, dt, cd)
    if dt < cd then
        love.graphics.setColor(.3, .3, .3)
        love.graphics.stencil(function() DrawUtils.drawBox(x, y, width, height) end)
        love.graphics.setStencilTest("greater", 0)
        love.graphics.arc("fill", "pie", x + width / 2, y + height / 2, height, 4.71, 10.99 - 6.28 * (dt / cd) )
        love.graphics.setStencilTest()
    end
end

return Gui
