////////////////////////////////////////////////////////////////////////////////
//////     		  REPLICATION MATERIAL FOR PLESCIA (2017)                ///////
//////      Portfolio-specific accountability and retrospective voting   ///////
////////////////////////////////////////////////////////////////////////////////

version 14

*****************************    load individual level - ITANES_2001-2006_subset
clear all
use "ITANES_2001-2006_subset", clear

***overall performance evaluation
recode q71  (1=0) (2=1) (3=2) (4=3) (5=4) (else=.), gen (retro_general)

forvalues i=1(1)6{
recode  q70_`i' (1=0) (2=1) (3=2) (4=3) (5=4) (else=.)
label define q70_`i'1 0 "molto pos"  1 "pos" 2 "ne pos ne neg" 3 "neg" 4 "molto neg" 
label values q70_`i'  q70_`i'1
}

forvalues i=1(1)6{
recode  q69_`i' (1=0) (2=1) (3=2) (4=3) (5=4) (else=.)
label define q69_`i'1 0 "molto pos"  1 "pos" 2 "ne pos ne neg" 3 "neg" 4 "molto neg" 
label values q69_`i'  q69_`i'1
}

rename q69_5 q70_0_criminalita
rename q69_1 q70_1_economy
rename q69_6 q70_2_pensioni
rename q70_1 q70_3_justice
rename q70_2 q70_4_war
rename q70_5 q70_5_TV
rename q70_4 q70_6_labour
rename q70_3 q70_7_patente
rename q70_6 q70_8_immigration
rename q69_3 q70_9_unempl
rename q69_4 q70_10_infla

*** ideology
recode  q53 (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7) (9=8) (10=9) (else=.), gen (ideo_self_2004)
egen meanIDEO = mean(ideo_self_2004)
replace ideo_self_2004=4 if ideo_self_2004==.
 forvalues i=1(1)16{
recode  q52_`i' (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7) (9=8) (10=9) (else=.)
}

*** socio-demo controls
gen female=1 if a_04==2
replace female=0 if a_04==1
gen edu=0 if c_04==1 | c_04==2 | c_04==3 
replace edu=1 if c_04==4
replace edu=2 if  c_04==5 | c_04==6
replace edu=3 if c_04==7
recode c22 (4=0) (3=1) (2=2) (1=3) (else=.), gen (religiosity)
recode q1 (1=3) (2=2) (3=1) (4=0)
recode q2_2 (1=3) (2=2) (3=1) (4=0)

*** choice
gen choice_FI_2001=0
replace choice_FI_2001=1 if e20==8
gen choice_AN_2001=0
replace choice_AN_2001=1 if e20==2
gen choice_LN_2001=0
replace choice_LN_2001=1 if e20==11
gen choice_UDC_2001=0
replace choice_UDC_2001=1 if e20==3

**PTV 
recode  q28_6 (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10) (else=.), gen (PTV_FI)
recode  q28_1 (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10) (else=.), gen (PTV_AN)
recode  q28_7 (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10) (else=.), gen (PTV_LN)
recode  q28_10 (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10) (else=.), gen (PTV_UDC)

** knowledge
recode c17 (1=1) (else=0)
recode c18 (1=1) (else=0)
recode c19 (1=1) (else=0)
gen know=c17+c18+c19
recode know (0/1=0) (else=1), gen (know2)

* PID 
gen PID2004_1=0 if q61!=.  /*FI*/
replace PID2004_1=1 if q61==12
gen PID2004_2=0 if q61!=. /*AN*/
replace PID2004_2=1 if q61==14
gen PID2004_3=0 if q61!=. /*LN*/
replace PID2004_3=1 if q61==13
gen PID2004_4=0 if q61!=. /*UDC*/
replace PID2004_4=1 if q61==9
gen PID2001_1=0 if c33!=. /*FI*/
replace PID2001_1=1 if c33==6
gen PID2001_2=0 if c33!=. /*AN*/
replace PID2001_2=1 if c33==2
gen PID2001_3=0 if c33!=. /*LN*/
replace PID2001_3=1 if c33==8
gen PID2001_4=0 if c33!=. /*UDC*/
replace PID2001_4=1 if c33==3 | c33==4

****************************************************************         TABLE 2  
sum q70_*

****************************************************************         TABLE 3
set more off
eststo clear 

qui regress PTV_FI c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004  choice_FI_2001 q2_2
eststo: regress PTV_FI c.retro_general female edu eta_01  religiosity ideo_self_2004 choice_FI_2001 q2_2 if e(sample)
qui regress PTV_AN c.retro_general c.q70_* female edu eta_01  religiosity  ideo_self_2004  choice_AN_2001 q2_2
eststo: regress PTV_AN c.retro_general female edu eta_01  religiosity ideo_self_2004 choice_AN_2001 q2_2 if e(sample)
qui regress PTV_UDC c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2
eststo: regress PTV_UDC c.retro_general female edu eta_01  religiosity ideo_self_2004  choice_UDC_2001 q2_2 if e(sample)
qui regress PTV_LN c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2
eststo: regress PTV_LN c.retro_general female edu eta_01  religiosity ideo_self_2004  choice_LN_2001 q2_2 if e(sample) 

esttab, se(%6.3f) starlevels(+ 0.1 * .05 ** .01 *** .001)  scalars ( r2_a bic aic)

****************************************************************        FIGURE 1

qui regress PTV_FI c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004  choice_FI_2001 q2_2
regress PTV_FI c.retro_general female edu eta_01  religiosity ideo_self_2004 choice_FI_2001 q2_2 if e(sample)
margins , at (retro_general  =(0(1)4))  post
est store FIvote

qui regress PTV_AN c.retro_general c.q70_* female edu eta_01  religiosity  ideo_self_2004  choice_AN_2001 q2_2
regress PTV_AN c.retro_general female edu eta_01  religiosity ideo_self_2004 choice_AN_2001 q2_2 if e(sample)
margins , at (retro_general  =(0(1)4))  post
est store ANvote

qui regress PTV_UDC c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2
regress PTV_UDC c.retro_general female edu eta_01  religiosity ideo_self_2004  choice_UDC_2001 q2_2 if e(sample)
margins , at (retro_general  =(0(1)4))  post
est store UDCvote

qui regress PTV_LN c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2
regress PTV_LN c.retro_general female edu eta_01  religiosity ideo_self_2004  choice_LN_2001 q2_2 if e(sample) 
margins , at (retro_general  =(0(1)4))  post
est store LNvote

coefplot  ANvote LNvote UDCvote FIvote, at xtitle("Overall performance evaluation")  ///
scheme (sj) recast(line)lwidth(*2) ciopts(recast(rarea)) col(black) graphregion(fcolor(white)) ylabel(0(1)8) ///
ytitle("Predicted probability to vote for party X") ylabel(, labsize(small)) xlabel(0 `" "very"  "positive" "' 1 `" "fairly"  "positive" "' 2 "neither"  3 `" "fairly"  "negative" "' 4 `" "very"  "negative" "', labsize(small))  ///
legend(ring(0) position(2) row(2)) legend(size(small)) legend(region(margin(tiny))) legend(rowgap(0.02))


******************************************************      TABLE 4 (first half)
rename q69_2 q_11_ecozona

egen mean_FI=rowmean(q70_0_criminalita q70_4_war q70_10_infla q_11_ecozona)
egen mean_LN=rowmean(q70_9_unempl q70_2_pensioni q70_3_justice q70_6_labour q70_9_unempl)
egen mean_AN=rowmean(q70_5_TV)

set more off
eststo clear

qui regress PTV_FI c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_FI_2001 q2_2
eststo: regress PTV_FI mean_FI mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004 choice_FI_2001 q2_2   if e(sample)
qui regress PTV_AN c.retro_general c.q70_* female edu eta_01  religiosity  ideo_self_2004 choice_AN_2001 q2_2
eststo: regress PTV_AN mean_FI mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity  ideo_self_2004 choice_AN_2001 q2_2  if e(sample)
qui regress PTV_UDC c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2
eststo: regress PTV_UDC mean_FI mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2   if e(sample)
qui regress PTV_LN c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2  
eststo: regress PTV_LN mean_FI mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2   if e(sample)

esttab, se(%6.3f) starlevels(+ 0.1 * .05 ** .01 *** .001)  scalars ( r2_a bic aic)

******************************************************     TABLE 4 (second half)
set more off
eststo clear

qui regress PTV_FI c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_FI_2001 q2_2
eststo: regress PTV_FI c.q70_*  female edu eta_01  religiosity ideo_self_2004 choice_FI_2001 q2_2   if e(sample)
qui regress PTV_AN c.retro_general c.q70_* female edu eta_01  religiosity  ideo_self_2004 choice_AN_2001 q2_2
eststo: regress PTV_AN c.q70_* female edu eta_01  religiosity  ideo_self_2004 choice_AN_2001 q2_2  if e(sample)
qui regress PTV_UDC c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2
eststo: regress PTV_UDC c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2   if e(sample)
qui regress PTV_LN c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2  
eststo: regress PTV_LN c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2   if e(sample)

esttab, se(%6.3f) starlevels(+ 0.1 * .05 ** .01 *** .001)  scalars ( r2_a bic aic)

****************************************************************        FIGURE 2
qui regress PTV_FI c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_FI_2001 q2_2
regress PTV_FI mean_FI mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004 choice_FI_2001 q2_2   if e(sample)
margins , at (mean_FI  =(0(1)4))  post
est store FIvote

qui regress PTV_AN c.retro_general c.q70_* female edu eta_01  religiosity  ideo_self_2004 choice_AN_2001 q2_2
regress PTV_AN mean_FI mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity  ideo_self_2004 choice_AN_2001 q2_2  if e(sample)
margins , at (mean_FI  =(0(1)4))  post
est store ANvote

qui regress PTV_LN c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2  
regress PTV_LN mean_FI mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2   if e(sample)
margins , at (mean_FI  =(0(1)4))  post
est store LNvote

qui regress PTV_UDC c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2
regress PTV_UDC mean_FI mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2   if e(sample)
margins , at (mean_FI  =(0(1)4))  post
est store UDCvote

coefplot ANvote LNvote UDCvote FIvote, at xtitle("(Mean) performance evaluation (FI ministers)")  ///
scheme (sj) recast(line)lwidth(*2) ciopts(recast(rarea)) col(black) graphregion(fcolor(white)) ylabel(0(1)8) ///
ytitle("") ylabel(, labsize(small)) xlabel(0 `" "very"  "positive" "' 1 `" "fairly"  "positive" "' 2 "neither"  3 `" "fairly"  "negative" "' 4 `" "very"  "negative" "', labsize(small))  ///
legend(ring(0) position(2) row(2)) legend(size(small)) legend(region(margin(tiny))) legend(rowgap(0.02))
graph save Graph "FI.gph", replace

************
qui regress PTV_FI c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_FI_2001 q2_2
regress PTV_FI mean_FI mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004 choice_FI_2001 q2_2   if e(sample)
margins , at (mean_AN  =(0(1)4))  post
est store FIvote

qui regress PTV_AN c.retro_general c.q70_* female edu eta_01  religiosity  ideo_self_2004 choice_AN_2001 q2_2
regress PTV_AN mean_FI mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity  ideo_self_2004 choice_AN_2001 q2_2  if e(sample)
margins , at (mean_AN  =(0(1)4))  post
est store ANvote

qui regress PTV_LN c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2  
regress PTV_LN mean_FI mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2   if e(sample)
margins , at (mean_AN  =(0(1)4))  post
est store LNvote

qui regress PTV_UDC c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2
regress PTV_UDC mean_FI mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2   if e(sample)
margins , at (mean_AN  =(0(1)4))  post
est store UDCvote

coefplot ANvote LNvote UDCvote FIvote, at xtitle("(Mean) performance evaluation (AN ministers)")  ///
scheme (sj) recast(line)lwidth(*2) ciopts(recast(rarea)) col(black) graphregion(fcolor(white)) ylabel(0(1)8) ///
ytitle("") ylabel(, labsize(small)) xlabel(0 `" "very"  "positive" "' 1 `" "fairly"  "positive" "' 2 "neither"  3 `" "fairly"  "negative" "' 4 `" "very"  "negative" "', labsize(small))  ///
legend(ring(0) position(2) row(2)) legend(size(small)) legend(region(margin(tiny))) legend(off)
graph save Graph "AN.gph", replace

************
qui regress PTV_FI c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_FI_2001 q2_2
regress PTV_FI mean_FI mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004 choice_FI_2001 q2_2   if e(sample)
margins , at (mean_LN  =(0(1)4))  post
est store FIvote

qui regress PTV_AN c.retro_general c.q70_* female edu eta_01  religiosity  ideo_self_2004 choice_AN_2001 q2_2
regress PTV_AN mean_FI mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity  ideo_self_2004 choice_AN_2001 q2_2  if e(sample)
margins , at (mean_LN  =(0(1)4))  post
est store ANvote

qui regress PTV_LN c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2  
regress PTV_LN mean_FI mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2   if e(sample)
margins , at (mean_LN  =(0(1)4))  post
est store LNvote

qui regress PTV_UDC c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2
regress PTV_UDC mean_FI mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2   if e(sample)
margins , at (mean_LN  =(0(1)4))  post
est store UDCvote

coefplot ANvote LNvote UDCvote FIvote, at xtitle("(Mean) performance evaluation (LN ministers)")  ///
scheme (sj) recast(line)lwidth(*2) ciopts(recast(rarea)) col(black) graphregion(fcolor(white)) ylabel(0(1)8) ///
ytitle("") ylabel(, labsize(small)) xlabel(0 `" "very"  "positive" "' 1 `" "fairly"  "positive" "' 2 "neither"  3 `" "fairly"  "negative" "' 4 `" "very"  "negative" "', labsize(small))  ///
legend(ring(0) position(2) row(2)) legend(size(small)) legend(region(margin(tiny))) legend(off)
graph save Graph "LN.gph", replace

************
qui regress PTV_FI c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_FI_2001 q2_2
regress PTV_FI mean_FI mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004 choice_FI_2001 q2_2   if e(sample)
margins , at (q70_7_patente  =(0(1)4))  post
est store FIvote

qui regress PTV_AN c.retro_general c.q70_* female edu eta_01  religiosity  ideo_self_2004 choice_AN_2001 q2_2
regress PTV_AN mean_FI mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity  ideo_self_2004 choice_AN_2001 q2_2  if e(sample)
margins , at (q70_7_patente  =(0(1)4))  post
est store ANvote


qui regress PTV_LN c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2  
regress PTV_LN mean_FI mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2   if e(sample)
margins , at (q70_7_patente  =(0(1)4))  post
est store LNvote

qui regress PTV_UDC c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2
regress PTV_UDC mean_FI mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2   if e(sample)
margins , at (q70_7_patente  =(0(1)4))  post
est store UDCvote

coefplot ANvote LNvote UDCvote FIvote, at xtitle("Performance evaluation on driving license issue")  ///
scheme (sj) recast(line)lwidth(*2) ciopts(recast(rarea)) col(black) graphregion(fcolor(white)) ylabel(0(1)8) ///
ytitle("") ylabel(, labsize(small)) xlabel(0 `" "very"  "positive" "' 1 `" "fairly"  "positive" "' 2 "neither"  3 `" "fairly"  "negative" "' 4 `" "very"  "negative" "', labsize(small))  ///
legend(ring(0) position(2) row(2)) legend(size(small))  legend(region(margin(tiny))) legend(off)
graph save Graph "driving.gph", replace

graph combine FI.gph AN.gph LN.gph driving.gph , graphregion(fcolor(white)) imargin(zero) l1("Predicted probaility to vote for party X")


*****************************    load individual level - ITANES_2001-2006_subset
clear all
use "ITANES_2001-2006_subset", clear

*********************************************************************       2004 
* retrospective evaluations
recode q65  (5=4) (4=3) (3=2) (2=1) (1=0) (else=.), gen (retro_MII)

*ideology
recode  q53 (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7) (9=8) (10=9) (else=.), gen (ideo_self_2004)
egen meanIDEO = mean(ideo_self_2004)
replace ideo_self_2004=4 if ideo_self_2004==.

*socio-demo controls
gen female=1 if a_04==2
replace female=0 if a_04==1
gen edu=0 if c_04==1 | c_04==2 | c_04==3 
replace edu=1 if c_04==4
replace edu=2 if  c_04==5 | c_04==6
replace edu=3 if c_04==7
recode c22 (4=0) (3=1) (2=2) (1=3) (else=.), gen (religiosity)
recode q1 (1=3) (2=2) (3=1) (4=0)
recode q2_2 (1=3) (2=2) (3=1) (4=0)

*choice
gen choice_FI_2001=0
replace choice_FI_2001=1 if e20==8
gen choice_AN_2001=0
replace choice_AN_2001=1 if e20==2
gen choice_LN_2001=0
replace choice_LN_2001=1 if e20==11
gen choice_UDC_2001=0
replace choice_UDC_2001=1 if e20==3

**PTV 
recode  q28_6 (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10) (else=.), gen (PTV_FI)
recode  q28_1 (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10) (else=.), gen (PTV_AN)
recode  q28_7 (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10) (else=.), gen (PTV_LN)
recode  q28_10 (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10) (else=.), gen (PTV_UDC)

** knowledge
recode c17 (1=1) (else=0)
recode c18 (1=1) (else=0)
recode c19 (1=1) (else=0)
gen know=c17+c18+c19
recode know (0/1=0) (else=1), gen (know2)


***********************************************************      TABLE A1 (2004)
set more off
eststo clear 

qui regress PTV_FI c.retro_MII c.q70_* female edu eta_01  religiosity ideo_self_2004  choice_FI_2001 q2_2
eststo: regress PTV_FI c.retro_MII female edu eta_01  religiosity ideo_self_2004 choice_FI_2001 q2_2 if e(sample)
qui regress PTV_AN c.retro_MII c.q70_* female edu eta_01  religiosity  ideo_self_2004  choice_AN_2001 q2_2
eststo: regress PTV_AN c.retro_MII female edu eta_01  religiosity ideo_self_2004 choice_AN_2001 q2_2 if e(sample)
qui regress PTV_UDC c.retro_MII c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2
eststo: regress PTV_UDC c.retro_MII female edu eta_01  religiosity ideo_self_2004  choice_UDC_2001 q2_2 if e(sample)
qui regress PTV_LN c.retro_MII c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2
eststo: regress PTV_LN c.retro_MII female edu eta_01  religiosity ideo_self_2004  choice_LN_2001 q2_2 if e(sample) 

esttab, se(%6.3f) starlevels(+ 0.1 * .05 ** .01 *** .001)  scalars ( r2_a bic aic)

***********************************************************      FIGURE 3 (2004)
qui regress PTV_FI c.retro_MII c.q70_* female edu eta_01  religiosity ideo_self_2004  choice_FI_2001 q2_2
regress PTV_FI c.retro_MII female edu eta_01  religiosity ideo_self_2004 choice_FI_2001 q2_2 if e(sample)
margins , at (retro_MII  =(0(1)4))  post
est store FIvote

qui regress PTV_AN c.retro_MII c.q70_* female edu eta_01  religiosity  ideo_self_2004  choice_AN_2001 q2_2
regress PTV_AN c.retro_MII female edu eta_01  religiosity ideo_self_2004 choice_AN_2001 q2_2 if e(sample)
margins , at (retro_MII  =(0(1)4))  post
est store ANvote

qui regress PTV_UDC c.retro_MII c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2
regress PTV_UDC c.retro_MII female edu eta_01  religiosity ideo_self_2004  choice_UDC_2001 q2_2 if e(sample)
margins , at (retro_MII  =(0(1)4))  post
est store UDCvote

qui regress PTV_LN c.retro_MII c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2
regress PTV_LN c.retro_MII female edu eta_01  religiosity ideo_self_2004  choice_LN_2001 q2_2 if e(sample) 
margins , at (retro_MII  =(0(1)4))  post
est store LNvote

coefplot  ANvote LNvote UDCvote FIvote, at xtitle("Overall performance evaluation")  ///
scheme (sj) recast(line)lwidth(*2) ciopts(recast(rarea)) col(black) graphregion(fcolor(white)) ylabel(0(1)8) ///
ytitle("2004") ylabel(, labsize(small)) xlabel(0 `" "very"  "positive" "' 1 `" "fairly"  "positive" "' 2 "neither"  3 `" "fairly"  "negative" "' 4 `" "very"  "negative" "', labsize(small))  ///
legend(ring(0) position(2) row(2)) legend(size(small)) legend(region(margin(tiny))) legend(rowgap(0.02))
graph save Graph "2004el.gph", replace


*******************************       load individual level - ITANES_2006_subset
clear all
use "ITANES_2006_subset", clear

*********************************************************************       2006
* retrospective evaluations
recode a32   (5=1) (4=0.75) (3=0.5) (2=0.25) (1=0) (else=.), gen (cont_perf_2006)
recode cont_perf_2006  (0=4) (0.25=3) (0.5=2) (0.75=1) (1=0) (else=.), gen (retroFULL)

*vote choice
gen choice_FI_2001=0
replace choice_FI_2001=1 if a80_2==7
gen choice_AN_2001=0
replace choice_AN_2001=1 if a80_2==1
gen choice_LN_2001=0
replace choice_LN_2001=1 if a80_2==10
gen choice_UDC_2001=0
replace choice_UDC_2001=1 if a80_2==2

*ideology
recode  a78 (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7) (9=8) (10=9) (else=.), gen (ideo_self_2006)
egen meanIDEO = mean(ideo_self_2006)
replace ideo_self_2006=4 if ideo_self_2006==.

*socio-demo controls
gen female=1 if a240 ==2
replace female=0 if  a240 ==1
gen edu=0 if a243 ==1 |  a243 ==2 |  a243 ==3
replace edu=1 if  a243==4 
replace edu=2 if a243==5 |  a243==6 |  a243==7 |  a243==8
replace edu=3 if a243==9 |  a243==10
recode a230 (4=0) (3=1) (2=2) (1=3) (else=.), gen (religiosity)
recode a20 (1=0) (2=1) (3=2) (4=3) (else=.), gen (pol_int)

**PTV 
recode  a85_6 (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7) (9=8) (10=9) (11=10) (else=.), gen (PTV_FI)
recode  a85_1 (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7) (9=8) (10=9) (11=10) (else=.), gen (PTV_AN)
recode  a85_7 (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7) (9=8) (10=9) (11=10) (else=.), gen (PTV_LN)
recode  a85_10 (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7) (9=8) (10=9) (11=10) (else=.), gen (PTV_UDC)

** knowledge
recode a120  (1=1) (else=0)
recode a121 (1=1) (else=0)
recode a122 (1=1) (else=0)

gen know=a120+a121+a122
recode know (0/1=0) (else=1), gen (know2)

***********************************************************      TABLE A1 (2006)
set more off
eststo clear

qui regress PTV_FI c.retroFULL  female edu eta  religiosity  ideo_self_2006 choice_FI_2001 pol_int
eststo:  regress PTV_FI c.retroFULL female edu eta  religiosity  ideo_self_2006 choice_FI_2001 pol_int if e(sample)
qui regress PTV_AN c.retroFULL  female edu eta  religiosity  ideo_self_2006 choice_AN_2001 pol_int
eststo:  regress PTV_AN c.retroFULL  female edu eta  religiosity  ideo_self_2006 choice_AN_2001 pol_int if e(sample)
qui regress PTV_LN c.retroFULL  female edu eta  religiosity  ideo_self_2006 choice_LN_2001 pol_int
eststo:  regress PTV_LN c.retroFULL  female edu eta  religiosity  ideo_self_2006 choice_LN_2001 pol_int if e(sample)
qui regress PTV_UDC c.retroFULL  female edu eta  religiosity  ideo_self_2006 choice_UDC_2001 pol_int
eststo:  regress PTV_UDC c.retroFULL  female edu eta  religiosity  ideo_self_2006 choice_UDC_2001 pol_int if e(sample)

esttab, se(%6.3f) starlevels(+ 0.1 * .05 ** .01 *** .001)  scalars ( r2_a bic aic)

***********************************************************      FIGURE 3 (2006)
qui regress PTV_FI c.retroFULL  female edu eta  religiosity  ideo_self_2006 choice_FI_2001 pol_int
qui regress PTV_FI c.retroFULL female edu eta  religiosity  ideo_self_2006 choice_FI_2001 pol_int if e(sample)
margins , at (retroFULL  =(0(1)4))  post
est store FIvote

qui regress PTV_AN c.retroFULL  female edu eta  religiosity  ideo_self_2006 choice_AN_2001 pol_int
qui regress PTV_AN c.retroFULL  female edu eta  religiosity  ideo_self_2006 choice_AN_2001 pol_int if e(sample)
margins , at (retroFULL  =(0(1)4))  post
est store ANvote

qui regress PTV_LN c.retroFULL  female edu eta  religiosity  ideo_self_2006 choice_LN_2001 pol_int
qui regress PTV_LN c.retroFULL  female edu eta  religiosity  ideo_self_2006 choice_LN_2001 pol_int if e(sample)
margins , at (retroFULL  =(0(1)4))  post
est store LNvote

qui regress PTV_UDC c.retroFULL  female edu eta  religiosity  ideo_self_2006 choice_UDC_2001 pol_int
qui regress PTV_UDC c.retroFULL  female edu eta  religiosity  ideo_self_2006 choice_UDC_2001 pol_int if e(sample)
margins , at (retroFULL  =(0(1)4))  post
est store UDCvote

coefplot  ANvote LNvote UDCvote FIvote, at xtitle("Overall performance evaluation")  ///
scheme (sj) recast(line)lwidth(*2) ciopts(recast(rarea)) col(black) graphregion(fcolor(white)) ylabel(0(1)8) ///
ytitle("2006") ylabel(, labsize(small)) xlabel(0 `" "very"  "positive" "' 1 `" "fairly"  "positive" "' 2 "neither"  3 `" "fairly"  "negative" "' 4 `" "very"  "negative" "', labsize(small))  ///
legend(ring(0) position(2) row(2)) legend(size(small)) legend(region(margin(tiny))) legend(rowgap(0.02))
graph save Graph "2006el.gph", replace


*******************************       load individual level - ITANES_2008_subset
clear all
use "ITANES_2008_subset", clear

*****************************************************************           2008
* retrospective evaluations
recode D031  (5=1) (4=0.75) (3=0.5) (2=0.25) (1=0) (else=.), gen (cont_perf_2008)
recode cont_perf_2008  (0=4) (0.25=3) (0.5=2) (0.75=1) (1=0) (else=.), gen (retroFULL)

*vote choice
gen choice_PD_2006=0
replace choice_PD_2006=1 if D053==4
gen choice_IDV_2006=0
replace choice_IDV_2006=1 if D053==6
gen choice_RIF_2006=0
replace choice_RIF_2006=1 if D053==1
recode D001 (1=0) (2=1) (3=2) (4=3) (else=.), gen (pol_int)

*ideology
recode  D045 (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7) (9=8) (10=9) (else=.), gen (ideo_self_2008)
egen meanIDEO = mean(ideo_self_2008)
replace ideo_self_2008=4 if ideo_self_2008==.

*socio-demo controls
gen female=1 if Sesso=="F"
replace female=0 if Sesso=="M"
gen edu=0 if A004==1 |  A004==2
replace edu=1 if  A004==3
replace edu=2 if A004==4 |  A004==5 |  A004==6 | A004==7 |  A004==8
replace edu=3 if A004==9 | A004==10
recode D135 (1=0) (2=1) (3=2) (4=3) (else=.), gen (religiosity)

**PTV 
recode  D130_2 (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10) (else=.), gen (PTV_PD)
recode  D130_3 (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10) (else=.), gen (PTV_IDV)
recode  D130_1 (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10) (else=.), gen (PTV_RIF)

** knowledge
recode D131_2  (1=1) (else=0)
recode D131_3 (1=1) (else=0)
gen know=D131_2+D131_3
recode know (0/1=0) (else=1), gen (know2)

***********************************************************      TABLE A2 (2008)
set more off
eststo clear

eststo: regress PTV_PD c.retroFULL ideo_self_2008 female edu annonas  religiosity  choice_PD_2006 pol_int
eststo: regress PTV_IDV c.retroFULL ideo_self_2008 female edu annonas  religiosity choice_IDV_2006 pol_int
eststo: regress PTV_RIF c.retroFULL ideo_self_2008 female edu annonas  religiosity choice_RIF_2006 pol_int

esttab, se(%6.3f) starlevels(+ 0.1 * .05 ** .01 *** .001)  scalars ( r2_a bic aic)

***********************************************************      FIGURE 3 (2008)
qui regress PTV_PD c.retroFULL  ideo_self_2008 female edu annonas know religiosity  choice_PD_2006 pol_int
qui regress PTV_PD c.retroFULL ideo_self_2008 female edu annonas know religiosity  choice_PD_2006 pol_int if e(sample)
margins , at (retroFULL  =(0(1)4))  post
est store PDvote

qui regress PTV_IDV c.retroFULL  ideo_self_2008 female edu annonas know religiosity  choice_IDV_2006 pol_int 
qui regress PTV_IDV c.retroFULL  ideo_self_2008 female edu annonas know religiosity  choice_IDV_2006 pol_int if e(sample)
margins , at (retroFULL  =(0(1)4))  post
est store IDVvote

qui regress PTV_RIF c.retroFULL  ideo_self_2008 female edu annonas know religiosity  choice_RIF_2006 pol_int
qui regress PTV_RIF c.retroFULL  ideo_self_2008 female edu annonas know religiosity  choice_RIF_2006 pol_int if e(sample)
margins , at (retroFULL  =(0(1)4))  post
est store RIFvote

coefplot  PDvote IDVvote RIFvote, at xtitle("Overall performance evaluation")  ///
scheme (sj) recast(line)lwidth(*2) ciopts(recast(rarea)) col(black) graphregion(fcolor(white)) ylabel(0(1)8) ///
ytitle("2008") ylabel(, labsize(small)) xlabel(0 `" "very"  "positive" "' 1 `" "fairly"  "positive" "' 2 "neither"  3 `" "fairly"  "negative" "' 4 `" "very"  "negative" "', labsize(small))  ///
legend(ring(0) position(2) row(2)) legend(size(small)) legend(region(margin(tiny))) legend(rowgap(0.02))
graph save Graph "2008el.gph", replace


*******************************       load individual level - ITANES_2011_subset
clear all
use "ITANES_2011_subset", clear

*****************************************************************           2011

* retrospective evaluations
recode Q15_W1  (1=4) (2=3) (3=2) (4=1) (5=0) (else=.), gen (retroFULL2011)
recode Q15_W4  (1=4) (2=3) (3=2) (4=1) (5=0) (else=.), gen (retroFULL2013)

gen choice_PDL_2008=0
replace choice_PDL_2008=1 if Q43_W1==4
gen choice_LN_2008=0
replace choice_LN_2008=1 if Q43_W1==5
gen choice_MAP_2008=0
replace choice_MAP_2008=1 if Q43_W1==9
recode Q01_W1 (1=0) (2=1) (3=2) (4=3) (else=.), gen (pol_int2011)
recode Q01_W4 (1=0) (2=1) (3=2) (4=3) (else=.), gen (pol_int2013)

*ideology
recode  Q34_W1 (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10) (else=.), gen (ideo_self_2011)
recode  Q34_W4 (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10) (else=.), gen (ideo_self_2013)

*socio-demo controls
gen female=1 if A001==2
replace female=0 if A001==1
gen edu=0 if A004==1 |  A004==2
replace edu=1 if  A004==3
replace edu=2 if A004==4 |  A004==5 |  A004==6 | A004==7 |  A004==8
replace edu=3 if A004==9 | A004==10 | A004==11
recode Q45_02_W1 (1=0) (2=1) (3=2) (4=3) (else=.), gen (religiosity)
recode Q45_01_W1 (0/2=0) (3/5=1) (6/8=2) (9/10=3) (else=.), gen (religiosity2)
replace religiosity=religiosity2 if religiosity==.

gen eta=A002
replace eta=. if A002>99

**PTV 
recode  Q36_06_W1 (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10) (else=.), gen (PTV_PDL2011)
recode  Q36_09_W1 (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10) (else=.), gen (PTV_LN2011)
recode  Q36_13_W1 (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10) (else=.), gen (PTV_MAP2011)


***********************************************************      TABLE A2 (2011)
set more off
eststo clear

eststo: regress PTV_PDL2011 c.retroFULL2011 ideo_self_2011 female edu eta  religiosity  choice_PDL_2008 pol_int2011
eststo: regress PTV_LN2011 c.retroFULL2011 ideo_self_2011 female edu eta  religiosity choice_LN_2008 pol_int2011
eststo: regress PTV_MAP2011 c.retroFULL2011 ideo_self_2011 female edu eta  religiosity choice_MAP_2008 pol_int2011

esttab, se(%6.3f) starlevels(+ 0.1 * .05 ** .01 *** .001)  scalars ( r2_a bic aic)

***********************************************************      FIGURE 3 (2011)
qui regress PTV_PDL c.retroFULL2011 ideo_self_2011 female edu eta  religiosity  choice_PDL_2008 pol_int2011
margins , at (retroFULL2011  =(0(1)4))  post
est store PDLvote

qui regress PTV_LN c.retroFULL2011 ideo_self_2011 female edu eta  religiosity choice_LN_2008 pol_int2011
margins , at (retroFULL2011  =(0(1)4))  post
est store LNvote

qui regress PTV_MAP c.retroFULL2011 ideo_self_2011 female edu eta  religiosity choice_MAP_2008 pol_int2011
margins , at (retroFULL2011  =(0(1)4))  post
est store MAPvote

coefplot  PDLvote LNvote MAPvote, at xtitle("Overall performance evaluation")  ///
scheme (sj) recast(line)lwidth(*2) ciopts(recast(rarea)) col(black) graphregion(fcolor(white)) ylabel(0(1)8) ///
ytitle("2011") ylabel(, labsize(small)) xlabel(0 `" "very"  "positive" "' 1 `" "fairly"  "positive" "' 2 "neither"  3 `" "fairly"  "negative" "' 4 `" "very"  "negative" "', labsize(small))  ///
legend(ring(0) position(2) row(2)) legend(size(small)) legend(region(margin(tiny))) legend(rowgap(0.02))
graph save Graph "2011el.gph", replace

graph combine 2004el.gph 2006el.gph 2008el.gph 2011el.gph, graphregion(fcolor(white)) imargin(zero) l1("Predicted probaility to vote for party X")









////////////////////////////////////////////////////////////////////////////////
//////     				ONLINE SUPPORTING MATERIAL           			 ///////
////////////////////////////////////////////////////////////////////////////////

*Additional tests on the effect of knowledge on retrospective evaluations and party support 

*****************************    load individual level - ITANES_2001-2006_subset
clear all
use "ITANES_2001-2006_subset", clear

***overall performance evaluation
recode q71  (1=0) (2=1) (3=2) (4=3) (5=4) (else=.), gen (retro_general)

forvalues i=1(1)6{
recode  q70_`i' (1=0) (2=1) (3=2) (4=3) (5=4) (else=.)
label define q70_`i'1 0 "molto pos"  1 "pos" 2 "ne pos ne neg" 3 "neg" 4 "molto neg" 
label values q70_`i'  q70_`i'1
}

forvalues i=1(1)6{
recode  q69_`i' (1=0) (2=1) (3=2) (4=3) (5=4) (else=.)
label define q69_`i'1 0 "molto pos"  1 "pos" 2 "ne pos ne neg" 3 "neg" 4 "molto neg" 
label values q69_`i'  q69_`i'1
}

rename q69_5 q70_0_criminalita
rename q69_1 q70_1_economy
rename q69_6 q70_2_pensioni
rename q70_1 q70_3_justice
rename q70_2 q70_4_war
rename q70_5 q70_5_TV
rename q70_4 q70_6_labour
rename q70_3 q70_7_patente
rename q70_6 q70_8_immigration
rename q69_3 q70_9_unempl
rename q69_4 q70_10_infla

*** ideology
recode  q53 (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7) (9=8) (10=9) (else=.), gen (ideo_self_2004)
egen meanIDEO = mean(ideo_self_2004)
replace ideo_self_2004=4 if ideo_self_2004==.
 forvalues i=1(1)16{
recode  q52_`i' (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7) (9=8) (10=9) (else=.)
}

*** socio-demo controls
gen female=1 if a_04==2
replace female=0 if a_04==1
gen edu=0 if c_04==1 | c_04==2 | c_04==3 
replace edu=1 if c_04==4
replace edu=2 if  c_04==5 | c_04==6
replace edu=3 if c_04==7
recode c22 (4=0) (3=1) (2=2) (1=3) (else=.), gen (religiosity)
recode q1 (1=3) (2=2) (3=1) (4=0)
recode q2_2 (1=3) (2=2) (3=1) (4=0)

*** choice
gen choice_FI_2001=0
replace choice_FI_2001=1 if e20==8
gen choice_AN_2001=0
replace choice_AN_2001=1 if e20==2
gen choice_LN_2001=0
replace choice_LN_2001=1 if e20==11
gen choice_UDC_2001=0
replace choice_UDC_2001=1 if e20==3

**PTV 
recode  q28_6 (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10) (else=.), gen (PTV_FI)
recode  q28_1 (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10) (else=.), gen (PTV_AN)
recode  q28_7 (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10) (else=.), gen (PTV_LN)
recode  q28_10 (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10) (else=.), gen (PTV_UDC)

** knowledge
recode c17 (1=1) (else=0)
recode c18 (1=1) (else=0)
recode c19 (1=1) (else=0)
gen know=c17+c18+c19
recode know (0/1=0) (else=1), gen (know2)

* PID 
gen PID2004_1=0 if q61!=.  /*FI*/
replace PID2004_1=1 if q61==12
gen PID2004_2=0 if q61!=. /*AN*/
replace PID2004_2=1 if q61==14
gen PID2004_3=0 if q61!=. /*LN*/
replace PID2004_3=1 if q61==13
gen PID2004_4=0 if q61!=. /*UDC*/
replace PID2004_4=1 if q61==9
gen PID2001_1=0 if c33!=. /*FI*/
replace PID2001_1=1 if c33==6
gen PID2001_2=0 if c33!=. /*AN*/
replace PID2001_2=1 if c33==2
gen PID2001_3=0 if c33!=. /*LN*/
replace PID2001_3=1 if c33==8
gen PID2001_4=0 if c33!=. /*UDC*/
replace PID2001_4=1 if c33==3 | c33==4

**************************************************************          TABLE S2

gen know_full=0 if c17==0 | c18==0 | c19==0
replace know_full=1 if c17==1 & c18==1 & c19==1

set more off
eststo clear

qui regress PTV_FI c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_FI_2001 q2_2  
eststo: regress PTV_FI c.retro_general##c.know female edu eta_01  religiosity ideo_self_2004  choice_FI_2001 q2_2   if e(sample)
qui regress PTV_AN c.retro_general c.q70_* female edu eta_01  religiosity  ideo_self_2004  choice_AN_2001 q2_2
eststo: regress PTV_AN c.retro_general##c.know female edu eta_01  religiosity ideo_self_2004  choice_AN_2001 q2_2 if e(sample)
qui regress PTV_UDC c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2
eststo: regress PTV_UDC c.retro_general##c.know female edu eta_01  religiosity ideo_self_2004  choice_UDC_2001 q2_2 if e(sample)
qui regress PTV_LN c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2
eststo: regress PTV_LN c.retro_general##c.know female edu eta_01  religiosity ideo_self_2004  choice_LN_2001 q2_2 if e(sample) 

qui regress PTV_FI c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_FI_2001 q2_2  
eststo: regress PTV_FI c.retro_general##c.q2_2 know female edu eta_01  religiosity ideo_self_2004  choice_FI_2001    if e(sample)
qui regress PTV_AN c.retro_general c.q70_* female edu eta_01  religiosity  ideo_self_2004  choice_AN_2001 q2_2
eststo: regress PTV_AN c.retro_general##c.q2_2 know female edu eta_01  religiosity ideo_self_2004  choice_AN_2001  if e(sample)
qui regress PTV_UDC c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2
eststo: regress PTV_UDC c.retro_general##c.q2_2 know female edu eta_01  religiosity ideo_self_2004  choice_UDC_2001  if e(sample)
qui regress PTV_LN c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2
eststo: regress PTV_LN c.retro_general##c.q2_2 know female edu eta_01  religiosity ideo_self_2004  choice_LN_2001  if e(sample) 

esttab, se(%6.3f) starlevels(+ 0.1 * .05 ** .01 *** .001)  scalars ( r2_a bic aic)


*Tests on the effect of partisanship on retrospective evaluations and party support

**************************************************************          TABLE S3
*note that the following commands must follows the models run for TABLE 3!

/*
corr PTV_FI retro_general mean_FI mean_LN mean_AN q70_* q2_2 PID200*_1 choice_FI_2001  if e(sample)
corr PTV_AN retro_general mean_FI mean_LN mean_AN q70_* q2_2 PID200*_2 choice_AN_2001  if e(sample)
corr PTV_UDC retro_general mean_FI mean_LN mean_AN q70_* q2_2 PID200*_4 choice_UDC_2001  if e(sample)
corr PTV_LN retro_general mean_FI mean_LN mean_AN q70_* q2_2 PID200*_3 choice_LN_2001  if e(sample)
*/

**************************************************************          TABLE S4
rename q69_2 q_11_ecozona

egen mean_FI=rowmean(q70_0_criminalita q70_4_war q70_10_infla q_11_ecozona)
egen mean_LN=rowmean(q70_9_unempl q70_2_pensioni q70_3_justice q70_6_labour q70_9_unempl)
egen mean_AN=rowmean(q70_5_TV)

set more off
eststo clear 

qui regress PTV_FI c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004  choice_FI_2001 q2_2
eststo: regress PTV_FI c.retro_general##i.choice_FI_2001 female edu eta_01  religiosity ideo_self_2004  q2_2 if e(sample)
qui regress PTV_AN c.retro_general c.q70_* female edu eta_01  religiosity  ideo_self_2004  choice_AN_2001 q2_2
eststo: regress PTV_AN c.retro_general##i.choice_AN_2001 female edu eta_01  religiosity ideo_self_2004  q2_2 if e(sample)
qui regress PTV_UDC c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2
eststo: regress PTV_UDC c.retro_general##i.choice_UDC_2001 female edu eta_01  religiosity ideo_self_2004   q2_2 if e(sample)
qui regress PTV_LN c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2
eststo: regress PTV_LN c.retro_general##i.choice_LN_2001 female edu eta_01  religiosity ideo_self_2004   q2_2 if e(sample) 

qui regress PTV_FI c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_FI_2001 q2_2
eststo: regress PTV_FI c.mean_FI##i.choice_FI_2001 mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004  q2_2   if e(sample)
qui regress PTV_AN c.retro_general c.q70_* female edu eta_01  religiosity  ideo_self_2004 choice_AN_2001 q2_2
eststo: regress PTV_AN mean_FI mean_LN c.mean_AN##i.choice_AN_2001 q70_7_patente q70_8_immigration female edu eta_01  religiosity  ideo_self_2004  q2_2  if e(sample)
qui regress PTV_UDC c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2
eststo: regress PTV_UDC mean_FI mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2   if e(sample)
qui regress PTV_LN c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2  
eststo: regress PTV_LN mean_FI c.mean_LN##i.choice_LN_2001 mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004  q2_2   if e(sample)

esttab, se(%6.3f) starlevels(+ 0.1 * .05 ** .01 *** .001)  scalars ( r2_a bic aic)

**************************************************************          TABLE S5
set more off
eststo clear 

qui regress PTV_FI c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004  choice_FI_2001 q2_2
eststo: regress PTV_FI c.retro_general##i.PID2001_1 female edu eta_01  religiosity ideo_self_2004  q2_2 if e(sample)
qui regress PTV_AN c.retro_general c.q70_* female edu eta_01  religiosity  ideo_self_2004  choice_AN_2001 q2_2
eststo: regress PTV_AN c.retro_general##i.PID2001_2 female edu eta_01  religiosity ideo_self_2004  q2_2 if e(sample)
qui regress PTV_UDC c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2
eststo: regress PTV_UDC c.retro_general##i.PID2001_4 female edu eta_01  religiosity ideo_self_2004   q2_2 if e(sample)
qui regress PTV_LN c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2
eststo: regress PTV_LN c.retro_general##i.PID2001_3 female edu eta_01  religiosity ideo_self_2004   q2_2 if e(sample) 

qui regress PTV_FI c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_FI_2001 q2_2
eststo: regress PTV_FI c.mean_FI##i.PID2001_1 mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004  q2_2   if e(sample)
qui regress PTV_AN c.retro_general c.q70_* female edu eta_01  religiosity  ideo_self_2004 choice_AN_2001 q2_2
eststo: regress PTV_AN mean_FI mean_LN c.mean_AN##i.PID2001_2 q70_7_patente q70_8_immigration female edu eta_01  religiosity  ideo_self_2004  q2_2  if e(sample)
qui regress PTV_UDC c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2
eststo: regress PTV_UDC mean_FI mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004 PID2001_4 q2_2   if e(sample)
qui regress PTV_LN c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2  
eststo: regress PTV_LN mean_FI c.mean_LN##i.PID2001_3 mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004  q2_2   if e(sample)

esttab, se(%6.3f) starlevels(+ 0.1 * .05 ** .01 *** .001)  scalars ( r2_a bic aic)

**************************************************************          TABLE S6
set more off
eststo clear

eststo: regress PTV_FI c.retro_general##i.PID2004_1 female edu eta_01  religiosity ideo_self_2004 q2_2 
eststo: regress PTV_AN c.retro_general##i.PID2004_2 female edu eta_01  religiosity ideo_self_2004 q2_2 
eststo: regress PTV_LN c.retro_general##i.PID2004_3 female edu eta_01  religiosity ideo_self_2004  q2_2 
eststo: regress PTV_UDC c.retro_general##i.PID2004_4 female edu eta_01  religiosity ideo_self_2004 q2_2 

eststo: regress PTV_FI c.mean_FI##i.PID2004_1 mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004  q2_2  
eststo: regress PTV_AN mean_FI mean_LN c.mean_AN##i.PID2004_2 q70_7_patente q70_8_immigration female edu eta_01  religiosity  ideo_self_2004  q2_2 
eststo: regress PTV_LN mean_FI c.mean_LN##i.PID2004_3 mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004  q2_2 
eststo: regress PTV_UDC mean_FI mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004 PID2004_4 q2_2  

esttab, se(%6.3f) starlevels(+ 0.1 * .05 ** .01 *** .001)  scalars ( r2_a bic aic)

**************************************************************          TABLE S7
tab q57
tab q57, nolab
recode q57 (10=1)  (else=0), gen (vote_FI_Q57)
recode q57 (11=1) (else=0), gen (vote_AN_Q57)
recode q57 (9=1)  (else=0), gen (vote_UDC_Q57)
recode q57 (12=1)  (else=0), gen (vote_LN_Q57)

set more off
eststo clear 

qui logit vote_FI_Q57 c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004  choice_FI_2001 q2_2
eststo: logit vote_FI_Q57 c.retro_general i.choice_FI_2001 female edu eta_01  religiosity ideo_self_2004  q2_2  if e(sample)
qui logit vote_AN_Q57 c.retro_general c.q70_* female edu eta_01  religiosity  ideo_self_2004  choice_AN_2001 q2_2
eststo: logit vote_AN_Q57 c.retro_general i.choice_AN_2001 female edu eta_01  religiosity ideo_self_2004  q2_2  if e(sample)
qui logit vote_UDC_Q57 c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2
eststo: logit vote_UDC_Q57 c.retro_general i.choice_UDC_2001 female edu eta_01  religiosity ideo_self_2004   q2_2  if e(sample)
qui logit vote_LN_Q57 c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2
eststo: logit vote_LN_Q57 c.retro_general i.choice_LN_2001 female edu eta_01  religiosity ideo_self_2004   q2_2  if e(sample)

qui logit vote_FI_Q57 c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_FI_2001 q2_2
eststo: logit vote_FI_Q57 c.mean_FI i.choice_FI_2001 mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004  q2_2    if e(sample)
qui logit vote_AN_Q57 c.retro_general c.q70_* female edu eta_01  religiosity  ideo_self_2004 choice_AN_2001 q2_2  if e(sample)
eststo: logit vote_AN_Q57 mean_FI mean_LN c.mean_AN i.choice_AN_2001 q70_7_patente q70_8_immigration female edu eta_01  religiosity  ideo_self_2004  q2_2   if e(sample)
qui logit vote_UDC_Q57 c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2  if e(sample)
eststo: logit vote_UDC_Q57 mean_FI mean_LN mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2    if e(sample)
qui logit vote_LN_Q57 c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2   if e(sample)
eststo: logit vote_LN_Q57 mean_FI c.mean_LN i.choice_LN_2001 mean_AN q70_7_patente q70_8_immigration female edu eta_01  religiosity ideo_self_2004  q2_2    if e(sample)

esttab, se(%6.3f) starlevels(+ 0.1 * .05 ** .01 *** .001)  scalars ( r2_a bic aic)



**************************************************************          TABLE S1
set more off
eststo clear 

keep if c17==1

qui regress PTV_FI c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_FI_2001 q2_2  
eststo: regress PTV_FI c.retro_general female edu eta_01  religiosity ideo_self_2004  choice_FI_2001 q2_2 if e(sample)
qui regress PTV_AN c.retro_general c.q70_* female edu eta_01  religiosity  ideo_self_2004  choice_AN_2001 q2_2
eststo: regress PTV_AN c.retro_general female edu eta_01  religiosity ideo_self_2004  choice_AN_2001 q2_2 if e(sample)
qui regress PTV_LN c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2
eststo: regress PTV_LN c.retro_general female edu eta_01  religiosity ideo_self_2004  choice_LN_2001 q2_2 if e(sample) 
qui regress PTV_UDC c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004  choice_UDC_2001 q2_2
eststo: regress PTV_UDC c.retro_general female edu eta_01  religiosity ideo_self_2004  choice_UDC_2001 q2_2 if e(sample)

keep if c17==1 & c18==1

qui regress PTV_FI c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_FI_2001 q2_2  
eststo: regress PTV_FI c.retro_general female edu eta_01  religiosity ideo_self_2004  choice_FI_2001 q2_2 if e(sample)
qui regress PTV_AN c.retro_general c.q70_* female edu eta_01  religiosity  ideo_self_2004  choice_AN_2001 q2_2
eststo: regress PTV_AN c.retro_general female edu eta_01  religiosity ideo_self_2004  choice_AN_2001 q2_2 if e(sample)
qui regress PTV_LN c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2
eststo: regress PTV_LN c.retro_general female edu eta_01  religiosity ideo_self_2004  choice_LN_2001 q2_2 if e(sample) 
qui regress PTV_UDC c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004  choice_UDC_2001 q2_2
eststo: regress PTV_UDC c.retro_general female edu eta_01  religiosity ideo_self_2004  choice_UDC_2001 q2_2 if e(sample)

keep if c17==1 & c18==1 & c19==1

qui regress PTV_FI c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_FI_2001 q2_2  
eststo: regress PTV_FI c.retro_general female edu eta_01  religiosity ideo_self_2004  choice_FI_2001 q2_2   if e(sample)
qui regress PTV_AN c.retro_general c.q70_* female edu eta_01  religiosity  ideo_self_2004  choice_AN_2001 q2_2
eststo: regress PTV_AN c.retro_general female edu eta_01  religiosity ideo_self_2004  choice_AN_2001 q2_2 if e(sample)
qui regress PTV_UDC c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_UDC_2001 q2_2
eststo: regress PTV_UDC c.retro_general female edu eta_01  religiosity ideo_self_2004  choice_UDC_2001 q2_2 if e(sample)
qui regress PTV_LN c.retro_general c.q70_* female edu eta_01  religiosity ideo_self_2004 choice_LN_2001 q2_2
eststo: regress PTV_LN c.retro_general female edu eta_01  religiosity ideo_self_2004  choice_LN_2001 q2_2 if e(sample) 

esttab, se(%6.3f) starlevels(+ 0.1 * .05 ** .01 *** .001)  scalars ( r2_a bic aic)





