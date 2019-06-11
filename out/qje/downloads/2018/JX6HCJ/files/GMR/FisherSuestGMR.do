
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* 
		capture drop xxx* 
		capture drop Ssample*
		estimates clear
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	if ("`cmd'" == "reg" | "`cmd'" == "areg" | "`cmd'" == "regress") {
		if ("`absorb'" ~= "") quietly areg `dep' `testvars' `anything' `if' `in', absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `testvars' `anything' `if' `in', 
		quietly generate Ssample$i = e(sample)
		if ("`absorb'" ~= "") quietly areg `dep' `anything' if Ssample$i, absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `anything' if Ssample$i, 
		quietly predict double yyy$i if Ssample$i, resid
		local newtestvars = ""
		foreach var in `testvars' {
			if ("`absorb'" ~= "") quietly areg `var' `anything' if Ssample$i, absorb(`absorb')
			if ("`absorb'" == "") quietly reg `var' `anything' if Ssample$i, 
			quietly predict double xxx`var'$i if Ssample$i, resid
			local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
			}
		quietly reg yyy$i `newtestvars', noconstant
		}
	else {
		`cmd' `dep' `testvars' `anything' `if' `in', 
		quietly generate Ssample$i = e(sample)
		local newtestvars = ""
		foreach var in `testvars' {
			quietly generate double xxx`var'$i = `var' if Ssample$i
			local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
			}
		`cmd' `dep' `newtestvars' `anything' `if' `in', 
		}
	estimates store M$i
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

end

****************************************
****************************************

use DatGMR2, clear
sort comuid folio wave
gen SAMPLE2 = 1
save aq, replace

use DatGMR1, clear
gen SAMPLE1 = 1
sort comuid folio wave
merge comuid folio wave using aq
tab _m

gl dep_all ani1 ani2 land vani1 vani2 ha
gl dep_dum ani1 ani2 land
gl dep_cont vani1 vani2 ha
gl dep_me me2 crafts const sewing food repair other
gl dep_all_in ani1 ani2 land vani1 vani2 ha me2 crafts
gl treatcom1 t2_c1_op
gl treatcom2 treatcom
gl basic nbani197 nbani297 ha97
gl controls no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p hhsize97 homeown97 dirtfloor97  electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97
*Extra specifications to get rid of drops 
gl controls1 nbani297 ha97 no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p hhsize97 homeown97 dirtfloor97  electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97
gl controls2 nbani197 ha97 no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p hhsize97 homeown97 dirtfloor97  electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97
gl controls3 nbani197 nbani297 no497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p hhsize97 homeown97 dirtfloor97  electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97
gl controls4 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p hhsize97 homeown97 dirtfloor97  electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97

global i = 0

*Table 2, Panel A1 
foreach x in ani1 ani2 land vani1 vani2 ha {
	mycmd (t2_c1_op) reg `x' t2_c1_op wave3 wave4 $basic $controls if SAMPLE1 == 1, cluster(comuid)
	}

*Table 2, Panel A2 
 	mycmd (t2_c1_op) reg ani1 t2_c1_op wave3 wave4 $controls1 if ani197 ==0 & SAMPLE1 == 1, cluster(comuid)
 	mycmd (t2_c1_op) reg ani2 t2_c1_op wave3 wave4 $controls2 if ani297 ==0 & SAMPLE1 == 1, cluster(comuid)
 	mycmd (t2_c1_op) reg land t2_c1_op wave3 wave4 $controls3 if land97 ==0 & SAMPLE1 == 1, cluster(comuid)

foreach x in vani1 vani2 ha {
	mycmd (t2_c1_op) reg `x' t2_c1_op wave3 wave4 $basic $controls4 if `x'97 >0 & SAMPLE1 == 1, cluster(comuid)
	}

*Table 2 - Panels B1 and C1 
foreach x in ani1 ani2 land vani1 vani2 ha {
	mycmd (t2_c1_op) reg `x' t2_c1_op $basic $controls if wave ==7 & SAMPLE2 == 1, cluster(comuid)
	mycmd (t2_c1_op t2_c1_opwave7) reg `x' t2_c1_op t2_c1_opwave7 wave3 wave4 wave7 $basic $controls if SAMPLE2 == 1, cluster(comuid)
	}

*Table 2 - Panels B2 and C2 
mycmd (t2_c1_op) reg ani1 t2_c1_op $controls1 if wave ==7 & ani197 ==0 & SAMPLE2 == 1, cluster(comuid)
mycmd (t2_c1_op t2_c1_opwave7) reg ani1 t2_c1_op t2_c1_opwave7 wave3 wave4 wave7 $controls1 if ani197 ==0 & SAMPLE2 == 1, cluster(comuid)
mycmd (t2_c1_op) reg ani2 t2_c1_op $controls2 if wave ==7 & ani297 ==0 & SAMPLE2 == 1, cluster(comuid)
mycmd (t2_c1_op t2_c1_opwave7) reg ani2 t2_c1_op t2_c1_opwave7 wave3 wave4 wave7 $controls2 if ani297 ==0 & SAMPLE2 == 1, cluster(comuid)
mycmd (t2_c1_op) reg land t2_c1_op $controls3 if wave ==7 & land97 ==0 & SAMPLE2 == 1, cluster(comuid)
mycmd (t2_c1_op t2_c1_opwave7) reg land t2_c1_op t2_c1_opwave7 wave3 wave4 wave7 $controls3 if land97 ==0 & SAMPLE2 == 1, cluster(comuid)
foreach x in vani1 vani2 ha {
	mycmd (t2_c1_op) reg `x' t2_c1_op $basic $controls4 if wave ==7 & `x'97 >0 & SAMPLE2 == 1, cluster(comuid)
	mycmd (t2_c1_op t2_c1_opwave7) reg `x' t2_c1_op t2_c1_opwave7 wave3 wave4 wave7 $basic $controls4 if `x'97 >0 & SAMPLE2 == 1, cluster(comuid)
	}

quietly suest $M, cluster(comuid)
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 2)

*Table 3 
global i = 0
foreach x in me2 crafts const sewing food repair other {
	mycmd (t2_c1_op) reg `x' t2_c1_op wave3 wave4 $basic $controls if SAMPLE1 == 1, cluster(comuid)
	}
quietly suest $M, cluster(comuid)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 3)

egen Treat = mean(treatcom), by(comuid)
bysort comuid: gen N = _n
sort N comuid
global N = 506
mata Y = st_data((1,$N),"Treat")
generate Order = _n
generate double U = .

mata ResF = J($reps,10,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"Treat",Y)
	sort comuid N
	quietly replace Treat = Treat[_n-1] if comuid == comuid[_n-1] & N > 1
	quietly replace t2_c1_op = Treat if t2_c1_op ~= .
	quietly replace t2_c1_opwave7 = t2_c1_op*wave7

global i = 0

*Table 2, Panel A1 
foreach x in ani1 ani2 land vani1 vani2 ha {
	mycmd (t2_c1_op) reg `x' t2_c1_op wave3 wave4 $basic $controls if SAMPLE1 == 1, cluster(comuid)
	}

*Table 2, Panel A2 
 	mycmd (t2_c1_op) reg ani1 t2_c1_op wave3 wave4 $controls1 if ani197 ==0 & SAMPLE1 == 1, cluster(comuid)
 	mycmd (t2_c1_op) reg ani2 t2_c1_op wave3 wave4 $controls2 if ani297 ==0 & SAMPLE1 == 1, cluster(comuid)
 	mycmd (t2_c1_op) reg land t2_c1_op wave3 wave4 $controls3 if land97 ==0 & SAMPLE1 == 1, cluster(comuid)

foreach x in vani1 vani2 ha {
	mycmd (t2_c1_op) reg `x' t2_c1_op wave3 wave4 $basic $controls4 if `x'97 >0 & SAMPLE1 == 1, cluster(comuid)
	}

*Table 2 - Panels B1 and C1 
foreach x in ani1 ani2 land vani1 vani2 ha {
	mycmd (t2_c1_op) reg `x' t2_c1_op $basic $controls if wave ==7 & SAMPLE2 == 1, cluster(comuid)
	mycmd (t2_c1_op t2_c1_opwave7) reg `x' t2_c1_op t2_c1_opwave7 wave3 wave4 wave7 $basic $controls if SAMPLE2 == 1, cluster(comuid)
	}

*Table 2 - Panels B2 and C2 
mycmd (t2_c1_op) reg ani1 t2_c1_op $controls1 if wave ==7 & ani197 ==0 & SAMPLE2 == 1, cluster(comuid)
mycmd (t2_c1_op t2_c1_opwave7) reg ani1 t2_c1_op t2_c1_opwave7 wave3 wave4 wave7 $controls1 if ani197 ==0 & SAMPLE2 == 1, cluster(comuid)
mycmd (t2_c1_op) reg ani2 t2_c1_op $controls2 if wave ==7 & ani297 ==0 & SAMPLE2 == 1, cluster(comuid)
mycmd (t2_c1_op t2_c1_opwave7) reg ani2 t2_c1_op t2_c1_opwave7 wave3 wave4 wave7 $controls2 if ani297 ==0 & SAMPLE2 == 1, cluster(comuid)
mycmd (t2_c1_op) reg land t2_c1_op $controls3 if wave ==7 & land97 ==0 & SAMPLE2 == 1, cluster(comuid)
mycmd (t2_c1_op t2_c1_opwave7) reg land t2_c1_op t2_c1_opwave7 wave3 wave4 wave7 $controls3 if land97 ==0 & SAMPLE2 == 1, cluster(comuid)
foreach x in vani1 vani2 ha {
	mycmd (t2_c1_op) reg `x' t2_c1_op $basic $controls4 if wave ==7 & `x'97 >0 & SAMPLE2 == 1, cluster(comuid)
	mycmd (t2_c1_op t2_c1_opwave7) reg `x' t2_c1_op t2_c1_opwave7 wave3 wave4 wave7 $basic $controls4 if `x'97 >0 & SAMPLE2 == 1, cluster(comuid)
	}

capture suest $M, cluster(comuid)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 2)
		}
	}

*Table 3 
global i = 0
foreach x in me2 crafts const sewing food repair other {
	mycmd (t2_c1_op) reg `x' t2_c1_op wave3 wave4 $basic $controls if SAMPLE1 == 1, cluster(comuid)
	}

capture suest $M, cluster(comuid)
if (_rc == 0) {
	capture test $test
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
save ip\FisherSuestGMR12, replace

*************************


use DatGMR3, clear

gl dep_d maiz frijol ani_prod credit_farm
gl credit credit credit_cons credit_farm trans_t trans_out
gl home home_prod_tot home_prod_tot_pp_ae home_prod_tot_pp_ae2
gl home3 home_prod_tot_w3 home_prod_tot_w3_pp_ae home_prod_tot_w3_pp_ae2
gl treatcom1 t2_c1_op
gl treatcom2 treatcom
gl basic nbani197 nbani297 ha97
gl controls no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p hhsize97 homeown97 dirtfloor97  electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97
gl controls_ae no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p hhsize_ae homeown97 dirtfloor97 electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97
gl controls_ae2	no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p hhsize_ae2 homeown97 dirtfloor97  electricity97	org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97	
gl controls1 no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p hhsize97 homeown97 dirtfloor97  electricity97 org_faenas min_dist lnup_cwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97

*Table 4 
global i = 0
mycmd (t2_c1_op) reg home_prod_tot_pp_ae2 t2_c1_op wave3 $basic $controls if home_prod_tot_tile <=95, cluster(comuid)
mycmd (t2_c1_op) reg home_prod_tot_w3_pp_ae2 t2_c1_op $basic $controls1 if home_prod_tot_w3_tile <=95 & wave ==3, cluster(comuid)
foreach x in maiz frijol ani_prod credit_farm {
	mycmd (t2_c1_op) reg `x' t2_c1_op wave3 $basic $controls, cluster(comuid)
	}

quietly suest $M, cluster(comuid)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)

*Table 6 
global i = 0
foreach x in credit credit_cons credit_farm trans_t trans_out {
	mycmd (t2_c1_op) reg `x' t2_c1_op $basic $controls, cluster(comuid)
	}

quietly suest $M, cluster(comuid)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)


egen Treat = mean(treatcom), by(comuid)
bysort comuid: gen N = _n
sort N comuid
global N = 506
mata Y = st_data((1,$N),"Treat")
generate Order = _n
generate double U = .

mata ResF = J($reps,10,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"Treat",Y)
	sort comuid N
	quietly replace Treat = Treat[_n-1] if comuid == comuid[_n-1] & N > 1
	quietly replace t2_c1_op = Treat if t2_c1_op ~= .


*Table 4 
global i = 0
mycmd (t2_c1_op) reg home_prod_tot_pp_ae2 t2_c1_op wave3 $basic $controls if home_prod_tot_tile <=95, cluster(comuid)
mycmd (t2_c1_op) reg home_prod_tot_w3_pp_ae2 t2_c1_op $basic $controls1 if home_prod_tot_w3_tile <=95 & wave ==3, cluster(comuid)
foreach x in maiz frijol ani_prod credit_farm {
	mycmd (t2_c1_op) reg `x' t2_c1_op wave3 $basic $controls, cluster(comuid)
	}

capture suest $M, cluster(comuid)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 4)
		}
	}

*Table 6 
global i = 0
foreach x in credit credit_cons credit_farm trans_t trans_out {
	mycmd (t2_c1_op) reg `x' t2_c1_op $basic $controls, cluster(comuid)
	}

capture suest $M, cluster(comuid)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 6)
		}
	}

}

drop _all
set obs $reps
forvalues i = 11/20 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save ip\FisherSuestGMR3, replace

************************************

use DatGMR4, clear
gl basic nbani197 nbani297 ha97
gl controls no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p homeown97 dirtfloor97 electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97
gl controls1 no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p homeown97 dirtfloor97 electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dirtfloor97 dummy_electricity97

*Table 5 
global i = 0
mycmd (t2_c1_op) reg consumo_pp_ae2 t2_c1_op $basic hhsize_ae2_97 $controls1 if consumo_pp_ae2_tl_t2 >2 & consumo_pp_ae2_tl_t2 <199, cluster(comuid)
foreach x in homeprod_pp_ae2 witransfer_act_m_pp_ae2 amount_p_pp_ae2 amount_t_pr_pp_ae2 amount_borrowed_m_pp_ae2 {
	mycmd (t2_c1_op) reg `x' t2_c1_op $basic hhsize_ae2_97 $controls1 if consumo_pp_ae2_tl_t2 >2 & consumo_pp_ae2_tl_t2 <199 & `x'_tl_t2 <=196, cluster(comuid)
	}
foreach x in outwage_lw_hh_pp_ae2 {
	mycmd (t2_c1_op) reg `x' t2_c1_op $basic hhsize_ae2_97 $controls1 if consumo_pp_ae2_tl_t2 >2 & consumo_pp_ae2_tl_t2 <199 & `x'_tl_t2 <=190, cluster(comuid)
	}

quietly suest $M, cluster(comuid)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)

egen Treat = mean(treatcom), by(comuid)
bysort comuid: gen N = _n
sort N comuid
global N = 506
mata Y = st_data((1,$N),"Treat")
generate Order = _n
generate double U = .

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"Treat",Y)
	sort comuid N
	quietly replace Treat = Treat[_n-1] if comuid == comuid[_n-1] & N > 1
	quietly replace t2_c1_op = Treat if t2_c1_op ~= .

*Table 5 
global i = 0
mycmd (t2_c1_op) reg consumo_pp_ae2 t2_c1_op $basic hhsize_ae2_97 $controls1 if consumo_pp_ae2_tl_t2 >2 & consumo_pp_ae2_tl_t2 <199, cluster(comuid)
foreach x in homeprod_pp_ae2 witransfer_act_m_pp_ae2 amount_p_pp_ae2 amount_t_pr_pp_ae2 amount_borrowed_m_pp_ae2 {
	mycmd (t2_c1_op) reg `x' t2_c1_op $basic hhsize_ae2_97 $controls1 if consumo_pp_ae2_tl_t2 >2 & consumo_pp_ae2_tl_t2 <199 & `x'_tl_t2 <=196, cluster(comuid)
	}
foreach x in outwage_lw_hh_pp_ae2 {
	mycmd (t2_c1_op) reg `x' t2_c1_op $basic hhsize_ae2_97 $controls1 if consumo_pp_ae2_tl_t2 >2 & consumo_pp_ae2_tl_t2 <199 & `x'_tl_t2 <=190, cluster(comuid)
	}

capture suest $M, cluster(comuid)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 5)
		}
	}
}

drop _all
set obs $reps
forvalues i = 21/25 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save ip\FisherSuestGMR4, replace

******************


use DatGMR5, clear
gl adl_d sick inactivity
gl adl_c days_sick days_inactivity nb_km moderate_adl vigorous_adl
gl basic nbani197 nbani297 ha97
gl controls_all no497 big497 age age_sq female educ1_hh ethnicity_hh educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p homeown97 dirtfloor97 electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97
gl controls_all1 no497 big497 age age_sq female educ1_hh ethnicity_hh educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p homeown97 dirtfloor97 electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dirtfloor97 dummy_electricity97

*Table 7 
global i = 0
foreach x in sick days_sick inactivity days_inactivity nb_km moderate_adl vigorous_adl {
	mycmd (t2_c1_op) reg `x' t2_c1_op $basic hhsize_97 $controls_all1 if age <=64 & consumo_pp_ae2_tl_t2 >1 & consumo_pp_ae2_tl_t2 <200, cluster(comuid)
	}

quietly suest $M, cluster(comuid)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 7)

egen Treat = mean(treatcom), by(comuid)
bysort comuid: gen N = _n
sort N comuid
global N = 506
mata Y = st_data((1,$N),"Treat")
generate Order = _n
generate double U = .

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"Treat",Y)
	sort comuid N
	quietly replace Treat = Treat[_n-1] if comuid == comuid[_n-1] & N > 1
	quietly replace t2_c1_op = Treat if t2_c1_op ~= .

*Table 7 
global i = 0
foreach x in sick days_sick inactivity days_inactivity nb_km moderate_adl vigorous_adl {
	mycmd (t2_c1_op) reg `x' t2_c1_op $basic hhsize_97 $controls_all1 if age <=64 & consumo_pp_ae2_tl_t2 >1 & consumo_pp_ae2_tl_t2 <200, cluster(comuid)
	}

capture suest $M, cluster(comuid)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 7)
		}
	}
}

drop _all
set obs $reps
forvalues i = 26/30 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save ip\FisherSuestGMR5, replace

*****************************************

use ip\FisherSuestGMR12, clear
merge 1:1 N using ip\FisherSuestGMR3, nogenerate
merge 1:1 N using ip\FisherSuestGMR4, nogenerate
merge 1:1 N using ip\FisherSuestGMR5, nogenerate
drop F*
svmat double F
aorder
save results\FisherSuestGMR, replace


