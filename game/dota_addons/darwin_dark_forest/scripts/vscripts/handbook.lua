--图鉴数据处理器
if HandBook == nil then HandBook = class({}) end

--处理生物数据

local vTypes={"nFury","nDurable","nElement","nHunt","nDecay","nMystery"}

--微调生物的名字
local vAdjustMap={
    
    npc_dota_creature_ogre_mauler_1=true,
    npc_dota_creature_ogre_mauler_2=true,
    npc_dota_creature_brute_1=true,
    npc_dota_creature_brute_2=true,
    npc_dota_creature_ogre_warlord=true,
    npc_dota_creature_ogre_warchief=true,
    npc_dota_creature_large_dragonspawn=true,
    npc_dota_creature_dragonspawn=true,
    npc_dota_creature_slark_1=true,
    npc_dota_creature_slark_2=true,
    npc_dota_creature_slark_3=true,
    npc_dota_creature_gaoler=true,
    npc_dota_creature_small_thunder_lizard_1=true,
    npc_dota_creature_small_thunder_lizard_2=true,
    npc_dota_creature_large_thunder_lizard=true


}

--微调生物的类群
local vAdjustsCombine={
    
    "nFury nDurable",
    "nDurable nFury",
    "nFury nDurable nElement",
    "nDurable nFury nElement",
    "nElement nFury nDurable",
    "nHunt nMystery",
    "nMystery nHunt",
    "nDurable nMystery",
    "nMystery nDurable",
    "nElement nDurable",
    "nDurable nElement",
}



function HandBook:DealCreatureData()

    -- 三重遍历
    local result={}
    for i=1,#vTypes do
        result[vTypes[i]]={}
    end

    for i1=1,#vTypes do
        local key=vTypes[i1]
        self:InsertCombineData(result[key],vTypes[i1])
        for i2=1,#vTypes do
            if i1~=i2 then
               self:InsertCombineData(result[key],vTypes[i1].." "..vTypes[i2])
               self:Adjust(result[key],vTypes[i1].." "..vTypes[i2])
                for i3=i2+1,#vTypes do
                   if i3~=i1 then
                      self:InsertCombineData(result[key],vTypes[i1].." "..vTypes[i2].." "..vTypes[i3])
                      self:Adjust(result[key],vTypes[i1].." "..vTypes[i2].." "..vTypes[i3])
                   end
                end
            end
        end
        CustomNetTables:SetTableValue("hand_book", key,result[key])
    end
end


function HandBook:InsertCombineData(vRawPerkData,sPerkNameCombine)
   
    vRawPerkData[sPerkNameCombine]={}
        
    for sUnitName, vData in pairs(GameRules.vUnitsKV) do
        if vData and type(vData) == "table"  and vData.nCreatureLevel>0 and vData.nCreatureLevel<11 and vData.nTotalPerk>0 and (vData.EconUnitFlag==nil or vData.EconUnitFlag==0) and (vData.ConsideredHero==nil or vData.ConsideredHero==0) and (vData.IsSummoned==nil or vData.IsSummoned==0) then
             
             local bMeetRequirement=true


             for i=1,#vTypes do
                if vData[vTypes[i]]>0 and string.find(sPerkNameCombine,vTypes[i])==nil then
                   bMeetRequirement=false
                end
             end
             
             for _,v in pairs(SpliteStr(sPerkNameCombine)) do
                 if vData[v]==0  then
                   bMeetRequirement=false
                end
             end
             
             if bMeetRequirement  and vAdjustMap[sUnitName]==nil then
                 local vPerkData={}
                 for _,v in pairs(SpliteStr(sPerkNameCombine)) do
                     vPerkData[v]=vData[v]
                 end
                 local vAbilityData={}
                 if vData.Ability1 and vData.Ability1~="" then
                    vAbilityData.ability_1=vData.Ability1
                 end
                 if vData.Ability2 and vData.Ability2~="" then
                    vAbilityData.ability_2=vData.Ability2
                 end
                 if vData.Ability3 and vData.Ability3~="" then
                    vAbilityData.ability_3=vData.Ability3
                 end
                 if vRawPerkData[sPerkNameCombine][vData.nCreatureLevel]==nil then
                    vRawPerkData[sPerkNameCombine][vData.nCreatureLevel] = {unit_name=sUnitName,total_perk=vData.nTotalPerk,perk_data=vPerkData,ability_data=vAbilityData}
                 else
                    if vRawPerkData[sPerkNameCombine][vData.nCreatureLevel].total_perk<vData.nTotalPerk then
                       vRawPerkData[sPerkNameCombine][vData.nCreatureLevel] = {unit_name=sUnitName,total_perk=vData.nTotalPerk,perk_data=vPerkData,ability_data=vAbilityData}
                    end
                 end
             end
        end
    end
    --[[
    if sPerkNameCombine=="nDurable nElement nDecay" then
        print("wtf")
        PrintTable(vRawPerkData[sPerkNameCombine])
    end
    ]]
    if next(vRawPerkData[sPerkNameCombine])==nil then
       vRawPerkData[sPerkNameCombine]=nil
    end
    
end


--部分数据微调
function HandBook:Adjust(vRawPerkData,sPerkNameCombine)
    
    --微调的标志位
    vRawPerkData[sPerkNameCombine.."a"]={}

    local bInAdjustCombine=false

    for _,v in ipairs(vAdjustsCombine) do
        if sPerkNameCombine==v then
            print("sPerkNameCombine"..sPerkNameCombine)
            bInAdjustCombine=true
        end
    end


    if bInAdjustCombine then

       for sUnitName, vData in pairs(GameRules.vUnitsKV) do
            
            if vAdjustMap[sUnitName] then
               
                 local vPerkData={}
                 local bValid=true

                 for _,v in pairs(SpliteStr(sPerkNameCombine)) do
                     vPerkData[v]=vData[v]
                     if vPerkData[v]==0 then
                        bValid=false
                     end
                 end
                 local vAbilityData={}
                 if vData.Ability1 and vData.Ability1~="" then
                    vAbilityData.ability_1=vData.Ability1
                 end
                 if vData.Ability2 and vData.Ability2~="" then
                    vAbilityData.ability_2=vData.Ability2
                 end
                 if vData.Ability3 and vData.Ability3~="" then
                    vAbilityData.ability_3=vData.Ability3
                 end

                 if bValid then
                     vRawPerkData[sPerkNameCombine.."a"][vData.nCreatureLevel] = {unit_name=sUnitName,total_perk=vData.nTotalPerk,perk_data=vPerkData,ability_data=vAbilityData}
                 end
            end 

        end
    end

    if next(vRawPerkData[sPerkNameCombine.."a"])==nil then
       vRawPerkData[sPerkNameCombine.."a"]=nil
    end
        
end



