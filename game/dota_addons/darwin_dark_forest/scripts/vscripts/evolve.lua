--[[进化]]
--LinkLuaModifier( "modifier_hero_adjustment", "modifiers/modifier_hero_adjustment", LUA_MODIFIER_MOTION_NONE )

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
   { [0]=30,[1]=50,[2]=15,[3]=5}, --2级
   { [0]=20,[1]=40,[2]=30,[3]=10}, --3级
   { [0]=10,[1]=30,[2]=45,[3]=15}, --4级
   { [1]=30,[2]=50,[3]=15,[4]=5}, --5级
   { [1]=20,[2]=40,[3]=30,[4]=10}, --6级
   { [1]=10,[2]=30,[3]=45,[4]=15}, --7级
   { [2]=30,[3]=50,[4]=15,[5]=5}, --8级
   { [2]=20,[3]=40,[4]=30,[5]=10}, --9级
   { [2]=10,[3]=30,[4]=45,[5]=15} --10级
}

vPairedAbility={bristleback_bristleback="bristleback_quill_spray",
ancient_apparition_ice_blast="ancient_apparition_ice_blast_release"}

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
    
    -- 遍历kv 加入进化池 key 单位名称 value单位总perk点
    local vEnvolvePool={}
    local vEnvolveBlankPool={} --白板池子

    local nEnvolvePoolTotalPerk=0 --进化池perk的总量

    for sUnitName, vData in pairs(GameRules.vUnitsKV) do

        if vData and type(vData) == "table" then       
             -- 跳过召唤生物
            if vData.IsSummoned==nil or vData.IsSummoned==0 then
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

    local sUnitToEnvolve =""
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
    
    print("To Evolve Creature"..sUnitToEnvolve)
    local hUnit = SpawnUnitToReplaceHero(sUnitToEnvolve,hHero,nPlayerId)

    AddAbilityForUnit(hUnit,nPlayerId)

    return hUnit
    --[[ 废弃，直接给玩家一个单位
    hHero:SetBaseHealthRegen(vUnitToEnvolve.StatusHealthRegen)
    hHero:SetBaseMaxHealth(vUnitToEnvolve.StatusHealth)
    hHero:SetMaxHealth(vUnitToEnvolve.StatusHealth)
    hHero:SetHealth(vUnitToEnvolve.StatusHealth)

    hHero:SetBaseAgility(0)
    hHero:SetBaseIntellect(0)  
    hHero:SetBaseStrength(0)  

    hHero:SetBaseManaRegen(vUnitToEnvolve.StatusManaRegen)
    hHero:SetMana(vUnitToEnvolve.StatusMana)
    hHero:SetBaseDamageMin(vUnitToEnvolve.AttackDamageMin)
    hHero:SetBaseDamageMin(vUnitToEnvolve.AttackDamageMax)
    hHero:SetPhysicalArmorBaseValue(vUnitToEnvolve.ArmorPhysical)
    hHero:SetBaseMoveSpeed(vUnitToEnvolve.MovementSpeed)
    hHero:SetAttackCapability(ConvertConstStrToInt(vUnitToEnvolve.AttackCapabilities))
    hHero:SetModel(vUnitToEnvolve.Model)
    hHero:SetOriginalModel(vUnitToEnvolve.Model)
    hHero:SetRangedProjectileName(vUnitToEnvolve.ProjectileModel)

    --弹道速度用modifier修正
    hHero.flProjectileSpeedModify=vUnitToEnvolve.AttackRate-hHero:GetProjectileSpeed()
    --attack rate在 modifier处理
    hHero.flBaseAttackRate=vUnitToEnvolve.AttackRate
    --用modifier修正攻击距离
    hHero.flAttackRangeModify=vUnitToEnvolve.AttackRange-hHero:GetBaseAttackRange() --默认128
    
    hHero:RemoveModifierByName("modifier_hero_adjustment")
    hHero:AddNewModifier(hHero, nil, "modifier_hero_adjustment", {})
    ]]
    

end


function SpawnUnitToReplaceHero(sUnitname,hHero,nPlayerId,vPosition)
  
  hHero:AddNoDraw()
  hHero:FindAbilityByName("dota_ability_hero_invulnerable"):SetLevel(1)
  --如果已经控制了某个生物 先移除

  --保留生物的当前血量百分比
  local flCurrentHealthRatio = 1
  if  hHero.hCurrentCreep~=nil and not hHero.hCurrentCreep:IsNull() then
    if hHero.hCurrentCreep:IsAlive() then
        flCurrentHealthRatio= hHero.hCurrentCreep:GetHealth()/hHero.hCurrentCreep:GetMaxHealth()
        if flCurrentHealthRatio<=0 then
           flCurrentHealthRatio=0.01
        end
    end
    hHero.hCurrentCreep:AddNoDraw()
    UTIL_Remove(  hHero.hCurrentCreep )
  end


  local hUnit = CreateUnitByName(sUnitname,GameMode.vStartPointLocation[hHero:GetTeamNumber()],true,hHero, hHero, hHero:GetTeamNumber())
  
  --设置视野范围
  hUnit:SetDayTimeVisionRange(1800)
  hUnit:SetNightTimeVisionRange(1000)

  hUnit:SetControllableByPlayer(hHero:GetPlayerID(), true)
  hUnit:SetHealth(hUnit:GetMaxHealth()*flCurrentHealthRatio)
  -- evolve island util
  AddTinyBody(hUnit)

  hHero.hCurrentCreep=hUnit
  hHero.nCurrentCreepLevel=hUnit:GetLevel()
  
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
   
   print("Ability number for player"..nPlayerId.." is:"..nAbilityNumber)

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
          hUnit:AddAbility(sNewAbilityName)
          
          hUnit:FindAbilityByName(sNewAbilityName):SetLevel(nAbilityLevel)
          
          --添加配对技能
          if vPairedAbility[sNewAbilityName]~=nil then
                hero:AddAbility(vPairedAbility[sNewAbilityName])
                hero:FindAbilityByName(vPairedAbility[sNewAbilityName]):SetLevel(nAbilityLevel)
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
