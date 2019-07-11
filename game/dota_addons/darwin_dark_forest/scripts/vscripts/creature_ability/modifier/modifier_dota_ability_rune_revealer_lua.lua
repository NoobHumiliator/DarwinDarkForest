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
		self.fTimeCreated = GameRules:GetGameTime()
		local fWarningTime = 15
		self.fFXExpireTime = self.fTimeCreated + fWarningTime
		
		local nRadius = 400
		local vOverheadPos = self:GetParent():GetAbsOrigin() + Vector( 0, 0, 100 )

		self.nTimerFX = ParticleManager:CreateParticle( "particles/essence_treasure_timer.vpcf", PATTACH_ABSORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( self.nTimerFX, 1, Vector( math.floor( fWarningTime ), 0, 0 ) )
		ParticleManager:SetParticleControl( self.nTimerFX, 2, Vector( nRadius, 0, - nRadius / fWarningTime ) )

		EmitSoundOnLocationForAllies( self:GetParent():GetAbsOrigin(), "Gem.Spawn_Warning", self:GetParent() )
		self:StartIntervalThink( 0.5 )
	end
end

function modifier_dota_ability_rune_revealer_lua:OnIntervalThink()
	if IsServer() then
        
        --判断是否已经生成神符
        if self.fFXExpireTime then
           if  GameRules:GetGameTime() >= self.fFXExpireTime then
		     ParticleManager:DestroyParticle( self.nTimerFX, false )
		     GameRules.RuneSpawner:SpawnRune(self:GetParent())
		     self.fFXExpireTime=nil
		   end
		else
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
end
