* 2018-11-8
/* 

This do-file creates all figures found in the appendix of

  - Bell, A., Chetty, R., Jaravel, X., Petkova, N. & Van Reenen, J. (2018). 
		Who Becomes an Inventor in America? The Importance of Exposure to Innovation
		
*/

* Run patents_figs_metafile first!

* Log
cap log close
log using "$logs/appendix_figures_log.log", replace

*** FIGURES IN APPENDIX

* Figure A1

* Fig A1a: Patent Rates Between Ages 30-40 vs. Parent Income Percentile
import delimited using "${data}/inventor3040_on_parinc.csv", clear
replace inventor3040 = inventor3040 * 1000
twoway (connected inventor3040 par_rank_w, mcolor(navy)), ///
	xtitle("Parent Household Income Percentile") ///
	ytitle("Inventors Between Ages 30-40 per Thousand") ///
	title(" ") ///
	xlabel(0 "0" .2 "20" .4 "40" .6 "60" .8 "80" 1 "100")
graph export "${figs}/inventor3040_on_parinc.${image_suffix}", replace 


* Fig A1b: Parental income and alternative measures of inventor status 
use "${data}/inventor_on_par_inc8084.dta", clear

replace inventor = inventor * 1000
replace applicant = applicant * 1000
replace grantee = grantee * 1000

twoway (scatter inventor  par_bin, msymbol (circle) mcolor(navy) lcolor(maroon)) ///
(scatter applicant  par_bin, msymbol(triangle_hollow) mcolor(maroon)) ///
(scatter grantee par_bin, msymbol(square_hollow) mcolor(forest_green)), ///
	xtitle("Parent Household Income Percentile") ///
	ytitle("Inventors/Applicants/Grantees per Thousand") /// 
	title(" ") ///
	legend(lab(1 "Inventors") lab(2 "Applicants") lab(3 "Grantees") c(3)) 
graph export "${figs}/inventor_on_parinc_alternative.${image_suffix}", replace

* Fig A1c: Patent Rates vs. Parent Income in NYC Public Schools
import delimited using "${data}/inventorvsparinc_nyc.csv", clear

replace par_rank = par_rank * 100
replace inventor = inventor * 1000

twoway (connected inventor par_rank, mcolor(navy) lcolor(navy)), ///
	xtitle("Parent Household Income Percentile") ///
	title(" ") ///
	ytitle("Inventors per Thousand")
graph export "${figs}/inventor_on_parinc_nyc.${image_suffix}", replace 


* Fig A2: Probability of child ending up in top 1% and 5% in relation to parent income 
use "${data}/inventor_on_par_inc8084.dta", clear
replace top1pc = top1pc * 100
replace top5pc = top5pc * 100
twoway (scatter top5pc par_bin, msize(small) mcolor(maroon)) ///
(scatter top1pc par_bin, msize(small) mcolor(navy) yaxis(2) msymbol (triangle)),  ///
	xtitle("Parent Household Income Percentile") ///
	ytitle("Percentage of Children with Income in Top 5%", axis(1)) ///
	ytitle("Percentage of Children with Income in Top 1%", axis(2)) ///
	title(" ") ///
	legend(order(1 "Income in Top 5%" 2 "Income in Top 1%" ))
graph export "${figs}/top_income_on_parinc.${image_suffix}", replace 

* Fig A3: Distribution of math test scores

* Fig A3a: Grade 3 math scores by parent income
graph use "${data}/mathkd_byparinc.gph"
graph play "${recordings}/take_out_blue_border.grec"
graph play "${recordings}/edit_figA3a.grec"
graph export "${figs}/mathkd_byparinc.${image_suffix}", replace
graph close

* Fig A3.b: Grade 3 math test scores, by gender
graph use "${data}/mathkd_bygender.gph"
graph play "${recordings}/take_out_blue_border.grec"
graph play "${recordings}/edit_figA3b.grec"
graph export "${figs}/mathkd_bygender.${image_suffix}", replace
graph close

* Fig A4: Percentage of Female Inventors and Gender Stereotypes 
use "${data}/patents_by_state", clear

* Generate Share females
gen num_f = inventor_g_f * kid_count_g_f
gen num_m = inventor_g_m * kid_count_g_m
gen num_inv = num_f + num_m
gen share_f = num_f / (num_inv)
replace share_f = 100* share_f

* Merge with Pope and Sydnor data and FIPS codes
rename par_stateabbrv state
merge 1:1 state using "${data}/Pope_Sydnor_JEP_statedata.dta", nogen 
rename state stateabbrv
merge 1:1 stateabbrv using "$data/FIPS_state_cw.dta", nogen
drop if fips==.
drop if fips > 56

twoway (scatter share_f Avg95_SAI, mlabel(stateabbrv) mlabposition(0) msymbol(i)) ///
(lfit share_f Avg95_SAI), ///
	xtitle("Gender Stereotype Adherence Index on 8th Grade Tests (Pope and Sydnor 2010)", size(3)) ///
	ytitle("Percentage of Inventors who are Female") ///
	title(" ") ///
	xlab(,format(%9.1f)) ///
	legend(off)
graph export "${figs}/inventors_bystategender.${image_suffix}", replace 

* Fig A5: Income of Inventors

* Fig A5a: Distribution of inventors' mean individual income between ages 40-50
graph use "${data}/mean_non_spouse_kd_2to99.gph"
graph play "${recordings}/take_out_blue_border.grec"
graph play "${recordings}/edit_figA6.grec"
graph export "${figs}/mean_inc_kd.${image_suffix}", replace
graph close

* Fig A5b: Income vs number of citations
use "${data}/mean_non_spouse_on_fcit_1996_21bins.dta", clear
gen weight = 5
replace weight = 1 if fcit_bin == 21
replace weight = 4 if fcit_bin == 20
reg   mean_non_spouse fcit_1996 [aw=weight]
local cons       = _b[_cons]
local slope      = _b[fcit_1996]
local slope_3    : di %04.3f `slope'
local se_slope   = _se[fcit_1996]
local se_slope_3 : di %04.3f `se_slope'
sum   fcit_1996, meanonly
local min_fcit = `r(min)'
local max_fcit = `r(max)'
twoway (scatter mean_non_spouse fcit_1996, mcolor(navy) lcolor(maroon)) ///
(function `slope'*x+`cons', range(`min_fcit' `max_fcit') lcolor(maroon)), ///
	text(680 450 "Slope : `slope_3'" "            (`se_slope_3')") ///
	graphregion(fcolor(white)) ///
	xtitle("Number of Citations") ///
	ytitle("Mean Annual Income Between Ages 40-50 ($1000)") ///
	legend(off) ///
	${title} ///
	ylabel(200(200)1200)
graph export "${figs}/income_on_citations.${image_suffix}", replace



log close
