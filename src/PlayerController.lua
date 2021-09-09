local ShapeUtils = require 'src.ShapeUtils'

local PlayerController = {}

local update, draw, handleKeypressed

function PlayerController.new(player)
    return {
        player = player,
        hovering = nil,
        update = update,
        draw = draw,
        handleKeyPressed = handleKeyPressed
    }
end

function update(self, dt)
    -- targeting
    local mouseX = love.mouse.getX()
    local mouseY = love.mouse.getY()

    -- for each npc, is the player clicking on it
    self.hovering = nil
    for _, npc in pairs(gs.npcs) do
        -- TODO not just NPCs
        -- todo logic for targeting CLOSEST (shift+click)
        if ShapeUtils.pointInCircle(mouseX, mouseY, npc.pos.x, npc.pos.y, npc.size + 16) then
            self.hovering = npc
            break
        end
    end

    -- player movement
    if love.mouse.isDown(2) then
        gs.players[1].character.cmeta.marker = {x = mouseX, y = mouseY}
    end
end

function draw(self)
    -- draw pre-targeting hover outline
    if self.hovering then
        love.graphics.setColor(0.7, 0.2, 0.2)
        love.graphics.setLineWidth(4)
        love.graphics.circle("line", self.hovering.pos.x, self.hovering.pos.y, self.hovering.size + 2)
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
        gs.players[1].character:q({
            x = love.mouse.getX(),
            y = love.mouse.getY()
        })
    end
    if key == "w" then
        gs.players[1].character:w()
    end
    if key == "e" then
        gs.players[1].character:e()
    end
    if key == "r" then
        gs.players[1].character:r()
    end
end

return PlayerController
