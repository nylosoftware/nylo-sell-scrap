Config = {}

Config.NPC = {
    coords = vector3(1413.24, -727.06, 67.8),
    heading = 270.0,
    model = `s_m_y_construct_01`,
    scenario = "WORLD_HUMAN_CLIPBOARD",
    invincible = true,
    freeze = true,
    blockevents = true
}

Config.SellableScrapItems = {
    "scrap_metal",
    "metalscrap",
    "scrapmetal"
}

Config.MinPayoutPerItem = 200
Config.MaxPayoutPerItem = 300

Config.InteractionDistance = 2.5
Config.InteractionKey = 38

Config.Locale = {
    prompt = 'Press [E] to sell scrap',
    selling = 'Selling scrap...',
    sold = 'Sold %d x %s for $%d',
    not_enough = 'You don\'t have the required materials.',
    error = 'An error occurred during selling.'
} 