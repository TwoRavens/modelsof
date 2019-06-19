*** FIGURES OUT THE CORRECT STARTING BANDWIDTH FOR KYRIAZIDOU PROCEDURE ***

clear
set mem 6g
set more off
set seed 105515

use /home/s/simberman/lusd/charter1/lusd_data_b.dta
*gsample .5, percent wor cluster(id)
sort id year


*BASE SAMPLE - LEVELS
merge id year using /home/s/simberman/lusd/charter1/bandwidth_b_va.dta, keep(pred) _merge(_mergebw) nokeep
tsset id year
gen dinfrac = d.infrac
gen dperc_attn = d.perc_attn
keep if dinfrac != . & dperc_attn != .


keep if pred != .

drop grade_* gradeyear_*

xi i.grade*i.year  i.grade*structural  i.grade*nonstructural

foreach num of numlist  20(1)50 {
  di " "
  di "bwcons = `num'"
  di " "
  kyrselect dinfrac convert_zoned startup_unzoned freelunch redlunch othecon recent_immi migrant _I*, fspred(pred) bwcons(`num') noout iis(id) tis(year)
  
  drop _w* _k*

}

