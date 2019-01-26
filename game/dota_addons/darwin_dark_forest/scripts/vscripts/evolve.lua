--[[进化]]
--LinkLuaModifier( "modifier_hero_adjustment", "modifiers/modifier_hero_adjustment", LUA_MODIFIER_MOTION_NONE )

--进化
function Evolve (nPlayerId,hHero)
     
    local nLevel=hHero.nCurrentCreepLevel
    
    -- 遍历kv 加入进化池 key 单位名称 value单位总perk点
    local vEnvolvePool={}
    local vEnvolveBlankPool={} --白板池子

    local nEnvolvePoolTotalPerk=0 --进化池perk的总量

    for sUnitName, vData in pairs(GameRules.vUnitsKV) do

        if vData and type(vData) == "table" then
            -- 等级相当，perk相符         

            if vData.nCreatureLevel ==nLevel then
               if  nLevel==1 then --第一级从直接随机选一个
                   vEnvolvePool[sUnitName] = 1
                   nEnvolvePoolTotalPerk=nEnvolvePoolTotalPerk+1
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
    

    local sUnitToEnvolve =""
    if nEnvolvePoolTotalPerk >0
        local nDice= RandomInt(1,nEnvolvePoolTotalPerk)
        local sUnitToEnvolve =""
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
    return SpawnUnitToReplaceHero(sUnitToEnvolve,hHero,nPlayerId)
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
  if  hHero.currentCreep~=nil and not hHero.currentCreep:IsNull() then
    hHero.currentCreep:AddNoDraw()
    UTIL_Remove(  hHero.currentCreep )
  end

  local hUnit = CreateUnitByName(sUnitname,GameMode.vStartPointLocation[hHero:GetTeamNumber()],true,hHero, hHero, hHero:GetTeamNumber())
  hUnit:SetControllableByPlayer(hHero:GetPlayerID(), true)


  hHero.currentCreep=hUnit
  hHero.nCurrentCreepLevel=hUnit:GetLevel()
  
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