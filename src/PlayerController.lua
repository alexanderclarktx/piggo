local ShapeUtils = require 'src.ShapeUtils'

local PlayerController = {}

local update, draw, handleKeypressed

function PlayerController.new(state)
    assert(state, state.players[1])
    return {
        state = state, player = state.players[1],
        update = update, draw = draw, handleKeyPressed = handleKeyPressed,
        hovering = nil,
    }
end

function update(self, dt)
    local mouseX, mouseY = love.mouse.getX(), love.mouse.getY()

    -- targeting
    -- for each npc, is the player clicking on it
    self.hovering = nil
    for _, npc in pairs(self.state.npcs) do
        -- TODO not just NPCs
        -- todo logic for targeting CLOSEST (shift+click)
        if ShapeUtils.pointInCircle(
                mouseX, mouseY,
                npc.meta.pos.x, npc.meta.pos.y, npc.meta.size + 16) then
            self.hovering = npc
            break
        end
    end

    -- player movement
    if love.mouse.isDown(2) then
        self.state.players[1].character.meta.marker = {x = mouseX, y = mouseY}
    end
end

function draw(self)
    -- draw pre-targeting hover outline
    if self.hovering then
        love.graphics.setColor(0.7, 0.2, 0.2)
        love.graphics.setLineWidth(4)
        love.graphics.circle("line", self.hovering.meta.pos.x, self.hovering.meta.pos.y, self.hovering.meta.size + 2)
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
        self.state.players[1].character.abilities.q.run(
            self.state.players[1].character
        )
    end
    if key == "w" then
        self.state.players[1].character.abilities.w.run(
            self.state.players[1].character
        )
    end
    if key == "e" then
        self.state.players[1].character.abilities.e:run(
            self.state.players[1].character
        )
    end
    if key == "r" then
        self.state.players[1].character.abilities.r:run(
            self.state.players[1].character
        )
    end
end

return PlayerController
