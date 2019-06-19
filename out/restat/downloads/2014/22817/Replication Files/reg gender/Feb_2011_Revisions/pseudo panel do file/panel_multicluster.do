clear 
set memory 300m 
set more off
/* cd "E:\occdist\reg_gender"  */
cd "C:\Users\kp\Documents\thesis_topic occdist\reg_gender" 

foreach xobs in 100 200 500{

foreach sx in M F {
clear

clear


use `sx'_agg_data00_x`xobs'.dta
merge pwmetro bpl using `sx'_agg_data90_x`xobs'.dta
keep if _merge==3 
drop _merge 

/********************DIfference out the average*************/
#delimit;

generate 	occpop1				=	(	occpop1_00	+	occpop1_90	)	/2		;
generate 	occpop2				=	(	occpop2_00	+	occpop2_90	)	/2		;
generate 	occpop3				=	(	occpop3_00	+	occpop3_90	)	/2		;
generate 	occpop4				=	(	occpop4_00	+	occpop4_90	)	/2		;
generate 	occpop5				=	(	occpop5_00	+	occpop5_90	)	/2		;
generate 	cntry_met				=	(	cntry_met_00	+	cntry_met_90	)	/2		;
generate 	p_occ_old_country1				=	(	p_occ_old_country1_00	+	p_occ_old_country1_90	)	/2		;
generate 	p_occ_old_country2				=	(	p_occ_old_country2_00	+	p_occ_old_country2_90	)	/2		;
generate 	p_occ_old_country3				=	(	p_occ_old_country3_00	+	p_occ_old_country3_90	)	/2		;
generate 	p_occ_old_country4				=	(	p_occ_old_country4_00	+	p_occ_old_country4_90	)	/2		;
generate 	p_occ_old_country5				=	(	p_occ_old_country5_00	+	p_occ_old_country5_90	)	/2		;
generate 	p_native_occ1				=	(	p_native_occ1_00	+	p_native_occ1_90	)	/2		;
generate 	p_native_occ2				=	(	p_native_occ2_00	+	p_native_occ2_90	)	/2		;
generate 	p_native_occ3				=	(	p_native_occ3_00	+	p_native_occ3_90	)	/2		;
generate 	p_native_occ4				=	(	p_native_occ4_00	+	p_native_occ4_90	)	/2		;
generate 	p_native_occ5				=	(	p_native_occ5_00	+	p_native_occ5_90	)	/2		;
generate 	p_occ_met1				=	(	p_occ_met1_00	+	p_occ_met1_90	)	/2		;
generate 	p_occ_met2				=	(	p_occ_met2_00	+	p_occ_met2_90	)	/2		;
generate 	p_occ_met3				=	(	p_occ_met3_00	+	p_occ_met3_90	)	/2		;
generate 	p_occ_met4				=	(	p_occ_met4_00	+	p_occ_met4_90	)	/2		;
generate 	p_occ_met5				=	(	p_occ_met5_00	+	p_occ_met5_90	)	/2		;
generate 	age				=	(	age_00	+	age_90	)	/2		;
generate 	sex				=	(	sex_00	+	sex_90	)	/2		;
generate 	english				=	(	english_00	+	english_90	)	/2		;
generate 	age2				=	(	age2_00	+	age2_90	)	/2		;
generate 	mean_occ_edu1				=	(	mean_occ_edu1_00	+	mean_occ_edu1_90	)	/2		;
generate 	mean_occ_edu2				=	(	mean_occ_edu2_00	+	mean_occ_edu2_90	)	/2		;
generate 	mean_occ_edu3				=	(	mean_occ_edu3_00	+	mean_occ_edu3_90	)	/2		;
generate 	mean_occ_edu4				=	(	mean_occ_edu4_00	+	mean_occ_edu4_90	)	/2		;
generate 	mean_occ_edu5				=	(	mean_occ_edu5_00	+	mean_occ_edu5_90	)	/2		;
generate 	edu1				=	(	edu1_00	+	edu1_90	)	/2		;
generate 	edu2				=	(	edu2_00	+	edu2_90	)	/2		;
generate 	edu3				=	(	edu3_00	+	edu3_90	)	/2		;
generate 	edu4				=	(	edu4_00	+	edu4_90	)	/2		;
generate 	edu5				=	(	edu5_00	+	edu5_90	)	/2		;
generate 	edu6				=	(	edu6_00	+	edu6_90	)	/2		;
generate 	marst1				=	(	marst1_00	+	marst1_90	)	/2		;
generate 	marst2				=	(	marst2_00	+	marst2_90	)	/2		;
generate 	marst3				=	(	marst3_00	+	marst3_90	)	/2		;
generate 	marst4				=	(	marst4_00	+	marst4_90	)	/2		;
generate 	marst5				=	(	marst5_00	+	marst5_90	)	/2		;
generate 	marst6				=	(	marst6_00	+	marst6_90	)	/2		;

replace	occpop1_00	 = 	occpop1_00	-	occpop1	;
replace	occpop2_00	 = 	occpop2_00	-	occpop2	;
replace	occpop3_00	 = 	occpop3_00	-	occpop3	;
replace	occpop4_00	 = 	occpop4_00	-	occpop4	;
replace	occpop5_00	 = 	occpop5_00	-	occpop5	;
replace	cntry_met_00	 = 	cntry_met_00	-	cntry_met	;
replace	p_occ_old_country1_00	 = 	p_occ_old_country1_00	-	p_occ_old_country1	;
replace	p_occ_old_country2_00	 = 	p_occ_old_country2_00	-	p_occ_old_country2	;
replace	p_occ_old_country3_00	 = 	p_occ_old_country3_00	-	p_occ_old_country3	;
replace	p_occ_old_country4_00	 = 	p_occ_old_country4_00	-	p_occ_old_country4	;
replace	p_occ_old_country5_00	 = 	p_occ_old_country5_00	-	p_occ_old_country5	;
replace	p_native_occ1_00	 = 	p_native_occ1_00	-	p_native_occ1	;
replace	p_native_occ2_00	 = 	p_native_occ2_00	-	p_native_occ2	;
replace	p_native_occ3_00	 = 	p_native_occ3_00	-	p_native_occ3	;
replace	p_native_occ4_00	 = 	p_native_occ4_00	-	p_native_occ4	;
replace	p_native_occ5_00	 = 	p_native_occ5_00	-	p_native_occ5	;
replace	p_occ_met1_00	 = 	p_occ_met1_00	-	p_occ_met1	;
replace	p_occ_met2_00	 = 	p_occ_met2_00	-	p_occ_met2	;
replace	p_occ_met3_00	 = 	p_occ_met3_00	-	p_occ_met3	;
replace	p_occ_met4_00	 = 	p_occ_met4_00	-	p_occ_met4	;
replace	p_occ_met5_00	 = 	p_occ_met5_00	-	p_occ_met5	;
replace	age_00	 = 	age_00	-	age	;
replace	sex_00	 = 	sex_00	-	sex	;
replace	english_00	 = 	english_00	-	english	;
replace	age2_00	 = 	age2_00	-	age2	;
replace	mean_occ_edu1_00	 = 	mean_occ_edu1_00	-	mean_occ_edu1	;
replace	mean_occ_edu2_00	 = 	mean_occ_edu2_00	-	mean_occ_edu2	;
replace	mean_occ_edu3_00	 = 	mean_occ_edu3_00	-	mean_occ_edu3	;
replace	mean_occ_edu4_00	 = 	mean_occ_edu4_00	-	mean_occ_edu4	;
replace	mean_occ_edu5_00	 = 	mean_occ_edu5_00	-	mean_occ_edu5	;
replace	edu1_00	 = 	edu1_00	-	edu1	;
replace	edu2_00	 = 	edu2_00	-	edu2	;
replace	edu3_00	 = 	edu3_00	-	edu3	;
replace	edu4_00	 = 	edu4_00	-	edu4	;
replace	edu5_00	 = 	edu5_00	-	edu5	;
replace	edu6_00	 = 	edu6_00	-	edu6	;
replace	marst1_00	 = 	marst1_00	-	marst1	;
replace	marst2_00	 = 	marst2_00	-	marst2	;
replace	marst3_00	 = 	marst3_00	-	marst3	;
replace	marst4_00	 = 	marst4_00	-	marst4	;
replace	marst5_00	 = 	marst5_00	-	marst5	;
replace	marst6_00	 = 	marst6_00	-	marst6	;

replace	occpop1_90	 = 	occpop1_90	-	occpop1	;
replace	occpop2_90	 = 	occpop2_90	-	occpop2	;
replace	occpop3_90	 = 	occpop3_90	-	occpop3	;
replace	occpop4_90	 = 	occpop4_90	-	occpop4	;
replace	occpop5_90	 = 	occpop5_90	-	occpop5	;
replace	cntry_met_90	 = 	cntry_met_90	-	cntry_met	;
replace	p_occ_old_country1_90	 = 	p_occ_old_country1_90	-	p_occ_old_country1	;
replace	p_occ_old_country2_90	 = 	p_occ_old_country2_90	-	p_occ_old_country2	;
replace	p_occ_old_country3_90	 = 	p_occ_old_country3_90	-	p_occ_old_country3	;
replace	p_occ_old_country4_90	 = 	p_occ_old_country4_90	-	p_occ_old_country4	;
replace	p_occ_old_country5_90	 = 	p_occ_old_country5_90	-	p_occ_old_country5	;
replace	p_native_occ1_90	 = 	p_native_occ1_90	-	p_native_occ1	;
replace	p_native_occ2_90	 = 	p_native_occ2_90	-	p_native_occ2	;
replace	p_native_occ3_90	 = 	p_native_occ3_90	-	p_native_occ3	;
replace	p_native_occ4_90	 = 	p_native_occ4_90	-	p_native_occ4	;
replace	p_native_occ5_90	 = 	p_native_occ5_90	-	p_native_occ5	;
replace	p_occ_met1_90	 = 	p_occ_met1_90	-	p_occ_met1	;
replace	p_occ_met2_90	 = 	p_occ_met2_90	-	p_occ_met2	;
replace	p_occ_met3_90	 = 	p_occ_met3_90	-	p_occ_met3	;
replace	p_occ_met4_90	 = 	p_occ_met4_90	-	p_occ_met4	;
replace	p_occ_met5_90	 = 	p_occ_met5_90	-	p_occ_met5	;
replace	age_90	 = 	age_90	-	age	;
replace	sex_90	 = 	sex_90	-	sex	;
replace	english_90	 = 	english_90	-	english	;
replace	age2_90	 = 	age2_90	-	age2	;
replace	mean_occ_edu1_90	 = 	mean_occ_edu1_90	-	mean_occ_edu1	;
replace	mean_occ_edu2_90	 = 	mean_occ_edu2_90	-	mean_occ_edu2	;
replace	mean_occ_edu3_90	 = 	mean_occ_edu3_90	-	mean_occ_edu3	;
replace	mean_occ_edu4_90	 = 	mean_occ_edu4_90	-	mean_occ_edu4	;
replace	mean_occ_edu5_90	 = 	mean_occ_edu5_90	-	mean_occ_edu5	;
replace	edu1_90	 = 	edu1_90	-	edu1	;
replace	edu2_90	 = 	edu2_90	-	edu2	;
replace	edu3_90	 = 	edu3_90	-	edu3	;
replace	edu4_90	 = 	edu4_90	-	edu4	;
replace	edu5_90	 = 	edu5_90	-	edu5	;
replace	edu6_90	 = 	edu6_90	-	edu6	;
replace	marst1_90	 = 	marst1_90	-	marst1	;
replace	marst2_90	 = 	marst2_90	-	marst2	;
replace	marst3_90	 = 	marst3_90	-	marst3	;
replace	marst4_90	 = 	marst4_90	-	marst4	;
replace	marst5_90	 = 	marst5_90	-	marst5	;
replace	marst6_90	 = 	marst6_90	-	marst6	;

drop occpop1
occpop2
occpop3
occpop4
occpop5
cntry_met
p_occ_old_country1
p_occ_old_country2
p_occ_old_country3
p_occ_old_country4
p_occ_old_country5
p_native_occ1
p_native_occ2
p_native_occ3
p_native_occ4
p_native_occ5
p_occ_met1
p_occ_met2
p_occ_met3
p_occ_met4
p_occ_met5
age
sex
english
age2
mean_occ_edu1
mean_occ_edu2
mean_occ_edu3
mean_occ_edu4
mean_occ_edu5
edu1
edu2
edu3
edu4
edu5
edu6
marst1
marst2
marst3
marst4
marst5
marst6;

rename	pop_00		pop_2000	;
rename	occpop1_00		occpop1_2000	;
rename	occpop2_00		occpop2_2000	;
rename	occpop3_00		occpop3_2000	;
rename	occpop4_00		occpop4_2000	;
rename	occpop5_00		occpop5_2000	;
rename cntry_met_00 cntry_met_2000;
rename	p_occ_old_country1_00		p_occ_old_country1_2000	;
rename	p_occ_old_country2_00		p_occ_old_country2_2000	;
rename	p_occ_old_country3_00		p_occ_old_country3_2000	;
rename	p_occ_old_country4_00		p_occ_old_country4_2000	;
rename	p_occ_old_country5_00		p_occ_old_country5_2000	;
rename	p_native_occ1_00		p_native_occ1_2000	;
rename	p_native_occ2_00		p_native_occ2_2000	;
rename	p_native_occ3_00		p_native_occ3_2000	;
rename	p_native_occ4_00		p_native_occ4_2000	;
rename	p_native_occ5_00		p_native_occ5_2000	;
rename	p_occ_met1_00		p_occ_met1_2000	;
rename	p_occ_met2_00		p_occ_met2_2000	;
rename	p_occ_met3_00		p_occ_met3_2000	;
rename	p_occ_met4_00		p_occ_met4_2000	;
rename	p_occ_met5_00		p_occ_met5_2000	;
rename	age_00		age_2000	;
rename	sex_00		sex_2000	;
rename	english_00		english_2000	;
rename	age2_00		age2_2000	;
rename	mean_occ_edu1_00		mean_occ_edu1_2000	;
rename	mean_occ_edu2_00		mean_occ_edu2_2000	;
rename	mean_occ_edu3_00		mean_occ_edu3_2000	;
rename	mean_occ_edu4_00		mean_occ_edu4_2000	;
rename	mean_occ_edu5_00		mean_occ_edu5_2000	;
rename	edu1_00		edu1_2000	;
rename	edu2_00		edu2_2000	;
rename	edu3_00		edu3_2000	;
rename	edu4_00		edu4_2000	;
rename	edu5_00		edu5_2000	;
rename	edu6_00		edu6_2000	;
rename	marst1_00		marst1_2000	;
rename	marst2_00		marst2_2000	;
rename	marst3_00		marst3_2000	;
rename	marst4_00		marst4_2000	;
rename	marst5_00		marst5_2000	;
rename	marst6_00		marst6_2000	;
rename	pop_90		pop_1990	;
rename	occpop1_90		occpop1_1990	;
rename	occpop2_90		occpop2_1990	;
rename	occpop3_90		occpop3_1990	;
rename	occpop4_90		occpop4_1990	;
rename	occpop5_90		occpop5_1990	;
rename	cntry_met_90		cntry_met_1990	;
rename	p_occ_old_country1_90		p_occ_old_country1_1990	;
rename	p_occ_old_country2_90		p_occ_old_country2_1990	;
rename	p_occ_old_country3_90		p_occ_old_country3_1990	;
rename	p_occ_old_country4_90		p_occ_old_country4_1990	;
rename	p_occ_old_country5_90		p_occ_old_country5_1990	;
rename	p_native_occ1_90		p_native_occ1_1990	;
rename	p_native_occ2_90		p_native_occ2_1990	;
rename	p_native_occ3_90		p_native_occ3_1990	;
rename	p_native_occ4_90		p_native_occ4_1990	;
rename	p_native_occ5_90		p_native_occ5_1990	;
rename	p_occ_met1_90		p_occ_met1_1990	;
rename	p_occ_met2_90		p_occ_met2_1990	;
rename	p_occ_met3_90		p_occ_met3_1990	;
rename	p_occ_met4_90		p_occ_met4_1990	;
rename	p_occ_met5_90		p_occ_met5_1990	;
rename	age_90		age_1990	;
rename	sex_90		sex_1990	;
rename	english_90		english_1990	;
rename	age2_90		age2_1990	;
rename	mean_occ_edu1_90		mean_occ_edu1_1990	;
rename	mean_occ_edu2_90		mean_occ_edu2_1990	;
rename	mean_occ_edu3_90		mean_occ_edu3_1990	;
rename	mean_occ_edu4_90		mean_occ_edu4_1990	;
rename	mean_occ_edu5_90		mean_occ_edu5_1990	;
rename	edu1_90		edu1_1990	;
rename	edu2_90		edu2_1990	;
rename	edu3_90		edu3_1990	;
rename	edu4_90		edu4_1990	;
rename	edu5_90		edu5_1990	;
rename	edu6_90		edu6_1990	;
rename	marst1_90		marst1_1990	;
rename	marst2_90		marst2_1990	;
rename	marst3_90		marst3_1990	;
rename	marst4_90		marst4_1990	;
rename	marst5_90		marst5_1990	;
rename	marst6_90		marst6_1990	;

generate id=_n;

reshape long pop_ occpop1_ occpop2_ occpop3_ occpop4_ occpop5_ cntry_met_ p_occ_old_country1_ p_occ_old_country2_ p_occ_old_country3_ p_occ_old_country4_ p_occ_old_country5_ p_native_occ1_ p_native_occ2_ p_native_occ3_ p_native_occ4_ p_native_occ5_ p_occ_met1_ p_occ_met2_ p_occ_met3_ p_occ_met4_ p_occ_met5_ age_ sex_ english_ age2_ mean_occ_edu1_ mean_occ_edu2_ mean_occ_edu3_ mean_occ_edu4_ mean_occ_edu5_ edu1_ edu2_ edu3_ edu4_ edu5_ edu6_ marst1_ marst2_ marst3_ marst4_ marst5_ marst6_, i(id) j(year);
rename	pop_		pop	;
rename	occpop1_		occpop1	;
rename	occpop2_		occpop2	;
rename	occpop3_		occpop3	;
rename	occpop4_		occpop4	;
rename	occpop5_		occpop5	;
rename cntry_met_ cntry_met;
rename	p_occ_old_country1_		p_occ_old_country1	;
rename	p_occ_old_country2_		p_occ_old_country2	;
rename	p_occ_old_country3_		p_occ_old_country3	;
rename	p_occ_old_country4_		p_occ_old_country4	;
rename	p_occ_old_country5_		p_occ_old_country5	;
rename	p_native_occ1_		p_native_occ1	;
rename	p_native_occ2_		p_native_occ2	;
rename	p_native_occ3_		p_native_occ3	;
rename	p_native_occ4_		p_native_occ4	;
rename	p_native_occ5_		p_native_occ5	;
rename	p_occ_met1_		p_occ_met1	;
rename	p_occ_met2_		p_occ_met2	;
rename	p_occ_met3_		p_occ_met3	;
rename	p_occ_met4_		p_occ_met4	;
rename	p_occ_met5_		p_occ_met5	;
rename	age_		age	;
rename	sex_		sex	;
rename	english_		english	;
rename	age2_		age2	;
rename	mean_occ_edu1_		mean_occ_edu1	;
rename	mean_occ_edu2_		mean_occ_edu2	;
rename	mean_occ_edu3_		mean_occ_edu3	;
rename	mean_occ_edu4_		mean_occ_edu4	;
rename	mean_occ_edu5_		mean_occ_edu5	;
rename	edu1_		edu1	;
rename	edu2_		edu2	;
rename	edu3_		edu3	;
rename	edu4_		edu4	;
rename	edu5_		edu5	;
rename	edu6_		edu6	;
rename	marst1_		marst1	;
rename	marst2_		marst2	;
rename	marst3_		marst3	;
rename	marst4_		marst4	;
rename	marst5_		marst5	;
rename	marst6_		marst6	;

#delimit cr

log using "Feb_2011_Revisions\log_panel\panel_`sx'_3clust_omb_obs`xobs'.log", replace

table  bpl, row col

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
	outreg p_occ_old_country p_nat_occ p_occmet mean_occedu `controls' using "Feb_2011_Revisions\reg_panel_output\panel_`sx'_obs`xobs'_3clust_omb.xls", bdec(3) rdec(3) sigsymb(**,*,+) 10pct coefastr ctitle(occpop) bracket replace
	}
	else { 
	outreg p_occ_old_country p_nat_occ p_occmet mean_occedu `controls' using "Feb_2011_Revisions\reg_panel_output\panel_`sx'_obs`xobs'_3clust_omb.xls", bdec(3) rdec(3) sigsymb(**,*,+) 10pct coefastr ctitle(occpop) bracket append
	}
	/* no mex */
	display "Excluding Mexicans, for popular occuption: `pop'"
	xi: cgmreg occpop p_occ_old_country p_nat_occ p_occmet mean_occedu `controls' if bpl!=200, cluster(pwmetro bpl)
	if `pop'==1 {
	outreg p_occ_old_country p_nat_occ p_occmet mean_occedu `controls' using "Feb_2011_Revisions\reg_panel_output\panel_`sx'_obs`xobs'_3clust_omb_nomex.xls", bdec(3) rdec(3) sigsymb(**,*,+) 10pct coefastr ctitle(occpop) bracket replace
	}
	else { 
	outreg p_occ_old_country p_nat_occ p_occmet mean_occedu `controls' using "Feb_2011_Revisions\reg_panel_output\panel_`sx'_obs`xobs'_3clust_omb_nomex.xls", bdec(3) rdec(3) sigsymb(**,*,+) 10pct coefastr ctitle(occpop) bracket append
	}

	drop occpop p_occ_old_country p_nat_occ p_occmet mean_occedu  
 	}  /*forvarlues pop */

log close


} /* foreach sx */
} /* foreach xobs */

