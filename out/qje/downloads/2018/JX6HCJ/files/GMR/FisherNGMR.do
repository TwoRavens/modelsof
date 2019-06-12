
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	quietly `anything' `if' `in', cluster(`cluster')
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
	syntax anything [if] [in] [, cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	quietly `anything' `if' `in', cluster(`cluster')
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


use DatGMR1, clear

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

matrix F = J(19,4,.)
matrix B = J(19,2,.)

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

egen Treat = mean(treatcom), by(comuid)
bysort comuid: gen N = _n
sort N comuid
global N = 506
mata Y = st_data((1,$N),"Treat")
generate Order = _n
generate double U = .

mata ResF = J($reps,19,.); ResD = J($reps,19,.); ResDF = J($reps,19,.); ResB = J($reps,19,.); ResSE = J($reps,19,.)
forvalues c = 1/$reps {
	matrix FF = J(19,3,.)
	matrix BB = J(19,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"Treat",Y)
	sort comuid N
	quietly replace Treat = Treat[_n-1] if comuid == comuid[_n-1] & N > 1
	quietly replace t2_c1_op = Treat if t2_c1_op ~= .

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

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..19] = FF[.,1]'; ResD[`c',1..19] = FF[.,2]'; ResDF[`c',1..19] = FF[.,3]'
mata ResB[`c',1..19] = BB[.,1]'; ResSE[`c',1..19] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/19 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/19 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherGMR1, replace

***********

use DatGMR2, clear

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

matrix F = J(24,4,.)
matrix B = J(36,2,.)

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

egen Treat = mean(treatcom), by(comuid)
bysort comuid: gen N = _n
sort N comuid
global N = 506
mata Y = st_data((1,$N),"Treat")
generate Order = _n
generate double U = .

mata ResF = J($reps,24,.); ResD = J($reps,24,.); ResDF = J($reps,24,.); ResB = J($reps,36,.); ResSE = J($reps,36,.)
forvalues c = 1/$reps {
	matrix FF = J(24,3,.)
	matrix BB = J(36,2,.)
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

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..24] = FF[.,1]'; ResD[`c',1..24] = FF[.,2]'; ResDF[`c',1..24] = FF[.,3]'
mata ResB[`c',1..36] = BB[.,1]'; ResSE[`c',1..36] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/24 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/36 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherGMR2, replace

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

matrix F = J(11,4,.)
matrix B = J(11,2,.)

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

egen Treat = mean(treatcom), by(comuid)
bysort comuid: gen N = _n
sort N comuid
global N = 506
mata Y = st_data((1,$N),"Treat")
generate Order = _n
generate double U = .

mata ResF = J($reps,11,.); ResD = J($reps,11,.); ResDF = J($reps,11,.); ResB = J($reps,11,.); ResSE = J($reps,11,.)
forvalues c = 1/$reps {
	matrix FF = J(11,3,.)
	matrix BB = J(11,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"Treat",Y)
	sort comuid N
	quietly replace Treat = Treat[_n-1] if comuid == comuid[_n-1] & N > 1
	quietly replace t2_c1_op = Treat if t2_c1_op ~= .

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

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..11] = FF[.,1]'; ResD[`c',1..11] = FF[.,2]'; ResDF[`c',1..11] = FF[.,3]'
mata ResB[`c',1..11] = BB[.,1]'; ResSE[`c',1..11] = BB[.,2]'

}


drop _all
set obs $reps
foreach j in ResF ResD ResDF ResB ResSE {
	forvalues i = 1/11 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherGMR3, replace

************************************

use DatGMR4, clear

gl basic nbani197 nbani297 ha97
gl controls no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p homeown97 dirtfloor97 electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97
gl controls1 no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p homeown97 dirtfloor97 electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dirtfloor97 dummy_electricity97

matrix F = J(7,4,.)
matrix B = J(7,2,.)

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

egen Treat = mean(treatcom), by(comuid)
bysort comuid: gen N = _n
sort N comuid
global N = 506
mata Y = st_data((1,$N),"Treat")
generate Order = _n
generate double U = .

mata ResF = J($reps,7,.); ResD = J($reps,7,.); ResDF = J($reps,7,.); ResB = J($reps,7,.); ResSE = J($reps,7,.)
forvalues c = 1/$reps {
	matrix FF = J(7,3,.)
	matrix BB = J(7,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"Treat",Y)
	sort comuid N
	quietly replace Treat = Treat[_n-1] if comuid == comuid[_n-1] & N > 1
	quietly replace t2_c1_op = Treat if t2_c1_op ~= .

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

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..7] = FF[.,1]'; ResD[`c',1..7] = FF[.,2]'; ResDF[`c',1..7] = FF[.,3]'
mata ResB[`c',1..7] = BB[.,1]'; ResSE[`c',1..7] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF ResB ResSE {
	forvalues i = 1/7 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherGMR4, replace

******************

use DatGMR5, clear
gl adl_d sick inactivity
gl adl_c days_sick days_inactivity nb_km moderate_adl vigorous_adl
gl basic nbani197 nbani297 ha97
gl controls_all no497 big497 age age_sq female educ1_hh ethnicity_hh educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p homeown97 dirtfloor97 electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97
gl controls_all1 no497 big497 age age_sq female educ1_hh ethnicity_hh educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p homeown97 dirtfloor97 electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dirtfloor97 dummy_electricity97

matrix F = J(7,4,.)
matrix B = J(7,2,.)

global i = 1
global j = 1

*Table 7 
foreach x in sick days_sick inactivity days_inactivity nb_km moderate_adl vigorous_adl {
	mycmd (t2_c1_op) reg `x' t2_c1_op $basic hhsize_97 $controls_all1 if age <=64 & consumo_pp_ae2_tl_t2 >1 & consumo_pp_ae2_tl_t2 <200, cluster(comuid)
	}

egen Treat = mean(treatcom), by(comuid)
bysort comuid: gen N = _n
sort N comuid
global N = 506
mata Y = st_data((1,$N),"Treat")
generate Order = _n
generate double U = .

mata ResF = J($reps,7,.); ResD = J($reps,7,.); ResDF = J($reps,7,.); ResB = J($reps,7,.); ResSE = J($reps,7,.)
forvalues c = 1/$reps {
	matrix FF = J(7,3,.)
	matrix BB = J(7,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"Treat",Y)
	sort comuid N
	quietly replace Treat = Treat[_n-1] if comuid == comuid[_n-1] & N > 1
	quietly replace t2_c1_op = Treat if t2_c1_op ~= .

global i = 1
global j = 1

*Table 7 
foreach x in sick days_sick inactivity days_inactivity nb_km moderate_adl vigorous_adl {
	mycmd1 (t2_c1_op) reg `x' t2_c1_op $basic hhsize_97 $controls_all1 if age <=64 & consumo_pp_ae2_tl_t2 >1 & consumo_pp_ae2_tl_t2 <200, cluster(comuid)
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..7] = FF[.,1]'; ResD[`c',1..7] = FF[.,2]'; ResDF[`c',1..7] = FF[.,3]'
mata ResB[`c',1..7] = BB[.,1]'; ResSE[`c',1..7] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF ResB ResSE {
	forvalues i = 1/7 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherGMR5, replace

***********************************

*Combining files

drop _all
use ip\FisherGMR1
sum B1
global k = r(N)
sum F1
global N = r(N)
mkmat F1-F4 in 1/$N, matrix(F)
mkmat B1 B2 in 1/$k, matrix(B)

foreach j in 2 3 4 5 {
	use ip\FisherGMR`j', clear
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
		rename ResF`i' ResF`k'
		rename ResDF`i' ResDF`k'
		rename ResD`i' ResD`k'
		}
	global k = $k + $k1
	global N = $N + $N1
	save a`j', replace
	}

use ip\FisherGMR1, clear
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
save results\FisherGMR, replace

foreach j in 2 3 4 5 {
	erase a`j'.dta
	}





