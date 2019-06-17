
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
    self:Begin()
  end

end

function BonusRing:Begin()
         
    --PVE模式不出奖励环
    if not GameRules.bPveMap then
        Timers:CreateTimer(180, function()
            BonusRing:SpawnRing()
            return 180
        end)
    end
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

    local vCenter=BonusRing:FindRingCenter()
    local nRadius= 800
    local nDuration = 60
     
    BonusRing.nParticleIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_kineticfield.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(BonusRing.nParticleIndex, 0, vCenter)
    ParticleManager:SetParticleControl(BonusRing.nParticleIndex, 1, Vector(nRadius, 1, 1))
    ParticleManager:SetParticleControl(BonusRing.nParticleIndex, 2, Vector(nDuration, 0, 0))
    
    local hThinker = CreateModifierThinker( nil, nil, "modifier_bonus_thinker", { duration = nDuration }, vCenter, DOTA_TEAM_NEUTRALS, false )

end
