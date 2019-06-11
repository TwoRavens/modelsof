***************************************************
* Title: Pov_Viol Paper Data Setup                          
* Date: November 7, 2015                              
***************************************************

/// Replication Note:

// Please install polychoric.ado before running this .do file


clear
set more off


/// SET DIRECTORIES AND CALL UP DATA

cd "~/Dropbox/PK2 share/Replication/Data"
use "FMS-four provinces data-wtd.appended.dta", clear


/// CREATE DISTRICT AND PROVINCE VARIABLES

	replace a6="FATA" if a6=="fata"
	replace a6="KPK" if a6=="kpk"

	tab a6, gen(province)
	tab a7, gen(district)
	gen fata = a6 =="FATA"


/// GENERATE TREATMENT DUMMIES

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

	* off by 1
	gen drop1 = 0
		replace drop1 = 1 if psu == 3 | psu == 9 | psu == 24 | psu == 25 | psu == 62 | psu == 90 | psu == 94 | psu == 139 | psu == 154 | psu == 173 | psu == 194 | psu == 305 | psu == 327 | psu == 359 | psu == 397 | psu == 401 | psu == 405 | psu == 413 | psu == 437 | psu == 565 | psu == 587 | psu == 613 | psu == 619 | psu == 628 | psu == 635 | psu == 653 | psu == 686 | psu == 693 | psu == 713 | psu == 720 | psu == 752 | psu == 783 | psu == 791 | psu == 792 | psu == 799 | psu == 855 | psu == 896 | psu == 996 | psu == 1000 | psu == 1007 | psu == 1014 | psu == 1031 | psu == 1041 | psu == 1088 | psu == 1091 | psu == 1099

	* off by more than 1
	gen drop2 = 0
		replace drop2 = 1 if psu == 6 | psu == 21 | psu == 22 | psu == 33 | psu == 34 | psu == 54 | psu == 92 | psu == 96 | psu == 100 | psu == 101 | psu == 103 | psu == 119 | psu == 120 | psu == 127 | psu == 140 | psu == 156 | psu == 157 | psu == 161 | psu == 166 | psu == 181 | psu == 182 | psu == 183 | psu == 186 | psu == 196 | psu == 197 | psu == 198 | psu == 199 | psu == 200 | psu == 201 | psu == 211 | psu == 221 | psu == 223 | psu == 282 | psu == 319 | psu == 378 | psu == 419 | psu == 443 | psu == 448 | psu == 475 | psu == 489 | psu == 502 | psu == 529 | psu == 584 | psu == 654 | psu == 655 | psu == 689 | psu == 724 | psu == 795 | psu == 849 | psu == 914 | psu == 926 | psu == 935 | psu == 952 | psu == 1050 

	gen drop = (drop1 == 1 | drop2 == 1)


/// RECODE MISSING DATA

	recode q* (98=.) (99=.) (998=.) (999=.)
	recode d* (98=.) (99=.) (998=.) (999=.)


/// ENDORSEMENT EFFECT CODING

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

// Set Control Group as baseline

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

	local group "a b c d e"
	foreach x of local group {
		foreach var in q800`x' q810`x' q820`x' q830`x' {
			gen `var'_resc = (`var'*-1 + 6)		
		}
	}

	foreach num of numlist 800 810 820 830 {
		egen q`num'mil_resc = rowmean(q`num'b_resc q`num'c_resc q`num'd_resc)
	}

	gen fata_support = (q810a==1 | q810a==2) if q810a!=.

// Create treatment-endorsement interactions

	local group "b c d e militancy"
	foreach x of local group {
		gen poverty_treat_`x' = poverty*treat_`x'
		gen natviol_treat_`x' = natviol*treat_`x'
		gen n11_treat_`x' = n11*treat_`x'
		gen n10_treat_`x' = n10*treat_`x'
		gen n01_treat_`x' = n01*treat_`x'	
	}

	egen treatprov = group(treat_militancy a6)

// Three Way Interaction Term Model

	gen povviol = poverty*natviol

	local group "b c d e militancy"
	foreach x of local group {
		gen povviol_treat_`x' = povviol*treat_`x'
	}


/// CREATE DEMOGRAPHIC VARIABLES

	gen gender_z = d005==1 if d005!=. // no missing data

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

// Create interactions: demograhics and treatment variables

	local group "b c d e militancy"
	foreach x of local group {
		gen educ_treat_`x' = educ_z *treat_`x'
	}

	gen read_treat_militancy = read_z * treat_militancy
	gen math_treat_militancy = math_z * treat_militancy
	gen tv_treat_militancy = tv * treat_militancy


/// CREATE KNOWLEDGE VARIABLES

// Knowledge of Policy Issues

	gen k1 = q540==1
	gen k2 = q550==1
	gen k3 = q560==1
	gen k4 = q570==1

	gen k_scale = (k1+k2+k3+k4)
		replace k_scale = k_scale/4

	tab k_scale, gen(kscale)
	gen issuehigh = (k_scale > .5) if k_scale !=. 

// Interact Knowledge Scale with Treatment

	local group "b c d e militancy"
	foreach x of local group {
		gen k_treat_`x' = k_scale*treat_`x'
		gen issue_treat_`x' = issuehigh*treat_`x'	
	}

// General Knowledge Scale

	gen know_declare = q500==1
	gen know_peace = q502==4
	gen know_ppp = q505==1
	gen know_18_1 = q5101==1
	gen know_18_2 = q5102==1
	gen know_18_3 = q5103==2
	gen know_18_4 = q5104==2
	gen know_18_5 = q5105==2
	gen know_18_6 = q5106==2
	gen know_18_7 = q5107==2
	gen know_pres = q515==1
	gen know_pm = q520==2
	gen know_cm = 0
		replace know_cm = 1 if q525==5 & a6=="Punjab"
		replace know_cm = 1 if q525==6 & a6=="Sindh"
		replace know_cm = 1 if q525==7 & a6=="KPK"|a6=="FATA"
		replace know_cm = 1 if q525==8 & a6=="Balochistan"
	gen know_chiefjustice = q530==3
	gen know_armychief = q535==4

	egen knowledge=rowtotal(know_*)
		replace knowledge=knowledge/15

	summ knowledge, d
	gen knowledgehigh = (knowledge > r(p50))

	local group "b c d e militancy"
	foreach x of local group {
		gen know_treat_`x' = knowledgehigh*treat_`x'
		gen knowledge_treat_`x' = knowledge*treat_`x'
	}

// Full knowledge index (alternate specification)

	gen know_karachi = q540==1
	gen know_fcr = q550==1
	gen know_durand = q560==1
	gen know_india = q570==1
	polychoric know_ppp know_pres know_pm know_cm know_chiefjustice know_armychief know_karachi-know_india
	scalar b = r(sum_w)
	matrix r = r(R)
	pcamat r, n(12994) 
	predict knowfullpca, sc

	set seed 123456789
	gen rand = runiform()
		replace rand = rand * .0001
	gen knowfullpca_noise = knowfullpca + rand

	xtile knowfullpca_quart = knowfullpca_noise, nq(3)
	xtile knowfull_high = knowfullpca_noise, nq(2)

	local group "b c d e militancy"
	foreach x of local group {
		gen knowfull_treat_`x' = knowfullpca*treat_`x'
		gen knowfullhigh_treat_`x' = knowfull_high*treat_`x'		
		gen kf_treat_`x'_nv = knowfullpca*treat_`x'*natviol
	}
	gen knowfull_natviol = knowfullpca*natviol


/// CREATE EDHI VARIABLES

	gen support_edhi = (q1001 < 3) if q1001 != .
	gen treat_edhi = treat_e*support_edhi


/// CREATE ECONOMIC VARIABLES

// Nominal expenditures

	gen expend = d140/1000

	local group "b c d e militancy"
	foreach x of local group {
		gen exp_treat_`x' = expend*treat_`x'
	}

// Poverty experiment income variable

	gen income = .
	replace income = q700a if poverty == 0
	replace income = q700b if poverty == 1
	
	gen income_bottom = (income==1) if income!=.

// Generate in province urban/rural specific expenditure cuts in quintiles
	
	gen urban = a12==1
	gen lowexp_urprov = 0
	gen highexp_urprov = 0

	encode a6, gen(prov1)

// Do cuts at levels from 15 to 35	

	forval w = 15(5)35 {
		local w1=`w'
		local w2=100-`w'
		gen lowexp`w'_urprov = 0
		gen highexp`w'_urprov = 0
	
		forval y = 0/1 {
			forval x = 1/5 {
				_pctile d140 if prov1==`x' & urban==`y' , p(`w1' `w2')
				replace lowexp`w'_urprov = 1 if d140 <= r(r1) & prov1==`x' & urban==`y'
				replace highexp`w'_urprov = 1 if d140 > r(r2) & prov1==`x' & urban==`y'
			}
		}
	
		local group "b c d e militancy"
		foreach x of local group {
   			gen lowexp`w'_urprov_`x' = treat_`x'*lowexp`w'_urprov
   			gen highexp`w'_urprov_`x' = treat_`x'*highexp`w'_urprov
   		}
   	}

// Create interactions with treatment variables

	gen lowexp20_urprov_pov = lowexp20_urprov * poverty
	gen lowexp20_urprov_pov_militancy = lowexp20_urprov * poverty * treat_militancy
	gen lowexp20_urprov_viol = lowexp20_urprov * natviol 
	gen lowexp20_urprov_viol_militancy = lowexp20_urprov * natviol * treat_militancy
    

/// SAVE DATASET FOR ANALYSES

compress
save "FLMS_2015_prepped.dta", replace
