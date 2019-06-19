clear	
cd "Yourpath"

use data6.dta, clear
		
		
foreach i of numlist 2201(1)2219{
preserve 
		
keep if bnum==`i' | knum!=22
		

sum bnum_num if knum==22 	
local treatment_district=r(mean)
display `treatment_district'
				

synth turnout_mean  turnout_mean(1(1)16) turnout_mean(17(1)32), ///
				  trunit(`treatment_district') trperiod(33) xperiod(1(1)32) mspeperiod(1(1)32)  ///
				   fig resultsperiod(1(1)125) keep(resout) replace
		
mat def X_balance = e(X_balance)
mat def W_weights = e(W_weights)
mat def Y_synthetic = e(Y_synthetic)
mat def Y_treated = e(Y_treated)

cap mat drop b
foreach covar of global XX2 {
reg  `covar'  , cluster(id), if inrange(year,1,32) & id!=22
		matrix   temp = _b[_cons] , _se[_cons]
		matrix   rownames temp = "`covar'"
		mat b = nullmat(b) \ temp
		matrix colnames b = mean  se
}

mat2txt , matrix(Y_synthetic) saving(Y_synthetic_district_`i'.txt)  replace
mat2txt , matrix(Y_treated) saving(Y_treated_district_`i'.txt)  replace
		
restore
}
		
	
