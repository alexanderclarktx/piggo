local IMenu = {}

local addText

function IMenu.new()

    -- attach methods for generic buttons/text/inputs
    local menu = {
        draw = draw, update = update,
        addText = addText, addTexture = addTexture, addButton = addButton,
        texts = {}, textures = {}, buttons = {}
    }

    return menu
end

function addTexture()

end

function addButton()

end

-- adds text to be drawn in the menu
function addText(self, body, x, y, fontSize)
    assert(body)
    assert(x)
    assert(y)
    assert(fontSize)

    table.insert(self.texts, {
        body = body,
        x = x, y = y,
        fontSize = fontSize
    })
end

function update(self, dt)
    -- TODO
end

function draw(self)
    -- draw all textures
    for _, each in ipairs(self.textures) do
        -- debug(each)

        -- love.graphics.drawLayer(
        --     image, frameToDraw,
        --     self.body:getX(), self.body:getY(),
        --     0, 4 * self.facingRight, 4, 6, 6
        -- )
    end

    -- draw all buttons
    for _, each in ipairs(self.buttons) do
        -- debug(each)

        -- love.graphics.rectangle()
    end

    -- draw all text
    for _, each in ipairs(self.texts) do
        local ogFont = love.graphics.getFont()

        love.graphics.setFont(love.graphics.newFont("Hussar.otf", each.fontSize))
        love.graphics.print(each.body, each.x, each.y, 0)

        love.graphics.setFont(ogFont)
    end
end

return IMenu
