local PlayerController = {}
local ShapeUtils = require "src.piggo.util.ShapeUtils"

local update, draw, handleKeyPressed, bufferCommand

function PlayerController.new(player)
    assert(player)
    return {
        update = update, draw = draw, handleKeyPressed = handleKeyPressed,
        bufferCommand = bufferCommand,
        player = player,
        hovering = nil,
        bufferedCommands = {}
    }
end

function update(self, dt, mouseX, mouseY, state)
    -- assert(mouseX and mouseY and state)
    -- -- for each npc, is the player clicking on it
    -- self.hovering = nil
    -- for _, npc in pairs(state.npcs) do
    --     -- TODO not just NPCs
    --     -- TODO logic for targeting CLOSEST (shift+click)
    --     if ShapeUtils.pointInCircle(
    --             mouseX, mouseY,
    --             npc.body:getX(), npc.body:getY(), npc.meta.size + 16) then
    --         self.hovering = npc
    --         break
    --     end
    -- end

    -- -- player movement
    -- if love.mouse.isDown(2) or love.mouse.isDown(1) then
    --     self.player.character.meta.marker = {
    --         x = mouseX,
    --         y = mouseY
    --     }
    -- end
end

function draw(self)
    -- draw pre-targeting hover outline
    if self.hovering then
        love.graphics.setColor(0.7, 0.2, 0.2)
        love.graphics.setLineWidth(4)
        if not self.hovering.body:isDestroyed() then
            love.graphics.circle("line", self.hovering.body:getX(), self.hovering.body:getY(), self.hovering.meta.size + 2)
        end
        love.graphics.setLineWidth(1)
    end

    -- draw targeting outline
    if self.targeting then
        -- TODO
    end
end

function bufferCommand(self, command)
    assert(command)
    debug("buffering command: ", command.action)
    table.insert(self.bufferedCommands, command)
end

function handleKeyPressed(self, key, scancode, isrepeat, mouseX, mouseY)
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
    if key == "s" then -- stop
        self:bufferCommand({action = "stop"})
    end
end

return PlayerController
