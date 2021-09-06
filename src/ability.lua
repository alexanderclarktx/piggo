local Ability = {}

function Ability.heal(me, hp)
    if me.hp + hp >= me.maxhp then
        me.hp = me.maxhp
    else
        me.hp = me.hp + hp
    end
end

return Ability
