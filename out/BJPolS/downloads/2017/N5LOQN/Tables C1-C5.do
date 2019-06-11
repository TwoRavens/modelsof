*****************************************************
*Replication file for "Hafner-Burton, Hyde and Jablonski. 
*Surviving Elections: Election Violence, Incumbent Victory, and Post-Election Repercussions" 
*British Journal of Political Science. Accepted November 2015
*
*These models were stimated using Stata/SE 13.0
*****************************************************

use BJPSReplication12112015, clear


***TABLE C1**
*Model 1
xi:xtlogit incumbentwins  preelecviolence ma_physint age sumten civwar gdp pop uncertain ma_polity2  any_demonstration   if incumbentrun==1 & competitive==1, re 
*Model 2
xi:xtlogit incumbentwins  preelecviolence ma_physint age sumten civwar gdp pop uncertain ma_polity2  any_demonstration   if incumbentrun==1 & competitive==1, fe 
*Model 3
xtlogit protest  preelecviolence  ma_physint age sumten civwar gdp pop  ma_polity2  preelectionprotest if incumbentrun==1 & competitive==1 & incumbentwon==1, re
*Model 4
xtlogit protest  preelecviolence  ma_physint age sumten civwar gdp pop  ma_polity2  preelectionprotest if incumbentrun==1 & competitive==1 & incumbentwon==1, fe
*Model 5
xtlogit concessions protest preelecviolence ma_physint age sumten civwar gdp pop ma_polity2    preelectionprotest if   competitive==1 & incumbentrun==1 & incumbentwon==1 , re
*Model 6
xtlogit concessions protest repressprotest preelecviolence ma_physint age sumten civwar gdp pop ma_polity2    preelectionprotest if   competitive==1 & incumbentrun==1 & incumbentwon==1 , re

***TABLE C2**
*Model 1
xi:logit incumbentwins   bothviolence ma_physint age sumten civwar gdp pop uncertain ma_polity2  any_demonstration   if incumbentrun==1 & competitive==1,  robust cluster(ccode)
*Model 2
xi:logit incumbentwins   nelda15 ma_physint age sumten civwar gdp pop uncertain ma_polity2  any_demonstration   if incumbentrun==1 & competitive==1,  robust cluster(ccode)
*Model 3
xi:logit incumbentwins  nelda33 ma_physint age sumten civwar gdp pop uncertain ma_polity2  any_demonstration   if incumbentrun==1 & competitive==1,  robust cluster(ccode)
*Model 4
logit boycott bothviolence ma_physint age sumten civwar gdp pop uncertain ma_polity2 any_demonstration  if incumbentrun==1 & competitive==1, robust cluster(ccode)
*Model 5
logit boycott nelda15 ma_physint age sumten civwar gdp pop uncertain ma_polity2 any_demonstration  if incumbentrun==1 & competitive==1, robust cluster(ccode)
*Model 6
logit boycott nelda33 ma_physint age sumten civwar gdp pop uncertain ma_polity2 any_demonstration  if incumbentrun==1 & competitive==1, robust cluster(ccode)
*Model 7
regress vt bothviolence  uncertain ma_physint  gdp pop any_demonstration   ma_polity2 civwar  age sumten prefraud compulsory multipleround  if incumbentrun==1 & competitive==1 & finalround==1, robust cluster(ccode)
*Model 8
regress vt nelda15  uncertain ma_physint  gdp pop any_demonstration   ma_polity2 civwar  age sumten prefraud compulsory multipleround  if incumbentrun==1 & competitive==1 & finalround==1, robust cluster(ccode)
*Model 9
regress vt nelda33  uncertain ma_physint  gdp pop any_demonstration   ma_polity2 civwar  age sumten prefraud compulsory multipleround  if incumbentrun==1 & competitive==1 & finalround==1, robust cluster(ccode)
*Model 10
logit protest  bothviolence  ma_physint age sumten civwar gdp pop  ma_polity2  preelectionprotest if incumbentrun==1 & competitive==1 & incumbentwon==1, robust cluster(ccode)
*Model 11
logit protest  nelda15  ma_physint age sumten civwar gdp pop  ma_polity2  preelectionprotest if incumbentrun==1 & competitive==1 & incumbentwon==1, robust cluster(ccode)
*Model 12
logit protest  nelda33  ma_physint age sumten civwar gdp pop  ma_polity2  preelectionprotest if incumbentrun==1 & competitive==1 & incumbentwon==1, robust cluster(ccode)

***TABLE C3**
local control "nelda45"
logit incumbentwins preelecviolence ma_physint age sumten civwar gdp pop uncertain ma_polity2  any_demonstration `control'  if incumbentrun==1 & competitive==1,  robust cluster(ccode)
local control "log_media2 log_media5"
logit incumbentwins preelecviolence ma_physint age sumten civwar gdp pop uncertain ma_polity2  any_demonstration `control'  if incumbentrun==1 & competitive==1,  robust cluster(ccode)
local control "log_revenue_cap"
logit incumbentwins preelecviolence ma_physint age sumten civwar gdp pop uncertain ma_polity2  any_demonstration `control'  if incumbentrun==1 & competitive==1,  robust cluster(ccode)
local control "nelda45"
logit boycott preelecviolence ma_physint age sumten civwar gdp pop uncertain ma_polity2 any_demonstration `control' if incumbentrun==1 & competitive==1, robust cluster(ccode)
local control "log_media2 log_media5"
logit boycott preelecviolence ma_physint age sumten civwar gdp pop uncertain ma_polity2 any_demonstration `control' if incumbentrun==1 & competitive==1, robust cluster(ccode)
local control "log_revenue_cap"
logit boycott preelecviolence ma_physint age sumten civwar gdp pop uncertain ma_polity2 any_demonstration `control' if incumbentrun==1 & competitive==1, robust cluster(ccode)
local control "nelda45"
logit protest  preelecviolence  ma_physint age sumten civwar gdp pop  ma_polity2  preelectionprotest `control' if incumbentrun==1 & competitive==1 & incumbentwon==1, robust cluster(ccode)
local control "log_media2 log_media5"
logit protest  preelecviolence  ma_physint age sumten civwar gdp pop  ma_polity2  preelectionprotest `control' if incumbentrun==1 & competitive==1 & incumbentwon==1, robust cluster(ccode)
local control "log_revenue_cap"
logit protest  preelecviolence  ma_physint age sumten civwar gdp pop  ma_polity2  preelectionprotest `control' if incumbentrun==1 & competitive==1 & incumbentwon==1, robust cluster(ccode)

*** TABLE C4***
*Model 1
logit protest  preelecviolence  prefraud ma_physint age sumten civwar gdp pop  ma_polity2 incumbentwon preelectionprotest if incumbentrun==1 & competitive==1, robust cluster(ccode)
*Model 2
logit concessions protest preelecviolence prefraud ma_physint age sumten civwar gdp pop ma_polity2  incumbentwon  preelectionprotest if   competitive==1 & incumbentrun==1 , robust cluster(ccode)
*Model 3
logit concessions protest preelecviolence repressprotest prefraud ma_physint age sumten civwar gdp pop ma_polity2  incumbentwon  preelectionprotest if   competitive==1 & incumbentrun==1 , robust cluster(ccode)
*Model 4
logit concessions protest preelecviolence preelecviolenceXprotest repressprotest prefraud ma_physint age sumten civwar gdp pop ma_polity2  incumbentwon  preelectionprotest if   competitive==1 & incumbentrun==1 , robust cluster(ccode)
*Model 5
logit concessions protest preelecviolence preelecviolenceXrepressprotest repressprotest prefraud ma_physint age sumten civwar gdp pop ma_polity2  incumbentwon  preelectionprotest if   competitive==1 & incumbentrun==1 , robust cluster(ccode)

*** TABLE C5***
local control "speech"
*Model 1
logit incumbentwins preelecviolence ma_physint age sumten civwar gdp pop uncertain ma_polity2  any_demonstration `control'  if incumbentrun==1 & competitive==1,  robust cluster(ccode)
*Model 2
logit boycott preelecviolence ma_physint age sumten civwar gdp pop uncertain ma_polity2 any_demonstration `control' if incumbentrun==1 & competitive==1, robust cluster(ccode)
*Model 3
logit protest  preelecviolence  ma_physint age sumten civwar gdp pop  ma_polity2  preelectionprotest `control' if incumbentrun==1 & competitive==1 & incumbentwon==1, robust cluster(ccode)

