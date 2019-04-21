local vMysteryTopLeft= {x=-6830,y=7637 }
local vMysteryDownRight= {x=2416,y=-1412}
local vElementTopLeft= {x=1125,y=-200}
local vElementDownRight= {x=6000,y=-6000}
local vDurableTopLeft= {x=-2190,y=7825}
local vDurableDownRight= {x=4620,y=222}

local vFuryTopLeft_1= {x=1078,y=7899}
local vFuryDownRight_1= {x=5883,y=1410}
local vFuryTopLeft_2= {x=5883,y=6909}
local vFuryDownRight_2= {x=8211,y=-5400}


local vDecayTopLeft= {x=-8051,y=1980}
local vDecayDownRight= {x=476,y=-5165}

local vHuntTopLeft= {x=-4914,y=2900}
local vHuntDownRight= {x=3357,y=-2000}



if NeutralSpawner == nil then
  NeutralSpawner = {}
  NeutralSpawner.__index = NeutralSpawner
end

function NeutralSpawner:Init()
  
  for sUnitName, _ in pairs(GameRules.vUnitsKV) do
    PrecacheUnitByNameAsync(sUnitName, function() end)
  end

  self.nCreaturesNumber = 0
  self.vCreatureLevelMap = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  self.vCreatureLevelMap[0]=0

  self.flTimeInterval = 0.5 --刷怪间隔

  ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(NeutralSpawner, "OnGameRulesStateChange"), self)


end


function NeutralSpawner:OnGameRulesStateChange()
  local newState = GameRules:State_Get()
  
  if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    self:Begin()
  end
end

function NeutralSpawner:Begin()
         
    --根据间隔刷怪
    Timers:CreateTimer(1, function()
        NeutralSpawner:SpawnOneCreature()
        --print("NeutralSpawner.nCreaturesNumber"..NeutralSpawner.nCreaturesNumber)
        --print("NeutralSpawner.flTimeInterval"..NeutralSpawner.flTimeInterval)
        if NeutralSpawner.nCreaturesNumber<100 then
           NeutralSpawner.flTimeInterval=NeutralSpawner.flTimeInterval/2
           --位置最小刷怪间隔 防止太卡
           if NeutralSpawner.flTimeInterval<0.1 then
              NeutralSpawner.flTimeInterval=0.1
           end
        else
           NeutralSpawner.flTimeInterval=NeutralSpawner.flTimeInterval*2
           --设置一个最大刷怪间隔
           if NeutralSpawner.flTimeInterval>20 then
              NeutralSpawner.flTimeInterval=20
           end
        end

      return NeutralSpawner.flTimeInterval
    end)

end


function NeutralSpawner:SpawnOneCreature()
   -- 先找到队伍平均等级
   local nTotalLevel = 0
   local nTotalHero = 0

   for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
      if PlayerResource:IsValidPlayer( nPlayerID ) then
        local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
        if hHero==nil then
          nTotalLevel=nTotalLevel+1
        else
          nTotalLevel=nTotalLevel+hHero.nCurrentCreepLevel 
        end
        nTotalHero=nTotalHero+1
      end
   end

   local nAverageLevel = math.floor(nTotalLevel/nTotalHero + 0.5) --四舍五入
   
   --比例
   local vLevelRatio ={}
   vLevelRatio["courier"]=0.55 --这是信使的比例
  --key是与玩家等级差距 value是比例
   vLevelRatio[-3]=0.05
   vLevelRatio[-2]=0.08
   vLevelRatio[-1]=0.12
   vLevelRatio[0]=0.09
   vLevelRatio[1]=0.05
   vLevelRatio[2]=0.03
   vLevelRatio[3]=0.02
   vLevelRatio[4]=0.01


   --1级 调高信使比例
   if nAverageLevel==1 then
      vLevelRatio["courier"]=0.80
   end

   --2级 调高信使比例
   if nAverageLevel==2 then
      vLevelRatio["courier"]=0.68
   end
   
   --3级 调高信使比例
   if nAverageLevel==3 then
      vLevelRatio["courier"]=0.60
   end


   if nAverageLevel==7 then
     vLevelRatio[-3]=0.05
     vLevelRatio[-2]=0.09
     vLevelRatio[-1]=0.13
     vLevelRatio[0]=0.10
     vLevelRatio[1]=0.05
     vLevelRatio[2]=0.02
     vLevelRatio[3]=0.01
     vLevelRatio[4]=0.00
   end

   
   if nAverageLevel==8 then
     vLevelRatio[-3]=0.05
     vLevelRatio[-2]=0.09
     vLevelRatio[-1]=0.13
     vLevelRatio[0]=0.09
     vLevelRatio[1]=0.05
     vLevelRatio[2]=0.02
     vLevelRatio[3]=0.01
     vLevelRatio[4]=0.00
   end

   if nAverageLevel==9 then
      vLevelRatio[-3]=0.05
      vLevelRatio[-2]=0.12
      vLevelRatio[-1]=0.15
      vLevelRatio[0]=0.09
      vLevelRatio[1]=0.03
      vLevelRatio[2]=0.01
      vLevelRatio[3]=0.00
      vLevelRatio[4]=0.00
   end

   if nAverageLevel==10 then
      vLevelRatio[-3]=0.05
      vLevelRatio[-2]=0.13
      vLevelRatio[-1]=0.17
      vLevelRatio[0]=0.07
      vLevelRatio[1]=0.03
      vLevelRatio[2]=0.00
      vLevelRatio[3]=0.00
      vLevelRatio[4]=0.00
   end 


   --print("Player's Average Level is:"..nAverageLevel)
   local vTemp={} --随机池

   --优先保证信使数量
   if self.nCreaturesNumber==0  or self.vCreatureLevelMap[0]/(self.nCreaturesNumber) <= vLevelRatio["courier"]  then --第一只怪或者信使不足   先信使里面刷
       for sUnitName,vData in pairs(GameRules.vUnitsKV) do
           --print(vData)
           if vData and type(vData) == "table" and vData.AttackCapabilities=="DOTA_UNIT_CAP_NO_ATTACK" then
             if vData.IsSummoned==nil or vData.IsSummoned==0 then
               table.insert(vTemp, sUnitName)
             end
           end
       end
   else 
        --从队伍平均等级 +4 到 -3 倒叙遍历 (保证高等级怪物的即时补充)
        for i=nAverageLevel+4,nAverageLevel-3,-1 do
             --如果某个等级怪物不足 补足此等级怪物
             --print("Ratio"..self.vCreatureLevelMap[i]/(self.nCreaturesNumber).."i"..i)
             if  self.vCreatureLevelMap[i]/(self.nCreaturesNumber) <= vLevelRatio[i-nAverageLevel] then
                 for sUnitName,vData in pairs(GameRules.vUnitsKV) do
                     if vData and type(vData) == "table" then
                         if vData.IsSummoned==nil or vData.IsSummoned==0 then
                             if vData.nCreatureLevel==i then
                                table.insert(vTemp, sUnitName)
                             end
                         end
                     end
                 end
                 if #vTemp>0 then
                   --print("To Spawn Creature Level:"..i)
                   break
                 end
             end
        end
   end
   
   --- 刷怪逻辑
   if #vTemp>0 then
      local sUnitName=vTemp[RandomInt(1, #vTemp)]
      local vRandomPos = GetRandomValidPositionForCreature(GameRules.vUnitsKV[sUnitName])
      
      local hUnit = CreateUnitByName(sUnitName, vRandomPos, true, nil, nil, DOTA_TEAM_NEUTRALS)
      
      for i=1,20 do
        local hAbility=hUnit:GetAbilityByIndex(i-1)
        if hAbility and GameRules.vUnitsKV[sUnitName].AbilitiesLevel then
           local nLevel= tonumber(SpliteStr(GameRules.vUnitsKV[sUnitName].AbilitiesLevel)[i])
           hAbility:SetLevel(nLevel)
        end
      end

      -- evolve island util
      AddTinyBody(hUnit)
      hUnit:SetNightTimeVisionRange(1000)
      hUnit:SetDayTimeVisionRange(1800)
      ItemController:CreateItemForNeutraulByChance(hUnit)

      FindClearSpaceForUnit(hUnit, vRandomPos, true)
      --设置生物等级
      hUnit.nCreatureLevel=GameRules.vUnitsKV[sUnitName].nCreatureLevel
      --登记单位数量
      self.vCreatureLevelMap[hUnit.nCreatureLevel] = self.vCreatureLevelMap[hUnit.nCreatureLevel]+1
      self.nCreaturesNumber=self.nCreaturesNumber+1
   end

end




function GetRandomValidPositionForCreature( vData )
   
    local vType = {}
    
    if vData.nMystery>0 then
        table.insert(vType, 1)
    end

    if vData.nElement>0 then
        table.insert(vType, 2)
    end
    
    if vData.nDurable>0 then
        table.insert(vType, 3)
    end

    if vData.nFury>0 then
        table.insert(vType, 4)
    end

    if vData.nDecay>0 then
        table.insert(vType, 5)
    end

    if vData.nHunt>0 then
        table.insert(vType, 6)
    end
    
    if #vType>0 then
       
       local nDice=RandomInt(1, #vType)
       local nType = vType[nDice]

       if nType==1 then
          return GetRandomValidPosition(vMysteryTopLeft,vMysteryDownRight)
       end
       if nType==2 then
          return GetRandomValidPosition(vElementTopLeft,vElementDownRight)
       end
       if nType==3 then
          return GetRandomValidPosition(vDurableTopLeft,vDurableDownRight)
       end 
       if nType==4 then
           if RandomInt(1, 2) == 1 then
              return GetRandomValidPosition(vFuryTopLeft_1,vFuryDownRight_1)
           else
              return GetRandomValidPosition(vFuryTopLeft_2,vFuryDownRight_2)
           end
       end
       if nType==5 then
          return GetRandomValidPosition(vDecayTopLeft,vDecayDownRight)
       end
       if nType==6 then
          return GetRandomValidPosition(vHuntTopLeft,vHuntDownRight)
       end

    else
       return GetRandomValidPosition()
    end

end

