* * * VOLATILE TOP INCOME SHARES IN SWITZERLAND? * * * 
 
 * Isabel Martinez, University of St. Gallen, 2012
 
 /***
 NOTES:
 * Pareto imputation following the approach of Dell, Piketty and Saez (2007); 
 see Piketty (2001) for details
 
 * years 1971-80
 
 ***/
*_____________________________________________________________________________________
 
version 14.0

clear all
set more off
cap log close
cap graph drop _all
cap clear matrix 
 

// read-in total adult population and married adults
import excel "$thepath/Population.xlsx", sheet("popstat_CH 1971-80") cellrange(D18:G23) clear firstrow
tempfile popstat
save "`popstat'"

use  "$thepath/1b_Swiss_tax_data_1971-80.dta", clear
merge 1:1 cant year using  "`popstat'", nogen

// claculate total income denominator, taking non-filers into account and assigning them 20% of average income
gen total_taxunits=total_adults-0.5*married
gen income_denominator=inc_total *[1+ 0.2*((total_taxunits)/tu_total - 1)]
format %15.0g income_denominator

  
*1) Generate total incomce y_s above each threshold s
 gen y_2000 = (inc_2000)
 label var y_2000 "Total income of all tax units with incomes above 2'000'000 SFr."
 
 gen y_1000 = (inc_1000 + y_2000)
 label var y_1000 "Total income of all tax units with incomes above 1'000'000 SFr."
 
 gen y_500 = (inc_500 + y_1000)
 label var y_500 "Total income of all tax units with incomes above 500'000 SFr."
 
 gen y_400 = (inc_400 + y_500)
 label var y_400 "Total income of all tax units with incomes above 400'000 SFr."
 
 gen y_300 = (inc_300 + y_400)
 label var y_300 "Total income of all tax units with incomes above 300'000 SFr."
 
 gen y_200 = (inc_200 + y_300)
 label var y_200 "Total income of all tax units with incomes above 200'000 SFr."
 
 gen y_150 = (inc_150 + y_200)
 label var y_150 "Total income of all tax units with incomes above 150'000 SFr."

 gen y_120 = (inc_120 + y_150)
 label var y_120 "Total income of all tax units with incomes above 120'000 SFr."
 
 gen y_100 = (inc_100 + y_120)
 label var y_100 "Total income of all tax units with incomes above 100'000 SFr."
 
 gen y_90=(inc_90 + y_100)
 label var y_90 "Total income of all tax units with incomes above 90'000 SFr."
 
 gen y_80=(inc_80 + y_90)
  label var y_80 "Total income of all tax units with incomes above 80'000 SFr."
  
 gen y_70=(inc_70 + y_80)
  label var y_70 "Total income of all tax units with incomes above 70'000 SFr."
  
 gen y_60=(inc_60 + y_70)
   label var y_60 "Total income of all tax units with incomes above 60'000 SFr."

  
  *2) Generate total number of tax units t_s above each threshold s:
  
  gen t_2000 = tu_2000
  label var t_2000 "Total number of tax units with incomes above 2'000'000 SFr."
  
  gen t_1000 = (tu_1000 + t_2000)
  label var t_1000 "Total number of tax units with incomes above 1'000'000 SFr."
  
  gen t_500 = (tu_500 + t_1000)
  label var t_500 "Total number of tax units with incomes above 500'000 SFr."
  
  gen t_400 = (tu_400 + t_500)
  label var t_400 "Total number of tax units with incomes above 400'000 SFr."
  
  gen t_300 = (tu_300 + t_400)
  label var t_300 "Total number of tax units with incomes above 300'000 SFr."
  
  gen t_200 = (tu_200 + t_300)
  label var t_200 "Total number of tax units with incomes above 200'000 SFr."
 
  gen t_150 = (tu_150 + t_200)
  label var t_150 "Total number of tax units with incomes above 150'000 SFr."
  
 gen t_120 = (tu_120 + t_150)
 label var t_120 "Total number of tax units with incomes above 120'000 SFr."
 
 gen t_100 = (tu_100 + t_120)
 label var t_100 "Total number oftax units with incomes above 100'000 SFr."
  
 gen t_90 = (tu_90 + t_100)
 label var t_90 "Total number of tax units with incomes above 90'000 SFr."

  gen t_80 = (tu_80 + t_90)
 label var t_80 "Total number of tax units with incomes above 80'000 SFr."
 
  gen t_70 = (tu_70 + t_80)
 label var t_70 "Total number of tax units with incomes above 70'000 SFr."
 
 gen t_60 = (tu_60 + t_70)
 label var t_60 "Total number of tax units with incomes above 70'000 SFr."
 
 
 * 3) Generate the average income y_s above each threshold s: 
  
  foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
  gen avg_`s'=y_`s'/t_`s'
  label var avg_`s' "Average income of all tax uints with incomes above `s''000 SFr."
  }
  

 * 4) Calculate the cumulated population shares p_s above each threshold s:
 foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen p_`s'=t_`s'/total_taxunits
label var p_`s' "Share of tax units with income above `s''000 SFr."
}
 
 * 5) Calculate the local paretian distribution parameters b_s, a_s, k_s for each threshold s:
 
 foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
 * 5.1) calculate b
 gen b_`s'= avg_`s'/(`s'*1000)
 label var b_`s' "Local beta parameter for incomes > `s''000 SFr."
 
 ** 5.2) calculate a
 gen a_`s' = b_`s'/(b_`s'-1)
 label var a_`s' "Local alpha parameter for incomes > `s''000 SFr."
 
 *** 5.3) calculate k
 gen k_`s' = `s'*1000*p_`s'^(1/a_`s')
 label var k_`s' "Local k parameter for incomes > `s''000 SFr."
 }
   
 
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *



*    ** top 10% **    *
   
* create the absolute deviation from the 10%-population share for each income bracket _`s'
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen abs90_`s'= abs(p_`s'- 0.1)
}
 
* create an indicator (dummy) indicating the bracket where p_`s' is closest to 10% 
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen bracket90_`s'=min(abs90_60, abs90_70, abs90_80, abs90_90, abs90_100, abs90_120, abs90_150, abs90_200, abs90_300, abs90_400, abs90_500, abs90_1000, abs90_2000)
replace bracket90_`s' = 0 if bracket90_`s' !=abs90_`s'
replace bracket90_`s' = 1 if bracket90_`s'==abs90_`s'
}

*drop the top10% absolute deviation variables
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
drop abs90_`s'
}

*calculate the top10% income threshold ts90:
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen ts90_`s' = (k_`s'/0.1^(1/a_`s'))*bracket90_`s'
replace  ts90_`s' = 0 if ts90_`s'==.
}
gen ts90 =  ts90_60+ ts90_70+ ts90_80+ ts90_90+ ts90_100+ ts90_120+ ts90_150+ ts90_200+ ts90_300+ ts90_400+ ts90_500+ ts90_1000+ ts90_2000
label var ts90 "Income threshold to belong to the top10%"

*calculate the average income above that threshold
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen inc_avg90_`s' = ts90_`s'*b_`s'*bracket90_`s'
replace inc_avg90_`s' = 0 if inc_avg90_`s'==.
}
gen inc_avg90 =inc_avg90_60+ inc_avg90_70+ inc_avg90_80+ inc_avg90_90+ inc_avg90_100+ inc_avg90_120+ inc_avg90_150+ inc_avg90_200+ inc_avg90_300+ inc_avg90_400+ inc_avg90_500+ inc_avg90_1000+ inc_avg90_2000
label var inc_avg90 "Average income of the top10% (i.e. above S90)"

*calculate the total income above that threshold
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen inc_abv90_`s' = ts90_`s'*b_`s'*bracket90_`s'*0.1*total_taxunits
replace inc_abv90_`s'=0 if inc_abv90_`s'==.
}
gen inc_abv90 =inc_abv90_60+ inc_abv90_70+ inc_abv90_80+ inc_abv90_90+ inc_abv90_100+ inc_abv90_120+ inc_abv90_150+ inc_abv90_200+ inc_abv90_300+ inc_abv90_400+ inc_abv90_500+ inc_abv90_1000+ inc_abv90_2000
label var inc_abv90 "Total income of the top10% (i.e. above S90)"

*generate the beta coeffiecients for the top 10%
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen b90_`s' = b_`s'*bracket90_`s'
replace b90_`s'=0 if b90_`s'==.
}
gen b90 =b90_60+ b90_70+ b90_80+ b90_90+ b90_100+ b90_120+ b90_150+ b90_200+ b90_300+ b90_400+ b90_500+ b90_1000+ b90_2000
label var b90 "beta-coefficient of the top10%"

* calculate the top10% income share
gen P90= inc_abv90/inc_total
label var P90 "Top 10% income share on uncorrected total taxincome"

* calculate the top10% income share on imputed tax income
gen P90d= inc_abv90/income_denominator
label var P90d "Top 10% income share on imputed tax income"






   *    ** top 5% **    *
   
* create the absolute deviation from the 5%-population share for each income bracket _`s'
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen abs95_`s'= abs(p_`s'- 0.05)
}
 
* create an indicator (dummy) indicating the bracket where p_`s' is closest to 5% 
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen bracket95_`s'=min(abs95_60, abs95_70, abs95_80, abs95_90, abs95_100, abs95_120, abs95_150, abs95_200, abs95_300, abs95_400, abs95_500, abs95_1000, abs95_2000)
replace bracket95_`s' = 0 if bracket95_`s' !=abs95_`s'
replace bracket95_`s' = 1 if bracket95_`s'==abs95_`s'
}

*drop the top5% absolute deviation variables
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
drop abs95_`s'
}

*calculate the top5% income threshold ts95:
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen ts95_`s' = (k_`s'/0.05^(1/a_`s'))*bracket95_`s'
replace  ts95_`s' = 0 if ts95_`s'==.
}
gen ts95 =  ts95_60+ ts95_70+ ts95_80+ ts95_90+ ts95_100+ ts95_120+ ts95_150+ ts95_200+ ts95_300+ ts95_400+ ts95_500+ ts95_1000+ ts95_2000
label var ts95 "Income threshold to belong to the top5%"

*calculate the average income above that threshold
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen inc_avg95_`s' = ts95_`s'*b_`s'*bracket95_`s'
replace inc_avg95_`s' = 0 if inc_avg95_`s'==.
}
gen inc_avg95 =inc_avg95_60+ inc_avg95_70+ inc_avg95_80+ inc_avg95_90+ inc_avg95_100+ inc_avg95_120+ inc_avg95_150+ inc_avg95_200+ inc_avg95_300+ inc_avg95_400+ inc_avg95_500+ inc_avg95_1000+ inc_avg95_2000
label var inc_avg95 "Average income of the top5% (i.e. above S95)"

*calculate the total income above that threshold
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen inc_abv95_`s' = ts95_`s'*b_`s'*bracket95_`s'*0.05*total_taxunits
replace inc_abv95_`s'=0 if inc_abv95_`s'==.
}
gen inc_abv95 =inc_abv95_60+ inc_abv95_70+ inc_abv95_80+ inc_abv95_90+ inc_abv95_100+ inc_abv95_120+ inc_abv95_150+ inc_abv95_200+ inc_abv95_300+ inc_abv95_400+ inc_abv95_500+ inc_abv95_1000+ inc_abv95_2000
label var inc_abv95 "Total income of the top5% (i.e. above S95)"

*generate the beta coeffiecients for the top 5%
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen b95_`s' = b_`s'*bracket95_`s'
replace b95_`s'=0 if b95_`s'==.
}
gen b95 =b95_60+ b95_70+ b95_80+ b95_90+ b95_100+ b95_120+ b95_150+ b95_200+ b95_300+ b95_400+ b95_500+ b95_1000+ b95_2000
label var b95 "beta-coefficient of the top5%"

* calculate the top5% income share
gen P95= inc_abv95/inc_total
label var P95 "Top 5% income share on uncorrected total taxincome"


* calculate the top5% income share on imputed tax income
gen P95d= inc_abv95/income_denominator
label var P95d "Top 5% income share on imputed tax income"





*    ** top 1% **    *
   
* create the absolute deviation from the 1%-population share for each income bracket _`s'
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen abs99_`s'= abs(p_`s'- 0.01)
}
 
* create an indicator (dummy) indicating the bracket where p_`s' is closest to 1% 
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen bracket99_`s'=min(abs99_60, abs99_70, abs99_80, abs99_90, abs99_100, abs99_120, abs99_150, abs99_200, abs99_300, abs99_400, abs99_500, abs99_1000, abs99_2000)
replace bracket99_`s' = 0 if bracket99_`s' !=abs99_`s'
replace bracket99_`s' = 1 if bracket99_`s'==abs99_`s'
}

*drop the top1% absolute deviation variables
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
drop abs99_`s'
}

*calculate the top1% income threshold ts99:
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen ts99_`s' = (k_`s'/0.01^(1/a_`s'))*bracket99_`s'
replace  ts99_`s' = 0 if ts99_`s'==.
}
gen ts99 =  ts99_60+ ts99_70+ ts99_80+ ts99_90+ ts99_100+ ts99_120+ ts99_150+ ts99_200+ ts99_300+ ts99_400+ ts99_500+ ts99_1000+ ts99_2000
label var ts99 "Income threshold to belong to the top1%"

*calculate the average income above that threshold
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen inc_avg99_`s' = ts99_`s'*b_`s'*bracket99_`s'
replace inc_avg99_`s' = 0 if inc_avg99_`s'==.
}
gen inc_avg99 =inc_avg99_60+ inc_avg99_70+ inc_avg99_80+ inc_avg99_90+ inc_avg99_100+ inc_avg99_120+ inc_avg99_150+ inc_avg99_200+ inc_avg99_300+ inc_avg99_400+ inc_avg99_500+ inc_avg99_1000+ inc_avg99_2000
label var inc_avg99 "Average income of the top1% (i.e. above S99)"

*calculate the total income above that threshold
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen inc_abv99_`s' = ts99_`s'*b_`s'*bracket99_`s'*0.01*total_taxunits
replace inc_abv99_`s'=0 if inc_abv99_`s'==.
}
gen inc_abv99 =inc_abv99_60+ inc_abv99_70+ inc_abv99_80+ inc_abv99_90+ inc_abv99_100+ inc_abv99_120+ inc_abv99_150+ inc_abv99_200+ inc_abv99_300+ inc_abv99_400+ inc_abv99_500+ inc_abv99_1000+ inc_abv99_2000
label var inc_abv99 "Total income of the top1% (i.e. above S99)"

*generate the beta coeffiecients for the top 5%
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen b99_`s' = b_`s'*bracket99_`s'
replace b99_`s'=0 if b99_`s'==.
}
gen b99 =b99_60+ b99_70+ b99_80+ b99_90+ b99_100+ b99_120+ b99_150+ b99_200+ b99_300+ b99_400+ b99_500+ b99_1000+ b99_2000
label var b99 "beta-coefficient of the top1%"

* calculate the top1% income share
gen P99= inc_abv99/inc_total
label var P99 "Top 1% income share on uncorrected total taxincome"

* calculate the top1% income share on imputed tax income
gen P99d= inc_abv99/income_denominator
label var P99d "Top 1% income share on imputed tax income"






   *    ** top 0.5% **    *
   
* create the absolute deviation from the 0.5%-population share for each income bracket _`s'
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen abs995_`s'= abs(p_`s'- 0.005)
}
 
* create an indicator (dummy) indicating the bracket where p_`s' is closest to 0.5% 
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen bracket995_`s'=min(abs995_60, abs995_70, abs995_80, abs995_90, abs995_100, abs995_120, abs995_150, abs995_200, abs995_300, abs995_400, abs995_500, abs995_1000, abs995_2000)
replace bracket995_`s' = 0 if bracket995_`s' !=abs995_`s'
replace bracket995_`s' = 1 if bracket995_`s'==abs995_`s'
}

*drop the top 0.5% absolute deviation variables
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
drop abs995_`s'
}

*calculate the top 0.5% income threshold ts995:
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen ts995_`s' = (k_`s'/0.005^(1/a_`s'))*bracket995_`s'
replace  ts995_`s' = 0 if ts995_`s'==.
}
gen ts995 =  ts995_60+ ts995_70+ ts995_80+ ts995_90+ ts995_100+ ts995_120+ ts995_150+ ts995_200+ ts995_300+ ts995_400+ ts995_500+ ts995_1000+ ts995_2000
label var ts995 "Income threshold to belong to the top0.5%"

*calculate the average income above that threshold
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen inc_avg995_`s' = ts995_`s'*b_`s'*bracket995_`s'
replace inc_avg995_`s' = 0 if inc_avg995_`s'==.
}
gen inc_avg995 =inc_avg995_60+ inc_avg995_70+ inc_avg995_80+ inc_avg995_90+ inc_avg995_100+ inc_avg995_120+ inc_avg995_150+ inc_avg995_200+ inc_avg995_300+ inc_avg995_400+ inc_avg995_500+ inc_avg995_1000+ inc_avg995_2000
label var inc_avg995 "Average income of the top0.5% (i.e. above S995)"

*calculate the total income above that threshold
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen inc_abv995_`s' = ts995_`s'*b_`s'*bracket995_`s'*0.005*total_taxunits
replace inc_abv995_`s'=0 if inc_abv995_`s'==.
}
gen inc_abv995 =inc_abv995_60+ inc_abv995_70+ inc_abv995_80+ inc_abv995_90+ inc_abv995_100+ inc_abv995_120+ inc_abv995_150+ inc_abv995_200+ inc_abv995_300+ inc_abv995_400+ inc_abv995_500+ inc_abv995_1000+ inc_abv995_2000
label var inc_abv995 "Total income of the top0.5% (i.e. above S995)"

*generate the beta coeffiecients for the top 0.5%%
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen b995_`s' = b_`s'*bracket995_`s'
replace b995_`s'=0 if b995_`s'==.
}
gen b995 =b995_60+ b995_70+ b995_80+ b995_90+ b995_100+ b995_120+ b995_150+ b995_200+ b995_300+ b995_400+ b995_500+ b995_1000+ b995_2000
label var b995 "beta-coefficient of the top 0.5%"

* calculate the top 0.5% income share
gen P995= inc_abv995/inc_total
label var P995 "Top 0.5% income share on uncorrected total taxincome"

* calculate the top 0.5% income share on imputed tax income
gen P995d= inc_abv995/income_denominator
label var P995d "Top 0.5% income share on imputed tax income"






   *    ** top 0.1% **    *
   
* create the absolute deviation from the 0.1%-population share for each income bracket _`s'
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen abs999_`s'= abs(p_`s'- 0.001)
}
 
* create an indicator (dummy) indicating the bracket where p_`s' is closest to 0.1% 
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen bracket999_`s'=min(abs999_60, abs999_70, abs999_80, abs999_90, abs999_100, abs999_120, abs999_150, abs999_200, abs999_300, abs999_400, abs999_500, abs999_1000, abs999_2000)
replace bracket999_`s' = 0 if bracket999_`s' !=abs999_`s'
replace bracket999_`s' = 1 if bracket999_`s'==abs999_`s'
}

*drop the top0.1% absolute deviation variables
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
drop abs999_`s'
}

*calculate the top0.1% income threshold ts999:
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen ts999_`s' = (k_`s'/0.001^(1/a_`s'))*bracket999_`s'
replace  ts999_`s' = 0 if ts999_`s'==.
}
gen ts999 =  ts999_60+ ts999_70+ ts999_80+ ts999_90+ ts999_100+ ts999_120+ ts999_150+ ts999_200+ ts999_300+ ts999_400+ ts999_500+ ts999_1000+ ts999_2000
label var ts999 "Income threshold to belong to the top0.1%"

*calculate the average income above that threshold
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen inc_avg999_`s' = ts999_`s'*b_`s'*bracket999_`s'
replace inc_avg999_`s' = 0 if inc_avg999_`s'==.
}
gen inc_avg999 =inc_avg999_60+ inc_avg999_70+ inc_avg999_80+ inc_avg999_90+ inc_avg999_100+ inc_avg999_120+ inc_avg999_150+ inc_avg999_200+ inc_avg999_300+ inc_avg999_400+ inc_avg999_500+ inc_avg999_1000+ inc_avg999_2000
label var inc_avg999 "Average income of the top0.1% (i.e. above S999)"

*calculate the total income above that threshold
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen inc_abv999_`s' = ts999_`s'*b_`s'*bracket999_`s'*0.001*total_taxunits
replace inc_abv999_`s'=0 if inc_abv999_`s'==.
}
gen inc_abv999 =inc_abv999_60+ inc_abv999_70+ inc_abv999_80+ inc_abv999_90+ inc_abv999_100+ inc_abv999_120+ inc_abv999_150+ inc_abv999_200+ inc_abv999_300+ inc_abv999_400+ inc_abv999_500+ inc_abv999_1000+ inc_abv999_2000
label var inc_abv999 "Total income of the top0.1% (i.e. above S999)"

*generate the beta coeffiecients for the top 0.1%
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen b999_`s' = b_`s'*bracket999_`s'
replace b999_`s'=0 if b999_`s'==.
}
gen b999 =b999_60+ b999_70+ b999_80+ b999_90+ b999_100+ b999_120+ b999_150+ b999_200+ b999_300+ b999_400+ b999_500+ b999_1000+ b999_2000
label var b999 "beta-coefficient of the top0.1%"

* calculate the top0.1% income share
gen P999= inc_abv999/inc_total
label var P999 "Top 0.1% income share on uncorrected total taxincome"

* calculate the top0.1% income share on imputed tax income
gen P999d= inc_abv999/income_denominator
label var P999d "Top 0.1% income share on imputed tax income"






   *    ** top 0.01% **    *
   
* create the absolute deviation from the 0.01%-population share for each income bracket _`s'
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen abs9999_`s'= abs(p_`s'- 0.0001)
}
 
* create an indicator (dummy) indicating the bracket where p_`s' is closest to 0.01% 
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen bracket9999_`s'=min(abs9999_60, abs9999_70, abs9999_80, abs9999_90, abs9999_100, abs9999_120, abs9999_150, abs9999_200, abs9999_300, abs9999_400, abs9999_500, abs9999_1000, abs9999_2000)
replace bracket9999_`s' = 0 if bracket9999_`s' !=abs9999_`s'
replace bracket9999_`s' = 1 if bracket9999_`s'==abs9999_`s'
}

*drop the top0.01% absolute deviation variables
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
drop abs9999_`s'
}

*calculate the top0.01% income threshold ts9999:
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen ts9999_`s' = (k_`s'/0.0001^(1/a_`s'))*bracket9999_`s'
replace  ts9999_`s' = 0 if ts9999_`s'==.
}
gen ts9999 =  ts9999_60+ ts9999_70+ ts9999_80+ ts9999_90+ ts9999_100+ ts9999_120+ ts9999_150+ ts9999_200+ ts9999_300+ ts9999_400+ ts9999_500+ ts9999_1000+ ts9999_2000
label var ts9999 "Income threshold to belong to the top0.01%"

*calculate the average income above that threshold
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen inc_avg9999_`s' = ts9999_`s'*b_`s'*bracket9999_`s'
replace inc_avg9999_`s' = 0 if inc_avg9999_`s'==.
}
gen inc_avg9999 =inc_avg9999_60+ inc_avg9999_70+ inc_avg9999_80 + inc_avg9999_90+ inc_avg9999_100+ inc_avg9999_120+ inc_avg9999_150+ inc_avg9999_200+ inc_avg9999_300+ inc_avg9999_400+ inc_avg9999_500+ inc_avg9999_1000+ inc_avg9999_2000
label var inc_avg9999 "Average income of the top0.01% (i.e. above S9999)"

*calculate the total income above that threshold
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen inc_abv9999_`s' = ts9999_`s'*b_`s'*bracket9999_`s'*0.0001*total_taxunits
replace inc_abv9999_`s'=0 if inc_abv9999_`s'==.
}
gen inc_abv9999=inc_abv9999_60+ inc_abv9999_70+ inc_abv9999_80+ inc_abv9999_90+ inc_abv9999_100+ inc_abv9999_120+ inc_abv9999_150+ inc_abv9999_200+ inc_abv9999_300+ inc_abv9999_400+ inc_abv9999_500+ inc_abv9999_1000+ inc_abv9999_2000
label var inc_abv9999 "Total income of the top0.01% (i.e. above S9999)"

*generate the beta coeffiecients for the top 0.01%
foreach s in 60 70 80 90 100 120 150 200 300 400 500 1000 2000 {
gen b9999_`s' = b_`s'*bracket9999_`s'
replace b9999_`s'=0 if b9999_`s'==.
}
gen b9999 =b9999_60+ b9999_70+ b9999_80+ b9999_90+ b9999_100+ b9999_120+ b9999_150+ b9999_200+ b9999_300+ b9999_400+ b9999_500+ b9999_1000+ b9999_2000
label var b9999 "beta-coefficient the top0.01%"

* calculate the top0.01% income share
gen P9999= inc_abv9999/inc_total
label var P9999 "Top 0.01% income share on uncorrected total taxincome"

* calculate the top0.01% income share on imputed tax income
gen P9999d= inc_abv9999/income_denominator
label var P9999d "Top 0.01% income share on imputed tax income"









*** *** *** *** *** *** *** 
* SHARES WITHIN SHARES *

gen top10_within_top1 =inc_abv999/inc_abv99
label var top10_within_top1 "Top 10% within the top 1% income share"

gen top1_within_top1 =inc_abv9999/inc_abv99
label var top1_within_top1 "Top 1% within the top 1% income share"

gen top10_within_top10 =inc_abv99/inc_abv90
label var top10_within_top10 "Top 10% within the top 10% income share"



* top 10-5% shares
gen P10_5d = P90d-P95d 
label var P10_5d "Top 10-5% income share on imputed tax income"

* top 5-1% shares
gen P5_1d = P95d-P99d
label var P5_1d "Top 5-1% income share on imputed tax income"

* top 10-1% shares
gen P10_1d = P90d-P99d
label var P10_1d "Top 10-1% income share on imputed tax income"



* top 10-5% shares
gen P10_5 = P90-P95
label var P10_5 "Top 10-5% income share on uncorrected total taxincome"

* top 5-1% shares
gen P5_1 = P95-P99
label var P5_1 "Top 5-1% income share on uncorrected total taxincome"

* top 10-1% shares
gen P10_1 = P90-P99
label var P10_1 "Top 10-1% income share on uncorrected total taxincome"





**** **** **** **** ****
* ALPHA AND BETA COEFFICIENTS 

gen alpha=1/(1-log(P99/P999)/log(10))
label var alpha "Pareto coefficient alpha"
note alpha: The Pareto-Lorenz a coefficients were computed using the top shares estimates. As a rule they were estimated from the top 0.1% share within the top 1% share: a=1/[1-log(Share1%/Share0.1%)/log(10)].

gen beta=alpha/(alpha-1)
label var beta "Inverted Pareto coefficient beta"
note beta: The inverted Pareto-Lorenz b coefficients were computed from the Pareto-Lorenz coefficients using the formula b=a/(a-1). Alternatively they can be computed by using directly the top income shares series and the formula: b=1/[log(Share1%/Share0.1%)/log(10)].

gen alpha_d=1/(1-log(P99d/P999d)/log(10))
label var alpha_d "Pareto coefficient alpha"
note alpha_d: The Pareto-Lorenz a coefficients were computed using the top shares estimates. As a rule they were estimated from the top 0.1% share within the top 1% share: a=1/[1-log(Share1%/Share0.1%)/log(10)].

gen beta_d=alpha_d/(alpha_d-1)
label var beta_d "Inverted Pareto coefficient beta"
note beta_d: The inverted Pareto-Lorenz b coefficients were computed from the Pareto-Lorenz coefficients using the formula b=a/(a-1). Alternatively they can be computed by using directly the top income shares series and the formula: b=1/[log(Share1%/Share0.1%)/log(10)].




* * * * * * * * * * * * * * * 

keep cant year period tu_total total_taxunits total_adults inc_total income_denominator  ///
ts90 inc_avg90 inc_abv90 P90 P90d b90 ///
ts95 inc_avg95 inc_abv95 P95 P95d b95 ///
ts99 inc_avg99 inc_abv99 P99 P99d b99 ///
ts995 inc_avg995 inc_abv995 P995 P995d b995 ///
ts999 inc_avg999 inc_abv999 P999 P999d b999 ///
ts9999 inc_avg9999 inc_abv9999 P9999 P9999d b9999 ///
P10_5 P10_5d P5_1 P5_1d P10_1 P10_1d top10_within_top1 top1_within_top1 top10_within_top10 ///
alpha beta ///
k_60 k_70 k_80 k_90 k_100 k_120 k_150 k_200 k_300 k_400 k_500 k_1000 k_2000 ///
b_60 b_70 b_80 b_90 b_100 b_120 b_150 b_200 b_300 b_400 b_500 b_1000 b_2000

order cant year P90 P90d P95 P95d P99 P99d P995 P995d P999 P999d P9999 P9999d  P10_5 P10_5d P5_1 P5_1d P10_1 P10_1d  top10_within_top1 top1_within_top1 top10_within_top10

foreach v in tu_total total_taxunits total_adults inc_total income_denominator  ///
ts90 inc_avg90 inc_abv90 P90 P90d b90 ///
ts95 inc_avg95 inc_abv95 P95 P95d b95 ///
ts99 inc_avg99 inc_abv99 P99 P99d b99 ///
ts995 inc_avg995 inc_abv995 P995 P995d b995 ///
ts999 inc_avg999 inc_abv999 P999 P999d b999 ///
ts9999 inc_avg9999 inc_abv9999 P9999 P9999d b9999 ///
P10_5 P10_5d P5_1 P5_1d P10_1 P10_1d top10_within_top1 top1_within_top1 top10_within_top10 ///
alpha beta{
replace `v'=. if `v'==0
}
drop if year==.

* SET PANEL AND TIME VARIABLES
* create a value label for the tax periods and years*
label define years 0 `"1971/72"', modify
label define years 1 `"1973/74"', modify
label define years 2 `"1975/76"', modify
label define years 3 `"1977/78"', modify
label define years 4 `"1979/80"', modify
label define years 5 `"1980/81"', modify
label values year years

sort cant year

xtset cant year, yearly delta(1)


saveold "$thepath/4c_TopIncomeShares_CH_1971-80.dta", version(12) replace
  
