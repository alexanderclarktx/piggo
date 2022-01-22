local IMenu = {}
local ShapeUtils = require "src.util.ShapeUtils"

local load, update, draw, handleKeyPressed
local addText, addTexture, addButton

function IMenu.new(fonts)
    assert(fonts)

    -- attach methods for generic buttons/text/inputs
    local menu = {
        load = load, update = update, draw = draw, handleKeyPressed = handleKeyPressed,
        addText = addText, addTexture = addTexture, addButton = addButton,
        texts = {}, textures = {}, buttons = {},
        fonts = fonts
    }

    return menu
end

-- adds text to be drawn in the menu
function addText(self, body, x, y, limit, font)
    assert(body and x and y and font)

    table.insert(self.texts, {
        body = body,
        x = x, y = y, limit = limit,
        font = font
    })
end

function addTexture() end

function addButton(self, body, x, y, width, height, font, callback)
    assert(body and x and y and width and height and font and callback)

    table.insert(self.buttons, {
        body = body, font = font,
        x = x, y = y, width = width, height = height,
        callback = callback
    })
end

function load(self) end

function update(self, dt)
    -- check if a button was pressed
    if love.mouse.isDown(1) then
        local mouseX, mouseY = love.mouse.getPosition()

        for _, button in ipairs(self.buttons) do
            local mouseIsHoveringButton = ShapeUtils.pointInPolygon(mouseX, mouseY,
                    button.x, button.y,
                    button.x, button.y + button.height,
                    button.x + button.width, button.y + button.height,
                    button.x + button.width, button.y
            )

            if mouseIsHoveringButton then
                -- callback
                button.callback()

                break
            end
        end
    end
end

function draw(self)
    local mouseX, mouseY = love.mouse.getPosition()

    -- draw all textures
    for _, texture in ipairs(self.textures) do
        -- debug(texture)

        -- love.graphics.drawLayer(
        --     image, frameToDraw,
        --     self.body:getX(), self.body:getY(),
        --     0, 4 * self.facingRight, 4, 6, 6
        -- )
    end

    -- draw all buttons
    for _, button in ipairs(self.buttons) do
        -- hovered buttons should be yellow
        local mouseIsHoveringButton = ShapeUtils.pointInPolygon(mouseX, mouseY,
                button.x, button.y,
                button.x, button.y + button.height,
                button.x + button.width, button.y + button.height,
                button.x + button.width, button.y
        )
        if mouseIsHoveringButton then
            love.graphics.setColor(1, 1, 0, 1)
        else
            love.graphics.setColor(1, 1, 1, 1)
        end

        -- button outline
        love.graphics.rectangle("line", button.x, button.y, button.width, button.height)

        -- button text
        love.graphics.setFont(self.fonts[button.font])
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(button.body,
                button.x, button.y + button.height/2 - self.fonts[button.font]:getHeight()/2, button.width, "center", 0)
    end

    -- draw all text
    for _, text in ipairs(self.texts) do
        love.graphics.setColor(1, 1, 1, 1) -- TODO color per text
        love.graphics.setFont(self.fonts[text.font])

        love.graphics.printf(text.body, text.x, text.y, text.limit, "center")
    end
end

function handleKeyPressed(self, key, scancode, isrepeat) end

return IMenu
