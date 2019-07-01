--图鉴数据处理器
if HandBook == nil then HandBook = class({}) end

--处理生物数据

local vTypes={"nFury","nDurable","nElement","nHunt","nDecay","nMystery"}

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


             if bMeetRequirement then
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

    if sPerkNameCombine=="nFury nDurable" or sPerkNameCombine=="nDurable nFury" then

       for sUnitName, vData in pairs(GameRules.vUnitsKV) do
            
            if sUnitName=="npc_dota_creature_ogre_mauler_1" or  sUnitName=="npc_dota_creature_ogre_mauler_2" or sUnitName=="npc_dota_creature_brute_1" or sUnitName=="npc_dota_creature_brute_2" or sUnitName=="npc_dota_creature_ogre_warlord" or  sUnitName=="npc_dota_creature_ogre_warchief" then
               
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

                vRawPerkData[sPerkNameCombine.."a"][vData.nCreatureLevel] = {unit_name=sUnitName,total_perk=vData.nTotalPerk,perk_data=vPerkData,ability_data=vAbilityData}

            end 

        end
    end

    if next(vRawPerkData[sPerkNameCombine.."a"])==nil then
       vRawPerkData[sPerkNameCombine.."a"]=nil
    end
        
end



