local Weapon = {}

local update, tryAttack, spawnProjectile

-- cd is in frames
function Weapon.new(isRanged, range, cd)
    assert(type(isRanged) == "boolean")
    assert(range > 0 and cd > 0)
    local weapon = {
        state = {
            ranged = isRanged,
            range = range,
            cd = cd,
            dt = cd
            -- bonuses = {}
        },
        update = update,
        tryAttack = tryAttack,
        spawnProjectile = spawnProjectile
    }
    return weapon
end

function update(self)
    self.state.dt = self.state.dt + 1
end

function tryAttack(self, characterPos, target)
    -- assert(target)

    -- auto is on cooldown
    if self.state.dt < self.state.cd then
        return false
    else
        -- self:doAttack(target)
        log:info("AUTOING")
        self.state.dt = 0
        -- self:spawnProjectile(characterPos, target)
    end
end

function spawnProjectile(self, characterPos, target)
    return {
        state = {
            target = target,
            x = characterPos.x,
            y = characterPos.y,
        },
        update = function(self)

        end,
        draw = function(self)
            love.graphics.point(self.x, self.y)
        end
    }
end

return Weapon
