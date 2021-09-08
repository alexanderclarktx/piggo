local drawutils = require 'src.drawutils'

local Gui = {}

local dim = {
    boxWidth = 50,
    boxHeight = 50,
}

local function drawDebug(player)
    local debug = table.concat({
        "fps: %d",
        "hp: %s",
        "position x: %d y: %d",
        "effects: %d"
    }, "\n")

    love.graphics.setColor(1, 1, 0, 0.7)
    love.graphics.print(debug:format(
        love.timer.getFPS(),
        player.character.cmeta.hp,
        player.character.cmeta.pos.x,
        player.character.cmeta.pos.y,
        #player.character.effects
    ), 10, 10)
end

local function drawAbilityOutline(x, y, dt, cd)
    if dt < cd then
        love.graphics.setColor(.8, .8, .2)
    else
        love.graphics.setColor(1, 1, 1)
    end
    drawutils.drawBox(x, y, dim.boxWidth, dim.boxHeight)
end

local function drawCooldownIndicator(x, y, width, height, dt, cd)
    if dt < cd then
        love.graphics.setColor(.3, .3, .3)
        love.graphics.stencil(function() drawutils.drawBox(x, y, width, height) end)
        love.graphics.setStencilTest("greater", 0)
        love.graphics.arc("fill", "pie", x + width / 2, y + height / 2, height, 4.71, 10.99 - 6.28 * (dt / cd) )
        love.graphics.setStencilTest()
    end
end

local function drawConsole(player)
    local q = {x = love.graphics.getWidth() / 2 - 100, y = love.graphics.getHeight() * 0.9}
    local w = {x = love.graphics.getWidth() / 2 - 45, y = love.graphics.getHeight() * 0.9}
    local e = {x = love.graphics.getWidth() / 2 + 10, y = love.graphics.getHeight() * 0.9}
    local r = {x = love.graphics.getWidth() / 2 + 65, y = love.graphics.getHeight() * 0.9}

    -- ability outlines
    drawAbilityOutline(q.x, q.y, player.character.abilities.q.dt, player.character.abilities.q.cd)
    drawAbilityOutline(w.x, w.y, player.character.abilities.w.dt, player.character.abilities.w.cd)
    drawAbilityOutline(e.x, e.y, player.character.abilities.e.dt, player.character.abilities.e.cd)
    drawAbilityOutline(r.x, r.y, player.character.abilities.r.dt, player.character.abilities.r.cd)

    -- cooldown indicators
    drawCooldownIndicator(q.x, q.y, dim.boxWidth, dim.boxHeight, player.character.abilities.q.dt, player.character.abilities.q.cd)
    drawCooldownIndicator(w.x, w.y, dim.boxWidth, dim.boxHeight, player.character.abilities.w.dt, player.character.abilities.w.cd)
    drawCooldownIndicator(e.x, e.y, dim.boxWidth, dim.boxHeight, player.character.abilities.e.dt, player.character.abilities.e.cd)
    drawCooldownIndicator(r.x, r.y, dim.boxWidth, dim.boxHeight, player.character.abilities.r.dt, player.character.abilities.r.cd)

    -- keybinds
    love.graphics.setColor(.7, .7, .2)
    love.graphics.print("q", q.x + 5, q.y + 30)
    love.graphics.print("w", w.x + 5, w.y + 30)
    love.graphics.print("e", e.x + 5, e.y + 30)
    love.graphics.print("r", r.x + 5, r.y + 30)
end

function Gui.new(player)
    local gui = {
        player = player,
        draw = function(self)
            drawDebug(self.player)
            drawConsole(self.player)
        end,
    }
    return gui
end

return Gui
