if Server == nil then Server = class({}) end
--持久化服务器ip 端口
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


function Server:EndPveGame(nPlayerID)
    local nPlayerSteamId = PlayerResource:GetSteamAccountID(nPlayerID)
    local nTimeCost=GameRules:GetGameTime() - GameRules.nGameStartTime
    local request = CreateHTTPRequestScriptVM("GET", sServerAddress .. "endpvegame")
    request:SetHTTPRequestGetOrPostParameter("dedicated_server_key",GetDedicatedServerKey("K4gN+u422RN2X4DubcLylw=="));
    request:SetHTTPRequestGetOrPostParameter("player_steam_id",nPlayerSteamId);
    request:SetHTTPRequestGetOrPostParameter("time_cost",nTimeCost);
end


function Server:GetRankData()
    local req = CreateHTTPRequestScriptVM("GET", sServerAddress .. "getrankdata")
    req:Send(function(result)
        print("Rank Data Arrive")
        if result.StatusCode == 200 then
            local body = JSON:decode(JSON:decode(result.Body))
            print(body)
            if body ~= nil then
                CustomNetTables:SetTableValue("rank_data", "rank_data", stringTable(body))
            end
        end
    end)
end
