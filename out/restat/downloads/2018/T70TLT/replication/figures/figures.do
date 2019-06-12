set scheme s2mono

* figure 1

use "..\data\data_complete.dta", clear
set more off

keep if year>2009
keep income year mtr_state1 - mtr_state99
gen inc_tsd=round(inc/1000)

gen perc99=.

foreach year of numlist 2010(1)2014 {

twoway__histogram_gen inc_tsd if year==`year' & inc_tsd>0, width(1) frequ gen(h`year' x`year') start(1)
sum income if year==`year', det
replace perc99=`r(p99)' if year==`year'

}

collapse  mtr_state1 - mtr_state99 perc99 (max) h* x*, by(inc_tsd year)

xtset inc_tsd year


foreach state of numlist 1 2 3 4 5 6 7 8 9 10 11 12 13 14 17  {

gen mtrdif`state'=mtr_state`state'-mtr_state99

}


sum perc99 if year==2011
local perc = `r(mean)'/1000
twoway  (connect mtrdif1 inc_tsd, m(none) lpattern(dot) color(gs0)) (connect mtrdif2 inc_tsd, m(none)lpattern(dot) color(gs7)) (connect mtrdif3 inc_tsd, m(none) lpattern(dot) color(gs11)) (connect mtrdif4 inc_tsd, m(none) lpattern(dot) color(gs15)) (connect mtrdif5 inc_tsd, m(none) lpattern(dash_dot) color(gs0)) (connect mtrdif6 inc_tsd, m(none) lpattern(dash_dot) color(gs7)) (connect mtrdif7 inc_tsd, m(none) lpattern(dash_dot) color(gs11))   (connect mtrdif8 inc_tsd, m(none) lpattern(dash_dot) color(gs15))  (connect mtrdif9 inc_tsd, m(none) lpattern(dash) lw(thick) color(gs0))  (connect mtrdif10 inc_tsd, m(none) lpattern(dash) color(gs7))  (connect mtrdif11 inc_tsd, m(none) lpattern(dash)  color(gs11))  (connect mtrdif12 inc_tsd, m(none) lpattern(dash) color(gs15))  (connect mtrdif13 inc_tsd, m(none) lpattern(solid) lw(thick) color(gs0))  (connect mtrdif14 inc_tsd, m(none) lpattern(dash) lpattern(solid) color(gs7))  (connect mtrdif17 inc_tsd, m(none) lpattern(solid) color(gs11) xline(`perc')) if year==2011&inc_tsd<325,   legend(  lab(1 "AND") lab(2 "ARA") lab(3 "AST") lab(4 "BAL") lab(5 "CAN") lab(6 "CNT")lab(7 "CAL") lab(8 "CAM") lab(9 "CAT") lab(10 "VAL") lab(11 "EXD") lab(12 "GAL") lab(13 "MAD") lab(14 "MUR") lab(15 "RIO")  ring(0) position(1) bmargin(tiny) cols(4) symxsize(6)  size(1) region(lwidth(none))) graphregion(color(white)) yscale(range(-3 4)) graphregion(color(white)) xtitle(income in thousands of Euros) ytitle(mtr relative to central mtr in percentage points) title(2011) ylabel(-2(2)4)
graph export "fig1a.pdf", as(pdf) replace

sum perc99 if year==2014
local perc = `r(mean)'/1000
twoway  (connect mtrdif1 inc_tsd, m(none) lpattern(dot) color(gs0)) (connect mtrdif2 inc_tsd, m(none)lpattern(dot) color(gs7)) (connect mtrdif3 inc_tsd, m(none) lpattern(dot) color(gs11)) (connect mtrdif4 inc_tsd, m(none) lpattern(dot) color(gs15)) (connect mtrdif5 inc_tsd, m(none) lpattern(dash_dot) color(gs0)) (connect mtrdif6 inc_tsd, m(none) lpattern(dash_dot) color(gs7)) (connect mtrdif7 inc_tsd, m(none) lpattern(dash_dot) color(gs11))   (connect mtrdif8 inc_tsd, m(none) lpattern(dash_dot) color(gs15))  (connect mtrdif9 inc_tsd, m(none) lpattern(dash) lw(thick) color(gs0))  (connect mtrdif10 inc_tsd, m(none) lpattern(dash) color(gs7))  (connect mtrdif11 inc_tsd, m(none) lpattern(dash)  color(gs11))  (connect mtrdif12 inc_tsd, m(none) lpattern(dash) color(gs15))  (connect mtrdif13 inc_tsd, m(none) lpattern(solid) lw(thick) color(gs0))  (connect mtrdif14 inc_tsd, m(none) lpattern(dash) lpattern(solid) color(gs7))  (connect mtrdif17 inc_tsd, m(none) lpattern(solid) color(gs11) xline(`perc')) if year==2014&inc_tsd<325,   legend(off)  graphregion(color(white)) yscale(range(-3 4)) graphregion(color(white)) xtitle(income in thousands of Euros) ytitle(mtr relative to central mtr in percentage points) title(2014) ylabel(-2(2)4)
graph export "fig1b.pdf", as(pdf) replace



* figure A2: within variation

use "..\data\data_ind.dta", clear
set more off

keep if percentile>97

set scheme s2mono

gen stats_mtr_sd_w=.
gen stats_mtr_max_w=.
gen stats_mtr_min_w=.
gen stats_mtr_mean=.
gen stats_mtr_max=.
gen stats_mtr_min=.

foreach grp of numlist 100 99 98 97 96 {

foreach yr of numlist 2014 2013 2012 2011 2010 2009 2008 2007 2006 2005 {

xtsum mtr if year==`yr'&percentile==`grp'
replace stats_mtr_sd_w=`r(sd_w)' if year==`yr'&percentile==`grp'
replace stats_mtr_max_w=`r(max_w)' if year==`yr'&percentile==`grp'
replace stats_mtr_min_w=`r(min_w)' if year==`yr'&percentile==`grp'
replace stats_mtr_max=`r(max)' if year==`yr'&percentile==`grp'
replace stats_mtr_min=`r(min)' if year==`yr'&percentile==`grp'
replace stats_mtr_mean=`r(mean)' if year==`yr'&percentile==`grp'

}
}


keep percentile year stats_mtr_sd_w stats_mtr_max_w stats_mtr_min_w stats_mtr_mean stats_mtr_max stats_mtr_min
collapse stats_mtr_sd_w stats_mtr_max_w stats_mtr_min_w stats_mtr_mean stats_mtr_max stats_mtr_min, by( percentile year)

label var stats_mtr_sd_w "within std. dev."

xtset percentile year

twoway (tsline stats_mtr_sd_w if percentile==100) (tsline stats_mtr_sd_w if percentile==99) (tsline stats_mtr_sd_w if percentile==98) , legend(  lab(1 "Top 1%") lab(2 "Top 2%") lab(3 "Top 3%")  ring(0) position(11) bmargin(large)) graphregion(color(white)) scheme(s2mono) ytitle(within standard deviation)
graph export "figA2.pdf", as(pdf) replace


* figure A3

use "..\data\data_ind.dta", clear
set more off

keep if move==1

gen incomeA=0
foreach inc of numlist 1 2 3 4 {
replace incomeA=incomeA+income`inc' if income_type`inc'=="A"
}

gen incomeB=0
foreach inc of numlist 1 2 3 4 {
replace incomeB=incomeB+income`inc' if income_type`inc'=="B"
}

gen incomeFL=0
foreach inc of numlist 1 2 3 4 {
replace incomeFL=incomeFL+income`inc' if income_type`inc'=="F"
replace incomeFL=incomeFL+income`inc' if income_type`inc'=="L"
}

gen incomeGH=0
foreach inc of numlist 1 2 3 4 {
replace incomeGH=incomeGH+income`inc' if income_type`inc'=="G"
replace incomeGH=incomeGH+income`inc' if income_type`inc'=="H"
}


replace incomeFL=incomeFL+income9999

global types "A B FL GH"

label var incomeA "labor income (employed)"
label var incomeB "pensions"
label var incomeGH "income from economic activities"
label var incomeFL "residual"

replace occu_cat=1 if occu_cat==888
replace occu_cat=4 if occu_cat>4

graph bar (mean) incomeA incomeB  incomeGH incomeFL , stack over(occu_cat, relabel(1  `" "self-""employed" "'  2 `"  "engineers," "college graduates" "'  3 `""managers and" "graduate assistants""'  4 "others")) perc  legend(label(1 "labor") label(2 "pensions") label(3 "economic activities") label(4 "other / residual")) graphregion(color(white))
graph export "figA3.pdf", as(pdf) replace


* figure A1

use "..\data\data_eti.dta", clear

set scheme s2mono

xtset destination_ccaa year

global controls dA1_Servicios_Publicos dA2_Actuaciones_de_ dA3_Produccion_de_Bienes_ dA4_Actuaciones_de_Caracter_ dA9_Actuaciones_de_Caracter_ dest_transport dest_highschool dest_senior dest_male dest_medianage dest_tertiaryedu dest_population dest_fertility dest_mortality dest_unempl dest_ltunemployment dest_gdpperc dest_RDspend dest_materialdep dest_instate dest_interstate dest_socialcont dest_tourism dest_HDD dest_CDD

xi: binscatter ln_share ln_net_topmtr, control( i.year ) noa absorb( destination_ccaa) reportreg ytitle(log share of income to the top 1%) xtitle(log net of tax rate) yscale(range(-.03(.01).03)) xscale(range(-.04 (.02) .04)) ylabel(-.03(.01).03) xlabel(-.04(.02).04) colors(gray black)  replace
graph export figA1.pdf, replace


