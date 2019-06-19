********************************************************************************
* To accompany Knittel and Metaxoglou
********************************************************************************
clear 
set memo 5000m
set type double
set more off
capture log close

********************************************************************************
* Define globals for paths
********************************************************************************
global root     = "c:/DB/Dropbox/RCOptim/Restat/RESTAT Codes"
global inpath   = "$root/2014.06.04 Nevo tight inner/Merger results"
global inpath2  = "$root/2014.06.04 Nevo tight inner/Optimization results"
global scripts  = "$root/2014.06.04 Nevo"

global outpath ="$inpath"

********************************************************************************
* Import various files with merger results
********************************************************************************
global myvars optmethod stvalue market brand share_obs price_pre price_post price_agg share_pre share_post share_agg mc elast_own profit_pre profit_post profit_agg mean_CV mean_CV_agg elast_agg

foreach i of numlist 1 2 3 4 5 7 8 9 10 11 {
	
	disp "Importing file : `i'"
		
	quietly {
		if `i'<=9 {
			qui infile $myvars using "$inpath/nevo_merger_results_0`i'.txt", clear
		}
		if `i'>9 {
			qui infile $myvars using "$inpath/nevo_merger_results_`i'.txt", clear
		}

		gen     firm_pre=1
		replace firm_pre=2 if brand>=10 & brand<=18
		replace firm_pre=3 if brand>=19 & brand<=20
		replace firm_pre=4 if brand>=21 & brand<=23
		replace firm_pre=5 if brand>=24

		gen     firm_post=1
		replace firm_post=3 if brand>=19 & brand<=20
		replace firm_post=4 if brand>=21 & brand<=23
		replace firm_post=5 if brand>=24

	       compress

		if `i'<=9 {
			save "$inpath/nevo_merger_results0`i'.dta", replace	
		}

		if `i'>9 {
			save "$inpath/nevo_merger_results`i'.dta", replace	
		}	
	}
}	

********************************************************************************
* Append files with merger results
********************************************************************************
clear
set obs 1
gen optmethod=9999

foreach i of numlist 1 2 3 4 5 7 8 9 10 11 {

	disp "Appending file : `i'"
	
	quietly {
		if `i'<=9 {
			append using "$inpath/nevo_merger_results0`i'.dta"
		}
		if `i'>9 {
			append using "$inpath/nevo_merger_results`i'.dta"
		}	
	
	}

}

drop in 1

order $myvars

format price_* share_* profit_* mc elast_* mean_C* %12.4fc
		
do "$scripts/00. standardize optmethods.do"

drop   optmethod

sort  optmethod_str stvalue market brand

gen mkt_size=250
gen quantity=share_obs*mkt_size

order  optmethod_str stvalue market brand firm_pre firm_post price_pre price_post price_agg share_obs share_pre share_post share_agg profit_pre profit_post profit_agg mean_CV mean_CV_agg elast_agg elast_own mc quantity 


compress

save "$outpath/nevo_merger_results_all.dta", replace
*EOF
