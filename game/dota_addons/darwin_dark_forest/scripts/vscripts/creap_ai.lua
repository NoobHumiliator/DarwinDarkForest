LinkLuaModifier( "modifier_neutral_passive", "modifiers/modifier_neutral_passive", LUA_MODIFIER_MOTION_NONE )

nWalkingMoveSpeed=140


function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end
    -- 对玩家无效
    if thisEntity:GetTeam()~=DOTA_TEAM_NEUTRALS then
       return
    end

    thisEntity:SetAcquisitionRange(600)
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
		while #thisEntity.vWaypoints < 10 do
			local waypoint = thisEntity:GetAbsOrigin() + RandomVector( RandomFloat( 0, 2048 ) )
			if GridNav:CanFindPath( thisEntity:GetAbsOrigin(), waypoint ) then
				table.insert( thisEntity.vWaypoints, waypoint )
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
		--还原移动速度
		print("thisEntity:GetAggroTarget()"..thisEntity:GetAggroTarget():GetUnitName())
		thisEntity:SetBaseMoveSpeed( thisEntity.nOriginalMovementSpeed )
        --如果四秒不受玩家反击，或者丢失玩家视野
		if (  thisEntity.flLastHitTime and ( GameRules:GetGameTime() - thisEntity.flLastHitTime >4 ) ) or not thisEntity:CanEntityBeSeenByMyTeam(thisEntity:GetAggroTarget())   then
	 		return RetreatFromUnit(thisEntity:GetAggroTarget())
		end
	else
		--恢复步行速度
		thisEntity:SetBaseMoveSpeed(nWalkingMoveSpeed)
		return nil
	end
end
--------------------------------------------------------------------

function RetreatFromUnit(hUnit)


	local vAwayFromEnemy = thisEntity:GetOrigin() - hUnit:GetOrigin()
	vAwayFromEnemy = vAwayFromEnemy:Normalized()
	local vMoveToPos = thisEntity:GetOrigin() + vAwayFromEnemy * nWalkingMoveSpeed

	-- if away from enemy is an unpathable area, find a new direction to run to
	local nAttempts = 0
	while ( ( not GridNav:CanFindPath( thisEntity:GetOrigin(), vMoveToPos ) ) and ( nAttempts < 5 ) ) do
		vMoveToPos = thisEntity:GetOrigin() + RandomVector( thisEntity:GetIdealSpeed() )
		nAttempts = nAttempts + 1
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vMoveToPos,
	})
 
    thisEntity:SetAggroTarget(nil)

	return 1.25
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
