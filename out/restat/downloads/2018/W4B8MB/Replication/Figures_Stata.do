capture mkdir images


*Figure 1
***********
use figure_1a.dta, replace

scatter flow_shr_trade free_flow_shr_trade flow_shr_cites free_flow_shr_cites dist, c(l l l l) s(i i i i) scheme(s1mono)   ///
col(blue blue black black) lpattern (solid dash solid dash) legend(off) xtit("Distance (km)")    ///
ytit("Share of flow w/ dist{subscript: jn} {&ge}  x-axis Distance") text(.07 2500 "Trade", col(blue)) text(.725 8000 "Benchmark: trade", col(blue))   ///
text(.47 3500 "Cites") text(.615 5000 "Benchmark:")  text(.58 5000 "Cites") xsize(3.5) ysize(3)

graph export images/figure_1a.pdf, replace


use figure_1b.dta, replace

local d1=1800*1.61
local d2=740*1.61
local d3=1750*1.61

scatter cites_shr trade_shr cites_free_shr trade_free_shr dist if dist<5000,  ///
scheme(s1color) c(l l l l) s(i i i i ) ///
col(black blue black blue) lpattern(solid solid dash dash)  ///
legend(off) text(0.4 `d2' "Cites") text(0.38 `d3' "Benchmark: cites", col(black)) ///
text(0.9 1400 "Benchmark: trade", col(blue)) ///
text(0.27 1000 "Trade", col(blue)) xtit("Distance (km)") ///
ytit("Share of flow w/ dist{subscript: jn} {&ge}  x-axis Distance") xsize(3.5) ysize(3)

graph export images/figure_1b.pdf, replace



*Figure 2
**********
u figure_2.dta, clear

scatter cpr dist if dist>1 & spec==7, xscale(log) ms(S) color(blue) ylab(0 -0.5 -1 -1.5 -2) ///
xlab(2.5  10 25 50 100 500 1000 5000) || scatter cpr dist if dist>1 & spec==6, /// 
scheme(s1color) legend(off) color(black)  text(-0.6 1500 "Geo+Ties", col(black)) ///
text(-1.6 1500 "Geo", col(blue)) text(-0.05 100 "Same university", col(gray)) ///
|| scatter cpr_2p dist if spec==6 & dist>1, c(l) s(i) col(black) /// 
|| scatter cpr_2p dist if spec==7 & dist>1, c(l) s(i) col(blue) ///
|| rcap cpr_max cpr_min dist if spec==6 & dist>1, col(black) ///
|| rcap cpr_max cpr_min dist if spec==7 & dist>1, col(blue) ///
yline(0,lcol(gray) lpat(dash)) ytit("reduction in log odds of citation") 

graph export images/figure_2.pdf, replace


*Figures 3a and 3b
*******************
u  figure_3a.dta, replace

twoway (line ecdf dist if group=="no ties",col(blue) lp(dash) ) (line ecdf dist if group=="1 tie", col(black) ) (line ecdf dist if group==">1 tie", col(red) ), ///
scheme(s1color) legend(off) xtitle("Distance (km.)") ytitle("Share of pairs at a larger distance") ///
text(0.27 4600 ">1 tie", col(red)) text(0.37 5000 "1 tie", col(black)) text(0.6 4800 "No ties", col(blue) place(3)) xsize(5) ysize(5)

graph export images/figure_3a.pdf, replace 

u figure_3b.dta, clear

twoway (line ecdf dist if group=="All author pairs", col(blue) lp(dash) ) (line ecdf dist if group=="Alma mater", col(black) ),      ///
scheme(s1color) legend(off) xtitle("Distance (km.)") ytitle("Share of pairs at a larger distance")    ///
text(0.6 6500 "All author pairs",col(blue)) text(0.25 5000 "Alma Mater") xsize(5) ysize(5)
graph export images/figure_3b.pdf, replace 



*Figures 6a and 6b
*******************
u figure_6a.dta, replace

twoway (scatter google_index year, c(l) s(i) yaxis(1) col(black))  (scatter arxiv_index   year, c(l) s(i) yaxis(2) col(blue)),   ///
scheme(s1color) legend(off) text(25 1998.3 "arXiv articles", col(blue))   ///
text(33 2008.5 "Google", col(black)) text(28 2009 "searches", col(black))     ///
xtit("")  xscale(range(1998 2012)) xlabel(1993 1998 2003 2008 2012)   ///
ytit("Googles searches (Year 2000=1)", axis(1))  ///
ytit("arXiv articles (Year 2000=1)", axis(2) col(blue))  ///
xline(2004.9, lpattern(solid) lcolor(red)) xline(2003.67, lpattern(dash) lcolor(green)) ///
text(140 2002 "Skype", col(green)) text(140 2007 "Google", col(red)) text(135 2007 "scholar", col(red)) xsize(5) ysize(5)
graph export images/figure_6a.pdf, replace


u figure_6b, replace

twoway (scatter inter_cons year, c(l) s(i) col(blue)) (scatter state_cons year, c(l) s(i) col(black)),     ///
scheme(s1color) legend(off) xtit("") ytit("Revenue per minute calll (2010 $)") xlabel(1990 1995 2000 2005 2007)  ///
text(.12 1993.2 "Interstate call", col(black)) text(1.6 1995 "International call", col(blue)) xsize(5) ysize(5)  ylabel(0.5 1 1.5)
graph export images/figure_6b.pdf, replace






*Figures A1a and A1b
**************************
use evo_n_insti.dta, clear 
keep year_o n_insti
sort year_o
ren n_insti n_insti_WOS

merge 1:1 year_o using evo_n_insti_mgp.dta
label var n_insti_WOS "Institutions (WOS)"
label var n_insti "Institutions (MGP)"
label var year_o "Year"

twoway (line n_insti year_o, lw(thick) ) (line n_insti_WOS year_o, lp(dash) lw(thick)), ///
legend(on order(1 "Institutions (WOS)" 2 "Institutions (MGP)" ))xlabel(1975(5)2009) ///
scheme(s1mono) legend(off) text(100 1993 "MGP") text(725 1993 "WOS") xsize(5) ysize(5)

graph export "images/figure_A1a.pdf", replace 


use evo_n_countries.dta, clear 
sort year_o
ren n_countries n_countries_WOS

merge 1:1 year_o using evo_n_countries_mgp.dta

label var n_countries_WOS "countries (WOS)"
label var n_countries  "countries (MGP)"
label var year_o "Year"

twoway (line n_countries  year_o, lw(thick) ) (line n_countries_WOS year_o, lp(dash) lw(thick)), ///
legend(on order(1 "countries (WOS)" 2 "countries (MGP)" ))xlabel(1975(5)2009) ///
scheme(s1mono) legend(off) text(22 1993 "MGP") text(57 1993 "WOS") xsize(5) ysize(5)

graph export images/figure_A1b.pdf, replace 








