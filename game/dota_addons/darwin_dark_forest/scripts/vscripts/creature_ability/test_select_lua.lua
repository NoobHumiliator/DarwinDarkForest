test_select_lua = class({})
--------------------------------------------------------------------------------

function test_select_lua:OnSpellStart()

	if IsServer() then

      local hTarget = self:GetCursorTarget()
      local hCaster = self:GetCaster()

      local nPlayerID = hCaster:GetOwner():GetPlayerID()
      
      hCaster:SetCursorCastTarget(hTarget)

      --CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID),"UpdateSelect", {creepIndex= hTargetHero.hCurrentCreep:GetEntityIndex()} )            
    end
end
