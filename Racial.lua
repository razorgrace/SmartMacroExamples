local addonName, addonNamespace = ...

addonNamespace.Racial = {
    name = 'Racial',
    text = [[
        #showtooltip

        if api.player.isDraenei then
            /cast {{api.spell.GiftOfTheNaaru}}
        elseif api.player.isHuman then
            /cast {{api.spell.EveryManForHimself()}}
        end
    ]],
}