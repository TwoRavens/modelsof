

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust absorb(string) re]
	gettoken testvars anything: anything, match(match)
	`anything' `if' `in', cluster(`cluster') `robust' `re'
	testparm `testvars'
	global k = r(df)
	unab testvars: `testvars'
	mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); V = sqrt(diagonal(V)); BB = B[1,1..$k]',V[1..$k,1]; st_matrix("B",BB)
preserve
	keep if e(sample)
	if ("$cluster" ~= "") egen M = group($cluster)
	if ("$cluster" == "") gen M = _n
	quietly sum M
	global N = r(max)
	mata ResB = J($N,$k,.); ResSE = J($N,$k,.); ResF = J($N,3,.)
	forvalues i = 1/$N {
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		quietly `anything' if M ~= `i', cluster(`cluster') `robust' `re'
		matrix BB = J($k,2,.)
		local c = 1
		foreach var in `testvars' {
			capture matrix BB[`c',1] = _b[`var'], _se[`var']
			local c = `c' + 1
			}
		matrix F = J(1,3,.)
		capture testparm `testvars'
		if (_rc == 0) matrix F = r(p), r(drop), e(df_r)
		mata BB = st_matrix("BB"); F = st_matrix("F"); ResB[`i',1..$k] = BB[1..$k,1]'; ResSE[`i',1..$k] = BB[1..$k,2]'; ResF[`i',1..3] = F
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
	save ip\JK$i, replace
restore
	global i = $i + 1
	global j = $j + $k
end



*******************


global cluster = "session"

global j = 1
global i = 1

use DatS, clear

*Table 5
foreach X in "" "0" {
	mycmd (trocp`X' treatp`X') xtreg prexp trocp`X' treatp`X' oc`X', re cluster(session) 
	}

foreach X in poexp poexp_a {
	mycmd (troca treata) xtreg `X' troca treata oc, re cluster(session)
	}

*Table 6
foreach X in "" "0" {
	mycmd (trocp`X' treatp`X') xtreg prexp trocp`X' treatp`X' oc`X' if p1 == 1, re cluster(session) 
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

use ip\JK1, clear
forvalues i = 2/24 {
	merge using ip\JK`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/24 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\JackKnifeS, replace


