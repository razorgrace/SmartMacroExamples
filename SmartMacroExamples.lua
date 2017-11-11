local addonName, addonNamespace = ...

local frame = CreateFrame('FRAME', nil, UIParent)

frame:RegisterEvent('ADDON_LOADED')

frame:SetScript('OnEvent', function (self, event, arg1)
    if event == 'ADDON_LOADED' and arg1 == addonName then
        self:SetScript('OnEvent', nil)
        addonNamespace.EntryPoint(SmartMacro)
    end
end)