clear
set more off

cap program drop rd_plot
program rd_plot
	args out titlex titley bw inputfile period invars
	
	**reg lines & SEs
	use `inputfile', clear
	local wt=`bw'*100
	
	reg `out' `invars' [aw=oweight`wt'], nocons
	predict resid, resid
	
	lpoly resid min_dist if (min_dist>0 & min_dist<`bw') [aw=oweight`wt'], kernel(rectangle) bwidth(`bw') degree(1)  generate(x s) se(se) nograph 
	keep x s se 
	drop if x==.
	save RD, replace

	use `inputfile', clear
	local wt=`bw'*100
	
	reg `out' `invars' [aw=oweight`wt'], nocons
	predict resid, resid
		
	lpoly resid min_dist if (min_dist<0 & min_dist>-`bw') [aw=oweight`wt'], kernel(rectangle) bwidth(`bw') degree(1)  generate(x s) se(se) nograph
	keep x s se 
	drop if x==.
	append using RD
	
	g ciplus=s+1.96*se
	g ciminus=s-1.96*se
	keep if abs(x)<`bw'
	save RD, replace
	
	**bin data ***all discontinuities
	
	use `inputfile', replace
		
	local increment = `bw'/10
	
	gen bin10=.
	foreach X of num 0(`increment')`bw' {
		di "`X'"
		replace bin=(-`X'+(`increment'/2)) if (min_dist>=-`X' & min_dist<(-`X'+`increment') & min_dist<0)
		replace bin=(`X'+(`increment'/2)) if (min_dist>`X' & min_dist<=(`X'+`increment'))
	}
	tab bin10
	drop if bin10==.

	reg `out' `invars' [aw=oweight`wt'], nocons
	predict resid, resid
	
	collapse (mean) resid min_dist , by(bin10)
	
	append using RD
	
	local biginc= `increment'*2
	
	twoway (connected s x if x>0, sort msymbol(none) clcolor(black) clpat(solid) clwidth(medthick)) (connected ciplus x if x>0, sort msymbol(none) clcolor(black) clpat(shortdash) clwidth(thin)) (connected ciminus x if x>0, sort msymbol(none) clcolor(black) clpat(shortdash) clwidth(thin)) (connected s x if x<0, sort msymbol(none) clcolor(black) clpat(solid) clwidth(medthick)) (connected ciplus x if x<0, sort msymbol(none) clcolor(black) clpat(shortdash) clwidth(thin)) (connected ciminus x if x<0, sort msymbol(none) clcolor(black) clpat(shortdash) clwidth(thin))  (scatter  resid min_dist, sort msize(med)xline(0) mcolor(black)),  legend(off) graphregion(color(white)) xtitle(`titlex')  ytitle(`titley') xlabel(-`bw'(`biginc')`bw') xsc(r(-`bw' `bw'))  xline(0, lpattern(shortdash) lc(black)) ylab(,nogrid)  name(`out',replace)
end

***************
**First stage
***************

do firstclose .2 1 1
rd_plot fr_strikes_mean "distance to threshold in period t" "bombing in period t+1" .2 firstclose_post 1 "ab bc cd de"
graph export bomb_immed_noc.pdf, replace

do firstclose .2 1 12
rd_plot fr_strikes_mean "distance to threshold in period t" "bombing until U.S. withdrawal" .2 firstclose_post 12 "ab bc cd de"
graph export bomb_cum_noc.pdf, replace

****************************
**First stage placebos
****************************

do plac_fs0 .2 
rd_plot fr_strikes_mean "distance to threshold in period t" "bombing in period t" .2 fs_plac0 1 "ab bc cd de"
graph export fs_plac0.pdf, replace

do plac_fs .2 1 1
rd_plot fr_strikes_mean "distance to threshold in period t" "bombing in period t-1" .2 fs_plac 1 "ab bc cd de"
graph export fs_immedplac.pdf, replace

do plac_fs .2 1 16
rd_plot fr_strikes_mean "distance to threshold in period t" "pre-period bombing" .2 fs_plac 12 "ab bc cd de"
graph export fs_cumplac.pdf, replace

***************************
**Outcomes 
****************************

do firstclose .2 1 12

foreach V in en_pres vc_infr_vilg village_comm prim_access civic_org_part fw_init  {

	rd_plot `V' "distance to threshold in period t" "" .2 firstclose_post 12 "ab bc cd de"
	graph export `V'_cum_noc.pdf, replace
}


****************************
**Predicted bombing placebo plots
****************************

do firstclose .2 1 1
reg fr_strikes_mean vmb22-vt54
predict bomb_pred, xb
save tempplac, replace
rd_plot bomb_pred "distance to threshold in period t" "predicted bombing" .2 tempplac 1 "ab bc cd de"
graph export predict_bomb_immed.pdf, replace

**Predicted bombing
do firstclose .2 1 12
reg fr_strikes_mean vmb22-vt54
predict bomb_pred, xb
save tempplac, replace
rd_plot bomb_pred "distance to threshold in period t" "predicted bombing" .2 tempplac 12 "ab bc cd de"
graph export predict_bomb_cum.pdf, replace

****************************
**1969 placebos
****************************

do plac69 .2 1
rd_plot fr_strikes_mean "distance to threshold in period t" "bombing in period t-1" .2 plac69_1 1 "ab bc cd de"
graph export immedplac69.pdf, replace

do plac69 .2 14
rd_plot fr_strikes_mean "distance to threshold in period t" "pre-period bombing" .2 plac69_14 14 "ab bc cd de"
graph export cumplac69.pdf, replace

****************************
***By period
****************************

global counter 0

cap program drop dynam
program dynam
	args datafile V yr dropvar
	use `datafile', clear
	
	if `yr'==0 {
		capture drop `dropvar'
		di "`yr'"
	}

	reg `V' below md_* ab bc cd de i.qdate vmb22-vt54 [aw=oweight20], nocons cluster(villageid)	

	*save output
	g indexnum = _n 
	keep if indexnum==1
	keep indexnum
	g depvar="`V'"
	g period=`yr'
	g coeff=_b[below]
	g se=_se[below]
	g dfile= "`datafile'"
	drop ind
	global counter=$counter+1
	di "$counter" 
	save temp/f$counter, replace
end		

foreach Y of num -2/8 {	
	do balancepanel .2 `Y' `Y' 
	dynam firstclose_post fr_strikes_mean `Y' 		
}

use temp/f1, clear
forvalues i=2/$counter {
	append using temp/F`i'
}			

g cp5=coeff+1.96*se
g cn5=coeff-1.96*se

g cp10=coeff+1.65*se
g cn10=coeff-1.65*se

replace period=-period if dfile=="placout"
replace period=-period if dfile=="fs_plac"

outsheet using bombing_balanced_dynamics.csv, comma replace


