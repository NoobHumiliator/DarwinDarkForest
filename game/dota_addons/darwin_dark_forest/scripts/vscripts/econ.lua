if Econ == nil then Econ = class({}) end

Econ.vParticleMap ={

    green={"particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_3.vpcf"},
    lava_trail={"particles/econ/courier/courier_trail_lava/courier_trail_lava.vpcf"},
    paltinum_baby_roshan={"particles/econ/paltinum_baby_roshan/paltinum_baby_roshan.vpcf"},
    legion_wings={"particles/econ/legion_wings/legion_wings.vpcf"},
    legion_wings_vip={"particles/econ/legion_wings/legion_wings_vip.vpcf"},
    legion_wings_pink={"particles/econ/legion_wings/legion_wings_pink.vpcf"},
    darkmoon={"particles/econ/courier/courier_roshan_darkmoon/courier_roshan_darkmoon.vpcf"},
    ethereal_flame_white={"particles/econ/ethereal_flame.vpcf"},
    ethereal_flame_golden={"particles/econ/ethereal_flame.vpcf"},
    ethereal_flame_pink={"particles/econ/ethereal_flame.vpcf"},
    sakura_trail={"particles/econ/courier/courier_axolotl_ambient/courier_axolotl_ambient.vpcf","particles/econ/sakura_trail.vpcf"},
    golden_ti7={"particles/econ/golden_ti7.vpcf"},
    rich={"particles/econ/rich.vpcf"},
}


Econ.vKillEffectMap ={
    sf_wings="particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_wings.vpcf",
    huaji="particles/econ/kill_mark/huaji.vpcf",
    jibururen_mark="particles/econ/kill_mark/jibururen_mark.vpcf",
    question_mark="particles/econ/kill_mark/question_mark.vpcf",
}


Econ.vKillSoundMap ={
    bai_tuo_shei_qu="soundboard.bai_tuo_shei_qu",
    duiyou_ne="soundboard.duiyou_ne",
    ni_qi_bu_qi="soundboard.ni_qi_bu_qi",
    liu_liu_liu="soundboard.liu_liu_liu",
    ta_daaaa="soundboard.ta_daaaa",
    zou_hao_bu_song="soundboard.zou_hao_bu_song",
    zai_jian_le_bao_bei="soundboard.zai_jian_le_bao_bei",
    gan_ma_ne_xiong_di="soundboard.gan_ma_ne_xiong_di",
    lian_dou_xiu_wai_la="soundboard.lian_dou_xiu_wai_la"
}


Econ.vSkinModelMap ={
    gold_crawl_zombie="models/items/undying/idol_of_ruination/ruin_wight_minion_torso_gold.vmdl",
    gold_zombie="models/items/undying/idol_of_ruination/ruin_wight_minion_gold.vmdl",
}


Econ.vSkinUnitMap ={
    gold_crawl_zombie="npc_dota_creature_crawl_zombie",
    gold_zombie="npc_dota_creature_basic_zombie",
}


Econ.vImmortalUnitMap ={
    shearing_deposition={"npc_dota_creature_lich","npc_dota_creature_lich_rime_lord","npc_dota_creature_lich_serakund_tyrant"},
    glare_of_the_tyrant={"npc_dota_creature_lich","npc_dota_creature_lich_rime_lord","npc_dota_creature_lich_serakund_tyrant"},
    

    dragonclaw_hook={"npc_dota_creature_pudge","npc_dota_creature_pudge_plague_champion","npc_dota_creature_pudge_surgical_precision"},
    feast_of_abscession={"npc_dota_creature_pudge","npc_dota_creature_pudge_plague_champion","npc_dota_creature_pudge_surgical_precision"},
    golden_rippers_reel={"npc_dota_creature_pudge","npc_dota_creature_pudge_plague_champion","npc_dota_creature_pudge_surgical_precision"},
    golden_scavenging_guttleslug={"npc_dota_creature_pudge","npc_dota_creature_pudge_plague_champion","npc_dota_creature_pudge_surgical_precision"},

    cult_of_aktok={"npc_dota_creature_venomancer","npc_dota_creature_venomancer_deathbringer","npc_dota_creature_venomancer_stalker","npc_dota_creature_venomancer_ferocious_toxicant"},
    
    bracers_of_aeons_of_the_crimson_witness={"npc_dota_creature_faceless_void","npc_dota_creature_faceless_void_endless_plane","npc_dota_creature_faceless_void_nezzureem"},
    jewel_of_aeons={"npc_dota_creature_faceless_void","npc_dota_creature_faceless_void_endless_plane","npc_dota_creature_faceless_void_nezzureem"},
    mace_of_aeons={"npc_dota_creature_faceless_void","npc_dota_creature_faceless_void_endless_plane","npc_dota_creature_faceless_void_nezzureem"},
    timebreaker={"npc_dota_creature_faceless_void","npc_dota_creature_faceless_void_endless_plane","npc_dota_creature_faceless_void_nezzureem"},

        
    soul_diffuser={"npc_dota_creature_spectre","npc_dota_creature_spectre_enduring_solitude","npc_dota_creature_spectre_conservator"},
    transversant_soul={"npc_dota_creature_spectre","npc_dota_creature_spectre_enduring_solitude","npc_dota_creature_spectre_conservator"},
    transversant_soul_of_the_crimson_witness={"npc_dota_creature_spectre","npc_dota_creature_spectre_enduring_solitude","npc_dota_creature_spectre_conservator"},

    shatterblast_core={"npc_dota_creature_ancient_apparition","npc_dota_creature_old_element"},
    shatterblast_crown={"npc_dota_creature_ancient_apparition","npc_dota_creature_old_element"},
    
    world_chasm_artifact={"npc_dota_creature_enigma","npc_dota_creature_primal_void","npc_dota_creature_void_overlord"},
    lycosidae_brood={"npc_dota_creature_broodmother","npc_dota_creature_broodmother_glutton_larder","npc_dota_creature_spider_queen"},

    
    severing_lash={"npc_dota_creature_razor","npc_dota_creature_razor_lightning_lord","npc_dota_creature_razor_affront_of_the_overseer"},
    golden_severing_crest={"npc_dota_creature_razor","npc_dota_creature_razor_lightning_lord","npc_dota_creature_razor_affront_of_the_overseer"},
    

    crimson_edict_of_shadows={"npc_dota_creature_riki","npc_dota_creature_dream_secret","npc_dota_creature_nightmare_hunter"},
    golden_edict_of_shadows={"npc_dota_creature_riki","npc_dota_creature_dream_secret","npc_dota_creature_nightmare_hunter"},
    shadow_masquerade={"npc_dota_creature_riki","npc_dota_creature_dream_secret","npc_dota_creature_nightmare_hunter"},
    golden_shadow_masquerade={"npc_dota_creature_riki","npc_dota_creature_dream_secret","npc_dota_creature_nightmare_hunter"},

    golden_infernal_chieftain={"npc_dota_creature_centaur_khan","npc_dota_creature_centaur_warchief"},
    infernal_chieftain_of_the_crimson_witness={"npc_dota_creature_centaur_khan","npc_dota_creature_centaur_warchief"},
    infernal_menace={"npc_dota_creature_centaur_khan","npc_dota_creature_centaur_warchief"},

    golden_dread_requisition={"npc_dota_creature_life_stealer","npc_dota_creature_life_stealer_bond_of_madness","npc_dota_creature_life_stealer_chainbreaker"},
    golden_profane_union={"npc_dota_creature_life_stealer","npc_dota_creature_life_stealer_bond_of_madness","npc_dota_creature_life_stealer_chainbreaker"},
    profane_union={"npc_dota_creature_life_stealer","npc_dota_creature_life_stealer_bond_of_madness","npc_dota_creature_life_stealer_chainbreaker"},

    iron_surge={"npc_dota_creature_spirit_breaker","npc_dota_creature_spirit_breaker_ironbarde_charger","npc_dota_creature_spirit_breaker_elemental_realms"},
    savage_mettle={"npc_dota_creature_spirit_breaker","npc_dota_creature_spirit_breaker_ironbarde_charger","npc_dota_creature_spirit_breaker_elemental_realms"},
}




function Econ:Init()

    CustomGameEventManager:RegisterListener("ChangeEquip",function(_, keys)
        self:ChangeEquip(keys)
    end)
    
    CustomGameEventManager:RegisterListener("DrawLottery",function(_, keys)
        self:DrawLottery(keys)
    end)

    CustomGameEventManager:RegisterListener("EconDataRefresh",function(_, keys)
        self:EconDataRefresh(keys)
    end)

end

function Econ:DrawLottery(keys)

    local nPlayerID = keys.playerId

    Server:DrawLottery(nPlayerID)


end

function Econ:EconDataRefresh(keys)
    
    local nPlayerID = keys.playerId
    local nPlayerSteamId = PlayerResource:GetSteamAccountID(nPlayerID)

    local econ_data = CustomNetTables:GetTableValue("econ_data", "econ_data")
    
    econ_data["econ_info"][tostring(nPlayerSteamId)]=keys
    econ_data["dna"][tostring(nPlayerSteamId)]=keys.dnaValue
    
    CustomNetTables:SetTableValue("econ_data", "econ_data",econ_data)

end




function Econ:ChangeEquip(keys)

    local nPlayerID = keys.playerId
    local hHero = PlayerResource:GetPlayer(nPlayerID):GetAssignedHero()
    
    -- 如果是特效
    if keys.type=="Particle" then

        local vCurrentEconParticleIndexs=hHero.vCurrentEconParticleIndexs
        
        if vCurrentEconParticleIndexs then
            for _,nParticleIndex in pairs(vCurrentEconParticleIndexs) do
                ParticleManager:DestroyParticle(nParticleIndex, true)
                ParticleManager:ReleaseParticleIndex(nParticleIndex)
            end
        end

        hHero.vCurrentEconParticleIndexs=nil
        hHero.sCurrentParticleEconItemName=nil

        if keys.isEquip==1 then           
            self:EquipParticleEcon(keys.itemName,nPlayerID)
        end

    end
    
    --如果是击杀特效
    if keys.type=="KillEffect" then
        hHero.sCurrentKillEffect = nil
        if keys.isEquip==1 then
           Econ:EquipKillEffectEcon(keys.itemName,nPlayerID)
        end
    end

    --如果是击杀音效
    if keys.type=="KillSound" then
        hHero.sCurrentKillSound = nil
        if keys.isEquip==1 then
           Econ:EquipKillSoundEcon(keys.itemName,nPlayerID)
        end
    end

     --如果是皮肤
    if keys.type=="Skin" then

      if hHero.vSkinInfo==nil then
           hHero.vSkinInfo={}
      end

      hHero.vSkinInfo[self.vSkinUnitMap[keys.itemName]]=nil
      if keys.isEquip==1 then
           Econ:EquipSkinEcon(keys.itemName,nPlayerID)
      end

    end
    
    --如果是皮肤
    if keys.type=="Immortal" then
          Econ:EquipImmortalEcon(keys.itemName,nPlayerID,keys.isEquip)
    end
    
    Server:UpdatePlayerEquip(nPlayerID,keys.itemName,keys.type,keys.isEquip)


end


function Econ:EquipParticleEcon(sItemName,nPlayerID)

    local hHero = PlayerResource:GetPlayer(nPlayerID):GetAssignedHero()
    
    local vCurrentEconParticleIndexs={}

    for _,sParticle in pairs(self.vParticleMap[sItemName]) do
        if hHero.hCurrentCreep and hHero.hCurrentCreep:IsAlive() then

            local nParticleAttach = Econ:ChooseParticleAttach(sItemName)
            print("nParticleAttach"..nParticleAttach)
            local nParticleIndex = ParticleManager:CreateParticle(sParticle,nParticleAttach,hHero.hCurrentCreep)
            ParticleManager:SetParticleControlEnt(nParticleIndex,0,hHero.hCurrentCreep,nParticleAttach,"follow_origin",hHero.hCurrentCreep:GetAbsOrigin(),true)
            
            Econ:SetControllPoints(nParticleIndex,sItemName)
            table.insert(vCurrentEconParticleIndexs,nParticleIndex)
        end
    end
    
    hHero.sCurrentParticleEconItemName=sItemName
    hHero.vCurrentEconParticleIndexs=vCurrentEconParticleIndexs
end

--根据类型微调附着点
function Econ:ChooseParticleAttach(sItemName)
    if  sItemName == "rich" then
        return PATTACH_OVERHEAD_FOLLOW
    end
    return PATTACH_ABSORIGIN_FOLLOW
end


--根据类型微调控制点
function Econ:SetControllPoints(nParticleIndex,sItemName)
    if  sItemName == "ethereal_flame_white" then
        ParticleManager:SetParticleControl(nParticleIndex, 15, Vector(200, 200, 200))
        ParticleManager:SetParticleControl(nParticleIndex, 2, Vector(255, 255, 255))
        ParticleManager:SetParticleControl(nParticleIndex, 16, Vector(1, 0, 0))
    end
    if  sItemName == "ethereal_flame_golden" then
        ParticleManager:SetParticleControl(nParticleIndex, 15, Vector(217, 191, 89))
        ParticleManager:SetParticleControl(nParticleIndex, 2, Vector(255, 255, 255))
        ParticleManager:SetParticleControl(nParticleIndex, 16, Vector(1, 0, 0))
    end
    if  sItemName == "ethereal_flame_pink" then
        ParticleManager:SetParticleControl(nParticleIndex, 15, Vector(210, 0, 210))
        ParticleManager:SetParticleControl(nParticleIndex, 2, Vector(255, 255, 255))
        ParticleManager:SetParticleControl(nParticleIndex, 16, Vector(1, 0, 0))
    end
end



function Econ:EquipKillEffectEcon(sItemName,nPlayerID)
    local hHero = PlayerResource:GetPlayer(nPlayerID):GetAssignedHero()
    hHero.sCurrentKillEffect=self.vKillEffectMap[sItemName]
end

function Econ:PlayKillEffect(sParticle,hHero)

    if hHero.hCurrentCreep and hHero.hCurrentCreep:IsAlive() then
        local nParticleIndex = ParticleManager:CreateParticle(sParticle,PATTACH_ABSORIGIN_FOLLOW,hHero.hCurrentCreep)
        ParticleManager:SetParticleControlEnt(nParticleIndex,0,hHero.hCurrentCreep,PATTACH_ABSORIGIN_FOLLOW,"follow_origin",hHero.hCurrentCreep:GetAbsOrigin(),true)
        ParticleManager:ReleaseParticleIndex(nParticleIndex)
    end
    
end


function Econ:EquipKillSoundEcon(sItemName,nPlayerID)
    local hHero = PlayerResource:GetPlayer(nPlayerID):GetAssignedHero()
    hHero.sCurrentKillSound=self.vKillSoundMap[sItemName]
end


function Econ:PlayKillSound(sSound,hHero)
    if hHero.hCurrentCreep and hHero.hCurrentCreep:IsAlive() then
        EmitSoundOnLocationWithCaster( hHero.hCurrentCreep:GetOrigin(), sSound, hHero.hCurrentCreep )
    end    
end



function Econ:EquipSkinEcon(sItemName,nPlayerID)
    
    local hHero = PlayerResource:GetPlayer(nPlayerID):GetAssignedHero()

    if hHero.vSkinInfo==nil then
       hHero.vSkinInfo={}
    end

    if  hHero then
        hHero.vSkinInfo[self.vSkinUnitMap[sItemName]] = self.vSkinModelMap[sItemName]
    end
    
end


function Econ:EquipImmortalEcon(sItemName,nPlayerID,nIsEquip)
    
    local hHero = PlayerResource:GetPlayer(nPlayerID):GetAssignedHero()
    if  hHero then
        local vUnitNames = self.vImmortalUnitMap[sItemName]
        for _,sUnitName in ipairs(vUnitNames) do
            if hHero.vImmortalInfo==nil then
               hHero.vImmortalInfo={}
            end       
            -- key为 原生物名称 value 为替换后的生物名称
            if hHero.vImmortalReplaceMap==nil then
               hHero.vImmortalReplaceMap={}
            end
            if hHero.vImmortalInfo[sUnitName]==nil then
               hHero.vImmortalInfo[sUnitName] = {}
            end
            if nIsEquip==0 then
                hHero.vImmortalInfo[sUnitName]=RemoveItemFromList(hHero.vImmortalInfo[sUnitName],sItemName)
            else
                table.insert(hHero.vImmortalInfo[sUnitName],sItemName)
                RemoveRepeated(hHero.vImmortalInfo[sUnitName])

                table.sort(hHero.vImmortalInfo[sUnitName],function(a,b) return b>a end )
            end

            local sUnitNameResult=sUnitName
            for i,v in ipairs(hHero.vImmortalInfo[sUnitName]) do
              sUnitNameResult=sUnitNameResult.."_"..v
            end
            
            -- key为 原生物名称 value 为替换后的生物名称
            hHero.vImmortalReplaceMap[sUnitName]=sUnitNameResult
        end
    end
end




function Econ:ReplaceUnitModel(hUnit,sModelName)
    
    local flModelScale= hUnit:GetModelScale()
    hUnit:SetOriginalModel(sModelName)
    hUnit:SetModel(sModelName)
    hUnit:SetModelScale(flModelScale)

end


