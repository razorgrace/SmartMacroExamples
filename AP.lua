local addonName, addonNamespace = ...

addonNamespace.AP = {
    name = 'AP',
    global = true,
    init = function (api)
        local tooltipScanner = (function ()
            local id = 0

            local function findLine(tooltip, pattern)
                if tooltip:NumLines() == 0 then
                    return nil
                end

                for i = 1, tooltip:NumLines() do
                    local fontString = _G[tooltip:GetName() .. 'TextLeft' ..i]
                    if fontString then
                        local text = fontString:GetText()

                        if text == RETRIEVING_ITEM_INFO then
                            return nil
                        end

                        if (type(text) == 'string') then
                            if text:match(pattern) then
                                return text
                            end
                        end
                    end
                end

                return false
            end

            return function (pattern)
                id = id + 1

                local tooltip = CreateFrame("GameTooltip", addonName .. 'ScannerTooltip' .. id, UIParent, "GameTooltipTemplate")

                local cache = setmetatable({}, { __index = function (self, link)
                    tooltip:SetOwner(UIParent, "ANCHOR_NONE")
                    tooltip:SetHyperlink(link)
                    local text = findLine(tooltip, pattern)
                    tooltip:Hide()
                    self[link] = text
                    return text
                end })

                return function (link)
                    return cache[link]
                end
            end
        end)()

        local getTagLine = tooltipScanner('\|cFFE6CC80' .. ARTIFACT_POWER .. '\|r')

        local getAmount = (function ()
            local getUseLine = tooltipScanner( '^' .. USE_COLON) -- ITEM_SPELL_TRIGGER_ON_USE

            local function getArtifactPowerAmount(link)
                local itemString = link:match('\|H(item:%d+:.-)\|h')

                if not itemString then
                    return 0
                end

                local pieces = { strsplit(':', itemString) }

                if not pieces[15] then
                    return 0
                end

                -- Numbers might be a bit off due to several unrelated sources:
                local multipliers = {
                    [0] = 0.0 + 1.00,
                    [1] = 0.25 + 1.00,
                    [2] = 0.50 + 1.00,
                    [3] = 0.90 + 1.00,
                    [4] = 1.40 + 1.00,
                    [5] = 2.00 + 1.00,
                    [6] = 2.75 + 1.00,
                    [7] = 3.75 + 1.00,
                    [8] = 5.00 + 1.00,
                    [9] = 6.50 + 1.00,
                    [10] = 8.50 + 1.00,
                    [11] = 11.00 + 1.00,
                    [12] = 14.00 + 1.00,
                    [13] = 17.75 + 1.00,
                    [14] = 22.50 + 1.00,
                    [15] = 28.50 + 1.00,
                    [16] = 36.00 + 1.00,
                    [17] = 45.50 + 1.00,
                    [18] = 57.00 + 1.00,
                    [19] = 72.00 + 1.00,
                    [20] = 90.00 + 1.00,
                    [21] = 113.00 + 1.00,
                    [22] = 142.00 + 1.00,
                    [23] = 178.00 + 1.00,
                    [24] = 223.00 + 1.00,
                    [25] = 249.00 + 1.00,
                    [26] = 1001.00,
                    [27] = 1301.00,
                    [28] = 1701.00,
                    [29] = 2201.00,
                    [30] = 2901.00,
                    [31] = 3801.00,
                    [32] = 4901.00,
                    [33] = 6401.00,
                    [34] = 8301.00,
                    [35] = 10801.00,
                    [36] = 14001.00,
                    [37] = 18201.00,
                    [38] = 23701.00,
                    [39] = 30801.00,
                    [40] = 40001.00,
                    [41] = 160001.00,
                    [42] = 208001.00,
                    [43] = 270401.00,
                    [44] = 351501.00,
                    [45] = 457001.00,
                    [46] = 594001.00,
                    [47] = 772501.00,
                    [48] = 1004001.00,
                    [49] = 1305001.00,
                    [50] = 1696501.00,
                    [51] = 2205501.00,
                    [52] = 2867501.00,
                    [53] = 3727501.00,
                    [54] = 4846001.00,
                    [55] = 6300001.00,
                }

                local multiplier = multipliers[tonumber(pieces[15]) - 1]

                if not multiplier then
                    return 0
                end

                pieces[15] = 1

                local text = getUseLine(table.concat(pieces, ':'))

                if text == nil then
                    return nil
                end

                if text == false then
                    return 0
                end

                local baseAmount = tonumber((text:gsub('[^%d]', '')))

                if not baseAmount then
                    return 0
                end

                return math.floor(baseAmount * multiplier)
            end

            local cache = setmetatable({}, { __index = function (self, link)
                local amount = getArtifactPowerAmount(link)
                self[link] = amount
                return amount
            end })

            return function (link)
                return cache[link]
            end
        end)()

        local scanBags = (function ()
            local cache = nil

            local frame = CreateFrame('FRAME', nil, UIParent)
            frame:RegisterEvent('BAG_UPDATE')
            frame:SetScript('OnEvent', function ()
                cache = nil
            end)

            local function scanBagSlot(bagIndex, bagSlotIndex)
                local amount = 0
                local link = GetContainerItemLink(bagIndex, bagSlotIndex)

                if (type(link) == 'string') and link:match("item:%d+") then
                    local tagLine = getTagLine(link)

                    if tagLine == nil then
                        return nil
                    end

                    if tagLine then
                        amount = getAmount(link)

                        if not amount then
                            return nil
                        end
                    end
                end

                return {
                    link = link,
                    amount = amount,
                    bag = bagIndex,
                    slot = bagSlotIndex,
                }
            end

            function scanBag(bagIndex)
                local result = {}
                local partial = false

                for bagSlotIndex = 1, GetContainerNumSlots(bagIndex) do
                    local item = scanBagSlot(bagIndex, bagSlotIndex)

                    if not item then
                        partial = true
                    elseif item.amount > 0 then
                        table.insert(result, item)
                    end
                end

                return result, partial
            end

            local function scanAllBags()
                local total = 0
                local list = {}
                local partial = false

                for bagIndex = 0, NUM_BAG_SLOTS do
                    local bagList, partialBag = scanBag(bagIndex)

                    for _, item in ipairs(bagList) do
                        table.insert(list, item)
                        total = total + item.amount
                    end

                    if partialBag then
                        partial = true
                    end
                end

                return total, list, partial
            end

            SBS = scanBagSlot
            SB = scanBag
            SAB = scanAllBags

            return function ()
                if not cache then
                    local total, list, partial = scanAllBags()

                    if partial then
                        return total, list, partial
                    end

                    cache = { total, list, partial }
                end

                return unpack(cache)
            end
        end)()

        return {
            scanBags = scanBags,

            OnUpdateTooltip = function (frame, tooltip)
                local total, list = scanBags()

                if #list > 0 then
                    tooltip:AddLine(' ')
                    tooltip:AddLine('Artifact power tokens in your bags:')
                    tooltip:AddLine(' ')

                    local maxItems = 10
                    local displayedItems = (#list <= maxItems) and #list or (maxItems - 1)
                    local subtotal = 0
                    for i = 1, displayedItems do
                        local item = list[i]
                        local name, _, quality, _, _, _, _, _, _, texture, _ = GetItemInfo(item.link)

                        --  -- In case we're lagging, provide some decent defaults:
                        if not name then
                            name = item.link
                            quality = 1
                            texture = 134400 -- Question mark icon
                        end

                        local r, g, b = GetItemQualityColor(quality)

                        -- Using texture escape sequence instead of AddTexture because:
                        -- 1. To avoid hitting 10 textures limitation
                        -- 2. To avoid resolving texture ID (returned by GetItemInfo) to filename (required by AddTexture)
                        tooltip:AddDoubleLine("|T" .. texture .. ":0|t " .. name, BreakUpLargeNumbers(item.amount, true), r, g, b)
                        subtotal = subtotal + item.amount
                    end

                    if #list > displayedItems then
                        local name = '...and ' .. (#list - displayedItems) .. ' more'
                        tooltip:AddDoubleLine(name, BreakUpLargeNumbers(total - subtotal, true))
                    end

                    tooltip:AddLine(' ')
                    tooltip:AddDoubleLine('Total', BreakUpLargeNumbers(total, true))
                else
                    tooltip:ClearLines()
                    tooltip:AddLine('|T130775:0|t Can\'t find any artifact\npower tokens in your bags.')
                end
            end,
        }
    end,
    text = [[
        #showtooltip

        local total, list = scanBags()

        if list[1] then
            /use {{list[1].bag}} {{list[1].slot}}
            api.setIcon('INV_MISC_QUESTIONMARK')
        else
            api.setIcon(130775)
            for _, frame in ipairs(api.getFrames()) do
                _G[frame:GetName() .. 'Name']:Hide()
            end
        end
    ]],
}
