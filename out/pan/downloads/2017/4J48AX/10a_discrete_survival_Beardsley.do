
set more off

*load Beardsley's discrete data version
use book-dyadyeardata, clear

*generate cubic polynomials of time since last crisis
btscs newcrisis year dyadno, generate(gapt)
gen gapt2=gapt^2
gen gapt3=gapt^3

*recalculate the interaction with time based on cubic polynomials
foreach var in med2 prevcris2 viol2 crisdur2 jointdem victory2 contig2 {
replace `var'_t= `var'*gapt
}

*estimate complete model including all control variables
eststo clear
eststo, title(Discrete duration model w/ covariates): probit newcrisis med2 med2_t prevcris2 viol2 crisdur2 jointdem victory2 contig2 /*
*/ gapt gapt2 gapt3 if _t<3650, cluster(dyadno)
matrix b=e(b)


*tables of results
esttab, star(* 0.05 ** 0.01) se  mtitle nodepvar  /*
*/ 		order(med2 med2_t)  /*
*/ 		varlabels(med2 "Mediation"/*
*/ 		med2_t "Mediation * time"/*
*/ 		prevcris2 "Previous crises"/*
*/ 		viol2 "Violence level"/*
*/ 		crisdur2 "Crisis duration"/*
*/ 		jointdem "Democratic dyad"/*
*/ 		victory2 "Victory"/*
*/ 		contig2 "Contiguity"/*
*/ 		prevcris2_t "Previous crises * time"/*
*/ 		viol2_t "Violence level * time"/*
*/ 		crisdur2_t "Crisis duration * time"/*
*/ 		jointdem_t "Democratic dyad * time"/*
*/ 		victory2_t "Victory * time"/*
*/ 		contig2_t "Contiguity * time"/*
*/ 		gapt "time"/*
*/ 		gapt2 "time$^2$"/*
*/ 		gapt3 "time$^3$"/*
*/		_cons Constant)
esttab using _table_discrete.tex, star(* 0.05 ** 0.01) se label  /*
*/ 		replace  /*
*/ 		order(med2 med2_t ) /*
*/ 		varlabels(med2 "Mediation"/*
*/ 		med2_t "Mediation $\times$ time"/*
*/ 		prevcris2 "Previous crises"/*
*/ 		viol2 "Violence level"/*
*/ 		crisdur2 "Crisis duration"/*
*/ 		jointdem "Democratic dyad"/*
*/ 		victory2 "Victory"/*
*/ 		contig2 "Contiguity"/*
*/ 		prevcris2_t "Previous crises $\times$ time"/*
*/ 		viol2_t "Violence level $\times$ time"/*
*/ 		crisdur2_t "Crisis duration $\times$ time"/*
*/ 		jointdem_t "Democratic dyad $\times$ time"/*
*/ 		victory2_t "Victory $\times$ time"/*
*/ 		contig2_t "Contiguity $\times$ time"/*
*/ 		gapt "time"/*
*/ 		gapt2 "time$^2$"/*
*/ 		gapt3 "time$^3$"/*
*/		_cons Constant)  /*
*/ 		b(%9.3g) nodepvar mtitle nonotes booktabs /*
*/ 		addnotes("Probit link function, cluster robust standard errors in parentheses, * p \textless 0.05, ** p \textless 0.01") 

*plot hazard rates for model with control variables
twoway function normal(b[1,1] + b[1,2]*x + b[1,9]*x + b[1,10]*x^2 + b[1,11]*x^3 + b[1,12]), range(0 10) lcol(black) || function normal(b[1,9]*x + b[1,10]*x^2 + b[1,11]*x^3 + b[1,12]), range(0 10) lcol(gs10) ytitle("Hazard rate") legend(label(1 "Mediation") label(2 "No mediation")) saving(discrete_h, replace) xtitle("Years at peace")

*use parametric bootstrap to calculate uncertainty of survival functions
*draw 1000 potential realization from the coefficient distribution
preserve
local pars=colsof(b)-1
drawnorm beta1-beta`pars' beta0, n(100000) means(e(b)) cov(e(V)) clear
save betasims.dta, replace
restore
capture drop _merge beta*
merge using betasims.dta 
tab _merge, miss
drop _merge
erase betasims.dta

*calculate mean for each variable
foreach var of varlist med2 prevcris2 viol2 crisdur2 jointdem victory2 contig2 {
quietly sum `var' if e(sample)
local s_`var'=r(mean)
}

*generate the risk score when every control variable is set to its mean
gen riskscore=beta3*`s_prevcris2' +beta4*`s_viol2' + /* 
*/		beta5*`s_crisdur2' +beta6*`s_jointdem' +beta7*`s_victory2' + /* 
*/		beta8*`s_contig2'

*generate variables to store survival curves for each case and their 
*difference and the confidence intervals for each of them
capture drop s_nomed s_nomed_up s_nomed_low s_med s_med_up s_med_low 
capture drop stime
gen s_nomed=1
gen s_nomed_up=1
gen s_nomed_low=1
gen s_med=1
gen s_med_up=1
gen s_med_low=1
gen s_diff=0
gen s_diff_up=0
gen s_diff_low=0
gen stime=0

*calculate predicted probability for each time point
*generate variables to store parametric bootstrap estimate
capture drop s0 s1
gen s0=1
gen s1=1
gen sdiff=.
local n=2
*for each year of a 10 year post-crisis period...
forvalues t=1/10 {
*...calculate mediation scenario
local betat=9
local betat2=10
local betat3=11
gen h`t' = normal(beta0 + beta1 + beta2*`t' + riskscore + beta`betat'*`t' + beta`betat2'*`t'^2 + beta`betat3'*`t'^3)
replace s1=s1*(1-h`t')
drop h`t'
quietly sum s1, d
replace s_med=r(mean) in `n'
replace s_med_up=r(p95) in `n'
replace s_med_low=r(p5) in `n'

*...calculate baseline scenario
gen h`t' = normal(beta0 +  riskscore + beta`betat'*`t' + beta`betat2'*`t'^2 + beta`betat3'*`t'^3)
replace s0=s0*(1-h`t')
drop h`t'
quietly sum s0, d
replace s_nomed=r(mean) in `n'
replace s_nomed_up=r(p95) in `n'
replace s_nomed_low=r(p5) in `n'

*...calculate difference due to mediation
replace sdiff=s1-s0
quietly sum sdiff, d
replace s_diff=r(mean) in `n'
replace s_diff_up=r(p95) in `n'
replace s_diff_low=r(p5) in `n'

replace stime=`n'-1 in `n'
local n=`n'+1
display `n'
}

*list the results including confidence intervals
list stime s_nomed s_nomed_up s_nomed_low s_med s_med_up s_med_low in 1/`n'

*prepare time variable for plotting
replace stime=. if _n>=`n'
label var stime "Years at peace"

*plot survival functions including confidence intervals
twoway rarea s_nomed_up s_nomed_low stime, col(gs14) || /*
*/ line s_med s_nomed s_med_up s_med_low stime, /*
*/ lcol(black gs10 black black) lp(solid solid shortdash shortdash) /*
*/ saving(discrete_s, replace) legend(off) ytitle("Survival probability")

*plot difference in survival functions
twoway line s_diff* stime, yline(0, lp(dot))/*
*/ lcol(black black black) lp(solid shortdash shortdash) /*
*/ saving(discrete_diff, replace) legend(off) ytitle("Difference in survival probability")

*combine all plots in the same graph
grc1leg discrete_h.gph discrete_s.gph discrete_diff.gph, leg(discrete_h.gph)
graph export Beardsley_survival_discrete_atmean_strata.pdf, as(pdf) replace


