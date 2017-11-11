local addonName, addonNamespace = ...

addonNamespace.Dispel = {
    name = 'Dispel',
    text = [[
        #showtooltip
        -- /cast [mod,@player][@mouseover] {{GetSpellName()}}

        if api.player.isPriest then
            /cast [harm,mod,@target][harm,@mouseover] {{api.spell.DispelMagic}}
            if api.player.isShadow then
                /cast [mod,@player][@mouseover] {{api.spell.PurifyDisease}}
            else
                /cast [mod,@player][@mouseover] {{api.spell.Purify}}
            end
        elseif api.player.isPaladin then
            if api.player.isHoly then
                /cast [mod,@player][@mouseover] {{api.spell.Cleanse}}
            else
                /cast [mod,@player][@mouseover] {{api.spell.CleanseToxins}}
            end
        elseif api.player.isShaman then
            if api.spell.Purge.isKnown then
                /cast [harm,mod,@target][harm,@mouseover] {{api.spell.Purge}}
            end
            if api.player.isRestoration then
                /cast [mod,@player][@mouseover] {{api.spell.PurifySpirit}}
            else
                /cast [mod,@player][@mouseover] {{api.spell.CleanseSpirit}}
            end
        elseif api.player.isRestorationDruid then
            /cast [mod,@player][@mouseover] {{api.spell.NaturesCure}}
        end
    ]],
}