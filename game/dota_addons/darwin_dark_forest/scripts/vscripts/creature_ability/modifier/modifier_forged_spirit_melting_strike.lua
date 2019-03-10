modifier_forged_spirit_melting_strike = class({})
--------------------------------------------------------------------------------

function modifier_forged_spirit_melting_strike:IsHidden()
	return true
end

--创建的时候 直接打开自动释放
function modifier_forged_spirit_melting_strike:OnCreated()
	self:GetAbility():ToggleAutoCast()
end


function modifier_forged_spirit_melting_strike:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end


function modifier_forged_spirit_melting_strike:OnAttackLanded(params)
	if IsServer() then
		--如果开启技能
		if self:GetAbility():GetAutoCastState() then
			if self:GetParent() == params.attacker and self:GetParent():GetMana()>=self:GetAbility():GetManaCost(self:GetAbility():GetLevel()) then
				--消耗法力
	            self:GetAbility():PayManaCost()

				local hTarget = params.target
				if hTarget ~= nil then
					local nDuration = self:GetAbility():GetSpecialValueFor( "duration" )
					local hDebuff = hTarget:FindModifierByName( "modifier_forged_spirit_melting_strike_effect" )
					if hDebuff == nil then
						hDebuff = hTarget:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_forged_spirit_melting_strike_effect", { duration = nDuration } )
						if hDebuff ~= nil then
							hDebuff:SetStackCount( 0 )
						end	
					end
					if hDebuff ~= nil then
						hDebuff:SetStackCount( hDebuff:GetStackCount() + 1 )  
						hDebuff:SetDuration( nDuration, true )
					end		
				end
			end
	   end
	end
	return 0 
end
