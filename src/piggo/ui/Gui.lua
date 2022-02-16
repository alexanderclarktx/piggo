local Gui = {}
local DrawUtils = require "src.piggo.util.DrawUtils"

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
    if debug then drawDebug(self.player) end
    drawConsole(self.player)
end

function drawDebug(player)
    local debug = table.concat({
        "fps: %d",
        "hp: %s",
        "position: x=%d y=%d",
        "marker: x=%d y=%d",
        "velocity: x=%d y=%d",
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
        velocityX/100, velocityY/100,
        #player.state.character.state.effects
    ), 10, 10)
end

function drawConsole(player)
    local q = {x = love.graphics.getWidth() / 2 - 120, y = love.graphics.getHeight() * consoleHeight - boxHeight}
    local w = {x = love.graphics.getWidth() / 2 - 60, y = love.graphics.getHeight() * consoleHeight - boxHeight}
    local e = {x = love.graphics.getWidth() / 2, y = love.graphics.getHeight() * consoleHeight - boxHeight}
    local r = {x = love.graphics.getWidth() / 2 + 60, y = love.graphics.getHeight() * consoleHeight - boxHeight}

    -- ability background
    drawAbilityBackground(q.x, q.y)
    drawAbilityBackground(w.x, w.y)
    drawAbilityBackground(e.x, e.y)
    drawAbilityBackground(r.x, r.y)

    -- ability outlines
    drawAbilityOutline(q.x, q.y, player.state.character.state.abilities.q.frame, player.state.character.state.abilities.q.cd)
    drawAbilityOutline(w.x, w.y, player.state.character.state.abilities.w.frame, player.state.character.state.abilities.w.cd)
    drawAbilityOutline(e.x, e.y, player.state.character.state.abilities.e.frame, player.state.character.state.abilities.e.cd)
    drawAbilityOutline(r.x, r.y, player.state.character.state.abilities.r.frame, player.state.character.state.abilities.r.cd)

    -- cooldown indicators
    drawCooldownIndicator(q.x, q.y, boxWidth, boxHeight, player.state.character.state.abilities.q.frame, player.state.character.state.abilities.q.cd)
    drawCooldownIndicator(w.x, w.y, boxWidth, boxHeight, player.state.character.state.abilities.w.frame, player.state.character.state.abilities.w.cd)
    drawCooldownIndicator(e.x, e.y, boxWidth, boxHeight, player.state.character.state.abilities.e.frame, player.state.character.state.abilities.e.cd)
    drawCooldownIndicator(r.x, r.y, boxWidth, boxHeight, player.state.character.state.abilities.r.frame, player.state.character.state.abilities.r.cd)

    -- keybinds
    love.graphics.setColor(.9, .9, .2)
    love.graphics.print("q", q.x + 5, q.y + 30)
    love.graphics.print("w", w.x + 5, w.y + 30)
    love.graphics.print("e", e.x + 5, e.y + 30)
    love.graphics.print("r", r.x + 5, r.y + 30)

    -- charge abilities
    love.graphics.setColor(.2, .9, .9)
    drawCharges(player.state.character.state.abilities.q, q.x + 18, q.y + 30)
    drawCharges(player.state.character.state.abilities.w, w.x + 18, w.y + 30)
    drawCharges(player.state.character.state.abilities.e, e.x + 18, e.y + 30)
    drawCharges(player.state.character.state.abilities.r, r.x + 18, r.y + 30)
end

function drawCharges(ability, x, y)
    if ability.charges then
        love.graphics.print(
            chargeCounter:format(ability.charges, ability.maxCharges),
            x, y
        )
    end
end

function drawAbilityBackground(x, y)
    love.graphics.setColor(1, 1, 1, 0.5)
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
