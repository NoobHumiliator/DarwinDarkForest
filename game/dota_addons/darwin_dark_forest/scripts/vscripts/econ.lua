if Econ == nil then Econ = class({}) end

Econ.vParticleMap ={

    green={"particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_3.vpcf"},
    lava_trail={"particles/econ/courier/courier_trail_lava/courier_trail_lava.vpcf"},
    paltinum_baby_roshan={"particles/econ/paltinum_baby_roshan/paltinum_baby_roshan.vpcf"},
    legion_wings={"particles/econ/legion_wings/legion_wings.vpcf"},
    legion_wings_vip={"particles/econ/legion_wings/legion_wings_vip.vpcf"},
    legion_wings_pink={"particles/econ/legion_wings/legion_wings_pink.vpcf"},
    darkmoon={"particles/econ/courier/courier_roshan_darkmoon/courier_roshan_darkmoon.vpcf"},
    sakura_trail={"particles/econ/courier/courier_axolotl_ambient/courier_axolotl_ambient.vpcf","particles/econ/sakura_trail.vpcf"}
}


Econ.vKillEffectMap ={
    sf_wings="particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_wings.vpcf",
    huaji="particles/econ/kill_mark/huaji.vpcf",
    jibururen_mark="particles/econ/kill_mark/jibururen_mark.vpcf",
    question_mark="particles/econ/kill_mark/question_mark.vpcf",
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
    shearing_deposition="npc_dota_creature_lich",
    glare_of_the_tyrant="npc_dota_creature_lich"
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
    print("keys.dnaValue"..keys.dnaValue)
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
            local nParticleIndex = ParticleManager:CreateParticle(sParticle,PATTACH_ABSORIGIN_FOLLOW,hHero.hCurrentCreep)
            ParticleManager:SetParticleControlEnt(nParticleIndex,0,hHero.hCurrentCreep,PATTACH_ABSORIGIN_FOLLOW,"follow_origin",hHero.hCurrentCreep:GetAbsOrigin(),true)
            table.insert(vCurrentEconParticleIndexs,nParticleIndex)
        end
    end
    
    hHero.sCurrentParticleEconItemName=sItemName
    hHero.vCurrentEconParticleIndexs=vCurrentEconParticleIndexs
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
        local sUnitName = self.vImmortalUnitMap[sItemName]
        

        
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
        print("sUnitNameResult"..sUnitNameResult)
        hHero.vImmortalReplaceMap[sUnitName]=sUnitNameResult
        

    end
    
end




function Econ:ReplaceUnitModel(hUnit,sModelName)
    
    local flModelScale= hUnit:GetModelScale()
    hUnit:SetOriginalModel(sModelName)
    hUnit:SetModel(sModelName)
    hUnit:SetModelScale(flModelScale)

end


