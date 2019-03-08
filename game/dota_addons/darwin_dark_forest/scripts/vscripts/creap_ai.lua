LinkLuaModifier( "modifier_neutral_passive", "modifiers/modifier_neutral_passive", LUA_MODIFIER_MOTION_NONE )

nWalkingMoveSpeed=140


function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

    if thisEntity:GetLevel() then
		local nLevel= thisEntity:GetLevel()
		thisEntity:SetHullRadius(5+nLevel*3)  --体型跟随等级线性增加 8到35
	end


    -- 对玩家无效
    if thisEntity:GetTeam()~=DOTA_TEAM_NEUTRALS then
       return
    end

    thisEntity:SetAcquisitionRange(540)
    
    --是否正在追击
    thisEntity.bChasing=false


    --保存初始移动速度
    thisEntity.nOriginalMovementSpeed=thisEntity:GetBaseMoveSpeed()
    --降低移动速度
    thisEntity:SetBaseMoveSpeed(nWalkingMoveSpeed)

    thisEntity:AddNewModifier(thisEntity, nil, "modifier_neutral_passive", {})

	thisEntity:SetContextThink( "CreepThink", CreepThink, 0.5 )
end

function CreepThink()

    if thisEntity.vWaypoints==nil then

	    thisEntity.vWaypoints = {}
	    --画一个漫步的行走方向
	    local currentWayPoint = thisEntity:GetAbsOrigin()
		while #thisEntity.vWaypoints < 10 do
			local waypoint = currentWayPoint + RandomVector( RandomFloat( 0, 2048 ) )
			if GridNav:CanFindPath( thisEntity:GetAbsOrigin(), waypoint ) then
				table.insert( thisEntity.vWaypoints, waypoint )
				currentWayPoint=waypoint
			end
		end
		
	end

    if not thisEntity:IsAlive() then
		return
	end
	if GameRules:IsGamePaused() then
		return 0.1
	end
	local agro = CheckIfHasAggro()
	if agro then
		return agro
	end
	return RoamBetweenWaypoints()

end


function CheckIfHasAggro()

	--如果有追击目标
	if thisEntity:GetAggroTarget() ~= nil then
		--尝试释放技能
         CastAbility(thisEntity:GetAggroTarget())
        --切换追击状态 此时视为被玩家捅了一下
        if not thisEntity.bChasing then
        	thisEntity.bChasing=true
        	thisEntity:SetBaseMoveSpeed( thisEntity.nOriginalMovementSpeed )
            thisEntity.flLastHitTime =  GameRules:GetGameTime();   
        end
		--还原移动速度
        --如果四秒不受玩家反击，或者丢失玩家视野
		if (  thisEntity.flLastHitTime and ( GameRules:GetGameTime() - thisEntity.flLastHitTime >4 ) ) or not thisEntity:CanEntityBeSeenByMyTeam(thisEntity:GetAggroTarget())   then
	 		thisEntity.bChasing=false
	 		thisEntity:SetBaseMoveSpeed( nWalkingMoveSpeed )
	 		return RetreatFromUnit(thisEntity:GetAggroTarget())
		end
	else
		--恢复步行速度
		thisEntity:SetBaseMoveSpeed(nWalkingMoveSpeed)
		return nil
	end
end
-------------------------------------------------------------------

function ContainsValue(nSum,nValue)

	if bit:_and(nSum,nValue)==nValue then
        return true
    else
    	return false
    end

end


-------------------------------------------------------------------

function CastAbility(hTarget)

    for i=1,20 do
        local hAbility=thisEntity:GetAbilityByIndex(i-1)
        if  hAbility and not hAbility:IsPassive() and hAbility:IsFullyCastable() then
        	--目标类技能
        	if ContainsValue(hAbility:GetBehavior(),DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) then
        		--对敌人使用的目标技能
        		if ContainsValue(hAbility:GetAbilityTargetTeam(),DOTA_UNIT_TARGET_TEAM_ENEMY) or ContainsValue(hAbility:GetAbilityTargetTeam(),DOTA_UNIT_TARGET_TEAM_CUSTOM) then
					    ExecuteOrderFromTable({
							UnitIndex = thisEntity:entindex(),
							OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
							AbilityIndex = hAbility:entindex(),
					        TargetIndex = hTarget:entindex()
						})
						return hAbility:GetCastPoint()+RandomFloat(0.1, 0.3)
                end
                -- 对自己释放的目标技能（此处忽略野怪之间互相buff）
                if ContainsValue(hAbility:GetAbilityTargetTeam(),DOTA_UNIT_TARGET_TEAM_FRIENDLY) then
					    ExecuteOrderFromTable({
							UnitIndex = thisEntity:entindex(),
							OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
							AbilityIndex = hAbility:entindex(),
					        TargetIndex = thisEntity:entindex()
						})
				    return hAbility:GetCastPoint()+RandomFloat(0.1, 0.3)
                end
        	end

        	--点技能
        	if ContainsValue(hAbility:GetBehavior(),DOTA_ABILITY_BEHAVIOR_POINT) then
        		--伤害类技能 对敌人扔
				local vLeadingOffset = hTarget:GetForwardVector() * RandomInt( 100, 300 )
                local vTargetPos = hTarget:GetOrigin() + vLeadingOffset
			    ExecuteOrderFromTable({
					UnitIndex = thisEntity:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					Position =  vTargetPos,
					AbilityIndex = hAbility:entindex(),
				})
				return hAbility:GetCastPoint()+RandomFloat(0.1, 0.3)
        	end

        	--无目标技能 直接乱放
        	if ContainsValue(hAbility:GetBehavior(),DOTA_ABILITY_BEHAVIOR_NO_TARGET) then
    				
			    ExecuteOrderFromTable({
					UnitIndex = thisEntity:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = hAbility:entindex(),
				})
				return hAbility:GetCastPoint()+RandomFloat(0.1, 0.3)
        	end

        end
    end

end

--------------------------------------------------------------------

function RetreatFromUnit(hUnit)

	local vAwayFromEnemy = thisEntity:GetOrigin() - hUnit:GetOrigin()
	vAwayFromEnemy = vAwayFromEnemy:Normalized()
	local vMoveToPos = thisEntity:GetOrigin() + vAwayFromEnemy * nWalkingMoveSpeed*1.75

	-- if away from enemy is an unpathable area, find a new direction to run to
	local nAttempts = 0
	while ( ( not GridNav:CanFindPath( thisEntity:GetOrigin(), vMoveToPos ) ) and ( nAttempts < 5 ) ) do
		vMoveToPos = thisEntity:GetOrigin() + RandomVector( nWalkingMoveSpeed*1.75 )
		nAttempts = nAttempts + 1
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vMoveToPos,
	})
 
    thisEntity:SetAggroTarget(nil)

	return 1.75
end
--------------------------------------------------------------------------------
-- RoamBetweenWaypoints
--------------------------------------------------------------------------------
function RoamBetweenWaypoints()
	local flGameTime = GameRules:GetGameTime()

	if thisEntity.targetWayPoint ~= nil then
		local flRoamTimeLeft = thisEntity.flNextWaypointTime - flGameTime
		--如果到了 游荡时间 或者抵达目的地 换目标点
		if flRoamTimeLeft <= 0 or (thisEntity.targetWayPoint-thisEntity:GetAbsOrigin()):Length2D()<100 then
			thisEntity.targetWayPoint = nil
		end
	end
	if thisEntity.targetWayPoint == nil then
	   thisEntity.targetWayPoint = thisEntity.vWaypoints[ RandomInt( 1, #thisEntity.vWaypoints ) ]
	   thisEntity.flNextWaypointTime = flGameTime + RandomFloat( 2, 4 ) * thisEntity:GetLevel() --高级怪多走两步
	   thisEntity:MoveToPositionAggressive( thisEntity.targetWayPoint )
	end
	return RandomFloat( 0.5, 1.0 )
end
