local vLevelRatio ={}

vLevelRatio["courier"]=0.35 --这是信使的比例
--key是与玩家等级差距 value是比例 
vLevelRatio[-1]=0.15
vLevelRatio[0]=0.25
vLevelRatio[1]=0.175
vLevelRatio[2]=0.05
vLevelRatio[3]=0.025

if NeutralSpawner == nil then
  NeutralSpawner = {}
  NeutralSpawner.__index = NeutralSpawner
end

function NeutralSpawner:Init()
  
  for sUnitName, _ in pairs(GameRules.vUnitsKV) do
    PrecacheUnitByNameAsync(sUnitName, function() end)
  end

  self.nCreaturesNumber = 0
  self.vCreatureLevelMap = {0,0,0,0,0,0,0,0,0,0}
  self.vCreatureLevelMap[0]=0

  self.flTimeInterval = 1 --刷怪间隔

  ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(NeutralSpawner, "OnGameRulesStateChange"), self)


end


function NeutralSpawner:OnGameRulesStateChange()
  local newState = GameRules:State_Get()
  
  if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    self:Begin()
  end
end

function NeutralSpawner:Begin()
     
    -- 先刷几只压压惊
    --for i=1,50 do
    --   self:SpawnOneCreature()
    --end
    
    --根据间隔刷怪
    Timers:CreateTimer(1, function()
        self:SpawnOneCreature()
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
        nTotalLevel=nTotalLevel+hHero.nCustomLevel
        nTotalHero=nTotalHero+1
      end
   end
   local nAverageLevel = math.floor(nTotalLevel/nTotalHero + 0.5) --四舍五入
   
   --如果一级的话 调高信使比例
   if nAverageLevel==1 then
      vLevelRatio["courier"]=0.5
   else
      vLevelRatio["courier"]=0.35
   end

   --print("Player's Average Level is:"..nAverageLevel)
   local vTemp={} --随机池

   if self.nCreaturesNumber==0  or self.vCreatureLevelMap[0]/(self.nCreaturesNumber) <= vLevelRatio["courier"]  then --第一只怪或者信使不足   先信使里面刷
       for sUnitName,vData in pairs(GameRules.vUnitsKV) do
           --print(vData)
           if vData and type(vData) == "table" and vData.AttackCapabilities=="DOTA_UNIT_CAP_NO_ATTACK" then
              table.insert(vTemp, sUnitName)
           end
       end
   else 
        --从队伍平均等级 -1 到 +3开始遍历 
        for i=nAverageLevel-1,nAverageLevel+3 do
             --如果某个等级怪物不足 补足此等级怪物
             if  self.vCreatureLevelMap[i]/(self.nCreaturesNumber) <= vLevelRatio[i-nAverageLevel] then
                 for sUnitName,vData in pairs(GameRules.vUnitsKV) do
                     if vData and type(vData) == "table" then
                         if vData.nCreatureLevel==i then
                            table.insert(vTemp, sUnitName)
                         end
                     end
                 end
                break
             end
        end
   end

   --- 刷怪逻辑
   if #vTemp>0 then
      local sUnitName=vTemp[RandomInt(1, #vTemp)]
      local vRandomPos = GetRandomValidPosition()
      
      local hUnit = CreateUnitByName(sUnitName, vRandomPos, true, nil, nil, DOTA_TEAM_NEUTRALS)
      FindClearSpaceForUnit(hUnit, vRandomPos, true)
      --设置生物等级
      hUnit.nCreatureLevel=GameRules.vUnitsKV[sUnitName].nCreatureLevel
      --登记单位数量
      self.vCreatureLevelMap[hUnit.nCreatureLevel] = self.vCreatureLevelMap[hUnit.nCreatureLevel]+1
      self.nCreaturesNumber=self.nCreaturesNumber+1
   end

end


