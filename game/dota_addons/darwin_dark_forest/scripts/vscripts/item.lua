
--[物品控制器，控制物品掉落，继承等规则]


if ItemController == nil then
  ItemController = {}
  ItemController.__index = ItemController
end


function ItemController:Init()
    
    ListenToGameEvent("dota_item_picked_up", Dynamic_Wrap(ItemController, "OnItemPickUp"), self)

    --载入物品
    local vItemsKV = LoadKeyValues('scripts/npc/npc_items_custom.txt')

    -- 携带物品的概率
    self.flItemCarryChance=1
    --掉落物品的概率
    self.flItemDropChance=1
    --玩家掉落物品的概率
    self.flPlayerItemDropChance=0.5

    --二维数组 k 为1-5级物品
    self.vItemsTieTable = {}
    for i=1,6 do
        self.vItemsTieTable[i]={}
    end

    -- 处理物品 kv 首先排序
    local vItems={}
    for sItemName, vData in pairs(vItemsKV) do
        if vData and type(vData) == "table" then
            if vData.ItemCost~=nil and (1~=vData.ItemRecipe)  then
                vData.sItemName=sItemName
                table.insert(vItems,vData)
            end
        end
    end
    -- 按照 物品价格排序
    table.sort(vItems,function(a,b) return a.ItemCost<b.ItemCost end )       

    -- 按照分组加入 
    for i=1,6 do
        local nPerTieNum= math.floor(#vItems/6)
        local nTemp=1+(i-1)*nPerTieNum
        for j=nTemp,nTemp+nPerTieNum-1 do
              table.insert(self.vItemsTieTable[i],vItems[j].sItemName)
        end
        -- 将多余出来的一并加入Tie6
        if i ==6 then
          for j=1+i*nPerTieNum,#vItems do
             table.insert(self.vItemsTieTable[i],vItems[j].sItemName)
          end
        end
    end

    for k,v in pairs(self.vItemsTieTable) do
        print("Tie----"..k.."--------")
        for kt,vt in pairs(self.vItemsTieTable[k]) do
            print(vt)
        end
    end
  
end



function ItemController:CreateItemForNeutraulByChance(hUnit)

    --对信使无效
    if hUnit:GetAttackCapability() == 0 then
        return
    end

    if RandomInt(1, 100)/100 <= self.flItemCarryChance then
        
        local nTieNum =  math.ceil(hUnit:GetLevel()/2)
        if nTieNum >6 then nTieNum=6 end
        local sItemName = self.vItemsTieTable[nTieNum][RandomInt(1, #self.vItemsTieTable[nTieNum])]
        hUnit:AddItemByName( sItemName )

    end
    
end


function ItemController:DropItemByChance(hUnit)
       
    for i=0,11 do --遍历物品
        local hItem = hUnit:GetItemInSlot(i)
        if hItem and self:RollDiceToDrop(hUnit) then
          local hNewItem = CreateItem( hItem:GetName(), nil, nil )
          hNewItem:SetPurchaseTime( 0 )
          if hNewItem:IsPermanent() and hNewItem:GetShareability() == ITEM_FULLY_SHAREABLE then
             hNewItem:SetStacksWithOtherOwners( true )
          end
          local hNewWorldItem = CreateItemOnPositionSync( hUnit:GetOrigin(), hNewItem )
          hNewItem:LaunchLoot( false, RandomFloat( 300, 450 ), 0.5, hUnit:GetOrigin() + RandomVector( RandomFloat( 200, 300 ) ) )
          Timers:CreateTimer({
            endTime = 0.5, 
            callback = function()
            EmitGlobalSound( "ui.inv_drop_highvalue" )
            end
          })
          UTIL_Remove(hItem)             
        end

    end

end


function ItemController:RollDiceToDrop(hUnit)

    local bDropItem = false
    
    --玩家与野怪掉率不同
    if hUnit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
       if RandomInt(1, 100)/100 < self.flItemDropChance then
           bDropItem=true
       end
    else
       if RandomInt(1, 100)/100 < self.flPlayerItemDropChance then
           bDropItem=true
       end
    end

    return bDropItem

end




-- 将当前物品信息 （名，堆叠，冷却）作为数组记录到英雄身上，进化或者退化的时候 重新给单位加上物品
function ItemController:RecordItemsInfo(hHero)

    local vItemInfos={}
    if not hHero.hCurrentCreep:IsNull() then
        for i=0,11 do --遍历物品
            local hItem = hHero.hCurrentCreep:GetItemInSlot(i)
            local vItemInfo={}
            if hItem then
               vItemInfo.sItemName =hItem:GetName()
               vItemInfo.flRemainingCoolDown = hItem:GetCooldownTimeRemaining()
               vItemInfo.nCurrentCharges=hItem:GetCurrentCharges()
               table.insert(vItemInfos,vItemInfo)
               --圣剑移除掉
               if hItem:GetName()=="item_rapier" then
                     UTIL_Remove(hItem)     
               end
            end
        end
    end
    hHero.vItemInfos=vItemInfos
end



-- 还原物品
function ItemController:RestoreItems(hHero)
    
    if hHero.vItemInfos and hHero.hCurrentCreep and (not hHero.hCurrentCreep:IsNull()) and hHero.hCurrentCreep:IsAlive() then

        for _,vItemInfo in pairs(hHero.vItemInfos) do
            
            local hNewItem =  hHero.hCurrentCreep:AddItemByName(vItemInfo.sItemName)
            hNewItem:SetCurrentCharges(vItemInfo.nCurrentCharges)
            hNewItem:StartCooldown(vItemInfo.flRemainingCoolDown)
            --hHero.hCurrentCreep:AddItem(hNewItem)
        end
    end
    
end


-- 物品谁捡起来就是谁的
function ItemController:OnItemPickUp(event)

  local hItem = EntIndexToHScript( event.ItemEntityIndex )
  if event.UnitEntityIndex then 
      local hUnit=EntIndexToHScript( event.UnitEntityIndex )
      local sItemName=hItem:GetName()
      UTIL_Remove(hItem)
      hUnit:AddItemByName(sItemName)
  end
  
end