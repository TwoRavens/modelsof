** Replication Analysis for Chapter 4 ** 
** WBL Polarization Data (Experiment 1) ** 
** Sept 2012 ** 

** Read in the data ** 
use exp1_replication.dta, clear  

**********************************
** Models of Attitudinal Change ** 
**********************************

** Change Score Analysis (See Table A4.1)  
gen rs_score = rs_post_pos - rs_pre_pos 
xtreg rs_score i.treatment i.year, vce(r)  
outreg2 using change_score.doc, se noaster bdec(2,2,2,2,2,2,2)
xtreg rs_score i.treatment i.year pid male student white age, vce(r) 
outreg2 using change_score.doc, se noaster bdec(2,2,2,2,2,2,2,2,2,2,2,2) append
xtreg rs_score i.treatment##hi_strength i.year, vce(r) 
outreg2 using change_score.doc, se noaster bdec(2,2,2,2,2,2,2,2,2,2) append
xtreg rs_score i.treatment##hi_strength i.year pid male student white age, vce(r) 
outreg2 using change_score.doc, se noaster bdec(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2) append


** Who becomes more extreme? 
gen more_extreme =0 
replace more_extreme = 1 if post_pos > pre_pos 
mean more_extreme, over(treatment) 
** LM: 33% more extreme, 23% in control (22% in cc) 
** Persuasion Rate (DV-Kaplan, Fox News Effect): 
display(100*(.33-.23)*(1/(1-.23))) 
** 13 percent persuasion rate 

***********************
** Robustness Checks **
***********************

** Break out by pre-test agreement w/ your party (diff. sorting vs. polarization) ** 
xtreg rs_score i.treatment i.year if pre_pos > 3, vce(r) /* in-step */ 
xtreg rs_score i.treatmen i.year if pre_pos < 4, vce(r) /* out-of-step */ 
** no real difference

** Is the attitude strength result driven by strong attitude folks being better informed etc.? ** 
** Strategy: interact treatmetn w/ both attitude strength & indicator for correctly perceiving slant of treatment ** 
** If attitude strength is just picking up general awareness/political "smarts," then effect should go away when you interact treatment w/ correct perception ** 
xtreg rs_score i.treatment##hi_strength i.treatment##correct_perception i.year, vce(r) 
** result survives ** 
