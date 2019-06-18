modifier_bonus_ring_thinker = class({})



function modifier_bonus_ring_thinker:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( FrameTime() )
		self.radius=kv.radius
	end
end


function modifier_bonus_ring_thinker:OnIntervalThink()
	if IsServer() then
		local vUnits = FindUnitsInRadius(DOTA_TEAM_NEUTRALS,self:GetParent():GetOrigin(),nil,self.radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER,false)
	    for _,vUnit in ipairs(vUnits) do
	    	if not vUnit:HasModifier("modifier_bonus_ring_effect") then
                local hModifier = vUnit:AddNewModifier(self:GetParent(), nil, "modifier_bonus_ring_effect", {x=self:GetParent():GetOrigin().x,y=self:GetParent():GetOrigin().y,z=self:GetParent():GetOrigin().z,radius=self.radius})    
	    	    hModifier.hThinker = self
	    	end
	    end
	end
end
