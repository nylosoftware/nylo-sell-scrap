RegisterNetEvent('nylo-sell-scrap:server:sellScrap', function()
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)

    if not Player or not Player.PlayerData or not Player.PlayerData.items then
        print(string.format("[nylo-sell-scrap] Error: Player object or inventory not found for source %s", src))
        pcall(function() exports.qbx_core:Notify(src, Config.Locale.error, 'error', 5000) end)
        return
    end

    local totalPayout = 0
    local itemsSoldSummary = {}
    local itemsToRemove = {}
    local hasSoldAnything = false

    for _, sellableItemName in ipairs(Config.SellableScrapItems) do
        local itemCount = 0
        for _, itemData in pairs(Player.PlayerData.items) do
            if itemData and itemData.name == sellableItemName then
                itemCount = itemData.amount
                break
            end
        end
        
        if itemCount > 0 then
            local payoutForItem = 0
            for i = 1, itemCount do
                payoutForItem = payoutForItem + math.random(Config.MinPayoutPerItem, Config.MaxPayoutPerItem)
            end
            totalPayout = totalPayout + payoutForItem
            
            table.insert(itemsToRemove, { name = sellableItemName, count = itemCount })
            table.insert(itemsSoldSummary, { name = sellableItemName, count = itemCount, payout = payoutForItem }) 
            hasSoldAnything = true
            print(string.format("[nylo-sell-scrap] Player %s (%s) has %d x %s to sell for potential $%d (random)", Player.PlayerData?.charinfo?.firstname or "Unknown", src, itemCount, sellableItemName, payoutForItem))
        end
    end

    if hasSoldAnything then
        local allItemsRemoved = true
        for _, itemInfo in ipairs(itemsToRemove) do
            local success = exports.qbx_core:RemoveItem(src, itemInfo.name, itemInfo.count)
            if not success then
                allItemsRemoved = false
                print(string.format("[nylo-sell-scrap] ERROR: Failed to remove %d x %s from player %s (%s)", itemInfo.count, itemInfo.name, Player.PlayerData?.charinfo?.firstname or "Unknown", src))
                exports.qbx_core:Notify(src, string.format(Config.Locale.error .. " (removing %s)", itemInfo.name), 'error', 5000)
                break 
            end
        end

        if allItemsRemoved then
            local moneyItemName = "money"
            local itemSuccess = exports.qbx_core:AddItem(src, moneyItemName, totalPayout) 

            if not itemSuccess then 
                print(string.format("[nylo-sell-scrap] ERROR: Failed to give %d x %s to player %s (%s)", totalPayout, moneyItemName, Player.PlayerData?.charinfo?.firstname or "Unknown", src))
                 exports.qbx_core:Notify(src, Config.Locale.error .. " (giving item)", 'error', 5000)
            else
                local summary = {}
                for _, soldItem in ipairs(itemsSoldSummary) do
                    table.insert(summary, string.format("%dx %s", soldItem.count, soldItem.name))
                end
                local notifyMsg = "Sold: " .. table.concat(summary, ", ") .. ". Received: " .. totalPayout .. "x " .. moneyItemName
                exports.qbx_core:Notify(src, notifyMsg, 'success', 7500)
            end
        else
             exports.qbx_core:Notify(src, Config.Locale.error .. " (item removal failed)", 'error', 5000)
        end

    else
        exports.qbx_core:Notify(src, Config.Locale.not_enough, 'error', 5000)
    end
end) 