
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [,  ]
	gettoken testvars anything: anything, match(match)
	unab testvars: `testvars'
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', 
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, ]
	gettoken testvars anything: anything, match(match)
	unab testvars: `testvars'
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', 
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end

****************************************
****************************************

global b = 262

use DatABS, clear

local health "base_soapfood base_soaptoil base_puratt"
local demos "age school schyear married pregnant children nchild5 hhldsize durables"
local locality "zlocality2 zlocality3 zlocality4 zlocality5"
local prior "base_use base_have"
local all_controls "`prior' `health' `demos' `locality'"

local zmarketers "zmarketer2 zmarketer3 zmarketer4 zmarketer5 zmarketer6"
local first_zmarketers "first_zmarketer2 first_zmarketer3 first_zmarketer4 first_zmarketer5 first_zmarketer6"
local second_zmarketers "second_zmarketer2 second_zmarketer3 second_zmarketer4 second_zmarketer5 second_zmarketer6"
local possec_zmarketers "possec_zmarketer2 possec_zmarketer3 possec_zmarketer4 possec_zmarketer5 possec_zmarketer6"

* LOCALS: WRITTEN BY LOOPS

local std_mkt_control ""
foreach control in `all_controls'{
	local std_mkt_control "`std_mkt_control' std_mkt_`control'"
}

local inter_follow_sunkcost ""
local inter_follow_value ""
local inter_married ""

foreach split in follow_sunkcost follow_value married base_ever{
	foreach var in `all_controls' {
		local inter_`split' "`inter_`split'' `var'_`split'"
	}
}

local inter_follow_sunkcost_nofirst ""
local inter_follow_fcon_nofirst ""

foreach split in follow_sunkcost follow_fcon{
	foreach var in `all_controls'{
		local inter_`split'_nofirst "`inter_`split'_nofirst' `var'_`split'"
	}
}

local inter_follow_sunkcost_first ""
foreach var in zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 zsecond8 {
	local inter_follow_sunkcost_first "`inter_follow_sunkcost_first' `var'_follow_sunkcost"
}

matrix B = J($b,1,.)

global j = 1

*Table 2
mycmd (first) reg bought first
mycmd (first) reg bought first `std_mkt_control'
mycmd (first) reg bought first if follow==1

*Table 3
mycmd (first zsecond2-zsecond8) regress follow_use first zsecond2-zsecond8 if bought==1
mycmd (first zsecond2-zsecond8) regress follow_use first zsecond2-zsecond8 `all_controls' if bought==1
mycmd (first zsecond2-zsecond8) regress follow_have first zsecond2-zsecond8 if bought==1
mycmd (first zsecond2-zsecond8) regress follow_have first zsecond2-zsecond8 `all_controls' if bought==1

*Table 4
foreach outcome in follow_use follow_have {
	foreach transprice in second possec {
		mycmd (`transprice' zfirst2-zfirst6) regress `outcome' `transprice' zfirst2-zfirst6 `all_controls' if bought==1
		mycmd (`transprice' `transprice'_follow_sunkcost zfirst2-zfirst6 zfirst2_follow_sunkcost-zfirst6_follow_sunkcost) reg `outcome' `transprice' `transprice'_follow_sunkcost zfirst2-zfirst6 zfirst2_follow_sunkcost-zfirst6_follow_sunkcost `all_controls' `inter_follow_sunkcost' follow_sunkcost if bought==1
		}
	}

*Table 5 
mycmd (first zsecond2-zsecond8) regress onemonth_exhausted first zsecond2-zsecond8 if bought==1
*ZSECOND ISSUE HERE
mycmd (first zsecond2-zsecond7) regress onemonth_use first zsecond2-zsecond8 if bought==1 & onemonth_exhausted~=1
*ZSECOND ISSUE HERE
mycmd (first zsecond2-zsecond7) regress onemonth_have first zsecond2-zsecond8 if bought==1 & onemonth_exhausted~=1
mycmd (first zsecond2-zsecond8) regress follow_purpose first zsecond2-zsecond8 if bought==1
mycmd (first zsecond2-zsecond8) regress follow_purpose first zsecond2-zsecond8 if bought==1 & onemonth_exhausted==1

*Table A3
mycmd (first) probit bought first
foreach outcome in follow_use follow_have {
*ZSECOND ISSUE HERE
	mycmd (first zsecond2-zsecond7) probit `outcome' first zsecond2-zsecond8 if bought==1
	mycmd (second zfirst2-zfirst6) probit `outcome' second zfirst2-zfirst6 `all_controls' if bought==1
	}

mycmd (first) reg bought first `zmarketers'
foreach outcome in follow_use follow_have {
	mycmd (first zsecond2-zsecond8) regress `outcome' first zsecond2-zsecond8 `zmarketers' if bought==1
	mycmd (second zfirst2-zfirst6) reg `outcome' second zfirst2-zfirst6 `all_controls' `zmarketers' if bought==1
	}

** SPECIFICATION 4: AVERAGE TREATMENT EFFECTS
foreach outcome in follow_use follow_have {
	scalar weighted = 0
	scalar weightsum = 0
	foreach f of numlist 3/8 {
		reg `outcome' second `all_controls' if first==`f' & bought==1
		scalar weighted = weighted + _b[second]/(_se[second]^2)
		scalar weightsum = weightsum + 1/(_se[second]^2)
		}
	scalar coef = weighted/weightsum
	matrix B[$j,1] = (scalar(coef))
	global j = $j + 1

	scalar weighted = 0
	scalar weightsum = 0
	* (note: only using transaction prices up to 6 because not enough data at 7 to estimate model)
	foreach s of numlist 0/6 {
		reg `outcome' first if second==`s'&bought==1
		scalar weighted = weighted + _b[first]/(_se[first]^2)
		scalar weightsum = weightsum + 1/(_se[first]^2)
		}
	scalar coef = weighted/weightsum
	matrix B[$j,1] = (scalar(coef))
	global j = $j + 1
	}

mycmd (first) reg bought first follow_puratt

foreach outcome in follow_use follow_have {
	mycmd (first zsecond2-zsecond8) reg `outcome' first zsecond2-zsecond8 follow_puratt if bought==1
	mycmd (second zfirst2-zfirst6) reg `outcome' second zfirst2-zfirst6 follow_puratt `all_controls' if bought==1
	}

mycmd (first zsecond2-zsecond8) oprobit follow_free first zsecond2-zsecond8 if bought==1
mycmd (second zfirst2-zfirst6) oprobit follow_free second zfirst2-zfirst6 `all_controls' if bought==1
mycmd (first zsecond2-zsecond8) oprobit follow_recent first zsecond2-zsecond8 if bought==1
mycmd (second zfirst2-zfirst6) oprobit follow_recent second zfirst2-zfirst6 `all_controls' if bought==1

global reps = _N

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if _n == `c'

global j = 1

*Table 2
mycmd1 (first) reg bought first
mycmd1 (first) reg bought first `std_mkt_control'
mycmd1 (first) reg bought first if follow==1

*Table 3
mycmd1 (first zsecond2-zsecond8) regress follow_use first zsecond2-zsecond8 if bought==1
mycmd1 (first zsecond2-zsecond8) regress follow_use first zsecond2-zsecond8 `all_controls' if bought==1
mycmd1 (first zsecond2-zsecond8) regress follow_have first zsecond2-zsecond8 if bought==1
mycmd1 (first zsecond2-zsecond8) regress follow_have first zsecond2-zsecond8 `all_controls' if bought==1

*Table 4
foreach outcome in follow_use follow_have {
	foreach transprice in second possec {
		mycmd1 (`transprice' zfirst2-zfirst6) regress `outcome' `transprice' zfirst2-zfirst6 `all_controls' if bought==1
		mycmd1 (`transprice' `transprice'_follow_sunkcost zfirst2-zfirst6 zfirst2_follow_sunkcost-zfirst6_follow_sunkcost) reg `outcome' `transprice' `transprice'_follow_sunkcost zfirst2-zfirst6 zfirst2_follow_sunkcost-zfirst6_follow_sunkcost `all_controls' `inter_follow_sunkcost' follow_sunkcost if bought==1
		}
	}

*Table 5 
mycmd1 (first zsecond2-zsecond8) regress onemonth_exhausted first zsecond2-zsecond8 if bought==1
*ZSECOND ISSUE HERE
mycmd1 (first zsecond2-zsecond7) regress onemonth_use first zsecond2-zsecond8 if bought==1 & onemonth_exhausted~=1
*ZSECOND ISSUE HERE
mycmd1 (first zsecond2-zsecond7) regress onemonth_have first zsecond2-zsecond8 if bought==1 & onemonth_exhausted~=1
mycmd1 (first zsecond2-zsecond8) regress follow_purpose first zsecond2-zsecond8 if bought==1
mycmd1 (first zsecond2-zsecond8) regress follow_purpose first zsecond2-zsecond8 if bought==1 & onemonth_exhausted==1

*Table A3
mycmd1 (first) probit bought first
foreach outcome in follow_use follow_have {
*ZSECOND ISSUE HERE
	mycmd1 (first zsecond2-zsecond7) probit `outcome' first zsecond2-zsecond8 if bought==1
	mycmd1 (second zfirst2-zfirst6) probit `outcome' second zfirst2-zfirst6 `all_controls' if bought==1
	}

mycmd1 (first) reg bought first `zmarketers'
foreach outcome in follow_use follow_have {
	mycmd1 (first zsecond2-zsecond8) regress `outcome' first zsecond2-zsecond8 `zmarketers' if bought==1
	mycmd1 (second zfirst2-zfirst6) reg `outcome' second zfirst2-zfirst6 `all_controls' `zmarketers' if bought==1
	}

** SPECIFICATION 4: AVERAGE TREATMENT EFFECTS
foreach outcome in follow_use follow_have {
	scalar weighted = 0
	scalar weightsum = 0
	foreach f of numlist 3/8 {
		quietly reg `outcome' second `all_controls' if first==`f' & bought==1
		scalar weighted = weighted + _b[second]/(_se[second]^2)
		scalar weightsum = weightsum + 1/(_se[second]^2)
		}
	scalar coef = weighted/weightsum
	matrix BB[$j,1] = (scalar(coef))
	global j = $j + 1

	scalar weighted = 0
	scalar weightsum = 0
	* (note: only using transaction prices up to 6 because not enough data at 7 to estimate model)
	foreach s of numlist 0/6 {
		quietly reg `outcome' first if second==`s'&bought==1
		scalar weighted = weighted + _b[first]/(_se[first]^2)
		scalar weightsum = weightsum + 1/(_se[first]^2)
		}
	scalar coef = weighted/weightsum
	matrix BB[$j,1] = (scalar(coef))
	global j = $j + 1
	}

mycmd1 (first) reg bought first follow_puratt

foreach outcome in follow_use follow_have {
	mycmd1 (first zsecond2-zsecond8) reg `outcome' first zsecond2-zsecond8 follow_puratt if bought==1
	mycmd1 (second zfirst2-zfirst6) reg `outcome' second zfirst2-zfirst6 follow_puratt `all_controls' if bought==1
	}

mycmd1 (first zsecond2-zsecond8) oprobit follow_free first zsecond2-zsecond8 if bought==1
mycmd1 (second zfirst2-zfirst6) oprobit follow_free second zfirst2-zfirst6 `all_controls' if bought==1
mycmd1 (first zsecond2-zsecond8) oprobit follow_recent first zsecond2-zsecond8 if bought==1
mycmd1 (second zfirst2-zfirst6) oprobit follow_recent second zfirst2-zfirst6 `all_controls' if bought==1

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 1/$b {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
svmat double B
gen N = _n
save results\OJackknifeABS, replace

matrix list = (1,4,5,6,7,8,9,10,11,20,21,22,23,24,25,26,27,36,37,38,39,40,41,72,73,74,75,76,77)
forvalues i = 1/29 {
	local j = 262 + `i'
	local k = list[1,`i']
	foreach var in ResB {
		generate double `var'`j' = `var'`k'
		}
	}
foreach var in B1 {
	forvalues i = 1/29 {
		local j = 262 + `i'
		local k = list[1,`i']
		quietly replace `var' = `var'[`k'] if _n == `j'
		}
	}
aorder
save results\OJackknifeABS, replace




