
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

        -- 接近进化
        if sText=="near" and hHero and not hHero.hCurrentCreep:IsNull() then
           hHero.nCustomExp=vEXP_TABLE[11]-1
           local nNewLevel=10
           CustomNetTables:SetTableValue( "player_info", tostring(nPlayerId), {current_exp=hHero.nCustomExp-vEXP_TABLE[nNewLevel],next_level_need=vEXP_TABLE[nNewLevel+1]-vEXP_TABLE[nNewLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] })
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
             hHero.nCustomExp=vEXP_TABLE[nLevel]+1
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
             CustomNetTables:SetTableValue( "player_info", tostring(nPlayerId), {current_exp=hHero.nCustomExp-vEXP_TABLE[nNewLevel],next_level_need=vEXP_TABLE[nNewLevel+1]-vEXP_TABLE[nNewLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )
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

            CustomNetTables:SetTableValue( "player_info", tostring(nHandlingPlayerId), {current_exp=1,next_level_need=vEXP_TABLE[nLevel+1]-vEXP_TABLE[nLevel],perk_table=GameMode.vPlayerPerk[nHandlingPlayerId] } )

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
            CustomNetTables:SetTableValue( "player_info", tostring(nHandlingPlayerId), {current_exp=1,next_level_need=vEXP_TABLE[hHero.nCurrentCreepLevel+1]-vEXP_TABLE[hHero.nCurrentCreepLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )
        end

        if string.match(sText,"mystery%d") and hHero and not hHero.hCurrentCreep:IsNull() then
            local flValue= tonumber(string.match(sText,"%d+"))
            GameMode.vPlayerPerk[nPlayerId][2] = flValue
            CustomNetTables:SetTableValue( "player_info", tostring(nHandlingPlayerId), {current_exp=1,next_level_need=vEXP_TABLE[hHero.nCurrentCreepLevel+1]-vEXP_TABLE[hHero.nCurrentCreepLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )
        end

        if string.match(sText,"durable%d") and hHero and not hHero.hCurrentCreep:IsNull() then 
            local flValue= tonumber(string.match(sText,"%d+"))
            GameMode.vPlayerPerk[nPlayerId][3] = flValue
            CustomNetTables:SetTableValue( "player_info", tostring(nHandlingPlayerId), {current_exp=1,next_level_need=vEXP_TABLE[hHero.nCurrentCreepLevel+1]-vEXP_TABLE[hHero.nCurrentCreepLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )       
        end
        
        if string.match(sText,"fury%d") and hHero and not hHero.hCurrentCreep:IsNull() then   
            local flValue= tonumber(string.match(sText,"%d+"))
            GameMode.vPlayerPerk[nPlayerId][4] = flValue
            CustomNetTables:SetTableValue( "player_info", tostring(nHandlingPlayerId), {current_exp=1,next_level_need=vEXP_TABLE[hHero.nCurrentCreepLevel+1]-vEXP_TABLE[hHero.nCurrentCreepLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )       
        end

        if string.match(sText,"decay%d") and hHero and not hHero.hCurrentCreep:IsNull() then   
            local flValue= tonumber(string.match(sText,"%d+"))
            GameMode.vPlayerPerk[nPlayerId][5] = flValue
            CustomNetTables:SetTableValue( "player_info", tostring(nHandlingPlayerId), {current_exp=1,next_level_need=vEXP_TABLE[hHero.nCurrentCreepLevel+1]-vEXP_TABLE[hHero.nCurrentCreepLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )
        end

        if string.match(sText,"hunt%d") and hHero and not hHero.hCurrentCreep:IsNull() then   
            local flValue= tonumber(string.match(sText,"%d+"))
            GameMode.vPlayerPerk[nPlayerId][6] = flValue
            CustomNetTables:SetTableValue( "player_info", tostring(nHandlingPlayerId), {current_exp=1,next_level_need=vEXP_TABLE[hHero.nCurrentCreepLevel+1]-vEXP_TABLE[hHero.nCurrentCreepLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )       
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

        --上传快照
        if string.match(sText,"snap") then
           local vSnap=Snapshot:GenerateSnapShot(nPlayerId)
           Server:UploadSnapLog(vSnap,"test")
        end

    end

end
