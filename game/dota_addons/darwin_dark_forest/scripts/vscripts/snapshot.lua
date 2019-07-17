--游戏快照，用于上传日志到服务器分析平衡性
if Snapshot == nil then Snapshot = class({}) end


function Snapshot:CreateSnapShot(nPlayerID)
    
   local vSanpInfo ={}

   local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )

   vSanpInfo.sItems=""

   for i=0,11 do --遍历物品
      local hCurrentItem = hHero.hCurrentCreep:GetItemInSlot(i)
      if hCurrentItem then
        vSanpInfo.sItems = vSanpInfo.sItems..hCurrentItem:GetName()
      end
   end

   vSanpInfo.sAbilities=""

   for i=0,20 do
        local hAbility=hHero.hCurrentCreep:GetAbilityByIndex(i)
        if hAbility then
           vSanpInfo.sAbilities = vSanpInfo.sAbilities..hAbility:GetAbilityName()
           vSanpInfo.sAbilities = ":"..vSanpInfo.sAbilities..hAbility:GetLevel()
        end
    end

    vSanpInfo.sPerks=""
    
    local vPerkNameMap={"Element:","Mystery:","Durable:","Fury:","Decay:","Hunt:"}

    for i=1,6 do
        vSanpInfo.sPerks=vSanpInfo.sPerks..vPerkNameMap[i]..GameMode.vPlayerPerk[nPlayerID][i]
    end

    vSanpInfo.sSteamID=PlayerResource:GetSteamAccountID(nPlayerID)

    vSanpInfo.sUnitName=hHero.hCurrentCreep:GetUnitName()


end