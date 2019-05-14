* Numeric variables
quietly label dir 					
foreach v in `r(names)' {
	capture confirm variable `v'
	if !_rc {
		quietly label list `v'	
		local length = length("`r(max)'")
		local format = (10^`length'-1)/9
		local 6 = 6*`format'
		local 7 = 7*`format'
		local 8 = 8*`format'
		local 9 = 9*`format'

		local a : label `v' `6'
		if regexm("`a'","Not .p+lic+able")  {
			local r `6'=.a \
			label define `v' .a "`a'" `6' "", modify
		}
		local b : label `v' `7'
		if regexm("`b'","Refus..") {
			local r `r' `7'=.b \
			label define `v' .b "`b'" `7' "", modify
		}
		local c : label `v' `8'
		if regexm("`c'","Don.?t .now") {
			local r `r' `8'=.c \
			label define `v' .c "`c'" `8' "", modify
		}
		local d : label `v' `9'
		if regexm("`d'","[No .nswer|Not .vailable]") {
			local r `r' `9'=.d \
			label define `v' .d "`d'" `9' "", modify
		}
		if !missing("`r'") mvdecode `v', mv(`r')
		local r
	}
}

* String variables
quietly ds, has(type string)
foreach v of varlist `r(varlist)' {	
	local length = substr("`:type `v''",4,4)
	local format = (10^`length'-1)/9
	local 6 = 6*`format'
	local 7 = 7*`format'
	local 8 = 8*`format'
	local 9 = 9*`format'
	di "`v'"
	replace `v'= "" if inlist(`v',"`9'","`8'","`7'","`6'")
}
