--[[ events.lua ]]
LinkLuaModifier( "modifier_zero_cooldown_and_mana_cost", "modifiers/modifier_zero_cooldown_and_mana_cost", LUA_MODIFIER_MOTION_NONE )

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
	if nNewState == DOTA_GAMERULES_STATE_PRE_GAME then

     GameRules.vPlayerSteamIdMap={}
   
     local nValidPlayerNumber= 0

     for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
       if PlayerResource:IsValidPlayer( nPlayerID ) then
          nValidPlayerNumber = nValidPlayerNumber+1
          local nPlayerSteamId = PlayerResource:GetSteamAccountID(nPlayerID)
          GameRules.sValidePlayerSteamIds=GameRules.sValidePlayerSteamIds..nPlayerSteamId..","
          GameRules.vPlayerSteamIdMap[nPlayerSteamId]=nPlayerID
       end
     end
     
     if string.sub(GameRules.sValidePlayerSteamIds,string.len(GameRules.sValidePlayerSteamIds))=="," then   --去掉最后一个逗号
        GameRules.sValidePlayerSteamIds=string.sub(GameRules.sValidePlayerSteamIds,0,string.len(GameRules.sValidePlayerSteamIds)-1)
     end

     if nValidPlayerNumber==1 then
         GameRules.bPveMap=true
     end
     Server:GetPlayerEconData()

	end

	if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
      
     --记录游戏开始的时间
     GameRules.nGameStartTime=GameRules:GetGameTime()
     
     local econData = CustomNetTables:GetTableValue("econ_data", "econ_data")

     PrintTable(econData)
     --给玩家装上饰品
     for sPlayerSteamID,vPlayerInfo in pairs(econData) do
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
              if v.type=="Skin" and v.equip=="true" then
                  Econ:EquipSkinEcon(v.name,nPlayerID)
              end
          end
      end

	end
end

function GameMode:OnPlayerPickHero(keys)
 
    local hHero = EntIndexToHScript(keys.heroindex)
    local nPlayerId=keys.player-1

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
    Evolve(nPlayerId,hHero)
end

function GameMode:OnEntityKilled(keys)
  
   if keys.entindex_attacker==nil then
       return
   end

   local hKilledUnit = EntIndexToHScript( keys.entindex_killed )
   local hKillerUnit = EntIndexToHScript(keys.entindex_attacker)
   

   local flPercentage=0.5 --进化点数 比例

   --如果玩家击杀野怪，把野怪的进化点赋给玩家
   if  hKilledUnit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then

       local nPlayerId = hKillerUnit:GetMainControllingPlayer()
       local hHero =  PlayerResource:GetSelectedHeroEntity(nPlayerId)

       --Todo 播放击杀特效，到时候挪走
       if hHero.sCurrentKillEffect then
            Econ:PlayKillEffect(hHero.sCurrentKillEffect,hHero)
       end
       
       --掉落物品
       ItemController:DropItemByChance(hKilledUnit)

       --消除野怪户口 (先确保被击杀单位不是野怪的召唤生物)      
       if hKilledUnit.nCreatureLevel then
           NeutralSpawner.nCreaturesNumber=NeutralSpawner.nCreaturesNumber-1
           NeutralSpawner.vCreatureLevelMap[hKilledUnit.nCreatureLevel]=NeutralSpawner.vCreatureLevelMap[hKilledUnit.nCreatureLevel]-1
       end

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
        --收割灵魂例子特效 白色特效
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

       --排序选出最大的两个
       for _,v in pairs(tempPerksColorMap) do
         if v.value>0 then 
           local nSoulParticle = ParticleManager:CreateParticle("particles/absorb_particle/absorb_"..v.color..".vpcf", PATTACH_POINT_FOLLOW, hKillerUnit)
           ParticleManager:SetParticleControlEnt(nSoulParticle, 0, hKilledUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", hKillerUnit:GetAbsOrigin(), true)
           ParticleManager:SetParticleControlEnt(nSoulParticle, 1, hKillerUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", hKillerUnit:GetAbsOrigin(), true)
         end
       end

       --给玩家经验
       if hKilledUnit.nCreatureLevel then
         hHero.nCustomExp=hHero.nCustomExp+vCREEP_EXP_TABLE[hKilledUnit.nCreatureLevel] 
       else
         hHero.nCustomExp=hHero.nCustomExp+vCREEP_EXP_TABLE[hKilledUnit:GetLevel()] 
       end
       
       --计算等级
       local nNewLevel=CalculateNewLevel(hHero)
       
       --如果升级了 进化
       if nNewLevel~=hHero.nCurrentCreepLevel then
          hHero.nCurrentCreepLevel=nNewLevel
          LevelUpAndEvolve(nPlayerId,hHero)
       end
       --更新UI显示
       CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerId),"UpdateRadar", {current_exp=hHero.nCustomExp-vEXP_TABLE[nNewLevel],next_level_need=vEXP_TABLE[nNewLevel+1]-vEXP_TABLE[nNewLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )
       CustomNetTables:SetTableValue( "player_perk", tostring(nPlayerId), GameMode.vPlayerPerk[nPlayerId] )


   end

    --如果玩家生物被击杀，损失经验 换出生点 换模型
   if  hKilledUnit:GetOwner() and not hKilledUnit:IsHero() and hKilledUnit:GetOwner() and hKilledUnit:GetOwner().GetPlayerID then
       local nPlayerId = hKilledUnit:GetOwner():GetPlayerID()
       local hHero =  PlayerResource:GetSelectedHeroEntity(nPlayerId)
       -- 保证是玩家的主控生物
       if hHero.hCurrentCreep == hKilledUnit and true~=hHero.hCurrentCreep.bKillByMech then

          --掉落物品
          ItemController:DropItemByChance(hKilledUnit)
                    
          --记录物品
          ItemController:RecordItemsInfo(hHero)

          local nPlayerId = hKilledUnit:GetOwner():GetPlayerID()
          local hHero =  PlayerResource:GetSelectedHeroEntity(nPlayerId)
           hHero.nCustomExp=hHero.nCustomExp-(vEXP_TABLE[hHero.hCurrentCreep:GetLevel()+1]-vEXP_TABLE[hHero.hCurrentCreep:GetLevel()])*0.5
           --保证不是负数
           if hHero.nCustomExp<1 then
              hHero.nCustomExp=1
           end
           --击杀英雄
           hHero:Kill(nil, hKillerUnit)
           GameMode:PutStartPositionToRandomPosForTeam(hHero:GetTeamNumber());

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

    --播放进化声音
    EmitSoundOn('General.LevelUp.Bonus',hHero) 

    GameMode:PutStartPositionToLocation(hHero,hHero:GetAbsOrigin())
    Evolve(nPlayerId,hHero)

    --进化完了播放升级粒子特效
    local nLevelUpParticleIndex = ParticleManager:CreateParticle("particles/econ/events/ti6/hero_levelup_ti6_godray.vpcf", PATTACH_ABSORIGIN_FOLLOW, hHero.hCurrentCreep)
    ParticleManager:ReleaseParticleIndex(nLevelUpParticleIndex)


end


--英雄重生
function GameMode:OnNPCSpawned( event )

    local hSpawnedUnit = EntIndexToHScript( event.entindex )
    print("hSpawnedUnit:GetUnitName()"..hSpawnedUnit:GetUnitName())

    --如果已经初始化过 （是复生 而不是第一次选出来）
    if hSpawnedUnit:IsHero() and hSpawnedUnit.nCurrentCreepLevel then
        local nPlayerId = hSpawnedUnit:GetOwner():GetPlayerID()
        --将镜头定位到重生英雄，然后放开
        PlayerResource:SetCameraTarget(nPlayerId,hSpawnedUnit)

        Timers:CreateTimer({ endTime = 0.5, 
            callback = function()
              PlayerResource:SetCameraTarget(nPlayerId,nil) 
            end
        })

        --计算等级
        local nNewLevel=CalculateNewLevel(hSpawnedUnit)
        hSpawnedUnit.nCurrentCreepLevel=nNewLevel
        
        Evolve(nPlayerId,hSpawnedUnit)
    end
     
    --设置一个随机的位置
    if hSpawnedUnit and hSpawnedUnit.GetUnitName then
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
    if bTEST_MODE and not IsDedicatedServer() then
        --刷新
        if sText=="re" and hHero and hHero.hCurrentCreep then
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
        
        -- 进化 换模型
        if sText=="evolve" and hHero and not hHero.hCurrentCreep:IsNull() then
            Evolve(nPlayerId,hHero)
        end
        -- 升级
        if string.match(sText,"to%d") and hHero and not hHero.hCurrentCreep:IsNull() then
           local nLevel= tonumber(string.match(sText,"%d+"))
           --给玩家对应等级的经验
           if nLevel>=1 and nLevel<=10 then
             hHero.nCustomExp=vCREEP_EXP_TABLE[nLevel]+1
               --计算等级
             local nNewLevel=CalculateNewLevel(hHero)
             
             --如果升级了 并且不是死亡状态（处理召唤生物杀人）
             if nNewLevel~=hHero.nCurrentCreepLevel and hHero:IsAlive() then
                
                --播放进化声音
                EmitSoundOn('General.LevelUp.Bonus',hHero) 

                GameMode:PutStartPositionToLocation(hHero,hHero:GetAbsOrigin())
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
            
            if GameRules.vUnitsKV[sText]==nil then
               print("Invalid creature"..sText)     
               return          
            end
            --经验/基因 设置过去
            local nLevel = GameRules.vUnitsKV[sText].nCreatureLevel

            hHero.nCustomExp=vEXP_TABLE[nLevel]+1

            GameMode.vPlayerPerk[nPlayerId][1] = GameRules.vUnitsKV[sText].nElement
            GameMode.vPlayerPerk[nPlayerId][2] = GameRules.vUnitsKV[sText].nMystery
            GameMode.vPlayerPerk[nPlayerId][3] = GameRules.vUnitsKV[sText].nDurable
            GameMode.vPlayerPerk[nPlayerId][4] = GameRules.vUnitsKV[sText].nFury
            GameMode.vPlayerPerk[nPlayerId][5] = GameRules.vUnitsKV[sText].nDecay
            GameMode.vPlayerPerk[nPlayerId][6] = GameRules.vUnitsKV[sText].nHunt
    
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerId),"UpdateRadar", {current_exp=1,next_level_need=vEXP_TABLE[nLevel+1]-vEXP_TABLE[nLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )
            CustomNetTables:SetTableValue( "player_perk", tostring(nPlayerId), GameMode.vPlayerPerk[nPlayerId] )
            
            GameMode:PutStartPositionToLocation(hHero,hHero:GetAbsOrigin())

            -- 替换模型
            local hUnit = SpawnUnitToReplaceHero(sText,hHero,nPlayerId)
            AddAbilityForUnit(hUnit,nPlayerId)

            local hModel = hUnit:FirstMoveChild()
            local vWearables={}

            while hModel ~= nil do

                  if hModel ~= nil and hModel:GetClassname() == "dota_item_wearable"then
                      table.insert(vWearables, hModel)
                  end
                  hModel = hModel:NextMovePeer()
            end

            for _,v in pairs(vWearables) do
                  print(v:GetModelName())
                  v:RemoveSelf()
            end
            
            local hTorso = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/lich/lich_immortal/lich_immortal.vmdl"})
            hTorso:FollowEntity(hUnit, true)

            

        end

        --添加物品
        if string.find(sText,"item_") == 1 and hHero and not hHero.hCurrentCreep:IsNull() then

             local hNewItem =  hHero.hCurrentCreep:AddItemByName(sText)
           
        end

    end


end