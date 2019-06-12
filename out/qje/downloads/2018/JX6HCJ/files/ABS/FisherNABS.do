
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

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string) robust logit]
	gettoken testvars anything: anything, match(match)
	unab testvars: `testvars'
	global k = wordcount("`testvars'")
	if ("`cluster'" ~= "") {
		quietly `anything' `if' `in', cluster(`cluster') `logit'
		}
	else {
		quietly `anything' `if' `in', `robust'
		}
	capture testparm `testvars'
	if (_rc == 0) {
		matrix FF[$i,1] = r(p), r(drop), e(df_r)
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var'], _se[`var']
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
generate N = _n
sort Strata N
generate Order = _n
generate double U = .
mata Y = st_data(.,("first","second"))

mata ResF = J($reps,43,.); ResD = J($reps,43,.); ResDF = J($reps,43,.); ResB = J($reps,262,.); ResSE = J($reps,262,.)
forvalues c = 1/$reps {
	matrix FF = J(43,3,.)
	matrix BB = J(262,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() 
	sort Strata U 
	mata st_store(.,("first","second"),Y)  
	forvalues i = 2/8 {
		quietly replace zsecond`i' = (second == `i'-1)
		}
	forvalues i = 2/6 {
		quietly replace zfirst`i' = (first == `i'+2)
		quietly replace zfirst`i'_follow_sunkcost = zfirst`i'*follow_sunkcost if follow_sunkcost ~= .
		}
	quietly replace possec = (second > 0)
	quietly replace possec_follow_sunkcost = possec*follow_sunkcost if follow_sunkcost ~= .
	quietly replace second_follow_sunkcost = second*follow_sunkcost if follow_sunkcost ~= .

global i = 1
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
	scalar coefse = sqrt(1/weightsum)
	scalar r = 2 * (1- normal( abs(coef/coefse) ) )
	matrix FF[$i,1] = scalar(r), 0, .
	matrix BB[$j,1] = (scalar(coef), scalar(coefse))
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
	matrix FF[$i,1] = scalar(r), 0, .
	matrix BB[$j,1] = (scalar(coef), scalar(coefse))
	global j = $j + 1
	global i = $i + 1
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

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..43] = FF[.,1]'; ResD[`c',1..43] = FF[.,2]'; ResDF[`c',1..43] = FF[.,3]'
mata ResB[`c',1..262] = BB[.,1]'; ResSE[`c',1..262] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/43 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/262 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N

foreach var in ResF ResDF ResD {
	local j = 44
	foreach i in 1 4 6 8 12 {
		generate double `var'`j' = `var'`i'
		local j = `j' + 1
		}
	}
matrix list = (1,4,5,6,7,8,9,10,11,20,21,22,23,24,25,26,27,36,37,38,39,40,41,72,73,74,75,76,77)
forvalues i = 1/29 {
	local j = 262 + `i'
	local k = list[1,`i']
	foreach var in ResB ResSE {
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
foreach var in B1 B2 {
	forvalues i = 1/29 {
		local j = 262 + `i'
		local k = list[1,`i']
		quietly replace `var' = `var'[`k'] if _n == `j'
		}
	}
aorder
save results\FisherABS, replace


