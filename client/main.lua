local npcPed = nil
local isNearNPC = false

local function setupNPC()
    RequestModel(Config.NPC.model)
    while not HasModelLoaded(Config.NPC.model) do
        Wait(100)
    end

    npcPed = CreatePed(4, Config.NPC.model, Config.NPC.coords.x, Config.NPC.coords.y, Config.NPC.coords.z - 1.0, Config.NPC.heading, false, true)
    FreezeEntityPosition(npcPed, Config.NPC.freeze)
    SetEntityInvincible(npcPed, Config.NPC.invincible)
    SetBlockingOfNonTemporaryEvents(npcPed, Config.NPC.blockevents)
    PlaceObjectOnGroundProperly(npcPed)
    TaskStartScenarioInPlace(npcPed, Config.NPC.scenario, 0, true)

    print("[nylo-sell-scrap] NPC Created at", Config.NPC.coords)
end

Citizen.CreateThread(function()
    Wait(1000)
    setupNPC()
end)

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - Config.NPC.coords)
        local currentNearNPC = false

        if distance < Config.InteractionDistance then
            currentNearNPC = true
            lib.showTextUI(Config.Locale.prompt)

            if IsControlJustPressed(0, Config.InteractionKey) then
                print("[nylo-sell-scrap] Sell key pressed near NPC")
                TriggerServerEvent('nylo-sell-scrap:server:sellScrap')
            end
        end

        if isNearNPC and not currentNearNPC then
            lib.hideTextUI()
        end

        isNearNPC = currentNearNPC

        if isNearNPC then
            Wait(0)
        else
            Wait(500)
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        if npcPed and DoesEntityExist(npcPed) then
            DeleteEntity(npcPed)
            print("[nylo-sell-scrap] NPC Cleaned up.")
        end
        if isNearNPC then
             lib.hideTextUI()
        end
    end
end) 