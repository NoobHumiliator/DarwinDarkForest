local particles = {
    "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_necro_souls_hero.vpcf",    
    "particles/econ/events/ti6/hero_levelup_ti6_godray.vpcf",
    "particles/units/heroes/hero_disruptor/disruptor_kineticfield.vpcf",
    "particles/items2_fx/veil_of_discord.vpcf",
    "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_omni.vpcf",
    "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_halo_buff.vpcf",
    "particles/items2_fx/rod_of_atos.vpcf",
    "particles/items4_fx/combo_breaker_buff.vpcf",
    "particles/units/heroes/hero_centaur/centaur_return.vpcf",
    'particles/units/heroes/hero_spirit_breaker/spirit_breaker_haste_owner.vpcf',
    'particles/units/heroes/hero_huskar/huskar_berserker_blood_hero_effect.vpcf',
    'particles/units/heroes/hero_huskar/huskar_berserkers_blood_glow.vpcf',
    'particles/units/heroes/hero_meepo/meepo_geostrike_ambient.vpcf',
    'particles/units/heroes/hero_luna/luna_ambient_lunar_blessing.vpcf',

}

local sounds = {
    "soundevents/game_sounds.vsndevts",
    "soundevents/game_sounds_ambient.vsndevts",
    "soundevents/game_sounds_items.vsndevts",
    "soundevents/soundevents_dota.vsndevts",
    "soundevents/game_sounds_dungeon.vsndevts",
    "soundevents/game_sounds_dungeon_enemies.vsndevts",
    "soundevents/game_sounds_winter_2018.vsndevts",
    "soundevents/game_sounds_creeps.vsndevts",
    "soundevents/game_sounds_ui.vsndevts",
    --KV里面没用过的音效，写在这里
    "soundevents/game_sounds_heroes/game_sounds_centaur.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_bounty_hunter.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_huskar.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_crystalmaiden.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_warlock.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_death_prophet.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_pugna.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_tusk.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_furion.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_lycan.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_medusa.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_antimage.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_alchemist.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_doombringer.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_disruptor.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_templar_assassin.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_clinkz.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_phantom_assassin.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_magnataur.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_mars.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_ember_spirit.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_bristleback.vsndevts",
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
        "scripts/npc/npc_abilities_custom.txt",
        "scripts/npc/npc_units_custom.txt",
        "scripts/npc/npc_heroes_custom.txt",
        "scripts/npc/npc_items_custom.txt",
    }
    for _, kv in pairs(kv_files) do
        local kvs = LoadKeyValues(kv)
        if kvs then
            --print("BEGIN TO PRECACHE RESOURCE FROM: ", kv)
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

end

