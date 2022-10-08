local Spell = {}

function Spell.new(spell)
    local spell = {
        type = "spell",
        spell = spell or "fart"
    }

    return spell
end

function Spell.cast(spell, root)
    print("casting ", spell)
end

return Spell
