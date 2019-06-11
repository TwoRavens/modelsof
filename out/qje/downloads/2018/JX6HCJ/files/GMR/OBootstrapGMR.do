
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust ]
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
	syntax anything [if] [in] [, cluster(string) robust ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', cluster(`cluster') `robust'
	if (_rc == 0) {
		capture testparm `testvars'
		if (_rc == 0) {
			matrix FF[$i,1] = r(p), r(drop), e(df_r)
			matrix V = e(V)
			matrix b = e(b)
			matrix V = V[1..$k,1..$k]
			matrix b = b[1,1..$k]
			matrix f = (b-B[$j..$j+$k-1,1]')*invsym(V)*(b'-B[$j..$j+$k-1,1])
			if (e(df_r) ~= .) capture matrix FF[$i,4] = Ftail($k,e(df_r),f[1,1]/$k)
			if (e(df_r) == .) capture matrix FF[$i,4] = chi2tail($k,f[1,1])
			local i = 0
			foreach var in `testvars' {
				matrix BB[$j+`i',1] = _b[`var'], _se[`var']
				local i = `i' + 1
				}
			}
		}
global i = $i + 1
global j = $j + $k
end


****************************************
****************************************

global a = 19
global b = 19

use DatGMR1, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

gl dep_all ani1 ani2 land vani1 vani2 ha
gl dep_dum ani1 ani2 land
gl dep_cont vani1 vani2 ha
gl dep_me me2 crafts const sewing food repair other
gl dep_all_in ani1 ani2 land vani1 vani2 ha me2 crafts
gl treatcom1 t2_c1_op
gl treatcom2 treatcom
gl basic nbani197 nbani297 ha97
gl controls no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p hhsize97 homeown97 dirtfloor97  electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97
*Extra specifications to get rid of drops - just to confirm singularity or not of covariance matrix
gl controls1 nbani297 ha97 no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p hhsize97 homeown97 dirtfloor97  electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97
gl controls2 nbani197 ha97 no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p hhsize97 homeown97 dirtfloor97  electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97
gl controls3 nbani197 nbani297 no497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p hhsize97 homeown97 dirtfloor97  electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97
gl controls4 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p hhsize97 homeown97 dirtfloor97  electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97

global i = 1
global j = 1

*Table 2, Panel A1 
foreach x in ani1 ani2 land vani1 vani2 ha {
	mycmd (t2_c1_op) reg `x' t2_c1_op wave3 wave4 $basic $controls, cluster(comuid)
	}

*Table 2, Panel A2 
 	mycmd (t2_c1_op) reg ani1 t2_c1_op wave3 wave4 $controls1 if ani197 ==0, cluster(comuid)
 	mycmd (t2_c1_op) reg ani2 t2_c1_op wave3 wave4 $controls2 if ani297 ==0, cluster(comuid)
 	mycmd (t2_c1_op) reg land t2_c1_op wave3 wave4 $controls3 if land97 ==0, cluster(comuid)

foreach x in vani1 vani2 ha {
	mycmd (t2_c1_op) reg `x' t2_c1_op wave3 wave4 $basic $controls4 if `x'97 >0, cluster(comuid)
	}

*Table 3 
foreach x in me2 crafts const sewing food repair other {
	mycmd (t2_c1_op) reg `x' t2_c1_op wave3 wave4 $basic $controls, cluster(comuid)
	}

gen Order = _n
sort comuid Order
gen N = 1
gen Dif = (comuid ~= comuid[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop comuid
	rename obs comuid

global i = 1
global j = 1

*Table 2, Panel A1 
foreach x in ani1 ani2 land vani1 vani2 ha {
	mycmd1 (t2_c1_op) reg `x' t2_c1_op wave3 wave4 $basic $controls, cluster(comuid)
	}

*Table 2, Panel A2 
 	mycmd1 (t2_c1_op) reg ani1 t2_c1_op wave3 wave4 $controls1 if ani197 ==0, cluster(comuid)
 	mycmd1 (t2_c1_op) reg ani2 t2_c1_op wave3 wave4 $controls2 if ani297 ==0, cluster(comuid)
 	mycmd1 (t2_c1_op) reg land t2_c1_op wave3 wave4 $controls3 if land97 ==0, cluster(comuid)

foreach x in vani1 vani2 ha {
	mycmd1 (t2_c1_op) reg `x' t2_c1_op wave3 wave4 $basic $controls4 if `x'97 >0, cluster(comuid)
	}

*Table 3 
foreach x in me2 crafts const sewing food repair other {
	mycmd1 (t2_c1_op) reg `x' t2_c1_op wave3 wave4 $basic $controls, cluster(comuid)
	}

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}


drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapGMR1, replace

****************************************
****************************************

global a = 24
global b = 36

use DatGMR2, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

gl dep_all ani1 ani2 land vani1 vani2 ha
gl dep_cont vani1 vani2 ha
gl dep_dum ani1 ani2 land
gl treatcom1 t2_c1_op
gl treatcom2 treatcom
gl basic nbani197 nbani297 ha97
gl controls no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p hhsize97 homeown97 dirtfloor97  electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97
*Extra specifications to get rid of drops - just to confirm singularity or not of covariance matrix
gl controls1 nbani297 ha97 no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p hhsize97 homeown97 dirtfloor97  electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97
gl controls2 nbani197 ha97 no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p hhsize97 homeown97 dirtfloor97  electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97
gl controls3 nbani197 nbani297 no497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p hhsize97 homeown97 dirtfloor97  electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97
gl controls4 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p hhsize97 homeown97 dirtfloor97  electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97

global i = 1
global j = 1

*Table 2 - Panels B1 and C1 
foreach x in ani1 ani2 land vani1 vani2 ha {
	mycmd (t2_c1_op) reg `x' t2_c1_op $basic $controls if wave ==7, cluster(comuid)
	mycmd (t2_c1_op t2_c1_opwave7) reg `x' t2_c1_op t2_c1_opwave7 wave3 wave4 wave7 $basic $controls, cluster(comuid)
	}

*Table 2 - Panels B2 and C2 
mycmd (t2_c1_op) reg ani1 t2_c1_op $controls1 if wave ==7 & ani197 ==0, cluster(comuid)
mycmd (t2_c1_op t2_c1_opwave7) reg ani1 t2_c1_op t2_c1_opwave7 wave3 wave4 wave7 $controls1 if ani197 ==0, cluster(comuid)
mycmd (t2_c1_op) reg ani2 t2_c1_op $controls2 if wave ==7 & ani297 ==0, cluster(comuid)
mycmd (t2_c1_op t2_c1_opwave7) reg ani2 t2_c1_op t2_c1_opwave7 wave3 wave4 wave7 $controls2 if ani297 ==0, cluster(comuid)
mycmd (t2_c1_op) reg land t2_c1_op $controls3 if wave ==7 & land97 ==0, cluster(comuid)
mycmd (t2_c1_op t2_c1_opwave7) reg land t2_c1_op t2_c1_opwave7 wave3 wave4 wave7 $controls3 if land97 ==0, cluster(comuid)
foreach x in vani1 vani2 ha {
	mycmd (t2_c1_op) reg `x' t2_c1_op $basic $controls4 if wave ==7 & `x'97 >0, cluster(comuid)
	mycmd (t2_c1_op t2_c1_opwave7) reg `x' t2_c1_op t2_c1_opwave7 wave3 wave4 wave7 $basic $controls4 if `x'97 >0, cluster(comuid)
	}

gen Order = _n
sort comuid Order
gen N = 1
gen Dif = (comuid ~= comuid[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save bb, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using bb
	drop comuid
	rename obs comuid

global i = 1
global j = 1

*Table 2 - Panels B1 and C1 
foreach x in ani1 ani2 land vani1 vani2 ha {
	mycmd1 (t2_c1_op) reg `x' t2_c1_op $basic $controls if wave ==7, cluster(comuid)
	mycmd1 (t2_c1_op t2_c1_opwave7) reg `x' t2_c1_op t2_c1_opwave7 wave3 wave4 wave7 $basic $controls, cluster(comuid)
	}

*Table 2 - Panels B2 and C2 
mycmd1 (t2_c1_op) reg ani1 t2_c1_op $controls1 if wave ==7 & ani197 ==0, cluster(comuid)
mycmd1 (t2_c1_op t2_c1_opwave7) reg ani1 t2_c1_op t2_c1_opwave7 wave3 wave4 wave7 $controls1 if ani197 ==0, cluster(comuid)
mycmd1 (t2_c1_op) reg ani2 t2_c1_op $controls2 if wave ==7 & ani297 ==0, cluster(comuid)
mycmd1 (t2_c1_op t2_c1_opwave7) reg ani2 t2_c1_op t2_c1_opwave7 wave3 wave4 wave7 $controls2 if ani297 ==0, cluster(comuid)
mycmd1 (t2_c1_op) reg land t2_c1_op $controls3 if wave ==7 & land97 ==0, cluster(comuid)
mycmd1 (t2_c1_op t2_c1_opwave7) reg land t2_c1_op t2_c1_opwave7 wave3 wave4 wave7 $controls3 if land97 ==0, cluster(comuid)
foreach x in vani1 vani2 ha {
	mycmd1 (t2_c1_op) reg `x' t2_c1_op $basic $controls4 if wave ==7 & `x'97 >0, cluster(comuid)
	mycmd1 (t2_c1_op t2_c1_opwave7) reg `x' t2_c1_op t2_c1_opwave7 wave3 wave4 wave7 $basic $controls4 if `x'97 >0, cluster(comuid)
	}

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}


drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapGMR2, replace

***********************************
***********************************

global a = 11
global b = 11

use DatGMR3, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

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

global i = 1
global j = 1

*Table 4 
mycmd (t2_c1_op) reg home_prod_tot_pp_ae2 t2_c1_op wave3 $basic $controls if home_prod_tot_tile <=95, cluster(comuid)
mycmd (t2_c1_op) reg home_prod_tot_w3_pp_ae2 t2_c1_op $basic $controls1 if home_prod_tot_w3_tile <=95 & wave ==3, cluster(comuid)
foreach x in maiz frijol ani_prod credit_farm {
	mycmd (t2_c1_op) reg `x' t2_c1_op wave3 $basic $controls, cluster(comuid)
	}

*Table 6 
foreach x in credit credit_cons credit_farm trans_t trans_out {
	mycmd (t2_c1_op) reg `x' t2_c1_op $basic $controls, cluster(comuid)
	}

gen Order = _n
sort comuid Order
gen N = 1
gen Dif = (comuid ~= comuid[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save cc, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using cc
	drop comuid
	rename obs comuid

global i = 1
global j = 1

*Table 4 
mycmd1 (t2_c1_op) reg home_prod_tot_pp_ae2 t2_c1_op wave3 $basic $controls if home_prod_tot_tile <=95, cluster(comuid)
mycmd1 (t2_c1_op) reg home_prod_tot_w3_pp_ae2 t2_c1_op $basic $controls1 if home_prod_tot_w3_tile <=95 & wave ==3, cluster(comuid)
foreach x in maiz frijol ani_prod credit_farm {
	mycmd1 (t2_c1_op) reg `x' t2_c1_op wave3 $basic $controls, cluster(comuid)
	}

*Table 6 
foreach x in credit credit_cons credit_farm trans_t trans_out {
	mycmd1 (t2_c1_op) reg `x' t2_c1_op $basic $controls, cluster(comuid)
	}

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}


drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapGMR3, replace

************************************
************************************

global a = 7
global b = 7

use DatGMR4, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

gl basic nbani197 nbani297 ha97
gl controls no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p homeown97 dirtfloor97 electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97
gl controls1 no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p homeown97 dirtfloor97 electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dirtfloor97 dummy_electricity97

global i = 1
global j = 1

*Table 5 
mycmd (t2_c1_op) reg consumo_pp_ae2 t2_c1_op $basic hhsize_ae2_97 $controls1 if consumo_pp_ae2_tl_t2 >2 & consumo_pp_ae2_tl_t2 <199, cluster(comuid)
foreach x in homeprod_pp_ae2 witransfer_act_m_pp_ae2 amount_p_pp_ae2 amount_t_pr_pp_ae2 amount_borrowed_m_pp_ae2 {
	mycmd (t2_c1_op) reg `x' t2_c1_op $basic hhsize_ae2_97 $controls1 if consumo_pp_ae2_tl_t2 >2 & consumo_pp_ae2_tl_t2 <199 & `x'_tl_t2 <=196, cluster(comuid)
	}
foreach x in outwage_lw_hh_pp_ae2 {
	mycmd (t2_c1_op) reg `x' t2_c1_op $basic hhsize_ae2_97 $controls1 if consumo_pp_ae2_tl_t2 >2 & consumo_pp_ae2_tl_t2 <199 & `x'_tl_t2 <=190, cluster(comuid)
	}

gen Order = _n
sort comuid Order
gen N = 1
gen Dif = (comuid ~= comuid[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save dd, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using dd
	drop comuid
	rename obs comuid

global i = 1
global j = 1

*Table 5 
mycmd1 (t2_c1_op) reg consumo_pp_ae2 t2_c1_op $basic hhsize_ae2_97 $controls1 if consumo_pp_ae2_tl_t2 >2 & consumo_pp_ae2_tl_t2 <199, cluster(comuid)
foreach x in homeprod_pp_ae2 witransfer_act_m_pp_ae2 amount_p_pp_ae2 amount_t_pr_pp_ae2 amount_borrowed_m_pp_ae2 {
	mycmd1 (t2_c1_op) reg `x' t2_c1_op $basic hhsize_ae2_97 $controls1 if consumo_pp_ae2_tl_t2 >2 & consumo_pp_ae2_tl_t2 <199 & `x'_tl_t2 <=196, cluster(comuid)
	}
foreach x in outwage_lw_hh_pp_ae2 {
	mycmd1 (t2_c1_op) reg `x' t2_c1_op $basic hhsize_ae2_97 $controls1 if consumo_pp_ae2_tl_t2 >2 & consumo_pp_ae2_tl_t2 <199 & `x'_tl_t2 <=190, cluster(comuid)
	}

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}


drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapGMR4, replace

*************************************
*************************************

global a = 7
global b = 7

use DatGMR5, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

gl adl_d sick inactivity
gl adl_c days_sick days_inactivity nb_km moderate_adl vigorous_adl
gl basic nbani197 nbani297 ha97
gl controls_all no497 big497 age age_sq female educ1_hh ethnicity_hh educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p homeown97 dirtfloor97 electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97
gl controls_all1 no497 big497 age age_sq female educ1_hh ethnicity_hh educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p homeown97 dirtfloor97 electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dirtfloor97 dummy_electricity97

global i = 1
global j = 1

*Table 7 
foreach x in sick days_sick inactivity days_inactivity nb_km moderate_adl vigorous_adl {
	mycmd (t2_c1_op) reg `x' t2_c1_op $basic hhsize_97 $controls_all1 if age <=64 & consumo_pp_ae2_tl_t2 >1 & consumo_pp_ae2_tl_t2 <200, cluster(comuid)
	}

gen Order = _n
sort comuid Order
gen N = 1
gen Dif = (comuid ~= comuid[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save ee, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using ee
	drop comuid
	rename obs comuid

gl adl_d sick inactivity
gl adl_c days_sick days_inactivity nb_km moderate_adl vigorous_adl
gl basic nbani197 nbani297 ha97
gl controls_all no497 big497 age age_sq female educ1_hh ethnicity_hh educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p homeown97 dirtfloor97 electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97
gl controls_all1 no497 big497 age age_sq female educ1_hh ethnicity_hh educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p homeown97 dirtfloor97 electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dirtfloor97 dummy_electricity97

global i = 1
global j = 1

*Table 7 
foreach x in sick days_sick inactivity days_inactivity nb_km moderate_adl vigorous_adl {
	mycmd1 (t2_c1_op) reg `x' t2_c1_op $basic hhsize_97 $controls_all1 if age <=64 & consumo_pp_ae2_tl_t2 >1 & consumo_pp_ae2_tl_t2 <200, cluster(comuid)
	}

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}


drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapGMR5, replace

*******************************
*******************************

*Combining Files

drop _all
use ip\OBootstrapGMR1
sum B1
global k = r(N)
sum F1
global N = r(N)
mkmat F1-F4 in 1/$N, matrix(F)
mkmat B1 B2 in 1/$k, matrix(B)

foreach j in 2 3 4 5 {
	use ip\OBootstrapGMR`j', clear
	sort N
	quietly sum B1
	global k1 = r(N)
	quietly sum F1
	global N1 = r(N)
mkmat F1-F4 in 1/$N1, matrix(FF)
mkmat B1 B2 in 1/$k1, matrix(BB)
	matrix F = F \ FF
	matrix B = B \ BB
	drop F1-F4 B1-B2
	forvalues i = $k1(-1)1 {
		local k = `i' + $k
		rename ResB`i' ResB`k'
		rename ResSE`i' ResSE`k'
		}
	forvalues i = $N1(-1)1 {
		local k = `i' + $N
		rename ResFF`i' ResFF`k'
		rename ResF`i' ResF`k'
		rename ResDF`i' ResDF`k'
		rename ResD`i' ResD`k'
		}
	global k = $k + $k1
	global N = $N + $N1
	save a`j', replace
	}

use ip\OBootstrapGMR1, clear
drop F1-F4 B1-B2 
foreach j in 2 3 4 5 {
	sort N
	merge N using a`j'
	tab _m
	drop _m
	sort N
	}
aorder
svmat double F
svmat double B
save results\OBootstrapGMR, replace

foreach file in aa bb cc dd ee aaa a2 a3 a4 a5 {
	capture erase `file'.dta
	}







