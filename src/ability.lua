local Ability = {}

function Ability.heal(me, hp)
    if me.cmeta.hp + hp >= me.cmeta.maxhp then
        me.cmeta.hp = me.cmeta.maxhp
    else
        me.cmeta.hp = me.cmeta.hp + hp
    end
end

function Ability.hurtbox(me, name, damage, poly)
    assert(damage ~= nil and damage > 0)
    table.insert(gs.hurtboxes, {
        name = name,
        damage = damage,
        poly = poly
    })
end

return Ability
