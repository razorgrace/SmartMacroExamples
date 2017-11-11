local addonName, addonNamespace = ...

addonNamespace.Sprint = {
    name = 'Sprint',
    trigger = '',
    text = [[
        #showtooltip

        if api.player.isPriest then
            if (api.player.isHoly or api.player.isDiscipline) and api.player.usesAngelicFeather then
                /cast [@player] {{api.spell.AngelicFeather}}
            elseif (api.player.isShadow or api.player.isDiscipline) and api.player.usesBodyAndSoul then
                /cast [@player] {{api.spell.PowerWordShield}}
            elseif api.player.isHoly and api.player.usesBodyAndMind then
                /cast [@player] {{api.spell.BodyAndMind}}
            end
        elseif api.player.isPaladin then
            /cast {{api.spell.DivineSteed}}
        elseif api.player.isShaman then
            /cast {{api.spell.GhostWolf}}
        elseif api.player.isDruid then
            /cast {{api.spell.Dash}}
        elseif api.player.isDeathKnight then
            /cast {{api.spell.WraithWalk}}
        elseif api.player.isHunter then
            /cast {{api.spell.AspectOfTheCheetah}}
        end
    ]],
}