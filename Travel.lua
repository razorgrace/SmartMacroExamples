local addonName, addonNamespace = ...

addonNamespace.Travel = {
    name = 'Travel',
    global = true,
    text = [[
        #showtooltip
        /stopmacro [flying]

        if api.mount.GrandExpeditionYak.isUsable then
            /cast [mod] {{api.mount.GrandExpeditionYak}}
        elseif api.mount.TravelersTundraMammoth.isUsable then
            /cast [mod] {{api.mount.TravelersTundraMammoth}}
        end

        /run C_MountJournal.SummonByID(0)
        /run UIErrorsFrame:Clear()

        if api.player.isDruid then
            -- LoadAddOn("Blizzard_PetJournal")
            -- /click MountJournalSummonRandomFavoriteButton
            /use {{api.spell.TravelForm}}
        elseif api.player.isShaman then
            /use {{api.spell.GhostWolf}}
        end
    ]],
}