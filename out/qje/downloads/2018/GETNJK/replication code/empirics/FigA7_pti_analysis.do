cd [Directory]

clear
forvalues year=2008/2009{
	forvalues quarter=1/4{
		import delimited historical_data1_Q`quarter'`year'.txt, delimiter("|") clear
		save historical_data1_Q`quarter'`year'.dta, replace
	}
}

clear
gen year=.
forvalues yr=2008/2009{
	forvalues quarter=1/4{
		append using historical_data1_Q`quarter'`yr'.dta,force
		replace year=`yr' if year==.
	}
}

rename v1 creditscore
rename v2 first_payment_date
rename v3 firsttimebuyer_flag
rename v4 maturity_date
rename v5 msa
rename v6 mortgageinsurancepercent
rename v7 units
rename v8 occupancy
rename v9 CLTV
rename v10 pti
rename v11 upb
rename v12 LTV
rename v13 original_interest_rate
rename v14 channel
rename v15 ppm
rename v16 product_type
rename v17 state
rename v18 property_type
rename v19 zipcode
rename v20 loan_id
rename v21 loan_purpose
rename v22 original_term
rename v23 numborrowers
rename v24 sellername
rename v25 servicername
rename v26 superconforming

destring pti, replace

save freddie_data_2008to2009, replace







/* code to make equity groups to merge in */

use output/master.dta, clear

renvars cash_out_amt*, subst(cash_out_amt casho_amt)

xtset msa datem
format datem %tm

drop ed_a age_21_30 // base categories
g mort_if_own = mort_own / home_own

cap renvars pct_zip*, subst(pct_zip pct_cltv_zip)

* CLTVs based on zip-level HPI  
g cltv_over80  	=  pct_cltv_zip_80_90_aw + pct_cltv_zip_90_100_aw + pct_cltv_zip_100_aw
g cltv_over100 	=  						   pct_cltv_zip_100_aw 

g cltv_0_40 	=  pct_cltv_zip_0_10_aw + pct_cltv_zip_10_20_aw + pct_cltv_zip_20_30_aw + pct_cltv_zip_30_40_aw
g cltv_40_80 	=  pct_cltv_zip_40_50_aw+ pct_cltv_zip_50_60_aw + pct_cltv_zip_60_70_aw + pct_cltv_zip_70_80_aw

g cltv_over40 = cltv_40_80 + cltv_over80 
g cltv_over60 = pct_cltv_zip_60_70_aw+pct_cltv_zip_70_80_aw + cltv_over80

pwcorr cltv_over* CLTV_p50 [aw=pop2008]     if datem==m(2008m11), obs

rename CLTV_p50 cltv_p50  
replace cltv_p50 = cltv_p50/100  

local cutoff = 25  
local z = 100-`cutoff'
// level of leverage:
sum cltv_p50 if datem==m(2008m11) [aw=pop2008], det
g       x = 1 if cltv_p50 < r(p`cutoff')&datem==m(2008m11) // group 1 = most equity
replace x = 4 if cltv_p50 > r(p`z')     &datem==m(2008m11) & cltv_p50<.
egen group = max(x), by(msa)

keep group msa
duplicates drop

preserve
merge 1:m msa using freddie_data_2008to2009, keep(3) nogen
save freddiemerged, replace
restore

merge 1:m msa using fannie_data_2007to2010_wcbsa, keep(3) nogen

append using freddiemerged, force

replace pti=65 if pti==.

program drop _all
program save_chart
	graph save stata/`0', replace
	gr export "pdf/`0'.pdf", replace as(pdf)
end

preserve
bys group year (pti): gen cdf_pti=_n/_N
keep if pti!=pti[_n+1]
twoway (line cdf_pti pti if group==1 & year==2009, lcolor(gs1)) (line cdf_pti pti if group==4 & year==2009, lpattern(dash)),  xlabel(0(10)70, angle(45) nogrid) xtitle("") ytitle("CDF of PTI in 2009") ///
legend(order(1 "Highest Equity Quartile" 2 "Lowest Equity Quartile") symx(9)) name(cdf_pti_`cutoff', replace)
save_chart pti_cdf_quartiles
restore

preserve
bys group year (CLTV): gen cdf_CLTV=_n/_N
keep if CLTV!=CLTV[_n+1]
twoway (line cdf_CLTV CLTV if group==1 & year==2009 & CLTV<101 & CLTV>19, lcolor(gs1)) (line cdf_CLTV CLTV if group==4 & year==2009 & CLTV<101 & CLTV>19,lpattern(dash)),  xlabel(20(10)100, angle(45) nogrid) xtitle("") ytitle("CDF of CLTV in 2009") ///
legend(order(1 "Highest Equity Quartile" 2 "Lowest Equity Quartile") symx(9)) name(cdf_pti_`cutoff', replace)
save_chart cltv_cdf_quartiles
restore

