***********************************************************************************************************************************************

****************************SYNTAX FOR "HAVING THEIR SAY: AUTHORITY, VOICE, AND SATISFACTION WITH DEMOCRACY***************************

************************************ERIC MERKLEY, FRED CUTLER, PAUL J. QUIRK, BENJAMIN NYBLADE**************

********************************************************ENVIRONMENTALIST SAMPLE**********************

set more off

****Drop Manitoba Residents and people who didn't complete survey

drop if mbresid==2
drop if Finished~=1

*****Experimental Condition Variables*****

**Voice Conditions**

destring Condition, replace
rename Condition condition
label variable condition "All Experimental Conditions"
tab condition

gen p3 = 0
replace p3 = 1 if condition == 1 | condition ==2
label variable p3 "3 Party Condition"
tab p3

gen p3A = 0
replace p3A = 1 if condition == 3 | condition ==4
label variable p3A "3 Party with Environmentalists Condition"
tab p3A

gen p4 = 0
replace p4 = 1 if condition == 5 | condition ==6
label variable p4 "4 Party Condition"
tab p4

gen cond = 0
replace cond = 1 if p3A == 1
replace cond = 2 if p4 == 1
label variable cond "Party System Experimental Condition"
tab cond
label def conds 0 "3p" 1 "3pA" 2 "4p"
label val cond conds

gen enviro = 0
replace enviro=1 if p3A==1 | p4==1
label variable enviro "Environment in Campaign Condition"
label def penvlab 0 "3p, no Enviro" 1 "3pA or 4p, Enviro"
label val enviro penvlab
tab enviro

drop p3 p3A p4

**Election Result Conditions**

egen ndp_maj = rownonmiss(A3Presult1 A4Presult1)
label variable ndp_maj "NDP Majority Condition"
tab ndp_maj

egen lib_maj = rownonmiss(A3Presult3 A4Presult3)
label variable lib_maj "Liberal Majority Condition"
tab lib_maj

egen ndp_min = rownonmiss(A3Presult2 A4Presult2)
label variable ndp_min "NDP Minority Condition"
tab ndp_min

egen lib_min = rownonmiss(A3Presult4 A4Presult4)
label variable lib_min "Liberal Minority Condition"
tab lib_min

gen lib_win=lib_maj==1|lib_min==1
gen ndp_win=ndp_maj==1|ndp_min==1

drop A4Presult*
drop A3Presult*

**********************************************************

**Pre-Trestment Efficacy**
recode represent 1=3 2=2 3=1 4=0 5/6=.
label define represent 0 "Strongly Disagree" 1 "Disagree" 2 "Agree" 3 "Strongly Agree"
label values represent represent
label variable represent "Respondent's views are represented"
tab represent

********************************************************

**********Ideology and PID*********

**Ideology Self-Placement Scale**
rename ideol_self_1 ideol
label variable ideol "Ideology Self-placement"

**PID**
gen pid = pid_2
recode pid 5/6=5 7=.
label define pid 1 "Liberal" 2 "Conservative" 3 "N.D.P." 4 "Green" 5 "Other/None" 
label values pid pid
label variable pid "Party Identification"
tab pid

drop pid_2
drop pid_2_TEXT
drop pid_3


****************************************

*****Efficacy Block*****

**Voice**
rename postt1 voice
recode voice 5=.
replace voice = voice-1
label define voice 0 "Strongly agree" 1 "Somewhat agree" 2 "Somewhat disagree" 3 "Strongly disagree"
label value voice voice
label variable voice "People like me don't have any say about what the government does."
tab voice

**Issues Important in Manitoba**
recode import 4=2 5=0 6=1 7=. 
label define import 2 "Yes" 1 "Not sure" 0 "No"
label value import import
tab import

*************************************************************************

*****Post-Election*****

**Vote Intention**
gen vintent = vintent3P
replace vintent = 1 if vintent4P==1
replace vintent = 2 if vintent4P==2
replace vintent = 3 if vintent4P==3
replace vintent = 4 if vintent4P==4
replace vintent = 5 if vintent4P==5
replace vintent = 6 if vintent4P==6
replace vintent = . if vintent==7
label define vintent 1 "NDP" 2 "Liberal" 3 "Conservative" 4 "Green" 5 "Choose not to vote" 6 "Can't decide"
label value vintent vintent
label variable vintent "On Election Day, you would vote for..."
drop vintent3P
drop vintent4P
tab vintent

**Satisfaction with Democracy**
gen satisfied = satisfy_2-1
recode satisfied 4=.
label variable satisfied "Satisfied with Democracy"
drop satisfy_2

gen demsatyes=satisfied==0 | satisfied==1
label variable demsatyes "Satisfied with Democracy - Binary"
drop satisfied

**********************************************************************************

** Winner / Majority **

gen win=0
replace win=1 if (lib_win==1 & vintent~=2)
replace win=1 if (ndp_win==1 & vintent~=1)
replace win=. if vintent==6
replace win=. if vintent==.
recode win 0=1 1=0
label variable win "Election Winner = 1"

gen majority=0
replace majority=1 if lib_maj==1 | ndp_maj==1
label variable majority "Majority Condition = 1"
drop *_maj
drop *_min
drop *_win
drop vintent

drop Finished condition mbresid

****************************************************************

****MAIN ANALYSES****

**Difference in proportions test
prtest demsatyes, by(win) 
prtest demsatyes, by(enviro) 

**Models
logit demsatyes i.enviro i.win
margins, at(enviro=(0 1))
margins, at(win=(0 1))
logit demsatyes i.enviro i.win i.pid ideol represent
margins, at(enviro=(0 1))
margins, at(win=(0 1))
logit demsatyes i.enviro##i.win i.pid ideol represent

**Figure 2 (Right Panel)
logit demsatyes i.enviro##i.win i.pid ideol represent
margins, at(enviro=(0 1) loser3=(0 1))
marginsplot, title("Sierra Club") l(90) aspect(1) xsize(3.5) ylabel(0(0.1)0.5) scheme(s1mono) recast(scatter) 

*****APPENDIX******

**Figure A16, right panel
lgraph demsatyes win, title("Sierra Club") aspect(2) xsize(2.5) ysize(4) scale(1.5) scheme(s1mono) s(mean) error(ci(90)) separate(0.10) lop(recast(rbar)) xlabel(0 1 2) ylabel(0(0.1)0.5) xlabel(0 "Loser" 1 "Winner") xtitle("") ytitle("Democratic Satisfaction")

**Figure A17, right panels
lgraph demsatyes enviro, title("Sierra Club") aspect(2) xsize(2.5) ysize(4) scale(1.5) scheme(s1mono) s(mean) error(ci(90)) separate(0.10) lop(recast(rbar)) xlabel(0 1 2) ylabel(0(0.1)0.5) xlabel(0 "Control" 1 "Environment") xtitle("") ytitle("Democratic Satisfaction")
lgraph demsatyes cond, title("Sierra Club") aspect(2) xsize(2.5) ysize(4) scale(1.5) scheme(s1mono) s(mean) error(ci(90)) separate(0.10) lop(recast(rbar)) xlabel(0 1 2) ylabel(0(0.1)0.5) xlabel(0 "Control" 1 "Environmentalist" 2 "Green Party") xtitle("") ytitle("Democratic Satisfaction")

**Figure A18, right panels
lgraph demsatyes win enviro, title("Sierra Club") aspect(1) xsize(4) ysize(4) scale(1) scheme(s1mono) s(mean) error(ci(90)) separate(0.10) lop(recast(rbar)) xlabel(0 1 2) ylabel(0(0.1)0.5) xlabel(0 "Loser" 1 "Winner") xtitle("") ytitle("Democratic Satisfaction")
lgraph demsatyes win cond, title("Sierra Club") aspect(1) xsize(4) ysize(4) scale(1) scheme(s1mono) s(mean) error(ci(90)) separate(0.10) lop(recast(rbar)) xlabel(0 1 2) ylabel(0(0.1)0.5) xlabel(0 "Loser" 1 "Winner") xtitle("") ytitle("Democratic Satisfaction")

**Table A1, Models 4, 5, and 6
logit demsatyes i.cond i.win
logit demsatyes i.cond i.win i.pid ideol represent
logit demsatyes i.cond##i.win i.pid ideol represent

**Figure A19, right panel
logit demsatyes i.cond##i.win i.pid ideol represent
qui:margins, at(cond=(0 1 2) win=(0 1))
marginsplot, title("Sierra Club") l(90) aspect(1) xsize(3.5) ylabel(0(0.1)0.5) scheme(s1mono) recast(scatter)

**Table A2, Models 3 and 4
logit demsatyes enviro i.win##i.majority i.pid ideol represent 
logit demsatyes i.win##i.majority##i.enviro i.pid ideol represent 

**Figure A21
qui:logit demsatyes i.win##i.majority##i.enviro i.pid ideol represent 
qui:margins, dydx(win) at(enviro=(0 1) majority=(0 1))
marginsplot, by(majority) l(90) aspect(1) xsize(3.5) ylabel(0.5(0.1)1) scheme(s1mono) recast(scatter)

**Table A3, Models 3,4, and 6
ologit voice i.enviro i.win i.pid ideol represent
ologit voice i.enviro##i.win i.pid ideol represent
ologit import i.enviro i.win i.pid ideol represent
