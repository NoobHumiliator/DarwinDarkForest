
modifier_item_armlet_lua_buff = class({})

function modifier_item_armlet_lua_buff:IsHidden()
	return false
end
----------------------------------------
function modifier_item_armlet_lua_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
----------------------------------------
function modifier_item_armlet_lua_buff:IsDebuff()
  return false
end
----------------------------------------
function modifier_item_armlet_lua_buff:GetTexture()
  return "item_armlet_active"
end
----------------------------------------

function modifier_item_armlet_lua_buff:OnCreated( kv )
	if IsServer() then
      self.unholy_bonus_health = self:GetAbility():GetSpecialValueFor( "unholy_bonus_health" )
      self.flHealSum=0 --开臂章的治疗量
      self:StartIntervalThink( 0.1 )
    end
end
---------------------------------------------
function modifier_item_armlet_lua_buff:OnIntervalThink()
	if IsServer() then
		if self.flHealSum<self.unholy_bonus_health then
    	   AddHealthBonusNoRatio(self:GetCaster(),83.4)
    	   self.flHealSum=self.flHealSum+83.4
        end
        ApplyDamage({
          victim    = self:GetCaster(),
          attacker  = self:GetCaster(),
          ability   =  self:GetAbility(),
          damage    = self:GetAbility():GetSpecialValueFor( "unholy_health_drain_per_second_tooltip" )/10,
          damage_type = DAMAGE_TYPE_PURE,
          damage_flags = DOTA_DAMAGE_FLAG_HPLOSS+DOTA_DAMAGE_FLAG_NON_LETHAL
        })    
	end
end
---------------------------------------------

function modifier_item_armlet_lua_buff:OnDestroy()
    if IsServer() then
    	RemoveHealthBonusNoRatio(self:GetCaster(),self.unholy_bonus_health)
    end
end


---------------------------------------------

function modifier_item_armlet_lua_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

----------------------------------------


function modifier_item_armlet_lua_buff:GetModifierPreAttack_BonusDamage( params )
	return self:GetAbility():GetSpecialValueFor( "unholy_bonus_damage" )
end

-------------------------------------------
function modifier_item_armlet_lua_buff:GetModifierPhysicalArmorBonus( params )
	return self:GetAbility():GetSpecialValueFor( "unholy_bonus_armor" )
end