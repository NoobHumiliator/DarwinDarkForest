
var HealthBarRoot = $("#HealthBarRoot");

GameUI.GetHUDSeed = function()
{
    return 1080/Game.GetScreenHeight();
}

GameUI.CorrectPositionValue = function(value)
{
    return GameUI.GetHUDSeed() * value;
}

GameUI.GetCursorEntity = function()
{
    var targets = GameUI.FindScreenEntities(GameUI.GetCursorPosition());
    var targets1 = targets.filter(function(e)
        {
            return e.accurateCollision;
        });
    var targets2 = targets.filter(function(e)
        {
            return !e.accurateCollision;
        });
    targets = targets1;
    if (targets1.length == 0)
    {
        targets = targets2;
    }
    if (targets.length == 0)
    {
        return -1;
    }
    return targets[0].entityIndex;
}


function UpdateHealthBar() {
    $.Schedule(0, UpdateHealthBar);

    for (var index = 0; index < HealthBarRoot.GetChildCount(); index++) {
        var panel = HealthBarRoot.GetChild(index);
        panel.used = false;
    }

    //只影响视野内单位
    var screenEntities = Entities.GetAllEntitiesByClassname('npc_dota_creature')
    var cursorEntIndex = GameUI.GetCursorEntity();
    var cursorPanel;
    for ( var entityIndex of screenEntities )
    {
        if (Entities.IsAlive( entityIndex ))
        {
            var panel = HealthBarRoot.FindChildTraverse(entityIndex);
            if (panel == null || panel == undefined)
            {
                panel = $.CreatePanel("Panel", HealthBarRoot, entityIndex);
                panel.BLoadLayoutSnippet("HealthBarPanel");
            }
            panel.used = true;

            panel.unitEntIndex = entityIndex;

            var unitName = Entities.GetUnitName(entityIndex) 

            var origin = Entities.GetAbsOrigin(entityIndex);
            var offset = Entities.GetHealthBarOffset(entityIndex);
            offset = offset == -1 ? 100 : offset;
            offset = offset-20
            var x = Game.WorldToScreenX(origin[0], origin[1], origin[2]+offset);
            var y = Game.WorldToScreenY(origin[0], origin[1], origin[2]+offset);
            panel.SetPositionInPixels(GameUI.CorrectPositionValue(x-panel.actuallayoutwidth/2), GameUI.CorrectPositionValue(y-panel.actuallayoutheight), 0);

            if (entityIndex == cursorEntIndex)
            {
                cursorPanel = panel;
            }

            panel.SetDialogVariable("unit_name", $.Localize(unitName));

            var manaPercent = Entities.GetMana(entityIndex)/Entities.GetMaxMana(entityIndex);
            panel.FindChildTraverse("ManaProgress").value = manaPercent;

            var healthPercent = Entities.GetHealth(entityIndex)/Entities.GetMaxHealth(entityIndex);
            panel.FindChildTraverse("HealthProgress").value = healthPercent;

            var level = Entities.GetLevel(entityIndex);
            panel.FindChildTraverse("LevelLabel").text = level;

            if (CustomNetTables.GetTableValue( "main_creature_owner",entityIndex)!=undefined)
            {
                var ownerInfo = CustomNetTables.GetTableValue( "main_creature_owner",entityIndex)
                var playInfo = CustomNetTables.GetTableValue( "player_info",""+ownerInfo.owner_id)

                if (ownerInfo.owner_id == Players.GetLocalPlayer())
                {
                     panel.FindChildTraverse("HealthProgress_Left").AddClass("Highlighted")
                     panel.FindChildTraverse("Bar").AddClass("Highlighted")
                     panel.FindChildTraverse("LevelInfo").AddClass("Highlighted")
                     panel.FindChildTraverse("HealthBar").AddClass("Highlighted")
                } else {
                    if (Players.GetTeam( ownerInfo.owner_id )!= Players.GetTeam( Players.GetLocalPlayer() ) )
                    {
                      panel.FindChildTraverse("Bar").AddClass("Highlighted")
                      panel.FindChildTraverse("HealthBar").AddClass("Highlighted")
                      panel.FindChildTraverse("LevelInfo").AddClass("Highlighted")
                      panel.FindChildTraverse("HealthProgress_Left").AddClass("Highlighted")
                      panel.FindChildTraverse("HealthProgress_Left").AddClass("EnemyTeam")
                    }
                }
                if (playInfo!=undefined)
                {
                    var radio = playInfo.current_exp/playInfo.next_level_need
                    panel.FindChildTraverse("CircularXPProgress").value = radio;
                    panel.FindChildTraverse("CircularXPProgressBlur").value = radio;
                }
            } else {
                if (Entities.GetTeamNumber(entityIndex)!= Players.GetTeam( Players.GetLocalPlayer() ))
                {
                    panel.FindChildTraverse("HealthProgress_Left").AddClass("EnemyTeam")
                }
            }
        }
    }
    
    for (var index = 0; index < HealthBarRoot.GetChildCount(); index++) {
        var panel = HealthBarRoot.GetChild(index);
        if (panel.used == false)
        {
            panel.DeleteAsync(-1);
        }
    }

    // 防止遮挡
    if (cursorPanel != undefined && cursorPanel != null)
    {
        HealthBarRoot.MoveChildAfter(cursorPanel, HealthBarRoot.GetChild(HealthBarRoot.GetChildCount()-1));
    }

}




(function () {
    UpdateHealthBar();
})();
