use "final_jop_dataverse.dta", replace

sort prefecture_id year
tsset prefecture_id year 

**************************
* Main text Regression
**************************

*====================================
* Table 1. Main table (1992-2010)
*====================================
eststo clear
qui xi:xtreg ln_school_p l.oil_sale l.coal_sale l.gas_sale ln_student_p ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_s l.oil_sale l.coal_sale l.gas_sale ln_student_s ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_h l.oil_sale l.coal_sale l.gas_sale ln_student_h ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_p l.oil_sale l.coal_sale l.gas_sale ln_student_p ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_s l.oil_sale l.coal_sale l.gas_sale ln_student_s ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_h l.oil_sale l.coal_sale l.gas_sale ln_student_h ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_hospital l.oil_sale l.coal_sale l.gas_sale ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_bed l.oil_sale l.coal_sale l.gas_sale ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_doctor l.oil_sale l.coal_sale l.gas_sale ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
esttab, keep(L.oil_sale L.coal_sale L.gas_sale ln_student_p ln_student_s ln_student_h ln_gdp ln_pop urban_pop ln_land_area ) se(3) b(3) star(* .1 ** .05 *** .01) tex

*====================================
* Table 2. FDI and SOE (1998-2007)
*====================================
eststo clear
qui xi:xtreg ln_school_p l.oil_sale l.coal_sale l.gas_sale ln_student_p manu_outside l.soe_share1 ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r 
eststo
qui xi:xtreg ln_school_s l.oil_sale l.coal_sale l.gas_sale ln_student_s manu_outside l.soe_share1 ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_h l.oil_sale l.coal_sale l.gas_sale ln_student_h manu_outside l.soe_share1 ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_p l.oil_sale l.coal_sale l.gas_sale ln_student_p manu_outside l.soe_share1 ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_s l.oil_sale l.coal_sale l.gas_sale ln_student_s manu_outside l.soe_share1 ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_h l.oil_sale l.coal_sale l.gas_sale ln_student_h manu_outside l.soe_share1 ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_hospital l.oil_sale l.coal_sale l.gas_sale manu_outside l.soe_share1 ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_bed l.oil_sale l.coal_sale l.gas_sale ln_gdp manu_outside l.soe_share1 ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_doctor l.oil_sale l.coal_sale l.gas_sale ln_gdp manu_outside l.soe_share1 ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
esttab, keep(L.oil_sale L.coal_sale L.gas_sale ln_student_p ln_student_s ln_student_h manu_outside L.soe_share1 ln_gdp ln_pop urban_pop ln_land_area ) se(3) b(3) star(* .1 ** .05 *** .01) tex

*======================================================
* Table 3. Non-labor related public services
*======================================================
eststo clear 
qui xi:xtreg ln_const l.oil_sale l.coal_sale l.gas_sale ln_pop urban_pop ln_gdp ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_const_res l.oil_sale l.coal_sale l.gas_sale ln_pop urban_pop ln_gdp ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_post l.oil_sale l.coal_sale l.gas_sale ln_pop urban_pop ln_gdp ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_gr l.oil_sale l.coal_sale l.gas_sale ln_pop urban_pop ln_gdp ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg sewage l.oil_sale l.coal_sale l.gas_sale ln_pop urban_pop ln_gdp ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_const l.oil_sale l.coal_sale l.gas_sale manu_outside l.soe_share1 ln_pop urban_pop ln_gdp ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_const_res l.oil_sale l.coal_sale l.gas_sale manu_outside l.soe_share1 ln_pop urban_pop ln_gdp ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_post l.oil_sale l.coal_sale l.gas_sale manu_outside l.soe_share1 ln_pop urban_pop ln_gdp ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_gr l.oil_sale l.coal_sale l.gas_sale manu_outside l.soe_share1 ln_pop urban_pop ln_gdp ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg sewage l.oil_sale l.coal_sale l.gas_sale manu_outside l.soe_share1 ln_pop urban_pop ln_gdp ln_land_area i.year, fe cluster(prov_id) r
eststo
esttab, keep(L.oil_sale L.coal_sale L.gas_sale manu_outside L.soe_share1 ln_gdp ln_pop urban_pop ln_land_area ) se(3) b(3) star(* .1 ** .05 *** .01) tex
 
*====================================
* Table 4. Tenure
*====================================
eststo clear
qui xi:xtreg promotion L_oil_sale L_coal_sale L_gas_sale tenure tenure2 yearstoretire yearstoretire2 i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg promotion L_oil_sale L_coal_sale L_gas_sale tenure tenure2 L_gdp_gr L_rev_gr yearstoretire yearstoretire2 i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg demotion L_oil_sale L_coal_sale L_gas_sale tenure tenure2 yearstoretire yearstoretire2 i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg demotion L_oil_sale L_coal_sale L_gas_sale tenure tenure2 L_gdp_gr L_rev_gr yearstoretire yearstoretire2 i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg change L_oil_sale L_coal_sale L_gas_sale tenure tenure2 yearstoretire yearstoretire2 i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg change L_oil_sale L_coal_sale L_gas_sale tenure tenure2 L_gdp_gr L_rev_gr yearstoretire yearstoretire2 i.year, fe cluster(prov_id) r
eststo
stset tenure, failure(change==1)
qui streg L_oil_sale L_coal_sale L_gas_sale yearstoretire yearstoretire2 _I* id_pre*,r distribution(weibull) 
eststo
qui streg L_oil_sale L_coal_sale L_gas_sale L_gdp_gr L_rev_gr yearstoretire yearstoretire2 _I* id_pre*,r distribution(weibull) 
eststo
esttab, drop(_I* id*) se(3) b(3) star(* .1 ** .05 *** .01) tex

*====================================
* Table 5. Local GDP/Gov finance
*====================================
eststo clear
qui xi:xtreg ln_gdp oil_sale coal_sale gas_sale ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_rev oil_sale coal_sale gas_sale ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_exp oil_sale coal_sale gas_sale ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg gov_edu_rate oil_sale coal_sale gas_sale ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg gov_health_rate oil_sale coal_sale gas_sale ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_sp_transfer oil_sale coal_sale gas_sale ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_wage oil_sale coal_sale gas_sale ln_pop urban_pop ln_land_area ln_prse_student i.year, fe cluster(prov_id) r
eststo
esttab, keep(oil_sale coal_sale gas_sale ln_pop urban_pop ln_land_area) se(3) b(3) star(* .1 ** .05 *** .01) tex

**************************
* Appendix Regression
**************************
 
*==============================
* A2. Summary
*==============================
 
#delimit ;
sum oil_sale coal_sale gas_sale
ln_pop ln_land_area 
ln_gdp manu_outside soe_share1 ln_rev ln_exp
school_pri school_sec school_higher student_pri student_sec student_higher teacher_pri teacher_sec teacher_higher
hospital doctor bed 
const_cd const_res_cd post_office gr_cd sewage 
;
#delimit cr
 

*===================================================================================================================================
* A3. collective action (2007 onward)
*====================================================================================================================================

* From 2007 - 2010

eststo clear
xi:xtreg ln_school_p l.oil_sale l.coal_sale l.gas_sale ln_student_p ln_gdp ln_pop urban_pop ln_land_area , fe cluster(prov_id) r 
eststo
qui xi:xtreg ln_school_s l.oil_sale l.coal_sale l.gas_sale ln_student_s ln_gdp ln_pop urban_pop ln_land_area , fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_h l.oil_sale l.coal_sale l.gas_sale ln_student_h ln_gdp ln_pop urban_pop ln_land_area , fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_p l.oil_sale l.coal_sale l.gas_sale ln_student_p ln_gdp ln_pop urban_pop ln_land_area , fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_s l.oil_sale l.coal_sale l.gas_sale ln_student_s ln_gdp ln_pop urban_pop ln_land_area , fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_h l.oil_sale l.coal_sale l.gas_sale ln_student_h ln_gdp ln_pop urban_pop ln_land_area , fe cluster(prov_id) r
eststo
esttab, keep(L.oil_sale L.coal_sale L.gas_sale ln_student_p ln_student_s ln_student_h ln_gdp ln_pop urban_pop ln_land_area ) se(3) b(3) star(* .1 ** .05 *** .01) tex


*==================
* A4. Excluding GDP
*==================
use "C:\Users\jyhong\Dropbox\Research\China_Resource\paper\JOP rnr2\dataverse\final_jop_dataverse.dta", clear
sort prefecture_id year
tsset prefecture_id year 

eststo clear
qui xi:xtreg ln_school_p l.oil_sale l.coal_sale l.gas_sale ln_student_p ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_s l.oil_sale l.coal_sale l.gas_sale ln_student_s ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_h l.oil_sale l.coal_sale l.gas_sale ln_student_h ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_p l.oil_sale l.coal_sale l.gas_sale ln_student_p ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_s l.oil_sale l.coal_sale l.gas_sale ln_student_s ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_h l.oil_sale l.coal_sale l.gas_sale ln_student_h ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_hospital l.oil_sale l.coal_sale l.gas_sale ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_bed l.oil_sale l.coal_sale l.gas_sale ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_doctor l.oil_sale l.coal_sale l.gas_sale ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo

esttab, keep(L.oil_sale L.coal_sale L.gas_sale ln_student_p ln_student_s ln_student_h ln_pop urban_pop ln_land_area ) se(3) b(3) star(* .1 ** .05 *** .01) tex


*==================
* A5. Per Capita
*==================
eststo clear
qui xi:xtreg ln_school_p_ps l.oil_sale_pc l.coal_sale_pc l.gas_sale_pc ln_gdp_pc ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_s_ps l.oil_sale_pc l.coal_sale_pc l.gas_sale_pc ln_gdp_pc ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_h_ps l.oil_sale_pc l.coal_sale_pc l.gas_sale_pc ln_gdp_pc ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_p_ps l.oil_sale_pc l.coal_sale_pc l.gas_sale_pc ln_gdp_pc ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_s_ps l.oil_sale_pc l.coal_sale_pc l.gas_sale_pc ln_gdp_pc ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_h_ps l.oil_sale_pc l.coal_sale_pc l.gas_sale_pc ln_gdp_pc ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_hospital_pc l.oil_sale_pc l.coal_sale_pc l.gas_sale_pc ln_gdp_pc ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_bed_pc l.oil_sale_pc l.coal_sale_pc l.gas_sale_pc ln_gdp_pc ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_doctor_pc l.oil_sale_pc l.coal_sale_pc l.gas_sale_pc ln_gdp_pc ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
esttab, keep(L.oil_sale_pc L.coal_sale_pc L.gas_sale_pc ln_gdp_pc ln_pop urban_pop ln_land_area ) se(3) b(3) star(* .1 ** .05 *** .01) tex


*===================================================================================================================================
* A6. production
*====================================================================================================================================

eststo clear
qui xi:xtreg ln_school_p l.oil_prod l.coal_prod l.gas_prod ln_student_p ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_s l.oil_prod l.coal_prod l.gas_prod ln_student_s ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_h l.oil_prod l.coal_prod l.gas_prod ln_student_h ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_p l.oil_prod l.coal_prod l.gas_prod ln_student_p ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_s l.oil_prod l.coal_prod l.gas_prod ln_student_s ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_h l.oil_prod l.coal_prod l.gas_prod ln_student_h ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_hospital l.oil_prod l.coal_prod l.gas_prod ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_bed l.oil_prod l.coal_prod l.gas_prod ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_doctor l.oil_prod l.coal_prod l.gas_prod ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
esttab, keep(L.oil_prod L.coal_prod L.gas_prod ln_student_p ln_student_s ln_student_h ln_gdp ln_pop urban_pop ln_land_area) se(3) b(3) star(* .1 ** .05 *** .01) tex


*===================================================================================================================================
* A7. boom/bust analysis: bust period
*====================================================================================================================================

* before 2004 (from 1992-2003)
drop if year > 2003

eststo clear
xi:xtreg ln_school_p l.oil_sale l.coal_sale l.gas_sale ln_student_p ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r 
eststo
qui xi:xtreg ln_school_s l.oil_sale l.coal_sale l.gas_sale ln_student_s ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_h l.oil_sale l.coal_sale l.gas_sale ln_student_h ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_p l.oil_sale l.coal_sale l.gas_sale ln_student_p ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_s l.oil_sale l.coal_sale l.gas_sale ln_student_s ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_h l.oil_sale l.coal_sale l.gas_sale ln_student_h ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_hospital l.oil_sale l.coal_sale l.gas_sale ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_bed l.oil_sale l.coal_sale l.gas_sale ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_doctor l.oil_sale l.coal_sale l.gas_sale ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
esttab, keep(L.oil_sale L.coal_sale L.gas_sale ln_student_p ln_student_s ln_student_h ln_gdp ln_pop urban_pop ln_land_area ) se(3) b(3) star(* .1 ** .05 *** .01) tex

*===================================================================================================================================
* A8. boom/bust analysis: boom period
*====================================================================================================================================

use "C:\Users\jyhong\Dropbox\Research\China_Resource\paper\JOP rnr2\dataverse\final_jop_dataverse.dta", clear
sort prefecture_id year 
xtset prefecture_id year 

* since 2004 (from 2004-2010)
drop if year < 2004

eststo clear
xi:xtreg ln_school_p l.oil_sale l.coal_sale l.gas_sale ln_student_p ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r 
eststo
qui xi:xtreg ln_school_s l.oil_sale l.coal_sale l.gas_sale ln_student_s ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_h l.oil_sale l.coal_sale l.gas_sale ln_student_h ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_p l.oil_sale l.coal_sale l.gas_sale ln_student_p ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_s l.oil_sale l.coal_sale l.gas_sale ln_student_s ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_h l.oil_sale l.coal_sale l.gas_sale ln_student_h ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_hospital l.oil_sale l.coal_sale l.gas_sale ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_bed l.oil_sale l.coal_sale l.gas_sale ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_doctor l.oil_sale l.coal_sale l.gas_sale ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
esttab, keep(L.oil_sale L.coal_sale L.gas_sale ln_student_p ln_student_s ln_student_h ln_gdp ln_pop urban_pop ln_land_area ) se(3) b(3) star(* .1 ** .05 *** .01) tex


*=====================================================================================================================================================
* A9. size of population birth rate - based on natural population change * 1 year
*=====================================================================================================================================================

eststo clear
qui xi:xtreg ln_school_p l.oil_sale l.coal_sale l.gas_sale ln_student_p l.ni_pop ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_s l.oil_sale l.coal_sale l.gas_sale ln_student_s l.ni_pop ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_h l.oil_sale l.coal_sale l.gas_sale ln_student_h l.ni_pop ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_p l.oil_sale l.coal_sale l.gas_sale ln_student_p l.ni_pop ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_s l.oil_sale l.coal_sale l.gas_sale ln_student_s l.ni_pop ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_h l.oil_sale l.coal_sale l.gas_sale ln_student_h l.ni_pop ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_hospital l.oil_sale l.coal_sale l.gas_sale l.ni_pop ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_bed l.oil_sale l.coal_sale l.gas_sale l.ni_pop ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_doctor l.oil_sale l.coal_sale l.gas_sale l.ni_pop ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
esttab, keep(L.oil_sale L.coal_sale L.gas_sale L.ni_pop ln_student_p ln_student_s ln_student_h ln_gdp ln_pop urban_pop ln_land_area ) se(3) b(3) star(* .1 ** .05 *** .01) tex

*=====================================================================================================================================================
* A10. size of population birth rate - based on natural population change *5 years
*=====================================================================================================================================================

eststo clear
qui xi:xtreg ln_school_p l.oil_sale l.coal_sale l.gas_sale ln_student_p ni_pop5 ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_s l.oil_sale l.coal_sale l.gas_sale ln_student_s ni_pop5 ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_h l.oil_sale l.coal_sale l.gas_sale ln_student_h ni_pop5 ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_p l.oil_sale l.coal_sale l.gas_sale ln_student_p ni_pop5 ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_s l.oil_sale l.coal_sale l.gas_sale ln_student_s ni_pop5 ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_h l.oil_sale l.coal_sale l.gas_sale ln_student_h ni_pop5 ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_hospital l.oil_sale l.coal_sale l.gas_sale ni_pop5 ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_bed l.oil_sale l.coal_sale l.gas_sale ni_pop5 ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_doctor l.oil_sale l.coal_sale l.gas_sale ni_pop5 ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
esttab, keep(L.oil_sale L.coal_sale L.gas_sale ln_student_p ln_student_s ln_student_h ni_pop5 ln_gdp ln_pop urban_pop ln_land_area ) se(3) b(3) star(* .1 ** .05 *** .01) tex

*=====================================================================================================================================================
* A11. population about to reach school age 2005 census
*=====================================================================================================================================================

eststo clear
qui xi:xtreg ln_school_p l.oil_sale l.coal_sale l.gas_sale ln_student_p school_age ln_gdp ln_pop urban_pop ln_land_area i.year if year > 1999, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_s l.oil_sale l.coal_sale l.gas_sale ln_student_s school_age ln_gdp ln_pop urban_pop ln_land_area i.year if year > 1999, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_h l.oil_sale l.coal_sale l.gas_sale ln_student_h school_age ln_gdp ln_pop urban_pop ln_land_area i.year if year > 1999, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_p l.oil_sale l.coal_sale l.gas_sale ln_student_p school_age ln_gdp ln_pop urban_pop ln_land_area i.year if year > 1999, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_s l.oil_sale l.coal_sale l.gas_sale ln_student_s school_age ln_gdp ln_pop urban_pop ln_land_area i.year if year > 1999, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_h l.oil_sale l.coal_sale l.gas_sale ln_student_h school_age ln_gdp ln_pop urban_pop ln_land_area i.year if year > 1999, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_hospital l.oil_sale l.coal_sale l.gas_sale school_age ln_gdp ln_pop urban_pop ln_land_area i.year if year > 1999, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_bed l.oil_sale l.coal_sale l.gas_sale school_age ln_gdp ln_pop urban_pop ln_land_area i.year if year > 1999, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_doctor l.oil_sale l.coal_sale l.gas_sale school_age ln_gdp ln_pop urban_pop ln_land_area i.year if year > 1999, fe cluster(prov_id) r
eststo
esttab, keep(L.oil_sale L.coal_sale L.gas_sale ln_student_p ln_student_s ln_student_h school_age ln_gdp ln_pop urban_pop ln_land_area ) se(3) b(3) star(* .1 ** .05 *** .01) tex



*===================================================================================================================================
* A12. Alternative lagging - 3 year lag
*====================================================================================================================================

eststo clear
qui xi:xtreg ln_school_p l3.oil_sale l3.coal_sale l3.gas_sale ln_student_p ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_s l3.oil_sale l3.coal_sale l3.gas_sale ln_student_s ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_h l3.oil_sale l3.coal_sale l3.gas_sale ln_student_h ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_p l3.oil_sale l3.coal_sale l3.gas_sale ln_student_p ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_s l3.oil_sale l3.coal_sale l3.gas_sale ln_student_s ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_h l3.oil_sale l3.coal_sale l3.gas_sale ln_student_h ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_hospital l3.oil_sale l3.coal_sale l3.gas_sale ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_bed l3.oil_sale l3.coal_sale l3.gas_sale ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_doctor l3.oil_sale l3.coal_sale l3.gas_sale ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
esttab, keep(L3.oil_sale L3.coal_sale L3.gas_sale ln_student_p ln_student_s ln_student_h ln_gdp ln_pop urban_pop ln_land_area ) se(3) b(3) star(* .1 ** .05 *** .01) tex

*===================================================================================================================================
* A13. Alternative lagging - 5 year lag
*====================================================================================================================================

eststo clear
qui xi:xtreg ln_school_p l5.oil_sale l5.coal_sale l5.gas_sale ln_student_p ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_s l5.oil_sale l5.coal_sale l5.gas_sale ln_student_s ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_h l5.oil_sale l5.coal_sale l5.gas_sale ln_student_h ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_p l5.oil_sale l5.coal_sale l5.gas_sale ln_student_p ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_s l5.oil_sale l5.coal_sale l5.gas_sale ln_student_s ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_h l5.oil_sale l5.coal_sale l5.gas_sale ln_student_h ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_hospital l5.oil_sale l5.coal_sale l5.gas_sale ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_bed l5.oil_sale l5.coal_sale l5.gas_sale ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_doctor l5.oil_sale l5.coal_sale l5.gas_sale ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
esttab, keep(L5.oil_sale L5.coal_sale L5.gas_sale ln_student_p ln_student_s ln_student_h ln_gdp ln_pop urban_pop ln_land_area ) se(3) b(3) star(* .1 ** .05 *** .01) tex
 
*===================================================================================================================================
* A14. Alternative lagging - 3 years average
*====================================================================================================================================

eststo clear
qui xi:xtreg ln_school_p oil_sale3 coal_sale3 gas_sale3 ln_student_p ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_s oil_sale3 coal_sale3 gas_sale3 ln_student_s ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_h oil_sale3 coal_sale3 gas_sale3 ln_student_h ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_p oil_sale3 coal_sale3 gas_sale3 ln_student_p ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_s oil_sale3 coal_sale3 gas_sale3 ln_student_s ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_h oil_sale3 coal_sale3 gas_sale3 ln_student_h ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_hospital oil_sale3 coal_sale3 gas_sale3 ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_bed oil_sale3 coal_sale3 gas_sale3 ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_doctor oil_sale3 coal_sale3 gas_sale3 ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
esttab, keep(oil_sale3 coal_sale3 gas_sale3 ln_student_p ln_student_s ln_student_h ln_gdp ln_pop urban_pop ln_land_area ) se(3) b(3) star(* .1 ** .05 *** .01) tex

*===================================================================================================================================
* A15. Alternative lagging - 5 years average
*====================================================================================================================================

eststo clear
qui xi:xtreg ln_school_p oil_sale5 coal_sale5 gas_sale5 ln_student_p ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_s oil_sale5 coal_sale5 gas_sale5 ln_student_s ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_h oil_sale5 coal_sale5 gas_sale5 ln_student_h ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_p oil_sale5 coal_sale5 gas_sale5 ln_student_p ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_s oil_sale5 coal_sale5 gas_sale5 ln_student_s ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_h oil_sale5 coal_sale5 gas_sale5 ln_student_h ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_hospital oil_sale5 coal_sale5 gas_sale5 ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_bed oil_sale5 coal_sale5 gas_sale5 ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_doctor oil_sale5 coal_sale5 gas_sale5 ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
esttab, keep(oil_sale5 coal_sale5 gas_sale5 ln_student_p ln_student_s ln_student_h ln_gdp ln_pop urban_pop ln_land_area ) se(3) b(3) star(* .1 ** .05 *** .01) tex
 
*===================================================================================================================================
* A16. Alternative lagging - no lag
*====================================================================================================================================

eststo clear
qui xi:xtreg ln_school_p oil_sale coal_sale gas_sale ln_student_p ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_s oil_sale coal_sale gas_sale ln_student_s ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_h oil_sale coal_sale gas_sale ln_student_h ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_p oil_sale coal_sale gas_sale ln_student_p ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_s oil_sale coal_sale gas_sale ln_student_s ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_h oil_sale coal_sale gas_sale ln_student_h ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_hospital oil_sale coal_sale gas_sale ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_bed oil_sale coal_sale gas_sale ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_doctor oil_sale coal_sale gas_sale ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
esttab, keep(oil_sale coal_sale gas_sale ln_student_p ln_student_s ln_student_h ln_gdp ln_pop urban_pop ln_land_area ) se(3) b(3) star(* .1 ** .05 *** .01) tex


*========================
* A17. Potential Sales
*========================
eststo clear
qui xi:xtreg ln_school_p l.oil_poten_sale ln_student_p ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_s l.oil_poten_sale ln_student_s ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_h l.oil_poten_sale ln_student_h ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_p l.oil_poten_sale ln_student_p ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_s l.oil_poten_sale ln_student_s ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_h l.oil_poten_sale ln_student_h ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_hospital l.oil_poten_sale ln_gdp ln_pop urban_pop ln_land_area province_* i.year, cluster(prov_id) r
eststo
qui xi:xtreg ln_bed l.oil_poten_sale ln_gdp ln_pop urban_pop ln_land_area province_* i.year, cluster(prov_id) r
eststo
qui xi:xtreg ln_doctor l.oil_poten_sale ln_gdp ln_pop urban_pop ln_land_area province_* i.year, cluster(prov_id) r
eststo
esttab, keep(L.oil_poten_sale ln_gdp ln_pop urban_pop ln_land_area ln_student_p ln_student_s ln_student_h) se(3) b(3) star(* .1 ** .05 *** .01) tex
 
*===================================================================================================================================
* A18. nonlinear
*====================================================================================================================================

eststo clear
qui xi:xtreg ln_school_p l.oil_sale l.oil_sale2 l.coal_sale l.coal_sale2 l.gas_sale l.gas_sale2 ln_student_p ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_s l.oil_sale l.oil_sale2 l.coal_sale l.coal_sale2 l.gas_sale l.gas_sale2 l.gas_sale2 ln_student_s ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_school_h l.oil_sale l.oil_sale2 l.coal_sale l.coal_sale2 l.gas_sale l.gas_sale2 ln_student_h ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_p l.oil_sale l.oil_sale2 l.coal_sale l.coal_sale2 l.gas_sale l.gas_sale2 ln_student_p ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_s l.oil_sale l.oil_sale2 l.coal_sale l.coal_sale2 l.gas_sale l.gas_sale2 ln_student_s ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_teacher_h l.oil_sale l.oil_sale2 l.coal_sale l.coal_sale2 l.gas_sale l.gas_sale2 ln_student_h ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_hospital l.oil_sale l.oil_sale2 l.coal_sale l.coal_sale2 l.gas_sale l.gas_sale2 ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_bed l.oil_sale l.oil_sale2 l.coal_sale l.coal_sale2 l.gas_sale l.gas_sale2 ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_doctor l.oil_sale l.oil_sale2 l.coal_sale l.coal_sale2 l.gas_sale l.gas_sale2 ln_gdp ln_pop urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
esttab, keep(L.oil_sale L.oil_sale2 L.coal_sale L.coal_sale2 L.gas_sale L.gas_sale2 ln_student_p ln_student_s ln_student_h ln_gdp ln_pop urban_pop ln_land_area ) se(3) b(3) star(* .1 ** .05 *** .01) tex

*===================================================================================================================================
* A19. student population
*====================================================================================================================================

use "C:\Users\jyhong\Dropbox\Research\China_Resource\paper\JOP rnr2\dataverse\final_jop_dataverse.dta", clear
sort prefecture_id year 
xtset prefecture_id year

eststo clear
qui xi:xtreg ln_student_p l.oil_sale l.coal_sale l.gas_sale ln_gdp urban_pop ln_land_area i.year, fe cluster(prov_id) r 
eststo
qui xi:xtreg ln_student_s l.oil_sale l.coal_sale l.gas_sale ln_gdp urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
qui xi:xtreg ln_student_h l.oil_sale l.coal_sale l.gas_sale ln_gdp urban_pop ln_land_area i.year, fe cluster(prov_id) r
eststo
esttab, keep(L.oil_sale L.coal_sale L.gas_sale ln_gdp urban_pop ln_land_area ) se(3) b(3) star(* .1 ** .05 *** .01) tex


*===================================================================================================================================
* A20. Long-term effect of FDI
*====================================================================================================================================

keep if year == 2004
eststo clear
reg manu_fdi_2000 p_student_19902 s_student_19902 h_student_19902 gdp_1990 sez pop_1990 soe_share_1990 ln_land_area, r 
eststo
reg manu_fdi_2000 p_school_19902 s_school_19902 h_school_19902 gdp_1990 sez pop_1990 soe_share_1990 ln_land_area, r 
eststo
reg manu_fdi_2000 p_teacher_19902 s_teacher_19902 h_teacher_19902 gdp_1990 sez pop_1990 soe_share_1990 ln_land_area, r 
eststo
reg manu_fdi_2000 p_student_19902 s_student_19902 h_student_19902 oil_1990 coal_1990 gas_1990 gdp_1990 sez pop_1990 soe_share_1990 ln_land_area, r 
eststo
reg manu_fdi_2000 p_school_19902 s_school_19902 h_school_19902 oil_1990 coal_1990 gas_1990 gdp_1990 sez pop_1990 soe_share_1990 ln_land_area, r 
eststo
reg manu_fdi_2000 p_teacher_19902 s_teacher_19902 h_teacher_19902 oil_1990 coal_1990 gas_1990 gdp_1990 sez pop_1990 soe_share_1990 ln_land_area, r 
eststo
esttab, se(3) b(3) star(* .1 ** .05 *** .01) tex

log close
exit

