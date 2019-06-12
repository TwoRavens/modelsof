***************************************************
* Title: Pakistan, Democracy, and Militancy
* Function: Data set-up and Variable construction                         
* Date: June 9, 2016                              
***************************************************

clear
set more off

// NOTE: Please copy all replication files into the same working directory

use "FMS-four provinces data-wtd.appended.dta"


**********************************
******** 1. Data set-up *********
**********************************

// CREATE PROVINCE AND DISTRICT VARIABLES

	replace a6="FATA" if a6=="fata"
	replace a6="KPK" if a6=="kpk"

	tab a6, gen(province)
	tab a7, gen(district)
	tab a8, gen(tehsil)

	gen fata = a6 =="FATA"

// GENERATE TREATMENT VARIABLES AND NEW PSU VARIABLE
	
	gen control_assign = q800a!=.&q810a!=.&q820a!=.&q830a!=.
	gen treat_assign = q800a!=.&q810a!=.&q820a!=.&q830a!=.

	gen treat_group = .
		recode treat_group (.=1) if q800a!=.&q810a!=.&q820a!=.&q830a!=.
		recode treat_group (.=2) if q800b!=.&q810b!=.&q820b!=.&q830b!=.
		recode treat_group (.=3) if q800c!=.&q810c!=.&q820c!=.&q830c!=.
		recode treat_group (.=4) if q800d!=.&q810d!=.&q820d!=.&q830d!=.
		recode treat_group (.=5) if q800e!=.&q810e!=.&q820e!=.&q830e!=.

	gen poverty_messup = (q700a!=.&q700b!=.) | (q700a==.&q700b==.)
	gen poverty = q700b!=. if poverty_messup==0  

	egen check2 = rownonmiss(q1400 q1410)
	egen check3 = rownonmiss(q1405 q1420)
	gen vignette_messup = check2!=1 | check3!=1
	gen violent_vignette = q1410!=. if vignette_messup==0

	gen locviol = .
		recode locviol (.=0) if q730b==1
		recode locviol (.=1) if q730a==1

	gen natviol = .
		recode natviol (.=0) if q730c==1
		recode natviol (.=1) if q730d==1

	gen pov_locviol = .
		recode pov_locviol (.=1) if poverty==1&locviol==1
		recode pov_locviol (.=2) if poverty==1&locviol==0
		recode pov_locviol (.=3) if poverty==0&locviol==1
		recode pov_locviol (.=4) if poverty==0&locviol==0

	gen pov_natviol = .
		recode pov_natviol (.=1) if poverty==1&natviol==1
		recode pov_natviol (.=2) if poverty==1&natviol==0
		recode pov_natviol (.=3) if poverty==0&natviol==1
		recode pov_natviol (.=4) if poverty==0&natviol==0

	gen n11 = pov_natviol==1 if pov_natviol!=.
	gen n10 = pov_natviol==2 if pov_natviol!=.
	gen n01 = pov_natviol==3 if pov_natviol!=.
	gen n00 = pov_natviol==4 if pov_natviol!=.

	gen treatment_povviol = pov_natviol	
		replace treatment_povviol = 5 if pov_locviol==1
		replace treatment_povviol = 6 if pov_locviol==2
		replace treatment_povviol = 7 if pov_locviol==3
		replace treatment_povviol = 8 if pov_locviol==4

	egen treat = concat(treat_group violent_vignette) if treat_group!=. & violent_vignette!=.
		destring treat, replace

	egen treatment = concat(treatment_povviol treat) if treatment_povviol!=. & treat!=.
		destring treatment, replace
		drop treat

	egen psu_new = concat(psu treatment) if psu!=. & treatment!=.


// RECODE MISSING DATA

	recode q* (98=.) (99=.) (998=.) (999=.)
	recode d* (98=.) (99=.) (998=.) (999=.)


// ENDORSEMENT EFFECT CODING

	local group "a b c d e"
	foreach x of local group {
		foreach num of numlist 800 810 820 830 {
			replace q`num'`x' = . if q`num'`x'==6 | q`num'`x'==7
			}
		}
	
	local group "a b c d e"
	foreach x of local group {
		quietly egen complete`x' = rownonmiss(q800`x' q810`x' q820`x' q830`x')
		}
	
	foreach x of local group {
		quietly egen com_`x' = rowtotal(q800`x' q810`x' q820`x' q830`x') if complete`x'==4
		quietly replace com_`x' = (com_`x'-20)/-16
		}
	
	egen check = rownonmiss(com_a com_b com_c com_d com_e)

	// Setting Control Group as baseline

	gen control = (com_a != .) if check==1
	gen treat_b = (com_b != .) if check==1
	gen treat_c = (com_c != .) if check==1
	gen treat_d = (com_d != .) if check==1
	gen treat_e = (com_e != .) if check==1
	gen treat_militancy = (treat_b == 1 | treat_c == 1 | treat_d == 1) if check==1

	egen policy_pref = rowtotal(com_a com_b com_c com_d com_e), missing

	egen policy_pref_b = rowtotal(com_a com_b), missing
	egen policy_pref_c = rowtotal(com_a com_c), missing
	egen policy_pref_d = rowtotal(com_a com_d), missing
	egen policy_pref_e = rowtotal(com_a com_e), missing
	egen policy_pref_militancy = rowtotal(com_a com_b com_c com_d), missing 

// EXPLICIT SUPPORT FOR MILITANT GROUPS

	gen support_ssp = (q1010 - 5)/-4
	gen support_atal = (q1012 - 5)/-4
	gen support_mil = (support_ssp + support_atal)/2


***********************************************
*** 2. Demographic and Religion Covariates ***
***********************************************

// DEMOGRAPHIC VARIABLES

	gen gender_z = d005==1 // no missing data

	gen urban_z = a12==1 // no missing data

	gen headh_z = d010
	recode headh_z (2=0)
	recode headh_z (.=0)
	gen headh_miss = d010==. 

	gen age_z = d030
	recode age_z (.=18)
	replace age_z = (age_z-18)/70
	gen age_miss = d030==. 

	gen read_z = d050
	recode read_z (2=0)
	recode read_z (.=0)
	gen read_miss = d050==.

	gen math_z = d070
	recode math_z (2=0)
	recode math_z (.=0)
	gen math_miss = d070==.

	gen educ_z = d080
	recode educ_z (.=0)
	replace educ_z = (educ_z)/6
	gen educ_miss = d080==.

	gen houseexpend_z = d140
	recode houseexpend_z (.=0)
	replace houseexpend_z = houseexpend_z/90000
	gen houseexpend_miss = d140==.

	gen bed = d2401>0 & d2401!=.
	gen chairs = d2402>0 & d2402!=.
	gen internet = d2403>0 & d2403!=.
	gen fans = d2404>0 & d2404!=.
	gen sewing = d2405>0 & d2405!=.
	gen books = d2406>0 & d2406!=.
	gen refrigerator = d2407>0 & d2407!=.
	gen cassette = d2408>0 & d2408!=.
	gen tv = d2409>0 & d2409!=.
	gen vcr = d2410>0 & d2410!=.
	gen air = d2415>0 & d2415!=.
	gen moto = d2416>0 & d2416!=.
	gen car = d2417>0 & d2417!=.
	gen cycle = d2418>0 & d2418!=.
	gen watch = d2421>0 & d2421!=.
	gen mobile = d2422>0 & d2422!=.
	gen computer = d2423>0 & d2423!=.
	gen landline = d2424>0 & d2424!=.

	gen assetindex_z = bed+chairs+internet+fans+sewing+books+refrigerator+cassette+tv+vcr+air+moto+car+cycle+watch+mobile+computer+landline
	replace assetindex_z = assetindex/18  // No missing data (enumerators sometimes coded 0 items as don't know, so missing responses are recoded as 0)
	gen assets = bed+chairs+internet+fans+sewing+books+refrigerator+cassette+tv+vcr+air+moto+car+cycle+watch+mobile+computer+landline

	tab d135, gen(ethnicity)
	foreach x in 1 2 3 4 5 6 7 8 {
		gen ethnicity`x'_z = ethnicity`x'
		recode ethnicity`x'_z (.=0)
	}


// RELIGION VARIABLES

	// Deobandi and Sunni
	
	gen ahlesunnat_r = (q020==1)
	gen ahlesunnat_rmiss = q020==.

	gen deobandi_r = (q020==2)
	
	gen ahleehadis_r = (q020==3)

	gen shia_r = (q020==4)

	// Pray Namaz scale (0-5, categories of how often they pray Namaz per week)
	
	gen namaz = q050

	gen namaz_r = namaz
	recode namaz_r (.=0)
	gen namaz_rmiss = namaz==. 
	
	// Extra religious (dummy)
	
	gen tah_namaz = (q052 == 1) if q052 != .

	gen tah_namaz_r = tah_namaz
	recode tah_namaz_r (.=0)
	gen tah_namaz_rmiss = tah_namaz==. 


******************************************
*** 3. Sharia and Democracy Variables ***
******************************************

// SHARIA VARIABLES

	// Definition of Sharia
	
	gen d_services = (q120 == 1) if q120 != .
	gen d_noncorrupt = (q125 == 1) if q125 != .
	gen d_security = (q130 == 1) if q130 != .
	gen d_justice = (q135 == 1) if q135 != .
	gen d_punish = (q140 == 1) if q140 != .
	gen d_restrict = (q145 == 1) if q145 != .
	gen d_veil = (q150 == 1) if q150 != .
				
	// Additive indices
		
	egen d_provides = rowmean(d_services d_noncorrupt d_security d_justice)
	egen d_imposes = rowmean(d_punish d_restrict)	
	egen d_sharia = rowmean(d_provides d_punish d_restrict) 
	
	// Binning people by views on Sharia as providing and imposing

	gen high_provides = (d_provides==1) if d_provides!=.
	gen high_imposes = (d_imposes==1) if d_imposes!=.

	gen highprov_highimp = (high_provides==1 & high_imposes==1) if high_provides!=. & high_imposes!=.	
	gen lowprov_lowimp = (high_provides==0 & high_imposes==0) if high_provides!=. & high_imposes!=.
	gen highprov_lowimp = (high_provides==1 & high_imposes==0) if high_provides!=. & high_imposes!=.
	gen lowprov_highimp = (high_provides==0 & high_imposes==1) if high_provides!=. & high_imposes!=.

	gen prov_imp = .
	replace prov_imp = 1 if lowprov_lowimp==1
	replace prov_imp = 2 if highprov_lowimp==1
	replace prov_imp = 3 if lowprov_highimp==1
	replace prov_imp = 4 if highprov_highimp==1

	// Sharia Knowledge
	
	gen k_pillars = (q060 == 5) if q060 != .
	gen k_namaz = (q070 == 1) if q070 != .
	gen k_zakat1 = (q080 == 1) if q080 != .
	gen k_zakat2 = (q090 == 1) if q090 != .
	gen k_quran = (q095 == 1) if q095 != .
		
	egen k_sharia = rowmean(k_pillars k_namaz k_zakat1 k_zakat2 k_quran)

		
// DEMOCRACY VARIABLES

	// Support for democracy index

	alpha q1030 q1050 q1070 q1090 q1110 q1130
	
	foreach var of varlist q1030 q1050 q1070 q1090 q1110 q1130 {
		gen `var'_resc = (`var' - 5) * -1
	}	
	
	egen democracy = rowmean(q1030_resc q1050_resc q1070_resc q1090_resc q1110_resc q1130_resc)
	replace democracy = democracy / 4


// INTERACTION TERMS

	foreach x in b c d militancy e {
		gen ksharia_treat_`x' = k_sharia * treat_`x'
		gen dprovides_treat_`x' = d_provides * treat_`x'
		gen dimposes_treat_`x' = d_imposes * treat_`x'		
		gen dsharia_treat_`x' = d_sharia * treat_`x'
		gen highprov_highimp_`x' = highprov_highimp * treat_`x'	
		gen lowprov_lowimp_`x' = lowprov_lowimp * treat_`x'	
		gen lowprov_highimp_`x' = lowprov_highimp * treat_`x'	
		gen highprov_lowimp_`x' = highprov_lowimp * treat_`x'	
	}

	gen d_provides_imposes = d_provides * d_imposes
	gen provides_imposes_militancy = d_provides * d_imposes * treat_militancy

save "FMS-four provinces data-ANALYSIS.dta", replace

