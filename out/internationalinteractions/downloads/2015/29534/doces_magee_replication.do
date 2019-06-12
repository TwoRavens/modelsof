
* change the directory below to match the folder where the data set is saved

cd c:\docume~1\cmagee\mydocu~1\tradea~1\replic~1\


set more off
clear
use doces_magee_data, clear

xtset my_code year

log using tables.log, replace

* Figure 1
collapse (median) kl8, by(year)
list
use doces_magee_data, clear


* Regression results from Figures 2 and 3
reg polity2 open3 if above_median_kl8==0
reg polity2 open3 if above_median_kl8==1


* Regression results for Tables 2 and 3

reg polity2 open3 female_percent_pop pop_15_64 pop_15_under ethnic_num2 religion_num2 lang_num2 region_polity_10 colony_1945 yrs_indep America Europe Africa Pacific time, robust cluster(my_code) 

reg polity2 open3 female_percent_pop pop_15_64 pop_15_under ethnic_num2 religion_num2 lang_num2 region_polity_10 colony_1945 yrs_indep America Europe Africa Pacific time if above_median_kl8==0, robust cluster(my_code) 

reg polity2 open3 female_percent_pop pop_15_64 pop_15_under ethnic_num2 religion_num2 lang_num2 region_polity_10 colony_1945 yrs_indep America Europe Africa Pacific time if above_median_kl8==1, robust cluster(my_code) 

ivreg2 polity2 female_percent_pop pop_15_64 pop_15_under ethnic_num2 religion_num2 lang_num2 region_polity_10 colony_1945 yrs_indep America Europe Africa Pacific time (open3 = open_hat1 region_open_10), first bw(2)
ivendog 

ivreg2 polity2 female_percent_pop pop_15_64 pop_15_under ethnic_num2 religion_num2 lang_num2 region_polity_10 colony_1945 yrs_indep America Europe Africa Pacific time (open3 = open_hat1 region_open_10) if above_median_kl8==0, first bw(2)
ivendog 

ivreg2 polity2 female_percent_pop pop_15_64 pop_15_under ethnic_num2 religion_num2 lang_num2 region_polity_10 colony_1945 yrs_indep America Europe Africa Pacific time (open3 = open_hat1 region_open_10) if above_median_kl8==1, first bw(2)
ivendog 


* Table 4 Robustness checks, adding in ln_gdppc, ln_pop, urban, oil 

reg polity2 open3 ln_gdppc8 ln_pop8 urban oil female_percent_pop pop_15_64 pop_15_under ethnic_num2 religion_num2 lang_num2 region_polity_10 colony_1945 yrs_indep America Europe Africa Pacific time, robust cluster(my_code) 

reg polity2 open3 ln_gdppc8 ln_pop8 urban oil female_percent_pop pop_15_64 pop_15_under ethnic_num2 religion_num2 lang_num2 region_polity_10 colony_1945 yrs_indep America Europe Africa Pacific time if above_median_kl8==0, robust cluster(my_code) 

reg polity2 open3 ln_gdppc8 ln_pop8 urban oil female_percent_pop pop_15_64 pop_15_under ethnic_num2 religion_num2 lang_num2 region_polity_10 colony_1945 yrs_indep America Europe Africa Pacific time if above_median_kl8==1, robust cluster(my_code) 

ivreg2 polity2 ln_gdppc8 ln_pop8 urban oil female_percent_pop pop_15_64 pop_15_under ethnic_num2 religion_num2 lang_num2 region_polity_10 colony_1945 yrs_indep America Europe Africa Pacific time (open3 = open_hat1 region_open_10), first bw(2)
ivendog 

ivreg2 polity2 ln_gdppc8 ln_pop8 urban oil female_percent_pop pop_15_64 pop_15_under ethnic_num2 religion_num2 lang_num2 region_polity_10 colony_1945 yrs_indep America Europe Africa Pacific time (open3 = open_hat1 region_open_10) if above_median_kl8==0, first bw(2)
ivendog 

ivreg2 polity2 ln_gdppc8 ln_pop8 urban oil female_percent_pop pop_15_64 pop_15_under ethnic_num2 religion_num2 lang_num2 region_polity_10 colony_1945 yrs_indep America Europe Africa Pacific time (open3 = open_hat1 region_open_10) if above_median_kl8==1, first bw(2)
ivendog 


* Further robustness checks, showing that neither instrument affects polity if added into the OLS regression in the full sample

reg polity2 open3 female_percent_pop pop_15_64 pop_15_under ethnic_num2 religion_num2 lang_num2 region_polity_10 colony_1945 yrs_indep America Europe Africa Pacific time open_hat1 region_open_10, robust cluster(my_code) 


* Further robustness checks, using region_open_20, region_polity_20

ivreg2 polity2 female_percent_pop pop_15_64 pop_15_under ethnic_num2 religion_num2 lang_num2 region_polity_20 colony_1945 yrs_indep America Europe Africa Pacific time (open3 = open_hat1 region_open_20), first bw(2)
ivendog 

ivreg2 polity2 female_percent_pop pop_15_64 pop_15_under ethnic_num2 religion_num2 lang_num2 region_polity_20 colony_1945 yrs_indep America Europe Africa Pacific time (open3 = open_hat1 region_open_20) if above_median_kl8==0, first bw(2)
ivendog 

ivreg2 polity2 female_percent_pop pop_15_64 pop_15_under ethnic_num2 religion_num2 lang_num2 region_polity_20 colony_1945 yrs_indep America Europe Africa Pacific time (open3 = open_hat1 region_open_20) if above_median_kl8==1, first bw(2)
ivendog 



* Further robustness checks, dividing sample by avg K/L in year

reg polity2 open3 female_percent_pop pop_15_64 pop_15_under ethnic_num2 religion_num2 lang_num2 region_polity_10 colony_1945 yrs_indep America Europe Africa Pacific time if above_avg_kl8==0, robust cluster(my_code) 

reg polity2 open3 female_percent_pop pop_15_64 pop_15_under ethnic_num2 religion_num2 lang_num2 region_polity_10 colony_1945 yrs_indep America Europe Africa Pacific time if above_avg_kl8==1, robust cluster(my_code) 

ivreg2 polity2 female_percent_pop pop_15_64 pop_15_under ethnic_num2 religion_num2 lang_num2 region_polity_10 colony_1945 yrs_indep America Europe Africa Pacific time (open3 = open_hat1 region_open_10) if above_avg_kl8==0, first bw(2)
ivendog 

ivreg2 polity2 female_percent_pop pop_15_64 pop_15_under ethnic_num2 religion_num2 lang_num2 region_polity_10 colony_1945 yrs_indep America Europe Africa Pacific time (open3 = open_hat1 region_open_10) if above_avg_kl8==1, first bw(2)
ivendog 


log close


