**********************************************************
* Estimate the effect of ID on school grant applications
**********************************************************

	capture log close
	clear all
	macro drop _all
	set more off
	version 14.2
	set matsize 11000

// user-written commands
* nbvargr
	
****************************************************** 
 *Set working directory 

capture cd "replication_APSR"
	
******************************************************
* import school grant application data
	
use "School_grant_apps.dta", clear
	
* merge-in councilor covariates
merge 1:1 id using "Councilors_covariates_v2.dta"
	drop if _merge ==1
	drop _merge

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
	
	gl controls NRM SWC Edu SMS  FirstTerm NOfChallengers2011 lpop constit_poverty  FirstTerm_miss NOfChallengers2011_miss constit_hhi lpop_miss constit_poverty_miss constit_hhi_miss 
	su $controls
	 
* define sample
	gen sample=0
	replace sample=1 if NRM!=. & SWC!=. & Edu!=. & SMS!=. & FirstTerm!=. & NOfChallengers2011!=. & lpop!=. & constit_poverty!=. & constit_hhi!=. & competitive!=.

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
	
******************************************************
* Regression Analysis	
******************************************************
* 	Outcome variables: 
*   1. sent in any application 
*   2. share of completed applications
******************************************************
	* drop outlier
	drop if schools==106
	
*   Kamuli drops since we were unable to conduct the experiment there
	drop if kamuli==1

	gen AppShare=(applicationapp1_ctv+applicationapp2_clv+applicationapp3_itv+applicationapp4_ilv+applicationapp7_cli)/schools
	replace AppShare=1 if AppShare>1 & AppShare!=.
	ttest AppShare if ID==0, by(SMS) unp

	gen AllApp = applicationapp1_ctv+applicationapp2_clv+applicationapp3_itv+applicationapp4_ilv+applicationapp7_cli
	replace AllApp = schools if AppShare>1 & AppShare!=.
	lab var AllApp "Total applications whether or not complete"
	ttest AllApp if ID==0, by(SMS) unp
			
	gen CompleteApp = applicationapp1_ctv+applicationapp2_clv+applicationapp7_cli
	lab var CompleteApp "Total schools with complete application"
	ttest CompleteApp if ID==0, by(SMS) unp
	
***************************************************
* checking distribution of N. applications 
*Figure 16 Online appendix
****************************************************
qui glm CompleteApp i.ID i.SMS schools $controls , fam(poi) cl(id) cformat(%8.3f)
nbvargr CompleteApp if e(sample), title("School Applications Distribution") xtitle("Number of completed school applications")
graph export "figures/CompleteApplicationsDistribution.pdf", replace	
	
******************************************************
* 	Regression Models 
* 	All models include district fixed effects and cluster SE at sub-county level
******************************************************
	* DVs:
	*1. Total number of submitted applications
	*2. Total number of submitted complete appplications
******************************************************
local dv AllApp CompleteApp 

	foreach y in `dv' {
	forvalues i=1(1)7{
	tempfile `y'`i'
	}
	}

set more off
	foreach y in `dv' {

*1. Main effects: use distirct FEs 	
	nbreg `y' i.ID schools i.distid  [pw=IPW], cluster(swc_id) irr
	estadd local control ""
	est store `y'_m1

*2. Main effects: add covariates	
	nbreg `y' i.ID schools i.distid initial_score $controls  [pw=IPW], cluster(swc_id) irr
	estadd local control "X"
	est store `y'_m2
	margins, dydx(ID) post
	parmest, label bmat(r(b)) vmat(r(V)) saving(``y'1')

*3. Hetrogenous effects: use MoV binary 	
	nbreg `y' ID##competitive schools i.distid  initial_score $controls [pw=IPW], cluster(swc_id) irr
	estadd local control "X"
	est store `y'_m3
	margins, dydx(ID) over(competitive) post
	parmest, label bmat(r(b)) vmat(r(V)) saving(``y'2') 
	estimate restore `y'_m3
	margins r.ID, over(r.competitive) post
	parmest, label bmat(r(b)) vmat(r(V)) saving(``y'3')
	
*4. Hetrogenous effects: use Majority distance binary  	
	nbreg `y' ID##kcompB schools i.distid initial_score $controls  [pw=IPW], cluster(swc_id) irr
	estadd local control "X"
	est store `y'_m4
	margins, dydx(ID) over(kcompB) post
	parmest, label bmat(r(b)) vmat(r(V)) saving(``y'4') 
	estimate restore `y'_m4
	margins r.ID, over(r.kcompB) post
	parmest, label bmat(r(b)) vmat(r(V)) saving(``y'5')
	
* Hetrogenous effects: use MoV continuous 
	nbreg `y' ID##c.MarginOfVictory2011 i.distid initial_score $controls  [pw=IPW], cluster(swc_id) irr
	estadd local control "X"
	estimate store `y'_m5
	margins , dydx(ID) at(MarginOfVictory2011=(-.5(0.025)0)) atmeans vsquish level(90)
	parmest, label bmat(r(b)) vmat(r(V)) saving(``y'6')

* Hetrogenous effects: use Majority distance continuous	
	nbreg `y' ID##c.kcomp i.distid initial_score $controls  [pw=IPW], cluster(swc_id) irr
	estadd local control "X"
	estimate store `y'_m6
	margins , dydx(ID) at(kcomp =(-.5(0.05).2)) atmeans vsquish level(90)
	parmest, label bmat(r(b)) vmat(r(V)) saving(``y'7')
	
************************************			
* Create tables	18-19 Online appendix			
************************************	
		
# delimit ; 
esttab  `y'_m1 `y'_m2 `y'_m3 `y'_m4 `y'_m5 `y'_m6
using "tables/`y'NB.tex", 
	keep (1.ID 1.competitive 1.ID#1.competitive 1.kcompB 1.ID#1.kcompB MarginOfVictory2011 1.ID#c.MarginOfVictory2011 kcomp 1.ID#c.kcomp _cons)
    order(1.ID 1.competitive 1.ID#1.competitive 1.kcompB 1.ID#1.kcompB MarginOfVictory2011 1.ID#c.MarginOfVictory2011 kcomp 1.ID#c.kcomp _cons)
			cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par))
			starlevels(* .10 ** .05 *** .01) 					
			mgroups("\textbf{Unconditional}" "\textbf{Conditional (binary)}" "\textbf{Conditional (cont)}", pattern(1 0 1 0 1 0)
			span prefix(\multicolumn{@span}{c}{) suffix(}) erepeat(\cmidrule(lr){@span})) nomtitles
			varlabels(1.ID "ID"
					  1.competitive "Competitive (MoV)"
					  1.ID#1.competitive "ID*Competitive (MoV)"
					  1.kcompB "Competitive (MD)"
					  1.ID#1.kcompB "ID*Competitive (MD)"
					  MarginOfVictory2011 "Margin of Victory"
					  1.ID#c.MarginOfVictory2011 "ID*Margin of Victory"
					  kcomp "Majority distance"
					  1.ID#c.kcomp "ID*Majority distance" 
					  _cons "Constant")
		stats(control N, labels("Controls" "N") 	
		fmt(0 0)) collabels(none)	label booktabs nonotes replace;
# delimit cr
	}
	
*************************************************************************
* // graph marginal effects from NB models
*Figure 31 online appendix
*************************************************************************

graph drop  _all
preserve 
use `CompleteApp2' , clear
append using `CompleteApp3'
append using `AllApp2'
append using `AllApp3'

drop if parm=="0o.competitive" | parm=="1o.competitive"

	gen model=1
	replace model =2 in 4/6
	replace parm="Competition: L" if parm=="0.competitive"
	replace parm="Competition: H" if parm=="1.competitive"
	replace parm="Difference" if parm=="r1vs0.competitive#r1vs0.ID"

	gen min90 = estimate - stderr*1.65
	gen max90 = estimate + stderr*1.65
	
		eclplot estimate min90 max90 model,  horizontal supby(parm, spaceby(0.15)) ///
		rplottype(rspike) ///
		ciopts(lc(black)) ///
		estopts1(col(ebg) msiz(vlarge) m(o)) ///
		estopts2(col(gs6) msiz(vlarge) m(t)) ///
		estopts3(col(black) msiz(vlarge) m(dh)) ///
		title("Margin of Victory", col(black) size(3)) ///
		ylabel(1 "Complete apps" 2 "All apps") ///
		ytitle("") xtitle("Marginal effects") xscale(r(-2 6)) xlabel(-2(1)6)  ///
		legend( pos(6) ring(1) row(1) region(fcolor(gs15)) textfirst keygap(4) symxsize(20) symysize(*5)) ///
		xline(0, lw(medthick) lc(black)) name(_1)
restore	

preserve 
use `CompleteApp4' , clear
append using `CompleteApp5'
append using `AllApp4'
append using `AllApp5'

drop if parm=="0o.kcompB" | parm=="1o.kcompB"

	gen model=1
	replace model =2 in 4/6
	replace parm="Competition: L" if parm=="0.kcompB"
	replace parm="Competition: H" if parm=="1.kcompB"
	replace parm="Difference" if parm=="r1vs0.kcompB#r1vs0.ID"

	gen min90 = estimate - stderr*1.65
	gen max90 = estimate + stderr*1.65
	
		eclplot estimate min90 max90 model,  horizontal supby(parm, spaceby(0.15)) ///
		rplottype(rspike) ///
		ciopts(lc(black)) ///
		estopts1(col(ebg) msiz(vlarge) m(o)) ///
		estopts2(col(gs6) msiz(vlarge) m(t)) ///
		estopts3(col(black) msiz(vlarge) m(dh)) ///
		title("Majority distance" , col(black) size(3)) ///
		ylabel(1 "Complete apps" 2 "All apps") ///
		ytitle("") xtitle("Marginal effects") xscale(r(-2 6)) xlabel(-2(1)6)  ///
		legend( pos(6) ring(1) row(1) region(fcolor(gs15)) textfirst keygap(4) symxsize(20) symysize(*5)) ///
		xline(0, lw(medthick) lc(black)) name(_2)
restore	
		
	graph combine _1 _2, title("ID conditional effect on school grant applications")
	graph export "figures/AppCond.pdf", replace	
	

