

capture program drop mycmd
program define mycmd
	syntax anything [aw pw] [if] [in] [, robust cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)
	unab testvars: `testvars'

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* 
		capture drop xx* 
		capture drop Ssample*
		matrix B = J(1,100,.)
		estimates clear
		global j = 0
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	unab anything: `anything'
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	if ("`cmd'" == "reg" | "`cmd'" == "areg" | "`cmd'" == "regress") {
		if ("`absorb'" ~= "") quietly areg `dep' `testvars' `anything' [`weight' `exp'] `if' `in', absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `testvars' `anything' [`weight' `exp'] `if' `in', 
		quietly generate Ssample$i = e(sample)
		if ("`absorb'" ~= "") quietly areg `dep' `anything' [`weight' `exp'] if Ssample$i, absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `anything' [`weight' `exp'] if Ssample$i, 
		quietly predict double yyy$i if Ssample$i, resid
		local newtestvars = ""
		foreach var in `testvars' {
			if ("`absorb'" ~= "") quietly areg `var' `anything' [`weight' `exp'] if Ssample$i, absorb(`absorb')
			if ("`absorb'" == "") quietly reg `var' `anything' [`weight' `exp'] if Ssample$i, 
			quietly predict double xx`var'$i if Ssample$i, resid
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		capture reg yyy$i `newtestvars' [`weight' `exp'], noconstant
		if (_rc == 0) {
			estimates store M$i
			foreach var in `newtestvars' {
				global j = $j + 1
				matrix B[1,$j] = _b[`var']
				}
			}
		}
	else {
		local newtestvars = ""
		foreach var in `testvars' {
			quietly generate double xx`var'$i = `var' 
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		capture `cmd' `dep' `newtestvars' `anything' `if' `in', 
		if (_rc == 0) {
			estimates store M$i
			foreach var in `newtestvars' {
				global j = $j + 1
				matrix B[1,$j] = _b[`var']
				}
			}
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

end

****************************************
****************************************

use DatCGTTTV1, clear

global hhcontrols "DK_basixi wealth_indexi logpce_new_wi riskav1_jul06i norm_exp_rainMay06 lcultirrpcti mean_payouts buy_ins04i ins_otheri bua_newi group_addi sched_ct muslim sexheadi lage_headi lhhsizei d_highedu ins_skilli" 

*Table 5
global i = 0
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit VD2-VD38, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit VD2-VD26 VD28-VD38 $hhcontrols, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit DK_basixiXendors_LSA DK_basixiXins_edu DK_basixiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit DK_basixiX* $hhcontrols VD2-VD26 VD28-VD38, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit wealth_indexiXendors_LSA wealth_indexiXins_edu wealth_indexiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit wealth_indexiX* $hhcontrols VD2-VD26 VD28-VD38, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit logpce_new_wiXendors_LSA logpce_new_wiXins_edu logpce_new_wiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit logpce_new_wiX* $hhcontrols VD2-VD26 VD28-VD38, robust 

quietly suest $M, robust
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 5)
matrix B5 = B[1,1..$j]

gen N = _n
sort N
save aa, replace

egen NN = max(N)
keep NN
save aaa, replace

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa

*Table 5
global i = 0
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit VD2-VD38, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit VD2-VD26 VD28-VD38 $hhcontrols, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit DK_basixiXendors_LSA DK_basixiXins_edu DK_basixiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit DK_basixiX* $hhcontrols VD2-VD26 VD28-VD38, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit wealth_indexiXendors_LSA wealth_indexiXins_edu wealth_indexiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit wealth_indexiX* $hhcontrols VD2-VD26 VD28-VD38, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit logpce_new_wiXendors_LSA logpce_new_wiXins_edu logpce_new_wiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit logpce_new_wiX* $hhcontrols VD2-VD26 VD28-VD38, robust 

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B5)*invsym(V)*(B[1,1..$j]-B5)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 5)
		}
	}
}

drop _all
set obs $reps
forvalues i = 1/5 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save ip\OBootstrapSuestCGTTTV1, replace


**********************************
**********************************

use DatCGTTTV2, clear

*Table 6
global i = 0
mycmd (pctdiscountT sewaT vframeT ppayT peerT) reg boughtins pctdiscountT sewaT vframeT ppayT peerT surveyed2007, robust cluster(villageno)
mycmd (pctdiscountT sewaT vframeT ppayT peerT) areg boughtins pctdiscountT sewaT vframeT ppayT peerT surveyed2007, robust cluster(villageno) absorb(villageno)
mycmd (pctdiscountT sewaT vframeT ppayT peerT vframeXpctdiscount ppayXpctdiscount sewaXpctdiscount peerXpctdiscount surveyXpctdiscount) reg boughtins pctdiscountT sewaT vframeT ppayT peerT vframeXpctdiscount ppayXpctdiscount sewaXpctdiscount peerXpctdiscount surveyXpctdiscount surveyed2007, robust cluster(villageno)
mycmd (pctdiscountT sewaT vframeT ppayT peerT vframeXpctdiscount ppayXpctdiscount sewaXpctdiscount peerXpctdiscount surveyXpctdiscount) areg boughtins pctdiscountT sewaT vframeT ppayT peerT vframeXpctdiscount ppayXpctdiscount sewaXpctdiscount peerXpctdiscount surveyXpctdiscount surveyed2007, robust cluster(villageno) absorb(villageno)

local anything = "$test"
global test = ""
matrix B6 = J(1,$j-9,.)
local k = 1
forvalues i = 1/$j {
	gettoken a anything: anything
	if ("`a'" ~= "xxsewaT1" & "`a'" ~= "xxppayT1" & "`a'" ~= "xxvframeT2" & "`a'" ~= "xxppayT2" & "`a'" ~= "xxpeerT2" & "`a'" ~= "xxpeerT3" & "`a'" ~= "xxpctdiscountT4" & "`a'" ~= "xxsewaT4" & "`a'" ~= "xxpeerT4") {
		global test = "$test" + " " + "`a'"
		matrix B6[1,`k'] = B[1,`i']
		local k = `k' + 1
		}
	}
global j = $j - 9

quietly suest $M, cluster(villageno)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)

*Table 7
global i = 0
mycmd (muslimT hinduT groupT) reg boughtins muslimT hinduT groupT surveyedwave1, robust cluster(villageno)
mycmd (muslimT hinduT groupT) areg boughtins muslimT hinduT groupT surveyedwave1, robust cluster(villageno) absorb(villageno)
mycmd (muslimT hinduT groupT musgr hingr) reg boughtins muslimT hinduT groupT musgr hingr surveyedwave1, robust cluster(villageno)
mycmd (muslimT hinduT groupT musgr hingr) areg boughtins muslimT hinduT groupT musgr hingr surveyedwave1, robust cluster(villageno) absorb(villageno)
mycmd (muslimT hinduT groupT musgr hingr) reg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="M", robust cluster(villageno)
mycmd (muslimT hinduT groupT musgr hingr) areg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="M", robust cluster(villageno) absorb(villageno)
mycmd (muslimT hinduT groupT musgr hingr) reg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="H", robust cluster(villageno)
mycmd (muslimT hinduT groupT musgr hingr) areg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="H", robust cluster(villageno) absorb(villageno)

local anything = "$test"
global test = ""
matrix B7 = J(1,$j-5,.)
local k = 1
forvalues i = 1/$j {
	gettoken a anything: anything
	if ("`a'" ~= "xxmuslimT1" & "`a'" ~= "xxhinduT1" & "`a'" ~= "xxgroupT3" & "`a'" ~= "xxgroupT4" & "`a'" ~= "xxmusgr4") {
		global test = "$test" + " " + "`a'"
		matrix B7[1,`k'] = B[1,`i']
		local k = `k' + 1
		}
	}
global j = $j - 5

quietly suest $M, cluster(villageno)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 7)

gen Order = _n
sort villageno Order
gen N = 1
gen Dif = (villageno ~= villageno[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save bb, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save bbb, replace

mata ResF = J($reps,10,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use bbb, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using bb
	drop villageno
	rename obs villageno

*Table 6
global i = 0
mycmd (pctdiscountT sewaT vframeT ppayT peerT) reg boughtins pctdiscountT sewaT vframeT ppayT peerT surveyed2007, robust cluster(villageno)
mycmd (pctdiscountT sewaT vframeT ppayT peerT) areg boughtins pctdiscountT sewaT vframeT ppayT peerT surveyed2007, robust cluster(villageno) absorb(villageno)
mycmd (pctdiscountT sewaT vframeT ppayT peerT vframeXpctdiscount ppayXpctdiscount sewaXpctdiscount peerXpctdiscount surveyXpctdiscount) reg boughtins pctdiscountT sewaT vframeT ppayT peerT vframeXpctdiscount ppayXpctdiscount sewaXpctdiscount peerXpctdiscount surveyXpctdiscount surveyed2007, robust cluster(villageno)
mycmd (pctdiscountT sewaT vframeT ppayT peerT vframeXpctdiscount ppayXpctdiscount sewaXpctdiscount peerXpctdiscount surveyXpctdiscount) areg boughtins pctdiscountT sewaT vframeT ppayT peerT vframeXpctdiscount ppayXpctdiscount sewaXpctdiscount peerXpctdiscount surveyXpctdiscount surveyed2007, robust cluster(villageno) absorb(villageno)

local anything = "$test"
global test = ""
matrix BB = J(1,$j-9,.)
local k = 1
forvalues i = 1/$j {
	gettoken a anything: anything
	if ("`a'" ~= "xxsewaT1" & "`a'" ~= "xxppayT1" & "`a'" ~= "xxvframeT2" & "`a'" ~= "xxppayT2" & "`a'" ~= "xxpeerT2" & "`a'" ~= "xxpeerT3" & "`a'" ~= "xxpctdiscountT4" & "`a'" ~= "xxsewaT4" & "`a'" ~= "xxpeerT4") {
		global test = "$test" + " " + "`a'"
		matrix BB[1,`k'] = B[1,`i']
		local k = `k' + 1
		}
	}
global j = $j - 9

capture suest $M, cluster(villageno)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (BB[1,1..$j]-B6)*invsym(V)*(BB[1,1..$j]-B6)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 6)
		}
	}

*Table 7
global i = 0
mycmd (muslimT hinduT groupT) reg boughtins muslimT hinduT groupT surveyedwave1, robust cluster(villageno)
mycmd (muslimT hinduT groupT) areg boughtins muslimT hinduT groupT surveyedwave1, robust cluster(villageno) absorb(villageno)
mycmd (muslimT hinduT groupT musgr hingr) reg boughtins muslimT hinduT groupT musgr hingr surveyedwave1, robust cluster(villageno)
mycmd (muslimT hinduT groupT musgr hingr) areg boughtins muslimT hinduT groupT musgr hingr surveyedwave1, robust cluster(villageno) absorb(villageno)
mycmd (muslimT hinduT groupT musgr hingr) reg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="M", robust cluster(villageno)
mycmd (muslimT hinduT groupT musgr hingr) areg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="M", robust cluster(villageno) absorb(villageno)
mycmd (muslimT hinduT groupT musgr hingr) reg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="H", robust cluster(villageno)
mycmd (muslimT hinduT groupT musgr hingr) areg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="H", robust cluster(villageno) absorb(villageno)

local anything = "$test"
global test = ""
matrix BB = J(1,$j-5,.)
local k = 1
forvalues i = 1/$j {
	gettoken a anything: anything
	if ("`a'" ~= "xxmuslimT1" & "`a'" ~= "xxhinduT1" & "`a'" ~= "xxgroupT3" & "`a'" ~= "xxgroupT4" & "`a'" ~= "xxmusgr4") {
		global test = "$test" + " " + "`a'"
		matrix BB[1,`k'] = B[1,`i']
		local k = `k' + 1
		}
	}
global j = $j - 5

capture suest $M, cluster(villageno)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (BB[1,1..$j]-B7)*invsym(V)*(BB[1,1..$j]-B7)'
		mata test = st_matrix("test"); ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', test[1,1], 7)
		}
	}
}

drop _all
set obs $reps
forvalues i = 6/15 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save ip\OBootstrapSuestCGTTTV2, replace

erase aa.dta
erase bb.dta
erase aaa.dta
erase bbb.dta

use ip\OBootstrapSuestCGTTTV1, clear
merge 1:1 N using ip\OBootstrapSuestCGTTTV2, nogenerate
drop F*
aorder
svmat double F
save results\OBootstrapSuestCGTTTV, replace

