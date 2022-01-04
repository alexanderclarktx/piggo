local IMenu = require 'src.ui.IMenu'

local AramMenu = {}

local addText

function AramMenu.new()
    local menu = IMenu.new()

    menu:addText("Piggo ARAM", 400, 50, 25)

    return menu
end

-- function load(self)
    
-- end

return AramMenu
