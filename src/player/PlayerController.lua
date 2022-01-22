local PlayerController = {}
local ShapeUtils = require 'src.util.ShapeUtils'

local update, draw, handleKeyPressed

function PlayerController.new()
    assert(state, state.players[1])
    return {
        player = state.players[1],
        update = update, draw = draw, handleKeyPressed = handleKeyPressed,
        hovering = nil,
    }
end

function update(self, dt)
    local mouseX, mouseY = state.camera.mx, state.camera.my

    -- targeting
    -- for each npc, is the player clicking on it
    self.hovering = nil
    for _, npc in pairs(state.npcs) do
        -- TODO not just NPCs
        -- todo logic for targeting CLOSEST (shift+click)
        if ShapeUtils.pointInCircle(
                mouseX, mouseY,
                npc.body:getX(), npc.body:getY(), npc.meta.size + 16) then
            self.hovering = npc
            break
        end
    end

    -- player movement
    if love.mouse.isDown(2) or love.mouse.isDown(1) then
        state.players[1].character.meta.marker = {
            x = state.camera.mx,
            y = state.camera.my
        }
    end
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

function handleKeyPressed(self, key, scancode, isrepeat)
    if key == "space" then
        love.event.quit()
    end
    if key == "q" then
        state.players[1].character.abilities.q:cast(
            state.players[1].character
        )
    end
    if key == "w" then
        state.players[1].character.abilities.w:cast(
            state.players[1].character
        )
    end
    if key == "e" then
        state.players[1].character.abilities.e:cast(
            state.players[1].character
        )
    end
    if key == "r" then
        state.players[1].character.abilities.r:cast(
            state.players[1].character
        )
    end
    if key == "s" then
        state.players[1].character.meta.marker = nil
        state.players[1].character.body:setLinearVelocity(0, 0)
    end
end

return PlayerController
