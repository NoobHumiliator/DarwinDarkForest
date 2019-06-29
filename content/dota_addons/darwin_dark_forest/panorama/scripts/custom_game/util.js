function FindDotaHudElement(id){
    var hudRoot;
    for(panel=$.GetContextPanel();panel!=null;panel=panel.GetParent()){
        hudRoot = panel;
    }
    var comp = hudRoot.FindChildTraverse(id);
    return comp;
}



function FindDotaHudElementByClass(className){
    var hudRoot;
    for(panel=$.GetContextPanel();panel!=null;panel=panel.GetParent()){
        hudRoot = panel;
    }
    var comp = hudRoot.FindChildrenWithClassTraverse(className);
    if (comp.length>0)
    {
        return comp[0];
    } 
    else 
    {
        return null;
    }
}



function ConvertToSteamid64(steamid32)  //32位转64位
{
    var steamid64 = '765' + (parseInt(steamid32) + 61197960265728).toString();
    return steamid64;
}

function ConvertToSteamId32(steamid64) {   //64位转32位
    return steamid64.substr(3) - 61197960265728;
}

function FormatSeconds(value) {
    var theTime = parseInt(value);// 秒
    var theTime1 = 0;// 分
    var theTime2 = 0;// 小时
    if(theTime > 60) {
        theTime1 = parseInt(theTime/60);
        theTime = parseInt(theTime%60);
            if(theTime1 > 60) {
            theTime2 = parseInt(theTime1/60);
            theTime1 = parseInt(theTime1%60);
            }
    }
        var result = ""+parseInt(theTime)+"\"";
        if(theTime1 > 0) {
           result = ""+parseInt(theTime1)+"\'"+result;
        }
        if(theTime2 > 0) {
          result = ""+parseInt(theTime2)+":"+result;
        }
    return result;
}

function DrawRandomFromArray (arr,num){

    var result = [];

    for (var i = 0; i < num; i++) {
        var ran = Math.floor(Math.random() * arr.length);
        result.push(arr.splice(ran, 1)[0]);
    }

    return result;

};

var ShowAbilityTooltip = ( function( ability )
{
    return function()
    {
        $.DispatchEvent( "DOTAShowAbilityTooltip", ability, ability.abilityname );
    }
});

var HideAbilityTooltip = ( function( ability )
{
    return function()
    {
        $.DispatchEvent( "DOTAHideAbilityTooltip", ability );
    }
});


function TipsOver(message, pos){
    if ($("#"+pos)!=undefined)
    {
       $.DispatchEvent( "DOTAShowTextTooltip", $("#"+pos), $.Localize(message));
    }
}

function TipsOut(){
    $.DispatchEvent( "DOTAHideTitleTextTooltip");
    $.DispatchEvent( "DOTAHideTextTooltip");
}

