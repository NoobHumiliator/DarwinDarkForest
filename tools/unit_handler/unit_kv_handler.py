# -*- coding:utf-8 -*-
from itertools import combinations,permutations

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

   'npc_dota_creature_razor':{'golden_severing_crest':('341','6916'),'severing_lash':('340','8000')},
   'npc_dota_creature_razor_lightning_lord':{'golden_severing_crest':('9353','6916'),'severing_lash':('340','8000')},
   'npc_dota_creature_razor_affront_of_the_overseer':{'golden_severing_crest':('8608','6916'),'severing_lash':('340','8000')},
 
   'npc_dota_creature_riki':{'crimson_edict_of_shadows':('163','12418'),'golden_edict_of_shadows':('163','9773'),'golden_shadow_masquerade':('164','7990'),'shadow_masquerade':('164','7976')},
   'npc_dota_creature_dream_secret':{'crimson_edict_of_shadows':('6549','12418'),'golden_edict_of_shadows':('6549','9773'),'golden_shadow_masquerade':('6550','7990'),'shadow_masquerade':('6550','7976')},
   'npc_dota_creature_nightmare_hunter':{'crimson_edict_of_shadows':('5327','12418'),'golden_edict_of_shadows':('5327','9773'),'golden_shadow_masquerade':('164','7990'),'shadow_masquerade':('164','7976')},
  
   'npc_dota_creature_centaur_khan':{'golden_infernal_chieftain':('6497','8039'),'infernal_chieftain_of_the_crimson_witness':('6497','8036'),'infernal_menace':('6500','12945')},
   'npc_dota_creature_centaur_warchief':{'golden_infernal_chieftain':('8481','8039'),'infernal_chieftain_of_the_crimson_witness':('8481','8036'),'infernal_menace':('8485','12945')},

   'npc_dota_creature_life_stealer':{'golden_dread_requisition':('444','12998'),'golden_profane_union':('8659','9215'),'profane_union':('8659','9199')},
   'npc_dota_creature_life_stealer_bond_of_madness':{'golden_dread_requisition':('6476','12998'),'golden_profane_union':('6478','9215'),'profane_union':('6478','9199')},
   'npc_dota_creature_life_stealer_chainbreaker':{'golden_dread_requisition':('9106','12998'),'golden_profane_union':('9107','9215'),'profane_union':('9107','9199')},
   
   'npc_dota_creature_spirit_breaker':{'iron_surge':('111','8234'),'savage_mettle':('113','9744')},
   'npc_dota_creature_spirit_breaker_ironbarde_charger':{'iron_surge':('9551','8234'),'savage_mettle':('9546','9744')},
   'npc_dota_creature_spirit_breaker_elemental_realms':{'iron_surge':('7456','8234'),'savage_mettle':('7455','9744')},
    
   'npc_dota_creature_ogre_double_head_mage':{'auspice_of_the_whyrlegyge':('133','7910'),'gimlek_decanter':('105','12318')},
   'npc_dota_creature_ogre_double_head_antipodeans':{'auspice_of_the_whyrlegyge':('7845','7910'),'gimlek_decanter':('7848','12318')},
   'npc_dota_creature_ogre_imperator':{'auspice_of_the_whyrlegyge':('7612','7910'),'gimlek_decanter':('7611','12318')},
   
   'npc_dota_creature_troll_warlord':{'bitter_lineage':('373','7818')},
   'npc_dota_creature_troll_warlord_icewrack_marauder':{'bitter_lineage':('9597','7818')},
   'npc_dota_creature_troll_plunder_of_the_savage_monger':{'bitter_lineage':('12561','7818')},

   'npc_dota_creature_clinkz':{'maraxiforms_ire':('59','9162')},
   'npc_dota_creature_clinkz_scorched_fletcher':{'maraxiforms_ire':('7141','9162')},
   'npc_dota_creature_clinkz_compendium_scorched_fletcher':{'maraxiforms_ire':('7349','9162')},

   'npc_dota_creature_sand_king':{'barren_crown':('180','8074'),'barren_vector':('199','7809')},
   'npc_dota_creature_sand_king_scouring_dunes':{'barren_crown':('6613','8074'),'barren_vector':('6612','7809')},
   'npc_dota_creature_sand_king_kray_legions':{'barren_crown':('9432','8074'),'barren_vector':('9433','7809')},

   'npc_dota_creature_bane':{'slumbering_terror':('613','7692')},
   'npc_dota_creature_bane_heir_of_terror':{'slumbering_terror':('7944','7692')},
   'npc_dota_creature_bane_lucid_torment':{'slumbering_terror':('8550','7692')},
   
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
   'npc_dota_creature_life_stealer':'噬魂鬼',
   'npc_dota_creature_life_stealer_bond_of_madness':'癫狂之缚',
   'npc_dota_creature_life_stealer_chainbreaker':'破链之刑',
   'npc_dota_creature_spirit_breaker':'裂魂人',
   'npc_dota_creature_spirit_breaker_ironbarde_charger':'钢甲冲锋者',
   'npc_dota_creature_spirit_breaker_elemental_realms':'黑钢杀戮者',

   'npc_dota_creature_ogre_double_head_mage':'双头食人魔法师',
   'npc_dota_creature_ogre_double_head_antipodeans':'双头食人战争魔法师',
   'npc_dota_creature_ogre_imperator':'食人魔帝国元首',
   
   'npc_dota_creature_troll_warlord':'巨魔战将',
   'npc_dota_creature_troll_warlord_icewrack_marauder':'巨魔劫掠者',
   'npc_dota_creature_troll_plunder_of_the_savage_monger':'巨魔竞技场冠军',

   'npc_dota_creature_sand_king':'沙王',
   'npc_dota_creature_sand_king_scouring_dunes':'沙丘之蚀',
   'npc_dota_creature_sand_king_kray_legions':'鳌虾之王',

   'npc_dota_creature_clinkz':'克林克兹',
   'npc_dota_creature_clinkz_scorched_fletcher':'闷燃弓手',
   'npc_dota_creature_clinkz_compendium_scorched_fletcher':'焦燃枯骨',

   'npc_dota_creature_bane':'祸乱之源',
   'npc_dota_creature_bane_heir_of_terror':'恐惧之裔',
   'npc_dota_creature_bane_lucid_torment':'无休折磨',
   

}


localizeMapEn={
   'npc_dota_creature_lich':'Lich',
   'npc_dota_creature_lich_rime_lord':'Rime Lord',
   'npc_dota_creature_lich_serakund_tyrant':'Serakund Tyrant',
   'npc_dota_creature_pudge':'Pudge',
   'npc_dota_creature_pudge_plague_champion':'Plague Champion',
   'npc_dota_creature_pudge_surgical_precision':'Surgical Precision',
   'npc_dota_creature_venomancer':'Venomancer',
   'npc_dota_creature_venomancer_deathbringer':'Deathbringer',
   'npc_dota_creature_venomancer_stalker':'Stalker',
   'npc_dota_creature_venomancer_ferocious_toxicant':'Ferocious Toxicant',
   'npc_dota_creature_faceless_void':'Faceless Void',
   'npc_dota_creature_faceless_void_endless_plane':'Endless Plane',
   'npc_dota_creature_faceless_void_nezzureem':'Nezzureem',
   'npc_dota_creature_spectre':'spectre',
   'npc_dota_creature_spectre_enduring_solitude':'Enduring Solitude',
   'npc_dota_creature_spectre_conservator':'Conservator',
   'npc_dota_creature_ancient_apparition':'Ancient Apparition',
   'npc_dota_creature_old_element':'Equilibrium',
   'npc_dota_creature_enigma':'Enigma',
   'npc_dota_creature_primal_void':'Primal Void',
   'npc_dota_creature_void_overlord':'Void Overlord',
   'npc_dota_creature_broodmother':'Broodmother',
   'npc_dota_creature_broodmother_glutton_larder':'Glutton Larder',
   'npc_dota_creature_spider_queen':'Spider Queen',
   'npc_dota_creature_razor':'Razor',
   'npc_dota_creature_razor_lightning_lord':'Lightning Lord',
   'npc_dota_creature_razor_affront_of_the_overseer':'Affront of Overseer',
   'npc_dota_creature_riki':'Riki',
   'npc_dota_creature_dream_secret':'Nightmare Prince',
   'npc_dota_creature_nightmare_hunter':'Nightmare Hunter',
   'npc_dota_creature_centaur_khan':'Centaur Khan',
   'npc_dota_creature_centaur_warchief':'Centaur Warchief',
   'npc_dota_creature_life_stealer':'Life Stealer',
   'npc_dota_creature_life_stealer_bond_of_madness':'Bond of Madness',
   'npc_dota_creature_life_stealer_chainbreaker':'Chain Breaker',
   'npc_dota_creature_spirit_breaker':'Spirit Breaker',
   'npc_dota_creature_spirit_breaker_ironbarde_charger':'Ironbarde Charger',
   'npc_dota_creature_spirit_breaker_elemental_realms':'Elemental Realms',

   'npc_dota_creature_ogre_double_head_mage':'Ogre Double Head Mage',
   'npc_dota_creature_ogre_double_head_antipodeans':'Ogre War Mage',
   'npc_dota_creature_ogre_imperator':'Ogre Emperor',
   
   'npc_dota_creature_troll_warlord':'Troll Warlord',
   'npc_dota_creature_troll_warlord_icewrack_marauder':'Icewrack Marauder',
   'npc_dota_creature_troll_plunder_of_the_savage_monger':'Troll Arena Champion',



   'npc_dota_creature_sand_king':'Sand King',
   'npc_dota_creature_sand_king_scouring_dunes':'Scouring Dunes',
   'npc_dota_creature_sand_king_kray_legions':'Kray Legions',

   'npc_dota_creature_clinkz':'Clinkz',
   'npc_dota_creature_clinkz_scorched_fletcher':'Scorched Fletcher',
   'npc_dota_creature_clinkz_compendium_scorched_fletcher':'Compendium Scorched Fletcher',

   'npc_dota_creature_bane':'Bane',
   'npc_dota_creature_bane_heir_of_terror':'Heir of Terror',
   'npc_dota_creature_bane_lucid_torment':'Lucid Torment',
}


econUnitBeginsFlag=False
playerUsableUnitBeginsFlag=False

#这是原版文件部分
reLines=[]
#饰品生物部分
econLines=[]
#玩家生物
playerUnitLines=[]


f = open("../../game/dota_addons/darwin_dark_forest/scripts/npc/npc_units_custom.txt","r",encoding='UTF-8') 
lines = f.readlines()


for line in lines:
  
  if econUnitBeginsFlag==False:
     reLines.append(line)
     if playerUsableUnitBeginsFlag:
       playerUnitLines.append(line.replace("npc_dota_creature_", "npc_dota_creature_player_"))
       if "HasInventory" in line:
        playerUnitLines.append('\t\t"ConsideredHero"             "1"')

  if "EconUnitBegins" in line:
     econUnitBeginsFlag=True
  if "//Level-1" in line:
     playerUsableUnitBeginsFlag=True

f.close()

econUnitBeginsFlag=False
#国际化文件原版部分
lReLines=[]
#国际化文件后面部分
lEconLines=[]
#国际化文件玩家生物部分
lPlyaerLines=[]

lf = open("../../game/dota_addons/darwin_dark_forest/resource/addon_schinese.txt","r",encoding='UTF-8') 
lLines = lf.readlines()

for line in lLines:
  
  if econUnitBeginsFlag==False:
     lReLines.append(line)
     if "npc_dota_creature_" in line:
      lPlyaerLines.append(line.replace("npc_dota_creature_", "npc_dota_creature_player_"))

  if "EconUnitBegins" in line:
     econUnitBeginsFlag=True

lf.close()


econUnitBeginsFlag=False
lReLinesEn=[]
lEconLinesEn=[]
lPlyaerLinesEn=[]

lf = open("../../game/dota_addons/darwin_dark_forest/resource/addon_english.txt","r",encoding='UTF-8') 
lLines = lf.readlines()

for line in lLines:
  
  if econUnitBeginsFlag==False:
     lReLinesEn.append(line)
     if "npc_dota_creature_" in line:
      lPlyaerLinesEn.append(line.replace("npc_dota_creature_", "npc_dota_creature_player_"))

  if "EconUnitBegins" in line:
     econUnitBeginsFlag=True

lf.close()






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
          resultLines.append('\t\t"ConsideredHero"              "1"\n')
       if '{' in line:
          braceNumber=braceNumber+1
       if  '}' in line:
          braceNumber=braceNumber-1
       #遍历需要替换的数组
       for key in replaceMap:
       	if (key in line) and ("ItemDef" in line):
       	   line=line.replace(key,replaceMap[key])
       if braceNumber==0:
          holdingUnit=None
       resultLines.append(line)
 econLines.extend(resultLines)

 #print(''.join(resultLines))
 #print(resultLines)
 return resultLines


def printNewLocalize(originalUnitName,suffix):
 
 lEconLines.append('\t"'+originalUnitName+suffix+'"                  "'+localizeMap[originalUnitName]+'"\n')
 lEconLinesEn.append('\t"'+originalUnitName+suffix+'"                  "'+localizeMapEn[originalUnitName]+'"\n')




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


with open('../../game/dota_addons/darwin_dark_forest/scripts/npc/npc_units_custom.txt','w',encoding='UTF-8') as f:
  for line in reLines:
    f.write(line)
  for line in econLines:
    f.write(line)
  f.write('\t//PlayerUnitBegins\n') 
  for line in playerUnitLines:
    f.write(line)
  f.write('}')
f.close()

with open('../../game/dota_addons/darwin_dark_forest/resource/addon_schinese.txt','w',encoding='UTF-8') as lf:
  for line in lReLines:
    lf.write(line)
  for line in lEconLines:
    lf.write(line)
  lf.write('\t//PlayerUnitBegins\n') 
  for line in lPlyaerLines:
    lf.write(line)
  lf.write('\t}\n')
  lf.write('}')
lf.close()


with open('../../game/dota_addons/darwin_dark_forest/resource/addon_english.txt','w',encoding='UTF-8') as lf:
  for line in lReLinesEn:
    lf.write(line)
  for line in lEconLinesEn:
    lf.write(line)
  lf.write('\t//PlayerUnitBegins\n') 
  for line in lPlyaerLinesEn:
    lf.write(line)
  lf.write('\t}\n')
  lf.write('}')
lf.close()