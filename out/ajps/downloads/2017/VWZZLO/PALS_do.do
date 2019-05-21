/*
Citation: Djupe, Paul A., Jacob R. Neiheisel, and Anand E. Sokhey. Forthcoming. “Reconsidering the Role of Politics in Leaving Religion: The Importance of Affiliation.” American Journal of Political Science.
Do: 2006 & 2012 Portrait of American Life Study (PALS).
Bill of Lading: This file builds the data file from the two waves, recodes, labels (select variables), and analyzes the data, and produces select data displays.
It includes code for Figure 3, Table A4, Table A5, Figure A12, and Table A10. (Figures/Tables beginning with "A" are in the SI).	
*/

*Downloading Public Data Files
*Complete the form and download the "merged" data file from here: http://www.thearda.com/pals/download/


*Keeping Relevant Variables 
keep dm_6_w1 dm_7_w1 dm_2_w1 rgender_w2 ne_10_w1 ne_11_w1 ci_0_w1 hr_age_w1 ///
ci_0_w2 hc_0_w2 ci_1_w1 ci_4_w1 ri_5_w1 re_white_w1 po_6_w1 po_7_w1 po_8_w1 ///
po_9_w1 ca_14_w1 ca_37_w1 ca_22_w1 ca_15_w1 ca_16_w1 ca_17_w1 ca_18_w1 ca_19_w1 ///
ca_20_w1 ca_21_w1 po_1_w1 po_10_w1 rc_3_w1 ci_1_w1 ca_3z6_w2 ci_1_w2 ci_0z7_w2 loweight_w2rake ///
se_1_w1 se_2_w1 se_3_w1


/*INDEPENDENT VARIABLES*/

*Wave 1 Total Family Income
gen Income=1 if dm_6_w1==1
replace Income=2 if dm_6_w1==2
replace Income=3 if dm_6_w1==3
replace Income=4 if dm_6_w1==4
replace Income=5 if dm_6_w1==5
replace Income=6 if dm_6_w1==6
replace Income=7 if dm_6_w1==7
replace Income=8 if dm_6_w1==8
replace Income=9 if dm_7_w1==1
replace Income=10 if dm_7_w1==2
replace Income=11 if dm_7_w1==3
replace Income=12 if dm_7_w1==4
replace Income=13 if dm_7_w1==5
replace Income=14 if dm_7_w1==6
replace Income=15 if dm_7_w1==7
replace Income=16 if dm_7_w1==8
replace Income=17 if dm_7_w1==9
replace Income=18 if dm_7_w1==10
replace Income=19 if dm_7_w1==11

*Education
gen Education=dm_2_w1 if dm_2_w1>0
recode Education (1=0)(2 3=1)(4 5 6=2)(7=3)(8 9 10 11=4)(12=.a), gen(ed5)

*Gender
gen Female=1 if rgender_w2==0
replace Female=0 if rgender_w2==1

*Wave 1 Attend
gen AttendW1=ci_0_w1 if ci_0_w1>0

*Wave 2 Attend 
gen AttendW2=ci_0_w2 if ci_0_w2>0

*Moved
gen moved=1 if hc_0_w2==2
replace moved=0 if hc_0_w2==1

*RelTrad Variables
gen Catholic=1 if ci_1_w1==4|ci_4_w1==1
replace Catholic=0 if Catholic==. 

gen Protestant=1 if Catholic==0 & ci_1_w1==1
replace Protestant=0 if Protestant==.

gen OtherFaith=1 if ci_1_w1==2|ci_1_w1==3|ci_1_w1==5|ci_1_w1==6|ci_1_w1==7
replace OtherFaith=0 if OtherFaith==.

gen main=0
replace main=1 if Protestant==1 & ri_5_w1==2

gen evan=0 
replace evan=1 if Protestant==1 & ri_5_w1==1 & re_white_w1==1

gen rt=.
replace rt=1 if main==1
replace rt=2 if evan==1
replace rt=3 if Catholic==1
replace rt=4 if OtherFaith==1
la def rt 1"Mainline" 2"Evangelical" 3"Catholic" 4"Other"
la val rt rt 

*Partisanship -- higher is Republican
gen pid7=7 if po_6_w1==2 & po_8_w1==1
replace pid7=6 if po_6_w1==2 & po_8_w1==2
replace pid7=5 if po_6_w1==3 & po_9_w1==2
replace pid7=5 if po_6_w1==4 & po_9_w1==2
replace pid7=5 if po_6_w1==2 & po_8_w1<1
replace pid7=4 if po_6_w1==3 & po_9_w1==3 | po_9_w1<1
replace pid7=3 if po_6_w1==1 & po_7_w1<1
replace pid7=3 if po_6_w1==4 & po_9_w1==1
replace pid7=3 if po_6_w1==3 & po_9_w1==1
replace pid7=2 if po_6_w1==1 & po_7_w1==2
replace pid7=1 if po_6_w1==1 & po_7_w1==1

la def pid7sm 1"SD" 2"D" 3"Lean D" 4"Ind" 5"Lean R" 6"R" 7"SR"
la val pid7 pid7sm


*Ideology -- higher is more conservative
gen Ideology=po_1_w1
recode Ideology (-7 -4=.a)(6=.b)

*Feels Like an Outsider
gen Outsider=1 if ca_14_w1==5
replace Outsider=2 if ca_14_w1==4
replace Outsider=3 if ca_14_w1==3
replace Outsider=4 if ca_14_w1==2
replace Outsider=5 if ca_14_w1==1

*Arguments over Traditional vs Contemporary Services
gen TradArg=1 if ca_37_w1==1
replace TradArg=0 if TradArg==.

*Overall Satisfaction with the Church
gen SatPreach=1 if ca_15_w1==5
replace SatPreach=2 if ca_15_w1==4
replace SatPreach=3 if ca_15_w1==3
replace SatPreach=3 if ca_15_w1==6
replace SatPreach=4 if ca_15_w1==2
replace SatPreach=5 if ca_15_w1==1

gen SatMusic=1 if ca_16_w1==5
replace SatMusic=2 if ca_16_w1==4
replace SatMusic=3 if ca_16_w1==3
replace SatMusic=3 if ca_16_w1==6
replace SatMusic=4 if ca_16_w1==2
replace SatMusic=5 if ca_16_w1==1

gen SatComm=1 if ca_17_w1==5
replace SatComm=2 if ca_17_w1==4
replace SatComm=3 if ca_17_w1==3
replace SatComm=3 if ca_17_w1==6
replace SatComm=4 if ca_17_w1==2
replace SatComm=5 if ca_17_w1==1

gen SatEduc=1 if ca_18_w1==5
replace SatEduc=2 if ca_18_w1==4
replace SatEduc=3 if ca_18_w1==3
replace SatEduc=3 if ca_18_w1==6
replace SatEduc=4 if ca_18_w1==2
replace SatEduc=5 if ca_18_w1==1

gen SatYouth=1 if ca_19_w1==5
replace SatYouth=2 if ca_19_w1==4
replace SatYouth=3 if ca_19_w1==3
replace SatYouth=3 if ca_19_w1==6
replace SatYouth=4 if ca_19_w1==2
replace SatYouth=5 if ca_19_w1==1

gen SatMoney=1 if ca_20_w1==5
replace SatMoney=2 if ca_20_w1==4
replace SatMoney=3 if ca_20_w1==3
replace SatMoney=3 if ca_20_w1==6
replace SatMoney=4 if ca_20_w1==2
replace SatMoney=5 if ca_20_w1==1

gen SatDecide=1 if ca_21_w1==5
replace SatDecide=2 if ca_21_w1==4
replace SatDecide=3 if ca_21_w1==3
replace SatDecide=3 if ca_21_w1==6
replace SatDecide=4 if ca_21_w1==2
replace SatDecide=5 if ca_21_w1==1

gen SatDenom=1 if SatPreach~=.
replace SatDenom=SatDenom+1 if SatMusic~=.
replace SatDenom=SatDenom+1 if SatComm~=.
replace SatDenom=SatDenom+1 if SatEduc~=.
replace SatDenom=SatDenom+1 if SatYouth~=.
replace SatDenom=SatDenom+1 if SatMoney~=.
replace SatDenom=SatDenom+1 if SatDecide~=.

egen SatNum = rowtotal(SatPreach SatMusic SatComm SatEduc SatYouth SatMoney SatDecide)
gen OverallChurchSatisfaction=SatNum/SatDenom
rename OverallChurchSatisfaction ocs

*Oppose CR Groups in Politics (high is oppose)
gen CRpoliticW1=1 if po_10_w1==5
replace CRpoliticW1=2 if po_10_w1==4
replace CRpoliticW1=3 if po_10_w1==3
replace CRpoliticW1=4 if po_10_w1==2
replace CRpoliticW1=5 if po_10_w1==1

gen CRpoliticW1c=(CRpoliticW1-1)/4 // on a 0-1 scale

*Thinking about dropping out
recode rc_3_w1 (2=0)(-7 -4=.a), gen(thinkdrop)

*Risk Aversion
alpha se_1_w1 se_2_w1 se_3_w1, gen(risk)

/*DEPENDENT VARIABLES*/ 

*Switched Congregation
gen switched2=0 if ci_1_w1<8
replace switched2=1 if ca_3z6_w2==2

*Leaving religion
recode  ci_1_w1  ci_1_w2 (-4=.a)
gen leftrel=0 if  ci_1_w1<8 
replace leftrel=1 if ci_1_w1<8 &  ci_1_w2>7 &  ci_1_w2<.

recode ci_0z7_w2 (2=1)(3=.)(1=0), gen(left)

/*MODELS AND DATA DISPLAYS*/

*Table A4- "Table A4 – Predicting Leaving a Congregation between 2006 and 2012 (PALS data, logit model)
logit switched2 c.CRpoliticW1c##i.evan##c.pid7 hr_age_w1 ocs TradArg Income ed5 Female AttendW1 Outsider Catholic OtherFaith moved risk left [pweight=loweight_w2rake], vsquish

*Figure 3 - The Interactive Effect of Partisanship, Evangelical Tradition, and Opposition to Conservative Christians Active in Politics on Leaving 2006 Church by 2012 (2012 PALS; Estimates from Table A4— CIs for a 90% Test Presented)
margins, at(pid7=(1(1)7) CRpoliticW1c=(0 1) evan=(0)) l(76)
marginsplot, graphregion(color(white)) xtitle("") ytitle("Rate of Disaffiliation") title("") ciopt(recast(rspike) lc(gs10)) title("Non-Evangelical") name(non, replace) ///
		legend(region(color(white)) order(3 "CR Supporter" 4 "CR Opponent")) xlabel(,val) plot1op(ms(O) mc(black) lc(black)) plot2op(ms(Sh) mc(black) lc(black))

margins, at(pid7=(1(1)7) CRpoliticW1c=(0 1) evan=(1)) l(76)
marginsplot, graphregion(color(white)) xtitle("") ytitle("Rate of Disaffiliation") title("") ciopt(recast(rspike) lc(gs10)) title("Evangelical") name(evan, replace) ///
		legend(region(color(white)) order(3 "CR Supporter" 4 "CR Opponent")) xlabel(,val) plot1op(ms(O) mc(black) lc(black)) plot2op(ms(Sh) mc(black) lc(black))
graph combine non evan, graphregion(color(white)) 


*Table A5 - "Predicting Worship Attendance in Wave 2 Among Those who Retained Membership in the Same House of Worship (ologit)"
ologit AttendW2 CRpoliticW1c pid7 ocs TradArg Income Education Female AttendW1 Outsider main Catholic OtherFaith Ideology risk hr_age_w1 if switched2==0 [pweight= loweight_w2rake], vsquish
ologit AttendW2 c.CRpoliticW1c##c.pid7 ocs TradArg Income Education Female AttendW1 Outsider main Catholic OtherFaith Ideology risk hr_age_w1 if switched2==0 [pweight= loweight_w2rake], vsquish

*Table A10 – Predicting De-Identifying with a Religious Tradition between 2006 and 2012 (PALS data, logit model)
logit leftrel CRpoliticW1c pid7 hr_age_w1 ocs TradArg AttendW1 Outsider thinkdrop Catholic re_white_w1 Income Education Female Ideology moved risk [pweight= loweight_w2rake], vsquish
logit leftrel c.CRpoliticW1c##c.pid7 hr_age_w1 ocs TradArg AttendW1 Outsider thinkdrop Catholic re_white_w1 Income Education Female Ideology moved risk [pweight= loweight_w2rake], vsquish

*Figure A12 – De-Identification from Religion as a Function of Partisanship and Opposition to the Christian Right
margins, at(pid7=(1(1)7) CRpoliticW1c=(0 1)) l(76)
marginsplot, graphregion(color(white)) xtitle("Partisanship") ytitle("Predicted Level of De-Identification") title("") ciopt(lc(gs10)) recastci(rspike) title("") name(evan, replace) ///
		legend(region(color(white)) order(3 "Christian Right Support" 4 "Christian Right Opposition")) xlabel(,val) plot1op(ms(O) mc(black) lc(black)) plot2op(ms(Sh) mc(black) lc(black))
 