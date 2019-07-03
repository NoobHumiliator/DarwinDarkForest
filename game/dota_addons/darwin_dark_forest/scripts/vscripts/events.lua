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
    CustomNetTables:SetTableValue( "player_perk", tostring(nPlayerId), GameMode.vPlayerPerk[nPlayerId] )
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
  
   if keys.entindex_attacker==nil then
       return
   end

   local hKilledUnit = EntIndexToHScript( keys.entindex_killed )
   local hKillerUnit = EntIndexToHScript(keys.entindex_attacker)
   

   local flPercentage=0.5 --野怪进化点数 比例
   local flPlayerPercentage=0.09 --玩家进化点数 吸取比例

   --如果玩家击杀野怪，把野怪的进化点赋给玩家
   if  hKilledUnit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then

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
   end

    --如果玩家生物被击杀
   if  hKilledUnit:GetOwner() and not hKilledUnit:IsHero() and hKilledUnit:GetOwner().GetPlayerID then
       local nPlayerId = hKilledUnit:GetOwner():GetPlayerID()
       local hHero =  PlayerResource:GetSelectedHeroEntity(nPlayerId)

       local nKillerPlayerId
       local hKillerHero 

       --玩家被 其他队伍的玩家所击杀 标志位
       local bKilledByOtherTeam = false
       
       if hKillerUnit:GetOwner() and  hKillerUnit:GetOwner().GetPlayerID then
          nKillerPlayerId = hKillerUnit:GetOwner():GetPlayerID()
          if nKillerPlayerId~=-1 and PlayerResource:GetTeam(nKillerPlayerId)~=PlayerResource:GetTeam(nPlayerId) then
            hKillerHero =  PlayerResource:GetSelectedHeroEntity(nKillerPlayerId)
            bKilledByOtherTeam=true
          end
       end

       print("nPlayerId"..nPlayerId)
       -- 保证是玩家的主控生物
       if hHero and hHero.hCurrentCreep == hKilledUnit and true~=hHero.hCurrentCreep.bKillByMech then

          --掉落物品
          ItemController:DropItemByChance(hKilledUnit)
                    
          --记录物品
          ItemController:RecordItemsInfo(hHero)

          local flExpLoseRatio = CalculateExpLostRatio(hHero)
          hHero.nCustomExp=hHero.nCustomExp-(vEXP_TABLE[hHero.hCurrentCreep:GetLevel()+1]-vEXP_TABLE[hHero.hCurrentCreep:GetLevel()])*flExpLoseRatio
          
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
            if hHero.hCurrentCreep and hHero.hCurrentCreep:HasModifier("modifier_item_creed_of_omniscience") then
               flExpRatio=flExpRatio*1.2
            end

            if hHero.hCurrentCreep and hHero.hCurrentCreep:HasModifier("modifier_bonus_ring_effect") then
               flExpRatio= flExpRatio*1.5
            end

            local flExp= vCREEP_EXP_TABLE[hKilledUnit:GetLevel()]*flExpRatio 
            
            PlayKillEffectAndSound(nKillerPlayerId)
            --给击杀者 英雄换模型
            hKillerHero:SetOriginalModel(hKillerUnit:GetModelName())
            hKillerHero:SetModel(hKillerUnit:GetModelName())
            
            GainExpAndUpdateRadar(nKillerPlayerId,hKillerHero,flExp)

          end

          hHero:Kill(nil, hKillerUnit)
          

          --重生前的0.1秒 将出身地随机
          Timers:CreateTimer(4.6, function()
                 GameMode:PutStartPositionToRandomPosForTeam(hHero:GetTeamNumber());
              end
          )

           -- 终极进化阶段不能再重生
           if GameRules.bUltimateStage then
              hHero:SetTimeUntilRespawn(99999999999)
           else
              hHero:SetTimeUntilRespawn(5)
           end
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
    print("hSpawnedUnit:GetUnitName()"..hSpawnedUnit:GetUnitName())

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
    --处理生物
    if hSpawnedUnit and hSpawnedUnit.GetUnitName then
        --修正眼睛插到天辉的问题
        if hSpawnedUnit:GetUnitName()=="npc_dota_observer_wards"then
           if hSpawnedUnit.GetTeam and hSpawnedUnit.GetOwner then
              hSpawnedUnit:SetTeam(hSpawnedUnit:GetOwner():GetTeam())
           end
        end
        if hSpawnedUnit:GetUnitName()~="npc_dota_thinker"then
          hSpawnedUnit:SetForwardVector(RandomVector(1))
        end
    end

end



--玩家打字事件
function GameMode:OnPlayerSay(keys) 
 
    local hPlayer = PlayerInstanceFromIndex( keys.userid )
    local hHero = hPlayer:GetAssignedHero()
    local nPlayerId= hHero:GetPlayerID()
    local nSteamID = PlayerResource:GetSteamAccountID( nPlayerId)
    local sText = string.trim( string.lower(keys.text) )

    --为测试模式设置作弊码
    if GameRules:IsCheatMode() or tostring(nSteamID)=="88765185" or tostring(nSteamID)=="135912126" then
        --刷新
        if sText=="refresh" and hHero and hHero.hCurrentCreep then
           hHero.hCurrentCreep:SetMana(hHero.hCurrentCreep:GetMaxMana())
           hHero.hCurrentCreep:SetHealth(hHero.hCurrentCreep:GetMaxHealth())
           for i=1,20 do
                local hAbility=hHero.hCurrentCreep:GetAbilityByIndex(i-1)
                if hAbility then
                   hAbility:EndCooldown()
                end
           end
        end
        --wtf 模式
        if sText=="wtf" and hHero and not hHero.hCurrentCreep:IsNull() then
           hHero.hCurrentCreep:AddNewModifier(hHero.hCurrentCreep, nil, "modifier_zero_cooldown_and_mana_cost", {})
        end

        -- 加闪烁技能
        if sText=="blink" and hHero and not hHero.hCurrentCreep:IsNull() then
           hHero.hCurrentCreep:AddAbility("test_blink")
           hHero.hCurrentCreep:FindAbilityByName("test_blink"):SetLevel(1)
        end
    
        -- 关闭 wtf 模式
        if sText=="unwtf" and hHero and not hHero.hCurrentCreep:IsNull() then
           hHero.hCurrentCreep:RemoveModifierByName("modifier_zero_cooldown_and_mana_cost")
        end

         -- 自杀
        if sText=="suicide" and hHero and not hHero.hCurrentCreep:IsNull() then
           hHero.hCurrentCreep:ForceKill(true)
        end
        
        -- 进化 换模型
        if sText=="evolve" and hHero and not hHero.hCurrentCreep:IsNull() then
            Evolve(nPlayerId,hHero)
        end

        -- 进化二号测试员
        if sText=="evolve enemy" then
            local hHandlingHero = PlayerResource:GetPlayer(1):GetAssignedHero()
            local nHandlingPlayerId = 1
            Evolve(nHandlingPlayerId,hHandlingHero)
        end

        -- 升级
        if string.match(sText,"to%d") and hHero and not hHero.hCurrentCreep:IsNull() then
           local nLevel= tonumber(string.match(sText,"%d+"))
           --给玩家对应等级的经验
           if nLevel>=1 and nLevel<=11 then
             hHero.nCustomExp=vCREEP_EXP_TABLE[nLevel]+1
               --计算等级
             local nNewLevel=CalculateNewLevel(hHero)
             
             --如果升级了 并且不是死亡状态（处理召唤生物杀人）
             if nNewLevel~=hHero.nCurrentCreepLevel and hHero:IsAlive() then
                
                hHero.nCurrentCreepLevel=nNewLevel

                Evolve(nPlayerId,hHero)

                --进化完了播放升级粒子特效
                local nLevelUpParticleIndex = ParticleManager:CreateParticle("particles/econ/events/ti6/hero_levelup_ti6_godray.vpcf", PATTACH_ABSORIGIN_FOLLOW, hHero.hCurrentCreep)
                ParticleManager:ReleaseParticleIndex(nLevelUpParticleIndex)
             end
             --更新UI显示
             CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerId),"UpdateRadar", {current_exp=hHero.nCustomExp-vEXP_TABLE[nNewLevel],next_level_need=vEXP_TABLE[nNewLevel+1]-vEXP_TABLE[nNewLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )
             CustomNetTables:SetTableValue( "player_perk", tostring(nPlayerId), GameMode.vPlayerPerk[nPlayerId] )
           end
        end
        --强制进化到某生物
        if string.find(sText,"npc_dota_creature_") == 1 and hHero and not hHero.hCurrentCreep:IsNull() then
            
            
            local hHandlingHero=hHero
            local nHandlingPlayerId=nPlayerId

            if string.find(sText,"enemy") ~= nil then
                
                hHandlingHero = PlayerResource:GetPlayer(1):GetAssignedHero()
                nHandlingPlayerId = 1
                sText = SpliteStr(sText)[1]
            end

            if GameRules.vUnitsKV[sText]==nil then
               print("Invalid creature"..sText)     
               return          
            end


            --经验/基因 设置过去
            local nLevel = GameRules.vUnitsKV[sText].nCreatureLevel

            hHandlingHero.nCustomExp=vEXP_TABLE[nLevel]+1

            GameMode.vPlayerPerk[nHandlingPlayerId][1] = GameRules.vUnitsKV[sText].nElement
            GameMode.vPlayerPerk[nHandlingPlayerId][2] = GameRules.vUnitsKV[sText].nMystery
            GameMode.vPlayerPerk[nHandlingPlayerId][3] = GameRules.vUnitsKV[sText].nDurable
            GameMode.vPlayerPerk[nHandlingPlayerId][4] = GameRules.vUnitsKV[sText].nFury
            GameMode.vPlayerPerk[nHandlingPlayerId][5] = GameRules.vUnitsKV[sText].nDecay
            GameMode.vPlayerPerk[nHandlingPlayerId][6] = GameRules.vUnitsKV[sText].nHunt
    
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nHandlingPlayerId),"UpdateRadar", {current_exp=1,next_level_need=vEXP_TABLE[nLevel+1]-vEXP_TABLE[nLevel],perk_table=GameMode.vPlayerPerk[nHandlingPlayerId] } )
            CustomNetTables:SetTableValue( "player_perk", tostring(nHandlingPlayerId), GameMode.vPlayerPerk[nHandlingPlayerId] )
            
            -- 替换模型
            local hUnit = SpawnUnitToReplaceHero(sText,hHandlingHero,nHandlingPlayerId)
            AddAbilityForUnit(hUnit,nHandlingPlayerId)
        end

        --添加物品
        if string.find(sText,"item_") == 1 and hHero and not hHero.hCurrentCreep:IsNull() then

             local hNewItem =  hHero.hCurrentCreep:AddItemByName(sText)
           
        end
        
        if string.find(sText,"vision") == 1 then
          AddFOWViewer(PlayerResource:GetTeam(nPlayerId), Vector(-3000,-3000,0), 90000, 999999, false)
          AddFOWViewer(PlayerResource:GetTeam(nPlayerId), Vector(-3000,3000,0), 90000, 999999, false)
          AddFOWViewer(PlayerResource:GetTeam(nPlayerId), Vector(3000,-3000,0), 90000, 999999, false)
          AddFOWViewer(PlayerResource:GetTeam(nPlayerId), Vector(3000,3000,0), 90000, 999999, false)
        end

        --开全图
        if string.find(sText,"allvision") == 1 then
          GameRules:GetGameModeEntity():SetFogOfWarDisabled(true)
        end
        --关闭全图
        if string.find(sText,"novision") == 1 then
          GameRules:GetGameModeEntity():SetFogOfWarDisabled(false)
        end

        for i,v in ipairs(GameRules.vAbilitiesTable) do
           if sText==v.sAbilityName then
                local hAbility = hHero.hCurrentCreep:AddAbility(sText)
                hAbility:SetLevel(hAbility:GetMaxLevel())
                break
           end
        end

        -- 微调属性
        if string.match(sText,"element%d") and hHero and not hHero.hCurrentCreep:IsNull() then
            local flValue= tonumber(string.match(sText,"%d+"))
            GameMode.vPlayerPerk[nPlayerId][1] = flValue
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerId),"UpdateRadar", {current_exp=1,next_level_need=vEXP_TABLE[hHero.nCurrentCreepLevel+1]-vEXP_TABLE[hHero.nCurrentCreepLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )
            CustomNetTables:SetTableValue( "player_perk", tostring(nPlayerId), GameMode.vPlayerPerk[nPlayerId] )
        end

        if string.match(sText,"mystery%d") and hHero and not hHero.hCurrentCreep:IsNull() then
            local flValue= tonumber(string.match(sText,"%d+"))
            GameMode.vPlayerPerk[nPlayerId][2] = flValue
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerId),"UpdateRadar", {current_exp=1,next_level_need=vEXP_TABLE[hHero.nCurrentCreepLevel+1]-vEXP_TABLE[hHero.nCurrentCreepLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )
            CustomNetTables:SetTableValue( "player_perk", tostring(nPlayerId), GameMode.vPlayerPerk[nPlayerId] )
        end

        if string.match(sText,"durable%d") and hHero and not hHero.hCurrentCreep:IsNull() then 
            local flValue= tonumber(string.match(sText,"%d+"))
            GameMode.vPlayerPerk[nPlayerId][3] = flValue
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerId),"UpdateRadar", {current_exp=1,next_level_need=vEXP_TABLE[hHero.nCurrentCreepLevel+1]-vEXP_TABLE[hHero.nCurrentCreepLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )
            CustomNetTables:SetTableValue( "player_perk", tostring(nPlayerId), GameMode.vPlayerPerk[nPlayerId] )
        end

        if string.match(sText,"fury%d") and hHero and not hHero.hCurrentCreep:IsNull() then   
            local flValue= tonumber(string.match(sText,"%d+"))
            GameMode.vPlayerPerk[nPlayerId][4] = flValue
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerId),"UpdateRadar", {current_exp=1,next_level_need=vEXP_TABLE[hHero.nCurrentCreepLevel+1]-vEXP_TABLE[hHero.nCurrentCreepLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )
            CustomNetTables:SetTableValue( "player_perk", tostring(nPlayerId), GameMode.vPlayerPerk[nPlayerId] )
        end

        if string.match(sText,"decay%d") and hHero and not hHero.hCurrentCreep:IsNull() then   
            local flValue= tonumber(string.match(sText,"%d+"))
            GameMode.vPlayerPerk[nPlayerId][5] = flValue
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerId),"UpdateRadar", {current_exp=1,next_level_need=vEXP_TABLE[hHero.nCurrentCreepLevel+1]-vEXP_TABLE[hHero.nCurrentCreepLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )
            CustomNetTables:SetTableValue( "player_perk", tostring(nPlayerId), GameMode.vPlayerPerk[nPlayerId] )
        end

        if string.match(sText,"hunt%d") and hHero and not hHero.hCurrentCreep:IsNull() then   
            local flValue= tonumber(string.match(sText,"%d+"))
            GameMode.vPlayerPerk[nPlayerId][6] = flValue
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerId),"UpdateRadar", {current_exp=1,next_level_need=vEXP_TABLE[hHero.nCurrentCreepLevel+1]-vEXP_TABLE[hHero.nCurrentCreepLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )
            CustomNetTables:SetTableValue( "player_perk", tostring(nPlayerId), GameMode.vPlayerPerk[nPlayerId] )
        end

        --杀地图全部的生物
        if string.find(sText,"killall") == 1 then
            local vEnemies = FindUnitsInRadius(PlayerResource:GetTeam(nPlayerId), Vector(0,0,0), nil, 100000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL,  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
            for _,hEnemy in pairs(vEnemies) do
               local DamageInfo =
               {
                 victim = hEnemy,
                 attacker = hHero.hCurrentCreep,
                 ability = nil,
                 damage = 1000000,
                 damage_type = DAMAGE_TYPE_PHYSICAL,
               }
               ApplyDamage( DamageInfo )
            end
        end
        --汇报地图生物的属性值 %d为玩家ID
        if string.match(sText,"report%d") then
          local nReportPlayerID= tonumber(string.match(sText,"%d+"))
          if PlayerResource:IsValidPlayer( nReportPlayerID ) and PlayerResource:GetSelectedHeroEntity (nReportPlayerID) then
              local hHero=PlayerResource:GetPlayer(nReportPlayerID):GetAssignedHero()
              Notifications:Top(nPlayerId,{text = "-------------"..hHero.hCurrentCreep:GetUnitName().."----------", duration = 10})
              Notifications:Top(nPlayerId,{text = "Elemet "..GameMode.vPlayerPerk[nReportPlayerID][1].."----------", duration = 10})
              Notifications:Top(nPlayerId,{text = "Mystery"..GameMode.vPlayerPerk[nReportPlayerID][2].."----------", duration = 10})
              Notifications:Top(nPlayerId,{text = "Durable"..GameMode.vPlayerPerk[nReportPlayerID][3].."----------", duration = 10})
              Notifications:Top(nPlayerId,{text = "Fury   "..GameMode.vPlayerPerk[nReportPlayerID][4].."----------", duration = 10})
              Notifications:Top(nPlayerId,{text = "Decay  "..GameMode.vPlayerPerk[nReportPlayerID][5].."----------", duration = 10})
              Notifications:Top(nPlayerId,{text = "Hunt   "..GameMode.vPlayerPerk[nReportPlayerID][6].."----------", duration = 10})             
          end
        end
        --汇报玩家控制的生物
        if string.match(sText,"reportname") then
          for i=0,24 do
            if PlayerResource:IsValidPlayer( i ) and PlayerResource:GetSelectedHeroEntity (i) then
              local hHero=PlayerResource:GetPlayer(i):GetAssignedHero()
              Notifications:Top(nPlayerId,{text = i.."-------------"..hHero.hCurrentCreep:GetUnitName().." Level:"..hHero.hCurrentCreep:GetLevel(), duration = 10})            
             end
          end
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
    local flExpLoseRatio = 0.5

    if  GameRules.nAverageLevel  and hHero.hCurrentCreep and not hHero.hCurrentCreep:IsNull()  then
        
        if hHero.hCurrentCreep:GetLevel() >= GameRules.nAverageLevel+2 then
           flExpLoseRatio=0.5
        end

        if hHero.hCurrentCreep:GetLevel() == GameRules.nAverageLevel+1 then
           flExpLoseRatio=0.4
        end

        if hHero.hCurrentCreep:GetLevel() == GameRules.nAverageLevel then
           flExpLoseRatio=0.3
        end

        if hHero.hCurrentCreep:GetLevel() == GameRules.nAverageLevel-1 then
           flExpLoseRatio=0.15
        end

        if hHero.hCurrentCreep:GetLevel() == GameRules.nAverageLevel-2 then
           flExpLoseRatio=0.05
        end

        if hHero.hCurrentCreep:GetLevel() <= GameRules.nAverageLevel-3 then
           flExpLoseRatio=0
        end
        
        --10级生物固定经验损失
        if hHero.hCurrentCreep:GetLevel()==10 then
            flExpLoseRatio=0.35    
        end
        if hHero.hCurrentCreep:GetLevel()==11 then
            flExpLoseRatio=0.01
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
        CustomNetTables:SetTableValue( "player_creature_index", tostring(nPlayerID), {creepIndex=hHero.hCurrentCreep:GetEntityIndex(),creepName=hHero.hCurrentCreep:GetUnitName()} )
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
           flDuration=3.5
        end

        if hHero.hCurrentCreep:GetLevel() == GameRules.nAverageLevel-1 then
           flDuration=5
        end

        if hHero.hCurrentCreep:GetLevel() == GameRules.nAverageLevel-2 then
           flDuration=7
        end

        if hHero.hCurrentCreep:GetLevel() <= GameRules.nAverageLevel-3 then
           flDuration=9
        end
        
    end

    return  flDuration
end
