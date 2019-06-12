
use DatT, clear

*Table 4

global i = 1

reg got any male hiv2004 age age2 rumphi balaka if MainSample == 1,  
	estimates store M$i
	global i = $i + 1

reg got any tinc male hiv2004 age age2 rumphi balaka if MainSample == 1,  
	estimates store M$i
	global i = $i + 1

reg got any tinc tincs male hiv2004 age age2 rumphi balaka if MainSample == 1,  
	estimates store M$i
	global i = $i + 1

reg got any tinc tincs distvct distvcts simave male hiv2004 age age2 rumphi balaka if MainSample == 1,  
	estimates store M$i
	global i = $i + 1

reg got any tinc tincs over simave male hiv2004 age age2 rumphi balaka if MainSample == 1,  
	estimates store M$i
	global i = $i + 1

probit got any male hiv2004 age age2 rumphi balaka if MainSample == 1,  
	estimates store M$i
	global i = $i + 1

probit got any tinc male hiv2004 age age2 rumphi balaka if MainSample == 1,  
	estimates store M$i
	global i = $i + 1

probit got any tinc tincs male hiv2004 age age2 rumphi balaka if MainSample == 1,  
	estimates store M$i
	global i = $i + 1

probit got any tinc tincs distvct distvcts simave male hiv2004 age age2 rumphi balaka if MainSample == 1,  
	estimates store M$i
	global i = $i + 1

probit got any tinc tincs over simave male hiv2004 age age2 rumphi balaka if MainSample == 1,  
	estimates store M$i
	global i = $i + 1

suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10, cluster(villnum)
test any tinc tincs
matrix F = (r(p), r(drop), r(df), r(chi2), 4)


*Table 5 

global i = 1

reg got any tinc tincs male hiv2004 over tb thinktreat mar simave rumphi balaka if MainSample == 1, 
	estimates store M$i
	global i = $i + 1

reg got any tinc tincs any_never male hiv2004 over simave never rumphi balaka if mar==0 & MainSample == 1, 
	estimates store M$i
	global i = $i + 1

reg got any tinc tincs male_any male hiv2004 over simave if balaka== 1 & MainSample == 1, 
	estimates store M$i
	global i = $i + 1

reg got any tinc tincs over_any over hiv2004 age male age2 simav rumphi balaka if MainSample == 1,  
	estimates store M$i
	global i = $i + 1

reg got any tinc tincs over over_hiv hiv2004 age male age2 simav rumphi balaka if MainSample == 1,  
	estimates store M$i
	global i = $i + 1

reg got any tinc tincs hiv_any over hiv2004 age male age2 simav rumphi balaka if MainSample == 1,  
	estimates store M$i
	global i = $i + 1


suest M1 M2 M3 M4 M5 M6, cluster(villnum)
test any tinc tincs any_never male_any over_any hiv_any
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)


*Table 6

global i = 1

reg got any tinc tincs any_male tinc_male tincs_male any_male_hiv tinc_male_hiv tincs_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004 distvct distvcts distvct_male distvcts_male distvct_male_hiv distvcts_male_hiv distvct_hiv2004 distvcts_hiv2004 hiv2004 male age age2 simave rumphi  if MainSample == 1 & followupsu == 1 & hadsex12==1, 
	estimates store M$i
	global i = $i + 1

reg hiv_got any tinc tincs any_male tinc_male tincs_male any_male_hiv tinc_male_hiv tincs_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004 distvct distvcts distvct_male distvcts_male distvct_male_hiv distvcts_male_hiv distvct_hiv2004 distvcts_hiv2004 hiv2004 male age age2 simave rumphi if MainSample == 1 & followupsu == 1 & hadsex12==1, 
	estimates store M$i
	global i = $i + 1


suest M1 M2, cluster(villnum)
test any tinc tincs any_male tinc_male tincs_male any_male_hiv tinc_male_hiv tincs_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)

egen Strata = group(rumphi), label
generate N = _n
sort Strata N
generate Order = _n
generate double U = .
mata Y = st_data(.,("any","tinc","tincs"))

mata ResF = J($reps,15,.)
forvalues c = 1/$reps {
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

*Table 4

global i = 1

quietly reg got any male hiv2004 age age2 rumphi balaka if MainSample == 1,  
	estimates store M$i
	global i = $i + 1

quietly reg got any tinc male hiv2004 age age2 rumphi balaka if MainSample == 1,  
	estimates store M$i
	global i = $i + 1

quietly reg got any tinc tincs male hiv2004 age age2 rumphi balaka if MainSample == 1,  
	estimates store M$i
	global i = $i + 1

quietly reg got any tinc tincs distvct distvcts simave male hiv2004 age age2 rumphi balaka if MainSample == 1,  
	estimates store M$i
	global i = $i + 1

quietly reg got any tinc tincs over simave male hiv2004 age age2 rumphi balaka if MainSample == 1,  
	estimates store M$i
	global i = $i + 1

quietly probit got any male hiv2004 age age2 rumphi balaka if MainSample == 1,  
	estimates store M$i
	global i = $i + 1

quietly probit got any tinc male hiv2004 age age2 rumphi balaka if MainSample == 1,  
	estimates store M$i
	global i = $i + 1

quietly probit got any tinc tincs male hiv2004 age age2 rumphi balaka if MainSample == 1,  
	estimates store M$i
	global i = $i + 1

quietly probit got any tinc tincs distvct distvcts simave male hiv2004 age age2 rumphi balaka if MainSample == 1,  
	estimates store M$i
	global i = $i + 1

quietly probit got any tinc tincs over simave male hiv2004 age age2 rumphi balaka if MainSample == 1,  
	estimates store M$i
	global i = $i + 1

capture suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10, cluster(villnum)
if (_rc == 0) {
	capture test any tinc tincs
		if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 4)
		}
	}


*Table 5 

global i = 1

quietly reg got any tinc tincs male hiv2004 over tb thinktreat mar simave rumphi balaka if MainSample == 1, 
	estimates store M$i
	global i = $i + 1

quietly reg got any tinc tincs any_never male hiv2004 over simave never rumphi balaka if mar==0 & MainSample == 1, 
	estimates store M$i
	global i = $i + 1

quietly reg got any tinc tincs male_any male hiv2004 over simave if balaka== 1 & MainSample == 1, 
	estimates store M$i
	global i = $i + 1

quietly reg got any tinc tincs over_any over hiv2004 age male age2 simav rumphi balaka if MainSample == 1,  
	estimates store M$i
	global i = $i + 1

quietly reg got any tinc tincs over over_hiv hiv2004 age male age2 simav rumphi balaka if MainSample == 1,  
	estimates store M$i
	global i = $i + 1

quietly reg got any tinc tincs hiv_any over hiv2004 age male age2 simav rumphi balaka if MainSample == 1,  
	estimates store M$i
	global i = $i + 1


capture suest M1 M2 M3 M4 M5 M6, cluster(villnum)
if (_rc == 0) {
	capture test any tinc tincs any_never male_any over_any hiv_any
	if (_rc == 0) {
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 5)
		}
	}


*Table 6

global i = 1

quietly reg got any tinc tincs any_male tinc_male tincs_male any_male_hiv tinc_male_hiv tincs_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004 distvct distvcts distvct_male distvcts_male distvct_male_hiv distvcts_male_hiv distvct_hiv2004 distvcts_hiv2004 hiv2004 male age age2 simave rumphi  if MainSample == 1 & followupsu == 1 & hadsex12==1, 
	estimates store M$i
	global i = $i + 1

quietly reg hiv_got any tinc tincs any_male tinc_male tincs_male any_male_hiv tinc_male_hiv tincs_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004 distvct distvcts distvct_male distvcts_male distvct_male_hiv distvcts_male_hiv distvct_hiv2004 distvcts_hiv2004 hiv2004 male age age2 simave rumphi if MainSample == 1 & followupsu == 1 & hadsex12==1, 
	estimates store M$i
	global i = $i + 1


capture suest M1 M2, cluster(villnum)
if (_rc == 0) {
	capture test any tinc tincs any_male tinc_male tincs_male any_male_hiv tinc_male_hiv tincs_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004
	if (_rc == 0) {
		mata ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 6)
		}
	}

}

drop _all
set obs $reps
forvalues i = 1/15 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save results\FisherSuestT, replace


