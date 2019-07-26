--[[进化]]

--技能数量几率表
--[[
vAbilityChanceEachLevel={
   { [0]=50,[1]=50 }, -- 1级
   { [1]=55,[2]=35,[3]=10}, --2级
   { [1]=35,[2]=45,[3]=20}, --3级
   { [1]=15,[2]=55,[3]=30}, --4级
   { [2]=55,[3]=35,[4]=10}, --5级
   { [2]=35,[3]=45,[4]=20}, --6级
   { [2]=15,[3]=55,[4]=30}, --7级
   { [3]=55,[4]=35,[5]=10}, --8级
   { [3]=35,[4]=45,[5]=20}, --9级
   { [3]=15,[4]=55,[5]=30}, --10级
   { [4]=50,[5]=50} --11级
}
]]

vAbilityChanceEachLevel={
   { [1]=50,[2]=50}, --1级
   { [2]=75,[3]=25}, --2级
   { [2]=50,[3]=50}, --3级
   { [2]=25,[3]=75}, --4级
   { [3]=75,[4]=25}, --5级
   { [3]=50,[4]=50}, --6级
   { [3]=25,[4]=75}, --7级
   { [4]=75,[5]=25}, --8级
   { [4]=50,[5]=50}, --9级
   { [4]=25,[5]=75}, --10级
   { [5]=100}  --11级
}


vPairedAbility={bristleback_bristleback="bristleback_quill_spray",
ancient_apparition_ice_blast="ancient_apparition_ice_blast_release",
templar_assassin_psionic_trap="templar_assassin_trap",
spectre_haunt_single_lua="spectre_reality_lua",
spectre_haunt_lua="spectre_reality_lua",
}


ALEARY_PRECACHE_UNIT ={}

ABILITY_PRECACHE_MAP = {
    antimage_blink="npc_precache_npc_dota_hero_antimage",
    crystal_maiden_frostbite="npc_precache_npc_dota_hero_crystal_maiden",
    morphling_waveform="npc_precache_npc_dota_hero_morphling",
    invoker_tornado="npc_precache_npc_dota_hero_invoker",
    crystal_maiden_crystal_nova="npc_precache_npc_dota_hero_crystal_maiden",
    lich_chain_frost="npc_precache_npc_dota_hero_lich",
    dragon_knight_breathe_fire="npc_precache_npc_dota_hero_dragon_knight",
    shredder_reactive_armor="npc_precache_npc_dota_hero_shredder",
    mars_bulwark="npc_precache_npc_dota_hero_mars",
    tiny_grow="npc_precache_npc_dota_hero_tiny",
    bristleback_bristleback="npc_precache_npc_dota_hero_bristleback",
    sandking_epicenter="npc_precache_npc_dota_hero_sandking",
    lich_frost_shield="npc_precache_npc_dota_hero_lich",
    dark_seer_surge="npc_precache_npc_dota_hero_dark_seer",
    templar_assassin_psionic_trap="npc_precache_npc_dota_hero_templar_assassin",
    wisp_relocate="npc_precache_npc_dota_hero_wisp",
    ancient_apparition_ice_blast="npc_precache_npc_dota_hero_ancient_apparition",
    storm_spirit_ball_lightning="npc_precache_npc_dota_hero_storm_spirit",
    dark_seer_vacuum="npc_precache_npc_dota_hero_dark_seer",
    templar_assassin_refraction="npc_precache_npc_dota_hero_templar_assassin",
    spectre_dispersion="npc_precache_npc_dota_hero_spectre",
    broodmother_spin_web="npc_precache_npc_dota_hero_broodmother",
    night_stalker_hunter_in_the_night="npc_precache_npc_dota_hero_night_stalker",
    night_stalker_darkness="npc_precache_npc_dota_hero_night_stalker",
    ember_spirit_searing_chains="npc_precache_npc_dota_hero_ember_spirit",
    tidehunter_gush="npc_precache_npc_dota_hero_tidehunter",
    razor_eye_of_the_storm="npc_precache_npc_dota_hero_razor",
    phantom_assassin_blur="npc_precache_npc_dota_hero_phantom_assassin",
    spirit_breaker_greater_bash="npc_precache_npc_dota_hero_spirit_breaker",
    sandking_burrowstrike="npc_precache_npc_dota_hero_sandking",
    riki_smoke_screen="npc_precache_npc_dota_hero_riki",
    bane_brain_sap="npc_precache_npc_dota_hero_bane",
    riki_blink_strike="npc_precache_npc_dota_hero_riki",
    clinkz_strafe="npc_precache_npc_dota_hero_clinkz",
    phantom_assassin_coup_de_grace="npc_precache_npc_dota_hero_phantom_assassin",
    ursa_overpower="npc_precache_npc_dota_hero_ursa",
    ursa_fury_swipes="npc_precache_npc_dota_hero_ursa",
    huskar_berserkers_blood="npc_precache_npc_dota_hero_huskar",
    ember_spirit_sleight_of_fist="npc_precache_npc_dota_hero_ember_spirit",
    clinkz_searing_arrows="npc_precache_npc_dota_hero_clinkz",
    mars_gods_rebuke="npc_precache_npc_dota_hero_mars",
    centaur_double_edge="npc_precache_npc_dota_hero_centaur",
    centaur_khan_war_stomp="npc_precache_npc_dota_hero_centaur",
    huskar_life_break="npc_precache_npc_dota_hero_huskar",
    alchemist_chemical_rage="npc_precache_npc_dota_hero_alchemist",
    slardar_amplify_damage="npc_precache_npc_dota_hero_slardar",
    faceless_void_chronosphere="npc_precache_npc_dota_hero_faceless_void",
    slardar_bash="npc_precache_npc_dota_hero_slardar",
    broodmother_insatiable_hunger="npc_precache_npc_dota_hero_broodmother",
    troll_warlord_battle_trance="npc_precache_npc_dota_hero_troll_warlord",
    spirit_breaker_charge_of_darkness="npc_precache_npc_dota_hero_spirit_breaker",
    spectre_desolate="npc_precache_npc_dota_hero_spectre",
    clinkz_death_pact="npc_precache_npc_dota_hero_clinkz",
    death_prophet_carrion_swarm="npc_precache_npc_dota_hero_death_prophet",
    skeleton_king_hellfire_blast="npc_precache_npc_dota_hero_skeleton_king",
    pugna_nether_blast="npc_precache_npc_dota_hero_pugna",
    visage_summon_familiars_stone_form="npc_precache_npc_dota_hero_visage",
    warlock_shadow_word="npc_precache_npc_dota_hero_warlock",
    dazzle_bad_juju="npc_precache_npc_dota_hero_dazzle",
    enigma_midnight_pulse="npc_precache_npc_dota_hero_enigma",
    pudge_meat_hook="npc_precache_npc_dota_hero_pudge",
    venomancer_poison_nova="npc_precache_npc_dota_hero_venomancer",
    doom_bringer_infernal_blade="npc_precache_npc_dota_hero_doom_bringer",
    life_stealer_rage="npc_precache_npc_dota_hero_life_stealer",
    skeleton_king_mortal_strike="npc_precache_npc_dota_hero_skeleton_king",    
}



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
    else
        --没有不朽物品，使用玩家专属生物
        sUnitToEnvolve = string.gsub(sUnitToEnvolve, "npc_dota_creature_", "npc_dota_creature_player_") 
    end

    --判断游戏阶段
    if nLevel==11 and GameRules.bUltimateStage==false then       
        GameEnterUltimateStage(nPlayerId)
        if not GameRules.bPveMap then
          local vSnap=Snapshot:GenerateSnapShot(nPlayerId)
          Server:UploadSnapLog(vSnap,"first_11")
        end
    end
    if nLevel==10 and GameRules.bLevelTenStage==false then 
        GameEnterLevelTenStage(nPlayerId)
        if not GameRules.bPveMap then
          local vSnap=Snapshot:GenerateSnapShot(nPlayerId)
          Server:UploadSnapLog(vSnap,"first_10")
        end
    end

  
    print("To Evolve Creature"..sUnitToEnvolve)
    local hUnit = SpawnUnitToReplaceHero(sUnitToEnvolve,hHero,nPlayerId)

    AddAbilityForUnit(hUnit,nPlayerId)
    
    --为11级生物添加两级反转
    if nLevel==11 then
       hUnit:AddAbility("ultimate_stage_reverse_polarity")
       hUnit:FindAbilityByName("ultimate_stage_reverse_polarity"):StartCooldown(140)
       hUnit:FindAbilityByName("ultimate_stage_reverse_polarity"):SetLevel(1)
    end

    --冒泡排序交换技能 把被动技能下沉
    for i=0,24 do
        for j=0,24-i do
          local hAbility1 = hUnit:GetAbilityByIndex(j)
          local hAbility2 = hUnit:GetAbilityByIndex(j+1)
          if hAbility1 and hAbility2 and hAbility1:IsPassive() and not hAbility2:IsPassive() then
              hUnit:SwapAbilities(hAbility1:GetAbilityName(), hAbility2:GetAbilityName(), true, true)
          end
        end   
    end

    --修正模型动作
    ActivityModifier:AddActivityModifierThink(hUnit)

    --计算平均等级
    CountAverageLevel()

    --继承粒子特效
    if Econ.vPlayerData[nPlayerId].sCurrentParticleEconItemName then
         Econ:EquipParticleEcon(Econ.vPlayerData[nPlayerId].sCurrentParticleEconItemName,nPlayerId)
    end

    --修改模型
    if Econ.vPlayerData[nPlayerId].vSkinInfo and Econ.vPlayerData[nPlayerId].vSkinInfo[sUnitToEnvolve]~=nil then
         Econ:ReplaceUnitModel(hUnit,Econ.vPlayerData[nPlayerId].vSkinInfo[sUnitToEnvolve])
    end

    return hUnit

end


function SpawnUnitToReplaceHero(sUnitname,hHero,nPlayerId)
  
  hHero:AddNoDraw()
  hHero:FindAbilityByName("dota_ability_hero_invulnerable"):SetLevel(1)
  --如果已经控制了某个生物 先移除
  local flCurrentHealthRatio = 1
  local bPreviousHasFlyMovementCapability = false
  local nPreviousLevel=1

  if  hHero.hCurrentCreep~=nil and not hHero.hCurrentCreep:IsNull() then
    bPreviousHasFlyMovementCapability =  hHero.hCurrentCreep:HasFlyMovementCapability()
    --开臂章有问题，此处多加一个标志物
    if hHero.hCurrentCreep:IsAlive() then
        nPreviousLevel=hHero.hCurrentCreep:GetLevel()
        --记录物品 记录血量 （重生的话从死亡事件里面记录物品）
        ItemController:RecordItemsInfo(hHero)
        flCurrentHealthRatio= hHero.hCurrentCreep:GetHealth()/hHero.hCurrentCreep:GetMaxHealth()
        if flCurrentHealthRatio<=0.01 then
           flCurrentHealthRatio=0.01
        end
    end
    
    RemoveInvulnerableModifier(hHero.hCurrentCreep)

    hHero.hCurrentCreep:AddNoDraw()

    --连环删除大法
    local hToKillUnit=hHero.hCurrentCreep

    Timers:CreateTimer(FrameTime(), function()
           if hToKillUnit  and not hToKillUnit:IsNull() and hToKillUnit:IsAlive() then
              --因游戏机制移除的生物
              hToKillUnit.bKillByMech=true
              hToKillUnit:AddNoDraw()
              hToKillUnit:ForceKill(false)
              return FrameTime()
           else
            return nil
           end
        end
    )
    --闪退 弃用
    --UTIL_Remove(  hHero.hCurrentCreep )
  end
  
  local hUnit = CreateUnitByName(sUnitname,hHero:GetOrigin(),true,hHero, hHero, hHero:GetTeamNumber())
  
  --设置视野范围
  hUnit:SetDayTimeVisionRange(1800)
  hUnit:SetNightTimeVisionRange(1000)

  hUnit:SetControllableByPlayer(hHero:GetPlayerID(), true)
  hUnit:SetHealth(hUnit:GetMaxHealth()*flCurrentHealthRatio)

  FindClearSpaceForUnit(hUnit, hUnit:GetAbsOrigin(), true)

  -- evolve island util
  AddTinyBody(hUnit)

  hHero.hCurrentCreep=hUnit
  --玩家的主控生物
  hUnit.bMainCreep=true

  if hUnit:GetLevel() then
     hHero.nCurrentCreepLevel=hUnit:GetLevel()
  end

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
  CustomNetTables:SetTableValue( "player_creature_index", tostring(nPlayerId), {creepIndex=hUnit:GetEntityIndex(), creepName=hUnit:GetUnitName(),creepLevel=hUnit:GetLevel()  } )
  CustomNetTables:SetTableValue( "main_creature_owner", tostring(hUnit:GetEntityIndex()), {owner_id=nPlayerId,creepName=hUnit:GetUnitName(), creepLevel=hUnit:GetLevel() } )

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
  local flDestroyTreeRadius=200

  --如果之前有飞行能力，现在没有了
  if bPreviousHasFlyMovementCapability and not hUnit:HasFlyMovementCapability() then
     flDestroyTreeRadius=450
  end
  
  --如果之前不足七级，或者本次是重生
  if nPreviousLevel<7 and hUnit:GetLevel()>=7 then
     flDestroyTreeRadius=450
  end
  
  GridNav:DestroyTreesAroundPoint( hUnit:GetOrigin(), flDestroyTreeRadius, false )

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
          
          local bToPrecache = false

          if ABILITY_PRECACHE_MAP[sNewAbilityName] then
             if ALEARY_PRECACHE_UNIT[ABILITY_PRECACHE_MAP[sNewAbilityName]]==nil then
                --添加在回调函数处理
                bToPrecache = true
                local sToPrecacheUnitName = ABILITY_PRECACHE_MAP[sNewAbilityName]
                ALEARY_PRECACHE_UNIT[sToPrecacheUnitName]=true
                print("Prcaching Unit:"..sToPrecacheUnitName)
                PrecacheUnitByNameAsync(sToPrecacheUnitName, function() 
                   
                    hUnit:AddAbility(sNewAbilityName)
                    hUnit:FindAbilityByName(sNewAbilityName):SetLevel(nAbilityLevel)
      
                    --添加配对技能
                    if vPairedAbility[sNewAbilityName]~=nil then
                        if not hUnit:HasAbility(vPairedAbility[sNewAbilityName]) then
                          hUnit:AddAbility(vPairedAbility[sNewAbilityName])
                          hUnit:FindAbilityByName(vPairedAbility[sNewAbilityName]):SetLevel(nAbilityLevel)
                        end
                    end

                end)
             end
          end
          
          --不需要预载入 直接添加技能即可
          if not bToPrecache then
              hUnit:AddAbility(sNewAbilityName)
              hUnit:FindAbilityByName(sNewAbilityName):SetLevel(nAbilityLevel)
              --添加配对技能
              if vPairedAbility[sNewAbilityName]~=nil then
                  if not hUnit:HasAbility(vPairedAbility[sNewAbilityName]) then
                    hUnit:AddAbility(vPairedAbility[sNewAbilityName])
                    hUnit:FindAbilityByName(vPairedAbility[sNewAbilityName]):SetLevel(nAbilityLevel)
                  end
              end
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
    Notifications:TopToAll({text = sPlayerName.." ", duration = 6})
    Notifications:TopToAll({text = "#UltimateStageNote", duration = 6, style = {color = "Orange"}, continue = true})       --无法复活 关闭战争迷雾
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
               sUnitToEnvolve="npc_dota_creature_dark_seer_imperial_relics"
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

           return sUnitToEnvolve
    else 
        -- 遍历kv 加入进化池 key 单位名称 value单位总perk点

        local nEnvolvePoolTotalPerk=0 --进化池perk的总量

        for sUnitName, vData in pairs(GameRules.vUnitsKV) do

            if vData and type(vData) == "table" then       
                 -- 跳过召唤生物 跳过饰品生物
                if (vData.IsSummoned==nil or vData.IsSummoned==0) and (vData.EconUnitFlag==nil or vData.EconUnitFlag==0) and (vData.ConsideredHero==nil or vData.ConsideredHero==0)  then
                 -- 等级相当，perk相符    
                    if vData.nCreatureLevel ==nLevel then
                       if  nLevel==1 then --第一级从直接随机选一个
                           table.insert(vEnvolveBlankPool, sUnitName)
                       else
                           local bPerkValid=true
                           --玩家Perk与生物需要的Perk的差值 再除上Perk数量，差值越大越好
                           local flPerkVariance =0
                           local nPerkVarianceType=0

                           if vData.nElement>GameMode.vPlayerPerk[nPlayerId][1] then
                              bPerkValid=false
                           else
                              if vData.nElement >0 then
                                 flPerkVariance=flPerkVariance+(GameMode.vPlayerPerk[nPlayerId][1])-vData.nElement
                                 nPerkVarianceType=nPerkVarianceType+1
                              end
                           end

                           if vData.nMystery>GameMode.vPlayerPerk[nPlayerId][2] then
                              bPerkValid=false
                           else
                              if vData.nMystery >0 then 
                                 flPerkVariance=flPerkVariance+(GameMode.vPlayerPerk[nPlayerId][2])-vData.nMystery
                                 nPerkVarianceType=nPerkVarianceType+1
                              end
                           end

                           if vData.nDurable>GameMode.vPlayerPerk[nPlayerId][3] then
                              bPerkValid=false
                           else
                              if vData.nDurable >0 then 
                                 flPerkVariance=flPerkVariance+(GameMode.vPlayerPerk[nPlayerId][3])-vData.nDurable
                                 nPerkVarianceType=nPerkVarianceType+1
                              end
                           end

                           if vData.nFury>GameMode.vPlayerPerk[nPlayerId][4] then
                              bPerkValid=false
                           else
                              if vData.nFury > 0 then
                                 flPerkVariance=flPerkVariance+(GameMode.vPlayerPerk[nPlayerId][4])-vData.nFury
                                 nPerkVarianceType=nPerkVarianceType+1
                              end
                           end

                           if vData.nDecay>GameMode.vPlayerPerk[nPlayerId][5] then
                              bPerkValid=false
                           else
                              if vData.nDecay > 0 then
                                 flPerkVariance=flPerkVariance+(GameMode.vPlayerPerk[nPlayerId][5])-vData.nDecay
                                 nPerkVarianceType=nPerkVarianceType+1
                              end
                           end

                           if vData.nHunt>GameMode.vPlayerPerk[nPlayerId][6] then
                              bPerkValid=false
                           else
                              if vData.nHunt > 0 then
                                 flPerkVariance=flPerkVariance+(GameMode.vPlayerPerk[nPlayerId][6])-vData.nHunt
                                 nPerkVarianceType=nPerkVarianceType+1
                              end
                           end

                           --满足条件加入进化池
                           if bPerkValid then

                              if vData.nTotalPerk == 0 then
                                 table.insert(vEnvolveBlankPool, sUnitName)
                              else
                                 local flRadio=1
                                 --十分重要参数 这是flPerkVariance的折价率
                                 if nPerkVarianceType==2 then
                                    flRadio=0.525
                                 end
                                 if nPerkVarianceType==3 then
                                    flRadio=0.35
                                 end

                                 local vUnitData = {}
                                 vUnitData.sUnitName=sUnitName
                                 vUnitData.nTotalPerk=vData.nTotalPerk
                                 vUnitData.flPerkVariance=flPerkVariance*flRadio
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
                     return a.flPerkVariance>b.flPerkVariance
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

function CountAverageLevel()

     local nTotalLevel = 0
     local nTotalHeroNumber = 0

     for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
        if PlayerResource:IsValidPlayer( nPlayerID ) then
          local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
          if hHero then
            if hHero.nCurrentCreepLevel then
              nTotalLevel=nTotalLevel+hHero.nCurrentCreepLevel 
            else
              nTotalLevel=nTotalLevel+1
            end
            nTotalHeroNumber=nTotalHeroNumber+1
          end
        end
     end
     
     local nAverageLevel =1 
     local sAverageLevel =""

     if nTotalHeroNumber>0 then
        nAverageLevel = math.floor(nTotalLevel/nTotalHeroNumber + 0.5) --四舍五入
        sAverageLevel = string.format("%.2f", nTotalLevel/nTotalHeroNumber)
     end

     -- PVE模式 无此机制
     if not GameRules.bPveMap then
       CustomNetTables:SetTableValue( "game_state","game_state", {average_level=nAverageLevel})
     end

     GameRules.nAverageLevel=nAverageLevel
     GameRules.sAverageLevel=sAverageLevel
     GameRules.nTotalHeroNumber=nTotalHeroNumber
  
end


--获得经验，尝试升级，升级并且更新雷达
function GainExpAndUpdateRadar (nPlayerId,hHero,flExp)

     hHero.nCustomExp=hHero.nCustomExp+flExp

     --计算等级
     local nNewLevel=CalculateNewLevel(hHero)
     if hHero:IsAlive() then
         --如果升级了 进化
         if nNewLevel~=hHero.nCurrentCreepLevel then
            hHero.nCurrentCreepLevel=nNewLevel
            LevelUpAndEvolve(nPlayerId,hHero)
         end
     end
     --更新UI显示
     CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerId),"UpdateRadar", {current_exp=hHero.nCustomExp-vEXP_TABLE[nNewLevel],next_level_need=vEXP_TABLE[nNewLevel+1]-vEXP_TABLE[nNewLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )
     CustomNetTables:SetTableValue( "player_info", tostring(nPlayerId), {current_exp=hHero.nCustomExp-vEXP_TABLE[nNewLevel],next_level_need=vEXP_TABLE[nNewLevel+1]-vEXP_TABLE[nNewLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )
      
    
end