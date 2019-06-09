modifier_item_bogduggs_lucky_femur = class({})

--------------------------------------------------------------------------------

function modifier_item_bogduggs_lucky_femur:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_bogduggs_lucky_femur:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_bogduggs_lucky_femur:OnCreated( kv )
	self.mana_regen_penalty = self:GetAbility():GetSpecialValueFor( "mana_regen_penalty" )
	self.refresh_pct = self:GetAbility():GetSpecialValueFor( "refresh_pct" )
end

--------------------------------------------------------------------------------

function modifier_item_bogduggs_lucky_femur:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------


function modifier_item_bogduggs_lucky_femur:OnAbilityFullyCast( params )
	if IsServer() then
		if params.unit ~= self:GetParent() then
			return 0
		end
		local Ability = params.ability
		if Ability == nil then
			return 0
		end

		if Ability:IsRefreshable() and Ability:IsItem() == false and RollPercentage( self.refresh_pct ) then
			Ability:EndCooldown()
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1, 2, 1 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
			EmitSoundOn( "Bogduggs.LuckyFemur", self:GetParent() )
		end
	end
	return 0
end

--------------------------------------------------------------------------------

function modifier_item_bogduggs_lucky_femur:GetModifierConstantManaRegen( params )
	return -self.mana_regen_penalty
end
