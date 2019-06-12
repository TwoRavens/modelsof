
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', cluster(`cluster') `robust'
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


use DatT, clear

matrix F = J(18,4,.)
matrix B = J(70,2,.)

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

egen Strata = group(rumphi), label

global treatvars = "any tinc tincs"

global i = 0

*Table 4
global i = $i + 1
	randcmdc ((any) reg got any male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) ), treatvars($treatvars) seed(1) strata(Strata) saving(ip\a$i, replace) reps($reps) sample 

	forvalues j = 1/11 {
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

global i = $i + 1
	randcmdc ((any) probit got any male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) ), treatvars($treatvars) seed(1) strata(Strata) saving(ip\a$i, replace) reps($reps) sample 

	forvalues j = 1/11 {
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

*Table 5 & 6

	forvalues j = 1/46 {
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
save results\FisherCondT, replace




