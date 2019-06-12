

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	if ("`absorb'" == "") `anything' `if' `in', cluster(`cluster') `robust'
	if ("`absorb'" ~= "") `anything' `if' `in', cluster(`cluster') `robust' absorb(`absorb')
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
		if ("`absorb'" == "") quietly `anything' if M ~= `i', cluster(`cluster') `robust'
		if ("`absorb'" ~= "") quietly `anything' if M ~= `i', cluster(`cluster') `robust' absorb(`absorb')
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


global cluster = "comuid"

global i = 1
global j = 1

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

****************************************
****************************************

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

***********************************
***********************************

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
mycmd (t2_c1_op) reg home_prod_tot_pp_ae2 t2_c1_op wave3 $basic $controls if home_prod_tot_tile <=95, cluster(comuid)
mycmd (t2_c1_op) reg home_prod_tot_w3_pp_ae2 t2_c1_op $basic $controls1 if home_prod_tot_w3_tile <=95 & wave ==3, cluster(comuid)
foreach x in maiz frijol ani_prod credit_farm {
	mycmd (t2_c1_op) reg `x' t2_c1_op wave3 $basic $controls, cluster(comuid)
	}

*Table 6 
foreach x in credit credit_cons credit_farm trans_t trans_out {
	mycmd (t2_c1_op) reg `x' t2_c1_op $basic $controls, cluster(comuid)
	}


************************************
************************************

use DatGMR4, clear

gl basic nbani197 nbani297 ha97
gl controls no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p homeown97 dirtfloor97 electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97
gl controls1 no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p homeown97 dirtfloor97 electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dirtfloor97 dummy_electricity97

*Table 5 
mycmd (t2_c1_op) reg consumo_pp_ae2 t2_c1_op $basic hhsize_ae2_97 $controls1 if consumo_pp_ae2_tl_t2 >2 & consumo_pp_ae2_tl_t2 <199, cluster(comuid)
foreach x in homeprod_pp_ae2 witransfer_act_m_pp_ae2 amount_p_pp_ae2 amount_t_pr_pp_ae2 amount_borrowed_m_pp_ae2 {
	mycmd (t2_c1_op) reg `x' t2_c1_op $basic hhsize_ae2_97 $controls1 if consumo_pp_ae2_tl_t2 >2 & consumo_pp_ae2_tl_t2 <199 & `x'_tl_t2 <=196, cluster(comuid)
	}
foreach x in outwage_lw_hh_pp_ae2 {
	mycmd (t2_c1_op) reg `x' t2_c1_op $basic hhsize_ae2_97 $controls1 if consumo_pp_ae2_tl_t2 >2 & consumo_pp_ae2_tl_t2 <199 & `x'_tl_t2 <=190, cluster(comuid)
	}


*************************************
*************************************

use DatGMR5, clear

gl adl_d sick inactivity
gl adl_c days_sick days_inactivity nb_km moderate_adl vigorous_adl
gl basic nbani197 nbani297 ha97
gl controls_all no497 big497 age age_sq female educ1_hh ethnicity_hh educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p homeown97 dirtfloor97 electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97
gl controls_all1 no497 big497 age age_sq female educ1_hh ethnicity_hh educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p homeown97 dirtfloor97 electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dirtfloor97 dummy_electricity97

*Table 7 
foreach x in sick days_sick inactivity days_inactivity nb_km moderate_adl vigorous_adl {
	mycmd (t2_c1_op) reg `x' t2_c1_op $basic hhsize_97 $controls_all1 if age <=64 & consumo_pp_ae2_tl_t2 >1 & consumo_pp_ae2_tl_t2 <200, cluster(comuid)
	}

use ip\JK1, clear
forvalues i = 2/68 {
	merge using ip\JK`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/68 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\JackKnifeGMR, replace


