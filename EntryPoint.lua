local addonName, addonNamespace = ...

addonNamespace.EntryPoint = function (SmartMacro)
    local AP = addonNamespace.AP
    local Dispel = addonNamespace.Dispel
    local Flask = addonNamespace.Flask
    local Immunity = addonNamespace.Immunity
    local Interrupt_Slow = addonNamespace.Interrupt_Slow
    local Racial = addonNamespace.Racial
    local Resurrect = addonNamespace.Resurrect
    local Sprint = addonNamespace.Sprint
    local Travel = addonNamespace.Travel

    SmartMacro.RegisterExternalItem(addonName .. '/AP', AP)
    SmartMacro.RegisterExternalItem(addonName .. '/Dispel', Dispel)
    SmartMacro.RegisterExternalItem(addonName .. '/Flask', Flask)
    SmartMacro.RegisterExternalItem(addonName .. '/Immunity', Immunity)
    SmartMacro.RegisterExternalItem(addonName .. '/Interrupt_Slow', Interrupt_Slow)
    SmartMacro.RegisterExternalItem(addonName .. '/Racial', Racial)
    SmartMacro.RegisterExternalItem(addonName .. '/Resurrect', Resurrect)
    SmartMacro.RegisterExternalItem(addonName .. '/Sprint', Sprint)
    SmartMacro.RegisterExternalItem(addonName .. '/Travel', Travel)
end