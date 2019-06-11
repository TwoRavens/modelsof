*at level of treatment (actually, probably should do day_num/sessions, which is above game_num/treatment, but want this to be analogous to randomization test)

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) fe i(string) vce(string) robust baseoutcome(string)]
	gettoken testvars anything: anything, match(match)
	unab testvars: `testvars'
	if ("`fe'" ~= "") {
		`anything' `if' `in', `fe' i(`i') vce(`vce')
		}
	else if ("`baseoutcome'" ~= "") {
		`anything' `if' `in', baseoutcome(`baseoutcome') cluster(`cluster')
		}
	else {
		`anything' `if' `in', `robust' cluster(`cluster')
		}
	testparm `testvars'
	global k = r(df)
	if ("`baseoutcome'" == "") {
		mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); V = sqrt(diagonal(V)); BB = B[1,1..$k]',V[1..$k,1]; st_matrix("B",BB)
		}
	else {
		matrix B = J($k,2,.)
		local i = 1
		foreach var in `testvars' {
			matrix B[`i',1] = [1]_b[`var'], [1]_se[`var']
			local i = `i' + 1
			matrix B[`i',1] = [2]_b[`var'], [2]_se[`var']
			local i = `i' + 1
			}
		}
preserve
	keep if e(sample)
	if ("$cluster" ~= "") egen M = group($cluster)
	if ("$cluster" == "") gen M = _n
	quietly sum M
	global N = r(max)
	mata ResB = J($N,$k,.); ResSE = J($N,$k,.); ResF = J($N,3,.)
	forvalues j = 1/$N {
		if (floor(`j'/50) == `j'/50) display "`j'", _continue
		if ("`fe'" ~= "") {
			quietly `anything' if M ~= `j', `fe' i(`i') vce(`vce')
			}
		else if ("`baseoutcome'" ~= "") {
			quietly `anything' if M ~= `j', baseoutcome(`baseoutcome') cluster(`cluster')
			}
		else {
			quietly `anything' if M ~= `j', `robust' cluster(`cluster')
			}
		matrix BB = J($k,2,.)
		if ("`baseoutcome'" == "") {
			matrix BB = J($k,2,.)
			local c = 1
			foreach var in `testvars' {
				capture matrix BB[`c',1] = _b[`var'], _se[`var']
				local c = `c' + 1
				}
			}
		else {
			matrix BB = J($k,2,.)
			local c = 1
			foreach var in `testvars' {
				matrix BB[`c',1] = [1]_b[`var'], [1]_se[`var']
				local c = `c' + 1
				matrix BB[`c',1] = [2]_b[`var'], [2]_se[`var']
				local c = `c' + 1
				}
			}
		matrix F = J(1,3,.)
		capture testparm `testvars'
		if (_rc == 0) matrix F = r(p), $k-r(df), e(df_r)
		mata BB = st_matrix("BB"); F = st_matrix("F"); ResB[`j',1..$k] = BB[1..$k,1]'; ResSE[`j',1..$k] = BB[1..$k,2]'; ResF[`j',1..3] = F
		}
	quietly drop _all
	quietly set obs $N
	global kk = $j + $k - 1
	forvalues i = $j/$kk {
		quietly generate double ResB`i' = .
		}
	forvalues i = $j/$kk {
		quietly generate double ResSE`i' = .
		}
	quietly generate double ResF$i = .
	quietly generate double ResD$i = .
	quietly generate double ResDF$i = .
	mata X = ResB, ResSE, ResF; st_store(.,.,X)
	quietly svmat double B
	quietly rename B2 SE$i
	capture rename B1 B$i
	save ip\AJK$i, replace
restore
	global i = $i + 1
	global j = $j + $k
end



*******************

global cluster = "game_num"

global i = 1
global j = 1

use DatGJKM, clear

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

mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0), baseoutcome(0) cluster(game_num)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1), baseoutcome(0) cluster(game_num)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & theta1pair==1), baseoutcome(0) cluster(game_num)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & theta1pair==1), baseoutcome(0) cluster(game_num)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & mixedpair==1), baseoutcome(0) cluster(game_num)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & mixedpair==1), baseoutcome(0) cluster(game_num)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & riskypair==1), baseoutcome(0) cluster(game_num)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & riskypair==1), baseoutcome(0) cluster(game_num)

use ip\AJK1, clear
forvalues i = 2/32 {
	merge using ip\AJK`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/32 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\JackKnifeAGJKM, replace


