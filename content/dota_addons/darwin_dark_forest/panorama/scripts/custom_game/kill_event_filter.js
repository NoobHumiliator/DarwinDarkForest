var steakSound={
  3:"announcer_killing_spree_announcer_kill_spree_01",
  4:"announcer_killing_spree_announcer_kill_dominate_01",
  5:"announcer_killing_spree_announcer_kill_mega_01",
  6:"announcer_killing_spree_announcer_kill_unstop_01",
  7:"announcer_killing_spree_announcer_kill_wicked_01",
  8:"announcer_killing_spree_announcer_kill_monster_01",
  9:"announcer_killing_spree_announcer_kill_godlike_01",
  10:"announcer_killing_spree_announcer_kill_holy_01"  
}

var multiSound={
  2:"announcer_killing_spree_announcer_kill_double_01",
  3:"announcer_killing_spree_announcer_kill_triple_01",
  4:"announcer_killing_spree_announcer_kill_ultra_01",
  5:"announcer_killing_spree_announcer_kill_rampage_01"
}



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
    $.Schedule(0.1, function(){
       var eventListLabels=FindDotaHudElements("EventListLabel");
       var eventListLabel= eventListLabels[eventListLabels.length-1];
       eventListLabel.style['text-overflow'] = 'clip';
       //$.Msg(eventListLabel.FindChildrenWithClassTraverse ("CombatEventGoldIcon"))
       if (eventListLabel.FindChildrenWithClassTraverse ("CombatEventGoldIcon")[0] != undefined )
       {
           eventListLabel.style.width=(eventListLabel.FindChildrenWithClassTraverse ("CombatEventGoldIcon")[0].actualxoffset+70)+"px";
       }
       var eventListLabels=FindDotaHudElements("CombatEventHeroIcon");
       for (var i = eventListLabels.length-1; i >= 0; i--) {
           var eventListLabel= eventListLabels[i];
           eventListLabel.style.visibility = 'collapse'
       }
    });
}



function DotaKillStreak(keys)
{   
    
    var streakDelay = 0.1
    if ( Players.GetTeam( Players.GetLocalPlayer())>=6 )  
    {
      if (keys.killer_multikill>=2)
      {   
          if (keys.killer_multikill>=5) {keys.killer_multikill=5}
          Game.EmitSound(multiSound[keys.killer_multikill]);
          streakDelay=2
      }
      $.Schedule(streakDelay, function(){
         if (keys.killer_streak>10) {keys.killer_streak=10}
         Game.EmitSound(steakSound[keys.killer_streak]);
      });
      
      var creepData= CustomNetTables.GetTableValue( "player_creature_index", keys.killer_id)
      if (creepData!=undefined &&  creepData.creepIndex!=undefined && Entities.IsValidEntity(creepData.creepIndex))
      {
         if (Entities.GetLevel(creepData.creepIndex)>=10)
         {
           $.Schedule(streakDelay+2, function(){
             Game.EmitSound("announcer_killing_spree_announcer_ownage_01");
           });
         }
      } 
    }
}

function DotaFirstBlood(keys)
{   
  if ( Players.GetTeam( Players.GetLocalPlayer())>=6 )  
  {
     Game.EmitSound("announcer_killing_spree_announcer_1stblood_01");
  }
}





(function () {
    GameEvents.Subscribe( "dota_player_kill", DotaPlayerKill );
    GameEvents.Subscribe( "dota_chat_kill_streak", DotaKillStreak );
    GameEvents.Subscribe( "dota_chat_first_blood", DotaFirstBlood );

})();