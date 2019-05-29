
LinkLuaModifier("modifier_item_ghost_lua", "item_ability/modifier/modifier_item_ghost_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_ghost_lua_buff", "item_ability/modifier/modifier_item_ghost_lua_buff", LUA_MODIFIER_MOTION_NONE)

item_ghost_lua	= class({})

------------------------
-- GHOST SCEPTER BASE --
------------------------

function item_ghost_lua:GetIntrinsicModifierName()
	return "modifier_item_ghost_lua"
end

function item_ghost_lua:OnSpellStart()
	self.caster		= self:GetCaster()
	self.duration	=	self:GetSpecialValueFor("duration")
	if not IsServer() then return end
	self.caster:EmitSound("DOTA_Item.GhostScepter.Activate")
	self.caster:AddNewModifier(self.caster, self, "modifier_item_ghost_lua_buff", {duration = self.duration})
end