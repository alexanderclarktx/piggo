local Drawutils = {}

-- todo health bar scales with character size
function Drawutils.drawHealthbar(pos, hp, maxhp)
    love.graphics.setColor(1, 0 , 0)
    -- outer healthbar
    love.graphics.rectangle(
        "line",
        pos.x + const.healthbar.xoff,
        pos.y + const.healthbar.yoff,
        const.healthbar.width,
        const.healthbar.height
    )
    -- fill healthbar
    love.graphics.rectangle(
        "fill",
        pos.x + const.healthbar.xoff,
        pos.y + const.healthbar.yoff,
        hp / maxhp * const.healthbar.width,
        const.healthbar.height
    )
    love.graphics.print(hp, pos.x, pos.y - 40)
end

function Drawutils.drawBox(x, y, width, height)
    love.graphics.rectangle("line", x, y, width, height)
end

return Drawutils
