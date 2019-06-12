
*********************************************************
* Winzorize Program by Year
*********************************************************
capture program drop winzorize_by_year

program winzorize_by_year
syntax, var(varname) pct(int) yr(varname)
local pctless100=100-`pct'

egen `var'`pct'=pctile(`var') if `var'!=0 &`var'!=. , p(`pct') by(`yr')
egen `var'`pctless100'=pctile(`var') if `var'!=0 &`var'!=. , p(`pctless100') by(`yr')

replace `var'=`var'`pct' if (`var'<`var'`pct' & `var'!=0 & `var'!=.)
replace `var'=`var'`pctless100' if (`var'>`var'`pctless100' & `var'!=0 & `var'!=.)

drop `var'`pct' `var'`pctless100'

end
