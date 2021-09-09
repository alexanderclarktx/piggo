local mlib = require 'lib.mlib'

local PlayerController = {}

local handleKeypress

function PlayerController.new(player)
    local pc = {
        player = player,
        hovering = nil,
        update = function(self, dt)
            -- targeting
            local mouseX = love.mouse.getX()
            local mouseY = love.mouse.getY()

            -- for each npc, is the player clicking on it
            self:hover(nil)
            for _, npc in pairs(gs.npcs) do
                -- TODO not just NPCs
                -- todo logic for targeting CLOSEST (shift+click)
                if mlib.circle.checkPoint(mouseX, mouseY, npc.pos.x, npc.pos.y, npc.size + 16) then
                    self:hover(npc)
                    break
                end
            end

            -- player movement
            if love.mouse.isDown(2) then
                gs.players[1].character.cmeta.marker = {x = mouseX, y = mouseY}
            end
        end,
        draw = function(self, dt)
            -- draw hover outline
            if self.hovering then
                love.graphics.setColor(1, 0, 0)
                love.graphics.setLineWidth(4)
                love.graphics.circle("line", self.hovering.pos.x, self.hovering.pos.y, self.hovering.size + 2)
                love.graphics.setLineWidth(1)
            end
        end,
        hover = function(self, entity) -- mouse is hovered over this character
            self.hovering = entity
        end,
        keypressed = function(self, key, scancode, isrepeat) handleKeypress(key, scancode, isrepeat) end
    }

    return pc
end

function handleKeypress(key, scancode, isrepeat)

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
