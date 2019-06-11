
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)
	unab testvars: `testvars'

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* 
		capture drop xx* 
		capture drop Ssample*
		estimates clear
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	unab anything: `anything'

	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	if ("`cmd'" == "reg" | "`cmd'" == "areg" | "`cmd'" == "regress") {
		if ("`absorb'" ~= "") quietly areg `dep' `testvars' `anything' `if' `in', absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `testvars' `anything' `if' `in', 
		quietly generate Ssample$i = e(sample)
		if ("`absorb'" ~= "") quietly areg `dep' `anything' if Ssample$i, absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `anything' if Ssample$i, 
		quietly predict double yyy$i if Ssample$i, resid
		local newtestvars = ""
		foreach var in `testvars' {
			if ("`absorb'" ~= "") quietly areg `var' `anything' if Ssample$i, absorb(`absorb')
			if ("`absorb'" == "") quietly reg `var' `anything' if Ssample$i, 
			quietly predict double xx`var'$i if Ssample$i, resid
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		quietly reg yyy$i `newtestvars', noconstant
		estimates store M$i
		}
	else {
		capture `cmd' `dep' `testvars' `anything' `if' `in', 
		if (_rc == 0) {
			quietly generate Ssample$i = e(sample)
			local newtestvars = ""
			foreach var in `testvars' {
				quietly generate double xx`var'$i = `var' if Ssample$i
				local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
				}
			capture `cmd' `dep' `newtestvars' `anything' `if' `in', 
			if (_rc == 0) {
				estimates store M$i
				}
			}
		}

	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

end

****************************************
****************************************


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

matrix B = J(291,2,.)
global j = 1

*Table 2
global i = 0
mycmd (first) reg bought first
mycmd (first) reg bought first `std_mkt_control'
mycmd (first) reg bought first if follow==1

quietly suest $M, robust
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 2)

*Table 3
global i = 0
mycmd (first) regress follow_use first zsecond2-zsecond8 if bought==1
mycmd (first) regress follow_use first zsecond2-zsecond8 `all_controls' if bought==1
mycmd (first) regress follow_have first zsecond2-zsecond8 if bought==1
mycmd (first) regress follow_have first zsecond2-zsecond8 `all_controls' if bought==1

quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 3)

*Table 4
global i = 0
foreach outcome in follow_use follow_have {
	foreach transprice in second possec {
		mycmd (`transprice') regress `outcome' `transprice' zfirst2-zfirst6 `all_controls' if bought==1
		mycmd (`transprice' `transprice'_follow_sunkcost) reg `outcome' `transprice' `transprice'_follow_sunkcost zfirst2-zfirst6 zfirst2_follow_sunkcost-zfirst6_follow_sunkcost `all_controls' `inter_follow_sunkcost' follow_sunkcost if bought==1
		}
	}

quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)

*Table 5 
global i = 0
mycmd (first) regress onemonth_exhausted first zsecond2-zsecond8 if bought==1
mycmd (first) regress onemonth_use first zsecond2-zsecond8 if bought==1 & onemonth_exhausted~=1
mycmd (first) regress onemonth_have first zsecond2-zsecond8 if bought==1 & onemonth_exhausted~=1
mycmd (first) regress follow_purpose first zsecond2-zsecond8 if bought==1
mycmd (first) regress follow_purpose first zsecond2-zsecond8 if bought==1 & onemonth_exhausted==1

quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)

*Table A3
global i = 0
mycmd (first) probit bought first
foreach outcome in follow_use follow_have {
	mycmd (first) probit `outcome' first zsecond2-zsecond8 if bought==1
	mycmd (second) probit `outcome' second zfirst2-zfirst6 `all_controls' if bought==1
	}

mycmd (first) reg bought first `zmarketers'
foreach outcome in follow_use follow_have {
	mycmd (first) regress `outcome' first zsecond2-zsecond8 `zmarketers' if bought==1
	mycmd (second) reg `outcome' second zfirst2-zfirst6 `all_controls' `zmarketers' if bought==1
	}

** SPECIFICATION 4: AVERAGE TREATMENT EFFECTS - skip these, can't suest

mycmd (first) reg bought first follow_puratt

foreach outcome in follow_use follow_have {
	mycmd (first) reg `outcome' first zsecond2-zsecond8 follow_puratt if bought==1
	mycmd (second) reg `outcome' second zfirst2-zfirst6 follow_puratt `all_controls' if bought==1
	}

mycmd (first) oprobit follow_free first zsecond2-zsecond8 if bought==1
mycmd (second) oprobit follow_free second zfirst2-zfirst6 `all_controls' if bought==1
mycmd (first) oprobit follow_recent first zsecond2-zsecond8 if bought==1
mycmd (second) oprobit follow_recent second zfirst2-zfirst6 `all_controls' if bought==1
mycmd (first) reg bought first
mycmd (first) regress follow_use first zsecond2-zsecond8 if bought==1
mycmd (first) regress follow_have first zsecond2-zsecond8 if bought==1
mycmd (second) regress follow_use second zfirst2-zfirst6 `all_controls' if bought==1
mycmd (second) regress follow_have second zfirst2-zfirst6 `all_controls' if bought==1

quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 103)

quietly generate zlocality1 = 1 - max(zlocality2,zlocality3,zlocality4,zlocality5)
egen Strata = group(zlocality1 zlocality2 zlocality3 zlocality4 zlocality5), label
generate N = _n
sort Strata N
generate Order = _n
generate double U = .
mata Y = st_data(.,("first","second"))

mata ResF = J($reps,25,.)
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


*Table 2
global i = 0
mycmd (first) reg bought first
mycmd (first) reg bought first `std_mkt_control'
mycmd (first) reg bought first if follow==1

capture suest $M, robust
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 2)
		}
	}

*Table 3
global i = 0
mycmd (first) regress follow_use first zsecond2-zsecond8 if bought==1
mycmd (first) regress follow_use first zsecond2-zsecond8 `all_controls' if bought==1
mycmd (first) regress follow_have first zsecond2-zsecond8 if bought==1
mycmd (first) regress follow_have first zsecond2-zsecond8 `all_controls' if bought==1

capture suest $M, robust
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 3)
		}
	}

*Table 4
global i = 0
foreach outcome in follow_use follow_have {
	foreach transprice in second possec {
		mycmd (`transprice') regress `outcome' `transprice' zfirst2-zfirst6 `all_controls' if bought==1
		mycmd (`transprice' `transprice'_follow_sunkcost) reg `outcome' `transprice' `transprice'_follow_sunkcost zfirst2-zfirst6 zfirst2_follow_sunkcost-zfirst6_follow_sunkcost `all_controls' `inter_follow_sunkcost' follow_sunkcost if bought==1
		}
	}

capture suest $M, robust
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 4)
		}
	}

*Table 5 
global i = 0
mycmd (first) regress onemonth_exhausted first zsecond2-zsecond8 if bought==1
mycmd (first) regress onemonth_use first zsecond2-zsecond8 if bought==1 & onemonth_exhausted~=1
mycmd (first) regress onemonth_have first zsecond2-zsecond8 if bought==1 & onemonth_exhausted~=1
mycmd (first) regress follow_purpose first zsecond2-zsecond8 if bought==1
mycmd (first) regress follow_purpose first zsecond2-zsecond8 if bought==1 & onemonth_exhausted==1

capture suest $M, robust
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',16..20] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 5)
		}
	}

*Table A3
global i = 0
mycmd (first) probit bought first
foreach outcome in follow_use follow_have {
	mycmd (first) probit `outcome' first zsecond2-zsecond8 if bought==1
	mycmd (second) probit `outcome' second zfirst2-zfirst6 `all_controls' if bought==1
	}

mycmd (first) reg bought first `zmarketers'
foreach outcome in follow_use follow_have {
	mycmd (first) regress `outcome' first zsecond2-zsecond8 `zmarketers' if bought==1
	mycmd (second) reg `outcome' second zfirst2-zfirst6 `all_controls' `zmarketers' if bought==1
	}

** SPECIFICATION 4: AVERAGE TREATMENT EFFECTS - skip these, can't suest

mycmd (first) reg bought first follow_puratt

foreach outcome in follow_use follow_have {
	mycmd (first) reg `outcome' first zsecond2-zsecond8 follow_puratt if bought==1
	mycmd (second) reg `outcome' second zfirst2-zfirst6 follow_puratt `all_controls' if bought==1
	}

mycmd (first) oprobit follow_free first zsecond2-zsecond8 if bought==1
mycmd (second) oprobit follow_free second zfirst2-zfirst6 `all_controls' if bought==1
mycmd (first) oprobit follow_recent first zsecond2-zsecond8 if bought==1
mycmd (second) oprobit follow_recent second zfirst2-zfirst6 `all_controls' if bought==1
mycmd (first) reg bought first
mycmd (first) regress follow_use first zsecond2-zsecond8 if bought==1
mycmd (first) regress follow_have first zsecond2-zsecond8 if bought==1
mycmd (second) regress follow_use second zfirst2-zfirst6 `all_controls' if bought==1
mycmd (second) regress follow_have second zfirst2-zfirst6 `all_controls' if bought==1

global test = subinstr("$test","xxzsecond722","",1)

capture suest $M, robust
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',21..25] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 103)
		}
	}

}

drop _all
set obs $reps
forvalues i = 1/25 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
save results\FisherSuestredABS, replace


