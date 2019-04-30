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



function Econ:Init()
    CustomGameEventManager:RegisterListener("ChangeEquip",function(_, keys)
        self:ChangeEquip(keys)
    end)
end


function Econ:ChangeEquip(keys)

    PrintTable(keys)
    --移除现有特效
    if keys.type=="Particle" then
        local nPlayerID = keys.playerId
        local hHero = PlayerResource:GetPlayer(nPlayerID):GetAssignedHero()
        local vCurrentEconParticleTable=hHero.vCurrentEconParticleTable
        
        if vCurrentEconParticleTable then
            for _,nParticleIndex in pairs(vCurrentEconParticleTable) do
                ParticleManager:DestroyParticle(nParticleIndex, true)
                ParticleManager:ReleaseParticleIndex(nParticleIndex)
            end
        end

        if keys.isEquip==1 then
            self:EquipParticleEcon(keys.itemName,nPlayerID)
            Server:UpdatePlayerEquip(nPlayerID)
        end

    end
end


function Econ:EquipParticleEcon(sItemName,hHero)
    
    local vCurrentEconParticleTable={}

    for _,sParticle in pairs(self.vParticleMap[sItemName]) do
        if hHero.hCurrentCreep and hHero.hCurrentCreep:IsAlive() then
            local nParticleIndex = ParticleManager:CreateParticle(sParticle,PATTACH_ABSORIGIN_FOLLOW,hHero.hCurrentCreep)
            ParticleManager:SetParticleControlEnt(nParticleIndex,0,hHero.hCurrentCreep,PATTACH_ABSORIGIN_FOLLOW,"follow_origin",hHero.hCurrentCreep:GetAbsOrigin(),true)
            table.insert(vCurrentEconParticleTable,nParticleIndex)
        end
    end
    
    hHero.vCurrentEconParticleTable=vCurrentEconParticleTable
end
