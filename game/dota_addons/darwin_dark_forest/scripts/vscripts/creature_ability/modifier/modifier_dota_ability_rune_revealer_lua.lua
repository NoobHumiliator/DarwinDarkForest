modifier_dota_ability_rune_revealer_lua = class({})

--------------------------------------------------------------------------------

function modifier_dota_ability_rune_revealer_lua:IsHidden() return false end
function modifier_dota_ability_rune_revealer_lua:IsPurgable() return false end

--------------------------------------------------------------------------------

function modifier_dota_ability_rune_revealer_lua:CheckState()
	local state = 
	{
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end


function modifier_dota_ability_rune_revealer_lua:OnCreated()
	if IsServer() then
		self:StartIntervalThink( 0.5 )
	end
end

function modifier_dota_ability_rune_revealer_lua:OnIntervalThink()
	if IsServer() then
		local vItems=Entities:FindAllByClassnameWithin("dota_item_drop",self:GetParent():GetAbsOrigin(),200)
		local bValid=false
		for _,hItem in pairs(vItems) do
			local hContainedItem = hItem:GetContainedItem()
			--身边必须有神符 否则摧毁
			if string.find(hContainedItem:GetName(),"item_rune_") == 1 then
               bValid=true
			end

		end
		if not bValid then
		   UTIL_Remove ( self:GetParent() )
		end
	end
end
