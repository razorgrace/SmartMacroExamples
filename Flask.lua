local addonName, addonNamespace = ...

addonNamespace.Flask = {
    name = 'Flask',
    init = function (api)
        local FlaskOfTenWhisperedPact = 127847
        local FlaskOfTenSeventhDemon = 127848
        local FlaskOfTenCountlessArmies = 127849
        local FlaskOfTenThousandScars = 127850
        local SpiritFlask = 127858

        local function getOptions()
            local options = {}

            -- if api.player.usesIntellect then
            table.insert(options, FlaskOfTenWhisperedPact)
            -- end

            -- if api.player.usesAgility then
            table.insert(options, FlaskOfTenSeventhDemon)
            -- end

            -- if api.player.usesStrength then
            table.insert(options, FlaskOfTenCountlessArmies)
            -- end

            -- if api.player.isTank then
            table.insert(options, FlaskOfTenThousandScars)
            -- end

            -- if GetItemCount(127858) > 0 then
            table.insert(options, SpiritFlask)
            -- end

            return options
        end

        local function getValue()
            local specializationId = (GetSpecializationInfo(GetSpecialization()))
            local storage = api.getPersistentLocalStorage()

            if type(storage.value) ~= 'table' then
                storage.value = {}
            end

            if not storage.value[specializationId] then
                storage.value[specializationId] = 0
            end

            return storage.value[specializationId]
        end

        local function setValue(value)
            local specializationId = (GetSpecializationInfo(GetSpecialization()))
            local storage = api.getPersistentLocalStorage()

            if type(storage.value) ~= 'table' then
                storage.value = {}
            end

            storage.value[specializationId] = value
        end

        local function getSelectedOption()
            local options = getOptions()
            local value = getValue()
            if value < 1 or value > #options then
                value = 1
            end
            if value > #options then
                value = #options
            end
            return options[value]
        end

        local function selectPreviousOption()
            local options = getOptions()
            local value = getValue() - 1
            if value < 1 then
                value = #options
            end
            setValue(value)
        end

        local function selectNextOption()
            local options = getOptions()
            local value = getValue() + 1
            if value > #options then
                value = 0
            end
            setValue(value)
        end

        return {
            updateHandlers = updateHandlers,
            getSelectedOption = getSelectedOption,

            OnDetachFrame = function (frame)
                frame:EnableMouseWheel(false)
                frame:SetScript("OnMouseWheel", nil)
            end,

            OnAttachFrame = function (frame)
                frame:EnableMouseWheel(true)
                frame:SetScript("OnMouseWheel", function(self, delta)
                    if delta < 0 then
                        selectNextOption()
                    else
                        selectPreviousOption()
                    end
                end)
            end,

            OnUpdateTooltip = function (frame, tooltip)
                tooltip:AddLine(' ')
                tooltip:AddLine('Available flasks')
                for i, option in ipairs(getOptions()) do
                    local name, _, _, _, _, _, _, _, _, texture, _ = GetItemInfo(option)

                    -- In case we're lagging, provide some decent defaults:
                    if not name then
                        name = 'Item #' .. option
                        texture = 134400 -- Question mark icon
                    end

                    -- Using texture escape sequence instead of AddTexture because:
                    -- 1. To avoid hitting 10 textures limitation
                    -- 2. To avoid resolving texture ID (returned by GetItemInfo) to filename (required by AddTexture)
                    if option == getSelectedOption() then
                        tooltip:AddDoubleLine("|T" .. texture .. ":0|t " .. name, '>>> ' .. GetItemCount(option), 0.5, 1.0, 0.5, 0.5, 1.0, 0.5)
                    else
                        tooltip:AddDoubleLine("|T" .. texture .. ":0|t " .. name, GetItemCount(option), 1.0, 1.0, 1.0, 1.0, 1.0, 1.0)
                    end
                end
            end,
        }
    end,
    text = [[
        #showtooltip

        /use item:{{getSelectedOption()}}
    ]],
}
