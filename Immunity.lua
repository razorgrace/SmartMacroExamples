local addonName, addonNamespace = ...

addonNamespace.Immunity = {
    name = 'Immunity',
    text = [[
        #showtooltip

        if api.player.isHunter then
            /cancelaura [mod] {{api.spell.AspectOfTheTurtle}}
            /stopmacro [mod]
            /cast {{api.spell.AspectOfTheTurtle}}
        elseif api.player.isPaladin then
            /cancelaura [mod] {{api.spell.DivineShield}}
            /stopmacro [mod]
            /cast {{api.spell.DivineShield}}
        end
    ]],
}