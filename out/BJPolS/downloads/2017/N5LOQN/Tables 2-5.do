*****************************************************
*Replication file for "Hafner-Burton, Hyde and Jablonski. 
*Surviving Elections: Election Violence, Incumbent Victory, and Post-Election Repercussions" 
*British Journal of Political Science. Accepted November 2015
*
*These models were stimated using Stata/SE 13.0
* Estimates Tables 2-5, including the prediction for Figures 2 and 3
* Predictions for Figure 2 and 3 were estimated using the margins command with controls set at the mean
*****************************************************

use BJPSReplication12112015, clear

***TABLE 2****
*Model 1
xi:logit incumbentwins  preelecviolence ma_physint prefraud age sumten civwar gdp pop uncertain ma_polity2  any_demonstration  if  incumbentrun==1 & competitive==1, robust cluster(ccode)
*Model 2
xi:logit incumbentwins  preelecviolence ma_physint prefraud age sumten civwar gdp pop uncertain ma_polity2  any_demonstration preelectionprotest if  incumbentrun==1 & competitive==1, robust cluster(ccode)
*Model 3
xi:logit incumbentwins  preelecviolence ma_physint age sumten civwar gdp pop uncertain ma_polity2  any_demonstration  preelectionprotest if incumbentrun==1 & competitive==1 , robust cluster(ccode)

***FIGURE 2 PREDICTIONS**
*Estimates the point predictions based upon the minimum and maximum values of each of the variables in Model 2
qui logit incumbentwins  preelecviolence ma_physint prefraud age sumten civwar gdp pop uncertain ma_polity2  any_demonstration preelectionprotest if  incumbentrun==1 & competitive==1, robust cluster(ccode)
local testvars="preelecviolence prefraud ma_physint age sumten civwar gdp pop uncertain ma_polity2  any_demonstration"
foreach testvar of local testvars {
	qui sum `testvar'
	qui margins, at((mean) _all `testvar'=`r(min)' ) 
	matrix mx = r(table)
	local p_min1 = mx[1,1]
	local s_min1 = mx[2,1]
	qui sum `testvar'
	qui margins, at((mean) _all `testvar'=`r(max)' ) 
	matrix mx = r(table)
	local p_min2 = mx[1,1]
	local s_min2 = mx[2,1]
	local p_diff=`p_min2'-`p_min1'
	local s_diff=sqrt((`s_min2'^2)+(`s_min1'^2))
	local upper = `p_diff'+1.96*`s_diff'
	local lower = `p_diff'-1.96*`s_diff'
	display `p_diff'
	display `upper'
	display `lower'
}


***TABLE 3****
*Model 1
logit boycott preelecviolence ma_physint age sumten civwar gdp pop uncertain ma_polity2 any_demonstration  if incumbentrun==1 & competitive==1, robust cluster(ccode)
*Model 2
logit incumbentwins preelecviolence boycott  prefraud ma_physint  age sumten civwar gdp pop uncertain ma_polity2 any_demonstration  if incumbentrun==1 & competitive==1 , robust cluster(ccode)
*Model 3
logit incumbentwins  preelecviolence boycott boycottviolence prefraud ma_physint  age sumten civwar gdp pop uncertain ma_polity2 any_demonstration if incumbentrun==1 & competitive==1 , robust cluster(ccode)


***FIGURE 3 PREDICTIONS***
*Estimates point predictions based upon the possible values of boycotts and pre-election violence
margins, at((mean) _all boycott=0 preelecviolence=0 boycottviolence=0)
matrix mx = r(table)
local pred1_mean= mx[1,1]
local pred1_ll= mx[5,1]
local pred1_ul= mx[6,1]
matrix drop mx
margins, at((mean) _all boycott=1 preelecviolence=0 boycottviolence=0)
matrix mx = r(table)
local pred2_mean= mx[1,1]
local pred2_ll= mx[5,1]
local pred2_ul= mx[6,1]
matrix drop mx
margins, at((mean) _all boycott=0 preelecviolence=1 boycottviolence=0)
matrix mx = r(table)
local pred3_mean= mx[1,1]
local pred3_ll= mx[5,1]
local pred3_ul= mx[6,1]
matrix drop mx
margins, at((mean) _all boycott=1 preelecviolence=1 boycottviolence=1)
matrix mx = r(table)
local pred4_mean= mx[1,1]
local pred4_ll= mx[5,1]
local pred4_ul= mx[6,1]
matrix drop mx
display "`pred1_mean',`pred2_mean',`pred3_mean',`pred4_mean'"
display "`pred1_ll',`pred2_ll',`pred3_ll',`pred4_ll'"
display "`pred1_ul',`pred2_ul',`pred3_ul',`pred4_ul'"


***TABLE 4****
*Model 1
regress vt preelecviolence  uncertain prefraud ma_physint  age sumten civwar gdp pop ma_polity2 any_demonstration compulsory multipleround if incumbentrun==1 & competitive==1 & finalround==1, robust cluster(ccode)
*Model 2
logit incumbentwins  preelecviolence uncertain vt prefraud ma_physint  age sumten civwar gdp pop ma_polity2 any_demonstration compulsory multipleround  if incumbentrun==1 & competitive==1 & finalround==1, robust cluster(ccode)
*Model 3
logit incumbentwins  turnoutviolence preelecviolence uncertain vt prefraud ma_physint  age sumten civwar gdp pop ma_polity2 any_demonstration compulsory multipleround  if incumbentrun==1 & competitive==1 & finalround==1,  robust cluster(ccode)

**TABLE 5**
*Model 1
logit protest  preelecviolence  ma_physint age sumten civwar gdp pop  ma_polity2  prefraud  preelectionprotest if incumbentrun==1 & competitive==1 & incumbentwon==1, robust cluster(ccode)
*Model 2
logit concessions protest preelecviolence ma_physint age sumten civwar gdp pop ma_polity2   prefraud   preelectionprotest any_demonstration if   competitive==1 & incumbentrun==1 & incumbentwon==1, robust cluster(ccode)
*Model 3
logit concessions protest repressprotest preelecviolence ma_physint age sumten civwar gdp pop ma_polity2 prefraud  preelectionprotest any_demonstration if   competitive==1 & incumbentrun==1 & incumbentwon==1, robust cluster(ccode)
*Model 4
logit concessions protest repressprotest preelecviolence ma_physint age sumten civwar gdp pop ma_polity2 prefraud  preelectionprotest any_demonstration if   competitive==1 & incumbentrun==1 & incumbentwon==1, robust cluster(ccode)
*Model 5
logit concessions protest repressprotest preelecviolenceXrepressprotest preelecviolence ma_physint age sumten civwar gdp pop ma_polity2 prefraud  preelectionprotest any_demonstration if   competitive==1 & incumbentrun==1 & incumbentwon==1, robust cluster(ccode)
