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
end

return Drawutils
