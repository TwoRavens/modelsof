**********************************************************
* estimate ID effect on concilor scorecard
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

******************************************************
* merge-in councilor covariates
******************************************************	
merge 1:1 id using "Councilors_covariates_v2.dta"
	drop _merge

********************************************************
* define controls
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
	 
* define sample
	gen sample=0
	replace sample=1 if NRM!=. & SWC!=. & Edu!=. & SMS!=. & FirstTerm!=. & NOfChallengers2011!=. & lpop!=. & constit_poverty!=. & constit_hhi!=. & competitive!=.

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
	
preserve

collapse total_score_2011_2012 total_score_2012_2013 total_score_2013_2014 total_score_2014_2015, by(ID HighP competitive)
drop if HighP==.
lab define initial 0 "Low" 1 "High" , modify
lab value HighP initial
lab var total_score_2011_2012 "Baseline score"
lab var total_score_2012_2013 "2012-13 score"
lab var total_score_2013_2014 "2013-14 score"
lab var total_score_2014_2015 "2014-15 score"

******************************************************
* Figure 26 Supplementary information	
*****************************************************

graph bar total_score_2011_2012 total_score_2012_2013 total_score_2013_2014, by(HighP) over(ID) over(competitive) ///
yscale(r(0 70)) ylabel(0(10)70) scheme(plotplainblind) legend(label(1 "Baseline score") label(2 "2012-13 score") label(3 "2013-14 score") size(small) col(3)) 
graph export "figures/HighPID.pdf", replace
restore
			
******************************************************
* Reshape into long format	
*****************************************************

reshape long total_score_ lr_subtotal_ elect_subtotal_  monitor_subtotal_ llg_, i(id) j(wave) string
	ren total_score_ total
	ren lr_subtotal_ lr
	ren elect_subtotal_ elect 
	ren monitor_subtotal_ monitor
	ren llg_ llg

	encode wave, gen(year)
	gen post=year>1
	lab var post "Post treatment period"
	recode year(1=0)(2=1)(3=2)(4=3), gen(period)

preserve
keep total year ID competitive 
collapse total, by(year ID competitive)
drop if competitive==.
saveold "estimates/ScoresByTreatment.dta", replace
restore	
	
******************************************************
******************************************************
* Regressions 
******************************************************
******************************************************
gen IDP=ID*post
xtset id year
local dv total lr elect monitor llg

	forvalues i=1(1)10 {
	foreach y in `dv' {
	foreach mod in kcompB competitive{
	tempfile `y'`mod'`i'
	}
	}
	}
	
*********************************************************************
// all years (including 2014-2015 that had no intense dissimination)
**********************************************************************
set more off

foreach y in `dv' {
foreach mod in kcompB competitive{

reghdfe `y' IDP if sample==1, abs(id year) cl(id)
	estadd local period "X"
	est store `y'_m1
	margins, dydx(IDP) post
	parmest, label bmat(r(b)) vmat(r(V)) saving(``y'`mod'1') 

reghdfe `y' IDP##`mod' ID##`mod' post##`mod' if sample==1, abs(id year) cl(id)
	estadd local period "X"
	est store `y'`mod'_m2
	margins, dydx(IDP) over(`mod') post
	parmest, label bmat(r(b)) vmat(r(V)) saving(``y'`mod'2') 	

reghdfe `y' IDP if sample==1 & `mod'==0, abs(id year) cl(id)
	estadd local period "X"
	est store `y'`mod'_m3
	margins, dydx(IDP) post
	parmest, label bmat(r(b)) vmat(r(V)) saving(``y'`mod'3') 
	
reghdfe `y' IDP if sample==1 & `mod'==1, abs(id year) cl(id)
	estadd local period "X"
	est store `y'`mod'_m4
	margins, dydx(IDP) post
	parmest, label bmat(r(b)) vmat(r(V)) saving(``y'`mod'4') 

reghdfe `y' c.IDP##c.MarginOfVictory2011 ID#c.MarginOfVictory2011 post#c.MarginOfVictory2011 if sample==1, abs(id year) cl(id)
	estadd local period "X"
	est store `y'_m5	

reghdfe `y' c.IDP##c.kcomp ID#c.kcomp post#c.kcomp if sample==1, abs(id year) cl(id)
	estadd local period "X"
	est store `y'_m6	

******************************************************	
// Excluding 2014-2015 that had no intense dissimination)
******************************************************

reghdfe `y' IDP if sample==1 & year!=4, abs(id year) cl(id)
estadd local period ""
	est store `y'_m7
	margins, dydx(IDP) post
	parmest, label bmat(r(b)) vmat(r(V)) saving(``y'`mod'5') 
			
reghdfe `y' IDP##`mod' ID##`mod' post##`mod' if sample==1 & year!=4, abs(id year) cl(id)
	estadd local period ""
	est store `y'`mod'_m8
	margins, dydx(IDP) over(`mod') post
	parmest, label bmat(r(b)) vmat(r(V)) saving(``y'`mod'6')
	est restore `y'`mod'_m8
	margins r.IDP, over(r.`mod') post
	parmest, label bmat(r(b)) vmat(r(V)) saving(``y'`mod'7')
	
reghdfe `y' IDP if sample==1 & `mod'==0 & year!=4, abs(id year) cl(id)
	estadd local period ""
	est store `y'`mod'_m9
	margins, dydx(IDP) post
	parmest, label bmat(r(b)) vmat(r(V)) saving(``y'`mod'8') 
	
reghdfe `y' IDP if sample==1 & `mod'==1 & year!=4, abs(id year) cl(id)
	estadd local period ""
	est store `y'`mod'_m10
	margins, dydx(IDP) post
	parmest, label bmat(r(b)) vmat(r(V)) saving(``y'`mod'9') 
	
reghdfe `y' c.IDP##c.MarginOfVictory2011 ID#c.MarginOfVictory2011 post#c.MarginOfVictory2011 if sample==1 & year!=4, abs(id year) cl(id)
	estadd local period ""
	est store `y'_m11	
reghdfe `y' c.IDP##c.kcomp ID#c.kcomp post#c.kcomp if sample==1 & year!=4, abs(id year) cl(id)
	estadd local period ""
	est store `y'_m12

}
}

******************************************************
// Table 12 online appendix;
******************************************************

# delimit ; 
esttab  total_m1 total_m7 lr_m1 lr_m7  
		elect_m1 elect_m7 monitor_m1 monitor_m7 llg_m1 llg_m7  
using "tables/ScorecardUnconditional.tex",
		cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par))
		starlevels(* .10 ** .05 *** .01) 					
		mgroups("\textbf{Total Score}" "\textbf{Legislative role}" "\textbf{Contact electorate}" "\textbf{Monitor services}" "\textbf{Local govs}", pattern(1 0 1 0 1 0 1 0 1 0)
		span prefix(\multicolumn{@span}{c}{) suffix(}) erepeat(\cmidrule(lr){@span})) nomtitles
		varlabels(IDP "ID*Post" _cons "Constant")
		stats(period N, labels("Includes 2014-15" "N")
		fmt(0 0)) collabels(none) label booktabs nonotes
		replace;
#delimit cr
	
******************************************************
// Table 13 online appendix;
// Panel 1
******************************************************

# delimit ; 
esttab  totalcompetitive_m2 totalcompetitive_m8 lrcompetitive_m2 lrcompetitive_m8  
		electcompetitive_m2 electcompetitive_m8 monitorcompetitive_m2 monitorcompetitive_m8 
		llgcompetitive_m2 llgcompetitive_m8 		
using "tables/ScorecardConditionalcompetitive.tex",
		keep( 1.IDP 1.post#1.competitive 1.IDP#1.competitive)
		order(1.IDP 1.post#1.competitive 1.IDP#1.competitive)
		cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par))
		starlevels(* .10 ** .05 *** .01) 					
		mgroups("\textbf{Total Score}" "\textbf{Legislative role}" "\textbf{Contact electorate}" "\textbf{Monitor services}" "\textbf{Local govs}", pattern(1 0 1 0 1 0 1 0 1 0)
		span prefix(\multicolumn{@span}{c}{) suffix(}) erepeat(\cmidrule(lr){@span})) nomtitles
		varlabels(1.IDP "ID*Competitive (MoV)"
				  1.post#1.competitive "Post*Competitive (MoV)" 
				  1.IDP#1.competitive "ID*Post*Competitive (MoV)")
		stats(period N, labels("Includes 2014-15" "N")
		fmt(0 0)) collabels(none) label booktabs nonotes
		replace;
#delimit cr

******************************************************
// Table 13 online appendix;
// Panel 2
******************************************************

# delimit ; 
esttab  totalkcompB_m2 totalkcompB_m8 lrkcompB_m2 lrkcompB_m8  
		electkcompB_m2 electkcompB_m8 monitorkcompB_m2 monitorkcompB_m8 
		llgkcompB_m2 llgkcompB_m8 		
using "tables/ScorecardConditionalkcompB.tex",
		keep( 1.IDP 1.post#1.kcompB 1.IDP#1.kcompB)
		order(1.IDP 1.post#1.kcompB 1.IDP#1.kcompB)
		cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par))
		starlevels(* .10 ** .05 *** .01) 					
		mgroups("\textbf{Total Score}" "\textbf{Legislative role}" "\textbf{Contact electorate}" "\textbf{Monitor services}" "\textbf{Local govs}", pattern(1 0 1 0 1 0 1 0 1 0)
		span prefix(\multicolumn{@span}{c}{) suffix(}) erepeat(\cmidrule(lr){@span})) nomtitles
		varlabels(1.IDP "ID*Competitive (MD)"
				  1.post#1.kcompB "Post*Competitive (MD)" 
				  1.IDP#1.kcompB "ID*Post*Competitive (MD)")
		stats(period N, labels("Includes 2014-15" "N")
		fmt(0 0)) collabels(none) label booktabs nonotes
		replace;
#delimit cr

******************************************************	
// Scorecard components (excluding 2014-2015)
// Figure 27 online appendix and Figure 5 Paper
******************************************************
preserve 
use `totalcompetitive6', clear
	append using `totalcompetitive7'
	append using `lrcompetitive6'
	append using `lrcompetitive7'
	append using `electcompetitive6'
	append using `electcompetitive7'
	append using `monitorcompetitive6'
	append using `monitorcompetitive7'
	append using `llgcompetitive6'
	append using `llgcompetitive7'
		
	replace label="Total score" in 1/3
	replace label="Legislative role" in 4/6
	replace label="Contact electorate" in 7/9
	replace label="Monitoring services" in 10/12
	replace label="Local government" in 13/15
	
	gen model=1
	replace model=2 if label=="Legislative role"
	replace model=3 if label=="Contact electorate"
	replace model=4 if label=="Monitoring services"
	replace model=5 if label=="Local government"
		
	replace parm="Competition: Low" if parm=="0.competitive"
	replace parm="Competition: High" if parm=="1.competitive"
	replace parm="Difference" if parm=="r1vs0.competitive#r1vs0.IDP"

	gen min90 = estimate - stderr*1.65
	gen max90 = estimate + stderr*1.65
	
	tempfile Conditional
	save `Conditional', replace
	
	drop if parm=="Difference"
	
		eclplot estimate min90 max90 model,  horizontal supby(parm, spaceby(0.15)) ///
		rplottype(rspike) ///
		ciopts(lc(black)) ///
		estopts1(col(ebg) msiz(vlarge) m(o)) ///
		estopts2(col(gs6) msiz(vlarge) m(t)) ///
		title("") ylabel(1 "Total score" 2 "Legislative role" 3 "Contact electorate" 4 "Monitoring services" 5 "Local government") ///
		ytitle("") xtitle("Marginal effects") xscale(r(-8 16)) xlabel (-8(4)16) ///
		legend( pos(6) ring(1) row(1) region(fcolor(gs15)) textfirst keygap(4) symxsize(20) symysize(*5)) ///
		xline(0, lw(medthick) lc(black)) name(Cond1)
 
 use `Conditional', clear
 keep if parm=="Difference"
 
		eclplot estimate min90 max90 model,  horizontal supby(parm, spaceby(0.15)) ///
		rplottype(rspike) ///
		ciopts(lc(black)) ///
		estopts1(col(black) msiz(large) m(s)) ///
		title("") ylabel(1 "Total score" 2 "Legislative role" 3 "Contact electorate" 4 "Monitoring services" 5 "Local government") ///
		ytitle("") xtitle("Marginal effects") xscale(r(-8 16)) xlabel (-8(4)16) ///
		legend( pos(6) ring(1) row(1) region(fcolor(gs15)) textfirst keygap(4) symxsize(20) symysize(*5)) ///
		xline(0, lw(medthick) lc(black)) name(Cond2)		

		graph combine Cond1 Cond2, scheme(lean2) title("ID conditional effect on ACODE scorecard component", col(black) size(3))	
		graph export "figures/ScoresAllOutCond.pdf", replace	

restore	


******************************************************	
// by year : Figure 6 Paper
******************************************************
set more off
graph drop  _all
tempfile kcompB1 kcompB2 competitive1 competitive2

foreach mod in kcompB competitive{
reghdfe total ID##period##`mod' if sample==1, abs(id) cl(id)	
	est store `mod'_m12

	margins, dydx(ID) over(`mod' period) post
	parmest, label bmat(r(b)) vmat(r(V)) saving(``mod'1')
	
	est restore `mod'_m12
	margins r.ID, over(r.`mod' r.period) post
	parmest, label bmat(r(b)) vmat(r(V)) saving(``mod'2')
	}

preserve
	use `competitive1', clear
	append using `competitive2'
	drop if parm=="0.competitive#0.period" | parm=="1.competitive#0.period"
	replace label="Competition: L" if parm=="0.competitive#1.period" | parm=="0.competitive#2.period" | parm=="0.competitive#3.period"
	replace label="Competition: H" if parm=="1.competitive#1.period" | parm=="1.competitive#2.period" | parm=="1.competitive#3.period"
	replace label ="Difference" if parm=="r1vs0.competitive#r1vs0.period#r1vs0.ID" | parm=="r1vs0.competitive#r2vs0.period#r1vs0.ID" | parm=="r1vs0.competitive#r3vs0.period#r1vs0.ID"

	gen period=1
	replace period=2 if parm=="0.competitive#2.period" | parm=="1.competitive#2.period" | parm=="r1vs0.competitive#r2vs0.period#r1vs0.ID"
	replace period=3 if parm=="0.competitive#3.period" | parm=="1.competitive#3.period" | parm=="r1vs0.competitive#r3vs0.period#r1vs0.ID"
	lab define period 1 "2013-2014" 2 "2013-2014" 3 "2014-2015", modify
	lab value period period
	
	gen min90 = estimate - stderr*1.65
	gen max90 = estimate + stderr*1.65
	
		eclplot estimate min90 max90 period,  horizontal supby(label, spaceby(0.15)) ///
		rplottype(rspike) ///
		ciopts(lc(black)) ///
		estopts1(col(ebg) msiz(vlarge) m(o)) ///
		estopts2(col(gs6) msiz(vlarge) m(t)) ///
		estopts3(col(black) msiz(vlarge) m(dh)) ///
		title("Margin of Victory", col(black) size(3)) ///
		ytitle("") xtitle("Marginal effects") ylabel(1(1)3) ///
		xsca(titlegap(5)) xlabel(-20(5)20) legend( pos(6) ring(1) row(1) region(fcolor(gs15)) textfirst keygap(4) symxsize(20) symysize(*5)) ///
		xline(0, lw(medthick) lc(black)) scheme(plotplain) name(_1)		
graph export "figures/ScoresEffectByYear1.pdf", replace
restore

preserve
	use `kcompB1', clear
	append using `kcompB2'
	drop if parm=="0.kcompB#0.period" | parm=="1.kcompB#0.period"
	replace label="Competition: L" if parm=="0.kcompB#1.period" | parm=="0.kcompB#2.period" | parm=="0.kcompB#3.period"
	replace label="Competition: H" if parm=="1.kcompB#1.period" | parm=="1.kcompB#2.period" | parm=="1.kcompB#3.period"
	replace label ="Difference" if parm=="r1vs0.kcompB#r1vs0.period#r1vs0.ID" | parm=="r1vs0.kcompB#r2vs0.period#r1vs0.ID" | parm=="r1vs0.kcompB#r3vs0.period#r1vs0.ID"

	gen period=1
	replace period=2 if parm=="0.kcompB#2.period" | parm=="1.kcompB#2.period" | parm=="r1vs0.kcompB#r2vs0.period#r1vs0.ID"
	replace period=3 if parm=="0.kcompB#3.period" | parm=="1.kcompB#3.period" | parm=="r1vs0.kcompB#r3vs0.period#r1vs0.ID"
	lab define period 1 "2013-2014" 2 "2013-2014" 3 "2014-2015", modify
	lab value period period
	
	gen min90 = estimate - stderr*1.65
	gen max90 = estimate + stderr*1.65
	
		eclplot estimate min90 max90 period,  horizontal supby(label, spaceby(0.15)) ///
		rplottype(rspike) ///
		ciopts(lc(black)) ///
		estopts1(col(ebg) msiz(vlarge) m(o)) ///
		estopts2(col(gs6) msiz(vlarge) m(t)) ///
		estopts3(col(black) msiz(vlarge) m(dh)) ///
		title("Majority distance", col(black) size(3)) ///
		ytitle("") xtitle("Marginal effects") ylabel(1(1)3) ///
		xsca(titlegap(5)) xlabel(-20(5)20) legend( pos(6) ring(1) row(1) region(fcolor(gs15)) textfirst keygap(4) symxsize(20) symysize(*5)) ///
		xline(0, lw(medthick) lc(black)) scheme(plotplain)	name(_2)	
graph export "figures/ScoresEffectByYear2.pdf", replace
restore

graph combine _1 _2, title("ID effects on scorecard by year", col(black))
graph export "figures/ScoresEffectByYear3.pdf", replace
