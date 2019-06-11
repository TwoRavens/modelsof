
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) fe i(string) vce(string) robust baseoutcome(string)]
	gettoken testvars anything: anything, match(match)
	unab testvars: `testvars'
	global k = wordcount("`testvars'")
	if ("`baseoutcome'" ~= "") global k = 2*$k	
	if ("`fe'" ~= "") {
		`anything' `if' `in', `fe' i(`i') vce(`vce')
		}
	else if ("`baseoutcome'" ~= "") {
		`anything' `if' `in', baseoutcome(`baseoutcome') cluster(`cluster')
		}
	else {
		`anything' `if' `in', `robust' cluster(`cluster')
		}
	if (_rc == 0) { 
		if ("`baseoutcome'" == "") {
			local i = 0
			foreach var in `testvars' {
				matrix B[$j+`i',1] = _b[`var']
				local i = `i' + 1
				}
			}
		else {
			local i = 0
			foreach var in `testvars' {
				matrix B[$j+`i',1] = [1]_b[`var']
				local i = `i' + 1
				matrix B[$j+`i',1] = [2]_b[`var']
				local i = `i' + 1
				}
			}
		}
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string) fe i(string) vce(string) robust baseoutcome(string)]
	gettoken testvars anything: anything, match(match)
	unab testvars: `testvars'
	global k = wordcount("`testvars'")
	if ("`baseoutcome'" ~= "") global k = 2*$k	
	if ("`fe'" ~= "") {
		capture `anything' `if' `in', `fe' i(`i') vce(`vce')
		}
	else if ("`baseoutcome'" ~= "") {
		capture `anything' `if' `in', baseoutcome(`baseoutcome') cluster(`cluster')
		}
	else {
		capture `anything' `if' `in', `robust' cluster(`cluster')
		}
	if (_rc == 0) { 
		if ("`baseoutcome'" == "") {
			local i = 0
			foreach var in `testvars' {
				matrix BB[$j+`i',1] = _b[`var']
				local i = `i' + 1
				}
			}
		else {
			local i = 0
			foreach var in `testvars' {
				matrix BB[$j+`i',1] = [1]_b[`var']
				local i = `i' + 1
				matrix BB[$j+`i',1] = [2]_b[`var']
				local i = `i' + 1
				}
			}
		}
global j = $j + $k
end

****************************************
****************************************

global b = 214

use DatGJKM, clear

matrix B = J($b,1,.)

global j = 1

*Table 5 

mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) reg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice, robust cluster(uid)
mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (game_type!=19 & game_type!=20), fe i(uid) vce(cluster uid)
mycmd (jlgame monitor talking ptnrchoice) reg risky jlgame monitor talking ptnrchoice if (dynamic==0), robust cluster(uid)
mycmd (jlgame monitor talking ptnrchoice) xtreg risky jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==0), fe i(uid) vce(cluster uid)
mycmd (jlgame monitor talking ptnrchoice) reg risky jlgame monitor talking ptnrchoice if (dynamic==1), robust cluster(uid)
mycmd (jlgame monitor talking ptnrchoice) xtreg risky jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==1), fe i(uid) vce(cluster uid)

*Table 6 

mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) reg repay dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice , robust cluster(uid)
mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg repay dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 , fe i(uid) vce(cluster uid)
mycmd (jlgame monitor talking ptnrchoice) reg repay jlgame monitor talking ptnrchoice if (dynamic==0), robust cluster(uid)
mycmd (jlgame monitor talking ptnrchoice) xtreg repay jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==0), fe i(uid) vce(cluster uid)
mycmd (jlgame monitor talking ptnrchoice) reg repay jlgame monitor talking ptnrchoice if (dynamic==1), robust cluster(uid)
mycmd (jlgame monitor talking ptnrchoice) xtreg repay jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==1), fe i(uid) vce(cluster uid)

*Table 7 

mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 , fe i(uid) vce(cluster uid)
mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (female==1), fe i(uid) vce(cluster uid)
mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (younger==1), fe i(uid) vce(cluster uid)
mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (older==1), fe i(uid) vce(cluster uid)
mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (secondary==1), fe i(uid) vce(cluster uid)
mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (gss2pos==1), fe i(uid) vce(cluster uid)
mycmd (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (saves_bank==1), fe i(uid) vce(cluster uid)

*Table 8 - one column dropped because could not reproduce

mycmd (dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (jlgame==1), fe i(uid) vce(cluster uid)
mycmd (dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice safewithrisky riskywithsafe round1 round3-round6 if (jlgame==1 ), fe i(uid) vce(cluster uid)
mycmd (dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (jlgame==1 & theta1==1), fe i(uid) vce(cluster uid)
mycmd (dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (jlgame==1 & theta1==0 & theta3==0 ), fe i(uid) vce(cluster uid)
mycmd (dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (jlgame==1 & theta3==1), fe i(uid) vce(cluster uid)

*Table 9 

mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0), baseoutcome(0) cluster(pairid)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1), baseoutcome(0) cluster(pairid)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & theta1pair==1), baseoutcome(0) cluster(pairid)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & theta1pair==1), baseoutcome(0) cluster(pairid)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & mixedpair==1), baseoutcome(0) cluster(pairid)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & mixedpair==1), baseoutcome(0) cluster(pairid)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & riskypair==1), baseoutcome(0) cluster(pairid)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & riskypair==1), baseoutcome(0) cluster(pairid)

egen M = group(uid)
sum M
global reps2 = r(max)

egen MM = group(pairid)
sum MM
global reps = r(max)

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

global j = 1

if (`c' <= $reps2) {
preserve

drop if M == `c'

*Table 5 

mycmd1 (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) reg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice, robust cluster(uid)
mycmd1 (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (game_type!=19 & game_type!=20), fe i(uid) vce(cluster uid)
mycmd1 (jlgame monitor talking ptnrchoice) reg risky jlgame monitor talking ptnrchoice if (dynamic==0), robust cluster(uid)
mycmd1 (jlgame monitor talking ptnrchoice) xtreg risky jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==0), fe i(uid) vce(cluster uid)
mycmd1 (jlgame monitor talking ptnrchoice) reg risky jlgame monitor talking ptnrchoice if (dynamic==1), robust cluster(uid)
mycmd1 (jlgame monitor talking ptnrchoice) xtreg risky jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==1), fe i(uid) vce(cluster uid)

*Table 6 

mycmd1 (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) reg repay dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice , robust cluster(uid)
mycmd1 (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg repay dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 , fe i(uid) vce(cluster uid)
mycmd1 (jlgame monitor talking ptnrchoice) reg repay jlgame monitor talking ptnrchoice if (dynamic==0), robust cluster(uid)
mycmd1 (jlgame monitor talking ptnrchoice) xtreg repay jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==0), fe i(uid) vce(cluster uid)
mycmd1 (jlgame monitor talking ptnrchoice) reg repay jlgame monitor talking ptnrchoice if (dynamic==1), robust cluster(uid)
mycmd1 (jlgame monitor talking ptnrchoice) xtreg repay jlgame monitor talking ptnrchoice round1 round3-round6 if (dynamic==1), fe i(uid) vce(cluster uid)

*Table 7 

mycmd1 (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 , fe i(uid) vce(cluster uid)
mycmd1 (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (female==1), fe i(uid) vce(cluster uid)
mycmd1 (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (younger==1), fe i(uid) vce(cluster uid)
mycmd1 (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (older==1), fe i(uid) vce(cluster uid)
mycmd1 (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (secondary==1), fe i(uid) vce(cluster uid)
mycmd1 (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (gss2pos==1), fe i(uid) vce(cluster uid)
mycmd1 (dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (saves_bank==1), fe i(uid) vce(cluster uid)

*Table 8 - one column dropped because could not reproduce

mycmd1 (dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (jlgame==1), fe i(uid) vce(cluster uid)
mycmd1 (dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice safewithrisky riskywithsafe round1 round3-round6 if (jlgame==1 ), fe i(uid) vce(cluster uid)
mycmd1 (dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (jlgame==1 & theta1==1), fe i(uid) vce(cluster uid)
mycmd1 (dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (jlgame==1 & theta1==0 & theta3==0 ), fe i(uid) vce(cluster uid)
mycmd1 (dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice) xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (jlgame==1 & theta3==1), fe i(uid) vce(cluster uid)
restore
}

global j = 167

preserve

drop if MM == `c'

*Table 9 

mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0), baseoutcome(0) cluster(pairid)
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1), baseoutcome(0) cluster(pairid)
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & theta1pair==1), baseoutcome(0) cluster(pairid)
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & theta1pair==1), baseoutcome(0) cluster(pairid)
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & mixedpair==1), baseoutcome(0) cluster(pairid)
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & mixedpair==1), baseoutcome(0) cluster(pairid)
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & riskypair==1), baseoutcome(0) cluster(pairid)
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & riskypair==1), baseoutcome(0) cluster(pairid)

restore

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

}

drop _all
set obs $reps
forvalues i = 1/$b {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
svmat double B
gen N = _n
save results\OJackknifeGJKM, replace



