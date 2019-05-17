--持久化服务器 交互Service
if Server == nil then Server = class({}) end
sServerAddress="http://106.13.43.157:8080/"


local function stringTable(t)
    local s = {}
    for k,v in pairs(t) do
        if type(v) == 'table' then
            s[k] = stringTable(v)
        else s[k] = tostring(v)
        end
    end
    return s
end


function Server:EndPveGame(iTeam)
    local nTimeCost=GameRules:GetGameTime() - GameRules.nGameStartTime
    local request = CreateHTTPRequestScriptVM("GET", sServerAddress .. "endpvegame")
    request:SetHTTPRequestGetOrPostParameter("dedicated_server_key",GetDedicatedServerKey("K4gN+u422RN2X4DubcLylw=="));
    request:SetHTTPRequestGetOrPostParameter("player_steam_id",GameRules.sValidePlayerSteamIds);

    print("GameRules.sValidePlayerSteamIds"..GameRules.sValidePlayerSteamIds)
    request:SetHTTPRequestGetOrPostParameter("time_cost",tostring(math.floor(nTimeCost)));
    request:Send(function(result)
        print("End Pve Game Finish"..result.StatusCode)
        if result.StatusCode == 200 and result.Body~=nil then
            local body = JSON:decode(result.Body)
            print(body)
            if body ~= nil then
                CustomNetTables:SetTableValue("end_game_rank_data", "end_game_rank_data", stringTable(body))
                GameRules:SetGameWinner(iTeam)
            end
        end
    end)


end



function Server:EndPvpGame(vSortedTeams,sType)

    local request = CreateHTTPRequestScriptVM("POST", sServerAddress .. "endpvpgame")
    request:SetHTTPRequestGetOrPostParameter("dedicated_server_key",GetDedicatedServerKey("K4gN+u422RN2X4DubcLylw=="));
    
    --整理表单数据
    local vFormData = {}
    for k,vTeam in ipairs(vSortedTeams) do
      for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
        if PlayerResource:IsValidPlayer( nPlayerID ) and PlayerResource:GetSelectedHeroEntity (nPlayerID) and PlayerResource:GetSelectedHeroEntity(nPlayerID):GetTeamNumber()==vTeam.teamID then
           print("nPlayerID"..nPlayerID)
           print("vTeam.teamID"..vTeam.teamID)

           local nPlayerSteamId = PlayerResource:GetSteamAccountID(nPlayerID)
           vFormData[""..nPlayerSteamId]=""..k
        end
      end
    end
    vFormData["88765184"]="2"
    print("vFormData: "..tostring(JSON:encode(vFormData)))

    --PrintTable(vFormData)
    --request:SetHTTPRequestGetOrPostParameter("form_data",tostring(JSON:encode(vFormData)));
    request:SetHTTPRequestGetOrPostParameter("type",sType);

    request:Send(function(result)
        print("End Pvp Game Finish"..result.StatusCode)
        if result.StatusCode == 200 and result.Body~=nil then
            local body = JSON:decode(result.Body)
            print(body)
            if body ~= nil then
                CustomNetTables:SetTableValue("end_game_rank_data", "end_game_rank_data", stringTable(body))
                GameRules:SetGameWinner(iTeam)
            end
        end
    end)
end





function Server:GetRankData()
    local request = CreateHTTPRequestScriptVM("GET", sServerAddress .. "getrankdata")
    request:Send(function(result)
        print("Rank Data Arrive")
        if result.StatusCode == 200 and result.Body~=nil then
            local body = JSON:decode(result.Body)
            print(body)
            if body ~= nil then
                CustomNetTables:SetTableValue("rank_data", "rank_data", stringTable(body))
            end
        end
    end)
end

--从服务器获取玩家饰品信息
function Server:GetPlayerEconData()
    local request = CreateHTTPRequestScriptVM("GET", sServerAddress .. "getecondata")
    request:SetHTTPRequestGetOrPostParameter("player_steam_ids",GameRules.sValidePlayerSteamIds);

    request:Send(function(result)
        print("Econ Data Arrive")
        if result.StatusCode == 200 then
            print(result.Body)
            local body = JSON:decode(result.Body)
            if body ~= nil then
                CustomNetTables:SetTableValue("econ_data", "econ_data", stringTable(body))
            end
        end
    end)
end

--更新装备信息
function Server:UpdatePlayerEquip(nPlayerID,sItemName,sType,nEquip)

    local request = CreateHTTPRequestScriptVM("GET", sServerAddress .. "updateplayerequip")
    local nPlayerSteamId = PlayerResource:GetSteamAccountID(nPlayerID)
    
    request:SetHTTPRequestGetOrPostParameter("player_steam_id",tostring(nPlayerSteamId));
    request:SetHTTPRequestGetOrPostParameter("item_name",sItemName);
    request:SetHTTPRequestGetOrPostParameter("item_type",sType);
    request:SetHTTPRequestGetOrPostParameter("equip",tostring(nEquip));

    request:Send(function(result)
        print("Update Player Equip")
        if result.StatusCode == 200 and result.Body~=nil then
            print(result.Body)
        end
    end)
end




function Server:GetEconRarity()
    local request = CreateHTTPRequestScriptVM("GET", sServerAddress .. "geteconrarity")
    request:Send(function(result)
        print("Rarity Data Arrive")
        if result.StatusCode == 200 and result.Body~=nil then
            local body = JSON:decode(result.Body)
            if body ~= nil then
                print(result.Body)
                CustomNetTables:SetTableValue("econ_rarity", "econ_rarity", stringTable(body.econ_rarity))
                CustomNetTables:SetTableValue("econ_type", "econ_type", stringTable(body.econ_type))
            end
        end
    end)
end

function Server:DrawLottery(nPlayerID)

    local request = CreateHTTPRequestScriptVM("GET", sServerAddress .. "drawlottery")
    local nPlayerSteamId = PlayerResource:GetSteamAccountID(nPlayerID)
    request:SetHTTPRequestGetOrPostParameter("player_steam_id",tostring(nPlayerSteamId));

    request:Send(function(result)
        if result.StatusCode == 200 and result.Body~=nil then
            local body = JSON:decode(result.Body)
            if body ~= nil then
               CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID),"DrawLotteryResultArrive",body)
            end
        end
    end)
end