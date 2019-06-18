LinkLuaModifier( "modifier_bonus_ring_thinker", "modifiers/modifier_bonus_ring_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bonus_ring_effect", "modifiers/modifier_bonus_ring_effect", LUA_MODIFIER_MOTION_NONE )


--[奖励区域生成器]

if BonusRing == nil then
  BonusRing = {}
  BonusRing.__index = BonusRing
end


function BonusRing:Init()
    
    ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(ItemController, "OnGameRulesStateChange"), self)

end



function BonusRing:OnGameRulesStateChange()

  local newState = GameRules:State_Get()
  if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    BonusRing:Begin()
  end

end

function BonusRing:Begin()
         
    --PVE模式不出奖励环 5分钟刷新一次

    --if not GameRules.bPveMap then
        Timers:CreateTimer(5, function()
            BonusRing:SpawnRing()
            return 60
        end)
    --end
end


--计算中心点
function BonusRing:FindRingCenter()

    local maxTry = 10
    local vRandomPos = GetRandomValidPosition()
    local vCenter = Vector(0,0,0)

    while (vRandomPos - vCenter):Length2D() > 5000 do
        vRandomPos =GetRandomValidPosition()
        maxTry = maxTry - 1
        if maxTry <= 0 then
            vRandomPos =GetRandomValidPosition()
            break
        end
    end
    return vRandomPos
end



--产生奖励区域
function BonusRing:SpawnRing()
  
    --EmitGlobalSound( "Hero_Disruptor.KineticField" )

    local vCenter=BonusRing:FindRingCenter()
    local nRadius= 850
    local nDuration = 60
     
    BonusRing.nParticleIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_kineticfield.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(BonusRing.nParticleIndex, 0, vCenter)
    ParticleManager:SetParticleControl(BonusRing.nParticleIndex, 1, Vector(nRadius, 1, 1))
    ParticleManager:SetParticleControl(BonusRing.nParticleIndex, 2, Vector(nDuration, 0, 0))

    --显示视野
    for nTeam = 0, (DOTA_TEAM_COUNT-1) do
          AddFOWViewer(nTeam, vCenter, 850, nDuration, false)
    end

    local hThinker = CreateModifierThinker( nil, nil, "modifier_bonus_ring_thinker", { duration = nDuration,radius=nRadius }, vCenter, DOTA_TEAM_NEUTRALS, false )
    local hDummy = CreateUnitByName( "npc_dota_ring_dummy", vCenter, false, nil, nil, DOTA_TEAM_NEUTRALS )
    hDummy:AddNewModifier(nil,nil,"modifier_kill",{duration=nDuration})  --设置强制死亡时间
    
    CustomGameEventManager:Send_ServerToAllClients( "ring_spawned", {})

    for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
        if PlayerResource:IsValidPlayer( nPlayerID ) then
          local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
          if hHero then
             hHero:EmitSound("Hero_Disruptor.KineticField" )
          end
        end
    end

end
