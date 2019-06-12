
////////////////////////////////////////
//        ADD NUSAF POLITICAL         //
////////////////////////////////////////

/***************************************************************************
*** 1. SET UP **************************************************************
****************************************************************************/

// CLEAR 
	drop _all 
	clear matrix
	clear mata
	
// SET PARAMETERS 
	set more off
	set varabbrev on
	set maxvar 27000


// TEMPORARY FILES
	tempfile yop parish
	
// OPEN NUSAF DATASET
 	use "$NUSAF/data/yop_analysis_deident", clear


	save "`yop'", replace 

// INSHEET ELECTIONS DATA 
 	insheet using "$NUSAF/Other politics data/Merge parishes/parish_master.csv", clear
	sort groupid 
	replace pres_nrm_prop_11="" if pres_nrm_prop_11 =="NA"
	replace pres_nrm_prop_06="" if pres_nrm_prop_06 =="NA"
	destring pres_nrm_prop_11 pres_nrm_prop_06, replace
	save "`parish'", replace

// MERGE IN ELECTIONS DATA 	
	use "`yop'", clear 
	merge n:1 groupid using "`parish'", gen(_merge_parish)
	
// SET GLOBALS
	gl ethnicgroup_imp "acholi_dum_imp alur_dum_imp bagwere_dum_imp iteso_dum_imp karamojong_dum_imp langi_dum_imp lugbara_dum_imp madi_dum_imp"	
	gl districts "D_1-D_13"

// SET SURVEY DESIGN
	svyset [pw=w_sampling_e], strata(district) psu(group_endline)	

/***************************************************************************
*** 3. CLEANING ************************************************************
****************************************************************************/

// DESTRING 
	replace attrselectfair = "0" if attrselectfair == "0-No"
	replace attrselectfair = "1" if attrselectfair == "1-Yes"
	destring attrselectfair, replace
		
// DROP VARIABLES 
	drop vbofferyou2011el_dum_e vbthreatenyou2011el_dum_e votebuying_e

// RENAME (too long)
	ren vote2011elprezinccomb_dum_e voteinc_dum_e

// REPLACE SPECIAL CODES 
	foreach x in apprlc1current_e apprlc3current_e apprlc3previous_e { 
		replace `x' = .d if `x' ==97
	}
	
// REPLACE DK by 0 
	replace ldmacceptc1 = 0 if ldmacceptc1 ==.d
	
// REPLACE BY MISSING SUCCESSFULLY REGISTERED IF DECLARED THAT HE DIDN'T TRY TO REGISTER
	replace regsuccess2011_e = . if regtry2011_e ==0 & ind_found_e2==1
	
// RESCALE TAX RIGHT
	replace taxright_e = 2.5 if taxright_e == 5
	
// REPLACE ETHNICITY DUMMIES BY ZERO WHEN MISSING 
	*foreach x in acholi_dum alur_dum bagwere_dum iteso_dum karamojong_dum langi_dum lugbara_dum madi_dum { 
	*	replace `x' = 0 if `x' == . 
	*}	
	
// ETHNICITY MISSING FOR 24 OBSERVATION
	mdesc q13 if ind_found_b==1 & e2==1	
	
	gen q13_imp = q13
	
	// Impute ethnicity mode with group or district, not very elegant but will do
	list groupid if q13==. & ind_found_b==1 & e2==1
	
	ta q13 if groupid== 9, mi
	replace q13_imp = 58 if q13==. & groupid == 9 & ind_found_b ==1
	
	ta q13 if groupid== 157, mi nol
	replace q13_imp = 55 if q13==. & groupid == 157 & ind_found_b ==1
	
	ta q13 if groupid== 161, mi nol
	replace q13_imp = 55 if q13==. & groupid == 161 & ind_found_b ==1
	
	ta q13 if groupid== 165, mi nol
	replace q13_imp = 55 if q13==. & groupid == 165 & ind_found_b ==1
	
	ta q13 if groupid== 177, mi nol
	replace q13_imp = 55 if q13==. & groupid ==177 & ind_found_b ==1
	
	ta q13 if groupid== 191, mi nol
	replace q13_imp = 55 if q13==. & groupid ==191 & ind_found_b ==1

	ta q13 if groupid== 192, mi nol
	replace q13_imp = 55 if q13==. & groupid ==192 & ind_found_b ==1

	ta q13 if groupid== 205, mi nol
	replace q13_imp = 12 if q13==. & groupid ==205 & ind_found_b ==1

	ta q13 if groupid== 206, mi nol
	replace q13_imp = 12 if q13==. & groupid ==206 & ind_found_b ==1

	ta q13 if groupid== 209, mi nol
	* No modal value of ethnicity

	ta q13 if groupid== 264, mi nol
	replace q13_imp = 55 if q13==. & groupid ==264 & ind_found_b ==1

	ta q13 if groupid== 267, mi nol
	replace q13_imp = 55 if q13==. & groupid ==267 & ind_found_b ==1

	ta q13 if groupid== 283, mi nol
	replace q13_imp = 55 if q13==. & groupid ==283 & ind_found_b ==1

	ta q13 if groupid== 284, mi nol
	replace q13_imp = 55 if q13==. & groupid ==284 & ind_found_b ==1

	ta q13 if groupid== 286, mi nol
	replace q13_imp = 55 if q13==. & groupid ==286 & ind_found_b ==1

	ta q13 if groupid== 355, mi nol
	replace q13_imp = 45 if q13==. & groupid ==355 & ind_found_b ==1
	
	ta q13 if groupid== 372, mi nol
	replace q13_imp = 45 if q13==. & groupid ==372 & ind_found_b ==1

	ta q13 if groupid== 386, mi nol
	replace q13_imp = 45 if q13==. & groupid ==386 & ind_found_b ==1
	
	ta q13 if groupid== 404, mi nol
	replace q13_imp = 21 if q13==. & groupid ==404 & ind_found_b ==1
	  
	ta q13 if groupid== 422, mi nol
	replace q13_imp = 45 if q13==. & groupid ==422 & ind_found_b ==1
	
	ta q13 if groupid== 438, mi nol
	replace q13_imp = 21 if q13==. & groupid ==438 & ind_found_b ==1

	ta q13 if groupid== 448, mi nol
	replace q13_imp = 45 if q13==. & groupid ==448 & ind_found_b ==1

	ta q13 if groupid== 499, mi nol
	replace q13_imp = 55 if q13==. & groupid ==499 & ind_found_b ==1
				
	mdesc q13_imp if ind_found_b==1 & e2==1	
	list groupid if q13_imp==. & ind_found_b==1 & e2==1
	
	// Regenerate ethnicity variables
	
	gen acholi_dum_imp =(q13_imp==11) if q13_imp != .
		la var acholi_dum_imp "Acholi ethnicity dummy"
	
	gen alur_dum_imp=(q13_imp==12) if q13_imp != .
		la var alur_dum_imp "Alur ethnicity dummy"
	
	gen bagwere_dum_imp=(q13_imp==21)  if q13_imp != .
		la var bagwere_dum_imp "Bagwere ethnicity dummy"
	
	gen iteso_dum_imp =(q13_imp==45) if q13_imp != .
		la var iteso_dum_imp "Iteso ethnicity dummy"
	
	gen karamojong_dum_imp =(q13_imp==51) if q13_imp != .
		la var karamojong_dum_imp "Karamojong ethnicity dummy"
	
	gen langi_dum_imp =(q13_imp==55) if q13_imp != .
		la var langi_dum_imp "Langi ethnicity dummy"
	
	gen lugbara_dum_imp =(q13_imp==57) if q13_imp != .
		la var lugbara_dum_imp "Lugbara ethnicity dummy"
	
	gen madi_dum_imp=(q13_imp==58) if q13_imp != .
		la var madi_dum_imp "Madi ethnicity dummy"

	gen other_dum_imp = (q13_imp!=11 & q13_imp!=12 & q13_imp!= 21& q13_imp!=45 & q13_imp!=51 & q13_imp!=55 & q13_imp!=57 & q13_imp!=58 )
		replace other_dum_imp = . if missing(q13_imp)
		la var other_dum_imp "Other ethnicity dummy"

// 2011 PREZ RESULTS MISSING FOR 64 PARISHES
replace pres_nrm_prop_11 = 	0.696 if parish=="Pakondo"	// parish
replace pres_nrm_prop_11 = 	0.649 if parish=="Ciforo"	
replace pres_nrm_prop_11 = 	0.705 if parish=="Odu"	// parish
replace pres_nrm_prop_11 = 	0.696 if parish=="Ataboo Central"	
replace pres_nrm_prop_11 = 	0.564 if parish=="Aringajobi"	// parish
replace pres_nrm_prop_11 = 	0.553 if parish=="Ariro"	
replace pres_nrm_prop_11 = 	0.647 if parish=="Logoba"	// parish
replace pres_nrm_prop_11 = 	0.535 if parish=="Lomunga"	// parish
replace pres_nrm_prop_11 = 	0.542 if parish=="Eremi"	// parish
replace pres_nrm_prop_11 = 	0.582 if parish=="Kochi"	// parish
replace pres_nrm_prop_11 = 	0.590 if parish=="Ward"	
replace pres_nrm_prop_11 = 	0.590 if parish=="West Yumbe"	
replace pres_nrm_prop_11 = 	0.643 if parish=="Anzu"	// parish
replace pres_nrm_prop_11 = 	0.206 if parish=="Nyai"	// parish
replace pres_nrm_prop_11 = 	0.551 if parish=="Sinyani"	
replace pres_nrm_prop_11 = 	0.464 if parish=="Abuge"	// parish
replace pres_nrm_prop_11 = 	0.593 if parish=="Anwangi"	// parish
replace pres_nrm_prop_11 = 	0.582 if parish=="Nambieso"	
replace pres_nrm_prop_11 = 	0.583 if parish=="Abaji"	
replace pres_nrm_prop_11 = 	0.583 if parish=="Paley"	
replace pres_nrm_prop_11 = 	0.693 if parish=="Paminya"	// parish
replace pres_nrm_prop_11 = 	0.716 if parish=="Aganga-Lendu"	// parish
replace pres_nrm_prop_11 = 	0.711 if parish=="Akaka"	// parish
replace pres_nrm_prop_11 = 	0.582 if parish=="Kamdini"	
replace pres_nrm_prop_11 = 	0.609 if parish=="Pukica"	// parish
replace pres_nrm_prop_11 = 	0.637 if parish=="Ajeri Jeri"	// parish
replace pres_nrm_prop_11 = 	0.494 if parish=="Owalo"	
replace pres_nrm_prop_11 = 	0.494 if parish=="Atinkok"	
replace pres_nrm_prop_11 = 	0.443 if parish=="Adok"	// parish
replace pres_nrm_prop_11 = 	0.494 if parish=="Apre"	
replace pres_nrm_prop_11 = 	0.612 if parish=="Bar dyang"	// parish
replace pres_nrm_prop_11 = 	0.494 if parish=="Angwec Bange"	
replace pres_nrm_prop_11 = 	0.633 if parish=="Kidepo"	// parish
replace pres_nrm_prop_11 = 	0.817 if parish=="Kapilan bar"	// parish
replace pres_nrm_prop_11 = 	0.806 if parish=="Kamukoi"	// parish
replace pres_nrm_prop_11 = 	0.602 if parish=="Lobatou"	
replace pres_nrm_prop_11 = 	0.515 if parish=="Oput"	// parish
replace pres_nrm_prop_11 = 	0.514 if parish=="Kobuku"	// parish
replace pres_nrm_prop_11 = 	0.572 if parish=="Kamailuk"	// parish
replace pres_nrm_prop_11 = 	0.939 if parish=="Nakapiripirit T/C"				
replace pres_nrm_prop_11 = 	0.651 if parish=="Pasia"		// parish
replace pres_nrm_prop_11 = 	0.601 if parish=="Angolol"		// parish
replace pres_nrm_prop_11 = 	0.441 if parish=="Kachango"		// parish
replace pres_nrm_prop_11 = 	0.812 if parish=="Kitoikawanoni"		// parish
replace pres_nrm_prop_11 = 	0.779 if parish=="Opwateta"		// parish
replace pres_nrm_prop_11 = 	0.768 if parish=="Oburiekori"		// parish
replace pres_nrm_prop_11 = 	0.490 if parish=="Akoboi"		// parish
replace pres_nrm_prop_11 = 	0.387 if parish=="Okulonyo"		// parish
replace pres_nrm_prop_11 = 	0.688 if parish=="Bululu"	// parish
replace pres_nrm_prop_11 = 	0.436 if parish=="T/Council"		
replace pres_nrm_prop_11 = 	0.436 if parish=="K'bulu"		
replace pres_nrm_prop_11 = 	0.436 if parish=="Otuboi"		
replace pres_nrm_prop_11 = 	0.590 if parish=="Orobo"		
replace pres_nrm_prop_11 = 	0.615 if parish=="Ajul"		// parish
replace pres_nrm_prop_11 = 	0.494 if parish=="Alyemeda"		
replace pres_nrm_prop_11 = 	0.613 if parish=="Alyec Meda"		// parish
replace pres_nrm_prop_11 = 	0.406 if parish=="Etam"		// parish
replace pres_nrm_prop_11 = 	0.494 if parish=="Awanangiri"	
replace pres_nrm_prop_11 = 	0.494 if parish=="Amaanangira"		
replace pres_nrm_prop_11 = 	0.532 if parish=="Awon Angiru"		// parish
replace pres_nrm_prop_11 = 	0.602 if parish=="Lopama"		
replace pres_nrm_prop_11 = 	0.939 if parish=="Nabilatuk TC"		
replace pres_nrm_prop_11 = 	0.970 if parish=="Lokarujak"		// parish
replace pres_nrm_prop_11 = 	0.494 if missing(pres_nrm_prop_11) & district=="LIRA"			
replace pres_nrm_prop_11 = 	0.634 if missing(pres_nrm_prop_11) & district=="PALLISA"
replace pres_nrm_prop_11 = 	0.553 if missing(pres_nrm_prop_11) & district=="MOYO"

replace pres_nrm_prop_06 = 	0.343 if parish=="Pakondo"
replace pres_nrm_prop_06 = 	0.455 if parish=="Ciforo"
replace pres_nrm_prop_06 = 	0.272 if parish=="Aringajobi"
replace pres_nrm_prop_06 = 	0.361 if parish=="Ariro"
replace pres_nrm_prop_06 = 	0.436 if parish=="Logoba"
replace pres_nrm_prop_06 = 	0.454 if parish=="Lomunga"
replace pres_nrm_prop_06 = 	0.329 if parish=="Eremi"
replace pres_nrm_prop_06 = 	0.496 if parish=="West Yumbe"
replace pres_nrm_prop_06 = 	0.364 if parish=="Eceko"
replace pres_nrm_prop_06 = 	0.247 if parish=="Ayaa"
replace pres_nrm_prop_06 = 	0.372 if parish=="Sinyani"
replace pres_nrm_prop_06 = 	0.350 if parish=="Abuge"
replace pres_nrm_prop_06 = 	0.116 if parish=="Apre"
replace pres_nrm_prop_06 = 	0.891 if parish=="Musupo"
replace pres_nrm_prop_06 = 	0.816 if parish=="Kidepo"
replace pres_nrm_prop_06 = 	0.572 if parish=="Kamukoi"
replace pres_nrm_prop_06 = 	0.817 if parish=="Loyoro"
replace pres_nrm_prop_06 = 	0.939 if parish=="Lobatou"
replace pres_nrm_prop_06 = 	0.269 if parish=="Oput"
replace pres_nrm_prop_06 = 	0.340 if parish=="Bukedea"
replace pres_nrm_prop_06 = 	0.305 if parish=="Kamailuk"
replace pres_nrm_prop_06 = 	0.727 if parish=="Nakapiripirit T/C"
replace pres_nrm_prop_06 = 	0.216 if parish=="Pasia"
replace pres_nrm_prop_06 = 	0.327 if parish=="Angolo"
replace pres_nrm_prop_06 = 	0.631 if parish=="Buseta"
replace pres_nrm_prop_06 = 	0.516 if parish=="Kibuku"
replace pres_nrm_prop_06 = 	0.860 if parish=="Central"
replace pres_nrm_prop_06 = 	0.280 if parish=="Oburiekori"
replace pres_nrm_prop_06 = 	0.133 if parish=="Okidi"
replace pres_nrm_prop_06 = 	0.133 if parish=="Bululu"
replace pres_nrm_prop_06 = 	0.186 if parish=="T/Council"
replace pres_nrm_prop_06 = 	0.186 if parish=="K'bulu"
replace pres_nrm_prop_06 = 	0.200 if parish=="Otuboi"
replace pres_nrm_prop_06 = 	0.215 if parish=="Amaanagira"
replace pres_nrm_prop_06 = 	0.953 if parish=="Nabilatuk TC" 
replace pres_nrm_prop_06 = 	0.163 if parish=="Acetgwen"
replace pres_nrm_prop_06 = 	0.961 if parish=="Lokarujak"
replace pres_nrm_prop_06 = 	0.079 if missing(pres_nrm_prop_06) & district =="LIRA"	
replace pres_nrm_prop_06 = 	0.516 if missing(pres_nrm_prop_06) & district =="PALLISA"	
replace pres_nrm_prop_06 = 	0.161 if missing(pres_nrm_prop_06) & district =="APAC"	


		
/***************************************************************************
*** 3. VARIABLE CONSTRUCTIONS **********************************************
****************************************************************************/

// MODIFY MAIN POLITICAL VARIABLES 
	
	// Construct PPA Index (ALT)
		egen ppa_index_alt_e = rowtotal (partyworked_resc ppapartymember), mi
			la var ppa_index_alt_e "Index of partisan political Action (0-6) ALT"
		
	// Regenerate EPA index (drop registered and voted in the LCV elections)
		drop epa_index_e
		egen epa_index_e = rowtotal(epavoteredu2011el_dum_e epadiscussvote2011el_dum_e epareportinc2011el_dum_e vote2011elprez_e), mi
			la var epa_index_e "Index of electoral political action (0-4)"
	
// CREATE REGION VARIABLE
	gen region = 1 if district == "APAC" | district =="LIRA" | district =="PALLISA" | district =="SOROTI" | district =="KUMI"
	replace region = 2 if district =="KABERAMAIDO" 	| district =="KOTIDO" 	 | district =="MOROTO" | district =="NAKAPIRIPIRIT" 
	replace region = 3 if district =="ADJUMANI" | district =="ARUA" | district =="MOYO" | district =="NEBBI" | district == "YUMBE" 
		la var region "Region" 
		la def region 1 "NC" 2"NE" 3"NW" 
		la val region region
	
// NEW PARISH AND SUBCOUNTY VARIABLE
 
	// Start with the variable from Sarah 
	gen parish_final = parish_gis
	gen subcounty_final = subcounty_gis
	
	// Drop parish data that was just parish
	replace parish_final = "" if parish_final =="PARISH"
	
	// Parish is missing for 21 groups
	mdesc parish_final
	ta groupid if parish_final == ""
	
	mdesc subcounty_final
	ta groupid if subcounty_final == ""
	
	// For these missing groups, let's use the baseline response to the question in the conclusion about the location of these groups. Sometimes the members of the same group say different parishes. I use the most most common response. 
	// Missing only parish 
	ta q295e if groupid ==53
	replace parish_final = "RENDRA" if groupid ==53
	
	// Missing btou
	*edit q295c q295e if groupid ==401
	replace parish_final = "NAWEYO" if groupid ==401
	replace subcounty_final = "BUDAKA" if groupid == 401 
	
	*edit q295c q295e if groupid ==402
	replace parish_final = "CHALI" if groupid ==402
	replace subcounty_final = "BUDAKA" if groupid == 402 
	
	*edit q295c q295e if groupid ==403
	replace parish_final = "BUDAKA" if groupid ==403
	replace subcounty_final = "BUDAKA" if groupid == 403 
	
	*edit q295c q295e if groupid ==404
	replace parish_final = "BUDAKA" if groupid ==404
	replace subcounty_final = "BUDAKA TC" if groupid == 403 
	
	*edit q295c q295e if groupid ==405
	replace parish_final = "KAMONKOLI" if groupid ==405
	replace subcounty_final = "KAMONKOLI" if groupid == 405
	
	*edit q295c q295e if groupid ==406
	replace parish_final = "IKI-IKI" if groupid ==406
	replace subcounty_final = "IKI-IKI" if groupid == 406
	
	*edit q295c q295e if groupid ==407
	replace parish_final = "KEREKERENE" if groupid ==407
	replace subcounty_final = "IKIIKI" if groupid == 407
	
	*edit q295c q295e if groupid ==408
	replace parish_final = "KIRYOLO" if groupid ==408
	replace subcounty_final = "KADERUNA" if groupid == 408
	
	*edit q295c q295e if groupid ==409
	replace parish_final = "KODIRI" if groupid ==409
	replace subcounty_final = "KADERUNA" if groupid == 409
	
	*edit q295c q295e if groupid ==410
	replace parish_final = "LERYA" if groupid ==410
	replace subcounty_final = "KAMERUKA" if groupid == 410
	
	*edit q295c q295e if groupid ==411
	replace parish_final = "BUKUCHAI" if groupid ==411
	replace subcounty_final = "KAMERUKA" if groupid == 411
	
	*edit q295c q295e if groupid ==414
	replace parish_final = "LYAMA" if groupid ==414
	replace subcounty_final = "LYAMA" if groupid == 414
	
	*edit q295c q295e if groupid ==415
	replace parish_final = "LUPADA" if groupid ==415
	replace subcounty_final = "NABOA" if groupid == 415
	
	*edit q295c q295e if groupid ==496
	replace parish_final = "JUNIOR QUATERS" if groupid ==496
	replace subcounty_final = "ADYEL" if groupid == 496
	
	*edit q295c q295e if groupid ==497
	replace parish_final = "STARCH FACTORY" if groupid ==497
	replace subcounty_final = "ADYEL" if groupid == 497
	
	*edit q295c q295e if groupid ==505
	replace parish_final = "ANAMWANY" if groupid ==505
	replace subcounty_final = "AWELO" if groupid == 505
	
	// No info for group 9993
	*edit q295c q295e if groupid ==9993
	*replace parish_final = "" if groupid ==9993	
	// groups 416, 413 and 501 have more than three different parish with no majority
	*edit q295c q295e if groupid ==416
	*replace parish_final = "" if groupid ==416
	replace subcounty_final = "NABOA" if groupid == 416
	
	*edit q295c q295e if groupid ==413
	*replace parish_final = "" if groupid ==413	
	replace subcounty_final = "LYAMA" if groupid == 413
	
	*edit q295c q295e if groupid ==501
	*replace parish_final = "" if groupid ==501
		
// ETHNICITY VARIABLE
	gen ethnic_group_long = q13
	replace ethnic_group_long = 68 if q13 == 3|q13==5|q13==8|q13==7
		la var ethnic_group_long "Ethnic Group (Long)"
		la val ethnic_group_long ethnicities
	
	gen ethnic_group_short = q13
	replace ethnic_group_short = 68 if q13 == 3|q13==5|q13==8|q13==7
	replace ethnic_group_short = 68 if q13 != 11 & q13 != 12& q13 !=21 & q13 != 45& q13 != 51& q13 != 55& q13 != 57& q13 != 58
	replace ethnic_group_short = . if q13==.
		la var ethnic_group_short "Ethnic Group (Short)"
		la val ethnic_group_short ethnicities
	
// GENERATE OTHER ETHNICITY DUMMY
	gen otheth_dum=(acholi_dum==0 & alur_dum==0 & bagwere_dum==0 & iteso_dum==0 & karamojong_dum==0 & langi_dum==0 & lugbara_dum==0 & madi_dum==0 ) if ind_found_b ==1
		la var otheth_dum "Ethnicity: Other"
 
// KNOW LCV PERSONALLY
	gen knowslc5_alt = (q281==1 | q281==2 | q281 ==3) if q281 !=.	
		la var knowslc5_alt "Know the LCV personally"
 
// EDUCATION (categorical)
	gen educ_categ_e = . 
	replace educ_categ_e = 1 if education == 0
	replace educ_categ_e = 2 if education >0 & education<8
	replace educ_categ_e = 3 if education >7 & education <12
	replace educ_categ_e = 4 if education > 11
		la var educ_categ_e "Education (categorical)"
		
	la def education_range_e 0 "No Education" 1 "Primary Education" 2 "Secondary Education" 3 "University" 4 "Post Graduate"
	gen education_range_e = 0 if educ_e==0
	replace education_range_e = 1 if educ_e>0 & educ_e<8
	replace education_range_e = 2 if educ_e>7 & educ_e<14
	replace education_range_e = 3 if educ_e==14
	la val education_range_e education_range_e

	ta education_range_e, gen(educ_)	
 
// RESCALE POLITICAL VARIABLES 
	gen discusspol_resc_e = discusspol_e - 1
		la var discusspol_resc_e "Discuss politics with friends (0-2)"

	gen free2011el_resc_e = free2011el_e-1
		la var free2011el_resc_e "Elections were free and fair (0-3)"

// VOTED FOR OPPOSITION 		
	gen voteopp_dum_e = (vote2011elprezinc_e ==2 | vote2011elprezincsupport_e==2 )
	replace voteopp_dum_e = . if missing(vote2011elprezinc_e) & missing(vote2011elprezincsupport_e)
	replace voteopp_dum_e = 1 if voteinc_dum_e==0 & voteopp_dum_e==.
	la var voteopp_dum_e "Voted or supported an opposition party in 2011"
	
// PARTISANSHIP

	// Like a political party
		/*
		gen partyaffnrmstrong_dum_e = (partyaffnrm_resc_e==5) if partyaffnrm_resc_e != . 
			la var partyaffnrmstrong_dum_e "Strongly like: NRM"

		gen partyafffdcstrong_dum_e = (partyafffdc_resc_e==5) if partyafffdc_resc_e != . 
			la var partyafffdcstrong_dum_e "Strongly like: FDC"

		gen partyafffupcstrong_dum_e = (partyaffupc_resc_e==5) if partyaffupc_resc_e != . 
			la var partyafffupcstrong_dum_e "Strongly like: UPC"
 
		gen partyaffdpstrong_dum_e = (partyaffdp_resc_e==5) if partyaffdp_resc_e != . 
			la var partyaffdpstrong_dum_e "Strongly like: FDP"

		egen partyaffoppstrong_dum_e = rowmax(partyafffdcstrong_dum_e partyafffupcstrong_dum_e partyaffdpstrong_dum_e) 
			la var partyaffoppstrong_dum_e "Strongly like one of the opposition party"
		*/
	// How do they like an opposition party? Take the maximum score of the opposition parties
		egen partyaffopp_resc_e = rowmax (partyaffdp_resc_e partyafffdc_resc_e partyaffupc_resc_e)
			la var partyaffopp_resc_e "How do you like opposition parties (max of fdp fdc upc)"
								
	// How much more they like the opposition party? Compare the score of opposition with NRM
		gen partyaffoppdiff_e = partyaffopp_resc_e-partyaffnrm_resc_e
			la var partyaffoppdiff_e "Relative Party Preference"
	
		gen partyaffoppdiff_dum_e = (partyaffoppdiff_e>0) if partyaffoppdiff_e!=.
			la var partyaffoppdiff_dum_e "Prefer the opposition"
	
	// Aggregate measure of partisanship
		egen nrm_e = rowtotal (nrmvote_e partyaffnrm_dum_e nrmclose_e nrmworked_e partywmembnrm_e), mi
			la var nrm_e "Support for the NRM (0-5)"
		
		egen nrm_prez_e = rowtotal(apprprezcurrent_dum_e voteinc_dum_e nrmvote_e partyaffnrm_dum_e nrmclose_e nrmworked_e partywmembnrm_e), mi
			la var nrm_prez_e "Support for the NRM and President (0-7)"

		egen dp_e = rowtotal (dpvote_e partyaffdp_dum_e dpclose_e dpworked_e partymembdp_e), mi
			la var dp_e "Support for the DP (0-5)"
		
		egen upc_e = rowtotal (upcvote_e partyafffupc_dum_e upcclose_e upcworked_e partymembupc_e), mi
			la var upc_e "Support for the UPC (0-5)"
		
		egen fdc_e = rowtotal (fdcvote_e partyafffdc_dum_e fdcclose_e fdcworked_e partymembfdc_e), mi
			la var fdc_e "Support for the FDC (0-5)"
		
		egen opposition_e = rowtotal (oppvote_e partyaffopp_dum_e oppclose_e oppworked_e partymembopp_e voteopp_dum_e ), mi
			la var opposition_e "Support the Opposition (0-5)"
	
// ELECTION INTIMIDATION

	// Was offered money
	gen vb_offeredmoney_resc_e = 4-vbofferyou2011el_e	
	replace vb_offeredmoney_resc_e = 0 if vbofferyou2011el_e==.d
		la var vb_offeredmoney_resc_e "Was offered money in exchange for vote (0-3)"
	
	gen vb_offeredmoney_os_e = (vbofferyou2011el_e==1 | vbofferyou2011el_e==2) if vbofferyou2011el_e!=.
		la var vb_offeredmoney_os_e "Was offered money in exchange for vote: Sometimes or Often"
	
	gen vb_offeredmoney_often_e = (vbofferyou2011el_e==1) if vbofferyou2011el_e!=.
		la var vb_offeredmoney_often_e "Was offered money in exchange for vote: Often"
	gen vb_offeredmoney_sometimes_e = (vbofferyou2011el_e==2) if vbofferyou2011el_e!=.
		la var vb_offeredmoney_sometimes_e "Was offered money in exchange for vote: Sometimes"
	gen vb_offeredmoney_rarely_e = (vbofferyou2011el_e==3) if vbofferyou2011el_e!=.
		la var vb_offeredmoney_rarely_e "Was offered money in exchange for vote: Rarely"
	gen vb_offeredmoney_never_e =(vbofferyou2011el_e==4) if vbofferyou2011el_e!=.
		la var vb_offeredmoney_never_e "Was offered money in exchange for vote: Never"

	// Was threatened
	gen vb_threatened_resc_e = vbthreatenyou2011el_e-1
	replace vb_threatened_resc_e = 0 if vbthreatenyou2011el_e==.d
		la var vb_threatened_resc_e "Was threatened during the 2011 election campaign (0-3)"
	
	gen vb_threatened_os_e = (vbthreatenyou2011el_e==1 | vbthreatenyou2011el_e==2) if vbthreatenyou2011el_e!=.
		la var vb_threatened_os_e "Was threatened: Sometimes or Often"
	
	gen vb_threatened_often_e = (vbthreatenyou2011el_e==4) if vbthreatenyou2011el_e!=.
		la var vb_threatened_often_e "Was threatened: Often"
	gen vb_threatened_sometimes_e = (vbthreatenyou2011el_e==3) if vbthreatenyou2011el_e!=.
		la var vb_threatened_sometimes_e "Was threatened: Sometimes"
	gen vb_threatened_rarely_e = (vbthreatenyou2011el_e==2) if vbthreatenyou2011el_e!=.
		la var vb_threatened_rarely_e "Was threatened: Rarely"
	gen vb_threatened_never_e = (vbthreatenyou2011el_e==1) if vbthreatenyou2011el_e!=.
		la var vb_threatened_never_e "Was threatened: Never"
	
	// Was intimidated
	gen vb_intimidated_resc_e = 4-vbintimidyou2011el_e	
	replace vb_intimidated_resc_e = 0 if vbintimidyou2011el_e==.d
		la var vb_intimidated_resc_e "Was intimidated during the 2011 election campaign (0-3)"
	
	gen vb_intimidated_os_e = (vbintimidyou2011el_e==1 | vbintimidyou2011el_e==2) if vbintimidyou2011el_e!=.
		la var vb_intimidated_os_e "Was intimidated: Sometimes or Often"
				
	gen vb_intimidated_often_e = (vbintimidyou2011el_e==1) if vbintimidyou2011el_e!=.
		la var vb_intimidated_often_e "Was intimidated: Often"
	gen vb_intimidated_sometimes_e = (vbintimidyou2011el_e==2) if vbintimidyou2011el_e!=.
		la var vb_intimidated_sometimes_e "Was intimidated: Sometimes"
	gen vb_intimidated_rarely_e = (vbintimidyou2011el_e==3) if vbintimidyou2011el_e!=.
		la var vb_intimidated_rarely_e "Was intimidated: Rarely"
	gen vb_intimidated_never_e = (vbintimidyou2011el_e==4) if vbintimidyou2011el_e!=.
		la var vb_intimidated_never_e "Was intimidated: Never"
	
	// Was taken to the polls
	gen tb_takentopoll_e = (tb2011ellcv_e== 1 | tb2011elprez_e==1) 
	replace tb_takentopoll_e = . if tb2011ellcv_e==. & tb2011elprez_e==.
		la var tb_takentopoll_e "Was taken to the poll (0-1)"

	// Electoral intimidation index
	foreach x in vb_offeredmoney_resc vb_threatened_resc vb_intimidated_resc { 
		gen `x'_dum_e = `x'_e/3
	}	
	egen e_influenced_e = rowtotal(vb_offeredmoney_resc_dum_e vb_threatened_resc_dum_e vb_intimidated_resc_dum_e tb_takentopoll_e cpneedinflvote_e), mi
		la var e_influenced_e "Index of 2011 election intimidation"
		 
// EXISTENCE OF A PATRON
	egen existpatron_e = rowmax(cpneedrelbigman_e cpneedrellocpol_e)
		la var existpatron_e "Existence of a patron (z-score)"

// ATTRIBUTION 		
	
	drop attribution_wb
	gen attribution_wb = (attrimpl_e ==5 | attrimpl_e ==10 | attrimpl_e ==11 | attrimpl_e ==12 | attrimpl_e==13 ) if attrimpl_e!=. 
	replace attribution_wb = . if attrimpl_e==.o
		la var attribution_wb "Foreign donor (e.g. World Bank, NGO)"
	
	gen attribution_local = (attrimpl_e ==6 | attrimpl_e ==7 | attrimpl_e ==8 | attrimpl_e ==9 ) if attrimpl_e!=.
	replace attribution_local = . if attrimpl_e==.o
		la var attribution_local "District or local politician/official"
	
	replace attribution_govt = . if attrimpl_e==.o
		la var attribution_govt "The President/NRM/national govt"
	
	ta attrinterpretation1_e, gen (attrinterpretation1_)
	foreach x in attrinterpretation1_1 attrinterpretation1_2 attrinterpretation1_3 attrinterpretation1_4 attrinterpretation1_5 attrinterpretation1_6 attrinterpretation1_7 { 
		replace `x'= . if attrinterpretation1_e==.
		replace `x' = 0 if attrinterpretation1_e==.d
	}
		la var attrinterpretation1_2 "To develop/assist the north"
		la var attrinterpretation1_3 "To make donors happy"	
		
	gen attrinterpretation1_incsup = (attrinterpretation1_e==1 | attrinterpretation1_e==4 | attrinterpretation1_e==5 ) if attrinterpretation1_e !=.
		la var attrinterpretation1_incsup "To increase political support"
	
	gen attrinterpretation1_dk = (attrinterpretation1_e==6 | attrinterpretation1_e==7 | attrinterpretation1_e==.d) if attrinterpretation1_e!=.
		la var attrinterpretation1_dk "Don't know"
		
	ta attrselect_e, gen(attrselect_)
	foreach x in attrselect_1 attrselect_2 attrselect_3 attrselect_4 attrselect_5 { 
		replace `x' = 0 if attrselect_e==.d
	}
		la var attrselect_1 "National government"
		la var attrselect_2 "District chairperson (elected official)"
		la var attrselect_3 "NUSAF district technical officer"
		la var attrselect_4 "District executive committee"
		la var attrselect_5 "Community facilitator"

	gen attrselect_dk = (attrselect_e==.d)
	replace attrselect_dk = . if attrselect_e==. 
		la var attrselect_dk "Don't know"
		
	gen selfair_e = attrselectfair_e
	replace selfair_e = 0 if attrselectfair_e==.d
		la var selfair_e "Do you think the selection was fair?"
	 
	la var attrselectreason_1_e "The best quality projects were selected"
	la var attrselectreason_4_e "Bribe to facilitator"
	la var attrselectreason_5_e "Relationship with district chairperson"
	la var attrselectreason_6_e "Random"
	la var attrselectreason_7_e "Don't Know"
	
	gen attrselectreason_hardwork = (attrselectreason_e==2 |attrselectreason_e==3) if attrselectreason_e!=.
		la var attrselectreason_hardwork "Hard work of group leaders/facilitators"
	
	gen assigned_wb = 0
	replace assigned_wb=1 if inlist(surveyexp_assigned,2,3)
	la var assigned_wb "Assigned to WB, survey experiment"

	gen assigned_govt = 0
	replace assigned_govt=1 if inlist(surveyexp_assigned,4,5)
	la var assigned_govt "Assigned to Govt, survey experiment" 

	gen assigned_random = 0
	replace assigned_random=1 if inlist(surveyexp_assigned,2,4)
	la var assigned_random "Assigned to random, survey experiment"

	gen assigned_notrandom = 0
	replace assigned_notrandom=1 if inlist(surveyexp_assigned,3,5)
	la var assigned_notrandom "Assigned to nonrandom, survey experiment"

/***************************************************************************
*** 3. CONSTRUCT NEW VARIABLES BETWEEN BASELINE AND ENDLINE ****************
****************************************************************************/
	
// IMPUTE MEDIAN VALUE FOR MISSING BASELINE VALUES
	foreach x of varlist female age age_2 age_3 urban $H $K $K2 $P $P_m $R $E $G $S $W $I low_nonag7da_zero high_nonag7da_zero nonaghours7da_zero { 	
		sum `x' if ind_found_b==1, d
		replace `x' = r(p50) if (`x'==. | `x'==.r)
	}	

// CASH INCREASE BETWEEN ENDLINE AND BASELINE
	
	* Cash4w has been capped at Baseline but not at endline
		sum cash4w_e if e1==1, d
		replace cash4w_e=r(p99) if cash4w_e>r(p99) & cash4w_e!=.
		
	* Linear increase in cash
		gen cash4w_inc_e = cash4w_e- cash4w 
			la var cash4w_inc_e "Increase in Cash 4w between Endline and Baseline"
				
		sort partid surveyid cash4w_inc_e
		by partid: carryforward cash4w_inc_e , replace	
				
		egen cash4w_inc_sd_e =std(cash4w_inc_e)
			la var cash4w_inc_sd_e "Increase in Cash 4w between Endline and Baseline (std)"
	
	* Log difference in cash
		gen cash4w_inc_log_e = ln(cash4w_e)- ln(cash4w)
		sort partid surveyid cash4w_inc_log_e
		by partid: carryforward cash4w_inc_log_e , replace	
			la var cash4w_inc_log_e "Log Increase in Cash 4w between Endline and Baseline"
			
/***************************************************************************
*** 3. VARIABLE TRANSFORMATION *********************************************
****************************************************************************/
		
// STANDARDIZE MAIN INDICES
	foreach x in existpatron epa_index ppa_index ppa_index_alt nrm_prez opposition fdc upc dp ldm_index contr_community e_influenced protest_attitude { 
		local lab : var label `x'_e
		egen `x'_std_e = std(`x'_e)
			la var `x'_std_e "`lab' standardized"
	}

// STANDARDIZE VARIABLES ACROSS NUSAF VS AB
	 foreach ethnic in acholi alur iteso karamojong langi lugbara madi {
		gen AB_`ethnic'_dum = `ethnic'_dum_imp 
		local lab : var lab `ethnic'_dum_imp
		la var AB_`ethnic'_dum "`lab', AB"
		}
	 ** PUT BAGWERE INTO OTHER ETHNICITY CATEGORY
	 gen AB_other_e_dum = max(bagwere_dum_imp,other_dum_imp) 
	 la var AB_other_e_dum "Other ethnicity (with Bagwere), AB"
	
// CREATE PREDICTED MEASURES OF PARTISANSHIP

	gl demographics "age female urban nonag_dummy father_farmer mother_farmer education literate wealthindex $ethnicgroup_imp $districts"	
	gl AB_demographics "educ_2 educ_3 educ_4 female age age_2 urban catholic_dum pentecostal_dum protestant_dum others_dum AB_acholi_dum AB_alur_dum AB_iteso_dum AB_karamojong_dum AB_langi_dum AB_madi_dum AB_other_e_dum pres_nrm_prop_11"
	gen imputed = 0
	
	foreach var in nonag_dummy father_farmer mother_farmer literate wealthindex urban catholic_dum pentecostal_dum protestant_dum ///
					muslim_dum others_dum educ_1 educ_2 educ_3 educ_4 langi_dum_imp acholi_dum_imp alur_dum_imp bagwere_dum_imp iteso_dum_imp karamojong_dum_imp ///
					madi_dum_imp other_dum_imp {
		replace imputed=1 if missing(`var')
	}
	foreach var in nonag_dummy father_farmer mother_farmer literate wealthindex urban  {
		sum `var', d
		replace `var' = r(p50) if missing(`var')	
	}
	 * manually impute religion
	replace catholic_dum = 1 if missing(catholic_dum)
	foreach religion in pentecostal protestant muslim others {
		replace `religion'_dum = 0 if missing(`religion'_dum)

	}
	* manually impute education
	replace educ_2 = 1 if missing(educ_2)
	foreach edu in 1 3 4 {
		replace educ_`edu' = 0 if missing(educ_`edu')
	}
	* manually impute ethnicity for YOP predictions
	replace langi_dum_imp = 1 if missing(langi_dum_imp)
	foreach eth in acholi alur bagwere iteso karamojong lugbara madi other {
		replace `eth'_dum_imp = 0 if missing(`eth'_dum_imp)
	}
	 * manually impute ethnicity for AB predictions
	replace AB_langi_dum = 1 if missing(AB_langi)
	foreach eth in acholi alur iteso karamojong lugbara madi other_e {
		replace AB_`eth'_dum = 0 if missing(AB_`eth'_dum)
	} 
	
	gen pol_diff =nrm_prez_std_e - opposition_std_e
		la var pol_diff ""
		
	levelsof partid if assigned==0, local(participants)	
	/*
	* Opposition support index
	svy: reg opposition_std_e $demographics pres_nrm_prop_06 pres_nrm_prop_11 if e2==1 & assigned==0		
		predict	opp_pred_e if e2==1 & assigned==1, xb
		* Control predicted value based off all other respondents assigned to the control group
		foreach i in `participants' {
			qui sum assigned if partid == `i'
				if r(mean) == 0 {
					qui svy: reg opposition_std_e $demographics pres_nrm_prop_06 pres_nrm_prop_11 if e2==1 & assigned==0 & partid != `i'
					predict opp_xb`i', xb
						replace opp_pred_e = opp_xb`i' if partid == `i'
					drop opp_xb`i'
				}
		}

		egen opp_pred_std_e = std(opp_pred_e)
		summ opp_pred_e, d
		gen opp_pred_likely_e=cond(opp_pred_e>r(p50),1,0) if e2==1 & opp_pred_e!=.
		drop opp_pred_e
		la var opp_pred_likely_e "Predicted support for Opposition above median"
		la var opp_pred_std_e "Predicted support for Opposition"
	
	* NRM support index	
	svy: reg nrm_prez_std_e $demographics pres_nrm_prop_06 pres_nrm_prop_11 if e2==1 & assigned==0		
		predict	nrm_pred_e if e2==1 & assigned==1 
		foreach i in `participants' {
			qui sum assigned if partid == `i'
				if r(mean) == 0 {
					qui svy: reg nrm_prez_std_e $demographics pres_nrm_prop_06 pres_nrm_prop_11 if e2==1 & assigned==0 & partid != `i'
					predict nrm_xb`i', xb
						replace nrm_pred_e = nrm_xb`i' if partid == `i'
					drop nrm_xb`i'
				}
		}
		egen nrm_pred_std_e = std(nrm_pred_e)
		summ nrm_pred_e, d
		gen nrm_pred_likely_e=cond(nrm_pred_e>r(p50),1,0) if e2==1 & nrm_pred_e!=.
		drop nrm_pred_e
		la var nrm_pred_likely_e "Predicted support for president/ruling party above median"
		la var nrm_pred_std_e "Predicted support for president/ruling party"
	
	* Voted for president
	svy: logit voteinc_dum_e $demographics pres_nrm_prop_06 pres_nrm_prop_11 if e2==1 & assigned==0		
		predict	prez_voted11_pred_e if e2==1 & assigned==1, xb
		foreach i in `participants' {
			qui sum assigned if partid == `i'
				if r(mean) == 0 {
					qui svy: logit voteinc_dum_e $demographics pres_nrm_prop_06 pres_nrm_prop_11 if e2==1 & assigned==0 & partid != `i'
					predict prez_voted11_xb`i', xb
						replace prez_voted11_pred_e = prez_voted11_xb`i' if partid == `i'
					drop prez_voted11_xb`i'
				}
		}
		summ prez_voted11_pred_e, d
		replace prez_voted11_pred_e = r(p50) if missing(prez_voted11_pred_e) &  e2==1 
		summ prez_voted11_pred_e, d
		gen prez_voted11_pred_likely_e =cond(prez_voted11_pred_e>r(p50),1,0) if e2==1 & prez_voted11_pred_e!=.
		la var prez_voted11_pred_likely_e "Predicted vote for president/ruling party above median"
		la var prez_voted11_pred_e "Predicted vote for president"

	* Voted for opposition
	svy: logit voteopp_dum_e $demographics pres_nrm_prop_06 pres_nrm_prop_11 if e2==1 & assigned==0		
		predict	opp_voted11_pred_e if e2==1 & assigned==1, xb
		foreach i in `participants' {
			qui sum assigned if partid == `i'
				if r(mean) == 0 {
					qui svy: logit voteopp_dum_e $demographics pres_nrm_prop_06 pres_nrm_prop_11 if e2==1 & assigned==0 & partid != `i'
					predict opp_voted11_xb`i', xb
						replace opp_voted11_pred_e = opp_voted11_xb`i' if partid == `i'
					drop opp_voted11_xb`i'
				}
		}
		summ opp_voted11_pred_e, d
		replace opp_voted11_pred_e = r(p50) if missing(opp_voted11_pred_e) &  e2==1 
		summ opp_voted11_pred_e, d
		gen opp_voted11_pred_likely_e =cond(opp_voted11_pred_e>r(p50),1,0) if e2==1 & opp_voted11_pred_e!=.
		la var opp_voted11_pred_likely_e "Predicted vote for opposition above median"
		la var opp_voted11_pred_e "Predicted vote for opposition"

	* AB COMPONENTS
	* NRM support index from three AB components
	
	 foreach var in nrmvote_e nrmclose_alt_e  partyaffnrm_dum_e {
		qui sum `var' if e2==1
		gen Z_`var' = (`var'-r(mean))/r(sd) 
	 }
	egen prez_std_e = rowtotal(Z_*)
	la var prez_std_e "Presidential support index, z-score AB" 
	drop Z_*

	svy: reg prez_std_e $AB_demographics D_1-D_14  if e2==1 & assigned==0		
		predict	nrm_pred_z_ab_e if e2==1 & assigned==1 
		foreach i in `participants' {
			qui sum assigned if partid == `i'
				if r(mean) == 0 {
					qui svy: reg prez_std_e $AB_demographics D_1-D_14 if e2==1 & assigned==0 & partid != `i'
					predict nrm_xb`i', xb
						replace nrm_pred_z_ab_e = nrm_xb`i' if partid == `i'
					drop nrm_xb`i'
				}
		}
		summ nrm_pred_z_ab_e, d
		replace nrm_pred_z_ab_e = r(p50) if missing(nrm_pred_z_ab_e) &  e2==1 
		egen nrm_pred_z_ab_std_e = std(nrm_pred_z_ab_e)
		summ nrm_pred_z_ab_e, d
		gen nrm_pred_likely_z_ab_e=cond(nrm_pred_z_ab_e>r(p50),1,0) if e2==1 & nrm_pred_z_ab_e!=.
		drop nrm_pred_z_ab_e
		la var nrm_pred_likely_z_ab_e "Predicted support for president/ruling party above median, AB data"
		la var nrm_pred_z_ab_std_e "Predicted support for president/ruling party, AB data"
	
	* OPP SUPPORT PREDICTION FROM AB
	
	 foreach var in oppvote_e oppclose_alt_e  partyaffopp_dum_e {
		qui sum `var' if e2==1
		gen Z_`var' = (`var'-r(mean))/r(sd) 
	 }
	egen opp_std_e = rowtotal(Z_*)
	la var opp_std_e "Oppositional support index, z-score AB" 
	drop Z_*

	svy: reg opp_std_e $AB_demographics D_1-D_14  if e2==1 & assigned==0		
		predict	opp_pred_z_ab_e if e2==1 & assigned==1 
		foreach i in `participants' {
			qui sum assigned if partid == `i'
				if r(mean) == 0 {
					qui svy: reg opp_std_e $AB_demographics D_1-D_14 if e2==1 & assigned==0 & partid != `i'
					predict opp_xb`i', xb
						replace opp_pred_z_ab_e = opp_xb`i' if partid == `i'
					drop opp_xb`i'
				}
		}
		summ opp_pred_z_ab_e, d
		replace opp_pred_z_ab_e = r(p50) if missing(opp_pred_z_ab_e) &  e2==1 
		egen opp_pred_z_ab_std_e = std(opp_pred_z_ab_e)
		summ opp_pred_z_ab_e, d
		gen opp_pred_likely_z_ab_e=cond(opp_pred_z_ab_e>r(p50),1,0) if e2==1 & opp_pred_z_ab_e!=.
		drop opp_pred_z_ab_e
		la var opp_pred_likely_z_ab_e "Predicted support for opposition above median, AB data"
		la var opp_pred_z_ab_std_e "Predicted support for opposition, AB data"
	
	
	* Would vote for NRM
	qui svy: logit nrmvote_e $AB_demographics D_1-D_14 if e2==1 & assigned==0		
		predict	nrm_wvote_pred_ab_e if e2==1 & assigned==1, xb
		foreach i in `participants' {
			qui sum assigned if partid == `i'
				if r(mean) == 0 {
					qui svy: logit voteopp_dum_e $AB_demographics  D_1-D_14 if e2==1 & assigned==0 & partid != `i'
					predict opp_voted11_xb`i', xb
						replace nrm_wvote_pred_ab_e = opp_voted11_xb`i' if partid == `i'
					drop opp_voted11_xb`i'
				}
		}
		summ nrm_wvote_pred_ab_e, d
		gen nrm_wvote_pred_likely_ab_e =cond(nrm_wvote_pred_ab_e>r(p50),1,0) if e2==1 & nrm_wvote_pred_ab_e!=.
		la var nrm_wvote_pred_likely_ab_e "Predicted to vote for NRM in future above median"
		la var nrm_wvote_pred_ab_e "Predicted to vote for NRM in future"
	
	* Likes/strongly likes NRM
	qui svy: logit partyaffnrm_dum_e $AB_demographics D_1-D_14 if e2==1 & assigned==0		
		predict	nrm_like_pred_ab_e if e2==1 & assigned==1, xb
		foreach i in `participants' {
			qui sum assigned if partid == `i'
				if r(mean) == 0 {
					qui svy: logit partyaffnrm_dum_e $AB_demographics D_1-D_14 if e2==1 & assigned==0 & partid != `i'
					predict nrm_like_xb`i', xb
						replace nrm_like_pred_ab_e = nrm_like_xb`i' if partid == `i'
					drop nrm_like_xb`i'
				}
		}
		summ nrm_like_pred_ab_e, d
		gen nrm_like_pred_likely_ab_e =cond(nrm_like_pred_ab_e>r(p50),1,0) if e2==1 & nrm_like_pred_ab_e!=.
		la var nrm_like_pred_likely_ab_e "Predicted like of NRM above median"
		la var nrm_like_pred_ab_e "Predicted like of NRM"
	
	* Feels close
	qui svy: logit nrmclose_alt_e $AB_demographics D_1-D_14 if e2==1 & assigned==0		
		predict	nrm_close_pred_ab_e if e2==1 & assigned==1, xb
		foreach i in `participants' {
			qui sum assigned if partid == `i'
				if r(mean) == 0 {
					qui svy: logit nrmclose_alt_e $AB_demographics D_1-D_14 if e2==1 & assigned==0 & partid != `i'
					predict nrm_close_xb`i', xb
						replace nrm_close_pred_ab_e = nrm_close_xb`i' if partid == `i'
					drop nrm_close_xb`i'
				}
		}
		summ nrm_close_pred_ab_e, d
		gen nrm_close_pred_likely_ab_e =cond(nrm_close_pred_ab_e>r(p50),1,0) if e2==1 & nrm_close_pred_ab_e!=.
		la var nrm_close_pred_likely_ab_e "Predicted feel close to NRM above median"
		la var nrm_close_pred_ab_e "Predicted feel close to NRM"	
	*/
	
	* Supports NRM 
/*	gen prez_vote_diff = prez_voted11_pred_e - voteinc_dum_e if e2==1
	gen opp_vote_diff = opp_voted11_pred_e - voteopp_dum_e if e2==1
	gen opp_support_diff = opp_pred_std_e - opposition_std_e if e2==1
	gen nrm_support_diff = nrm_pred_std_e - nrm_prez_std_e if e2==1

	/*tw hist prez_vote_diff if assigned==0, start(-1) width(.05) || hist prez_vote_diff if assigned==1, start(-1) width(.05) gap(40) col(black)
	tw hist opp_vote_diff if assigned==0, start(-1) width(.05) || hist opp_vote_diff if assigned==1, start(-1) width(.05) gap(40) col(black)
	tw hist opp_support_diff if assigned==0, start(-6) width(.25) || hist opp_support_diff if assigned==1, start(-6) width(.25) gap(40) col(black)
	tw hist nrm_support_diff if assigned==0, start(-6) width(.25) || hist nrm_support_diff if assigned==1, start(-6) width(.25) gap(40) col(black)
	*/	
// GENERATE INTERACTION 	
	*partyaffoppdiff_prop_dum partyaffnrm_resc_prop_dum	 partyaffoppdiff_prop partyaffnrm_resc_prop
	foreach x in opp_pred_std_e prez_voted11_pred_e opp_voted11_pred_e nrm_pred_std_e survey_gov_e survey_int_e selection_random_e attribution_govt_e ass_gov survey_gov ass_notrandom ass_random lgrantsize_pp_est1 pres_nrm_prop_11 { 
		*gen t_`x' = treated*`x'
		gen a_`x' = assigned*`x'
	}	 
	*/

/***************************************************************************
*** 3. LABELS **************************************************************
****************************************************************************/
	
	la var pres_nrm_prop_06 "Parish NRM vote share in 2006"
	
	// ECON OUTCOMES
		la var treated "Group received YOP cash transfer"
		la var anytransferlikely_e "Thinks likely to receive future program"
		la var bizasset_val_real_p99_e "Business assets (000s 2008 UGX)"
		la var totalhrs7da_zero_e "Average employment hours per week"
		la var zero_hours_e "No employment hours in past month"
		la var trade_dummy_e "Engaged in any skilled trade"
		la var migrate_e "Has changed parish since baseline"
		la var urban_e "Lives in large town or city"
		la var capital_e "Lives in Kampala"
		la var profits4w_real_p99_e "Monthly cash earnings (000s 2008 UGX)"
		la var wealthindex_e "Durable assets (z-score)"
		la var consumption_real_p99_z_e "Non-durable consumption (z-score)"

	// OUTCOMES 
	
	* Outcomes dv_index	
		la var epa_index_std_e "Index of electoral political action (z-score)"
		la var ppa_index_std_e "Index of partisan political action (z-score)"
		la var nrm_prez_std_e "Index of NRM/Presidential support (z-score)"
		la var opposition_std_e "Index of opposition support (z-score)"
		la var e_influenced_std_e "Index of 2011 election intimidation (z-score)"
		la var ldm_index_std_e "Index of leadership & decision-making (z-score)"
		la var contr_community_std_e "Index of community contributions (z-score)"
		la var protest_attitude_std_e "Index of protest attitudes/participation (z-score)"
		la var existpatron_std_e "Existence of a patron (z-score)"
	* Components epa_index_std_e
		la var epavoteredu2011el_dum_e "Attended voter education meeting "
		la var epadiscussvote2011el_dum_e "Got together with other to discuss vote "
		la var epareportinc2011el_dum_e "Reported a campaign malpractice"
		la var vote2011elprez_e "Voted in the presidential election"
	* Components ppa_index_std_e
		la var pparally2011el_resc_e "Attended an election rally (0-3)"
		la var ppaprimary2011el_resc_e "Participated in a political primary (0-3)"
		la var partyworked_resc_e "Worked to get a candidate/party elected (0-3)"
		la var ppapartymember_e "Member of a political party (0-3)"
	* Components nrm_prez_std_e
		la var nrmvote_e "Would vote NRM if election tomorrow"
		la var partyaffnrm_dum_e "Like or strongly like the NRM "
		la var nrmclose_alt_e "Feels close to the NRM"
		la var nrmworked_e "Worked to get the NRM elected"
		la var partywmembnrm_e "Member of the NRM"
		la var voteinc_dum_e "Voted or supported the President in 2011"
		la var apprprezcurrent_dum_e "Approve or strongly approve of President" 
	* Components opposition_std_e
		la var oppvote_e "Would vote opposition if election tomorrow"
		la var partyaffopp_dum_e "Like or strongly like any opposition party"
		la var oppclose_alt_e "Feels close to any opposition party"	 
		la var oppworked_e "Worked to get the opposition elected"	
		la var partymembopp_e "Member of an opposition party "
	* Components e_influenced_std_e
		la var vb_offeredmoney_resc_e "Was offered money in exchange for vote (0-3)"
		la var vb_threatened_resc_e "Was threatened during campaign (0-3)"
		la var vb_intimidated_resc_e "Was intimidated during campaign (0-3)"
		la var tb_takentopoll_e "Was taken to the poll on election day"
		la var cpneedinflvote_e "Any of patrons tried to influence you"
	* Components ldm_index_std_e
		la var ldmcomlc1_resc_e "Member of the village (LC1) committee"
		la var ldmcomother_resc_e "Member of another village committee"
		la var ldmacceptc1_resc_e "Would accept LC1 position if nominated"
	* Components contr_community_std_e
		la var contrpubgood_vol_dum_e "Contributed voluntary to public good"
		la var comm_meet12m_dum_e "Attended community meeting in past year"
		la var comm_mobilizer_e "Mobilizes communities for meetings"
		la var belongs_to_group_e "Belongs to a commununity group"
	* Components protest_attitude_std_e
		la var protest_attitude_std_e "Index of protest attitudes/participation (z-score)"
		la var protests_e "Protest attendance index (4-point scale)"
		la var attptreasonjustified_resc_e "Feel protests were justified"
		la var attptviolencejustified_resc_e "Feel violence and destruction during protests was justified"
		la var attptpolvioljustified_resc_e "Feel police and the military were justified in having a violent response to the protest"
		la var hcaptwish_e "Wishes there would have been a protest in their district"
		la var hcaptwouldgo_e "Would go if there was a similar protest in their district"
		la var hcaptwouldgoviol_e "If the protest turned violent, would stay to participate in the violence"
		
	* Components existpatron_std_e
		la var cpneedrelbigman_e "There is a big man he can go to if in need"
		la var cpneedrellocpol_e "There is politician he can go to if in need"
	
	* Others 
		la var apprprezcurrent_e "Approve of the way the Pdt Museveni has performed his job over the past 12m 0-5"
		la var dp_std_e "Support for the DP (z-score)"
		la var upc_std_e "Support for the UPC (z-score)"
		la var fdc_std_e "Support for the FDC (z-score)"
		la var cpneedrelative_e "There is a family member he can go to if in need"
		la var taxcorrupt_e "Thinks tax officials are corrupt (0-3)"
		la var taxright_e "The tax department always has the right to make people pay taxes"
		la var secballott_e "Thinks it is likely that powerful people can find out how they voted"
		la var apprlc1current_e "Approve the current LC 1 (1-4)"
		la var apprlc3current_e "Approve the current LC 3 (1-4)"
		la var apprlc3previous_e "Approve the previous LC 3 (1-4)"
		la var apprlc5current_e "Approve the current LC 5 (1-4)"
		la var apprlc5previous_e "Approve the previous LC 5 (1-4)"
		la var helpfuturengoyou12mlik_e "Thinks it is very likely that he will receive more transfer from the NGO (0-1)"
		la var helpfuturegovyou12mlik_e "Thinks it is very likely that he will receive more transfer from the Gov (0-1)"
		la var fdcclose_alt_e "Feel close to the FDC (0-1)"
		la var partyafffdc_dum_e "Like or strongly like the FDC (0-1)"
		la var fdcvote_e "Would vote for FDC if elections were tomorrow (0-1)"
		la var upcclose_alt_e "Feel close to the UPC (0-1)"
		la var partyafffupc_dum_e "Like or strongly like the UPC (0-1)"
		la var upcvote_e "Would vote for UPC if elections were tomorrow (0-1)"
		la var dpclose_alt_e "Feel close to the DP (0-1)"
		la var partyaffdp_dum_e "Like or strongly like the DP (0-1)"
		la var dpvote_e "Would vote for DP if elections were tomorrow (0-1)"
	
	// BASELINE CONTROLS
	
	* Baseline controls ctrl_indiv
		la var age "Age"
	* Baseline controls P
		la var regsuccess2006 "Registered to vote in 2006"
		la var vote2006elprez "Voted in 2006 presidential election"
		la var vote2005ref "Voted in 2005 referendum" 
		la var vote2006ellcv "Voted in 2005 district election" 
		la var ppapartymember "Member of a political party" 
		la var comm_elections_dum "Participated in election of community leaders in past year" 
		la var comm_meetings "Attended community meetings in past month" 
		la var comm_mobilizer "Is a community mobilizer" 
		la var belongs_to_group "Belongs to a commununity group" 
		la var comm_leaders "Currently a community leader" 
		la var ldmcomother "Currently on a community committee" 
		la var ldmacceptc1 "Would accept nomination to be community leader"
	* Baseline controls G 	
		la var q250 "Trust people in youth group"
		la var q251a "People cooperate well in youth group"
		la var q252 "Would form a group with same member"
		la var q253a "Would work with same facilitator"
		la var q254 "Voice was heard when discussing projects"
		la var trustequshare "Money will benefit members equally"
		la var q258 "Number of members who will complete the training"
		la var q259 "Number of members were your friends before"
		la var q260 "Group existed before"
	* Baseline controls H
		la var education "Education"
		la var literate "Literacy"
		la var voc_training "Indicator for prior vocational training"
		la var numeracy_numcorrect_m "Numeracy"
	* Baseline controls K
		la var wealthindex "Wealth Index"
		la var savings_6mo_p99 "Savings"
		la var cash4w_p99 "Cash earned in past month"
		la var loan_100k "Could obtain a 100k loan"
		la var loan_1mil "Could obtain a 1 million loan"	
	* Baseline controls S
		la var family_caring "Family very caring"
		la var family_disputes "Family disputes"
		la var social_support_all "Community support"
		la var prosocial "Prosocial behavior"
		la var groups_in "Number of group memberships"
		la var hrs_bizz_advice "Hours spent getting business advice in past month"
	* Baseline controls I 
		la var jumpy "Are you jumpy?"
		la var q157 "Do you destroy things that belong to others?"
		la var q162 "Do you feel like you do not value your life?"
		la var quarrelsome "Are you quarrelsome?"
		la var unloved "Do you feel unloved?"
		la var q166 "Do you think that everything you do is wrong?"
		la var dishonest "Do you lie or behave in a dishonest way?"
		la var takethings "Do you take things from other places without permission?"
		la var disobeyparents "Do you disobey your parents/guardians, teachers or elders?"
		la var curse "Do you curse or use abusive language?"
		la var threaten "Do you threaten to hurt others?"
		la var disputes "Indicator for any angry non-family disputes in past two weeks"
	* Baseline controls Ethnicity
		la var acholi_dum 		"Ethnicity: Acholi"
		la var alur_dum 		"Ethnicity: Alur"
		la var bagwere_dum 		"Ethnicity: Bagwere" 
		la var iteso_dum 		"Ethnicity: Iteso" 
		la var karamojong_dum "Ethnicity: Karamojong" 
		la var langi_dum 	"Ethnicity: Langi" 
		la var lugbara_dum 		"Ethnicity: Lugbara" 
		la var madi_dum 	"Ethnicity: Madi" 
	* Districts
		la var district_2 "District Amolatar"
		la var district_3 "District Apac"
		la var district_4 "District Arua"
		la var district_5 "District Budaka"
		la var district_6 "District Bukedea"
		la var district_7 "District Dokolo"
		la var district_8 "District Kaabong"
		la var district_9 "District Kaberamaido"
		la var district_10 "District Koboko"
		la var district_11 "District Kotido"
		la var district_12 "District Kumi"
		la var district_13 "District Lira"
		la var district_14 "District Moroto"
		la var district_15 "District Moyo"
		la var district_16 "District Nakapiripirit"
		la var district_17 "District Nebbi"
		la var district_18 "District Nyadri"
		la var district_19 "District Pyam"
		la var district_20 "District Pallisa"
		la var district_21 "District Soroti"
		la var district_22 "District Yumbe"

	// LAGGED DV 
		la var ppapartymember "Member of a political party (0-1)"
		la var epa_index "Index of electoral political action (0-4)"
		la var comm_mobilizer "Mobilizes communities for meetings (0-1)"
		la var contr_community "Contribution to Community Index (0-4)"
		la var ldmcomother "Member in a decision making committee (0-1)"
		la var ldm_index "Leadership/Decision making involvment (0-3)"
	
	// OTHER NOT USED 
		la var polknowledge "Knows the name of LC3 and LC5 (0-1)"
		la var satisleadership "Satisfaction with the community and subcounty leadership (0-3)"
		la var vote2006elprez "Voted in the presidential election (0-1)" 
		la var vote2005ref "Voted in August 2005 Referendum (0-1)"
		la var vote2006ellcv "Voted in the LCV election (0-1)"
		la var comm_meetings "1 if attended community meetings in past month (0-1)"
		la var comm_leaders "Currently a community leader in any way (0-1)"
		la var leader "Is a group leader (0-1)"
		la var personalrel "Personal Relationship index (0-3)"
		la var votebuying "Was offered money or gift or was threatened (0-1)"
		la var supportlcv_e "Support for the previous LC V (0-1)"
		la var vote2011ellcvinccomb_dum_e "Voted or support the previous LCV (0-1)"
		la var apprlc5previous_dum_e "Approve or Strongly Approve the LC V (0-1)"
		la var disapprlc5previous_dum_e "Disapprove or Strongly Disapprove the LC V (0-1)"
		la var q274 "Has a close family member related to a community or political leader"
		la var attribution_govt_e "Attribution to the government"
		la var disapprprezcurrent_dum_e "Disapprove or Strongly Disapprove the president (0-1)"
		la var supprezpolicies_dum_e "Agree with the statement that the government policies have benefited the most 0-1"
		la var ldmcomlc1_e "Member of the LC1 comittee (0-1)"
		la var ldmcomother_e "Member of a decision making comittee (0-1)"
		la var ldmacceptc1_e "Would accept LC1 position if nominated (0-1)"
		la var ldm_index_e "Leadership/Decision making involvment (0-3)"
		la var contr_community_e "Contribution to community Index (0-4)"
		la var contrpubgood_all_e "Contribution to public good (all) (0-7)"
		la var contrpubgood_vol_e "Contribution to public good (voluntary) (0-6)"
		la var rcaraiseissue12m_dum_e "Got together with others to raise an issue (0-1)"
		la var rcademo12m_dum_e "Attended a demonstration or protest march (0-1)" 
		
// LABEL FOR TABLE 
	la var admin_cost_us 	"Grant amount applied for, USD"
	la var groupsize_est_e 	"Group size"
	la var grantsize_pp_US_est3 	"Grant amount per member, USD"
	la var group_existed 	"Group existed before application"
	la var group_age 	"Group age, in years"
	la var ingroup_hetero 	"Within-group heterogeneity (z-score)"
	la var ingroup_dynamic 	"Quality of group dynamic (z-score)"
	la var avgdisteduc	"Distance to educational facilities (km)"
	la var ind_unfound_b	"Individual unfound at baseline"
	la var age 	"Age at baseline"
	la var female 	"Female"
	la var urban 	"Large town/urban area"
	la var risk_aversion 	"Risk aversion index (z-score)"
	la var grp_leader 	"Any leadership position in group"
	la var grp_chair 	"Group chair or vice-chair"
	la var totalhrs7da_zero 	"Weekly employment, hours"
	la var nonaghours7da_zero 	"All non-agricultural work"
	la var lowskill7da_zero 	"Casual labor, low skill"
	la var lowbus7da_zero 	"Petty business, low skill"
	la var skilledtrade7da_zero 	"Skilled trades"
	la var highskill7da_zero 	"High-skill wage labor"
	la var acto7da_zero 	"Other non-agricultural work"
	la var aghours7da_zero 	"All agricultural work"
	la var chores7da_zero	"Weekly household chores, hours"
	la var zero_hours 	"Zero employment hours in past month"
	la var nonag_dummy	"Main occupation is non-agricultural"
	la var emplvoc 	"Engaged in a skilled trade"
	la var inschool 	"Currently in school"
	la var education 	"Highest grade reached at school"
	la var literate 	"Able to read and write minimally"
	la var voc_training 	"Received prior vocational training"
	la var numeracy_numcorrect_m 	"Digit recall test score"
	la var adl 	"Index of physical disability"
	la var wealthindex 	"Durable assets (z-score)"
	la var savings_6mo_p99 	"Savings in past 6 mo. (000s 2008 UGX)"
	la var cash4w_p99 	"Monthly gross cash earnings (000s 2008 UGX)"
	la var loan_100k 	"Can obtain 100,000 UGX ($58) loan"
	la var loan_1mil 	"Can obtain 1,000,000 UGX ($580) loan"
	la var regsuccess2006	"Registered to vote in 2006"
	la var vote2006elprez 	"Voted in 2006 presidential election"
	la var vote2005ref	"Voted in 2005 referendum"
	la var vote2006ellcv 	"Voted in 2005 district election"
	la var ppapartymember 	"Member of a political party"
	la var comm_elections_dum 	"Participated in election of community leaders in past year"
	la var comm_meetings	"Attended community meetings in past month"
	la var comm_mobilizer 	"Is a community mobilizer"
	la var belongs_to_group 	"Belongs to a commununity group"
	la var comm_leaders 	"Currently a community leader"
	la var ldmcomother 	"Currently on a community committee"
	la var ldmacceptc1 	"Would accept nomination to be community leader"
	la var pres_nrm_prop_06 "Parish vote share for Museveni, 2006"
	
	la var groupsize_est_e "Applicant group size"
	la var grantsize_pp_US_est3 "Grant amount per member, USD"
	la var age "Age at baseline"
	la var urban "Large town or urban area"
	la var wealthindex "Wealth Index"
	la var commngolikely_e "Likely that community will received transfer from NGO next year"
	la var commgovlikely_e "Likely that community will received transfer from govt next year"
	la var indngolikely_e "Likely that I will received transfer from NGO next year"
	la var indgovlikely_e "Likely that I will received transfer from govt next year"
	
	
sort groupid 


********************************************************************************
* Perform some final cleanings *************************************************
********************************************************************************


	* Clean endline district info * 
	gen district_b = q295a
	la var district_b "Baseline district"
	
	gen district_e = indistrict_e		
	replace district_e = "OTHER" if indistrict_e=="0"
	replace district_e = "ADJUMANI" if indistrict_e=="1"
	replace district_e = "AMOLATAR" if indistrict_e=="2"
	replace district_e = "APAC" if indistrict_e=="3"
	replace district_e = "ARUA" if indistrict_e=="4"
	replace district_e = "BUDAKA" if indistrict_e=="5"
	replace district_e = "BUKEDEA" if indistrict_e=="6"
	replace district_e = "DOKOLO" if indistrict_e=="7"
	replace district_e = "KAABONG" if indistrict_e=="8"
	replace district_e = "KABERAMAIDO" if indistrict_e=="9"
	replace district_e = "KOBOKO" if indistrict_e=="10"
	replace district_e = "KOTIDO" if indistrict_e=="11"
	replace district_e = "KUMI" if indistrict_e=="12"
	replace district_e = "LIRA" if indistrict_e=="13"
	replace district_e = "MOROTO" if indistrict_e=="14"
	replace district_e = "MOYO" if indistrict_e=="15"
	replace district_e = "NAKAPIRPIRIT" if indistrict_e=="16"
	replace district_e = "NEBBI" if indistrict_e=="17"
	replace district_e = "NYADRI" if indistrict_e=="18"
	replace district_e = "OYAM" if indistrict_e=="19"
	replace district_e = "PALLISA" if indistrict_e=="20"
	replace district_e = "SOROTI" if indistrict_e=="21"
	replace district_e = "YUMBE" if indistrict_e=="22"
			
	replace district_e = "ADJUMANI" if inlist(indistrict_e, "ADJMANI", "Adjuma i", "Adjumani")
	replace district_e = "AMOLATAR" if inlist(indistrict_e, "Amolatar", "Amolatr")
	replace district_e = "APAC" if inlist(indistrict_e, "Apac", "Apac \", "Apav", "Apsc")
	replace district_e = "ARUA" if inlist(indistrict_e, "Arua", "Aruq")
	replace district_e = "BUDAKA" if inlist(indistrict_e, "Bukaka", "Budakaa", "Budaka")
	replace district_e = "BUKEDEA" if inlist(indistrict_e, "Bukedea", "Bukedia")
	replace district_e = "DOKOLO" if inlist(indistrict_e, "Dokolo")
	replace district_e = "KABERAMAIDO" if inlist(indistrict_e, "Kaberamaido", "KaberEmaido", "Kaberemaido")
	replace district_e = "KOBOKO" if inlist(indistrict_e, "Koboko")
	replace district_e = "MOROTO" if inlist(indistrict_e, "Morort", "Morot", "Morotp")
	replace district_e = "MOYO" if inlist(indistrict_e, "Mol0", "Moy0")
	replace district_e = "LIRA" if inlist(indistrict_e, "Liea", "Lira", "Lita")
	replace district_e = "NAKAPIRIPIRIT" if inlist(indistrict_e, "Naka iriprt", "Nakapiripirita", "Nakapiripirt")
	replace district_e = "NAKAPIRIPIRIT" if inlist(indistrict_e, " Nakapiripirt", "Nakapiripit", "Nakapiriprit", "Nakapirpiri", "Nakapirpirit", "Nakapirpirt", "Nakapirripirit")
	replace district_e = "NEBBI" if inlist(indistrict_e, "Neb bi", "Nebbi", "NEEBI")
	replace district_e = "YUMBE" if inlist(indistrict_e, "Yumbe ")
	replace district_e = "PALLISA" if inlist(indistrict_e, "ApllIsa", "pallisa", "Pallisa", "Kibuku", "Apllisa")
	replace district_e= strupper(district_e)
	replace district_e = "NAKAPIRIPIRIT" if inlist(district_e, "NAKAPIRPIRIT")
	replace district_e = "NEBBI" if inlist(district_e, "NEEBBI")
	replace district_e = "LUWEERO" if inlist(district_e, "LUWERO")
	replace district_e = "ARUA" if inlist(district_e, "NYADRI")
	
	la var district_e "Endline district for LC5 voting results"
	
	gen district_e_move = district_e
	replace district_e_move = "OTHER" if inlist(district_e, "AGAGO", "ALEBTONG", "AMUDAT", "BUIKWE", "ENTEBBE-WAKISO", "GULU", "K0LE") 
	replace district_e_move = "OTHER" if inlist(district_e, "KAMPALA", "KATAKWI", "KOLE", "KOTIDO", "LUWEERO", "MARACHA", "MBALE", "MUKONO")
	replace district_e_move = "OTHER" if inlist(district_e, "MUKONO", "NAPAK", "NGORA", "OTUKE", "PADER", "SERERE", "WAKISO", "ZOMBO")
	la var district_e_move "Endline district for moving from baseline"
	
	cap drop _merge
	merge m:1 district_e using "$NUSAF/Other politics data/LC5 party/2011_LC5_by_district.dta"
	

	** Interaction terms
		foreach var in win_nrm win_opp {
			gen a_`var' = assigned*`var'
			la var a_`var' "Assigned x `var'"
		}
	
	foreach x in apprlc3previous apprlc3current apprlc1current { 
					local lbl : variable label `x'_e
					cap drop `x'_resc_e
					recode `x'_e (3=4) (4=5) (.d=3) (.r=.), gen (`x'_resc_e)
						la var `x'_resc_e "`lbl'"
				}	
				la var apprlc5previous_resc_e "Approve of the way the previous LCV has performed his job(1-5)"
				la var apprlc5current_resc_e "Approve of the way the current LCV has performed his job (1-5)"
				
			
				* Approve the current/ previous LC 3
			cap	gen apprlc3previous_dum_e = (apprlc3previous_resc_e ==4 |apprlc3previous_resc_e==5) if apprlc3previous_resc_e!=.
					la var apprlc3previous_dum_e "Approve or Strongly Approve the previous LC3 (0-1)" 
				
			cap	gen disapprlc3previous_dum_e = (apprlc3previous_resc_e ==1 |apprlc3previous_resc==2) if apprlc3previous_resc!=.
					la var disapprlc3previous_dum_e "Disapprove or Strongly Disapprove the previous LC3 (0-1)" 
				
			cap	gen apprlc3current_dum_e = (apprlc3current_resc_e==4 |apprlc3current_resc==5) if apprlc3current_resc!=.
					la var apprlc3current_dum_e "Approve or Strongly Approve the current LC3 (0-1)" 
					
			cap	gen disapprlc3current_dum_e = (apprlc3current_resc_e==1 |apprlc3current_resc==2) if apprlc3current_resc!=.
					la var disapprlc3current_dum_e "Disapprove or Strongly Disapprove the current LC3 (0-1)" 
					
				* Approve the current LC1
			cap	gen apprlc1current_dum_e = (apprlc1current_resc_e==4 |apprlc1current_resc==5) if apprlc1current_resc!=.
					la var apprlc1current_dum_e "Approve or Strongly Approve the current LC1 (0-1)" 
					
			cap	gen disapprlc1current_dum_e = (apprlc1current_resc_e==1 |apprlc1current_resc==2) if apprlc1current_resc!=.
					la var disapprlc1current_dum_e "Disapprove or Strongly Disapprove the current LC1 (0-1)" 
		
			* Approve the current LC5 
			cap	gen apprlc5current_dum_e = (apprlc5current_resc_e==4 |apprlc5current_resc==5) if apprlc5current_resc!=.
					la var apprlc5current_dum_e "Approve or Strongly Approve the current LC5 (0-1)" 
					
			cap	gen disapprlc5current_dum_e = (apprlc5current_resc_e==1 |apprlc5current_resc==2) if apprlc5current_resc!=.
					la var disapprlc5current_dum_e "Disapprove or Strongly Disapprove the current LC5 (0-1)" 
	
	* Clean selection variable
	
	* Opposition support index
	gen pres_opp_prop_11 = 1-pres_nrm_prop_11
	la var pres_opp_prop_11 "Parish vote share for opposition parties, 2011"
	
	replace selection_notrandom_e = 1 if (attrselectreason_e==97 | missing(attrselectreason_e)) & e2==1
	replace selection_random_e = 0 if selection_notrandom_e==1
	
	* Econ index for IV regression
	foreach v in profits4w_real_p99_e wealthindex_e consumption_real_p99_z_e {
		qui sum `v' if e2==1, d
		gen X_`v' = (`v'-r(mean))/r(sd) if e2==1

	}
	egen econ_std_e = rowtotal(X_*),m 
	qui sum econ_std_e if e2==1, d 
	replace econ_std_e = (econ_std_e-r(mean))/r(sd) if e2==1
	drop X_*
	la var econ_std_e "Family of income variables"
	
	foreach v in profits4w_real_p99_e wealthindex_e consumption_real_p99_z_e {
		qui sum `v' if e1==1, d
		gen X_`v' = (`v'-r(mean))/r(sd) if e1==1

	}
	egen econ_std_e1 = rowtotal(X_*),m 
	qui sum econ_std_e1 if e1==1, d 
	replace econ_std_e1 = (econ_std_e1-r(mean))/r(sd) if e1==1
	drop X_*
	
	replace econ_std_e = econ_std_e1 if e1==1
	drop econ_std_e1
	
	* New pooled political action index
	foreach v in epavoteredu2011el_dum_e epadiscussvote2011el_dum_e epareportinc2011el_dum_e vote2011elprez_e pparally2011el_resc_e ppaprimary2011el_resc_e partyworked_resc_e ppapartymember_e {
		qui sum `v' if e2==1, d
		gen X_`v' = (`v'-r(mean))/r(sd) if e2==1

	}
	egen pol_std_e = rowtotal(X_*),m 
	qui sum pol_std_e if e2==1, d 
	replace pol_std_e = (pol_std_e-r(mean))/r(sd) if e2==1
	drop X_*
	la var pol_std_e "Index of general election political action"
	
	* NUSAF questions
	
	qui gen nusaf_you_e = .
		replace nusaf_you_e=-2 if q269_e==4
		replace nusaf_you_e=-1 if q269_e==3
		replace nusaf_you_e=0 if q269_e==5
		replace nusaf_you_e=1 if q269_e==2
		replace nusaf_you_e=2 if q269_e==1
	la var nusaf_you_e "Effect of NUSAF on you (-2 to +2, +2 =most positive)"
	
	qui gen nusaf_cmty_e = .
		replace nusaf_cmty_e=-2 if q270_e==4
		replace nusaf_cmty_e=-1 if q270_e==3
		replace nusaf_cmty_e=0 if q270_e==5
		replace nusaf_cmty_e=1 if q270_e==2
		replace nusaf_cmty_e=2 if q270_e==1
	la var nusaf_cmty_e "Effect of NUSAF on community (-2 to +2, +2 =most positive)"
	
	qui gen nusaf_north_e = .
		replace nusaf_north_e=-2 if q271_e==4
		replace nusaf_north_e=-1 if q271_e==3
		replace nusaf_north_e=0 if q271_e==5
		replace nusaf_north_e=1 if q271_e==2
		replace nusaf_north_e=2 if q271_e==1
	la var nusaf_north_e "Effect of NUSAF on north (-2 to +2, +2 =most positive)"
	
	* Add in YOP2 responses to YOP4
	foreach g in you cmty north { 
		egen mean_nusaf_`g'_e = mean(nusaf_`g'_e), by(partid)
		replace nusaf_`g'_e = mean_nusaf_`g'_e
		drop mean_nusaf_`g'_e
	}
	
	* Add all attribution options
	foreach g in incum devn donor sign reward nomotive noop pol { 
		gen yopreason_`g' = 0
	}
	replace yopreason_incum = 1 if attrinterpretation1_e ==1
	replace yopreason_devn = 1 if attrinterpretation1_e ==2
	replace yopreason_donor = 1 if attrinterpretation1_e ==3
	replace yopreason_sign = 1 if attrinterpretation1_e ==4
	replace yopreason_reward = 1 if attrinterpretation1_e ==5
	replace yopreason_nomotive = 1 if attrinterpretation1_e ==6
	replace yopreason_noop = 1 if attrinterpretation1_e ==7
	replace yopreason_pol = 1 if inlist(attrinterpretation1_e,1,3,5)
	
		forv i = 1/4 { 
			replace yopreason_incum = 1 if attrinterpretation2_`i'_e =="1-To increase incumbent suppo"
			replace yopreason_devn = 1 if attrinterpretation2_`i'_e =="2-To develop and help the north"
			replace yopreason_donor = 1 if attrinterpretation2_`i'_e =="3-To make donors happy"
			replace yopreason_sign = 1 if attrinterpretation2_`i'_e =="4-Signal a future supp. increase"
			replace yopreason_reward = 1 if attrinterpretation2_`i'_e =="5-To reward friends and allies"
			replace yopreason_nomotive = 1 if attrinterpretation2_`i'_e =="6-No motive"
			replace yopreason_noop = 1 if attrinterpretation2_`i'_e =="7-No opinion"
			replace yopreason_pol = 1 if attrinterpretation2_`i'_e =="1-To increase incumbent suppo" |  ///
										 attrinterpretation2_`i'_e =="3-To make donors happy" |  		///
										 attrinterpretation2_`i'_e =="5-To reward friends and allies" 
		}
	
	* Outcomes for heterogeneit of lc5 results by incumbent party 
	
	gen  vote2011ellcvinccomb_dum_opp_e =  vote2011ellcvinccomb_dum_e 
	replace vote2011ellcvinccomb_dum_opp_e   = . if   win_nrm==1

	gen  vote2011ellcvinccomb_dum_nrm_e =  vote2011ellcvinccomb_dum_e 
	replace vote2011ellcvinccomb_dum_nrm_e   = . if   win_opp==1
	
	
********************************************************************************
* Label Variables so that tables are more clear ********************************
********************************************************************************
	
	label var vote2011ellcvinccomb_dum_nrm_e "Races where incumbent was from ruling party"
	label var vote2011ellcvinccomb_dum_opp_e "Races where incumbent was from opposition"



********************************************************************************
* Save it to be used by the politics analysis code *****************************
********************************************************************************
save "$NUSAF/data/yop_political_analysis.dta", replace 




********************************************************************************
* Move our working directory back to where the master do-file is located *******
********************************************************************************
/* 	This allows us to continue on with the next steps in the master do file.
*/ 
cd $NUSAF

******************************************************************************** 				
	
