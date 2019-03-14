	**********************************************************
	* 1. create composite index 
	* 2. estimate the effect of the ID program on the composite index
	* Last update: Spetmeber 16, 2016
	**********************************************************

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
*Import updated scorecard data
	use "Scorecard_scores.dta", clear
	egen meanscore=rowmean(total_score_2012_2013 total_score_2013_2014 total_score_2014_2015)
		
******************************************************
* merge-in councilor covariates
******************************************************	
merge 1:1 id using "Councilors_covariates_v2.dta"
		drop _merge

******************************************************
* merge-in councilor peer evaluation
******************************************************
merge 1:1 id using "peer_evaluations.dta", 
		drop if _m==2
		drop _m
		egen avescore= rmean(peer_score*) 
		order avescore, b(peer_score1)

******************************************************
* merge-in technocrats evaluation
******************************************************
merge 1:m id using "Technocrats_assessmentB.dta", keepus(index_technocratsA)
		drop if _m==2
		drop _merge	
		ren index_technocratsA technocrats

******************************************************
* merge-in behavioral outcome (school grant apps)
******************************************************	
merge 1:1 id using "School_grant_apps.dta"	
		drop if _m==2
		drop _merge	
		drop if schools==106
		
	gen AppShare=(applicationapp1_ctv+applicationapp2_clv+applicationapp3_itv+applicationapp4_ilv+applicationapp7_cli)/schools
		replace AppShare=1 if AppShare>1 & AppShare!=.
		
	gen AllApp = applicationapp1_ctv+applicationapp2_clv+applicationapp3_itv+applicationapp4_ilv+applicationapp7_cli
		lab var AllApp "Total school grant applications"

	gen CompleteApp = applicationapp1_ctv+applicationapp2_clv+applicationapp7_cli
		lab var CompleteApp "Complete school grant application"
		
******************************************************
* Generate composite outcome index	(Kling et al., 2007)
*****************************************************	
	foreach var in meanscore avescore technocrats AllApp CompleteApp{
	quietly summarize `var' if ID==0
	local `var'_mean= r(mean)
	local `var'_sd= r(sd) 
	gen c_`var' = (`var'-``var'_mean')/``var'_sd'
	qui egen mean_std_`var'=mean(c_`var') if ID==1
	replace c_`var' = mean_std_`var' if ID==1 & c_`var'==.
	replace c_`var' = 0 if ID==0 & c_`var'==.
	qui egen mean_`var'1=mean(`var') if ID==1
	replace `var' = mean_`var'1 if ID==1 & `var'==.
	qui egen mean_`var'0=mean(`var') if ID==0
	replace `var' = mean_`var'0 if ID==0 & `var'==.
	drop mean_`var'0 mean_`var'1 mean_std_`var'
	}
	
	egen index_PerformanceA=rowmean(c_meanscore c_avescore c_technocrats c_CompleteApp)
	
******************************************************
* Generate weighted outcome index	(Anderson, 2008)
*****************************************************
	* 2. Use Anderaon 2008
	
do "make_index.ado"		
		make_index PerformanceB meanscore avescore technocrats CompleteApp

		lab var index_PerformanceA "Councilor performance index"
		lab var index_PerformanceB "Councilor performance index"
		su index_PerformanceA index_PerformanceB, de
		corr index_PerformanceA index_PerformanceB

******************************************************
* save small dataset of outcomes	
*****************************************************
replace MarginOfVictory2011=-1*MarginOfVictory2011

	preserve
	keep id ID SMS MarginOfVictory2011 competitive NRM index_PerformanceA index_PerformanceB meanscore total_score_2013_2014 avescore technocrats AllApp CompleteApp 
	saveold "MainOutcomes.dta", replace
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
	gen kcomp= -1*(VoteShare2011-.5)
	egen medianK = median(kcomp) 
	gen kcompB = cond(missing(kcomp), ., (kcomp > medianK))
	lab var kcompB "Majority distance binary"
	
********************************************************
* Run regressions 
******************************************************
	set more off
	local dv index_PerformanceA index_PerformanceB c_meanscore c_avescore c_technocrats c_AllApp c_CompleteApp
	
	foreach y in `dv' {
	tempfile `y'1
	}
	
********************************************************
* unconditional treatment effects
********************************************************
	foreach y in `dv'{
		
	areg `y' i.ID if sample==1 , abs(distid) vce(bs, rep(1000) seed(07182017)) cl(distid)
		estadd local control "" 
		estadd local district "X"
		estimate store `y'_m1

	areg `y' i.ID $controls if sample==1 , abs(distid) vce(bs, rep(1000) seed(07182017)) cl(distid)
		estadd local control "X"
		estadd local district "X"
		estimate store `y'_m2 	
		margins , dydx(ID) post
		parmest, label bmat(r(b)) vmat(r(V)) saving(``y'1')
		
********************************************************
* effects conditional on competitiveness: continuous
********************************************************

	areg `y' ID##c.MarginOfVictory2011##c.MarginOfVictory2011 $controls if sample==1 , abs(distid) vce(bs, rep(1000) seed(07182017)) cl(distid)
		estadd local control "X"
		estadd local district "X"
		estimate store `y'_m3a
		
	areg `y' ID##c.MarginOfVictory2011 $controls if sample==1 , abs(distid) vce(bs, rep(1000) seed(07182017)) cl(distid)
		estadd local control "X"
		estadd local district "X"
		estimate store `y'_m3b	
		
	areg `y' ID##c.kcomp##c.kcomp $controls if sample==1 , abs(distid) vce(bs, rep(1000) seed(07182017)) cl(distid)
		estadd local control "X"
		estadd local district "X"
		estimate store `y'_m4a
		
	areg `y' ID##c.kcomp $controls if sample==1 , abs(distid) vce(bs, rep(1000) seed(07182017)) cl(distid)
		estadd local control "X"
		estadd local district "X"
		estimate store `y'_m4b
}	
		
********************************************************
// effects conditional on competitiveness: Binary
******************************************************
ren competitive comp

	foreach y in `dv' {
	tempfile `y'kcompB2 `y'kcompB3 `y'comp2 `y'comp3
	}

foreach y in `dv' {
foreach mod in kcompB comp{

	areg `y' ID##`mod' if sample==1 , abs(distid) vce(bs, rep(1000) seed(07182017)) cl(distid)
		estadd local control ""
		estadd local district "X"
		estimate store `y'`mod'_m5
		
	areg `y' ID##`mod' $controls if sample==1 , abs(distid) vce(bs, rep(1000) seed(07182017)) cl(distid)
		estadd local control "X"
		estadd local district "X"
		estimate store `y'`mod'_m6
		
		margins, dydx(ID) over(`mod') post
		parmest, label bmat(r(b)) vmat(r(V)) saving(``y'`mod'2') 
		estimate restore `y'`mod'_m6
		margins r.ID, over(r.`mod') post
		parmest, label bmat(r(b)) vmat(r(V)) saving(``y'`mod'3')
}
}

*****************************************
// make tables	9-10-14	Online appendix
*****************************************	
foreach y in `dv' {

	# delimit ; 
	esttab  `y'_m1 `y'_m2 `y'comp_m6 `y'kcompB_m6 `y'_m3b `y'_m4b 
	using "tables/`y'.tex", replace
keep (1.ID 1.comp 1.ID#1.comp 1.kcompB 1.ID#1.kcompB MarginOfVictory2011 1.ID#c.MarginOfVictory2011 kcomp 1.ID#c.kcomp )
order(1.ID 1.comp 1.ID#1.comp 1.kcompB 1.ID#1.kcompB MarginOfVictory2011 1.ID#c.MarginOfVictory2011 kcomp 1.ID#c.kcomp )
			cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par))
			starlevels(* .10 ** .05 *** .01) 					
			mgroups("\textbf{Unconditional}" "\textbf{Conditional (binary)}" "\textbf{Conditional (cont)}", pattern(1 0 1 0 1 0)
			span prefix(\multicolumn{@span}{c}{) suffix(}) erepeat(\cmidrule(lr){@span})) nomtitles
			varlabels(1.ID "ID"
					  1.comp "Competitive (MoV)"
					  1.ID#1.comp "ID*Competitive (MoV)"
					  1.kcompB "Competitive (MD)"
					  1.ID#1.kcompB "ID*Competitive (MD)"
					  MarginOfVictory2011 "Margin of Victory"
					  1.ID#c.MarginOfVictory2011 "ID*Margin of Victory"
					  kcomp "Majority distance"
					  1.ID#c.kcomp "ID*Majority distance")
			stats(district control N, labels("District FE" "Controls" "N" )
			fmt(0 0 0)) collabels(none)	label booktabs nonotes;
	#delimit cr		
	}

	**************************************************	
	**************************************************	
	* Save estimation results of models to plot
	**************************************************
	**************************************************	

// binary measure of competitiveness

foreach y in index_PerformanceA index_PerformanceB c_meanscore c_avescore c_technocrats c_AllApp c_CompleteApp {	
preserve
	use ``y'1', clear
	append using ``y'comp2'
	append using ``y'comp3'

		replace parm="Competition: Low" if parm=="0.comp" 
		replace parm="Competition: High" if parm=="1.comp" 
		replace parm ="Difference" if parm=="r1vs0.comp#r1vs0.ID"
		drop label 
		replace eq="ID"
		drop if z==.
		
		gen DV="`y'"
		gen model="Unconditional"
		replace model="Conditional" in 2/4
				
saveold "estimates/ConditionalEstimates`y'comp.dta", replace
restore	 
	
	preserve
	use ``y'1', clear
	append using ``y'kcompB2'
	append using ``y'kcompB3'

		replace parm="Competition: Low" if parm=="0.kcompB" 
		replace parm="Competition: High" if parm=="1.kcompB" 
		replace parm ="Difference" if parm=="r1vs0.kcompB#r1vs0.ID"
		drop label 
		replace eq="ID"
		drop if z==.
		
		gen DV="`y'"
		gen model="Unconditional"
		replace model="Conditional" in 2/4
				
	saveold "estimates/ConditionalEstimates`y'kcompB.dta", replace
	restore	 	
}
*/
********************************************************
* generate estimation figures: Binary
* Figure 3 Paper
******************************************************
// MoV

tempfile Unconditional Conditional


preserve
use "estimates/ConditionalEstimatesindex_PerformanceAcomp.dta", clear     
	append using "estimates/ConditionalEstimatesc_meanscorecomp.dta"
	append using "estimates/ConditionalEstimatesc_avescorecomp.dta"
	append using "estimates/ConditionalEstimatesc_technocratscomp.dta"
	append using "estimates/ConditionalEstimatesc_AllAppcomp.dta"
	
	gen min90 = estimate - stderr*1.65
	gen max90 = estimate + stderr*1.65
	
save `Unconditional', replace
	
	keep if parm=="1.ID"
	gen DV2 =_n
		
	eclplot estimate min90 max90 DV2,  horizontal ///
	rplottype(rspike) ///
	ciopts(lc(black)) ///
	estopts(col(black) msiz(large) m(o)) ///
	title("ID Treatment Effects (unconditional)", col(black)) ///
	ylabel(1 "Composite index" 2 "ACODE score" 3 "Peer evaluation" 4 "Technocrats" 5 "School applications") ///
	ytitle("") xtitle("Marginal effects") ///
	xsca(titlegap(5))  ///
	xline(0, lw(medthick) lc(black)) 
	graph export "figures/AllOutcomesUncond.pdf", replace
restore

******************************
*Figure 4 paper
******************************
	
preserve

use `Unconditional', clear
	graph drop _all
	
	drop if parm=="1.ID"
	gen DV2=1
	replace DV2=2 in 4/6
	replace DV2=3 in 7/9
	replace DV2=4 in 10/12
	replace DV2=5 in 13/15
	lab define DV2 1 "Composite index" 2 "ACODE score" 3 "Peer evaluation" 4 "Technocrats" 5 "School applications", modify
	lab value DV2 DV2
save `Conditional', replace
	
	drop if parm=="Difference"
	
eclplot estimate min90 max90 DV2,  horizontal supby(parm, spaceby(0.15)) ///
	rplottype(rspike) ///
	ciopts(lc(black)) ///
	estopts1(col(ebg) msiz(vlarge) m(o)) ///
	estopts2(col(gs6) msiz(vlarge) m(t)) ///
	title("", col(black)) ///
	ytitle("") xtitle("Marginal effects") ///
	xsca(titlegap(5)) xlabel(-.5(.25).75) legend( pos(6) ring(1) row(1) region(fcolor(gs15)) textfirst keygap(4) symxsize(20) symysize(*5)) ///
	xline(0, lw(medthick) lc(black)) scheme(plotplain) name(Cond1)

use `Conditional', replace 	
	keep if parm=="Difference"
	
eclplot estimate min90 max90 DV2,  horizontal supby(parm, spaceby(0.15)) ///
	rplottype(rspike) ///
	ciopts(lc(black)) ///
	estopts1(col(black) msiz(vlarge) m(s)) ///
	title("", col(black)) ///
	ytitle("") xtitle("Marginal effects") ///
	xsca(titlegap(5)) xlabel(-.5(.25).75) legend( pos(6) ring(1) row(1) region(fcolor(gs15)) textfirst keygap(4) symxsize(20) symysize(*5)) ///
	xline(0, lw(medthick) lc(black)) scheme(plotplain) name(Cond2)

	graph combine Cond1 Cond2, scheme(lean2) title("ID effects conditional on competitiveness (MoV)", size(3))	
	graph export "figures/AllOutcomesIDcond.pdf", replace
restore

********************************************************
// Ggenerate estimation figures: continuous
// Figure 7 paper
******************************************************

// continuous measure: MoV

foreach y in index_PerformanceA index_PerformanceB c_meanscore c_avescore c_technocrats c_AllApp c_CompleteApp {	
	preserve
	est restore `y'_m3a
		margins , dydx(ID) at(MarginOfVictory2011=(-.5(0.025)0)) atmeans vsquish level(90)
		parmest, label bmat(r(b)) vmat(r(V)) norestore	
		
		drop if eq=="0b.ID"
		drop if z==.
		replace eq="ID" if eq=="1.ID"
		replace label= "Margin of victory"
		drop parm  
	saveold "estimates/MoV`y'.dta", replace
	restore	

// continuous measure: Majority distance
	
preserve
	est restore `y'_m4a
		margins , dydx(ID) at(kcomp =(-.5(0.05).2)) atmeans vsquish level(90)
		parmest, label bmat(r(b)) vmat(r(V)) norestore	
		
		drop if eq=="0b.ID"
		drop if z==.
		replace eq="ID" if eq=="1.ID"
		replace label= "Majority distance"
		drop parm  
	saveold "estimates/MajorityDistance`y'.dta", replace
restore	
	}

// continuous measure: margin of victory	
tempfile fig1 fig2 fig3 fig4 fig5
preserve
	
	use "estimates/MoVindex_PerformanceA.dta", clear
	gen DV="Composite index (M)"
	bys DV: gen x = _n*0.025-0.525
	save `fig1', replace
	
	use "estimates/MoVc_avescore.dta", clear
	gen DV="Total Score" 
	bys DV: gen x = _n*0.025-0.525
	save `fig2', replace
	
	use "estimates/MoVc_meanscore.dta", clear
	gen DV="Peer evaluation" 
	bys DV: gen x = _n*0.025-0.525
	save `fig3', replace
	
	use "estimates/MoVc_CompleteApp.dta", clear
	gen DV="Grant applications" 
	bys DV: gen x = _n*0.025-0.525
	save `fig4', replace
	
	use "estimates/MoVindex_PerformanceB.dta", clear
	gen DV="Composite index (WM)"
	bys DV: gen x = _n*0.025-0.525
	save `fig5', replace
	
	use `fig1', clear
	append using `fig2'
	append using `fig3'
	append using `fig4'
	append using `fig5'

	gen min90 = estimate - stderr*1.65
	gen max90 = estimate + stderr*1.65	
	
graph drop  _all	
levelsof DV , local(dv)
local n = 1
foreach y of local dv { 
    eclplot estimate min90 max90 x if DV == "`y'" ,   ///
    rplottype(rspike) ciopts(lc(black)) ///
    estopts(col(black) msiz(small) m(o)) ///
    title("`y'", col(black)) ///
    xtitle("Margin of victory") ytitle("Marginal effects") ///
    xsca(r(-.5 0)) xlabel(-.5(.05)0) name(_`n') ///
    yline(0, lw(medthick) lc(black)) xline(-.22, lw(medthick) lp(solid) lc(red))
    local ++n
    }
	
graph combine _1 _4 _3 _5, xcommon ycommon	
graph export "figures/OutcomesMoV.pdf", replace
restore

* continuous measure: Majority distance
preserve 	
	tempfile fig11 fig12 fig13 fig14 fig15
	
	use "estimates/MajorityDistanceindex_PerformanceA.dta", clear
	gen DV="Composite index (M)"
	bys DV: gen x = _n*0.05-0.55
	save `fig11', replace
	
	use "estimates/MajorityDistancec_avescore.dta", clear
	gen DV="Total Score" 
	bys DV: gen x = _n*0.05-0.55
	save `fig12', replace
	
	use "estimates/MajorityDistancec_meanscore.dta", clear
	gen DV="Peer evaluation" 
	bys DV: gen x = _n*0.05-0.55
	save `fig13', replace
	
	use "estimates/MajorityDistancec_CompleteApp.dta", clear
	gen DV="Grant applications" 
	bys DV: gen x = _n*0.05-0.55
	save `fig14', replace
	
	use "estimates/MajorityDistanceindex_PerformanceB.dta", clear
	gen DV="Composite index (WM)"
	bys DV: gen x = _n*0.05-0.55
	save `fig15', replace
	
	use `fig11', clear
	append using `fig12'
	append using `fig13'
	append using `fig14'
	append using `fig15'

	gen min90 = estimate - stderr*1.65
	gen max90 = estimate + stderr*1.65
	
*graph drop  _all	
levelsof DV , local(dv)
local n = 11
foreach y of local dv { 
    eclplot estimate min90 max90 x if DV == "`y'" ,   ///
    rplottype(rspike) ciopts(lc(black)) ///
    estopts(col(black) msiz(small) m(o)) ///
    title("`y'", col(black)) ///
    xtitle("Majority distance") ytitle("Marginal effects") ///
    xsca(r(-.5 .2)) xlabel(-.5(.1).2) name(_`n') ///
    yline(0, lw(medthick) lc(black)) xline(-.08, lw(medthick) lp(solid) lc(red))
    local ++n
    }

**************************
*Figure 8 paper
**************************
	
graph combine _11 _14 _13 _15, xcommon ycommon	
graph export "figures/OutcomesMD.pdf", replace

**************************
*Figure 24 online appendix
**************************

graph combine _1 _2 _11 _12, ycommon	
graph export "figures/OutcomesMoVMD.pdf", replace
restore

**************************
*Figure 25 online appendix
**************************
interflex index_PerformanceA ID MarginOfVictory2011, cut(-.2 -.1) ylabel(Perfromance index) dlabel(ID) xlabel(Margin of victory)
graph export "figures/interflexMoV.pdf", replace


// Figure 23 online appendix
preserve

use "estimates/ConditionalEstimatesindex_PerformanceAcomp.dta", clear 
append using "estimates/ConditionalEstimatesindex_PerformanceBcomp.dta"
append using "estimates/ConditionalEstimatesindex_PerformanceAkcompB.dta"
append using "estimates/ConditionalEstimatesindex_PerformanceBkcompB.dta"
drop if parm=="1.ID"
drop model eq

gen moderator=1
replace moderator=2 in 7/12
replace moderator=2 in 31/36

gen model=1 if DV=="index_PerformanceA" & moderator==1
replace model=2 if DV=="index_PerformanceB" & moderator==1
replace model=3 if DV=="index_PerformanceA" & moderator==2
replace model=4 if DV=="index_PerformanceB" & moderator==2
	lab define model 1 "Mean index-MoV" 2 "Weighted index-MoV" 3 "Mean index-MD" 4 "Weighted index-MD", modify 
	lab value model model 
	tab model

	gen min90 = estimate - stderr*1.65
	gen max90 = estimate + stderr*1.65

	eclplot estimate min90 max90 model,  horizontal supby(parm, spaceby(0.12)) ///
	rplottype(rspike) ///
	ciopts(lc(black)) ///
	estopts1(col(ebg) msiz(vlarge) m(o)) ///
	estopts2(col(gs6) msiz(vlarge) m(t)) ///
	estopts3(col(black) msiz(vlarge) m(s)) ///
	title("ID effects conditional on competitiveness: robustness", col(black)) ///
	ytitle("") xtitle("Marginal effects") yscale(r(1 4)) ylab(1(1) 4) ///
	xsca(titlegap(5)) xlabel(-.5(.25)1) legend( pos(6) ring(1) row(1) region(fcolor(gs15)) textfirst keygap(4) symxsize(20) symysize(*5)) ///
	xline(0, lw(medthick) lc(black)) scheme(plotplainblind)
graph export "figures/OutcomesMoVMDBIN.pdf", replace

restore

********************************************************
* Effects conditional on high/low initial performance 
* Table 11 Online appendix
******************************************************
		
	areg index_PerformanceA ID##HighP if sample==1, abs(distid) vce(bs, rep(1000) seed(07182017)) cl(distid)
		estadd local control ""
		estadd local district "X"
		estimate store HighP_m1
		
	areg index_PerformanceA ID##HighP $controls if sample==1, abs(distid) vce(bs, rep(1000) seed(07182017)) cl(distid)
		estadd local control "X"
		estadd local district "X"
		estimate store HighP_m2

	areg index_PerformanceA ID##c.initial_score if sample==1, abs(distid) vce(bs, rep(1000) seed(07182017)) cl(distid)
		estadd local control ""
		estadd local district "X"
		estimate store HighP_m3
		
	areg index_PerformanceA ID##c.initial_score $controls if sample==1, abs(distid) vce(bs, rep(1000) seed(07182017)) cl(distid)
		estadd local control "X"
		estadd local district "X"
		estimate store HighP_m4
		
	# delimit ; 
	esttab  HighP_m3 HighP_m4 HighP_m1 HighP_m2
	using "tables/InitialHighScore.tex", replace
			keep (1.ID  1.HighP 1.ID#1.HighP initial_score 1.ID#c.initial_score _cons)
			order(1.ID  1.HighP 1.ID#1.HighP initial_score 1.ID#c.initial_score _cons)
			cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par))
			starlevels(* .10 ** .05 *** .01) 					
			mgroups("\textbf{Continuous}" "\textbf{Binary}", pattern(1 0 1 0)
			span prefix(\multicolumn{@span}{c}{) suffix(}) erepeat(\cmidrule(lr){@span})) nomtitles
			varlabels(1.ID "ID"
					  1.HighP "High Score"
					  1.ID#1.HighP "ID*High Score"
					  initial_score "Baseline score"
					  1.ID#c.initial_score "ID*baseline score"
					_cons "Constant")
			stats(district control N, labels("District FE" "Controls" "N" )
			fmt(0 0)) collabels(none)	label booktabs nonotes;
	#delimit cr	
		

********************************************************
// Effects conditional on ELF
// Table 4 paper
******************************************************
gl controls2 NRM SWC Edu SMS FirstTerm NOfChallengers2011 lpop constit_poverty  FirstTerm_miss NOfChallengers2011_miss lpop_miss constit_poverty_miss constit_hhi_miss 

set more off		
	areg index_PerformanceA ID##c.constit_hhi $controls2 if sample==1, abs(distid) vce(bs, rep(1000) seed(07182017)) cl(distid)
		estadd local control "X"
		estadd local district "X"
		estimate store hhi_m1

	areg index_PerformanceA ID##c.constit_hhi $controls2 if sample==1 & comp==0, abs(distid) vce(bs, rep(1000) seed(07182017)) cl(distid)
		estadd local control "X"
		estadd local district "X"
		estimate store hhi_m2
		
	areg index_PerformanceA ID##c.constit_hhi $controls2 if sample==1 & comp==1, abs(distid) vce(bs, rep(1000) seed(07182017)) cl(distid)
		estadd local control "X"
		estadd local district "X"
		estimate store hhi_m3
		
*Make table 4 Paper;
	# delimit ; 
	esttab  hhi_m1 hhi_m2 hhi_m3
	using "tables/HHI.tex", replace
			keep (1.ID  constit_hhi 1.ID#c.constit_hhi _cons)
			order(1.ID  constit_hhi 1.ID#c.constit_hhi _cons)
			cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par))
			starlevels(* .10 ** .05 *** .01) 					
			mgroups("\textbf{Full Sample}" "\textbf{Less competitive}" "\textbf{More competitive}" , pattern(1  1 1)
			span prefix(\multicolumn{@span}{c}{) suffix(}) erepeat(\cmidrule(lr){@span})) nomtitles
			varlabels(1.ID "ID"
					  constit_hhi "ELF"
					  1.ID#c.constit_hhi "ID*ELF"
					_cons "Constant")
			stats(district control N, labels("District FE" "Controls" "N" )
			fmt(0 0)) collabels(none)	label booktabs nonotes;
	#delimit cr	


********************************************************
* Robustness to clustering at special councilor and reweighting obs
******************************************************	
	
set more off
areg index_PerformanceA ID##c.MarginOfVictory2011##c.MarginOfVictory2011 $controls if sample==1 [pw= IPW], abs(distid) cl(swc_id)
margins , dydx(ID) at(MarginOfVictory2011=(-.5(0.025)0)) atmeans vsquish level(90)
marginsplot

areg index_PerformanceA ID##comp $controls if sample==1 [pw=IPW], abs(distid) cl(swc_id)
margins, dydx(ID) over(comp)

