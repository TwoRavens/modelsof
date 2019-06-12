***This is the code to generate Table A3 of the Paper
clear all
set mem 200m
set more off
***Set location to where the data has been saved on computer. 
cd F:\RESTAT\DATA
use compustat.dta, clear
***Get stcode for headquarter state
merge m:1 state using state_stcode.dta
keep if _m==3
drop _m

***trimming roa at both the left and right tail
winsor2 roa, replace cuts(1 99) trim

***generate industy/year and state/year effect
sort year sic3
by year sic3: egen ind_year=sum(roa)
by year sic3: replace ind_year=(ind_year-roa)/(_N-1)
replace ind_year=0 if ind_year==.
sort year state
by year state: egen state_year=sum(roa)
by year state: replace state_year=(state_year-roa)/(_N-1)
replace state_year=0 if state_year==.


***Merge with disaster data
***One year lag to the fiscal year. i.e. disaster in year t-1 merged with fiscal year t accounting information 
replace year=fyear-1
destring gvkey,replace
***Merge with hit_ratio data
merge 1:1 gvkey year using planthit_bygvkeyyear.dta
keep if _m==3
drop _m

***Merge to get patent data
gen calyear=fyear
merge 1:1 gvkey calyear using pat.dta
drop if _m==2
drop _m
replace sum5yr=log(sum5yr/at1+1)
***replace patent data to zero if missing. patent data available only till 2010
replace sum5yr=0 if sum5yr==. & fyear<2011

***transport R&D, advertisement, and SG&A data
replace rdc=log(rdc+1)
replace rdc=0 if rdc==.
replace ad=log(ad+1)
replace ad=0 if ad==.
replace sga=log(sga+1)
replace sga=0 if sga==.

***Get year t-1 concentration of supplier
merge 1:1 gvkey year using sup_hhi.dta
drop if _m==2
drop _m
***missing supplier's concentration is replaced by zero
replace s_hhi=0 if s_hhi==.
rename s_hhi s_hhi1
***Get year t concentration of supplier
replace year=fyear
merge 1:1 gvkey year using sup_hhi.dta
drop if _m==2
drop _m
***missing supplier's concentration is replaced by zero
replace s_hhi=0 if s_hhi==.


global xclist size size2 age page tang s_hhi rdc sum5yr sga ad ind_year state_year


******Table A2 Begins******


***Interaction with GPT
replace calyear=fyear-1
******Merge with GPT data
merge 1:1 gvkey calyear using tech_div_rb.dta
drop if _m==2
drop _m

***technology diversity available till 2010
drop if fyear>2011

global xalist hit_ratio 

global xblista2 div_j div_subcat div_cat2

global xclist size size2 age page tang s_hhi rdc sum5yr sga ad state_year ind_year   

 foreach VAR of varlist $xblista2 { 
	replace `VAR'=0 if `VAR'==.
	}
	  
  sort fyear sic3
 	  foreach VAR of varlist $xblista2 { 
	   by fyear sic3: egen avg = pctile(`VAR'), p(75)
		  gen `VAR'_dm=.
		   replace `VAR'_dm=1 if `VAR'>avg & `VAR'~=.
		   replace `VAR'_dm=0 if `VAR'<=avg & `VAR'~=.		   
	   drop avg
	  } 
set more off
foreach INNO of varlist $xblista2 { 
   foreach DISASTER of varlist $xalist { 
   gen inno_dis=`DISASTER'*`INNO'_dm
	  areg roa inno_dis `INNO'_dm `DISASTER' $xclist i.year, a(gvkey) cluster(state) 	  
	  drop inno_dis
  }
}

