


clear
set mem 200m
insheet using ./dta/hosp_and_health_shares.txt, names tab

twoway ///
       (connected health_share year, sort msymbol(i) yaxis(1)) ///
       (connected hosp_share year, sort msymbol(i) lpattern(dash) yaxis(2)), ///
        scheme(s2mono) ylabel(, nogrid) graphregion(fcolor(white)) legend(on order(1 2) cols(1)) ///
        legend(label(1 "Total Health Spending Share of GDP")) ///
        legend(label(2 "Hospital Spending Share of GDP")) ///
        xtitle("Year") ytitle("Health Spending Share of GDP", axis(1)) ytitle("Hospital Spending Share of GDP", axis(2)) ///
         ylabel(0(0.05)0.2, axis(1)) ylabel(0(0.01)0.07, axis(2))

graph export ./gph/figure1.eps, replace fontface("Times-Roman")








clear
set mem 200m
use aha_final_esr.dta
keep if log_payroll < . & log_exptot < . & south == 1 & year >= 1970 & year <= 1990
keep if year == 1989

replace tot_size =  tot_size * 1000
summ tot_size, det
gen tot_size2 = tot_size
replace tot_size2 = . if tot_size2 > 0
keep if tot_size > 0

twoway (histogram tot_size, frequency width(.5) start(0)), ///
        scheme(s2mono) ylabel(, nogrid) graphregion(fcolor(white)) legend(off) ///
        xtitle("Oil Reserves (in billions of barrels)") ytitle("Count")
graph export ./gph/figure3b.eps, replace fontface("Times-Roman")







clear 
insheet using ./dta/hospital_days.txt, names tab 
twoway (bar hospital_days age, barw(0.9)), ///
       scheme(s2mono) ylabel(, nogrid) graphregion(fcolor(white)) ///
       legend(off) ///
       xtitle("Age Range") ytitle("Hospital Days") ///
       xlabel(1 "0-4" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-29" 7 "30-34" 8 "35-39" 9 "40-44" 10 "45-49" 11 "50-54" 12 "55-59" 13 "60-64" 14 "65-69" 15 "70-74" 16 "75-79" 17 "80+", alternate)

graph export ./gph/figure5_hospital_days.eps, replace fontface("Times-Roman")






clear
set more off
set mem 500m

use aha_final_esr

keep if year >= 1970 & year <= 1990 & south == 1

replace exptot = log(exptot)
replace payroll = log(payroll)

summ exptot payroll, det


twoway (histogram exptot, percent width(0.5) start(14)) , ///
        scheme(s2mono) ylabel(, nogrid) graphregion(fcolor(white)) legend(off) xlabel(14(2)26) ///
        xtitle("log Expenditures") ytitle("Percent") 
graph export ./gph/figure4a.eps, replace fontface("Times-Roman")

twoway (histogram payroll, percent width(0.5) start(15)) , ///
        scheme(s2mono) ylabel(, nogrid) graphregion(fcolor(white)) legend(off) xlabel(14(2)26) ///
        xtitle("log Income") ytitle("Percent") 
graph export ./gph/figure4b.eps, replace fontface("Times-Roman")


/**
 ** figures for slides
 **
twoway (histogram exptot, percent width(0.5) start(14)) , ///
       title("Total Hospital Expenditures by ESR") ///
        scheme(s2mono) ylabel(, nogrid) graphregion(fcolor(white)) legend(off) ///
        xtitle("log Expenditures") ytitle("Percent") 
graph save exptot.gph, replace

twoway (histogram payroll, percent width(0.5) start(15)) , ///
        title("Total Income by ESR") ///
        scheme(s2mono) ylabel(, nogrid) graphregion(fcolor(white)) legend(off) ///
        xtitle("log Income") ytitle("Percent") 
graph save payroll.gph, replace

graph combine payroll.gph exptot.gph, ///
 col(2) ysize(2.8) xsize(6.0) title("Figure 4: Aggregate Income and Hospital Expenditure Data") ///
 iscale(1.15) ///
 scheme(s2mono) graphregion(fcolor(white))
graph export ./gph/figure4.eps, replace fontface("Times-Roman")
 **/



clear
use ./dta/oilprice.dta

reg oilprice oilprice_prev
test _b[oilprice_prev] = 1.0

est store reg1
reg oilprice oilprice_prev oilprice_prev2
test _b[oilprice_prev] + _b[oilprice_prev2] = 1.0
est store reg2
reg oilprice oilprice_prev oilprice_prev2 oilprice_prev3
test _b[oilprice_prev] + _b[oilprice_prev2] + _b[oilprice_prev3] = 1.0
est store reg3
reg oilprice oilprice_prev oilprice_prev2 oilprice_prev3 oilprice_prev4
test _b[oilprice_prev] + _b[oilprice_prev2] + _b[oilprice_prev3] + _b[oilprice_prev4] = 1.0
est store reg4

**estout reg* using oilregs.txt, ///
** stats(N r2, fmt(%9.0f %9.3f)) modelwidth(10)  ///
** cells(b( fmt(%9.3f)) se(par fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) ) style(tab) replace notype mlabels(, numbers ) drop(_*)

**keep if year >= 1950 & year <= 2005

twoway (connected oilprice year, msymbol(i)), ///
       scheme(s2mono) ylabel(, nogrid) graphregion(fcolor(white)) ///
       legend(off) ///
       xtitle("Year") ytitle("Price (\$/barrel)") xlabel(1950(10)2000) xsc(r(1950 2005))
graph export ./gph/fig2_oilprice.eps, replace fontface("Times-Roman")

exit







