*********************************************************
**Use the results obtained by running "Run_simulation" to 
**generate Figure1 and Figure2.
*********************************************************

cd "XXXX define path to folders XXXX/MC"


clear *

set mem 2000m

forvalues R = 1(1)200 {

foreach B in 500 {
foreach N in  25 100       {

	foreach a_b in  "50_200"  {
	
		foreach c in 0.01  0.05 0.1 0.2   {
		
			 cap append using Results/`N'_`a_b'_`c'_0_Round`R'.dta
				
		}
	}	
}
}
}

tab N c 




set scheme s2mono

local bin=10
set more off
foreach N in   25  100      {

	foreach b in  200    {
	
		foreach c in "01" "1" "2"   {

			preserve
			
			keep if N==`N'  & b==`b' & inrange(c,0.`c'-0.0001,0.`c'+0.0001)

			summ reject_without_5
			local mean_without=r(mean)

			summ reject_FP_5
			local mean_FP=r(mean)

			
			collapse (mean) reject* , by(M_bin`bin')

			cap la var M_bin10 "Decile of the number of observations in the treated group"
			cap la var M_bin5 "Quintile of the number of observations in the treated group"
			la var reject_without_5 "Reject H_0 at 5%"
			la var reject_FP_5 "Reject H_0 at 5%"

						
			twoway (bar reject_without_5 M_bin`bin', fi(inten30) lc(black) barw(0.6) yline(`mean_without') ylabel(0(0.02)0.16) xlabel(1(1)`bin') yscale(range(0 0.16)) xscale(range(1 `bin')) ) , graphregion(color(white))     
			graph export "Figures/CT_`N'_`b'_`c'.pdf", replace
			

			twoway (bar reject_FP_5 M_bin`bin', fi(inten30) lc(black) barw(0.6) yline(`mean_FP') ylabel(0(0.02)0.16) xlabel(1(1)`bin') yscale(range(0 0.16)) xscale(range(1 `bin')) ) , graphregion(color(white))  
			graph export "Figures/FP_`N'_`b'_`c'.pdf", replace


			restore
			
		}
	}
}
		
				
		
