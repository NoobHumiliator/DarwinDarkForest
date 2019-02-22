modifier_venomancer_ward_root = class ({})

--------------------------------------------------------------------------------

function modifier_venomancer_ward_root:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_venomancer_ward_root:IsHidden()
	return true
end


--------------------------------------------------------------------------------

function modifier_venomancer_ward_root:CheckState()
	local state =
	{
		[MODIFIER_STATE_ROOTED] = true,
	}
	return state
end


