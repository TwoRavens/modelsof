
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")

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
	local i = 0
	foreach var in `newtestvars' {
		matrix B[$j+`i',1] = _b[`var'], _se[`var']
		local i = `i' + 1
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

global j = $j + $k
end

****************************************
****************************************

*Can switch everything to areg for this segment

use DatGJKM, clear

global j = 1
matrix B = J(214,2,.)

*Table 5 
global i = 0
	mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) reg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice, robust cluster(uid)
	mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) areg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (game_type!=19 & game_type!=20), absorb(uid)
	mycmd (jlgame monitor talking ptnrchoice) reg risky jlgame monitor talking ptnrchoice if (dynamic==0), robust cluster(uid)
	mycmd (jlgame monitor talking ptnrchoice) areg risky jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==0), absorb(uid)
	mycmd (jlgame monitor talking ptnrchoice) reg risky jlgame monitor talking ptnrchoice if (dynamic==1), robust cluster(uid)
	mycmd (jlgame monitor talking ptnrchoice) areg risky jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==1), absorb(uid)

quietly suest $M, cluster(uid)
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 5)

*Table 6 
global i = 0
	mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) reg repay dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice , robust cluster(uid)
	mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) areg repay dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 , absorb(uid) 
	mycmd (jlgame monitor talking ptnrchoice) reg repay jlgame monitor talking ptnrchoice if (dynamic==0), robust cluster(uid)
	mycmd (jlgame monitor talking ptnrchoice) areg repay jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==0), absorb(uid) 
	mycmd (jlgame monitor talking ptnrchoice) reg repay jlgame monitor talking ptnrchoice if (dynamic==1), robust cluster(uid)
	mycmd (jlgame monitor talking ptnrchoice) areg repay jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==1), absorb(uid) 

quietly suest $M, cluster(uid)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)

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

*Table 9 

global i = 1
mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0), baseoutcome(0) 
		estimates store M$i
		global i = $i + 1

mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1), baseoutcome(0) 
		estimates store M$i
		global i = $i + 1

mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & theta1pair==1), baseoutcome(0) 
		estimates store M$i
		global i = $i + 1

mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & theta1pair==1), baseoutcome(0) 
		estimates store M$i
		global i = $i + 1

mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & mixedpair==1), baseoutcome(0) 
		estimates store M$i
		global i = $i + 1

mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & mixedpair==1), baseoutcome(0) 
		estimates store M$i
		global i = $i + 1

mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & riskypair==1), baseoutcome(0) 
		estimates store M$i
		global i = $i + 1

mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & riskypair==1), baseoutcome(0) 
		estimates store M$i
		global i = $i + 1

quietly suest M1 M2 M3 M4 M5 M6 M7 M8, cluster(pairid)
test [M1_1]monitor [M1_2]monitor [M1_1]talking [M1_2]talking [M1_1]ptnrchoice [M1_2]ptnrchoice [M2_1]monitor [M2_2]monitor [M2_1]talking [M2_2]talking [M2_1]ptnrchoice [M2_2]ptnrchoice [M3_1]monitor [M3_2]monitor [M3_1]talking [M3_2]talking [M3_1]ptnrchoice [M3_2]ptnrchoice [M4_1]monitor [M4_2]monitor [M4_1]talking [M4_2]talking [M4_1]ptnrchoice [M4_2]ptnrchoice [M5_1]monitor [M5_2]monitor [M5_1]talking [M5_2]talking [M5_1]ptnrchoice [M5_2]ptnrchoice [M6_1]monitor [M6_2]monitor [M6_1]talking [M6_2]talking [M6_1]ptnrchoice [M6_2]ptnrchoice [M7_1]monitor [M7_2]monitor [M7_1]talking [M7_2]talking [M7_1]ptnrchoice [M7_2]ptnrchoice [M8_1]monitor [M8_2]monitor [M8_1]talking [M8_2]talking [M8_1]ptnrchoice [M8_2]ptnrchoice 
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 9)

drop _all
svmat double F
svmat double B
save results/SuestGJKM, replace






