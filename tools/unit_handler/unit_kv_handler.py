# -*- coding:utf-8 -*-
from itertools import combinations,permutations


f = open("../../game/dota_addons/darwin_dark_forest/scripts/npc/npc_units_custom.txt","r",encoding='UTF-8') 
lines = f.readlines()


map={
   'npc_dota_creature_lich':{'glare_of_the_tyrant':('333','9756'),'shearing_deposition':('332','7576')},
   'npc_dota_creature_lich_rime_lord':{'glare_of_the_tyrant':('12636','9756'),'shearing_deposition':('12637','7576')},
   'npc_dota_creature_lich_serakund_tyrant':{'glare_of_the_tyrant':('8519','9756'),'shearing_deposition':('8520','7576')},
   
   'npc_dota_creature_pudge':{'dragonclaw_hook':('5955','4007'),'feast_of_abscession':('5950','7756'),'golden_rippers_reel':('5955','8038'),'golden_scavenging_guttleslug':('5954','7742')},
   'npc_dota_creature_pudge_plague_champion':{'dragonclaw_hook':('8501','4007'),'feast_of_abscession':('8496','7756'),'golden_rippers_reel':('8501','8038'),'golden_scavenging_guttleslug':('8500','7742')},
   'npc_dota_creature_pudge_surgical_precision':{'dragonclaw_hook':('7546','4007'),'feast_of_abscession':('7542','7756'),'golden_rippers_reel':('7546','8038'),'golden_scavenging_guttleslug':('7541','7742')},
   
   'npc_dota_creature_venomancer':{'cult_of_aktok':('291','9558')},
   'npc_dota_creature_venomancer_deathbringer':{'cult_of_aktok':('6643','9558')},
   'npc_dota_creature_venomancer_stalker':{'cult_of_aktok':('9916','9558')},
   'npc_dota_creature_venomancer_ferocious_toxicant':{'cult_of_aktok':('9894','9558')},
   
   'npc_dota_creature_faceless_void':{'bracers_of_aeons_of_the_crimson_witness':('92','7996'),'jewel_of_aeons':('91','8268'),'mace_of_aeons':('15','7571'),'timebreaker':('15','4264')},
   'npc_dota_creature_faceless_void_endless_plane':{'bracers_of_aeons_of_the_crimson_witness':('8374','7996'),'jewel_of_aeons':('7378','8268'),'mace_of_aeons':('7379','7571'),'timebreaker':('7379','4264')},
   'npc_dota_creature_faceless_void_nezzureem':{'bracers_of_aeons_of_the_crimson_witness':('12656','7996'),'jewel_of_aeons':('12655','8268'),'mace_of_aeons':('12658','7571'),'timebreaker':('12658','4264')},
   
   'npc_dota_creature_spectre':{'soul_diffuser':('395','6894'),'transversant_soul':('325','9129'),'transversant_soul_of_the_crimson_witness':('325','9204')},
   'npc_dota_creature_spectre_enduring_solitude':{'soul_diffuser':('9512','6894'),'transversant_soul':('9513','9129'),'transversant_soul_of_the_crimson_witness':('9513','9204')},
   'npc_dota_creature_spectre_conservator':{'soul_diffuser':('7521','6894'),'transversant_soul':('7520','9129'),'transversant_soul_of_the_crimson_witness':('7520','9204')},
   
   'npc_dota_creature_ancient_apparition':{'shatterblast_core':('648','9462'),'shatterblast_crown':('172','7462')},
   'npc_dota_creature_old_element':{'shatterblast_core':('12571','9462'),'shatterblast_crown':('12572','7462')},
   
   'npc_dota_creature_enigma':{'world_chasm_artifact':('559','8326')},
   'npc_dota_creature_primal_void':{'world_chasm_artifact':('9474','8326')},
   'npc_dota_creature_void_overlord':{'world_chasm_artifact':('12329','8326')},

   'npc_dota_creature_broodmother':{'lycosidae_brood':('103','9090')},
   'npc_dota_creature_broodmother_glutton_larder':{'lycosidae_brood':('8565','9090')},
   'npc_dota_creature_spider_queen':{'lycosidae_brood':('9797','9090')},

   'npc_dota_creature_razor':{'severing_lash':('340','8000'),'golden_severing_crest':('341','6916')},
   'npc_dota_creature_razor_lightning_lord':{'severing_lash':('340','8000'),'golden_severing_crest':('9353','6916')},
   'npc_dota_creature_razor_affront_of_the_overseer':{'severing_lash':('340','8000'),'golden_severing_crest':('8608','6916')},
 
   'npc_dota_creature_riki':{'crimson_edict_of_shadows':('163','12418'),'golden_edict_of_shadows':('163','9773'),'golden_shadow_masquerade':('164','7990'),'shadow_masquerade':('164','7976')},
   'npc_dota_creature_dream_secret':{'crimson_edict_of_shadows':('6549','12418'),'golden_edict_of_shadows':('6549','9773'),'golden_shadow_masquerade':('6550','7990'),'shadow_masquerade':('6550','7976')},
   'npc_dota_creature_nightmare_hunter':{'crimson_edict_of_shadows':('5327','12418'),'golden_edict_of_shadows':('5327','9773'),'golden_shadow_masquerade':('164','7990'),'shadow_masquerade':('164','7976')},
  
   'npc_dota_creature_centaur_khan':{'golden_infernal_chieftain':('6497','8039'),'infernal_chieftain_of_the_crimson_witness':('6497','8036'),'infernal_menace':('6500','12945')},
   'npc_dota_creature_centaur_warchief':{'golden_infernal_chieftain':('8481','8039'),'infernal_chieftain_of_the_crimson_witness':('8481','8036'),'infernal_menace':('8485','12945')},

}


localizeMap={
   'npc_dota_creature_lich':'巫妖',
   'npc_dota_creature_lich_rime_lord':'雾凇领主',
   'npc_dota_creature_lich_serakund_tyrant':'寒域暴君',
   'npc_dota_creature_pudge':'屠夫',
   'npc_dota_creature_pudge_plague_champion':'瘟神勇士',
   'npc_dota_creature_pudge_surgical_precision':'恐怖外科医生',
   'npc_dota_creature_venomancer':'剧毒术士',
   'npc_dota_creature_venomancer_deathbringer':'死亡传播者',
   'npc_dota_creature_venomancer_stalker':'绝岛追猎者',
   'npc_dota_creature_venomancer_ferocious_toxicant':'极恶猛毒',
   'npc_dota_creature_faceless_void':'虚空假面',
   'npc_dota_creature_faceless_void_endless_plane':'无尽平行',
   'npc_dota_creature_faceless_void_nezzureem':'奥玄岩晶',
   'npc_dota_creature_spectre':'幽鬼',
   'npc_dota_creature_spectre_enduring_solitude':'恒久孤寂',
   'npc_dota_creature_spectre_conservator':'汇聚幽魂',
   'npc_dota_creature_ancient_apparition':'极寒幽魂',
   'npc_dota_creature_old_element':'衡势晶体',
   'npc_dota_creature_enigma':'谜团',
   'npc_dota_creature_primal_void':'虚空尊者',
   'npc_dota_creature_void_overlord':'虚空大君',
   'npc_dota_creature_broodmother':'育母蜘蛛',
   'npc_dota_creature_broodmother_glutton_larder':'饕餮蛛母',
   'npc_dota_creature_spider_queen':'蜘蛛女皇',
   'npc_dota_creature_razor':'闪电幽魂',
   'npc_dota_creature_razor_lightning_lord':'闪电帝国领主',
   'npc_dota_creature_razor_affront_of_the_overseer':'监察之蔑',
   'npc_dota_creature_riki':'隐形刺客',
   'npc_dota_creature_dream_secret':'梦魇王子',
   'npc_dota_creature_nightmare_hunter':'梦魇猎杀者',
   'npc_dota_creature_centaur_khan':'半人马可汗',
   'npc_dota_creature_centaur_warchief':'半人马大酋长',

}


econUnitBeginsFlag=False
#这是原版文件部分
reLines=[]
#后面部分
econLines=[]


for line in lines:
  
  if econUnitBeginsFlag==False:
     reLines.append(line)
  if "EconUnitBegins" in line:
     econUnitBeginsFlag=True



def createNewUnit(originalUnitName,suffix,map):

 holdingUnit=None
 inWearables=False
 resultLines=[]
 replaceMap={}
 
 for key in map:
   if key in suffix:
     replaceMap[map[key][0]]=map[key][1]
 
 for lineIndex in range(0, len(lines)):
    line=lines[lineIndex]
    
    if '"'+originalUnitName+'"' in line:
       holdingUnit=originalUnitName
       braceNumber=0
       resultLines.append(line.replace(originalUnitName,originalUnitName+suffix))
       continue
    if holdingUnit:
       if 'HasInventory' in line:
          resultLines.append('\t\t"EconUnitFlag"              "1"\n')
       if '{' in line:
          braceNumber=braceNumber+1
       if  '}' in line:
          braceNumber=braceNumber-1
       #遍历需要替换的数组
       for key in replaceMap:
       	if key in line:
       	   line=line.replace(key,replaceMap[key])
       if braceNumber==0:
          holdingUnit=None
       resultLines.append(line)
 econLines.extend(resultLines)

 #print(''.join(resultLines))
 #print(resultLines)
 return resultLines


def printNewLocalize(originalUnitName,suffix):

 print('"'+originalUnitName+suffix+'"                  "'+localizeMap[originalUnitName]+'"')




for key in map:
  temp = []
  for i in range(1, len(map[key])+1):
    combine = combinations(map[key], i)
    for tupleData in list(combine):
        result=""
        for data in tupleData:
         result=result+"_"+data
        createNewUnit(key,result,map[key])
        printNewLocalize(key,result)

f.close()

with open('../../game/dota_addons/darwin_dark_forest/scripts/npc/npc_units_custom.txt','w',encoding='UTF-8') as f:
  for line in reLines:
    f.write(line)
  for line in econLines:
    f.write(line)
  f.write('}')