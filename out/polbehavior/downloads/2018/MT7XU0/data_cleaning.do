/* 
LEFT-RIGHT CATEGORIZATION AND PERCEPTIONS OF PARTY IDEOLOGIES
by Federico Vegetti and Daniela Sirinic
Political Behavior, 2018

This syntax is used to clean the ESS data and merge it with the Chapel Hill data,
to be used for the actual analyses in R
*/

clear*
set memory 500m
set more off

* Set the working directory to the one where you keep the data
cd "***DIRECTORY PATH***"

/*
The data of the 2009 wave of the European Election Study can be downloaded from here:
https://dbk.gesis.org/dbksearch/sdesc2.asp?no=5055&db=e&doi=10.4232/1.12732
We use here the version saved for Stata 12
*/
use "ZA5055_v1-1-1_stata12.dta"

****************************************************************************************************************************************************
/// COUNTRY + POLITICAL SYSTEM ///	
****************************************************************************************************************************************************
	
* gen country with number in the label and replace with new variable
	gen country = t102

* Gen political system with number in the label and replace with new variable
	gen system = t103
	replace system = 27 if t103 == 28
	replace system = system + 1
	
* gen a political system variable for the labels
	gen str syslab = ""
	replace syslab = "BE-W" if system == 1
	replace syslab = "BE-F" if system == 2
	replace syslab = "CZ" if system == 3
	replace syslab = "DK" if system == 4
	replace syslab = "DE" if system == 5
	replace syslab = "EE" if system == 6
	replace syslab = "GR" if system == 7
	replace syslab = "ES" if system == 8
	replace syslab = "FR" if system == 9
	replace syslab = "IE" if system == 10
	replace syslab = "IT" if system == 11
	replace syslab = "CY" if system == 12
	replace syslab = "LV" if system == 13
	replace syslab = "LT" if system == 14
	replace syslab = "LU" if system == 15
	replace syslab = "HU" if system == 16
	replace syslab = "MT" if system == 17
	replace syslab = "NL" if system == 18
	replace syslab = "AT" if system == 19
	replace syslab = "PL" if system == 20
	replace syslab = "PT" if system == 21
	replace syslab = "SI" if system == 22
	replace syslab = "SK" if system == 23
	replace syslab = "FI" if system == 24
	replace syslab = "SE" if system == 25
	replace syslab = "UK" if system == 26
	replace syslab = "BG" if system == 27
	replace syslab = "RO" if system == 28

****************************************************************************************************************************************************
/// VARIABILES OF INTEREST ///
****************************************************************************************************************************************************

* Left-right self placement
	gen lrsp = .
	replace lrsp = q46 if q46 < 11 & q46 >= 0
	
* Centered around 5
	gen lrsp_cent = lrsp - 5
	
* Group-level standardized
	bysort syslab: egen mlrsp = mean(lrsp)
	bysort syslab: egen sdlrsp = sd(lrsp)
	gen lrsp_gsd = (lrsp - mlrsp) / sdlrsp
	drop mlrsp sdlrsp

* Left-right extremity (for other purposes)
	gen lrext = abs(lrsp_cent)
	bysort syslab: egen mlrext = median(lrext)
	gen lrext_cen = lrext - mlrext
	drop mlrext
	
* Variable about the side of the respondent
	gen left = .
	replace left = 1 if lrsp < 5 & lrsp != .
	replace left = 0 if lrsp >= 5 & lrsp != .
	gen right = .
	replace right = 1 if lrsp > 5 & lrsp != .
	replace right = 0 if lrsp <= 5 & lrsp != .
	gen center = .
	replace center = 1 if lrsp == 5 
	replace center = 0 if lrsp < 5 & lrsp != . | lrsp > 5 & lrsp != .
	
* Issue placement
	local i = 1
	foreach n of numlist 56/67 {
	qui gen iss`i' = q`n'
	qui replace iss`i' = . if q`n' > 5
	local i = `i' + 1
	}
	gen i2ImmCus = (iss1 * -1) + 6
	gen i1PriEnt = (iss2 * -1) + 6
	gen i3SamSex = (iss3 * -1) + 6
	gen i1StaOwn = iss4
	gen i3AboFree = iss5
	gen i1IntEco = (iss6 * -1) + 6
	gen i3HarSen = (iss7 * -1) + 6
	gen i1OrdRed = iss8
	gen i3ObeAut = (iss9 * -1) + 6
	gen i3WorCut = (iss11 * -1) + 6
	gen i2ImmDec = (iss12 * -1) + 6
	
	drop iss1 - iss12

* Squared term unstandardized issues
	local issues i2ImmCus i1PriEnt i3SamSex i1StaOwn i3AboFree i1IntEco i3HarSen i1OrdRed i3ObeAut i3WorCut i2ImmDec
	foreach i in `issues' {
	gen `i'_sq = (`i')^2
	}
	
* Group-standardize them all
	local issues i2ImmCus i1PriEnt i3SamSex i1StaOwn i3AboFree i1IntEco i3HarSen i1OrdRed i3ObeAut i3WorCut i2ImmDec
	foreach i in `issues' {
	bysort syslab: egen m`i' = mean(`i')
	bysort syslab: egen sd`i' = sd(`i')
	gen `i'_gsd = (`i' - m`i') / sd`i'
	drop m`i' sd`i'
	}

* Squared term standardized issues
	local issues i2ImmCus_gsd i1PriEnt_gsd i3SamSex_gsd i1StaOwn_gsd i3AboFree_gsd i1IntEco_gsd i3HarSen_gsd i1OrdRed_gsd i3ObeAut_gsd i3WorCut_gsd i2ImmDec_gsd
	foreach i in `issues' {
	gen `i'_sq = (`i')^2
	}

****************************************************************************************************************************************************
/// PARTISANSHIP ///
****************************************************************************************************************************************************
	
* pid (close to a party)
	gen pid = .
	replace pid = 1 if q87 == 1040320 | q87 == 1056521 | q87 == 1100300 					///
	| q87 == 1196321 | q87 == 1203320 | q87 == 1276521 | q87 == 1208320 | q87 == 1233430 	///
	| q87 == 1300511 | q87 == 1724610 | q87 == 1246320 | q87 == 1250226 | q87 == 1348421 	///
	| q87 == 1372620 | q87 == 1380630 | q87 == 1440620 | q87 == 1442113 | q87 == 1428610 	///
	| q87 == 1470500 | q87 == 1528320 | q87 == 1620211 | q87 == 1642400 | q87 == 1752220 	///
	| q87 == 1705951 | q87 == 1703711 | q87 == 1826320 | q87 == 1056522
	replace pid = 2 if q87 == 1040520 | q87 == 1056421 | q87 == 1100400 					///
	| q87 == 1196711 | q87 == 1203523 | q87 == 1276320 | q87 == 1208410 | q87 == 1233411 	///
	| q87 == 1300313 | q87 == 1724320 | q87 == 1246810 | q87 == 1250220 | q87 == 1348700 	///
	| q87 == 1372520 | q87 == 1380720 | q87 == 1440320 | q87 == 1442320 | q87 == 1428110 	///
	| q87 == 1470300 | q87 == 1528521 | q87 == 1616811 | q87 == 1620314 | q87 == 1642300 	///
	| q87 == 1752320 | q87 == 1705421 | q87 == 1703423 | q87 == 1826620 |q87 == 1056427
	replace pid = 3 if q87 == 1040720 | q87 == 1056327 | q87 == 1100900 					///
	| q87 == 1196422 | q87 == 1203220 | q87 == 1276113 | q87 == 1208620 | q87 == 1233613 	///
	| q87 == 1300210 | q87 == 1724220 | q87 == 1246620 | q87 == 1250320 | q87 == 1372110 	///
	| q87 == 1380331 | q87 == 1440001 | q87 == 1442420 | q87 == 1428423 | q87 == 1470100 	///
	| q87 == 1528420 | q87 == 1620229 | q87 == 1642401 | q87 == 1752810 | q87 == 1705521 	///
	| q87 == 1703523 | q87 == 1826421 | q87 == 1056322
	replace pid = 4 if q87 == 1040700 | q87 == 1056711 | q87 == 1100700 					///
	| q87 == 1196322 | q87 == 1203413 | q87 == 1276321 | q87 == 1208230 | q87 == 1233410 	///
	| q87 == 1300215 | q87 == 1246223 | q87 == 1250110 | q87 == 1348210 | q87 == 1372320 	///
	| q87 == 1380902 | q87 == 1440621 | q87 == 1442520 | q87 == 1428317 | q87 == 1470700 	///
	| q87 == 1528330 | q87 == 1620311 | q87 == 1642900 | q87 == 1752420 | q87 == 1705710 	///
	| q87 == 1703954 | q87 == 1826902 |q87 == 1056710
	replace pid = 5 if q87 == 1040110 | q87 == 1056112 | q87 == 1100600 					///
	| q87 == 1196600 | q87 == 1203110 | q87 == 1276420 | q87 == 1208720 | q87 == 1233100 	///
	| q87 == 1300703 | q87 == 1724010 | q87 == 1246110 | q87 == 1250336 | q87 == 1372951 	///
	| q87 == 1380523 | q87 == 1440421 | q87 == 1442951 | q87 == 1428424 | q87 == 1528110 	///
	| q87 == 1616010 | q87 == 1620313 | q87 == 1642600 | q87 == 1752620 | q87 == 1705320 	///
	| q87 == 1703521 | q87 == 1826901 | q87 == 1056111
	replace pid = 6 if q87 == 1040951 | q87 == 1056913 | q87 == 1100001 					///
	| q87 == 1196110 | q87 == 1208420 | q87 == 1233612 | q87 == 1300116 | q87 == 1724007 	///
	| q87 == 1246901 | q87 == 1250626 | q87 == 1348521 | q87 == 1372001 | q87 == 1380221 	///
	| q87 == 1440322 | q87 == 1442222 | q87 == 1428723 | q87 == 1528006 | q87 == 1616011 	///
	| q87 == 1642800 | q87 == 1752520 | q87 == 1705323 | q87 == 1703710 | q87 == 1826951 
	replace pid = 7 if q87 == 1040422 | q87 == 1056600 | q87 == 1100002 					///
	| q87 == 1208421 | q87 == 1724905 | q87 == 1246520 | q87 == 1250720 | q87 == 1348220 	///
	| q87 == 1380212 | q87 == 1440420 | q87 == 1442220 | q87 == 1428422 | q87 == 1528526 	///
	| q87 == 1616210 | q87 == 1642700 | q87 == 1752110 | q87 == 1705324 | q87 == 1703222 	///
	| q87 == 1826720
	replace pid = 8 if q87 == 1040220 | q87 == 1056328 | q87 == 1100601 					///
	| q87 == 1208955 | q87 == 1724902 | q87 == 1246820 | q87 == 1250337 | q87 == 1348422 	///
	| q87 == 1380631 | q87 == 1440952 | q87 == 1442009 | q87 == 1428611 | q87 == 1528527 	///
	| q87 == 1752700 | q87 == 1705522 | q87 == 1703524 | q87 == 1826110
	replace pid = 9 if q87 == 1056222 | q87 == 1208954 | q87 == 1348526 					///
	| q87 == 1440824 | q87 == 1428425 | q87 == 1528220 | q87 == 1616435 | q87 == 1752000 	///
	| q87 == 1705952
	replace pid = 10 if q87 == 1724908 | q87 == 1440410 									///
	| q87 == 1528600 | q87 == 1616436
	replace pid = 11 if q87 == 1528726
	replace pid = 12 if q87 == 1724907
	replace pid = 13 if q87 == 1724923
	replace pid = 14 if q87 == 1724990
	replace pid = 15 if q87 == 1724992	
	
	gen close_party = pid

* pid_rep (not close, but closer to a party than the others)
	gen pid_rep = .
	replace pid_rep = 1 if q90 == 1040320 | q90 == 1056521 | q90 == 1100300 				///
	| q90 == 1196321 | q90 == 1203320 | q90 == 1276521 | q90 == 1208320 | q90 == 1233430 	///
	| q90 == 1300511 | q90 == 1724610 | q90 == 1246320 | q90 == 1250226 | q90 == 1348421 	///
	| q90 == 1372620 | q90 == 1380630 | q90 == 1440620 | q90 == 1442113 | q90 == 1428610 	///
	| q90 == 1470500 | q90 == 1528320 | q90 == 1620211 | q90 == 1642400 | q90 == 1752220 	///
	| q90 == 1705951 | q90 == 1703711 | q90 == 1826320 | q90 == 1056522
	replace pid_rep = 2 if q90 == 1040520 | q90 == 1056421 | q90 == 1100400 				///
	| q90 == 1196711 | q90 == 1203523 | q90 == 1276320 | q90 == 1208410 | q90 == 1233411 	///
	| q90 == 1300313 | q90 == 1724320 | q90 == 1246810 | q90 == 1250220 | q90 == 1348700 	///
	| q90 == 1372520 | q90 == 1380720 | q90 == 1440320 | q90 == 1442320 | q90 == 1428110 	///
	| q90 == 1470300 | q90 == 1528521 | q90 == 1616811 | q90 == 1620314 | q90 == 1642300 	///
	| q90 == 1752320 | q90 == 1705421 | q90 == 1703423 | q90 == 1826620 |q90 == 1056427
	replace pid_rep = 3 if q90 == 1040720 | q90 == 1056327 | q90 == 1100900 				///
	| q90 == 1196422 | q90 == 1203220 | q90 == 1276113 | q90 == 1208620 | q90 == 1233613 	///
	| q90 == 1300210 | q90 == 1724220 | q90 == 1246620 | q90 == 1250320 | q90 == 1372110 	///
	| q90 == 1380331 | q90 == 1440001 | q90 == 1442420 | q90 == 1428423 | q90 == 1470100 	///
	| q90 == 1528420 | q90 == 1620229 | q90 == 1642401 | q90 == 1752810 | q90 == 1705521 	///
	| q90 == 1703523 | q90 == 1826421 | q90 == 1056322
	replace pid_rep = 4 if q90 == 1040700 | q90 == 1056711 | q90 == 1100700 				///
	| q90 == 1196322 | q90 == 1203413 | q90 == 1276321 | q90 == 1208230 | q90 == 1233410 	///
	| q90 == 1300215 | q90 == 1246223 | q90 == 1250110 | q90 == 1348210 | q90 == 1372320 	///
	| q90 == 1380902 | q90 == 1440621 | q90 == 1442520 | q90 == 1428317 | q90 == 1470700 	///
	| q90 == 1528330 | q90 == 1620311 | q90 == 1642900 | q90 == 1752420 | q90 == 1705710 	///
	| q90 == 1703954 | q90 == 1826902 |q90 == 1056710
	replace pid_rep = 5 if q90 == 1040110 | q90 == 1056112 | q90 == 1100600 				///
	| q90 == 1196600 | q90 == 1203110 | q90 == 1276420 | q90 == 1208720 | q90 == 1233100 	///
	| q90 == 1300703 | q90 == 1724010 | q90 == 1246110 | q90 == 1250336 | q90 == 1372951 	///
	| q90 == 1380523 | q90 == 1440421 | q90 == 1442951 | q90 == 1428424 | q90 == 1528110 	///
	| q90 == 1616010 | q90 == 1620313 | q90 == 1642600 | q90 == 1752620 | q90 == 1705320 	///
	| q90 == 1703521 | q90 == 1826901 | q90 == 1056111
	replace pid_rep = 6 if q90 == 1040951 | q90 == 1056913 | q90 == 1100001 				///
	| q90 == 1196110 | q90 == 1208420 | q90 == 1233612 | q90 == 1300116 | q90 == 1724007 	///
	| q90 == 1246901 | q90 == 1250626 | q90 == 1348521 | q90 == 1372001 | q90 == 1380221 	///
	| q90 == 1440322 | q90 == 1442222 | q90 == 1428723 | q90 == 1528006 | q90 == 1616011 	///
	| q90 == 1642800 | q90 == 1752520 | q90 == 1705323 | q90 == 1703710 | q90 == 1826951 
	replace pid_rep = 7 if q90 == 1040422 | q90 == 1056600 | q90 == 1100002 				///
	| q90 == 1208421 | q90 == 1724905 | q90 == 1246520 | q90 == 1250720 | q90 == 1348220 	///
	| q90 == 1380212 | q90 == 1440420 | q90 == 1442220 | q90 == 1428422 | q90 == 1528526 	///
	| q90 == 1616210 | q90 == 1642700 | q90 == 1752110 | q90 == 1705324 | q90 == 1703222 	///
	| q90 == 1826720
	replace pid_rep = 8 if q90 == 1040220 | q90 == 1056328 | q90 == 1100601 				///
	| q90 == 1208955 | q90 == 1724902 | q90 == 1246820 | q90 == 1250337 | q90 == 1348422 	///
	| q90 == 1380631 | q90 == 1440952 | q90 == 1442009 | q90 == 1428611 | q90 == 1528527 	///
	| q90 == 1752700 | q90 == 1705522 | q90 == 1703524 | q90 == 1826110
	replace pid_rep = 9 if q90 == 1056222 | q90 == 1208954 | q90 == 1348526 				///
	| q90 == 1440824 | q90 == 1428425 | q90 == 1528220 | q90 == 1616435 | q90 == 1752000 	///
	| q90 == 1705952
	replace pid_rep = 10 if q90 == 1724908 | q90 == 1440410 								///
	| q90 == 1528600 | q90 == 1616436
	replace pid_rep = 11 if q90 == 1528726
	replace pid_rep = 12 if q90 == 1724907
	replace pid_rep = 13 if q90 == 1724923
	replace pid_rep = 14 if q90 == 1724990
	replace pid_rep = 15 if q90 == 1724992	
	
* put them together
	gen close_party_full = .
	foreach n of numlist 1/15 {
	replace close_party_full = `n' if pid == `n' | pid_rep == `n'
	}
	* drop the other two
	drop pid pid_rep
	
* strength of party id
	gen close_int = .
	replace close_int = (v301 / 4) if v301 < 7

* either close or not
	gen close_dummy = 1
	replace close_dummy = 0 if q87 == 0
	replace close_dummy = . if q87 == 77 | q87 == 88 | q87 == 99
	gen close_dummy_full = 1
	replace close_dummy_full = 0 if q87 == 0 & q89 == 2 | q87 == 0 & q89 == 7 | q87 == 0 & q89 == 8 | q87 == 77 & q89 == 2| q87 == 88 & q89 == 2
	replace close_dummy_full = . if q87 == 77 & q89 == 7 | q87 == 88 & q89 == 8 | q87 == 77 & q89 == 8 | q87 == 88 & q89 == 7 

* integrate non-partisans (category 0) in the close_party variables
	gen close_party_np = close_party
	replace close_party_np = 0 if close_dummy == 0
	gen close_party_full_np = close_party_full
	replace close_party_full_np = 0 if close_dummy_full == 0
	
* Create dummies
	foreach n of numlist 1/15{
	gen close_`n' = .
	replace close_`n' = 1 if close_party_full_np == `n'
	replace close_`n' = 0 if close_party_full_np != `n' & close_party_full_np != .
	}

* Generate party ID with strength variables
	foreach n of numlist 1/15 {
	qui gen close_str_`n' = .
	qui replace close_str_`n' = close_`n'*close_int
	}
	

****************************************************************************************************************************************************
/// LEFT-RIGHT PARTY PLACEMENTS ///	
****************************************************************************************************************************************************
	
* l-r parties placement
	foreach n of numlist 1/15 {
	qui gen lrp`n' = .
	qui replace lrp`n' = q47_p`n' if q47_p`n' < 11 & q47_p`n' >= 0
	}
	
* Dummy to identify those who place all parties in the same position
	egen sd_parties = rowsd(lrp*)
	gen all_same_lrp = .
	replace all_same_lrp = 0 if sd_parties > 0
	replace all_same_lrp = 1 if sd_parties == 0
	drop sd_parties
	
* Chapel Hill Part *************************************************************
/*
The mean experts placements are saved in a separate file called "ch_pos.dta"
These are the mean party left-right positions across the experts in each country
The original data are available here: https://www.chesdata.eu/s/2010_CHES_dataset_means.csv
However, the data used here (included in the Dataverse) have been compiled by hand to harmonize the party IDs with the EES data
*/
	merge m:1 syslab using "ch_pos.dta"
	drop _merge
	gen l_r_ch_11 = .
	gen l_r_ch_13 = .
	foreach n of numlist 1/14{
	qui gen l_r_ch`n' = l_r_ch_`n'
	qui drop l_r_ch_`n'
	}
* Compute party polarization
/*
Use party vote shares at the 2009 European Election, saved in a separate file called "votesharesees2009.dta"
Party vote shares have been obtained from the EES 2009 contextual dataset, Parlgov and Wikipedia
The data used here (included in the Dataverse) have been compiled by hand
*/
	merge m:1 t103 using "votesharesees2009.dta"
	drop _merge
	egen totshare_n = rowtotal(sharel1 - sharel14)
	foreach n of numlist 1/14{
	qui gen weshare`n' = sharel`n'/ totshare_n
	}
	drop sharel* totshare totshare_n
	* generate for every country the "CENTER" (the weighted mean of the relevant parties' positions)
	foreach n of numlist 1/14 {
	qui gen wepos`n' = l_r_ch`n' * weshare`n'
	}
	egen wemeanpos = rowtotal(wepos*)
	drop wepos*
	* generate parties' extremity in respect of the weighted mean
	foreach n of numlist 1/14 {
	qui gen wepextr`n' = abs(l_r_ch`n' - wemeanpos)
	}	
	* multiply every party's extremity for the size
	foreach n of numlist 1/14 {
	qui gen temp`n' = wepextr`n' * weshare`n'
	}	
	* sum them up
	egen ch_polar = rowtotal(temp*)
	drop wepextr*
	drop temp*
	drop wemeanpos
	drop weshare*

***************************************************************************************************************************************************************	
/// SOCIO STRUCTURE & CONTROLS ///
****************************************************************************************************************************************************

* political interest
	gen polint = 0
	replace polint = 1 if q78 == 3
	replace polint = 2 if q78 == 2
	replace polint = 3 if q78 == 1
	replace polint = . if q78 == 7 | q78 == 8
* group standardize
	bysort syslab: egen mint = mean(polint)
	bysort syslab: egen sdint = sd(polint)
	gen polint_gsd = (polint - mint) / sdint
	gen polint_cen = (polint - mint)
	drop mint sdint
	
* political knowledge
	gen info1 = (q92 == 2)
	replace info1 = . if q92 == 7
	
	gen info2 = (q93 == 2)
	replace info2 = . if q93 == 7
	
	gen info3 = (q94 == 2)
	replace info3 = . if q94 == 7
	
	gen info4 = (q95 == 1)
	replace info4 = . if q95 == 7
	
	gen info5 = (q96 == 1)
	replace info5 = . if q96 == 7
	
	gen info6 = 0
	replace info6 = 1 if q97 == 1 & t102 == 1196 | q97 == 1 & t102 == 1300 | q97 == 1 & t102 == 1380 | q97 == 1 & t102 == 1440
	replace info6 = 1 if q97 == 2 & t102 != 1196 & t102 != 1300 & t102 != 1380 & t102 != 1440
	replace info6 = . if q97 == 7
	
	gen info7 = (q98 == 2)
	replace info7 = . if q98 == 7
	
	egen polinfo = rowtotal(info1 - info7), missing
	drop info1 - info7
* group standardize
	bysort syslab: egen minfo = mean(polinfo)
	bysort syslab: egen sdinfo = sd(polinfo)
	gen polinfo_gsd = (polinfo - minfo) / sdinfo
	gen polinfo_cen = (polinfo - minfo)
	drop minfo sdinfo
	
* education (categorical)
	gen educ = .
	replace educ = 0 if v200 >= 0 & v200 <= 2
	replace educ = 1 if v200 > 2 & v200 <= 4
	replace educ = 2 if v200 > 4 & v200 <= 6
* create dummies
	gen edlow = .
	replace edlow = 1 if educ == 0
	replace edlow = 0 if educ == 1 | educ == 2
	gen edhigh = .
	replace edhigh = 1 if educ == 2
	replace edhigh = 0 if educ == 0 | educ == 1

* gender (female)
	gen female = 0
	replace female = 1 if q102 == 2
	replace female = . if q102 == 7

* age
	gen age =  .
	replace age = 2009 - q103 if q103 != 7777
	egen agemed = median(age)
	replace age = age - agemed
	drop agemed
* group standardize
	bysort syslab: egen mage = mean(age)
	bysort syslab: egen sdage = sd(age)
	gen age_gsd = (age - mage) / sdage
	drop mage sdage

* subjective social class
	gen class = .
	replace class = (q114 - 3) if q114 < 6
	
* class in dummies
	tabulate class, gen(clasd)
	
* subjective standard of living
	gen standard = .
	replace standard = (q120 - 4) if q120 < 8
* squared term unstandardized
	gen standard_sq = standard^2
* group standardize
	bysort syslab: egen mstandard = mean(standard)
	bysort syslab: egen sdstandard = sd(standard)
	gen standard_gsd = (standard - mstandard) / sdstandard
	drop mstandard sdstandard
* squared term standardized
	gen standard_gsd_sq = standard_gsd^2

* subjective religiosity
	gen relig = .
	replace relig = (q119 - 5) if q119 < 11
* squared term unstandardized
	gen relig_sq = relig^2
* group standardize
	bysort syslab: egen mrelig = mean(relig)
	bysort syslab: egen sdrelig = sd(relig)
	gen relig_gsd = (relig - mrelig) / sdrelig
	drop mrelig sdrelig
* squared term standardized
	gen relig_gsd_sq = relig_gsd^2
	
* church attendance
	gen churchat = .
	replace churchat = (q118 - 4) * -1 if q118 < 7
	replace churchat = 2 if churchat == 3
* squared term unstandardized
	gen churchat_sq = churchat^2
* group standardize
	bysort syslab: egen mchurch = mean(churchat)
	bysort syslab: egen sdchurch = sd(churchat)
	gen churchat_gsd = (churchat - mchurch) / sdchurch
	drop mchurch sdchurch
* squared term standardized
	gen churchat_gsd_sq = churchat_gsd^2

****************************************************************************************************************************************************
/// DROP THE OTHER VARIABLES ///
	drop t001 - doi
	
/// DROP THE COUNTRIES WHERE WE DON'T HAVE CHAPEL HILL DATA
	drop if syslab == "CY" | syslab == "LU" | syslab == "MT" 
	* Latvia only has 3 parties in common between the EES 2009 and the CH 2010, so it will be dropped as well
	drop if syslab == "LV"
		
sort system
* Save the data (to be used for the calculation of relative importance of the left-right components)
saveold "EES_2009_unstacked.dta", replace version(11)

****************************************************************************************************************************************************
/// STACK THE DATA FOR ANALYSES OF DISTANCE ///
****************************************************************************************************************************************************
* Distances between respondent and party 
* Perceived distances (respondent's own perceptions)
foreach n of numlist 1/14 {
qui gen dist_p`n' = abs(lrsp - lrp`n')
}
* Objective distances: Chapel Hill positions
foreach n of numlist 1/14 {
qui gen dist_ch`n' = abs(lrsp - l_r_ch`n')
}
* For each party, see whether it is left (1), right (2) or center (3)
* Chapel Hill positions
foreach n of numlist 1/14 {
qui gen lrg_ch`n' = .
qui replace lrg_ch`n' = 1 if l_r_ch`n' < 5 & l_r_ch`n' != .
qui replace lrg_ch`n' = 2 if l_r_ch`n' > 5 & l_r_ch`n' != .
qui replace lrg_ch`n' = 3 if l_r_ch`n' == 5
}
* Individually perceived position
foreach n of numlist 1/14 {
qui gen lrg_p`n' = .
qui replace lrg_p`n' = 1 if lrp`n' < 5 & lrp`n' != .
qui replace lrg_p`n' = 2 if lrp`n' > 5 & lrp`n' != .
qui replace lrg_p`n' = 3 if lrp`n' == 5
}

* Same side (Chapel Hill positions)
foreach n of numlist 1/14 {
qui gen sameside_ch`n' = .
qui replace sameside_ch`n' = 1 if left == 1 & lrg_ch`n' == 1
qui replace sameside_ch`n' = 1 if right == 1 & lrg_ch`n' == 2
qui replace sameside_ch`n' = 0 if left == 1 & lrg_ch`n' == 2
qui replace sameside_ch`n' = 0 if right == 1 & lrg_ch`n' == 1
qui replace sameside_ch`n' = 0 if lrg_ch`n' == 3 | lrsp == 5 
}
* Same side (Individually perceived positions)
foreach n of numlist 1/14 {
qui gen sameside_p`n' = .
qui replace sameside_p`n' = 1 if left == 1 & lrg_p`n' == 1
qui replace sameside_p`n' = 1 if right == 1 & lrg_p`n' == 2
qui replace sameside_p`n' = 0 if left == 1 & lrg_p`n' == 2
qui replace sameside_p`n' = 0 if right == 1 & lrg_p`n' == 1
qui replace sameside_p`n' = 0 if lrg_p`n' == 3 | lrsp == 5 
}
* Other side (Chapel Hill positions)
foreach n of numlist 1/14 {
qui gen otherside_ch`n' = .
qui replace otherside_ch`n' = 0 if left == 1 & lrg_ch`n' == 1
qui replace otherside_ch`n' = 0 if right == 1 & lrg_ch`n' == 2
qui replace otherside_ch`n' = 1 if left == 1 & lrg_ch`n' == 2
qui replace otherside_ch`n' = 1 if right == 1 & lrg_ch`n' == 1
qui replace otherside_ch`n' = 0 if lrg_ch`n' == 3 | lrsp == 5 
}
* Other side (Individually perceived positions)
foreach n of numlist 1/14 {
qui gen otherside_p`n' = .
qui replace otherside_p`n' = 0 if left == 1 & lrg_p`n' == 1
qui replace otherside_p`n' = 0 if right == 1 & lrg_p`n' == 2
qui replace otherside_p`n' = 1 if left == 1 & lrg_p`n' == 2
qui replace otherside_p`n' = 1 if right == 1 & lrg_p`n' == 1
qui replace otherside_p`n' = 0 if lrg_p`n' == 3 | lrsp == 5 
}
* Position party correctly according to ChapelHill (including center)
foreach n of numlist 1/14 {
qui gen correct_p`n' = .
qui replace correct_p`n' = 1 if lrg_p`n' == 1 & lrg_ch`n' == 1
qui replace correct_p`n' = 1 if lrg_p`n' == 3 & lrg_ch`n' == 3
qui replace correct_p`n' = 1 if lrg_p`n' == 2 & lrg_ch`n' == 2
qui replace correct_p`n' = 0 if lrg_p`n' == 1 & lrg_ch`n' == 2
qui replace correct_p`n' = 0 if lrg_p`n' == 2 & lrg_ch`n' == 1
qui replace correct_p`n' = 0 if lrg_p`n' == . & lrg_ch`n' == 1
qui replace correct_p`n' = 0 if lrg_p`n' == . & lrg_ch`n' == 2
qui replace correct_p`n' = 0 if lrg_p`n' == . & lrg_ch`n' == 3
qui replace correct_p`n' = 0.5 if lrg_p`n' == 1 & lrg_ch`n' == 3
qui replace correct_p`n' = 0.5 if lrg_p`n' == 2 & lrg_ch`n' == 3
qui replace correct_p`n' = 0.5 if lrg_p`n' == 3 & lrg_ch`n' == 1
qui replace correct_p`n' = 0.5 if lrg_p`n' == 3 & lrg_ch`n' == 2
}
* Position party correctly according to ChapelHill (excluding center)
foreach n of numlist 1/14 {
qui gen correct_p_nc`n' = .
qui replace correct_p_nc`n' = 1 if lrg_p`n' == 1 & lrg_ch`n' == 1
qui replace correct_p_nc`n' = 1 if lrg_p`n' == 3 & lrg_ch`n' == 3
qui replace correct_p_nc`n' = 1 if lrg_p`n' == 2 & lrg_ch`n' == 2
qui replace correct_p_nc`n' = 0 if lrg_p`n' == 1 & lrg_ch`n' == 2
qui replace correct_p_nc`n' = 0 if lrg_p`n' == 2 & lrg_ch`n' == 1
qui replace correct_p_nc`n' = 0 if lrg_p`n' == . & lrg_ch`n' == 1
qui replace correct_p_nc`n' = 0 if lrg_p`n' == . & lrg_ch`n' == 2
qui replace correct_p_nc`n' = 0 if lrg_p`n' == . & lrg_ch`n' == 3
qui replace correct_p_nc`n' = 0 if lrg_p`n' == 1 & lrg_ch`n' == 3
qui replace correct_p_nc`n' = 0 if lrg_p`n' == 2 & lrg_ch`n' == 3
qui replace correct_p_nc`n' = 0 if lrg_p`n' == 3 & lrg_ch`n' == 1
qui replace correct_p_nc`n' = 0 if lrg_p`n' == 3 & lrg_ch`n' == 2
}

* Partisanship for own party and other party (remove old ones and create new ones with new names)
drop close_1 - close_15
drop close_str_1 - close_str_15
tabulate close_party_full, gen(pid)
* In "close_party_full" there's no party 12, so dummies 12, 13 actually refer to parties 13, 14 (no party 15 in CH data)
replace pid14 = pid13
replace pid13 = pid12
replace pid12 = .
foreach n of numlist 1/14{
qui gen antipid`n' = 0
qui replace antipid`n' = 1 if pid`n' == 0
qui replace pid`n' = 0 if close_dummy_full == 0
}
drop i2ImmCus i1PriEnt i3SamSex i1StaOwn i3AboFree i1IntEco i3HarSen i1OrdRed i3ObeAut i3WorCut i2ImmDec
drop i2ImmCus_sq i1PriEnt_sq i3SamSex_sq i1StaOwn_sq i3AboFree_sq i1IntEco_sq i3HarSen_sq i1OrdRed_sq i3ObeAut_sq i3WorCut_sq i2ImmDec_sq
drop i2ImmCus_gsd i1PriEnt_gsd i3SamSex_gsd i1StaOwn_gsd i3AboFree_gsd i1IntEco_gsd i3HarSen_gsd i1OrdRed_gsd i3ObeAut_gsd i3WorCut_gsd i2ImmDec_gsd
drop i2ImmCus_gsd_sq i1PriEnt_gsd_sq i3SamSex_gsd_sq i1StaOwn_gsd_sq i3AboFree_gsd_sq i1IntEco_gsd_sq i3HarSen_gsd_sq i1OrdRed_gsd_sq i3ObeAut_gsd_sq i3WorCut_gsd_sq i2ImmDec_gsd_sq
drop class clasd* standard standard_sq standard_gsd standard_gsd_sq relig relig_sq relig_gsd relig_gsd_sq churchat churchat_sq churchat_gsd churchat_gsd_sq
drop close_party close_party_full close_party_np close_party_full_np
drop lrp15 
gen id = _n

reshape long dist_p dist_ch lrp l_r_ch lrg_ch lrg_p correct_p correct_p_nc sameside_ch otherside_ch sameside_p otherside_p pid antipid, i(id) j(stackid)
* Drop cases where distance is not available (because some respondents they did not place some parties)
drop if dist_p == .
* Create additional variables (difference)
gen dist_diff = dist_p - dist_ch
* Save
saveold "EES_2009_stacked.dta", replace version(11)
