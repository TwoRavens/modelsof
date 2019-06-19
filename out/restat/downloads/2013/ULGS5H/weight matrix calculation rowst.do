
capture qui drop dij*

sort year idcode
by year: egen counter=seq(), from(1)

qui sum longitude
local n= r(N)

local size=`n'+1000


set matsize `size'


qui sum year
local j = r(min)

forval i = 1/`n' {
* distance to the observation of all the other observations
	qui gen loni= longitude in `i'
 	qui egen temp=max(loni)
	qui replace loni=temp
	qui drop temp
	qui gen lati= latitude in `i'
	qui egen temp=max(lati)
	qui replace lati=temp
	qui drop temp
	qui vincenty lati loni latitude longitude, v(dij`i') inkm
	qui replace dij`i'=0 in `i'
	qui replace dij`i'=0 if year!=`j'
	qui drop loni lati 
	qui replace dij`i'=115.38078/dij`i'
	
	if `i'!=`n'{
		local c=`i'+1
		local c=counter in `c'
		local cm=counter in `i'
		if `c'<`cm' {
			local j=`j'+1 
		}
	}
} // close i loop
drop counter

qui foreach var of varlist dij* {
replace `var' =0 if `var'==.
}


qui egen rowsum = rsum(dij*)

qui foreach var of varlist dij* {
replace `var' = `var'/rowsum
replace `var'=0 if `var'==.
}

qui drop rowsum


