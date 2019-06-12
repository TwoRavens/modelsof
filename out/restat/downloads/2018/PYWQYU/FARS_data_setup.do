

 ** do a loop that merges data from FARS -- by years and then appends
  
 foreach i in   91 92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 12 13   { 
    use "/Path/FARS1991-2000/FSAS`i'/ACCIDENT.DTA"
    keep state county month day year hour minute ST_CASE DAY_WEEK
	replace year = 19`i' if `i' >90 & `i' < 98
     rename ST_CASE st_case
     rename DAY_WEEK day_week
     keep state county month day year hour minute st_case day_week
    sort st_case   year
     save  "/Path/Minimum wage/stata/data/FARS/accident/allages/accident`i'.dta", replace
 
   use "/Path/FARS1991-2000/FSAS`i'/person.dta", clear
    rename ST_CASE st_case
     gen year=19`i' if `i' > 90
     replace year=20`i' if `i' < 90
    rename VEH_NO veh_no
   rename PER_NO per_no
    keep state county year  st_case  age   PER_TYP veh_no per_no
    sort year st_case veh_no per_no
   save "/Path/Minimum wage/stata/data/FARS/person/allages/PERSON`i'.dta", replace
 
}
   
   
   
   foreach i in     91 92 93 94 95 96 97 98 99 00    { 
  use    "/Path/FARS1991-2000/MISAS`i'/miper`i'.dta", clear
   rename ST_CASE st_case, if year > 2001
        rename VEH_NO veh_no
  rename PER_NO per_no
   sort year st_case veh_no per_no
   save "/Path/Minimum wage/stata/data/FARS/miper/allages/miper`i'.dta", replace
   }
 
foreach i in      01 02   { 
  use    "/Path/FARS1991-2000/MISAS`i'/miper.dta", clear
   rename ST_CASE st_case, if year > 2001
 rename VEH_NO veh_no, if year < 2003
  rename PER_NO per_no, if year < 2003
   sort year st_case veh_no per_no
   save "/Path/Minimum wage/stata/data/FARS/miper/allages/miper`i'.dta", replace
   }
   
   foreach i in       03 04 05    { 
  use    "/Path/FARS1991-2000/MISAS`i'/miper.dta", clear
   rename ST_CASE st_case, if year > 2001
  
   sort year st_case veh_no per_no
   save "/Path/Minimum wage/stata/data/FARS/miper/allages/miper`i'.dta", replace
   }
  foreach i in        06 07 08 09 10 11 12 13  { 
  use    "/Path/FARS1991-2000/MISAS`i'/miper.dta", clear
   gen year = 20`i'
   rename ST_CASE st_case 
   rename VEH_NO veh_no
  rename PER_NO per_no
   sort year st_case veh_no per_no
   save "/Path/Minimum wage/stata/data/FARS/miper/allages/miper`i'.dta", replace
   }
  
   foreach i in  91 92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 12 13 { 
  use "/Path/Minimum wage/stata/data/FARS/person/allages/PERSON`i'.dta"
   
   merge 1:1 year st_case veh_no per_no using "/Path/Minimum wage/stata/data/FARS/miper/allages/miper`i'.dta"
   keep if _merge==3
     drop _merge
   
    sort year st_case
 
   merge m:1 year st_case using "/Path/Minimum wage/stata/data/FARS/accident/allages/accident`i'.dta"
    keep if _merge==3
    drop _merge
   save "/Path/Minimum wage/stata/data/FARS/year/allages/merge`i'.dta", replace
 
} 
  
save "/Path/Minimum wage/stata/data/FARS/merged/allages/test/fars91_13allages_temp.dta", replace

  foreach i in  91 92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 12  {
  use "/Path/Minimum wage/stata/data/FARS/merged/allages/test/fars91_13allages_temp.dta", clear
  append  using "/Path/Minimum wage/stata/data/FARS/year/allages/merge`i'.dta"
  save "/Path/Minimum wage/stata/data/FARS/merged/allages/test/fars91_13allages_temp.dta", replace
  }
  
  
  
  
  
  
 forvalues i = 1(1)10 { 
 rename P`i' p`i'
  }

  
 

  save "/Path/Minimum wage/stata/data/FARS/merged/allages/test/fars91_13allages.dta", replace
 
 
 gen age16_20 = 0 
 gen age16_17=0
 gen age18 = 0
 gen age19_20 =0
 gen age26plus = 0 
 replace age16_20 = 1 if age >15 & age< 21
 replace age16_17 =1 if age==16 |age==17
 replace age18 = 1 if age==18
 replace age19_20 =1 if age==19 | age==20
 replace age26plus = 1 if age >25
 
 rename PER_TYP per_typ
 keep if per_typ ==1

 save "/Path/Minimum wage/stata/data/FARS/merged/allages/test/fars91_1316_20_groups_dui.dta", replace
 foreach a in 16_20 16_17 18 19_20 26plus {
 use "/Path/Minimum wage/stata/data/FARS/merged/allages/test/fars91_1316_20_groups_dui.dta", clear
 keep if age`a'==1
 sort  st_case year   per_no
  egen N_drivers = count(st_case), by (st_case state year)
 quietly by st_case year:  gen dup = cond(_N==1,0,_n)
 
tab  dup 
 forvalues i = 1(1)10 {
 gen tpc`i'=0
 replace tpc`i'=1 if p`i' >0
 }
 
 egen sum_tpc  = rowtotal(tpc1-tpc10)
 keep st_case year p1-p10 sum_tpc state  dup   tpc1-tpc10 N_drivers month day year hour minute  day_week age16_17 age18 age19_20 age16_20 age26plus
 sum
 
 
save   "/Path/Minimum wage/stata/data/FARS/merged/allages/test/mergedoneage`a'dui.dta",    replace 
  
  
 
  **first listed driver
   use "/Path/Minimum wage/stata/data/FARS/merged/allages/test/mergedoneage`a'dui.dta",  clear
  
drop if dup >1

  gen dup_1 = 1
  
  forvalues i = 1(1)10 {
 gen tpc_a`i'=tpc`i'
  }
  
  gen sum_tpc_a = sum_tpc
 keep st_case year tpc_a1-tpc_a10  sum_tpc_a state       dup_1 N_drivers  month day year hour minute  day_week age16_17 age18 age19_20 age16_20 age26plus
 sum
  sort st_case year
 save "/Path/Minimum wage/stata/data/FARS/merged/allages/test/merged_dup1age`a'dui.dta", replace 
  
  **second listed driver  
     
use "/Path/Minimum wage/stata/data/FARS/merged/allages/test/mergedoneage`a'dui.dta", clear
    
 keep if dup==2
 gen dup_2 = 1 
 
 forvalues i = 1(1)10 {
 gen tpc_b`i'=tpc`i'
  }
  
  gen sum_tpc_b = sum_tpc
 keep st_case year    dup_2   tpc_b1-tpc_b10   sum_tpc_b age16_17 age18 age19_20 age16_20 age26plus
 sum
 save "/Path/Minimum wage/stata/data/FARS/merged/allages/test/merged_dup2age`a'dui.dta", replace 
 
  **third listed driver
   
use "/Path/Minimum wage/stata/data/FARS/merged/allages/test/mergedoneage`a'dui.dta", clear
  keep if dup==3
 gen dup_3 = 1 
  
 forvalues i = 1(1)10 {
 gen tpc_c`i'=tpc`i'
  }
  
  gen sum_tpc_c = sum_tpc
 keep st_case year    dup_3   tpc_c1-tpc_c10   sum_tpc_c age16_17 age18 age19_20 age16_20 age26plus
 sum 
 save "/Path/Minimum wage/stata/data/FARS/merged/allages/test/merged_dup3age`a'dui.dta", replace 
  
 
 
  **fourth listed driver
   
use "/Path/Minimum wage/stata/data/FARS/merged/allages/test/mergedoneage`a'dui.dta", clear
  keep if dup==4
 gen dup_4 = 1 
  
 forvalues i = 1(1)10 {
 gen tpc_d`i'=tpc`i'
  }
  
  gen sum_tpc_d = sum_tpc
 keep st_case year    dup_4   tpc_d1-tpc_d10   sum_tpc_d age16_17 age18 age19_20 age16_20 age26plus
 sum
 save "/Path/Minimum wage/stata/data/FARS/merged/allages/test/merged_dup4age`a'dui.dta", replace 
  
 
 
 **fifth listed driver
   
use "/Path/Minimum wage/stata/data/FARS/merged/allages/test/mergedoneage`a'dui.dta", clear
  keep if dup==5
 gen dup_5 = 1 
  
 forvalues i = 1(1)10 {
 gen tpc_e`i'=tpc`i'
  }
  
  gen sum_tpc_e = sum_tpc
 keep st_case year   dup_5   tpc_e1-tpc_e10   sum_tpc_e age16_17 age18 age19_20 age16_20 age26plus
 sum
 save "/Path/Minimum wage/stata/data/FARS/merged/allages/test/merged_dup5age`a'dui.dta", replace 
  
 
 **sixth listed driver
   
use "/Path/Minimum wage/stata/data/FARS/merged/allages/test/mergedoneage`a'dui.dta", clear
  keep if dup==6
 gen dup_6 = 1 
  
 forvalues i = 1(1)10 { 

 gen tpc_f`i'=tpc`i'
  }
  
  gen sum_tpc_f = sum_tpc
 keep st_case year    dup_6   tpc_f1-tpc_f10   sum_tpc_f age16_17 age18 age19_20 age16_20 age26plus
 sum
 save "/Path/Minimum wage/stata/data/FARS/merged/allages/test/merged_dup6age`a'dui.dta", replace 
  
 **merging mulitple drivers in one accident to one row
 
 use    "/Path/Minimum wage/stata/data/FARS/merged/allages/test/merged_dup1age`a'dui.dta", clear
 merge 1:1 st_case year using    "/Path/Minimum wage/stata/data/FARS/merged/allages/test/merged_dup2age`a'dui.dta" 
   drop _merge
 sum
 merge 1:1 st_case year using    "/Path/Minimum wage/stata/data/FARS/merged/allages/test/merged_dup3age`a'dui.dta" 
  
 drop _merge
 sum   
 
 merge 1:1 st_case year using    "/Path/Minimum wage/stata/data/FARS/merged/allages/test/merged_dup4age`a'dui.dta" 
  
 drop _merge
 sum  
 merge 1:1 st_case year using    "/Path/Minimum wage/stata/data/FARS/merged/allages/test/merged_dup5age`a'dui.dta" 
  
 drop _merge
 sum  
 merge 1:1 st_case year using    "/Path/Minimum wage/stata/data/FARS/merged/allages/test/merged_dup6age`a'dui.dta" 
  
 drop _merge
 sum  
  save "/Path/Minimum wage/stata/data/FARS/merged/allages/test/merged_dup_123age`a'dui.dta", replace
}
 

 set more off, perm
capture log close
clear
 
log using "/Path/Minimum wage/stata/logs/means_agegroups_8_8_2017.log ", replace

foreach a in 16_20 16_17 18 19_20 26plus {

use  "/Path/Minimum wage/stata/data/FARS/merged/allages/test/merged_dup_123age`a'dui.dta", clear
 **these defininitions are from appendic C of the FARS analystical user's manual.  Page 486
 **783 observations do not have date and time information (0.52% of 16-20 sample)

  
 forvalues i = 1(1)10 {
 egen tpc_3mean`i' = rowmean(tpc_a`i' tpc_b`i' tpc_c`i') if N_drivers==3
 }
  forvalues i = 1(1)10 {
  egen tpc_2mean`i' = rowmean(tpc_a`i' tpc_b`i'  ) if N_drivers==2
   }
  forvalues i = 1(1)10 { 
  gen tpc_mean_all`i'  =  tpc_a`i'     if N_drivers==1
 replace tpc_mean_all`i'=tpc_2mean`i' if N_drivers==2
  replace tpc_mean_all`i'=tpc_3mean`i' if N_drivers==3
 }
 
 

 
 
  save "/Path/Minimum wage/stata/data/FARS/merged/allages/test/fars_merged_age`a'.dta", replace
  
 use  "/Path/Minimum wage/stata/data/FARS/merged/allages/test/fars_merged_age`a'.dta", clear
 
 collapse (sum) tpc_a1-tpc_a10 tpc_mean_all1-tpc_mean_all10          , by (state year )
 
 egen sum_tpc_driv_a = rowtotal(tpc_a1-tpc_a10)
egen sum_tpc_mean = rowtotal(tpc_mean_all1-tpc_mean_all10)

 gen dr_a_DUI_age_`a'= sum_tpc_driv_a/10
gen mean_DUI_age_`a' = sum_tpc_mean/10
 
 

sort year
 gen age`a' = 0
 replace age`a' = 1
sum dr_a_DUI_age_`a'  mean_DUI_age_`a'  

 
  replace  dr_a_DUI_age_`a'= 0 if dr_a_DUI_age_`a'==.
 replace mean_DUI_age_`a' =0 if mean_DUI_age_`a'==.
 
 
 
 
 label var  state "state fips codes"
    
   
   label var mean_DUI_age_`a' "DUI accidents - mean of drivers"
  
   
 
 
 keep     mean_DUI_age_`a'      year state age`a'    
 sort state year
 
  save "/Path/Minimum wage/stata/data/FARS/merged/allages/test/fars_state_means_age`a'.dta", replace
  }
  
 
 


  ** do a loop that merges data sets by years and then append
   
  foreach i in   91 92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 12 13   {
    
   use "/Path/Minimum wage/stata/data/FARS/person/allages/PERSON`i'.dta"
     
   
    
     sort year st_case
   
    merge m:1 year st_case using "/Path/Minimum wage/stata/data/FARS/accident/allages/accident`i'.dta"
      keep if _merge==3
     drop _merge
    save "/Path/Minimum wage/stata/data/FARS/year/allages/merge`i'_count.dta", replace
   
  }
   
 save "/Path/Minimum wage/stata/data/FARS/merged/allages/test/fars91_13allages_temp_count.dta", replace
 
 
   foreach i in  91 92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 12  { 
    use "/Path/Minimum wage/stata/data/FARS/merged/allages/test/fars91_13allages_temp_count.dta", clear
    append  using "/Path/Minimum wage/stata/data/FARS/year/allages/merge`i'_count.dta"
    save "/Path/Minimum wage/stata/data/FARS/merged/allages/test/fars91_13allages_temp_count.dta", replace
    }
 
   save "/Path/Minimum wage/stata/data/FARS/merged/allages/test/fars91_13allages_count.dta", replace
 
  
 
 
 gen age16_17=0
 gen age18 = 0
 gen age19_20 =0
 gen age26plus = 0
 gen age16_20 =0
 replace age16_17 =1 if age==16 |age==17
 replace age18 = 1 if age==18
 replace age19_20 =1 if age==19 | age==20
 replace age16_20 =1 if age>15  & age< 21
 replace age26plus = 1 if age>25
  
 
 rename PER_TYP per_typ
 keep if per_typ ==1
  
 gen accident = 1
gen nighttime =0
 replace nighttime = 1 if hour >17 
 replace nighttime = 1 if hour < 6
 
 gen daytime =0
 replace daytime = 1 if hour < 18 & hour >5
   
   
 gen weekday = 0
 replace weekday = 1 if day_week ==2 & hour >5 & hour <=23
 replace weekday = 1 if day_week >2 & day_week < 6
 replace weekday = 1 if day_week ==6 & hour >=0 & hour <=17
 replace weekday = 1 if day_week ==6 & hour ==24
 
 gen weekend = 0
 replace weekend = 1 if day_week ==6 & hour >17 & hour < 24
 replace weekend = 1 if day_week == 1 | day_week==7
 replace weekend = 1 if day_week ==2 & hour >=0 & hour <6
  replace weekend = 1 if day_week ==2 & hour ==24
  
  replace nighttime = . if day_week==9
  replace nighttime = . if hour==99
  
  replace daytime = . if day_week==9
 replace daytime = . if hour==99
 
  replace weekday = . if day_week==9
   replace weekday = . if hour==99
  
  replace weekend = . if day_week==9
   replace weekend = . if hour==99
  
 keep st_case state year nighttime daytime weekday weekend age16_17 age18 age19_20 age26plus age16_20 accident
 save "/Path/Minimum wage/stata/data/FARS/merged/allages/test/fars91_13allages_counts_16_20.dta", replace

foreach a in 16_17 18 19_20 16_20 26plus {
use  "/Path/Minimum wage/stata/data/FARS/merged/allages/test/fars91_13allages_counts_16_20.dta", clear
keep if age`a'==1
sort st_case state year

quietly by st_case state year :  gen dup = cond(_N==1,0,_n)
drop if dup>1
collapse (sum) weekend_`a' = weekend weekday_`a' =  weekday nighttime_`a' =  nighttime daytime_`a' = daytime accident_`a'= accident, by (state year)

save "/Path/Minimum wage/stata/data/FARS/merged/allages/test/acc_countsage`a'.dta", replace
sort state year
}

use "/Path/Minimum wage/stata/data/FARS/merged/allages/test/acc_countsage16_17.dta", clear
merge 1:1  state year using "/Path/Minimum wage/stata/data/FARS/merged/allages/test/acc_countsage18.dta"
drop _merge
merge 1:1  state year using "/Path/Minimum wage/stata/data/FARS/merged/allages/test/acc_countsage19_20.dta"
drop _merge
merge 1:1 state year using "/Path/Minimum wage/stata/data/FARS/merged/allages/test/acc_countsage26plus.dta"
drop _merge
merge 1:1 state year using "/Path/Minimum wage/stata/data/FARS/merged/allages/test/acc_countsage16_20.dta"
drop _merge


foreach a in 16_17 18 19_20 16_20 26plus {
replace weekend_`a' = 0 if missing(weekend_`a')
replace weekday_`a' = 0 if missing(weekday_`a')
replace nighttime_`a' = 0 if missing(nighttime_`a')
replace daytime_`a' = 0 if missing(daytime_`a')
replace accident_`a' = 0 if missing(accident_`a')
}
save "/Path/Minimum wage/stata/data/FARS/merged/allages/test/acc_countsbygroup.dta", replace
 
 
 


use "/Path/Minimum wage/stata/data/FARS/merged/allages/test/fars_state_means_age16_20.dta", clear
save    "/Path/Minimum wage/stata/data/FARS/merged/allages/test/fars_state_means_agetemp.dta", replace
 foreach a in  16_17 18 19_20 26plus {
use   "/Path/Minimum wage/stata/data/FARS/merged/allages/test/fars_state_means_agetemp.dta", clear
merge 1:1 year state using  "/Path/Minimum wage/stata/data/FARS/merged/allages/test/fars_state_means_age`a'.dta" 
drop _merge


 
save     "/Path/Minimum wage/stata/data/FARS/merged/allages/test/fars_state_means_agetemp.dta", replace
  }
merge 1:1 state year using  "/Path/Minimum wage/stata/data/FARS/merged/allages/test/acc_countsbygroup.dta"
foreach a in 16_20 16_17 18 19_20 26plus {
 
  gen mean_nonDUI_age_`a' = accident_`a' - mean_DUI_age_`a'
   

   label var mean_nonDUI_age_`a' "Non DUI accidents - mean of drivers"
 
    
   drop age`a'
   }
   
 replace mean_DUI_age_16_20 = 0 if mean_DUI_age_16_20==. 
  replace mean_DUI_age_16_17  = 0 if mean_DUI_age_16_17 ==. 
   replace mean_DUI_age_18 = 0 if mean_DUI_age_18==. 
    replace mean_DUI_age_19_20 = 0 if mean_DUI_age_19_20==. 

     
   
   replace mean_nonDUI_age_16_17 = 0 if mean_nonDUI_age_16_17==. 
   replace  mean_nonDUI_age_16_20 = 0 if  mean_nonDUI_age_16_20==. 
   replace mean_nonDUI_age_18 = 0 if mean_nonDUI_age_18==. 
   replace mean_nonDUI_age_26plus = 0 if mean_nonDUI_age_26plus==. 
   replace  mean_nonDUI_age_19_20 = 0 if  mean_nonDUI_age_19_20==. 
   
        
   gen tot_acc_all = accident_16_20
   gen tot_acc_nt = nighttime_16_20
   gen tot_acc_dt = daytime_16_20
   gen tot_acc_we=weekend_16_20
   gen tot_acc_wd = weekday_16_20
   gen DUI_1620 = mean_DUI_age_16_20
   gen nonDUI_1620 = mean_nonDUI_age_16_20 
   
   
 
  save "/Path/Minimum Wage/stata/data/FARS/final/fars_DUI_counts_agegroups_8_8_2017.dta", replace
log close

