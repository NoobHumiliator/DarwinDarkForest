--测试PVE模式
_G.bTEST_PVE=false

_G.nNEUTRAL_TEAM = 4
--最大玩家数量 可能会根据地图调整
_G.nMAX_PLAYER_NUMBER = 10

_G.vEXP_TABLE={
    0,
    8,
    20,
    38,
    65,
    105,
    162,
    253,
    390,  --9
    615,  --10
    1500, --11级 游戏结束
    101349
}

--每级递增1.5倍

_G.vCREEP_EXP_TABLE={
    4, --1
    6,
    9,
    14,
    20,
    30,
    46,
    68,
    103,
    155, --10
    350  --11
}

vCREEP_EXP_TABLE[0]=2

-- 根据系数调整升级经验
for i,_ in ipairs(vEXP_TABLE) do
    vEXP_TABLE[i]=math.floor(vEXP_TABLE[i]*1.7+0.5)
end

GameRules.vWorldCenterPos=Vector(-640,624,128)

if GameMode == nil then
	_G.GameMode = class({}) 
end


require( "events" )
require( "evolve" )
require( "neutral_spawner" )
require( "item" )
require( "bonus_ring" )
require( "server" )
require( "econ" )
require( "item_ability/item_util" )
require( "utils/utility_functions" )
require( "utils/timers" )
require( "utils/bit" )
require( "utils/json" )
require( "utils/evolve_island_util" )
require( "utils/notifications" )
require( "rune_spawner" )
require('libraries/activity_modifier')
require('libraries/animations')
require('handbook')
require('cheat')
require('snapshot')


Precache = require "Precache"


function Activate()
    GameMode:InitGameMode()
end


--载入单位
GameRules.vUnitsKV = LoadKeyValues('scripts/npc/npc_units_custom.txt')
--载入技能
GameRules.vAbilitiesKV = LoadKeyValues('scripts/npc/npc_abilities_custom.txt')

GameRules.vAbilitiesTable = {}

--key 是 playerId，value是六维数组存储玩家的perk点
GameMode.vPlayerPerk={}

--key 是等级 value是数组 
vCreaturePerksTotal={}
for i=0,11 do
   vCreaturePerksTotal[i]={}
   vCreaturePerksTotal[i]["nElement"]=0
   vCreaturePerksTotal[i]["nMystery"]=0
   vCreaturePerksTotal[i]["nDurable"]=0
   vCreaturePerksTotal[i]["nFury"]=0
   vCreaturePerksTotal[i]["nDecay"]=0
   vCreaturePerksTotal[i]["nHunt"]=0
end


vAbilityPerksTotal={}
vAbilityPerksTotal["nElement"]=0
vAbilityPerksTotal["nMystery"]=0
vAbilityPerksTotal["nDurable"]=0
vAbilityPerksTotal["nFury"]=0
vAbilityPerksTotal["nDecay"]=0
vAbilityPerksTotal["nHunt"]=0


-- 处理一下 计算一下总进化度 计算一下怪物等级 
for sUnitName, vData in pairs(GameRules.vUnitsKV) do

    if vData and type(vData) == "table" then
        
        --元素
        if vData.nElement ==nil then
        	vData.nElement=0
        end
        --神秘
        if vData.nMystery ==nil then
        	vData.nMystery=0
        end
        --耐久
        if vData.nDurable ==nil then
        	vData.nDurable=0
        end
        --狂暴
        if vData.nFury ==nil then
        	vData.nFury=0
        end
        --腐朽
        if vData.nDecay ==nil then
        	vData.nDecay=0
        end
        --狩猎
        if vData.nHunt ==nil then
        	vData.nHunt=0
        end

        vData.nTotalPerk=vData.nElement+vData.nMystery+vData.nDurable+vData.nFury+vData.nDecay+vData.nHunt
        vData.sUnitName=sUnitName

        --为每个生物定义一个等级
        if vData.AttackCapabilities=="DOTA_UNIT_CAP_NO_ATTACK" then
            vData.nCreatureLevel=0
        else
            vData.nCreatureLevel=vData.Level
        end
        if vData.nCreatureLevel==nil then
            vData.nCreatureLevel=1
        end
        --print("sUnitName"..sUnitName)
        --计算总perk
        
        --剔除召唤饰品生物
        if (vData.IsSummoned==nil or vData.IsSummoned==0) and (vData.EconUnitFlag==nil or vData.EconUnitFlag==0) and (vData.ConsideredHero==nil or vData.ConsideredHero==0)  then
          vCreaturePerksTotal[vData.nCreatureLevel]["nElement"]=vCreaturePerksTotal[vData.nCreatureLevel]["nElement"]+vData.nElement
          vCreaturePerksTotal[vData.nCreatureLevel]["nMystery"]=vCreaturePerksTotal[vData.nCreatureLevel]["nMystery"]+vData.nMystery
          vCreaturePerksTotal[vData.nCreatureLevel]["nDurable"]=vCreaturePerksTotal[vData.nCreatureLevel]["nDurable"]+vData.nDurable
          vCreaturePerksTotal[vData.nCreatureLevel]["nFury"]=vCreaturePerksTotal[vData.nCreatureLevel]["nFury"]+vData.nFury
          vCreaturePerksTotal[vData.nCreatureLevel]["nDecay"]=vCreaturePerksTotal[vData.nCreatureLevel]["nDecay"]+vData.nDecay
          vCreaturePerksTotal[vData.nCreatureLevel]["nHunt"]=vCreaturePerksTotal[vData.nCreatureLevel]["nHunt"]+vData.nHunt
        end

    end
end


for i=0,10 do
    print("Creature Level "..i)
    for k,v in pairs(vCreaturePerksTotal[i]) do
        print(k..":"..v)
    end
    print("-----------------------------------")
end


-- 处理一下 将KV里面的技能 按等级拆碎 进化的时候一并洗入技能池
for sAbilityName, vData in pairs(GameRules.vAbilitiesKV) do
    if vData and type(vData) == "table" then
        
        if vData.AbilitySpecial then
            for _, special in pairs(vData.AbilitySpecial) do
                for k,v in pairs(special) do
                    if k=="nMystery" then
                        vData.nMystery=v
                    end
                    if k=="nElement" then
                        vData.nElement=v
                    end
                    if k=="nDurable" then
                        vData.nDurable=v
                    end
                    if k=="nFury" then
                        vData.nFury=v
                    end
                    if k=="nDecay" then
                        vData.nDecay=v
                    end
                    if k=="nHunt" then
                        vData.nHunt=v
                    end
                end
            end
        end


        if vData.nMystery~=nil or vData.nElement~=nil or vData.nDurable~=nil or vData.nFury~=nil or vData.nDecay~=nil or vData.nHunt~=nil  then
            
            print("sAbilityName"..sAbilityName)
            local vLevel=1
            --最大技能等级
            if vData.MaxLevel and tonumber(vData.MaxLevel) then
               vLevel=tonumber(vData.MaxLevel)
            end
            
            -- 构造数据
            for i=1,vLevel do
                
                --元素
                local nElement=0
                if vData.nElement ~=nil then
                   nElement=tonumber(SpliteStr(vData.nElement)[i])
                end
                --神秘
                local nMystery=0
                if vData.nMystery ~=nil then
                   nMystery=tonumber(SpliteStr(vData.nMystery)[i])
                end
                --耐久
                local nDurable=0
                if vData.nDurable ~=nil then
                    nDurable=tonumber(SpliteStr(vData.nDurable)[i])
                end
                --狂暴
                local nFury=0
                if vData.nFury ~=nil then
                    nFury=tonumber(SpliteStr(vData.nFury)[i])
                end
                --腐朽
                local nDecay=0
                if vData.nDecay ~=nil then
                    nDecay=tonumber(SpliteStr(vData.nDecay)[i])
                end
                --狩猎
                local nHunt=0
                if vData.nHunt ~=nil then
                    nHunt=tonumber(SpliteStr(vData.nHunt)[i])
                end

                local vTempData={
                  sAbilityName=sAbilityName,              
                  nLevel=i,
                  nElement=nElement,
                  nMystery=nMystery,
                  nDurable=nDurable,
                  nFury=nFury,
                  nDecay=nDecay,
                  nHunt=nHunt,
                  nTotalPerk=nElement+nMystery+nDurable+nFury+nDecay+nHunt
                }     

                vAbilityPerksTotal["nElement"]=vAbilityPerksTotal["nElement"]+nElement
                vAbilityPerksTotal["nMystery"]=vAbilityPerksTotal["nMystery"]+nMystery
                vAbilityPerksTotal["nDurable"]=vAbilityPerksTotal["nDurable"]+nDurable
                vAbilityPerksTotal["nFury"]=vAbilityPerksTotal["nFury"]+nFury
                vAbilityPerksTotal["nDecay"]=vAbilityPerksTotal["nDecay"]+nDecay
                vAbilityPerksTotal["nHunt"]=vAbilityPerksTotal["nHunt"]+nHunt

                table.insert(GameRules.vAbilitiesTable,vTempData)
            end

        end

    end
end

print("Ability Total Perks: ")
for k,v in pairs(vAbilityPerksTotal) do
    print(k..":"..v)
end

HandBook:DealCreatureData()
---------------------------------------------------------------------------
-- Initializer
---------------------------------------------------------------------------
function GameMode:InitGameMode()

    GameRules:GetGameModeEntity().GameMode = self

    GameRules.bPveMap = false       --此地图只有一个有效玩家，PVE模式（DOTA_GAMERULES_STATE_GAME_IN_PROGRESS时候定义此值）
    GameRules.bSendEndToSever = false   --已经向服务器发送 结束请求

    GameRules.sValidePlayerSteamIds="" --有效玩家的steamId队列
    GameRules.bUltimateStage=false  --终极进化阶段
    GameRules.bLevelTenStage=false  --有生物到达10级
    
    Timers:start()
    ItemController:Init()
    RuneSpawner:Init()
    NeutralSpawner:Init()
    Econ:Init()
    BonusRing:Init()
    GameRules.RuneSpawner=RuneSpawner

    GameMode.vStartPointLocation={} --key是teamnumber value坐标
    GameRules.nFatalErrorTimes=1

    GameRules.sMatchId=tostring(GameRules:GetMatchID())

    if GameRules.sMatchId=="0" then
       GameRules.sMatchId=tostring(GetSystemTime())..tostring(RandomInt(1,9999999))
    end
    
    --队伍颜色
	self.m_TeamColors = {}
	self.m_TeamColors[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }	--		Teal
	self.m_TeamColors[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }		--		Yellow
	self.m_TeamColors[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }	--      Pink
	self.m_TeamColors[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }		--		Orange
	self.m_TeamColors[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 }		--		Blue
	self.m_TeamColors[DOTA_TEAM_CUSTOM_4] = { 101, 212, 19 }	--		Green
	self.m_TeamColors[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 }		--		Brown
	self.m_TeamColors[DOTA_TEAM_CUSTOM_6] = { 27, 192, 216 }	--		Cyan
	self.m_TeamColors[DOTA_TEAM_CUSTOM_7] = { 199, 228, 13 }	--		Olive
	self.m_TeamColors[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 }	--		Purple
    
    --胜利信息
	self.m_VictoryMessages = {}
	self.m_VictoryMessages[DOTA_TEAM_GOODGUYS] = "#VictoryMessage_GoodGuys"
	self.m_VictoryMessages[DOTA_TEAM_BADGUYS]  = "#VictoryMessage_BadGuys"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_1] = "#VictoryMessage_Custom1"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_2] = "#VictoryMessage_Custom2"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_3] = "#VictoryMessage_Custom3"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_4] = "#VictoryMessage_Custom4"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_5] = "#VictoryMessage_Custom5"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_6] = "#VictoryMessage_Custom6"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_7] = "#VictoryMessage_Custom7"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_8] = "#VictoryMessage_Custom8"




    --根据出生点 设置队伍玩家数量
    self:GatherAndRegisterValidTeams()

    -- 设置队伍颜色
	for nTeamNumber = 0, (DOTA_TEAM_COUNT-1) do
		local color = self.m_TeamColors[ nTeamNumber ]
		if color then
			SetTeamCustomHealthbarColor( nTeamNumber, color[1], color[2], color[3] )
		end
	end

    --设置 出生位置
    Timers:CreateTimer(1, function()
    	for _,v in ipairs(self.vfoundTeamsList) do
    		self:PutStartPositionToRandomPosForTeam(v)
    	end
    end)
    
	GameRules:SetSameHeroSelectionEnabled(true)
    GameRules:SetUseUniversalShopMode(true)
    --使用自定义的金币奖励
    GameRules:SetGoldPerTick(0)
    GameRules:SetGoldTickTime(0)
    GameRules:SetStartingGold(0)
    GameRules:SetUseBaseGoldBountyOnHeroes(true)

    GameRules:GetGameModeEntity():SetRemoveIllusionsOnDeath(true)
    GameRules:GetGameModeEntity():SetFogOfWarDisabled(false)
    GameRules:GetGameModeEntity():SetCameraDistanceOverride(1500)
    GameRules:GetGameModeEntity():SetSelectionGoldPenaltyEnabled(false)
    GameRules:GetGameModeEntity():SetLoseGoldOnDeath(false)
    GameRules:GetGameModeEntity():SetBuybackEnabled(false)

    GameRules:SetHeroRespawnEnabled( true )
    GameRules:GetGameModeEntity():SetFixedRespawnTime(99999999999)
    
    --在死亡事件里面设置重生时间
    
    --GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(GameMode, "DamageFilter"), self)
    --GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(GameMode, "OrderFilter"), self)
    --GameRules:GetGameModeEntity():SetModifierGainedFilter(Dynamic_Wrap(GameMode, 'ModifierFilter'), self)
    GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(GameMode, "ModifyGoldFilter"), self)
    --GameRules:GetGameModeEntity():SetModifyExperienceFilter(Dynamic_Wrap(GameMode, "ModifyExpFilter"), self)
    
    SendToServerConsole("dota_max_physical_items_purchase_limit 9999")
    


    --替换英雄模型
    ListenToGameEvent("dota_player_pick_hero",Dynamic_Wrap(GameMode,"OnPlayerPickHero"),self)
    ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( GameMode, 'OnGameRulesStateChange' ), self )
    ListenToGameEvent( "entity_killed", Dynamic_Wrap( GameMode, 'OnEntityKilled' ), self )
    ListenToGameEvent( "npc_spawned", Dynamic_Wrap( GameMode, "OnNPCSpawned" ), self )
    ListenToGameEvent("player_chat", Dynamic_Wrap(GameMode, "OnPlayerSay"), self)


    CustomGameEventManager:RegisterListener("RequestCreatureIndex", Dynamic_Wrap(GameMode, 'RequestCreatureIndex'))
    CustomGameEventManager:RegisterListener("PortraitClicked", Dynamic_Wrap(GameMode, 'PortraitClicked'))

    --[[
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( GameMode, "OnNPCSpawned" ), self )
	ListenToGameEvent( "dota_team_kill_credit", Dynamic_Wrap( GameMode, 'OnTeamKillCredit' ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( GameMode, 'OnEntityKilled' ), self )
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( GameMode, "OnItemPickUp"), self )
	ListenToGameEvent( "dota_npc_goal_reached", Dynamic_Wrap( GameMode, "OnNpcGoalReached" ), self )
    --]]
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 1 ) 

end


--本游戏 直接禁止一切获取金币的手段
function GameMode:ModifyGoldFilter(filterTable)
    local reason = filterTable.reason_const
    --print("[GameMode:ModifyGoldFilter]: Attempt to call default dota gold modify func... FIX IT - Reason: " .. filterTable.reason_const .."  --  Amount: " .. filterTable.gold)
    filterTable.gold = 0
    return false
end



-- 根据出生点，设定队伍玩家数量 nMAX_PLAYER_NUMBER
function GameMode:GatherAndRegisterValidTeams()

	local foundTeams = {}
	for _, playerStart in pairs( Entities:FindAllByClassname( "info_player_start_dota" ) ) do
		foundTeams[  playerStart:GetTeam() ] = true
	end

	local numTeams = TableCount(foundTeams)
	print( "GatherValidTeams - Found spawns for a total of " .. numTeams .. " teams" )
	
	self.vfoundTeamsList = {}
	for t, _ in pairs( foundTeams ) do
		table.insert( self.vfoundTeamsList, t )
	end

    print( "Setting up teams:" )
    local nGameTeamMaxPlayers =1 
    if GetMapName() == "island_1x10" then 
        nGameTeamMaxPlayers=1
    elseif GetMapName() == "island_3x4" then
        nGameTeamMaxPlayers=3
    end

    for nTeam = 0, (DOTA_TEAM_COUNT-1) do
        local nTempmaxPlayers = 0
        --如果没有对应出生点 设置为0
        if ( nil ~= TableFindKey( self.vfoundTeamsList, nTeam ) ) then
            nTempmaxPlayers = nGameTeamMaxPlayers
        end
        print( " - " .. nTeam .. " ( " .. GetTeamName( nTeam ) .. " ) -> max players = " .. nTempmaxPlayers )
        GameRules:SetCustomGameTeamMaxPlayers( nTeam, nTempmaxPlayers )
    end


end

---------------------------------------------------------------------------------
-- 将玩家的出生点放到随机的位置
---------------------------------------------------------------------------------
function GameMode:PutStartPositionToRandomPosForTeam(nTeam)
    -- 将对应队伍的出生点放到随机的位置去
    local vPlayerStarts = Entities:FindAllByClassname("info_player_start_dota")
    for _, hStart in pairs(vPlayerStarts) do
        if hStart:GetTeamNumber() == nTeam then
           
            local nMaxTry = 20
            local bHasValidPlace = false
            local vRandomPos =GetRandomValidPosition()
            
            --如果重生，尽量避开其他玩家
            while not bHasValidPlace do
                vRandomPos =GetRandomValidPosition()
                bHasValidPlace=true

                nMaxTry = nMaxTry - 1
                if nMaxTry <= 0 then
                    break
                end

                local vEnemies = FindUnitsInRadius( nTeam, vRandomPos, nil, 2500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, 0, false )           
                for _,hEnemy in pairs(vEnemies) do
                    if hEnemy.bMainCreep then
                        bHasValidPlace=false
                    end
                end
            end
            
            GameMode.vStartPointLocation[nTeam]=vRandomPos
            hStart:SetOrigin(vRandomPos)
        end
    end
end

---------------------------------------------------------------------------------
-- 将玩家的出生点放到指定的位置
---------------------------------------------------------------------------------
function GameMode:PutStartPositionToLocation(hHero,vLocation)
    -- 将对应队伍的出生点放到随机的位置去
    local playerStarts = Entities:FindAllByClassname("info_player_start_dota")
    for _, start in pairs(playerStarts) do
        if start:GetTeamNumber() == hHero:GetTeamNumber() then
            GameMode.vStartPointLocation[hHero:GetTeamNumber()]=vLocation
            start:SetOrigin(vLocation)
        end
    end
end


---------------------------------------------------------------------------
-- Get the color associated with a given teamID
---------------------------------------------------------------------------
function GameMode:ColorForTeam( teamID )
	local color = self.m_TeamColors[ teamID ]
	if color == nil then
		color = { 255, 255, 255 } -- default to white
	end
	return color
end


---------------------------------------------------------------------------
-- Put a label over a player's hero so people know who is on what team
---------------------------------------------------------------------------
function GameMode:UpdatePlayerColor( nPlayerID )
	if not PlayerResource:HasSelectedHero( nPlayerID ) then
		return
	end

	local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	if hero == nil then
		return
	end

	local teamID = PlayerResource:GetTeam( nPlayerID )
	local color = self:ColorForTeam( teamID )
	PlayerResource:SetCustomPlayerColor( nPlayerID, color[1], color[2], color[3] )
end


---------------------------------------------------------------------------
-- 更新等级榜，检查获胜
---------------------------------------------------------------------------
function GameMode:UpdateScoreboardAndVictory()

	local vSortedTeams = {}
    local vAliveTeams = {}
    local vAlivePlayers = {}

	for _, nTeamID in pairs( self.vfoundTeamsList ) do
        local nTeamMaxLevel = 1       
		for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
		  --选出等级最高的英雄
		  if PlayerResource:IsValidPlayer( nPlayerID ) and PlayerResource:GetSelectedHeroEntity (nPlayerID) then

             local hHero = PlayerResource:GetSelectedHeroEntity (nPlayerID)
             if hHero.GetTeamNumber and hHero:GetTeamNumber()==nTeamID then
                local nLevel=hHero.nCurrentCreepLevel
                if nLevel then
                   if nTeamMaxLevel<nLevel then
                 	  nTeamMaxLevel=nLevel
                   end
                end
                if  hHero.IsAlive and  hHero:IsAlive() and hHero.hCurrentCreep and not hHero.hCurrentCreep:IsNull() and hHero.hCurrentCreep.IsAlive and hHero.hCurrentCreep:IsAlive() then
                    table.insert(vAliveTeams, nTeamID)
                    table.insert(vAlivePlayers, nPlayerID)
                end
             end

		  end
	    end
        local sortedTeam={}
        sortedTeam.teamID=nTeamID
        sortedTeam.teamScore=nTeamMaxLevel
        CustomNetTables:SetTableValue( "team_max_level",tostring(nTeamID), {team_max_level=nTeamMaxLevel} )

		table.insert( vSortedTeams,sortedTeam)
	end
    
    -- reverse-sort by score
    table.sort( vSortedTeams, function(a,b) return ( a.teamScore > b.teamScore ) end )
    
    --终极进化阶段
    if GameRules.bUltimateStage then
      vAliveTeams=RemoveRepetition(vAliveTeams)
      --只剩唯一队伍
      if #vAliveTeams==1 then
          --结束各种类型游戏，记录天梯分数
          --作弊模式直接结束游戏
          if GameRules:IsCheatMode() then
             Notifications:BottomToAll({text="#cheat_not_record", duration=20, style={color="Red"}})
             GameRules.bUltimateStage=false
             Timers:CreateTimer(6, function()
               GameRules:SetGameWinner(vAliveTeams[1])
             end)
          else
            --非作弊 
            if GameRules.bPveMap  and not GameRules.bSendEndToSever  then             
                  Server:EndPveGame(vAliveTeams[1])
                  GameRules.bSendEndToSever=true
            end
            if GetMapName() == "island_1x10" and not GameRules.bSendEndToSever then
                  GameRules.bSendEndToSever=true
                  Server:EndPvpGame(vSortedTeams,"solo",vAliveTeams[1])
            end
            if GetMapName() == "island_3x4" and not GameRules.bSendEndToSever then
                  if GameRules.nValidTeamNumber==1 then
                     Notifications:BottomToAll({text="#coop_same_team_not_record", duration=20, style={color="Red"}})
                     GameRules.bUltimateStage=false
                     Timers:CreateTimer(6, function()
                       GameRules:SetGameWinner(vAliveTeams[1])
                     end)
                  else
                    GameRules.bSendEndToSever=true
                    Server:EndPvpGame(vSortedTeams,"three_player",vAliveTeams[1])
                  end
            end
          end
      end

    end
 

end
---------------------------------------------------------------------------
-- Update player labels and the scoreboard
---------------------------------------------------------------------------
function GameMode:OnThink()

    -- Stop thinking if game is paused
    if GameRules:IsGamePaused() == true then
        return 1
    end

    for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
        GameMode:UpdatePlayerColor( nPlayerID )
    end
	
    xpcall(
    function()
        GameMode:UpdateScoreboardAndVictory()
    end,
    function(e)
        --每一百次上传一次错误日志
        if math.mod(GameRules.nFatalErrorTimes,100)==1 then
           Server:UploadErrorLog(e)
        end
        GameRules.nFatalErrorTimes=GameRules.nFatalErrorTimes+1
    end)

	return 1
end

