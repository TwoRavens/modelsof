*** Supplemental material for 
*** "It sounds like they’re moving: understanding and modelling emphasis-based policy change"
*** Thomas M. Meyer & Markus Wagner, University of Vienna

*** Data analysis

*** Note: file requires eclplots (by Roger Newson)

set more off

log using "log_analysis.smcl", replace

* load data
use data_sounds_like_moving.dta, clear

*******************************************************************************
*** Magnitude of party policy shifts (Table 1)
*******************************************************************************

regress abs_pure_polchange ///
	  i.leadercentred_d    ///
	  c.abs_pure_polchange_lag ///
	  c.votechange_lag ///	  
	  i.country ,cluster(party)		  
est sto model1 

regress abs_pure_salchange ///
	  i.leadercentred_d    ///
	  c.abs_pure_salchange_lag  ///
	  c.votechange_lag ///	  
	  i.country ,cluster(party)		  
est sto model2 

esttab model1 model2    using "Table_1.rtf", replace label    ///
						star(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
						mtitles("Opinion-based policy change (abs)" "Emphasis-based policy change (abs)") ///
						scalar(ll) nogaps 



*******************************************************************************
*** Explaining why and how parties adapt their positions to rival parties (Table 2)
*******************************************************************************
regress pure_polchange ///
	  c.systemic_shift_ln##i.leadercentred_d    ///
	  c.dmvpt    ///	  
	  c.pure_polchange_lag##c.votechange_lag ///	  
	  c.unemp_change ///
	  i.country ,cluster(party)		  
est sto model1

regress pure_salchange ///
	  c.systemic_shift_ln##i.leadercentred_d    ///
	  c.dmvpt    ///	  
	  c.pure_salchange_lag##c.votechange_lag ///	  
	  c.unemp_change  ///
	  i.country , cluster(party)
est sto model2

esttab model1  model2  using "Table_2.rtf", replace label    ///
						star(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
						mtitles("Opinion-based policy change" "Emphasis-based policy change") ///
						scalar(ll) nogaps 



*****************************************************************************
*** ME plots (Figure 2)
*****************************************************************************

* Model 1				
gen x=_n in 1/2

gen effect=.
gen upper=.
gen lower=.

est restore model1	  
margins, dydx(systemic_shift_ln) at((mean) _continuous (base) _factor leadercentred_d=(0 1))

matrix b=r(b)
matrix V=r(V)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==1
replace upper=b[1,1] + 1.96*sqrt(V[1,1]) if x==1
replace lower=b[1,1] - 1.96*sqrt(V[1,1]) if x==1

replace effect=b[1,2] 					  if x==2
replace upper=b[1,2] + 1.96*sqrt(V[2,2]) if x==2
replace lower=b[1,2] - 1.96*sqrt(V[2,2]) if x==2

label define Hyp   1 "Activist-dominated party"  2 "Leader-dominated party"  
			
label values x  Hyp
sort x
eclplot effect lower upper x in 1/2, ///
	rplottype(rspike) ///
	estopts(msymbol(circle) mcolor(black)) ///
	ciopts(lcolor(black))	///
	legend(off) ///
	graphregion(color(white)) ///
	yscale(range(0.8 2.2)) ///
	xscale(range(-0.01 0.03)) ///
    ylabel(1 2, valuelabel labsize(small) notick nogrid) ///
	xlabel(-0.50(0.1)0.5, labsize(small) ) ///
	title("DV: Opinion-based policy change (Model 1)",color(black)) ///
	ytitle("") ///
	xtitle("Marginal effect",size(small)) ///
	ysize(2) ///
	xsize(4) ///
	xline(0, lcolor(black)) ///
	horizontal 
	
graph export fig2a.tif, replace  width(4800) 

drop x effect upper lower 
matrix drop _all
label drop Hyp						


* Model 2				
gen x=_n in 1/2

gen effect=.
gen upper=.
gen lower=.

est restore model2  
margins, dydx(systemic_shift_ln) at((mean) _continuous (base) _factor leadercentred_d=(0 1))

matrix b=r(b)
matrix V=r(V)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==1
replace upper=b[1,1] + 1.96*sqrt(V[1,1]) if x==1
replace lower=b[1,1] - 1.96*sqrt(V[1,1]) if x==1

replace effect=b[1,2] 					  if x==2
replace upper=b[1,2] + 1.96*sqrt(V[2,2]) if x==2
replace lower=b[1,2] - 1.96*sqrt(V[2,2]) if x==2

label define Hyp   1 "Activist-dominated party"  2 "Leader-dominated party"  
			
label values x  Hyp
sort x
eclplot effect lower upper x in 1/2, ///
	rplottype(rspike) ///
	estopts(msymbol(circle) mcolor(black)) ///
	ciopts(lcolor(black))	///
	legend(off) ///
	graphregion(color(white)) ///
	yscale(range(0.8 2.2)) ///
	xscale(range(-2 2)) ///
    ylabel(1 2, valuelabel labsize(small) notick nogrid) ///
	xlabel(-2.5(0.5)2.5, labsize(small) ) ///
	title("DV: Emphasis-based policy change (Model 2)",color(black)) ///
	ytitle("") ///
	xtitle("Marginal effect",size(small)) ///
	ysize(2) ///
	xsize(4) ///
	xline(0, lcolor(black)) ///
	horizontal 
	
graph export fig2b.tif, replace  width(4800) 

drop x effect upper lower 
matrix drop _all
label drop Hyp			





*****************************************************************************
*** Appendix B: Sample & Descriptives
*****************************************************************************

* Tablbe B.2
preserve
bysort country: gen no_shifts=_N
gen year=floor(date/100)
bysort country: egen min_date=min(year)
bysort country: egen max_date=max(year)
bysort party: gen p_id=1 if _n==1
bysort country: egen p_count=total(p_id)

keep country min_date max_date no_shifts  p_count
collapse  min_date max_date no_shifts p_count, by(country)
list country min_date max_date p_count no_shifts  
restore


*Table B.3
sum   pure_polchange pure_polchange_lag pure_salchange pure_salchange_lag ///
      abs_pure_polchange abs_pure_polchange_lag ///
	  abs_pure_salchange abs_pure_salchange_lag ///
	  systemic_shift_ln dmvpt votechange_lag unemp_change 	
tab leadercentred_d	





*****************************************************************************
*** Appendix C: Alternative economic indicators
*****************************************************************************
regress pure_polchange ///
	  c.systemic_shift_ln##i.leadercentred_d    ///
	  c.dmvpt    ///	  
	  c.pure_polchange_lag##c.votechange_lag ///	  
	  c.oecd_mean_growth  ///
	  i.country,cluster(party)		  
est sto model1_growth 

regress pure_salchange ///
	  c.systemic_shift_ln##i.leadercentred_d    ///
	  c.dmvpt    ///	  
	  c.pure_salchange_lag##c.votechange_lag ///	  
	  c.oecd_mean_growth  ///
	  i.country, cluster(party)
est sto model2_growth 

esttab model1_growth  model2_growth  using "Appendix_C_1.rtf", replace label    ///
						star(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
						mtitles("Opinion-based policy change" "Emphasis-based policy change") ///
						scalar(ll) nogaps



* OLS with cluster, lagged DV (Abou-Chadi et al.)
regress pure_polchange ///
	  c.systemic_shift_ln##i.leadercentred_d    ///
	  c.dmvpt    ///	  
	  c.pure_polchange_lag##c.votechange_lag ///	  
	  c.wb_infl_conprice  ///
	  i.country,cluster(party)		  
est sto model1_infl

regress pure_salchange ///
	  c.systemic_shift_ln##i.leadercentred_d    ///
	  c.dmvpt    ///	  
	  c.pure_salchange_lag##c.votechange_lag ///	  
	  c.wb_infl_conprice  ///
	  i.country, cluster(party)
est sto model2_infl

esttab  model1_infl  model2_infl  using "Appendix_C_2.rtf", replace label    ///
						star(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
						mtitles("Opinion-based policy change" "Emphasis-based policy change") ///
						scalar(ll) nogaps


*****************************************************************************
*** Appendix D: Alternative model specifications
*****************************************************************************
	
*** SE clustered by election
regress abs_pure_polchange ///
	  i.leadercentred_d    ///
	  c.abs_pure_polchange_lag ///
	  c.votechange_lag ///	  
	  i.country, cluster(elec_group) 
est sto model1_elec

regress abs_pure_salchange ///
	  i.leadercentred_d    ///
	  c.abs_pure_salchange_lag  ///
	  c.votechange_lag ///	  
	  i.country, cluster(elec_group) 
est sto model2_elec

esttab model1_elec  model2_elec    using "Appendix_D_1.rtf", replace label    ///
						star(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
						mtitles("Opinion-based policy change" "Emphasis-based policy change") ///
						scalar(ll) nogaps 
	

regress pure_polchange ///
	  c.systemic_shift_ln##i.leadercentred_d    ///
	  c.dmvp    ///	  
	  c.pure_polchange_lag##c.votechange_lag ///	  
	  c.unemp_change ///
	  i.country, cluster(elec_group)		  
est sto model1_elec 

regress pure_salchange ///
	  c.systemic_shift_ln##i.leadercentred_d    ///
	  c.dmvpt    ///	  
	  c.pure_salchange_lag##c.votechange_lag ///	  
	  c.unemp_change ///
	  i.country, cluster(elec_group)
est sto model2_elec


esttab  model1_elec  model2_elec   using "Appendix_D_2.rtf", replace label    ///
						star(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
						mtitles("Opinion-based policy change" "Emphasis-based policy change") ///
						scalar(ll) nogaps 



*  ME plots

* Model 1					
gen x=_n in 1/2

gen effect=.
gen upper=.
gen lower=.

est restore model1_elec	  
margins, dydx(systemic_shift_ln) at((mean) _continuous (base) _factor leadercentred_d=(0 1))

matrix b=r(b)
matrix V=r(V)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==1
replace upper=b[1,1] + 1.96*sqrt(V[1,1]) if x==1
replace lower=b[1,1] - 1.96*sqrt(V[1,1]) if x==1

replace effect=b[1,2] 					  if x==2
replace upper=b[1,2] + 1.96*sqrt(V[2,2]) if x==2
replace lower=b[1,2] - 1.96*sqrt(V[2,2]) if x==2

label define Hyp   1 "Activist-dominated party"  2 "Leader-dominated party"  
			
label values x  Hyp
sort x
eclplot effect lower upper x in 1/2, ///
	rplottype(rspike) ///
	estopts(msymbol(circle) mcolor(black)) ///
	ciopts(lcolor(black))	///
	legend(off) ///
	graphregion(color(white)) ///
	yscale(range(0.8 2.2)) ///
	xscale(range(-0.01 0.03)) ///
    ylabel(1 2, valuelabel labsize(small) notick nogrid) ///
	xlabel(-0.50(0.1)0.5, labsize(small) ) ///
	title("DV: Opinion-based policy change (Model 1)",color(black)) ///
	ytitle("") ///
	xtitle("Marginal effect",size(small)) ///
	ysize(2) ///
	xsize(4) ///
	xline(0, lcolor(black)) ///
	horizontal 
	
graph export figD1a.tif, replace  width(2400) 

drop x effect upper lower 
matrix drop _all
label drop Hyp						


* Model 2				
gen x=_n in 1/2

gen effect=.
gen upper=.
gen lower=.

est restore model2_elec	  
margins, dydx(systemic_shift_ln) at((mean) _continuous (base) _factor leadercentred_d=(0 1))

matrix b=r(b)
matrix V=r(V)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==1
replace upper=b[1,1] + 1.96*sqrt(V[1,1]) if x==1
replace lower=b[1,1] - 1.96*sqrt(V[1,1]) if x==1

replace effect=b[1,2] 					  if x==2
replace upper=b[1,2] + 1.96*sqrt(V[2,2]) if x==2
replace lower=b[1,2] - 1.96*sqrt(V[2,2]) if x==2

label define Hyp   1 "Activist-dominated party"  2 "Leader-dominated party"  
			
label values x  Hyp
sort x
eclplot effect lower upper x in 1/2, ///
	rplottype(rspike) ///
	estopts(msymbol(circle) mcolor(black)) ///
	ciopts(lcolor(black))	///
	legend(off) ///
	graphregion(color(white)) ///
	yscale(range(0.8 2.2)) ///
	xscale(range(-2.5 2.5)) ///
    ylabel(1 2, valuelabel labsize(small) notick nogrid) ///
	xlabel(-2.5(0.5)2.5, labsize(small) ) ///
	title("DV: Emphasis-based policy change (Model 2)",color(black)) ///
	ytitle("") ///
	xtitle("Marginal effect",size(small)) ///
	ysize(2) ///
	xsize(4) ///
	xline(0, lcolor(black)) ///
	horizontal 
	
graph export figD1b.tif, replace  width(2400) 

drop x effect upper lower 
matrix drop _all
label drop Hyp						
		




*** Panel-corrected standard errors

* xtset data
xtset party edate


*** similar to Schumacher
xtgls abs_pure_polchange ///
	  i.leadercentred_d    ///
	  c.abs_pure_polchange_lag ///
	  c.votechange_lag ///	  
	  i.country , panels(h) force  		  		  
est sto model1_pcse

xtgls abs_pure_salchange ///
	  i.leadercentred_d    ///
	  c.abs_pure_salchange_lag  ///
	  c.votechange_lag ///	  
	  i.country, panels(h) force  		  		  
est sto model2_pcse

esttab model1_pcse model2_pcse    using "Appendix_D_3.rtf", replace label    ///
						star(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
						mtitles("Opinion-based policy change" "Emphasis-based policy change") ///
						nogaps


	
xtgls pure_polchange ///
	  c.systemic_shift_ln##i.leadercentred_d    ///
	  c.dmvpt    ///	  
	  c.pure_polchange_lag##c.votechange_lag ///	
	  c.unemp_change ///
	  i.country , panels(h) force  		  
est sto model1_pcse

xtgls pure_salchange ///
	  c.systemic_shift_ln##i.leadercentred_d    ///
	  c.dmvpt    ///	  
	  c.pure_salchange_lag##c.votechange_lag ///	  
	  c.unemp_change ///
	  i.country, panels(h) force
est sto model2_pcse  
	

esttab model1_pcse  model2_pcse  using "Appendix_D_4.rtf", replace label    ///
						star(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
						mtitles("Opinion-based policy change" "Emphasis-based policy change") ///
						nogaps



***  ME plots 

* Model 1					
gen x=_n in 1/2

gen effect=.
gen upper=.
gen lower=.

est restore model1_pcse	  
margins, dydx(systemic_shift_ln) at((mean) _continuous (base) _factor leadercentred_d=(0 1))

matrix b=r(b)
matrix V=r(V)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==1
replace upper=b[1,1] + 1.96*sqrt(V[1,1]) if x==1
replace lower=b[1,1] - 1.96*sqrt(V[1,1]) if x==1

replace effect=b[1,2] 					  if x==2
replace upper=b[1,2] + 1.96*sqrt(V[2,2]) if x==2
replace lower=b[1,2] - 1.96*sqrt(V[2,2]) if x==2

label define Hyp   1 "Activist-dominated party"  2 "Leader-dominated party"  
			
label values x  Hyp
sort x
eclplot effect lower upper x in 1/2, ///
	rplottype(rspike) ///
	estopts(msymbol(circle) mcolor(black)) ///
	ciopts(lcolor(black))	///
	legend(off) ///
	graphregion(color(white)) ///
	yscale(range(0.8 2.2)) ///
	xscale(range(-0.01 0.03)) ///
	xlabel(-0.50(0.1)0.5, labsize(small) ) ///
    ylabel(1 2, valuelabel labsize(small) notick nogrid) ///
	title("DV: Opinion-based policy change (Model 1)",color(black)) ///
	ytitle("") ///
	xtitle("Marginal effect",size(small)) ///
	ysize(2) ///
	xsize(4) ///
	xline(0, lcolor(black)) ///
	horizontal 
	
graph export figD2a.tif, replace  width(2400) 

drop x effect upper lower 
matrix drop _all
label drop Hyp						


* Model 2				
gen x=_n in 1/2

gen effect=.
gen upper=.
gen lower=.

est restore model2_pcse	  
margins, dydx(systemic_shift_ln) at((mean) _continuous (base) _factor leadercentred_d=(0 1))

matrix b=r(b)
matrix V=r(V)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==1
replace upper=b[1,1] + 1.96*sqrt(V[1,1]) if x==1
replace lower=b[1,1] - 1.96*sqrt(V[1,1]) if x==1

replace effect=b[1,2] 					  if x==2
replace upper=b[1,2] + 1.96*sqrt(V[2,2]) if x==2
replace lower=b[1,2] - 1.96*sqrt(V[2,2]) if x==2

label define Hyp   1 "Activist-dominated party"  2 "Leader-dominated party"  
			
label values x  Hyp
sort x
eclplot effect lower upper x in 1/2, ///
	rplottype(rspike) ///
	estopts(msymbol(circle) mcolor(black)) ///
	ciopts(lcolor(black))	///
	legend(off) ///
	graphregion(color(white)) ///
	yscale(range(0.8 2.2)) ///
	xscale(range(-2.5 2.5)) ///
    ylabel(1 2, valuelabel labsize(small) notick nogrid) ///
	xlabel(-2.5(0.5)2.5, labsize(small) ) ///
	title("DV: Emphasis-based policy change (Model 2)",color(black)) ///
	ytitle("") ///
	xtitle("Marginal effect",size(small)) ///
	ysize(2) ///
	xsize(4) ///
	xline(0, lcolor(black)) ///
	horizontal 
	
graph export figD2b.tif, replace  width(2400) 

drop x effect upper lower 
matrix drop _all
label drop Hyp			
	

	
*****************************************************************************
*** Appendix E: Controlling for lagged party system policy change
*****************************************************************************

regress pure_polchange ///
	  c.systemic_shift_ln_lag##i.leadercentred_d    ///
	  c.systemic_shift_ln##i.leadercentred_d    ///
	  c.dmvpt    ///	  
	  c.pure_polchange_lag##c.votechange_lag ///	 
 	  c.unemp_change ///
	  i.country ,cluster(party)		  
est sto model1_lag

regress pure_salchange ///
	  c.systemic_shift_ln_lag##i.leadercentred_d    ///
	  c.systemic_shift_ln##i.leadercentred_d    ///
	  c.dmvpt    ///	  
	  c.pure_salchange_lag##c.votechange_lag ///	  
	  c.unemp_change ///
	  i.country , cluster(party)
est sto model2_lag

esttab  model1_lag  model2_lag  using "Appendix_E_1.rtf", replace label    ///
						star(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
						mtitles("Opinion-based policy change" "Emphasis-based policy change") ///
						scalar(ll) nogaps


*** ME plots 

* Model 1				
gen x=_n in 1/2

gen effect=.
gen upper=.
gen lower=.

est restore model1_lag	  
margins, dydx(systemic_shift_ln_lag) at((mean) _continuous (base) _factor leadercentred_d=(0 1))

matrix b=r(b)
matrix V=r(V)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==1
replace upper=b[1,1] + 1.96*sqrt(V[1,1]) if x==1
replace lower=b[1,1] - 1.96*sqrt(V[1,1]) if x==1

replace effect=b[1,2] 					  if x==2
replace upper=b[1,2] + 1.96*sqrt(V[2,2]) if x==2
replace lower=b[1,2] - 1.96*sqrt(V[2,2]) if x==2

label define Hyp   1 "Activist-dominated party"  2 "Leader-dominated party"  
			
label values x  Hyp
sort x
eclplot effect lower upper x in 1/2, ///
	rplottype(rspike) ///
	estopts(msymbol(circle) mcolor(black)) ///
	ciopts(lcolor(black))	///
	legend(off) ///
	graphregion(color(white)) ///
	yscale(range(0.8 2.2)) ///
	xscale(range(-0.01 0.03)) ///
    ylabel(1 2, valuelabel labsize(small) notick nogrid) ///
	xlabel(-0.50(0.1)0.5, labsize(small) ) ///
	title("DV: Opinion-based policy change (Model 1)",color(black)) ///
	ytitle("") ///
	xtitle("Marginal effect",size(small)) ///
	ysize(2) ///
	xsize(4) ///
	xline(0, lcolor(black)) ///
	horizontal 
	
graph export figE1a.tif, replace  width(4800) 

drop x effect upper lower 
matrix drop _all
label drop Hyp						


* Model 2				
gen x=_n in 1/2

gen effect=.
gen upper=.
gen lower=.

est restore model2_lag	  
margins, dydx(systemic_shift_ln_lag) at((mean) _continuous (base) _factor leadercentred_d=(0 1))

matrix b=r(b)
matrix V=r(V)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==1
replace upper=b[1,1] + 1.96*sqrt(V[1,1]) if x==1
replace lower=b[1,1] - 1.96*sqrt(V[1,1]) if x==1

replace effect=b[1,2] 					  if x==2
replace upper=b[1,2] + 1.96*sqrt(V[2,2]) if x==2
replace lower=b[1,2] - 1.96*sqrt(V[2,2]) if x==2

label define Hyp   1 "Activist-dominated party"  2 "Leader-dominated party"  
			
label values x  Hyp
sort x
eclplot effect lower upper x in 1/2, ///
	rplottype(rspike) ///
	estopts(msymbol(circle) mcolor(black)) ///
	ciopts(lcolor(black))	///
	legend(off) ///
	graphregion(color(white)) ///
	yscale(range(0.8 2.2)) ///
	xscale(range(-2 2)) ///
    ylabel(1 2, valuelabel labsize(small) notick nogrid) ///
	xlabel(-2.5(0.5)2.5, labsize(small) ) ///
	title("DV: Emphasis-based policy change (Model 2)",color(black)) ///
	ytitle("") ///
	xtitle("Marginal effect",size(small)) ///
	ysize(2) ///
	xsize(4) ///
	xline(0, lcolor(black)) ///
	horizontal 
	
graph export figE1b.tif, replace  width(4800) 

drop x effect upper lower 
matrix drop _all
label drop Hyp		



*****************************************************************************
*** Continuous measure for party organization
*****************************************************************************

* proof for our claim that "The empirical range of this continuous measure is from -12.4 to +14.1."
sum leadercentred

	
regress abs_pure_polchange ///
	  c.leadercentred##c.leadercentred 	 ///
	  c.abs_pure_polchange_lag ///
	  c.votechange_lag ///	  
	  i.country, cluster(party) 
est sto model1_cont 

regress abs_pure_salchange ///
	  c.leadercentred##c.leadercentred 	 ///
	  c.abs_pure_salchange_lag  ///
	  c.votechange_lag ///	  
	  i.country, cluster(party) 
est sto model2_cont 	  


esttab model1_cont model2_cont  using "Appendix_F_1.rtf", replace label    ///
						star(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
						mtitles("Opinion-based policy change" "Emphasis-based policy change") ///
						scalar(ll) nogaps


	 
est restore model1_cont
margins, dydx(leadercentred) at((mean) _continuous (base) _factor leadercentred=(-5(1)13))
marginsplot, ///
	plotopts(recast(line) lcolor(black) )	///
	ciopts(recast(rarea) color(gs12) fintensity(100))	///
	legend(off) ///
	graphregion(color(white)) ///
	yscale(range(-0.15 0.15)) ///
	xscale(range(-5 13)) ///
    ylabel(-0.1(0.1)0.1, valuelabel labsize(small)  nogrid) ///
	xlabel(-5(2.5)12.5, labsize(small) ) ///
	title("DV: |Opinion-based policy change| (Model 1)",color(black)) ///
	ytitle("") ///
	xtitle("Leader-dominated party organization",size(small)) ///
	ysize(4) ///
	xsize(4) ///
	yline(0, lcolor(black)) /// 
	xline(0, lcolor(black))  
graph export figF1a.tif, replace  width(2400) 


est restore model2_cont
margins, dydx(leadercentred) at((mean) _continuous (base) _factor leadercentred=(-5(1)13))
marginsplot, ///
	plotopts(recast(line) lcolor(black) )	///
	ciopts(recast(rarea) color(gs12) fintensity(100))	///
	legend(off) ///
	graphregion(color(white)) ///
	yscale(range(-0.2 0.6)) ///
	xscale(range(-5 13)) ///
    ylabel(-0.2(0.2)0.6, valuelabel labsize(small)  nogrid) ///
	xlabel(-5(2.5)12.5, labsize(small) ) ///
	title("DV: |Emphasis-based policy change| (Model 2)",color(black)) ///
	ytitle("") ///
	xtitle("Leader-dominated party organization",size(small)) ///
	ysize(4) ///
	xsize(4) ///
	yline(0, lcolor(black)) /// 
	xline(0, lcolor(black))  
graph export figF1b.tif, replace  width(2400) 
	
	
	
regress pure_polchange ///
	  c.systemic_shift_ln##c.leadercentred##c.leadercentred    ///
	  c.dmvpt    ///	  
	  c.pure_polchange_lag##c.votechange_lag ///	  
	  c.unemp_change ///
	  i.country,cluster(party)		  
est sto model1_cont 

regress pure_salchange ///
	  c.systemic_shift_ln##c.leadercentred##c.leadercentred    ///
	  c.dmvpt    ///	  
	  c.pure_salchange_lag##c.votechange_lag ///	  
	  c.unemp_change ///
	  i.country, cluster(party)
est sto model2_cont 

esttab  model1_cont  model2_cont  using "Appendix_F_2.rtf", replace label    ///
						star(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
						mtitles("Opinion-based policy change" "Emphasis-based policy change") ///
						scalar(ll) nogaps

sum leadercentred, detail
* 2.5 - 97.5% (~-5 - 13)


est restore model1_cont
margins, dydx(systemic_shift_ln) at((mean) _continuous (base) _factor leadercentred=(-5(1)13))
marginsplot, ///
	plotopts(recast(line) lcolor(black) )	///
	ciopts(recast(rarea) color(gs12) fintensity(100))	///
	legend(off) ///
	graphregion(color(white)) ///
	yscale(range(-0.5 1)) ///
	xscale(range(-5 13)) ///
    ylabel(-0.5(0.25)1, valuelabel labsize(small)  nogrid) ///
	xlabel(-5(2.5)12.5, labsize(small) ) ///
	title("DV: Opinion-based policy change (Model 1)",color(black)) ///
	ytitle("") ///
	xtitle("Leader-dominated party organization",size(small)) ///
	ysize(4) ///
	xsize(4) ///
	yline(0, lcolor(black)) /// 
	xline(0, lcolor(black))  
graph export figF2a.tif, replace  width(2400) 


est restore model2_cont
margins, dydx(systemic_shift_ln) at((mean) _continuous (base) _factor leadercentred=(-5(1)13))
marginsplot, ///
	plotopts(recast(line) lcolor(black) )	///
	ciopts(recast(rarea) color(gs12) fintensity(100))	///
	legend(off) ///
	graphregion(color(white)) ///
	yscale(range(-2 4)) ///
	xscale(range(-5 13)) ///
    ylabel(-2(1)4, valuelabel labsize(small)  nogrid) ///
	xlabel(-5(2.5)12.5, labsize(small) ) ///
	title("DV: Emphasis-based policy change (Model 2)",color(black)) ///
	ytitle("") ///
	xtitle("Leader-dominated party organization",size(small)) ///
	ysize(4) ///
	xsize(4) ///
	yline(0, lcolor(black)) /// 
	xline(0, lcolor(black))  
graph export figF2b.tif, replace  width(2400) 





*******************************************************************************
*** Appendix G: Controlling for alternative party characteristics 
*******************************************************************************

regress abs_pure_polchange ///
	  i.leadercentred_d    ///
	  c.abs_pure_polchange_lag ///
	  c.pervote_lag ///
	  c.sal_eco_lag ///
	  c.votechange_lag ///	  
	  i.country , cluster(party)
est sto model1_pfactors

regress abs_pure_salchange ///
	  i.leadercentred_d    ///
	  c.abs_pure_salchange_lag  ///
	  c.votechange_lag ///	  
	  c.pervote_lag ///
	  c.sal_eco_lag ///
	  i.country , cluster(party)
est sto model2_pfactors

esttab model1_pfactors model2_pfactors  using "Appendix_G_1.rtf", replace label    ///
						star(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
						mtitles("Opinion-based policy change" "Emphasis-based policy change") ///
						scalar(ll) nogaps

 	
regress pure_polchange ///
	  c.systemic_shift_ln##i.leadercentred_d    ///
	  c.systemic_shift_ln##c.pervote_lag ///
	  c.systemic_shift_ln##c.sal_eco_lag ///
	  c.dmvpt    ///	  
	  c.pure_polchange_lag##c.votechange_lag ///	 
	  c.unemp_change ///
	  i.country ,cluster(party)		  
est sto model1_pfactors

regress pure_salchange ///
	  c.systemic_shift_ln##i.leadercentred_d    ///
	  c.systemic_shift_ln##c.pervote_lag ///
	  c.systemic_shift_ln##c.sal_eco_lag ///
	  c.dmvpt    ///	  
	  c.pure_salchange_lag##c.votechange_lag ///	  
	  c.unemp_change ///
	  i.country, cluster(party)
est sto model2_pfactors

esttab  model1_pfactors  model2_pfactors  using "Appendix_G_2.rtf", replace label    ///
						star(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
						mtitles("Opinion-based policy change" "Emphasis-based policy change") ///
						scalar(ll) nogaps

		
					
* Model 1
gen x=_n in 1/2

gen effect=.
gen upper=.
gen lower=.

est restore model1_pfactors
margins, dydx(systemic_shift_ln) at((mean) _continuous (base) _factor leadercentred_d=(0 1))

matrix b=r(b)
matrix V=r(V)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==1
replace upper=b[1,1] + 1.96*sqrt(V[1,1]) if x==1
replace lower=b[1,1] - 1.96*sqrt(V[1,1]) if x==1

replace effect=b[1,2] 					  if x==2
replace upper=b[1,2] + 1.96*sqrt(V[2,2]) if x==2
replace lower=b[1,2] - 1.96*sqrt(V[2,2]) if x==2

label define Hyp   1 "Activist-dominated party"  2 "Leader-dominated party"  
			
label values x  Hyp
sort x
eclplot effect lower upper x in 1/2, ///
	rplottype(rspike) ///
	estopts(msymbol(circle) mcolor(black)) ///
	ciopts(lcolor(black))	///
	legend(off) ///
	graphregion(color(white)) ///
	yscale(range(0.8 2.2)) ///
	xscale(range(-0.01 0.03)) ///
    ylabel(1 2, valuelabel labsize(small) notick nogrid) ///
	xlabel(-0.50(0.1)0.5, labsize(small) ) ///
	title("DV: Opinion-based policy change (Model 1)",color(black)) ///
	ytitle("") ///
	xtitle("Marginal effect",size(small)) ///
	ysize(2) ///
	xsize(4) ///
	xline(0, lcolor(black)) ///
	horizontal 

graph export figG1a.tif, replace  width(2400) 
					
drop x effect upper lower 
matrix drop _all
label drop Hyp		



* Model 2
gen x=_n in 1/2

gen effect=.
gen upper=.
gen lower=.

est restore model2_pfactors
margins, dydx(systemic_shift_ln) at((mean) _continuous (base) _factor leadercentred_d=(0 1))

matrix b=r(b)
matrix V=r(V)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==1
replace upper=b[1,1] + 1.96*sqrt(V[1,1]) if x==1
replace lower=b[1,1] - 1.96*sqrt(V[1,1]) if x==1

replace effect=b[1,2] 					  if x==2
replace upper=b[1,2] + 1.96*sqrt(V[2,2]) if x==2
replace lower=b[1,2] - 1.96*sqrt(V[2,2]) if x==2

label define Hyp   1 "Activist-dominated party"  2 "Leader-dominated party"  
			
label values x  Hyp
sort x
eclplot effect lower upper x in 1/2, ///
	rplottype(rspike) ///
	estopts(msymbol(circle) mcolor(black)) ///
	ciopts(lcolor(black))	///
	legend(off) ///
	graphregion(color(white)) ///
	yscale(range(0.8 2.2)) ///
	xscale(range(-2.5 2.5)) ///
    ylabel(1 2, valuelabel labsize(small) notick nogrid) ///
	xlabel(-2.5(0.5)2.5, labsize(small) ) ///
	title("DV: Emphasis-based policy change (Model 2)",color(black)) ///
	ytitle("") ///
	xtitle("Marginal effect",size(small)) ///
	ysize(2) ///
	xsize(4) ///
	xline(0, lcolor(black)) ///
	horizontal 

graph export figG1b.tif, replace  width(2400) 
					
drop x effect upper lower 
matrix drop _all
label drop Hyp	

log close

