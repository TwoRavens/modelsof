set more off
local sub0 "Period before votes in press release"
local sub1 "Period with votes in press release"
local tp=1 
local sw = ${sw_op} //2 3
local sw_min = -`sw'
local sw_max = `sw'
local d_range = "`sw_min'(1)`sw_max'"
local sw1 = "S&P S&P NASDAQ" //"S&P S&P NASDAQ"

// 2002-07
use "$path3\T2pm_dissent.dta", clear
keep if FOMC_public==`tp' 
drop if year<2002
drop if year>2007
drop if year==2007 & month>=3  //& quarter>=2
drop if year==2007 & month==2 & day>=20  //rename vs2_S_P500_p_exreturn S_P500_p_exreturn   //rename vs2_NASDAQ_p_exreturn NASDAQ_p_exreturn
collapse SP_open_exreturn* NASDAQ_p_exreturn, by(window1 dissent)  //S_P500_p_exreturn
xtset dissent window1
label variable dissent "dissent"
label def dissent_l 0 "Unanimity" 1 "Dissent"
label values dissent dissent_l
local i=1
foreach x of varlist SP_open_exreturn NASDAQ_p_exreturn { //S_P500_p_exreturn
local sw =  word("`sw1'",`i')
label variable `x' "`sw'"
local i = 1+`i'		
}
xtline SP_open_exreturn2 NASDAQ_p_exreturn, /// S_P500_p_exreturn
byopts() xlabel(`d_range') xtick(`d_range') ///
ylabel() ytick() byopts(note("")) lp("l" "_...") lwidth(medthick medthick) ///
legend(cols(2) span  forcesize) xtitle("Day from FOMC decision, March 2002 - January 2007") //ytitle("March 2002 - January 2007") 
graph save "$path_g\graph1.gph", replace
xtline SP_open_exreturn2, /// S_P500_p_exreturn
byopts() xlabel(`d_range') xtick(`d_range') ///
ylabel() ytick() byopts(note("")) lp("l" "_...") lwidth(medthick medthick) ///
legend(cols(2) span  forcesize) xtitle("Day from FOMC decision, March 2002 - January 2007") //ytitle("March 2002 - January 2007") 
graph save "$path_g\graph11.gph", replace


// 2007-09
use "$path3\T2pm_dissent.dta", clear
keep if FOMC_public==`tp' 
drop if year<2002
drop if year<2007
drop if year==2007 & month<=1 //& quarter<=1
drop if year==2007 & month==2 & day<=19
drop if year>2009
drop if year==2009 & month>=7 //& quarter>=3  //rename vs2_S_P500_p_exreturn S_P500_p_exreturn //rename vs2_NASDAQ_p_exreturn NASDAQ_p_exreturn
collapse SP_open_exreturn* NASDAQ_p_exreturn, by(window1 dissent) //S_P500_p_exreturn
xtset dissent window1
label variable dissent "dissent"
label def dissent_l 0 "Unanimity" 1 "Dissent"
label values dissent dissent_l
local i=1
foreach x of varlist SP_open_exreturn NASDAQ_p_exreturn {  //S_P500_p_exreturn 
local sw =  word("`sw1'",`i')
label variable `x' "`sw'"
local i = 1+`i'		
}
xtline SP_open_exreturn2 NASDAQ_p_exreturn, /// S_P500_p_exreturn
byopts(legend(off)) xlabel(`d_range') xtick(`d_range') ///
ylabel() ytick() byopts(note("")) lp("l" "_...") lwidth(medthick medthick) ///
xtitle("February 2007 - June 2009") //ytitle("") 
graph save "$path_g\graph3.gph", replace
xtline SP_open_exreturn2, /// S_P500_p_exreturn
byopts(legend(off)) xlabel(`d_range') xtick(`d_range') ///
ylabel() ytick() byopts(note("")) lp("l" "_...") lwidth(medthick medthick) ///
xtitle("February 2007 - June 2009") //ytitle("") 
graph save "$path_g\graph13.gph", replace

// 2009-14
use "$path3\T2pm_dissent.dta", clear
keep if FOMC_public==`tp' 
drop if year<2002
drop if year<2009
drop if year==2009 & month<=6 //& quarter<=2  //rename vs2_S_P500_p_exreturn S_P500_p_exreturn //rename vs2_NASDAQ_p_exreturn NASDAQ_p_exreturn
collapse SP_open_exreturn* NASDAQ_p_exreturn, by(window1 dissent)  // S_P500_p_exreturn
xtset dissent window1
label variable dissent "dissent"
label def dissent_l 0 "Unanimity" 1 "Dissent"
label values dissent dissent_l
local i=1
foreach x of varlist SP_open_exreturn NASDAQ_p_exreturn { //S_P500_p_exreturn
local sw =  word("`sw1'",`i')
label variable `x' "`sw'"
local i = 1+`i'		
}
xtline SP_open_exreturn2 NASDAQ_p_exreturn, /// S_P500_p_exreturn
byopts(legend(off)) xlabel(`d_range') xtick(`d_range') ///
ylabel() ytick() byopts(note("")) lp("l" "_...") lwidth(medthick medthick) ///
xtitle("July 2009 - January 2018") //ytitle("July 2009 - January 2016") 
graph save "$path_g\graph4.gph", replace
xtline SP_open_exreturn2, /// S_P500_p_exreturn
byopts(legend(off)) xlabel(`d_range') xtick(`d_range') ///
ylabel() ytick() byopts(note("")) lp("l" "_...") lwidth(medthick medthick) ///
xtitle("July 2009 - January 2018") //ytitle("July 2009 - January 2016") 
graph save "$path_g\graph14.gph", replace

// 2007-14
use "$path3\T2pm_dissent.dta", clear
keep if FOMC_public==`tp' 
drop if year<2002
drop if year<2007
drop if year==2007 & month<=1 //& quarter<=1
drop if year==2007 & month==2 & day<=19 //rename vs2_S_P500_p_exreturn S_P500_p_exreturn //rename vs2_NASDAQ_p_exreturn NASDAQ_p_exreturn
collapse SP_open_exreturn* NASDAQ_p_exreturn, by(window1 dissent) //S_P500_p_exreturn 
xtset dissent window1
label variable dissent "dissent"
label def dissent_l 0 "Unanimity" 1 "Dissent"
label values dissent dissent_l
local i=1
foreach x of varlist SP_open_exreturn NASDAQ_p_exreturn { //S_P500_p_exreturn
local sw =  word("`sw1'",`i')
label variable `x' "`sw'"
local i = 1+`i'		
}
xtline SP_open_exreturn2 NASDAQ_p_exreturn, /// S_P500_p_exreturn
byopts(legend(off)) xlabel(`d_range') xtick(`d_range') ///
ylabel() ytick() byopts(note("")) /// ylabel(-0.20(0.10)0.40) ytick(-0.20(0.05)0.40) 
lp("l" "_...") lwidth(medthick medthick) ///
xtitle("February 2007 - January 2018") //ytitle("February 2007 - January 2016")
graph save "$path_g\graph2.gph", replace
xtline SP_open_exreturn2, /// S_P500_p_exreturn
byopts(legend(off)) xlabel(`d_range') xtick(`d_range') ///
ylabel() ytick() byopts(note("")) /// ylabel(-0.20(0.10)0.40) ytick(-0.20(0.05)0.40) 
lp("l" "_...") lwidth(medthick medthick) ///
xtitle("February 2007 - January 2018") //ytitle("February 2007 - January 2016")
graph save "$path_g\graph12.gph", replace

graph combine "$path_g\graph1.gph" "$path_g\graph2.gph" "$path_g\graph3.gph" "$path_g\graph4.gph", ///
graphregion(color(white) lcolor(white) icolor(white)) 
graph export "$path_g\CAR_pers.emf", replace
graph combine "$path_g\graph11.gph" "$path_g\graph12.gph" "$path_g\graph13.gph" "$path_g\graph14.gph", ///
graphregion(color(white) lcolor(white) icolor(white)) 
graph export "$path_g\SP500_CAR_pers.emf", replace
