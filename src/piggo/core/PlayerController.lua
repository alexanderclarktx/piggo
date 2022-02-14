local PlayerController = {}
local ShapeUtils = require "src.piggo.util.ShapeUtils"

local update, draw, handleKeyPressed, handleMousePressed, bufferCommand

function PlayerController.new(player)
    assert(player)
    return {
        update = update, draw = draw,
        handleKeyPressed = handleKeyPressed, handleMousePressed = handleMousePressed,
        bufferCommand = bufferCommand,
        player = player,
        hovering = nil,
        bufferedCommands = {}
    }
end

function update(self, mouseX, mouseY, state)
end

function draw(self)
    -- draw pre-targeting hover outline
    if self.hovering then
        love.graphics.setColor(0.7, 0.2, 0.2)
        love.graphics.setLineWidth(4)
        if not self.hovering.body:isDestroyed() then
            love.graphics.circle("line", self.hovering.body:getX(), self.hovering.body:getY(), self.hovering.state.size + 2)
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
    command.frame = state.scene.game.state.frame

    log.debug("buffering command: ", command.action, command.frame)
    table.insert(self.bufferedCommands, command)
end

function handleKeyPressed(self, key, scancode, isrepeat, mouseX, mouseY, state)
    assert(mouseX, mouseY)

    if key == "q" then
        self.player.character.abilities.q:cast(
            self.player.character, mouseX, mouseY
        )
    end
    if key == "w" then
        self.player.character.abilities.w:cast(
            self.player.character, mouseX, mouseY
        )
    end
    if key == "e" then
        self.player.character.abilities.e:cast(
            self.player.character, mouseX, mouseY
        )
    end
    if key == "r" then
        self.player.character.abilities.r:cast(
            self.player.character, mouseX, mouseY
        )
    end
    if key == "s" then
        self:bufferCommand({action = "stop"}, state)
    end
end

function handleMousePressed(self, x, y, mouseButton, state)
    self.player.character.state.marker = {x = x, y = y}
    self:bufferCommand({
        action = "move",
        marker = self.player.character.state.marker
    }, state)
end

return PlayerController
