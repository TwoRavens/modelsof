clear all
import delimited "01_data/cleaned_data/data_fullyear_03_11.csv"

keep if appalrdplayincludebw1 == 1 

* All Votes

bysort year state: egen yearly_mean = mean(pro_env)

gen treated_mean = yearly_mean if appalplayz == 1
bysort year: egen treated_mean1 = mean(treated_mean)
label var treated_mean1 "Treated Units"

gen control_mean = yearly_mean if appalplayz == 0
bysort year: egen control_mean1 = mean(control_mean)
label var control_mean1 "Control Units"

twoway (line treated_mean1 year if year < 2005, lcolor(black) lpattern(solid)) ///
	   (line control_mean1 year if year < 2005, lcolor(black) lpattern(dash)) ///
	   (line treated_mean1 year if year >= 2004 & year < 2011, lcolor(gs11) lpattern(solid)) ///
	   (line control_mean1 year if year >= 2004 & year < 2011, lcolor(gs11) lpattern(dash)) ///
	   (line treated_mean1 year if year >= 2010, lcolor(black) lpattern(solid)) ///
	   (line control_mean1 year if year >= 2010, lcolor(black) lpattern(dash)) ///
	   , xline(2004 2010, lpattern(dot) lcolor(red)) legend(on order (1 2 3 4) size(small) nobox region(fcolor(none) lcolor(none)) label(1 "Shale (In the Sample)") label(2 "Non-Shale (In the Sample)") label(3 "Shale (Not in the Sample)") label(4 "Non-Shale (Not in the Sample)")) ///
		ytitle(Pro-Environment Votes (%)) xtitle(Year) ///
		title(Votes on All Environmental Bills, size(medium)) xscale(range(2003 2011)) xlabel(2003(2)2011) yscale(range(0 1)) ylabel(0(0.2)1) graphregion(fcolor(none) lcolor(none) ifcolor(none) ilcolor(none)) plotregion(fcolor(none) lcolor(none) ifcolor(none) ilcolor(none)) 

graph save Graph "03_figures/figure_2_all.gph", replace


* Dirty Energy Votes

clear
import delimited "01_data/cleaned_data/data_fullyear_03_11.csv"

keep if appalrdplayincludebw1 == 1 & dirty_energy == 1 

bysort year state: egen yearly_mean = mean(pro_env)

gen treated_mean = yearly_mean if appalplayz == 1
bysort year: egen treated_mean1 = mean(treated_mean)
label var treated_mean1 "Treated Units"

gen control_mean = yearly_mean if appalplayz == 0
bysort year: egen control_mean1 = mean(control_mean)
label var control_mean1 "Control Units"

twoway (line treated_mean1 year if year < 2005, lcolor(black) lpattern(solid)) ///
	   (line control_mean1 year if year < 2005, lcolor(black) lpattern(dash)) ///
	   (line treated_mean1 year if year >= 2004 & year < 2011, lcolor(gs11) lpattern(solid)) ///
	   (line control_mean1 year if year >= 2004 & year < 2011, lcolor(gs11) lpattern(dash)) ///
	   (line treated_mean1 year if year >= 2010, lcolor(black) lpattern(solid)) ///
	   (line control_mean1 year if year >= 2010, lcolor(black) lpattern(dash)) ///
	   , xline(2004 2010, lpattern(dot) lcolor(red)) legend(on order (1 2 3 4) size(small) nobox region(fcolor(none) lcolor(none)) label(1 "Shale (In the Sample)") label(2 "Non-Shale (In the Sample)") label(3 "Shale (Not in the Sample)") label(4 "Non-Shale (Not in the Sample)")) ///
		title(Votes on Conventional Energy Bills, size(medium)) xscale(range(2003 2011)) xlabel(2003(2)2011) yscale(range(0 1)) ylabel(0(0.2)1) graphregion(fcolor(none) lcolor(none) ifcolor(none) ilcolor(none)) plotregion(fcolor(none) lcolor(none) ifcolor(none) ilcolor(none)) 

graph save Graph "03_figures/figure_2_conventional.gph", replace


* Drilling Votes

clear
import delimited "01_data/cleaned_data/data_fullyear_03_11.csv"

keep if appalrdplayincludebw1 == 1 & drilling == 1 

bysort year state: egen yearly_mean = mean(pro_env)

gen treated_mean = yearly_mean if appalplayz == 1
bysort year: egen treated_mean1 = mean(treated_mean)
label var treated_mean1 "Treated Units"

gen control_mean = yearly_mean if appalplayz == 0
bysort year: egen control_mean1 = mean(control_mean)
label var control_mean1 "Control Units"

twoway (line treated_mean1 year if year < 2005, lcolor(black) lpattern(solid)) ///
	   (line control_mean1 year if year < 2005, lcolor(black) lpattern(dash)) ///
	   (line treated_mean1 year if year >= 2004 & year < 2011, lcolor(gs11) lpattern(solid)) ///
	   (line control_mean1 year if year >= 2004 & year < 2011, lcolor(gs11) lpattern(dash)) ///
	   (line treated_mean1 year if year >= 2010, lcolor(black) lpattern(solid)) ///
	   (line control_mean1 year if year >= 2010, lcolor(black) lpattern(dash)) ///
	   , xline(2004 2010, lpattern(dot) lcolor(red)) legend(on order (1 2 3 4) size(small) nobox region(fcolor(none) lcolor(none)) label(1 "Shale (In the Sample)") label(2 "Non-Shale (In the Sample)") label(3 "Shale (Not in the Sample)") label(4 "Non-Shale (Not in the Sample)")) ///
	   title(Votes on Drilling Bills, size(medium)) xscale(range(2003 2011)) xlabel(2003(2)2011) yscale(range(0 1)) ylabel(0(0.2)1) graphregion(fcolor(none) lcolor(none) ifcolor(none) ilcolor(none)) plotregion(fcolor(none) lcolor(none) ifcolor(none) ilcolor(none)) 

graph save Graph "03_figures/figure_2_drilling.gph", replace


* Land Votes

clear
import delimited "01_data/cleaned_data/data_fullyear_03_11.csv"

keep if appalrdplayincludebw1 == 1 & lands == 1 

bysort year state: egen yearly_mean = mean(pro_env)

gen treated_mean = yearly_mean if appalplayz == 1
bysort year: egen treated_mean1 = mean(treated_mean)
label var treated_mean1 "Treated Units"

gen control_mean = yearly_mean if appalplayz == 0
bysort year: egen control_mean1 = mean(control_mean)
label var control_mean1 "Control Units"

twoway (line treated_mean1 year if year < 2005, lcolor(black) lpattern(solid)) ///
	   (line control_mean1 year if year < 2005, lcolor(black) lpattern(dash)) ///
	   (line treated_mean1 year if year >= 2004 & year < 2011, lcolor(gs11) lpattern(solid)) ///
	   (line control_mean1 year if year >= 2004 & year < 2011, lcolor(gs11) lpattern(dash)) ///
	   (line treated_mean1 year if year >= 2010, lcolor(black) lpattern(solid)) ///
	   (line control_mean1 year if year >= 2010, lcolor(black) lpattern(dash)) ///
	   , xline(2004 2010, lpattern(dot) lcolor(red)) legend(on order (1 2 3 4) size(small) nobox region(fcolor(none) lcolor(none)) label(1 "Shale (In the Sample)") label(2 "Non-Shale (In the Sample)") label(3 "Shale (Not in the Sample)") label(4 "Non-Shale (Not in the Sample)")) ///
		title(Votes on Lands Bills, size(medium)) xscale(range(2003 2011)) xlabel(2003(2)2011) yscale(range(0 1)) ylabel(0(0.2)1) graphregion(fcolor(none) lcolor(none) ifcolor(none) ilcolor(none)) plotregion(fcolor(none) lcolor(none) ifcolor(none) ilcolor(none)) 

graph save Graph "03_figures/figure_2_lands.gph", replace

grc1leg "03_figures/figure_2_all.gph" "03_figures/figure_2_conventional.gph" "03_figures/figure_2_drilling.gph" "03_figures/figure_2_lands.gph", rows(2) /// 
	legendfrom("03_figures/figure_2_all.gph") /* Note that you need to install the grc1leg package via findit grc1leg */

graph export "03_figures/figure_2_average_trend.pdf", replace

erase "03_figures/figure_2_all.gph" 
erase "03_figures/figure_2_conventional.gph"
erase "03_figures/figure_2_drilling.gph"
erase "03_figures/figure_2_lands.gph"
