/*
*************************************************************************************
*************************************************************************************
*************************************************************************************

nis.do


This program calculates facts about pre and post–migration wages of immigrants as a function
of the GDP per capita in their former country. 

Current version: May 7, 2017

Steps:
1.  Read in NIS.
2.  Clean NIS data. 
3.  Read in and clean MMP/LAMP data. 
4.  Compare NIS, ACS samples
5.  Baseline Analysis: Wage Gains at Migration. 
6.  Robustness
7.  Assimilation
8:  Imperfect Substitution and Barriers
9.  Selection
10. Skill Transfer and Skill Loss
11. Use NIS-provided PPP adjustments instead. 

*************************************************************************************
*************************************************************************************
*************************************************************************************

*/

	clear all
	set maxvar 20000
	set more off
	
/*

*************************************************************************************
*************************************************************************************
*************************************************************************************

Step 1.  Read in NIS data. 

*************************************************************************************
*************************************************************************************
*************************************************************************************

*/
	
*
* 1.1: Append together separate data files.
*

	use "./raw data/nis 2003_1/NIS03-ROSTER_stata/roster_adult.dta", clear
	append using "./raw data/nis 2003_1/NIS03-ROSTER_stata/roster_proxy.dta""./raw data/nis 2003_1/NIS03-ROSTER_stata/roster_spouse.dta", force
	save ./temp/roster.dta, replace
	
	use "./raw data/nis 2003_1/NIS03-CIS_stata/presamp.dta", clear
	append using "./raw data/nis 2003_1/NIS03-CIS_stata/preprox.dta"
	save ./temp/cis.dta, replace
	
	use "./raw data/nis 2003_1/NIS03-A_stata/a_adult.dta"
	append using "./raw data/nis 2003_1/NIS03-A_stata/a_proxy.dta"
	save ./temp/section_a.dta, replace
	
	use "./raw data/restricted/country_r.dta", clear
	append using "./raw data/restricted/countryspo_r.dta""./raw data/restricted/countryprox_r.dta"
	save ./temp/restricted.dta, replace
	
	use "./raw data/nis 2003_1/NIS03-B_stata/b_adult.dta", clear
	append using "./raw data/nis 2003_1/NIS03-B_stata/b_spouse.dta""./raw data/nis 2003_1/NIS03-B_stata/b_proxy.dta", force
	save ./temp/section_b.dta, replace
	
	use "./raw data/nis 2003_1/NIS03-Bppp_stata/bsampppp.dta", clear
	append using "./raw data/nis 2003_1/NIS03-Bppp_stata/bspoppp.dta""./raw data/nis 2003_1/NIS03-Bppp_stata/bproxppp.dta"
	keep pu_id b42ppp b46ppp b66ppp b70ppp
	save ./temp/section_bppp.dta, replace	
	
	use "./raw data/nis 2003_1/NIS03-C_stata/c_adult.dta", clear
	append using "./raw data/nis 2003_1/NIS03-C_stata/c_spouse.dta""./raw data/nis 2003_1/NIS03-C_stata/c_proxy.dta", force
	save ./temp/section_c.dta, replace		
	
	use "./raw data/nis 2003_1/NIS03-Cppp_stata/csampppp.dta", clear
	append using "./raw data/nis 2003_1/NIS03-Cppp_stata/cspoppp.dta""./raw data/nis 2003_1/NIS03-Cppp_stata/cproxppp.dta", force
	save ./temp/section_cppp.dta, replace
	
	use "./raw data/nis 2003_1/NIS03-J_stata/j_adult.dta", clear
	append using "./raw data/nis 2003_1/NIS03-J_stata/j_proxy.dta", force
	save ./temp/section_j.dta, replace	
	
	use "./raw data/nis 2003_1/NIS03-K_stata/k_adult.dta", clear
	append using "./raw data/nis 2003_1/NIS03-K_stata/k_spouse.dta""./raw data/nis 2003_1/NIS03-K_stata/k_proxy.dta", force
	save ./temp/section_k.dta, replace	
	
	use "./raw data/nis 2003_2/NIS-03-2-A_stata/a_ma_r2.dta", clear
	append using "./raw data/nis 2003_2/NIS-03-2-A_stata/a_cp_r2.dta", force
	rename PU_ID pu_id
	save ./temp/section_a2.dta, replace
	
	use "./raw data/nis 2003_2/NIS-03-2-BPPP_stata/bmappp.dta", clear
	append using "./raw data/nis 2003_2/NIS-03-2-BPPP_stata/bspppp.dta""./raw data/nis 2003_2/NIS-03-2-BPPP_stata/bcpppp.dta", force
	rename PU_ID pu_id
	save ./temp/section_bppp2.dta, replace
	
	use "./raw data/nis 2003_2/NIS-03-2-C_stata/c_ma_r2.dta", clear
	append using "./raw data/nis 2003_2/NIS-03-2-C_stata/c_sp_r2.dta""./raw data/nis 2003_2/NIS-03-2-C_stata/c_cp_r2.dta", force
	rename PU_ID pu_id
	save ./temp/section_c2.dta, replace

	use "./raw data/nis 2003_2/w_adult.dta", clear
	rename PU_ID pu_id
	save ./temp/weights.dta, replace
	
*
* 1.2: Combine rosters and demographic information. 
*		Replicate spousal information: in the basic data construct, responses to spousal questions are 
*		appended to those of the interviewee.  We need to separate these off to make distinct observations
*		for the spouse. 
*
	
	use ./temp/roster.dta, clear
	merge 1:1 pu_id using ./temp/section_a.dta
	keep if _merge == 3
	drop _merge
	merge 1:1 pu_id using ./temp/weights.dta
	drop _merge
	
	* Generate basic demographic information for respondents. 
	rename statemo statefips
	rename strtyr year
	rename a6 sex
	rename a7 birth_year
	rename a20 yrschl
	rename a21 yrschl_us
	rename a22 yrschl_usage
	rename a24_deg educd
	rename a25mo educcountry
	rename a964 ruralkid
	rename NISWGTSAMP1 weight
	replace weight = niswgtsamp1 if inttype == 2
	rename NISWGTSAMP12	 weight_attrition
	
	quietly destring spnum* yob* gendr* year birth_year sex, replace	
	gen age = year - birth_year if birth_year > 19
	save ./temp/rostera_resp.dta, replace
	
	* The remainder of this section replicates the information for spouses. 
	
	* We need one variable from restricted file. Merge it on. 
	merge 1:1 pu_id using ./temp/restricted.dta
	keep if _merge == 3
	drop _merge
	
	* Some households have more than one person rostered as spouse. Keep only those with exactly one.	
	gen spouseinhh = 0 
	forvalues x = 1/99 {
		quietly replace spouseinhh = spouseinhh + 1 if rel_`x' == 1 | rel_`x' == 2
	}
	keep if spouseinhh == 1
	
	* Change husband's id to wife's. Create a new interview type that means spouse (inttype = 4)
	replace pu_id = substr(pu_id,1,4)+"20"
	replace inttype = 4
	
	* Read a few variables off the general roster. 
	gen bpld = .
	forvalues x = 1/30 {
		quietly replace sex = gendr_`x' if rel_`x' == 1 | rel_`x' == 2
		quietly replace birth_year = yob_`x' if rel_`x' == 1 | rel_`x' == 2
		quietly replace bpld = a18b_`x't if rel_`x' == 1 | rel_`x' == 2
	}
	
	* Drop restricted file immediately to save confusion.
	drop countryt - coo2t	
	
	* Read the remaining variables off of spouse–specific responses. 
	replace yrschl = a54_1
	replace yrschl_us = a55_1
	replace yrschl_usage = a56_1
	replace educd = a58_1deg
	replace educcountry = a59_1mo
	replace age = year - birth_year if birth_year > 19
	replace age = . if birth_year <= 19
	drop if age < 18
	replace ruralkid = a970
	
	* Generate a spouse flag
	gen flag_spouse = 1

	* Append with respondents and save complete demographic & roster data. 
	append using ./temp/rostera_resp.dta
	replace flag_spouse = 0 if missing(flag_spouse)
	gen year_us_educ = age - yrschl_usage if yrschl_usage >= 0 & yrschl_usage <= 70
	replace year_us_educ = 3000 if yrschl_us == 0 & educcountry != 218
	save ./temp/rostera.dta, replace

*
* 1.3: Merge on administrative data on visa status. 
*

	merge 1:1 pu_id using "./temp/cis.dta"
	drop _merge
	gen visacat = 1 if visacatmo == 7
	replace visacat = 2 if visacatmo >= 1 & visacatmo <= 5
	replace visacat = 3 if visacatmo == 9 
	replace visacat = 4 if visacatmo == 11
	replace visacat = 5 if visacatmo == 13 | visacatmo == 0
	
	label define visalbl 1 `"Employment"', add
	label define visalbl 2 `"Family"', add
	label define visalbl 3 `"Diversity"', add
	label define visalbl 4 `"Refugee"', add
	label define visalbl 5 `"Other"', add
	label values visacat visalbl
	
*
* 1.4: Merge on restricted country data
*

	merge 1:1 pu_id using ./temp/restricted.dta
	keep if _merge == 3
	drop _merge
	
	replace bpld = a9at if inttype >= 1 & inttype <= 3

*
* 1.5: Merge on prior employment data. 
*		Record outcomes for most recent pre–migration job. 
*
	
	merge 1:1 pu_id using "./temp/section_b.dta", force
	keep if _merge == 3
	drop _merge
	merge 1:1 pu_id using "./temp/section_bppp.dta", force
	keep if _merge == 3
	drop _merge
	
	rename b25 labforce1
	rename b26 incwage_refyear1
	rename b27t labcountry1
	rename b29oc occ1
	rename b29in ind1
	rename b32 classwkr1
	rename b34 classwkrd1
	rename b36 hours1
	rename b37 wkswork1
	rename b38 paidwrk1
	rename b39 payment1
	rename b40 currency1
	rename b41nu currency1try2
	rename b42 incwagetemp1
	rename b42ppp incwageppptemp1
	rename b43 incwage_units1
	rename b46 incwage_weekly1
	rename b46ppp incwage_weeklyppp1
	
	rename b50 labforce2
	rename b52t labcountry2
	rename b54oc occ2
	rename b54in ind2
	rename b57 classwkr2
	rename b59 classwkrd2
	rename b61 hours2
	rename b62 wkswork2
	rename b63 paidwrk2
	rename b64 payment2
	rename b65 currency2
	rename b65anu currency2try2
	rename b66 incwagetemp2
	rename b66ppp incwageppptemp2
	rename b67 incwage_units2
	rename b70 incwage_weekly2
	rename b70ppp incwage_weeklyppp2
	rename b73 incwage_refyear2
	
	* Create wage information for last pre–US job.
	* Combine currency code information
	replace currency1 = currency1try2 if currency1 == 997
	replace currency2 = currency2try2 if currency2 == 997
	
	* Create hourly wage. 
	gen incwage1 = incwagetemp1 if incwagetemp1 > 0 & incwage_units1 == 2
	replace incwage1 = incwagetemp1/(hours1/5) if hours1 > 0 & incwagetemp1 > 0 & incwage_units1 == 3
	replace incwage1 = incwagetemp1/hours1 if hours1 > 0 & incwagetemp1 > 0 & incwage_units1 == 4
	replace incwage1 = incwagetemp1/(2*hours1) if hours1 > 0 & incwagetemp1 > 0 & incwage_units1 == 5
	replace incwage1 = incwagetemp1/(4.33*hours1) if hours1 > 0 & incwagetemp1 > 0 & incwage_units1 == 6
	replace incwage1 = incwagetemp1/(wkswork1*hours1) if hours1 > 0 & wkswork1 > 0 & incwagetemp1 > 0 & incwage_units1 == 7
	replace incwage1 = incwage_weekly1/hours1 if missing(incwage1) & ~missing(incwage_weekly1) & incwage_weekly1 > 0 & hours1 > 0 	
	
	gen incwage2 = incwagetemp2 if incwagetemp2 > 0 & incwage_units2 == 2
	replace incwage2 = incwagetemp2/(hours2/5) if hours2 > 0 & incwagetemp2 > 0 & incwage_units2 == 3
	replace incwage2 = incwagetemp2/hours2 if hours2 > 0 & incwagetemp2 > 0 & incwage_units2 == 4
	replace incwage2 = incwagetemp2/(2*hours2) if hours2 > 0 & incwagetemp2 > 0 & incwage_units2 == 5
	replace incwage2 = incwagetemp2/(4.33*hours2) if hours2 > 0 & incwagetemp2 > 0 & incwage_units2 == 6
	replace incwage2 = incwagetemp2/(wkswork2*hours2) if hours2 > 0 & wkswork2 > 0 & incwagetemp2 > 0 & incwage_units2 == 7
	replace incwage2 = incwage_weekly2/hours2 if missing(incwage2) & ~missing(incwage_weekly2) & incwage_weekly2 > 0 & hours2 > 0 
	
	gen incwageppp1 = incwageppptemp1 if incwageppptemp1 > 0 & incwage_units1 == 2
	replace incwageppp1 = incwageppptemp1/(hours1/5) if hours1 > 0 & incwageppptemp1 > 0 & incwage_units1 == 3
	replace incwageppp1 = incwageppptemp1/hours1 if hours1 > 0 & incwageppptemp1 > 0 & incwage_units1 == 4
	replace incwageppp1 = incwageppptemp1/(2*hours1) if hours1 > 0 & incwageppptemp1 > 0 & incwage_units1 == 5
	replace incwageppp1 = incwageppptemp1/(4.33*hours1) if hours1 > 0 & incwageppptemp1 > 0 & incwage_units1 == 6
	replace incwageppp1 = incwageppptemp1/(wkswork1*hours1) if hours1 > 0 & wkswork1 > 0 & incwageppptemp1 > 0 & incwage_units1 == 7
	replace incwageppp1 = incwage_weeklyppp1/hours1 if missing(incwageppp1) & ~missing(incwage_weeklyppp1) & incwage_weeklyppp1 > 0 & hours1 > 0 	
	
	gen incwageppp2 = incwageppptemp2 if incwageppptemp2 > 0 & incwage_units2 == 2
	replace incwageppp2 = incwageppptemp2/(hours2/5) if hours2 > 0 & incwageppptemp2 > 0 & incwage_units2 == 3
	replace incwageppp2 = incwageppptemp2/hours2 if hours2 > 0 & incwageppptemp2 > 0 & incwage_units2 == 4
	replace incwageppp2 = incwageppptemp2/(2*hours2) if hours2 > 0 & incwageppptemp2 > 0 & incwage_units2 == 5
	replace incwageppp2 = incwageppptemp2/(4.33*hours2) if hours2 > 0 & incwageppptemp2 > 0 & incwage_units2 == 6
	replace incwageppp2 = incwageppptemp2/(wkswork2*hours2) if hours2 > 0 & wkswork2 > 0 & incwageppptemp2 > 0 & incwage_units2 == 7
	replace incwageppp2 = incwage_weeklyppp2/hours2 if missing(incwageppp2) & ~missing(incwage_weeklyppp2) & incwage_weeklyppp2 > 0 & hours2 > 0 	
	
	* Occupation
	gen bocc1 = 1 if occ1 >= 10 & occ1 <= 430
	replace bocc1 = 2 if occ1 >= 500 & occ1 <= 740
	replace bocc1 = 3 if occ1 >= 800 & occ1 <= 950
	replace bocc1 = 4 if occ1 >= 1000 & occ1 <= 1240
	replace bocc1 = 5 if occ1 >= 1300 & occ1 <= 1560
	replace bocc1 = 6 if occ1 >= 1600 & occ1 <= 1965
	replace bocc1 = 7 if occ1 >= 2000 & occ1 <= 2060
	replace bocc1 = 8 if occ1 >= 2100 & occ1 <= 2160
	replace bocc1 = 9 if occ1 >= 2200 & occ1 <= 2550
	replace bocc1 = 10 if occ1 >= 2600 & occ1 <= 2960
	replace bocc1 = 11 if occ1 >= 3000 & occ1 <= 3540
	replace bocc1 = 12 if occ1 >= 3600 & occ1 <= 3655
	replace bocc1 = 13 if occ1 >= 3700 & occ1 <= 3955
	replace bocc1 = 14 if occ1 >= 4000 & occ1 <= 4160
	replace bocc1 = 15 if occ1 >= 4200 & occ1 <= 4250
	replace bocc1 = 16 if occ1 >= 4300 & occ1 <= 4650
	replace bocc1 = 17 if occ1 >= 4700 & occ1 <= 4965
	replace bocc1 = 18 if occ1 >= 5000 & occ1 <= 5940
	replace bocc1 = 19 if occ1 >= 6000 & occ1 <= 6130
	replace bocc1 = 20 if occ1 >= 6200 & occ1 <= 6765
	replace bocc1 = 21 if occ1 >= 6800 & occ1 <= 6940
	replace bocc1 = 22 if occ1 >= 7000 & occ1 <= 7630
	replace bocc1 = 23 if occ1 >= 7700 & occ1 <= 8965
	replace bocc1 = 24 if occ1 >= 9000 & occ1 <= 9750
	replace bocc1 = 25 if occ1 >= 9800 & occ1 <= 9920
	
	gen bocc2 = 1 if occ2 >= 10 & occ2 <= 430
	replace bocc2 = 2 if occ2 >= 500 & occ2 <= 740
	replace bocc2 = 3 if occ2 >= 800 & occ2 <= 950
	replace bocc2 = 4 if occ2 >= 1000 & occ2 <= 1240
	replace bocc2 = 5 if occ2 >= 1300 & occ2 <= 1560
	replace bocc2 = 6 if occ2 >= 1600 & occ2 <= 1965
	replace bocc2 = 7 if occ2 >= 2000 & occ2 <= 2060
	replace bocc2 = 8 if occ2 >= 2100 & occ2 <= 2160
	replace bocc2 = 9 if occ2 >= 2200 & occ2 <= 2550
	replace bocc2 = 10 if occ2 >= 2600 & occ2 <= 2960
	replace bocc2 = 11 if occ2 >= 3000 & occ2 <= 3540
	replace bocc2 = 12 if occ2 >= 3600 & occ2 <= 3655
	replace bocc2 = 13 if occ2 >= 3700 & occ2 <= 3955
	replace bocc2 = 14 if occ2 >= 4000 & occ2 <= 4160
	replace bocc2 = 15 if occ2 >= 4200 & occ2 <= 4250
	replace bocc2 = 16 if occ2 >= 4300 & occ2 <= 4650
	replace bocc2 = 17 if occ2 >= 4700 & occ2 <= 4965
	replace bocc2 = 18 if occ2 >= 5000 & occ2 <= 5940
	replace bocc2 = 19 if occ2 >= 6000 & occ2 <= 6130
	replace bocc2 = 20 if occ2 >= 6200 & occ2 <= 6765
	replace bocc2 = 21 if occ2 >= 6800 & occ2 <= 6940
	replace bocc2 = 22 if occ2 >= 7000 & occ2 <= 7630
	replace bocc2 = 23 if occ2 >= 7700 & occ2 <= 8965
	replace bocc2 = 24 if occ2 >= 9000 & occ2 <= 9750
	replace bocc2 = 25 if occ2 >= 9800 & occ2 <= 9920
	
	label define bocclbl 1 `"Management"', add
	label define bocclbl 2 `"Business Operations Specialists"', add
	label define bocclbl 3 `"Financial Specialists"', add
	label define bocclbl 4 `"Computer and Mathematics"', add
	label define bocclbl 5 `"Architecture and Engineering"', add
	label define bocclbl 6 `"Life, Physical, and Social Sciences"', add
	label define bocclbl 7 `"Community and Social Services"', add
	label define bocclbl 8 `"Legal"', add
	label define bocclbl 9 `"Education, Training, and Library"', add
	label define bocclbl 10 `"Arts, Design, Entertainment, Sports, and Media"', add
	label define bocclbl 11 `"Healthcare Practitioners and Technical"', add
	label define bocclbl 12 `"Healthcare Support"', add
	label define bocclbl 13 `"Protective Service"', add
	label define bocclbl 14 `"Food Preparation and Serving"', add
	label define bocclbl 15 `"Building and Grounds Cleaning and Maintenance"', add
	label define bocclbl 16 `"Personal Care and Service"', add
	label define bocclbl 17 `"Sales and Related"', add
	label define bocclbl 18 `"Office and Administrative Support"', add
	label define bocclbl 19 `"Farming, Fishing, and Forestry"', add
	label define bocclbl 20 `"Construction and Extraction"', add
	label define bocclbl 21 `"Extraction"', add
	label define bocclbl 22 `"Installation, Maintenance, and Repair"', add
	label define bocclbl 23 `"Production"', add
	label define bocclbl 24 `"Transportation and Material Moving"', add
	label define bocclbl 25 `"Military"', add
	label values bocc1 bocclbl
	label values bocc2 bocclbl
	
*
* 1.6: Record information for first post–migration job. 
*

	rename b74 worked_us
	rename b75 incwage_refyear3
	rename b76mo country3
	rename b78in ind3
	rename b78oc occ3
	rename b81 classwkr3
	rename b85 hours3
	rename b86 wkswork3
	rename b87 paidwrk3
	rename b88 payment3
	rename b89 currency3
	rename b90nu currency3try2
	rename b91 incwagetemp3
	rename b92 incwage_units3
	rename b95 incwage_weekly3
	rename b98 samejob3
	rename b99 lastyearinjob3
	
	* Create wage information for first post–migration job. 
	* Create wage information for last pre–US job.
	* Combine currency code information
	replace currency3 = currency3try2 if currency1 == 997
	
	* Create hourly wage. 
	gen incwage3 = incwagetemp3 if incwagetemp3 > 0 & incwage_units3 == 2
	replace incwage3 = incwagetemp3/(hours3/5) if hours3 > 0 & incwagetemp3 > 0 & incwage_units3 == 3
	replace incwage3 = incwagetemp3/hours3 if hours3 > 0 & incwagetemp3 > 0 & incwage_units3 == 4
	replace incwage3 = incwagetemp3/(2*hours3) if hours3 > 0 & incwagetemp3 > 0 & incwage_units3 == 5
	replace incwage3 = incwagetemp3/(4.33*hours3) if hours3 > 0 & incwagetemp3 > 0 & incwage_units3 == 6
	replace incwage3 = incwagetemp3/(wkswork3*hours3) if hours3 > 0 & wkswork3 > 0 & incwagetemp3 > 0 & incwage_units3 == 7
	replace incwage3 = incwage_weekly3/hours3 if missing(incwage3) & ~missing(incwage_weekly1) & incwage_weekly3 > 0 & hours3 > 0 
	
	* Occupation
	gen bocc3 = 1 if occ3 >= 10 & occ3 <= 430
	replace bocc3 = 2 if occ3 >= 500 & occ3 <= 740
	replace bocc3 = 3 if occ3 >= 800 & occ3 <= 950
	replace bocc3 = 4 if occ3 >= 1000 & occ3 <= 1240
	replace bocc3 = 5 if occ3 >= 1300 & occ3 <= 1560
	replace bocc3 = 6 if occ3 >= 1600 & occ3 <= 1965
	replace bocc3 = 7 if occ3 >= 2000 & occ3 <= 2060
	replace bocc3 = 8 if occ3 >= 2100 & occ3 <= 2160
	replace bocc3 = 9 if occ3 >= 2200 & occ3 <= 2550
	replace bocc3 = 10 if occ3 >= 2600 & occ3 <= 2960
	replace bocc3 = 11 if occ3 >= 3000 & occ3 <= 3540
	replace bocc3 = 12 if occ3 >= 3600 & occ3 <= 3655
	replace bocc3 = 13 if occ3 >= 3700 & occ3 <= 3955
	replace bocc3 = 14 if occ3 >= 4000 & occ3 <= 4160
	replace bocc3 = 15 if occ3 >= 4200 & occ3 <= 4250
	replace bocc3 = 16 if occ3 >= 4300 & occ3 <= 4650
	replace bocc3 = 17 if occ3 >= 4700 & occ3 <= 4965
	replace bocc3 = 18 if occ3 >= 5000 & occ3 <= 5940
	replace bocc3 = 19 if occ3 >= 6000 & occ3 <= 6130
	replace bocc3 = 20 if occ3 >= 6200 & occ3 <= 6765
	replace bocc3 = 21 if occ3 >= 6800 & occ3 <= 6940
	replace bocc3 = 22 if occ3 >= 7000 & occ3 <= 7630
	replace bocc3 = 23 if occ3 >= 7700 & occ3 <= 8965
	replace bocc3 = 24 if occ3 >= 9000 & occ3 <= 9750
	replace bocc3 = 25 if occ3 >= 9800 & occ3 <= 9920
	label values bocc3 bocclbl

*
* 1.7: Load current employment data. 
*

	merge 1:1 pu_id using "./temp/section_c.dta", force
	keep if _merge == 3
	drop _merge

	rename c1 empstat4
	rename c1anu empstat24
	rename c16 empstat34
	gen incwage_refyear4 = year
	rename c18_1in ind4
	rename c18_1oc occ4
	rename c19a_1mo labcountry4
	rename c20_1 startmonth4
	rename c20a_1 startyear4
	rename c22_1 classwkr4
	rename c24_1 samejob
	rename c25_1 prioroffer
	rename c26_1 classwkrd4
	rename c33_1 hours4
	rename c37_1 wkswork4
	rename c47_1 payment4
	rename c48_1 incwagetemp4
	rename c48a_1 currency4
	rename c48a1_1nu currency4try2
	rename c48a2_1 incwage_units4
	rename c49_1mo incwage_hourly4
	
	replace currency4 = currency4try2 if currency4 == 997

	* Recode incwage to the hourly value. Use actual hourly wage when reported.
	gen incwage4 = incwage_hourly4 if payment4 == 2 & (!missing(incwage_hourly4) & incwage_hourly4 > 0)
	* Construct hourly wage for other workers. 
	replace incwage4 = incwagetemp4 if payment4 != 2 & incwagetemp4 > 0 & (currency4 == 65 | missing(currency4)) & incwage_units4 == 1
	replace incwage4 = incwagetemp4/hours4 if payment4 != 2 & hours4 > 0 & incwage4 > 0 & (currency4 == 65 | missing(currency4)) & incwagetemp4 > 0 & incwage_units4 == 2
	replace incwage4 = incwagetemp4/(2*hours4) if payment4 != 2 & hours4 > 0 & incwage4 > 0 & (currency4 == 65 | missing(currency4)) & incwagetemp4 > 0 & incwage_units4 == 3
	replace incwage4 = incwagetemp4/(4.33*hours4) if payment4 != 2 & hours4 > 0 & incwage4 > 0 & (currency4 == 65 | missing(currency4)) & incwagetemp4 > 0 & incwage_units4 == 4
	replace incwage4 = incwagetemp4/(hours4*wkswork4) if payment4 != 2 & hours4 > 0 & wkswork4 > 0 & incwage4 > 0 & (currency4 == 65 | missing(currency4)) & incwagetemp4 > 0 & incwage_units4 == 5
	
	gen logwage4 = log(incwage4)
	
	* Occupation
	gen bocc4 = 1 if occ4 >= 10 & occ4 <= 430
	replace bocc4 = 2 if occ4 >= 500 & occ4 <= 740
	replace bocc4 = 3 if occ4 >= 800 & occ4 <= 950
	replace bocc4 = 4 if occ4 >= 1000 & occ4 <= 1240
	replace bocc4 = 5 if occ4 >= 1300 & occ4 <= 1560
	replace bocc4 = 6 if occ4 >= 1600 & occ4 <= 1965
	replace bocc4 = 7 if occ4 >= 2000 & occ4 <= 2060
	replace bocc4 = 8 if occ4 >= 2100 & occ4 <= 2160
	replace bocc4 = 9 if occ4 >= 2200 & occ4 <= 2550
	replace bocc4 = 10 if occ4 >= 2600 & occ4 <= 2960
	replace bocc4 = 11 if occ4 >= 3000 & occ4 <= 3540
	replace bocc4 = 12 if occ4 >= 3600 & occ4 <= 3655
	replace bocc4 = 13 if occ4 >= 3700 & occ4 <= 3955
	replace bocc4 = 14 if occ4 >= 4000 & occ4 <= 4160
	replace bocc4 = 15 if occ4 >= 4200 & occ4 <= 4250
	replace bocc4 = 16 if occ4 >= 4300 & occ4 <= 4650
	replace bocc4 = 17 if occ4 >= 4700 & occ4 <= 4965
	replace bocc4 = 18 if occ4 >= 5000 & occ4 <= 5940
	replace bocc4 = 19 if occ4 >= 6000 & occ4 <= 6130
	replace bocc4 = 20 if occ4 >= 6200 & occ4 <= 6765
	replace bocc4 = 21 if occ4 >= 6800 & occ4 <= 6940
	replace bocc4 = 22 if occ4 >= 7000 & occ4 <= 7630
	replace bocc4 = 23 if occ4 >= 7700 & occ4 <= 8965
	replace bocc4 = 24 if occ4 >= 9000 & occ4 <= 9750
	replace bocc4 = 25 if occ4 >= 9800 & occ4 <= 9920
	label values bocc4 bocclbl
	
*
* 1.8: Load social variables and migration history. 
*

	merge 1:1 pu_id using "./temp/section_j.dta"
	drop if _merge == 2
	drop _merge
	
	* Get English-speaking variables.
	gen english = 1 if j1 == 2 | ((j13 == 1 | j13 == 2) & (j14 == 1 | j14 == 2))
	replace english = 0 if j13 == 3 | j13 == 4 | j14 == 3 | j14 == 4

	gen english_work = 1 if j7_1mo == 1
	replace english_work = 0 if j7_1mo >= 2 & j7_1mo <= 995
	gen english_any_work = 1 if j7_1mo == 1 | j7_2mo == 1 | j7_3mo == 1 | j7_4mo == 1
	replace english_any_work = 0 if missing(english_any_work)

	merge 1:1 pu_id using "./temp/section_k.dta", force
	keep if _merge == 3
	drop _merge
	
	gen yrimmig = .
	forvalues x = 1/30 {
		replace yrimmig = k4_`x' if k6_`x'mo == 218 & k16_`x' == 2 &  missing(yrimmig) & k4_`x' > 0
	}
	replace yrimmig = k20 if missing(yrimmig) & !missing(k20) & k20 > 0 & countrymo == 218
	
	* Get a few migration history variables
	rename k4_1 year_left_cob
	rename k6_1mo country_move_to
	rename k16_1 long_leave
	rename k20 year_move_current
	
*
* 1.9: Load Round 2 survey date and new education variables from demographics. 
*

	preserve
	* Respondents
	use ./temp/section_a2.dta, clear
	rename CURDATE_Y incwage_refyear5
	gen newschool = 1 if A23 == 1 | A39 == 1
	replace newschool = 0 if A23 == 2 & A39 == 2
	save ./temp/rosterav2.dta, replace
	* Spouses
	keep if A52B == 1	
	replace pu_id = substr(pu_id,1,4)+"20"
	rename A52B samespouse
	drop newschool
	gen newschool = 1 if A55_1 > 0 | A59_1 == 218
	replace newschool = 0 if A55_1 == 0 & A59_1 != 218
	append using ./temp/rosterav2.dta
	keep incwage_refyear5 pu_id newschool
	save ./temp/rosterav2.dta, replace
	restore
	
	merge 1:1 pu_id using ./temp/rosterav2.dta
	drop if _merge == 2
	drop _merge
	
*
* 1.10: Load Round 2 post-migration employment outcomes. 
*

	merge 1:1 pu_id using "./temp/section_c2.dta"
	drop if _merge == 2
	drop _merge
	
	rename C1 empstat5
	rename C16 empstat5try2
	rename C18in ind5
	rename C18oc occ5
	rename C19Amo labcountry5
	rename C39CHK classwkr5
	rename C33 hours5
	rename C37 wkswork5
	rename C47 payment5
	rename C47_A incwage_units5
	rename C48 incwagetemp5
	rename C482 incwage5try2
	rename C48A currency5
	rename C48AOSnu currency5try2
	rename C49 incwage_hourly5
	rename C49A incwage_hourlycurrency5
		
	replace incwagetemp5 = incwage5try2 if missing(incwagetemp5)
	replace currency5 = currency5try2 if currency5 == 997
	
	* Recode incwage to the hourly value. Use actual hourly wage when reported.
	gen incwage5 = incwage_hourly5 if payment5 == 2 & !missing(incwage_hourly5) & incwage_hourly5 > 0 & labcountry5 == 218
	
	* Construct hourly wage for other workers. 
	replace incwage5 = incwagetemp5 if payment5 != 2 & incwagetemp5 > 0 & currency5 == 65 & labcountry5 == 218 & incwage_units5 == 1
	replace incwage5 = incwagetemp5/hours5 if payment5 != 2 & hours5 > 0 & incwagetemp5 > 0 & currency5 == 65 & labcountry5 == 218 & incwage_units5 == 2
	replace incwage5 = incwagetemp5/(2*hours5) if payment5 != 2 & hours5 > 0 & incwagetemp5 > 0 & currency5 == 65 & labcountry5 == 218 & incwage_units5 == 3
	replace incwage5 = incwagetemp5/(4.33*hours5) if payment5 != 2 & hours5 > 0 & incwagetemp5 > 0 & currency5 == 65 & labcountry5 == 218 & incwage_units5 == 4
	replace incwage5 = incwagetemp5/(hours5*wkswork5) if payment5 != 2 & hours5 > 0 & wkswork5 > 0 & incwagetemp5 > 0 & currency5 == 65 & labcountry5 == 218 & incwage_units5 == 5
	
	* Occupation
	gen bocc5 = 1 if occ5 >= 10 & occ5 <= 430
	replace bocc5 = 2 if occ5 >= 500 & occ5 <= 740
	replace bocc5 = 3 if occ5 >= 800 & occ5 <= 950
	replace bocc5 = 4 if occ5 >= 1000 & occ5 <= 1240
	replace bocc5 = 5 if occ5 >= 1300 & occ5 <= 1560
	replace bocc5 = 6 if occ5 >= 1600 & occ5 <= 1965
	replace bocc5 = 7 if occ5 >= 2000 & occ5 <= 2060
	replace bocc5 = 8 if occ5 >= 2100 & occ5 <= 2160
	replace bocc5 = 9 if occ5 >= 2200 & occ5 <= 2550
	replace bocc5 = 10 if occ5 >= 2600 & occ5 <= 2960
	replace bocc5 = 11 if occ5 >= 3000 & occ5 <= 3540
	replace bocc5 = 12 if occ5 >= 3600 & occ5 <= 3655
	replace bocc5 = 13 if occ5 >= 3700 & occ5 <= 3955
	replace bocc5 = 14 if occ5 >= 4000 & occ5 <= 4160
	replace bocc5 = 15 if occ5 >= 4200 & occ5 <= 4250
	replace bocc5 = 16 if occ5 >= 4300 & occ5 <= 4650
	replace bocc5 = 17 if occ5 >= 4700 & occ5 <= 4965
	replace bocc5 = 18 if occ5 >= 5000 & occ5 <= 5940
	replace bocc5 = 19 if occ5 >= 6000 & occ5 <= 6130
	replace bocc5 = 20 if occ5 >= 6200 & occ5 <= 6765
	replace bocc5 = 21 if occ5 >= 6800 & occ5 <= 6940
	replace bocc5 = 22 if occ5 >= 7000 & occ5 <= 7630
	replace bocc5 = 23 if occ5 >= 7700 & occ5 <= 8965
	replace bocc5 = 24 if occ5 >= 9000 & occ5 <= 9750
	replace bocc5 = 25 if occ5 >= 9800 & occ5 <= 9920
	label values bocc5 bocclbl
	
*
* 1.12: Keep only needed variables.
*

	keep pu_id logwage* ind* bocc* occ* class* labforce* labcountry* empstat* sex year age* yrschl yrschl_us yrschl_usage educ* weight* wkswork* hours* incwage* bpld visacat visacatmo inttype currency* flag* birth_year samejob3 prioroffer lastyearinjob3 worked_us year_left_cob country_move_to long_leave year_move_current yrimmig cisadjust english* ruralkid newschool year_us_educ paidwrk*
	
/*

*************************************************************************************
*************************************************************************************
*************************************************************************************

Step 2: Clean NIS data. 

*************************************************************************************
*************************************************************************************
*************************************************************************************

*/

	
*
* 2.1: Clean some variables. 
*

	* Create education categories for merging purposes
	gen educcat = 1 if educd == 0 | educd == 1 | (educd == 2 & yrschl >= 0 & yrschl <= 8)
	replace educcat = 2 if (educd == 2 & yrschl >= 9 & yrschl <= 11) | educd == 2
	replace educcat = 3 if educd == 3
	replace educcat = 4 if educd == 4
	replace educcat = 5 if educd == 5 | educd == 6 | educd == 7 | educd == 8
	* Use years of schooling when they're available and degrees are not
	replace educcat = 1 if (yrschl >= 0 & yrschl <= 8) & missing(educcat)
	replace educcat = 2 if (yrschl >= 9 & yrschl <= 11) & missing(educcat)
	replace educcat = 3 if (yrschl == 12) & missing(educcat)
	replace educcat = 4 if (yrschl >= 13 & yrschl <= 15) & missing(educcat)
	replace educcat = 5 if (yrschl >= 16 & yrschl <= 30) & missing(educcat)

	label define educlbl 1 "No HS", add
	label define educlbl 2 "Some HS", add
	label define educlbl 3 "HS Grad", add
	label define educlbl 4 "Some Coll", add
	label define educlbl 5 "Coll Grad", add
	label values educcat educlbl
	label var educcat "Education Level"

	* Clean years of schooling
	replace yrschl = . if yrschl < 0
	replace yrschl = 22 if yrschl > 22 & educd >= 5
	replace yrschl = . if yrschl > 22 & (educd >= 1 & educd <= 4)
	
	* Use educd to fill in yrschl when necessary
	replace yrschl = 6 if educd == 1 & missing(yrschl)
	replace yrschl = 9 if educd == 2 & missing(yrschl)
	replace yrschl = 12 if educd == 3 & missing(yrschl)
	replace yrschl = 14 if educd == 4 & missing(yrschl)
	replace yrschl = 16 if educd == 5 & missing(yrschl)
	replace yrschl = 18 if educd == 6 & missing(yrschl)
	replace yrschl = 20 if (educd == 7 | educd == 8) & missing(yrschl)

	* Force some categories together
	* Combine UK, USSR, Yugoslavia, Eritrea/Ethiopia
	foreach x in "1" "2" {
		replace labcountry`x' = 217 if labcountry`x' == 246 | labcountry`x' == 288
		replace labcountry`x' = 187 if (labcountry`x' == 221 | labcountry`x' == 215 | labcountry`x' == 210 | labcountry`x' == 202 | labcountry`x' == 172 | labcountry`x' == 137 | labcountry`x' == 115 | labcountry`x' == 121 | labcountry`x' == 113 | labcountry`x' == 108 | labcountry`x' == 79 | labcountry`x' == 68 | labcountry`x' == 19 | labcountry`x' == 14 | labcountry`x' == 10) & incwage_refyear`x' <= 1991
		replace labcountry`x' = 58 if (labcountry`x' == 57 | labcountry`x' == 182) & incwage_refyear`x' <= 1992
		replace labcountry`x' = 69 if labcountry`x' == 67 & incwage_refyear`x' <= 1992
		replace labcountry`x' = 228 if (labcountry`x' == 27 | labcountry`x' == 54 | labcountry`x' == 124 | labcountry`x' == 183 | labcountry`x' == 253 | labcountry`x' == 291 | labcountry`x' == 289 | labcountry`x' == 290) & incwage_refyear`x' <= 1990
	}
	replace bpld = 217 if bpld == 246 | bpld == 288
	replace bpld = 187 if (bpld == 221 | bpld == 215 | bpld == 210 | bpld == 202 | bpld == 172 | bpld == 137 | bpld == 115 | bpld == 121 | bpld == 113 | bpld == 108 | bpld == 79 | bpld == 68 | bpld == 19 | bpld == 14 | bpld == 10) & birth_year <= 1991
	replace bpld = 58 if (bpld == 57 | bpld == 182) & birth_year <= 1992
	replace bpld = 69 if bpld == 67 & birth_year <= 1992
	replace bpld = 228 if (bpld == 27 | bpld == 54 | bpld == 124 | bpld == 183 | bpld == 253 | bpld == 291 | bpld == 289 | bpld == 290) & birth_year <= 1990
	
	* Separate USSR and Czechoslovakia after their dissolution, if possible.
	* Use currency to guess country. Not really possible with Yugoslavia, no clear currencies.
	foreach x in "1" "2" {
		replace labcountry`x' = 10 if (labcountry`x' == 187 & currency`x' == 67 & incwage_refyear`x' >= 1992)
		replace labcountry`x' = 14 if (labcountry`x' == 187 & currency`x' == 150 & incwage_refyear`x' >= 1992)
		replace labcountry`x' = 19 if (labcountry`x' == 187 & currency`x' == 71 & incwage_refyear`x' >= 1992)
		replace labcountry`x' = 68 if (labcountry`x' == 187 & currency`x' == 89 & incwage_refyear`x' >= 1992)
		replace labcountry`x' = 79 if (labcountry`x' == 187 & currency`x' == 92 & incwage_refyear`x' >= 1992)
		replace labcountry`x' = 108 if (labcountry`x' == 187 & currency`x' == 101 & incwage_refyear`x' >= 1992)
		replace labcountry`x' = 113 if (labcountry`x' == 187 & currency`x' == 144 & incwage_refyear`x' >= 1992)
		replace labcountry`x' = 121 if (labcountry`x' == 187 & currency`x' == 107 & incwage_refyear`x' >= 1992)
		replace labcountry`x' = 115 if (labcountry`x' == 187 & currency`x' == 103 & incwage_refyear`x' >= 1992)
		replace labcountry`x' = 137 if (labcountry`x' == 187 & currency`x' == 111 & incwage_refyear`x' >= 1992)
		replace labcountry`x' = 172 if (labcountry`x' == 187 & currency`x' == 50 & incwage_refyear`x' >= 1992)
		replace labcountry`x' = 202 if (labcountry`x' == 187 & currency`x' == 167 & incwage_refyear`x' >= 1992)
		replace labcountry`x' = 210 if (labcountry`x' == 187 & currency`x' == 130 & incwage_refyear`x' >= 1992)
		replace labcountry`x' = 215 if (labcountry`x' == 187 & currency`x' == 133 & incwage_refyear`x' >= 1992)
		replace labcountry`x' = 221 if (labcountry`x' == 187 & currency`x' == 135 & incwage_refyear`x' >= 1992)
		replace labcountry`x' = 57 if (labcountry`x' == 58 & currency`x' == 16 & incwage_refyear`x' >= 1993)
		replace labcountry`x' = 182 if (labcountry`x' == 58 & currency`x' == 143 & incwage_refyear`x' >= 1993)
	}
	
	* Clean some payment codes with duplicates
	foreach x in "1" "2" {
		replace currency`x' = 53 if currency`x' == 123
		replace currency`x' = 36 if currency`x' == 102
		* Grenada dollar is not a currency, that's the East Caribbean dollar
		replace currency`x' = 84 if currency`x' == 95
		* Yugoslav dinar after 1994 was fixed to the Deutschmark
		replace currency`x' = 23 if currency`x' == 137 & year >= 1994
	}
	
*
* 2.2: Load on exchange rates and cost of living adjustments, create real income
*
		
	* Merge on ISO codes to match with PWT
	foreach x in "1" "2" {
		gen code = labcountry`x'
		replace code = bpld if missing(code) | code < 0
		merge m:1 code using ./temp/country_iso.dta
		drop if _merge == 2
		drop _merge* code
		rename iso iso`x'
	}
	
	* Merge on exchange rates, cost of living adjustments, and growth rates.
	* Missing exchanges checked carefully: they are early, implausible year–currency pairs,
	* a couple of cases that would be thrown out for devaluations below, and Burma (no GDP data anyway). 
	foreach x in "1" "2" {
		rename currency`x' currency
		rename incwage_refyear`x' incwage_refyear
		rename iso`x' iso
		merge m:1 currency incwage_refyear using "./temp/xrate.dta"
		drop if _merge == 2
		drop _merge
		merge m:1 iso incwage_refyear using "./temp/cola.dta"
		drop if _merge == 2
		drop _merge
		rename currency currency`x'
		rename incwage_refyear incwage_refyear`x'
		rename iso iso`x'
		rename xrat xrat`x' 
		rename cola cola`x'
	}
	
	* Merge on numeraire wage levels for birth country, current US, and first US job in order.
	gen exp4 = age - yrschl - 6	
	foreach x in "1" "2" "3" "5" {
		rename incwage_refyear`x' year_temp
		gen exp = exp4 + (year_temp - incwage_refyear4)
		replace exp = 0 if exp >= -2 & exp < 0
		replace exp = . if exp < 0
		merge m:1 year_temp exp sex educcat using ./temp/cpswagefile.dta
		drop if _merge == 2
		drop _merge exp
		rename year_temp incwage_refyear`x'
		rename logwage_base logwage_base`x'
	}
	rename incwage_refyear4 year_temp
	rename exp4 exp
	merge m:1 year_temp exp sex educcat using ./temp/cpswagefile.dta
	drop if _merge == 2
	drop _merge 
	rename exp exp4
	rename year_temp incwage_refyear4 
	rename logwage_base logwage_base4
		
	* Create logwage and wage change. 
	foreach x in "1" "2" {
		gen logwage`x' = log(incwage`x'/(xrat`x'*cola`x')) + logwage_base4 - logwage_base`x'
		gen logwageppp`x' = log(incwageppp`x') + logwage_base4 - logwage_base`x'
		gen logwage_unadj`x' = log(incwage`x')
	}
	
	foreach x in "3" "5" {
		gen logwage`x' = log(incwage`x') + logwage_base4 - logwage_base`x'
	}
	
*
* 2.3: Load on GDP per worker. 
*	

	* Merge on GDP per worker. 
	foreach x in "1" "2" {
		rename incwage_refyear`x' incwage_refyear
		rename iso`x' iso
		merge m:1 iso incwage_refyear using ./temp/gdp.dta
		drop if _merge == 2
		drop _merge*
		merge m:1 iso using ./temp/gdp2005.dta
		drop if _merge == 2
		drop _merge*
		rename incwage_refyear incwage_refyear`x'
		rename iso iso`x'
		rename gdp gdp`x'
		rename gdp2005 gdp2005`x'
	}

	
*
* 2.4: Load data for flags. 
*

	* Merge on list of countries & years with devaluations
	foreach x in "1" "2" {
		rename currency`x' currency
		merge m:1 currency using "./temp/devaluation.dta"
		drop _merge*
		rename currency currency`x' 
		rename flag_devaluation flag_devaluation`x'
		rename devaluation_year devaluation_year`x'
	}

	* Match on currency codes to detect valid currency–country pairs.
	foreach x in "1" "2" {
		rename iso`x' iso
		merge m:1 iso using ./temp/isocurrency.dta
		drop if _merge == 2
		drop _merge*
		rename iso iso`x'
		rename acc_curr1 acc_curr1_`x' 
		rename acc_curr2 acc_curr2_`x'
		rename acc_curr3 acc_curr3_`x'
	}
	
	* Match: 1 is valid, 0 is invalid (works in India, paid in florints), missing is no currency to match.
	foreach x in "1" "2" {
		gen flag_match`x' = 0 if currency`x' == acc_curr1_`x' | currency`x' == acc_curr2_`x' | currency`x' == acc_curr3_`x'
		replace flag_match`x' = 1 if missing(flag_match`x')
	}
	
	* Merge on inflation rates in the home country
	foreach x in "1" "2" {
		rename incwage_refyear`x' incwage_refyear
		rename iso`x' iso
		merge m:1 iso incwage_refyear using "./temp/wdi_inflation.dta"
		drop if _merge == 2
		drop _merge*
		rename incwage_refyear incwage_refyear`x' 
		rename iso iso`x'
		rename flag_inflationever flag_inflationever`x'
		rename flag_inflation flag_inflation`x'
		
		* Only modern country missing is Taiwan, which has had stable inflation since at least 1981
		* (source: National Statistics Office of Taiwan)
		replace flag_inflation`x' = 0 if iso`x' == "TWN" & incwage_refyear`x' > 1981
		replace flag_inflationever`x' = 0 if iso`x' == "TWN" & incwage_refyear`x' > 1981
	}
	
*
* 2.5: Create wage gains at migration, define GDP category. 
*

	* Define wage gains at migration, based on different comparisons. 
	gen diff42 = logwage4 - logwage2 if !missing(gdp20052) & (flag_devaluation2 == 0 | incwage_refyear2 > devaluation_year2) & incwage_refyear2 >= 1983 & logwage4 > log(0.01) & logwage2 > log(0.01) & logwage4 < log(1000) & logwage2 < log(1000) & (labcountry4 == 218 | missing(labcountry4)) & labcountry2 != 218 & yrschl_us <= 0 & educcountry != 218
	gen diff41 = logwage4 - logwage1 if !missing(gdp20051) & (flag_devaluation1 == 0 | incwage_refyear1 > devaluation_year1) & incwage_refyear1 >= 1983 & logwage4 > log(0.01) & logwage1 > log(0.01) & logwage4 < log(1000) & logwage1 < log(1000) & (labcountry4 == 218 | missing(labcountry4)) & labcountry1 != 218 & yrschl_us <= 0 & educcountry != 218
	gen diff32 = logwage3 - logwage2 if !missing(gdp20052) &  (flag_devaluation2 == 0 | incwage_refyear2 > devaluation_year2) & incwage_refyear2 >= 1983 & logwage3 > log(0.01) & logwage2 > log(0.01) & logwage3 < log(1000) & logwage2 < log(1000) & labcountry2 != 218 & yrschl_us <= 0 & educcountry != 218
	gen diff31 = logwage3 - logwage1 if !missing(gdp20051) &  (flag_devaluation1 == 0 | incwage_refyear1 > devaluation_year1) & incwage_refyear1 >= 1983 & logwage3 > log(0.01) & logwage1 > log(0.01) & logwage3 < log(1000) & logwage1 < log(1000) & labcountry1 != 218 & yrschl_us <= 0 & educcountry != 218
	gen diff52 = logwage5 - logwage2 if !missing(gdp20052) &  (flag_devaluation2 == 0 | incwage_refyear2 > devaluation_year2) & incwage_refyear2 >= 1983 & logwage5 > log(0.01) & logwage2 > log(0.01) & logwage5 < log(1000) & logwage2 < log(1000) & labcountry2 != 218 & labcountry5 == 218 & newschool == 0
	gen diff51 = logwage5 - logwage1 if !missing(gdp20051) &  (flag_devaluation1 == 0 | incwage_refyear1 > devaluation_year1) & incwage_refyear1 >= 1983 & logwage5 > log(0.01) & logwage1 > log(0.01) & logwage5 < log(1000) & logwage1 < log(1000) & labcountry1 != 218 & labcountry5 == 218 & newschool == 0
	
	* Define baseline wage gain at migration.  Preference: for post migration, 4 to 3 to 5.  For pre-migration, 2 to 1. 
	gen diff = .
	gen incwage_refyear = .
	gen incwage_refyearus = .
	gen currency = .
	gen cola = .
	gen gdpcat = .
	gen gdp = .
	gen loggdp = .
	gen loggdp2005 = .
	gen oldocc = .
	gen newocc = .
	gen oldbocc = .
	gen newbocc = .
	gen oldind = .
	gen newind = .
	gen oldlogwage = .
	gen newlogwage = .
	gen oldlogwage_unadj = .
	gen oldclasswkr = .
	gen newclasswkr = .
	gen labcountry = .
	gen flag_inflation = .
	gen flag_inflationever = .
	gen flag_devaluation = .
	gen flag_match = .
	gen iso = ""
	foreach x in "4" "3" "5" {
		foreach y in "2" "1" {
			replace incwage_refyear = incwage_refyear`y' if missing(diff) & !missing(diff`x'`y')
			replace incwage_refyearus = incwage_refyear`x' if missing(diff) & !missing(diff`x'`y')
			replace currency = currency`y' if missing(diff) & !missing(diff`x'`y')
			replace cola = cola`y' if missing(diff) & !missing(diff`x'`y')
			replace gdp = gdp`y' if missing(diff) & !missing(diff`x'`y')
			replace loggdp = log(gdp`y') if missing(diff) & !missing(diff`x'`y')
			replace loggdp2005 = log(gdp2005`y') if missing(diff) & !missing(diff`x'`y')
			replace gdpcat = 1 if gdp2005`y' > 16 & !missing(gdp2005`y') & missing(diff) & !missing(diff`x'`y')
			replace gdpcat = 2 if gdp2005`y' >= 8 & gdp2005`y' < 16 & missing(diff) & !missing(diff`x'`y')
			replace gdpcat = 3 if gdp2005`y' >= 4 & gdp2005`y' < 8 & missing(diff) & !missing(diff`x'`y')
			replace gdpcat = 4 if gdp2005`y' >= 2 & gdp2005`y' < 4 & missing(diff) & !missing(diff`x'`y')
			replace gdpcat = 5 if gdp2005`y' >= 1 & gdp2005`y' < 2 & missing(diff) & !missing(diff`x'`y')
			replace oldocc = occ`y' if missing(diff) & !missing(diff`x'`y')
			replace newocc = occ`x' if missing(diff) & !missing(diff`x'`y')
			replace oldbocc = bocc`y' if missing(diff) & !missing(diff`x'`y')
			replace newbocc = bocc`x' if missing(diff) & !missing(diff`x'`y')
			replace oldind = ind`y' if missing(diff) & !missing(diff`x'`y')
			replace newind = ind`x' if missing(diff) & !missing(diff`x'`y')
			replace oldlogwage = logwage`y' if missing(diff) & !missing(diff`x'`y')
			replace newlogwage = logwage`x' if missing(diff) & !missing(diff`x'`y')
			replace oldlogwage_unadj = logwage_unadj`y' if missing(diff) & !missing(diff`x'`y')
			replace iso = iso`y' if missing(diff) & !missing(diff`x'`y')
			replace oldclasswkr = classwkr`y' if missing(diff) & !missing(diff`x'`y')
			replace newclasswkr = classwkr`x' if missing(diff) & !missing(diff`x'`y')
			replace labcountry = labcountry`y' if missing(diff) & !missing(diff`x'`y')
			replace flag_inflation = flag_inflation`y' if missing(diff) & !missing(diff`x'`y')
			replace flag_inflationever = flag_inflationever`y' if missing(diff) & !missing(diff`x'`y')
			replace flag_devaluation = flag_devaluation`y' if missing(diff) & !missing(diff`x'`y')
			replace flag_match = flag_match`y' if missing(diff) & !missing(diff`x'`y')
			replace diff = diff`x'`y' if missing(diff) & !missing(diff`x'`y')
		}
	}
	
	label define gdpcatlbl 1 "<1/16", add
	label define gdpcatlbl 2 "1/16–1/8", add
	label define gdpcatlbl 3 "1/8–1/4", add
	label define gdpcatlbl 4 "1/4–1/2", add
	label define gdpcatlbl 5 ">1/2", add
	label values gdpcat gdpcatlbl
	label var gdpcat "PPP GDP p.w. relative to U.S., 2005"
	
	save ./temp/nis_all_obs.dta, replace

*
* 2.6: Construct sample size by step. 
*

* Sample size: everyone.
	keep if inttype == 1
	gen pre = 1
	gen post = 1 
	gen both = 1
	collapse (sum) pre post both
	gen title = "All respondents"
	save ./temp/samplesize.dta, replace
	
* Sample size: labor force status. 
	use ./temp/nis_all_obs.dta, clear
	keep if inttype == 1 & labforce1 == 1 & (paidwrk1 == 1 | paidwrk2 == 1)
	gen pre = 1
	gen post = 1 if worked_us == 1 | empstat4 == 1 | empstat5 == 1
	gen both = 1 if !missing(pre) & !missing(post)
	replace post = 0 if missing(post)
	replace both = 0 if missing(both)
	collapse (sum) pre post both
	gen title = "Labor Force Alone"
	append using ./temp/samplesize.dta
	save ./temp/samplesize.dta, replace
	
* Sample size: any valid wage.
	use ./temp/nis_all_obs.dta, clear
	keep if inttype == 1 & labforce1 == 1 & (paidwrk1 == 1 | paidwrk2 == 1)
	gen pre = 1 if (!missing(incwagetemp1) & incwagetemp1 > 0) | (!missing(incwagetemp2) & incwagetemp2 > 0)
	gen post = 1 if (!missing(incwagetemp3) & incwagetemp3 > 0) | (!missing(incwagetemp4) & incwagetemp4 > 0) | (!missing(incwagetemp5) & incwagetemp5 >= 0) | (!missing(incwage_hourly4) & incwage_hourly4 > 0) | (!missing(incwage_hourly5) & incwage_hourly5 > 0)
	gen both = 1 if !missing(pre) & !missing(post)
	replace pre = 0 if missing(pre)
	replace post = 0 if missing(post)
	replace both = 0 if missing(both)
	collapse (sum) pre post both
	gen title = "Any Wage"
	append using ./temp/samplesize.dta
	save ./temp/samplesize.dta, replace

* Sample size: adjusted hourly wage
	use ./temp/nis_all_obs.dta, clear
	keep if inttype == 1 & labforce1 == 1 & (paidwrk1 == 1 | paidwrk2 == 1)
	gen pre = 1 if !missing(logwage1) | !missing(logwage2)
	gen post = 1 if !missing(logwage3) | !missing(logwage4) | !missing(logwage5)
	gen both = 1 if !missing(pre) & !missing(post)
	replace pre = 0 if missing(pre)
	replace post = 0 if missing(post)
	replace both = 0 if missing(both)
	collapse (sum) pre post both
	gen title = "Adjusted Hourly Wage"
	append using ./temp/samplesize.dta
	save ./temp/samplesize.dta, replace
	
* Sample size: US schooling
	use ./temp/nis_all_obs.dta, clear
	keep if inttype == 1
	keep if yrschl_us <= 0 & educcountry != 218 & labforce1 == 1 & (paidwrk1 == 1 | paidwrk2 == 1)
	gen pre = 1 if !missing(logwage1) | !missing(logwage2)
	gen post = 1 if !missing(logwage3) | !missing(logwage4) | !missing(logwage5)
	gen both = 1 if !missing(pre) & !missing(post)
	replace pre = 0 if missing(pre)
	replace post = 0 if missing(post)
	replace both = 0 if missing(both)
	collapse (sum) pre post both
	gen title = "No US Schooling"
	append using ./temp/samplesize.dta
	save ./temp/samplesize.dta, replace
	
* Sample size: final
	use ./temp/nis_all_obs.dta, clear
	keep if inttype == 1
	drop if missing(diff)
	drop if missing(gdpcat)
	keep if yrschl_us <= 0 & educcountry != 218
	gen both = 1
	collapse (sum) both
	gen title = "Final (Main) Sample"
	append using ./temp/samplesize.dta
	save ./temp/samplesize.dta, replace
	
* Refine schooling variable slightly, save balanced sample. 
	use ./temp/nis_all_obs.dta, clear
	drop if missing(diff)
	drop if missing(gdpcat)
	keep if yrschl_us <= 0 & educcountry != 218
	egen meanweight = mean(weight)
	replace weight = weight/meanweight
	drop meanweight
	save ./temp/nis_analysis.dta, replace

/*

*************************************************************************************
*************************************************************************************
*************************************************************************************

Step 3:  Read in and clean MMP/LAMP data. 

*************************************************************************************
*************************************************************************************
*************************************************************************************

*/

*
* 3.1: Prepare MMP + LAMP
*

	import excel "./raw data/mmp_lamp/wage_gain_table.xlsx", sheet("Sheet1") firstrow clear

	rename country iso
	rename yearLastHomeJob incwage_refyear
	rename yearLastUsJob incwage_usyear

	* Drop Puerto Rico
	drop if iso == "PRI"

	* Format education.
	gen educcat = 1 if edyrs >= 0 & edyrs <= 8
	replace educcat = 2 if edyrs >= 9 & edyrs <= 11
	replace educcat = 3 if edyrs == 12
	replace educcat = 4 if edyrs >= 13 & edyrs <= 15
	replace educcat = 5 if edyrs >= 16

	* Merge on GDP per capita.
	merge m:1 iso using ./temp/gdp2005.dta
	keep if _merge == 3
	drop _merge*
	gen loggdp2005 = log(gdp2005)

	gen gdpcat = 1 if gdp2005 > 16
	replace gdpcat = 2 if gdp2005 <= 16 & gdp2005 > 8
	replace gdpcat = 3 if gdp2005 <= 8 & gdp2005 > 4
	replace gdpcat = 4 if gdp2005 <= 4 & gdp2005 >= 2
	replace gdpcat = 5 if gdp2005 < 2

	* Format occupation into a simple AMS variable.
	gen oldagdum = 1 if  occGroupLastHomeJob == "Ag"
	replace oldagdum = 0 if missing(oldagdum)
	gen newagdum = 1 if occGroupLastUsJob == "Ag"
	replace newagdum = 0 if missing(newagdum)
	drop occ*

	* Start the process to adjust wages.  
	* Merge on the cost of living adjustment
	merge m:1 iso incwage_refyear using ./temp/cola.dta
	keep if _merge == 3
	drop _merge*

	* To merge on currency, we need to manually add in currency name.  All remaining cases have the obvious or right currency.
	gen currency = 14 if iso == "COL"
	replace currency = 83 if iso == "DOM"
	replace currency = 65 if iso == "ECU"
	replace currency = 26 if iso == "GTM"
	replace currency = 96 if iso == "HTI"
	replace currency = 42 if iso == "MEX"
	replace currency = 114 if iso == "NIC"
	replace currency = 46 if iso == "PER"
	replace currency = 65 if iso == "PRI"
	replace currency = 65 if iso == "SLV"
	merge m:1 currency incwage_refyear using ./temp/xrate.dta
	keep if _merge == 3
	drop _merge*

	* Merge on wage growth normalizations. Adjust first wage
	* adjustment to second wage adjustment using type-specific wage growth
	* Adjust both to year 2003 using aggregate wage growth
	* last step is aggregate levels reporting only. 
	gen first = min(incwage_refyear,incwage_usyear)
	gen last = max(incwage_refyear,incwage_usyear)

	gen exp = first - yrborn - edyrs - 6
	replace exp = 0 if exp >= -2 & exp < 0
	replace exp = . if exp < 0
	rename first year_temp
	merge m:1 year_temp exp sex educcat using ./temp/cpswagefile.dta
	drop if _merge == 2
	drop _merge exp
	rename year_temp first
	rename logwage_base logwage_base_first

	gen exp = last - yrborn - edyrs - 6
	replace exp = 0 if exp >= -2 & exp < 0
	replace exp = . if exp < 0
	rename last year_temp
	merge m:1 year_temp exp sex educcat using ./temp/cpswagefile.dta
	drop if _merge == 2
	drop _merge exp
	* Merge on aggregate wage adjustment
	merge m:1 year_temp using ./temp/cpswagefile_agg.dta
	drop if _merge == 2
	drop _merge

	rename year_temp last
	rename logwage_base logwage_base_last

	* Adjust the first observation to the data of the second.
	* Generically this works best because it insures that experience is positive and the conversion exist. 
	gen oldlogwage= .
	gen newlogwage = .
	if first == incwage_refyear {
		replace oldlogwage = log(lastHomeWage/(xrat*cola)) + logwage_base_last - logwage_base_first - aggwageadj
		replace newlogwage = log(lastUsWage) - aggwageadj
		}
	else {
		replace oldlogwage = log(lastHomeWage/(xrat*cola)) - aggwageadj
		replace newlogwage = log(lastUsWage) + logwage + logwage_base_last - logwage_base_first - aggwageadj
	}
	drop aggwageadj w

	* Merge on currencies to check for devaluations. 
	merge m:1 currency using ./temp/devaluation.dta
	drop if _merge == 2
	drop _merge*

	* Define diff for valid cases
	gen diff = newlogwage - oldlogwage if !missing(gdp2005) & (flag_devaluation == 0 | incwage_refyear > devaluation_year) & abs(incwage_refyear - incwage_usyear) <= 20 & newlogwage > log(0.01) & newlogwage < log(1000) & oldlogwage > log(0.01) & oldlogwage < log(1000)
	drop if missing(diff) 

	* Generate a weight of 1.
	gen weight = 1

	save ./temp/mmp_lamp.dta, replace

*
* 3.2: Sample size for MMP + LAMP
*

	drop if missing(diff)
	drop if missing(gdpcat)
	gen both = 1
	collapse (sum) both
	gen title = "MMP/LAMP Sample"
	append using ./temp/samplesize.dta
	export delimited using ./output/sample_details.csv, replace

/*

*************************************************************************************
*************************************************************************************
*************************************************************************************

Step 4: Compare NIS Balanced Sample, NIS Unbalanced Sample, and ACS Sample

*************************************************************************************
*************************************************************************************
*************************************************************************************

*/
	
	
*
* 4.1: Construct wages, education, and age for balanced and unbalanced samples. 
*

	use ./temp/nis_all_obs.dta, clear
	
	* Start by defining the balanced sample. 
	gen category = 3 if !missing(diff) & !missing(gdpcat)
	drop if !missing(diff) & missing(gdpcat)
	
	* Now do the unbalanced sample: only post-migration wages. 
	* Define preferred post-migration wage. 
	* Use the GDP of the associated country. 
	replace newlogwage = logwage4 if missing(category) & logwage4 > log(0.01) & logwage4 < log(1000) &  (labcountry4 == 218 | missing(labcountry4))
	replace newlogwage = logwage3 if missing(category) & missing(newlogwage) & logwage3 > log(0.01) & logwage3 < log(1000)
	replace newlogwage = logwage5 if missing(category) & missing(newlogwage) & logwage5 > log(0.01) & logwage5 < log(1000) & labcountry5 == 218 & newschool == 0
	drop iso
	rename bpld code
	merge m:1 code using ./temp/country_iso.dta
	drop _merge*
	merge m:1 iso using ./temp/gdp2005.dta
	drop _merge*
	replace category = 2 if missing(category) & !missing(newlogwage)
	replace gdp2005 = . if missing(category)
	
	* Now do the unbalanced sample: only pre-migration waegs. 
	* Define the preferred pre-migration wage. 
	* Use the GDP of the associated country. 
	replace oldlogwage = logwage2 if missing(category) & (flag_devaluation2 == 0 | incwage_refyear2 > devaluation_year2) & incwage_refyear2 >= 1983 & logwage2 > log(0.01) & logwage2 < log(1000) & labcountry2 != 218
	replace gdp2005 = gdp20052 if missing(category) & !missing(oldlogwage)
	replace oldlogwage = logwage1 if missing(category) & missing(oldlogwage) & (flag_devaluation1 == 0 | incwage_refyear1 > devaluation_year1) & incwage_refyear1 >= 1983 & logwage1 > log(0.01) & logwage1 < log(1000) & labcountry1 != 218
	replace gdp2005 = gdp20051 if missing(category) & missing(gdp2005) & !missing(oldlogwage)
	replace category = 1 if missing(category) & !missing(oldlogwage)

	* Define GDP categories. 
	replace gdpcat = 1 if category != 3 & gdp2005 > 16 & !missing(gdp2005)
	replace gdpcat = 2 if category != 3 & gdp2005 >= 8 & gdp2005 < 16 
	replace gdpcat = 3 if category != 3 & gdp2005 >= 4 & gdp2005 < 8
	replace gdpcat = 4 if category != 3 & gdp2005 >= 2 & gdp2005 < 4 
	replace gdpcat = 5 if category != 3 & gdp2005 >= 1 & gdp2005 < 2
	drop if missing(gdpcat)
	
	* Drop those who never worked anywhere. 
	drop if missing(category)
	
	* Collapse to means. 
	collapse (mean) oldlogwage logwage5 newlogwage yrschl age [aw=weight], by(gdpcat category)
	gen oldwage = exp(oldlogwage)
	gen newwage = exp(newlogwage)
	gen lastwage = exp(logwage5)
	drop oldlogwage newlogwage logwage5
	reshape wide oldwage newwage lastwage yrschl age, i(gdpcat) j(category)
	
*
* 4.2: Merge on US Census data. 
*
	
	* Merge on Census
	merge 1:1 gdpcat using ./temp/uscensus_immcompare.dta
	drop _merge
	gen wage_uscensus = exp(logwage_uscensus)

	preserve
	use ./temp/mmp_lamp.dta, clear
	gen age = incwage_usyear - yrborn
	collapse (mean) oldlogwagemp = oldlogwage newlogwagemp = newlogwage yrschlmp = edyrs agemp = age [aw=weight], by(gdpcat)
	save ./temp/mp_immcompare.dta, replace
	restore

	merge 1:1 gdpcat using ./temp/mp_immcompare.dta
	drop _merge
	gen oldwagemp = exp(oldlogwagemp)
	gen newwagemp = exp(newlogwagemp)

* 
* 4.3: Figures for comparison: balanced vs. unbalanced. 
*
	
	graph bar oldwage1 oldwage2 oldwage3, over(gdpcat) ytitle("Hourly Wage") legend(rows(1) order(1 2 3) label(1 "Pre-Migration Only") label(2 "Post-Migration Only") label(3 "Both")) ylabel(0(5)20) yscale(r(0 20)) plotregion(margin(sides)) b1title("PPP GDP per worker relative to U.S., 2005") 
	graph export ./output/baseline/nis_balance_oldw.pdf, replace
	
	graph bar newwage1 newwage2 newwage3, over(gdpcat) ytitle("Hourly Wage") legend(rows(1) order(1 2 3) label(1 "Pre-Migration Only") label(2 "Post-Migration Only") label(3 "Both") label(4 "ACS")) ylabel(0(5)20) yscale(r(0 20)) plotregion(margin(sides)) b1title("PPP GDP per worker relative to U.S., 2005") 
	graph export ./output/baseline/nis_balance_neww.pdf, replace
	
	graph bar age1 age2 age3, over(gdpcat) ytitle("Age") legend(rows(1) order(1 2 3) label(1 "Pre-Migration Only") label(2 "Post-Migration Only") label(3 "Both")) ylabel(30(5)45) plotregion(margin(sides)) b1title("PPP GDP per worker relative to U.S., 2005")  exclude0
	graph export ./output/baseline/nis_balance_a.pdf, replace
	
	graph bar yrschl1 yrschl2 yrschl3, over(gdpcat) ytitle("Years of Schooling") legend(rows(1) order(1 2 3) label(1 "Pre-Migration Only") label(2 "Post-Migration Only") label(3 "Both")) ylabel(8(2)16)  plotregion(margin(sides)) b1title("PPP GDP per worker relative to U.S., 2005") exclude0 
	graph export ./output/baseline/nis_balance_s.pdf, replace
	
		
*
* 4.4: Compare NIS to Census samples: simple means
*

	graph bar wage_uscensus newwage3 newwagemp lastwage3, over(gdpcat) ytitle("Hourly Wage") legend(rows(1) label(1 "ACS") label(2 "NIS – Baseline") label(3 "MP") label(4 "NIS - Follow-Up")) ylabel(0(5)20) yscale(r(0 20))  plotregion(margin(sides)) b1title("PPP GDP per worker relative to U.S., 2005")
	graph export ./output/baseline/nis_census_w.pdf, replace
	
	graph bar age_uscensus age3 agemp, over(gdpcat) ytitle("Age") legend(rows(1) label(1 "ACS") label(2 "NIS") label(3 "MP")) ylabel(30(5)45)  plotregion(margin(sides)) b1title("PPP GDP per worker relative to U.S., 2005") exclude0
	graph export ./output/baseline/nis_census_a.pdf, replace
	
	graph bar yrschl_uscensus yrschl3 yrschlmp, over(gdpcat) ytitle("Years of Schooling") legend(rows(1) label(1 "ACS") label(2 "NIS") label(3 "MP")) ylabel(6(2)16)  plotregion(margin(sides)) b1title("PPP GDP per worker relative to U.S., 2005") exclude0
	graph export ./output/baseline/nis_census_s.pdf, replace
	
/*

*************************************************************************************
*************************************************************************************
*************************************************************************************

Step 5: Baseline Analysis: Wage Gains at Migration. 

*************************************************************************************
*************************************************************************************
*************************************************************************************

*/

*
* 5.1: Most common countries by income group in the baseline sample.
*

	use ./temp/nis_analysis.dta, clear
	sort gdpcat
	by gdpcat : tab iso
		
*
* 5.2: Wages and wage changes at migration.
*

	* Wage levels, NIS sample. 
	collapse (mean) loggdp2005 meanpre = oldlogwage meanpost = newlogwage meandiff = diff (count) num = diff [aw=weight], by(gdpcat)
	
	replace meanpre = exp(meanpre)
	replace meanpost = exp(meanpost)	
	replace meandiff = exp(meandiff)
	
	save ./temp/tempresults.dta, replace
	export delimited using ./output/levels_gains_gdpcat.csv, replace
	
	keep meanpre gdpcat
	replace gdpcat = gdpcat - 0.2
	append using ./temp/tempresults.dta
	replace meanpre = . if !missing(meanpost)
	replace gdpcat = gdpcat + 0.2 if missing(meanpre)
	twoway bar meanpre gdpcat, barwidth(0.4) || bar meanpost gdpcat, barwidth(0.4) || scatteri 14.91 3 (12) "2003 Mean U.S. Wage", msymbol(i) mlabsize(large) xtitle("PPP GDP per worker relative to U.S., 2005") ytitle("Hourly Wage, 2003 U.S. Dollars") legend(rows(1) order(1 2) label(1 "Pre-Migration Wage") label(2 "Post-Migration Wage")) xlabel(1 "<1/16" 2 "1/16–1/8" 3 "1/8–1/4" 4 "1/4–1/2" 5 ">1/2") ylabel(0(5)20) yscale(r(0 20)) yline(14.91,lwidth(medthick) lcolor(black)) plotregion(margin(sides))
	graph export ./output/baseline/prepostwage.pdf, replace

	* Wage gains, NIS sample
	use ./temp/nis_analysis.dta, clear
	collapse (mean) loggdp2005 meanpre = oldlogwage meanpost = newlogwage meandiff = diff (count) num = diff [aw=weight], by(gdpcat)
	replace meandiff = exp(meandiff)	
	graph bar meandiff, over(gdpcat) ytitle("Ratio of Post– to Pre–Migration Wage") ylabel(0(1)4) bar(1,color(cb3)) plotregion(margin(sides)) b1title("PPP GDP per worker relative to U.S., 2005")
	graph export ./output/baseline/wagegain.pdf, replace

	* Wage levels, MP sample
	use ./temp/mmp_lamp.dta, clear
	gen mexdum = 1 if iso == "MEX"
	replace mexdum = 0 if iso != "MEX"

	collapse (mean) loggdp2005 meanpre = oldlogwage meanpost = newlogwage meandiff = diff (count) num = diff [aw=weight], by(mexdum)
	
	replace meanpre = exp(meanpre)
	replace meanpost = exp(meanpost)	
	replace meandiff = exp(meandiff)
	
	save ./temp/tempresults.dta, replace
	export delimited using ./output/levels_gains_gdpcat_mp.csv, replace
	
	keep meanpre mexdum
	replace mexdum = mexdum - 0.2
	append using ./temp/tempresults.dta
	replace meanpre = . if !missing(meanpost)
	replace mexdum = mexdum + 0.2 if missing(meanpre)
	twoway bar meanpre mexdum, barwidth(0.4) || bar meanpost mexdum, barwidth(0.4) || scatteri 14.91 1 (12) "2003 Mean U.S. Wage", msymbol(i) mlabsize(large) xtitle("Subsample") ytitle("Hourly Wage, 2003 U.S. Dollars") legend(rows(1) order(1 2) label(1 "Pre-Migration Wage") label(2 "Post-Migration Wage")) xlabel(0 "Latin American MP" 1 "Mexican MP") ylabel(0(5)20) yscale(r(0 20)) yline(14.91,lwidth(medthick) lcolor(black)) plotregion(margin(sides))
	graph export ./output/baseline/prepostwage_mp.pdf, replace

	* Wage gains, MP sample
	use ./temp/mmp_lamp.dta, clear
	gen mexdum = 1 if iso == "MEX"
	replace mexdum = 0 if iso != "MEX"
	collapse (mean) loggdp2005 meanpre = oldlogwage meanpost = newlogwage meandiff = diff (count) num = diff [aw=weight], by(mexdum)
	replace meandiff = exp(meandiff)
	label define mexlbl 0 "Latin American MP"
	label define mexlbl 1 "Mexican MP", add
	label values mexdum mexlbl	
	graph bar meandiff, over(mexdum) ytitle("Ratio of Post– to Pre–Migration Wage") ylabel(0(1)4) bar(1,color(cb3)) plotregion(margin(sides)) b1title("Subsample")
	graph export ./output/baseline/wagegain_mp.pdf, replace

*
* 5.3: Histogram of wage gains for appendix. 
*

	* NIS, baseline sample
	use ./temp/nis_analysis.dta, clear
	keep if gdpcat <= 3
	hist oldlogwage, start(-5.5) width(0.5) xlabel(-4(2)6) xtitle("Log Pre-Migration Wage")
	graph export ./output/baseline/hist_premigration.pdf, replace
	hist newlogwage, start(-5.5) width(0.5) xlabel(-4(2)6) xtitle("Log Post-Migration Wage")
	graph export ./output/baseline/hist_postmigration.pdf, replace
	hist diff, start(-5.5) width(0.5) xlabel(-4(2)6) xtitle("Log-Wage Gain at Migration")
	graph export ./output/baseline/hist_wagegains.pdf, replace

	* NIS, rich country sample. 
	use ./temp/nis_analysis.dta, clear
	keep if gdpcat >= 4
	hist diff, start(-5.5) width(0.5) xlabel(-4(2)6) xtitle("Log-Wage Gain at Migration")
	graph export ./output/baseline/hist_wagegains_high.pdf, replace	

	* MP sample
	use ./temp/mmp_lamp.dta, clear
	hist oldlogwage, start(-5.5) width(0.5) xlabel(-4(2)6) xtitle("Log Pre-Migration Wage")
	graph export ./output/baseline/hist_premigration_mp.pdf, replace
	hist newlogwage, start(-5.5) width(0.5) xlabel(-4(2)6) xtitle("Log Post-Migration Wage")
	graph export ./output/baseline/hist_postmigration_mp.pdf, replace
	hist diff, start(-5.5) width(0.5) xlabel(-4(2)6) xtitle("Log-Wage Gain at Migration")
	graph export ./output/baseline/hist_wagegains_mp.pdf, replace

*
* 5.4: Implied importance of human capital and country–specific factors by GDP per worker category. 
*

	* NIS only. 
	use ./temp/nis_analysis.dta, clear
	gen hc_share = 1 - diff/loggdp2005
	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight], by(gdpcat)
	
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	export delimited using "./output/baseline_gdpcat_nis.csv", replace

	* MP only. 
	use ./temp/mmp_lamp.dta, clear

	gen mexdum = 1 if iso == "MEX"
	replace mexdum = 0 if iso != "MEX"
	gen hc_share = 1 - diff/loggdp2005
	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight], by(mexdum)
	
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	export delimited using "./output/baseline_gdpcat_mp.csv", replace

*
* 5.5: Implied importance of human capital and country-specific factors, < 1/4 US GDP p.c.
* 

	* NIS only. 
	use ./temp/nis_analysis.dta, clear
	keep if gdpcat <= 3
	gen hc_share = 1 - diff/loggdp2005
	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	gen title = "NIS"
	save ./temp/baseline_sample.dta, replace

	* MP only. 
	use ./temp/mmp_lamp.dta, clear
	keep if gdpcat <= 3 | iso == "MEX"
	gen hc_share = 1 - diff/loggdp2005
	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	gen title = "MP"
	append using ./temp/baseline_sample.dta
	save ./temp/baseline_sample.dta, replace

	* Pooled. 
	use ./temp/nis_analysis.dta, clear
	append using ./temp/mmp_lamp.dta
	keep if gdpcat <= 3 | iso == "MEX"
	gen hc_share = 1 - diff/loggdp2005
	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	gen title = "NIS+MP"
	append using ./temp/baseline_sample.dta
	export delimited using "./output/baseline_sample.csv", replace

/*

*************************************************************************************
*************************************************************************************
*************************************************************************************

Step 6: Robustness

*************************************************************************************
*************************************************************************************
*************************************************************************************

*/	

*
* 6.1 Baseline
*
 
 	* Simple means
	use ./temp/nis_analysis.dta, clear
	keep if gdpcat <= 3
	gen hc_share = 1- diff/loggdp2005
	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	
	keep hc_share lower upper num
	gen title = "baseline"
	save ./temp/robustness.dta, replace

*
* 6.2: Use medians, not means
*

	use ./temp/nis_analysis.dta, clear
	keep if gdpcat <= 3
	gen hc_share = 1- diff/loggdp2005
	collapse (median) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	
	gen se = 1.253*sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	
	keep hc_share lower upper num
	gen title = "median"
	append using ./temp/robustness.dta
	save ./temp/robustness.dta, replace
		
*
* 6.3: Use ratio of means, not mean of ratios
*

	use ./temp/nis_analysis.dta, clear
	keep if gdpcat <= 3
	collapse (mean) diff loggdp2005 [aw=weight]
	
	gen hc_share = 1- diff/loggdp2005
	keep hc_share 
	gen title = "ratio_means"
	append using ./temp/robustness.dta
	save ./temp/robustness.dta, replace
	
*
* 6.4: Bootstrap the standard errors. 
*

	use ./temp/nis_analysis.dta, clear
	keep if gdpcat <= 3
	gen hc_share = 1- diff/loggdp2005
	
	bootstrap meanhc = r(mean), reps(10000) : sum hc_share
	
	* Tedious work to save the mean and confidence interval
	clear
	set obs 2
	gen ident = "lower" in 1
	replace ident = "upper" in 2
	gen hc_share = _b[mean]
	matrix b = e(ci_percentile)
	svmat b
	reshape wide b1, i(hc_share) j(ident) string
	rename b1lower lower
	rename b1upper upper
	
	keep hc_share lower upper
	gen title = "bootstrap_ci"
	append using ./temp/robustness.dta
	save ./temp/robustness.dta, replace

*
* 6.5: Do a select country analysis. 
*	

	* Plot figures
	use ./temp/nis_analysis.dta, clear
	egen n = count(diff), by(iso)
	keep if n >= 50 & gdpcat <= 3
	collapse (mean) loggdp2005 meanpre = oldlogwage meanpost = newlogwage meandiff = diff (count) num = diff [aw=weight], by(iso)
	
	replace meanpre = exp(meanpre)
	replace meanpost = exp(meanpost)	
	replace meandiff = exp(meandiff)
	
	graph bar meanpre meanpost, over(iso,sort(loggdp2005) desc) ytitle("Hourly Wage, 2003 U.S. Dollars") legend(rows(1) label(1 "Pre–Migration Wage") label(2 "Post–Migration Wage")) ylabel(0(5)20) yscale(r(0 20)) plotregion(margin(sides)) b1title("Country")
	graph export ./output/baseline/prepostwage_iso_all.pdf, replace
	
	graph bar meandiff, over(iso,sort(loggdp2005) desc) ytitle("Ratio of Post– to Pre–Migration Wage") ylabel(0(1)4) plotregion(margin(sides)) bar(1,color(cb3)) b1title("Country")
	graph export ./output/baseline/wagegain_iso_all.pdf, replace

	* Entry for the robustness table
	use ./temp/nis_analysis.dta, clear
	egen n = count(diff), by(iso)
	keep if n >= 50 & gdpcat <= 3
	gen hc_share = 1 - diff/loggdp2005
	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight], by(iso)
	
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	
	keep hc_share lower upper num iso 
	gen title = "country"+iso
	append using ./temp/robustness.dta
	save ./temp/robustness.dta, replace

*
* 6.6: By Visa category
*
	
	* First cut: simple means
	use ./temp/nis_analysis.dta, clear
	keep if gdpcat <= 3
	collapse (mean) loggdp2005 meanpre = oldlogwage meanpost = newlogwage meandiff = diff (count) num = diff [aw=weight], by(visacat)
	
	replace meanpre = exp(meanpre)
	replace meanpost = exp(meanpost)	
	replace meandiff = exp(meandiff)

	graph bar meanpre meanpost, over(visacat) ytitle("Hourly Wage, 2003 U.S. Dollars") legend(rows(1) label(1 "Pre–Migration Wage") label(2 "Post–Migration Wage")) ylabel(0(5)20) yscale(r(0 20)) plotregion(margin(sides)) b1title("Visa Category")
	graph export ./output/baseline/prepostwage_visa3.pdf, replace
	
	graph bar meandiff, over(visacat) ytitle("Ratio of Post– to Pre–Migration Wage") ylabel(0(1)4) plotregion(margin(sides)) bar(1,color(cb3)) b1title("Visa Category")
	graph export ./output/baseline/wagegain_visa3.pdf, replace

	* Repeat the analysis using residuals. 
	use ./temp/nis_analysis.dta, clear
	keep if gdpcat <= 3
	encode iso, gen(isonum)
	reg oldlogwage i.isonum ib(last).visacat [aw=weight]
	parmest,  saving(./temp/oldlogwage_visares.dta,replace)	
	reg newlogwage i.isonum ib(last).visacat [aw=weight]
	parmest,  saving(./temp/newlogwage_visares.dta,replace)
	reg diff i.isonum ib(last).visacat [aw=weight]
	parmest,  saving(./temp/diff_visares.dta,replace)

	* Collect estimates and plot wage levels. 
	use ./temp/oldlogwage_visares.dta,clear
	gen when = 0
	append using ./temp/newlogwage_visares.dta
	replace when = 1 if missing(when)
	keep if substr(parm,-7,7) == "visacat"
	gen visacat = substr(parm,1,1)
	keep visacat estimate when
	destring visacat, replace
	replace estimate = exp(estimate)
	label define visalbl 1 `"Employment"', add
	label define visalbl 2 `"Family"', add
	label define visalbl 3 `"Diversity"', add
	label define visalbl 4 `"Refugee"', add
	label define visalbl 5 `"Other"', add
	label values visacat visalbl
	reshape wide estimate, i(visacat) j(when)
	graph bar estimate0 estimate1, over(visacat) ytitle("Estimated Wage (Other Visa = 1)") legend(rows(1) label(1 "Pre–Migration Wage") label(2 "Post–Migration Wage")) ylabel(0(0.5)2.5) plotregion(margin(sides)) b1title("Visa Category")
	graph export ./output/baseline/prepostwage_visa_res.pdf, replace	

	* Collect estimates and plot wage gains
	use ./temp/diff_visares.dta, clear
	keep if substr(parm,-7,7) == "visacat"
	gen visacat = substr(parm,1,1)
	keep visacat estimate
	destring visacat, replace
	replace estimate = exp(estimate)
	label define visalbl 1 `"Employment"', add
	label define visalbl 2 `"Family"', add
	label define visalbl 3 `"Diversity"', add
	label define visalbl 4 `"Refugee"', add
	label define visalbl 5 `"Other"', add
	label values visacat visalbl
	graph bar estimate, over(visacat) ytitle("Ratio of Wages (Other Visa = 1)") ylabel(0(0.5)1.5) plotregion(margin(sides)) bar(1,color(cb3)) b1title("Visa Category")
	graph export ./output/baseline/wagegain_visa_res.pdf, replace

	use ./temp/nis_analysis.dta, clear
	keep if gdpcat <= 3
	drop if missing(visacat)
	gen hc_share = 1- diff/loggdp2005
	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight], by(visacat)
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	keep hc_share lower upper num visacat
	gen title = "Employment Visa" if visacat == 1
	replace title = "Family Visa" if visacat == 2
	replace title = "Diversity Visa" if visacat == 3
	replace title = "Refugee Visa" if visacat == 4
	replace title = "Other Visa" if visacat == 5
	drop visacat
	append using ./temp/robustness.dta
	save ./temp/robustness.dta, replace


*
* 6.7: Cut more of the outliers
*

	use ./temp/nis_analysis.dta, clear
	keep if gdpcat <= 3
	drop if oldlogwage < log(0.1) | newlogwage < log(0.1)
	drop if (oldlogwage > log(100) & !missing(oldlogwage)) | (newlogwage > log(100) & !missing(newlogwage))
	
	gen hc_share = 1- diff/loggdp2005
	encode iso, gen(isonum)
	gen educdum = 0 if educcat <= 2
	replace educdum = 1 if educcat > 3
	reg hc_share i.isonum i.educdum [aw=weight]
	margins, at(educdum = (0 1))

	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	
	keep hc_share lower upper num
	gen title = "fewer_outliers"
	append using ./temp/robustness.dta
	save ./temp/robustness.dta, replace
	
*
* 6.8: Cut more of the outliers from the bottom. 
*

	use ./temp/nis_analysis.dta, clear
	keep if gdpcat <= 3
	drop if oldlogwage < log(0.1) | newlogwage < log(5)
	drop if (oldlogwage > log(100) & !missing(oldlogwage)) | (newlogwage > log(100) & !missing(newlogwage))

	gen hc_share = 1- diff/loggdp2005
	encode iso, gen(isonum)
	gen educdum = 0 if educcat <= 2
	replace educdum = 1 if educcat > 3
	reg hc_share i.isonum i.educdum [aw=weight]
	margins, at(educdum = (0 1))

	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	
	keep hc_share lower upper num
	gen title = "fewest_outliers"
	append using ./temp/robustness.dta
	save ./temp/robustness.dta, replace
		
	
*
* 6.9: Only wage workers
*
	
	use ./temp/nis_analysis.dta, clear
	keep if oldclasswkr == 2 & newclasswkr == 2
	keep if gdpcat <= 3

	gen hc_share = 1- diff/loggdp2005
	encode iso, gen(isonum)
	gen educdum = 0 if educcat <= 2
	replace educdum = 1 if educcat > 3
	reg hc_share i.isonum i.educdum [aw=weight]
	margins, at(educdum = (0 1))

	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	keep hc_share lower upper num 
	gen title = "Wage workers"
	append using ./temp/robustness.dta
	save ./temp/robustness.dta, replace
	
*
* 6.10: No secondary migration
*

	use ./temp/nis_analysis.dta, clear
	keep if labcountry == bpld
	keep if gdpcat <= 3

	gen hc_share = 1- diff/loggdp2005
	encode iso, gen(isonum)
	gen educdum = 0 if educcat <= 2
	replace educdum = 1 if educcat > 3
	reg hc_share i.isonum i.educdum [aw=weight]
	margins, at(educdum = (0 1))

	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	keep hc_share lower upper num
	gen title = "No Secondary Migration"
	append using ./temp/robustness.dta
	save ./temp/robustness.dta, replace
	
*
* 6.11: Sampled interviewees only
*

	use ./temp/nis_analysis.dta, clear
	keep if inttype == 1
	keep if gdpcat <= 3

	gen hc_share = 1- diff/loggdp2005
	encode iso, gen(isonum)
	gen educdum = 0 if educcat <= 2
	replace educdum = 1 if educcat > 3
	reg hc_share i.isonum i.educdum [aw=weight]
	margins, at(educdum = (0 1))

	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	keep hc_share lower upper num
	gen title = "Sampled interviewees only"
	append using ./temp/robustness.dta
	save ./temp/robustness.dta, replace
	
*
* 6.12: No high post–migration inflation
*

	use ./temp/nis_analysis.dta, clear
	drop if flag_inflation == 1
	keep if gdpcat <= 3

	gen hc_share = 1- diff/loggdp2005
	encode iso, gen(isonum)
	gen educdum = 0 if educcat <= 2
	replace educdum = 1 if educcat > 3
	reg hc_share i.isonum i.educdum [aw=weight]
	margins, at(educdum = (0 1))

	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	keep hc_share lower upper num
	gen title = "No high inflation"
	append using ./temp/robustness.dta
	save ./temp/robustness.dta, replace
	
*
* 6.13: No high inflation ever.
*

	use ./temp/nis_analysis.dta, clear
	drop if flag_inflationever == 1
	keep if gdpcat <= 3

	gen hc_share = 1- diff/loggdp2005
	encode iso, gen(isonum)
	gen educdum = 0 if educcat <= 2
	replace educdum = 1 if educcat > 3
	reg hc_share i.isonum i.educdum [aw=weight]
	margins, at(educdum = (0 1))

	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	keep hc_share lower upper num 
	gen title = "No high inflation ever"
	append using ./temp/robustness.dta
	save ./temp/robustness.dta, replace
	
*
* 6.14: No countries with revaluations
*

	use ./temp/nis_analysis.dta, clear
	drop if flag_devaluation == 1
	keep if gdpcat <= 3

	gen hc_share = 1- diff/loggdp2005
	encode iso, gen(isonum)
	gen educdum = 0 if educcat <= 2
	replace educdum = 1 if educcat > 3
	reg hc_share i.isonum i.educdum [aw=weight]
	margins, at(educdum = (0 1))

	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	keep hc_share lower upper num
	gen title = "No revaluations ever"
	append using ./temp/robustness.dta
	save ./temp/robustness.dta, replace
	
*
* 6.15: Drop inexplicable currency–country pairs
*

	use ./temp/nis_analysis.dta, clear
	drop if flag_match == 1
	keep if gdpcat <= 3

	gen hc_share = 1- diff/loggdp2005
	encode iso, gen(isonum)
	gen educdum = 0 if educcat <= 2
	replace educdum = 1 if educcat > 3
	reg hc_share i.isonum i.educdum [aw=weight]
	margins, at(educdum = (0 1))

	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	keep hc_share lower upper num
	gen title = "Currency–country match"
	append using ./temp/robustness.dta
	save ./temp/robustness.dta, replace
	
	export delimited using "./output/robustness.csv", replace
	
*
* 6.16: Contemporary GDP per worker
*
	
	use ./temp/nis_analysis.dta, clear
	keep if !missing(loggdp) & gdp > 4

	gen hc_share = 1- diff/loggdp
	encode iso, gen(isonum)
	gen educdum = 0 if educcat <= 2
	replace educdum = 1 if educcat > 3
	reg hc_share i.isonum i.educdum [aw=weight]
	margins, at(educdum = (0 1))

	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	keep hc_share lower upper num
	gen title = "Year t GDP"
	append using ./temp/robustness.dta
	save ./temp/robustness.dta, replace
	
*
* 6.17: Same occupation
*
	
	use ./temp/nis_analysis.dta, clear
	keep if oldocc == newocc & !missing(newocc) & newocc > 0
	keep if gdpcat <= 3
	gen hc_share = 1- diff/loggdp2005
	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	keep hc_share lower upper num
	gen title = "Same Narrow Occupation"
	append using ./temp/robustness.dta
	save ./temp/robustness.dta, replace

*
* 6.18: Offered 2003 job before migrating. 
*

	use ./temp/nis_analysis.dta, clear
	keep if prioroffer == 1
	keep if gdpcat <= 3
	gen hc_share = 1- diff/loggdp2005
	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	keep hc_share lower upper num
	gen title = "Prior offer"
	append using ./temp/robustness.dta
	save ./temp/robustness.dta, replace
	

*
* 6.19: Simple immigration histories. 
*

	use ./temp/nis_analysis.dta, clear
	replace incwage_refyearus = year if missing(incwage_refyearus)
	drop if missing(diff)
	
	* Compute some facts about immigration histories. What fraction are "simple" cases to understand?
	gen simple1 = 1 if long_leave == 2 & country_move_to == 218
	replace simple1 = 0 if missing(simple1)
	gen simple2 = 1 if (year_left_cob == yrimmig) & (incwage_refyearus >= yrimmig & incwage_refyear <= yrimmig)	
	replace simple2 = 0 if missing(simple2)
	gen simple3 = min(simple1,simple2)
	
	rename cisadjust newarrival
	collapse (mean) simple* newarrival (median) incwage_refyear [aw=weight], by(gdpcat)
	
	export delimited using "./output/immigration_histories.csv", replace
	
*
* 6.20: Robustness to using only simple immigration histories. 
*
	
	use ./temp/nis_analysis.dta, clear
	keep if gdpcat <= 3
	replace incwage_refyearus = year if missing(incwage_refyearus)
	drop if year_left_cob < 0 | incwage_refyearus < 0 | incwage_refyear < 0
	keep if (year_left_cob == yrimmig) & (incwage_refyearus >= yrimmig & incwage_refyear <= yrimmig)	

	gen hc_share = 1- diff/loggdp2005
	encode iso, gen(isonum)
	gen educdum = 0 if educcat <= 2
	replace educdum = 1 if educcat > 3
	reg hc_share i.isonum i.educdum [aw=weight]
	margins, at(educdum = (0 1))

	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	keep hc_share lower upper num
	gen title = "Simple Migration Cases"
	append using ./temp/robustness.dta
	save ./temp/robustness.dta, replace
	
*
* 6.21: Crude adjustment for total compensation.
*

	* NIPA  reports that total labor compensation was 123.87% of wages in 2003 in the US.
	* Adjust US wages up. 
	use ./temp/nis_analysis.dta, clear
	keep if gdpcat <= 3
	replace diff = (newlogwage + log(1.2387)) - oldlogwage

	gen hc_share = 1- diff/loggdp2005
	encode iso, gen(isonum)
	gen educdum = 0 if educcat <= 2
	replace educdum = 1 if educcat > 3
	reg hc_share i.isonum i.educdum [aw=weight]
	margins, at(educdum = (0 1))

	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	keep hc_share lower upper num
	gen title = "Total Compensation Adjustment" 
	append using ./temp/robustness.dta
	save ./temp/robustness.dta, replace
	
*
* 6.22: Crude adjustment for non-competitive foreign labor markets. 
*

	* Freeman and Medoff (1984) report union wage gaps of around 20%. Adjust foreign MPL down. 
	* Adjust US wages up. 
	use ./temp/nis_analysis.dta, clear
	keep if gdpcat <= 3
	replace diff = newlogwage - (oldlogwage - log(1.2))

	gen hc_share = 1- diff/loggdp2005
	encode iso, gen(isonum)
	gen educdum = 0 if educcat <= 2
	replace educdum = 1 if educcat > 3
	reg hc_share i.isonum i.educdum [aw=weight]
	margins, at(educdum = (0 1))

	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	keep hc_share lower upper num
	gen title = "Non-Competitive Adjustment"
	append using ./temp/robustness.dta
	save ./temp/robustness.dta, replace
	
*
* 6.23: Minimum wage
*

	* Define a dummy for those who are below minimum wage
	use ./temp/nis_analysis.dta, clear
	keep if gdpcat <= 3
	drop if missing(diff)
	
	gen mw_dum = 1 if newlogwage <= log(5.15)
	replace mw_dum = 0 if newlogwage > log(5.15) & !missing(newlogwage)
	tab mw_dum 
	
	gen logwagec_plot = newlogwage / log(2)
	twoway scatteri 0.15 2.3645724 (3) "2003  U.S. Minimum Wage", msymbol(i) mlabsize(large) || hist logwagec_plot, width(0.125) xline(2.3645724, lcolor(cb2) lwidth(medthick)) xlabel(1.3219 "2.50" 2.3219 "5" 3.3219 "10" 4.3219 "20" 5.3219 "40") frac plotregion(margin(sides)) xtitle("Post-Migration Wage") fcolor(cb1) legend(off)
	graph export ./output/baseline/minimum_wage.pdf, replace
	
	keep if mw_dum == 0

	gen hc_share = 1 - diff/loggdp2005
	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	keep hc_share lower upper num
	gen title = "Above Minimum Wage"
	append using ./temp/robustness.dta
	save ./temp/robustness.dta, replace
	
*
* 6.24: Men
*

	use ./temp/nis_analysis.dta, clear
	keep if sex == 1
	keep if gdpcat <= 3

	gen hc_share = 1- diff/loggdp2005
	encode iso, gen(isonum)
	gen educdum = 0 if educcat <= 2
	replace educdum = 1 if educcat > 3
	reg hc_share i.isonum i.educdum [aw=weight]
	margins, at(educdum = (0 1))

	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	keep hc_share lower upper num
	gen title = "Only Men"
	append using ./temp/robustness.dta
	save ./temp/robustness.dta, replace
	
*
* 6.25: English-speaking
*

	use ./temp/nis_analysis.dta, clear
	keep if gdpcat <= 3
	drop if missing(english)

	gen hc_share = 1- diff/loggdp2005
	encode iso, gen(isonum)
	gen educdum = 0 if educcat <= 2
	replace educdum = 1 if educcat > 3
	reg hc_share i.isonum i.educdum [aw=weight]
	margins, at(educdum = (0 1))

	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight], by(english)
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	gen title = "Good English" if english == 1
	replace title = "Bad English" if english == 0
	keep hc_share lower upper num title
	append using ./temp/robustness.dta
	save ./temp/robustness.dta, replace

*
* 6.26: Speaks English on the job. 
*

	use ./temp/nis_analysis.dta, clear
	keep if gdpcat <= 3
	drop if missing(english_work)

	gen hc_share = 1- diff/loggdp2005
	encode iso, gen(isonum)
	gen educdum = 0 if educcat <= 2
	replace educdum = 1 if educcat > 3
	reg hc_share i.isonum i.educdum [aw=weight]
	margins, at(educdum = (0 1))

	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight], by(english_work)
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	gen title = "English at Work" if english_work == 1
	replace title = "Non-English at Work" if english_work == 0
	keep hc_share lower upper num title
	append using ./temp/robustness.dta
	save ./temp/robustness.dta, replace
	
	export delimited using "./output/robustness.csv", replace

/*

*************************************************************************************
*************************************************************************************
*************************************************************************************

Step 7: Assimilation

*************************************************************************************
*************************************************************************************
*************************************************************************************

*/

*
* 7.1: Robustness: different possible comparisons. 
*

	use ./temp/nis_analysis.dta, clear
	keep if gdpcat <= 3
	forvalues x = 3/4 {
		gen hc_share`x' = 1 - diff`x'2/loggdp2005
		replace hc_share`x' = 1 - diff`x'1/loggdp2005 if missing(hc_share`x')
	}
	collapse (mean) hc_share* (sd) sigma3=hc_share3 sigma4=hc_share4 (count) num3=hc_share3 num4=hc_share4 [aw=weight]
	save ./temp/assimilationtemp.dta, replace

	use ./temp/nis_analysis.dta, clear
	keep if gdpcat <= 3
	forvalues x = 5/5 {
		gen hc_share`x' = 1 - diff`x'2/loggdp2005
		replace hc_share`x' = 1 - diff`x'1/loggdp2005 if missing(hc_share`x')
	}
	collapse (mean) hc_share* (sd) sigma5=hc_share5 (count) num5=hc_share5 [aw=weight_attrition]
	merge 1:1 _n using ./temp/assimilationtemp.dta
	drop _merge*

	forvalues x = 3/5 {
		gen se`x' = sigma`x'/sqrt(num`x')
		gen lower`x' = hc_share`x' - 1.96*se`x'
		gen upper`x' = hc_share`x' + 1.96*se`x'
	}
	keep hc_share* lower* upper* num*
	gen i = 1
	reshape long hc_share lower upper num, i(i) j(wagecat)
	gen title = "Wage Comparison "+string(wagecat)
	drop i wagecat
	save ./temp/robustness_assimilation.dta, replace
	
*
* 7.2: Robustness: very short window
*

	use ./temp/nis_analysis.dta, clear
	* Focus on 4-2 and 4-1 comparisons
	drop diff
	gen diff = diff42
	replace diff = diff41 if missing(diff42)
	drop if missing(diff)
	keep if yrimmig == 2003
	keep if gdpcat <= 3
	gen hc_share = 1- diff/loggdp2005
	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	keep hc_share lower upper num 
	gen title = "2003 arrivals"
	append using ./temp/robustness_assimilation.dta
	save ./temp/robustness_assimilation.dta, replace
	
*
* 7.3: Robustness: medium window
*

	use ./temp/nis_analysis.dta, clear
	* Focus on 4-2 and 4-1 comparisons
	drop diff
	gen diff = diff42
	replace diff = diff41 if missing(diff42)
	drop if missing(diff)
	keep if yrimmig >= 1998 & yrimmig <= 2002
	keep if gdpcat <= 3
	gen hc_share = 1- diff/loggdp2005
	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	keep hc_share lower upper num 
	gen title = "1998-2002 arrivals"
	append using ./temp/robustness_assimilation.dta
	save ./temp/robustness_assimilation.dta, replace
	
*
* 7.4: Robustness: long window
*

	use ./temp/nis_analysis.dta, clear
	* Focus on 4-2 and 4-1 comparisons
	drop diff
	gen diff = diff42
	replace diff = diff41 if missing(diff42)
	drop if missing(diff)
	keep if yrimmig <= 1997 
	keep if gdpcat <= 3
	gen hc_share = 1- diff/loggdp2005
	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	keep hc_share lower upper num 
	gen title = "1988-1997 arrivals"
	append using ./temp/robustness_assimilation.dta
	save ./temp/robustness_assimilation.dta, replace
	
	export delimited using "./output/robustness_assimilation.csv", replace

/*

*************************************************************************************
*************************************************************************************
*************************************************************************************

Step 8: Imperfect Substitution and Barriers

*************************************************************************************
*************************************************************************************
*************************************************************************************

*/

*
* 8.1: Regresions to test for imperfect substitution. 
*

	* NIS + MP data. 
	use ./temp/nis_analysis.dta, clear
	append using ./temp/mmp_lamp.dta
	keep if gdpcat <= 3 | iso == "MEX"
	encode iso, gen(isonum)
	merge m:1 iso using ./temp/impsub.dta
	drop _merge*

	reg diff i.isonum ib(last).educcat [aw=weight]

*
* 8.3: Imperfect Substitutes: Bounding Approach
*

	use ./temp/nis_analysis.dta, clear
	keep if gdpcat <= 3

	forvalues x = 2/4 {
		preserve
		gen educdum = 0 if educcat < `x'
		replace educdum = 1 if educcat >= `x'
		gen hc_share = 1 - diff/loggdp2005
		collapse (mean) hc_share [aw=weight], by(educdum)
		gen cut = `x'
		reshape wide hc_share, i(cut) j(educdum)
		save ./temp/educ_cut`x'.dta, replace
		restore
	}

	use ./temp/educ_cut2.dta, clear
	append using ./temp/educ_cut3.dta
	append using ./temp/educ_cut4.dta
	export delimited using ./output/impsub_bounds.csv, replace
	
*
* 8.4: Imperfect Substitutes: Point Estimates
*

	use ./temp/nis_analysis.dta, clear
	append using ./temp/mmp_lamp.dta
	keep if gdpcat <= 3 | iso == "MEX"
	encode iso, gen(isonum)
	merge m:1 iso using ./temp/impsub.dta
	drop _merge*

	forvalues x = 1/5 {
		gen weight`x' = 1 if educcat == `x'
	}

	* Predict wages for all workers and education possibilities. 
	reg diff i.isonum i.educcat [aw=weight]
	forvalues x = 1/5 {
		replace educcat = `x'
		predict gain`x'
	}

	* Take average for poor countries. 
	keep if gdpcat <= 3 & !missing(pu_id)
	collapse (mean) lu lp lpc ls lsc lh lhc loggdp2005 gain* (sum) weight1-weight5 [aw=weight]

	* Exponentiate
	forvalues x = 1/5 {
		replace gain`x' = exp(gain`x')
	}
	append using ./temp/impsub.dta
	keep if missing(iso) | iso == "USA"
	gen gdplevel = 83400.81 if iso == "USA"
	replace gdplevel = 83400.81/exp(loggdp2005) if iso != "USA"
	drop loggdp2005
	export excel using "./output/impsub.xls", firstrow(variables) replace

*
* 8.5: Sectoral wage gaps: regression approach
*

	* NIS + MP data. 
	use ./temp/nis_analysis.dta, clear
	replace ruralkid = . if ruralkid < 0
	replace ruralkid = 0 if ruralkid == 2
	gen oldagdum = 1 if oldbocc == 19
	replace oldagdum = 0 if oldbocc != 19
	append using ./temp/mmp_lamp.dta
	keep if gdpcat <= 3 | iso == "MEX"
	encode iso, gen(isonum)
	merge m:1 iso using ./temp/caselli.dta
	replace empshare_wdi = empshare_wdi/100
	drop _merge*


	reg diff i.isonum i.oldagdum [aw=weight]
	reg diff i.isonum i.ruralkid [aw=weight]
	reg diff i.isonum ib(last).educcat i.oldagdum [aw=weight]
	reg diff i.isonum ib(last).educcat i.ruralkid [aw=weight]

*
* 8.6: Sectoral Productivity Gap Analysis
*

	gen hc_share = 1 - diff/loggdp2005

	* NIS + MP w/Mex
	preserve
	collapse (mean) agshare_nismp = empshare_wdi [aw=weight]
	save ./temp/empshare_wdi.dta, replace
	restore
	preserve
	collapse (mean) hc_share [aw=weight], by(oldagdum)
	gen i = 1
	reshape wide hc_share, i(i) j(oldagdum)
	cross using ./temp/empshare_wdi.dta
	gen hc_nismp = hc_share0*(1-agshare_nismp) + hc_share1*agshare_nismp
	keep hc_nismp
	save ./temp/agcorrect.dta, replace
	restore

	* NIS + MP w/o MEX
	keep if gdpcat <= 3
	preserve
	collapse (mean) agshare_nismp_nomex = empshare_wdi [aw=weight]
	save ./temp/empshare_wdi.dta, replace
	restore
	preserve
	collapse (mean) hc_share [aw=weight], by(oldagdum)
	gen i = 1
	reshape wide hc_share, i(i) j(oldagdum)
	cross using ./temp/empshare_wdi.dta
	gen hc_nismp_nomex = hc_share0*(1-agshare_nismp_nomex) + hc_share1*agshare_nismp_nomex
	keep hc_nismp_nomex
	cross using ./temp/agcorrect.dta
	save ./temp/agcorrect.dta, replace
	restore

	* NIS
	drop if missing(pu_id)
	preserve
	collapse (mean) agshare_poor = empshare_wdi [aw=weight]
	save ./temp/empshare_wdi.dta, replace
	restore
	preserve
	collapse (mean) hc_share [aw=weight], by(oldagdum)
	gen i = 1
	reshape wide hc_share, i(i) j(oldagdum)
	cross using ./temp/empshare_wdi.dta
	gen hc_nis_poor = hc_share0*(1-agshare_poor) + hc_share1*agshare_poor
	keep hc_nis_poor agshare_poor
	cross using ./temp/agcorrect.dta
	save ./temp/agcorrect.dta, replace
	restore

	* NIS, poorest countries, impute wage. 
	keep if gdpcat == 1
	preserve
	collapse (mean) agshare_poorest = empshare_wdi [aw=weight]
	save ./temp/empshare_wdi.dta, replace
	restore
	
	gen hc_share0 = 1 - diff/loggdp2005
	gen hc_share1 = 1 - (diff + 0.532)/loggdp2005
	gen hc_share2 = 1 - (diff + 2*0.532)/loggdp2005
	collapse (mean) hc_share* [aw=weight]
	cross using ./temp/empshare_wdi
	gen hc_nis_poorest_1 = hc_share0*(1-agshare_poorest) + hc_share1*agshare_poorest
	gen hc_nis_poorest_2 = hc_share0*(1-agshare_poorest) + hc_share2*agshare_poorest
	keep hc_nis* agshare_poorest
	cross using ./temp/agcorrect.dta
	export delimited using ./output/agcorrect.csv, replace

*
* 8.7: Sectoral development accounting: agriculture
*

	use ./temp/nis_analysis.dta, clear
	gen oldagdum = 1 if oldbocc == 19
	replace oldagdum = 0 if oldbocc != 19
	append using ./temp/mmp_lamp.dta
	keep if gdpcat <= 3 | iso == "MEX"
	keep if oldagdum == 1
	merge m:1 iso using ./temp/caselli.dta

	gen diff_a = diff - log(cola) + log(ratio_ppp_nom_a)
	gen hc_share_a = 1 - diff/log(ya)

	collapse (mean) hc_share_a (sd) sigma_a = hc_share_a (count) num_a = hc_share_a [aw=weight]
	gen se = sigma/sqrt(num)
	gen lower = hc_share_a - 1.96*se
	gen upper = hc_share_a + 1.96*se
	gen title = "Ag only" 
	keep hc_share lower upper num title

	export delimited using ./output/sectoral_accounting.csv, replace


/*

*************************************************************************************
*************************************************************************************
*************************************************************************************

Step 9: Selection

*************************************************************************************
*************************************************************************************
*************************************************************************************

*/

*
* 9.1: Selection
*

	* H based on observables
	use ./temp/nis_analysis.dta, clear
	cross using ./temp/estimates_1.dta
	gen agecat = 5*floor(age/5)
	replace agecat = 65 if agecat > 65
	gen loghobs = yrschl*estimate_yrschl
	forvalues x = 15(5)65 {
		replace loghobs = loghobs + estimate`x' if agecat == `x'
	}
	
	* Birth country average h
	merge m:1 iso using ./temp/h_nonmig_1.dta
	gen selection_observables = loghobs - loghnonmig
	
	collapse (mean) oldlogwage loggdp2005 selection_observables diff [aw=weight], by(gdpcat)
	cross using ./temp/usmeanwage.dta
	gen selection = exp(oldlogwage - (usmeanlogwage - loggdp2005))
	replace selection_observables= exp(selection_observables)
	gen residual_selection = selection/selection_observables
	replace diff = exp(diff)
	li
	
	graph bar selection residual_selection, over(gdpcat) ytitle("Selection") ylabel(0(1)6) plotregion(margin(sides)) legend(rows(1) label(1 "Total Selection") label(2 "Selection on Unobservables")) b1title("PPP GDP per worker relative to U.S., 2005") b1title("PPP GDP per worker relative to U.S., 2005")
	graph export ./output/baseline/residualized_selection.pdf, replace

*
* 9.2: Selection: MP
*

	use ./temp/mmp_lamp.dta, clear
	cross using ./temp/estimates_1.dta
	gen agecat = 5*floor((incwage_usyear - yrborn)/5)
	replace agecat = 65 if agecat > 65
	gen loghobs = edyrs*estimate_yrschl
	forvalues x = 15(5)65 {
	replace loghobs = loghobs + estimate`x' if agecat == `x'
	}
	merge m:1 iso using ./temp/h_nonmig_1.dta
	keep if _merge == 3
	gen selection_observables = loghobs - loghnonmig

	gen mexdum = 1 if iso == "MEX"
	replace mexdum = 0 if iso != "MEX"
	collapse (mean) oldlogwage loggdp2005 selection_observables [aw=weight], by(mexdum)

	cross using ./temp/usmeanwage.dta
	gen selection = exp(oldlogwage - (usmeanlogwage - loggdp2005))
	replace selection_observables= exp(selection_observables)
	gen residual_selection = selection/selection_observables

	label define mexlbl 0 "Latin American MP"
	label define mexlbl 1 "Mexican MP", add
	label values mexdum mexlbl

	graph bar selection residual_selection, over(mexdum) ytitle("Selection") ylabel(0(1)6) plotregion(margin(sides)) legend(rows(1) label(1 "Total Selection") label(2 "Selection on Unobservables")) b1title("Subsample")
	
	graph export ./output/baseline/residualized_selection_mp.pdf, replace

*
* 9.3: Selection: occupation and employment status before migration
*

	* Self–employment among those with pre–migration wages. 
	use ./temp/nis_analysis.dta, clear
	drop if oldclasswkr == 3
	replace oldclasswkr = 0 if oldclasswkr == 2
	collapse (mean) oldclasswkr [aw=weight], by(gdpcat)
	list
	
	* Education. 
	use ./temp/nis_analysis.dta, clear
	gen yrschl_for = yrschl - yrschl_us if yrschl_us > = 0
	gen colldum = 1 if educcat == 5
	gen hsdropdum = 1 if educcat <= 2
	replace colldum = 0 if educcat >= 1 & educcat <= 4
	replace hsdropdum = 0 if educcat >= 3 & educcat <= 5
	collapse (mean) yrschl yrschl_for yrschl_us hsdropdum colldum [aw=weight], by(gdpcat)
	list
	
	use ./temp/nis_analysis.dta, clear
	drop if missing(gdpcat)
	gen count = 1
	collapse (sum) count [aw=weight], by(oldbocc gdpcat)
	reshape wide count, i(oldbocc) j(gdpcat)
	drop if missing(oldbocc)
	export delimited using "./output/occupation_gdp.csv", replace

	
*
* 9.4: Replicate Hendricks (2002)
*

	* NIS only
	use ./temp/nis_analysis.dta, clear
	
	* Keep immigrants
	drop if missing(diff)
	gen yrschl_high = max(0,yrschl-12)
	gen agebin = 5*floor(age/5)
	replace agebin = 65 if agebin > 65
	
	cross using ./temp/estimates_1.dta
	gen residual = newlogwage - yrschl*estimate_yrschl
	forvalues x = 15(5)65 {
		replace residual = residual - estimate`x' if agebin == `x'
	}
	drop estimate*
	replace loggdp2005 = -loggdp2005
	collapse (mean) residual* loggdp2005 (count) n=weight [aw=weight], by(iso)
	reg residual loggdp2005
	reg residual loggdp2005 if n > 1
	reg residual loggdp2005 if n >= 5
	reg residual loggdp2005 if n >= 10

	* NIS + MP
	use ./temp/nis_analysis.dta, clear
	append using ./temp/mmp_lamp.dta
	drop if missing(diff)
	gen yrschl_high = max(0,yrschl-12)
	gen agebin = 5*floor(age/5)
	replace agebin = 65 if agebin > 65
	cross using ./temp/estimates_1.dta
	gen residual = newlogwage - yrschl*estimate_yrschl
	forvalues x = 15(5)65 {
		replace residual = residual - estimate`x' if agebin == `x'
	}
	drop estimate*
	replace loggdp2005 = -loggdp2005
	collapse (mean) residual* loggdp2005 (count) n=weight [aw=weight], by(iso)
	reg residual loggdp2005

*
* 9.5: Test selection assumptions: Schoellman (2012)
*

	* H based on observables
	use ./temp/nis_analysis.dta, clear
	append using ./temp/mmp_lamp.dta
	drop if missing(educcat) | missing(diff)
	cross using ./temp/estimates_1.dta
	gen agecat = 5*floor(age/5)
	replace agecat = 65 if agecat > 65
	gen loghobs = yrschl*estimate_yrschl
	forvalues x = 15(5)65 {
		replace loghobs = loghobs + estimate`x' if agecat == `x'
	}
	
	* Birth country average h
	merge m:1 iso using ./temp/h_nonmig_1.dta
	gen selection_todd = loghobs - loghnonmig
	
	collapse (mean) oldlogwage loggdp2005 selection_todd [aw=weight], by(gdpcat educcat)
	cross using ./temp/usmeanwage.dta
	gen selection = exp(oldlogwage - (usmeanlogwage - loggdp2005))
	replace selection_todd = exp(selection_todd)
	gen residual_selection = selection/selection_todd
	
	keep residual_selection gdpcat educcat
	reshape wide residual_selection, i(gdpcat) j(educcat)
	
	graph bar residual_selection*,  over(gdpcat) ytitle("Residual Selection") ylabel(0(1)3) plotregion(margin(sides)) b1title("Education X PPP GDP per worker relative to U.S., 2005") legend(rows(2) label(1 "No H.S.") label(2 "Some H.S.") label(3 "H.S. Grad") label(4 "Some Coll.") label(5 "Coll. Grad"))
	graph export ./output/baseline/residualized_selection_todd.pdf, replace

/*

*************************************************************************************
*************************************************************************************
*************************************************************************************

Step 10: Skill Loss and Skill Transfer

*************************************************************************************
*************************************************************************************
*************************************************************************************

*/	

*
* 10.1: Occupation and industry change
*

	use ./temp/nis_analysis.dta, clear
	
	gen occ_change = 1 if oldocc != newocc & oldocc > 0 & newocc > 0 & !missing(oldocc) & !missing(newocc)
	replace occ_change = 0 if oldocc == newocc & oldocc > 0 & !missing(oldocc)
	
	gen bocc_change = 1 if oldbocc != newbocc & oldbocc > 0 & newbocc > 0 & !missing(oldbocc) & !missing(newbocc)
	replace bocc_change = 0 if oldbocc == newbocc & oldbocc > 0 & !missing(oldbocc)
	
*
* 10.2: Value of occupation and industry changes, as implied by mean native wages. 
*

	merge m:1 oldocc using ./temp/meanwage_oldocc.dta
	drop if _merge == 2
	drop _merge*
	merge m:1 newocc using ./temp/meanwage_newocc.dta
	drop if _merge == 2
	drop _merge*
	
	gen occ_upgrade = 1 if wage_newocc > wage_oldocc & !missing(wage_newocc) & !missing(wage_oldocc)
	gen occ_downgrade = 1 if wage_newocc < wage_oldocc & !missing(wage_newocc) & !missing(wage_oldocc)
	replace occ_upgrade = 0 if wage_newocc <= wage_oldocc & !missing(wage_newocc) & !missing(wage_oldocc)
	replace occ_downgrade = 0 if wage_newocc >= wage_oldocc & !missing(wage_newocc) & ! missing(wage_oldocc)
	
	gen occ_change2 = exp(wage_newocc - wage_oldocc)-1 
	
	* Merge on occupation ratings for the round 2 occupations.
	drop newocc wage_newocc
	rename occ5 newocc
	merge m:1 newocc using ./temp/meanwage_newocc.dta
	drop if _merge == 2
	drop _merge*
	gen occ_change_last = exp(wage_newocc - wage_oldocc)-1
	
	save ./temp/nis_occ.dta, replace	
	collapse (mean) bocc_change occ_change* occ_upgrade occ_downgrade (mean) meanocc = occ_change2 if !missing(diff) [aw=weight], by(gdpcat)
	export delimited using "./output/skilltransfer.csv", replace

*
* 10.3: Downgrading and English. 
*

	use ./temp/nis_occ.dta, clear	
	keep if gdpcat <= 3
	drop if missing(english)
	collapse (mean) bocc_change occ_change* occ_upgrade occ_downgrade (mean) meanocc = occ_change2 if !missing(diff) [aw=weight], by(english)
	save ./temp/nis_english.dta, replace


	use ./temp/nis_occ.dta, clear	
	keep if gdpcat <= 3
	drop if missing(english_work)
	collapse (mean) bocc_change occ_change* occ_upgrade occ_downgrade (mean) meanocc = occ_change2 if !missing(diff) [aw=weight], by(english_work)
	append using ./temp/nis_english.dta
	export delimited using "./output/skilltransfer_english.csv", replace
	
*	
* 10.4: How does downgrading change over time?
*

	use ./temp/nis_analysis.dta, clear
	keep if gdpcat <= 3
	
	merge m:1 oldocc using ./temp/meanwage_oldocc.dta
	drop if _merge == 2
	drop _merge* newocc
	
	rename occ3 newocc
	merge m:1 newocc using ./temp/meanwage_newocc.dta
	drop if _merge == 2
	drop _merge*
	gen occ_change3 = exp(wage_newocc - wage_oldocc)-1 
	drop newocc wage_newocc
	
	rename occ4 newocc
	merge m:1 newocc using ./temp/meanwage_newocc.dta
	drop if _merge == 2
	drop _merge*
	gen occ_change4 = exp(wage_newocc - wage_oldocc)-1 
	drop newocc wage_newocc	
	
	rename occ5 newocc
	merge m:1 newocc using ./temp/meanwage_newocc.dta
	drop if _merge == 2
	drop _merge*
	gen occ_change5 = exp(wage_newocc - wage_oldocc)-1 
	drop newocc wage_newocc	
	
	collapse (mean) occ_change3 occ_change4 occ_change5 if !missing(diff) [aw=weight]
	export delimited using "./output/skilltransfer_assimilation.csv", replace
	
*
* 10.5: Baseline Development Accounting
*
 
	use ./temp/nis_analysis.dta, clear
	keep if gdpcat <= 3
	gen hc_share = 1- diff/loggdp2005
	collapse (mean) hc_share newlogwage (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	gen meanimmwage = exp(newlogwage)
	
	keep hc_share lower upper meanimmwage
	gen title = "baseline"
	save ./temp/robustness.dta, replace
	
*
* 10.6: Development accounting with alternative wages.
*		Assign each "downgraded" worker the mean wage of their pre–migration occupation
*

	use ./temp/nis_occ.dta, clear
	replace newlogwage = newlogwage + (wage_oldocc - wage_newocc) if wage_oldocc > wage_newocc
	keep if gdpcat <= 3
	replace diff = newlogwage - oldlogwage
	gen hc_share = 1- diff/loggdp2005
	collapse (mean) hc_share newlogwage (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	gen meanimmwage = exp(newlogwage)
	
	keep hc_share lower upper meanimmwage
	gen title = "Mean Skill Transfer for Downgrades"
	append using ./temp/robustness.dta
	save ./temp/robustness.dta, replace
	
*
* 10.7: Development accounting with alternative wages.
*		Assign each "downgraded" worker the mean wage + sigma for their pre–migration occupation.
*

	use ./temp/nis_occ.dta, clear
	replace newlogwage = newlogwage + (wage_oldocc + sigma_wage_oldocc - wage_newocc) if wage_oldocc > wage_newocc
	keep if gdpcat <= 3
	replace diff = newlogwage - oldlogwage
	gen hc_share = 1- diff/loggdp2005
	collapse (mean) hc_share newlogwage (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	gen meanimmwage = exp(newlogwage)
	
	keep hc_share lower upper meanimmwage
	gen title = "Mu + Sigma"
	append using ./temp/robustness.dta
	save ./temp/robustness.dta, replace

	export delimited using "./output/robustness_skilltransfer.csv", replace

*
* 10.8: Comparison of immigrant to native wages for non–switchers. 
*	

	use ./temp/nis_occ.dta, replace
	gen ratio = exp(newlogwage - wage_newocc) if occ_change == 0
	keep if gdpcat <= 3
	collapse (mean) meanratio = ratio (median) medianratio = ratio [aw=weight]
	list

/*

*************************************************************************************
*************************************************************************************
*************************************************************************************

Step 11: Use NIS-provided PPP adjustments instead. 

*************************************************************************************
*************************************************************************************
*************************************************************************************

*/

*
* 11.1: Create wage gains at migration, define GDP category. 
*

	use ./temp/nis_all_obs.dta, clear
	drop diff* incwage_refyear incwage_refyearus currency gdpcat gdp loggdp loggdp2005 oldocc newocc oldbocc newbocc oldind oldlogwage newlogwage oldlogwage_unadj oldclasswkr newclasswkr labcountry flag_inflation flag_inflationever flag_devaluation flag_match iso
		
	* Define wage gains at migration, based on different comparisons. 
	gen diff42 = logwage4 - logwageppp2 if !missing(gdp20052) & (flag_devaluation2 == 0 | incwage_refyear2 > devaluation_year2) & incwage_refyear2 >= 1983 & logwage4 > log(0.01) & logwageppp2 > log(0.01) & logwage4 < log(1000) & logwageppp2 < log(1000) & (labcountry4 == 218 | missing(labcountry4)) & labcountry2 != 218 & yrschl_us <= 0 & educcountry != 218
	gen diff41 = logwage4 - logwageppp1 if !missing(gdp20051) & (flag_devaluation1 == 0 | incwage_refyear1 > devaluation_year1) & incwage_refyear1 >= 1983 & logwage4 > log(0.01) & logwageppp1 > log(0.01) & logwage4 < log(1000) & logwageppp1 < log(1000) & (labcountry4 == 218 | missing(labcountry4)) & labcountry1 != 218 & yrschl_us <= 0 & educcountry != 218
	gen diff32 = logwage3 - logwageppp2 if !missing(gdp20052) &  (flag_devaluation2 == 0 | incwage_refyear2 > devaluation_year2) & incwage_refyear2 >= 1983 & logwage3 > log(0.01) & logwageppp2 > log(0.01) & logwage3 < log(1000) & logwageppp2 < log(1000) & labcountry2 != 218 & yrschl_us <= 0 & educcountry != 218
	gen diff31 = logwage3 - logwageppp1 if !missing(gdp20051) &  (flag_devaluation1 == 0 | incwage_refyear1 > devaluation_year1) & incwage_refyear1 >= 1983 & logwage3 > log(0.01) & logwageppp1 > log(0.01) & logwage3 < log(1000) & logwageppp1 < log(1000) & labcountry1 != 218 & yrschl_us <= 0 & educcountry != 218
	gen diff52 = logwage5 - logwageppp2 if !missing(gdp20052) &  (flag_devaluation2 == 0 | incwage_refyear2 > devaluation_year2) & incwage_refyear2 >= 1983 & logwage5 > log(0.01) & logwageppp2 > log(0.01) & logwage5 < log(1000) & logwageppp2 < log(1000) & labcountry2 != 218 & labcountry5 == 218 & newschool == 0
	gen diff51 = logwage5 - logwageppp1 if !missing(gdp20051) &  (flag_devaluation1 == 0 | incwage_refyear1 > devaluation_year1) & incwage_refyear1 >= 1983 & logwage5 > log(0.01) & logwageppp1 > log(0.01) & logwage5 < log(1000) & logwageppp1 < log(1000) & labcountry1 != 218 & labcountry5 == 218 & newschool == 0
	
	* Define baseline wage gain at migration.  Preference: for post migration, 4 to 3 to 5.  For pre-migration, 2 to 1. 
	gen diff = .
	gen incwage_refyear = .
	gen incwage_refyearus = .
	gen currency = .
	gen gdpcat = .
	gen gdp = .
	gen loggdp = .
	gen loggdp2005 = .
	gen oldocc = .
	gen newocc = .
	gen oldbocc = .
	gen newbocc = .
	gen oldind = .
	gen oldlogwage = .
	gen newlogwage = .
	gen oldlogwage_unadj = .
	gen oldclasswkr = .
	gen newclasswkr = .
	gen labcountry = .
	gen flag_inflation = .
	gen flag_inflationever = .
	gen flag_devaluation = .
	gen flag_match = .
	gen iso = ""
	foreach x in "4" "3" "5" {
		foreach y in "2" "1" {
			replace incwage_refyear = incwage_refyear`y' if missing(diff) & !missing(diff`x'`y')
			replace incwage_refyearus = incwage_refyear`x' if missing(diff) & !missing(diff`x'`y')
			replace currency = currency`y' if missing(diff) & !missing(diff`x'`y')
			replace gdp = gdp`y' if missing(diff) & !missing(diff`x'`y')
			replace loggdp = log(gdp`y') if missing(diff) & !missing(diff`x'`y')
			replace loggdp2005 = log(gdp2005`y') if missing(diff) & !missing(diff`x'`y')
			replace gdpcat = 1 if gdp2005`y' > 16 & !missing(gdp2005`y') & missing(diff) & !missing(diff`x'`y')
			replace gdpcat = 2 if gdp2005`y' >= 8 & gdp2005`y' < 16 & missing(diff) & !missing(diff`x'`y')
			replace gdpcat = 3 if gdp2005`y' >= 4 & gdp2005`y' < 8 & missing(diff) & !missing(diff`x'`y')
			replace gdpcat = 4 if gdp2005`y' >= 2 & gdp2005`y' < 4 & missing(diff) & !missing(diff`x'`y')
			replace gdpcat = 5 if gdp2005`y' >= 1 & gdp2005`y' < 2 & missing(diff) & !missing(diff`x'`y')
			replace oldocc = occ`y' if missing(diff) & !missing(diff`x'`y')
			replace newocc = occ`x' if missing(diff) & !missing(diff`x'`y')
			replace oldbocc = bocc`y' if missing(diff) & !missing(diff`x'`y')
			replace newbocc = bocc`x' if missing(diff) & !missing(diff`x'`y')
			replace oldind = ind`y' if missing(diff) & !missing(diff`x'`y')
			replace oldlogwage = logwage`y' if missing(diff) & !missing(diff`x'`y')
			replace newlogwage = logwage`x' if missing(diff) & !missing(diff`x'`y')
			replace oldlogwage_unadj = logwage_unadj`y' if missing(diff) & !missing(diff`x'`y')
			replace iso = iso`y' if missing(diff) & !missing(diff`x'`y')
			replace oldclasswkr = classwkr`y' if missing(diff) & !missing(diff`x'`y')
			replace newclasswkr = classwkr`x' if missing(diff) & !missing(diff`x'`y')
			replace labcountry = labcountry`y' if missing(diff) & !missing(diff`x'`y')
			replace flag_inflation = flag_inflation`y' if missing(diff) & !missing(diff`x'`y')
			replace flag_inflationever = flag_inflationever`y' if missing(diff) & !missing(diff`x'`y')
			replace flag_devaluation = flag_devaluation`y' if missing(diff) & !missing(diff`x'`y')
			replace flag_match = flag_match`y' if missing(diff) & !missing(diff`x'`y')
			replace diff = diff`x'`y' if missing(diff) & !missing(diff`x'`y')
		}
	}
	
*
* 11.2: Restrict sample slightly
*

	drop if missing(diff)
	drop if missing(gdpcat)
	keep if yrschl_us <= 0 & educcountry != 218	
	
*
* 11.3: Compute wage gains at migration
*  

	keep if gdpcat <= 3
	gen hc_share = 1- diff/loggdp2005
	collapse (mean) hc_share (sd) sigma = hc_share (count) num = hc_share [aw=weight]
	
	gen se = sigma/sqrt(num)
	gen lower = hc_share - 1.96*se
	gen upper = hc_share + 1.96*se
	
	keep hc_share lower upper num
	list
	
*
* Program Finished.
*
	
	