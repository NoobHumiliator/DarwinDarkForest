test_double_lua = class({})
--------------------------------------------------------------------------------

function test_double_lua:OnSpellStart()

	if IsServer() then

		ApplyDamage( {
                      victim    = self:GetCaster(),
                      attacker  = self:GetCaster(),
                      damage    = 1000000,
                      damage_type = DAMAGE_TYPE_PURE
                    } )

		ApplyDamage( {
                      victim    = self:GetCursorTarget(),
                      attacker  = self:GetCaster(),
                      damage    = 1000000,
                      damage_type = DAMAGE_TYPE_PURE
                    } )


    end
end
