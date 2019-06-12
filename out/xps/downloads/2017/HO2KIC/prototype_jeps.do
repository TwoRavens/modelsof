***********************************************************************
***********************************************************************
***********************************************************************
***********************************************************************
**Party Affiliation and The Evaluation of Non-Prototypical Candidates**
******************Severson JEPS Submission .do File********************
*******************Last edited: 11-28-2017***************************** 
***********************************************************************
***********************************************************************
***********************************************************************
***********************************************************************





*************************************************************
*************************************************************
*************SECTION 1: DEFINE WORKSPACE********************
*************************************************************
*************************************************************

clear
cd "C:\Users\awseverson\Desktop"
log using session, replace
use "C:\Users\awseverson\Desktop\CCES14_FSU_OUTPUT.dta"

*Define Data As Survey Data (Adjust For Sampling Weights)

svyset [pw=weight]





*************************************************************
*************************************************************
*************SECTION 2: VARIABLE CLEANING********************
*************************************************************
*************************************************************

*Rename Condition Variable

*Condition 1 = Prototypical Republican
*Condition 2 = Nonprototypical Republican
*Condition 3= Prototypical Democrat
*Condition 4 = Nonprototypical Democrat

rename FSU381_treat condition
tab condition

*Rename Primary Dependent Variables (Prototype Perceptions; Vote Propensity; Feeling Thermometer Score)

	*Prototype Perception

rename FSU384 partysimilar
sum partysimilar

	*Vote Propensity

rename FSU381 vote
sum vote

	*Feeling Thermometer

rename FSU382 therm
sum therm

*Rename and Recode Interactive Terms (Political Knowledge; Party Identification)

	*Rename Political Knowledge Variables

rename FSU375 know1
rename FSU376 know2
rename FSU377 know3
rename FSU378 know4

	*Code Correct Answers to Political Knowledge Questions

gen know1right=0
replace know1right=1 if know1==1
gen know2right=0
replace know2right=1 if know2==3
gen know3right=0
replace know3right=1 if know3==1
gen know4right=0
replace know4right=1 if know4==4

	*Generate Political Knowledge Index

gen know_index=know1right+know2right+know3right+know4right
sum know_index

	*Generate Manual Interactions (Condition * Political Knowledge) To Help Construct ATE Plot 

gen cknowrep = condition*know_index if condition<=2
label var cknowrep "Republican Candidate"

gen cknowdem = condition*know_index if condition>=3
label var cknowdem "Democrat Candidate"

	*Rename Party Identification Variables

rename pid7 pid
sum pid
drop if pid >=8
hist pid

gen republican=0
replace republican=1 if pid>=5
sum republican

gen democrat=0
replace democrat=1 if pid<=3
sum democrat

	*Generate Manual Interaction Variable (Party ID * Condition) - Aids Creation of ATE Plots Later

gen rvotei = condition*republican
label var rvotei "Republican Identifier"

gen dvotei = condition*democrat
label var dvotei "Democratic Identifier"

	*Generate Dummy Variables for Each Level of Party Identification
	
gen sd = 0
replace sd=1 if pid==1
gen wd=0
replace wd=1 if pid==2
gen ld=0
replace ld=1 if pid==3
gen ind=0
replace ind=1 if pid==4
gen lr = 0
replace lr=1 if pid==5
gen wr=0
replace wr=1 if pid==6
gen sr=0
replace sr=1 if pid==7

gen sdv = condition*sd
label var sdv "Strong Dem"

gen wdv = condition*wd
label var wdv "Weak Dem"

gen ldv = condition*ld
label var ldv "Leaning Dem"

gen indv = condition*ind
label var indv "Independent"

gen srv = condition*sr
label var srv "Strong Rep"

gen wrv = condition*wr
label var wrv "Weak Rep"

gen lrv = condition*lr
label var lrv "Leaning Rep"

	*Rename Other Relevant Variables & Recode Covariates

rename FSU383 selfsimilar
sum selfsimilar

rename religpew relig
tab relig
gen protestant =0
replace protestant = 1 if relig == 1

rename CC334A ideo
tab ideo
drop if ideo>=8

rename FSU374 interest
sum interest

tab race
gen white=0
replace white=1 if race==1

gen female=0
replace female=1 if gender==2



*Order Variables

order condition, after (weight)
order interest, after(condition)
order know1, after(interest)
order know2, after(know1)
order know3, after (know2)
order know4, after (know3)
order know_index, after (know4)
order pid, after(know_index)
order vote, after(pid)
order therm, after(vote)
order selfsimilar, after (therm)
order partysimilar, after (selfsimilar)
order relig, after (selfsimilar)
order protestant, after(relig)
order ideo, after (protestant)
order educ, after(ideo)
order race, after(educ)
order white, after(race)
order gender, after(white)
order female, after (gender)

*Descriptive Summary of Variables

tabstat condition partysimilar vote therm know_index pid ideo interest educ female white protestant, stat(mean sd min max)    
sutex condition partysimilar vote therm know_index pid ideo interest educ female white protestant, minmax

*************************************************************
*************************************************************
*************SECTION 2: COVARIATE BALANCE********************
*************************************************************
*************************************************************




*Assess Covariate Balance (Condition 2 Used as Base) (Appendix E Results)

qui mlogit condition know_index pid ideo interest educ female white protestant 
outtex 

*************************************************************
*************************************************************
********SECTION 3: PREDICTING PROTOTYPE PERCEPTIONS**********
*************************************************************
*************************************************************





*Predicting Prototype Perceptions by Condition*Party ID Interaction


**Figure axis labels & colors are cleaned up using "The Economist" graph theme and the Graph Editor.


*Generates Paper Figure 1

qui svy: reg partysimilar pid##condition  if condition<=2
estimates store s1, title(Republican Prototype)
margins , dydx(condition) over(pid)
marginsplot , ytitle(ATE of PID) ylab(1(1)-3) yline(0)

qui svy: reg partysimilar pid##condition educ  if condition<=2
estimates store s1, title(Republican Prototype)
margins , dydx(condition) over(pid)
marginsplot , ytitle(ATE of PID) ylab(1(1)-3) yline(0)

*Generates Paper Figure 2

qui svy: reg partysimilar pid##condition  if condition>=3
estimates store s2, title(Democrat Prototype)
margins , dydx(condition) over(pid)
marginsplot , ytitle(ATE of PID) ylab(1(1)-3) yline(0)

qui svy: reg partysimilar pid##condition educ  if condition>=3
estimates store s2, title(Democrat Prototype)
margins , dydx(condition) over(pid)
marginsplot , ytitle(ATE of PID) ylab(1(1)-3) yline(0)


*Predicting Prototype Perceptions by Condition*Political Knowledge Interaction

*Generates Paper Figure 3

qui svy: reg partysimilar know_index##condition  if condition<=2
estimates store s1, title(Republican Prototype)
margins , dydx(condition) over(know_index)
marginsplot , ytitle(ATE of Political Knowledge) ylab(2(1)-3) yline(0)

qui svy: reg partysimilar know_index##condition educ  if condition<=2
estimates store s1, title(Republican Prototype)
margins , dydx(condition) over(know_index)
marginsplot , ytitle(ATE of Political Knowledge) ylab(2(1)-3) yline(0)

*Generates Paper Figure 4 

qui svy: reg partysimilar know_index##condition  if condition>=3
estimates store s2, title(Democrat Prototype)
margins , dydx(condition) over(know_index)
marginsplot , ytitle(ATE of Political Knowledge) ylab(2(1)-3) yline(0)

qui svy: reg partysimilar know_index##condition educ  if condition>=3
estimates store s2, title(Democrat Prototype)
margins , dydx(condition) over(know_index)
marginsplot , ytitle(ATE of Political Knowledge) ylab(2(1)-3) yline(0)

*Prototype Perceptions by Party ID with Independents as Baseline (Appendix C)

qui svy: mean partysimilar, subpop (if condition ==1) over(pid)
test[partysimilar]Independent  = [partysimilar]_subpop_1
test[partysimilar]Independent  = [partysimilar]_subpop_2
test[partysimilar]Independent  = [partysimilar]_subpop_3
test[partysimilar]Independent  = [partysimilar]_subpop_5
test[partysimilar]Independent  = [partysimilar]_subpop_6
test[partysimilar]Independent  = [partysimilar]_subpop_7

qui svy: mean partysimilar, subpop (if condition ==2) over(pid)
test[partysimilar]Independent  = [partysimilar]_subpop_1
test[partysimilar]Independent  = [partysimilar]_subpop_2
test[partysimilar]Independent  = [partysimilar]_subpop_3
test[partysimilar]Independent  = [partysimilar]_subpop_5
test[partysimilar]Independent  = [partysimilar]_subpop_6
test[partysimilar]Independent  = [partysimilar]_subpop_7

qui svy: mean partysimilar, subpop (if condition ==3) over(pid)
test[partysimilar]Independent  = [partysimilar]_subpop_1
test[partysimilar]Independent  = [partysimilar]_subpop_2
test[partysimilar]Independent  = [partysimilar]_subpop_3
test[partysimilar]Independent  = [partysimilar]_subpop_5
test[partysimilar]Independent  = [partysimilar]_subpop_6
test[partysimilar]Independent  = [partysimilar]_subpop_7

qui svy: mean partysimilar, subpop (if condition ==4) over(pid)
test[partysimilar]Independent  = [partysimilar]_subpop_1
test[partysimilar]Independent  = [partysimilar]_subpop_2
test[partysimilar]Independent  = [partysimilar]_subpop_3
test[partysimilar]Independent  = [partysimilar]_subpop_5
test[partysimilar]Independent  = [partysimilar]_subpop_6
test[partysimilar]Independent  = [partysimilar]_subpop_7

*Prototype Perceptions by Levels of Political Knowledge with 0 Knowledge As Baseline (Appendix D)

qui svy: mean partysimilar, subpop (if condition ==1) over(know_index)
test[partysimilar]0  = [partysimilar]1
test[partysimilar]0  = [partysimilar]2
test[partysimilar]0  = [partysimilar]3
test[partysimilar]0  = [partysimilar]4

qui svy: mean partysimilar, subpop (if condition ==2) over(know_index)
test[partysimilar]0  = [partysimilar]1
test[partysimilar]0  = [partysimilar]2
test[partysimilar]0  = [partysimilar]3
test[partysimilar]0  = [partysimilar]4

qui svy: mean partysimilar, subpop (if condition ==3) over(know_index)
test[partysimilar]0  = [partysimilar]1
test[partysimilar]0  = [partysimilar]2
test[partysimilar]0  = [partysimilar]3
test[partysimilar]0  = [partysimilar]4

qui svy: mean partysimilar, subpop (if condition ==4) over(know_index)
test[partysimilar]0  = [partysimilar]1
test[partysimilar]0  = [partysimilar]2
test[partysimilar]0  = [partysimilar]3
test[partysimilar]0  = [partysimilar]4





*************************************************************
*************************************************************
********SECTION 4: ATE ESTIMATES + MARGINAL EFFECTS**********
*************************************************************
*************************************************************





*ATE of Non-Prototypicality on Vote Choice

	*Republican Prototype ATEs (Generates Figure 5 in Article)

qui svy: reg vote srv sr condition  if condition<=2 
estimates store sr1, title(Vote for Republican)

qui svy: reg vote wrv wr condition  if condition<=2 
estimates store wr1, title(Vote for Republican)

qui svy: reg vote lrv lr condition  if condition<=2 
estimates store lr1, title(Vote for Republican)

qui svy: reg vote indv ind condition  if condition<=2 
estimates store indv1, title(Vote for Republican)

qui svy: reg vote ldv ld condition  if condition<=2 
estimates store ld1, title(Vote for Republican)

qui svy: reg vote wdv wd condition  if condition<=2 
estimates store wd1, title(Vote for Republican)

qui svy: reg vote sdv sd condition  if condition<=2 
estimates store sd1, title(Vote for Republican)

coefplot (sr1 \ wr1 \ lr1 \ indv1 \ ld1 \ wd1 \ sd1), yline(0) vertical recast(bar)fcolor(*.5) barwidth(0.25)  ciopts(recast(rcap)) citop   drop(_cons sr lr wr ind wd ld sd condition)  xline(0, lc(gs13) lp(dash)) title(ATE of Prototypicality, span) subtitle(on Vote Propensity, span) xsize(4) ysize(4)


qui svy: reg vote srv sr condition educ  if condition<=2 
estimates store sr1, title(Vote for Republican)

qui svy: reg vote wrv wr condition educ  if condition<=2 
estimates store wr1, title(Vote for Republican)

qui svy: reg vote lrv lr condition educ  if condition<=2 
estimates store lr1, title(Vote for Republican)

qui svy: reg vote indv ind condition educ  if condition<=2 
estimates store indv1, title(Vote for Republican)

qui svy: reg vote ldv ld condition educ  if condition<=2 
estimates store ld1, title(Vote for Republican)

qui svy: reg vote wdv wd condition educ  if condition<=2 
estimates store wd1, title(Vote for Republican)

qui svy: reg vote sdv sd condition educ  if condition<=2 
estimates store sd1, title(Vote for Republican)

coefplot (sr1 \ wr1 \ lr1 \ indv1 \ ld1 \ wd1 \ sd1), yline(0) vertical recast(bar)fcolor(*.5) barwidth(0.25)  ciopts(recast(rcap)) citop   drop(_cons sr lr wr ind wd ld sd condition)  xline(0, lc(gs13) lp(dash)) title(ATE of Prototypicality, span) subtitle(on Vote Propensity, span) xsize(4) ysize(4)


	*Democratic Prototype ATEs (Generates Figure 6 in Article)

svy: reg vote srv sr condition  if condition>=3 
estimates store sr1, title(Vote for Republican)

svy: reg vote lrv lr condition  if condition>=3 
estimates store lr1, title(Vote for Republican)

svy: reg vote wrv wr condition  if condition>=3 
estimates store wr1, title(Vote for Republican)

svy: reg vote indv ind condition  if condition>=3 
estimates store indv1, title(Vote for Republican)

svy: reg vote wdv wd condition  if condition>=3 
estimates store wd1, title(Vote for Republican)

svy: reg vote ldv ld condition  if condition>=3 
estimates store ld1, title(Vote for Republican)

svy: reg vote sdv sd condition  if condition>=3 
estimates store sd1, title(Vote for Republican)

coefplot (sr1 \ wr1 \ lr1 \ indv1 \ ld1 \ wd1 \ sd1), yline(0) vertical recast(bar)fcolor(*.5) barwidth(0.25)  ciopts(recast(rcap)) citop   drop(_cons sr lr wr ind wd ld sd condition)  xline(0, lc(gs13) lp(dash)) title(ATE of Prototypicality, span) subtitle(on Vote Propensity, span) xsize(4) ysize(4)


qui svy: reg vote srv sr condition educ  if condition>=3 
estimates store sr1, title(Vote for Republican)

qui svy: reg vote wrv wr condition educ  if condition>=3 
estimates store wr1, title(Vote for Republican)

qui svy: reg vote lrv lr condition educ  if condition>=3 
estimates store lr1, title(Vote for Republican)

qui svy: reg vote indv ind condition educ  if condition>=3 
estimates store indv1, title(Vote for Republican)

qui svy: reg vote ldv ld condition educ  if condition>=3 
estimates store ld1, title(Vote for Republican)

qui svy: reg vote wdv wd condition educ  if condition>=3 
estimates store wd1, title(Vote for Republican)

qui svy: reg vote sdv sd condition educ  if condition>=3 
estimates store sd1, title(Vote for Republican)

coefplot (sr1 \ wr1 \ lr1 \ indv1 \ ld1 \ wd1 \ sd1), yline(0) vertical recast(bar)fcolor(*.5) barwidth(0.25)  ciopts(recast(rcap)) citop   drop(_cons sr lr wr ind wd ld sd condition)  xline(0, lc(gs13) lp(dash)) title(ATE of Prototypicality, span) subtitle(on Vote Propensity, span) xsize(4) ysize(4)


	*Generates Figure 7

qui svy: reg vote pid##condition if condition<=2
margins i.pid#i.condition  
marginsplot

qui svy: reg vote pid##condition educ if condition<=2
margins i.pid#i.condition  
marginsplot

	*Generates Figure 8

qui svy: reg vote pid##condition if condition>=3
margins i.pid#i.condition  
marginsplot


qui svy: reg vote pid##condition if condition>=3
margins i.pid#i.condition  
marginsplot

*ATE of Non-Prototypicality on Candidate Affect

	*Generates Figure 9 in Article

qui svy: reg therm srv sr condition  if condition<=2 
estimates store sr1, title(Vote for Republican)

qui svy: reg therm lrv lr condition  if condition<=2 
estimates store lr1, title(Vote for Republican)

qui svy: reg therm wrv wr condition  if condition<=2 
estimates store wr1, title(Vote for Republican)

qui svy: reg therm indv ind condition  if condition<=2 
estimates store indv1, title(Vote for Republican)

qui svy: reg therm wdv wd condition  if condition<=2 
estimates store wd1, title(Vote for Republican)

qui svy: reg therm ldv ld condition  if condition<=2 
estimates store ld1, title(Vote for Republican)

qui svy: reg therm sdv sd condition  if condition<=2 
estimates store sd1, title(Vote for Republican)

coefplot (sr1 \ wr1 \ lr1 \ indv1 \ ld1 \ wd1 \ sd1), yline(0) vertical recast(bar)fcolor(*.5) barwidth(0.25)  ciopts(recast(rcap)) citop   drop(_cons sr lr wr ind wd ld sd condition)  xline(0, lc(gs13) lp(dash)) title(ATE of Prototypicality, span) subtitle(on Candidate Affect, span) xsize(4) ysize(4)


qui svy: reg therm srv sr condition educ  if condition<=2 
estimates store sr1, title(Vote for Republican)

qui svy: reg therm lrv lr condition educ if condition<=2 
estimates store lr1, title(Vote for Republican)

qui svy: reg therm wrv wr condition educ if condition<=2 
estimates store wr1, title(Vote for Republican)

qui svy: reg therm indv ind condition educ  if condition<=2 
estimates store indv1, title(Vote for Republican)

qui svy: reg therm wdv wd condition educ  if condition<=2 
estimates store wd1, title(Vote for Republican)

qui svy: reg therm ldv ld condition educ if condition<=2 
estimates store ld1, title(Vote for Republican)

qui svy: reg therm sdv sd condition educ if condition<=2 
estimates store sd1, title(Vote for Republican)

coefplot (sr1 \ wr1 \ lr1 \ indv1 \ ld1 \ wd1 \ sd1), yline(0) vertical recast(bar)fcolor(*.5) barwidth(0.25)  ciopts(recast(rcap)) citop   drop(_cons sr lr wr ind wd ld sd condition)  xline(0, lc(gs13) lp(dash)) title(ATE of Prototypicality, span) subtitle(on Candidate Affect, span) xsize(4) ysize(4)


	*Generates Figure 10 in Article

qui svy: reg therm srv sr condition  if condition>=3 
estimates store sr1, title(Vote for Republican)

qui svy: reg therm lrv lr condition  if condition>=3 
estimates store lr1, title(Vote for Republican)

qui svy: reg therm wrv wr condition  if condition>=3 
estimates store wr1, title(Vote for Republican)

qui svy: reg therm indv ind condition  if condition>=3 
estimates store indv1, title(Vote for Republican)

qui svy: reg therm wdv wd condition  if condition>=3 
estimates store wd1, title(Vote for Republican)

qui svy: reg therm ldv ld condition  if condition>=3 
estimates store ld1, title(Vote for Republican)

qui svy: reg therm sdv sd condition  if condition>=3 
estimates store sd1, title(Vote for Republican)

coefplot (sr1 \ wr1 \ lr1 \ indv1 \ ld1 \ wd1 \ sd1), yline(0) vertical recast(bar)fcolor(*.5) barwidth(0.25)  ciopts(recast(rcap)) citop   drop(_cons sr lr wr ind wd ld sd condition)  xline(0, lc(gs13) lp(dash)) title(ATE of Prototypicality, span) subtitle(on Candidate Affect, span) xsize(4) ysize(4)

	*Generates Figure 11
	
qui svy: reg therm pid##condition if condition<=2
margins i.pid#i.condition  
marginsplot

	*Generates Figure 12
	
qui svy: reg therm pid##condition if condition>=3
margins i.pid#i.condition  
marginsplot

log close
translate session.smcl session.pdf
