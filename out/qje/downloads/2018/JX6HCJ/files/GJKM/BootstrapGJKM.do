
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) fe i(string) vce(string) robust baseoutcome(string)]
	tempvar touse newcluster
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
	gen `touse' = e(sample)
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
		mata BB = st_matrix("B")
		}
	mata ResF = J($reps,4,.); ResB = J($reps,$k,.); ResSE = J($reps,$k,.)
	set seed 1
	forvalues c = 1/$reps {
		if (floor(`c'/50) == `c'/50) display "`c'", _continue
		preserve
			bsample if `touse', cluster($cluster) idcluster(`newcluster')
			quietly xtset `newcluster'
			if ("`fe'" ~= "") {
				capture `anything' `if' `in', `fe' cluster(`newcluster')
				}
			else if ("`baseoutcome'" ~= "") {
				capture `anything' `if' `in', baseoutcome(`baseoutcome') cluster(`newcluster')
				}
			else {
				capture `anything' `if' `in', `robust' cluster(`newcluster')
				}
			if (_rc == 0) {
				if ("`baseoutcome'" == "") {
					capture mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); B = B[1,1..$k]; V = V[1..$k,1..$k]
					}
				else {
					capture matrix V = e(V)
					capture matrix b = e(b)
					capture matrix S = J($k,rowsof(V),0)
					local i = 1
					foreach var in `testvars' {
						capture local q = rownumb(V,"1:`var'")
						capture matrix S[`i',`q'] = 1
						local i = `i' + 1
						capture local q = rownumb(V,"2:`var'")
						capture matrix S[`i',`q'] = 1
						local i = `i' + 1
						}
					capture matrix V = S*V*S'
					capture matrix b = b*S'
					capture mata B = st_matrix("b"); V = st_matrix("V")
					}	
				capture testparm `testvars'
				if (_rc == 0 & r(df) == $k) {
					mata t = (B-BB[1..$k,1]')*invsym(V)*(B'-BB[1..$k,1])
					if (e(df_r) == .) mata ResF[`c',1..3] = `r(p)', chi2tail($k,t[1,1]), $k - `r(df)'
					if (e(df_r) ~= .) mata ResF[`c',1...] = `r(p)', Ftail($k,`e(df_r)',t[1,1]/$k), $k - `r(df)', `e(df_r)'
					mata ResB[`c',1...] = B; ResSE[`c',1...] = sqrt(diagonal(V))'
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

global cluster = "uid"

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

global cluster = "pairid"

*Table 9 

mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0), baseoutcome(0) cluster(pairid)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1), baseoutcome(0) cluster(pairid)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & theta1pair==1), baseoutcome(0) cluster(pairid)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & theta1pair==1), baseoutcome(0) cluster(pairid)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & mixedpair==1), baseoutcome(0) cluster(pairid)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & mixedpair==1), baseoutcome(0) cluster(pairid)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==0 & riskypair==1), baseoutcome(0) cluster(pairid)
mycmd (monitor talking ptnrchoice) mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (jlgame==1 & dynamic==1  & riskypair==1), baseoutcome(0) cluster(pairid)


use ip\BS1, clear
forvalues i = 2/32 {
	merge using ip\BS`i'
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
save results\BootstrapGJKM, replace

