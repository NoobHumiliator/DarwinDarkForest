--[[ events.lua ]]

---------------------------------------------------------------------------
-- Event: Game state change handler
---------------------------------------------------------------------------
function GameMode:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()

	if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then

	end

	if nNewState == DOTA_GAMERULES_STATE_PRE_GAME then

	end

	if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then

	end
end

function GameMode:OnPlayerPickHero(keys)
 
    local hHero = EntIndexToHScript(keys.heroindex)
    local nPlayerId=keys.player-1

    --初始化玩家的perk点数
    GameMode.vPlayerPerk[nPlayerId]={0,0,0,0,0,0}
    CustomNetTables:SetTableValue( "player_perk", tostring(nPlayerId), GameMode.vPlayerPerk[nPlayerId] )
    hHero.nCustomExp=1 --自定义经验
    hHero.nCustomLevel=1 --自定义等级
    

    -- 移除饰品
    for _,child in pairs(hHero:GetChildren()) do
       if child:GetClassname() == "dota_item_wearable" then
           child:RemoveSelf()
       end
    end
    --移除物品
    for i=0,8 do
		if hHero:GetItemInSlot(i)~= nil then
			hHero:RemoveItem(hHero:GetItemInSlot(i))
		end
	end
    hHero:SetAbilityPoints(0)
    --移除空白技能
    for i=1,16 do
    	hHero:RemoveAbility("empty"..i)
    end
    hHero.nCurrentCreepLevel=1

    Evolve(nPlayerId,hHero)
end

function GameMode:OnEntityKilled(keys)

   local hKilledUnit = EntIndexToHScript( keys.entindex_killed )
   local hKillerUnit = EntIndexToHScript(keys.entindex_attacker)
   

   local flPercentage=0.5 --进化点数 比例

   --如果玩家击杀野怪，把野怪的进化点赋给玩家
   if  hKilledUnit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then

       local nPlayerId = hKillerUnit:GetOwner():GetPlayerID()
       local hHero =  PlayerResource:GetSelectedHeroEntity(nPlayerId)

       --消除野怪户籍
       NeutralSpawner.nCreaturesNumber=NeutralSpawner.nCreaturesNumber+1

       NeutralSpawner.vCreatureLevelMap[hKilledUnit.nCreatureLevel]=NeutralSpawner.vCreatureLevelMap[hKilledUnit.nCreatureLevel]-1
       

       local tempPerksMap = {0,0,0,0,0,0}

       tempPerksMap[1] = GameRules.vUnitsKV[hKilledUnit:GetUnitName()].nElement  *flPercentage
       tempPerksMap[2] = GameRules.vUnitsKV[hKilledUnit:GetUnitName()].nMystery *flPercentage
       tempPerksMap[3] = GameRules.vUnitsKV[hKilledUnit:GetUnitName()].nDurable *flPercentage
       tempPerksMap[4] = GameRules.vUnitsKV[hKilledUnit:GetUnitName()].nFury *flPercentage
       tempPerksMap[5] = GameRules.vUnitsKV[hKilledUnit:GetUnitName()].nDecay *flPercentage
       tempPerksMap[6] = GameRules.vUnitsKV[hKilledUnit:GetUnitName()].nHunt *flPercentage

       --计算一个总进化点数       
       local flTotalPerks=0
       --计算多少种属性 需要倒扣
       local nUnmatchTypes=0

       for _,v in ipairs(tempPerksMap) do
         flTotalPerks=v+flTotalPerks
         if v==0 then
           nUnmatchTypes=nUnmatchTypes+1
         end
       end
       
       if flTotalPerks>0 then --需要处理进化点数
             -- 遍历 如果进化点不符合倒扣，属性符合增加
             for i,v in ipairs(tempPerksMap) do        
                 if tempPerksMap[i] ==0 then --此项倒扣，倒扣的值为 flTotalPerks/nUnmatchTypes
                    GameMode.vPlayerPerk[nPlayerId][i]= math.max(0, GameMode.vPlayerPerk[nPlayerId][i]-flTotalPerks/nUnmatchTypes)
                 else --此项增加
                    GameMode.vPlayerPerk[nPlayerId][i]=GameMode.vPlayerPerk[nPlayerId][i]+ tempPerksMap[i]
                 end
             end
       end


       --收割灵魂例子特效
       local nSoulParticle = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_necro_souls_hero.vpcf", PATTACH_POINT_FOLLOW, hKillerUnit)
       ParticleManager:SetParticleControlEnt(nSoulParticle, 0, hKilledUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", hKillerUnit:GetAbsOrigin(), true)
       ParticleManager:SetParticleControlEnt(nSoulParticle, 1, hKillerUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", hKillerUnit:GetAbsOrigin(), true)
       
       --给玩家经验
       hHero.nCustomExp=hHero.nCustomExp+vCREEP_EXP_TABLE[hKilledUnit.nCreatureLevel] 
       
       --计算等级
       local nNewLevel=CalculateNewLevel(hHero)
       
       --如果升级了 进化
       if nNewLevel~=hHero.nCurrentCreepLevel then
          
          --播放进化声音
          EmitSoundOn('General.LevelUp.Bonus',hHero) 

          GameMode:PutStartPositionToLocation(hHero,hHero:GetAbsOrigin())
          hHero.nCurrentCreepLevel=nNewLevel
          Evolve(nPlayerId,hHero)

          --进化完了播放升级粒子特效
          local nLevelUpParticleIndex = ParticleManager:CreateParticle("particles/econ/events/ti6/hero_levelup_ti6_godray.vpcf", PATTACH_ABSORIGIN_FOLLOW, hHero.currentCreep)
          ParticleManager:ReleaseParticleIndex(nLevelUpParticleIndex)

       end
       --更新UI显示
       CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerId),"UpdateRadar", {current_exp=hHero.nCustomExp-vEXP_TABLE[nNewLevel],next_level_need=vEXP_TABLE[nNewLevel+1]-vEXP_TABLE[nNewLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )
       CustomNetTables:SetTableValue( "player_perk", tostring(nPlayerId), GameMode.vPlayerPerk[nPlayerId] )


   end

    --如果玩家生物被击杀，损失经验 换出生点 换模型
   if  hKilledUnit:GetOwner() and not hKilledUnit:IsHero() then
       local nPlayerId = hKilledUnit:GetOwner():GetPlayerID()
       local hHero =  PlayerResource:GetSelectedHeroEntity(nPlayerId)

       hHero.nCustomExp=hHero.nCustomExp-(vEXP_TABLE[hHero.currentCreep:GetLevel()+1]-vEXP_TABLE[hHero.currentCreep:GetLevel()])*0.5
      
       --保证不是负数
       if hHero.nCustomExp<1 then
          hHero.nCustomExp=1
       end
  
       --计算等级
       local nNewLevel=CalculateNewLevel(hHero)
       hHero.nCurrentCreepLevel=nNewLevel
       
       --击杀英雄
       hHero:Kill(nil, hKillerUnit)
       GameMode:PutStartPositionToRandomPosForTeam(hHero:GetTeamNumber());
       hHero:SetTimeUntilRespawn(5)

        --计算等级
       local nNewLevel=CalculateNewLevel(hHero)
       hHero.nCurrentCreepLevel=nNewLevel
       --英雄重生的时候再进化
       --Evolve(nPlayerId,hHero)
        --更新雷达显示
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerId),"UpdateRadar", {current_exp=hHero.nCustomExp-vEXP_TABLE[nNewLevel],next_level_need=vEXP_TABLE[nNewLevel+1]-vEXP_TABLE[nNewLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )
   end

end


function CalculateNewLevel(hHero)

     --计算等级
     local nNewLevel=1
     for i, v in ipairs(vEXP_TABLE) do
         if  hHero.nCustomExp>vEXP_TABLE[i]  and   hHero.nCustomExp<vEXP_TABLE[i+1]  then
             nNewLevel=i
             break
         end
     end
     return nNewLevel

end

--英雄重生
function GameMode:OnNPCSpawned( event )
    local hSpawnedUnit = EntIndexToHScript( event.entindex )
    --如果已经初始化过 （是复生 而不是第一次选出来）
    if hSpawnedUnit:IsHero() and hSpawnedUnit.nCurrentCreepLevel then
        local nPlayerId = hSpawnedUnit:GetOwner():GetPlayerID()
        --将镜头定位到重生英雄，然后放开
        PlayerResource:SetCameraTarget(nPlayerId,hSpawnedUnit)
        PlayerResource:SetCameraTarget(nPlayerId,nil) 
        Evolve(nPlayerId,hSpawnedUnit)
    end
    
    --设置一个随机的位置
    if hSpawnedUnit and hSpawnedUnit.GetUnitName then
        hSpawnedUnit:SetForwardVector(RandomVector(1))
    end

end