item_armlet_lua = class({})
LinkLuaModifier( "modifier_item_armlet_lua", "item_ability/modifier/modifier_item_armlet_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_armlet_lua_buff", "item_ability/modifier/modifier_item_armlet_lua_buff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_armlet_lua:GetIntrinsicModifierName()
	return "modifier_item_armlet_lua"
end

--------------------------------------------------------------------------------


function item_armlet_lua:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		if hCaster:HasModifier("modifier_item_armlet_lua_buff") then
		   hCaster:EmitSound("DOTA_Item.Armlet.DeActivate")
		   hCaster:RemoveModifierByName("modifier_item_armlet_lua_buff")
		else
		   hCaster:EmitSound("DOTA_Item.Armlet.Activate")
		   hCaster:AddNewModifier(hCaster, self, "modifier_item_armlet_lua_buff", {})
		end
	end
end


function item_armlet_lua:GetAbilityTextureName()
  if IsClient() then
    local hCaster = self:GetCaster()
    if hCaster:HasModifier("modifier_item_armlet_lua_buff") then
         return "armlet_active"
    else
         return "item_armlet"
    end
  end
end