--[[进化]]

--技能数量几率表
--[[
vAbilityChanceEachLevel={
   { [0]=100 },  -- 1级
   { [0]=10,[1]=70,[2]=15,[3]=5}, --2级
   { [0]=5,[1]=50,[2]=35,[3]=10}, --3级
   { [1]=10,[2]=70,[3]=15,[4]=5}, --4级
   { [1]=5,[2]=50,[3]=35,[4]=10}, --5级
   { [2]=10,[3]=70,[4]=15,[5]=5}, --6级
   { [2]=5,[3]=50,[4]=35,[5]=10}, --7级
   { [3]=10,[4]=70,[5]=15,[6]=5}, --8级
   { [3]=5,[4]=50,[5]=35,[6]=10}, --9级
   { [4]=10,[5]=70,[6]=20 } --10级
}
]]
vAbilityChanceEachLevel={
   { [0]=100 },  -- 1级
   { [0]=15,[1]=50,[2]=30,[3]=5}, --2级
   { [0]=10,[1]=40,[2]=40,[3]=10}, --3级
   { [0]=5,[1]=30,[2]=50,[3]=15}, --4级
   { [1]=15,[2]=50,[3]=30,[4]=5}, --5级
   { [1]=10,[2]=40,[3]=40,[4]=10}, --6级
   { [1]=5,[2]=30,[3]=50,[4]=15}, --7级
   { [2]=15,[3]=50,[4]=30,[5]=5}, --8级
   { [2]=10,[3]=40,[4]=40,[5]=10}, --9级
   { [2]=5,[3]=30,[4]=50,[5]=15}, --10级
   { [4]=50,[5]=50} --11级
}

vPairedAbility={bristleback_bristleback="bristleback_quill_spray",
ancient_apparition_ice_blast="ancient_apparition_ice_blast_release",
ancient_apparition_ice_blast="ancient_apparition_ice_blast_release"
}

--[[
vAbilityChanceEachLevel={
   { [0]=100 },  -- 1级
   { [0]=75,[1]=20,[2]=5}, --2级
   { [0]=50,[1]=40,[2]=10}, --3级
   { [0]=25,[1]=60,[2]=15}, --4级
   { [1]=75,[2]=20,[3]=5}, --5级
   { [1]=50,[2]=40,[3]=10}, --6级
   { [1]=25,[2]=60,[3]=15}, --7级
   { [2]=75,[3]=20,[4]=5}, --8级
   { [2]=50,[3]=40,[4]=10}, --9级
   { [2]=25,[3]=60,[4]=15} --10级
}
]]

--进化 
function Evolve (nPlayerId,hHero)

    local nLevel=hHero.nCurrentCreepLevel
    local sUnitToEnvolve = DetermineNewUnitName(nPlayerId,hHero,nLevel)

    local sOriginalUnitName=""

    --如果装备不朽物品 nPlayerId
    if Econ.vPlayerData[nPlayerId].vImmortalReplaceMap and  Econ.vPlayerData[nPlayerId].vImmortalReplaceMap[sUnitToEnvolve]  then
         sOriginalUnitName=sUnitToEnvolve
         sUnitToEnvolve=Econ.vPlayerData[nPlayerId].vImmortalReplaceMap[sUnitToEnvolve]
         CustomNetTables:SetTableValue("econ_unit_replace",sUnitToEnvolve,{sOriginalUnitName=sOriginalUnitName})
    end

    --判断游戏阶段
    if nLevel==11 and GameRules.bUltimateStage==false then       
        GameEnterUltimateStage(nPlayerId)    
    end
    if nLevel==10 and GameRules.bLevelTenStage==false then 
        GameEnterLevelTenStage(nPlayerId)
    end          

  
    print("To Evolve Creature"..sUnitToEnvolve)
    local hUnit = SpawnUnitToReplaceHero(sUnitToEnvolve,hHero,nPlayerId)

    AddAbilityForUnit(hUnit,nPlayerId)
     
    --继承粒子特效
    if Econ.vPlayerData[nPlayerId].sCurrentParticleEconItemName then
         Econ:EquipParticleEcon(Econ.vPlayerData[nPlayerId].sCurrentParticleEconItemName,nPlayerId)
    end

    --修改模型
    if Econ.vPlayerData[nPlayerId].vSkinInfo and Econ.vPlayerData[nPlayerId].vSkinInfo[sUnitToEnvolve]~=nil then
         Econ:ReplaceUnitModel(hUnit,Econ.vPlayerData[nPlayerId].vSkinInfo[sUnitToEnvolve])
    end
    
    --修正模型动作
    ActivityModifier:AddActivityModifierThink(hUnit)

    return hUnit

end


function SpawnUnitToReplaceHero(sUnitname,hHero,nPlayerId,vPosition)
  
  hHero:AddNoDraw()
  hHero:FindAbilityByName("dota_ability_hero_invulnerable"):SetLevel(1)
  --如果已经控制了某个生物 先移除
  local flCurrentHealthRatio = 1
  if  hHero.hCurrentCreep~=nil and not hHero.hCurrentCreep:IsNull() then
    if hHero.hCurrentCreep:IsAlive() then
        --记录物品 记录血量 （重生的话从死亡事件里面记录物品）
        ItemController:RecordItemsInfo(hHero)
        flCurrentHealthRatio= hHero.hCurrentCreep:GetHealth()/hHero.hCurrentCreep:GetMaxHealth()
        if flCurrentHealthRatio<=0 then
           flCurrentHealthRatio=0.01
        end
    end
    hHero.hCurrentCreep:AddNoDraw()
    --因为游戏机制移除的
    hHero.hCurrentCreep.bKillByMech=true
    hHero.hCurrentCreep:ForceKill(false)

    --UTIL_Remove(  hHero.hCurrentCreep )
  end


  local hUnit = CreateUnitByName(sUnitname,GameMode.vStartPointLocation[hHero:GetTeamNumber()],true,hHero, hHero, hHero:GetTeamNumber())
  
  --设置视野范围
  hUnit:SetDayTimeVisionRange(1800)
  hUnit:SetNightTimeVisionRange(1000)

  hUnit:SetControllableByPlayer(hHero:GetPlayerID(), true)
  hUnit:SetHealth(hUnit:GetMaxHealth()*flCurrentHealthRatio)

  -- evolve island util
  AddTinyBody(hUnit) 
  --为死灵法师添加技能（被动技能加给野怪过强）  
  if hUnit:GetUnitName()=="npc_dota_creature_necrolyte_apostle_of_decay" then
     hUnit:AddAbility("necrolyte_heartstopper_aura"):SetLevel(1)
  end


  hHero.hCurrentCreep=hUnit
  hHero.nCurrentCreepLevel=hUnit:GetLevel()

  
  --设置技能等级
  for i=1,20 do
    local hAbility=hUnit:GetAbilityByIndex(i-1)
    if hAbility and GameRules.vUnitsKV[sUnitname].AbilitiesLevel then
       local nLevel= tonumber(SpliteStr(GameRules.vUnitsKV[sUnitname].AbilitiesLevel)[i])
       if nLevel==nil or nLevel==0 then
          nLevel=1
       end
       hAbility:SetLevel(nLevel)
    end
  end

    -- 还原之前记录的物品
  ItemController:RestoreItems(hHero)

  --放在NetTable送达前台
  CustomNetTables:SetTableValue( "player_creature_index", tostring(nPlayerId), {creepIndex=hUnit:GetEntityIndex()} )
  -- Fix for centering camera
  Timers:CreateTimer({
    callback = function()
      if IsValidEntity(hUnit) and hUnit:IsAlive() then
        hHero:SetAbsOrigin(hUnit:GetAbsOrigin())    
        return 0.5
      end
    end
  })

  --清除周围树木,防止卡在树里面
  GridNav:DestroyTreesAroundPoint( hUnit:GetOrigin(), 300, false )

  return hUnit

end



function AddAbilityForUnit(hUnit,nPlayerId)
   
   local nLevel=hUnit:GetLevel()
   local vAbilityChance =  vAbilityChanceEachLevel[nLevel]

   local nDice= RandomInt(1,100)

   local nTemp=0
   local nAbilityNumber=0

   for k,v in pairs(vAbilityChance) do
       nTemp=nTemp+v
       if nDice<=nTemp then
         nAbilityNumber=k
         break;
       end
   end
   
   local vAbilityPool={}
   local nAbilityTotalPerks=0

   for _, vData in pairs(GameRules.vAbilitiesTable) do
         
       local bPerkValid=true
       if vData.nElement>GameMode.vPlayerPerk[nPlayerId][1] then
            bPerkValid=false
       end
       if vData.nMystery>GameMode.vPlayerPerk[nPlayerId][2] then
          bPerkValid=false
       end
       if vData.nDurable>GameMode.vPlayerPerk[nPlayerId][3] then
          bPerkValid=false
       end
       if vData.nFury>GameMode.vPlayerPerk[nPlayerId][4] then
          bPerkValid=false
       end
       if vData.nDecay>GameMode.vPlayerPerk[nPlayerId][5] then
          bPerkValid=false
       end
       if vData.nHunt>GameMode.vPlayerPerk[nPlayerId][6] then
          bPerkValid=false
       end
       --满足条件加入技能池
       if bPerkValid then
          table.insert(vAbilityPool, vData)
          nAbilityTotalPerks=nAbilityTotalPerks+vData.nTotalPerk
       end
    end

    for i=1,20 do
      local hAbility=hUnit:GetAbilityByIndex(i-1)
      if hAbility and hAbility.GetAbilityName then
           local abilityName=hAbility:GetAbilityName()
           nAbilityTotalPerks=RemoveAbilityFromPoolByName(nAbilityTotalPerks,abilityName,vAbilityPool)        
      end
    end
    

    if nAbilityNumber>0 then
     for i=1,nAbilityNumber do

          --如果技能池为空
          if #vAbilityPool==0 then
             break
          end

          local nDice= RandomInt(1,nAbilityTotalPerks)
          local sNewAbilityName=""
          local nAbilityLevel=1
          --遍历技能池 确认技能结果
          local nTemp=0
          for k,vData in pairs(vAbilityPool) do
             nTemp=nTemp+vData.nTotalPerk
             if nDice<=nTemp then
               sNewAbilityName=vData.sAbilityName
               nAbilityLevel=vData.nLevel
               break;
             end
          end

          --为单位添加技能
          print("AddAbility"..sNewAbilityName)
          hUnit:AddAbility(sNewAbilityName)

          hUnit:FindAbilityByName(sNewAbilityName):SetLevel(nAbilityLevel)
          
          --添加配对技能
          if vPairedAbility[sNewAbilityName]~=nil then
                hUnit:AddAbility(vPairedAbility[sNewAbilityName])
                hUnit:FindAbilityByName(vPairedAbility[sNewAbilityName]):SetLevel(nAbilityLevel)
          end

          nAbilityTotalPerks=RemoveAbilityFromPoolByName(nAbilityTotalPerks,sNewAbilityName,vAbilityPool)

      end
    end
end


function RemoveAbilityFromPoolByName(nAbilityTotalPerks,sNewAbilityName,vAbilityPool)
   --将同名技能从技能池移除  
    local i,max=1,#vAbilityPool
    while i<=max do
        if vAbilityPool[i].sAbilityName == sNewAbilityName then
            nAbilityTotalPerks=nAbilityTotalPerks-vAbilityPool[i].nTotalPerk
            table.remove(vAbilityPool,i)
            i = i-1
            max = max-1
        end
        i= i+1
    end
    return nAbilityTotalPerks
end




function GameEnterUltimateStage  (nPlayerId)
    local sPlayerName=PlayerResource:GetPlayerName(nPlayerId)
    Notifications:TopToAll({text = sPlayerName.." ", duration = 4})
    Notifications:TopToAll({text = "#UltimateStageNote", duration = 4, style = {color = "Orange"}, continue = true})       --无法复活 关闭战争迷雾
    GameRules:GetGameModeEntity():SetFixedRespawnTime(99999999999)
    GameRules:GetGameModeEntity():SetFogOfWarDisabled(true)
    GameRules.bUltimateStage=true    
end

function GameEnterLevelTenStage  (nPlayerId)
    local sPlayerName=PlayerResource:GetPlayerName(nPlayerId)
    Notifications:TopToAll({text = sPlayerName.." ", duration = 4})
    Notifications:TopToAll({text = "#LevelTenStageNote", duration = 4, style = {color = "Orange"}, continue = true})   
    GameRules.bLevelTenStage=true
end


function DetermineNewUnitName(nPlayerId,hHero,nLevel)

    local sUnitToEnvolve=""

    local vEnvolvePool={}  --进化池
    local vEnvolveBlankPool={} --白板池子

    if nLevel==11 then
          local tempPerksMap = { 
              {name="element",value=GameMode.vPlayerPerk[nPlayerId][1]},
              {name="mystery",value=GameMode.vPlayerPerk[nPlayerId][2]},
              {name="durable",value=GameMode.vPlayerPerk[nPlayerId][3]},
              {name="fury",value=GameMode.vPlayerPerk[nPlayerId][4]},
              {name="decay",value=GameMode.vPlayerPerk[nPlayerId][5]},
              {name="hunt",value=GameMode.vPlayerPerk[nPlayerId][6]}
           }
           table.sort(tempPerksMap,function(a,b)
                return a.value > b.value
           end)

           if tempPerksMap[1].name=="element" then
               sUnitToEnvolve="npc_dota_creature_storm_spirit"
           end
           if tempPerksMap[1].name=="mystery" then
               sUnitToEnvolve="npc_dota_creature_dark_seer"
           end
           if tempPerksMap[1].name=="durable" then
               sUnitToEnvolve="npc_dota_creature_storegga_2"
           end
           if tempPerksMap[1].name=="fury" then
               sUnitToEnvolve="npc_dota_creature_ursa_razorwyrm"
           end
           if tempPerksMap[1].name=="decay" then
               sUnitToEnvolve="npc_dota_creature_necrolyte_apostle_of_decay"
           end
           if tempPerksMap[1].name=="hunt" then
               sUnitToEnvolve="npc_dota_creature_nightstalker"
           end  
    else 
        -- 遍历kv 加入进化池 key 单位名称 value单位总perk点

        local nEnvolvePoolTotalPerk=0 --进化池perk的总量

        for sUnitName, vData in pairs(GameRules.vUnitsKV) do

            if vData and type(vData) == "table" then       
                 -- 跳过召唤生物 跳过饰品生物
                if (vData.IsSummoned==nil or vData.IsSummoned==0) and (vData.EconUnitFlag==nil or vData.EconUnitFlag==0)  then
                 -- 等级相当，perk相符    
                    if vData.nCreatureLevel ==nLevel then
                       if  nLevel==1 then --第一级从直接随机选一个
                           table.insert(vEnvolveBlankPool, sUnitName)
                       else
                           local bPerkValid=true
                           --玩家Perk与生物需要的Perk的差值，差值越大越好
                           local nPerkVariance =0

                           if vData.nElement>GameMode.vPlayerPerk[nPlayerId][1] then
                              bPerkValid=false
                           else
                              if vData.nElement >0 then
                                 nPerkVariance=nPerkVariance+(GameMode.vPlayerPerk[nPlayerId][1])-vData.nElement
                              end
                           end

                           if vData.nMystery>GameMode.vPlayerPerk[nPlayerId][2] then
                              bPerkValid=false
                           else
                              if vData.nMystery >0 then 
                                 nPerkVariance=nPerkVariance+(GameMode.vPlayerPerk[nPlayerId][2])-vData.nMystery
                              end
                           end

                           if vData.nDurable>GameMode.vPlayerPerk[nPlayerId][3] then
                              bPerkValid=false
                           else
                              if vData.nDurable >0 then 
                                 nPerkVariance=nPerkVariance+(GameMode.vPlayerPerk[nPlayerId][3])-vData.nDurable
                              end
                           end

                           if vData.nFury>GameMode.vPlayerPerk[nPlayerId][4] then
                              bPerkValid=false
                           else
                              if vData.nFury > 0 then
                                 nPerkVariance=nPerkVariance+(GameMode.vPlayerPerk[nPlayerId][4])-vData.nFury
                              end
                           end

                           if vData.nDecay>GameMode.vPlayerPerk[nPlayerId][5] then
                              bPerkValid=false
                           else
                              if vData.nDecay > 0 then
                                 nPerkVariance=nPerkVariance+(GameMode.vPlayerPerk[nPlayerId][5])-vData.nDecay
                              end
                           end

                           if vData.nHunt>GameMode.vPlayerPerk[nPlayerId][6] then
                              bPerkValid=false
                           else
                              if vData.nHunt > 0 then
                                 nPerkVariance=nPerkVariance+(GameMode.vPlayerPerk[nPlayerId][6])-vData.nHunt
                              end
                           end

                           --满足条件加入进化池
                           if bPerkValid then
                              if vData.nTotalPerk == 0 then
                                 table.insert(vEnvolveBlankPool, sUnitName)
                              else
                                 local vUnitData = {}
                                 vUnitData.sUnitName=sUnitName
                                 vUnitData.nTotalPerk=vData.nTotalPerk
                                 vUnitData.nPerkVariance=nPerkVariance
                                 table.insert(vEnvolvePool, vUnitData)   
                              end
                              nEnvolvePoolTotalPerk=nEnvolvePoolTotalPerk+vData.nTotalPerk
                           end
                        end
                    end
                end
            end
        end
        
        if nEnvolvePoolTotalPerk >0 then
           
           --双重排序 确定进化结果
           table.sort(vEnvolvePool,function(a,b)
                if a.nTotalPerk == b.nTotalPerk then
                     return a.nPerkVariance>b.nPerkVariance
                else
                     return a.nTotalPerk > b.nTotalPerk
                end
           end)
          
           PrintTable(vEnvolvePool)
           sUnitToEnvolve=vEnvolvePool[1].sUnitName

        else
            local nDice= RandomInt(1,#vEnvolveBlankPool)
            sUnitToEnvolve=vEnvolveBlankPool[nDice]
        end
    end


    return sUnitToEnvolve
end



-- 挑选新的生物名字
--[[
function DetermineNewUnitName(nPlayerId,hHero,nLevel)

    local sUnitToEnvolve=""

    local vEnvolvePool={}  --进化池
    local vEnvolveBlankPool={} --白板池子

    if nLevel==11 then
          local tempPerksMap = { 
              {name="element",value=GameMode.vPlayerPerk[nPlayerId][1]},
              {name="mystery",value=GameMode.vPlayerPerk[nPlayerId][2]},
              {name="durable",value=GameMode.vPlayerPerk[nPlayerId][3]},
              {name="fury",value=GameMode.vPlayerPerk[nPlayerId][4]},
              {name="decay",value=GameMode.vPlayerPerk[nPlayerId][5]},
              {name="hunt",value=GameMode.vPlayerPerk[nPlayerId][6]}
           }
           table.sort(tempPerksMap,function(a,b)
                return a.value > b.value
           end)

           if tempPerksMap[1].name=="element" then
               sUnitToEnvolve="npc_dota_creature_storm_spirit"
           end
           if tempPerksMap[1].name=="mystery" then
               sUnitToEnvolve="npc_dota_creature_dark_seer"
           end
           if tempPerksMap[1].name=="durable" then
               sUnitToEnvolve="npc_dota_creature_storegga_2"
           end
           if tempPerksMap[1].name=="fury" then
               sUnitToEnvolve="npc_dota_creature_ursa_razorwyrm"
           end
           if tempPerksMap[1].name=="decay" then
               sUnitToEnvolve="npc_dota_creature_necrolyte_apostle_of_decay"
           end
           if tempPerksMap[1].name=="hunt" then
               sUnitToEnvolve="npc_dota_creature_nightstalker"
           end  
    else 
        -- 遍历kv 加入进化池 key 单位名称 value单位总perk点

        local nEnvolvePoolTotalPerk=0 --进化池perk的总量

        for sUnitName, vData in pairs(GameRules.vUnitsKV) do

            if vData and type(vData) == "table" then       
                 -- 跳过召唤生物 跳过饰品生物
                if (vData.IsSummoned==nil or vData.IsSummoned==0) and (vData.EconUnitFlag==nil or vData.EconUnitFlag==0)  then
                 -- 等级相当，perk相符    
                    if vData.nCreatureLevel ==nLevel then
                       if  nLevel==1 then --第一级从直接随机选一个
                           table.insert(vEnvolveBlankPool, sUnitName)
                       else
                           local bPerkValid=true  
                           if vData.nElement>GameMode.vPlayerPerk[nPlayerId][1] then
                              bPerkValid=false
                           end
                           if vData.nMystery>GameMode.vPlayerPerk[nPlayerId][2] then
                              bPerkValid=false
                           end
                           if vData.nDurable>GameMode.vPlayerPerk[nPlayerId][3] then
                              bPerkValid=false
                           end
                           if vData.nFury>GameMode.vPlayerPerk[nPlayerId][4] then
                              bPerkValid=false
                           end
                           if vData.nDecay>GameMode.vPlayerPerk[nPlayerId][5] then
                              bPerkValid=false
                           end
                           if vData.nHunt>GameMode.vPlayerPerk[nPlayerId][6] then
                              bPerkValid=false
                           end
                           --满足条件加入进化池
                           if bPerkValid then
                              if vData.nTotalPerk == 0 then
                                 table.insert(vEnvolveBlankPool, sUnitName)
                              else
                                 vEnvolvePool[sUnitName] = vData.nTotalPerk
                              end
                              nEnvolvePoolTotalPerk=nEnvolvePoolTotalPerk+vData.nTotalPerk
                           end
                        end
                    end
                end
            end
        end
        
        if nEnvolvePoolTotalPerk >0 then
            local nDice= RandomInt(1,nEnvolvePoolTotalPerk)

            --遍历进化池 确认进化结果
            local nTemp=0
            for sUnitName,nPerk in pairs(vEnvolvePool) do
               nTemp=nTemp+nPerk
               if nDice<=nTemp then
                 sUnitToEnvolve=sUnitName
                 break;
               end
            end
        else
            local nDice= RandomInt(1,#vEnvolveBlankPool)
            sUnitToEnvolve=vEnvolveBlankPool[nDice]
        end
    end



    return sUnitToEnvolve
end

]]



