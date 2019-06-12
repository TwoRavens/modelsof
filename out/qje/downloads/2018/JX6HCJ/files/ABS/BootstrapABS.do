
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust ]
	tempvar touse newcluster
	gettoken testvars anything: anything, match(match)
	`anything' `if' `in', 
	testparm `testvars'
	global k = r(df)
	gen `touse' = e(sample)
	mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); V = sqrt(diagonal(V)); BB = B[1,1..$k]',V[1..$k,1]; st_matrix("B",BB)
	mata ResF = J($reps,4,.); ResB = J($reps,$k,.); ResSE = J($reps,$k,.)
	set seed 1
	forvalues i = 1/$reps {
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		preserve
			bsample if `touse' 
			capture `anything', 
			if (_rc == 0) {
			capture mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); B = B[1,1..$k]; V = V[1..$k,1..$k]
			capture testparm `testvars'
			if (_rc == 0 & r(df) == $k) {
				mata t = (B-BB[1..$k,1]')*invsym(V)*(B'-BB[1..$k,1])
				if (e(df_r) == .) mata ResF[`i',1..3] = `r(p)', chi2tail($k,t[1,1]), $k - `r(df)'
				if (e(df_r) ~= .) mata ResF[`i',1...] = `r(p)', Ftail($k,`e(df_r)',t[1,1]/$k), $k - `r(df)', `e(df_r)'
				mata ResB[`i',1...] = B; ResSE[`i',1...] = sqrt(diagonal(V))'
				}
				}
		restore
		}
	preserve
		quietly drop _all
		quietly set obs $reps
		quietly generate double ResF$i = .
		quietly generate double ResFF$i = .
		quietly generate double ResD$i = .
		quietly generate double ResDF$i = .
		global kk = $j + $k - 1
		forvalues i = $j/$kk {
			quietly generate double ResB`i' = .
			}
		forvalues i = $j/$kk {
			quietly generate double ResSE`i' = .
			}
		mata X = ResF, ResB, ResSE; st_store(.,.,X)
		quietly svmat double B
		quietly rename B2 SE$i
		capture rename B1 B$i
		save ip\BS$i, replace
		global i = $i + 1
		global j = $j + $k
	restore
end


*******************

global cluster = ""

global i = 1
global j = 1

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
capture drop t
generate t = .
*Stratify by the sub-equations used in the estimation of average treatment effects
*scalar cumulations fail with error if _b[second] doesn't exist, so this confirms no drops of second

		foreach outcome in follow_use follow_have {

			quietly replace t = .
			scalar weighted = 0
			scalar weightsum = 0
			foreach f of numlist 3/8 {
				reg `outcome' second `all_controls' if first==`f' & bought==1
				scalar weighted = weighted + _b[second]/(_se[second]^2)
				scalar weightsum = weightsum + 1/(_se[second]^2)
				quietly replace t = 1 if e(sample) == 1
				}
			matrix B = weighted/weightsum, sqrt(1/weightsum)
			mata B = st_matrix("B"); ResF = J($reps,4,.); ResB = J($reps,1,.); ResSE = J($reps,1,.)
			global k = 1
			set seed 1
			forvalues i = 1/$reps {
				if (floor(`i'/50) == `i'/50) display "`i'", _continue
				preserve
				quietly keep if t == 1
				bsample, strata(first)
				scalar weighted = 0
				scalar weightsum = 0
				foreach f of numlist 3/8 {
					capture reg `outcome' second `all_controls' if first==`f' & bought==1
					scalar weighted = weighted + _b[second]/(_se[second]^2)
					scalar weightsum = weightsum + 1/(_se[second]^2)
					}
				matrix BB = weighted/weightsum, sqrt(1/weightsum)
				mata BB = st_matrix("BB"); ResB[`i',1] = BB[1,1]; ResSE[`i',1] = BB[1,2]; t = ((BB[1,1]-B[1,1])/BB[1,2])^2; tt = (BB[1,1]/BB[1,2])^2; ResF[`i',1..3] = chi2tail(1,tt[1,1]), chi2tail(1,t[1,1]), 0
				restore
				}
	preserve
		quietly drop _all
		quietly set obs $reps
		quietly generate double ResF$i = .
		quietly generate double ResFF$i = .
		quietly generate double ResD$i = .
		quietly generate double ResDF$i = .
		global kk = $j + $k - 1
		forvalues i = $j/$kk {
			quietly generate double ResB`i' = .
			}
		forvalues i = $j/$kk {
			quietly generate double ResSE`i' = .
			}
		mata X = ResF, ResB, ResSE; st_store(.,.,X)
		quietly svmat double B
		quietly rename B2 SE$i
		capture rename B1 B$i
		save ip\BS$i, replace
		global i = $i + 1
		global j = $j + $k
	restore

			quietly replace t = .
			scalar weighted = 0
			scalar weightsum = 0
			foreach s of numlist 0/6 {
				reg `outcome' first if second==`s'&bought==1
				scalar weighted = weighted + _b[first]/(_se[first]^2)
				scalar weightsum = weightsum + 1/(_se[first]^2)
				quietly replace t = 1 if e(sample) == 1
				}
			matrix B = weighted/weightsum, sqrt(1/weightsum)
			mata B = st_matrix("B"); ResF = J($reps,4,.); ResB = J($reps,1,.); ResSE = J($reps,1,.)
			global k = 1
			set seed 1
			forvalues i = 1/$reps {
				if (floor(`i'/50) == `i'/50) display "`i'", _continue
				preserve
				quietly keep if t == 1
				bsample, strata(second)
				scalar weighted = 0
				scalar weightsum = 0
				foreach s of numlist 0/6 {
					capture reg `outcome' first if second==`s'&bought==1
					scalar weighted = weighted + _b[first]/(_se[first]^2)
					scalar weightsum = weightsum + 1/(_se[first]^2)
					}
				matrix BB = weighted/weightsum, sqrt(1/weightsum)
				mata BB = st_matrix("BB"); ResB[`i',1] = BB[1,1]; ResSE[`i',1] = BB[1,2]; t = ((BB[1,1]-B[1,1])/BB[1,2])^2; tt = (BB[1,1]/BB[1,2])^2; ResF[`i',1..3] = chi2tail(1,tt[1,1]), chi2tail(1,t[1,1]), 0
				restore
				}
	preserve
		quietly drop _all
		quietly set obs $reps
		quietly generate double ResF$i = .
		quietly generate double ResFF$i = .
		quietly generate double ResD$i = .
		quietly generate double ResDF$i = .
		global kk = $j + $k - 1
		forvalues i = $j/$kk {
			quietly generate double ResB`i' = .
			}
		forvalues i = $j/$kk {
			quietly generate double ResSE`i' = .
			}
		mata X = ResF, ResB, ResSE; st_store(.,.,X)
		quietly svmat double B
		quietly rename B2 SE$i
		capture rename B1 B$i
		save ip\BS$i, replace
		global i = $i + 1
		global j = $j + $k
	restore
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


use ip\BS1, clear
forvalues i = 2/43 {
	merge using ip\BS`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/43 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\BootstrapABS, replace

use results\BootstrapABS, clear
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
foreach var in B1 B2 {
	forvalues i = 1/29 {
		local j = 262 + `i'
		local k = list[1,`i']
		quietly replace `var' = `var'[`k'] if _n == `j'
		}
	}
aorder
save results\BootstrapABS, replace
