
use DatFJP, clear

*Table 2
global i = 1
foreach var in taken_new tdeposits {
	reg `var' Treated Treated_Hindu_SC_Kat Treated_muslim Hindu_SC_Kat muslim SEWACENTER2-SEWACENTER4 TMONTH2-TMONTH8 SAMPLINGPHASE2, 
	estimates store M$i
	global i = $i + 1
	}

suest M1 M2, cluster(t_group)
test Treated Treated_Hindu_SC_Kat Treated_muslim
matrix F = (r(p), r(drop), r(df), r(chi2), 2)


*Table 3
global i = 1
foreach var in Dummy_Client_Income Talk_Fam {
	reg `var' Treated Treated_Hindu_SC_Kat Treated_muslim Hindu_SC_Kat muslim SEWACENTER2-SEWACENTER4 TMONTH2-TMONTH8 SAMPLINGPHASE2, 
	estimates store M$i
	global i = $i + 1
	}

suest M1 M2, cluster(t_group)
test Treated Treated_Hindu_SC_Kat Treated_muslim
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 3)

egen Strata = group(sewa_center sampling_phase), label
generate Order = _n
sort Strata Order
generate double U = .
mata Y = st_data(.,"Treated")

mata ResF = J($reps,10,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Strata Order
	quietly replace U = uniform()
	sort Strata U 
	mata st_store(.,"Treated",Y)
	quietly replace Treated_Hindu_SC_Kat = Treated*Hindu_SC_Kat
	quietly replace Treated_muslim = Treated*muslim	

*Table 2
global i = 1
foreach var in taken_new tdeposits {
	quietly reg `var' Treated Treated_Hindu_SC_Kat Treated_muslim Hindu_SC_Kat muslim SEWACENTER2-SEWACENTER4 TMONTH2-TMONTH8 SAMPLINGPHASE2, 
	estimates store M$i
	global i = $i + 1
	}

capture suest M1 M2, cluster(t_group)
if (_rc == 0) {
	capture test Treated Treated_Hindu_SC_Kat Treated_muslim
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 2)
		}
	}


*Table 3
global i = 1
foreach var in Dummy_Client_Income Talk_Fam {
	quietly reg `var' Treated Treated_Hindu_SC_Kat Treated_muslim Hindu_SC_Kat muslim SEWACENTER2-SEWACENTER4 TMONTH2-TMONTH8 SAMPLINGPHASE2, 
	estimates store M$i
	global i = $i + 1
	}

capture suest M1 M2, cluster(t_group)
if (_rc == 0) {
	capture test Treated Treated_Hindu_SC_Kat Treated_muslim
	if (_rc == 0) {
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 3)
		}
	}
}

drop _all
set obs $reps
forvalues i = 1/10 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save results\FisherSuestFJP, replace



