
var HealthBarRoot = $("#HealthBarRoot");

GameUI.GetHUDSeed = function()
{
    return 1080/Game.GetScreenHeight();
}

GameUI.CorrectPositionValue = function(value)
{
    return GameUI.GetHUDSeed() * value;
}

function UpdateHealthBar() {
    $.Schedule(0, UpdateHealthBar);

    for (var index = 0; index < HealthBarRoot.GetChildCount(); index++) {
        var panel = HealthBarRoot.GetChild(index);
        panel.used = false;
    }

    //只影响视野内单位
    var screenEntities = Entities.GetAllEntitiesByClassname('npc_dota_creature')
    for ( var entityIndex of screenEntities )
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
        var x = Game.WorldToScreenX(origin[0], origin[1], origin[2]+offset);
        var y = Game.WorldToScreenY(origin[0], origin[1], origin[2]+offset);
        panel.SetPositionInPixels(GameUI.CorrectPositionValue(x-panel.actuallayoutwidth/2), GameUI.CorrectPositionValue(y-panel.actuallayoutheight), 0);

        //if (entityIndex == cursorEntIndex)
        {
            cursorPanel = panel;
        }

        panel.SetDialogVariable("unit_name", $.Localize(unitName));

        var manaPercent = Entities.GetMana(entityIndex)/Entities.GetMaxMana(entityIndex);
        panel.FindChildTraverse("ManaProgress").value = manaPercent;

        var healthPercent = Entities.GetHealthPercent(entityIndex);
        panel.FindChildTraverse("HealthProgress").value = healthPercent;

        var level = Entities.GetLevel(entityIndex);
        panel.FindChildTraverse("LevelLabel").text = level;

        if (needXp == 0)
            percent = 1;
        else
            percent = levelXp/levelNeedXp;

        if (percent == 1) {
            panel.FindChildTraverse("LevelLabel").text = $.Localize("Level_Max");
        }

        
    }


}




(function () {
    UpdateHealthBar();
})();
