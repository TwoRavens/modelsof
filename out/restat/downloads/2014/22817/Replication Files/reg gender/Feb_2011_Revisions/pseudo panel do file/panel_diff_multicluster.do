clear 
set memory 300m 
set more off
/* cd "E:\occdist\reg_gender"  */
cd "C:\Users\kp\Documents\thesis_topic occdist\reg_gender" 

foreach xobs in 100 {

foreach sx in M F {
clear

clear
log using "Feb_2011_Revisions\log_panel\paneldiff_`sx'_3clust_omb_obs`xobs'.log", replace 

use `sx'_agg_data00.dta
merge pwmetro bpl using `sx'_agg_data90.dta


/************* difference from the years *****************/
generate 	occpop1	=	occpop1_00	-	occpop1_90	
generate 	occpop2	=	occpop2_00	-	occpop2_90	
generate 	occpop3	=	occpop3_00	-	occpop3_90	
generate 	occpop4	=	occpop4_00	-	occpop4_90	
generate 	occpop5	=	occpop5_00	-	occpop5_90	
generate 	cntry_met	=	cntry_met_00	-	cntry_met_90	 
generate 	p_occ_old_country1	=	p_occ_old_country1_00	-	p_occ_old_country1_90	 
generate 	p_occ_old_country2	=	p_occ_old_country2_00	-	p_occ_old_country2_90	 
generate 	p_occ_old_country3	=	p_occ_old_country3_00	-	p_occ_old_country3_90	 
generate 	p_occ_old_country4	=	p_occ_old_country4_00	-	p_occ_old_country4_90	 
generate 	p_occ_old_country5	=	p_occ_old_country5_00	-	p_occ_old_country5_90	 
generate 	p_native_occ1	=	p_native_occ1_00	-	p_native_occ1_90	 
generate 	p_native_occ2	=	p_native_occ2_00	-	p_native_occ2_90	 
generate 	p_native_occ3	=	p_native_occ3_00	-	p_native_occ3_90	 
generate 	p_native_occ4	=	p_native_occ4_00	-	p_native_occ4_90	 
generate 	p_native_occ5	=	p_native_occ5_00	-	p_native_occ5_90	 
generate 	p_occ_met1	=	p_occ_met1_00	-	p_occ_met1_90	 
generate 	p_occ_met2	=	p_occ_met2_00	-	p_occ_met2_90	 
generate 	p_occ_met3	=	p_occ_met3_00	-	p_occ_met3_90	 
generate 	p_occ_met4	=	p_occ_met4_00	-	p_occ_met4_90	 
generate 	p_occ_met5	=	p_occ_met5_00	-	p_occ_met5_90	 
generate 	age	=	age_00	-	age_90	 
generate 	sex	=	sex_00	-	sex_90	 
generate 	english	=	english_00	-	english_90	 
generate 	age2	=	age2_00	-	age2_90	 
generate 	mean_occ_edu1	=	mean_occ_edu1_00	-	mean_occ_edu1_90	 
generate 	mean_occ_edu2	=	mean_occ_edu2_00	-	mean_occ_edu2_90	 
generate 	mean_occ_edu3	=	mean_occ_edu3_00	-	mean_occ_edu3_90	 
generate 	mean_occ_edu4	=	mean_occ_edu4_00	-	mean_occ_edu4_90	 
generate 	mean_occ_edu5	=	mean_occ_edu5_00	-	mean_occ_edu5_90	 
generate 	edu1	=	edu1_00	-	edu1_90	 
generate 	edu2	=	edu2_00	-	edu2_90	 
generate 	edu3	=	edu3_00	-	edu3_90	 
generate 	edu4	=	edu4_00	-	edu4_90	 
generate 	edu5	=	edu5_00	-	edu5_90	 
generate 	edu6	=	edu6_00	-	edu6_90	 
generate 	marst1	=	marst1_00	-	marst1_90	 
generate 	marst2	=	marst2_00	-	marst2_90	 
generate 	marst3	=	marst3_00	-	marst3_90	 
generate 	marst4	=	marst4_00	-	marst4_90	 
generate 	marst5	=	marst5_00	-	marst5_90	 
generate 	marst6	=	marst6_00	-	marst6_90	 


local controls "cntry_met  age age2 sex english edu1 edu2 edu3 edu4 edu5 edu6  marst1 marst2 marst3 marst4 marst5 marst6"

forvalues pop= 1(1)5 { 
	generate occpop=occpop`pop'
	generate p_occ_old_country = p_occ_old_country`pop'
	generate p_nat_occ = p_native_occ`pop'
	generate p_occmet = p_occ_met`pop'
	generate mean_occedu = mean_occ_edu`pop'

	display "for popular occuption: `pop'"
	xi: cgmreg occpop p_occ_old_country p_nat_occ p_occmet mean_occedu `controls'  , cluster(pwmetro bpl)
	if `pop'==1 {
	outreg p_occ_old_country p_nat_occ p_occmet mean_occedu `controls' using "Feb_2011_Revisions\reg_panel_output\paneldiff_`sx'_obs`xobs'_3clust_omb.xls", bdec(3) rdec(3) sigsymb(**,*,+) 10pct coefastr ctitle(occpop) bracket replace
	}
	else { 
	outreg p_occ_old_country p_nat_occ p_occmet mean_occedu `controls' using "Feb_2011_Revisions\reg_panel_output\paneldiff_`sx'_obs`xobs'_3clust_omb.xls", bdec(3) rdec(3) sigsymb(**,*,+) 10pct coefastr ctitle(occpop) bracket append
	}
	/* no mex */
	display "Excluding Mexicans, for popular occuption: `pop'"
	xi: cgmreg occpop p_occ_old_country p_nat_occ p_occmet mean_occedu `controls'  if bpl!=200, cluster(pwmetro bpl)
	if `pop'==1 {
	outreg p_occ_old_country p_nat_occ p_occmet mean_occedu `controls' using "Feb_2011_Revisions\reg_output\paneldiff_`sx'_obs`xobs'_3clust_omb_nomex.xls", bdec(3) rdec(3) sigsymb(**,*,+) 10pct coefastr ctitle(occpop) bracket replace
	}
	else { 
	outreg p_occ_old_country p_nat_occ p_occmet mean_occedu `controls' using "Feb_2011_Revisions\reg_output\paneldiff_`sx'_obs`xobs'_3clust_omb_nomex.xls", bdec(3) rdec(3) sigsymb(**,*,+) 10pct coefastr ctitle(occpop) bracket append
	}


	drop occpop p_occ_old_country p_nat_occ p_occmet mean_occedu  
 	}  /*forvarlues pop */
log close



} /* foreach sx */
} /* foreach xobs */

