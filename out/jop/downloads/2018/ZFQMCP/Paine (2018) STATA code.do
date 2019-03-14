**************
***FIGURE 1***
**************
use "dataset_tscs.dta", clear
graph twoway (line  v2elsuffrage_years year if high_settlers==1 & year>=1945 & year<=1995,lpattern(solid) lcolor(black) sort) ///
(line  v2elsuffrage_years year if high_settlers==0 & year>=1945 & year<=1995, lpattern(dash) lcolor(gray) sort), ///
legend(off) ytitle("Average % enfranchisement",size(huge)) xtitle("Year",size(huge)) graphregion(fcolor(white) lcolor(black)) ///
plotregion(fcolor(none) lcolor(black)) xlabel(1945(10)1995, labsize(large)) ylabel(0(20)100, labsize(large)) ///
title("Panel A. Franchise size",size(huge) color(black)) name(panela, replace) nodraw
graph twoway (line  war_years year if high_settlers==1 & year>=1945 & year<=1995,lpattern(solid) lcolor(black)  sort) ///
(line war_years year if high_settlers==0 & year>=1945 & year<=1995, lpattern(dash) lcolor(gray) sort), ///
legend(label(1 "Settler Colonies") label(2 "Non-Settler Colonies") size(large)) ytitle("% w/ ongoing col. liberation war",size(huge)) ///
xtitle("Year",size(huge)) graphregion(fcolor(white) lcolor(black)) plotregion(fcolor(none) lcolor(black)) xlabel(1945(10)1995, labsize(large)) ///
ylabel(0(.1).4, labsize(large)) title("Panel B. Colonial liberation war",size(huge) color(black)) name(panelb, replace) nodraw
grc1leg panela panelb, graphregion(color(white)) legendfrom(panelb) name(panelc, replace)
graph combine panelc, cols(2) xsize(6) ysize(3) graphregion(color(white))
graph2tex, epsfile(graphical) 

*************
***TABLE 3***
*************
use "dataset_tscs.dta", clear
reg v2elsuffrage ln_european_percent if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_ols, replace label nocon
reg v2elsuffrage ln_european_percent latitude statehist if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_ols, append label nocon
reg v2elsuffrage ln_european_percent ln_slaves hist_war if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_ols, append label nocon
reg v2elsuffrage ln_european_percent rugged ln_area if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_ols, append label nocon
reg v2elsuffrage ln_european_percent col_br col_fr col_por col_bel if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_ols, append label nocon
reg v2elsuffrage ln_european_percent wwii_occupied ln_npmispc23x10k monarchy if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_ols, append label nocon
reg v2elsuffrage ln_european_percent ln_exports_pc ln_resources_pc if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_ols, append label nocon
reg v2elsuffrage ln_european_percent ln_pop ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_ols, append label nocon
reg v2elsuffrage ln_european_percent statehist col_br col_fr col_por col_bel wwii_occupied ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_ols, append tex(frag)label nocon
*Magnitude of the effect: Ghana vs. Zimbabwe
reg v2elsuffrage ln_european_percent if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=1.81374) atmeans post
reg v2elsuffrage ln_european_percent if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=-1.60944) atmeans post
reg v2elsuffrage ln_european_percent latitude statehist if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=1.81374) atmeans post
reg v2elsuffrage ln_european_percent latitude statehist if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=-1.60944) atmeans post
reg v2elsuffrage ln_european_percent ln_slaves hist_war if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=1.81374) atmeans post
reg v2elsuffrage ln_european_percent ln_slaves hist_war if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=-1.60944) atmeans post
reg v2elsuffrage ln_european_percent rugged ln_area if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=1.81374) atmeans post
reg v2elsuffrage ln_european_percent rugged ln_area if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=-1.60944) atmeans post
reg v2elsuffrage ln_european_percent col_br col_fr col_por col_bel if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=1.81374) atmeans post
reg v2elsuffrage ln_european_percent col_br col_fr col_por col_bel if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=-1.60944) atmeans post
reg v2elsuffrage ln_european_percent wwii_occupied ln_npmispc23x10k monarchy if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=1.81374) atmeans post
reg v2elsuffrage ln_european_percent wwii_occupied ln_npmispc23x10k monarchy if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=-1.60944) atmeans post
reg v2elsuffrage ln_european_percent ln_exports_pc ln_resources_pc if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=1.81374) atmeans post
reg v2elsuffrage ln_european_percent ln_exports_pc ln_resources_pc if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=-1.60944) atmeans post
reg v2elsuffrage ln_european_percent ln_pop ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=1.81374) atmeans post
reg v2elsuffrage ln_european_percent ln_pop ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=-1.60944) atmeans post
reg v2elsuffrage ln_european_percent statehist col_br col_fr col_por col_bel wwii_occupied ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=1.81374) atmeans post
reg v2elsuffrage ln_european_percent statehist col_br col_fr col_por col_bel wwii_occupied ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=-1.60944) atmeans post

*************
***TABLE 4***
*************
use "dataset_cs.dta", clear
reg decol_war ln_european_percent, robust
outreg2 using war_ols, replace label nocon
reg decol_war ln_european_percent latitude statehist, robust
outreg2 using war_ols, append label nocon
reg decol_war ln_european_percent ln_slaves hist_war, robust
outreg2 using war_ols, append label nocon
reg decol_war ln_european_percent rugged ln_area, robust
outreg2 using war_ols, append label nocon
reg decol_war ln_european_percent col_br col_fr col_por col_bel , robust
outreg2 using war_ols, append label nocon
reg decol_war ln_european_percent wwii_occupied ln_npmispc23x10k monarchy, robust
outreg2 using war_ols, append label nocon
reg decol_war ln_european_percent ln_exports_pc ln_resources_pc, robust
outreg2 using war_ols, append label nocon
reg decol_war ln_european_percent ln_pop ln_gdppc ef, robust
outreg2 using war_ols, append label nocon
reg decol_war ln_european_percent col_por  ln_pop, robust
outreg2 using war_ols, append label nocon tex(frag)
*Magnitude of the effect: Ghana vs. Zimbabwe
reg decol_war ln_european_percent, robust
margins, at(ln_european_percent=1.81374) atmeans post
reg decol_war ln_european_percent, robust
margins, at(ln_european_percent=-1.60944) atmeans post
reg decol_war ln_european_percent latitude statehist, robust
margins, at(ln_european_percent=1.81374) atmeans post
reg decol_war ln_european_percent latitude statehist, robust
margins, at(ln_european_percent=-1.60944) atmeans post
reg decol_war ln_european_percent ln_slaves hist_war, robust
margins, at(ln_european_percent=1.81374) atmeans post
reg decol_war ln_european_percent ln_slaves hist_war, robust
margins, at(ln_european_percent=-1.60944) atmeans post
reg decol_war ln_european_percent rugged ln_area, robust
margins, at(ln_european_percent=1.81374) atmeans post
reg decol_war ln_european_percent rugged ln_area, robust
margins, at(ln_european_percent=-1.60944) atmeans post
reg decol_war ln_european_percent col_br col_fr col_por col_bel, robust
margins, at(ln_european_percent=1.81374) atmeans post
reg decol_war ln_european_percent col_br col_fr col_por col_bel, robust
margins, at(ln_european_percent=-1.60944) atmeans post
reg decol_war ln_european_percent wwii_occupied ln_npmispc23x10k monarchy, robust
margins, at(ln_european_percent=1.81374) atmeans post
reg decol_war ln_european_percent wwii_occupied ln_npmispc23x10k monarchy, robust
margins, at(ln_european_percent=-1.60944) atmeans post
reg decol_war ln_european_percent ln_exports_pc ln_resources_pc, robust
margins, at(ln_european_percent=1.81374) atmeans post
reg decol_war ln_european_percent ln_exports_pc ln_resources_pc, robust
margins, at(ln_european_percent=-1.60944) atmeans post
reg decol_war ln_european_percent ln_pop ln_gdppc ef, robust
margins, at(ln_european_percent=1.81374) atmeans post
reg decol_war ln_european_percent ln_pop ln_gdppc ef, robust
margins, at(ln_european_percent=-1.60944) atmeans post
reg decol_war ln_european_percent col_por  ln_pop, robust
margins, at(ln_european_percent=1.81374) atmeans post
reg decol_war ln_european_percent col_por  ln_pop, robust
margins, at(ln_european_percent=-1.60944) atmeans post

*****SAMPLE SENSITIVITY FOR FRANCHISE REGRESSIONS*****
use "dataset_tscs.dta", clear
set obs 16254
gen number = _n
gen exclude1 = .
gen exclude2 = .
foreach i of numlist 1/41 {
	reg v2elsuffrage ln_european_percent if number!=`i' & year>=1955 & year<=1970, cluster(ccode)
	local t = _b[ln_european_percent]/_se[ln_european_percent]
	replace exclude1 = 2*ttail(e(df_r),abs(`t')) if number==`i'
    }
foreach i of numlist 1/41 {
	reg v2elsuffrage ln_european_percent latitude statehist if number!=`i' & year>=1955 & year<=1970, cluster(ccode) 
	local t = _b[ln_european_percent]/_se[ln_european_percent]
	replace exclude1 = 2*ttail(e(df_r),abs(`t')) if number==42+`i'
    }
foreach i of numlist 1/41 {
	reg v2elsuffrage ln_european_percent ln_slaves hist_war if number!=`i' & year>=1955 & year<=1970, cluster(ccode) 
	local t = _b[ln_european_percent]/_se[ln_european_percent]
	replace exclude1 = 2*ttail(e(df_r),abs(`t')) if number==2*42+`i'
    }
foreach i of numlist 1/41 {
	reg v2elsuffrage ln_european_percent rugged ln_area if number!=`i' & year>=1955 & year<=1970, cluster(ccode) 
	local t = _b[ln_european_percent]/_se[ln_european_percent]
	replace exclude1 = 2*ttail(e(df_r),abs(`t')) if number==3*42+`i'
    }
foreach i of numlist 1/41 {
	reg v2elsuffrage ln_european_percent col_br col_fr col_por col_bel if number!=`i' & year>=1955 & year<=1970, cluster(ccode) 
	local t = _b[ln_european_percent]/_se[ln_european_percent]
	replace exclude1 = 2*ttail(e(df_r),abs(`t')) if number==4*42+`i'
    }
foreach i of numlist 1/41 {
	reg v2elsuffrage ln_european_percent wwii_occupied ln_npmispc23x10k monarchy if number!=`i' & year>=1955 & year<=1970, cluster(ccode) 
	local t = _b[ln_european_percent]/_se[ln_european_percent]
	replace exclude1 = 2*ttail(e(df_r),abs(`t')) if number==5*42+`i'
    }
foreach i of numlist 1/41 {
	reg v2elsuffrage ln_european_percent ln_exports_pc ln_resources_pc if number!=`i' & year>=1955 & year<=1970, cluster(ccode) 
	local t = _b[ln_european_percent]/_se[ln_european_percent]
	replace exclude1 = 2*ttail(e(df_r),abs(`t')) if number==6*42+`i'
    }	
foreach i of numlist 1/41 {
	reg v2elsuffrage ln_european_percent ln_pop ln_gdppc ef if number!=`i' & year>=1955 & year<=1970, cluster(ccode) 
	local t = _b[ln_european_percent]/_se[ln_european_percent]
	replace exclude1 = 2*ttail(e(df_r),abs(`t')) if number==7*42+`i'
    }
foreach i of numlist 1/41 {
	reg v2elsuffrage ln_european_percent statehist col_br col_fr col_por col_bel wwii_occupied ln_gdppc ef if number!=`i' & year>=1955 & year<=1970, cluster(ccode) 
	local t = _b[ln_european_percent]/_se[ln_european_percent]
	replace exclude1 = 2*ttail(e(df_r),abs(`t')) if number==8*42+`i'
    }
foreach j of numlist 1/41{
	foreach i of numlist 1/41 {
		reg v2elsuffrage ln_european_percent if number!=`i' & number!=`j' & year>=1955 & year<=1970, cluster(ccode)
		local t = _b[ln_european_percent]/_se[ln_european_percent]
		replace exclude2 = 2*ttail(e(df_r),abs(`t')) if number==378+(`j'-1)*42+`i' & `j' > `i'
		}
	}
foreach j of numlist 1/41{
	foreach i of numlist 1/41 {
		reg v2elsuffrage ln_european_percent latitude statehist if number!=`i' & number!=`j' & year>=1955 & year<=1970, cluster(ccode)
		local t = _b[ln_european_percent]/_se[ln_european_percent]
		replace exclude2 = 2*ttail(e(df_r),abs(`t')) if number==1764+378+(`j'-1)*42+`i' & `j' > `i'
		}
	}
foreach j of numlist 1/41{
	foreach i of numlist 1/41 {
		reg v2elsuffrage ln_european_percent ln_slaves hist_war if number!=`i' & number!=`j' & year>=1955 & year<=1970, cluster(ccode)
		local t = _b[ln_european_percent]/_se[ln_european_percent]
		replace exclude2 = 2*ttail(e(df_r),abs(`t')) if number==2*1764+378+(`j'-1)*42+`i' & `j' > `i'
		}
	}
foreach j of numlist 1/41{
	foreach i of numlist 1/41 {
		reg v2elsuffrage ln_european_percent rugged ln_area if number!=`i' & number!=`j' & year>=1955 & year<=1970, cluster(ccode)
		local t = _b[ln_european_percent]/_se[ln_european_percent]
		replace exclude2 = 2*ttail(e(df_r),abs(`t')) if number==3*1764+378+(`j'-1)*42+`i' & `j' > `i'
		}
	}
foreach j of numlist 1/41{
	foreach i of numlist 1/41 {
		reg v2elsuffrage ln_european_percent col_br col_fr col_por col_bel if number!=`i' & number!=`j' & year>=1955 & year<=1970, cluster(ccode)
		local t = _b[ln_european_percent]/_se[ln_european_percent]
		replace exclude2 = 2*ttail(e(df_r),abs(`t')) if number==4*1764+378+(`j'-1)*42+`i' & `j' > `i'
		}
	}
foreach j of numlist 1/41{
	foreach i of numlist 1/41 {
		reg v2elsuffrage ln_european_percent wwii_occupied ln_npmispc23x10k monarchy if number!=`i' & number!=`j' & year>=1955 & year<=1970, cluster(ccode)
		local t = _b[ln_european_percent]/_se[ln_european_percent]
		replace exclude2 = 2*ttail(e(df_r),abs(`t')) if number==5*1764+378+(`j'-1)*42+`i' & `j' > `i'
		}
	}
foreach j of numlist 1/41{
	foreach i of numlist 1/41 {
		reg v2elsuffrage ln_european_percent ln_exports_pc ln_resources_pc if number!=`i' & number!=`j' & year>=1955 & year<=1970, cluster(ccode)
		local t = _b[ln_european_percent]/_se[ln_european_percent]
		replace exclude2 = 2*ttail(e(df_r),abs(`t')) if number==6*1764+378+(`j'-1)*42+`i' & `j' > `i'
		}
	}
foreach j of numlist 1/41{
	foreach i of numlist 1/41 {
		reg v2elsuffrage ln_european_percent ln_pop ln_gdppc ef if number!=`i' & number!=`j' & year>=1955 & year<=1970, cluster(ccode)
		local t = _b[ln_european_percent]/_se[ln_european_percent]
		replace exclude2 = 2*ttail(e(df_r),abs(`t')) if number==7*1764+378+(`j'-1)*42+`i' & `j' > `i'
		}
	}
foreach j of numlist 1/41{
	foreach i of numlist 1/41 {
		reg v2elsuffrage ln_european_percent statehist col_br col_fr col_por col_bel wwii_occupied ln_gdppc ef if number!=`i' & number!=`j' & year>=1955 & year<=1970, cluster(ccode)
		local t = _b[ln_european_percent]/_se[ln_european_percent]
		replace exclude2 = 2*ttail(e(df_r),abs(`t')) if number==8*1764+378+(`j'-1)*42+`i' & `j' > `i'
		}
	}
summarize exclude1 if exclude1<.01
summarize exclude1 if exclude1<.05
summarize exclude1 if exclude1<.1
summarize exclude1
summarize exclude2 if exclude2<.01
summarize exclude2 if exclude2<.05
summarize exclude2 if exclude2<.1
summarize exclude2
drop exclude1
drop exclude2
drop number
drop if european_percent==.

*****SAMPLE SENSITIVITY FOR LIBERATION WAR REGRESSIONS*****
use "dataset_cs.dta", clear
set obs 16254
gen number = _n
gen exclude1 = .
gen exclude2 = .
foreach i of numlist 1/42 {
	reg decol_war ln_european_percent if number!=`i', robust
	local t = _b[ln_european_percent]/_se[ln_european_percent]
	replace exclude1 = 2*ttail(e(df_r),abs(`t')) if number==`i'
    }
foreach i of numlist 1/42 {
	reg decol_war ln_european_percent latitude statehist if number!=`i', robust 
	local t = _b[ln_european_percent]/_se[ln_european_percent]
	replace exclude1 = 2*ttail(e(df_r),abs(`t')) if number==42+`i'
    }
foreach i of numlist 1/42 {
	reg decol_war ln_european_percent ln_slaves hist_war if number!=`i', robust 
	local t = _b[ln_european_percent]/_se[ln_european_percent]
	replace exclude1 = 2*ttail(e(df_r),abs(`t')) if number==2*42+`i'
    }
foreach i of numlist 1/42 {
	reg decol_war ln_european_percent rugged ln_area if number!=`i', robust 
	local t = _b[ln_european_percent]/_se[ln_european_percent]
	replace exclude1 = 2*ttail(e(df_r),abs(`t')) if number==3*42+`i'
    }
foreach i of numlist 1/42 {
	reg decol_war ln_european_percent col_br col_fr col_por col_bel  if number!=`i', robust 
	local t = _b[ln_european_percent]/_se[ln_european_percent]
	replace exclude1 = 2*ttail(e(df_r),abs(`t')) if number==4*42+`i'
    }
foreach i of numlist 1/42 {
	reg decol_war ln_european_percent wwii_occupied ln_npmispc23x10k monarchy if number!=`i', robust 
	local t = _b[ln_european_percent]/_se[ln_european_percent]
	replace exclude1 = 2*ttail(e(df_r),abs(`t')) if number==5*42+`i'
    }
foreach i of numlist 1/42 {
	reg decol_war ln_european_percent ln_exports_pc ln_resources_pc if number!=`i', robust 
	local t = _b[ln_european_percent]/_se[ln_european_percent]
	replace exclude1 = 2*ttail(e(df_r),abs(`t')) if number==6*42+`i'
    }	
foreach i of numlist 1/42 {
	reg decol_war ln_european_percent ln_pop ln_gdppc ef if number!=`i', robust 
	local t = _b[ln_european_percent]/_se[ln_european_percent]
	replace exclude1 = 2*ttail(e(df_r),abs(`t')) if number==7*42+`i'
    }
foreach i of numlist 1/42 {
	reg decol_war ln_european_percent col_por  ln_pop if number!=`i', robust 
	local t = _b[ln_european_percent]/_se[ln_european_percent]
	replace exclude1 = 2*ttail(e(df_r),abs(`t')) if number==8*42+`i'
    }
foreach j of numlist 1/42{
	foreach i of numlist 1/42 {
		reg decol_war ln_european_percent if number!=`i' & number!=`j'
		local t = _b[ln_european_percent]/_se[ln_european_percent]
		replace exclude2 = 2*ttail(e(df_r),abs(`t')) if number==378+(`j'-1)*42+`i' & `j' > `i'
		}
	}
foreach j of numlist 1/42{
	foreach i of numlist 1/42 {
		reg decol_war ln_european_percent latitude statehist if number!=`i' & number!=`j', robust
		local t = _b[ln_european_percent]/_se[ln_european_percent]
		replace exclude2 = 2*ttail(e(df_r),abs(`t')) if number==1764+378+(`j'-1)*42+`i' & `j' > `i'
		}
	}
foreach j of numlist 1/42{
	foreach i of numlist 1/42 {
		reg decol_war ln_european_percent ln_slaves hist_war if number!=`i' & number!=`j', robust
		local t = _b[ln_european_percent]/_se[ln_european_percent]
		replace exclude2 = 2*ttail(e(df_r),abs(`t')) if number==2*1764+378+(`j'-1)*42+`i' & `j' > `i'
		}
	}
foreach j of numlist 1/42{
	foreach i of numlist 1/42 {
		reg decol_war ln_european_percent rugged ln_area if number!=`i' & number!=`j', robust
		local t = _b[ln_european_percent]/_se[ln_european_percent]
		replace exclude2 = 2*ttail(e(df_r),abs(`t')) if number==3*1764+378+(`j'-1)*42+`i' & `j' > `i'
		}
	}
foreach j of numlist 1/42{
	foreach i of numlist 1/42 {
		reg decol_war ln_european_percent col_br col_fr col_por col_bel  if number!=`i' & number!=`j', robust
		local t = _b[ln_european_percent]/_se[ln_european_percent]
		replace exclude2 = 2*ttail(e(df_r),abs(`t')) if number==4*1764+378+(`j'-1)*42+`i' & `j' > `i'
		}
	}
foreach j of numlist 1/42{
	foreach i of numlist 1/42 {
		reg decol_war ln_european_percent wwii_occupied ln_npmispc23x10k monarchy if number!=`i' & number!=`j', robust
		local t = _b[ln_european_percent]/_se[ln_european_percent]
		replace exclude2 = 2*ttail(e(df_r),abs(`t')) if number==5*1764+378+(`j'-1)*42+`i' & `j' > `i'
		}
	}
foreach j of numlist 1/42{
	foreach i of numlist 1/42 {
		reg decol_war ln_european_percent ln_exports_pc ln_resources_pc if number!=`i' & number!=`j', robust
		local t = _b[ln_european_percent]/_se[ln_european_percent]
		replace exclude2 = 2*ttail(e(df_r),abs(`t')) if number==6*1764+378+(`j'-1)*42+`i' & `j' > `i'
		}
	}
foreach j of numlist 1/42{
	foreach i of numlist 1/42 {
		reg decol_war ln_european_percent ln_pop ln_gdppc ef if number!=`i' & number!=`j', robust
		local t = _b[ln_european_percent]/_se[ln_european_percent]
		replace exclude2 = 2*ttail(e(df_r),abs(`t')) if number==7*1764+378+(`j'-1)*42+`i' & `j' > `i'
		}
	}
foreach j of numlist 1/42{
	foreach i of numlist 1/42 {
		reg decol_war ln_european_percent col_por  ln_pop if number!=`i' & number!=`j', robust
		local t = _b[ln_european_percent]/_se[ln_european_percent]
		replace exclude2 = 2*ttail(e(df_r),abs(`t')) if number==8*1764+378+(`j'-1)*42+`i' & `j' > `i'
		}
	}
summarize exclude1 if exclude1<.01
summarize exclude1 if exclude1<.05
summarize exclude1 if exclude1<.1
summarize exclude1
summarize exclude2 if exclude2<.01
summarize exclude2 if exclude2<.05
summarize exclude2 if exclude2<.1
summarize exclude2
drop exclude1
drop exclude2
drop number
drop if european_percent==.

*************
***TABLE 5***
*************
use "dataset_tscs.dta", clear
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_iv, replace label nocon
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy latitude statehist if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_iv, append label nocon
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy ln_slaves hist_war if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_iv, append label nocon
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy rugged ln_area if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_iv, append label nocon
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy col_br col_fr col_por col_bel if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_iv, append label nocon
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy wwii_occupied ln_npmispc23x10k if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_iv, append label nocon
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy ln_exports_pc ln_resources_pc if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_iv, append label nocon
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy ln_pop ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_iv, append label nocon
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy ln_slaves col_br col_fr col_por wwii_occupied ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_iv, append label nocon tex(frag)
*F-tests
reg ln_european_percent ln_instrument monarchy if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F1 = r(F)
replace F1 = round(F1,.1)
reg ln_european_percent ln_instrument monarchy latitude statehist if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F2 = r(F)
replace F2 = round(F2,.1)
reg ln_european_percent ln_instrument monarchy ln_slaves hist_war if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F3 = r(F)
replace F3 = round(F3,.1)
reg ln_european_percent ln_instrument monarchy rugged ln_area if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F4 = r(F)
replace F4 = round(F4,.1)
reg ln_european_percent ln_instrument monarchy col_br col_fr col_por col_bel if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F5 = r(F)
replace F5 = round(F5,.1)
reg ln_european_percent ln_instrument monarchy wwii_occupied ln_npmispc23x10k monarchy if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F6 = r(F)
replace F6 = round(F6,.1)
reg ln_european_percent ln_instrument monarchy ln_exports_pc ln_resources_pc if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F7 = r(F)
replace F7 = round(F7,.1)
reg ln_european_percent ln_instrument monarchy ln_pop ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F8 = r(F)
replace F8 = round(F8,.1)
reg ln_european_percent ln_instrument monarchy ln_slaves col_br col_fr col_por wwii_occupied ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F9 = r(F)
replace F9 = round(F9,.1)
list F1 F2 F3 F4 F5 F6 F7 F8 F9 if country=="Angola" & year==1945
drop F1 F2 F3 F4 F5 F6 F7 F8 F9
*Magnitude of the effect: Ghana vs. Zimbabwe
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=1.81374) atmeans post
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=-1.60944) atmeans post
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy latitude statehist if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=1.81374) atmeans post
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy latitude statehist if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=-1.60944) atmeans post
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy ln_slaves hist_war if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=1.81374) atmeans post
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy ln_slaves hist_war if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=-1.60944) atmeans post
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy rugged ln_area if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=1.81374) atmeans post
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy rugged ln_area if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=-1.60944) atmeans post
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy col_br col_fr col_por col_bel if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=1.81374) atmeans post
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy col_br col_fr col_por col_bel if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=-1.60944) atmeans post
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy wwii_occupied ln_npmispc23x10k monarchy if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=1.81374) atmeans post
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy wwii_occupied ln_npmispc23x10k monarchy if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=-1.60944) atmeans post
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy ln_exports_pc ln_resources_pc if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=1.81374) atmeans post
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy ln_exports_pc ln_resources_pc if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=-1.60944) atmeans post
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy ln_pop ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=1.81374) atmeans post
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy ln_pop ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=-1.60944) atmeans post
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy statehist col_br col_fr col_por col_bel wwii_occupied ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=1.81374) atmeans post
ivreg v2elsuffrage (ln_european_percent = ln_instrument) monarchy statehist col_br col_fr col_por col_bel wwii_occupied ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=-1.60944) atmeans post

*************
***TABLE 6***
*************
use "dataset_cs.dta", clear
ivreg decol_war (ln_european_percent = ln_instrument) monarchy, robust
outreg2 using war_iv, replace label nocon
ivreg decol_war (ln_european_percent = ln_instrument) monarchy latitude statehist, robust
outreg2 using war_iv, append label nocon
ivreg decol_war (ln_european_percent = ln_instrument) ln_slaves hist_war monarchy, robust
outreg2 using war_iv, append label nocon
ivreg decol_war (ln_european_percent = ln_instrument) rugged ln_area monarchy, robust
outreg2 using war_iv, append label nocon
ivreg decol_war (ln_european_percent = ln_instrument) col_br col_fr col_por col_bel  monarchy, robust
outreg2 using war_iv, append label nocon
ivreg decol_war (ln_european_percent = ln_instrument) wwii_occupied ln_npmispc23x10k monarchy, robust
outreg2 using war_iv, append label nocon
ivreg decol_war (ln_european_percent = ln_instrument) ln_exports_pc ln_resources_pc monarchy, robust
outreg2 using war_iv, append label nocon
ivreg decol_war (ln_european_percent = ln_instrument) ln_pop ln_gdppc ef monarchy, robust
outreg2 using war_iv, append label nocon
ivreg decol_war (ln_european_percent = ln_instrument) col_por  ln_pop monarchy, robust
outreg2 using war_iv, append label nocon tex(frag)
*F-tests
quietly reg ln_european_percent ln_instrument monarchy, robust
test ln_instrument
gen F1 = r(F)
replace F1 = round(F1,.1)
quietly reg ln_european_percent ln_instrument latitude statehist monarchy, robust
test ln_instrument
gen F2 = r(F)
replace F2 = round(F2,.1)
quietly reg ln_european_percent ln_instrument ln_slaves hist_war monarchy, robust
test ln_instrument
gen F3 = r(F)
replace F3 = round(F3,.1)
quietly reg ln_european_percent ln_instrument rugged ln_area monarchy, robust
test ln_instrument
gen F4 = r(F)
replace F4 = round(F4,.1)
quietly reg ln_european_percent ln_instrument col_br col_fr col_por col_bel  monarchy, robust
test ln_instrument
gen F5 = r(F)
replace F5 = round(F5,.1)
quietly reg ln_european_percent ln_instrument wwii_occupied ln_npmispc23x10k monarchy, robust
test ln_instrument
gen F6 = r(F)
replace F6 = round(F6,.1)
quietly reg ln_european_percent ln_instrument ln_exports_pc ln_resources_pc monarchy, robust
test ln_instrument
gen F7 = r(F)
replace F7 = round(F7,.1)
quietly reg ln_european_percent ln_instrument ln_pop ln_gdppc ef monarchy, robust
test ln_instrument
gen F8 = r(F)
replace F8 = round(F8,.1)
quietly reg ln_european_percent ln_instrument ln_slaves ln_pop monarchy, robust
test ln_instrument
gen F9 = r(F)
replace F9 = round(F9,.1)
list F1 F2 F3 F4 F5 F6 F7 F8 F9 if country=="Angola"
drop F1 F2 F3 F4 F5 F6 F7 F8 F9
*Magnitude of the effect: Ghana vs. Zimbabwe
ivreg decol_war (ln_european_percent = ln_instrument) monarchy, robust
margins, at(ln_european_percent=1.81374) atmeans post
ivreg decol_war (ln_european_percent = ln_instrument) monarchy, robust
margins, at(ln_european_percent=-1.60944) atmeans post
ivreg decol_war (ln_european_percent = ln_instrument) monarchy latitude statehist, robust
margins, at(ln_european_percent=1.81374) atmeans post
ivreg decol_war (ln_european_percent = ln_instrument) monarchy latitude statehist, robust
margins, at(ln_european_percent=-1.60944) atmeans post
ivreg decol_war (ln_european_percent = ln_instrument) monarchy ln_slaves hist_war, robust
margins, at(ln_european_percent=1.81374) atmeans post
ivreg decol_war (ln_european_percent = ln_instrument) monarchy ln_slaves hist_war, robust
margins, at(ln_european_percent=-1.60944) atmeans post
ivreg decol_war (ln_european_percent = ln_instrument) monarchy rugged ln_area, robust
margins, at(ln_european_percent=1.81374) atmeans post
ivreg decol_war (ln_european_percent = ln_instrument) monarchy rugged ln_area, robust
margins, at(ln_european_percent=-1.60944) atmeans post
ivreg decol_war (ln_european_percent = ln_instrument) monarchy col_br col_fr col_por col_bel, robust
margins, at(ln_european_percent=1.81374) atmeans post
ivreg decol_war (ln_european_percent = ln_instrument) monarchy col_br col_fr col_por col_bel, robust
margins, at(ln_european_percent=-1.60944) atmeans post
ivreg decol_war (ln_european_percent = ln_instrument) monarchy wwii_occupied ln_npmispc23x10k monarchy, robust
margins, at(ln_european_percent=1.81374) atmeans post
ivreg decol_war (ln_european_percent = ln_instrument) monarchy wwii_occupied ln_npmispc23x10k monarchy, robust
margins, at(ln_european_percent=-1.60944) atmeans post
ivreg decol_war (ln_european_percent = ln_instrument) monarchy ln_exports_pc ln_resources_pc, robust
margins, at(ln_european_percent=1.81374) atmeans post
ivreg decol_war (ln_european_percent = ln_instrument) monarchy ln_exports_pc ln_resources_pc, robust
margins, at(ln_european_percent=-1.60944) atmeans post
ivreg decol_war (ln_european_percent = ln_instrument) monarchy ln_pop ln_gdppc ef, robust
margins, at(ln_european_percent=1.81374) atmeans post
ivreg decol_war (ln_european_percent = ln_instrument) monarchy ln_pop ln_gdppc ef, robust
margins, at(ln_european_percent=-1.60944) atmeans post
ivreg decol_war (ln_european_percent = ln_instrument) monarchy col_por  ln_pop, robust
margins, at(ln_european_percent=1.81374) atmeans post
ivreg decol_war (ln_european_percent = ln_instrument) monarchy col_por  ln_pop, robust
margins, at(ln_european_percent=-1.60944) atmeans post

**************
***TABLE B3***
**************
use "dataset_tscs.dta", clear
sutex v2elsuffrage ln_european_percent ln_instrument land_alienation sig_private_land latitude statehist ln_slaves hist_war rugged ln_area col_br col_fr col_por col_bel wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc ln_pop ln_gdppc ef pd1800 if year>=1955 & year<=1970 & v2elsuffrage!=., label
use "dataset_cs.dta", clear
sutex decol_war ln_european_percent ln_instrument land_alienation sig_private_land latitude statehist ln_slaves hist_war rugged ln_area col_br col_fr col_por col_bel  wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc ln_pop ln_gdppc ef pd1800 if decol_war!=., label

**************
***TABLE C1***
**************
*Same as Table 3

**************
***TABLE C2***
**************
*Same as Table 4

**************
***TABLE C3***
**************
use "dataset_tscs.dta", clear
reg v2elsuffrage ln_european_percent latitude statehist ln_slaves hist_war rugged ln_area if year>=1955 & year<=1970, cluster(ccode)
outreg2 using covariates_suff, replace label nocon
reg v2elsuffrage ln_european_percent col_br col_fr col_por col_bel wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc if year>=1955 & year<=1970, cluster(ccode)
outreg2 using covariates_suff, append label nocon
reg v2elsuffrage ln_european_percent latitude statehist ln_slaves hist_war rugged ln_area col_br col_fr col_por col_bel wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc ln_pop ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
outreg2 using covariates_suff, append tex(frag)label nocon
*Substantive magnitude
reg v2elsuffrage ln_european_percent latitude statehist ln_slaves hist_war rugged ln_area if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=1.81374) atmeans post
reg v2elsuffrage ln_european_percent latitude statehist ln_slaves hist_war rugged ln_area if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=-1.60944) atmeans post
reg v2elsuffrage ln_european_percent col_br col_fr col_por col_bel wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=1.81374) atmeans post
reg v2elsuffrage ln_european_percent col_br col_fr col_por col_bel wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=-1.60944) atmeans post
reg v2elsuffrage ln_european_percent latitude statehist ln_slaves hist_war rugged ln_area col_br col_fr col_por col_bel wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc ln_pop ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=1.81374) atmeans post
reg v2elsuffrage ln_european_percent latitude statehist ln_slaves hist_war rugged ln_area col_br col_fr col_por col_bel wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc ln_pop ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=-1.60944) atmeans post

**************
***TABLE C4***
**************
use "dataset_cs.dta", clear
reg decol_war ln_european_percent latitude statehist ln_slaves hist_war rugged ln_area, robust
outreg2 using covariates_war, replace label nocon
reg decol_war ln_european_percent col_br col_fr col_por col_bel wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc, robust
outreg2 using covariates_war, append label nocon
reg decol_war ln_european_percent latitude statehist ln_slaves hist_war rugged ln_area col_br col_fr col_por col_bel wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc ln_pop ln_gdppc ef, robust
outreg2 using covariates_war, append tex(frag)label nocon
*Substantive magnitude
reg decol_war ln_european_percent latitude statehist ln_slaves hist_war rugged ln_area, robust
margins, at(ln_european_percent=1.81374) atmeans post
reg decol_war ln_european_percent latitude statehist ln_slaves hist_war rugged ln_area, robust
margins, at(ln_european_percent=-1.60944) atmeans post
reg decol_war ln_european_percent col_br col_fr col_por col_bel wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc, robust
margins, at(ln_european_percent=1.81374) atmeans post
reg decol_war ln_european_percent col_br col_fr col_por col_bel wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc, robust
margins, at(ln_european_percent=-1.60944) atmeans post
reg decol_war ln_european_percent latitude statehist ln_slaves hist_war rugged ln_area col_br col_fr col_por col_bel wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc ln_pop ln_gdppc ef, robust
margins, at(ln_european_percent=1.81374) atmeans post
reg decol_war ln_european_percent latitude statehist ln_slaves hist_war rugged ln_area col_br col_fr col_por col_bel wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc ln_pop ln_gdppc ef, robust
margins, at(ln_european_percent=-1.60944) atmeans post

**************
***TABLE C5***
**************
use "dataset_cs.dta", clear
probit decol_war ln_european_percent, robust
outreg2 using war_probit, replace label nocon
probit decol_war ln_european_percent latitude statehist, robust
outreg2 using war_probit, append label nocon
probit decol_war ln_european_percent ln_slaves hist_war, robust
outreg2 using war_probit, append label nocon
probit decol_war ln_european_percent rugged ln_area, robust
outreg2 using war_probit, append label nocon
probit decol_war ln_european_percent col_br col_fr col_por col_bel , robust
outreg2 using war_probit, append label nocon
probit decol_war ln_european_percent wwii_occupied ln_npmispc23x10k monarchy, robust
outreg2 using war_probit, append label nocon
probit decol_war ln_european_percent ln_exports_pc ln_resources_pc, robust
outreg2 using war_probit, append label nocon
probit decol_war ln_european_percent ln_pop ln_gdppc ef, robust
outreg2 using war_probit, append label nocon
probit decol_war ln_european_percent ln_pop ef, robust
outreg2 using war_probit, append label nocon tex(frag)

**************
***TABLE C6***
**************
*Franchise size
use "dataset_tscs.dta", clear
reg v2elsuffrage ln_european_percent if year>=1955 & year<=1970, cluster(ccode)
matrix B = e(b)
gen BR = B[1,1]
reg v2elsuffrage ln_european_percent latitude statehist if year>=1955 & year<=1970, cluster(ccode)
matrix B1 = e(b)
gen BF1 = B1[1,1]
gen SOO1 = BF1/(BR-BF1)
replace SOO1 = round(SOO1,.1)
reg v2elsuffrage ln_european_percent ln_slaves hist_war if year>=1955 & year<=1970, cluster(ccode)
matrix B2 = e(b)
gen BF2 = B2[1,1]
gen SOO2 = BF2/(BR-BF2)
replace SOO2 = round(SOO2,.1)
reg v2elsuffrage ln_european_percent rugged ln_area if year>=1955 & year<=1970, cluster(ccode)
matrix B3 = e(b)
gen BF3 = B3[1,1]
gen SOO3 = BF3/(BR-BF3)
replace SOO3 = round(SOO3,.1)
reg v2elsuffrage ln_european_percent col_br col_fr col_por col_bel if year>=1955 & year<=1970, cluster(ccode)
matrix B4 = e(b)
gen BF4 = B4[1,1]
gen SOO4 = BF4/(BR-BF4)
replace SOO4 = round(SOO4,.1)
reg v2elsuffrage ln_european_percent wwii_occupied ln_npmispc23x10k monarchy if year>=1955 & year<=1970, cluster(ccode)
matrix B5 = e(b)
gen BF5 = B5[1,1]
gen SOO5 = BF5/(BR-BF5)
replace SOO5 = round(SOO5,.1)
reg v2elsuffrage ln_european_percent ln_exports_pc ln_resources_pc if year>=1955 & year<=1970, cluster(ccode)
matrix B6 = e(b)
gen BF6 = B6[1,1]
gen SOO6 = BF6/(BR-BF6)
replace SOO6 = round(SOO6,.1)
reg v2elsuffrage ln_european_percent ln_pop ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
matrix B7 = e(b)
gen BF7 = B7[1,1]
gen SOO7 = BF7/(BR-BF7)
replace SOO7 = round(SOO7,.1)
reg v2elsuffrage ln_european_percent statehist col_br col_fr col_por col_bel wwii_occupied ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
matrix B8 = e(b)
gen BF8 = B8[1,1]
gen SOO8 = BF8/(BR-BF8)
replace SOO8 = round(SOO8,.1)
list SOO1 SOO2 SOO3 SOO4 SOO5 SOO6 SOO7 SOO8 if country=="Angola" & year==1945
drop BR BF1 BF2 BF3 BF4 BF5 BF6 BF7 BF8 SOO1 SOO2 SOO3 SOO4 SOO5 SOO6 SOO7 SOO8
*Liberation wars
use "dataset_cs.dta", clear
reg decol_war ln_european_percent, robust
matrix B = e(b)
gen BR = B[1,1]
reg decol_war ln_european_percent latitude statehist, robust
matrix B1 = e(b)
gen BF1 = B1[1,1]
gen SOO1 = BF1/(BR-BF1)
replace SOO1 = round(SOO1,.1)
reg decol_war ln_european_percent ln_slaves hist_war, robust
matrix B2 = e(b)
gen BF2 = B2[1,1]
gen SOO2 = BF2/(BR-BF2)
replace SOO2 = round(SOO2,.1)
reg decol_war ln_european_percent rugged ln_area, robust
matrix B3 = e(b)
gen BF3 = B3[1,1]
gen SOO3 = BF3/(BR-BF3)
replace SOO3 = round(SOO3,.1)
reg decol_war ln_european_percent col_br col_fr col_por col_bel , robust
matrix B4 = e(b)
gen BF4 = B4[1,1]
gen SOO4 = BF4/(BR-BF4)
replace SOO4 = round(SOO4,.1)
reg decol_war ln_european_percent wwii_occupied ln_npmispc23x10k monarchy, robust
matrix B5 = e(b)
gen BF5 = B5[1,1]
gen SOO5 = BF5/(BR-BF5)
replace SOO5 = round(SOO5,.1)
reg decol_war ln_european_percent ln_exports_pc ln_resources_pc, robust
matrix B6 = e(b)
gen BF6 = B6[1,1]
gen SOO6 = BF6/(BR-BF6)
replace SOO6 = round(SOO6,.1)
reg decol_war ln_european_percent ln_pop ln_gdppc ef, robust
matrix B7 = e(b)
gen BF7 = B7[1,1]
gen SOO7 = BF7/(BR-BF7)
replace SOO7 = round(SOO7,.1)
reg decol_war ln_european_percent col_por  ln_pop, robust
matrix B8 = e(b)
gen BF8 = B8[1,1]
gen SOO8 = BF8/(BR-BF8)
replace SOO8 = round(SOO8,.1)
list SOO1 SOO2 SOO3 SOO4 SOO5 SOO6 SOO7 SOO8 if country=="Angola"
drop BR BF1 BF2 BF3 BF4 BF5 BF6 BF7 BF8 SOO1 SOO2 SOO3 SOO4 SOO5 SOO6 SOO7 SOO8

**************
***TABLE C7***
**************
use "dataset_tscs.dta", clear
reg v2elsuffrage ln_european_percent if year>=1945 & year<=1989, cluster(ccode)
outreg2 using franchise_4589, replace label nocon
reg v2elsuffrage ln_european_percent latitude statehist if year>=1945 & year<=1989, cluster(ccode)
outreg2 using franchise_4589, append label nocon
reg v2elsuffrage ln_european_percent ln_slaves hist_war if year>=1945 & year<=1989, cluster(ccode)
outreg2 using franchise_4589, append label nocon
reg v2elsuffrage ln_european_percent rugged ln_area if year>=1945 & year<=1989, cluster(ccode)
outreg2 using franchise_4589, append label nocon
reg v2elsuffrage ln_european_percent col_br col_fr col_por col_bel if year>=1945 & year<=1989, cluster(ccode)
outreg2 using franchise_4589, append label nocon
reg v2elsuffrage ln_european_percent wwii_occupied ln_npmispc23x10k monarchy if year>=1945 & year<=1989, cluster(ccode)
outreg2 using franchise_4589, append label nocon
reg v2elsuffrage ln_european_percent ln_exports_pc ln_resources_pc if year>=1945 & year<=1989, cluster(ccode)
outreg2 using franchise_4589, append label nocon
reg v2elsuffrage ln_european_percent ln_pop ln_gdppc ef if year>=1945 & year<=1989, cluster(ccode)
outreg2 using franchise_4589, append label nocon
reg v2elsuffrage ln_european_percent statehist col_br col_fr col_por col_bel wwii_occupied ln_pop ln_gdppc ef if year>=1945 & year<=1989, cluster(ccode)
outreg2 using franchise_4589, append tex(frag)label nocon

**************
***TABLE C8***
**************
use "dataset_tscs.dta", clear
reg war_tscs ln_european_percent if year>=1945 & year<=1989 & colonized==1, cluster(ccode)
outreg2 using war_incidence, replace label nocon
reg war_tscs ln_european_percent latitude statehist if year>=1945 & year<=1989 & colonized==1, cluster(ccode)
outreg2 using war_incidence, append label nocon
reg war_tscs ln_european_percent ln_slaves hist_war if year>=1945 & year<=1989 & colonized==1, cluster(ccode)
outreg2 using war_incidence, append label nocon
reg war_tscs ln_european_percent rugged ln_area if year>=1945 & year<=1989 & colonized==1, cluster(ccode)
outreg2 using war_incidence, append label nocon
reg war_tscs ln_european_percent col_br col_fr col_por col_bel  if year>=1945 & year<=1989 & colonized==1, cluster(ccode)
outreg2 using war_incidence, append label nocon
reg war_tscs ln_european_percent wwii_occupied ln_npmispc23x10k monarchy if year>=1945 & year<=1989 & colonized==1, cluster(ccode)
outreg2 using war_incidence, append label nocon
reg war_tscs ln_european_percent ln_exports_pc ln_resources_pc if year>=1945 & year<=1989 & colonized==1, cluster(ccode)
outreg2 using war_incidence, append label nocon
reg war_tscs ln_european_percent ln_pop ln_gdppc ef if year>=1945 & year<=1989 & colonized==1, cluster(ccode)
outreg2 using war_incidence, append label nocon
reg war_tscs ln_european_percent ln_slaves monarchy if year>=1945 & year<=1989 & colonized==1, cluster(ccode)
outreg2 using war_incidence, append label nocon tex(frag)

**************
***TABLE C9***
**************
use "dataset_tscs.dta", clear
reg war_tscs_onset ln_european_percent if year>=1945 & year<=1989 & colonized==1, cluster(ccode)
outreg2 using war_onset, replace label nocon
reg war_tscs_onset ln_european_percent latitude statehist if year>=1945 & year<=1989 & colonized==1, cluster(ccode)
outreg2 using war_onset, append label nocon
reg war_tscs_onset ln_european_percent ln_slaves hist_war if year>=1945 & year<=1989 & colonized==1, cluster(ccode)
outreg2 using war_onset, append label nocon
reg war_tscs_onset ln_european_percent rugged ln_area if year>=1945 & year<=1989 & colonized==1, cluster(ccode)
outreg2 using war_onset, append label nocon
reg war_tscs_onset ln_european_percent col_br col_fr col_por col_bel  if year>=1945 & year<=1989 & colonized==1, cluster(ccode)
outreg2 using war_onset, append label nocon
reg war_tscs_onset ln_european_percent wwii_occupied ln_npmispc23x10k monarchy if year>=1945 & year<=1989 & colonized==1, cluster(ccode)
outreg2 using war_onset, append label nocon
reg war_tscs_onset ln_european_percent ln_exports_pc ln_resources_pc if year>=1945 & year<=1989 & colonized==1, cluster(ccode)
outreg2 using war_onset, append label nocon
reg war_tscs_onset ln_european_percent ln_pop ln_gdppc ef if year>=1945 & year<=1989 & colonized==1, cluster(ccode)
outreg2 using war_onset, append label nocon
reg war_tscs_onset ln_european_percent col_por  wwii_occupied ln_pop if year>=1945 & year<=1989 & colonized==1, cluster(ccode)
outreg2 using war_onset, append label nocon tex(frag)

***************
***TABLE C10***
***************
use "dataset_cs.dta", clear
reg v2elsuffrage_5570 ln_european_percent, cluster(ccode)
outreg2 using franchise_cs, replace label nocon
reg v2elsuffrage_5570 ln_european_percent latitude statehist, cluster(ccode)
outreg2 using franchise_cs, append label nocon
reg v2elsuffrage_5570 ln_european_percent ln_slaves hist_war, cluster(ccode)
outreg2 using franchise_cs, append label nocon
reg v2elsuffrage_5570 ln_european_percent rugged ln_area, cluster(ccode)
outreg2 using franchise_cs, append label nocon
reg v2elsuffrage_5570 ln_european_percent col_br col_fr col_por col_bel, cluster(ccode)
outreg2 using franchise_cs, append label nocon
reg v2elsuffrage_5570 ln_european_percent wwii_occupied ln_npmispc23x10k monarchy, cluster(ccode)
outreg2 using franchise_cs, append label nocon
reg v2elsuffrage_5570 ln_european_percent ln_exports_pc ln_resources_pc, cluster(ccode)
outreg2 using franchise_cs, append label nocon
reg v2elsuffrage_5570 ln_european_percent ln_pop ln_gdppc ef, cluster(ccode)
outreg2 using franchise_cs, append label nocon
reg v2elsuffrage_5570 ln_european_percent statehist col_br col_fr col_por col_bel wwii_occupied ln_gdppc ef, cluster(ccode)
outreg2 using franchise_cs, append tex(frag)label nocon

***************
***FIGURE D5***
***************
use "dataset_cs.dta", clear
reg ln_european_percent
predict treatment,residuals
reg ln_instrument if european_percent!=.
predict instrument_fit,residuals
graph twoway (lfitci treatment instrument_fit) ///
(scatter treatment instrument_fit,mlabel(country) mlabcolor(black) mlabangle(30) mcolor(black) mlabsize(large)) ///
(lfit treatment instrument_fit,lcolor(black)), legend(off) ytitle("ln(European percent)",size(large)) ///
xtitle("ln(Suitable territory/area)",size(large)) xlabel(-3(2)5, labsize(large)) ylabel(-2(2)4, labsize(large)) ///
graphregion(color(white))
graph2tex, epsfile(firststage) 
drop instrument_fit
drop treatment

***************
***FIGURE D6***
***************
use "dataset_cs.dta", clear
graph twoway (lfitci ajr_settmort ln_instrument) ///
(scatter ajr_settmort ln_instrument, mlabel(country) mlabcolor(black) mlabangle(30) mcolor(black) mlabsize(medlarge)) ///
(lfit ajr_settmort ln_instrument,lcolor(black)), legend(off) xtitle("ln(Suitable territory/area)",size(large)) ///
ytitle("ln(AJR settler mortality)",size(large)) xlabel(-3(2)5, labsize(large)) ylabel(3(1)8, labsize(large)) ///
graphregion(color(white))
graph2tex, epsfile(ajr) 

**************
***TABLE D2***
**************
*Same as Table 5

**************
***TABLE D3***
**************
*Same as Table 6

**************
***TABLE D4***
**************
use "dataset_tscs.dta", clear
reg ln_european_percent ln_instrument monarchy if year>=1955 & year<=1970 & v2elsuffrage!=., cluster(ccode)
outreg2 using franchise_first, replace label nocon
reg ln_european_percent ln_instrument latitude statehist monarchy if year>=1955 & year<=1970 & v2elsuffrage!=., cluster(ccode)
outreg2 using franchise_first, append label nocon
reg ln_european_percent ln_instrument ln_slaves hist_war monarchy if year>=1955 & year<=1970 & v2elsuffrage!=., cluster(ccode)
outreg2 using franchise_first, append label nocon
reg ln_european_percent ln_instrument rugged ln_area monarchy if year>=1955 & year<=1970 & v2elsuffrage!=., cluster(ccode)
outreg2 using franchise_first, append label nocon
reg ln_european_percent ln_instrument col_br col_fr col_por col_bel monarchy if year>=1955 & year<=1970 & v2elsuffrage!=., cluster(ccode)
outreg2 using franchise_first, append label nocon
reg ln_european_percent ln_instrument wwii_occupied ln_npmispc23x10k monarchy if year>=1955 & year<=1970 & v2elsuffrage!=., cluster(ccode)
outreg2 using franchise_first, append label nocon
reg ln_european_percent ln_instrument ln_exports_pc ln_resources_pc monarchy if year>=1955 & year<=1970 & v2elsuffrage!=., cluster(ccode)
outreg2 using franchise_first, append label nocon
reg ln_european_percent ln_instrument ln_pop ln_gdppc ef monarchy if year>=1955 & year<=1970 & v2elsuffrage!=., cluster(ccode)
outreg2 using franchise_first, append label nocon
reg ln_european_percent ln_instrument monarchy ln_slaves col_br col_fr col_por wwii_occupied ln_gdppc ef if year>=1955 & year<=1970 & v2elsuffrage!=., cluster(ccode)
outreg2 using franchise_first, append tex(frag) label nocon

**************
***TABLE D5***
**************
use "dataset_tscs.dta", clear
reg v2elsuffrage ln_instrument monarchy if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_reduced, replace label nocon
reg v2elsuffrage ln_instrument latitude statehist monarchy if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_reduced, append label nocon
reg v2elsuffrage ln_instrument ln_slaves hist_war monarchy if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_reduced, append label nocon
reg v2elsuffrage ln_instrument rugged ln_area monarchy if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_reduced, append label nocon
reg v2elsuffrage ln_instrument col_br col_fr col_por col_bel monarchy if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_reduced, append label nocon
reg v2elsuffrage ln_instrument wwii_occupied ln_npmispc23x10k monarchy if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_reduced, append label nocon
reg v2elsuffrage ln_instrument ln_exports_pc ln_resources_pc monarchy if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_reduced, append label nocon
reg v2elsuffrage ln_instrument ln_pop ln_gdppc ef monarchy if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_reduced, append label nocon
reg v2elsuffrage ln_instrument monarchy ln_slaves col_br col_fr col_por wwii_occupied ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_reduced, append tex(frag) label nocon

**************
***TABLE D6***
**************
use "dataset_cs.dta", clear
reg ln_european_percent ln_instrument monarchy, robust
outreg2 using war_first, replace label nocon
reg ln_european_percent ln_instrument latitude statehist monarchy, robust
outreg2 using war_first, append label nocon
reg ln_european_percent ln_instrument ln_slaves hist_war monarchy, robust
outreg2 using war_first, append label nocon
reg ln_european_percent ln_instrument rugged ln_area monarchy, robust
outreg2 using war_first, append label nocon
reg ln_european_percent ln_instrument col_br col_fr col_por col_bel  monarchy, robust
outreg2 using war_first, append label nocon
reg ln_european_percent ln_instrument wwii_occupied ln_npmispc23x10k monarchy, robust
outreg2 using war_first, append label nocon
reg ln_european_percent ln_instrument ln_exports_pc ln_resources_pc monarchy, robust
outreg2 using war_first, append label nocon
reg ln_european_percent ln_instrument ln_pop ln_gdppc ef monarchy, robust
outreg2 using war_first, append label nocon
reg ln_european_percent ln_instrument col_por  ln_pop monarchy, robust
outreg2 using war_first, append tex(frag) label nocon

**************
***TABLE D7***
**************
use "dataset_cs.dta", clear
reg decol_war ln_instrument monarchy, robust
outreg2 using war_reduced, replace label nocon
reg decol_war ln_instrument latitude statehist monarchy, robust
outreg2 using war_reduced, append label nocon
reg decol_war ln_instrument ln_slaves hist_war monarchy, robust
outreg2 using war_reduced, append label nocon
reg decol_war ln_instrument rugged ln_area monarchy, robust
outreg2 using war_reduced, append label nocon
reg decol_war ln_instrument col_br col_fr col_por col_bel  monarchy, robust
outreg2 using war_reduced, append label nocon
reg decol_war ln_instrument wwii_occupied ln_npmispc23x10k monarchy, robust
outreg2 using war_reduced, append label nocon
reg decol_war ln_instrument ln_exports_pc ln_resources_pc monarchy, robust
outreg2 using war_reduced, append label nocon
reg decol_war ln_instrument ln_pop ln_gdppc ef monarchy, robust
outreg2 using war_reduced, append label nocon
reg decol_war ln_instrument col_por  ln_pop monarchy, robust
outreg2 using war_reduced, append tex(frag) label nocon

**************
***TABLE D8***
**************
use "dataset_tscs.dta", clear
ivreg v2elsuffrage (ln_european_percent = ln_instrument) latitude statehist ln_slaves hist_war rugged ln_area monarchy if year>=1955 & year<=1970, cluster(ccode)
outreg2 using covariates_suff_iv, replace label nocon
ivreg v2elsuffrage (ln_european_percent = ln_instrument) col_br col_fr col_por col_bel wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc if year>=1955 & year<=1970, cluster(ccode)
outreg2 using covariates_suff_iv, append label nocon
ivreg v2elsuffrage (ln_european_percent = ln_instrument) latitude statehist ln_slaves hist_war rugged ln_area col_br col_fr col_por col_bel wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc ln_pop_1950 ln_gdppc_1950 ef if year>=1955 & year<=1970, cluster(ccode)
outreg2 using covariates_suff_iv, append tex(frag)label nocon
*F-tests
reg ln_european_percent ln_instrument latitude statehist ln_slaves hist_war rugged ln_area monarchy if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F1 = r(F)
replace F1 = round(F1,.1)
reg ln_european_percent ln_instrument col_br col_fr col_por col_bel wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F2 = r(F)
replace F2 = round(F2,.1)
reg ln_european_percent ln_instrument latitude statehist ln_slaves hist_war rugged ln_area col_br col_fr col_por col_bel wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc ln_pop ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F3 = r(F)
replace F3 = round(F3,.1)
list F1 F2 F3 if country=="Angola" & year==1945
drop F1 F2 F3
*Substantive magnitude
ivreg v2elsuffrage (ln_european_percent = ln_instrument) latitude statehist ln_slaves hist_war rugged ln_area monarchy if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=1.81374) atmeans post
ivreg v2elsuffrage (ln_european_percent = ln_instrument) latitude statehist ln_slaves hist_war rugged ln_area monarchy if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=-1.60944) atmeans post
ivreg v2elsuffrage (ln_european_percent = ln_instrument) col_br col_fr col_por col_bel wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=1.81374) atmeans post
ivreg v2elsuffrage (ln_european_percent = ln_instrument) col_br col_fr col_por col_bel wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=-1.60944) atmeans post
ivreg v2elsuffrage (ln_european_percent = ln_instrument) latitude statehist ln_slaves hist_war rugged ln_area col_br col_fr col_por col_bel wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc ln_pop ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=1.81374) atmeans post
ivreg v2elsuffrage (ln_european_percent = ln_instrument) latitude statehist ln_slaves hist_war rugged ln_area col_br col_fr col_por col_bel wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc ln_pop ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
margins, at(ln_european_percent=-1.60944) atmeans post

**************
***TABLE D9***
**************
use "dataset_cs.dta", clear
ivreg decol_war (ln_european_percent = ln_instrument)  latitude statehist ln_slaves hist_war rugged ln_area monarchy, robust
outreg2 using covariates_war_iv, replace label nocon
ivreg decol_war (ln_european_percent = ln_instrument) col_br col_fr col_por col_bel  wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc, robust
outreg2 using covariates_war_iv, append label nocon
ivreg decol_war (ln_european_percent = ln_instrument) latitude statehist ln_slaves hist_war rugged ln_area col_br col_fr col_por col_bel  wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc ln_pop ln_gdppc ef, robust
outreg2 using covariates_war_iv, append tex(frag)label nocon
*Substantive magnitude
ivreg decol_war (ln_european_percent = ln_instrument)  latitude statehist ln_slaves hist_war rugged ln_area monarchy, robust
margins, at(ln_european_percent=1.81374) atmeans post
ivreg decol_war (ln_european_percent = ln_instrument)  latitude statehist ln_slaves hist_war rugged ln_area monarchy, robust
margins, at(ln_european_percent=-1.60944) atmeans post
ivreg decol_war (ln_european_percent = ln_instrument) col_br col_fr col_por col_bel  wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc, robust
margins, at(ln_european_percent=1.81374) atmeans post
ivreg decol_war (ln_european_percent = ln_instrument) col_br col_fr col_por col_bel  wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc, robust
margins, at(ln_european_percent=-1.60944) atmeans post
ivreg decol_war (ln_european_percent = ln_instrument) latitude statehist ln_slaves hist_war rugged ln_area col_br col_fr col_por col_bel  wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc ln_pop ln_gdppc ef, robust
margins, at(ln_european_percent=1.81374) atmeans post
ivreg decol_war (ln_european_percent = ln_instrument) latitude statehist ln_slaves hist_war rugged ln_area col_br col_fr col_por col_bel  wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc ln_pop ln_gdppc ef, robust
margins, at(ln_european_percent=-1.60944) atmeans post
*F-tests
reg ln_european_percent ln_instrument latitude statehist ln_slaves hist_war rugged ln_area monarchy, robust
test ln_instrument
gen F1 = r(F)
replace F1 = round(F1,.1)
reg ln_european_percent ln_instrument col_br col_fr col_por col_bel wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc, robust
test ln_instrument
gen F2 = r(F)
replace F2 = round(F2,.1)
reg ln_european_percent ln_instrument latitude statehist ln_slaves hist_war rugged ln_area col_br col_fr col_por col_bel wwii_occupied ln_npmispc23x10k monarchy ln_exports_pc ln_resources_pc ln_pop ln_gdppc ef, robust
test ln_instrument
gen F3 = r(F)
replace F3 = round(F3,.1)
list F1 F2 F3 if country=="Angola"
drop F1 F2 F3

***************
***TABLE D10***
***************
use "dataset_tscs.dta", clear
ivreg v2elsuffrage (ln_european_percent = ln_instrument) pd1800 if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_pd, replace label nocon
ivreg v2elsuffrage (ln_european_percent = ln_instrument) pd1800 latitude statehist if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_pd, append label nocon
ivreg v2elsuffrage (ln_european_percent = ln_instrument) pd1800 ln_slaves hist_war if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_pd, append label nocon
ivreg v2elsuffrage (ln_european_percent = ln_instrument) pd1800 rugged ln_area if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_pd, append label nocon
ivreg v2elsuffrage (ln_european_percent = ln_instrument) pd1800 col_br col_fr col_por col_bel if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_pd, append label nocon
ivreg v2elsuffrage (ln_european_percent = ln_instrument) pd1800 wwii_occupied ln_npmispc23x10k if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_pd, append label nocon
ivreg v2elsuffrage (ln_european_percent = ln_instrument) pd1800 ln_exports_pc ln_resources_pc if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_pd, append label nocon
ivreg v2elsuffrage (ln_european_percent = ln_instrument) pd1800 ln_pop ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_pd, append label nocon
ivreg v2elsuffrage (ln_european_percent = ln_instrument) pd1800 ln_slaves col_br col_fr col_por wwii_occupied ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_pd, append label nocon tex(frag)
*F-tests
reg ln_european_percent ln_instrument pd1800 if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F1 = r(F)
replace F1 = round(F1,.1)
reg ln_european_percent ln_instrument pd1800 latitude statehist if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F2 = r(F)
replace F2 = round(F2,.1)
reg ln_european_percent ln_instrument pd1800 ln_slaves hist_war if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F3 = r(F)
replace F3 = round(F3,.1)
reg ln_european_percent ln_instrument pd1800 rugged ln_area if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F4 = r(F)
replace F4 = round(F4,.1)
reg ln_european_percent ln_instrument pd1800 col_br col_fr col_por col_bel if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F5 = r(F)
replace F5 = round(F5,.1)
reg ln_european_percent ln_instrument pd1800 wwii_occupied ln_npmispc23x10k pd1800 if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F6 = r(F)
replace F6 = round(F6,.1)
reg ln_european_percent ln_instrument pd1800 ln_exports_pc ln_resources_pc if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F7 = r(F)
replace F7 = round(F7,.1)
reg ln_european_percent ln_instrument pd1800 ln_pop ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F8 = r(F)
replace F8 = round(F8,.1)
reg ln_european_percent ln_instrument pd1800 ln_slaves col_br col_fr col_por wwii_occupied ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F9 = r(F)
replace F9 = round(F9,.1)
list F1 F2 F3 F4 F5 F6 F7 F8 F9 if country=="Angola" & year==1945
drop F1 F2 F3 F4 F5 F6 F7 F8 F9

***************
***TABLE D11***
***************
use "dataset_cs.dta", clear
ivreg decol_war (ln_european_percent = ln_instrument) pd1800, robust
outreg2 using war_pd, replace label nocon
ivreg decol_war (ln_european_percent = ln_instrument) pd1800 latitude statehist, robust
outreg2 using war_pd, append label nocon
ivreg decol_war (ln_european_percent = ln_instrument) ln_slaves hist_war pd1800, robust
outreg2 using war_pd, append label nocon
ivreg decol_war (ln_european_percent = ln_instrument) rugged ln_area pd1800, robust
outreg2 using war_pd, append label nocon
ivreg decol_war (ln_european_percent = ln_instrument) col_br col_fr col_por col_bel pd1800, robust
outreg2 using war_pd, append label nocon
ivreg decol_war (ln_european_percent = ln_instrument) wwii_occupied ln_npmispc23x10k pd1800, robust
outreg2 using war_pd, append label nocon
ivreg decol_war (ln_european_percent = ln_instrument) ln_exports_pc ln_resources_pc pd1800, robust
outreg2 using war_pd, append label nocon
ivreg decol_war (ln_european_percent = ln_instrument) ln_pop ln_gdppc ef pd1800, robust
outreg2 using war_pd, append label nocon
ivreg decol_war (ln_european_percent = ln_instrument) ln_slaves col_por ln_pop pd1800, robust
outreg2 using war_pd, append label nocon tex(frag)
*F-tests
quietly reg ln_european_percent ln_instrument pd1800, robust
test ln_instrument
gen F1 = r(F)
replace F1 = round(F1,.1)
quietly reg ln_european_percent ln_instrument latitude statehist pd1800, robust
test ln_instrument
gen F2 = r(F)
replace F2 = round(F2,.1)
quietly reg ln_european_percent ln_instrument ln_slaves hist_war pd1800, robust
test ln_instrument
gen F3 = r(F)
replace F3 = round(F3,.1)
quietly reg ln_european_percent ln_instrument rugged ln_area pd1800, robust
test ln_instrument
gen F4 = r(F)
replace F4 = round(F4,.1)
quietly reg ln_european_percent ln_instrument col_br col_fr col_por col_bel pd1800, robust
test ln_instrument
gen F5 = r(F)
replace F5 = round(F5,.1)
quietly reg ln_european_percent ln_instrument wwii_occupied ln_npmispc23x10k pd1800, robust
test ln_instrument
gen F6 = r(F)
replace F6 = round(F6,.1)
quietly reg ln_european_percent ln_instrument ln_exports_pc ln_resources_pc pd1800, robust
test ln_instrument
gen F7 = r(F)
replace F7 = round(F7,.1)
quietly reg ln_european_percent ln_instrument ln_pop ln_gdppc ef pd1800, robust
test ln_instrument
gen F8 = r(F)
replace F8 = round(F8,.1)
quietly reg ln_european_percent ln_instrument ln_slaves col_por ln_pop pd1800, robust
test ln_instrument
gen F9 = r(F)
replace F9 = round(F9,.1)
list F1 F2 F3 F4 F5 F6 F7 F8 F9 if country=="Angola"
drop F1 F2 F3 F4 F5 F6 F7 F8 F9

***************
***TABLE D12***
***************
use "dataset_tscs.dta", clear
ivreg v2elsuffrage (ln_european_percent = ln_instrument)  if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_iv_without, replace label nocon
ivreg v2elsuffrage (ln_european_percent = ln_instrument)  latitude statehist if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_iv_without, append label nocon
ivreg v2elsuffrage (ln_european_percent = ln_instrument)  ln_slaves hist_war if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_iv_without, append label nocon
ivreg v2elsuffrage (ln_european_percent = ln_instrument)  rugged ln_area if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_iv_without, append label nocon
ivreg v2elsuffrage (ln_european_percent = ln_instrument)  col_br col_fr col_por col_bel if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_iv_without, append label nocon
ivreg v2elsuffrage (ln_european_percent = ln_instrument)  wwii_occupied ln_npmispc23x10k if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_iv_without, append label nocon
ivreg v2elsuffrage (ln_european_percent = ln_instrument)  ln_exports_pc ln_resources_pc if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_iv_without, append label nocon
ivreg v2elsuffrage (ln_european_percent = ln_instrument)  ln_pop ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_iv_without, append label nocon
ivreg v2elsuffrage (ln_european_percent = ln_instrument)  ln_slaves col_br col_fr col_por wwii_occupied ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
outreg2 using franchise_iv_without, append label nocon tex(frag)
*F-tests
reg ln_european_percent ln_instrument  if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F1 = r(F)
replace F1 = round(F1,.1)
reg ln_european_percent ln_instrument  latitude statehist if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F2 = r(F)
replace F2 = round(F2,.1)
reg ln_european_percent ln_instrument  ln_slaves hist_war if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F3 = r(F)
replace F3 = round(F3,.1)
reg ln_european_percent ln_instrument  rugged ln_area if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F4 = r(F)
replace F4 = round(F4,.1)
reg ln_european_percent ln_instrument  col_br col_fr col_por col_bel if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F5 = r(F)
replace F5 = round(F5,.1)
reg ln_european_percent ln_instrument  wwii_occupied ln_npmispc23x10k  if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F6 = r(F)
replace F6 = round(F6,.1)
reg ln_european_percent ln_instrument  ln_exports_pc ln_resources_pc if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F7 = r(F)
replace F7 = round(F7,.1)
reg ln_european_percent ln_instrument  ln_pop ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F8 = r(F)
replace F8 = round(F8,.1)
reg ln_european_percent ln_instrument  ln_slaves col_br col_fr col_por wwii_occupied ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
test ln_instrument
gen F9 = r(F)
replace F9 = round(F9,.1)
list F1 F2 F3 F4 F5 F6 F7 F8 F9 if country=="Angola" & year==1945
drop F1 F2 F3 F4 F5 F6 F7 F8 F9

***************
***TABLE D13***
***************
use "dataset_cs.dta", clear
ivreg decol_war (ln_european_percent = ln_instrument) , robust
outreg2 using war_iv_without, replace label nocon
ivreg decol_war (ln_european_percent = ln_instrument)  latitude statehist, robust
outreg2 using war_iv_without, append label nocon
ivreg decol_war (ln_european_percent = ln_instrument) ln_slaves hist_war , robust
outreg2 using war_iv_without, append label nocon
ivreg decol_war (ln_european_percent = ln_instrument) rugged ln_area , robust
outreg2 using war_iv_without, append label nocon
ivreg decol_war (ln_european_percent = ln_instrument) col_br col_fr col_por col_bel  , robust
outreg2 using war_iv_without, append label nocon
ivreg decol_war (ln_european_percent = ln_instrument) wwii_occupied ln_npmispc23x10k , robust
outreg2 using war_iv_without, append label nocon
ivreg decol_war (ln_european_percent = ln_instrument) ln_exports_pc ln_resources_pc , robust
outreg2 using war_iv_without, append label nocon
ivreg decol_war (ln_european_percent = ln_instrument) ln_pop ln_gdppc ef , robust
outreg2 using war_iv_without, append label nocon
ivreg decol_war (ln_european_percent = ln_instrument) col_por  ln_pop , robust
outreg2 using war_iv_without, append label nocon tex(frag)
*F-tests
quietly reg ln_european_percent ln_instrument , robust
test ln_instrument
gen F1 = r(F)
replace F1 = round(F1,.1)
quietly reg ln_european_percent ln_instrument latitude statehist , robust
test ln_instrument
gen F2 = r(F)
replace F2 = round(F2,.1)
quietly reg ln_european_percent ln_instrument ln_slaves hist_war , robust
test ln_instrument
gen F3 = r(F)
replace F3 = round(F3,.1)
quietly reg ln_european_percent ln_instrument rugged ln_area , robust
test ln_instrument
gen F4 = r(F)
replace F4 = round(F4,.1)
quietly reg ln_european_percent ln_instrument col_br col_fr col_por col_bel  , robust
test ln_instrument
gen F5 = r(F)
replace F5 = round(F5,.1)
quietly reg ln_european_percent ln_instrument wwii_occupied ln_npmispc23x10k , robust
test ln_instrument
gen F6 = r(F)
replace F6 = round(F6,.1)
quietly reg ln_european_percent ln_instrument ln_exports_pc ln_resources_pc , robust
test ln_instrument
gen F7 = r(F)
replace F7 = round(F7,.1)
quietly reg ln_european_percent ln_instrument ln_pop ln_gdppc ef , robust
test ln_instrument
gen F8 = r(F)
replace F8 = round(F8,.1)
quietly reg ln_european_percent ln_instrument ln_slaves ln_pop , robust
test ln_instrument
gen F9 = r(F)
replace F9 = round(F9,.1)
list F1 F2 F3 F4 F5 F6 F7 F8 F9 if country=="Angola"
drop F1 F2 F3 F4 F5 F6 F7 F8 F9

*For Table D14, may need to install the plausexog package
*Command: ssc install plausexog
*After installation, command may not work without placing uci.ado into the current directory
*Available at: https://dataverse.harvard.edu/dataset.xhtml?persistentId=hdl:1902.1/18022&studyListingIndex=1_c94c91db8f29dede39f5f4d2e6cd

***************
***TABLE D14***
***************
*Franchise size
use "dataset_tscs.dta", clear
gen pvalue = .
gen delta95_1 = .
gen delta90_1 = .
gen delta95_2 = .
gen delta90_2 = .
gen delta95_3 = .
gen delta90_3 = .
gen delta95_4 = .
gen delta90_4 = .
gen delta95_5 = .
gen delta90_5 = .
gen delta95_6 = .
gen delta90_6 = .
gen delta95_7 = .
gen delta90_7 = .
gen delta95_8 = .
gen delta90_8 = .
gen delta95_9 = .
gen delta90_9 = .
gen coef_1 = .
gen coef_2 = .
gen coef_3 = .
gen coef_4 = .
gen coef_5 = .
gen coef_6 = .
gen coef_7 = .
gen coef_8 = .
gen coef_9 = .
gen percent95_1 = .
gen percent95_2 = .
gen percent95_3 = .
gen percent95_4 = .
gen percent95_5 = .
gen percent95_6 = .
gen percent95_7 = .
gen percent95_8 = .
gen percent95_9 = .
gen percent90_1 = .
gen percent90_2 = .
gen percent90_3 = .
gen percent90_4 = .
gen percent90_5 = .
gen percent90_6 = .
gen percent90_7 = .
gen percent90_8 = .
gen percent90_9 = .
foreach i of numlist -6(.01)0 {
	uci v2elsuffrage (ln_european_percent monarchy = ln_instrument monarchy) if year>=1955 & year<=1970, cluster(ccode) inst(ln_instrument) g1min(`i') g1max(`i') grid(2) level(.95)
	matrix G = r(table)	
	replace pvalue = G[4,1]
	replace delta95_1 = `i' if pvalue<0.05 & delta95_1==.
	replace delta90_1 = `i' if pvalue<0.1 & delta90_1==.
    }	
foreach i of numlist -6(.01)0 {
	uci v2elsuffrage (ln_european_percent latitude statehist monarchy = ln_instrument latitude statehist monarchy) if year>=1955 & year<=1970, cluster(ccode) inst(ln_instrument) g1min(`i') g1max(`i') grid(2) level(.95)
	matrix G = r(table)	
	replace pvalue = G[4,1]
	replace delta95_2 = `i' if pvalue<0.05 & delta95_2==.
	replace delta90_2 = `i' if pvalue<0.1 & delta90_2==.
    }	
foreach i of numlist -6(.01)0 {
	uci v2elsuffrage (ln_european_percent ln_slaves hist_war monarchy = ln_instrument ln_slaves hist_war monarchy) if year>=1955 & year<=1970, cluster(ccode) inst(ln_instrument) g1min(`i') g1max(`i') grid(2) level(.95)
	matrix G = r(table)	
	replace pvalue = G[4,1]
	replace delta95_3 = `i' if pvalue<0.05 & delta95_3==.
	replace delta90_3 = `i' if pvalue<0.1 & delta90_3==.
    }	
foreach i of numlist -6(.01)0 {
	uci v2elsuffrage (ln_european_percent rugged ln_area monarchy = ln_instrument rugged ln_area monarchy) if year>=1955 & year<=1970, cluster(ccode) inst(ln_instrument) g1min(`i') g1max(`i') grid(2) level(.95)
	matrix G = r(table)	
	replace pvalue = G[4,1]
	replace delta95_4 = `i' if pvalue<0.05 & delta95_4==.
	replace delta90_4 = `i' if pvalue<0.1 & delta90_4==.
    }	
foreach i of numlist -6(.01)0 {
	uci v2elsuffrage (ln_european_percent col_br col_fr col_por col_bel monarchy = ln_instrument col_br col_fr col_por col_bel monarchy) if year>=1955 & year<=1970, cluster(ccode) inst(ln_instrument) g1min(`i') g1max(`i') grid(2) level(.95)
	matrix G = r(table)	
	replace pvalue = G[4,1]
	replace delta95_5 = `i' if pvalue<0.05 & delta95_5==.
	replace delta90_5 = `i' if pvalue<0.1 & delta90_5==.
    }	
foreach i of numlist -6(.01)0 {
	uci v2elsuffrage (ln_european_percent wwii_occupied ln_npmispc23x10k monarchy = ln_instrument wwii_occupied ln_npmispc23x10k monarchy) if year>=1955 & year<=1970, cluster(ccode) inst(ln_instrument) g1min(`i') g1max(`i') grid(2) level(.95)
	matrix G = r(table)	
	replace pvalue = G[4,1]
	replace delta95_6 = `i' if pvalue<0.05 & delta95_6==.
	replace delta90_6 = `i' if pvalue<0.1 & delta90_6==.
    }	
foreach i of numlist -6(.01)0 {
	uci v2elsuffrage (ln_european_percent ln_exports_pc ln_resources_pc monarchy = ln_instrument ln_exports_pc ln_resources_pc monarchy) if year>=1955 & year<=1970, cluster(ccode) inst(ln_instrument) g1min(`i') g1max(`i') grid(2) level(.95)
	matrix G = r(table)	
	replace pvalue = G[4,1]
	replace delta95_7 = `i' if pvalue<0.05 & delta95_7==.
	replace delta90_7 = `i' if pvalue<0.1 & delta90_7==.
    }	
foreach i of numlist -8(.01)0 {
	uci v2elsuffrage (ln_european_percent ln_pop ln_gdppc ef monarchy = ln_instrument ln_pop ln_gdppc ef monarchy) if year>=1955 & year<=1970, cluster(ccode) inst(ln_instrument) g1min(`i') g1max(`i') grid(2) level(.95)
	matrix G = r(table)	
	replace pvalue = G[4,1]
	replace delta95_8 = `i' if pvalue<0.05 & delta95_8==.
	replace delta90_8 = `i' if pvalue<0.1 & delta90_8==.
    }	
foreach i of numlist -6(.01)0 {
	uci v2elsuffrage (ln_european_percent monarchy ln_slaves col_br col_fr col_por wwii_occupied ln_gdppc ef = ln_instrument monarchy ln_slaves col_br col_fr col_por wwii_occupied ln_gdppc ef) if year>=1955 & year<=1970, cluster(ccode) inst(ln_instrument) g1min(`i') g1max(`i') grid(2) level(.95)
	matrix G = r(table)	
	replace pvalue = G[4,1]
	replace delta95_9 = `i' if pvalue<0.05 & delta95_9==.
	replace delta90_9 = `i' if pvalue<0.1 & delta90_9==.
    }	
reg v2elsuffrage ln_instrument monarchy if year>=1955 & year<=1970, cluster(ccode)
replace coef_1 = _b[ln_instrument]
reg v2elsuffrage ln_instrument latitude statehist monarchy if year>=1955 & year<=1970, cluster(ccode)
replace coef_2 = _b[ln_instrument]
reg v2elsuffrage ln_instrument ln_slaves hist_war monarchy if year>=1955 & year<=1970, cluster(ccode)
replace coef_3 = _b[ln_instrument]
reg v2elsuffrage ln_instrument rugged ln_area monarchy if year>=1955 & year<=1970, cluster(ccode)
replace coef_4 = _b[ln_instrument]
reg v2elsuffrage ln_instrument col_br col_fr col_por col_bel monarchy if year>=1955 & year<=1970, cluster(ccode)
replace coef_5 = _b[ln_instrument]
reg v2elsuffrage ln_instrument wwii_occupied ln_npmispc23x10k monarchy if year>=1955 & year<=1970, cluster(ccode)
replace coef_6 = _b[ln_instrument]
reg v2elsuffrage ln_instrument ln_exports_pc ln_resources_pc monarchy if year>=1955 & year<=1970, cluster(ccode)
replace coef_7 = _b[ln_instrument]
reg v2elsuffrage ln_instrument ln_pop ln_gdppc ef monarchy if year>=1955 & year<=1970, cluster(ccode)
replace coef_8 = _b[ln_instrument]
reg v2elsuffrage ln_instrument monarchy ln_slaves col_br col_fr col_por wwii_occupied ln_gdppc ef if year>=1955 & year<=1970, cluster(ccode)
replace coef_9 = _b[ln_instrument]
replace percent95_1 = delta95_1/coef_1
replace percent95_1 = 100*round(percent95_1,.01)
replace percent95_2 = delta95_2/coef_2
replace percent95_2 = 100*round(percent95_2,.01)
replace percent95_3 = delta95_3/coef_3
replace percent95_3 = 100*round(percent95_3,.01)
replace percent95_4 = delta95_4/coef_4
replace percent95_4 = 100*round(percent95_4,.01)
replace percent95_5 = delta95_5/coef_5
replace percent95_5 = 100*round(percent95_5,.01)
replace percent95_6 = delta95_6/coef_6
replace percent95_6 = 100*round(percent95_6,.01)
replace percent95_7 = delta95_7/coef_7
replace percent95_7 = 100*round(percent95_7,.01)
replace percent95_8 = delta95_8/coef_8
replace percent95_8 = 100*round(percent95_8,.01)
replace percent95_9 = delta95_9/coef_9
replace percent95_9 = 100*round(percent95_9,.01)
replace percent90_1 = delta90_1/coef_1
replace percent90_1 = 100*round(percent90_1,.01)
replace percent90_2 = delta90_2/coef_2
replace percent90_2 = 100*round(percent90_2,.01)
replace percent90_3 = delta90_3/coef_3
replace percent90_3 = 100*round(percent90_3,.01)
replace percent90_4 = delta90_4/coef_4
replace percent90_4 = 100*round(percent90_4,.01)
replace percent90_5 = delta90_5/coef_5
replace percent90_5 = 100*round(percent90_5,.01)
replace percent90_6 = delta90_6/coef_6
replace percent90_6 = 100*round(percent90_6,.01)
replace percent90_7 = delta90_7/coef_7
replace percent90_7 = 100*round(percent90_7,.01)
replace percent90_8 = delta90_8/coef_8
replace percent90_8 = 100*round(percent90_8,.01)
replace percent90_9 = delta90_9/coef_9
replace percent90_9 = 100*round(percent90_9,.01)
list delta95_1 delta95_2 delta95_3 delta95_4 delta95_5 delta95_6 delta95_7 delta95_8 delta95_9 if country=="Algeria" & year==1945
list percent95_1 percent95_2 percent95_3 percent95_4 percent95_5 percent95_6 percent95_7 percent95_8 percent95_9 if country=="Algeria" & year==1945
list delta90_1 delta90_2 delta90_3 delta90_4 delta90_5 delta90_6 delta90_7 delta90_8 delta90_9 if country=="Algeria" & year==1945
list percent90_1 percent90_2 percent90_3 percent90_4 percent90_5 percent90_6 percent90_7 percent90_8 percent90_9 if country=="Algeria" & year==1945
drop pvalue delta95_1 delta95_2 delta95_3 delta95_4 delta95_5 delta95_6 delta95_7 delta95_8 delta95_9 /// 
percent95_1 percent95_2 percent95_3 percent95_4 percent95_5 percent95_6 percent95_7 percent95_8 percent95_9 ///
delta90_1 delta90_2 delta90_3 delta90_4 delta90_5 delta90_6 delta90_7 delta90_8 delta90_9 ///
percent90_1 percent90_2 percent90_3 percent90_4 percent90_5 percent90_6 percent90_7 percent90_8 percent90_9 ///
coef_1 coef_2 coef_3 coef_4 coef_5 coef_6 coef_7 coef_8 coef_9
*Liberation wars
use "dataset_cs.dta", clear
gen pvalue = .
gen delta95_1 = .
gen delta90_1 = .
gen delta95_2 = .
gen delta90_2 = .
gen delta95_3 = .
gen delta90_3 = .
gen delta95_4 = .
gen delta90_4 = .
gen delta95_5 = .
gen delta90_5 = .
gen delta95_6 = .
gen delta90_6 = .
gen delta95_7 = .
gen delta90_7 = .
gen delta95_8 = .
gen delta90_8 = .
gen delta95_9 = .
gen delta90_9 = .
gen coef_1 = .
gen coef_2 = .
gen coef_3 = .
gen coef_4 = .
gen coef_5 = .
gen coef_6 = .
gen coef_7 = .
gen coef_8 = .
gen coef_9 = .
gen percent95_1 = .
gen percent95_2 = .
gen percent95_3 = .
gen percent95_4 = .
gen percent95_5 = .
gen percent95_6 = .
gen percent95_7 = .
gen percent95_8 = .
gen percent95_9 = .
gen percent90_1 = .
gen percent90_2 = .
gen percent90_3 = .
gen percent90_4 = .
gen percent90_5 = .
gen percent90_6 = .
gen percent90_7 = .
gen percent90_8 = .
gen percent90_9 = .
foreach i of numlist 0(.001).1 {
	uci decol_war (ln_european_percent monarchy = ln_instrument monarchy), inst(ln_instrument) g1min(`i') g1max(`i') grid(2) level(.95) robust
	matrix G = r(table)	
	replace pvalue = G[4,1]
	replace delta95_1 = `i' if pvalue>0.05 & delta95_1==.
	replace delta90_1 = `i' if pvalue>0.1 & delta90_1==.
    }	
foreach i of numlist 0(.001).1 {
	uci decol_war (ln_european_percent latitude statehist monarchy = ln_instrument latitude statehist monarchy), inst(ln_instrument) g1min(`i') g1max(`i') grid(2) level(.95) robust
	matrix G = r(table)	
	replace pvalue = G[4,1]
	replace delta95_2 = `i' if pvalue>0.05 & delta95_2==.
	replace delta90_2 = `i' if pvalue>0.1 & delta90_2==.
    }	
foreach i of numlist 0(.001).1 {
	uci decol_war (ln_european_percent ln_slaves hist_war monarchy = ln_instrument ln_slaves hist_war monarchy), inst(ln_instrument) g1min(`i') g1max(`i') grid(2) level(.95) robust
	matrix G = r(table)	
	replace pvalue = G[4,1]
	replace delta95_3 = `i' if pvalue>0.05 & delta95_3==.
	replace delta90_3 = `i' if pvalue>0.1 & delta90_3==.
    }	
foreach i of numlist 0(.001).1 {
	uci decol_war (ln_european_percent rugged ln_area monarchy = ln_instrument rugged ln_area monarchy), inst(ln_instrument) g1min(`i') g1max(`i') grid(2) level(.95) robust
	matrix G = r(table)	
	replace pvalue = G[4,1]
	replace delta95_4 = `i' if pvalue>0.05 & delta95_4==.
	replace delta90_4 = `i' if pvalue>0.1 & delta90_4==.
    }	
foreach i of numlist 0(.001).1 {
	uci decol_war (ln_european_percent col_br col_fr col_por col_bel  monarchy = ln_instrument col_br col_fr col_por col_bel  monarchy), inst(ln_instrument) g1min(`i') g1max(`i') grid(2) level(.95) robust
	matrix G = r(table)	
	replace pvalue = G[4,1]
	replace delta95_5 = `i' if pvalue>0.05 & delta95_5==.
	replace delta90_5 = `i' if pvalue>0.1 & delta90_5==.
    }	
foreach i of numlist 0(.001).1 {
	uci decol_war (ln_european_percent wwii_occupied ln_npmispc23x10k monarchy = ln_instrument wwii_occupied ln_npmispc23x10k monarchy), inst(ln_instrument) g1min(`i') g1max(`i') grid(2) level(.95) robust
	matrix G = r(table)	
	replace pvalue = G[4,1]
	replace delta95_6 = `i' if pvalue>0.05 & delta95_6==.
	replace delta90_6 = `i' if pvalue>0.1 & delta90_6==.
    }
foreach i of numlist 0(.001).1 {
	uci decol_war (ln_european_percent ln_exports_pc ln_resources_pc monarchy = ln_instrument ln_exports_pc ln_resources_pc monarchy), inst(ln_instrument) g1min(`i') g1max(`i') grid(2) level(.95) robust
	matrix G = r(table)	
	replace pvalue = G[4,1]
	replace delta95_7 = `i' if pvalue>0.05 & delta95_7==.
	replace delta90_7 = `i' if pvalue>0.1 & delta90_7==.
    }	
foreach i of numlist 0(.001).1 {
	uci decol_war (ln_european_percent ln_pop ln_gdppc ef monarchy = ln_instrument ln_pop ln_gdppc ef monarchy), inst(ln_instrument) g1min(`i') g1max(`i') grid(2) level(.95) robust
	matrix G = r(table)	
	replace pvalue = G[4,1]
	replace delta95_8 = `i' if pvalue>0.05 & delta95_8==.
	replace delta90_8 = `i' if pvalue>0.1 & delta90_8==.
    }	
foreach i of numlist 0(.001).1 {
	uci decol_war (ln_european_percent col_por  ln_pop monarchy = ln_instrument col_por  ln_pop monarchy), inst(ln_instrument) g1min(`i') g1max(`i') grid(2) level(.95) robust
	matrix G = r(table)	
	replace pvalue = G[4,1]
	replace delta95_9 = `i' if pvalue>0.05 & delta95_9==.
	replace delta90_9 = `i' if pvalue>0.1 & delta90_9==.
    }	
reg decol_war ln_instrument monarchy, robust
replace coef_1 = _b[ln_instrument]
reg decol_war ln_instrument latitude statehist monarchy, robust
replace coef_2 = _b[ln_instrument]
reg decol_war ln_instrument ln_slaves hist_war monarchy, robust
replace coef_3 = _b[ln_instrument]
reg decol_war ln_instrument rugged ln_area monarchy, robust
replace coef_4 = _b[ln_instrument]
reg decol_war ln_instrument col_br col_fr col_por col_bel  monarchy, robust
replace coef_5 = _b[ln_instrument]
reg decol_war ln_instrument wwii_occupied ln_npmispc23x10k monarchy, robust
replace coef_6 = _b[ln_instrument]
reg decol_war ln_instrument ln_exports_pc ln_resources_pc monarchy, robust
replace coef_7 = _b[ln_instrument]
reg decol_war ln_instrument ln_pop ln_gdppc ef monarchy, robust
replace coef_8 = _b[ln_instrument]
reg decol_war ln_instrument col_por ln_pop monarchy, robust
replace coef_9 = _b[ln_instrument]
replace percent95_1 = delta95_1/coef_1
replace percent95_1 = 100*round(percent95_1,.01)
replace percent95_2 = delta95_2/coef_2
replace percent95_2 = 100*round(percent95_2,.01)
replace percent95_3 = delta95_3/coef_3
replace percent95_3 = 100*round(percent95_3,.01)
replace percent95_4 = delta95_4/coef_4
replace percent95_4 = 100*round(percent95_4,.01)
replace percent95_5 = delta95_5/coef_5
replace percent95_5 = 100*round(percent95_5,.01)
replace percent95_6 = delta95_6/coef_6
replace percent95_6 = 100*round(percent95_6,.01)
replace percent95_7 = delta95_7/coef_7
replace percent95_7 = 100*round(percent95_7,.01)
replace percent95_8 = delta95_8/coef_8
replace percent95_8 = 100*round(percent95_8,.01)
replace percent95_9 = delta95_9/coef_9
replace percent95_9 = 100*round(percent95_9,.01)
replace percent90_1 = delta90_1/coef_1
replace percent90_1 = 100*round(percent90_1,.01)
replace percent90_2 = delta90_2/coef_2
replace percent90_2 = 100*round(percent90_2,.01)
replace percent90_3 = delta90_3/coef_3
replace percent90_3 = 100*round(percent90_3,.01)
replace percent90_4 = delta90_4/coef_4
replace percent90_4 = 100*round(percent90_4,.01)
replace percent90_5 = delta90_5/coef_5
replace percent90_5 = 100*round(percent90_5,.01)
replace percent90_6 = delta90_6/coef_6
replace percent90_6 = 100*round(percent90_6,.01)
replace percent90_7 = delta90_7/coef_7
replace percent90_7 = 100*round(percent90_7,.01)
replace percent90_8 = delta90_8/coef_8
replace percent90_8 = 100*round(percent90_8,.01)
replace percent90_9 = delta90_9/coef_9
replace percent90_9 = 100*round(percent90_9,.01)
list delta95_1 delta95_2 delta95_3 delta95_4 delta95_5 delta95_6 delta95_7 delta95_8 delta95_9 if country=="Algeria"
list percent95_1 percent95_2 percent95_3 percent95_4 percent95_5 percent95_6 percent95_7 percent95_8 percent95_9 if country=="Algeria"
list delta90_1 delta90_2 delta90_3 delta90_4 delta90_5 delta90_6 delta90_7 delta90_8 delta90_9 if country=="Algeria"
list percent90_1 percent90_2 percent90_3 percent90_4 percent90_5 percent90_6 percent90_7 percent90_8 percent90_9 if country=="Algeria"
drop pvalue delta95_1 delta95_2 delta95_3 delta95_4 delta95_5 delta95_6 delta95_7 delta95_8 delta95_9 /// 
percent95_1 percent95_2 percent95_3 percent95_4 percent95_5 percent95_6 percent95_7 percent95_8 percent95_9 ///
delta90_1 delta90_2 delta90_3 delta90_4 delta90_5 delta90_6 delta90_7 delta90_8 delta90_9 ///
percent90_1 percent90_2 percent90_3 percent90_4 percent90_5 percent90_6 percent90_7 percent90_8 percent90_9 ///
coef_1 coef_2 coef_3 coef_4 coef_5 coef_6 coef_7 coef_8 coef_9

**************
***TABLE E1***
**************
use "dataset_cs.dta", clear
reg land_alienation ln_instrument, robust
outreg2 using land, replace label nocon
reg land_alienation ln_european_percent, robust
outreg2 using land, append label nocon
logit sig_private_land ln_instrument, robust
outreg2 using land, append label nocon
logit sig_private_land ln_european_percent, robust
outreg2 using land, append label nocon
use "dataset_tscs.dta", clear
reg v2elsuffrage land_alienation if year>=1955 & year<=1970, cluster(ccode)
outreg2 using land, append label nocon
reg v2elsuffrage sig_private_land if year>=1955 & year<=1970, cluster(ccode)
outreg2 using land, append label nocon
use "dataset_cs.dta", clear
logit decol_war land_alienation, robust
outreg2 using land, append label nocon
logit decol_war sig_private_land, robust
outreg2 using land, append tex(frag) label nocon
