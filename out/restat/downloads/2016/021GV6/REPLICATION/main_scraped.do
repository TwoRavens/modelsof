***************************************************
*Main script for Paper Titled "Scraped Data and Sticky Prices"
*Author: Alberto Cavallo
*Last modified: 7/2016
**************************************************

clear
set more off
pause on 

**************************************************
*Setup - UPDATE THE FIRST LINE BELOW TO MATCH THE LOCATION OF YOUR FOLDER
global dir_main "X:\Dropbox (Personal)\PAPERS\Scraped Data and Sticky\REPLICATION"
cd "${dir_main}"

*Install custom commands
capture ssc install unique 
capture ssc install egenmore
capture ssc install mvfiles
set scheme s2monowhite

*Create Directories
capture mkdir RESULTS
capture mkdir GRAPHS
capture mkdir TABLES
capture mkdir TEMP

global dir_rawdata "RAWDATA"
global dir_code "CODE"
global dir_data "DATA"
global dir_results "RESULTS"
global dir_graphs "GRAPHS"
global dir_tables "TABLES"
global dir_temp "TEMP"
**************************************************

*log file
qui log using "${dir_temp}\main_scraped.txt", replace text


*Select databases to run analysis on
global listcountries "usa_all argentina brazil chile colombia usa1 usa2 usa3 usa5"
global type full

*****************

*Original Online Data
foreach database in $listcountries {
foreach sales in full nsfull {
global database `database'
global sales `sales'
	do "${dir_code}\SC_stats.do", nostop
	do "${dir_code}\SC_distributions.do" , nostop
	do "${dir_code}\SC_survival.do", nostop

}
}

***************
*Measurement error

*Create simulated data
foreach database in $listcountries {
foreach sales in full nsfull {
global database `database'
global sales `sales'
	do "${dir_code}\SC_simulate-weeklyaverage.do"
	do "${dir_code}\SC_simulate-cpi-bppcat.do"
	do "${dir_code}\SC_simulate-cpi-url.do"
	do "${dir_code}\SC_simulate-cpi-month.do"
	do "${dir_code}\SC_simulate-weekly.do"
}
}


*Stats with simulated data
foreach country in $listcountries {
foreach sales in full nsfull {
foreach simulation in weekly  weekly_average cpi_bppcat cpi_month  cpi_url  {
global sales `sales'
global country `country'
global simulation `simulation'
global database ${simulation}_${sales}_${country}
display "Starting $database"

*run do file	
	do "${dir_code}\SC_stats_simul.do", nostop
    do "${dir_code}\SC_distributions_simul.do" , nostop
	do "${dir_code}\SC_survival-simulated_dailyequivalent.do", nostop

}
}
}


**************
*Hazard graphs and NS (08) comparison
foreach sector in 100 {
global sector `sector'
foreach sales in full  {
foreach simulation in cpi_url {
global sales `sales'
global country usa_all
global simulation `simulation'
global database ${simulation}_${sales}_${country}
display "Starting $database"

*run do file	
	do "${dir_code}\SC_survival-simulated_dailyequivalent_sector.do", nostop

}
}
}

do "${dir_code}\SC-hazard_nscomp.do"
*output is survival_hazard_usa_all_100_cpi_url_NS.png for the paper
**************


***********************************************************************
**ROBUSTNESS

***************************************
**CALVO SIMULATION
*****************
*argentina brazil chile colombia usa
*Create stats database from micro data
foreach database in calvo {
foreach sales in full {
global database `database'
global sales `sales'
	do "${dir_code}\SC_stats_calvo.do", nostop
	do "${dir_code}\SC_simulate-weekly_calvo.do" , nostop
	do "${dir_code}\SC_simulate-weeklyaverage_calvo.do" , nostop
	do "${dir_code}\SC_simulate-cpi-url_calvo.do" , nostop
	do "${dir_code}\SC_simulate-cpi-month_calvo.do" , nostop
}
}

*Stats with simulated data
foreach country in calvo {
foreach sales in full {
foreach simulation in cpi_month weekly  {
* weekly_average cpi_url  weekly  weekly_average cpi_bppcat cpi_month 
global sales `sales'
global country `country'
global simulation `simulation'
global database ${simulation}_${sales}_${country}
display "Starting $database"

*run do file	
	do "${dir_code}\SC_stats_simul_calvo.do", nostop

}
}
}


*****PER CATEGORY Stats
*Create category rawdata
do "${dir_code}\SC_pscode3.do", nostop


********************************************************
**RESULTS PER l1 CATEGORY 
use ${dir_rawdata}\\usa_all.dta, clear

ren category pscode3
gen pscode=int(pscode3/100)
destring pscode, replace force
replace pscode= pscode * 100

levelsof pscode, clean
global listpscode `r(levels)'



*****************
*argentina brazil chile colombia usa
*Create stats database from micro data
foreach database in $listpscode {
foreach sales in full nsfull {
global database usa_all_sec`database'
global sales `sales'
	do "${dir_code}\SC_stats.do", nostop
	do "${dir_code}\SC_distributions.do" , nostop
}
}


***************
*Measurement error 

*Create simulated data
foreach database in $listpscode {
foreach sales in full nsfull {
global database usa_all_sec`database'
global sales `sales'
	do "${dir_code}\SC_simulate-weeklyaverage.do"
	do "${dir_code}\SC_simulate-cpi-bppcat.do"
	do "${dir_code}\SC_simulate-cpi-url.do"
	do "${dir_code}\SC_simulate-cpi-month.do"
	do "${dir_code}\SC_simulate-weekly.do"
}
}

*Stats with simulated data
foreach country in $listpscode {
foreach sales in full nsfull {
foreach simulation in weekly  weekly_average cpi_bppcat cpi_month  cpi_url  {
*weekly  weekly_average cpi_bppcat cpi_month 
global sales `sales'
global country usa_all_sec`country'
global simulation `simulation'
global database ${simulation}_${sales}_${country}
display "Starting $database"

*run do file	
	do "${dir_code}\SC_stats_simul.do", nostop
    do "${dir_code}\SC_distributions_simul.do" , nostop

}
}
}
************************************************************************************************************






************************************************************************************************************
**RESULTS PER l3 CATEGORY FOR THE APPENDIX
use ${dir_rawdata}\\usa_all.dta, clear
levelsof category, clean
global listcat `r(levels)'

*****************
*argentina brazil chile colombia usa
*Create stats database from micro data
foreach database in $listcat {
foreach sales in full nsfull {
global database usa_all_cat`database'
global sales `sales'
	do "${dir_code}\SC_stats.do", nostop
	do "${dir_code}\SC_distributions.do" , nostop
	*do "stats_sales.do", nostop
}
}


***************
*Measurement error 

*Create simulated data
foreach database in $listcat {
foreach sales in full nsfull {
global database usa_all_cat`database'
global sales `sales'
	do "${dir_code}\SC_simulate-weeklyaverage.do"
	do "${dir_code}\SC_simulate-cpi-bppcat.do"
	do "${dir_code}\SC_simulate-cpi-url.do"
	do "${dir_code}\SC_simulate-cpi-month.do"
	do "${dir_code}\SC_simulate-weekly.do"
}
}

*Stats with simulated data
foreach country in $listcat {
foreach sales in full nsfull {
foreach simulation in weekly  weekly_average cpi_bppcat cpi_month  cpi_url  {
*weekly  weekly_average cpi_bppcat cpi_month 
global sales `sales'
global country usa_all_cat`country'
global simulation `simulation'
global database ${simulation}_${sales}_${country}
display "Starting $database"

*run do file	
	do "${dir_code}\SC_stats_simul.do", nostop
    do "${dir_code}\SC_distributions_simul.do" , nostop

}
}
}
************************************************************************************************************


*************Weekly robustness --pick a different date for the "week" price
*Create simulated data
foreach database in $listcountries {
foreach sales in full nsfull {
global database `database'
global sales `sales'
foreach dow in 0 1 2 3 4 5 6 {
global dow `dow'
	do "${dir_code}\SC_simulate-weekly-pick.do"
}
}
}

*Stats with simulated data
foreach country in $listcountries {
foreach sales in full nsfull {
foreach simulation in weekly_0 weekly_1 weekly_2 weekly_3 weekly_4 weekly_5 weekly_6 {
global sales `sales'
global country `country'
global simulation `simulation'
global database ${simulation}_${sales}_${country}
display "Starting $database"

*run do file	
	do "${dir_code}\SC_stats_simul.do", nostop
    do "${dir_code}\SC_distributions_simul.do" , nostop

}
}
}


******
*monthly robustness --pick a different date for the "month" price
*Create simulated data
foreach database in $listcountries {
foreach sales in full nsfull {
global database `database'
global sales `sales'
foreach dom in 1 30 {
global dom `dom'
	do "${dir_code}\SC_simulate-cpi-month-pick.do"
}
}
}

*Stats with simulated data
foreach country in $listcountries {
foreach sales in full nsfull {
foreach simulation in cpi_month_1 cpi_month_30 {
global sales `sales'
global country `country'
global simulation `simulation'
global database ${simulation}_${sales}_${country}
display "Starting $database"

*run do file	
	do "${dir_code}\SC_stats_simul.do", nostop
    do "${dir_code}\SC_distributions_simul.do" , nostop

}
}
}



*******************************************************************************
**with no carry forward substitutions

foreach database in usa_all argentina brazil chile colombia {
global database `database'
use ${dir_rawdata}\\${database}.dta, clear
replace fullprice=. if miss==1
replace nsfullprice=. if miss==1
save ${dir_rawdata}\\${database}_nm.dta, replace

}

*Create stats database from micro data
foreach database in usa_all_nm argentina_nm brazil_nm chile_nm colombia_nm {
foreach sales in full nsfull {
global database `database'
global sales `sales'
	do "${dir_code}\SC_stats.do", nostop
	*do "${dir_code}\SC_distributions.do" , nostop
	*do "stats_sales.do", nostop
}
}


*Create simulated data
foreach database in usa_all_nm argentina_nm brazil_nm chile_nm colombia_nm  {
foreach sales in full nsfull {
global database `database'
global sales `sales'
	do "${dir_code}\SC_simulate-weeklyaverage.do"
	do "${dir_code}\SC_simulate-cpi-month.do"
	do "${dir_code}\SC_simulate-weekly.do"
	do "${dir_code}\SC_simulate-cpi-bppcat.do"
	do "${dir_code}\SC_simulate-cpi-url.do"
}
}

*Stats with simulated data
foreach country in usa_all_nm argentina_nm brazil_nm chile_nm colombia_nm  {
foreach sales in full nsfull {
foreach simulation in cpi_month  weekly  weekly_average  cpi_bppcat  cpi_url  {
*weekly  weekly_average cpi_bppcat cpi_month 
global sales `sales'
global country `country'
global simulation `simulation'
global database ${simulation}_${sales}_${country}
display "Starting $database"

*run do file	
	do "${dir_code}\SC_stats_simul.do", nostop
    *do "${dir_code}\SC_distributions_simul.do" , nostop

}
}
}
***********


************************************************
**What can be done to "correct" scanner data? Simulations described in the Appendix. 

* do "${dir_code}\SC_stats_scanner_corrected.do", nostop

	
* *Create simulated data
* foreach database in usa1 {
* foreach sales in full {
* global database `database'
* global sales `sales'
	* do "${dir_code}\SC_simulate-weeklyaverage_correction.do"
	* *do "${dir_code}\SC_simulate-weeklyaverage_correction2.do"

* }
* }

* *Stats with simulated data
* foreach country in usa1 {
* foreach sales in full {
* foreach simulation in weekly_average_correction  {
* global sales `sales'
* global country `country'
* global simulation `simulation'
* global database ${simulation}_${sales}_${country}
* display "Starting $database"

* *run do file	
	* do "${dir_code}\SC_stats_simul.do", nostop
    * do "${dir_code}\SC_distributions_simul.do" , nostop

* }
* }
* }


***************Cummulative Distribution Functions in the Appendix

*Create simulated data
foreach database in usa_all weekly_average_full_usa_all cpi_bppcat_full_usa_all cpi_url_full_usa_all {

global sales full
global database `database'

do "${dir_code}\SC_cdf.do"

}


*U.S. Sector hazards
foreach sector in 100 {
 global sector `sector'
foreach sales in full  {
global sales `sales'
global database usa_all
display "Starting $database"

*run do file	
	do "${dir_code}\SC_survival_sector.do", nostop

}
}



****************Scanner data --Cannot be replicated because the Nielsen data is propietary. I only include the scripts for reference. 

* *Analysis with scanner data
* foreach sales in full nsfull {
* global sales `sales'
* global database usa_scanner
* global simulation scanner
* display "Starting $database"

* *run do file	
	* do "${dir_code}\SC_stats_scanner.do", nostop
	* do "${dir_code}\SC_distributions_simul_scanner.do", nostop
	* do "${dir_code}\SC_survival_scanner.do", nostop
* }
****************


************************************
***TABLES AND FIGURES FOR THE PAPER (those not generated before)


************************************
***TABLES FOR THE PAPER
foreach sales in full nsfull {
global sales `sales'
do "${dir_code}\SC_table2.do"  , nostop
do "${dir_code}\SC_table_me.do"  , nostop
do "${dir_code}\SC_table_me_sector.do"  , nostop
}


* *****************
* * Combine kernels and make graphs
foreach database in $listcountries {
 foreach sales in full nsfull {
 global database `database'
 global sales `sales'
 *Compare Results
 do "${dir_code}\SC_literature_analysis.do", nostop
 }
 }

**Table 9 NS results
do "${dir_code}\SC_NS08.do"  , nostop

log off
log close


