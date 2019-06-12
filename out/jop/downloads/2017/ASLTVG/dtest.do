******A TEST OF EXOGENEITY WITHOUT AN INSTRUMENTAL VARIABLE******
**All files dtest* are for the program taken from Caetano’s 
**website and based on her Econometrica (2016) paper

***Program for making output table***
capture program drop output_line
program output_line
args yvar Theta SE
di as text  %11s abbrev("`yvar'",11) "{c | }" as result /*
   */      %8.0g `Theta' "    " /*
   */      %8.0g `SE' "  "
end

***Program for the test itself***
capture program drop dtest
program dtest, rclass
version 11

***Specifying syntax for the dtest command ***
syntax varlist(min = 2) if , xbar(real) h(real) p(integer) [Kernel(string)] 
tokenize `varlist'
local yvar "`1'"
local xvar "`2'"
macro shift 2 
local zvars "`*'"


***Defining temporary variables***
tempvar plug1 plug2 xbartemp
quietly {
** Generating E[Y|X=0,Z] **
gen `xbartemp' = `xbar' in 1
regress `yvar' `zvars' if `xvar' == `xbar', robust
predict `plug1'

** Generating E[Y|X=0,Z] - Y **
gen `plug2' = `plug1' - `yvar'
}

*** Using STATA's lpoly command to calculate theta and standard error for the Discontinuity Test ***
tempvar s serr 
quietly lpoly `plug2' `xvar' `if' , bw(`h') deg(`p') kernel(`kernel') nograph n(1) at(`xbartemp') gen(`s') se(`serr')

local theta = `s'
local se = `serr'

return scalar theta = `theta'
return scalar se = `se'

*** Displaying STATA output table for test results ***
di "{text: A Test of Exogeneity Without an}"
di "{text: Instrumental Variable}"
di as text "{hline 11}{c TT}{hline 24}"
di as text "   Variable{c  |} Theta" _col(26) "Std. Err."
di as text "{hline 11}{c +}{hline 24}"
output_line `yvar' `theta' `se'
di as text "{hline 11}{c BT}{hline 24}"
di "{text: Bandwidth = `h', Degree = `p'}" 
  


end
