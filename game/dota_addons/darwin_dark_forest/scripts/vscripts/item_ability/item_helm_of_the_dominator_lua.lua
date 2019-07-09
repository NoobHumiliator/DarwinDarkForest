item_helm_of_the_dominator_lua = class({})
LinkLuaModifier( "modifier_item_helm_of_the_dominator_lua", "item_ability/modifier/modifier_item_helm_of_the_dominator_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_helm_of_the_dominator_lua_aura_effect", "item_ability/modifier/modifier_item_helm_of_the_dominator_lua_aura_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_helm_of_the_dominator_lua:GetIntrinsicModifierName()
	return "modifier_item_helm_of_the_dominator_lua"
end

--------------------------------------------------------------------------------

function item_helm_of_the_dominator_lua:CastFilterResultTarget(hTarget)
	if IsServer() then 
		local hCaster = self:GetCaster()

        if hTarget:GetTeamNumber()==hCaster:GetTeamNumber() then
			return UF_FAIL_FRIENDLY
		end

		if hTarget:GetLevel()>hCaster:GetLevel()-2 then
			return UF_FAIL_OTHER
		end
	end
end




function item_helm_of_the_dominator_lua:OnSpellStart()
	if IsServer() then
		local hTarget = self:GetCursorTarget()
		hTarget:SetOwner(self:GetCaster())
		hTarget:EmitSound("Hero_Chen.HolyPersuasionEnemy")
		hTarget:SetTeam(self:GetCaster():GetTeam())
		hTarget:SetControllableByPlayer(self:GetCaster():GetMainControllingPlayer(), false)
		--恢复移动速度
		if  hTarget.nOriginalMovementSpeed then
		   hTarget:SetBaseMoveSpeed( hTarget.nOriginalMovementSpeed )
		end
		hTarget:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration=self:GetSpecialValueFor( "duration" )})
	end
end
