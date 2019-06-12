*Tables and figures for June 2014 Jerusalem paper (later chapter 6 of book))
*
*  This version: produce tables and results for version in ISQ research note
*
*using file: RCE_USUOF_final.dta
*   do file: RCE_USUOF_ISQ_final.do
* gener variable year for use later [exists in file]
*gener year=year(edate)


*Table 1: average gender difference by episodes and N of items
tabstat men_f wom_f sexgap if sexgap~=.,by(epis2) labelwidth(150) format(%5.0f) stats(mean)
tabstat men_f wom_f sexgap if sexgap~=.,by(epis2) labelwidth(150) format(%5.0f) stats(n)
*
*
* Figure 1: gender differences by half decade
gener halfdec=0
label var halfdec "half decades"
replace halfdec=1 if year<1986
replace halfdec=2 if year>1985 & year<1991
replace halfdec=3 if year>1990 & year<1996
replace halfdec=4 if year>1995 & year<2001
replace halfdec=5 if year>2000 & year<2006
replace halfdec=6 if year>2005 
*label define halfdec 1 "1982-1985"
*label define halfdec 2 "1986-1990",add
*label define halfdec 3 "1991-1995",add
*label define halfdec 4 "1996-2000",add
*label define halfdec 5 "2001-2005",add
*label define halfdec 6 "2006-2013",add
*label values halfdec halfdec
tabstat sexgap if sexgap~=.,by(halfdec) labelwidth(150) format(%5.0f) stats(mean)
*
*
* Table 2:  by action type
*
tabstat men_f wom_f sexgap if sexgap~=.,by(action) labelwidth(150) format(%5.0f) stats(mean n)
*
* Table 3:  by PPO
tabstat men_f wom_f sexgap if sexgap~=.,by(PPO) labelwidth(150) format(%5.0f) stats(mean)
tabstat men_f wom_f sexgap if sexgap~=.,by(PPO) labelwidth(150) format(%5.0f) stats(n)

* Casualty analyses: Tables 4 and 5
* 
* First Table 4
*
* gener filter variable for wars in Afghanistan and Iraq
gener iraq_af=0
replace iraq_af=1 if epis2==18|epis2==19
* now top of Table 4 ....excluding Iraq and Afghanistan
tabstat men_f wom_f sexgap if iraq_af==0,by(anydeath) stats(mean) format(%5.0f)
*confidence interval
ci men_f wom_f sexgap if iraq_==0 & anydeath==0 , level(95)
*now with casualties
*confidence interval
ci men_f wom_f sexgap if iraq_==0 & anydeath==1 , level(95)
*
*
* Now bottom of table for Afghanistan and Iraq
* Afghanistan
tabstat men_f wom_f sexgap if epis2==18,by(anydeath) stats(mean) format(%5.0f)
*confidence interval
ci men_f wom_f sexgap if epis2==18 & anydeath==0 , level(95)
*now with casualties
*confidence interval
ci men_f wom_f sexgap if epis2==18 & anydeath==1 , level(95)
*
*  Iraq
tabstat men_f wom_f sexgap if epis2==19,by(anydeath) stats(mean)
*confidence interval
ci men_f wom_f sexgap if epis2==19 & anydeath==0 , level(95)
*now with casualties
*confidence interval
ci men_f wom_f sexgap if epis2==19 & anydeath==1 , level(95)
* 
* finally: bottom of Table 4, all episodes combined
tabstat men_f wom_f sexgap,by(anydeath) stats(mean)
*confidence interval
ci men_f wom_f sexgap if anydeath==0 , level(95)
*now with casualties
*confidence interval
ci men_f wom_f sexgap if anydeath==1 , level(95)
*
*  end Table 4
*
*  Table 5...casualty analysis Afghanistan/Iraq
*
*look at afgh and iraq 2001-2013
* Iraq
tabstat men_f wom_f sexgap if anydeath==0 & year>2000 & epis2==19,by(year) labelwidth(150) format(%5.0f) stats(mean)
tabstat men_f wom_f sexgap if anydeath==1 & year>2000 & epis2==19,by(year) labelwidth(150) format(%5.0f) stats(mean)
*
* Afghanistan
set more off
tabstat men_f wom_f sexgap if anydeath==0 & year>2000 & epis2==18,by(year) labelwidth(150) format(%5.0f) stats(mean)
tabstat men_f wom_f sexgap if anydeath==1 & year>2000 & epis2==18,by(year) labelwidth(150) format(%5.0f) stats(mean)
*
* end Table 5
*
* Table 6: multilateralism
*
tabstat men_f wom_f sexgap,by(multi) labelwidth(100) format (%5.0f)
tabstat men_f wom_f sexgap,by(multi) labelwidth(100) format (%5.0f) stats(n)
*
* confidence interval 
mean sexgap, over (multi)
*
* end Table 6
*
* Table 7: regression analysis of gender difference
*  and VARIABLE LABELS FOR OUT REGRESS
*
*

label var PKEEP "Peacekeeping operations"
label var send "send troops"
label var ground "ground troops"
label var aironly "air or missile strikes"
label var sell "sell/provide weapons"
label var anydeath "casualties mentioned"
label var UN "United Nations mentioned"
label var NATO "NATO mentioned"
label var terror "terror or terrorism mentioned"
*
*
*
*
* Regression Table 7: all episodes combined
*
*
*   re-do for ISQ research note July 2014
*   now with clustered standard errors
*
* generate variables for regressions
*
*
gener repub=0
replace repub=1 if year<1993
replace repub=1 if year>2000 & year<2009
label var repub "republican president = 1"
gener iraq_afg=0
replace iraq_afg=1 if epis2==18|epis2==19
label var iraq_afg "filter variable for Iraq and Afghanistan Wars"
gener keep=0
replace keep=1 if action==6
gener increase=0
replace increase=1 if action==7
label var keep "keep/maintain troops"
label var increase "increase troops"
gener war=0
replace war=1 if action==9
label var war "war"
*
*
order men_fav wom_fav sexgap HUM IPC PKEEP send keep increase ground aironly sell war retal anydeath UN NATO terror repub


regress men_f HUM-send keep-sell war retal anydeath-NATO terror repub,vce(cluster epis2)
outreg2 using e:/ISQ_note_regress,label  alpha(0.01,0.05) 2aster ctitle(Men) slow(100) replace
regress wom_f HUM-send keep-sell war retal anydeath-NATO terror repub,vce(cluster epis2)
outreg2 using e:/ISQ_note_regress, label  alpha(0.01,0.05) 2aster ctitle(Women) append
regress sexgap HUM-send keep-sell war retal anydeath-NATO terror repub,vce(cluster epis2)
outreg2 using e:/ISQ_note_regress, label  alpha(0.01,0.05) 2aster ctitle(Gender difference) append
*
*Now without Iraq and Afgh wars
*
regress men_f HUM-send keep-sell war retal anydeath-NATO terror repub if iraq_afg==0,vce(cluster epis2)
outreg2 using e:/ISQ_note_regress, label  alpha(0.01,0.05) 2aster ctitle(Men) 
regress wom_f HUM-send keep-sell war retal anydeath-NATO terror repub if iraq_afg==0,vce(cluster epis2)
outreg2 using e:/ISQ_note_regress, label  alpha(0.01,0.05) 2aster ctitle(Women) append
regress sexgap HUM-send keep-sell war retal anydeath-NATO terror repub if iraq_afg==0,vce(cluster epis2)
outreg2 using e:/ISQ_note_regress, label  alpha(0.01,0.05) 2aster ctitle(Gender difference) append
*
summ men_f-terror repub epis2 if sexgap~=.
*
*  end Table 7


