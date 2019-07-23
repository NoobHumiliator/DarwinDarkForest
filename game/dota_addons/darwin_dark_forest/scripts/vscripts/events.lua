--[[ events.lua ]]
LinkLuaModifier( "modifier_zero_cooldown_and_mana_cost", "modifiers/modifier_zero_cooldown_and_mana_cost", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_respawn_invulnerable", "modifiers/modifier_respawn_invulnerable", LUA_MODIFIER_MOTION_NONE )

---------------------------------------------------------------------------
-- Event: Game state change handler
---------------------------------------------------------------------------
function GameMode:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()

  if nNewState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
        Server:GetRankData()
        Server:GetEconRarity()
  end

	if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then

	end
  
   -- 统计有效玩家个数
	if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then

     GameRules.vPlayerSteamIdMap={}
   
     local nValidPlayerNumber= 0
     local vPlayerTeam={}

     for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
       if PlayerResource:IsValidPlayer( nPlayerID ) then
          nValidPlayerNumber = nValidPlayerNumber+1
          table.insert(vPlayerTeam,PlayerResource:GetTeam(nPlayerID))
          local nPlayerSteamId = PlayerResource:GetSteamAccountID(nPlayerID)
          GameRules.sValidePlayerSteamIds=GameRules.sValidePlayerSteamIds..nPlayerSteamId..","
          GameRules.vPlayerSteamIdMap[nPlayerSteamId]=nPlayerID
          if Econ.vPlayerData[nPlayerID] == nil then
             Econ.vPlayerData[nPlayerID]={}
          end
       end
     end
     
     if string.sub(GameRules.sValidePlayerSteamIds,string.len(GameRules.sValidePlayerSteamIds))=="," then   --去掉最后一个逗号
        GameRules.sValidePlayerSteamIds=string.sub(GameRules.sValidePlayerSteamIds,0,string.len(GameRules.sValidePlayerSteamIds)-1)
     end

     if nValidPlayerNumber==1 then
         GameRules.bPveMap=true
         --Local不测单人
         if GameRules.sValidePlayerSteamIds=="88765185" then
            if bTEST_PVE then
               GameRules.bPveMap=true
            else
               GameRules.bPveMap=false
            end
         end
     end
     
     vPlayerTeam=RemoveRepetition(vPlayerTeam)
     GameRules.nValidTeamNumber=#vPlayerTeam
     Server:GetPlayerEconData()

	end

	if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
      
     --记录游戏开始的时间
     GameRules.nGameStartTime=GameRules:GetGameTime()
     local econData = CustomNetTables:GetTableValue("econ_data", "econ_data")
     --这个地方重发一下数据，保证前台数据完整
     CustomNetTables:SetTableValue("econ_data", "econ_data",econData)

     --给玩家 Particle,KillEffect,KillSound,Immortal 类型饰品
     if econData and econData["econ_info"] then
         for sPlayerSteamID,vPlayerInfo in pairs(econData["econ_info"]) do
              for nIndex,v in pairs(vPlayerInfo) do
                  local nPlayerID = GameRules.vPlayerSteamIdMap[tonumber(sPlayerSteamID)]
                  if v.type=="Particle" and v.equip=="true" then
                      Econ:EquipParticleEcon(v.name,nPlayerID)
                  end
                  if v.type=="KillEffect" and v.equip=="true" then
                      Econ:EquipKillEffectEcon(v.name,nPlayerID)
                  end
                  if v.type=="Immortal" and v.equip=="true" then
                      Econ:EquipImmortalEcon(v.name,nPlayerID,1)
                  end
                  if v.type=="KillSound" and v.equip=="true" then
                      Econ:EquipKillSoundEcon(v.name,nPlayerID)
                  end
              end
          end
      end
	end
end

function GameMode:OnPlayerPickHero(keys)
 
    local hHero = EntIndexToHScript(keys.heroindex)
    local nPlayerId=hHero:GetPlayerID()

    if Econ.vPlayerData[nPlayerId] == nil then
       Econ.vPlayerData[nPlayerId]={}
    end

    --初始化玩家的perk点数
    GameMode.vPlayerPerk[nPlayerId]={0,0,0,0,0,0}
    CustomNetTables:SetTableValue( "player_info", tostring(nHandlingPlayerId), {current_exp=1,next_level_need=vEXP_TABLE[2],perk_table=GameMode.vPlayerPerk[nPlayerId] } )       

    hHero.nCustomExp=1 --自定义经验
    
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
    --稍等英雄位置落地 再进化
    Timers:CreateTimer(FrameTime(), function()
             xpcall(
              function()
                  Evolve(nPlayerId,hHero)
              end,
              function(e)
                  Server:UploadErrorLog(e)
            end)
        end
    )
end

function GameMode:OnEntityKilled(keys)
  
   local hKilledUnit = EntIndexToHScript( keys.entindex_killed )
   
   local flPercentage=0.5 --野怪进化点数 比例
   local flPlayerPercentage=0.08 --玩家进化点数 吸取比例

   --如果玩家击杀野怪，把野怪的进化点赋给玩家
   if  hKilledUnit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
       if keys.entindex_attacker  then
           local hKillerUnit = EntIndexToHScript(keys.entindex_attacker)
           if hKillerUnit and not hKillerUnit:IsNull() then

             local nPlayerId = hKillerUnit:GetMainControllingPlayer()
             local hHero =  PlayerResource:GetSelectedHeroEntity(nPlayerId)
              
             --如果是生物自然死亡，不做处理
             if hHero==nil then
                 return
             end

             --掉落物品
             ItemController:DropItemByChance(hKilledUnit)
         
             --被击杀的时大怪，播放
             if hKilledUnit:GetLevel()>hHero.nCurrentCreepLevel then
                  PlayKillEffectAndSound(nPlayerId)
             end

             --消除野怪户口 (先确保被击杀单位不是野怪的召唤生物)      
             if hKilledUnit.nCreatureLevel then
                 NeutralSpawner.nCreaturesNumber=NeutralSpawner.nCreaturesNumber-1
                 NeutralSpawner.vCreatureLevelMap[hKilledUnit.nCreatureLevel]=NeutralSpawner.vCreatureLevelMap[hKilledUnit.nCreatureLevel]-1
             end

             local tempPerksMap = {0,0,0,0,0,0}
         
             if GameRules.vUnitsKV[hKilledUnit:GetUnitName()] then
                 tempPerksMap[1] = GameRules.vUnitsKV[hKilledUnit:GetUnitName()].nElement  *flPercentage
                 tempPerksMap[2] = GameRules.vUnitsKV[hKilledUnit:GetUnitName()].nMystery *flPercentage
                 tempPerksMap[3] = GameRules.vUnitsKV[hKilledUnit:GetUnitName()].nDurable *flPercentage
                 tempPerksMap[4] = GameRules.vUnitsKV[hKilledUnit:GetUnitName()].nFury *flPercentage
                 tempPerksMap[5] = GameRules.vUnitsKV[hKilledUnit:GetUnitName()].nDecay *flPercentage
                 tempPerksMap[6] = GameRules.vUnitsKV[hKilledUnit:GetUnitName()].nHunt *flPercentage
             end
           

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
             
             PlayAbsorbParticle(tempPerksMap,hKillerUnit,hKilledUnit)

             --计算经验获取率
             local flExpRatio=1
             if hHero.hCurrentCreep and hHero.hCurrentCreep:HasModifier("modifier_item_creed_of_omniscience") then
                 flExpRatio= flExpRatio*1.2
             end

             if hHero.hCurrentCreep and hHero.hCurrentCreep:HasModifier("modifier_bonus_ring_effect") then
                 flExpRatio= flExpRatio*1.5
             end
             
             local flExp = 0
             if hKilledUnit.nCreatureLevel then
               flExp= vCREEP_EXP_TABLE[hKilledUnit.nCreatureLevel]*flExpRatio
             else
               flExp= vCREEP_EXP_TABLE[hKilledUnit:GetLevel()]*flExpRatio
             end

             GainExpAndUpdateRadar(nPlayerId,hHero,flExp)
          end --if hKillerUnit and not hKillerUnit:IsNull()
       end --if keys.entindex_attacker
   end --hKilledUnit:GetTeamNumber() == DOTA_TEAM_NEUTRALS

    --如果玩家生物被击杀
   if  hKilledUnit:GetOwner() and not hKilledUnit:IsHero() and hKilledUnit:GetOwner().GetPlayerID then
       local nPlayerId = hKilledUnit:GetOwner():GetPlayerID()
       local hHero =  PlayerResource:GetSelectedHeroEntity(nPlayerId)

       local nKillerPlayerId
       local hKillerHero 

       --玩家被 其他队伍的玩家所击杀 标志位
       local bKilledByOtherTeam = false
       local hKillerUnit=nil

       if keys.entindex_attacker then
         hKillerUnit = EntIndexToHScript(keys.entindex_attacker)
         if hKillerUnit and not hKillerUnit:IsNull() and hKillerUnit:GetOwner() and  hKillerUnit:GetOwner().GetPlayerID then
            nKillerPlayerId = hKillerUnit:GetOwner():GetPlayerID()
            if nKillerPlayerId~=-1 and PlayerResource:GetTeam(nKillerPlayerId)~=PlayerResource:GetTeam(nPlayerId) then
              hKillerHero =  PlayerResource:GetSelectedHeroEntity(nKillerPlayerId)
              bKilledByOtherTeam=true
            end
         end
       end

       -- 保证是玩家的主控生物
       if hHero and hHero.hCurrentCreep == hKilledUnit and true~=hHero.hCurrentCreep.bKillByMech then

          hHero:Kill(nil, hKillerUnit)

          -- 终极进化阶段不能再重生
          if GameRules.bUltimateStage then
            hHero:SetTimeUntilRespawn(-1)
          else
            hHero:SetTimeUntilRespawn(5)
          end

          --掉落物品
          ItemController:DropItemByChance(hKilledUnit)
                    
          --记录物品
          ItemController:RecordItemsInfo(hHero)

          local flExpLoseRatio = CalculateExpLostRatio(hHero)
          
          if  hHero.hCurrentCreep and not hHero.hCurrentCreep:IsNull() and hHero.hCurrentCreep:GetLevel()==11 then
              hHero.nCustomExp = vEXP_TABLE[9]+1
          else
              hHero.nCustomExp=hHero.nCustomExp-(vEXP_TABLE[hHero.hCurrentCreep:GetLevel()+1]-vEXP_TABLE[hHero.hCurrentCreep:GetLevel()])*flExpLoseRatio       
          end

           --保证不是负数
          if hHero.nCustomExp<1 then
              hHero.nCustomExp=1
          end

          -- 处理被其他队伍玩家击杀的情况 
          if bKilledByOtherTeam then
             local tempPerksMap = {0,0,0,0,0,0}
   
            for i=1,6 do
                --按比例给予 击杀者perk
                GameMode.vPlayerPerk[nKillerPlayerId][i]=GameMode.vPlayerPerk[nKillerPlayerId][i]+ GameMode.vPlayerPerk[nPlayerId][i] * flPlayerPercentage
                tempPerksMap[i]=GameMode.vPlayerPerk[nPlayerId][i] * flPlayerPercentage
            end

            PlayAbsorbParticle(tempPerksMap,hKillerUnit,hKilledUnit)

            --给击杀者经验 玩家互相杀 经验翻倍
            local flExpRatio=2
            if hKillerHero.hCurrentCreep and hKillerHero.hCurrentCreep:HasModifier("modifier_item_creed_of_omniscience") then
               flExpRatio=flExpRatio*1.2
            end

            if hKillerHero.hCurrentCreep and hKillerHero.hCurrentCreep:HasModifier("modifier_bonus_ring_effect") then
               flExpRatio= flExpRatio*1.5
            end

            local flExp= vCREEP_EXP_TABLE[hKilledUnit:GetLevel()]*flExpRatio 
            
            PlayKillEffectAndSound(nKillerPlayerId)
            --给击杀者 英雄换模型
            hKillerHero:SetOriginalModel(hKillerUnit:GetModelName())
            hKillerHero:SetModel(hKillerUnit:GetModelName())
            
            GainExpAndUpdateRadar(nKillerPlayerId,hKillerHero,flExp)

          end

          --重生前将出身地随机
          Timers:CreateTimer(4.6, function()
                 GameMode:PutStartPositionToRandomPosForTeam(hHero:GetTeamNumber());
              end
          )

           --计算等级
          local nNewLevel=CalculateNewLevel(hHero)
          hHero.nCurrentCreepLevel=nNewLevel
          --英雄重生的时候再进化
          --Evolve(nPlayerId,hHero)
          --更新雷达显示
          CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerId),"UpdateRadar", {current_exp=hHero.nCustomExp-vEXP_TABLE[nNewLevel],next_level_need=vEXP_TABLE[nNewLevel+1]-vEXP_TABLE[nNewLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )
       end
   end
   DoCleanForDeadUnit(hKilledUnit)
end


function CalculateNewLevel(hHero)

     --计算等级
     local nNewLevel=1
     for i, v in ipairs(vEXP_TABLE) do
         if  hHero.nCustomExp>=vEXP_TABLE[i]  and   hHero.nCustomExp<vEXP_TABLE[i+1]  then
             nNewLevel=i
             break
         end
     end
     return nNewLevel

end

function LevelUpAndEvolve(nPlayerId,hHero)

    --播放进化声音，不能放在这 否则会影响连杀音效 十分诡异？？
    --EmitSoundOn('General.LevelUp.Bonus',hHero) 

    hHero:EmitSound("General.LevelUp.Bonus")

    --由于进化位置是
    --GameMode:PutStartPositionToLocation(hHero,hHero:GetAbsOrigin())
    
     --关键函数包起来
      xpcall(
      function()
          Evolve(nPlayerId,hHero)
      end,
      function(e)
          Server:UploadErrorLog(e)
      end)

    --进化完了播放升级粒子特效
    local nLevelUpParticleIndex = ParticleManager:CreateParticle("particles/econ/events/ti6/hero_levelup_ti6_godray.vpcf", PATTACH_ABSORIGIN_FOLLOW, hHero.hCurrentCreep)
    ParticleManager:ReleaseParticleIndex(nLevelUpParticleIndex)


end

--播放击杀 吸收特效
function PlayAbsorbParticle(tempPerksMap,hKillerUnit,hKilledUnit)


     --收割灵魂例子特效 白色特效
       local flTotalPerks=0

       for _,v in ipairs(tempPerksMap) do
         flTotalPerks=v+flTotalPerks
       end

       --如果没有可以吸的 播放白色特效
       if flTotalPerks ==0 then
           local nSoulParticle = ParticleManager:CreateParticle("particles/absorb_particle/absorb_white.vpcf", PATTACH_POINT_FOLLOW, hKillerUnit)
           ParticleManager:SetParticleControlEnt(nSoulParticle, 0, hKilledUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", hKillerUnit:GetAbsOrigin(), true)
           ParticleManager:SetParticleControlEnt(nSoulParticle, 1, hKillerUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", hKillerUnit:GetAbsOrigin(), true)
       end

         
       local tempPerksColorMap = { 
          {color="blue",value=tempPerksMap[1]},
          {color="purple",value=tempPerksMap[2]},
          {color="yellow",value=tempPerksMap[3]},
          {color="red",value=tempPerksMap[4]},
          {color="green",value=tempPerksMap[5]},
          {color="black",value=tempPerksMap[6]}
       }     
       
       table.sort(tempPerksColorMap,function(a,b)
            return a.value > b.value
       end)

       --播放吸收特效
       local timePause=FrameTime()
       for _,v in pairs(tempPerksColorMap) do
         if v.value>0 then 
            Timers:CreateTimer(timePause, function()
                local nSoulParticle = ParticleManager:CreateParticle("particles/absorb_particle/absorb_"..v.color..".vpcf", PATTACH_POINT_FOLLOW, hKillerUnit)
                ParticleManager:SetParticleControlEnt(nSoulParticle, 0, hKilledUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", hKillerUnit:GetAbsOrigin(), true)
                ParticleManager:SetParticleControlEnt(nSoulParticle, 1, hKillerUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", hKillerUnit:GetAbsOrigin(), true)
                return nil
              end
            )
            timePause=timePause+0.5
         end
       end

     
end


--英雄重生
function GameMode:OnNPCSpawned( event )

    local hSpawnedUnit = EntIndexToHScript( event.entindex )
    --print("hSpawnedUnit:GetUnitName()"..hSpawnedUnit:GetUnitName())

    --如果已经初始化过 （是复生 而不是第一次选出来）
    if hSpawnedUnit:IsHero() and hSpawnedUnit.nCurrentCreepLevel then
        local nPlayerId = hSpawnedUnit:GetPlayerID()

        print("Respawning Player Id"..nPlayerId)
        --计算等级
        local nNewLevel=CalculateNewLevel(hSpawnedUnit)
        hSpawnedUnit.nCurrentCreepLevel=nNewLevel
        
        --关键函数包起来
        xpcall(
        function()
            local hNewCreep=Evolve(nPlayerId,hSpawnedUnit)           
            local flDuration = CalculateInvulnerableDuration(hSpawnedUnit)
            hNewCreep:AddNewModifier(hNewCreep, nil, "modifier_respawn_invulnerable", {duration=flDuration})
        end,
        function(e)
            Server:UploadErrorLog(e)
        end)


         --将镜头定位到重生英雄，然后放开
        PlayerResource:SetCameraTarget(nPlayerId,hSpawnedUnit)
        Timers:CreateTimer({ endTime = 0.5, 
            callback = function()
              PlayerResource:SetCameraTarget(nPlayerId,nil) 
            end
        })
    end
    
    if not hSpawnedUnit:IsHero() then
    --修正模型动作
       ActivityModifier:AddActivityModifierThink(hSpawnedUnit)
    end
    --处理生物角度
    if hSpawnedUnit and hSpawnedUnit.GetUnitName then
        if hSpawnedUnit:GetUnitName()~="npc_dota_thinker"then
          hSpawnedUnit:SetForwardVector(RandomVector(1))
        end
    end

end


function PlayKillEffectAndSound (nPlayerID)
    
     if PlayerResource:GetPlayer(nPlayerID) and PlayerResource:GetPlayer(nPlayerID).GetAssignedHero then
         local hHero = PlayerResource:GetPlayer(nPlayerID):GetAssignedHero()

         if Econ.vPlayerData[nPlayerID].sCurrentKillEffect then
              Econ:PlayKillEffect(Econ.vPlayerData[nPlayerID].sCurrentKillEffect,hHero)
         end

         if Econ.vPlayerData[nPlayerID].sCurrentKillSound then
              Econ:PlayKillSound(Econ.vPlayerData[nPlayerID].sCurrentKillSound,hHero)
         end
     end

end

--清理死亡生物留下的
function DoCleanForDeadUnit(hUnit)
    -- 清理蜘蛛网
    local vWebs = Entities:FindAllByName("npc_dota_broodmother_web")
    for _, hWeb in pairs(vWebs) do
      if hWeb:GetOwner() == hUnit then
        UTIL_Remove(hWeb)
      end
    end
end


--计算 生物的经验损失比率
function CalculateExpLostRatio(hHero)
              
    --损失经验率
    local flExpLoseRatio = 0.35

    if  GameRules.nAverageLevel  and hHero.hCurrentCreep and not hHero.hCurrentCreep:IsNull()  then
        
        if hHero.hCurrentCreep:GetLevel() >= GameRules.nAverageLevel+2 then
           flExpLoseRatio=0.45
        end

        if hHero.hCurrentCreep:GetLevel() == GameRules.nAverageLevel+1 then
           flExpLoseRatio=0.40
        end

        if hHero.hCurrentCreep:GetLevel() == GameRules.nAverageLevel then
           flExpLoseRatio=0.35
        end

        if hHero.hCurrentCreep:GetLevel() == GameRules.nAverageLevel-1 then
           flExpLoseRatio=0.10
        end

        if hHero.hCurrentCreep:GetLevel() == GameRules.nAverageLevel-2 then
           flExpLoseRatio=0.03
        end

        if hHero.hCurrentCreep:GetLevel() <= GameRules.nAverageLevel-3 then
           flExpLoseRatio=0
        end
        
    end

    print("AverageLevel: "..GameRules.nAverageLevel.."flExpLoseRatio: "..flExpLoseRatio)
    return  flExpLoseRatio
end


function GameMode:RequestCreatureIndex(keys) 
    local nPlayerID = keys.playerId
    local hHero = PlayerResource:GetPlayer(nPlayerID):GetAssignedHero()
    
    if hHero and hHero.hCurrentCreep and not hHero.hCurrentCreep:IsNull()  then
        print("Request Creature Index from Sever"..nPlayerID)
        CustomNetTables:SetTableValue( "player_creature_index", tostring(nPlayerID), {creepIndex=hHero.hCurrentCreep:GetEntityIndex(),creepName=hHero.hCurrentCreep:GetUnitName(), creepLevel=hHero.hCurrentCreep:GetLevel() } )
        CustomNetTables:SetTableValue( "main_creature_owner", tostring(hHero.hCurrentCreep:GetEntityIndex()), {owner_id=nPlayerID,creepName=hHero.hCurrentCreep:GetUnitName(), creepLevel=hHero.hCurrentCreep:GetLevel() } )
    end
    
end

function GameMode:PortraitClicked(keys) 
    local nPlayerID = keys.playerId
    local nTargetPlayerID = keys.targetPlayerId
    local nDoubleClick = keys.doubleClick
    local nControldown = keys.controldown
    
    local hTargetHero =  PlayerResource:GetSelectedHeroEntity(nTargetPlayerID)
    local hHero =  PlayerResource:GetSelectedHeroEntity(nPlayerID)
  
    if hTargetHero and hHero and hTargetHero.hCurrentCreep and hHero.hCurrentCreep then
         if   hHero.hCurrentCreep:CanEntityBeSeenByMyTeam(hTargetHero.hCurrentCreep) then
              
              CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID),"UpdateSelect", {creepIndex= hTargetHero.hCurrentCreep:GetEntityIndex()} )            
              
              --如果按住ctrl 或者双击，定位到目标位置              
              if nDoubleClick==1  or nControldown==1 then
                PlayerResource:SetCameraTarget(nPlayerID,hTargetHero.hCurrentCreep)
                Timers:CreateTimer({ endTime = 0.1, 
                    callback = function()
                      PlayerResource:SetCameraTarget(nPlayerID,nil) 
                    end
                })
              end
         end
    end
end


--计算复活无敌时间
function CalculateInvulnerableDuration(hHero)
              
    --无敌时间
    local flDuration = 3.5

    if  GameRules.nAverageLevel and hHero.hCurrentCreep and not hHero.hCurrentCreep:IsNull() then
        
        if hHero.hCurrentCreep:GetLevel() >= GameRules.nAverageLevel+2 then
           flDuration=0.3
        end

        if hHero.hCurrentCreep:GetLevel() == GameRules.nAverageLevel+1 then
           flDuration=1
        end

        if hHero.hCurrentCreep:GetLevel() == GameRules.nAverageLevel then
           flDuration=3
        end

        if hHero.hCurrentCreep:GetLevel() == GameRules.nAverageLevel-1 then
           flDuration=6
        end

        if hHero.hCurrentCreep:GetLevel() == GameRules.nAverageLevel-2 then
           flDuration=12
        end

        if hHero.hCurrentCreep:GetLevel() == GameRules.nAverageLevel-3 then
           flDuration=24
        end

        if hHero.hCurrentCreep:GetLevel() <= GameRules.nAverageLevel-4 then
           flDuration=36
        end
        
    end

    return  flDuration
end
