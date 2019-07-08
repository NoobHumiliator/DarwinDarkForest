item_hurricane_pike_lua = class({})
LinkLuaModifier( "modifier_item_hurricane_pike_lua", "item_ability/modifier/modifier_item_hurricane_pike_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_hurricane_pike_lua_ally", "item_ability/modifier/modifier_item_hurricane_pike_lua_ally", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_hurricane_pike_lua_self", "item_ability/modifier/modifier_item_hurricane_pike_lua_self", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_hurricane_pike_lua_enemy", "item_ability/modifier/modifier_item_hurricane_pike_lua_enemy", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_hurricane_pike_lua_buff", "item_ability/modifier/modifier_item_hurricane_pike_lua_buff", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function item_hurricane_pike_lua:GetIntrinsicModifierName()
	return "modifier_item_hurricane_pike_lua"
end

--------------------------------------------------------------------------------
function item_hurricane_pike_lua:OnSpellStart()
	if not IsServer() then return end
	local ability = self
	local target = self:GetCursorTarget()
	local duration = 0.4

	if self:GetCaster():GetTeamNumber() == target:GetTeamNumber() then
		EmitSoundOn("DOTA_Item.ForceStaff.Activate", target)
		target:AddNewModifier(self:GetCaster(), ability, "modifier_item_hurricane_pike_lua_ally", {duration = duration })
	else
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	
		target:AddNewModifier(self:GetCaster(), ability, "modifier_item_hurricane_pike_lua_enemy", {duration = duration})
		self:GetCaster():AddNewModifier(target, ability, "modifier_item_hurricane_pike_lua_self", {duration = duration})
		local buff = self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_item_hurricane_pike_lua_buff", {duration = ability:GetSpecialValueFor("range_duration")})
		buff.target = target
		buff:SetStackCount(ability:GetSpecialValueFor("max_attacks"))
		EmitSoundOn("DOTA_Item.ForceStaff.Activate", target)
		EmitSoundOn("DOTA_Item.ForceStaff.Activate", self:GetCaster())
		
		local startAttack = {
			UnitIndex = self:GetCaster():entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = target:entindex(),}
		ExecuteOrderFromTable(startAttack)

	end
end