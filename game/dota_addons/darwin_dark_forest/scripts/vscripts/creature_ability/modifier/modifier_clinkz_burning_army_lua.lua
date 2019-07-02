modifier_clinkz_burning_army_lua =  class({})

function modifier_clinkz_burning_army_lua:IsDebuff()	
	return false 
end

function modifier_clinkz_burning_army_lua:IsHidden() 				
	return true
end

function modifier_clinkz_burning_army_lua:IsPurgable() 				
	return false 
end


function modifier_clinkz_burning_army_lua:OnCreated()
	if IsServer() then
		self.cloud_bolt_interval = self:GetAbility():GetSpecialValueFor( "cloud_bolt_interval" )
		self.cloud_bolt_damage = self:GetAbility():GetSpecialValueFor( "cloud_bolt_damage" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	    self:StartIntervalThink( self.cloud_bolt_interval )
	end
end


function modifier_clinkz_burning_army_lua:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
			MODIFIER_EVENT_ON_ATTACKED,
		}
	return decFuns
end

function modifier_clinkz_burning_army_lua:GetModifierIncomingDamage_Percentage()
	return -100
end

function modifier_clinkz_burning_army_lua:CheckState()
	local state =
		{
			[MODIFIER_STATE_ROOTED] = true,
			[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		}
	return state
end

function modifier_clinkz_burning_army_lua:OnAttacked( keys )
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local egg = self:GetParent()
	local attacker = keys.attacker

	if keys.target ~= egg then
		return
	end

	if  egg:GetHealth()<=1 then
		egg:Kill(ability, attacker)
	else
		egg:SetHealth( egg:GetHealth()-1 )
	end
end