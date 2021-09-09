local Drawutils = {}

local const = {
    healthbar = {
        width = 50,
        height = 10,
        xoff = -25,
        yoff = -20,
    },
    healthnumber = {
        yoff = -35,
        xoff = -25
    }
}

function Drawutils.drawHealthbar(pos, size, hp, maxhp)
    love.graphics.setColor(1, 0 , 0)
    -- outer healthbar
    love.graphics.rectangle(
        "line",
        pos.x + const.healthbar.xoff,
        pos.y + const.healthbar.yoff - size,
        const.healthbar.width,
        const.healthbar.height
    )
    -- fill healthbar
    love.graphics.rectangle(
        "fill",
        pos.x + const.healthbar.xoff,
        pos.y + const.healthbar.yoff - size,
        hp / maxhp * const.healthbar.width,
        const.healthbar.height
    )
    love.graphics.print(hp, pos.x + const.healthnumber.xoff, pos.y + const.healthnumber.yoff - size)
end

function Drawutils.drawBox(x, y, width, height)
    love.graphics.rectangle("line", x, y, width, height)
end

return Drawutils
