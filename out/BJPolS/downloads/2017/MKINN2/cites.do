capture program drop cites
program define cites
args n type
replace b_cites_`type'= _b[cites] if _n==`n'
replace se_cites_`type' = _se[cites]  if _n==`n'
replace pval_cites_`type'= 2*normal(-abs(_b[cites]/_se[cites]))  if _n==`n'
replace method_`type' = "`e(cmd)'" if _n==`n'
replace dv_`type' = "`e(depvar)'" if _n==`n'
replace dv_`type' = "`:word 2 of `e(cmdline)''" if _n==`n' & dv_`type'==""
replace lo_cites_`type' = _b[cites]-(_se[cites]*invnormal(.975)) if _n==`n'
replace hi_cites_`type' = _b[cites]+(_se[cites]*invnormal(.975)) if _n==`n'
replace N_cites_`type' = `e(N)'  if _n==`n'

end
