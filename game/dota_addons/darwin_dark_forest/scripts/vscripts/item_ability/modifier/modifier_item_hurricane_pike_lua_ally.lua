modifier_item_hurricane_pike_lua_ally = modifier_item_hurricane_pike_lua_ally or class({})

function modifier_item_hurricane_pike_lua_ally:IsDebuff() return false end
function modifier_item_hurricane_pike_lua_ally:IsHidden() return true end
function modifier_item_hurricane_pike_lua_ally:IsPurgable() return false end
function modifier_item_hurricane_pike_lua_ally:IsStunDebuff() return false end
function modifier_item_hurricane_pike_lua_ally:IsMotionController()  return true end
function modifier_item_hurricane_pike_lua_ally:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end
function modifier_item_hurricane_pike_lua_ally:IgnoreTenacity()	return true end

function modifier_item_hurricane_pike_lua_ally:OnCreated()
	if not IsServer() then return end
	
	self.pfx = ParticleManager:CreateParticle("particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:GetParent():StartGesture(ACT_DOTA_FLAIL)
	self:StartIntervalThink(FrameTime())
	self.angle = self:GetParent():GetForwardVector():Normalized()
	self.distance = self:GetAbility():GetSpecialValueFor("push_length") / ( self:GetDuration() / FrameTime())
end

function modifier_item_hurricane_pike_lua_ally:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end

function modifier_item_hurricane_pike_lua_ally:OnIntervalThink()
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_hurricane_pike_lua_ally:HorizontalMotion(unit, time)
	if not IsServer() then return end
	local pos = unit:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(pos, 80, false)
	local pos_p = self.angle * self.distance
	local next_pos = GetGroundPosition(pos + pos_p,unit)
	unit:SetAbsOrigin(next_pos)
end