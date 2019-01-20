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
    Evolve(nPlayerId,hHero)
end

function GameMode:OnEntityKilled(keys)

   local hKilledUnit = EntIndexToHScript( event.entindex_killed )
   local hKillerUnit = EntIndexToHScript(keys.entindex_attacker)
   local nPlayerId = hKillerUnit:GetOwner():GetPlayerID()
   local hHero =  PlayerResource:GetSelectedHeroEntity(nPlayerId)

   local flPercentage=0.5 --进化经验值

   --如果玩家击杀野怪，把野怪的进化点赋给玩家
   if  hKilledUnit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then

       --消除野怪户籍
       NeutralSpawner.nCreaturesNumber=NeutralSpawner.nCreaturesNumber+1
       if  hKilledUnit:GetAttackCapability()==0 then --无攻击力的为0级怪物
         NeutralSpawner.vCreatureLevelMap[0]=vCreatureLevelMap[0]-1
       else
         NeutralSpawner.vCreatureLevelMap[hKilledUnit:GetLevel()]=vCreatureLevelMap[hKilledUnit:GetLevel()]-1
       end
       
       local nElement = GameRules.vUnitsKV[hKilledUnit:GetUnitName()].nElement
       GameMode.vPlayerPerk[nPlayerId][1]=GameMode.vPlayerPerk[nPlayerId][1]+ math.ceil(nElement*flPercentage)
       
       local nMystery = GameRules.vUnitsKV[hKilledUnit:GetUnitName()].nMystery
       GameMode.vPlayerPerk[nPlayerId][1]=GameMode.vPlayerPerk[nPlayerId][2]+ math.ceil(nMystery*flPercentage)
    
       local nDurable = GameRules.vUnitsKV[hKilledUnit:GetUnitName()].nDurable
       GameMode.vPlayerPerk[nPlayerId][1]=GameMode.vPlayerPerk[nPlayerId][3]+ math.ceil(nDurable*flPercentage)
       
       local nFury = GameRules.vUnitsKV[hKilledUnit:GetUnitName()].nFury
       GameMode.vPlayerPerk[nPlayerId][1]=GameMode.vPlayerPerk[nPlayerId][4]+ math.ceil(nFury*flPercentage)

       local nDecay = GameRules.vUnitsKV[hKilledUnit:GetUnitName()].nDecay
       GameMode.vPlayerPerk[nPlayerId][1]=GameMode.vPlayerPerk[nPlayerId][5]+ math.ceil(nDecay*flPercentage)
       
       local nHunt = GameRules.vUnitsKV[hKilledUnit:GetUnitName()].nHunt
       GameMode.vPlayerPerk[nPlayerId][1]=GameMode.vPlayerPerk[nPlayerId][6]+ math.ceil(nHunt*flPercentage)
       
       CustomNetTables:SetTableValue( "player_perk", tostring(nPlayerId), GameMode.vPlayerPerk[nPlayerId] )
       
       --收割灵魂例子特效
       local nSoulParticle = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_necro_souls_hero.vpcf", PATTACH_POINT_FOLLOW, hKillerUnit)
       ParticleManager:SetParticleControlEnt(nSoulParticle, 0, hKilledUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", hKillerUnit:GetAbsOrigin(), true)
       ParticleManager:SetParticleControlEnt(nSoulParticle, 1, hKillerUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", hKillerUnit:GetAbsOrigin(), true)
       
       --给玩家经验
       local nCreepExp=vCREEP_EXP_TABLE[hKilledUnit.nCreatureLevel] 
       hHero.nCustomExp=hHero.nCustomExp+nCreepExp
       
       CustomNetTables:SetTableValue( "player_exp", tostring(nPlayerId), {hHero.nCustomExp} )

       --计算等级
       local nNewLevel=1
       for i, v in ipairs(vEXP_TABLE) do
           if  hHero.nCustomExp>vEXP_TABLE[i]  and   hHero.nCustomExp<vEXP_TABLE[i+1]  then
               nNewLevel=i
               break
           end
       end
       --如果升级了 进化
       if nNewLevel~=hKillerUnit.nCreatureLevel then
          Evolve(nPlayerId,hHero)
       end

   end


end

