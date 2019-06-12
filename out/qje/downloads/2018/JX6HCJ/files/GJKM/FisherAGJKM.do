****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) fe i(string) vce(string) robust baseoutcome(string)]
	gettoken testvars anything: anything, match(match)
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
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$i,1] = r(p), $k-r(df), e(df_r), $k
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

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string) fe i(string) vce(string) robust baseoutcome(string)]
	gettoken testvars anything: anything, match(match)
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
		capture testparm `testvars'
		if (_rc == 0) {
			matrix FF[$i,1] = r(p), $k-r(df), e(df_r)
			local i = 0
			if ("`baseoutcome'" == "") {
				foreach var in `testvars' {
					matrix BB[$j+`i',1] = _b[`var'], _se[`var']
					local i = `i' + 1
					}
				}
			else {
				foreach var in `testvars' {
					matrix BB[$j+`i',1] = _b[1:`var'], _se[1:`var']
					local i = `i' + 1
					matrix BB[$j+`i',1] = _b[2:`var'], _se[2:`var']
					local i = `i' + 1
					}
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

bysort day_num game_num: gen nn = _n
sort nn day_num game_num
gen Order = _n
gen double U = .
global N = 289
mata Y = st_data((1,$N),"game_type")

*Paper says explicitly randomized games within days, so treat day_num as strata
*Clear did not randomize overall, because different games played at different times (tab day_num game_type)

mata ResF = J($reps,32,.); ResD = J($reps,32,.); ResDF = J($reps,32,.); ResB = J($reps,214,.); ResSE = J($reps,214,.)
forvalues c = 1/$reps {
	matrix FF = J(32,3,.)
	matrix BB = J(214,2,.)

	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort day_num U in 1/$N
	mata st_store((1,$N),("game_type"),Y)
	sort day_num game_num nn
	quietly replace game_type = game_type[_n-1] if nn > 1

foreach var in dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice {
	quietly replace `var' = 0
	}
quietly replace dynamic = 1 if (game_type == 2 | game_type == 4 | game_type == 6 | game_type == 11 | game_type == 12)
quietly replace jlgame = 1 if game_type >= 3 & game_type <= 12
quietly replace monitor = 1 if game_type >= 5 & game_type <= 12
quietly replace talking = 1 if game_type >= 9 & game_type <= 12
quietly replace ptnrchoice = 1 if (game_type == 10 | game_type == 12)
quietly replace Djlgame = 1 if (game_type == 4 | game_type == 6 | game_type == 11 | game_type == 12)
quietly replace Dmonitor = 1 if (game_type == 6 | game_type == 11 | game_type == 12)
quietly replace Dtalking = 1 if game_type >= 11 & game_type <= 12
quietly replace Dptnrchoice = 1 if game_type == 12

global i = 25
global j = 167

*Table 9 

mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0), baseoutcome(0) cluster(game_num)
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1), baseoutcome(0) cluster(game_num)
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & theta1pair==1), baseoutcome(0) cluster(game_num)
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & theta1pair==1), baseoutcome(0) cluster(game_num)
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & mixedpair==1), baseoutcome(0) cluster(game_num)
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & mixedpair==1), baseoutcome(0) cluster(game_num)
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & riskypair==1), baseoutcome(0) cluster(game_num)
mycmd1 (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & riskypair==1), baseoutcome(0) cluster(game_num)

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..32] = FF[.,1]'; ResD[`c',1..32] = FF[.,2]'; ResDF[`c',1..32] = FF[.,3]'
mata ResB[`c',1..214] = BB[.,1]'; ResSE[`c',1..214] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/32 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/214 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save results\FisherAGJKM, replace






