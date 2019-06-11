use "mode matters replication", clear
set more off

***I. Create Indicators of Survey Response Patterns***************
******I.A. Item Non-Response********************************************
*********I.A.1 Calculate # of Missing Responses for Each Item********************************************

foreach x of varlist Q1_Days - q16 Q16a q17_2-q17_5 q18_2 - q18_5 q19-q20   q21 q22  q23  q24 q25 q26 q27 q29_a- q29_d q30- q36 q37- q42 q43- q48 q50 q52 q56- q65  q67-q69 q72 q75 q76  q77 q78 Q78b_1-Q78b_10 Q78c q79-q83 q85 q87 q88 q89 q90 q91 q92 q93 q94 q95 q96 q97 q100 q102 q103 q104 q105 q106 q107 q108 q109 q110 q111 q112 q113  q114 {
gen missing_`x' = 1 if `x'==.a
replace missing_`x' = 1 if `x'==.
replace missing_`x' = 0 if missing_`x'==.
}
*********Note:Q70 asked of all respondents but missing values indicated by a separate variable, Q70_Refused***
gen missing_q70 = Q70_Refused

*********I.A.2 Calculate Summaries of Missing Responses for All Items********************************************
egen itemcount = anycount(missing_*), value (0 1)
label variable itemcount "Number of items counted for missing values"
egen missingtotal = rowtotal(missing_*)
label variable missingtotal "# of missing responses"
gen prmissing = missingtotal/itemcount
label variable prmissing "Proportion item non-response"

*********I.A.3 Generate item non-response variables for pulldown items*******
egen matrixitemcount = anycount(missing_q6-missing_q16 missing_q17_2-missing_q18_5 missing_Q78b*), value (0 1)
label variable matrixitemcount "Number of items counted for missing values, matrix items"
egen matrixmissing = rowtotal(missing_q6-missing_q16 missing_q17_2-missing_q18_5 missing_Q78b*)
label variable matrixmissing "# of missing responses, matrix items"
gen prmatrixmissing = matrixmissing/matrixitemcount
label variable prmatrixmissing "Proportion item non-response, matrix items"

*********I.A.4 Generate item non-response variables for pulldown items*******
egen pulldownitemcount = anycount(missing_Q1_Days - missing_Q4_Own missing_q56-missing_q65), value (0 1)
label variable pulldownitemcount "Number of items counted for missing values, pulldown items"
egen pulldownmissing = rowtotal(missing_Q1_Days-missing_Q4_Own missing_q56-missing_q65)
label variable pulldownmissing "# of missing responses, pulldown items"
gen prpulldownmissing = pulldownmissing/pulldownitemcount
label variable prpulldownmissing "Proportion item non-response, pulldown items"

*********I.A.5 Generate item non-response variables for yes/no items*******
egen yesnoitemcount = anycount(missing_q30 - missing_q48 missing_q67-missing_q69), value (0 1)
label variable yesnoitemcount "Number of items counted for missing values, yesno items"
egen yesnomissing = rowtotal(missing_q30 - missing_q48 missing_q67-missing_q69)
label variable yesnomissing "# of missing responses, yesno items"
gen pryesnomissing = yesnomissing/yesnoitemcount
label variable pryesnomissing "Proportion item non-response, yesno items"

*********I.A.6 Generate item non-response variables for feeling thermometers*******
egen ftitemcount = anycount(missing_q29*), value (0 1)
label variable ftitemcount "Number of items counted for missing values, feeling thermometers"
egen ftmissing = rowtotal(missing_q29*)
label variable ftmissing "# of missing responses, feeling thermometers"
gen prftmissing = ftmissing/ftitemcount
label variable prftmissing "Proportion item non-response, feeling thermometers"

****** I.B. No Opinion / Don't Know Responses*****************************************
*********I.B.1 Create Don't Know Dummies****
gen dk85 = q85==3 if q85~=.
gen dk92 = q92==7 if q92~=.
gen dk100 = q100==3 if q100~=.
gen dk109 = q109==4 if q109~=.
gen dk110 = q110==4 if q110~=.
gen dk111 = q111==4 if q111~=.
gen dk112 = q112==4 if q112~=.
gen dk113 = q113==4 if q113~=.
gen dk26 = q26==4 if q26~=.
gen dk27 = q27==4 if q27~=.
*********I.B.2 Create Summaries of DKs****
egen dks = rowtotal(dk85 - dk27)
label variable dks "Sum of Don't Knows"
gen prdks = dks/10
label variable prdks "Proportion of DK's"

****** I.C. Differentiation Index****************************************
*********I.C.1 Create dummies for all response choices in batteries******
foreach var of varlist  Q1_Days-Q4_Own q6-q16 q17_2-q17_5 q18_2-q18_5 q30-q48 q56-q65 q67-q69 q88 q89 q90 q91 q104-q106 Q78b_1-Q78b_10 {
 tab `var', generate(ac`var')
}
foreach num of numlist 0/100 {
	gen acq29_a`num' = q29_a==`num'
	gen acq29_b`num' = q29_b==`num'
	gen acq29_c`num' = q29_c==`num'
	gen acq29_d`num' = q29_d==`num'
}

foreach num of numlist 1/8 {
	egen bat1ac`num' = rowtotal(acQ1_Days`num' acQ2_Days`num' acQ3_Days`num' acQ4_Days`num')
}
foreach num of numlist 1/2 {
	egen bat2ac`num' = rowtotal(acQ1_Own`num' acQ2_Own`num' acQ3_Own`num' acQ4_Own`num')
}
foreach num of numlist 1/5 {
	egen bat3ac`num' = rowtotal(acq6`num' acq7`num' acq8`num' acq9`num' acq10`num' acq11`num' acq12`num' acq13`num' acq14`num' acq15`num' acq16`num')
}
foreach num of numlist 1/3 {
  egen bat4ac`num' = rowtotal(acq17_2`num' acq17_3`num' acq17_4`num' acq17_5`num' acq18_2`num' acq18_3`num' acq18_4`num' acq18_5`num')
} 
foreach num of numlist 0/100 {
	egen bat5ac`num' = rowtotal(acq29_a`num' acq29_b`num' acq29_c`num' acq29_d`num')
}
foreach num of numlist 1/2 {
	egen bat6ac`num' = rowtotal(acq30`num' acq31`num' acq32`num' acq33`num' acq34`num' acq35`num' acq36`num' acq37`num' acq38`num' acq39`num' acq40`num' acq41`num' acq42`num' acq43`num' acq44`num' acq45`num' acq46`num' acq47`num' acq48`num' )
}
foreach num of numlist 1/8 {
	egen bat7ac`num' = rowtotal(acq56`num' acq57`num' acq58`num' acq59`num' acq60`num' acq61`num' acq62`num' acq63`num' acq65`num' acq65`num') 
}
foreach num of numlist 1/2 {
	egen bat8ac`num' = rowtotal(acq67`num' acq68`num' acq69`num')
}
foreach num of numlist 1/6 {
	egen bat9ac`num' = rowtotal(acq88`num' acq89`num' acq90`num' acq91`num')
}
foreach num of numlist 1/2 {
	egen bat10ac`num' = rowtotal(acq104`num' acq105`num' acq106`num')
}
foreach num of numlist 1/7 {
	egen bat11ac`num' = rowtotal(acQ78b_1`num' acQ78b_2`num' acQ78b_3`num' acQ78b_4`num' acQ78b_5`num' acQ78b_6`num' acQ78b_7`num' acQ78b_8`num' acQ78b_9`num' acQ78b_10`num')
}
*********I.C.2 Sum non-missing observations****
egen bat1nm = rownonmiss(Q1_Days Q2_Days Q3_Days Q4_Days)
egen bat2nm = rownonmiss(Q1_Own- Q4_Own)
egen bat3nm = rownonmiss(q6-q16)
egen bat4nm = rownonmiss(q17_2 - q17_5 q18_2 - q18_5)
egen bat5nm = rownonmiss(q29_a- q29_d)
egen bat6nm = rownonmiss(q30 - q48)
egen bat7nm = rownonmiss(q56 - q65)
egen bat8nm = rownonmiss(q67 - q69)
egen bat9nm = rownonmiss(q88 q89 q90 q91)
egen bat10nm = rownonmiss(q104 - q106)
egen bat11nm = rownonmiss(Q78b_1 - Q78b_10)

*********I.C.3 find most used answer choice, calculate proportion choosing same answer***

egen bat1max = rowmax(bat1ac*)
egen bat2max = rowmax(bat2ac*)
egen bat3max = rowmax(bat3ac*)
egen bat4max = rowmax(bat4ac*)
egen bat5max = rowmax(bat5ac*)
egen bat6max = rowmax(bat6ac*)
egen bat7max = rowmax(bat7ac*)
egen bat8max = rowmax(bat8ac*)
egen bat9max = rowmax(bat9ac*)
egen bat10max = rowmax(bat10ac*)
egen bat11max = rowmax(bat11ac*)
gen bat1prop = (bat1max-1)/3 if bat1nm==4
gen bat2prop = (bat2max-1)/3 if bat2nm==4
gen bat3prop = (bat3max-1)/10 if bat3nm==11
gen bat4prop = (bat4max-1)/(bat4nm-1) if bat4nm==8
gen bat5prop = (bat5max-1)/3 if bat5nm==4
gen bat6prop = (bat6max-1)/18 if bat6nm==19
gen bat7prop = (bat7max-1)/9 if bat7nm==10
gen bat8prop = (bat8max-1)/2 if bat8nm==3
gen bat9prop = (bat9max-1)/3 if bat9nm==4
gen bat10prop = (bat10max-1)/2 if bat10nm==3
gen bat11prop = (bat11max-1)/9 if bat11nm==10

*********I.C.3 Calculate differentiation index (rho)****
foreach var of varlist bat1ac* {
	gen prop2`var' = (`var'/4)^2 if bat1nm==4
}
foreach var of varlist bat2ac* {
	gen prop2`var' = (`var'/4)^2 if bat2nm==4
}
foreach var of varlist bat3ac* {
	gen prop2`var' = (`var'/11)^2 if bat3nm==11
}
foreach var of varlist bat4ac* {
	gen prop2`var' = (`var'/8)^2 if bat4nm==8 
}
foreach var of varlist bat5ac* {
	gen prop2`var' = (`var'/4)^2  if bat5nm==4
}
foreach var of varlist bat6ac* {
	gen prop2`var' = (`var'/19)^2  if bat6nm==19
}
foreach var of varlist bat7ac* {
	gen prop2`var' = (`var'/10)^2  if bat7nm==10
}
foreach var of varlist bat8ac* {
	gen prop2`var' = (`var'/3)^2  if bat8nm==3
}
foreach var of varlist bat9ac* {
	gen prop2`var' = (`var'/4)^2  if bat9nm==4
}
foreach var of varlist bat10ac* {
	gen prop2`var' = (`var'/3)^2  if bat10nm==3
}
foreach var of varlist bat11ac* {
	gen prop2`var' = (`var'/10)^2  if bat11nm==10
}
foreach num of numlist 1/11 {
	egen bat`num'sigma =  rowtotal(prop2bat`num'ac*) if prop2bat`num'ac1~=.
    gen bat`num'rho = 1 - bat`num'sigma
}
egen rhomean = rowmean(bat*rho)
egen matrixrhomean = rowmean(bat3rho bat4rho bat11rho)
egen yesnorhomean = rowmean(bat6rho bat8rho )
egen pulldownrhomean = rowmean(bat1rho bat2rho bat7rho)
gen ftrhomean = bat5rho


***II. Analyses Reported in Tables***
******Table 2 - Summary Indicators of Survey Response Patterns by Survey Mode****
ttest prmissing, by(source)
ttest prdks, by(source)
ttest rhomean, by(source)

******Table 3 - Differences in Mode Effects by Question Type****
ttest prmatrixmissing, by(source)
ttest matrixrhomean, by(source)
ttest pryesnomissing, by(source)
ttest yesnorhomean, by(source)
ttest prpulldownmissing, by(source)
ttest pulldownrhomean, by(source)
ttest prftmissing, by(source)
ttest ftrhomean, by(source)

******Table 4: OLS Regression Models of Response Patterns by Survey Mode and Sample Source****
reg missingtotal i.mode2##i.sample3 i.raceage i.xSpanish
est store miss1
reg prdks i.mode2##i.sample3 i.raceage i.xSpanish
est store dks1
reg rhomean i.mode2##i.sample3 i.raceage i.xSpanish
est store rho1
est table miss1 dks1 rho1, b(%3.2f)se stats(N r2) keep(i.mode2##i.sample3 _cons)

******NOTE: see "Replication of Social Desirability and Survey Mode Analyses.do" for Replication of Table 5: Social Desirability and Survey Mode******

*********Note: see separate .do file for simulation of imputed knowledge*****

***V. Analyses Reported in Supplementary Appendix***
******Table S-1: Sample Characteristics******
tab xMills source
bysort xppracem: tab sample3 source

******Table S-2 - Item Non-Response by Question (note: Q70 appears at end of list)****
foreach var of varlist missing_* {
	desc `var'
	ttest `var', by(source)
}

******Table S-3: ÒDonÕt KnowÓ or ÒNot SureÓ Responses as a Proportion of Valid Responses by Survey Mode******
foreach var of varlist dk26 dk27 dk85-dk113 {
	sum `var'
	ttest `var', by(source)
}

******Table S-4: Scale Differentiation by Survey Mode******
foreach num of numlist 1/11 {
	    ttest bat`num'rho, by(source)
}

******Table S-5: Differences in Computer Use and Demographic Variables across Survey Modes by Sample Source, Race and Age******
gen net = 2 - q5
foreach var of varlist Q1_Days net {
	ttest `var' if group4 & sample3 , by(source)
	ttest `var' if group5 & sample3 , by(source)
	ttest `var' if group6 & sample3 , by(source)
	ttest `var' if group10 & sample3 , by(source)
	ttest `var' if group11 & sample3 , by(source)
	ttest `var' if group12 & sample3 , by(source)
	ttest `var' if xppracem==1 & sample1 & ppage>=20, by(source)
}

******Table S-6: Complete OLS Regression Models of Response Patterns by Survey Mode and Sample Source******
est table miss1 dks1 rho1, b(%3.2f)se stats(N r2)

******NOTE: see "Replication of Social Desirability and Survey Mode Analyses.do" for Replication of Table S-7 and Table S-8******
******NOTE: see "Replication of Political Knowledge Analyses.do" for Replication of Table S-9******


***IV. Other Analyses Reported in Text***
****** Mean number of missing responses by mode****
ttest missingtotal, by(source)
******Calculate percent using midpoint for all 10 items in "Big 5" battery*****
foreach num of numlist 1(1)10 {
 gen mpQ78b_`num' = (Q78b_`num'==4)
}
egen nummpbig5 = rsum(mpQ78b_*)
gen mp10big= (nummpbig5==10)
ttest mp10big, by(source)
*******Number of missing responses for pulldown items by mode***
tab pulldownmissing source, col 

***Replication of Analyses with Survey Weights Applied***
******NOTE: run "mode matters replication.do" BEFORE running these commands****

******Apply weights for overall population********
svyset _n [pweight=weight1_NEW], strata(raceage) vce(linearized) singleunit(missing)
******Weighted Summary Indicators of Survey Response Patterns by Survey Mode****
svy: mean prmissing, over(source)
test [prmissing]Online=[prmissing]Telephone
svy: mean prdks, over(source)
test [prdks]Online=[prdks]Telephone
svy: mean rhomean, over(source)
test [rhomean]Online= [rhomean]Telephone

******Weighted Differences in Mode Effects by Question Type****
svy: mean prmatrixmissing, over(source)
test [prmatrixmissing]Online=[prmatrixmissing]Telephone
svy: mean pryesnomissing, over(source)
test [pryesnomissing]Online=[pryesnomissing]Telephone
svy: mean prpulldownmissing, over(source)
test [prpulldownmissing]Online=[prpulldownmissing]Telephone
svy: mean prftmissing, over(source)
test [prftmissing]Online=[prftmissing]Telephone
svy: mean matrixrhomean, over(source)
test [matrixrhomean]Online= [matrixrhomean]Telephone
svy: mean yesnorhomean, over(source)
test [yesnorhomean]Online= [yesnorhomean]Telephone
svy: mean pulldownrhomean, over(source)
test [pulldownrhomean]Online= [pulldownrhomean]Telephone
svy: mean ftrhomean, over(source)
test [ftrhomean]Online= [ftrhomean]Telephone

******Weighted Regression Models of Response Patterns by Survey Mode and Sample Source****
svy: reg prdks i.mode2##i.sample3 i.raceage i.xSpanish
est store dks2
svy: reg missingtotal i.mode2##i.sample3 i.raceage i.xSpanish
est store miss2
svy: reg rhomean i.mode2##i.sample3 i.raceage i.xSpanish
est store rho2
est table miss2 dks2 rho2, b(%3.2f)se stats(N r2) keep(i.mode2##i.sample3 _cons)


******Weighted Item Non-Response by Question (note: Q70 appears at end of list)****
foreach var of varlist missing_* {
	svy: mean `var', over(source)
	test [`var']Online= [`var']Telephone
}

******Weighted "Don't Know" or "Not Sure" Responses as a Proportion of Valid Responses by Survey Mode******
foreach var of varlist dk26 dk27 dk85-dk113 {
	svy: mean `var', over(source)
	test [`var']Online= [`var']Telephone
}

******Weighted Scale Differentiation by Survey Mode******
foreach num of numlist 1/11 {
		svy: mean bat`num'rho, over(source)
	test [bat`num'rho]Online= [bat`num'rho]Telephone

}

******Apply weights for within racial group analyses********
svyset _n [pweight=weight2_NEW], strata(raceage) vce(linearized) singleunit(missing)
******Weighted Differences in Computer Use and Demographic Variables across Survey Modes by Sample Source, Race and Age******
foreach var of varlist Q1_Days net {
	svy, subpop(group4): mean `var', over(source)
	test [`var']Online= [`var']Telephone
	svy, subpop(group5): mean `var', over(source)
	test [`var']Online= [`var']Telephone
	svy, subpop(group6): mean `var', over(source)
	test [`var']Online= [`var']Telephone
	svy, subpop(group10): mean `var', over(source)
	test [`var']Online= [`var']Telephone
	svy, subpop(group11): mean `var', over(source)
	test [`var']Online= [`var']Telephone
	svy, subpop(group12): mean `var', over(source)
	test [`var']Online= [`var']Telephone
	svy, subpop(race1): mean `var' if sample1 & ppage>=20, over(source)
	test [`var']Online= [`var']Telephone
}
