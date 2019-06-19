*** FIGURES OUT THE CORRECT STARTING BANDWIDTH FOR KYRIAZIDOU PROCEDURE ***

clear
set mem 6g
set more off
set seed 105515

use /home/s/simberman/lusd/charter1/lusd_data_b.dta
*gsample .5, percent wor cluster(id)
sort id year


*BASE SAMPLE - LEVELS
merge id year using /home/s/simberman/lusd/charter1/bandwidth_b_va_test.dta, keep(pred) _merge(_mergebw) nokeep
tsset id year
gen dstanford_math_sd = d.stanford_math_sd
gen dstanford_read_sd = d.stanford_read_sd
gen dstanford_lang_sd = d.stanford_lang_sd
keep if dstanford_math_sd != . & dstanford_read_sd != . & dstanford_lang_sd != .


keep if pred != .

drop grade_* gradeyear_*

xi i.grade*i.year  i.grade*structural  i.grade*nonstructural

foreach num of numlist 1(1)50{
  di " "
  di "bwcons = `num'"
  di " "
  kyrselect dstanford_math_sd convert_zoned startup_unzoned freelunch redlunch othecon recent_immi migrant _I*, fspred(pred) bwcons(`num') noout iis(id) tis(year)
  
  drop _w* _k*

}

