--测试模式
_G.bTEST_MODE=true

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
    390,
    595,
    1350, --11级 游戏结束
    101349
}


_G.vCREEP_EXP_TABLE={
    4,
    6,
    9,
    14,
    20,
    30,
    46,
    68,
    103,
    375
}

vCREEP_EXP_TABLE[0]=2

-- 根据系数调整升级经验
for i,_ in ipairs(vEXP_TABLE) do
    vEXP_TABLE[i]=math.floor(vEXP_TABLE[i]*1.5+0.5)
end



if GameMode == nil then
	_G.GameMode = class({}) 
end


require( "events" )
require( "evolve" )
require( "neutral_spawner" )
require( "utils/utility_functions" )
require( "utils/timers" )

---------------------------------------------------------------------------
-- Precache
---------------------------------------------------------------------------
function Precache( context )
 	 PrecacheResource( "particle", "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_necro_souls_hero.vpcf", context )    
     PrecacheResource( "particle", "particles/econ/events/ti6/hero_levelup_ti6_godray.vpcf", context )
end

function Activate()
	GameMode:InitGameMode()
end

GameRules.vWorldCenterPos=Vector(-640,624,128)

--载入单位
GameRules.vUnitsKV = LoadKeyValues('scripts/npc/npc_units_custom.txt')
--载入技能
GameRules.vAbilitiesKV = LoadKeyValues('scripts/npc/npc_abilities_custom.txt')

GameRules.vAbilitiesTable = {}


--key 是 playerId，value是六维数组存储玩家的perk点
GameMode.vPlayerPerk={}

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
        --计算总perk
        vData.nTotalPerk=vData.nElement+vData.nMystery+vData.nDurable+vData.nFury+vData.nDecay+vData.nHunt
        
        --为每个生物定义一个等级
        if vData.AttackCapabilities=="DOTA_UNIT_CAP_NO_ATTACK" then
            vData.nCreatureLevel=0
        else
            vData.nCreatureLevel=vData.Level
        end

    end
end

-- 处理一下 将KV里面的技能 按等级拆碎 进化的时候一并洗入技能池
for sAbilityName, vData in pairs(GameRules.vAbilitiesKV) do
    if vData and type(vData) == "table" then
        
        --保证是进化类型的技能 而不是其他
        if vData.nMystery~=nil or vData.nElement~=nil or vData.nDurable~=nil or vData.nFury~=nil or vData.nDecay~=nil or vData.nHunt~=nil  then
            
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
                table.insert(GameRules.vAbilitiesTable,vTempData)
            end
        end

    end
end





---------------------------------------------------------------------------
-- Initializer
---------------------------------------------------------------------------
function GameMode:InitGameMode()

    GameRules:GetGameModeEntity().GameMode = self
    Timers:start()
    NeutralSpawner:Init()
    GameMode.vStartPointLocation={} --key是teamnumber value坐标
    

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


    GameRules:GetGameModeEntity():SetRemoveIllusionsOnDeath(true)
    GameRules:GetGameModeEntity():SetFogOfWarDisabled(false)
    GameRules:GetGameModeEntity():SetCameraDistanceOverride(1500)
    GameRules:GetGameModeEntity():SetSelectionGoldPenaltyEnabled(false)
    GameRules:GetGameModeEntity():SetLoseGoldOnDeath(false)
    GameRules:GetGameModeEntity():SetBuybackEnabled(false)
    --在死亡事件里面固定重生时间

    --为测试模式设置
    if bTEST_MODE and not IsDedicatedServer() then
        GameRules:GetGameModeEntity():SetFogOfWarDisabled(true)
    end
    
  

    --[[
    GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(GameMode, "DamageFilter"), self)
    GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(GameMode, "OrderFilter"), self)
    GameRules:GetGameModeEntity():SetModifierGainedFilter(Dynamic_Wrap(GameMode, 'ModifierFilter'), self)
    GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(GameMode, "ModifyGoldFilter"), self)
    GameRules:GetGameModeEntity():SetModifyExperienceFilter(Dynamic_Wrap(GameMode, "ModifyExpFilter"), self)
    ]]
    SendToServerConsole("dota_max_physical_items_purchase_limit 9999")
    


    --替换英雄模型
    ListenToGameEvent("dota_player_pick_hero",Dynamic_Wrap(GameMode,"OnPlayerPickHero"),self)
    ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( GameMode, 'OnGameRulesStateChange' ), self )
    ListenToGameEvent( "entity_killed", Dynamic_Wrap( GameMode, 'OnEntityKilled' ), self )
    ListenToGameEvent( "npc_spawned", Dynamic_Wrap( GameMode, "OnNPCSpawned" ), self )
    ListenToGameEvent("player_chat", Dynamic_Wrap(GameMode, "OnPlayerSay"), self) 
    --[[
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( GameMode, "OnNPCSpawned" ), self )
	ListenToGameEvent( "dota_team_kill_credit", Dynamic_Wrap( GameMode, 'OnTeamKillCredit' ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( GameMode, 'OnEntityKilled' ), self )
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( GameMode, "OnItemPickUp"), self )
	ListenToGameEvent( "dota_npc_goal_reached", Dynamic_Wrap( GameMode, "OnNpcGoalReached" ), self )
    --]]
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 1 ) 

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

	local maxPlayersPerTeam = math.floor( nMAX_PLAYER_NUMBER / numTeams )

	print( "Setting up teams:" )
	for team = 0, (DOTA_TEAM_COUNT-1) do
		local maxPlayers = 0
		if ( nil ~= TableFindKey( self.vfoundTeamsList, team ) ) then
			maxPlayers = maxPlayersPerTeam
		end
		print( " - " .. team .. " ( " .. GetTeamName( team ) .. " ) -> max players = " .. tostring(maxPlayers) )
		GameRules:SetCustomGameTeamMaxPlayers( team, maxPlayers )
	end
end

---------------------------------------------------------------------------------
-- 将玩家的出生点放到随机的位置
---------------------------------------------------------------------------------
function GameMode:PutStartPositionToRandomPosForTeam(team, deadPos)
    -- 将对应队伍的出生点放到随机的位置去
    local playerStarts = Entities:FindAllByClassname("info_player_start_dota")
    for _, start in pairs(playerStarts) do
        if start:GetTeamNumber() == team then
           
            local maxTry = 10
            local randomPos = GetRandomValidPosition()
            if deadPos == nil then deadPos = Vector(0,0,0) end
            while (randomPos - deadPos):Length2D() < 4000 do
                randomPos =GetRandomValidPosition()
                maxTry = maxTry - 1
                if maxTry <= 0 then
                    randomPos =GetRandomValidPosition()
                    break
                end
            end
            GameMode.vStartPointLocation[team]=randomPos
            start:SetOrigin(randomPos)
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
---------------------------------------------------------------------------
function GameMode:EndGame( victoryTeam )
	GameRules:SetGameWinner( victoryTeam )
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
-- 更新等级榜
---------------------------------------------------------------------------
function GameMode:UpdateScoreboard()
	local sortedTeams = {}
	for _, team in pairs( self.vfoundTeamsList ) do
		for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
		  --选出等级最高的英雄
		  local nTeamMaxLevel = 1;		  
		  if PlayerResource:IsValidPlayer( nPlayerID ) and PlayerResource:GetTeamNumber()==team then
             local nLevel=GetSelectedHeroEntity (nPlayerID):GetLevel()
             if nTeamMaxLevel<nLevel then
             	nTeamMaxLevel=nLevel
             end
		  end
	    end
		table.insert( sortedTeams, { teamID = team, teamScore = nTeamMaxLevel } )
	end

	-- reverse-sort by score
	table.sort( sortedTeams, function(a,b) return ( a.teamScore > b.teamScore ) end )

	for _, t in pairs( sortedTeams ) do
		local clr = self:ColorForTeam( t.teamID )
		-- Scaleform UI Scoreboard
		local score = 
		{
			team_id = t.teamID,
			team_score = t.teamScore
		}
		FireGameEvent( "score_board", score )
	end

end

---------------------------------------------------------------------------
-- Update player labels and the scoreboard
---------------------------------------------------------------------------
function GameMode:OnThink()
	for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
		self:UpdatePlayerColor( nPlayerID )
	end
	
	--self:UpdateScoreboard()
	-- Stop thinking if game is paused
	if GameRules:IsGamePaused() == true then
        return 1
    end

	return 1
end

