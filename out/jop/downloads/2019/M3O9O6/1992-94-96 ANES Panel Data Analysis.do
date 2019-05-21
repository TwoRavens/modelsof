*"Dixie's Drivers: Core Values and the Southern Republican Realignment*

*This project analyzes the sources of partisan change among southerners*
*and non-southerners from 1988 to 2016*
*Our specific endeavor is to assess the role of core values in the great*
*Southern Republican realignment*
*This project was conducted collaboratively with Seth C. McKee of Texas*
*Tech University*

*This Stata do file features code used to analyze both the American National* 
*Election Studies (ANES) Cumulative File (1948-2016) and the 1992-1997 ANES*
*Merged File*

*This analysis specifies cross-lagged panel models using the 1992-1996*
*American National Election Studies (ANES) panel surveys to examine the*
*potential reciprocal relationships among white Southerners' and* 
*non-Southerners' core political values and party identification*

*The code in this Stata do file produces article Table 3*

*This Stata do file corresponds to the final manuscript accepted* 
*for publication in the Journal of Politics*

*Wed. 8 November 2017*
*Wed. 15 November 2017*
*Thurs. 24 January 2019*

***************
*This analysis first requires that the researcher download the*
*ANES 1997 Merged File, which I have uploaded as part of these materials* 
*as the following Stata Data file: "1992-94-96 ANES Panel Study.dta"
****************

set more off

****************
*Recode the relevant demographic variable, race*
****************

*Note: For the record, the race variable consists of whites and non-whites,* 
*who in 1992 are American Indian, Alaskan native, Asian or Pacific Islander,* 
*black or other*

*Note:  This panel data analysis is restricted to whites only, as with the*
*primary empirical analysis in this paper, given that our theoretical focus*
*is the Southern realignment defined by whites' partisan change* 

*Race*

gen race92 = V924202
replace race92 = . if V924202 == 9
replace race92 = 0 if V924202 == 1
replace race92 = 1 if V924202 == 2
replace race92 = 1 if V924202 == 3
replace race92 = 1 if V924202 == 4
label var race92 ///
"race"
label define racial92 ///
0 "Whites" 1 "Non-whites" 
label values race92 racial92

*Here, we instruct Stata to restrict our analysis to white respondents*

keep if race92 == 0

****************
*Recode the region variable*

*Note: "South" will be the omitted reference category in the empirical* 
*analysis and compared to the other regions, which in this analysis are*
*identified as "Northeast," "North central" and "West"*

*The "South" in this coding scheme consists of the eleven secessionist*
*states: Alabama, Arkansas, Florida, Georgia, Louisiana, Mississippi,*
*North Carolina, South Carolina, Tennessee, Texas and Virginia*
****************

*South*

gen south92 = . 
replace south92 = . if V923017 == 99
replace south92 = 0 if V923017 < 40
replace south92 = 0 if V923017 == 51
replace south92 = 0 if V923017 == 52
replace south92 = 0 if V923017 == 53
replace south92 = 0 if V923017 == 56
replace south92 = 0 if V923017 >= 61 & V923017 <= 82
replace south92 = 1 if V923017 == 40
replace south92 = 1 if V923017 == 41
replace south92 = 1 if V923017 == 42
replace south92 = 1 if V923017 == 43
replace south92 = 1 if V923017 == 44
replace south92 = 1 if V923017 == 45
replace south92 = 1 if V923017 == 46
replace south92 = 1 if V923017 == 47
replace south92 = 1 if V923017 == 48
replace south92 = 1 if V923017 == 49
replace south92 = 1 if V923017 == 54
label var south92 ///
"South Region Dummy"
label define southern92 ///
0 "0 Non-south" 1 "1 South"
label values south92 southern92

****************
*Recode symbolic predispositions*
****************

*Party Identification*

*Note: partisanship runs from "strong Democrat" (0)* 
*to "strong republican" (6), with "3" representing true political independents*
*We do not label this variable because we will recode it to run from 0 to 1*
*for the purpose of comparison in our empirical analysis*

gen partyid92 = V923634
replace partyid92 = . if V923634 == 8
replace partyid92 = . if V923634 == 9
replace partyid92 = . if V923634 == 7
label var partyid92 ///
"Party Identification"

*Recode party identification to range from "0" to "1"*

*Note: The variable is coded in this fashion so that all primary predictors*
*of interest range from zero to one, enabling a clear comparison of effects*

replace partyid92 = partyid92/6

*Ideology*

*Note: The traditional measure of liberal-conservative self-identification* 
*will be considered "symbolic ideology" in this analysis*

*Note: Ideology is recoded such that "liberal" is coded as zero (0),* 
*"moderate" is coded as one (1) and "conservative" is coded as 2 (2)*
*We do not label this variable because we will recode it to run from 0 to 1*
*for the purpose of comparison in our empirical analysis*

gen ideology92 = V923513
replace ideology92 = . if V923513 == 0
replace ideology92 = . if V923513 == 7
replace ideology92 = . if V923513 == 8
replace ideology92 = . if V923513 == 9
replace ideology92 = 0 if V923513 == 1
replace ideology92 = 1 if V923513 == 3
replace ideology92 = 2 if V923513 == 5
label var ideology92 "Ideology"

*Recode ideology to range from "0" to "1"*

*Note: The variable is coded in this fashion so that all primary predictors*
*of interest range from zero to one, enabling a clear comparison of effects*

replace ideology92 = ideology92/2

****************
*Recode racial resentment variables*
****************

*Blacks should get ahead without any special favors*

gen blacksspecial92 = V926126
replace blacksspecial92 = . if V926126 == 8
replace blacksspecial92 = . if V926126 == 9
replace blacksspecial92 = 0 if V926126 == 5
replace blacksspecial92 = 1 if V926126 == 4
replace blacksspecial92 = 2 if V926126 == 3
replace blacksspecial92 = 3 if V926126 == 2
replace blacksspecial92 = 4 if V926126 == 1

*Blacks have gotten less than they deserve*

gen blacksgotless92 = V926127
replace blacksgotless92 = . if V926127 == 0
replace blacksgotless92 = . if V926127 == 8
replace blacksgotless92 = . if V926127 == 9
replace blacksgotless92 = 0 if V926127 == 1
replace blacksgotless92 = 1 if V926127 == 2
replace blacksgotless92 = 2 if V926127 == 3
replace blacksgotless92 = 3 if V926127 == 4
replace blacksgotless92 = 4 if V926127 == 5

*Blacks could succeed if they would try harder*

gen blackstry92 = V926128
replace blackstry92 = . if V926128 == 8
replace blackstry92 = . if V926128 == 9
replace blackstry92 = 0 if V926128 == 5
replace blackstry92 = 1 if V926128 == 4
replace blackstry92 = 2 if V926128 == 3
replace blackstry92 = 3 if V926128 == 2
replace blackstry92 = 4 if V926128 == 1

*Conditions have made it difficult for blacks to succeed*

gen conditionsblack92 = V926129
replace conditionsblack92 = . if V926129 == 8
replace conditionsblack92 = . if V926129 == 9
replace conditionsblack92 = 0 if V926129 == 1
replace conditionsblack92 = 1 if V926129 == 2
replace conditionsblack92 = 2 if V926129 == 3
replace conditionsblack92 = 3 if V926129 == 4
replace conditionsblack92 = 4 if V926129 == 5

****************
*Create a racial resentment scale*
****************

alpha blacksspecial92 blackstry92 blacksgotless92 conditionsblack92, detail ///
item generate (racialresentmentscale92)

*Recode the racial resentment scale to range from "0" to "1"*

*Note: The variable is coded in this fashion so that all primary predictors*
*of interest range from zero to one, allowing for a clear comparison* 
*of effects*

replace racialresentmentscale92 = racialresentmentscale92/4

****************
*Recode core values variables*
****************

****************
*Recode egalitarianism variables*

*Note: The equal rights, less equal and unequal variables* 
*are all reverse coded so that higher values indicate* 
*more conservative attitudes*
****************

*Do whatever is necessary for equal opportunity*

gen equalopp92 = V926024
replace equalopp92 = . if V926024 == 8 
replace equalopp92 = . if V926024 == 9
replace equalopp92 = 0 if V926024 == 1
replace equalopp92 = 1 if V926024 == 2
replace equalopp92 = 2 if V926024 == 3
replace equalopp92 = 3 if V926024 == 4
replace equalopp92 = 4 if V926024 == 5
label var equalopp92 /// 
"Our society should Do What is Necessary to ensure equal Opportunity"
label define equalopportunity92 ///
0 "0 Agree strongly" 1 "1 Agree somewhat" ///
2 "2 Neither agree nor disagree" 3 "3 Disagree somewhat" 4 "4 Disagree strongly"
label values equalopp92 equalopportunity92

*Have gone too far pushing equal rights
*Note: This variable is reverse coded so that higher values indicate* 
*more conservative attitudes*

gen equalrights92 = V926025
replace equalrights92 = . if V926025 == 8
replace equalrights92 = . if V926025 == 9
replace equalrights92 = 0 if V926025 == 5
replace equalrights92 = 1 if V926025 == 4
replace equalrights92 = 2 if V926025 == 3
replace equalrights92 = 3 if V926025 == 2
replace equalrights92 = 4 if V926025 == 1
label var equalrights92 "We Have gone Too far pushing equal rights"
label define equalrightspush92 ///
0 "0 Disagree strongly" 1 "1 Disagree somewhat" /// 
2 "2 Neither agree nor disagree" 3 "3 Agree somewhat" 4 "4 Agree strongly"
label values equalrights92 equalrightspush92

*Better off if we worried less about equality*
*Note: This variable is reverse coded so that higher values indicate* 
*more conservative attitudes*

gen lessequal92 = V926026
replace lessequal92 = . if V926026 == 8
replace lessequal92 = . if V926026 == 9
replace lessequal92 = 0 if V926026 == 5
replace lessequal92 = 1 if V926026 == 4
replace lessequal92 = 2 if V926026 == 3
replace lessequal92 = 3 if V926026 == 2
replace lessequal92 = 4 if V926026 == 1
label var lessequal92 ///
"This country Would Be Better Off if We Worried less about equality"
label define lessequality92 ///
0 "0 Disagree strongly" 1 "1 Disagree somewhat" /// 
2 "2 Neither agree nor disagree" 3 "3 Agree somewhat" 4 "4 Agree strongly"
label values lessequal92 lessequality92

*Not that big of a problem if people have more of a chance*
*Note: This variable is reverse coded so that higher values indicate* 
*more conservative attitudes*

gen unequal92 = V926027
replace unequal92 = . if V926027 == 8
replace unequal92 = . if V926027 == 9
replace unequal92 = 0 if V926027 == 5 
replace unequal92 = 1 if V926027 == 4 
replace unequal92 = 2 if V926027 == 3 
replace unequal92 = 3 if V926027 == 2 
replace unequal92 = 4 if V926027 == 1 
label var unequal92 /// 
"it is Not That Big of a Problem if Some People Have More of a Chance in Life"
label define unequalchance92 ///
0 "0 Disagree strongly" 1 "1 Disagree somewhat" ///
2 "2 Neither agree nor disagree" 3 "3 Agree somewhat" 4 "4 Agree strongly"
label values unequal92 unequalchance92

*Many fewer problems if people were treated equally*

gen fewer92 = V926028
replace fewer92 = . if V926028 == 8
replace fewer92 = . if V926028 == 9
replace fewer92 = 0 if V926028 == 1
replace fewer92 = 1 if V926028 == 2
replace fewer92 = 2 if V926028 == 3
replace fewer92 = 3 if V926028 == 4
replace fewer92 = 4 if V926028 == 5
label var fewer /// 
"If People were Treated more Equally in this Country We Would Have Many Fewer Problems"
label define Treatequally92 ///
0 "0 Agree strongly" 1 "1 Agree somewhat" ///
2 "2 Neither agree nor disagree" 3 "3 Disagree somewhat" 4 "4 Disagree strongly"
label values fewer92 Treatequally92

*Big problem is not giving everyone an equal chance*

gen equalchance92 = V926029
replace equalchance92 = . if V926029 == 8
replace equalchance92 = . if V926029 == 9
replace equalchance92 = 0 if V926029 == 1
replace equalchance92 = 1 if V926029 == 2
replace equalchance92 = 2 if V926029 == 3
replace equalchance92 = 3 if V926029 == 4
replace equalchance92 = 4 if V926029 == 5
label var equalchance92 /// 
"One of the Big problems in this country is Not giving everyone an equal chance"
label define equalchances92 /// 
0 "0 Agree strongly" 1 "1 Agree somewhat" ///
2 "2 Neither agree nor disagree" 3 "3 Disagree somewhat" 4 "4 Disagree strongly"
label values equalchance92 equalchances92

****************
*Create an egalitarianism scale constructed from the six indicators*
*of egalitarianism*
****************

alpha equalopp92 equalrights92 equalchance92 unequal92 lessequal92 fewer92, ///
detail item generate (equalityscale92) 

*Recode the egalitarianism scale to range from 0 to 1*
*Note: We rescale this variable differently because the maximum scale value*
*does not equal 4, but only 3.8333*

table equalityscale92
su equalityscale92, meanonly
gen egalitarianismscale92 = (equalityscale92 - r(min))/(r(max) - r(min))

****************
*Recode moral traditionalism variables*

*Note: The family and lifestyle variables are reverse coded so that higher* 
*values indicate more conservative attitudes*
****************

*Adjusting views of moral behavior*

gen changing92 = V926115
replace changing92 = . if V926115 == 8
replace changing92 = . if V926115 == 9
replace changing92 = 0 if V926115 == 1
replace changing92 = 1 if V926115 == 2
replace changing92 = 2 if V926115 == 3
replace changing92 = 3 if V926115 == 4
replace changing92 = 4 if V926115 == 5
label var changing92 /// 
"We should Adjust our Views of moral Behavior to changes in society"
label define changingmorals92 0 "Agree strongly" 1 "Agree somewhat" /// 
2 "Neither agree nor disagree" 3 "Disagree somewhat" 4 "Disagree strongly"
label values changing92 changingmorals92

*Tolerant of people who choose to live according to their own moral standards*

gen standards92 = V926116
replace standards92 = . if V926116 == 8
replace standards92 = . if V926116 == 9
replace standards92 = 0 if V926116 == 1
replace standards92 = 1 if V926116 == 2
replace standards92 = 2 if V926116 == 3
replace standards92 = 3 if V926116 == 4
replace standards92 = 4 if V926116 == 5
label var standards92 /// 
"We should Be more Tolerant of people Who choose to live According to Their Own moral standards"
label define standardsown92 ///
0 "0 Agree strongly" 1 "1 Agree somewhat" ///
2 "2 Neither agree nor disagree" 3 "3 Disagree somewhat" 4 "4 Disagree strongly"
label values standards92 standardsown92

*More emphasis on traditional family ties*
*Note: This variable is reverse coded so that higher values indicate* 
*more conservative attitudes*
 
gen family92 = V926117
replace family92 = . if V926117 == 8
replace family92 = . if V926117 == 9
replace family92 = 0 if V926117 == 5
replace family92 = 1 if V926117 == 4
replace family92 = 2 if V926117 == 3
replace family92 = 3 if V926117 == 2
replace family92 = 4 if V926117 == 1
label var family92 /// 
"This country Would Have many fewer problems if There Were more emphasis on Traditional family Ties"
label define familyties92 /// 
0 "0 Disagree strongly" 1 "1 Disagree somewhat" /// 
2 "2 Neither agree nor disagree" 3 "3 Agree somewhat" 4 "4 Agree strongly"
label values family92 familyties92
 
*Newer lifestyles contributing to a breakdown in society*
*Note: This variable is reverse coded so that higher values indicate* 
*more conservative attitudes*
 
gen lifestyles92 = V926118
replace lifestyles92 = . if V926118 == 8
replace lifestyles92 = . if V926118 == 9
replace lifestyles92 = 0 if V926118 == 5
replace lifestyles92 = 1 if V926118 == 4
replace lifestyles92 = 2 if V926118 == 3
replace lifestyles92 = 3 if V926118 == 2
replace lifestyles92 = 4 if V926118 == 1
label var lifestyles92 /// 
"Newer lifestyles are contributing to the Breakdown of society"
label define lifestylesnew92 ///
0 "0 Disagree strongly" 1 "1 Disagree somewhat" /// 
2 "2 Neither agree nor disagree" 3 "3 Agree somewhat" 4 "4 Agree strongly"
label values lifestyles92 lifestylesnew92

****************
*Create a moral traditionalism scale constructed from the four indicators*
*of moral traditionalism*
****************

alpha lifestyles92 changing92 family92 standards92, ///
detail item generate (moralityscale92) casewise

*Recode the moral traditionalism scale to range from 0 to 1*

*Note: The variable is coded in this fashion so that all primary predictors*
*of interest range from zero to one, allowing for a clear comparison* 
*of effects*

replace moralityscale92 = moralityscale92/4

****************
*1996 Data*
****************

****************
*Recode symbolic predispositions*
****************

*Party identification*

*Note: partisanship runs from "Strong Democrat" (0)* 
*to "Strong Republican" (6), with "3" representing true political independents*
*We do not label this variable because we will recode it to run from 0 to 1*
*for the purpose of comparison in our empirical analysis*

gen partyid96 = V960420
replace partyid96 = . if V960420 == 7
replace partyid96 = . if V960420 == 8
replace partyid96 = . if V960420 == 9
label var partyid96 ///
"Party Identification"

*Recode party identification to range from "0" to "1"*

*Note: The variable is coded in this fashion so that all primary predictors*
*of interest range from zero to one, allowing for a clear comparison* 
*of effects*

replace partyid96 = partyid96/6

*Ideology*

*Note: The traditional measure of liberal-conservative self-identification* 
*will be considered "symbolic ideology" in this analysis*

*Note: Ideology is recoded such that "liberal" is coded as zero (0),* 
*"moderate" is coded as one (1) and "conservative" is coded as 2 (2)*
*We do not label this variable because we will recode it to run from 0 to 1*
*for the purpose of comparison in our empirical analysis*

gen ideology96 = V961272
replace ideology96 = . if V961272 == 0
replace ideology96 = . if V961272 == 7
replace ideology96 = . if V961272 == 8
replace ideology96 = . if V961272 == 9
replace ideology96 = 0 if V961272 == 1
replace ideology96 = 1 if V961272 == 3
replace ideology96 = 2 if V961272 == 5

*Recode ideology to range from "0" to "1"*

*Note: The variable is coded in this fashion so that all primary predictors*
*of interest range from zero to one, allowing for a clear comparison* 
*of effects*

replace ideology96 = ideology96/2

****************
*Recode core values variables*
****************

****************
*Recode egalitarianism variables*

*Note: The equal rights, less equal and unequal variables* 
*are all reverse coded so that higher values indicate* 
*more conservative values*
****************

*Do whatever is necessary for equal opportunity*

gen equalopp96 = V961229
replace equalopp96 = . if V961229 == 0 
replace equalopp96 = . if V961229 == 8 
replace equalopp96 = . if V961229 == 9
replace equalopp96 = 0 if V961229 == 1
replace equalopp96 = 1 if V961229 == 2
replace equalopp96 = 2 if V961229 == 3
replace equalopp96 = 3 if V961229 == 4
replace equalopp96 = 4 if V961229 == 5
label var equalopp96 /// 
"Our Society Should Do What is Necessary to ensure equal Opportunity"
label define equalopportunity96 ///
0 "0 Agree strongly" 1 "1 Agree somewhat" ///
2 "2 Neither agree nor disagree" 3 "3 Disagree somewhat" 4 "4 Disagree strongly"
label values equalopp96 equalopportunity96

*Have gone too far pushing equal rights
*Note: This variable is reverse coded so that higher values indicate* 
*more conservative values*

gen equalrights96 = V961230
replace equalrights96 = . if V961230 == 0
replace equalrights96 = . if V961230 == 8
replace equalrights96 = . if V961230 == 9
replace equalrights96 = 0 if V961230 == 5
replace equalrights96 = 1 if V961230 == 4
replace equalrights96 = 2 if V961230 == 3
replace equalrights96 = 3 if V961230 == 2
replace equalrights96 = 4 if V961230 == 1
label var equalrights96 "We Have Gone Too Far pushing equal Rights"
label define equalrightspush96 ///
0 "0 Disagree strongly" 1 "1 Disagree somewhat" /// 
2 "2 Neither agree nor disagree" 3 "3 Agree somewhat" 4 "4 Agree strongly"
label values equalrights96 equalrightspush96

*Better off if we worried less about equality*
*Note: This variable is reverse coded so that higher values indicate* 
*more conservative values*

gen lessequal96 = V961232
replace lessequal96 = . if V961232 == 0
replace lessequal96 = . if V961232 == 8
replace lessequal96 = . if V961232 == 9
replace lessequal96 = 0 if V961232 == 5
replace lessequal96 = 1 if V961232 == 4
replace lessequal96 = 2 if V961232 == 3
replace lessequal96 = 3 if V961232 == 2
replace lessequal96 = 4 if V961232 == 1
label var lessequal96 ///
"This country Would Be Better Off if We Worried less about equality"
label define lessequality96 ///
0 "0 Disagree strongly" 1 "1 Disagree somewhat" /// 
2 "2 Neither agree nor disagree" 3 "3 Agree somewhat" 4 "4 Agree strongly"
label values lessequal96 lessequality96

*Not that big of a problem if people have more of a chance*
*Note: This variable is reverse coded so that higher values indicate* 
*more conservative values*

gen unequal96 = V961233
replace unequal96 = . if V961233 == 0
replace unequal96 = . if V961233 == 8
replace unequal96 = . if V961233 == 9
replace unequal96 = 0 if V961233 == 5 
replace unequal96 = 1 if V961233 == 4 
replace unequal96 = 2 if V961233 == 3 
replace unequal96 = 3 if V961233 == 2 
replace unequal96 = 4 if V961233 == 1 
label var unequal96 /// 
"it is Not That Big of a problem if Some people Have more of a chance in life"
label define unequalchance96 ///
0 "0 Disagree strongly" 1 "1 Disagree somewhat" ///
2 "2 Neither agree nor disagree" 3 "3 Agree somewhat" 4 "4 Agree strongly"
label values unequal96 unequalchance96

*Many fewer problems if people were treated equally*

gen fewer96 = V961234
replace fewer96 = . if V961234 == 0
replace fewer96 = . if V961234 == 8
replace fewer96 = . if V961234 == 9
replace fewer96 = 0 if V961234 == 1
replace fewer96 = 1 if V961234 == 2
replace fewer96 = 2 if V961234 == 3
replace fewer96 = 3 if V961234 == 4
replace fewer96 = 4 if V961234 == 5
label var fewer96 /// 
"if people Were Treated more equally in this country We Would Have many Fewer problems"
label define Treatequally96 ///
0 "0 Agree strongly" 1 "1 Agree somewhat" ///
2 "2 Neither agree nor disagree" 3 "3 Disagree somewhat" 4 "4 Disagree strongly"
label values fewer96 treatequally96

*Big problem is not giving everyone an equal chance*

gen equalchance96 = V961231
replace equalchance96 = . if V961231 == 0
replace equalchance96 = . if V961231 == 8
replace equalchance96 = . if V961231 == 9
replace equalchance96 = 0 if V961231 == 1
replace equalchance96 = 1 if V961231 == 2
replace equalchance96 = 2 if V961231 == 3
replace equalchance96 = 3 if V961231 == 4
replace equalchance96 = 4 if V961231 == 5
label var equalchance96 /// 
"One of the Big problems in this country is Not Giving everyone an equal chance"
label define equalchances96 /// 
0 "0 Agree strongly" 1 "1 Agree somewhat" ///
2 "2 Neither agree nor disagree" 3 "3 Disagree somewhat" 4 "4 Disagree strongly"
label values equalchance96 equalchances96

****************
*Create an egalitarianism scale constructed from the six indicators*
*of egalitarianism*
****************

alpha equalopp96 equalrights96 equalchance96 unequal96 lessequal96 fewer96, ///
detail item generate (egalitarianismscale96)

*Recode the egalitarianism scale to range from 0 to 1*

*Note: The variable is coded in this fashion so that all primary predictors*
*of interest range from zero to one, allowing for a clear comparison* 
*of effects*

replace egalitarianismscale96 = egalitarianismscale96/4

****************
*Recode moral traditionalism variables*

*Note: The family and lifestyle variables are reverse coded so that higher* 
*values indicate more conservative values*
****************

*Adjusting views of moral behavior*

gen changing96 = V961248
replace changing96 = . if V961248 == 0
replace changing96 = . if V961248 == 8
replace changing96 = . if V961248 == 9
replace changing96 = 0 if V961248 == 1
replace changing96 = 1 if V961248 == 2
replace changing96 = 2 if V961248 == 3
replace changing96 = 3 if V961248 == 4
replace changing96 = 4 if V961248 == 5
label var changing96 /// 
"We Should Adjust our Views of moral Behavior to changes in Society"
label define changingmorals96 0 "Agree strongly" 1 "Agree somewhat" /// 
2 "Neither agree nor disagree" 3 "Disagree somewhat" 4 "Disagree strongly"
label values changing96 changingmorals96

*Tolerant of people who choose to live according to their own moral standards*

gen standards96 =V961250
replace standards96 = . if V961250 == 0
replace standards96 = . if V961250 == 8
replace standards96 = . if V961250 == 9
replace standards96 = 0 if V961250 == 1
replace standards96 = 1 if V961250 == 2
replace standards96 = 2 if V961250 == 3
replace standards96 = 3 if V961250 == 4
replace standards96 = 4 if V961250 == 5
label var standards96 /// 
"We Should Be more Tolerant of people Who choose to live According to Their Own moral Standards"
label define standardsown96 ///
0 "0 Agree strongly" 1 "1 Agree somewhat" ///
2 "2 Neither agree nor disagree" 3 "3 Disagree somewhat" 4 "4 Disagree strongly"
label values standards96 standardsown96

*More emphasis on traditional family ties*
*Note: This variable is reverse coded so that higher values indicate* 
*more conservative values*
 
gen family96 = V961249
replace family96 = . if V961249 == 0
replace family96 = . if V961249 == 8
replace family96 = . if V961249 == 9
replace family96 = 0 if V961249 == 5
replace family96 = 1 if V961249 == 4
replace family96 = 2 if V961249 == 3
replace family96 = 3 if V961249 == 2
replace family96 = 4 if V961249 == 1
label var family96 /// 
"This Country Would Have Many Fewer Problems if There Were more Emphasis on Traditional Family Ties"
label define familyties96 /// 
0 "0 Disagree strongly" 1 "1 Disagree somewhat" /// 
2 "2 Neither agree nor disagree" 3 "3 Agree somewhat" 4 "4 Agree strongly"
label values family96 familyties96
 
*Newer lifestyles contributing to a breakdown in society*
*Note: This variable is reverse coded so that higher values indicate* 
*more conservative values*
 
gen lifestyles96 = V961247
replace lifestyles96 = . if V961247 == 0
replace lifestyles96 = . if V961247 == 8
replace lifestyles96 = . if V961247 == 9
replace lifestyles96 = 0 if V961247 == 5
replace lifestyles96 = 1 if V961247 == 4
replace lifestyles96 = 2 if V961247 == 3
replace lifestyles96 = 3 if V961247 == 2
replace lifestyles96 = 4 if V961247 == 1
label var lifestyles96 /// 
"Newer lifestyles are contributing to the Breakdown of Society"
label define lifestylesnew96 ///
0 "0 Disagree strongly" 1 "1 Disagree somewhat" /// 
2 "2 Neither agree nor disagree"  3 "3 Agree somewhat" 4 "4 Agree strongly"
label values lifestyles96 lifestylesnew96

****************
*Create a moral traditionalism scale constructed from the four indicators* 
*of moral traditionalism*
****************

alpha lifestyles96 changing96 family96 standards96, ///
detail item generate (moralityscale96)

*Recode the moral traditionalism scale to range from 0 to 1*

*Note: The variable is coded in this fashion so that all primary predictors*
*of interest range from zero to one, allowing for a clear comparison* 
*of effects*

replace moralityscale96 = moralityscale96/4

****************
*Analyze the potential reciprocal relationship between core values and*
*partisanship among both Southerners and non-Southerners using 1992 and 1996*
*ANES panel data*
****************

*Keep only variables in this dataset relevant to the immediate panel analysis*
*in the interest of clarity*

keep race92 south92 partyid92 ideology92 racialresentmentscale92 ///
egalitarianismscale92 moralityscale92 partyid96 ideology96 ///
egalitarianismscale96 moralityscale96 

*Note: This dataset is saved as the* 
*following: "1992-94-96 ANES Panel Data Analysis Dataset.dta"*

****************
*Specify a cross-lagged model in which egalitarianism and partisanship in 1996*
*are the dependent variables in order to assess whether or not each variable's* 
*1992 value influences the other's 1996 value*
****************

*Egalitarianism*

sem (egalitarianismscale96 <- egalitarianismscale92 partyid92 ideology92 ///
racialresentmentscale92) /// 
(partyid96 <- partyid92 egalitarianismscale92 ideology92 ///
racialresentmentscale92), group(south92)

****************
*Specify a cross-lagged model in which moral traditionalism and partisanship* 
*in 1996 are the dependent variables in order to assess whether or not each* 
*variable's 1992 value influence on the other's 1996 value*
****************

*Moral traditionalism*

sem (moralityscale96 <- moralityscale92 partyid92 ideology92 ///
racialresentmentscale92) /// 
(partyid96 <- partyid92 moralityscale92 ideology92 ///
racialresentmentscale92), group(south92)

****************
*Supplemental analysis*
****************

****************
*Specify a cross-lagged model in which ideology and partisanship* 
*in 1996 are the dependent variables in order to assess whether each* 
*variable's 1992 value influences the other's 1996 value*
****************

sem (ideology96 <- ideology92 partyid92 egalitarianismscale92 ///
moralityscale92 racialresentmentscale92) /// 
(partyid96 <- partyid92 ideology92 egalitarianismscale92 moralityscale92 ///
racialresentmentscale92), group(south92)

