local particles = {
    "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_necro_souls_hero.vpcf",    
    "particles/econ/events/ti6/hero_levelup_ti6_godray.vpcf",
    "particles/units/heroes/hero_disruptor/disruptor_kineticfield.vpcf",
}

local sounds = {
    "soundevents/game_sounds_dungeon.vsndevts", 
    "soundevents/game_sounds_dungeon_enemies.vsndevts",
    "soundevents/game_sounds_winter_2018.vsndevts",
    "soundevents/game_sounds_creeps.vsndevts",
}


local precacheHeroes = {
   "spirit_breaker",
   "bounty_hunter",
   "huskar",
   "zuus",
   "crystalmaiden",
   "morphling",
   "warlock",
   "death_prophet",
   "pugna",
   "dark_seer",
   "tusk",
   "furion",
   "lycan",
   "dragon_knight",
   "medusa",
   "antimage",
   "alchemist",
   "doombringer",
   "disruptor",
   "templar_assassin",
   "clinkz",
   "phantom_assassin"

}


local function PrecacheEverythingFromTable( context, kvtable)
    for key, value in pairs(kvtable) do
        if type(value) == "table" then
            PrecacheEverythingFromTable( context, value )
        else
            if string.find(value, "vpcf") then
                PrecacheResource( "particle", value, context)
            end
            if string.find(value, "vmdl") then
                PrecacheResource( "model", value, context)
            end
            if string.find(value, "vsndevts") then
                PrecacheResource( "soundfile", value, context)
            end
        end
    end
end

function PrecacheEverythingFromKV( context )
    local kv_files = {
        "scripts/npc/npc_units_custom.txt",
        "scripts/npc/npc_abilities_custom.txt",
        "scripts/npc/npc_heroes_custom.txt",
        "scripts/npc/npc_abilities_override.txt",
        "scripts/npc/npc_items_custom.txt",
    }
    for _, kv in pairs(kv_files) do
        local kvs = LoadKeyValues(kv)
        if kvs then
            -- print("BEGIN TO PRECACHE RESOURCE FROM: ", kv)
            PrecacheEverythingFromTable( context, kvs)
        end
    end
end

return function(context)

    PrecacheEverythingFromKV(context)
    
    for _, p in pairs(particles) do
        PrecacheResource("particle", p, context)
    end
    for _, p in pairs(sounds) do
        PrecacheResource("soundfile", p, context)
    end

    for unit in pairs(LoadKeyValues("scripts/npc/npc_units_custom.txt")) do
        PrecacheUnitByNameSync(unit,context,0)
    end

    for _, p in pairs(precacheHeroes) do
        PrecacheUnitByNameSync("npc_dota_hero_"..p, context, -1)
    end

end