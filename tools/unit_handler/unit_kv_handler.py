# -*- coding:utf-8 -*-
from itertools import combinations,permutations


f = open("npc_units_custom.txt","r",encoding='UTF-8') 
lines = f.readlines()


map={
   'npc_dota_creature_lich':{'glare_of_the_tyrant':('333','9756'),'shearing_deposition':('332','7576')}
}



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

       if holdingUnit:
         resultLines.append(line)
 print(''.join(resultLines))
 #print(resultLines)
 return resultLines



for key in map:
  temp = []
  for i in range(1, len(map[key])+1):
    combine = combinations(map[key], i)
    for tupleData in list(combine):
        result=""
        for data in tupleData:
         result=result+"_"+data
        #print(result)
        createNewUnit(key,result,map[key])