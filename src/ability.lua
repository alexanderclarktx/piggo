local Ability = {}

function Ability.heal(me, hp)
    if me.cmeta.hp + hp >= me.cmeta.maxhp then
        me.cmeta.hp = me.cmeta.maxhp
    else
        me.cmeta.hp = me.cmeta.hp + hp
    end
end

return Ability
