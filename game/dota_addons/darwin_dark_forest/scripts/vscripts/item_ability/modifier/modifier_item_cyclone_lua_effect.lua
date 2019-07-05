modifier_item_cyclone_lua_effect = class({})

function modifier_item_cyclone_lua_effect:IsDebuff() return false end
function modifier_item_cyclone_lua_effect:IsHidden() return false end
function modifier_item_cyclone_lua_effect:IsPurgable() return true end
function modifier_item_cyclone_lua_effect:IsStunDebuff() return true end
function modifier_item_cyclone_lua_effect:IsMotionController()  return true end
function modifier_item_cyclone_lua_effect:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_item_cyclone_lua_effect:OnCreated()
	self:StartIntervalThink(FrameTime())
	EmitSoundOn("DOTA_Item.Cyclone.Activate", self:GetParent())
	if IsServer() then
		self:GetParent():StartGesture(ACT_DOTA_FLAIL)
		self.angle = self:GetParent():GetAngles()
		self.abs = self:GetParent():GetAbsOrigin()
		self.cyc_pos = self:GetParent():GetAbsOrigin()

		self.pfx_name = "particles/items_fx/cyclone.vpcf"
		self.pfx = ParticleManager:CreateParticle(self.pfx_name, PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 0, self.abs)
	end
end

function modifier_item_cyclone_lua_effect:OnIntervalThink()
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_cyclone_lua_effect:HorizontalMotion(unit, time)
	if not IsServer() then return end
	-- Change the Face Angle
	local angle = self:GetParent():GetAngles()
	local new_angle = RotateOrientation(angle, QAngle(0,20,0))
	self:GetParent():SetAngles(new_angle[1], new_angle[2], new_angle[3])
	if self:GetElapsedTime() <= 0.3 then
		self.cyc_pos.z = self.cyc_pos.z + 50
		self:GetParent():SetAbsOrigin(self.cyc_pos)
	elseif self:GetDuration() - self:GetElapsedTime() < 0.3 then
		self.step = self.step or (self.cyc_pos.z - self.abs.z) / ((self:GetDuration() - self:GetElapsedTime()) / FrameTime())
		self.cyc_pos.z = self.cyc_pos.z - self.step
		self:GetParent():SetAbsOrigin(self.cyc_pos)
	else 
	end
end

function modifier_item_cyclone_lua_effect:OnDestroy()
	StopSoundOn("DOTA_Item.Cyclone.Activate", self:GetParent())
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)

	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	self:GetParent():SetAbsOrigin(self.abs)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
	self:GetParent():SetAngles(self.angle[1], self.angle[2], self.angle[3])
end

function modifier_item_cyclone_lua_effect:CheckState()
	local state =
		{
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		}
	return state
end