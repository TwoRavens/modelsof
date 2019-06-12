
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

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	quietly `anything' `if' `in', cluster(`cluster') `robust'
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
generate N = _n
sort Strata N
generate Order = _n
generate double U = .
mata Y = st_data(.,("any","tinc","tincs"))

mata ResF = J($reps,18,.); ResD = J($reps,18,.); ResDF = J($reps,18,.); ResB = J($reps,70,.); ResSE = J($reps,70,.)
forvalues c = 1/$reps {
	matrix FF = J(18,3,.)
	matrix BB = J(70,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() 
	sort Strata U 
	mata st_store(.,("any","tinc","tincs"),Y)

	quietly replace any_never = any*never
	quietly replace male_any = male*any
	quietly replace over_any = over*any
	quietly replace hiv_any = hiv2004*any
	quietly replace any_male = any*male
	quietly replace tinc_male = tinc*male
	quietly replace tincs_male = tincs*male
	quietly replace any_male_hiv = any*male*hiv2004
	quietly replace tinc_male_hiv = tinc*male*hiv2004
	quietly replace tincs_male_hiv = tincs*male*hiv2004
	quietly replace any_hiv2004 = any*hiv2004
	quietly replace tinc_hiv2004 = tinc*hiv2004
	quietly replace tincs_hiv2004 = tincs*hiv2004

global i = 1
global j = 1

*Table 4
mycmd1 (any) reg got any male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd1 (any tinc) reg got any tinc male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd1 (any tinc tincs) reg got any tinc tincs male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd1 (any tinc tincs) reg got any tinc tincs distvct distvcts simave male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd1 (any tinc tincs) reg got any tinc tincs over simave male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd1 (any) probit got any male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd1 (any tinc) probit got any tinc male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd1 (any tinc tincs) probit got any tinc tincs male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd1 (any tinc tincs) probit got any tinc tincs distvct distvcts simave male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd1 (any tinc tincs) probit got any tinc tincs over simave male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 

*Table 5 
mycmd1 (any tinc tincs) reg got any tinc tincs male hiv2004 over tb thinktreat mar simave rumphi balaka if MainSample == 1, robust cluster(villnum)
mycmd1 (any tinc tincs any_never) reg got any tinc tincs any_never male hiv2004 over simave never rumphi balaka if mar==0 & MainSample == 1, robust cluster(villnum)
mycmd1 (any tinc tincs male_any) reg got any tinc tincs male_any male hiv2004 over simave if balaka== 1 & MainSample == 1, robust cluster(villnum)
mycmd1 (any tinc tincs over_any) reg got any tinc tincs over_any over hiv2004 age male age2 simav rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd1 (any tinc tincs) reg got any tinc tincs over over_hiv hiv2004 age male age2 simav rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd1 (any tinc tincs hiv_any) reg got any tinc tincs hiv_any over hiv2004 age male age2 simav rumphi balaka if MainSample == 1, robust cluster(villnum) 

*Table 6
mycmd1 (any tinc tincs any_male tinc_male tincs_male any_male_hiv tinc_male_hiv tincs_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004) reg got any tinc tincs any_male tinc_male tincs_male any_male_hiv tinc_male_hiv tincs_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004 distvct distvcts distvct_male distvcts_male distvct_male_hiv distvcts_male_hiv distvct_hiv2004 distvcts_hiv2004 hiv2004 male age age2 simave rumphi  if MainSample == 1 & followupsu == 1 & hadsex12==1, robust cluster(villnum)
mycmd1 (any tinc tincs any_male tinc_male tincs_male any_male_hiv tinc_male_hiv tincs_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004) reg hiv_got any tinc tincs any_male tinc_male tincs_male any_male_hiv tinc_male_hiv tincs_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004 distvct distvcts distvct_male distvcts_male distvct_male_hiv distvcts_male_hiv distvct_hiv2004 distvcts_hiv2004 hiv2004 male age age2 simave rumphi if MainSample == 1 & followupsu == 1 & hadsex12==1, robust cluster(villnum)

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..18] = FF[.,1]'; ResD[`c',1..18] = FF[.,2]'; ResDF[`c',1..18] = FF[.,3]'
mata ResB[`c',1..70] = BB[.,1]'; ResSE[`c',1..70] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/18 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/70 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save results\FisherT, replace


