
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) re]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', cluster(`cluster') `re'
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

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string) re]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	quietly `anything' `if' `in', cluster(`cluster') `re'
	capture testparm `testvars'
	if (_rc == 0) {
		matrix FF[$i,1] = r(p), r(drop), e(df_r)
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************
use DatS, clear

matrix F = J(24,4,.)
matrix B = J(60,2,.)

global i = 1
global j = 1

*Table 5
foreach X in "" "0" {
	mycmd (trocp`X' treatp`X') xtreg prexp trocp`X' treatp`X' oc`X', re cluster(session) 
	}
foreach X in poexp poexp_a {
	mycmd (troca treata) xtreg `X' troca treata oc, re cluster(session)
	}

*Table 6 
foreach X in "" "0" {
	mycmd( trocp`X' treatp`X') xtreg prexp trocp`X' treatp`X' oc`X' if p1 == 1, re cluster(session) 
	}
foreach X in poexp poexp_a {
	mycmd (troca treata) xtreg `X' troca treata oc if p1 == 1, re cluster(session)
	}

*Table 7 
foreach Y in wexp wgap {
	foreach X in "" "0" {
		mycmd (trocp`X' treatp`X') xtreg `Y' trocp`X' treatp`X' oc`X' if p1 == 1, re cluster(session) 
		}
	}

mycmd (troca0 treata0) xtreg investment troca0 treata0 oc if p1==1, re cluster(session)
mycmd (troca treata) xtreg reject troca treata oc if p1==1, re cluster(session)

*Table B4
foreach X in "" "dumneg" {
	mycmd (wgaptr wgaptroc treat troc) xtprobit investment wgaptr wgaptroc treat troc wgap wgapoc dum23 oc `X' if reject==0 & role==2 , re
	}
foreach X in "" "dumneg" {
	mycmd (wgaptr wgaptroc treat troc wexptr wexptroc) xtprobit reject wgaptr wgaptroc treat troc wexptr wexptroc wgap wgapoc oc wexp2 wexpoc dumPC `X' if role==2, re
	}

*Table B5 
foreach Y in wexp wgap {
	foreach X in "" "0" {
		mycmd (trocp`X' treatp`X') xtreg `Y' trocp`X' treatp`X' oc`X', re cluster(session) 
		}
	}
mycmd (troca0 treata0) xtreg investment troca0 treata0 oc, re cluster(session)
mycmd (troca treata) xtreg reject troca treata oc, re cluster(session)

bysort session: gen NN = _n
sort NN session
global N = 5
mata Y = st_data((1,$N),"Treat")
generate Order = _n
generate double U = .

generate P = 0 if period >= 3 & period <= 17
replace P = 1 if period >= 20 & period <= 34

mata ResF = J($reps,24,.); ResD = J($reps,24,.); ResDF = J($reps,24,.); ResB = J($reps,60,.); ResSE = J($reps,60,.)
forvalues c = 1/$reps {
	matrix FF = J(24,3,.)
	matrix BB = J(60,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"Treat",Y)
	sort session NN
	quietly replace Treat = Treat[_n-1] if session == session[_n-1] 
	quietly replace treat = Treat*P + (1-Treat)*(1-P) if treat ~= .

*a and p refer to agent and principal, as in variable role - generally not randomly assigned.

	quietly replace trocp = oc*treat if trocp ~= .
	quietly replace treatp = treat if treatp ~= .
	quietly replace troca = oc*treat if troca ~= .
	quietly replace treata = treat if treata ~= .
	quietly replace trocp0 = oc*treat if trocp0 ~= .
	quietly replace treatp0 = treat if treatp0 ~= .
	quietly replace treata0 = treat if treata0 ~= .
	quietly replace troca0 = oc*treat if troca0 ~= .

	quietly replace troc = treat*oc if troc ~= .
	quietly replace wgaptr = wgap*treat if wgaptr ~= .
	quietly replace wgaptroc = wgap*troc if wgaptroc ~= .
	quietly replace wexptr = wexp2*treat if wexptr ~= .
	quietly replace wexptroc = wexp2*troc if wexptroc ~= .

global i = 1
global j = 1

*Table 5
foreach X in "" "0" {
	mycmd1 (trocp`X' treatp`X') xtreg prexp trocp`X' treatp`X' oc`X', re cluster(session) 
	}
foreach X in poexp poexp_a {
	mycmd1 (troca treata) xtreg `X' troca treata oc, re cluster(session)
	}

*Table 6 
foreach X in "" "0" {
	mycmd1( trocp`X' treatp`X') xtreg prexp trocp`X' treatp`X' oc`X' if p1 == 1, re cluster(session) 
	}
foreach X in poexp poexp_a {
	mycmd1 (troca treata) xtreg `X' troca treata oc if p1 == 1, re cluster(session)
	}

*Table 7 
foreach Y in wexp wgap {
	foreach X in "" "0" {
		mycmd1 (trocp`X' treatp`X') xtreg `Y' trocp`X' treatp`X' oc`X' if p1 == 1, re cluster(session) 
		}
	}

mycmd1 (troca0 treata0) xtreg investment troca0 treata0 oc if p1==1, re cluster(session)
mycmd1 (troca treata) xtreg reject troca treata oc if p1==1, re cluster(session)

*Table B4
foreach X in "" "dumneg" {
	mycmd1 (wgaptr wgaptroc treat troc) xtprobit investment wgaptr wgaptroc treat troc wgap wgapoc dum23 oc `X' if reject==0 & role==2 , re
	}
foreach X in "" "dumneg" {
	mycmd1 (wgaptr wgaptroc treat troc wexptr wexptroc) xtprobit reject wgaptr wgaptroc treat troc wexptr wexptroc wgap wgapoc oc wexp2 wexpoc dumPC `X' if role==2, re
	}

*Table B5 
foreach Y in wexp wgap {
	foreach X in "" "0" {
		mycmd1 (trocp`X' treatp`X') xtreg `Y' trocp`X' treatp`X' oc`X', re cluster(session) 
		}
	}
mycmd1 (troca0 treata0) xtreg investment troca0 treata0 oc, re cluster(session)
mycmd1 (troca treata) xtreg reject troca treata oc, re cluster(session)

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..24] = FF[.,1]'; ResD[`c',1..24] = FF[.,2]'; ResDF[`c',1..24] = FF[.,3]'
mata ResB[`c',1..60] = BB[.,1]'; ResSE[`c',1..60] = BB[.,2]'

}


drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/24 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/60 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save results\FisherS, replace









