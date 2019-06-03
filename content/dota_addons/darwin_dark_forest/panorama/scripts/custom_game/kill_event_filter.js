
function FindDotaHudElements(className){
    var hudRoot;
    for(panel=$.GetContextPanel();panel!=null;panel=panel.GetParent()){
        hudRoot = panel;
    }
    var comps = hudRoot.FindChildrenWithClassTraverse(className);
    return comps;
}


function DotaPlayerKill(keys)
{   
    $.Schedule(0.05, function(){
       var eventListLabels=FindDotaHudElements("EventListLabel");
       var eventListLabel= eventListLabels[eventListLabels.length-1];
       eventListLabel.style['text-overflow'] = 'clip';
       //$.Msg(eventListLabel.FindChildrenWithClassTraverse ("CombatEventGoldIcon"))
       eventListLabel.style.width=(eventListLabel.FindChildrenWithClassTraverse ("CombatEventGoldIcon")[0].actualxoffset+70)+"px";

       var eventListLabels=FindDotaHudElements("CombatEventHeroIcon");
       for (var i = eventListLabels.length-1; i >= 0; i--) {
           var eventListLabel= eventListLabels[i];
           eventListLabel.style.visibility = 'collapse'
       }
    });
}


(function () {
    GameEvents.Subscribe( "dota_player_kill", DotaPlayerKill );
})();