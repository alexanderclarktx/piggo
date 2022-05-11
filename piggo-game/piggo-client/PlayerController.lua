local PlayerController = {}
local ShapeUtils = require "piggo-core.util.ShapeUtils"

local update, draw, handleKeyPressed, handleMousePressed, bufferCommand

function PlayerController.new(player)
    assert(player)
    return {
        state = {
            player = player,
        },
        update = update, draw = draw,
        handleKeyPressed = handleKeyPressed, handleMousePressed = handleMousePressed,
        bufferCommand = bufferCommand,
        hovering = nil,
        bufferedCommands = {}
    }
end

function update(self, mouseX, mouseY, state)
    -- is a character being hovered
    self.state.hovering = nil
    for _, character in pairs(state.scene.state.game.state.npcs) do
        if ShapeUtils.pointInCircle(
                mouseX, mouseY,
                character.state.body:getX(), character.state.body:getY(),
                character.state.size + 2) then
            self.state.hovering = character
            break
        end
    end

    -- cursor color
    if self.state.hovering then state.cursorColor = {1, 0, 0} else state.cursorColor = {1, 1, 1} end

    -- are we r-clicking
    if love.mouse.isDown(2) then
        if self.state.hovering then
            self.state.player.state.character.state.weapon:tryAttack(
                {
                    x = self.state.player.state.character.state.body:getX(),
                    y = self.state.player.state.character.state.body:getY()
                },
                self.state.hovering
            )
        else
            self.state.player.state.character.state.marker = {x = mouseX, y = mouseY}
            self:bufferCommand({
                action = "move",
                marker = self.state.player.state.character.state.marker
            }, state)
        end
    end

    -- local target = nil
    -- self.state.target = target
end

function draw(self)
    -- draw pre-targeting hover outline
    if self.state.hovering then
        love.graphics.setColor(0.7, 0.2, 0.2)
        love.graphics.setLineWidth(4)
        if not self.state.hovering.state.body:isDestroyed() then
            love.graphics.circle("line", self.state.hovering.state.body:getX(), self.state.hovering.state.body:getY(), self.state.hovering.state.size + 2)
        end
        love.graphics.setLineWidth(1)
    end

    -- draw targeting outline
    if self.targeting then
        -- TODO
    end
end

function bufferCommand(self, command, state)
    assert(command)

    -- append meta information
    command.frame = state.scene.state.game.state.frame

    log:debug("buffering command: ", command.action, command.frame)
    table.insert(self.bufferedCommands, command)
end

function handleKeyPressed(self, key, scancode, isrepeat, mouseX, mouseY, state)
    assert(mouseX, mouseY)

    if key == "q" then
        self:bufferCommand({action = "cast", ability = "q", mouseX = mouseX, mouseY = mouseY}, state)
    end
    if key == "w" then
        self:bufferCommand({action = "cast", ability = "w", mouseX = mouseX, mouseY = mouseY}, state)
    end
    if key == "e" then
        self:bufferCommand({action = "cast", ability = "e", mouseX = mouseX, mouseY = mouseY}, state)
    end
    if key == "r" then
        self:bufferCommand({action = "cast", ability = "r", mouseX = mouseX, mouseY = mouseY}, state)
    end
    if key == "s" then
        self:bufferCommand({action = "stop"}, state)
    end
end

function handleMousePressed(self, x, y, mouseButton, state)
    if mouseButton == 2 then -- rightclick
        self.state.player.state.character.state.marker = {x = x, y = y}
        self:bufferCommand({
            action = "move",
            marker = self.state.player.state.character.state.marker
        }, state)
    end
end

function handleMouseMoved(self, x, y, state) end

return PlayerController
