
*randomizing at their level (i.e. treating observations as independent and ignoring fact treatment is applied in village groups) - this affects first set of regressions


****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, absorb(string) cluster(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" == "") {
		`anything' `if' `in', `robust' cluster(`cluster')
		}
	else {
		`anything' `if' `in', cluster(`cluster') `robust' absorb(`absorb')
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

use DatCGTTTV1, clear

global hhcontrols "DK_basixi wealth_indexi logpce_new_wi riskav1_jul06i norm_exp_rainMay06 lcultirrpcti mean_payouts buy_ins04i ins_otheri bua_newi group_addi sched_ct muslim sexheadi lage_headi lhhsizei d_highedu ins_skilli" 

matrix F = J(18,4,.)
matrix B = J(105,2,.)

global i = 1
global j = 1

*Table 5
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit VD2-VD38, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit VD2-VD26 VD28-VD38 $hhcontrols, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit DK_basixiXendors_LSA DK_basixiXins_edu DK_basixiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit DK_basixiX* $hhcontrols VD2-VD26 VD28-VD38, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit wealth_indexiXendors_LSA wealth_indexiXins_edu wealth_indexiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit wealth_indexiX* $hhcontrols VD2-VD26 VD28-VD38, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit logpce_new_wiXendors_LSA logpce_new_wiXins_edu logpce_new_wiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit logpce_new_wiX* $hhcontrols VD2-VD26 VD28-VD38, robust 

generate Order = _n

global i = 0

*Table 5
foreach var in d_visit endors_LSA ins_edu d_highreward endors_visit {
	global i = $i + 1
	local a = "d_visit endors_LSA ins_edu d_highreward endors_visit"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(`a')
	randcmdc ((`var') reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit, robust), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample
	}

foreach var in d_visit endors_LSA ins_edu d_highreward endors_visit {
	global i = $i + 1
	local a = "d_visit endors_LSA ins_edu d_highreward endors_visit"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(`a')
	randcmdc ((`var') reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit VD2-VD38, robust), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample
	}

foreach var in d_visit endors_LSA ins_edu d_highreward endors_visit {
	global i = $i + 1
	local a = "d_visit endors_LSA ins_edu d_highreward endors_visit"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(`a')
	randcmdc ((`var') reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit VD2-VD26 VD28-VD38 $hhcontrols, robust), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample
	}

forvalues j = 1/24 {
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


***********************************************

use DatCGTTTV2, clear

global i = 7
global j = 40

*Table 6
mycmd (pctdiscountT sewaT vframeT ppayT peerT) reg boughtins pctdiscountT sewaT vframeT ppayT peerT surveyed2007, robust cluster(villageno)
mycmd (pctdiscountT sewaT vframeT ppayT peerT) areg boughtins pctdiscountT sewaT vframeT ppayT peerT surveyed2007, robust cluster(villageno) absorb(villageno)
mycmd (pctdiscountT sewaT vframeT ppayT peerT vframeXpctdiscount ppayXpctdiscount sewaXpctdiscount peerXpctdiscount surveyXpctdiscount) reg boughtins pctdiscountT sewaT vframeT ppayT peerT vframeXpctdiscount ppayXpctdiscount sewaXpctdiscount peerXpctdiscount surveyXpctdiscount surveyed2007, robust cluster(villageno)
mycmd (pctdiscountT sewaT vframeT ppayT peerT vframeXpctdiscount ppayXpctdiscount sewaXpctdiscount peerXpctdiscount surveyXpctdiscount) areg boughtins pctdiscountT sewaT vframeT ppayT peerT vframeXpctdiscount ppayXpctdiscount sewaXpctdiscount peerXpctdiscount surveyXpctdiscount surveyed2007, robust cluster(villageno) absorb(villageno)

*Table 7
mycmd (muslimT hinduT groupT) reg boughtins muslimT hinduT groupT surveyedwave1, robust cluster(villageno)
mycmd (muslimT hinduT groupT) areg boughtins muslimT hinduT groupT surveyedwave1, robust cluster(villageno) absorb(villageno)
mycmd (muslimT hinduT groupT musgr hingr) reg boughtins muslimT hinduT groupT musgr hingr surveyedwave1, robust cluster(villageno)
mycmd (muslimT hinduT groupT musgr hingr) areg boughtins muslimT hinduT groupT musgr hingr surveyedwave1, robust cluster(villageno) absorb(villageno)
mycmd (muslimT hinduT groupT musgr hingr) reg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="M", robust cluster(villageno)
mycmd (muslimT hinduT groupT musgr hingr) areg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="M", robust cluster(villageno) absorb(villageno)
mycmd (muslimT hinduT groupT musgr hingr) reg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="H", robust cluster(villageno)
mycmd (muslimT hinduT groupT musgr hingr) areg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="H", robust cluster(villageno) absorb(villageno)

egen M1 = group(muslimT hinduT groupT)
egen MM = max(M1), by(villageno)
*Not strictly stratified by village (correspondence with authors), but groups of villages x previously surveyed are strata because treatment was differentiated by these characteristics
egen Strata = group(MM surveyT), missing
tab villageno if Strata == 4
tab Strata
generate N = _n
sort Strata N
generate Order = _n

global i = 39

*Table 6
foreach var in pctdiscountT sewaT vframeT ppayT peerT {
	global i = $i + 1
	local a = "pctdiscountT sewaT vframeT ppayT peerT"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg boughtins pctdiscountT sewaT vframeT ppayT peerT surveyed2007, robust cluster(villageno)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample
	}

foreach var in pctdiscountT sewaT vframeT ppayT peerT {
	global i = $i + 1
	local a = "pctdiscountT sewaT vframeT ppayT peerT"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') areg boughtins pctdiscountT sewaT vframeT ppayT peerT surveyed2007, robust cluster(villageno) absorb(villageno)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample
	}

*Interaction with surveyed, not possible to rerandomize pctdiscount while holding surveyXpctdiscount constant
forvalues j = 1/20 {
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

*Table 7
foreach var in muslimT hinduT groupT {
	global i = $i + 1
	local a = "muslimT hinduT groupT"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg boughtins muslimT hinduT groupT surveyedwave1, robust cluster(villageno)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample
	}

foreach var in muslimT hinduT groupT {
	global i = $i + 1
	local a = "muslimT hinduT groupT"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') areg boughtins muslimT hinduT groupT surveyedwave1, robust cluster(villageno) absorb(villageno)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample
	}

foreach var in muslimT hinduT groupT musgr hingr {
	global i = $i + 1
	local a = "muslimT hinduT groupT musgr hingr"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg boughtins muslimT hinduT groupT musgr hingr surveyedwave1, robust cluster(villageno)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample
	}

foreach var in muslimT hinduT groupT musgr hingr {
	global i = $i + 1
	local a = "muslimT hinduT groupT musgr hingr"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') areg boughtins muslimT hinduT groupT musgr hingr surveyedwave1, robust cluster(villageno) absorb(villageno)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample
	}

foreach var in muslimT hinduT groupT musgr hingr {
	global i = $i + 1
	local a = "muslimT hinduT groupT musgr hingr"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="M", robust cluster(villageno)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample
	}

foreach var in muslimT hinduT groupT musgr hingr {
	global i = $i + 1
	local a = "muslimT hinduT groupT musgr hingr"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') areg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="M", robust cluster(villageno) absorb(villageno)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample
	}

foreach var in muslimT hinduT groupT musgr hingr {
	global i = $i + 1
	local a = "muslimT hinduT groupT musgr hingr"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') reg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="H", robust cluster(villageno)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample
	}

foreach var in muslimT hinduT groupT musgr hingr {
	global i = $i + 1
	local a = "muslimT hinduT groupT musgr hingr"
	local a = subinstr("`a'","`var'","",1)
	capture drop NewStrata
	egen NewStrata = group(Strata `a')
	randcmdc ((`var') areg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="H", robust cluster(villageno) absorb(villageno)), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample
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
save results\FisherCondCGTTTV, replace
