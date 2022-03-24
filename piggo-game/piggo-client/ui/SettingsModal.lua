local SettingsModal = {}

local update, draw

function SettingsModal.new()
    local settingsModal = {
        update = update, draw = draw
    }
    return settingsModal
end

function update(self)
    local windowWidth, _ = love.graphics.getDimensions()
end

function draw(self)
    love.graphics.setColor(0.1, 0, 0.3, 0.95)
    love.graphics.rectangle("fill", 200, 10, 1000, 1000)
end

return SettingsModal
