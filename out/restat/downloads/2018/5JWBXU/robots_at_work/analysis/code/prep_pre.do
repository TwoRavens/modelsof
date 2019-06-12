* robots: for analysis of basic outcomes, pull "pre-trends"

u "..\input\EUKLEMS", clear

	keep if year==1993 | year==1993 - ( 2007-1993 )
		
	so country code_euklems year
	
	by country code_euklems: gen pre_ch_va = log(VA_QI[_n]/VA_QI[_n-1])
		by country code_euklems: gen pre_va0 = log(VA_QI[1])
	by country code_euklems: gen pre_ch_h = log(H_EMP[_n]/H_EMP[_n-1])
		by country code_euklems: gen pre_h0 = log(H_EMP[1])
		
	gen pre_ch_prod = pre_ch_va - pre_ch_h
		by country code_euklems: gen pre_prod0 = log(VA_QI[1]/H_EMP[1])
		
	keep if year==1993 & code_euklems!=""
	
	keep country code_euklems pre_*

sa "..\temp\EUKLEMS_pre", replace	
