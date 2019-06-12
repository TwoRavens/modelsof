cd [Directory]

clear

forvalues year=2007/2015{
	forvalues quarter=1/4{
		import delimited Acquisition_`year'Q`quarter'.txt, delimiter("|") clear
		save Acquisition_`year'Q`quarter'.dta, replace
	}
}

clear
forvalues year=2007/2015{
	forvalues quarter=1/4{
		append using Acquisition_`year'Q`quarter'.dta
	}
}

rename v1 loan_id
rename v2 channel
rename v3 seller
rename v4 rate
rename v5 upb
rename v6 loan_term
rename v7 orig_date
rename v8 first_payment_date
rename v9 LTV
rename v10 CLTV
rename v11 numborrowers
rename v12 pti
rename v13 creditscore
rename v14 first_time_buyer
rename v15 loan_purpose
rename v16 property_type
rename v17 num_units
rename v18 occupancy_status
rename v19 state
rename v20 zip3
rename v21 pmi
rename v22 product_type
rename v23 coborrower_creditscore
rename v24 mortgage_insurance_type
rename v25 relocation_mortgage_indicator

gen month=substr(orig_date,1,2)
gen year=substr(orig_date,4,4)
destring month, replace
destring year, replace
gen mdate = ym(year, month) 
format mdate %tm 

keep if mdate>=ym(2007,1) & mdate<=ym(2010,12)
save fannie_data_2007to2010, replace

clear
forvalues year=2008/2009{
	forvalues quarter=1/4{
		import delimited Performance_`year'Q`quarter'.txt, delimiter("|") clear
		rename v1 loan_id
		rename v10 msa
		keep loan_id msa
		save Performance_`year'Q`quarter'_msainfo.dta, replace
	}
}

clear
forvalues year=2008/2009{
	forvalues quarter=1/4{
		append using Performance_`year'Q`quarter'_msainfo.dta
	}
}
duplicates drop
sort loan_id msa
drop if loan_id==loan_id[_n-1]
save fannie_performance_msa, replace
use fannie_performance_msa, clear

merge 1:1 loan_id using fannie_data_2007to2010, keep(2 3)
rename _merge _merge_value
rename msa msa_performance
save fannie_data_2007to2010_linked

use zipTOcbsa_2010q1_hud.dta, replace
*assign each zip to whatever place has the most population (note this will leave a few ties, but that's fine for the next step)
bys zip: egen maxcbsa=max(res_ratio)
keep if res_ratio==maxcbsa
gen zip3=substr(zip,1,3)
destring zip3, replace

bys zip3: egen cbsa_mode=mode(cbsa), minmode
keep zip3 cbsa_mode
rename cbsa_mode msa
duplicates drop

merge 1:m zip3 using fannie_data_2007to2010_linked
keep if _merge==3
drop _merge

replace msa=35840 if msa==14600|msa==42260 
replace msa=18880 if msa==23020
replace msa=44600 if msa==48260
replace msa=42044 if msa==11244
replace msa=14460 if msa==4048

drop if msa==99999
gen metro=1 if msa_performance==47900 | msa_performance==14460 | msa_performance==16980 | msa_performance==19100 | msa_performance==33100 | msa_performance==41860 | msa_performance==31080 | msa_performance==42660 | msa_performance==35620 | msa_performance==19820 | msa_performance==37980
replace msa=msa_performance if msa_performance!=. & metro!=1





save fannie_data_2007to2010_wcbsa, replace
