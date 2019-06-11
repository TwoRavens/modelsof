
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust]
	tempvar touse newcluster
	gettoken testvars anything: anything, match(match)
	`anything' `if' `in', cluster(`cluster') `robust'
	testparm `testvars'
	global k = r(df)
	gen `touse' = e(sample)
	mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); V = sqrt(diagonal(V)); BB = B[1,1..$k]',V[1..$k,1]; st_matrix("B",BB)
	mata ResF = J($reps,4,.); ResB = J($reps,$k,.); ResSE = J($reps,$k,.)
	set seed 1
	forvalues i = 1/$reps {
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		preserve
			if ("$cluster" ~= "") {
				bsample if `touse', cluster($cluster) idcluster(`newcluster')
				capture `anything', cluster(`newcluster') `robust'
				}
			else {
				bsample if `touse' 
				capture `anything', `robust'
				}
			if (_rc == 0) {
			capture mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); B = B[1,1..$k]; V = V[1..$k,1..$k]
			capture testparm `testvars'
			if (_rc == 0 & r(df) == $k) {
				mata t = (B-BB[1..$k,1]')*invsym(V)*(B'-BB[1..$k,1])
				if (e(df_r) == .) mata ResF[`i',1..3] = `r(p)', chi2tail($k,t[1,1]), $k - `r(df)'
				if (e(df_r) ~= .) mata ResF[`i',1...] = `r(p)', Ftail($k,`e(df_r)',t[1,1]/$k), $k - `r(df)', `e(df_r)'
				mata ResB[`i',1...] = B; ResSE[`i',1...] = sqrt(diagonal(V))'
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

global cluster = "villnum"

use DatT, clear

global i = 1
global j = 1

*Table 4
mycmd (any) reg got any male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc) reg got any tinc male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc tincs) reg got any tinc tincs male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc tincs) reg got any tinc tincs distvct distvcts simave male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc tincs) reg got any tinc tincs over simave male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any) probit got any male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc) probit got any tinc male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc tincs) probit got any tinc tincs male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc tincs) probit got any tinc tincs distvct distvcts simave male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc tincs) probit got any tinc tincs over simave male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 

*Table 5 
mycmd (any tinc tincs) reg got any tinc tincs male hiv2004 over tb thinktreat mar simave rumphi balaka if MainSample == 1, robust cluster(villnum)
mycmd (any tinc tincs any_never) reg got any tinc tincs any_never male hiv2004 over simave never rumphi balaka if mar==0 & MainSample == 1, robust cluster(villnum)
mycmd (any tinc tincs male_any) reg got any tinc tincs male_any male hiv2004 over simave if balaka== 1 & MainSample == 1, robust cluster(villnum)
mycmd (any tinc tincs over_any) reg got any tinc tincs over_any over hiv2004 age male age2 simav rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc tincs) reg got any tinc tincs over over_hiv hiv2004 age male age2 simav rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc tincs hiv_any) reg got any tinc tincs hiv_any over hiv2004 age male age2 simav rumphi balaka if MainSample == 1, robust cluster(villnum) 

*Table 6
mycmd (any tinc tincs any_male tinc_male tincs_male any_male_hiv tinc_male_hiv tincs_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004) reg got any tinc tincs any_male tinc_male tincs_male any_male_hiv tinc_male_hiv tincs_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004 distvct distvcts distvct_male distvcts_male distvct_male_hiv distvcts_male_hiv distvct_hiv2004 distvcts_hiv2004 hiv2004 male age age2 simave rumphi  if MainSample == 1 & followupsu == 1 & hadsex12==1, robust cluster(villnum)
mycmd (any tinc tincs any_male tinc_male tincs_male any_male_hiv tinc_male_hiv tincs_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004) reg hiv_got any tinc tincs any_male tinc_male tincs_male any_male_hiv tinc_male_hiv tincs_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004 distvct distvcts distvct_male distvcts_male distvct_male_hiv distvcts_male_hiv distvct_hiv2004 distvcts_hiv2004 hiv2004 male age age2 simave rumphi if MainSample == 1 & followupsu == 1 & hadsex12==1, robust cluster(villnum)

use ip\BS1, clear
forvalues i = 2/18 {
	merge using ip\BS`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/18 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\BootstrapT, replace

