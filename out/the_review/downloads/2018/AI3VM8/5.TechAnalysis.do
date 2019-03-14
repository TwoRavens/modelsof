****************************************************************************
* Estimate the effect of the ID program on technocrats' assessments
****************************************************************************

	capture log close
	clear all
	macro drop _all
	set more off
	version 14.2
	set matsize 11000

****************************************************** 
 *Set working directory 

capture cd "replication_APSR"
	
******************************************************
* bring in data	
use "Technocrats_assessment.dta", clear
drop mindex_tech mindex_tech_avg index_technocratsA

******************************************************
* merge-in councilor covariates
******************************************************	
merge m:1 id using "Councilors_covariates_v2.dta"
	keep if _m==3
	drop _merge

******************************************************
* Generate composite outcome index	(Kling et al., 2007)
*****************************************************	
	foreach var in tech_q1 tech_q2 tech_q3 tech_q4 {
	quietly summarize `var' if ID==0
	local `var'_mean= r(mean)
	local `var'_sd= r(sd) 
	gen c_`var' = (`var'-``var'_mean')/``var'_sd'
	qui egen mean_std_`var'=mean(c_`var') if ID==1
	replace c_`var' = mean_std_`var' if ID==1 & c_`var'==.
	replace c_`var' = 0 if ID==0 & c_`var'==.
	}
	
egen index_technocratsA=rowmean(c_tech_q1 c_tech_q2 c_tech_q3 c_tech_q4)
	
	preserve
	keep id index_technocratsA
	collapse index_technocratsA, by(id)
	saveold "Technocrats_assessmentB.dta", replace
	restore
	
********************************************************
* Define covariates
******************************************************

	gl covs NRM SWC Edu SMS cterms FirstTerm NOfChallengers2011 lpop constit_poverty constit_hhi 
	su $covs

* assign mean values of control to missing values of covariates (Lin, green and Coppock, 2015))
	foreach y in $covs {
	 egen `y'_mean=mean(`y')
	 gen `y'_miss = `y'==.
	 replace `y' = `y'_mean if `y'==.
	 }

	gen initial_score = total_score_2011_2012

	bys district: egen initial_mean_low=mean(total_score_2011_2012) if competitive ==0
	replace initial_score = initial_mean_low if initial_score==. & competitive ==0
	
	bys district: egen initial_mean_high=mean(total_score_2011_2012) if competitive ==1
	replace initial_score = initial_mean_high if initial_score==. & competitive ==1
	gen initial_score_miss = total_score_2011_2012==.
	
	gl controls NRM SWC Edu SMS  FirstTerm NOfChallengers2011 lpop constit_poverty FirstTerm_miss NOfChallengers2011_miss constit_hhi lpop_miss constit_poverty_miss constit_hhi_miss 
	su $controls
	 
* create var capturing whether the councilor's baseline scorer was above the district median

	bysort distid : egen median_by_dist = median(initial_score) 
	gen HighP = cond(missing(initial_score), ., (initial_score > median_by_dist))
	lab var HighP "Initial score above median" 
	
* Majority distance: alternative measure of competitivness
	replace MarginOfVictory2011=-1*MarginOfVictory2011
	gen kcomp= -1*(VoteShare2011-.5)
	egen medianK = median(kcomp) 
	gen kcompB = cond(missing(kcomp), ., (kcomp > medianK))
	lab var kcompB "Majority distance binary"
 
* define technocart controls	
	gl technocart i.tech_office tech_gender tech_year
	su $technocart

* define sample
	gen sample=0
	replace sample=1 if NRM!=. & SWC!=. & Edu!=. & SMS!=. & FirstTerm!=. & NOfChallengers2011!=. & lpop!=. & constit_poverty!=. & constit_hhi!=. & competitive!=.

	
***************************************************
* Regression Analysis	
***************************************************
* set panel 
xtset id tech_office
local dv index_technocratsA c_tech_q1 c_tech_q2 c_tech_q3 c_tech_q4 

	foreach y in `dv' {
	forvalues i=1(1)4{
	tempfile `y'`i'
	}
	}
	
******************************************************
* unconditional ID effects	
* weighting by inverse probability of treatment assignment
******************************************************	 

foreach y in  `dv' {
reghdfe `y' ID $technocart if sample==1 [pw=IPW], abs(distid) cl(id)
	estadd local control ""
	est store `y'_m1
	
// add covariates 
reghdfe `y' ID $technocart $controls if sample==1 [pw=IPW], abs(distid) cl(id)
	estadd local control "X"
	est store `y'_m2
	
******************************************************
// Conditional on electoral competition	
******************************************************	 
reghdfe `y' ID##competitive $technocart if sample==1 [pw=IPW], abs(distid) cl(id)
	estadd local control "X"
	est store `y'_m3
	margins, dydx(ID) over(competitive) post
	parmest, label bmat(r(b)) vmat(r(V)) saving(``y'1')
	est restore `y'_m3
	margins r.ID, over(r.competitive) post
	parmest, label bmat(r(b)) vmat(r(V)) saving(``y'2')
		
reghdfe `y' ID##kcompB $technocart $controls if sample==1 [pw=IPW], abs(distid) cl(id)
	estadd local control "X"
	est store `y'_m4
	margins, dydx(ID) over(kcompB)
	parmest, label bmat(r(b)) vmat(r(V)) saving(``y'3')
	est restore `y'_m3
	margins r.ID, over(r.kcompB) post
	parmest, label bmat(r(b)) vmat(r(V)) saving(``y'4')
	
reghdfe `y' ID##c.MarginOfVictory2011 $technocart if sample==1 [pw=IPW], abs(distid) cl(id)
	estadd local control "X"
	est store `y'_m5
	
reghdfe `y' ID##c.kcomp $technocart $controls if sample==1 [pw=IPW], abs(distid) cl(id)
	estadd local control "X"
	est store `y'_m6		
	}
	
************************************			
* Table	main effects: 16 online appendix				
************************************
		
# delimit ; 
esttab  index_technocratsA_m1 index_technocratsA_m2
		c_tech_q1_m1 c_tech_q1_m2
		c_tech_q2_m1 c_tech_q2_m2
		c_tech_q3_m1 c_tech_q3_m2
		c_tech_q4_m1 c_tech_q4_m2
using "tables/TechnocratsUnconditional.tex",
		keep(ID)
		order(ID)
		cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par))
		starlevels(* .10 ** .05 *** .01)
		mgroups("\textbf{Mean assessment}" "\textbf{Office Visits}" "\textbf{Knowledgeable}" "\textbf{Monitoring}" "\textbf{Effort}", pattern(1 0 1 0 1 0 1 0 1 0)
		span prefix(\multicolumn{@span}{c}{) suffix(}) erepeat(\cmidrule(lr){@span})) nomtitles
		varlabels(ID "ID")
		stats(control N, labels("Controls" "N")
		fmt(0 0)) collabels(none)
		label booktabs nonotes replace;
#delimit cr

************************************			
* Table	17 online appendix				
************************************ 

# delimit ; 
esttab  index_technocratsA_m3 index_technocratsA_m4
		c_tech_q1_m3 c_tech_q1_m4
		c_tech_q2_m3 c_tech_q2_m4
		c_tech_q3_m3 c_tech_q3_m4
		c_tech_q4_m3 c_tech_q4_m4
using "tables/TechnocratsConditional.tex",
		keep( 1.ID 1.competitive 1.ID#1.competitive 1.kcompB 1.ID#1.kcompB)
		order(1.ID 1.competitive 1.ID#1.competitive 1.kcompB 1.ID#1.kcompB)
		cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par))
		starlevels(* .10 ** .05 *** .01)
		mgroups("\textbf{Mean assessment}" "\textbf{Office Visits}" "\textbf{Knowledgeable}" "\textbf{Monitoring}" "\textbf{Effort}", pattern(1 0 1 0 1 0 1 0 1 0)
		span prefix(\multicolumn{@span}{c}{) suffix(}) erepeat(\cmidrule(lr){@span})) nomtitles
		varlabels(1.ID "ID"
					  1.competitive "Competitive (MoV)"
					  1.ID#1.competitive "ID*Competitive (MoV)"
					  1.kcompB "Competitive (MD)"
					  1.ID#1.kcompB "ID*Competitive (MD)")
		stats(control N, labels("Controls" "N")
		fmt(0 0)) collabels(none)
		label booktabs nonotes replace;
#delimit cr	
********************************
*Figure 29 Online Appendix
********************************

preserve
use `index_technocratsA1', clear
	append using `index_technocratsA2'
	append using `c_tech_q11'
	append using `c_tech_q12' 
	append using `c_tech_q21' 
	append using `c_tech_q22' 
	append using `c_tech_q31' 
	append using `c_tech_q32'
	append using `c_tech_q41'
	append using `c_tech_q42'
	
	gen model=1
	replace model =2 in 4/6
	replace model =3 in 7/9
	replace model =4 in 10/12
	replace model =5 in 13/15

	replace parm="Competition: Low" if parm=="0.competitive"
	replace parm="Competition: High" if parm=="1.competitive"
	replace parm="Difference" if parm=="r1vs0.competitive#r1vs0.ID"

	gen min90 = estimate - stderr*1.65
	gen max90 = estimate + stderr*1.65
	
		eclplot estimate min90 max90 model,  horizontal supby(parm, spaceby(0.15)) ///
		rplottype(rspike) ///
		ciopts(lc(black)) ///
		estopts1(col(ebg) msiz(vlarge) m(o)) ///
		estopts2(col(gs6) msiz(vlarge) m(t)) ///
		estopts3(col(black) msiz(vlarge) m(dh)) ///
		title("ID conditional effect on technocrats' assessement", col(black) size(3)) ///
		ylabel(1 "Mean assessement" 2 "Office visits" 3 "Knowledgeable" 4 "Monitoring" 5 "Effort") ///
		ytitle("") xtitle("Marginal effects") ///
		legend( pos(6) ring(1) row(1) region(fcolor(gs15)) textfirst keygap(4) symxsize(20) symysize(*5)) ///
		xline(0, lw(medthick) lc(black)) scheme(plotplain) 		
		graph export "figures/TechCond.pdf", replace	
	
restore

********************************
*Figure 30 Online Appendix
********************************

set more off
graph drop  _all
areg index_technocratsA ID##c.kcomp $technocart $controls i.tech_office if sample==1 [pw=IPW], abs(distid) cl(id)
	margins, dydx(ID) at(kcomp =(-.5(0.05).2)) atmeans vsquish level(90)
	marginsplot,  title("") ///
	xtitle("Majority distance") ytitle("Marginal effects") xsca(r(-.5 .2)) xlabel(-.5(.1).2) ysca(r(-.3 .3)) ylabel(-.3(.1).3) ///
	yline(0, lw(medthick) lc(black)) xline(-.08, lw(medthick) lp(solid) lc(red)) name(_1)

areg index_technocratsA ID##c.MarginOfVictory2011 $technocart $controls i.tech_office if sample==1 [pw=IPW], abs(distid) cl(id)
	margins, dydx(ID) at(MarginOfVictory2011=(-.5(0.025)0)) atmeans vsquish level(90)	
	marginsplot, title("") ///
	xtitle("Margin of victory") ytitle("Marginal effects") xsca(r(-.5 0)) xlabel(-.5(.05)0) ysca(r(-.3 .3)) ylabel(-.3(.1).3) ///
	yline(0, lw(medthick) lc(black)) xline(-.08, lw(medthick) lp(solid) lc(red)) name(_2)
	
graph combine _1 _2, title("Technocrats' assessement (summary index)")	
		graph export "figures/TechCondCont.pdf", replace	
	
