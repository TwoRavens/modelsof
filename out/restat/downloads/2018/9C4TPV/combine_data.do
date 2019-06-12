** appends the yearly data files together

use ../Mort2004/rawish2004.dta, clear
forvalues i = 5(1)14 {
	if `i'<10 {
		append using ../Mort200`i'/rawish200`i'.dta
	}
	else {
		append using ../Mort20`i'/rawish20`i'.dta
	}
}
compress
save ..\processed_data\raw_data_all_years.dta, replace


