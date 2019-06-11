
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) re ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', `re'
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string) re ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', `re'
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end


****************************************
****************************************

global b = 60

use DatS, clear

matrix B = J($b,1,.)

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

egen M = group(session)
sum M
global reps = r(max)

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"
preserve

drop if M == `c'

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

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 1/$b {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
svmat double B
gen N = _n
save results\OJackknifeS, replace


