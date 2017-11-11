local addonName, addonNamespace = ...

addonNamespace.Resurrect = {
    name = 'Resurrect',
    text = [[
        #showtooltip

        if api.player.isPaladin then
            if api.player.isHoly then
                /cast [mod] {{api.spell.Absolution}}; {{api.spell.Redemption}}
            else
                /cast {{api.spell.Redemption}}
            end
        elseif api.player.isPriest then
            if api.player.isShadow then
                /cast {{api.spell.Resurrection}}
            else
                /cast [mod] {{api.spell.MassResurrection}}; {{api.spell.Resurrection}}
            end
        end
    ]],
}