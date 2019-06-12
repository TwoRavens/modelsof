
****************************************
****************************************


capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, fe robust cluster(string) baseoutcome(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`baseoutcome'" ~= "") {
		`anything' `if' `in', baseoutcome(`baseoutcome') cluster(`cluster')
		global k = $k*2
		}
	else {
		`anything' `if' `in', `fe' cluster(`cluster') `robust'
		}
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$i,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		if ("`baseoutcome'" == "") {
			foreach var in `testvars' {
				matrix B[$j+`i',1] = _b[`var'], _se[`var']
				local i = `i' + 1
				}
			}
		else {
			foreach var in `testvars' {
				matrix B[$j+`i',1] = _b[1:`var'], _se[1:`var']
				local i = `i' + 1
				matrix B[$j+`i',1] = _b[2:`var'], _se[2:`var']
				local i = `i' + 1
				}
			}
		}
global i = $i + 1
global j = $j + $k
end


****************************************
****************************************

matrix F = J(32,4,.)
matrix B = J(214,2,.)

global i = 1
global j = 1

use DatGJKM, clear

*Table 5 

mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) reg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice, robust cluster(uid)
mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (game_type!=19 & game_type!=20), fe  cluster(uid)
mycmd (jlgame monitor talking ptnrchoice) reg risky jlgame monitor talking ptnrchoice if (dynamic==0), robust cluster(uid)
mycmd (jlgame monitor talking ptnrchoice) xtreg risky jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==0), fe  cluster(uid)
mycmd (jlgame monitor talking ptnrchoice) reg risky jlgame monitor talking ptnrchoice if (dynamic==1), robust cluster(uid)
mycmd (jlgame monitor talking ptnrchoice) xtreg risky jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==1), fe  cluster(uid)

*Table 6 

mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) reg repay dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice , robust cluster(uid)
mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg repay dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 , fe  cluster(uid)
mycmd (jlgame monitor talking ptnrchoice) reg repay jlgame monitor talking ptnrchoice if (dynamic==0), robust cluster(uid)
mycmd (jlgame monitor talking ptnrchoice) xtreg repay jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==0), fe  cluster(uid)
mycmd (jlgame monitor talking ptnrchoice) reg repay jlgame monitor talking ptnrchoice if (dynamic==1), robust cluster(uid)
mycmd (jlgame monitor talking ptnrchoice) xtreg repay jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==1), fe  cluster(uid)

*Table 7 

mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 , fe  cluster(uid)
mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (female==1), fe  cluster(uid)
mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (younger==1), fe  cluster(uid)
mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (older==1), fe  cluster(uid)
mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (secondary==1), fe  cluster(uid)
mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (gss2pos==1), fe  cluster(uid)
mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (saves_bank==1), fe  cluster(uid)

*Table 8 - one column dropped because could not reproduce

mycmd (dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (jlgame==1), fe  cluster(uid)
mycmd (dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice safewithrisky riskywithsafe round1 round3-round6 if (jlgame==1 ), fe  cluster(uid)
mycmd (dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (jlgame==1 & theta1==1), fe  cluster(uid)
mycmd (dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (jlgame==1 & theta1==0 & theta3==0 ), fe  cluster(uid)
mycmd (dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (jlgame==1 & theta3==1), fe  cluster(uid)

*Table 9 

mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0), baseoutcome(0) cluster(pairid)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1), baseoutcome(0) cluster(pairid)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & theta1pair==1), baseoutcome(0) cluster(pairid)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & theta1pair==1), baseoutcome(0) cluster(pairid)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & mixedpair==1), baseoutcome(0) cluster(pairid)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & mixedpair==1), baseoutcome(0) cluster(pairid)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & riskypair==1), baseoutcome(0) cluster(pairid)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & riskypair==1), baseoutcome(0) cluster(pairid)

generate Order = _n

global i = 0

*Table 5 
foreach var in dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice {
	global i = $i + 1
	local a = "dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(day_num `a')
	randcmdc ((`var') reg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice, robust cluster(uid)), groupvar(game_num) treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice {
	global i = $i + 1
	local a = "dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(day_num `a')
	randcmdc ((`var') xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (game_type!=19 & game_type!=20), fe cluster(uid)), groupvar(game_num) treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in jlgame monitor talking ptnrchoice {
	global i = $i + 1
	local a = "jlgame monitor talking ptnrchoice"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(day_num `a')
	randcmdc ((`var') reg risky jlgame monitor talking ptnrchoice if (dynamic==0), robust cluster(uid)), groupvar(game_num) treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in jlgame monitor talking ptnrchoice {
	global i = $i + 1
	local a = "jlgame monitor talking ptnrchoice"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(day_num `a')
	randcmdc ((`var') xtreg risky jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==0), fe  cluster(uid)), groupvar(game_num) treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in jlgame monitor talking ptnrchoice {
	global i = $i + 1
	local a = "jlgame monitor talking ptnrchoice"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(day_num `a')
	randcmdc ((`var') reg risky jlgame monitor talking ptnrchoice if (dynamic==1), robust cluster(uid)), groupvar(game_num) treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in jlgame monitor talking ptnrchoice {
	global i = $i + 1
	local a = "jlgame monitor talking ptnrchoice"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(day_num `a')
	randcmdc ((`var') xtreg risky jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==1), fe  cluster(uid)), groupvar(game_num) treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

*Table 6 

foreach var in dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice {
	global i = $i + 1
	local a = "dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(day_num `a')
	randcmdc ((`var') reg repay dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice , robust cluster(uid)), groupvar(game_num) treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice {
	global i = $i + 1
	local a = "dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(day_num `a')
	randcmdc ((`var') xtreg repay dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 , fe  cluster(uid)), groupvar(game_num) treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in jlgame monitor talking ptnrchoice {
	global i = $i + 1
	local a = "jlgame monitor talking ptnrchoice"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(day_num `a')
	randcmdc ((`var') reg repay jlgame monitor talking ptnrchoice if (dynamic==0), robust cluster(uid)), groupvar(game_num) treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in jlgame monitor talking ptnrchoice {
	global i = $i + 1
	local a = "jlgame monitor talking ptnrchoice"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(day_num `a')
	randcmdc ((`var') xtreg repay jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==0), fe  cluster(uid)), groupvar(game_num) treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in jlgame monitor talking ptnrchoice {
	global i = $i + 1
	local a = "jlgame monitor talking ptnrchoice"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(day_num `a')
	randcmdc ((`var') reg repay jlgame monitor talking ptnrchoice if (dynamic==1), robust cluster(uid)), groupvar(game_num) treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in jlgame monitor talking ptnrchoice {
	global i = $i + 1
	local a = "jlgame monitor talking ptnrchoice"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(day_num `a')
	randcmdc ((`var') xtreg repay jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==1), fe  cluster(uid)), groupvar(game_num) treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

*Table 7 

foreach var in dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice {
	global i = $i + 1
	local a = "dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(day_num `a')
	randcmdc ((`var') xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 , fe  cluster(uid)), groupvar(game_num) treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice {
	global i = $i + 1
	local a = "dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(day_num `a')
	randcmdc ((`var') xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (female==1), fe  cluster(uid)), groupvar(game_num) treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice {
	global i = $i + 1
	local a = "dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(day_num `a')
	randcmdc ((`var') xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (younger==1), fe  cluster(uid)), groupvar(game_num) treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice {
	global i = $i + 1
	local a = "dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(day_num `a')
	randcmdc ((`var') xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (older==1), fe  cluster(uid)), groupvar(game_num) treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice {
	global i = $i + 1
	local a = "dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(day_num `a')
	randcmdc ((`var') xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (secondary==1), fe  cluster(uid)), groupvar(game_num) treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice {
	global i = $i + 1
	local a = "dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(day_num `a')
	randcmdc ((`var') xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (gss2pos==1), fe  cluster(uid)), groupvar(game_num) treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice {
	global i = $i + 1
	local a = "dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(day_num `a')
	randcmdc ((`var') xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (saves_bank==1), fe  cluster(uid)), groupvar(game_num) treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

*Table 8 - one column dropped because could not reproduce

foreach var in dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice {
	global i = $i + 1
	local a = "dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(day_num `a')
	randcmdc ((`var') xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (jlgame==1), fe  cluster(uid)), groupvar(game_num) treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice {
	global i = $i + 1
	local a = "dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(day_num `a')
	randcmdc ((`var') xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice safewithrisky riskywithsafe round1 round3-round6 if (jlgame==1 ), fe  cluster(uid)), groupvar(game_num) treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice {
	global i = $i + 1
	local a = "dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(day_num `a')
	randcmdc ((`var') xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (jlgame==1 & theta1==1), fe  cluster(uid)), groupvar(game_num) treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice {
	global i = $i + 1
	local a = "dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(day_num `a')
	randcmdc ((`var') xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (jlgame==1 & theta1==0 & theta3==0 ), fe  cluster(uid)), groupvar(game_num) treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice {
	global i = $i + 1
	local a = "dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(day_num `a')
	randcmdc ((`var') xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (jlgame==1 & theta3==1), fe  cluster(uid)), groupvar(game_num) treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}


*Table 9 
	forvalues j = 1/48 {
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
save results\FisherCondGJKM, replace





