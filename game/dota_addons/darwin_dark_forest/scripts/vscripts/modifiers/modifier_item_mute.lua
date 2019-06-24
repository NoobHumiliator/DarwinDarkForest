modifier_item_mute = class({})


-----------------------------------------------------------------------------------
function modifier_item_mute:IsHidden()
	return false
end
--------------------------------------------------------------------------------
function modifier_item_mute:IsPermanent()
	return true
end
--------------------------------------------------------------------------------
function modifier_item_mute:IsPurgable()
	return false
end
--------------------------------------------------------------------------------
function modifier_item_mute:IsDebuff()
	return true
end
--------------------------------------------------------------------------------
function modifier_item_mute:GetTexture()
	return "item_nullifier"
end
--------------------------------------------------------------------------------
function modifier_item_mute:OnCreated()
	if IsServer() then
	   self:StartIntervalThink(1)
    end
end
--------------------------------------------------------------------------------
function modifier_item_mute:CheckState()
	local state =
		{
			[MODIFIER_STATE_MUTED] = true
		}
	return state
end
---------------------------------------------------------------------------------
function modifier_item_mute:OnIntervalThink()

	if IsServer() then
		local bHasTeamMateItem=false

		if self:GetParent().GetOwner and self:GetParent():GetOwner() then
			local nPlayerId = self:GetParent():GetOwner():GetPlayerID()
		    local hHero =  PlayerResource:GetSelectedHeroEntity(nPlayerId)

		    for i=0,11 do --遍历物品
		        local hItem = hHero.hCurrentCreep:GetItemInSlot(i)		      
		        if hItem then
		            if hItem:GetPurchaser()~=hHero then
		            	bHasTeamMateItem=true
		            end
		        end
		    end
		end

		if  not bHasTeamMateItem then
			self:Destroy()
		end
    end
end
