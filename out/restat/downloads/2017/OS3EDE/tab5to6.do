***** Table 5 *****
use lps.dta, clear

preserve
  keep if agegrp!=.
  bys agegrp: tab escr_data if loantype=="S"
restore

bys loantype: tab escr_data
bys gtype: tab escr_data
bys oyr: tab escr_data



***** Table 6 *****
preserve
	keep if loantype=="P"
	bys escr_data: summ fico_orig ltv_ratio orig_amt cur_int_rate
restore

preserve
	keep if loantype=="S"
	bys escr_data: summ fico_orig ltv_ratio orig_amt cur_int_rate
restore

preserve
	keep if loantype=="FHA"
	bys escr_data: summ fico_orig ltv_ratio orig_amt cur_int_rate
restore
