modifier_item_hurricane_pike_lua_enemy = modifier_item_hurricane_pike_lua_enemy or class({})

function modifier_item_hurricane_pike_lua_enemy:IsDebuff() return false end
function modifier_item_hurricane_pike_lua_enemy:IsHidden() return true end
function modifier_item_hurricane_pike_lua_enemy:IsPurgable() return false end
function modifier_item_hurricane_pike_lua_enemy:IsStunDebuff() return false end
function modifier_item_hurricane_pike_lua_enemy:IsMotionController()  return true end
function modifier_item_hurricane_pike_lua_enemy:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end
function modifier_item_hurricane_pike_lua_enemy:IgnoreTenacity()	return true end

function modifier_item_hurricane_pike_lua_enemy:OnCreated()
	if not IsServer() then return end
	
	self.pfx = ParticleManager:CreateParticle("particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:GetParent():StartGesture(ACT_DOTA_FLAIL)
	self:StartIntervalThink(FrameTime())
	self.angle = (self:GetCaster():GetForwardVector()-self:GetParent():GetForwardVector()):Normalized()
	self.distance = self:GetAbility():GetSpecialValueFor("enemy_length") / ( self:GetDuration() / FrameTime())
end

function modifier_item_hurricane_pike_lua_enemy:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end

function modifier_item_hurricane_pike_lua_enemy:OnIntervalThink()
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_hurricane_pike_lua_enemy:HorizontalMotion(unit, time)
	if not IsServer() then return end
	local pos = unit:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(pos, 80, false)
	local pos_p = self.angle * self.distance
	local next_pos = GetGroundPosition(pos + pos_p,unit)
	unit:SetAbsOrigin(next_pos)
end