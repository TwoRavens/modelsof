

********************************************************
********************************************************
** This file provides the analysis for the 			  **
** "Elections and Uncertain Decisions in Politics: 	  **
** A Survey Experiment with U.S. Municipal Officials" **
** Author: Daniel M. Butler							  **
********************************************************
********************************************************

clear
set more off

** Change the directory below to match the location of the dataset
cd 

**************
** Get Data **
**************

use "Elections_Uncertainty.dta"

****************
**  Table A1  **
****************		
	tab sq_vignette_comp positive_expec if vote_yes!=. & learn_soon==1
	tab sq_vignette_comp positive_expec if vote_yes!=. & learn_soon==0

***********************************
** Regression Tables in Appendix **
***********************************

** Table A2 + Prep work for Figure 2
	reg vote_yes lose_race win_race if learn_soon==1 & positive_expec==0
		outreg2 using "Main_results", dec(3) word ctitle("EV=Neg, OLS") label se replace
		regsave lose_race win_race using reg_results.dta, ci addlabel(group, 1, positive_EV, no) replace 
	probit vote_yes lose_race win_race if learn_soon==1 & positive_expec==0
		outreg2 using "Main_results", dec(3) word ctitle("EV=Neg, Probit") label se append
	reg vote_yes lose_race win_race if learn_soon==1 & positive_expec==1
		outreg2 using "Main_results", dec(3) word ctitle("EV=Pos, OLS") label se append	
		regsave lose_race win_race using reg_results.dta, ci addlabel(group, 5, positive_EV, yes) append 
	probit vote_yes lose_race win_race if learn_soon==1 & positive_expec==1
		outreg2 using "Main_results", dec(3) word ctitle("EV=Pos, Probit") label se append	
	
** Table A3 + Prep work for Figure 3
	reg vote_yes win_big win_small lose_big lose_small if learn_soon==1 & positive_expec==0
		outreg2 using "Individual_Treatments", dec(3) word ctitle("EV=Neg, OLS") label se replace	
		regsave win_big win_small lose_big lose_small using reg_results_individual.dta, ci addlabel(group, 1, positive_EV, no) replace 
	probit vote_yes win_big win_small lose_big lose_small if learn_soon==1 & positive_expec==0
		outreg2 using "Individual_Treatments", dec(3) word ctitle("EV=Neg, Probit") label se append		
	reg vote_yes win_big win_small lose_big lose_small if learn_soon==1 & positive_expec==1
		outreg2 using "Individual_Treatments", dec(3) word ctitle("EV=Pos, OLS") label se append	
		regsave win_big win_small lose_big lose_small using reg_results_individual.dta, ci addlabel(group,7, positive_EV, yes) append 
	probit vote_yes win_big win_small lose_big lose_small if learn_soon==1 & positive_expec==1
		outreg2 using "Individual_Treatments", dec(3) word ctitle("EV=Pos, Probit") label se append	

** Table A4 + Prep work for Figure 4. Time Horizon
	label var learn_soon "Learn outcome before election"
	** Negative Expected Value
	reg vote_yes learn_soon  if sq_vignette_c==5 & positive_ex==0
		outreg2 using "Varying_Timing_Neg", dec(3) word ctitle("Lose Close Race, OLS") label se replace	
		regsave learn_soon using varying_time_results.dta, ci addlabel(group, 1, positive_EV, no, Election, lose) replace 
	probit vote_yes learn_soon  if sq_vignette_c==5 & positive_ex==0
		outreg2 using "Varying_Timing_Neg", dec(3) word ctitle("Lose Close Race, Probit") label se append	
	reg vote_yes learn_soon  if sq_vignette_c==1 & positive_ex==0
		outreg2 using "Varying_Timing_Neg", dec(3) word ctitle("Retire, OLS") label se append
		regsave learn_soon using varying_time_results.dta, ci addlabel(group, 2, positive_EV, no, Election, retire) append 
	probit vote_yes learn_soon  if sq_vignette_c==1 & positive_ex==0
		outreg2 using "Varying_Timing_Neg", dec(3) word ctitle("Retire, Probit") label se append

	** Positive Expected Value
	reg vote_yes learn_soon  if sq_vignette_c==3 & positive_ex==1
		outreg2 using "Varying_Timing_Pos", dec(3) word ctitle("Win Close Race, OLS") label se replace
		regsave learn_soon using varying_time_results.dta, ci addlabel(group, 4, positive_EV, yes, Election, win) append 
	probit vote_yes learn_soon  if sq_vignette_c==3 & positive_ex==1
		outreg2 using "Varying_Timing_Pos", dec(3) word ctitle("Win Close Race, Probit") label se append
	reg vote_yes learn_soon  if sq_vignette_c==1 & positive_ex==1
		outreg2 using "Varying_Timing_Pos", dec(3) word ctitle("Retire, OLS") label se append
		regsave learn_soon using varying_time_results.dta, ci addlabel(group, 5, positive_EV, yes, Election, retire) append 
	probit vote_yes learn_soon  if sq_vignette_c==1 & positive_ex==1
		outreg2 using "Varying_Timing_Pos", dec(3) word ctitle("Retire, Probit") label se append

**************
** Appendix **
**************

	** Table A5 + Prep work for Figure A3: Pooled Results
	reg vote_yes lose_race win_race if learn_soon==1 
		outreg2 using "Pooled", dec(3) word ctitle("Pooled, OLS") label se replace
		regsave lose_race win_race using pooled.dta, ci addlabel(group, 1) replace 
	probit vote_yes lose_race win_race if learn_soon==1 
		outreg2 using "Pooled", dec(3) word ctitle("Pooled, OLS") label se append

	** Table A8. Heterogenous Effect by Position (Mayor v. Councilor)
	reg vote_yes lose_race##mayor win_race##mayor if learn_soon==1 & positive_expec==0
		outreg2 using "Mayor_results", dec(3) word ctitle("EV=Neg, OLS") label se replace
	probit vote_yes lose_race##mayor win_race##mayor if learn_soon==1 & positive_expec==0
		outreg2 using "Mayor_results", dec(3) word ctitle("EV=Neg, Probit") label se append
	reg vote_yes lose_race##mayor win_race##mayor if learn_soon==1 & positive_expec==1
		outreg2 using "Mayor_results", dec(3) word ctitle("EV=Pos, OLS") label se append	
	probit vote_yes lose_race##mayor win_race##mayor if learn_soon==1 & positive_expec==1
		outreg2 using "Mayor_results", dec(3) word ctitle("EV=Pos, Probit") label se append	
	
	** Attrition 
		** Number who started the survey
		count if ti_intro_4!=.
	
		** Number who saw the SQ Bias question
		gen saw_SQ_question=1 if ti_sqbias_4!=. | sq_bias!=.

		reg vote_yes lose_race win_race 	
		gen in_sample=e(sample)==1
	
		tab in_sample if saw_SQ_question==1
		reg in_sample learn_soon positive_expec i.sq_vignette_comp if saw_SQ_question==1

	** Table A6. Randomization Check
	gen rand_check=lose_race if in_sample==1
		replace rand_check=2 if win_race==1
	gen female=gender==2
	replace educ=2 if educ==1
	gen republican=party==1
	gen democrat=party==2
	rename libcon conservatism
	xi: mprobit rand_check mayor female i.educ republican democrat i.conservatism  if learn_soon==1
		outreg2 using "Randomization_check", dec(3) word ctitle("EV=Neg, Probit") label se append

	** Table A7. Results when controlling for partisanship
	reg vote_yes lose_race win_race republican democrat if learn_soon==1 & positive_expec==0
		outreg2 using "Control_partisanship", dec(3) word ctitle("EV=Neg, OLS") label se replace
	probit vote_yes lose_race win_race republican democrat if learn_soon==1 & positive_expec==0
		outreg2 using "Control_partisanship", dec(3) word ctitle("EV=Neg, Probit") label se append
	reg vote_yes lose_race win_race republican democrat if learn_soon==1 & positive_expec==1
		outreg2 using "Control_partisanship", dec(3) word ctitle("EV=Pos, OLS") label se append	
	probit vote_yes lose_race win_race republican democrat if learn_soon==1 & positive_expec==1
		outreg2 using "Control_partisanship", dec(3) word ctitle("EV=Pos, Probit") label se append	

	** Table A9. Weighted Results
	xi: probit in_sample i.state census2010pop 
		outreg2 using "Selection_model", dec(3) word ctitle("Probit") label se replace
		predict fitprob
	gen iprob= 1/fitprob
	
	reg vote_yes lose_race win_race if learn_soon==1 & positive_expec==0 [pweight=iprob]
		outreg2 using "Weighted_results", dec(3) word ctitle("EV=Neg, OLS") label se replace
	probit vote_yes lose_race win_race if learn_soon==1 & positive_expec==0 [pweight=iprob]
		outreg2 using "Weighted_results", dec(3) word ctitle("EV=Neg, Probit") label se append
	reg vote_yes lose_race win_race if learn_soon==1 & positive_expec==1 [pweight=iprob]
		outreg2 using "Weighted_results", dec(3) word ctitle("EV=Pos, OLS") label se append	
	probit vote_yes lose_race win_race if learn_soon==1 & positive_expec==1 [pweight=iprob]
		outreg2 using "Weighted_results", dec(3) word ctitle("EV=Pos, Probit") label se append	
	
	

***************************************************	
***************************************************
***********   CREATE FIGURES in Paper   ***********
***************************************************
***************************************************
	
** Figure 2.

use "reg_results.dta", clear
expand 2
bysort var positive_EV: gen aa=_n
gen ci_graph=ci_lower if aa==1 
	replace ci_graph=ci_upper if aa==2 
replace group=group+1 if var=="win_race"
set obs 10
	replace group=3 if _n==9
	replace group=7 if _n==10
	replace coef=0 if _n>=9
		
#delimit;
	twoway (line group ci_graph if group==6, lcolor(black)) 
		(line group ci_graph if group==5, lcolor(black)) 
		(line group ci_graph if group==2, lcolor(black)) 
		(line group ci_graph if group==1, lcolor(black)) 
		(scatter group coef if group!=3 & group!=7, mcolor(black) msize(medsmall))
		(scatter group coef if group==3 | group==7, mcolor(black) msize(medsmall) msymbol(circle_hollow))
		, 
		text(8 .05 `"Positive Expected Value (65% Chance of Savings)"')  
		text(4 .05 `"Negative Expected Value (35% Chance of Savings)"') 
		xline(0, lcolor(gs7) lpattern(dot))
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) legend(off)
		ysc(r(8)) ylabel(none, nogrid) ytitle("") 
		ylabel(1 "Expect to Lose Race" 2 "Expect to Win Race" 3 "Retiring" 5 "Expect to Lose Race" 6 "Expect to Win Race" 7 "Retiring",nogrid angle(horizontal)) 
		xtitle("Difference in Propotion of Officials who Expect Mayor" "to Implement Proposal with Uncertain Outcome" "(Treatment Condition - Retirement Condition)") ;
#delimit cr;		
		graph export "Main Results.png", height(1600) replace

	

** Figure 3. Individual treatments	
	
use "reg_results_individual.dta", clear
expand 2
bysort var positive_EV: gen aa=_n
gen ci_graph=ci_lower if aa==1 
	replace ci_graph=ci_upper if aa==2 
replace group=group+1 if var=="lose_small"
replace group=group+2 if var=="win_big"
replace group=group+3 if var=="win_small"
set obs 18
	replace group=5 if _n==17
	replace group=11 if _n==18
	replace coef=0 if _n>=17
		
#delimit;
	twoway (line group ci_graph if group==10, lcolor(black)) 
		(line group ci_graph if group==9, lcolor(black)) 
		(line group ci_graph if group==8, lcolor(black)) 
		(line group ci_graph if group==7, lcolor(black)) 
		(line group ci_graph if group==4, lcolor(black)) 
		(line group ci_graph if group==3, lcolor(black)) 
		(line group ci_graph if group==2, lcolor(black)) 
		(line group ci_graph if group==1, lcolor(black)) 
		(scatter group coef if group!=5 & group!=11, mcolor(black) msize(medsmall))
		(scatter group coef if group==5 | group==11, mcolor(black) msize(medsmall) msymbol(circle_hollow))
		, 
		text(12 .05 `"Positive Expected Value (65% Chance of Savings)"') 
		text(6 .05 `"Negative Expected Value (35% Chance of Savings)"') 
		xline(0, lcolor(gs7) lpattern(dot))
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) legend(off)
		ysc(r(12)) ylabel(none, nogrid) ytitle("") 
		ylabel(1 "Lose in Blowout" 2 "Lose Close Race" 3 "Win in Blowout" 4 "Win Close Race" 5 "Retiring" 7 "Lose in Blowout" 8 "Lose Close Race" 9 "Win in Blowout" 10 "Win Close Race" 11 "Retiring",nogrid angle(horizontal)) 
		xtitle("Difference in Propotion of Officials who Expect Mayor" "to Implement Proposal with Uncertain Outcome" "(Treatment Condition - Retirement Condition)") ;
#delimit cr;		
		graph export "Individual Treatments.png", height(1600) replace

		
	

** Figure 4. Varying Time of Learning

use "varying_time_results.dta", clear
expand 2
bysort var group: gen aa=_n
gen ci_graph=ci_lower if aa==1 
	replace ci_graph=ci_upper if aa==2 
	
#delimit;
	twoway (line group ci_graph if group==5, lcolor(black)) 
		(line group ci_graph if group==4, lcolor(black)) 
		(line group ci_graph if group==2, lcolor(black)) 
		(line group ci_graph if group==1, lcolor(black)) 
		(scatter group coef , mcolor(black) msize(medsmall))
		, 
		text(5.75 .05 `"Positive Expected Value (65% Chance of Savings)"') 
		text(2.75 .05 `"Negative Expected Value (35% Chance of Savings)"') 
		xline(0, lcolor(gs7) lpattern(dot))
		ylabel(1 "Lose Close Race" 2 "Retiring" 4 "Win Close Race" 5 "Retiring",nogrid angle(horizontal)) 
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) legend(off)
		ysc(r(6)) ytitle("") 
		xlabel(,nogrid)
		xtitle("Difference in Propotion of Officials who Expect Mayor" "to Implement Proposal with Uncertain Outcome" "(Learned Before Election Condition - Learn After Election Condition)") ;
#delimit cr;		
		graph export "Varying Learning Time.png", height(1600) replace

	

************************
** Figure in Appendix **
************************
	
** Create Figure A3. Varying Time of Learning
use "Pooled.dta", clear
	expand 2
bysort var group: gen aa=_n
gen ci_graph=ci_lower if aa==1 
	replace ci_graph=ci_upper if aa==2 
replace group=group+1 if var=="win_race"
	set obs 5
	replace group=3 if _n==5
	replace coef=0 if _n>=5
	
#delimit;
	twoway (line group ci_graph if group==2, lcolor(black)) 
		(line group ci_graph if group==1, lcolor(black)) 
		(scatter group coef if group!=3, mcolor(black) msize(medsmall))
		(scatter group coef if group==3,  mcolor(black) msize(medsmall) msymbol(circle_hollow))
		, 
		xline(0, lcolor(gs7) lpattern(dot))
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) legend(off)
		ysc(r(3)) ylabel(none, nogrid) ytitle("") 
		ylabel(1 "Expect to Lose Race" 2 "Expect to Win Race" 3 "Retiring" ,nogrid angle(horizontal)) 
		xtitle("Difference in Propotion of Officials who Expect Mayor" "to Implement Proposal with Uncertain Outcome" "(Treatment Condition - Retirement Condition)") ;
#delimit cr;		
	graph export "Pooled.png", height(1600) replace
	
	
