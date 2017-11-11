local addonName, addonNamespace = ...

addonNamespace.Interrupt_Slow = {
    name = 'Interrupt/Slow',
    text = [[
        #showtooltip

        /stopcasting

        if api.player.isHunter then
            /cast [mod] {{api.spell.ConcussiveShot}}; {{api.spell.CounterShot}}
        elseif api.player.isPaladin then
            if api.player.isRetribution then
                /cast [mod] {{api.spell.HandOfHindrance}}; {{api.spell.Rebuke}}
            else
                /cast {{api.spell.Rebuke}}
            end
        elseif api.player.isShaman then
            if api.player.isElemental then
                /cast [mod] {{api.spell.FrostShock}}; {{api.spell.WindShear}}
            else
                /cast {{api.spell.WindShear}}
            end
        end
    ]],
}
