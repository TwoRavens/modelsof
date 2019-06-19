*** FIGURES OUT THE CORRECT STARTING BANDWIDTH FOR KYRIAZIDOU PROCEDURE ***

clear
set mem 6g
set more off
set seed 105515

log using /home/s/simberman/lusd/charter1/optimal_bandwidth_b.log, replace
use /home/s/simberman/lusd/charter1/lusd_data_b.dta
*gsample 5, percent wor cluster(id)
sort id year


*BASE SAMPLE - LEVELS
merge id year using /home/s/simberman/lusd/charter1/bandwidth_b_test.dta, keep(pred) _merge(_mergebw) nokeep
keep if infrac != . & perc_attn != .


keep if pred != .

drop grade_* gradeyear_*

xi i.grade*i.year  i.grade*structural  i.grade*nonstructural  i.grade*outofdist
  kyrselect_b infrac convert_zoned startup_unzoned freelunch redlunch othecon recent_immi migrant _I*, fspred(pred) bwcons(1) noout iis(id) tis(year)




foreach num of numlist 1(1)50 {
  di " "
  di "bwcons = `num'"
  di " "
  kyrselect_b infrac convert_zoned startup_unzoned freelunch redlunch othecon recent_immi migrant _I*, fspred(pred) bwcons(`num') noout iis(id) tis(year)
  
  drop _w* _k*
  
  matrix drop _all
  
}

log close