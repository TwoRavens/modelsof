* 2018-11-8
/* 

This do-file creates all figures found in the main text of

  - Bell, A., Chetty, R., Jaravel, X., Petkova, N. & Van Reenen, J. (2018). 
		Who Becomes an Inventor in America? The Importance of Exposure to Innovation
		
*/

* Run patents_figs_metafile first!

* Log
cap log close
log using "${logs}/figures_main_text_log.log", replace

*** FIGURES IN MAIN TEXT

* Fig 1: Patent rates vs. parent income percentile 
use "${data}/inventor_on_par_inc8084.dta", clear
replace inventor = inventor * 1000
replace fcit_top5pc = fcit_top5pc * 1000

* Fig 1a:  All Inventors by 2014
twoway scatter inventor par_bin, mcolor(navy) ///
	${title} msize(vsmall) ///
	xtitle("Parent Household Income Percentile") ///
		ytitle("Inventors per Thousand")
graph export "${figs}/inventor_on_parinc.${image_suffix}", replace 		
	
* Fig 1b:  Highly-Cited Inventors
twoway scatter fcit_top5pc par_bin, mcolor(navy)  ///
	${title} msize(vsmall) ///
	xtitle("Parent Household Income Percentile") ///
	ytitle("Highly-Cited (Top 5%) Inventors per Thousand", margin(b-3)) ///
	ylab(0 "0" .1 "0.1" .2 "0.2" .3 "0.3" .4 "0.4", gmax)
graph export "${figs}/highly_cited_on_parinc.${image_suffix}", replace 


* Fig 2: Patent rates by race and ethnicity, NYC
use "${data}/race_reweighting.dta", clear

gen sort = 1 if ethnicity == "White"
replace sort = 2 if ethnicity == "Black"
replace sort = 3 if ethnicity == "Hispanic"
replace sort = 4 if ethnicity == "Asian"
gen inv_1k_unweighted = inv_1k if weight=="none"
gen inv_1k_math3 = inv_1k if weight=="math3"
gen inv_1k_par_vin = inv_1k if weight=="par_vin"
sort sort

graph bar inv_1k_unweighted  inv_1k_par_vin inv_1k_math3, ///
	over(ethnicity, sort(sort)) ///
	bargap(10)  ///
	legend(off) ///
	ytitle("Inventors per Thousand") ///
	${title} ///
	blabel(bar, position(center) format(%12.1f) color(black)) ///
	yscale(range(0 4)) ///
	bar(1, color("255 229 204")) ///
	bar(2, color("255 178 102"))  ///
	bar(3, color("255 128 0"))

graph export "${figs}/inventors_byrace.${image_suffix}", replace


* Fig 3: Percentage of Female Inventors by Birth Cohort
use "${data}/female_by_cohort.dta", clear

keep if yob <=1980 & yob>=1940
reg female yob, vce(r)
local slope : di %3.2f _b[yob]
local se : di %4.3f _se[yob]

twoway (scatter  female yob) (lfit female yob, lcolor(maroon)), /// 
	ylabel(0(10)50, gmax) ///
	graphregion(fcolor(white)) ///
	legend(off) ///
	${title} ///
	xtitle("Year of Birth") ///
	ytitle("Percentage of Inventors who are Female ") ///
	text( 35 1955 "Average Change per Year: `slope'%" "(`se')") 
graph export "${figs}/female_inventors_bycohort.${image_suffix}", replace

* Fig 4: Patent rates vs grade 3 math scores
* Fig 4a: Patent rates vs grade 3 math scores, by parental income
insheet using "${data}/nyc_inv_on_math3_bypar.csv", clear

twoway (connected inv_1k_by1 math3_by1, mcolor(dkorange) lcolor(dkorange) msymbol(triangle)) ///
(connected inv_1k_by2 math3_by2, mcolor(navy) lcolor(navy)), ///
	graphregion(fcolor(white))  ///
	legend(label(1 "Parent Income Below 80th Percentile")  /// 
	label(2 "Parent Income Above 80th Percentile") /// 
	pos(6) size(2.5)) ///
	xtitle("3rd Grade Math Test Score (Standardized)") ///
	ytitle("Inventors per Thousand") ///
	${title} ///
	text(6.5 0.9 "90th Percentile") ///
	xscale(range(-2 2.5)) ///
	yscale(range(0 8.05)) ///
	xline(1.4, lpattern(dash) lc(maroon))

graph export "${figs}/inventor_on_math3_byparinc.${image_suffix}", replace


* Fig 4b: Patent rates vs test scores by race and ethnicity, NYC
insheet using "${data}/nyc_inv_on_math3_byrace.csv", clear

forval i = 1/4 {
	replace inv_1k_by`i' = inv_1k_by`i' * 1000
	}
label variable math3_by1 "math3; ethn==Asian"
label variable math3_by2 "math3; ethn==Black"
label variable math3_by3 "math3; ethn==Hispanic"
label variable math3_by4 "math3; ethn==White"
label variable inv_1k_by1 "inv_1k; ethn==Asian"
label variable inv_1k_by2 "inv_1k; ethn==Black"
label variable inv_1k_by3 "inv_1k; ethn==Hispanic"
label variable inv_1k_by4 "inv_1k; ethn==White"

twoway (connected inv_1k_by1 math3_by1, msymbol(circle) mcolor(navy) lcolor(navy)) ///
(connected inv_1k_by2 math3_by2, msymbol(diamond) mcolor(maroon) lcolor(maroon)) ///
(connected inv_1k_by3 math3_by3, msymbol(triangle) mcolor(forest_green) lcolor(forest_green)) ///
(connected inv_1k_by4 math3_by4, msymbol(square) mcolor(dkorange) lcolor(dkorange)) , ///
	xtitle("3rd Grade Math Test Score (Standardized)") ///
	ytitle("Inventors per Thousand") ///
	${title} ///
	text(6.5 0.9 "90th Percentile") ///
	legend(order (3 2 4 1) label(4 "White") label(2 "Black") label(3 "Hispanic") label(1 "Asian") row(1)) ///
	xline(1.4, lpattern(dash) lc(maroon)) ///
	yscale(range(0 8.05)) ///
	xscale(range(-2 2.5))
graph export "${figs}/inventor_on_math3_byrace.${image_suffix}", replace
	
* Fig 4c: Patent rates vs test scores by gender, NYC
use "${data}/gender3.dta", clear
gen math = (math30*n0 + math31*n1) /(n0+n1)
twoway (connected inv_1k1 math, mcolor(navy) lcolor(navy)) ///
(connected inv_1k0 math,  mcolor(dkorange) lcolor(dkorange) msymbol(triangle)), ///
	graphregion(fcolor(white))  ///
	legend(label(1 "Male") label(2 "Female") ///
	order(2 1)) ///
	xtitle("3rd Grade Math Test Score (Standardized)") ///
	ytitle("Inventors per Thousand") ///
	${title} ///
	text(6.5 0.8 "90th Percentile") ///
	xscale(range(-2 2.5)) ///
	yscale(range(0 8.05)) ylab(0 (2) 8) ///
	xline(1.35, lpattern(dash) lc(maroon))
graph export "${figs}/inventor_on_math3_bygender.${image_suffix}", replace

* Fig 5: Pct. of Gap in Patent Rates for Low vs. High-Inc. Students Explained
* by Test Scores in Grades 3-8
local data_gap "${data}/p80"

* Compute raw and reweighted means and gaps
matrix gap_closed = J(6,1,.) // store fraction of gap closed at each grade
forvalues grade = 3/8 {
	* Load grade-specific data set
	use "`data_gap'`grade'", clear
	
	* Raw means and gap
	* Kids from high-income families
	sum inv_1k1 [aw=n1]
	local high_mean_`grade' = `r(mean)'
	local N1				= `r(sum_w)' 	// # of kids from high-inc families
	* Kids from low-income families
	sum inv_1k0 [aw=n0]
	local low_mean_`grade'  = `r(mean)'
	local N0				= `r(sum_w)' 	// # of kids from low-inc families
	* Gap
	local diff_`grade'	= `high_mean_`grade''-`low_mean_`grade''
	
	* Reweighting the disadvantaged group
	sum inv_1k0 [aw=n1]
	local rw_low_mean_`grade' = `r(mean)'
	* Gap
	local rw_diff_`grade' 	  = `high_mean_`grade''-`rw_low_mean_`grade''
	* Compute fraction of gap closed
	local closed_`grade' = 1-`rw_diff_`grade'' / `diff_`grade''
	matrix gap_closed[`grade'-2,1]  = `closed_`grade'' * 100
}

* Compute average pp change per grade
clear
svmat gap_closed
gen grade = _n + 2
regress gap_closed grade // robust standard errors are smaller
local slope : di %3.2f _b[grade]
local se : di %3.2f _se[grade]

* Scatter plot
twoway (scatter gap_closed grade) ///
(lfit gap_closed grade), ///
	xtitle("Grade") ///
	ytitle("Percent of Gap Explained by Math Test Scores") ///
	text(31.5 7.4 "Slope: `slope'%" ///
	"        (`se')") ///
	ylab(30(5)50) ///
	${title} ///
	legend(off)
graph export "${figs}/pct_gap_explained_by_math_scores.${image_suffix}", replace

/* Fig 6: Patent rates and college attended
Note: Sample is birth cohorts 1980-84 matched to a college based on college
most attended at age 19-22. */

* Fig 6a: Top 10 colleges for Patent Rates (note: this dataset is one of the online tables)
use "${data}/patents_by_college.dta", clear
* Keep 10 large colleges with highest share of inventors
keep if count >= 2500
gsort -inventor
keep if _n <= 10
replace inventor=inventor * 1000
replace instnm = subinstr(instnm,"O","o",.)
local col3 "0 0 102"
graph hbar (asis) inventor, ///
	over(instnm, sort(inventor) descending) ///
    bar(1, fcolor(`col3') lcolor(`col3')) ///
    ylabel(0(20)120, gmax) ///
	ytitle("Inventors per 1000 Students") ///
	${title} ///
    yscale(range(0 120)) ymtick(##2) ///
    legend(off) name(g1, replace)
graph export "${figs}/top_10_colleges_innovation.${image_suffix}", replace 

* Fig 6b: Patent rates vs. parent income percentile in 10 most innovative colleges
import delimited "${data}/top10coll_inv_parinc.csv", clear
replace par_rank_n = par_rank_n * 100
twoway (scatter inventor par_rank_n, mcolor(navy) lcolor(maroon)) ///
 , xt("Parents' Percentile Rank in National Income Distribution") ///
 yt("Inventors per 1000 Students") ///
 ${title} ///
  ylab(0 (10) 90) yscale(range(0 90)) xlab (0(20)100) 
graph export "${figs}/top10coll_inv_parinc.${image_suffix}", replace 

* Fig 7: Patent rates vs. class-level patent rates in childhood environment

* Fig 7a: Distance between father's technology class and child's technology class
use "${data}/distance_ownddad_class_8084.dta", replace
twoway connected density distance_rank if dist<=100, ///
	ytitle("Inventors per Thousand") ///
	${title} ///
	xtitle("Distance from Father's Technology Class") ///
	ylabel(0 "0" .2 "0.2" .4 "0.4" .6 "0.6" .8 "0.8" 1 "1", gmax) msize(vsmall)
graph export "${figs}/distance_ownddad_class.${image_suffix}", replace


* Fig 7b: Effect of Class-Level Patent Rates in Father’s Industry by Distance
import delim using "${data}/naics_distance_f8_matrix_v1.csv", clear

ren c1 reg_coef
gen dist = (_n-1)*10

graph bar reg_coef, ///
	bargap(10) ///
	over(dist, relabel(1 "0" 2 "1-10" 3 "11-20" 4 "21-30" 5 "31-40" 6 "41-50" 7 "51-60" 8 "61-70" 9 "71-80" 10 "81-90" 11 "91-100"))  ///
	b1title("Distance Between Technology Classes") ///
	title(" ") ///
	ylabel(0 "0" .02 "0.02" .04 "0.04" .06 "0.06" .08 "0.08") ///
	ytitle("Regression Coefficient on Class-Level Patent Rate")
graph export "${figs}/Father_class_level_bydistance.${image_suffix}", replace

* Fig 7c: Effect of Class-Level Patent Rates in CZ by Technological Distance
import delim using "${data}/cz_distance_f8_matrix_v1.csv", clear

ren c1 reg_coef
gen dist = (_n-1)*10
graph bar reg_coef, ///
	bargap(10) ///
	over(dist, relabel(1 "0" 2 "1-10" 3 "11-20" 4 "21-30" 5 "31-40" 6 "41-50" 7 "51-60" 8 "61-70" 9 "71-80" 10 "81-90" 11 "91-100"))  ///
	b1title("Distance Between Technology Classes") ///
	ylabel(0 "0" .2 "0.2" .4 "0.4" .6 "0.6" .8 "0.8" 1 "1" 1.2 "1.2") ///
	title(" ") ///
	ytitle("Regression Coefficient on Class-Level Patent Rate") 
graph export "${figs}/CZ_class_level_bydistance.${image_suffix}", replace


* Fig 8: Patent rates by CZ where child grew up
* Now using online table: birth cohorts 1980-84

* Fig 8a: Map of patent rates by childhood CZ
use "${data}/patents_by_cz.dta", clear
rename par_cz cz
gen share = inventor * 1000
replace share = . if kid_count<1000
* Share of kids excluded by restriction
sum cz [aw=kid_count]
local tot_kids = `r(sum_w)'
sum cz [aw=kid_count] if kid_count<1000
local excl_kids = `r(sum_w)'
local pct_exc = `excl_kids'/ `tot_kids' * 100
di `pct_exc'

maptile2 share, geo(cz) nq(10) ///
 savegraph("${figs}/map_inventors.png") colorscheme("Blues") 
 

 * Fig 8b: Bar chart of top 10 and bottom 10 CZs per innovation rates
use "${data}/patents_by_cz.dta", clear

*merge in the CZ names and size
rename par_cz cz
merge 1:1 cz using "${data}/cz_name_pop.dta", nogen keep(match)
gen cz_lab=czname + ", " + stateabbrv

* Keep 100 largest CZs and sort by share of inventors
gsort - pop2000
keep in 1/100
gsort -inventor
gen rank=_n
replace inventor=inventor*1000

* Generate figure
local col2 "126 183 239"
local col3 "0 0 102"
graph hbar (asis) inventor if rank<=10, ///
	over(cz_lab, sort(inventor) descending) ///
    bar(1, fcolor(`col3') lcolor(`col3')) ///
    ylabel(0(1)6, gmax) ///
	ytitle("Inventors per 1000 Children") ///
	title("{bf:Top 10}"" ", size(normal)) ///
    yscale(range(0 6)) ymtick(##2) ///
	name(g1, replace)
graph hbar (asis) inventor if rank>90, ///
	over(cz_lab, sort(inventor) descending) ///
    bar(1, fcolor(`col2') lcolor(`col2')) ///
    ylabel(0(1)6, gmax) ///
	ytitle("Inventors per 1000 Children") ///
	title("{bf:Bottom 10}"" ", size(normal)) ///
    yscale(range(0 6)) ymtick(##2) ///
    legend(off) name(g2, replace)
graph combine g1 g2
graph export "${figs}/top_bottom_10_cz_by_innovation.${image_suffix}", replace 

* Fig 9: Patent rates of children and adults in CZ
* Now using online table: birth cohorts 1980-84
use "${data}/patents_by_cz", clear
rename par_cz cz

* Merge in the Annual Patent Rate per Thousand Working Age Adult
merge 1:1 cz using "${data}/czpatentingintensity.dta", nogen
* Merge in the CZ names and size
merge 1:1 cz using "${data}/cz_name_pop.dta", nogen

gen inventor_1k =inventor*1000
gen inventor_p_1k = patentspercap*1000

* Keep 100 largest CZs
gsort -pop2000
g pop_rank = _n
keep if pop_rank <= 100

* Labels
gen label=1 if inlist(czname, ///
 "Madison", "Houston", "Minneapolis", "Newark", "San Jose", "Brownsville")
replace label = 1 if cz == 20100

* Variable for repositioning of CZ labels in scatter plot
gen pos=3
replace pos=9 if czname=="San Jose"
replace pos=5 if czname=="Houston"  
replace pos=4 if czname == "Brownsville"
replace pos=12 if czname=="Portland"

twoway (scatter inventor_1k inventor_p_1k if label==1, mlabv(pos) mlabel(czname)) ///
(scatter inventor_1k inventor_p_1k, mc(navy)) ///
(lfit inventor_1k inventor_p_1k, lc(maroon)), ///
	ylabel(0(1)6, gmax)  ///
	${title} ///
	xlabel(0 "0" .2 "0.2" .4 "0.4" .6 "0.6" .8 "0.8" ) ///
	xtitle("Annual Patent Rate per Thousand Working Age Adults in CZ") ///
	ytitle("Num. of Inventors per 1000 Children who Grow up in CZ") ///
	legend(off) 
graph export "${figs}/inventors_by_par_cz.${image_suffix}", replace 

* Fig 10: Percent of female inventors by origin
* Fig 10a: Percent of female inventors by state where child grew up
* Now using online table: birth cohorts 1980-84
use "${data}/patents_by_state", clear
gen num_f = inventor_g_f * kid_count_g_f
gen num_m = inventor_g_m * kid_count_g_m
gen num_inv = num_f + num_m
gen share_f = num_f / (num_inv)
replace share_f = 100* share_f
rename par_state state
label drop _all
maptile2 share_f, geo(state) ///
colorscheme("Blues")  cutvalues(0 5 14.7 16.8 18.4 20.4 25)  ///
 legdecimals(1) savegraph("${figs}/map_female_inventors.png")


* Fig 10b: Top 10/Bottom 10 CZ for Share Female Inventors
* Now using online table: birth cohorts 1980-84
use "${data}/patents_by_cz", clear

*merge in the CZ names and population
rename par_cz cz
merge 1:1 cz using "${data}/cz_name_pop.dta", nogen keep(match)
gen cz_lab=czname + ", " + stateabbrv

* Keep 100 largest CZs and sort by share of female inventors
gsort - pop2000
keep in 1/100
gen num_f = inventor_g_f * kid_count_g_f
gen num_m = inventor_g_m * kid_count_g_m
gen num_inv = num_f + num_m
gen share_f = num_f / (num_inv)
gsort -share_f
replace share_f=share_f*100
gen rank = _n

* Generate figure
local col2 "126 183 239"
local col3 "0 0 102"
graph hbar (asis) share_f if rank<=10, ///
	over(cz_lab, sort(share_f) descending) ///
    bar(1, fcolor(`col3') lcolor(`col3')) ///
    ylabel(0(10)50, gmax) ///
	ytitle("Female Inventor Share (%)") ///
	title("{bf:Top 10}"" ", size(normal)) ///
    yscale(range(0 50)) ymtick(##2) ///
    legend(off) name(g1, replace)
graph hbar (asis) share_f if rank>90, ///
	over(cz_lab, sort(share_f) descending) ///
    bar(1, fcolor(`col2') lcolor(`col2')) ///
    ylabel(0(10)50, gmax) ///
	ytitle("Female Inventor Share (%)") ///
	title("{bf:Bottom 10}"" ", size(normal)) ///
    yscale(range(0 50)) ymtick(##2) ///
    legend(off) name(g2, replace)
graph combine g1 g2
graph export "${figs}/top_bottom_10_cz_by_femaleshare.${image_suffix}", replace 

* Figure 11: Income and Citations of Inventors by Characteristics at Birth

* Fig 11a: Mean Income
use "${data}/cittop5_by_female.dta", clear
gen inc_mean   = f1040_inc_mean / 1000
gen inc_semean = f1040_inc_semean / 1000 
tempfile female
save `female'

use "${data}/cittop5_by_p80.dta", clear
gen inc_mean   = f1040_inc_mean / 1000
gen inc_semean = f1040_inc_semean / 1000 
tempfile p80
save `p80'

use "${data}/hhjkpredictions.dta", clear
gen group      = "Minority"     if minority == 1
replace group  = "Non-Minority" if minority == 0
gen inc_mean   = f1040_inc_mean / 1000
gen inc_semean = f1040_inc_semean / 1000 
keep if minority != .
append using `female' `p80'

generate x_place = 0
replace  x_place = 1.7 if female == 1 | minority == 1 | p80 == 0
replace  x_place = x_place + 5 if minority != .
replace  x_place = x_place + 10 if female != .

generate inc_mean_high = inc_mean + 1.96 * inc_semean
generate inc_mean_low  = inc_mean - 1.96 * inc_semean

gen x_place_2 = x_place - 0.42
gen y_place = inc_mean / 2
format inc_mean %12.0f

twoway (bar inc_mean x_place if p80 == 1 | female == 0 | minority == 0, color(navy) fintensity(full)) ///
(bar inc_mean x_place if p80 == 0 | female == 1 | minority == 1, color(maroon) fintensity(full)) ///
(rcap inc_mean_high inc_mean_low x_place, lcolor(black)) ///
(scatter y_place x_place_2, msymbol(none) mlabel(inc_mean) mlabcolor(white)), ///
       xlabel(-.2 `""Par Inc." "Above p80""' 1.8 `""Par Inc." "Below p80""' 4.9 "Non-Minority" 6.8 "Minority" 10 "Male" 11.7 "Female", noticks) ///
       ${title} ///
	   legend(off) ///
	   graphregion(fcolor(white)) ///
	   ytitle("Mean Income in 2012 ($1000)")
graph export "${figs}/inv_inc_bygenderminorityparinc.${image_suffix}", replace 

* Fig 11b: Fraction with Highly-Cited Patents
use "${data}/cittop5_by_female.dta", clear

gen top5_fcit_mean = cittop5_mean * 100
gen top5_fcit_semean = cittop5_semean * 100
tempfile female
save `female'

use "${data}/cittop5_by_p80.dta", clear

gen top5_fcit_mean = cittop5_mean * 100
gen top5_fcit_semean = cittop5_semean * 100
tempfile p80
save `p80'

use "${data}/hhjkpredictions.dta", clear
gen group = "Minority" if minority == 1
replace group = "Non-Minority" if minority == 0
gen top5_fcit_mean = cittop5_mean *100
gen top5_fcit_semean = cittop5_semean*100
keep if minority != .
append using `female' `p80'

generate x_place = 0
replace x_place = 1.7 if female == 1 | minority == 1 | p80 == 0
replace x_place = x_place + 5 if minority != .
replace x_place = x_place + 10 if female != .

generate top5_fcit_high = top5_fcit_mean + 1.96 * top5_fcit_semean
generate top5_fcit_low = top5_fcit_mean - 1.96 * top5_fcit_semean
replace top5_fcit_low  = 0 if top5_fcit_low < 0

gen x_place_2 = x_place - 0.32
gen y_place = top5_fcit_mean / 2
format top5_fcit_mean %12.1f

twoway (bar top5_fcit_mean x_place if p80 == 1 | female == 0 | minority == 0, color(navy) fintensity(full)) ///
(bar top5_fcit_mean x_place if p80 == 0 | female == 1 | minority == 1, color(maroon) fintensity(full)) ///
(rcap top5_fcit_high top5_fcit_low x_place, lcolor(black)) (scatter y_place x_place_2, msymbol(none) mlabel(top5_fcit_mean) mlabcolor(white)), ///
       xlabel(-.2 `""Par Inc." "Above p80""' 1.8 `""Par Inc." "Below p80""' 4.9 "Non-Minority" 6.8 "Minority" 10 "Male" 11.7 "Female", noticks) ///
	   ylabel(, format(%1.0f)) ///
	   legend(off) ///
	   ${title} ///
	   graphregion(fcolor(white)) ///
	   ytitle("Pct. of Inventors in Top 5% of Citation Distribution")
graph export "${figs}/inventors_top5_bygenderminorityparinc.${image_suffix}", replace 

log close

