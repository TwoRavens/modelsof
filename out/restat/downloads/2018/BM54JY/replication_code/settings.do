//	Stores coefficients for the effects on the sample average

tempfile fileusing
use eop_bootfile_intgm_rep, clear
keep intg11pt intg11pt_faminc1  repl
rename intg11pt intgm11pt
rename intg11pt_faminc1 intgm11pt_faminc1
save `fileusing', replace

//	Stores the pdf estimates and quantiles for the groups at every bootstrap iteration

tempfile fileusing_pdf
use eop_bootfile_dec_rep, clear
gen id = repl*1000 + p
keep  steps repl p group id intgpdf*
foreach i of numlist 1(1)10 {
	replace intgpdf`i' = . if group!=`i'
	gen steps`i' = steps if group==`i'
}
drop steps 
rename intgpdf intgpdf_tot
reshape wide steps* intgpdf*, i(id) j(group)
foreach i of numlist 1(1)9 {
	local x = `i'*10 + `i'
	rename intgpdf`x' intg`i'_p1t1wy0609_pdf
	rename steps`x' intg`i'_p1t1wy0609
}
rename intgpdf1010 intg10_p1t1wy0609_pdf
rename steps1010 intg10_p1t1wy0609
drop intgpdf* steps*
rename p quantile
save `fileusing_pdf', replace

//	Saves the pdf estimates to be used in every iteration. These estimates are defined for every group, an alternative for the step above

use intg_distwy0609faminc_rep, clear
tempfile fileuse2
duplicates drop quantile repl, force
save `fileuse2', replace

//	Stores the father income distribution

use eop_bootfile_intg_rep, clear
sort repl quantile
qui sum repl
local repmax = r(max)
qui sum quantile if repl==1
local qmax = r(max)
keep quantile repl intg1_p1t1faminc*
foreach P of numlist 1(1)4 {
	mkmat   intg1_p1t1faminc`P' if repl==0, mat(FI_`P') nomis
}
tempfile fileuse3
save `fileuse3', replace

//	Uses the main data source

use eop_bootfile_dec_rep, clear
sort repl group p
gen id = repl*1000 + p
rename p quantile
keep  intg4_pt* intg4_pt_faminc1* intg4_pt_faminc2* intg4_pt_faminc3* intg4_pt_faminc4* repl quantile group  id
reshape wide intg4_pt intg4_pt_faminc1 intg4_pt_faminc2 intg4_pt_faminc3 intg4_pt_faminc4, i(id) j(group)

foreach var of varlist intg4_pt* intg4_pt_faminc1* intg4_pt_faminc2* intg4_pt_faminc3* intg4_pt_faminc4* {
	replace `var' = 0 if `var'==.
}

*	Rename variables to set variables after a merge

merge m:1 repl using `fileusing', nogen
merge 1:1 repl quantile using `fileusing_pdf', nogen

drop if id==.

foreach i of numlist 1(1)10 {
	foreach x of numlist 1(1)4 {
		rename intg4_pt_faminc`x'`i' intg41pt_faminc`x'`i'
	}
	rename intg4_pt`i' intg41pt`i'
}

foreach G of numlist 1(1)10 {
	mkmat  intg`G'_p1t1wy0609_pdf if repl==0, mat(fgroup_`G') nomis
}

*	Construct QTE conditional on percentiles of the father income x
foreach x of numlist 1(1)99 {
	foreach P of numlist 1(1)4 {
		local fi_`x'_`P' = FI_`P'[`x',1]
	}
	foreach G of numlist 1(1)10 {
		if `x'/10>`G'-1 & `x'/10<=`G' {
			gen rif_ez_i`x' =  intg41pt`G' + intg41pt_faminc1`G'*`fi_`x'_1' + intg41pt_faminc2`G'*`fi_`x'_2' + intg41pt_faminc3`G'*`fi_`x'_3' + intg41pt_faminc4`G'*`fi_`x'_4'
			replace rif_ez_i`x' = rif_ez_i`x' / intg`G'_p1t1wy0609_pdf
		}
	}
	gen rifm_ez_i`x' = intgm11pt + intgm11pt_faminc1*`fi_`x'_1' 
	gen QTE`x' = .
	gen seQTE`x' = .
	gen ATEf`x' = .
	gen seATEf`x' = .
	foreach y of numlist 1(1)`qmax' {
		sum rif_ez_i`x' if quantile==`y' & repl>=1
		local m = r(mean)
		local se = r(sd)
		replace QTE`x' = `m' if quantile==`y' & repl==0
		replace seQTE`x' = `se' if quantile==`y' & repl==0
	}
	sum rifm_ez_i`x' if quantile==1 & repl>=1
	local m = r(mean)
	local se = r(sd)
	replace ATEf`x' = `m' if quantile==1 & repl==0
	replace seATEf`x' = `se' if quantile==1 & repl==0		
}

keep QTE* seQTE* ATEf* seATEf* quantile repl

keep if QTE1!=.
save data_graph.dta, replace


***********************************************************
*	GRAPH1 : INTERGENERATIONAL
***********************************************************

local tvalue = 2.33
reshape long QTE seQTE, i(quantile) j(quantiles_faminc)
sort quantiles_faminc quantile
gen QTE_signif = (abs(QTE/seQTE)>=`tvalue')
label var quantiles_faminc "Percentailes of family income"

local if "if quantiles_faminc>=5 & quantiles_faminc<=95 & QTE<=60000 & QTE>=-60000"
local color1 "black"
local color2 "red"
local color3 "gs9"
local opt "	ytitle(, color(black)) xtitle(, color(black)) xscale(range(0 99)) xlabel(0(10)99, labcolor(black)) legend(on rows(2) size(small) color(black) position(6)) graphregion(fcolor(white) lcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))"
local opt2 "ytitle("Earnings (NOK)", size(small) color(black)) ylabel(-60000(30000)60000, labels labsize(small) labcolor(black)) yline(0, lwidth(medthin) lpattern(solid) lcolor(black)) xtitle("Percentiles of family income", size(small) color(black)) xscale(range(0 99)) xlabel(0(10)99, labcolor(black) labels labsize(small)) legend(on cols(3) size(small) color(black) position(6) label(1 "QTE, by family income" "(significant at 1%)") label(2 "QTE, by family income" "(non significant at 1%)") label(3 "Median QTE")) graphregion(fcolor(white) lcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))"
local opt3 "ytitle("Earnings (NOK)", size(small) color(black)) ylabel(-60000(30000)60000, labels labsize(small) labcolor(black)) yline(0, lwidth(medthin) lpattern(solid) lcolor(black)) xtitle("Percentiles of family income", size(small) color(black)) xscale(range(0 99)) xlabel(0(10)99, labcolor(black) labels labsize(small)) legend(on cols(3) size(small) color(black) position(1) ring(0) label(1 "QTE, by family income" "(significant at 1%)") label(2 "QTE, by family income" "(non significant at 1%)") label(3 "Median QTE")) scheme(s1color)"

twoway (scatter QTE quantiles_faminc if QTE_signif==1, mcolor(`color1') msymbol(circle) msize(vsmall) ) ///
	(scatter QTE quantiles_faminc if QTE_signif==0, mcolor(`color3') msymbol(circle) msize(vsmall)) ///
	(line QTE quantiles_faminc if quantile==50, lcolor(`color1') lwidth(medthick) lpattern(solid) connect(direct)) ///
	`if', `opt3'
*graph export graphs\mobility.png, replace wid(918) hei(668)



***********************************************************
*	GRAPH2 : EZOP
***********************************************************

/*clear all
set maxvar 20000
use data_graph.dta
foreach x of numlist 10(10)90 {
	if `x' < 90 {
		local x2 = `x' + 10
		foreach y of numlist `x2'(10)90 {
			gen DQTE`x'`y' = QTE`x' - QTE`y'
			gen seDQTE`x'`y' = (seQTE`x'^2 + seQTE`y'^2)^0.5
		}
	}
	else {
		gen DQTE9099 = QTE90 - QTE99
		gen seDQTE9099 = (seQTE90^2 + seQTE99^2)^0.5
	}
}
keep quantile DQTE* seDQTE*

local tvalue = 2.33
reshape long DQTE seDQTE, i(quantile) j(quantiles_faminc)
sort quantile quantiles_faminc
gen DQTE_signif = (abs(DQTE/seDQTE)>=`tvalue')
label var quantiles_faminc "Percentailes of family income"
label var quantile "Percentiles of child income"

local if "if quantile>=5 & quantile<=95 & DQTE<=60000 & DQTE>=-40000"
local color1 "black"
local color2 "red"
local color3 "gs12"
local opt "ytitle("Earnings (NOK)", size(small) color(black)) ylabel(-40000(20000)60000, labels labsize(small) labcolor(black)) yline(0, lwidth(medthin) lpattern(solid) lcolor(black)) xtitle("Percentiles of child earnings", size(small) color(black)) xscale(range(0 99)) xlabel(0(10)99, labcolor(black) labels labsize(small)) legend(on cols(3) size(small) color(black) position(6) label(1 "Gap curves difference by child earings" "(significant at 1%)") label(2 "Gap curves difference by child earnings" "(non significant at 1%)")) graphregion(fcolor(white) lcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))"
twoway (scatter DQTE quantile if DQTE_signif==1, mcolor(`color1') msymbol(circle) msize(vsmall) ) ///
	(scatter DQTE quantile if DQTE_signif==0, mcolor(`color2') msymbol(circle) msize(vsmall)) ///
	`if', `opt'
*graph export graphs\ezop.png, replace wid(918) hei(668)
*/

***********************************************************
*	GRAPH2b : EZOP in the middle of the groups intervals
***********************************************************

clear all
set maxvar 20000
use data_graph.dta
foreach x of numlist 5(10)75 {
	local x2 = `x' + 10
	foreach y of numlist `x2'(10)95 {
		gen DQTE`x'`y' = QTE`x' - QTE`y'
		gen seDQTE`x'`y' = (seQTE`x'^2 + seQTE`y'^2)^0.5
	}
}
gen DQTE8595 = QTE85 - QTE95
gen seDQTE8595 = (seQTE85^2 + seQTE95^2)^0.5
keep quantile DQTE* seDQTE*

local tvalue = 2.33
reshape long DQTE seDQTE, i(quantile) j(quantiles_faminc)
sort quantile quantiles_faminc
gen DQTE_signif = (abs(DQTE/seDQTE)>=`tvalue')
label var quantiles_faminc "Percentailes of family income"
label var quantile "Percentiles of child income"

local if "if quantile>=5 & quantile<=95 & DQTE<=60000 & DQTE>=-40000"
local color1 "black"
local color2 "red"
local color3 "gs12"
local opt "ytitle("Earnings (NOK)", size(small) color(black)) ylabel(-40000(20000)60000, labels labsize(small) labcolor(black)) yline(0, lwidth(medthin) lpattern(solid) lcolor(black)) xtitle("Percentiles of child earnings", size(small) color(black)) xscale(range(0 99)) xlabel(0(10)99, labcolor(black) labels labsize(small)) legend(on cols(3) size(small) color(black) position(6) label(1 "Gap curves difference by child earings" "(significant at 1%)") label(2 "Gap curves difference by child earnings" "(non significant at 1%)")) graphregion(fcolor(white) lcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))"
twoway (scatter DQTE quantile if DQTE_signif==1, mcolor(`color1') msymbol(circle) msize(vsmall) ) ///
	(scatter DQTE quantile if DQTE_signif==0, mcolor(`color2') msymbol(circle) msize(vsmall)) ///
	`if', `opt'
*graph export graphs\ezop_b.png, replace wid(918) hei(668)


***********************************************************
*	GRAPH2c : EZOP as a mean of differences
***********************************************************

clear all
*set maxvar 20000
use data_graph.dta
foreach x of numlist 0(10)90 {
	if `x' < 90 {
		local x2 = `x' + 10
	}
	else local x2 = 99
	local x3 = `x' + 1
	local x4 = `x' + 5 
	egen AQTE`x4' = rowmean(QTE`x3'-QTE`x2')
	foreach y of numlist `x3'(1)`x2' {
		replace seQTE`y' = seQTE`y'^2
	}
	egen AseQTE`x4' = rowmean(seQTE`x3'-seQTE`x2')
	replace AseQTE`x4' = AseQTE`x4'^0.5
}
foreach x of numlist 5(10)75 {
	local x2 = `x' + 10
 	foreach y of numlist `x2'(10)95 {
		gen DQTE`x'`y' = AQTE`x' - AQTE`y'
		gen seDQTE`x'`y' = (AseQTE`x'^2 + AseQTE`y'^2)^0.5
	}
}
gen DQTE8595 = QTE85 - QTE95
gen seDQTE8595 = (seQTE85^2 + seQTE95^2)^0.5
keep quantile DQTE* seDQTE*

local tvalue = 2.33
reshape long DQTE seDQTE, i(quantile) j(quantiles_faminc)
sort quantile quantiles_faminc
gen DQTE_signif = (abs(DQTE/seDQTE)>=`tvalue')
label var quantiles_faminc "Percentailes of family income"
label var quantile "Percentiles of child income"

local if "if quantile>=5 & quantile<=95 & DQTE<=60000 & DQTE>=-20000"
local color1 "black"
local color2 "red"
local color3 "gs9"
*local opt "ytitle("Earnings (NOK)", size(small) color(black)) ylabel(-20000(20000)60000, labels labsize(small) labcolor(black)) yline(0, lwidth(medthin) lpattern(solid) lcolor(black)) xtitle("Percentiles of child earnings", size(small) color(black)) xscale(range(0 99)) xlabel(0(10)99, labcolor(black) labels labsize(small)) legend(on cols(3) size(small) color(black) position(11) ring(0) label(1 "Gap curves difference " "by child earings" "(significant at 1%)") label(2 "Gap curves difference" "by child earnings" "(non significant at 1%)")) graphregion(fcolor(white) lcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) scheme(s1color)"
local opt "ytitle("Earnings (NOK)", size(small) color(black)) ylabel(-20000(20000)60000, labels labsize(small) labcolor(black)) yline(0, lwidth(medthin) lpattern(solid) lcolor(black)) xtitle("Percentiles of child earnings", size(small) color(black)) xscale(range(0 99)) xlabel(0(10)99, labcolor(black) labels labsize(small)) legend(on cols(3) size(small) color(black) position(11) ring(0) label(1 "Gap curves difference " "by child earnings" "(significant at 1%)") label(2 "Gap curves difference" "by child earnings" "(non significant at 1%)"))  scheme(s1color)"
twoway (scatter DQTE quantile if DQTE_signif==1, mcolor(`color1') msymbol(circle) msize(vsmall) ) ///
	(scatter DQTE quantile if DQTE_signif==0, mcolor(`color3') msymbol(circle) msize(vsmall)) ///
	`if', `opt'
*graph export ezop_c.png, replace wid(1374) hei(1000)
graph export ezop_c.pdf, replace 



***********************************************************
*	GRAPH3 : EZOP for 5% father income groups
***********************************************************

clear all
set maxvar 20000
use data_graph.dta
foreach x of numlist 5(5)95 {
	if `x' < 95 {
		local x2 = `x' + 5
		foreach y of numlist `x2'(5)95 {
			gen DQTE`x'`y' = QTE`x' - QTE`y'
			gen seDQTE`x'`y' = (seQTE`x'^2 + seQTE`y'^2)^0.5
		}
	}
	else {
		gen DQTE9599 = QTE95 - QTE99
		gen seDQTE9599 = (seQTE95^2 + seQTE99^2)^0.5
	}
}
keep quantile DQTE* seDQTE*

local tvalue = 2.33
reshape long DQTE seDQTE, i(quantile) j(quantiles_faminc)
sort quantile quantiles_faminc
gen DQTE_signif = (abs(DQTE/seDQTE)>=`tvalue')
label var quantiles_faminc "Percentailes of family income"
label var quantile "Percentiles of child income"

local if "if quantile>=5 & quantile<=95 & DQTE<=60000 & DQTE>=-40000"
local color1 "black"
local color2 "red"
local color3 "gs12"
local opt "ytitle("Differences in gap curves, by income", size(small) color(black)) ylabel(-40000(20000)60000, labels labsize(small) labcolor(black)) yline(0, lwidth(medthin) lpattern(solid) lcolor(black)) xtitle("Percentiles of child income", size(small) color(black)) xscale(range(0 99)) xlabel(0(10)99, labcolor(black) labels labsize(small)) legend(on cols(3) size(small) color(black) position(6) label(1 "Gap curves difference (signif. 1%)") label(2 "Gap curves difference (non signif. 1%)")) graphregion(fcolor(white) lcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))"
twoway (scatter DQTE quantile if DQTE_signif==1, mcolor(`color1') msymbol(circle) msize(vsmall) ) ///
	(scatter DQTE quantile if DQTE_signif==0, mcolor(`color2') msymbol(circle) msize(vsmall)) ///
	`if', `opt'
*graph export graphs\ezop_20.png, replace wid(918) hei(668)




***********************************************************
*	GRAPH4 : EZOP 99 father intervals
***********************************************************

clear all
set maxvar 20000
use data_graph.dta
foreach x of numlist 1(1)98 {
	if `x' < 98 {
		local x2 = `x' + 1
		foreach y of numlist `x2'(1)99 {
			gen DQTE`x'`y' = QTE`x' - QTE`y'
			gen seDQTE`x'`y' = (seQTE`x'^2 + seQTE`y'^2)^0.5
		}
	}
	else {
		gen DQTE9899 = QTE98 - QTE99
		gen seDQTE9899 = (seQTE98^2 + seQTE99^2)^0.5
	}
}
keep quantile DQTE* seDQTE*

local tvalue = 2.33
reshape long DQTE seDQTE, i(quantile) j(quantiles_faminc)
sort quantile quantiles_faminc
gen DQTE_signif = (abs(DQTE/seDQTE)>=`tvalue')
label var quantiles_faminc "Percentailes of family income"
label var quantile "Percentiles of child income"

local if "if quantile>=5 & quantile<=95 & DQTE<=60000 & DQTE>=-60000"
local color1 "black"
local color2 "red"
local color3 "gs12"
local opt "ytitle("Differences in gap curve, by income", size(small) color(black)) ylabel(-60000(30000)60000, labels labsize(small) labcolor(black)) yline(0, lwidth(medthin) lpattern(solid) lcolor(black)) xtitle("Percentiles of child income", size(small) color(black)) xscale(range(0 99)) xlabel(0(10)99, labcolor(black) labels labsize(small)) legend(on cols(3) size(small) color(black) position(6) label(1 "Gap curves diff. (sig. 1%)") label(2 "Gap curves diff. (non sig. 1%)")) graphregion(fcolor(white) lcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))"
twoway (scatter DQTE quantile if DQTE_signif==1, mcolor(`color1') msymbol(circle) msize(vsmall) ) ///
	(scatter DQTE quantile if DQTE_signif==0, mcolor(`color2') msymbol(X) msize(vsmall)) ///
	`if', `opt'
*graph export graphs\ezop_99.png, replace wid(918) hei(668)


***********************************************************
*	GRAPH5 : INTERGENERATIONAL MEAN + QUANTILES
***********************************************************

clear all
set maxvar 20000
use data_graph.dta

local tvalue = 2.33
reshape long QTE seQTE ATEf seATEf, i(quantile) j(quantiles_faminc)
sort quantiles_faminc quantile
gen QTE_signif = (abs(QTE/seQTE)>=`tvalue')
gen QTE_lb = QTE - `tvalue'*seQTE
gen QTE_ub = QTE + `tvalue'*seQTE
gen ATEf_lb = ATEf - `tvalue'*seATEf
gen ATEf_ub = ATEf + `tvalue'*seATEf
label var quantiles_faminc "Percentailes of family income"

local if "if quantiles_faminc>=5 & quantiles_faminc<=95 & QTE<=40000 & QTE>=-40000"
local color1 "black"
local color2 "red"
local color3 "gs14"
local opt2 "ytitle("Earnings (NOK)", size(small) color(black)) ylabel(-40000(20000)40000, labels labsize(small) labcolor(black)) yline(0, lwidth(medthin) lpattern(solid) lcolor(black)) xtitle("Percentiles of family income", size(small) color(black)) xscale(range(0 99)) xlabel(0(10)99, labcolor(black) labels labsize(small)) legend(on cols(3) size(small) color(black) position(6) order(2 1 - 3 4 5) label(2 "Treatment effects" "on the mean") label(1 "CI at 99%") label(3 "QTE on pct 20%" ) label(4 "QTE on the median" )  label(5 "QTE on pct 80%" )) graphregion(fcolor(white) lcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))"
local opt3 "ytitle("Earnings (NOK)", size(small) color(black)) ylabel(-40000(20000)40000, labels labsize(small) labcolor(black)) yline(0, lwidth(medthin) lpattern(solid) lcolor(black)) xtitle("Percentiles of family income", size(small) color(black)) xscale(range(0 99)) xlabel(0(10)99, labcolor(black) labels labsize(small)) legend(on cols(3) size(small) color(black) position(11) ring(0) order(3 1 - 2 4) label(1 "CI at 99%") label(2 "QTE on pct 20%" ) label(3 "QTE on the median" )  label(4 "QTE on pct 80%" )) scheme(s1color)"

twoway (rarea ATEf_lb ATEf_ub quantiles_faminc, color(`color3') ) ///
	(line ATEf quantiles_faminc if quantile==1, lcolor(`color1') lwidth(medthick) lpattern(solid) connect(direct)) ///
	(line QTE quantiles_faminc if quantile==20, lcolor(`color1') lwidth(medium) lpattern(dash)) ///
	(line QTE quantiles_faminc if quantile==50, lcolor(`color1') lwidth(medthick) lpattern(dot)) ///
	(line QTE quantiles_faminc if quantile==80, lcolor(`color1') lwidth(medium) lpattern(dash_3dot)) ///
	`if', `opt2'
*graph export graphs\AVGmobility.png, replace wid(918) hei(668)

twoway (rarea QTE_lb QTE_ub quantiles_faminc if quantile==50, color(`color3') ) ///
	(line QTE quantiles_faminc if quantile==20, lcolor(`color1') lwidth(medthick) lpattern(dash)) ///
	(line QTE quantiles_faminc if quantile==50, lcolor(`color1') lwidth(medthick) lpattern(solid)) ///
	(line QTE quantiles_faminc if quantile==80, lcolor(`color1') lwidth(medthick) lpattern(dash_3dot)) ///
	`if', `opt3'
*graph export graphs\AVGmobility.png, replace wid(2061) hei(1500)
