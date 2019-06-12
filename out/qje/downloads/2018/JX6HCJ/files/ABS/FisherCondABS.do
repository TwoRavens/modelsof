
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust logit]
	gettoken testvars anything: anything, match(match)
	unab testvars: `testvars'
	global k = wordcount("`testvars'")
	if ("`cluster'" ~= "") {
		`anything' `if' `in', cluster(`cluster') `logit'
		}
	else {
		`anything' `if' `in', `robust'
		}
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$i,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end


****************************************
****************************************



*Had issues with dummies for zsecond8
*Dropped in 4 regressions/probits (but not necessarily dropped in subsequent randomizations)
*To keep consistent, when simulate, test only up zsecond7 (as no zsecond8 in baseline to compare)
*Search for "*ZSECOND ISSUE HERE" in code below to see where this arises

use DatABS, clear

*Their code to create locals

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

matrix F = J(43,4,.)
matrix B = J(262,2,.)

global i = 1
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
mycmd (first zsecond2-zsecond7) regress onemonth_use first zsecond2-zsecond8 if bought==1 & onemonth_exhausted~=1
mycmd (first zsecond2-zsecond7) regress onemonth_have first zsecond2-zsecond8 if bought==1 & onemonth_exhausted~=1
mycmd (first zsecond2-zsecond8) regress follow_purpose first zsecond2-zsecond8 if bought==1
mycmd (first zsecond2-zsecond8) regress follow_purpose first zsecond2-zsecond8 if bought==1 & onemonth_exhausted==1

*Table A3
mycmd (first) probit bought first
foreach outcome in follow_use follow_have {
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
		quietly reg `outcome' second `all_controls' if first==`f' & bought==1
		scalar weighted = weighted + _b[second]/(_se[second]^2)
		scalar weightsum = weightsum + 1/(_se[second]^2)
		}
	scalar coef = weighted/weightsum
	scalar coefse = sqrt(1/weightsum)
	scalar r = 2 * (1- normal( abs(coef/coefse) ) )
	matrix F[$i,1] = scalar(r), 0, ., 1
	matrix B[$j,1] = (scalar(coef), scalar(coefse))
	global j = $j + 1
	global i = $i + 1

	scalar weighted = 0
	scalar weightsum = 0
	* (note: only using transaction prices up to 6 because not enough data at 7 to estimate model)
	foreach s of numlist 0/6 {
		quietly reg `outcome' first if second==`s'&bought==1
		scalar weighted = weighted + _b[first]/(_se[first]^2)
		scalar weightsum = weightsum + 1/(_se[first]^2)
		}
	scalar coef = weighted/weightsum
	scalar coefse = sqrt(1/weightsum)
	scalar r = 2 * (1- normal( abs(coef/coefse) ) )
	matrix F[$i,1] = scalar(r), 0, ., 1
	matrix B[$j,1] = (scalar(coef), scalar(coefse))
	global j = $j + 1
	global i = $i + 1
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

quietly generate zlocality1 = 1 - max(zlocality2,zlocality3,zlocality4,zlocality5)
egen Strata = group(zlocality1 zlocality2 zlocality3 zlocality4 zlocality5), label

global i = 0

*Table 2

global i = $i + 1
randcmdc ((first) reg bought first), treatvars(first) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 

global i = $i + 1
randcmdc ((first) reg bought first `std_mkt_control'), treatvars(first) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 

global i = $i + 1
randcmdc ((first) reg bought first if follow==1), treatvars(first) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 

*Table 3

foreach var in first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 zsecond8 {
	global i = $i + 1
	local a = "first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 zsecond8"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') regress follow_use first zsecond2-zsecond8 if bought==1), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 zsecond8 {
	global i = $i + 1
	local a = "first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 zsecond8"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') regress follow_use first zsecond2-zsecond8 `all_controls' if bought==1), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 zsecond8 {
	global i = $i + 1
	local a = "first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 zsecond8"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') regress follow_have first zsecond2-zsecond8 if bought==1), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 zsecond8 {
	global i = $i + 1
	local a = "first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 zsecond8"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') regress follow_have first zsecond2-zsecond8 `all_controls' if bought==1), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}


*Table 4
foreach outcome in follow_use follow_have {
	foreach transprice in second possec {

		foreach var in `transprice' zfirst2 zfirst3 zfirst4 zfirst5 zfirst6 {
			global i = $i + 1
			local a = "`transprice' zfirst2 zfirst3 zfirst4 zfirst5 zfirst6"
			local a = subinstr("`a'","`var'","",1)
			capture drop NewStrata
			egen NewStrata = group(Strata `a')
			randcmdc ((`var') regress `outcome' `transprice' zfirst2-zfirst6 `all_controls' if bought==1), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
			}

		forvalues j = 1/12 {
			global i = $i + 1
			preserve
				drop _all
				set obs $reps
				foreach var in ResB ResSE ResF {
					gen `var' = .
					}
				gen __0000001 = 0 if _n == 1
				gen __0000002 = 0 if _n == 1
				save ip\a$i, replace
			restore
			}
		}
	}

*Table 5 

foreach var in first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 zsecond8 {
	global i = $i + 1
	local a = "first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 zsecond8"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') regress onemonth_exhausted first zsecond2-zsecond8 if bought==1), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 {
	global i = $i + 1
	local a = "first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') regress onemonth_use first zsecond2-zsecond8 if bought==1 & onemonth_exhausted~=1), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 {
	global i = $i + 1
	local a = "first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') regress onemonth_have first zsecond2-zsecond8 if bought==1 & onemonth_exhausted~=1), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 zsecond8 {
	global i = $i + 1
	local a = "first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 zsecond8"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') regress follow_purpose first zsecond2-zsecond8 if bought==1), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 zsecond8 {
	global i = $i + 1
	local a = "first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 zsecond8"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') regress follow_purpose first zsecond2-zsecond8 if bought==1 & onemonth_exhausted==1), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}


*Table A3

global i = $i + 1
randcmdc ((first) probit bought first), treatvars(first) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 

foreach outcome in follow_use follow_have {

	foreach var in first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 {
		global i = $i + 1
		local a = "first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7"
		local a = subinstr("`a'","`var'","",1)
		capture drop NewStrata
		egen NewStrata = group(Strata `a')
		randcmdc ((`var') probit `outcome' first zsecond2-zsecond8 if bought==1), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}

	foreach var in second zfirst2 zfirst3 zfirst4 zfirst5 zfirst6 {
		global i = $i + 1
		local a = "second zfirst2 zfirst3 zfirst4 zfirst5 zfirst6"
		local a = subinstr("`a'","`var'","",1)
		capture drop NewStrata
		egen NewStrata = group(Strata `a')
		randcmdc ((`var') probit `outcome' second zfirst2-zfirst6 `all_controls' if bought==1), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}

	}

global i = $i + 1
randcmdc ((first) reg bought first `zmarketers'), treatvars(first) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 

foreach outcome in follow_use follow_have {

	foreach var in first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 zsecond8 {
		global i = $i + 1
		local a = "first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 zsecond8"
		local a = subinstr("`a'","`var'","",1)
		capture drop NewStrata
		egen NewStrata = group(Strata `a')
		randcmdc ((`var') regress `outcome' first zsecond2-zsecond8 `zmarketers' if bought==1), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}

	foreach var in second zfirst2 zfirst3 zfirst4 zfirst5 zfirst6 {
		global i = $i + 1
		local a = "second zfirst2 zfirst3 zfirst4 zfirst5 zfirst6"
		local a = subinstr("`a'","`var'","",1)
		capture drop NewStrata
		egen NewStrata = group(Strata `a')
		randcmdc ((`var') reg `outcome' second zfirst2-zfirst6 `all_controls' `zmarketers' if bought==1), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}

	}


** SPECIFICATION 4: AVERAGE TREATMENT EFFECTS
foreach outcome in follow_use follow_have {

	global i = $i + 1

preserve
	generate Order = _n
	scalar weighted = 0
	scalar weightsum = 0
	generate sample = .
	foreach f of numlist 3/8 {
		quietly reg `outcome' second `all_controls' if first==`f' & bought==1
		scalar weighted = weighted + _b[second]/(_se[second]^2)
		scalar weightsum = weightsum + 1/(_se[second]^2)
	replace sample = 1 if e(sample) == 1
		}
	matrix T = (weighted/weightsum,sqrt(1/weightsum))

	keep if sample == 1
	capture drop NewStrata
	egen NewStrata = group(Strata first)
	sort NewStrata Order
	gen double U = .
	mata t = st_data(.,"second"); ResB = J($reps,2,.)
	set seed 1
	forvalues j = 1/$reps {
		quietly replace U = uniform()
		sort NewStrata U
		mata st_store(.,"second",t)
		scalar weighted = 0
		scalar weightsum = 0
		foreach f of numlist 3/8 {
			quietly reg `outcome' second `all_controls' if first==`f' & bought==1
			scalar weighted = weighted + _b[second]/(_se[second]^2)
			scalar weightsum = weightsum + 1/(_se[second]^2)
			}
		matrix bb = (weighted/weightsum,sqrt(1/weightsum))
		mata bb = st_matrix("bb"); ResB[`j',1..2] = bb
		}
	drop _all
	set obs $reps
	generate double ResB = .
	generate double ResSE = .
	mata st_store(.,.,ResB)
	generate double ResF = (ResB/ResSE)^2
	gen double __0000001 = T[1,1] if _n == 1
	gen double __0000002 = T[1,2] if _n == 1
	save ip\a$i, replace
restore

	global i = $i + 1

preserve
	generate Order = _n
	scalar weighted = 0
	scalar weightsum = 0
	generate sample = .
	* (note: only using transaction prices up to 6 because not enough data at 7 to estimate model)
	foreach s of numlist 0/6 {
		quietly reg `outcome' first if second==`s'&bought==1
		scalar weighted = weighted + _b[first]/(_se[first]^2)
		scalar weightsum = weightsum + 1/(_se[first]^2)
	replace sample = 1 if e(sample) == 1
		}
	matrix T = (weighted/weightsum,sqrt(1/weightsum))

	keep if sample == 1
	capture drop NewStrata
	egen NewStrata = group(Strata second)
	sort NewStrata Order
	gen double U = .
	mata t = st_data(.,"first"); ResB = J($reps,2,.)
	set seed 1
	forvalues j = 1/$reps {
		quietly replace U = uniform()
		sort NewStrata U
		mata st_store(.,"first",t)
		scalar weighted = 0
		scalar weightsum = 0
		foreach s of numlist 0/6 {
			quietly reg `outcome' first if second==`s'&bought==1
			scalar weighted = weighted + _b[first]/(_se[first]^2)
			scalar weightsum = weightsum + 1/(_se[first]^2)
			}
		matrix bb = (weighted/weightsum,sqrt(1/weightsum))
		mata bb = st_matrix("bb"); ResB[`j',1..2] = bb
		}
	drop _all
	set obs $reps
	generate double ResB = .
	generate double ResSE = .
	mata st_store(.,.,ResB)
	generate double ResF = (ResB/ResSE)^2
	gen double __0000001 = T[1,1] if _n == 1
	gen double __0000002 = T[1,2] if _n == 1
	save ip\a$i, replace
restore
	}


	global i = $i + 1
	randcmdc ((first) reg bought first follow_puratt), treatvars(first) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 

foreach outcome in follow_use follow_have {
	
	foreach var in first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 zsecond8 {
		global i = $i + 1
		local a = "first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 zsecond8"
		local a = subinstr("`a'","`var'","",1)
		capture drop NewStrata
		egen NewStrata = group(Strata `a')
		randcmdc ((`var') reg `outcome' first zsecond2-zsecond8 follow_puratt if bought==1), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}

	foreach var in second zfirst2 zfirst3 zfirst4 zfirst5 zfirst6 {
		global i = $i + 1
		local a = "second zfirst2 zfirst3 zfirst4 zfirst5 zfirst6"
		local a = subinstr("`a'","`var'","",1)
		capture drop NewStrata
		egen NewStrata = group(Strata `a')
		randcmdc ((`var') reg `outcome' second zfirst2-zfirst6 follow_puratt `all_controls' if bought==1), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}

	}

foreach var in first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 zsecond8 {
	global i = $i + 1
	local a = "first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 zsecond8"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') oprobit follow_free first zsecond2-zsecond8 if bought==1), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in second zfirst2 zfirst3 zfirst4 zfirst5 zfirst6 {
	global i = $i + 1
	local a = "second zfirst2 zfirst3 zfirst4 zfirst5 zfirst6"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') oprobit follow_free second zfirst2-zfirst6 `all_controls' if bought==1), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 zsecond8 {
	global i = $i + 1
	local a = "first zsecond2 zsecond3 zsecond4 zsecond5 zsecond6 zsecond7 zsecond8"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') oprobit follow_recent first zsecond2-zsecond8 if bought==1), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in second zfirst2 zfirst3 zfirst4 zfirst5 zfirst6 {
	global i = $i + 1
	local a = "second zfirst2 zfirst3 zfirst4 zfirst5 zfirst6"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') oprobit follow_recent second zfirst2-zfirst6 `all_controls' if bought==1), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

matrix T = J($i,2,.)
use ip\a1, clear
mkmat __* in 1/1, matrix(a)
drop __*
matrix T[1,1] = a
rename ResB ResB1
rename ResSE ResSE1
rename ResF ResF1
forvalues i = 2/$i {
	merge using ip\a`i'
	mkmat __* in 1/1, matrix(a)
	drop __* _m
	matrix T[`i',1] = a
	rename ResB ResB`i'
	rename ResSE ResSE`i'
	rename ResF ResF`i'
	}
svmat double F
svmat double B
svmat double T
gen N = _n
sort N
compress
aorder
save results\FisherCondABS, replace

use results\FisherCondABS, clear
matrix list = (1,4,5,6,7,8,9,10,11,20,21,22,23,24,25,26,27,36,37,38,39,40,41,72,73,74,75,76,77)
forvalues i = 1/29 {
	local j = 262 + `i'
	local k = list[1,`i']
	foreach var in ResB ResSE ResF {
		generate double `var'`j' = `var'`k'
		}
	}
foreach var in F1 F2 F3 F4 {
	local j = 44
	foreach i in 1 4 6 8 12 {
		quietly replace `var' = `var'[`i'] if _n == `j'
		local j = `j' + 1
		}
	}
foreach var in B1 B2 T1 T2 {
	forvalues i = 1/29 {
		local j = 262 + `i'
		local k = list[1,`i']
		quietly replace `var' = `var'[`k'] if _n == `j'
		}
	}
aorder
save results\FisherCondABS, replace



