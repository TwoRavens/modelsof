********************************************************************************
/*
Notes:
1.- This dofiles replicates results from article "URBANIZATION PATTERNS, 
	INFORMATION DIFFUSION AND FEMALE VOTING IN RURAL PARAGUAY" (Chong et al. 2018)
	
2.- You only need two datasets: "PY_dataset.dta" and "attrition_locality.dta"

3.- Before running the code you should change the directory where files are located 
*/
********************************************************************************

cd "PATH"

use "PY_dataset.dta", clear
	
*Correction when variables were missing
foreach x in age married children num_children employed languag yrseduc bornloc ///
			 hh_asset_index fecha_registro elecc_muni2010 elecc_presid2008	 	///
			 derecha izquierda centro interes log_pop mujeres_perc mujeres_PEA  ///
			 pob_0_14_perc pob_15_64_perc pob_65mas_perc analfabetos_perc 		///
			 asiste_escuela_perc TASA_women TASA_men electricidad_perc 			///
			 agua_perc basura_perc fono_fijo_perc fono_cel_perc ocupantes Rural ///
			 distancia2_final cedula_perc registrado_perc extranjero 			///
			 log_viv_ocupadas desague_perc dens_real dens_censo log_hectareas 	///
			 attendance_rallies ratio_treat {
	gen db_`x' = (`x'==.)
	replace `x' = 0 if `x'==.
}


* Individual and hh level controls
global controls_indiv  		age married children num_children employed languag yrseduc bornloc hh_asset_index 
global db_controls_indiv 	db_age db_married db_children db_num_children db_employed db_languag db_yrseduc db_bornloc db_hh_asset_index

* Village level controls
global controls_loc			log_pop mujeres_perc pob_0_14_perc pob_15_64_perc pob_65mas_perc analfabetos_perc asiste_escuela_perc TASA_women TASA_men electricidad_perc agua_perc desague_perc basura_perc fono_fijo_perc fono_cel_perc ocupantes Rural
global db_controls_loc 		db_log_pop db_mujeres_perc db_pob_0_14_perc db_pob_15_64_perc db_pob_65mas_perc db_analfabetos_perc db_asiste_escuela_perc db_TASA_women db_TASA_men db_electricidad_perc db_agua_perc db_desague_perc db_basura_perc db_fono_fijo_perc db_fono_cel_perc db_ocupantes db_Rural
	
* Village level controls+distance
global controls_loc2 		log_pop mujeres_perc pob_0_14_perc pob_15_64_perc pob_65mas_perc analfabetos_perc asiste_escuela_perc TASA_women TASA_men electricidad_perc agua_perc desague_perc basura_perc fono_fijo_perc fono_cel_perc ocupantes Rural  distancia2_final 
global db_controls_loc2 	db_log_pop db_mujeres_perc db_pob_0_14_perc db_pob_15_64_perc db_pob_65mas_perc db_analfabetos_perc db_asiste_escuela_perc db_TASA_women db_TASA_men db_electricidad_perc db_agua_perc db_desague_perc db_basura_perc db_fono_fijo_perc db_fono_cel_perc db_ocupantes db_Rural db_distancia2_final

********************************************************************************
**********Table 1: Effect of GOTV Campaings on Registration and Turnout*********
********************************************************************************

*PANEL A: Effect of the treatment on Registration

**Contacted Household
cap drop uno
reg registro massive D2DT $controls_indiv $controls_loc2 fecha_registro if D2DC!=1, cluster(loc)
gen uno=1 if e(sample)
sum registro if e(sample) & control==1
	reg registro massive D2DT 																											 if uno==1 , cluster(loc)
	reg registro massive D2DT $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 										 if uno==1 , cluster(loc)
	reg registro massive D2DT $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1								     if uno==1 , cluster(loc)
	reg registro massive D2DT $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 fecha_registro db_fecha_registro if uno==1 , cluster(loc)

**Uncontacted Household
cap drop uno
reg registro massive D2DC $controls_indiv $controls_loc2 fecha_registro if D2DT!=1, cluster(loc)
gen uno=1 if e(sample)
sum registro if e(sample) & control==1
	reg registro massive D2DC 																											 if uno==1 , cluster(loc)
	reg registro massive D2DC $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 										 if uno==1 , cluster(loc)
	reg registro massive D2DC $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 								 if uno==1 , cluster(loc)
	reg registro massive D2DC $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 fecha_registro db_fecha_registro if uno==1 , cluster(loc)
	local r2=e(r2)
	dis `r2'
*PANEL B: Effect of the treatment on Turnout

**Contacted Household
cap drop uno
reg elecc_presid2013 massive D2DT $controls_indiv $controls_loc2 elecc_presid2008 if D2DC!=1, cluster(loc)
gen uno=1 if e(sample)
sum elecc_presid2013 if e(sample) & control==1
	reg elecc_presid2013 massive D2DT 																												 if uno==1 , cluster(loc)
	local r2=e(r2)
	dis `r2'
	reg elecc_presid2013 massive D2DT $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 											 if uno==1 , cluster(loc)
	reg elecc_presid2013 massive D2DT $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 									 if uno==1 , cluster(loc)
	reg elecc_presid2013 massive D2DT $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if uno==1 , cluster(loc)

**Uncontacted Household
cap drop uno
reg elecc_presid2013 massive D2DC $controls_indiv $controls_loc2 elecc_presid2008 if D2DT!=1, cluster(loc)
gen uno=1 if e(sample)
sum elecc_presid2013 if e(sample) & control==1
	reg elecc_presid2013 massive D2DC 																												 if uno==1 , cluster(loc)
	reg elecc_presid2013 massive D2DC $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 											 if uno==1 , cluster(loc)
	reg elecc_presid2013 massive D2DC $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 									 if uno==1 , cluster(loc)
	reg elecc_presid2013 massive D2DC $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if uno==1 , cluster(loc)
	local r2=e(r2)
	dis `r2'

********************************************************************************
****************Table 2: Lee (2009) bounds for treatment-effects****************
********************************************************************************
*Instalation of 'leebounds' command:
ssc install leebounds	
	
preserve
	reg registro massive D2DT D2DC $controls_indiv $controls_loc2 fecha_registro, cluster(loc)
	keep if e(sample)

	set obs 5621
	gen 	attrited=1 	if id_indiv==.
	gen 	ident	=_n if attrited==1
	
	replace control	=1 	if ident>=4034 				&  ident<(4034+517)
	replace control	=0 	if ident>=4034+517 			&  ident~=.
	
	replace massive	=1 	if ident>=4034+517 			&  ident< 4034+517+619
	replace massive	=0 	if ident< 4034+517 			| (ident>=4034+517+619 			& ident~=.)
	
	replace D2DT	=1 	if ident>=4034+517+619 		&  ident< 4034+517+619+185
	replace D2DT	=0 	if ident< 4034+517+619 		| (ident>=4034+517+619+185 		& ident~=.)
	
	replace D2DC	=1 	if ident>=4034+517+619+185 	&  ident< 4034+517+619+185+267
	replace D2DC	=0 	if ident< 4034+517+619+185 	| (ident>=4034+517+619+185+267 	& ident~=.)

	reg 	  elecc_presid2013 massive 	if D2DT==0 	  & D2DC==0
	leebounds elecc_presid2013 massive 	if D2DT==0 	  & D2DC==0

	reg 	  elecc_presid2013 D2DC 	if massive==0 & D2DT==0
	leebounds elecc_presid2013 D2DC 	if massive==0 & D2DT==0

	reg 	  elecc_presid2013 D2DT		if massive==0 & D2DC==0
	leebounds elecc_presid2013 D2DT 	if massive==0 & D2DC==0
restore	

	
********************************************************************************
*********Table 3: Effect of GOTV Campaigns on Registration and Turnout,********* 
**************************by Linearity of the Locality**************************
********************************************************************************

*PANEL A: Effect of the treatment on Registration

**Contacted Household
cap drop uno
reg registro massive D2DT $controls_indiv $controls_loc2 fecha_registro if D2DC!=1, cluster(loc)
gen uno=1 if e(sample)

		
	reg registro massive D2DT $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 fecha_registro db_fecha_registro if uno==1			  , cluster(loc)
	sum registro if e(sample) & control==1
	
	reg registro massive D2DT $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 fecha_registro db_fecha_registro if uno==1 & lineal==0, cluster(loc)
	sum registro if e(sample) & control==1
	
	reg registro massive D2DT $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 fecha_registro db_fecha_registro if uno==1 & lineal==1, cluster(loc)
	sum registro if e(sample) & control==1
	
**Uncontacted Household
cap drop uno
reg registro massive D2DC $controls_indiv $controls_loc2 fecha_registro if D2DT!=1, cluster(loc)
gen uno=1 if e(sample)

	reg registro massive D2DC $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 fecha_registro db_fecha_registro if uno==1 			  , cluster(loc)
	sum registro if e(sample) & control==1
	
	reg registro massive D2DC $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 fecha_registro db_fecha_registro if uno==1 & lineal==0, cluster(loc)
	sum registro if e(sample) & control==1
	
	reg registro massive D2DC $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 fecha_registro db_fecha_registro if uno==1 & lineal==1, cluster(loc)
	sum registro if e(sample) & control==1
	
**P-values	
	qui reg registro massive D2DT $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 fecha_registro db_fecha_registro if D2DC!=1 & lineal==0
	est store lineal_t
	qui reg registro massive D2DT $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 fecha_registro db_fecha_registro if D2DC!=1 & lineal==1
	est store nolineal_t
	suest lineal_t nolineal_t, cluster(loc)
	test [lineal_t_mean]D2DT=[nolineal_t_mean]D2DT

	reg registro massive D2DC $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 fecha_registro db_fecha_registro if D2DT!=1 & lineal==0
	est store lineal_c
	reg registro massive D2DC $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 fecha_registro db_fecha_registro if D2DT!=1 & lineal==1
	est store nolineal_c
	suest lineal_c nolineal_c, cluster(loc)
	test [lineal_c_mean]D2DC=[nolineal_c_mean]D2DC
	
*PANEL B: Effect of the treatment on Turnout	
	
**Contacted Household	
drop uno
estimates drop _all
reg elecc_presid2013 massive D2DT $controls_indiv $controls_loc2 elecc_presid2008 if D2DC!=1, cluster(loc)
gen uno=1 if e(sample)
	
	reg elecc_presid2013 massive D2DT $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if uno==1			  , cluster(loc)
	sum elecc_presid2013 if e(sample) & control==1
	
	reg elecc_presid2013 massive D2DT $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if uno==1 & lineal==0, cluster(loc)
	sum elecc_presid2013 if e(sample) & control==1
	
	reg elecc_presid2013 massive D2DT $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if uno==1 & lineal==1, cluster(loc)
	sum elecc_presid2013 if e(sample) & control==1
	
**Uncontacted Household
drop uno
reg elecc_presid2013 massive D2DC $controls_indiv $controls_loc2 elecc_presid2008 if D2DT!=1, cluster(loc)
gen uno=1 if e(sample)

	reg elecc_presid2013 massive D2DC $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if uno==1			  , cluster(loc)
	sum elecc_presid2013 if e(sample) & control==1
	
	reg elecc_presid2013 massive D2DC $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if uno==1 & lineal==0, cluster(loc)
	sum elecc_presid2013 if e(sample) & control==1
	
	reg elecc_presid2013 massive D2DC $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if uno==1 & lineal==1, cluster(loc)
	sum elecc_presid2013 if e(sample) & control==1
	
**P-values
	qui reg elecc_presid2013 massive D2DT $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if D2DC!=1 & lineal==0
	est store lineal_t
	qui reg elecc_presid2013 massive D2DT $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if D2DC!=1 & lineal==1
	est store nolineal_t
	qui suest lineal_t nolineal_t, cluster(loc)
	test [lineal_t_mean]D2DT=[nolineal_t_mean]D2DT
	
	qui reg elecc_presid2013 massive D2DC $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if D2DT!=1 & lineal==0
	est store lineal_c
	qui reg elecc_presid2013 massive D2DC $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if D2DT!=1 & lineal==1
	est store nolineal_c
	qui suest lineal_c nolineal_c, cluster(loc)
	test [lineal_c_mean]D2DC=[nolineal_c_mean]D2DC

	
********************************************************************************
****Table 4: Estimating Reinforcement and Diffusion Effects - 2SLS Estimates****
********************************************************************************

gen D2D30 = (treat2 == "Treat 30%")
gen D2D40 = (treat2 == "Treat 40%")
gen D2D50 = (treat2 == "Treat 50%")


**Reinforcement Effect
	ivreg2 elecc_presid2013 massive (ratio_treat=D2D30 D2D40 D2D50) db_ratio_treat $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if D2DC!=1			, cluster(loc) 
	sum elecc_presid2013 if e(sample) & control==1
	
	ivreg2 elecc_presid2013 massive (ratio_treat=D2D30 D2D40 D2D50) db_ratio_treat $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if D2DC!=1 & lineal==0, cluster(loc) 
	sum elecc_presid2013 if e(sample) & control==1
	
	ivreg2 elecc_presid2013 massive (ratio_treat=D2D30 D2D40 D2D50) db_ratio_treat $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if D2DC!=1 & lineal==1, cluster(loc) 
	sum elecc_presid2013 if e(sample) & control==1
	
**Diffusion Effect
	ivreg2 elecc_presid2013 massive (ratio_treat=D2D30 D2D40 D2D50) db_ratio_treat $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if D2DT!=1			, cluster(loc) 
	sum elecc_presid2013 if e(sample) & control==1
	
	ivreg2 elecc_presid2013 massive (ratio_treat=D2D30 D2D40 D2D50) db_ratio_treat $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if D2DT!=1 & lineal==0, cluster(loc) 
	sum elecc_presid2013 if e(sample) & control==1
	
	ivreg2 elecc_presid2013 massive (ratio_treat=D2D30 D2D40 D2D50) db_ratio_treat $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if D2DT!=1 & lineal==1, cluster(loc) 
	sum elecc_presid2013 if e(sample) & control==1
	
********************************************************************************
***********Table A.1: Descriptive Statistics at the Individual Level,*********** 
*******************************by treatment status******************************
********************************************************************************

reg elecc_presid2013 massive D2DT D2DC $controls_indiv $controls_loc2 elecc_presid2008, cluster(loc)
preserve
	keep if e(sample)
	foreach x in age married children num_children employed languag yrseduc bornloc ///
				 hh_asset_index ratio_treat fecha_registro registro elecc_muni2010  ///
				 elecc_presid2013 {

		reg `x' control massive D2D if elecc_presid2013 != . , noc cl(loc)
		lincom massive - control
		lincom D2D 	   - control
		lincom D2D 	   - control


		reg `x' control massive D2DT D2DC if elecc_presid2013 != . , noc cl(loc)
		estimates store r2_`x'
		lincom D2DT - control
		lincom D2DC - control
	}
restore


********************************************************************************
***********Table A.2: Descriptive Statistics at the Individual Level,*********** 
***************************by linearity of the Locality*************************
********************************************************************************

reg elecc_presid2013 massive D2DT D2DC $controls_indiv $controls_loc2 elecc_presid2008, cluster(loc)
preserve
	keep if e(sample)
	foreach x in age married children num_children employed languag yrseduc bornloc ///
				 hh_asset_index ratio_treat fecha_registro registro elecc_muni2010  ///
				 elecc_presid2013 {

		reg `x' lineal lineal_inv if elecc_presid2013 != . , noc cl(loc)
		lincom lineal_inv - lineal
	}
restore		


********************************************************************************
************Table A.3: Descriptive Statistics at the Locality Level,************
*******************************by treatment status******************************
********************************************************************************


reg elecc_presid2013 massive D2DT D2DC $controls_indiv $controls_loc2 elecc_presid2008, cluster(loc)
preserve
	keep if e(sample)
	collapse (mean) log_pop mujeres_perc mujeres_PEA pob_0_14_perc pob_15_64_perc 	///
					pob_65mas_perc analfabetos_perc asiste_escuela_perc TASA_women 	///
					TASA_men electricidad_perc agua_perc basura_perc fono_fijo_perc ///
					fono_cel_perc ocupantes Rural distancia2_final cedula_perc 		///
					registrado_perc extranjero log_viv_ocupadas desague_perc 		///
					dens_real dens_censo log_hectareas ratio_treat 					///
					attendance_rallies control massive D2D D2D30 D2D40 D2D50 lineal ///
					lineal_inv, by(loc)

	foreach x in 	log_pop mujeres_perc mujeres_PEA pob_0_14_perc pob_15_64_perc 	///
					pob_65mas_perc analfabetos_perc asiste_escuela_perc TASA_women 	///
					TASA_men electricidad_perc agua_perc basura_perc fono_fijo_perc	///
					fono_cel_perc ocupantes Rural distancia2_final cedula_perc 		///
					registrado_perc extranjero log_viv_ocupadas desague_perc 		///
					dens_real dens_censo log_hectareas ratio_treat 					///
					attendance_rallies {

		reg `x' control massive D2D, noc 
		lincom massive - control
		lincom D2D 	   - control
		lincom D2D 	   - control
	}
restore 


********************************************************************************
************Table A.4: Descriptive Statistics at the Locality Level,************
***************************by linearity of the Locality*************************
********************************************************************************

reg elecc_presid2013 massive D2DT D2DC $controls_indiv $controls_loc2 elecc_presid2008, cluster(loc)
preserve
	keep if e(sample)
	collapse (mean) log_pop mujeres_perc mujeres_PEA pob_0_14_perc pob_15_64_perc 	///
					pob_65mas_perc analfabetos_perc asiste_escuela_perc TASA_women 	///
					TASA_men electricidad_perc agua_perc basura_perc fono_fijo_perc ///
					fono_cel_perc ocupantes Rural distancia2_final cedula_perc 		///
					registrado_perc extranjero log_viv_ocupadas desague_perc 		///
					dens_real dens_censo log_hectareas ratio_treat 					///
					attendance_rallies control massive D2D D2D30 D2D40 D2D50 lineal ///
					lineal_inv, by(loc)

	foreach x in 	log_pop mujeres_perc mujeres_PEA pob_0_14_perc pob_15_64_perc 	///
					pob_65mas_perc analfabetos_perc asiste_escuela_perc TASA_women 	///
					TASA_men electricidad_perc agua_perc basura_perc fono_fijo_perc	///
					fono_cel_perc ocupantes Rural distancia2_final cedula_perc 		///
					registrado_perc extranjero log_viv_ocupadas desague_perc 		///
					dens_real dens_censo log_hectareas ratio_treat 					///
					attendance_rallies {

		reg `x' lineal lineal_inv, noc 
		lincom lineal_inv - lineal
	}
restore


********************************************************************************
************Table A.5: Correlates of Attrition at the locality level************
********************************************************************************
preserve
	use "attrition_locality.dta", clear
	
	reg loc_non_att  massive D2D,  
	reg loc_non_att  massive D2D $controls_loc  
	reg loc_non_att  massive D2D $controls_loc dpto1
	reg loc_non_att  massive D2D $controls_loc dpto1 lineal  
restore

********************************************************************************
***********Table A.6: Correlates of Attrition at the individual level***********
********************************************************************************

reg registro massive D2DT D2DC $controls_indiv $controls_loc2 fecha_registro, cluster(loc)

preserve
	keep if e(sample)
	gen non_attrition=1
	
	gen MMA=0
	set obs 4922
	replace MMA=1 if MMA==.
	gen ident=_n 
	replace control=1 	if ident>=(4034) 			& ident<(4034+265)
	replace control=0 	if control==.
	replace massive=1	if ident>=(4034+265) 		& ident<(4034+265+339)
	replace massive=0 	if massive==.
	replace D2D	   =1	if ident>=(4034+265+339) 	& ident<(4034+265+339+285)
	replace D2D	   =0	if D2D==.
	replace D2DT   =1 	if ident>=(4034+265+339) 	& ident<(4034+265+339+124)
	replace D2DT   =0	if D2DT==.
	replace D2DC   =1 	if ident>=(4034+265+339+124) & ident<(4034+265+339+124+161)
	replace D2DC   =0	if D2DC==.

	drop ident
	set obs 5621
	replace MMA=1 if MMA==.
	gen ident=_n 
	replace control=1 	if ident>=(4923) 			& ident<(4923+252)
	replace control=0 	if control==.
	replace massive=1	if ident>=(4923+252) 		& ident<(4923+252+280)
	replace massive=0 	if massive==.
	replace D2D	   =1	if ident>=(4923+252+280) 	& ident<(4923+252+280+167)
	replace D2D	   =0	if D2D==.
	replace D2DT   =1 	if ident>=(4923+252+280) 	& ident<(4923+252+280+61)
	replace D2DT   =0	if D2DT==.
	replace D2DC   =1 	if ident>=(4923+252+280+61) & ident<(4923+252+280+61+106)
	replace D2DC   =0	if D2DC==.

	drop ident
	gen IA=0
	set obs 5987
	replace IA=1 if IA==.
	gen ident=_n 
	replace control=1 	if ident>=(5622) 			& ident<(5622+99)
	replace control=0 	if control==.
	replace massive=1	if ident>=(5622+99) 		& ident<(5622+99+57)
	replace massive=0 	if massive==.
	replace D2D	   =1	if ident>=(5622+99+57) 		& ident<(5622+99+57+210)
	replace D2D	   =0	if D2D==.
	replace D2DT   =1 	if ident>=(5622+99+57) 		& ident<(5622+99+57+161)
	replace D2DT   =0	if D2DT==.
	replace D2DC   =1 	if ident>=(5622+99+57+161)  & ident<(5622+99+57+161+49)
	replace D2DC   =0	if D2DC==.

	drop ident
	gen LA=0
	set obs 6250
	replace LA=1 if LA==.
	gen ident=_n 
	replace control=1 	if ident>=(5988) 			& ident<(5988+114)
	replace control=0 	if control==.
	replace massive=1	if ident>=(5988+114) 		& ident<(5988+114+20)
	replace massive=0 	if massive==.
	replace D2D	   =1	if ident>=(5988+114+20) 	& ident<(5988+114+20+129)
	replace D2D	   =0	if D2D==.
	replace D2DT   =1 	if ident>=(5988+114+20) 	& ident<(5988+114+20+62)
	replace D2DT   =0	if D2DT==.
	replace D2DC   =1 	if ident>=(5988+114+20+62)  & ident<(5988+114+20+62+67)
	replace D2DC   =0	if D2DC==.
	
	replace non_attrition=0 if non_attrition==.
	replace IA			 =0 if IA ==.
	replace MMA			 =0 if MMA==.
	replace LA			 =0 if LA ==.
	
	label var IA  "Individual level attrition"
	label var MMA "Missing surveys and administratives records attrition"
	label var LA  "Location level attrition"
	
	reg non_attrition massive D2D
	reg non_attrition massive D2DT D2DC
restore

********************************************************************************
**********Table A.7: Effects of treatments on Registration and Turnout,*********
*********************comparing independently against control********************
********************************************************************************

*Effect of the treatment on Registration
reg registro massive $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 fecha_registro db_fecha_registro if D2DC==0 	  & D2DT==0			   , cluster(loc)
reg registro massive $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 fecha_registro db_fecha_registro if D2DC==0 	  & D2DT==0 & lineal==0, cluster(loc)
reg registro massive $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 fecha_registro db_fecha_registro if D2DC==0 	  & D2DT==0 & lineal==1, cluster(loc)

reg registro D2DC 	 $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 fecha_registro db_fecha_registro if massive==0 & D2DT==0			   , cluster(loc)
reg registro D2DC 	 $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 fecha_registro db_fecha_registro if massive==0 & D2DT==0 & lineal==0, cluster(loc)
reg registro D2DC 	 $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 fecha_registro db_fecha_registro if massive==0 & D2DT==0 & lineal==1, cluster(loc)

reg registro D2DT 	 $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 fecha_registro db_fecha_registro if massive==0 & D2DC==0			   , cluster(loc)
reg registro D2DT 	 $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 fecha_registro db_fecha_registro if massive==0 & D2DC==0 & lineal==0, cluster(loc)
reg registro D2DT 	 $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 fecha_registro db_fecha_registro if massive==0 & D2DC==0 & lineal==1, cluster(loc)


*Effect of the treatment on Turnout
reg elecc_presid2013 massive $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if D2DC==0 	  & D2DT==0			   , cluster(loc)
reg elecc_presid2013 massive $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if D2DC==0 	  & D2DT==0 & lineal==0, cluster(loc)
reg elecc_presid2013 massive $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if D2DC==0 	  & D2DT==0 & lineal==1, cluster(loc)

reg elecc_presid2013 D2DC 	 $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if massive==0 & D2DT==0			   , cluster(loc)
reg elecc_presid2013 D2DC 	 $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if massive==0 & D2DT==0 & lineal==0, cluster(loc)
reg elecc_presid2013 D2DC 	 $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if massive==0 & D2DT==0 & lineal==1, cluster(loc)

reg elecc_presid2013 D2DT 	 $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if massive==0 & D2DC==0			   , cluster(loc)
reg elecc_presid2013 D2DT 	 $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if massive==0 & D2DC==0 & lineal==0, cluster(loc)
reg elecc_presid2013 D2DT 	 $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if massive==0 & D2DC==0 & lineal==1, cluster(loc)


********************************************************************************
***********Table A.8: Spillover effects, controlling for interactions***********
*******************between the treatment and other covariates*******************
********************************************************************************

gen D2D_lineal	  =D2D	  *lineal
gen massive_lineal=massive*lineal

preserve
	foreach var in  $controls_indiv $controls_loc2 {
		sum `var'
		replace `var'=`var'-r(mean)
	}
	
	foreach var in  $controls_indiv $controls_loc2 {
		gen	`var'_D2D=`var'*D2D
		gen	`var'_massive=`var'*massive
	}

	global interactions_indiv 	age_D2D age_massive married_D2D married_massive children_D2D children_massive num_children_D2D num_children_massive employed_D2D employed_massive languag_D2D languag_massive yrseduc_D2D yrseduc_massive bornloc_D2D bornloc_massive hh_asset_index_D2D hh_asset_index_massive
	global interactions_loc 	distancia2_final_massive distancia2_final_D2D Rural_massive Rural_D2D ocupantes_massive ocupantes_D2D fono_cel_perc_massive fono_cel_perc_D2D fono_fijo_perc_massive fono_fijo_perc_D2D basura_perc_massive basura_perc_D2D desague_perc_massive desague_perc_D2D agua_perc_massive agua_perc_D2D electricidad_perc_massive electricidad_perc_D2D TASA_men_massive TASA_men_D2D TASA_women_massive TASA_women_D2D asiste_escuela_perc_massive asiste_escuela_perc_D2D analfabetos_perc_massive analfabetos_perc_D2D pob_65mas_perc_massive pob_65mas_perc_D2D pob_15_64_perc_massive pob_15_64_perc_D2D pob_0_14_perc_massive pob_0_14_perc_D2D mujeres_perc_massive mujeres_perc_D2D log_pop_massive log_pop_D2D

	*PANEL A: Effect of the treatment on Registration
	**Targeted Households
	cap drop uno
	reg registro massive D2D $controls_indiv $controls_loc2 $interactions_indiv $interactions_loc fecha_registro if D2DC!=1, cluster(loc)
	gen uno=1 if e(sample)		
		reg registro massive D2D D2D_lineal massive_lineal lineal $controls_indiv $controls_loc2 										fecha_registro if uno==1, cluster(loc)
		reg registro massive D2D D2D_lineal massive_lineal lineal $controls_indiv $controls_loc2  $interactions_indiv 					fecha_registro if uno==1, cluster(loc)
		reg registro massive D2D D2D_lineal massive_lineal lineal $controls_indiv $controls_loc2  $interactions_indiv $interactions_loc fecha_registro if uno==1, cluster(loc)

	**Untargeted Households
	cap drop uno
	reg registro massive D2D $controls_indiv $controls_loc2 $interactions_indiv $interactions_loc elecc_presid2008 if D2DT!=1, cluster(loc)
	gen uno=1 if e(sample)
		reg registro massive D2D D2D_lineal massive_lineal lineal $controls_indiv $controls_loc2 										fecha_registro if uno==1, cluster(loc)
		reg registro massive D2D D2D_lineal massive_lineal lineal $controls_indiv $controls_loc2  $interactions_indiv 					fecha_registro if uno==1, cluster(loc)
		reg registro massive D2D D2D_lineal massive_lineal lineal $controls_indiv $controls_loc2  $interactions_indiv $interactions_loc fecha_registro if uno==1, cluster(loc)

	*Effect of the treatment on Turnout
	**Targeted Households
	cap drop uno
	reg elecc_presid2013 massive D2D $controls_indiv $controls_loc2 $interactions_indiv  $interactions_loc elecc_presid2008 if D2DC!=1, cluster(loc)
	gen uno=1 if e(sample)	
		reg elecc_presid2013 massive D2D D2D_lineal massive_lineal lineal $controls_indiv $controls_loc2 										elecc_presid2008 if uno==1, cluster(loc)
		reg elecc_presid2013 massive D2D D2D_lineal massive_lineal lineal $controls_indiv $controls_loc2 $interactions_indiv 					elecc_presid2008 if uno==1, cluster(loc)
		reg elecc_presid2013 massive D2D D2D_lineal massive_lineal lineal $controls_indiv $controls_loc2 $interactions_indiv  $interactions_loc elecc_presid2008 if uno==1, cluster(loc)

	**Untargeted Households
	cap drop uno
	reg elecc_presid2013 massive D2D $controls_indiv $controls_loc2 $interactions_indiv  $interactions_loc elecc_presid2008 if D2DT!=1, cluster(loc)
	gen uno=1 if e(sample)
		reg elecc_presid2013 massive D2D D2D_lineal massive_lineal lineal $controls_indiv $controls_loc2 										elecc_presid2008 if uno==1, cluster(loc)
		reg elecc_presid2013 massive D2D D2D_lineal massive_lineal lineal $controls_indiv $controls_loc2 $interactions_indiv 					elecc_presid2008 if uno==1, cluster(loc)
		reg elecc_presid2013 massive D2D D2D_lineal massive_lineal lineal $controls_indiv $controls_loc2 $interactions_indiv  $interactions_loc elecc_presid2008 if uno==1, cluster(loc)
restore		



********************************************************************************
**************Table A.9: Estimating Spillover Effects - First Stage*************
********************************************************************************

**Targeted Households
	ivreg2 elecc_presid2013 massive (ratio_treat=D2D30 D2D40 D2D50) db_ratio_treat $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if D2DC!=1			, cluster(loc) first
	ivreg2 elecc_presid2013 massive (ratio_treat=D2D30 D2D40 D2D50) db_ratio_treat $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if D2DC!=1 & lineal==0, cluster(loc) first
	ivreg2 elecc_presid2013 massive (ratio_treat=D2D30 D2D40 D2D50) db_ratio_treat $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if D2DC!=1 & lineal==1, cluster(loc) first

**Untargeted Households
	ivreg2 elecc_presid2013 massive (ratio_treat=D2D30 D2D40 D2D50) db_ratio_treat $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if D2DT!=1			, cluster(loc) first 
	ivreg2 elecc_presid2013 massive (ratio_treat=D2D30 D2D40 D2D50) db_ratio_treat $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if D2DT!=1 & lineal==0, cluster(loc) first 
	ivreg2 elecc_presid2013 massive (ratio_treat=D2D30 D2D40 D2D50) db_ratio_treat $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if D2DT!=1 & lineal==1, cluster(loc) first 


********************************************************************************
***********Table A.10: Estimating Spillover Effects - OLS Regressions***********
********************************************************************************

**Targeted Households
	reg elecc_presid2013 massive ratio_treat db_ratio_treat $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if D2DC!=1			 , cluster(loc) 
	reg elecc_presid2013 massive ratio_treat db_ratio_treat $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if D2DC!=1 & lineal==0, cluster(loc) 
	reg elecc_presid2013 massive ratio_treat db_ratio_treat $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if D2DC!=1 & lineal==1, cluster(loc) 

**Untargeted Households
	reg elecc_presid2013 massive ratio_treat db_ratio_treat $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if D2DT!=1			 , cluster(loc)  
	reg elecc_presid2013 massive ratio_treat db_ratio_treat $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if D2DT!=1 & lineal==0, cluster(loc)  
	reg elecc_presid2013 massive ratio_treat db_ratio_treat $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if D2DT!=1 & lineal==1, cluster(loc)  

********************************************************************************
***********Table A.11: Effect of GOTV Campaigns on Turnout – Full Sample********
********************************************************************************

** Full Sample

cap drop uno
qui reg elecc_presid2013 massive D2DT D2DC $controls_indiv $controls_loc2 elecc_presid2008, cluster(loc)
gen uno=1 if e(sample)
reg elecc_presid2013 massive D2DT  D2DC $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if uno==1 , cluster(loc)

lincom 0.356*D2DT+0.644*D2DC-2*massive
test 0.356*D2DT+0.644*D2DC=2*massive

local sign = sign(_b[D2DT]+_b[D2DC]-2*_b[massive])
display "H0: D2DT + D2DC < 2*massive p-value = " 1-ttail(r(df_r),`sign'*sqrt(r(F)))
display "H0: D2DT + D2DC > 2*massive p-value = " ttail(r(df_r),`sign'*sqrt(r(F)))

* Linear Household 

cap drop uno
qui reg elecc_presid2013 massive D2DT D2DC $controls_indiv $controls_loc2 elecc_presid2008, cluster(loc)
gen uno=1 if e(sample)
reg elecc_presid2013 massive D2DT D2DC $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if uno==1 & lineal==0, cluster(loc)

lincom 0.356*D2DT+0.644*D2DC-2*massive
test 0.356*D2DT+0.644*D2DC=2*massive
 
local sign = sign(_b[D2DT]+_b[D2DC]-2*_b[massive])
display "H0: D2DT + D2DC < 2*massive p-value = " 1-ttail(r(df_r),`sign'*sqrt(r(F)))
display "H0: D2DT + D2DC > 2*massive p-value = " ttail(r(df_r),`sign'*sqrt(r(F)))

*Non-linear Contacted Household 
cap drop uno
qui reg elecc_presid2013 massive D2DT D2DC $controls_indiv $controls_loc2 elecc_presid2008, cluster(loc)
gen uno=1 if e(sample)
reg elecc_presid2013 massive D2DT D2DC $controls_indiv $controls_loc2 $db_controls_indiv $db_controls_loc2 dpto1 elecc_presid2008 db_elecc_presid2008 if uno==1 & lineal==1, cluster(loc)

lincom 0.356*D2DT+0.644*D2DC-2*massive
test 0.356*D2DT+0.644*D2DC=2*massive
 
local sign = sign(_b[D2DT]+_b[D2DC]-2*_b[massive])
display "H0: D2DT + D2DC < 2*massive p-value = " 1-ttail(r(df_r),`sign'*sqrt(r(F)))
display "H0: D2DT + D2DC > 2*massive p-value = " ttail(r(df_r),`sign'*sqrt(r(F)))
