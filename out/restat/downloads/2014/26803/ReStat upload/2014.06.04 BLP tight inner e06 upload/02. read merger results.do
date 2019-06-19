*******************************************************************************
* To accompany Knittel and Metaxoglou
*******************************************************************************
clear 
set memo 5000m
set type double
set more off
capture log close

*******************************************************************************
* Define globals for paths
*******************************************************************************
global root    = "C:/DB/Dropbox/RCOptim/ReStat/RESTAT Codes"
global path    = "$root/2014.06.04 BLP tight inner e06/optimization results"
global inpath  = "$root/2014.06.04 BLP tight inner e06/Merger results"
global inpath2 = "$root/2014.06.04 BLP tight inner e06"
global scripts = "$root/2014.06.04 BLP tight inner e06"

global outpath = "$inpath"

*******************************************************************************
* Import info from original BLP data
*******************************************************************************
import excel using "$inpath2/BLP data.xls",sheet("For Stata") clear firstrow case(lower)
sort id firmid market
save         "$outpath/temp1.dta", replace

import excel using "$inpath2/BLP data.xls",sheet("BLP_mkt_size") clear firstrow case(lower)
sort market
save         "$outpath/temp2.dta", replace

*******************************************************************************
* Merge intermediate files
*******************************************************************************
use          "$outpath/temp1.dta",clear
sort  market
merge market using "$outpath/temp2.dta"
drop  _merge
sort id firmid market

*Notice that newmodv does not uniquely identify a product in a market
keep market firmid id newmodv quantity mkt_size

sort id, stable

save "$outpath/Adtnl info.dta", replace

erase "$outpath/temp1.dta"
erase "$outpath/temp2.dta"

*******************************************************************************
* Import various files with merger results
*******************************************************************************
global myvars optmethod stvalue market model_id firmid id product share_obs price_pre price_post price_agg share_pre share_post share_agg mc elast_own profit_pre profit_post profit_agg mean_CV mean_CV_agg elast_agg

foreach i of numlist 1 3 4 5 14 15 {

	disp "Importing file : `i'"
	
	quietly {
		if `i'<=9 {
			infile $myvars using "$inpath\blp_merger_results_0`i'.txt", clear
		}
		if `i'>9 {
			infile $myvars using "$inpath\blp_merger_results_`i'.txt", clear
		}
				
		***************************************************************
		* Merge additional info
		***************************************************************
		sort   id, stable
		merge  id using "$outpath/Adtnl info.dta"
		assert _merge~=2
		drop   _merge
		
		gen     firm_pre  = firmid
		gen     firm_post = firm_pre
		replace firm_post = 16 if firm_post==19
				
		if `i'<=9 {
			save "$inpath\blp_merger_results0`i'.dta", replace	
		}		
		if `i'>9 {
			save "$inpath\blp_merger_results`i'.dta", replace	
		}
	}		
}	

***************************************************************************
* Append files with merger results
***************************************************************************
clear
set obs 1
gen optmethod=9999

foreach i of numlist 1 3 4 5 14 15 {

	disp "Appending file : `i'"
	
	quietly {
		if `i'<=9 {
			append using "$inpath\blp_merger_results0`i'.dta"
		}
		if `i'>9 {
			append using "$inpath\blp_merger_results`i'.dta"
		}
	}	
}

drop in 1

order $myvars

format price_* share_* profit_* mc elast_* mean_CV_* quantity mkt_size %12.4fc
		
do "$scripts/00. standardize optmethods.do"

drop  optmethod

sort  optmethod_str stvalue market product

order  optmethod_str stvalue market model_id firmid id product newmodv mkt_size firm_pre firm_post price_pre price_post price_agg share_obs share_pre share_post share_agg profit_pre profit_post profit_agg mean_CV mean_CV_agg elast_agg elast_own mc quantity 

compress
save         "$inpath\blp_merger_results_all.dta", replace
*EOF
