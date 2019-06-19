**************************************************************************************************
**************************************************************************************************
* Expected value estimation (risk neutrality)
**************************************************************************************************
**************************************************************************************************

capture program drop MLneutral
program define MLneutral

args lnf noise 
tempvar euNDexpoff euD euDiff stdevUexpoff varUexpoff

quietly {

	generate double `euNDexpoff' = 0
	generate double `varUexpoff' = 0

/* Expected utility of no deal decision */

qui sum evcount
forvalues x = 1/`r(max)' {
replace `euNDexpoff' = `euNDexpoff' + expoff`x'*P`x'
}


/* Standard deviation attached to no deal decision */

qui sum evcount
forvalues x = 1/`r(max)' {
replace `varUexpoff' = `varUexpoff'+P`x'*(expoff`x' -`euNDexpoff')^2 
}

 generate double `stdevUexpoff' = sqrt(`varUexpoff')
  

/* Creating utility for deal decision, and using the difference with utility for no deal decision to estimate the model */	
      generate double `euD' = offer

      generate double `euDiff' = (`euNDexpoff' - `euD')/(`stdevUexpoff'*`noise')                 /* EU difference ND or D*/
 
      replace `lnf' = ln(max(normal((2*$ML_y1-1 )*`euDiff'),0.01))
    }
end


**************************************************************************************************
**************************************************************************************************
* CARA utility function
**************************************************************************************************
**************************************************************************************************

capture program drop MLcara
program define MLcara

    args lnf  alph  noise   
    tempvar euNDexpoff euD euDiff stdevUexpoff varUexpoff

    quietly {

	generate double `euNDexpoff' = 0
	generate double `varUexpoff' = 0
	
/* Expected utility of no deal decision */

qui sum evcount
forvalues x = 1/`r(max)' {
replace `euNDexpoff' = `euNDexpoff' + P`x'*(1-exp(-`alph'*expoff`x')) /`alph'
}

/* Standard deviation attached to no deal decision */

qui sum evcount
forvalues x = 1/`r(max)' {
replace `varUexpoff' = `varUexpoff'+P`x'*(((1-exp(-`alph'*expoff`x')) /`alph') -`euNDexpoff')^2 
}

generate double `stdevUexpoff' = sqrt(`varUexpoff')
	
/* Creating utility for deal decision, and using the difference with utility for no deal decision to estimate the model */	
	  generate double `euD' = (1-exp(-`alph'*offer)) /`alph'

      generate double `euDiff' = (`euNDexpoff' - `euD')/(`stdevUexpoff'*`noise')                 /* EU difference ND or D*/

      replace `lnf' = ln(max(normal((2*$ML_y1-1 )*`euDiff'),0.01))
    }
end

**************************************************************************************************
**************************************************************************************************
* CRRA Utility
**************************************************************************************************
**************************************************************************************************

capture program drop MLcrra
program define MLcrra

args lnf beta noise 
tempvar euNDexpoff euD euDiff stdevUexpoff varUexpoff

quietly {

	generate double `euNDexpoff' = 0
	generate double `varUexpoff' = 0
	
/* Expected utility of no deal decision */

qui sum evcount
forvalues x = 1/`r(max)' {
replace `euNDexpoff' = `euNDexpoff' + P`x'*(expoff`x')^(1-`beta')
}


/* Standard deviation attached to no deal decision */

qui sum evcount
forvalues x = 1/`r(max)' {
replace `varUexpoff' = `varUexpoff'+P`x'*(((expoff`x')^(1-`beta')) -`euNDexpoff')^2 
}

 generate double `stdevUexpoff' = sqrt(`varUexpoff')
  

/* Creating utility for deal decision, and using the difference with utility for no deal decision to estimate the model */	
      generate double `euD' = (offer)^(1-`beta')

      generate double `euDiff' = (`euNDexpoff' - `euD')/(`stdevUexpoff'*`noise')                 /* EU difference ND or D*/
 
      replace `lnf' = ln(max(normal((2*$ML_y1-1 )*`euDiff'),0.01))
    }
end

**************************************************************************************************
**************************************************************************************************
* Expo Power Utility 
**************************************************************************************************
**************************************************************************************************

capture program drop MLexpo
program define MLexpo

args lnf alphat beta noise 
tempvar euNDexpoff euD euDiff alpha stdevUexpoff varUexpoff

quietly {

	generate double `euNDexpoff' = 0
	generate double `varUexpoff' = 0
	generate double `alpha'      = `alphat'*sign(`alphat'*`beta')
	
/* Expected utility of no deal decision */

qui sum evcount
forvalues x = 1/`r(max)' {
replace `euNDexpoff' = `euNDexpoff' + P`x'*(1-exp(-`alpha'*(expoff`x')^(1-`beta')))/`alpha'
}


/* Standard deviation attached to no deal decision */

qui sum evcount
forvalues x = 1/`r(max)' {
replace `varUexpoff' = `varUexpoff'+P`x'*(((1-exp(-`alpha'*(expoff`x')^(1-`beta')))/`alpha') -`euNDexpoff')^2 
}

 generate double `stdevUexpoff' = sqrt(`varUexpoff')
  

/* Creating utility for deal decision, and using the difference with utility for no deal decision to estimate the model */	
      generate double `euD' = (1-exp(-`alpha'*(offer)^(1-`beta')))/`alpha'

      generate double `euDiff' = (`euNDexpoff' - `euD')/(`stdevUexpoff'*`noise')                 /* EU difference ND or D*/
 
      replace `lnf' = ln(max(normal((2*$ML_y1-1 )*`euDiff'),0.01))
    }
end

**************************************************************************************************
**************************************************************************************************
* Prospect Theory model
**************************************************************************************************
**************************************************************************************************
capture program drop MLpt
program define MLpt
   
    args lnf alpha lambdat theta1 theta2 noiset 
    tempvar ptNDexpoff ptND ptD ptDiff  varUexpoff stdevUexpoff refpunt p pOut lambda noise eoffer 
    quietly {

	generate double `lambda' =`lambdat'  
	generate double `noise'  = `noiset'
	
	generate double `ptNDexpoff' = 0
	generate double `varUexpoff' = 0
	     
/* Determining the reference point */

gen double `refpunt' = (`theta1'+`theta2'*(ev-initialev)/ev)*offer
replace `refpunt' = highestexpoff if `refpunt' >= highestexpoff
replace `refpunt' = lowestexpoff if `refpunt'  <= lowestexpoff

/* Expected PT value of no deal decision */

qui sum evcount
forvalues x = 1/`r(max)' {
replace `ptNDexpoff' = `ptNDexpoff' + P`x'*(expoff`x'-`refpunt')^(`alpha')                 if expoff`x' >= `refpunt'
replace `ptNDexpoff' = `ptNDexpoff' + P`x'*-1*`lambda'*(-1*(expoff`x'-`refpunt'))^(`alpha') if expoff`x' < `refpunt'
}

/* Standard deviation attached to no deal decision */

qui sum evcount
forvalues x = 1/`r(max)' {
replace `varUexpoff' = `varUexpoff'+P`x'*(((expoff`x'-`refpunt')^(`alpha'))-`ptNDexpoff')^2  if expoff`x' >= `refpunt'
replace `varUexpoff' = `varUexpoff'+P`x'*((-1*`lambda'*(-1*(expoff`x'-`refpunt'))^(`alpha'))-`ptNDexpoff')^2 if expoff`x' < `refpunt'
}


generate double `stdevUexpoff' = sqrt(`varUexpoff')

#delimit cr 
 
/* Creating PT value for deal decision, and using the difference with PT value for no deal decision to estimate the model */	

	generate double `ptD' = 0 
	replace `ptD' = (offer-`refpunt')^(`alpha') if offer >= `refpunt'		
	replace `ptD' = -1*`lambda'*(-1*(offer-`refpunt'))^(`alpha') if offer < `refpunt' 
	generate double `ptDiff' = (`ptNDexpoff' - `ptD')/(`stdevUexpoff'*`noise')                 /* pt difference ND or D*/

      replace `lnf' = ln(max(normal((2*$ML_y1-1 )*`ptDiff'),0.01))

    }
end


