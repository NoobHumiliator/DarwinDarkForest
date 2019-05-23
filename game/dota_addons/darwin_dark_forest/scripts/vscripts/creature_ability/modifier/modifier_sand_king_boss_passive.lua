modifier_sand_king_boss_passive = class({})

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_passive:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_passive:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end
-----------------------------------------------------------------

function modifier_sand_king_boss_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end
-----------------------------------------------------------------
function modifier_sand_king_boss_passive:OnAttackLanded( params )
	if IsServer() then
		if self:GetParent() == params.attacker then
			self.bInAttack = false

			local Target = params.target
			if Target ~= nil then
				local caustic_duration = self:GetAbility():GetSpecialValueFor( "caustic_duration" )
				local hCausticBuff = Target:FindModifierByName( "modifier_sand_king_boss_caustic_finale" )
				if hCausticBuff == nil then
					hCausticBuff = Target:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_sand_king_boss_caustic_finale", { duration = caustic_duration } )
					if hCausticBuff ~= nil then
						hCausticBuff:SetStackCount( 0 )
					end	
				end
				if hCausticBuff ~= nil then
					hCausticBuff:SetStackCount( hCausticBuff:GetStackCount() + 1 )  
					hCausticBuff:SetDuration( caustic_duration, true )
				end		
			end
		end
	end
	return 0 
end

-----------------------------------------------------------------------------------------