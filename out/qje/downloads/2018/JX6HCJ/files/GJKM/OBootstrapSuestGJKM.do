
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* 
		capture drop xx* 
		capture drop Ssample*
		estimates clear
		matrix B = J(1,100,.)
		global j = 0
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	if ("`cmd'" == "areg") {
		quietly areg `dep' `testvars' `anything' `if' `in', absorb(`absorb')
		quietly generate Ssample$i = e(sample)
		quietly areg `dep' `anything' if Ssample$i, absorb(`absorb')
		quietly predict double yyy$i if Ssample$i, resid
		local newtestvars = ""
		foreach var in `testvars' {
			quietly areg `var' `anything' if Ssample$i, absorb(`absorb')
			quietly predict double xx`var'$i if Ssample$i, resid
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		quietly reg yyy$i `newtestvars', noconstant
		}
	else {
		quietly reg `dep' `testvars' `anything' `if' `in', 
		quietly generate Ssample$i = e(sample)
		quietly reg `dep' `anything' if Ssample$i, 
		quietly predict double yyy$i if Ssample$i, resid
		local newtestvars = ""
		foreach var in `testvars' {
			quietly reg `var' `anything' if Ssample$i, 
			quietly predict double xx`var'$i if Ssample$i, resid
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		quietly reg yyy$i `newtestvars', noconstant
		}
	estimates store M$i
	foreach var in `newtestvars' {
		global j = $j + 1
		matrix B[1,$j] = _b[`var']
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, baseoutcome(string)]
	if ($i == 0) {
		global M = ""
		global test = ""
		estimates clear
		capture drop xxx*
		matrix B = J(1,100,.)
		global j = 0
		}
	global i = $i + 1

	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	local newtestvars = ""
	foreach var in `testvars' {
		quietly gen xxx`var'$i = `var'
		local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
		}
	capture `cmd' `dep' `newtestvars' `anything' `if' `in', baseoutcome(`baseoutcome')
	scalar rc = scalar(rc) + _rc
	if (_rc == 0) {
		estimates store M$i
		foreach var in `newtestvars' {
			global j = $j + 1
			capture matrix B[1,$j] = _b[1:`var']
			scalar rc = scalar(rc) + _rc
			global j = $j + 1
			capture matrix B[1,$j] = _b[2:`var']
			scalar rc = scalar(rc) + _rc
			}
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

end

****************************************
****************************************


*dropping collinear

use DatGJKM, clear

*Table 5 
global i = 0
	mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) reg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice, robust cluster(uid)
	mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) areg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (game_type!=19 & game_type!=20), absorb(uid)
	*mycmd (jlgame monitor talking ptnrchoice) reg risky jlgame monitor talking ptnrchoice if (dynamic==0), robust cluster(uid)
	mycmd (jlgame monitor talking ptnrchoice) areg risky jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==0), absorb(uid)
	*mycmd (jlgame monitor talking ptnrchoice) reg risky jlgame monitor talking ptnrchoice if (dynamic==1), robust cluster(uid)
	mycmd (jlgame monitor talking ptnrchoice) areg risky jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==1), absorb(uid)

quietly suest $M, cluster(uid)
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 5)
matrix B5 = B[1,1..$j]

*Table 6 
global i = 0
	mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) reg repay dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice , robust cluster(uid)
	mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) areg repay dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 , absorb(uid) 
	*mycmd (jlgame monitor talking ptnrchoice) reg repay jlgame monitor talking ptnrchoice if (dynamic==0), robust cluster(uid)
	mycmd (jlgame monitor talking ptnrchoice) areg repay jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==0), absorb(uid) 
	*mycmd (jlgame monitor talking ptnrchoice) reg repay jlgame monitor talking ptnrchoice if (dynamic==1), robust cluster(uid)
	mycmd (jlgame monitor talking ptnrchoice) areg repay jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==1), absorb(uid) 

quietly suest $M, cluster(uid)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)
matrix B6 = B[1,1..$j]

*Table 7 
global i = 0
	mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) areg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 , absorb(uid) 
	mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) areg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (female==1), absorb(uid) 
	mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) areg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (younger==1), absorb(uid) 
	mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) areg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (older==1), absorb(uid) 
	mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) areg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (secondary==1), absorb(uid) 
	mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) areg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (gss2pos==1), absorb(uid) 
	mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) areg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (saves_bank==1), absorb(uid) 

quietly suest $M, cluster(uid)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 7)
matrix B7 = B[1,1..$j]

*Table 8 - one column dropped because could not reproduce
global i = 0
	mycmd (dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice) areg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (jlgame==1), absorb(uid) 
	mycmd (dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice) areg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice safewithrisky riskywithsafe round1 round3-round6 if (jlgame==1 ), absorb(uid) 
	mycmd (dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice) areg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (jlgame==1 & theta1==1), absorb(uid) 
	mycmd (dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice) areg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (jlgame==1 & theta1==0 & theta3==0 ), absorb(uid) 
	mycmd (dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice) areg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (jlgame==1 & theta3==1), absorb(uid) 

quietly suest $M, cluster(uid)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 8)
matrix B8 = B[1,1..$j]

*Table 9 
scalar rc = 0
global i = 0
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0), baseoutcome(0) 
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1), baseoutcome(0) 
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & theta1pair==1), baseoutcome(0) 
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & theta1pair==1), baseoutcome(0) 
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & mixedpair==1), baseoutcome(0) 
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & mixedpair==1), baseoutcome(0) 
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & riskypair==1), baseoutcome(0) 
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & riskypair==1), baseoutcome(0) 

quietly suest $M, cluster(pairid)
test [M1_1]xxxmonitor1 [M1_2]xxxmonitor1 [M1_1]xxxtalking1 [M1_2]xxxtalking1 [M1_1]xxxptnrchoice1 [M1_2]xxxptnrchoice1 [M2_1]xxxmonitor2 [M2_2]xxxmonitor2 [M2_1]xxxtalking2 [M2_2]xxxtalking2 [M2_1]xxxptnrchoice2 [M2_2]xxxptnrchoice2 [M3_1]xxxmonitor3 [M3_2]xxxmonitor3 [M3_1]xxxtalking3 [M3_2]xxxtalking3 [M3_1]xxxptnrchoice3 [M3_2]xxxptnrchoice3 [M4_1]xxxmonitor4 [M4_2]xxxmonitor4 [M4_1]xxxtalking4 [M4_2]xxxtalking4 [M4_1]xxxptnrchoice4 [M4_2]xxxptnrchoice4 [M5_1]xxxmonitor5 [M5_2]xxxmonitor5 [M5_1]xxxtalking5 [M5_2]xxxtalking5 [M5_1]xxxptnrchoice5 [M5_2]xxxptnrchoice5 [M6_1]xxxmonitor6 [M6_2]xxxmonitor6 [M6_1]xxxtalking6 [M6_2]xxxtalking6 [M6_1]xxxptnrchoice6 [M6_2]xxxptnrchoice6 [M7_1]xxxmonitor7 [M7_2]xxxmonitor7 [M7_1]xxxtalking7 [M7_2]xxxtalking7 [M7_1]xxxptnrchoice7 [M7_2]xxxptnrchoice7 [M8_1]xxxmonitor8 [M8_2]xxxmonitor8 [M8_1]xxxtalking8 [M8_2]xxxtalking8 [M8_1]xxxptnrchoice8 [M8_2]xxxptnrchoice8 
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 9)
matrix B9 = B[1,1..$j]

preserve

	gen Order = _n
	sort uid Order
	gen N = 1
	gen Dif = (uid ~= uid[_n-1])
	replace N = N[_n-1] + Dif if _n > 1
	save bb, replace

	drop if N == N[_n-1]
	egen NN = max(N)
	keep NN
	generate obs = _n
	save bbb, replace

restore

preserve

	gen Order = _n
	sort pairid Order
	gen N = 1
	gen Dif = (pairid ~= pairid[_n-1])
	replace N = N[_n-1] + Dif if _n > 1
	save cc, replace

	drop if N == N[_n-1]
	egen NN = max(N)
	keep NN
	generate obs = _n
	save ccc, replace

restore

mata ResF = J($reps,25,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	set seed `c'
	use bbb, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using bb
	drop uid
	rename obs uid

*Table 5 
global i = 0
	mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) reg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice, robust cluster(uid)
	mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) areg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (game_type!=19 & game_type!=20), absorb(uid)
	mycmd (jlgame monitor talking ptnrchoice) areg risky jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==0), absorb(uid)
	mycmd (jlgame monitor talking ptnrchoice) areg risky jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==1), absorb(uid)

capture suest $M, cluster(uid)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B5)*invsym(V)*(B[1,1..$j]-B5)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 5)
		}
	}

*Table 6 
global i = 0
	mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) reg repay dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice , robust cluster(uid)
	mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) areg repay dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 , absorb(uid) 
	mycmd (jlgame monitor talking ptnrchoice) areg repay jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==0), absorb(uid) 
	mycmd (jlgame monitor talking ptnrchoice) areg repay jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==1), absorb(uid) 

capture suest $M, cluster(uid)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B6)*invsym(V)*(B[1,1..$j]-B6)'
		mata test = st_matrix("test"); ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', test[1,1], 6)
		}
	}

*Table 7 
global i = 0
	mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) areg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 , absorb(uid) 
	mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) areg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (female==1), absorb(uid) 
	mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) areg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (younger==1), absorb(uid) 
	mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) areg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (older==1), absorb(uid) 
	mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) areg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (secondary==1), absorb(uid) 
	mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) areg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (gss2pos==1), absorb(uid) 
	mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) areg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (saves_bank==1), absorb(uid) 

capture suest $M, cluster(uid)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B7)*invsym(V)*(B[1,1..$j]-B7)'
		mata test = st_matrix("test"); ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', test[1,1], 7)
		}
	}

*Table 8 
global i = 0
	mycmd (dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice) areg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (jlgame==1), absorb(uid) 
	mycmd (dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice) areg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice safewithrisky riskywithsafe round1 round3-round6 if (jlgame==1 ), absorb(uid) 
	mycmd (dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice) areg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (jlgame==1 & theta1==1), absorb(uid) 
	mycmd (dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice) areg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (jlgame==1 & theta1==0 & theta3==0 ), absorb(uid) 
	mycmd (dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice) areg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (jlgame==1 & theta3==1), absorb(uid) 

capture suest $M, cluster(uid)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B8)*invsym(V)*(B[1,1..$j]-B8)'
		mata test = st_matrix("test"); ResF[`c',16..20] = (`r(p)', `r(drop)', `r(df)', test[1,1], 8)
		}
	}

	set seed `c'
	use ccc, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using cc
	drop pairid
	rename obs pairid

*Table 9 

scalar rc = 0
global i = 0
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0), baseoutcome(0) 
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1), baseoutcome(0) 
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & theta1pair==1), baseoutcome(0) 
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & theta1pair==1), baseoutcome(0) 
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & mixedpair==1), baseoutcome(0) 
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & mixedpair==1), baseoutcome(0) 
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & riskypair==1), baseoutcome(0) 
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & riskypair==1), baseoutcome(0) 

capture suest $M, cluster(pairid)
if (_rc == 0 & scalar(rc) == 0) {
	capture test [M1_1]xxxmonitor1 [M1_2]xxxmonitor1 [M1_1]xxxtalking1 [M1_2]xxxtalking1 [M1_1]xxxptnrchoice1 [M1_2]xxxptnrchoice1 [M2_1]xxxmonitor2 [M2_2]xxxmonitor2 [M2_1]xxxtalking2 [M2_2]xxxtalking2 [M2_1]xxxptnrchoice2 [M2_2]xxxptnrchoice2 [M3_1]xxxmonitor3 [M3_2]xxxmonitor3 [M3_1]xxxtalking3 [M3_2]xxxtalking3 [M3_1]xxxptnrchoice3 [M3_2]xxxptnrchoice3 [M4_1]xxxmonitor4 [M4_2]xxxmonitor4 [M4_1]xxxtalking4 [M4_2]xxxtalking4 [M4_1]xxxptnrchoice4 [M4_2]xxxptnrchoice4 [M5_1]xxxmonitor5 [M5_2]xxxmonitor5 [M5_1]xxxtalking5 [M5_2]xxxtalking5 [M5_1]xxxptnrchoice5 [M5_2]xxxptnrchoice5 [M6_1]xxxmonitor6 [M6_2]xxxmonitor6 [M6_1]xxxtalking6 [M6_2]xxxtalking6 [M6_1]xxxptnrchoice6 [M6_2]xxxptnrchoice6 [M7_1]xxxmonitor7 [M7_2]xxxmonitor7 [M7_1]xxxtalking7 [M7_2]xxxtalking7 [M7_1]xxxptnrchoice7 [M7_2]xxxptnrchoice7 [M8_1]xxxmonitor8 [M8_2]xxxmonitor8 [M8_1]xxxtalking8 [M8_2]xxxtalking8 [M8_1]xxxptnrchoice8 [M8_2]xxxptnrchoice8, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B9)*invsym(V)*(B[1,1..$j]-B9)'
		mata test = st_matrix("test"); ResF[`c',21..25] = (`r(p)', `r(drop)', `r(df)', test[1,1], 9)
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
gen N = _n
save results\OBootstrapSuestGJKM, replace

capture erase bb.dta
capture erase bbb.dta
capture erase cc.dta
capture erase ccc.dta

