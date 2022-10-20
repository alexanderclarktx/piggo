local CharacterRenderer = {}

local update, draw

function CharacterRenderer.new(root)
    local characterRenderer = {
        root = root,
        update = update, draw = draw,
        imageCache = {}
    }

    return characterRenderer
end

function draw(self)
    for _, entity in ipairs(self.root.entities) do
        if entity.sprite then
            if not self.imageCache[entity.sprite.path] then
               self.imageCache[entity.sprite.path] = love.graphics.newImage(entity.sprite.path) 
            end
            love.graphics.draw(
                self.imageCache[entity.sprite.path],
                entity.position.x, entity.position.y,
                0, 3, 3, 8, 7
            )
        end
    end
end

function update(self) end

return CharacterRenderer
