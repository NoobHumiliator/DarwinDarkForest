
var options = {
    startPosition:1,                        //开始位置
    stopPosition:1,                         //停止位置
    totalCircle:1000,                       //滚动的圈数 (设置为无限大，滚动期间等待服务器回传)
    speed:0.4,                              //正常速度  （这里的速度就是定时器的时间间隔，间隔越短，速度越快）
    speedUp:0.1,                            //加速的时候速度
    speedDown:0.6,                          //减速的时候速度
    speedUpPosition:3,                      //加速点
    speedDownPosition:5,                    //减速点    
    domNumber:14                             
 };




function BuildLottery(){


	for (var i=1;i<=options.domNumber;i++){

		var parentPanel= $("#LotteryCell_"+i)
        var id = "lottery_cell_container_"+i;
		var newItemPanel = $.CreatePanel("Panel", parentPanel,id);

        newItemPanel.BLoadLayoutSnippet("LotteryItem");
        newItemPanel.FindChildTraverse("lottery_item_title").text = $.Localize("econ_unknow");
        newItemPanel.FindChildTraverse("lottery_item_image").SetImage("file://{resources}/images/custom_game/econ/blank.png");
	}
}



function ResetLottery(){


    for (var i=1;i<=options.domNumber;i++){
        var panel= $("#LotteryCell_"+i)
        panel.FindChildTraverse("lottery_item_title").text = $.Localize("econ_unknow");
        panel.FindChildTraverse("lottery_item_image").SetImage("file://{resources}/images/custom_game/econ/blank.png");
        
        //重置稀有度
        panel.FindChildTraverse("lottery_item_rarity").RemoveClass("Rarity_Rare")
        panel.FindChildTraverse("lottery_item_title_panel").RemoveClass("TitleRare")
        
        panel.FindChildTraverse("lottery_item_rarity").RemoveClass("Rarity_Mythical")
        panel.FindChildTraverse("lottery_item_title_panel").RemoveClass("TitleMythical")

        panel.FindChildTraverse("lottery_item_rarity").RemoveClass("Rarity_Immortal")
        panel.FindChildTraverse("lottery_item_title_panel").RemoveClass("TitleImmortal")

    }

}



var LotteryInitSpeed=0.4
var LotteryCircle = 0
var LotteryCircleStep = 0
var IsLotteryFinish= false;





function StartLottery(){
    
    //正在滚动，不进行触发
	if(LotteryCircleStep !=0 ) {
        return false;
    }
    
    ResetLottery()
     
    //等2秒再发 服务器请求
    $.Schedule(1.5,DrawLotteryFromServer);

    Scroll();
}

function DrawLotteryFromServer() {
    
     var playerId = Game.GetLocalPlayerInfo().player_id;
    GameEvents.SendCustomGameEventToServer( "DrawLottery", {playerId:playerId} );
    
}

function PopOutNotify() {
    $("#new_item_notify").RemoveClass("Hidden")
}

function HideNotify() {
    $("#new_item_notify").AddClass("Hidden")
}



function CloseLottery(){
    $("#page_lottery").AddClass("Hidden");
}

function Scroll () {

    if(IsLotteryFinish){
        //结束定时任务 恢复初始化参数
        PopOutNotify();
        LotteryCircle=0;
        LotteryCircleStep=0;
        options.speed = LotteryInitSpeed;
        IsLotteryFinish = false;			
        return;
    }

    
    ChangeNext();
    $.Schedule(options.speed,Scroll);
}

//加速
function SpeedUp () {
    if(LotteryCircleStep == options.speedUpPosition){
        options.speed = options.speedUp;
    }
}
function SpeedDown () {

    var tmp1 = options.stopPosition-options.speedDownPosition;
    var tmp2 = options.totalCircle+1;
    if(tmp1<=0){
        tmp1 = options.domNumber + tmp1;
        tmp2 = tmp2-1;
    }

    if(options.startPosition==tmp1 && LotteryCircle==tmp2)
        options.speed = options.speedDown;
}

function ChangeDomClass () {


	var panel= $("#LotteryCell_"+options.startPosition)
    panel.AddClass("Active")
    
    
    if(options.startPosition==1) {
      var lastpanel= $("#LotteryCell_"+options.domNumber)
      lastpanel.RemoveClass("Active")
    } else {
      var lastpanel= $("#LotteryCell_"+(options.startPosition-1))
      lastpanel.RemoveClass("Active")
    }
    
    options.startPosition++;
}



function ChangeNext() {

    LotteryCircleStep++;
    //完成一圈
    if(options.startPosition==options.domNumber+1){
        options.startPosition=1;
        LotteryCircle++;
    }

    if(LotteryCircle==options.totalCircle+1 && options.startPosition==options.stopPosition){
        IsLotteryFinish = true;
    }
    ChangeDomClass();
    SpeedUp();
    SpeedDown();
}


function SetFakeCells(number,level,array){

    var indexs = DrawRandomFromArray(array,number)

    for (var i = indexs.length - 1; i >= 0; i--) {
        var panel = $("#LotteryCell_"+indexs[i])
        var econ_rarity = CustomNetTables.GetTableValue("econ_rarity", "econ_rarity");
        
        var temp=[]
        for(var key in econ_rarity){
          if (econ_rarity[key]==level)
          {
            temp.push(key)
          }
        }
        var item_name = temp[Math.floor((Math.random()*temp.length))]
        
        SetPanelRarity(econ_rarity[item_name],panel)
        panel.FindChildTraverse("lottery_item_title").text = $.Localize("econ_"+item_name);
        panel.FindChildTraverse("lottery_item_image").SetImage("file://{resources}/images/custom_game/econ/"+item_name+".png");
    }

}


function DrawLotteryResultArrive(data)
{   
   if (data.type==1 || data.type==2)
   {
        var arrayObj = new Object();
        arrayObj.array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]; 
        
        var econ_rarity = CustomNetTables.GetTableValue("econ_rarity", "econ_rarity");
        var targetLevel=econ_rarity[data.item_name]  


        var playerId = Game.GetLocalPlayerInfo().player_id;     //玩家ID
        var steam_id = Game.GetPlayerInfo(playerId).player_steamid;
         steam_id = ConvertToSteamId32(steam_id);

        //设置目标位置
        var targetIndex = DrawRandomFromArray(arrayObj.array,1)[0]       
        var targetPanel = $("#LotteryCell_"+targetIndex)
        targetPanel.FindChildTraverse("lottery_item_title").text = $.Localize("econ_"+data.item_name);
        targetPanel.FindChildTraverse("lottery_item_image").SetImage("file://{resources}/images/custom_game/econ/"+data.item_name+".png");
        SetPanelRarity(targetLevel,targetPanel)


        //设置通告版
        var notifyPanel = $("#new_item_notify_container")
        notifyPanel.FindChildTraverse("lottery_new_item_title").text = $.Localize("econ_"+data.item_name);
        notifyPanel.FindChildTraverse("lottery_new_item_image").SetImage("file://{resources}/images/custom_game/econ/"+data.item_name+".png");
        SetPanelRarity(targetLevel,notifyPanel)
        if (data.type==1)
        {
            notifyPanel.FindChildTraverse("refund_container").RemoveClass("Hidden")
            notifyPanel.FindChildTraverse("lottery_refund_text").text = "  X  "+data.refund;
             $("#new_item_notify_label").text=$.Localize("RefundItem");
        }
         if (data.type==2)
        {
            notifyPanel.FindChildTraverse("refund_container").AddClass("Hidden")
            $("#new_item_notify_label").text=$.Localize("CongratulationNewItem");
            
            var econ_data = CustomNetTables.GetTableValue("econ_data", "econ_data");
            var playerData=econ_data[steam_id]
            var length=Object.keys(playerData).length;

            var newData={}
            newData.name=data.item_name
            newData.equip="false"

            playerData[length+1]=newData;
            playerData.playerId=playerId

            GameEvents.SendCustomGameEventToServer ( "EconDataRefresh",playerData); //通知前台更新NetTable
            
        }

        //设置假砖块位置 根据真砖块等级 减少假砖块数量
        SetFakeCells(targetLevel==4?0:1,4,arrayObj.array)
        SetFakeCells(targetLevel==3?1:2,3,arrayObj.array)
        SetFakeCells(targetLevel==2?3:4,2,arrayObj.array)
        SetFakeCells(targetLevel==1?6:7,1,arrayObj.array)

        //服务器返回了 当前圈数 + 2 圈滚动结束
        options.totalCircle = LotteryCircle+ 2;
        //停止位置为真砖块的位置
        options.stopPosition = targetIndex
        //减速点 随机4-7之间一个值
        options.speedDownPosition = Math.floor(Math.random()*(7-4+1)+4);
   }

}

//设置砖块的稀有度
function SetPanelRarity(rarityLevel,panel) {


    if (rarityLevel==1) {
        panel.FindChildTraverse("lottery_item_rarity").text = $.Localize("rarity_normal");
    }

   if (rarityLevel==2) {
        panel.FindChildTraverse("lottery_item_rarity").text = $.Localize("rarity_rare");
        panel.FindChildTraverse("lottery_item_rarity").AddClass("Rarity_Rare")
        panel.FindChildTraverse("lottery_item_title_panel").AddClass("TitleRare")
    }
    if (rarityLevel==3) {
        panel.FindChildTraverse("lottery_item_rarity").text = $.Localize("rarity_mythical");
        panel.FindChildTraverse("lottery_item_rarity").AddClass("Rarity_Mythical")
        panel.FindChildTraverse("lottery_item_title_panel").AddClass("TitleMythical")
    }
    if (rarityLevel==4) {
        panel.FindChildTraverse("lottery_item_rarity").text = $.Localize("rarity_immortal");
        panel.FindChildTraverse("lottery_item_rarity").AddClass("Rarity_Immortal")
        panel.FindChildTraverse("lottery_item_title_panel").AddClass("TitleImmortal")
    }

}



(function()
{
    BuildLottery();
    GameEvents.Subscribe( "DrawLotteryResultArrive", DrawLotteryResultArrive ); //持久化服务器对于抽奖处理完毕
})();
