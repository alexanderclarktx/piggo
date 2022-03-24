local DrawUtils = {}

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

-- function DrawUtils.withColor(run, r, g, b, alpha)
--     love.graphics.setColor(r, g, b, alpha)
--     run()
--     love.graphics.
-- end

function DrawUtils.drawHealthbar(x, y, size, hp, maxhp)
    -- fill healthbar
    love.graphics.setColor(0.7, 0, 0)
    love.graphics.rectangle(
        "fill",
        x + const.healthbar.xoff,
        y + const.healthbar.yoff - size,
        hp / maxhp * const.healthbar.width,
        const.healthbar.height
    )

    -- print hp
    if debug then
        love.graphics.print(hp, x + const.healthnumber.xoff, y + const.healthnumber.yoff - size)
    end

    -- healthbar outline
    love.graphics.setColor(1, 0.3, 0.3)
    love.graphics.rectangle(
        "line",
        x + const.healthbar.xoff,
        y + const.healthbar.yoff - size,
        const.healthbar.width,
        const.healthbar.height
    )
end

function DrawUtils.drawBox(x, y, width, height)
    love.graphics.rectangle("line", x, y, width, height)
end

return DrawUtils
