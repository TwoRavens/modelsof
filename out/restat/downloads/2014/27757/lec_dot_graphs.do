*************************************************************
* LEC_DOT_GRAPHS.DO 
*
* Program that graphs Local Economic Conditions (LEC) data 
* as dot graphs
*
* Creates Figure 2 in Flores, Carlos A. and Oscar A. Mitnik (2013). 
* "Comparing Treatments across Labor Markets: An Assessment of Nonexperimental Multiple-Treatment Strategies",
* Review of Economics and Statistics, December 2013, Vol. 95, No. 5, Pages 1691-1707.
*
*
* Version: November, 2012 
*************************************************************

* Directories
local datadir ""		// Main data location directory
local figsdir ""		// Directory where figures will be saved

capture log using "`figsdir'lec_dot_graphs.log", replace

use "`datadir'analysis.dta", clear

* Express earnings in $1,000nds
foreach v of varlist avg_tot_rern_1 avg_tot_rern_2 avg_tot_rern1 avg_tot_rern2 {
	replace `v' = `v'/1000
}

* Figure 2 - Local economic conditions overlap

* Before RA
graph dot tot_emp_pop_1 tot_emp_pop_2, over(radatp) over(alphsite, relabel(1 "ATL" 2 "DET" 3 "GRP" 4 "POR" 5 "RIV") label(labsize(small))) ascategory legend(label(1 "Year 1 before RA") label (2 "Year 2 before RA") size(small)) marker(1, msymbol(Oh)) marker(2, msymbol(X) msize(large) mcolor(black)) yvaroptions(label(labsize(small))) title(Employment/population ratio before RA, size(medium) color(black)) ylabel(#10) name(g1b, replace) graphregion(fcolor(none))

graph dot unemp_rate_1 unemp_rate_2, over(radatp) over(alphsite, relabel(1 "ATL" 2 "DET" 3 "GRP" 4 "POR" 5 "RIV") label(labsize(small))) ascategory legend(label(1 "Year 1 before RA") label (2 "Year 2 before RA") size(small)) marker(1, msymbol(Oh)) marker(2, msymbol(X) msize(large) mcolor(black)) yvaroptions(label(labsize(small))) title(Unemployment rate before RA, size(medium) color(black)) ylabel(#10) name(g2b, replace) graphregion(fcolor(none))

graph dot avg_tot_rern_1 avg_tot_rern_2, over(radatp) over(alphsite, relabel(1 "ATL" 2 "DET" 3 "GRP" 4 "POR" 5 "RIV") label(labsize(small))) ascategory legend(label(1 "Year 1 before RA") label (2 "Year 2 before RA") size(small)) marker(1, msymbol(Oh)) marker(2, msymbol(X) msize(large) mcolor(black)) yvaroptions(label(labsize(small))) title(Average real earnings ($1,000) before RA, size(medium) color(black)) ylabel(#10) yscale(range(0 40)) name(g3b, replace) graphregion(fcolor(none))


* After RA
graph dot tot_emp_pop1 tot_emp_pop2, over(radatp) over(alphsite, relabel(1 "ATL" 2 "DET" 3 "GRP" 4 "POR" 5 "RIV") label(labsize(small))) ascategory legend(label(1 "Year 1 after RA") label (2 "Year 2 after RA") size(small)) marker(1, msymbol(Oh)) marker(2, msymbol(X) msize(large) mcolor(black)) yvaroptions(label(labsize(small))) title(Employment/population ratio after RA, size(medium) color(black)) ylabel(#10) name(g1a, replace) graphregion(fcolor(none))

graph dot unemp_rate1 unemp_rate2, over(radatp) over(alphsite, relabel(1 "ATL" 2 "DET" 3 "GRP" 4 "POR" 5 "RIV") label(labsize(small))) ascategory legend(label(1 "Year 1 after RA") label (2 "Year 2 after RA") size(small)) marker(1, msymbol(Oh)) marker(2, msymbol(X) msize(large) mcolor(black)) yvaroptions(label(labsize(small))) title(Unemployment rate after RA, size(medium) color(black)) ylabel(#10) name(g2a, replace) graphregion(fcolor(none))

graph dot avg_tot_rern1 avg_tot_rern2, over(radatp) over(alphsite, relabel(1 "ATL" 2 "DET" 3 "GRP" 4 "POR" 5 "RIV") label(labsize(small))) ascategory legend(label(1 "Year 1 after RA") label (2 "Year 2 after RA") size(small)) marker(1, msymbol(Oh)) marker(2, msymbol(X) msize(large) mcolor(black)) yvaroptions(label(labsize(small))) title(Average real earnings ($1,000) after RA, size(medium) color(black)) ylabel(#10) name(g3a, replace) graphregion(fcolor(none))

* Combine in landscape figure
graph combine g1b g1a g2b g2a g3b g3a, cols(3) colfirst xsize(10.8) ysize(8.1) iscale(*.8) title("Figure 2. Local economic conditions overlap" "By site and random assignment cohort",size(small) color(black)) imargin(tiny) graphregion(fcolor(none)) name(graph_lec_comb, replace) 
graph save "`figsdir'Figure_2.gph", replace
graph export "`figsdir'Figure_2.ps", logo(off) orientation(landscape) pagesize(letter) tm(.1) lm(.17) replace 
if "`c(os)'"== "Windows" graph export "`figsdir'Figure_2.png", height (2400) replace

log close
