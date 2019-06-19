* replicate figure 1
use $data\edex_data_analytic, clear

* figure 1a
gen edoutcome = 1 if f3attainment==1
replace edoutcome = 2 if f3attainment==2
replace edoutcome = 3 if f3attainment>=3 & f3attainment<=5
replace edoutcome = 4 if f3attainment==6 | f3attainment==7
replace edoutcome = 5 if f3attainment>=8

preserve
keep edoutcome
gen samplecat = 1 
save temp_1, replace
restore

preserve
gen samplecat = 2 if cbyrace6==1 
replace samplecat = 3 if cbyrace3==1 
keep edoutcome samplecat
drop if samplecat==.
save temp_2, replace
restore

preserve
gen samplecat = 4 if gend==1 
replace samplecat = 5 if gend==0 
keep edoutcome samplecat
drop if samplecat==.
save temp_3, replace
restore

use temp_1, clear
append using temp_2
append using temp_3

foreach i of num 1/5 {
twoway__histogram_gen edoutcome if samplecat==`i', discrete generate(h`i' x`i')
}
keep x* h*
keep if _n<=5

reshape long h, i(x1) j(category)
keep category x1 h


label define fig1 1 "Less Than HS" 2 "HS Diploma" 3 "Some College" 4 "4-Yr Degree" 5 "Graduate Degree"
label values x1 fig1

label define cate 1 "All Sample" 2 "White" 3 "Black" 4 "Male" 5 "Female"
label values category cate

graph bar h, over(category) over(x1, label(labsize(3))) asyvar bar(1, color(black) fintensity(inten100)) bar(2, color(black) fintensity(inten60)) bar(3, color(black) fintensity(inten40)) bar(4, color(black) fintensity(inten20)) bar(5, color(black) fintensity(inten0)) graphregion(color(white)) bgcolor(white)  ysc(r(0 0.62)) ylabel(0 "0" 0.2 "0.2" 0.4 "0.4" 0.6 "0.6") title("Educational Attainment by Subgroup", size(medium)) ytitle("Fraction")
graph export $figure\figure1a.pdf, replace

use $data\edex_data_analytic, clear

keep byte20 bytm20 f3attainment


gen math=1
preserve
keep bytm20 math f3attainment
rename bytm20 Texp
save math_temp, replace
restore
preserve
keep byte20 math f3attainment
replace math=0
rename byte20 Texp
save eng_temp, replace
restore
clear
u math_temp
append using eng_temp

gen Y = f3attainment>=6

label define fig1 1 "Less Than HS" 2 "HS Diploma" 3 "Some 2-Yr" 4 "Some College" 5 "4-Yr Degree" 6 "Masters" 7 "Advanced"
label values Texp fig1

label define fig1math 0 "ELA Teacher" 1 "Math Teacher"
label values math fig1math

graph bar Y, over(math, label(labsize(tiny))) over(Texp, label(labsize(2.6))) asyvars bar(1, color(black) fintensity(inten100)) bar(2, color(black) fintensity(inten0)) ytitle("Probability of Completion", size(small)) title("4-Year College Graduation Rates by Teacher Expectation", size(medium) color(black)) graphregion(color(white)) bgcolor(white)  ysc(r(0 1)) ylabel(0 "0" 0.2 "0.2" 0.4 "0.4" 0.6 "0.6" 0.8 "0.8"  1 "1")
*graph bar Y, over(math, label(labsize(tiny))) over(Texp, label(labsize(2.6)) relabel(`r(relabel)')) asyvars bar(1, color(black) fintensity(inten100)) bar(2, color(black) fintensity(inten0)) ytitle("Probability of Completion", size(small)) title("4-Year College Graduation Rates by Teacher Expectation", size(medium) color(black)) graphregion(color(white)) bgcolor(white)  ysc(r(0 1)) ylabel(0 "0" 0.2 "0.2" 0.4 "0.4" 0.6 "0.6" 0.8 "0.8"  1 "1")

graph export $figure\figure1b.pdf, replace

