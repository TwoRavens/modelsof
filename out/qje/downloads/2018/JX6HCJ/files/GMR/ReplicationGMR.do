
************************************************

*Done in parts following their do file code which analyses in parts

*Part 1:  Confirming tables

use investments_data.dta, clear
keep if wave ==2 | wave ==3 | wave ==4
replace land =. if ha ==.
g byte all =(ani1 ~=. & ani2 ~=. & land ~=. & me~=.)
keep if all ==1

foreach x in 2 3 4 {
	g byte wave`x' =(wave ==`x')
	}
foreach x in t2_c1_op treatcom {
	foreach y in wave2 wave3 wave4 {
		g `x'`y' =`y' * `x'
		}
	}

gl dep_all ani1 ani2 land vani1 vani2 ha
gl dep_dum ani1 ani2 land
gl dep_cont vani1 vani2 ha
gl dep_me me2 crafts const sewing food repair other
gl dep_all_in ani1 ani2 land vani1 vani2 ha me2 crafts
gl treatcom1 t2_c1_op
gl treatcom2 treatcom
gl basic nbani197 nbani297 ha97
gl controls no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p hhsize97 homeown97 dirtfloor97  electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97

*Table 2, Panel A1 - All okay
foreach x of global dep_all {
	foreach y of global treatcom1 {
		reg `x' `y' wave3 wave4 $basic $controls, cl(comuid)
		reg `x' `y'wave2 `y'wave3 `y'wave4 wave3 wave4 $basic $controls, cl(comuid)
		test `y'wave2 = `y'wave3 = `y'wave4
		}
	}

*Table 2, Panel A2 - All okay
foreach y of global treatcom1 {
	foreach x of global dep_dum {
		reg `x' `y' wave3 wave4 $basic $controls if `x'97 ==0, cl(comuid)
		reg `x' `y'wave2 `y'wave3 `y'wave4 wave3 wave4 $basic $controls if `x'97 ==0, cl(comuid)
		test `y'wave2 = `y'wave3 = `y'wave4
		}
	foreach x of global dep_cont {
		reg `x' `y' wave3 wave4 $basic $controls if `x'97 >0, cl(comuid)
		reg `x' `y'wave2 `y'wave3 `y'wave4 wave3 wave4 $basic $controls if `x'97 >0, cl(comuid)
		test `y'wave2 = `y'wave3 = `y'wave4
		}
	}

*Table 3 - All okay
foreach x of global dep_me {
	foreach y of global treatcom1 {
		reg `x' `y' wave3 wave4 $basic $controls, cl(comuid)
		reg `x' `y'wave2 `y'wave3 `y'wave4 wave3 wave4 $basic $controls, cl(comuid)
		test `y'wave2 = `y'wave3 = `y'wave4
		}
	}

*************

*Part 1: My Code

use investments_data.dta, clear
keep if wave ==2 | wave ==3 | wave ==4
replace land =. if ha ==.
g byte all =(ani1 ~=. & ani2 ~=. & land ~=. & me~=.)
keep if all ==1

foreach x in 2 3 4 {
	g byte wave`x' =(wave ==`x')
	}
foreach x in t2_c1_op treatcom {
	foreach y in wave2 wave3 wave4 {
		g `x'`y' =`y' * `x'
		}
	}
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

*Table 2, Panel A1 - All okay
foreach x in ani1 ani2 land vani1 vani2 ha {
	reg `x' t2_c1_op wave3 wave4 $basic $controls, cl(comuid)
	reg `x' t2_c1_opwave2 t2_c1_opwave3 t2_c1_opwave4 wave3 wave4 $basic $controls, cl(comuid)
	}

*Table 2, Panel A2 - All okay
 	reg ani1 t2_c1_op wave3 wave4 $controls1 if ani197 ==0, cl(comuid)
 	reg ani1 t2_c1_opwave2 t2_c1_opwave3 t2_c1_opwave4 wave3 wave4 $controls1 if ani197 ==0, cl(comuid)
 	reg ani2 t2_c1_op wave3 wave4 $controls2 if ani297 ==0, cl(comuid)
 	reg ani2 t2_c1_opwave2 t2_c1_opwave3 t2_c1_opwave4 wave3 wave4 $controls2 if ani297 ==0, cl(comuid)
 	reg land t2_c1_op wave3 wave4 $controls3 if land97 ==0, cl(comuid)
 	reg land t2_c1_opwave2 t2_c1_opwave3 t2_c1_opwave4 wave3 wave4 $controls3 if land97 ==0, cl(comuid)

foreach x in vani1 vani2 ha {
	reg `x' t2_c1_op wave3 wave4 $basic $controls4 if `x'97 >0, cl(comuid)
	reg `x' t2_c1_opwave2 t2_c1_opwave3 t2_c1_opwave4 wave3 wave4 $basic $controls4 if `x'97 >0, cl(comuid)
	}

*Table 3 - All okay
foreach x in me2 crafts const sewing food repair other {
	reg `x' t2_c1_op wave3 wave4 $basic $controls, cl(comuid)
	reg `x' t2_c1_opwave2 t2_c1_opwave3 t2_c1_opwave4 wave3 wave4 $basic $controls, cl(comuid)
	}

save DatGMR1, replace

***********

*Part 2:  Confirming tables

use investments_data.dta, clear
keep if wave ==2 | wave ==3 | wave ==4 | wave ==7
replace land =. if ha ==.
g byte all =(ani1 ~=. & ani2 ~=. & land ~=. & me~=.)
sort state muni local folio wave
replace all =all[_n-1] if wave ==7
keep if all ==1

foreach x in 2 3 4 7 {
	g byte wave`x' =(wave ==`x')
	}
foreach x in t2_c1_op treatcom {
	foreach y in wave2 wave3 wave4 wave7 {
		g `x'`y' =`y' * `x'
		}
	}

ta wave if vani2 >=50000 & vani2 ~=.
sum vani2 if vani2 >=50000
keep if vani2 <50000

gl dep_all ani1 ani2 land vani1 vani2 ha
gl dep_cont vani1 vani2 ha
gl dep_dum ani1 ani2 land
gl treatcom1 t2_c1_op
gl treatcom2 treatcom
gl basic nbani197 nbani297 ha97
gl controls no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p hhsize97 homeown97 dirtfloor97  electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97

*Table 2 - Panels B1 and C1 - All okay
foreach x of global dep_all {
	foreach y of global treatcom1 {
		reg `x' `y' $basic $controls if wave ==7, cl(comuid)
		reg `x' `y' `y'wave7 wave3 wave4 wave7 $basic $controls, cl(comuid)
		}
	}

*Table 2 - Panels B2 and C2 - All okay
foreach y of global treatcom1 {
	foreach x of global dep_dum {
		reg `x' `y' $basic $controls if wave ==7 & `x'97 ==0, cl(comuid)
		reg `x' `y' `y'wave7 wave3 wave4 wave7 $basic $controls if `x'97 ==0, cl(comuid)
		}
	foreach x of global dep_cont {
		reg `x' `y' $basic $controls if wave ==7 & `x'97 >0, cl(comuid)
		reg `x' `y' `y'wave7 wave3 wave4 wave7 $basic $controls if `x'97 >0, cl(comuid)
		}
	}

*******************************

*Part 2:  My Code

use investments_data.dta, clear
keep if wave ==2 | wave ==3 | wave ==4 | wave ==7
replace land =. if ha ==.
g byte all =(ani1 ~=. & ani2 ~=. & land ~=. & me~=.)
sort state muni local folio wave
replace all =all[_n-1] if wave ==7
keep if all ==1

foreach x in 2 3 4 7 {
	g byte wave`x' =(wave ==`x')
	}
foreach x in t2_c1_op treatcom {
	foreach y in wave2 wave3 wave4 wave7 {
		g `x'`y' =`y' * `x'
		}
	}

ta wave if vani2 >=50000 & vani2 ~=.
sum vani2 if vani2 >=50000
keep if vani2 <50000

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

*Table 2 - Panels B1 and C1 - All okay
foreach x in ani1 ani2 land vani1 vani2 ha {
	reg `x' t2_c1_op $basic $controls if wave ==7, cl(comuid)
	reg `x' t2_c1_op t2_c1_opwave7 wave3 wave4 wave7 $basic $controls, cl(comuid)
	}

*Table 2 - Panels B2 and C2 - All okay
reg ani1 t2_c1_op $controls1 if wave ==7 & ani197 ==0, cl(comuid)
reg ani1 t2_c1_op t2_c1_opwave7 wave3 wave4 wave7 $controls1 if ani197 ==0, cl(comuid)
reg ani2 t2_c1_op $controls2 if wave ==7 & ani297 ==0, cl(comuid)
reg ani2 t2_c1_op t2_c1_opwave7 wave3 wave4 wave7 $controls2 if ani297 ==0, cl(comuid)
reg land t2_c1_op $controls3 if wave ==7 & land97 ==0, cl(comuid)
reg land t2_c1_op t2_c1_opwave7 wave3 wave4 wave7 $controls3 if land97 ==0, cl(comuid)
foreach x in vani1 vani2 ha {
	reg `x' t2_c1_op $basic $controls4 if wave ==7 & `x'97 >0, cl(comuid)
	reg `x' t2_c1_op t2_c1_opwave7 wave3 wave4 wave7 $basic $controls4 if `x'97 >0, cl(comuid)
	}

save DatGMR2, replace

*************************

*Part 3: Confirming tables

use investments_data.dta, clear

keep if wave ==2 | wave ==3 | wave ==4
replace land =. if ha ==.
g byte all =(ani1 ~=. & ani2 ~=. & land ~=. & me~=.)
keep if all ==1

foreach x in 2 3 4 {
	g byte wave`x' =(wave ==`x')
	}
foreach x in farm cons emerg {
	replace credit_`x' =0 if credit ==0 & credit_`x' ==.
	}
g crop_sales_m   = crop_sales/12
g ani_sales_a_m  = ani_sales_a/6
egen home_prod_tot_w3 =rsum(crop_sales_m ani_sales_a_m homeprod ani_prod_sales_a)
replace home_prod_tot_w3 =. if (crop_sales_m ==. & ani_sales_a_m ==. & homeprod ==. & ani_prod_sales_a ==.)
egen home_prod_tot =rsum(crop_sales_m ani_sales_a_m homeprod)
replace home_prod_tot =. if (crop_sales_m ==. & ani_sales_a_m ==. & homeprod ==.)
foreach x in crop_sales_m ani_sales_a_m ani_prod_sales_a home_prod_tot home_prod_tot_w3 ag_exp {
	g `x'_pp_ae = `x'/hhsize_ae
	g `x'_pp_ae2 = `x'/hhsize_ae2
	}
foreach x in homeprod home_prod_tot home_prod_tot_w3 homeprod_pp_ae home_prod_tot_pp_ae home_prod_tot_w3_pp_ae homeprod_pp_ae2 home_prod_tot_pp_ae2 home_prod_tot_w3_pp_ae2 {
	xtile `x'_tile =`x', nq(100) 
	sum `x' if `x'_tile <=95
	}

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
				
*Table 4 - All okay
*Their loops cover lots of regressions that aren't presented in the table - recode to select the ones that are

foreach x in home_prod_tot_pp_ae2 {
	foreach y of global treatcom1 {
		reg `x' `y' wave3 $basic $controls if home_prod_tot_tile <=95, cl(comuid)
		}
	}
foreach x in home_prod_tot_w3_pp_ae2 {
	foreach y of global treatcom1 {
		reg `x' `y' $basic $controls if home_prod_tot_w3_tile <=95 & wave ==3, cl(comuid)
		}
	}
foreach x of global dep_d {
	foreach y of global treatcom1 {
		reg `x' `y' wave3 $basic $controls, cl(comuid)
		}
	}

*Table 6 - All okay
foreach x of global credit {
	foreach y of global treatcom1 {
		reg `x' `y' $basic $controls, cl(comuid)
		}
	}

***********************************

*Part 3: My Code

use investments_data.dta, clear
keep if wave ==2 | wave ==3 | wave ==4
replace land =. if ha ==.
g byte all =(ani1 ~=. & ani2 ~=. & land ~=. & me~=.)
keep if all ==1
foreach x in 2 3 4 {
	g byte wave`x' =(wave ==`x')
	}
foreach x in farm cons emerg {
	replace credit_`x' =0 if credit ==0 & credit_`x' ==.
	}
g crop_sales_m   = crop_sales/12
g ani_sales_a_m  = ani_sales_a/6
egen home_prod_tot_w3 =rsum(crop_sales_m ani_sales_a_m homeprod ani_prod_sales_a)
replace home_prod_tot_w3 =. if (crop_sales_m ==. & ani_sales_a_m ==. & homeprod ==. & ani_prod_sales_a ==.)
egen home_prod_tot =rsum(crop_sales_m ani_sales_a_m homeprod)
replace home_prod_tot =. if (crop_sales_m ==. & ani_sales_a_m ==. & homeprod ==.)
foreach x in crop_sales_m ani_sales_a_m ani_prod_sales_a home_prod_tot home_prod_tot_w3 ag_exp {
	g `x'_pp_ae = `x'/hhsize_ae
	g `x'_pp_ae2 = `x'/hhsize_ae2
	}
foreach x in homeprod home_prod_tot home_prod_tot_w3 homeprod_pp_ae home_prod_tot_pp_ae home_prod_tot_w3_pp_ae homeprod_pp_ae2 home_prod_tot_pp_ae2 home_prod_tot_w3_pp_ae2 {
	xtile `x'_tile =`x', nq(100) 
	sum `x' if `x'_tile <=95
	}

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


*Table 4 - All okay
reg home_prod_tot_pp_ae2 t2_c1_op wave3 $basic $controls if home_prod_tot_tile <=95, cl(comuid)
reg home_prod_tot_w3_pp_ae2 t2_c1_op $basic $controls1 if home_prod_tot_w3_tile <=95 & wave ==3, cl(comuid)

foreach x in maiz frijol ani_prod credit_farm {
	reg `x' t2_c1_op wave3 $basic $controls, cl(comuid)
	}

*Table 6 - All okay
foreach x in credit credit_cons credit_farm trans_t trans_out {
	reg `x' t2_c1_op $basic $controls, cl(comuid)
	}

save DatGMR3, replace

************************************

*Part 4: Confirming tables

use investments_data.dta, clear
keep if wave == 7
drop if consumo_pp_ae ==0 | consumo_pp_ae ==.
gl public solidaridad INI probecat empleotemp procampo liconsa DIF tortilla progbecas progpapilla progmonetario amount_solidaridad amount_INI amount_probecat amount_empleotemp amount_procampo
ren amount_procampo amount_p
ren amount_t amount_t_pr
ren nonfood nonfoodexp
foreach x in foodexp nonfoodexp {
	drop `x'_pp `x'_pp_ae
	}
foreach x in amount_p amount_t_pr amount_borrowed_m outwage_lw_hh foodexp nonfoodexp {
	g `x'_pp_ae = `x'/hhsize_ae
	g `x'_pp_ae2 = `x'/hhsize_ae2
	}
egen amount_t_pb = rsum(amount_p witransfer_act_m)
replace amount_t_pb =. if amount_p ==. & witransfer_act_m ==.
egen amount_t_pb_pp_ae = rsum(amount_p_pp_ae witransfer_act_m_pp_ae)
replace amount_t_pb_pp_ae =. if amount_p_pp_ae ==. & witransfer_act_m_pp_ae ==.
egen amount_t_pb_pp_ae2 =rsum(amount_p_pp_ae2 witransfer_act_m_pp_ae2)
replace amount_t_pb_pp_ae2 =. if amount_p_pp_ae2 ==. & witransfer_act_m_pp_ae2 ==.

foreach x in consumo homeprod foodexp nonfoodexp witransfer_act_m amount_p amount_t_pb amount_t_pr amount_borrowed_m outwage_lw_hh consumo_pp_ae homeprod_pp_ae foodexp_pp_ae nonfoodexp_pp_ae witransfer_act_m_pp_ae amount_p_pp_ae amount_t_pb_pp_ae amount_t_pr_pp_ae amount_borrowed_m_pp_ae outwage_lw_hh_pp_ae consumo_pp_ae2 homeprod_pp_ae2 foodexp_pp_ae2 nonfoodexp_pp_ae2 witransfer_act_m_pp_ae2 amount_p_pp_ae2 amount_t_pb_pp_ae2 amount_t_pr_pp_ae2 amount_borrowed_m_pp_ae2 outwage_lw_hh_pp_ae2 {
	g d`x' =(`x'>0)
	}
foreach x in consumo consumo_pp_ae consumo_pp_ae2 homeprod homeprod_pp_ae homeprod_pp_ae2 foodexp foodexp_pp_ae foodexp_pp_ae2 nonfoodexp nonfoodexp_pp_ae nonfoodexp_pp_ae2 witransfer_act_m witransfer_act_m_pp_ae witransfer_act_m_pp_ae2 amount_p amount_p_pp_ae amount_p_pp_ae2 amount_t_pb amount_t_pb_pp_ae amount_t_pb_pp_ae2 amount_t_pr amount_t_pr_pp_ae amount_t_pr_pp_ae2 amount_borrowed_m amount_borrowed_m_pp_ae amount_borrowed_m_pp_ae2 outwage_lw_hh outwage_lw_hh_pp_ae outwage_lw_hh_pp_ae2 {
	xtile `x'_tl_t2 = `x' if t2_c1_op ~=., nq(200)
	xtile `x'_tl_tr = `x' if treatcom ~=. & ineligible ==1, nq(200)
	}
gl basic nbani197 nbani297 ha97
gl controls no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p homeown97 dirtfloor97 electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97


*Table 5 - All okay
*Again, drop regressions that don't appear in the table
foreach x in consumo_pp_ae2  {
	reg `x' t2_c1_op $basic hhsize_ae2_97 $controls if consumo_pp_ae2_tl_t2 >2 & consumo_pp_ae2_tl_t2 <199, cl(comuid)
	}
foreach x in homeprod_pp_ae2 witransfer_act_m_pp_ae2 amount_p_pp_ae2 amount_t_pr_pp_ae2 amount_borrowed_m_pp_ae2 {
	reg `x' t2_c1_op $basic hhsize_ae2_97 $controls if consumo_pp_ae2_tl_t2 >2 & consumo_pp_ae2_tl_t2 <199 & `x'_tl_t2 <=196, cl(comuid)
	}
foreach x in outwage_lw_hh_pp_ae2 {
	reg `x' t2_c1_op $basic hhsize_ae2_97 $controls if consumo_pp_ae2_tl_t2 >2 & consumo_pp_ae2_tl_t2 <199 & `x'_tl_t2 <=190, cl(comuid)
	}

*************************************

*Part 4: My Code

use investments_data.dta, clear
keep if wave == 7
drop if consumo_pp_ae ==0 | consumo_pp_ae ==.
gl public solidaridad INI probecat empleotemp procampo liconsa DIF tortilla progbecas progpapilla progmonetario amount_solidaridad amount_INI amount_probecat amount_empleotemp amount_procampo
ren amount_procampo amount_p
ren amount_t amount_t_pr
ren nonfood nonfoodexp
foreach x in foodexp nonfoodexp {
	drop `x'_pp `x'_pp_ae
	}
foreach x in amount_p amount_t_pr amount_borrowed_m outwage_lw_hh foodexp nonfoodexp {
	g `x'_pp_ae = `x'/hhsize_ae
	g `x'_pp_ae2 = `x'/hhsize_ae2
	}
egen amount_t_pb = rsum(amount_p witransfer_act_m)
replace amount_t_pb =. if amount_p ==. & witransfer_act_m ==.
egen amount_t_pb_pp_ae = rsum(amount_p_pp_ae witransfer_act_m_pp_ae)
replace amount_t_pb_pp_ae =. if amount_p_pp_ae ==. & witransfer_act_m_pp_ae ==.
egen amount_t_pb_pp_ae2 =rsum(amount_p_pp_ae2 witransfer_act_m_pp_ae2)
replace amount_t_pb_pp_ae2 =. if amount_p_pp_ae2 ==. & witransfer_act_m_pp_ae2 ==.

foreach x in consumo homeprod foodexp nonfoodexp witransfer_act_m amount_p amount_t_pb amount_t_pr amount_borrowed_m outwage_lw_hh consumo_pp_ae homeprod_pp_ae foodexp_pp_ae nonfoodexp_pp_ae witransfer_act_m_pp_ae amount_p_pp_ae amount_t_pb_pp_ae amount_t_pr_pp_ae amount_borrowed_m_pp_ae outwage_lw_hh_pp_ae consumo_pp_ae2 homeprod_pp_ae2 foodexp_pp_ae2 nonfoodexp_pp_ae2 witransfer_act_m_pp_ae2 amount_p_pp_ae2 amount_t_pb_pp_ae2 amount_t_pr_pp_ae2 amount_borrowed_m_pp_ae2 outwage_lw_hh_pp_ae2 {
	g d`x' =(`x'>0)
	}
foreach x in consumo consumo_pp_ae consumo_pp_ae2 homeprod homeprod_pp_ae homeprod_pp_ae2 foodexp foodexp_pp_ae foodexp_pp_ae2 nonfoodexp nonfoodexp_pp_ae nonfoodexp_pp_ae2 witransfer_act_m witransfer_act_m_pp_ae witransfer_act_m_pp_ae2 amount_p amount_p_pp_ae amount_p_pp_ae2 amount_t_pb amount_t_pb_pp_ae amount_t_pb_pp_ae2 amount_t_pr amount_t_pr_pp_ae amount_t_pr_pp_ae2 amount_borrowed_m amount_borrowed_m_pp_ae amount_borrowed_m_pp_ae2 outwage_lw_hh outwage_lw_hh_pp_ae outwage_lw_hh_pp_ae2 {
	xtile `x'_tl_t2 = `x' if t2_c1_op ~=., nq(200)
	xtile `x'_tl_tr = `x' if treatcom ~=. & ineligible ==1, nq(200)
	}
gl basic nbani197 nbani297 ha97
gl controls no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p homeown97 dirtfloor97 electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97
gl controls1 no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p homeown97 dirtfloor97 electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dirtfloor97 dummy_electricity97

*Table 5 - All okay
reg consumo_pp_ae2 t2_c1_op $basic hhsize_ae2_97 $controls1 if consumo_pp_ae2_tl_t2 >2 & consumo_pp_ae2_tl_t2 <199, cl(comuid)

foreach x in homeprod_pp_ae2 witransfer_act_m_pp_ae2 amount_p_pp_ae2 amount_t_pr_pp_ae2 amount_borrowed_m_pp_ae2 {
	reg `x' t2_c1_op $basic hhsize_ae2_97 $controls1 if consumo_pp_ae2_tl_t2 >2 & consumo_pp_ae2_tl_t2 <199 & `x'_tl_t2 <=196, cl(comuid)
	}
foreach x in outwage_lw_hh_pp_ae2 {
	reg `x' t2_c1_op $basic hhsize_ae2_97 $controls1 if consumo_pp_ae2_tl_t2 >2 & consumo_pp_ae2_tl_t2 <199 & `x'_tl_t2 <=190, cl(comuid)
	}

save DatGMR4, replace


******************

*Part 5: Confirming tables

use investments_data.dta, clear

keep if wave == 7
tab wave
drop if consumo_pp_ae ==0 | consumo_pp_ae ==.
foreach x in consumo_pp_ae2 {
	xtile `x'_tl_t2 = `x' if t2_c1_op ~=., nq(200)
	xtile `x'_tl_tr = `x' if treatcom ~=. & ineligible ==1, nq(200)
	}
sort state muni local folio wave
tempfile investments
save `investments'
use adults_morbidity_03.dta, clear
sort state muni local folio wave
merge state muni local folio wave using `investments'
keep if _merge ==3
sort state muni local folio numero wave

gl adl_d sick inactivity
gl adl_c days_sick days_inactivity nb_km moderate_adl vigorous_adl
foreach y in moderate vigorous {
	replace `y'_adl =. if `y'_adl ==0
	}
g age_sq =age*age
gl basic nbani197 nbani297 ha97
gl controls_all no497 big497 age age_sq female educ1_hh ethnicity_hh educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p homeown97 dirtfloor97 electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97

*Table 7 - All okay
foreach x of global adl_d {
	reg `x' t2_c1_op $basic hhsize_97 $controls_all if age<=64 & consumo_pp_ae2_tl_t2 >1 & consumo_pp_ae2_tl_t2 <200, cl(comuid)
	}
foreach x of global adl_c {
	reg `x' t2_c1_op $basic hhsize_97 $controls_all if age <=64 & consumo_pp_ae2_tl_t2 >1 & consumo_pp_ae2_tl_t2 <200, cl(comuid)
	}

************************************


*Part 5: My Code

use investments_data.dta, clear
keep if wave == 7
tab wave
drop if consumo_pp_ae ==0 | consumo_pp_ae ==.
foreach x in consumo_pp_ae2 {
	xtile `x'_tl_t2 = `x' if t2_c1_op ~=., nq(200)
	xtile `x'_tl_tr = `x' if treatcom ~=. & ineligible ==1, nq(200)
	}
sort state muni local folio wave
tempfile investments
save `investments'
use adults_morbidity_03.dta, clear
sort state muni local folio wave
merge state muni local folio wave using `investments'
keep if _merge ==3
sort state muni local folio numero wave
gl adl_d sick inactivity
gl adl_c days_sick days_inactivity nb_km moderate_adl vigorous_adl
foreach y in moderate vigorous {
	replace `y'_adl =. if `y'_adl ==0
	}
g age_sq =age*age
gl basic nbani197 nbani297 ha97
gl controls_all no497 big497 age age_sq female educ1_hh ethnicity_hh educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p homeown97 dirtfloor97 electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97
gl controls_all1 no497 big497 age age_sq female educ1_hh ethnicity_hh educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p homeown97 dirtfloor97 electricity97 org_faenas min_dist lnup_cwagepm up2_mcwagepm dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dirtfloor97 dummy_electricity97

*Table 7 - All okay
foreach x in sick days_sick inactivity days_inactivity nb_km moderate_adl vigorous_adl {
	reg `x' t2_c1_op $basic hhsize_97 $controls_all1 if age <=64 & consumo_pp_ae2_tl_t2 >1 & consumo_pp_ae2_tl_t2 <200, cl(comuid)
	}

save DatGMR5, replace


***********************************

*Part 6: Confirming tables, but randomization distribution not possible (see below)

use investments_data.dta, clear
drop if consumo_pp_ae ==0 
foreach x in 2 3 4 6 7 {
	g byte wave`x' =(wave ==`x')
	}
foreach x in t2_c1_op  {
	foreach y of varlist wave2 wave3 wave4{
		g `x'_`y' = `x' * `y'
		}
	}
foreach x in 02 314 1526 27p 15p {
	foreach y in act pot {
		g cum`x'_`y'_pp_ae2 =cum`x'_`y'/hhsize_ae2
		}
	}
foreach x in consumo_pp_ae2 consumo1_pp_ae2 {
	xtile `x'_tl_t2 = `x' if t2_c1_op ~=., nq(200)
	}
foreach x in witransfer_act_m_pp_ae2 {
	xtile `x'_tl_t2 = `x' if t2_c1_op ~=. & `x' >0, nq(200)
	}

gl wave wave3 wave6 wave7
gl basic nbani197 nbani297 ha97
gl controls_ae2 no497 big497 age_hh age_hh2 female_hh educ1_hh ethnicity_hh age_sp age_sp2 educ1_sp dage0_7_97 dage8_17_97 dage18_54_97 dage55p hhsize_ae2_97 homeown97 dirtfloor97  electricity97 org_faenas min_dist dummy_age_hh dummy_educ_hh dummy_ethnicity_hh dummy_age_sp dummy_educ_sp dummy_dage0_7_97 dummy_dirtfloor97 dummy_electricity97

*Table 8 - All okay 
*Remaining columns are means of transfers by wave or mpc calculated by dividing coefficient estimate by mean transfers
reg consumo1_pp_ae2 t2_c1_op_wave2 t2_c1_op_wave3 t2_c1_op_wave4 $controls_ae2 if consumo1_pp_ae2_tl_t2 >2 & consumo1_pp_ae2_tl_t2 <199 & witransfer_act_m_pp_ae2_tl_t2 ~=1 &  witransfer_act_m_pp_ae2_tl_t2 ~=2 & witransfer_act_m_pp_ae2_tl_t2 ~=199 & witransfer_act_m_pp_ae2_tl_t2 ~=200 & wave <=4, cl(comuid)
*But, can't run this because they determine the regression by the transfer amount and the transfer amount was determined by treatment (just regress witransfer_act_m_pp_ae2_tl_t2 on t2_c1_op)
*Can't reproduce the randomization distribution because can't calculate the counterfactual transfer under different randomization outcome

*Table 10 - I can't do because cannot calculate counterfactual transfers if had been randomized to different treatment as transfers varied according to eligible children in school




