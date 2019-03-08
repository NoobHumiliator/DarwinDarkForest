function AddTinyBody(hUnit)

    if hUnit:GetUnitName()=="npc_dota_creature_tiny_02" then
        local hTorso = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_02/tiny_02_body.vmdl"})
        hTorso:FollowEntity(hUnit, true)
        local hHead = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_02/tiny_02_head.vmdl"})
        hHead:FollowEntity(hUnit, true)
        local hLeft_arm = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_02/tiny_02_left_arm.vmdl"})
        hLeft_arm:FollowEntity(hUnit, true)
        local hRight_arm = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_02/tiny_02_right_arm.vmdl"})
        hRight_arm:FollowEntity(hUnit, true)
    end

    if hUnit:GetUnitName()=="npc_dota_creature_tiny_03" then
        local hTorso = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_03/tiny_03_body.vmdl"})
        hTorso:FollowEntity(hUnit, true)
        local hHead = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_03/tiny_03_head.vmdl"})
        hHead:FollowEntity(hUnit, true)
        local hLeft_arm = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_03/tiny_03_left_arm.vmdl"})
        hLeft_arm:FollowEntity(hUnit, true)
        local hRight_arm = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_03/tiny_03_right_arm.vmdl"})
        hRight_arm:FollowEntity(hUnit, true)
    end

    if hUnit:GetUnitName()=="npc_dota_creature_tiny_04" then
        local hTorso = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_04/tiny_04_body.vmdl"})
        hTorso:FollowEntity(hUnit, true)
        local hHead = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_04/tiny_04_head.vmdl"})
        hHead:FollowEntity(hUnit, true)
        local hLeft_arm = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_04/tiny_04_left_arm.vmdl"})
        hLeft_arm:FollowEntity(hUnit, true)
        local hRight_arm = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_04/tiny_04_right_arm.vmdl"})
        hRight_arm:FollowEntity(hUnit, true)
    end
end