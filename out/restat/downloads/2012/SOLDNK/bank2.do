* The Ticket to Easy Street?
* Scott Hankins, Mark Hoekstra, Paige Skiba
* April 12 2010

/* 
This do file recreates all of the tables and graphs for the paper
if you have any questions, please contact me
* Scott Hankins
* University of Kentucky
* scott.hankins@gmail.com

*/

version 10
clear all
macro drop _all
capture log close
set mem 1g

capture log close
log using bank2.smcl

/* The graphics scheme used here (vg_s1m) comes from http://www.stata-press.com/data/vgsg.html
i.e. the book "A Visual Guide to Stata Graphics" by Mitchell. Just follow the instructions on the website to install it
*/


local data_dir = "/media/disk/complete_bank/data/restat"
local results_dir = "/media/disk/complete_bank/"

set scheme vg_s1m

/*
-table 1 - constructing the sample
-table 2 - lottery players linked to bankruptcy
-table 3 - falsification regressions
-table 4 - main results
-table 5 - robustness checks
-table 6 - paige's responsibility

-figure 1a - flow graph
-figure 1b - flow graph w/ year effects partialed out
-figure 2 - bankruptcy rates in 1st 2 years after winning (by amount)
-figure 3 - bankruptcy rates 3 - 5 years after winning (by amount)
-figure 4 - bankruptcy rates within 5 years after winning (by amount)

*/

clear
set mem 500m


use `data_dir'/lottery_bankruptcy_anonymous.dta, clear

preserve

keep if fantasy == 1
keep if ( draw_date >= td(29apr1993) & draw_date <= td(22nov2002) )


* change the bucket size so there is a group between 100-150k
drop bucket
gen bucket = recode(amount, 1, 2.5, 5, 7.5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 60, 70, 80, 90, 100, 150, 151)


/* table 1 (construction of dataset) */
tabout bucket using `results_dir'/table1a

keep if county_phone_num <=1
tabout bucket using `results_dir'/table1b

keep if county_first_time == 1
tabout bucket using `results_dir'/table1c


/* table 2 (relationship between amount and bankruptcy)*/
gen byte after2 = ave_post_diff > 0 & ave_post_diff <=(2*365)
gen byte after25 = ave_post_diff > (2*365) & ave_post_diff <= (5*365)
gen byte after5 = ave_post_diff > 0 & ave_post_diff <= (5*365)

gen byte before2 = ave_pre_diff < 0 & ave_pre_diff >= (2* -365)
gen byte before25 = ave_pre_diff < (2*-365) & ave_pre_diff >= (5* -365)
gen byte before5 = ave_pre_diff < 0 & ave_pre_diff >= (5* -365)

tabout bucket after2  using `results_dir'/table2a
tabout bucket after25 using `results_dir'/table2b
tabout bucket after5  using `results_dir'/table2c

/* table 3 (falsification results) and table 4 (main results) */

gen game_change = draw_date >= td(16jul2001)


/* control for bankruptcy reform (mark's code) */
gen five_years_after=draw_date
replace five_years_after=.
replace five_years_after=(draw_date+(5*365))

*reform started on oct 17, 2005.  March 1, 2005 is when we think you started to see an uptick in bankrupcy
gen bank_reform= td(17oct2005)
gen bank_announce=td(01mar2005)

gen reform_time1 = 0
replace reform_time1=(five_years_after - bank_announce)
replace reform_time1=0 if reform_time1<0

*230 is the number of days max you could be exposed to the announcement
replace reform_time1=(bank_reform - bank_announce) if reform_time1>230
replace reform_time1=reform_time1/30

gen reform_time2=0
replace reform_time2 =(five_years_after-bank_reform)
replace reform_time2=0 if reform_time2<0
replace reform_time2=reform_time2/30

gen double reform_time11 = reform_time1^2
gen double reform_time22 = reform_time2^2
/* end mark's code */

* previous drawing total amount won and max amount won
bys draw_date: egen previous_max = max(amount)
gen new_pre_max = previous_max[_n-1] if previous_max[_n-1] != previous_max[_n]
bys draw_date: replace new_pre_max = new_pre_max[1]
drop previous_max
rename new_pre_max previous_max

bys draw_date: egen previous_total = sum(amount)
gen new_pre_total = previous_total[_n-1] if previous_total[_n-1] != previous_total[_n]
bys draw_date: replace new_pre_total = new_pre_total[1]
drop previous_total
rename new_pre_total previous_total

* total amount won in current drawing
bys draw_date: egen current_total = sum(amount)


gen byte bucket10  = amount > 2.5 & amount <=10
gen byte bucket50  = amount > 10 & amount <= 50
gen byte bucket100 = amount > 50 & amount <= 150

foreach group in before2 before25 before5 after2 after25 after5 {
    eststo: reg `group' bucket50 bucket100 if amount<=150
    eststo: reg `group' bucket50 bucket100 game_change if amount<=150
    eststo: xi:reg `group' bucket50 bucket100 i.draw_year if amount<=150
    eststo: xi:reg `group' bucket50 bucket100 game_change i.draw_year if amount<=150
}

esttab using `results_dir'/bank99_tables3_4.csv, se b(4) star(* .1 ** .05 *** .01)
eststo clear

/* table 5 (robustness checks) */

foreach group in after2 after25 after5 {
    eststo: xi:reg `group' bucket50 bucket100 game_change i.draw_year if amount<=150 /* table 5, column 1 */
    eststo: xi:reg `group' bucket10 bucket50 bucket100 game_change i.draw_year if amount<=150 /* table 5, column 2 */
    eststo: xi:reg `group' bucket50 bucket100 previous_max previous_total i.draw_year if amount<=150 /* table 5, column 4 */
    eststo: xi:reg `group' bucket50 bucket100 current_total i.draw_year if amount<=150 /* table 5, column 5 */
    eststo: xi:reg `group' bucket50 bucket100 game_change reform_time* i.draw_year if amount<=150 /* table 5, column 7 */
}

esttab using `results_dir'/bank99_table5a.csv, se b(4) star(* .1 ** .05 *** .01)
eststo clear

/* table 5, column 6 (4 vs. 5) */

foreach group in after2 after25 after5 {
  eststo: xi:reg `group' match5 if amount<=150 & draw_date >= td(16jul2001)
  }
  
esttab using `results_dir'/bank99_table5b.csv, se b(4) star(* .1 ** .05 *** .01)
eststo clear

/* probit for footnote*/
foreach group in after2 after25 after5 {
    eststo: dprobit `group' bucket50 bucket100 if amount<=150
    eststo: dprobit `group' bucket50 bucket100 game_change if amount<=150
    eststo: xi:dprobit `group' bucket50 bucket100 i.draw_year if amount<=150
    eststo: xi:dprobit `group' bucket50 bucket100 game_change i.draw_year if amount<=150
}

esttab using `results_dir'/bank99_probit.csv, margin p b(4) star(* .1 ** .05 *** .01) replace
eststo clear

restore, preserve

/* table 5, column 3 */
keep if (fantasy == 1 | lotto == 1)
keep if ( draw_date >= td(29apr1993) & draw_date <= td(22nov2002) )

* change the bucket size so there is a group between 100-150k
drop bucket
gen bucket = recode(amount, 1, 2.5, 5, 7.5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 60, 70, 80, 90, 100, 150, 151)

keep if county_phone_num <=1
keep if county_first_time == 1


gen byte after2 = ave_post_diff > 0 & ave_post_diff <=(2*365)
gen byte after25 = ave_post_diff > (2*365) & ave_post_diff <= (5*365)
gen byte after5 = ave_post_diff > 0 & ave_post_diff <= (5*365)

gen byte bucket10  = amount > 1 & amount <= 10
gen byte bucket50  = amount > 10 & amount <= 50
gen byte bucket100 = amount > 50 & amount <= 150

foreach group in after2 after25 after5 {
    eststo: xi:reg `group' bucket10 bucket50 bucket100 lotto i.draw_year if amount<=150
}

esttab using `results_dir'/bank99_table5c.csv, se b(4) star(* .1 ** .05 *** .01)
eststo clear

restore

/************************************  graphs  ************************************/
keep if fantasy == 1 
keep if ( draw_date >= td(29apr1993) & draw_date <= td(22nov2002) )

keep if county_phone_num <=1
keep if county_first_time == 1


gen byte after2 = ave_post_diff > 0 & ave_post_diff <=(2*365)
gen byte after25 = ave_post_diff > (2*365) & ave_post_diff <= (5*365)
gen byte after5 = ave_post_diff > 0 & ave_post_diff <= (5*365)

/*********************** flow graphs (unconditional) :: 5 years out ****************/
*** control = amount<=10k
gen big_amount = amount > 50 & amount <=150
gen small_amount = amount <=10

preserve

forvalues i = 1/5 {
    gen pre_`i' = ave_pre_diff < (`i' - 1)*-365 & ave_pre_diff >= `i' * -365
    gen post_`i' = ave_post_diff >(`i' - 1)* 365 & ave_post_diff <= `i' * 365
    }

replace post_1 = . if draw_year == 2007
replace post_2 = . if draw_year == 2006
replace post_3 = . if draw_year == 2005
replace post_4 = . if draw_year == 2004
replace post_5 = . if draw_year == 2003

forvalues i = 1/5 {
    egen big_pre_mean_`i'    = mean(pre_`i')  if big_amount == 1
    egen big_post_mean_`i'   = mean(post_`i') if big_amount == 1
    egen small_pre_mean_`i'  = mean(pre_`i')  if small_amount == 1
    egen small_post_mean_`i' = mean(post_`i') if small_amount == 1
    }

gen plot_year = 0

replace plot_year = -1 if (diff1 <0             & diff1 >= -365 *1)
replace plot_year = -2 if (diff1 < (-365 * 1)-1 & diff1 >= -365 *2)
replace plot_year = -3 if (diff1 < (-365 * 2)-1 & diff1 >= -365 *3)
replace plot_year = -4 if (diff1 < (-365 * 3)-1 & diff1 >= -365 *4)
replace plot_year = -5 if (diff1 < (-365 * 4)-1 & diff1 >= -365 *5)

replace plot_year = 1 if (diff1 > 0           & diff1 <= 365 *1)
replace plot_year = 2 if (diff1 > (365 * 1)+1 & diff1 <= 365 *2)
replace plot_year = 3 if (diff1 > (365 * 2)+1 & diff1 <= 365 *3)
replace plot_year = 4 if (diff1 > (365 * 3)+1 & diff1 <= 365 *4)
replace plot_year = 5 if (diff1 > (365 * 4)+1 & diff1 <= 365 *5)

drop if plot_year == 0

gen prob=0
forvalues i=1/5 {
    replace prob = small_pre_mean_`i'  if plot_year == -`i' & small_amount==1
    replace prob = small_post_mean_`i' if plot_year == `i'  & small_amount==1
    replace prob = big_pre_mean_`i'    if plot_year == -`i' & big_amount==1
    replace prob = big_post_mean_`i'   if plot_year == `i'  & big_amount==1
    }
drop if prob==0

sort plot_year
twoway ///
(connected prob plot_year if small_amount==1, lcolor(black) msymbol(X) mcolor(black)) ///
(connected prob plot_year if big_amount==1, clpattern(dash) lcolor(black) msymbol(O) mcolor(black)) ///
, yscale(range(0 .025)) ylabel(0(.005).025, angle(0) ) ytitle("Probability" "of Bankruptcy" ,orientation(horizontal)) ///
xscale(range(-5 5)) xlabel(-5(1)5) xtitle("Years from Winning") xline(0) ///
legend(symxsize(5) cols(1) position(6) order(1 "Small Amounts (<=$10,000)" 2 "Large Amounts ($50-150,000)"))
graph export `results_dir'/flow.png ,replace
graph save `results_dir'/flow ,replace

restore
/* flow graph with year and game effects removed */
preserve

forvalues i = 1/5 {
    gen pre_`i' = ave_pre_diff < (`i' - 1)*-365 & ave_pre_diff >= `i' * -365
    gen post_`i' = ave_post_diff >(`i' - 1)* 365 & ave_post_diff <= `i' * 365
    }

replace post_1 = . if draw_year == 2007
replace post_2 = . if draw_year == 2006
replace post_3 = . if draw_year == 2005
replace post_4 = . if draw_year == 2004
replace post_5 = . if draw_year == 2003

forvalues i = 1/5 {
    eststo: xi: reg pre_`i' i.draw_year lotto
    predict double pre_resid_`i', residuals
    eststo: xi: reg post_`i' i.draw_year lotto
    predict double post_resid_`i', residuals
}
esttab using `results_dir'/bank99_regression_flow.csv, se b(4) star(* .1 ** .05 *** .01)
eststo clear

forvalues i = 1/5 {
    egen big_pre_mean_`i'    = mean(pre_resid_`i')  if big_amount == 1
    egen big_post_mean_`i'   = mean(post_resid_`i') if big_amount == 1
    egen small_pre_mean_`i'  = mean(pre_resid_`i')  if small_amount == 1
    egen small_post_mean_`i' = mean(post_resid_`i') if small_amount == 1
    }

gen plot_year = 0

replace plot_year = -1 if (ave_pre_diff <0                  & ave_pre_diff >= -365 *1)
replace plot_year = -2 if (ave_pre_diff < (-365 * 1)-1 & ave_pre_diff >= -365 *2)
replace plot_year = -3 if (ave_pre_diff < (-365 * 2)-1 & ave_pre_diff >= -365 *3)
replace plot_year = -4 if (ave_pre_diff < (-365 * 3)-1 & ave_pre_diff >= -365 *4)
replace plot_year = -5 if (ave_pre_diff < (-365 * 4)-1 & ave_pre_diff >= -365 *5)

replace plot_year = 1 if (ave_post_diff > 0                  & ave_post_diff <= 365 *1)
replace plot_year = 2 if (ave_post_diff > (365 * 1)+1 & ave_post_diff <= 365 *2)
replace plot_year = 3 if (ave_post_diff > (365 * 2)+1 & ave_post_diff <= 365 *3)
replace plot_year = 4 if (ave_post_diff > (365 * 3)+1 & ave_post_diff <= 365 *4)
replace plot_year = 5 if (ave_post_diff > (365 * 4)+1 & ave_post_diff <= 365 *5)

drop if plot_year == 0

gen prob=0
forvalues i=1/5 {
    replace prob = small_pre_mean_`i'  if plot_year == -`i' & small_amount==1
    replace prob = small_post_mean_`i' if plot_year == `i'  & small_amount==1
    replace prob = big_pre_mean_`i'    if plot_year == -`i' & big_amount==1
    replace prob = big_post_mean_`i'   if plot_year == `i'  & big_amount==1
    }
drop if prob==0

sort plot_year
twoway ///
(connected prob plot_year if small_amount==1, lcolor(black) msymbol(X) mcolor(black)) ///
(connected prob plot_year if big_amount==1, clpattern(dash) lcolor(black) msymbol(O) mcolor(black)) ///
,  yscale(range(-.0125 .0125)) ylabel(-.01(.005).01, angle(0)) ytitle("Probability" "of Bankruptcy" ,orientation(horizontal)) ///
xscale(range(-5 5)) xlabel(-5(1)5) xtitle("Years from Winning") xline(0) ///
legend(symxsize(5) cols(1) position(6) order(1 "Small Amounts (<=$10,000)" 2 "Large Amounts ($50-150,000)"))
graph export `results_dir'/flow2.png ,replace
graph save `results_dir'/flow2 ,replace

restore
************************************************************
* change the buckets so there are fewer goups and label them so the lines are centered
drop bucket
gen bucket = recode(amount, 1, 5, 15, 25, 35, 45, 55, 75, 95, 100, 101)
recode bucket (15 = 10) (25 = 21) (35 = 30) (45 = 40) (55 = 50) (75 = 65) (95 = 85)

/************************* confidence interval graphs */
foreach group in after2 after25 after5 {
    egen mean = mean(`group') ,by(bucket)
    egen std = semean(`group') ,by(bucket)
    gen high = mean + (1.96*std)
    gen low = mean - (1.96*std)
    twoway ///
    (rcap high low bucket if bucket <=100 & bucket !=5 , msize(vlarge)) ///
    (scatter mean bucket if bucket <= 100 & bucket !=5 , msymbol(O) msize(medium)) ///
    , yscale(range(-.02 .2)) ylabel(0 (.05) .2, angle(0)) xscale(range(1 100) ) ///
    ytitle("Probability" "of Bankruptcy" ,orientation(horizontal)) xtitle("Amount Won ($1,000s)") ///
    legend(symxsize(5) cols(1) position(6) order(2 "Mean" 1 "95% Confidence Interval"))
    graph export `results_dir'/ciplot_`group'.png, replace
    graph save `results_dir'/ciplot_`group', replace
    
    drop mean std high low
}

log close

