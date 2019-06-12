******************************************************************************
** file name: 	analyses.do  (manuscript + supplementary materials)			**
** purpose: 	estimations, producing tables and figures					**
** paper:		gender, political knowledge and descriptive representation	**
** date: 		september 2017												**
** authors: 	Ruth Dassonneville and Ian McAllister						**
******************************************************************************


** install commands ( if not installed yet) and set scheme for graphs 

ssc install loevh, replace all
ssc install estout, replace all
ssc install blindschemes, replace all
set scheme plotplain, permanently					// sets daniel bischof's plottig scheme as the default scheme for graphs


**********************************
** MAIN RESULTS (MANUSCRIPT)	**
**********************************


** FIGURE 1, GENDER GAP IN POLITICAL KNOWLEDGE BY SAMPLE

	* CSES data
	use  "CSES_gender_knowledge_ajpsreplication.dta", clear
	
	drop if polknowledge==.
	
	encode A1004, gen(election) 
	order election, before(A1004)
	numlabel, add force
	tab election
	
	set more off
	tempname gender_bivariate
	
	postfile `gender_bivariate' sample b_female se_female using gender_bivariate.dta, replace
	
	foreach lname of numlist 1(1)106 {  		// loop to repeat the same command for each election sample
		local t : label election `lname'
		noisily reg polknowledge female if election==`lname' 
		post `gender_bivariate' (`lname') (`=_b[female]') (`=_se[female]')
		}
		
	postclose `gender_bivariate'
		
	use "gender_bivariate.dta", clear
	sort b_female
	gen order= _n
	sort sample
	
	* add sample labels to the dataset
	label define electionlabel 4 "ALB 2005" 103 "AUS 1996" 52 "AUS 2004" 102 "AUS 2007" ///
	96 "AUT 2008" 9	"BEL 1999" 60 "BEL 2003" 49	"BRA 2002" 46 "BRA 2006" 57 "BRA 2010" ///
	59 "CAN 1997" 19 "CAN 2004" 71 "CAN 2008" 3 "CHE 1999" 8 "CHE 2003" 5 "CHE 2007" ///
	106 "CHL 2005" 99 "CZE 1996" 95 "CZE 2002" 58 "CZE 2006" 94 "CZE 2010" 23 "DEU 1998" ///
	16 "DEU 2002" 75 "DEU 2005"  43	"DEU 2009" 12 "DNK 2007" 7 "ESP 1996" 51 "ESP 2000" ///
	35 "ESP 2004" 74 "ESP 2008" 80 "EST 2011" 21 "FIN 2003" 89 "FIN 2007" 101 "FIN 2011" ///
	24 "FRA 2002" 13 "FRA 2007" 11 "GBR 1997" 18 "GBR 2005" 1 "GRC 2009" 38 "HKG 1998" ///
	54 "HKG 2000" 82 "HKG 2004" 70 "HKG 2008" 30 "HRV 2007" 33 "HUN 1998" 79 "HUN 2002" ///
	68 "IRL 2002" 91 "IRL 2007" 41 "ISL 2007" 77 "ISL 2009" 86 "ISR 1996" 36 "ISR 2003" ///
	73 "ISR 2006" 63 "ITA 2006" 105 "JPN 2004" 65 "JPN 2007" 90	"KGZ 2005" 81 "KOR 2004" ///
	93 "KOR 2008" 87 "LVA 2010" 40 "MEX 1997" 31 "MEX 2000" 22 "MEX 2003" 85 "MEX 2006" ///
	83 "MEX 2009" 37 "NLD 1998" 78 "NLD 2002" 48 "NLD 2006" 29 "NLD 2010" 61 "NOR 1997" ///
	55 "NOR 2001" 47 "NOR 2005" 66 "NOR 2009" 53 "NZL 1996" 69 "NZL 2002" 92 "NZL 2008" ///
	6 "PER 2006" 27 "PER 2011" 72 "PHL 2004" 98	"PHL 2010" 26 "POL 1997" 14 "POL 2001" ///
	28 "POL 2005" 50 "POL 2007" 25 "PRT 2002" 20 "PRT 2005" 64 "PRT 2009" 104 "ROU 1996" ///
	97 "ROU 2004" 45 "ROU 2009" 84 "RUS 2004" 39 "SVK 2010" 34 "SVN 2004" 44 "SWE 1998" ///
	15 "SWE 2002" 100 "SWE 2006" 76 "THA 2007" 2 "TWN 1996" 32 "TWN 2001" 17 "TWN 2004" ///
	10 "TWN 2008" 67 "UKR 1998" 62 "USA 1996" 42 "USA 2004" 56 "USA 2008" 88 "ZAF 2009"


	label values order electionlabel 
	
	gen lower=b_female-(1.96*se_female)
	gen upper=b_female+(1.96*se_female)
	
	tw rspike lower upper order if order<54, hor || scatter  order b_female if order<54 , msymbol(circle)  ///
	ylabel(1(1)53, valuelabel labsize(vsmall)) ytitle("") xtitle("Estimated effect of being female", size(small)) ///
	legend(off) xlabel(-0.35(0.1).1, labsize(small)) xline(0) ysc(reverse) xsize(5) ysize(8) ///
	graphregion(margin(vsmall)) saving(cses_bivariate_1, replace)
	
	tw rspike lower upper order if order>53, hor || scatter  order b_female if order>53 , msymbol(circle)  ///
	ylabel(54(1)106, valuelabel labsize(vsmall)) ytitle("") xtitle("Estimated effect of being female", size(small)) ///
	legend(off) xlabel(-0.35(0.1).1, labsize(small)) xline(0) ysc(reverse) xsize(5) ysize(8) ///
	graphregion(margin(vsmall)) saving(cses_bivariate_2, replace)

	graph combine cses_bivariate_1.gph cses_bivariate_2.gph, col(2) xsize(7) ysize(8) graphregion(margin(vsmall))
	
	
	* EES data
	use "EES_gender_knowledge_ajpsreplication.dta" , clear
	
	drop if polknowledge_st==.
	
	encode countrycode, gen(election) 
	order election, before(countrycode) 
	numlabel, add force
	tab election
	
	set more off
	tempname gender_bivariate2
	
	postfile `gender_bivariate2' sample b_female se_female using gender_bivariate2.dta, replace
	
	foreach lname of numlist 1(1)27 {  	// loop to repeat the same command for each country
		local t : label election `lname'
		noisily reg polknowledge_st female if election==`lname' 
		post `gender_bivariate2' (`lname') (`=_b[female]') (`=_se[female]')
		}
		
	postclose `gender_bivariate2'
	
	use "gender_bivariate2.dta", clear
	sort b_female
	gen order= _n
	sort sample

	* add sample labels to the dataset
	label define countrylabel 12 "AT" 21 "BE" 22 "BG" 2 "CY" 20 "CZ" 4 "DE" ///
	16 "DK" 26 "EE" 15 "EL" 6 "ES" 23 "FI" 8 "FR" 18 "HU" 7 "IE" 17 "IT" 24 "LT" ///
	11 "LU" 27 "LV" 1 "MT" 9 "NL" 13 "PL" 3 "PT" 10 "RO" 19 "SE" 14 "SI" 25 "SK" 5 "UK"
	
	label values order countrylabel 
	
	gen lower=b_female-(1.96*se_female)
	gen upper=b_female+(1.96*se_female)
	
	tw rspike lower upper order , hor || scatter  order b_female  , msymbol(circle)  ///
	ylabel(1(1)27, valuelabel labsize(vsmall)) ytitle("") xtitle("Estimated effect of being female", size(small)) ///
	legend(off) xlabel(-0.35(0.1).1, labsize(small)) xline(0) ysc(reverse) xsize(3) ysize(5) ///
	graphregion(margin(vsmall)) saving(ees_bivariate, replace)
	

	

** TABLE 1, EXPLAINING THE GENDER GAP - CSES DATA (+ Figure 3 and 5)

	use  "CSES_gender_knowledge_ajpsreplication.dta", clear
	
	drop if polknowledge==.
	
	split A1004, p("_")
	drop A10042
	rename A10041 iso
	
	egen cohort = cut(birthyear), at(1900 1905 1910 1915 1920 1925 1930 1935 1940 1945 1950 1955 1960 1965 1970 1975 1980 1985 1990 1995 2000)
	replace cohort=1910 if cohort==1905
	replace cohort=1910 if cohort==1900
	
	* Model 1 - main effect, gender gap 
	set more off
		
	xtmixed polknowledge i.female age college i.female##c.lsq i.female##c.democ	i.female##c.gdp_growth ///
	i.female##i.Z_Qcontent i.female##i.womencontent i.female##i.Qstructure i.svy_mode ///
	|| iso: || A1004: || cohort: if women_parliament_survey!=. & women_parliament_18_21!=., var
	
	eststo M1
	sum women_parliament_survey if e(sample)==1
	sum women_parliament_18_21 if e(sample)==1

	* Model 2 - interaction women survey year
		
		* estimate model
	xtmixed polknowledge i.female##c.women_parliament_survey age college i.female##c.lsq i.female##c.democ	i.female##c.gdp_growth ///
	i.female##i.Z_Qcontent i.female##i.womencontent i.female##i.Qstructure i.svy_mode ///
	|| iso: || A1004: || cohort: if women_parliament_survey!=. & women_parliament_18_21!=., var
	eststo M2
	
		* calculate marginal effects and construct Figure 3 (upper panel)
	margins , dydx(female)  at(women_parliament_survey=(6(2)46)) 
	
	marginsplot, level(95)  yline(0) recast(line) recastci(rline)  xtitle("% Women in Parliament in survey year") ///
	addplot(hist women_parliament_survey if e(sample)==1, percent bin(30) yaxis(2) yscale(axis(2) alt  )   yscale(range(0(10)100) axis(2)) ///
	yscale(range(-0.14(0.02)-0.06) axis(1)) ytitle("Percentage of observations", axis(2)) )  ///
	ytitle("AME Female")  legend(off) title("% Women in Parliament in survey year") saving(CSES_survey, replace)
	

	* Model 3 - interaction women, formative years
		
		* estimate model
	xtmixed polknowledge i.female##c.women_parliament_survey i.female##c.women_parliament_18_21 age college i.female##c.lsq i.female##c.democ	i.female##c.gdp_growth ///
	i.female##i.Z_Qcontent i.female##i.womencontent i.female##i.Qstructure i.svy_mode ///
	|| iso: || A1004: || cohort: if women_parliament_survey!=. & women_parliament_18_21!=., var
	eststo M3
	
		* calculate marginal effects and construct Figure 3 (lower panel)
	margins , dydx(female)  at(women_parliament_18_21=(0(2)46)) 
	
	marginsplot, level(95)  yline(0) recast(line) recastci(rline)  xtitle("% Women in Parliament at 18-21 years") ///
	addplot(hist women_parliament_18_21, percent bin(30) yaxis(2) yscale(axis(2) alt  )   yscale(range(0(10)100) axis(2)) ///
	yscale(range(-0.14(0.02)-0.06) axis(1)) ytitle("Percentage of observations", axis(2)) ) ///
	ytitle("AME Female")  legend(off) title("% Women in Parliament at 18-21 years") saving(CSES_formative, replace)
	
		* calculate marginal effects for Figure 5 - focus on predicted levels for men and women
	margins ,  at(women_parliament_18_21=(0(2)46)) over(female)
	marginsplot, level(95) xtitle("% Women in Parliament at 18-21 years") saving(CSES_menwomen, replace)


	* Compile table
	
		/* General note on tables: esttab command is used for compiling table with coefficients and
		standard errors. This raw output has been manually edited further, e.g., variable names. The
		relevant information on the number of observations and the variance components (sigma squared)
		are obtained from the standard Stata-output and manually added to the table */
		
	esttab M1 M2 M3 using table1.rtf, b(3) se(3) nogap wide replace
	
	
	
		

* TABLE 2, EXPLAINING THE GENDER GAP - EES 2009 DATA (+ Figure 4 and 6)

	use "EES_gender_knowledge_ajpsreplication.dta" , clear
	
	egen cohort = cut(birthyear), at(1900 1905 1910 1915 1920 1925 1930 1935 1940 1945 1950 1955 1960 1965 1970 1975 1980 1985 1990 1995 2000)
	replace cohort=1920 if cohort==1915
	replace cohort=1920 if cohort==1910
	
	* Model 1 - main effect gender gap
		
	xtmixed polknowledge_st i.female age edu  i.female##c.lsq_prev i.female##c.gdp_growth i.svy_mode || countrycode: || cohort: ///
	if women_parliament_survey!=. & women_parliament_18_21!=., var
	eststo M1
	
	* Model 2 - interaction women survey year
	
		* estimate model
	xtmixed polknowledge_st i.female##c.women_parliament_survey age edu  i.female##c.lsq_prev i.female##c.gdp_growth i.svy_mode || countrycode: || cohort: ///
	if women_parliament_survey!=. & women_parliament_18_21!=., var
	eststo M2

		* calculate marginal effects and construct Figure 4 (upper panel)
	margins , dydx(female)  at(women_parliament_survey=(8(2)47))
	marginsplot, level(95)  yline(0) recast(line) recastci(rline)  xtitle("% Women in Parliament in survey year") ///
	addplot(hist women_parliament_survey if e(sample)==1, percent bin(30) yaxis(2) yscale(axis(2) alt  )   yscale(range(0(10)100) axis(2)) ///
	yscale(range(-0.16(0.02)-0.02) axis(1)) ytitle("Percentage of observations", axis(2)) ) xsize(6) ysize(4) ///
	ytitle("AME Female")  legend(off) title("% Women in Parliament in survey year") saving(EES_survey, replace)

	
	* Model 3 - interaction women formative years
		
		* estimate model
	xtmixed polknowledge_st i.female##c.women_parliament_survey i.female##c.women_parliament_18_21 age edu  i.female##c.lsq_prev i.female##c.gdp_growth i.svy_mode || countrycode: || cohort: ///
	if women_parliament_survey!=. & women_parliament_18_21!=., var
	eststo M3

		* calculate marginal effects and construct Figure 4 (lower panel)
	margins , dydx(female)  at(women_parliament_18_21=(0(2)47))
	marginsplot, level(95)  yline(0) recast(line) recastci(rline)  ytitle("AME Female", axis(1)) ///
	addplot(hist women_parliament_18_21 if e(sample)==1, percent bin(40) yaxis(2) yscale(axis(2) alt  )   yscale(range(0(10)100) axis(2)) ///
	yscale(range(-0.16(0.02)-0.02) axis(1)) ytitle("Percentage of observations", axis(2)) )  xlabel(0(2)47) ylabel(-0.15(0.05)0.01) ///
	xtitle("% Women in Parliament at 18-21 years")  legend(off) title("% Women in Parliament at 18-21 years") saving(EES_formative, replace)

	
		* calculate marginal effects for Figure 5 - focus on predicted levels for men and women
	margins ,  at(women_parliament_18_21=(0(2)47)) over(female)
	marginsplot, level(95) xtitle("% Women in Parliament at 18-21 years") saving(EES_menwomen, replace)
	
	* Compile table
	esttab M1 M2 M3 using table2.rtf, b(3) se(3) nogap wide replace



	
	
**********************************
** SUPPLEMENTARY MATERIALS 		**
**********************************


** APPENDIX 1 - descriptives 

	* CSES
	use  "CSES_gender_knowledge_ajpsreplication.dta", clear
	keep if polknowledge!=.

	egen cohort = cut(birthyear), at(1900 1905 1910 1915 1920 1925 1930 1935 1940 1945 1950 1955 1960 1965 1970 1975 1980 1985 1990 1995 2000)
	replace cohort=1910 if cohort==1905
	replace cohort=1910 if cohort==1900
	
	reg  polknowledge i.female  age college  i.female##c.lsq  i.female##c.democ  i.female##c.gdp_growth ///
	i.female##i.Z_Qcontent i.female##i.womencontent i.female##i.Qstructure i.svy_mode i.cohort ///
	if women_parliament_survey!=. & women_parliament_18_21!=. 
	
	sum polknowledge i.female  age college  lsq  democ gdp_growth ///
	i.Z_Qcontent i.womencontent i.Qstructure i.svy_mode women_parliament_survey women_parliament_18_21 if e(sample)==1
	
	* EES
	use "EES_gender_knowledge_ajpsreplication.dta" , clear
	
	reg polknowledge_st i.female women_parliament_survey women_parliament_18_21 age edu  lsq_prev i.svy_mode  ///
	if women_parliament_survey!=. & women_parliament_18_21!=.
	
	sum polknowledge_st i.female women_parliament_survey women_parliament_18_21 age edu  lsq_prev i.svy_mode if e(sample)==1


	
** APPENDIX 2 is description of the operationalization of the key independent variable: percent women in parliament during formative years


** APPENDIX 3 - scaling statistics
	
	* CSES DATA *
	use  "CSES_gender_knowledge_ajpsreplication.dta", clear
	keep if polknowledge!=.
	
	split A1004, p("_")
	drop A10042
	rename A10041 iso
	
	** coding knowledge items
	gen polinfo1=polinfo1_mod1 if Module==1
	replace polinfo1=polinfo1_mod2 if Module==2
	replace polinfo1=polinfo1_mod3 if Module==3
	
	gen polinfo2=polinfo2_mod1 if Module==1
	replace polinfo2=polinfo2_mod2 if Module==2
	replace polinfo2=polinfo2_mod3 if Module==3
	
	gen polinfo3=polinfo3_mod1 if Module==1
	replace polinfo3=polinfo3_mod2 if Module==2
	replace polinfo3=polinfo3_mod3 if Module==3
	
	
	** Cronbach's alpha /Loevinger's H 
	alpha polinfo1 polinfo2 polinfo3 if A1004=="USA_2004"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="USA_2004"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="LVA_2010"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="LVA_2010"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="USA_2008"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="USA_2008"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="THA_2007"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="THA_2007"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="ZAF_2009"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="ZAF_2009"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="KGZ_2005"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="KGZ_2005"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="TWN_2008"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="TWN_2008"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="TWN_2001"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="TWN_2001"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="RUS_2004"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="RUS_2004"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="ALB_2005"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="ALB_2005"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="ITA_2006"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="ITA_2006"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="ISL_2007"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="ISL_2007"
	return list	

	alpha polinfo1 polinfo2 polinfo3 if A1004=="POL_2007"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="POL_2007"
	return list

	alpha polinfo1 polinfo2 polinfo3 if A1004=="MEX_1997"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="MEX_1997"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="NLD_2002"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="NLD_2002"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="NLD_2010"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="NLD_2010"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="ROU_2009"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="ROU_2009"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="ESP_2000"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="ESP_2000"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="ESP_2004"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="ESP_2004"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="NLD_2006"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="NLD_2006"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="IRL_2002"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="IRL_2002"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="ISL_2009"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="ISL_2009"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="HRV_2007"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="HRV_2007"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="BEL_1999"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="BEL_1999"
	return list	
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="SVN_2004"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="SVN_2004"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="NOR_2001"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="NOR_2001"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="ROU_2004"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="ROU_2004"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="PRT_2005"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="PRT_2005"
	return list

	alpha polinfo1 polinfo2 polinfo3 if A1004=="POL_2005"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="POL_2005"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="POL_2001"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="POL_2001"
	return list	
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="BRA_2002"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="BRA_2002"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="PRT_2002"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="PRT_2002"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="PER_2006"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="PER_2006"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="TWN_2004"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="TWN_2004"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="MEX_2009"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="MEX_2009"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="DEU_2009"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="DEU_2009"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="HUN_1998"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="HUN_1998"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="GRC_2009"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="GRC_2009"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="MEX_2003"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="MEX_2003"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="KOR_2008"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="KOR_2008"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="EST_2011"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="EST_2011"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="DEU_1998"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="DEU_1998"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="SWE_1998"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="SWE_1998"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="NOR_2009"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="NOR_2009"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="CAN_2004"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="CAN_2004"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="BRA_2010"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="BRA_2010"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="AUT_2008"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="AUT_2008"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="CAN_1997"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="CAN_1997"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="BEL_2003"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="BEL_2003"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="SVK_2010"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="SVK_2010"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="POL_1997"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="POL_1997"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="KOR_2004"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="KOR_2004"
	return list	
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="MEX_2006"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="MEX_2006"
	return list

	alpha polinfo1 polinfo2 polinfo3 if A1004=="HUN_2002"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="HUN_2002"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="HKG_1998"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="HKG_1998"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="ISR_2003"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="ISR_2003"
	return list	
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="MEX_2000"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="MEX_2000"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="ESP_2008"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="ESP_2008"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="BRA_2006"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="BRA_2006"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="PER_2011"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="PER_2011"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="HKG_2000"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="HKG_2000"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="GBR_2005"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="GBR_2005"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="SWE_2002"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="SWE_2002"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="CHE_2007"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="CHE_2007"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="NZL_1996"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="NZL_1996"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="CZE_2006"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="CZE_2006"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="FRA_2007"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="FRA_2007"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="NOR_1997"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="NOR_1997"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="CHE_1999"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="CHE_1999"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="HKG_2008"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="HKG_2008"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="FIN_2003"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="FIN_2003"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="ESP_1996"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="ESP_1996"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="NOR_2005"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="NOR_2005"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="AUS_2004"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="AUS_2004"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="CHE_2003"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="CHE_2003"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="IRL_2007"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="IRL_2007"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="DEU_2002"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="DEU_2002"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="GBR_1997"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="GBR_1997"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="ISR_2006"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="ISR_2006"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="PRT_2009"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="PRT_2009"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="NLD_1998"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="NLD_1998"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="FIN_2007"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="FIN_2007"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="AUS_1996"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="AUS_1996"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="CZE_1996"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="CZE_1996"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="DNK_2007"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="DNK_2007"
	return list	
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="CHL_2005"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="CHL_2005"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="CAN_2008"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="CAN_2008"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="FIN_2011"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="FIN_2011"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="NZL_2008"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="NZL_2008"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="SWE_2006"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="SWE_2006"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="PHL_2004"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="PHL_2004"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="HKG_2004"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="HKG_2004"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="AUS_2007"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="AUS_2007"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="CZE_2002"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="CZE_2002"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="CZE_2010"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="CZE_2010"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="ROU_1996"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="ROU_1996"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="FRA_2002"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="FRA_2002"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="PHL_2010"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="PHL_2010"
	return list	
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="ISR_1996"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="ISR_1996"
	return list	
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="DEU_2005"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="DEU_2005"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="JPN_2007"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="JPN_2007"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="NZL_2002"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="NZL_2002"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 if A1004=="JPN_2004"
	loevh polinfo1 polinfo2 polinfo3 if A1004=="JPN_2004"
	return list
	
	* EES DATA *
	use "EES_gender_knowledge_ajpsreplication.dta" , clear
	keep if polknowledge!=.
	
	** Cronbach's alpha /Loevinger's H 
	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="BG"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="BG"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="MT"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="MT"
	return list

	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="PT"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="PT"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="IT"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="IT"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="SI"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="SI"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="RO"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="RO"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="PL"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="PL"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="FR"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="FR"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="HU"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="HU"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="NL"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="NL"
	return list
		
	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="SK"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="SK"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="DK"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="DK"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="CY"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="CY"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="ES"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="ES"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="DE"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="DE"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="AT"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="AT"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="LU"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="LU"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="LV"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="LV"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="LT"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="LT"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="IE"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="IE"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="UK"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="UK"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="CZ"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="CZ"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="SE"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="SE"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="FI"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="FI"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="EE"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="EE"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="BE"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="BE"
	return list
	
	alpha polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="EL"
	loevh polinfo1 polinfo2 polinfo3 polinfo4 polinfo5 polinfo6 polinfo7 if countrycode=="EL"
	return list

	
	
** APPENDIX 4 - analyses for samples with loevinger's h >.39 (CSES)
	use  "CSES_gender_knowledge_ajpsreplication.dta", clear
	
	** generate variable that captures sample with good knowledge scale  (LOEVINGER'S H >.4)
	gen goodscale=1 if A1004=="USA_2004"
	replace goodscale=1 if A1004=="LVA_2010"
	replace goodscale=1 if A1004=="USA_2008"
	replace goodscale=1 if A1004=="THA_2007"
	replace goodscale=1 if A1004=="ZAF_2009"
	replace goodscale=1 if A1004=="KGZ_2005"
	replace goodscale=1 if A1004=="TWN_2008"
	replace goodscale=1 if A1004=="TWN_2001"
	replace goodscale=1 if A1004=="RUS_2004"
	replace goodscale=1 if A1004=="ALB_2005"
	replace goodscale=1 if A1004=="ITA_2006"
	replace goodscale=1 if A1004=="ISL_2007"
	replace goodscale=1 if A1004=="POL_2007"
	replace goodscale=1 if A1004=="MEX_1997"
	replace goodscale=1 if A1004=="NLD_2002"
	replace goodscale=1 if A1004=="THA_2011"
	replace goodscale=1 if A1004=="NLD_2010"
	replace goodscale=1 if A1004=="ROU_2009"
	replace goodscale=1 if A1004=="ESP_2000"
	replace goodscale=1 if A1004=="ESP_2004"
	replace goodscale=1 if A1004=="NLD_2006"
	replace goodscale=1 if A1004=="IRL_2002"
	replace goodscale=1 if A1004=="ISL_2009"
	replace goodscale=1 if A1004=="HRV_2007"
	replace goodscale=1 if A1004=="BEL_1999"
	replace goodscale=1 if A1004=="SVN_2004"
	replace goodscale=1 if A1004=="NOR_2001"
	replace goodscale=1 if A1004=="POL_2011"
	replace goodscale=1 if A1004=="ROU_2004"
	replace goodscale=1 if A1004=="NZL_2014"
	replace goodscale=1 if A1004=="ISR_2013"
	replace goodscale=1 if A1004=="GBR_2015"
	replace goodscale=1 if A1004=="PRT_2005"
	replace goodscale=1 if A1004=="POL_2005"
	replace goodscale=1 if A1004=="POL_2001"
	replace goodscale=1 if A1004=="SVN_2011"
	replace goodscale=1 if A1004=="BRA_2002"
	replace goodscale=1 if A1004=="KEN_2013"
	replace goodscale=1 if A1004=="PRT_2002"
	replace goodscale=1 if A1004=="NZL_2011"
	replace goodscale=1 if A1004=="PER_2006"
	replace goodscale=1 if A1004=="TWN_2004"
	replace goodscale=1 if A1004=="MEX_2009"
	replace goodscale=1 if A1004=="DEU_2009"
	replace goodscale=1 if A1004=="HUN_1998"
	replace goodscale=1 if A1004=="GRC_2009"
	replace goodscale=1 if A1004=="MEX_2003"
	replace goodscale=1 if A1004=="KOR_2008"
	replace goodscale=1 if A1004=="EST_2011"
	replace goodscale=1 if A1004=="DEU_1998"
	replace goodscale=1 if A1004=="SWE_1998"
	replace goodscale=1 if A1004=="KOR_2012"
	replace goodscale=1 if A1004=="NOR_2009"
	replace goodscale=1 if A1004=="AUS_2013"
	replace goodscale=1 if A1004=="PRT_2015"
	replace goodscale=1 if A1004=="ROU_2012"
	replace goodscale=1 if A1004=="CAN_2004"
	replace goodscale=1 if A1004=="BRA_2010"
	replace goodscale=1 if A1004=="AUT_2008"
	replace goodscale=1 if A1004=="CAN_1997"
	replace goodscale=1 if A1004=="BEL_2003"
	replace goodscale=1 if A1004=="SVK_2010"
	replace goodscale=1 if A1004=="POL_1997"
	replace goodscale=1 if A1004=="FRA_2012"
	replace goodscale=1 if A1004=="KOR_2004"
	replace goodscale=1 if A1004=="MEX_2006"
	replace goodscale=1 if A1004=="TWN_2012"
	replace goodscale=1 if A1004=="HUN_2002"
	replace goodscale=1 if A1004=="HKG_1998"
	replace goodscale=1 if A1004=="ISR_2003"
	replace goodscale=1 if A1004=="MEX_2000"
	replace goodscale=1 if A1004=="ESP_2008"
	replace goodscale=1 if A1004=="BRA_2006"

	* coding additional variables for analyses
	drop if polknowledge==.
	
	split A1004, p("_")
	drop A10042
	rename A10041 iso
	
	egen cohort = cut(birthyear), at(1900 1905 1910 1915 1920 1925 1930 1935 1940 1945 1950 1955 1960 1965 1970 1975 1980 1985 1990 1995 2000)
	replace cohort=1910 if cohort==1905
	replace cohort=1910 if cohort==1900
		
	
	* Model 1 - main effect, gender gap 
	set more off
		
	xtmixed polknowledge i.female age college i.female##c.lsq i.female##c.democ	i.female##c.gdp_growth ///
	i.female##i.Z_Qcontent i.female##i.womencontent i.female##i.Qstructure i.svy_mode ///
	|| iso: || A1004: || cohort: if women_parliament_survey!=. & women_parliament_18_21!=. & goodscale==1, var
	
	eststo M1
	sum women_parliament_survey if e(sample)==1
	sum women_parliament_18_21 if e(sample)==1

	* Model 2 - interaction women survey year
		
		* estimate model
	xtmixed polknowledge i.female##c.women_parliament_survey age college i.female##c.lsq i.female##c.democ	i.female##c.gdp_growth ///
	i.female##i.Z_Qcontent i.female##i.womencontent i.female##i.Qstructure i.svy_mode ///
	|| iso: || A1004: || cohort: if women_parliament_survey!=. & women_parliament_18_21!=. & goodscale==1, var
	eststo M2	

	* Model 3 - interaction women, formative years
		
		* estimate model
	xtmixed polknowledge i.female##c.women_parliament_survey i.female##c.women_parliament_18_21 age college i.female##c.lsq i.female##c.democ	i.female##c.gdp_growth ///
	i.female##i.Z_Qcontent i.female##i.womencontent i.female##i.Qstructure i.svy_mode ///
	|| iso: || A1004: || cohort: if women_parliament_survey!=. & women_parliament_18_21!=. & goodscale==1, var
	eststo M3
	
		* calculate marginal effects and construct Figure 1 (left panel) in Appendix 4
	margins , dydx(female)  at(women_parliament_18_21=(0(2)46)) 
	
	marginsplot, level(95)  yline(0) recast(line) recastci(rline)  xtitle("% Women in Parliament at 18-21 years") ///
	addplot(hist women_parliament_18_21, percent bin(30) yaxis(2) yscale(axis(2) alt  )   yscale(range(0(10)100) axis(2)) ///
	ytitle("Percentage of observations", axis(2)) ) ///
	ytitle("AME Female")  legend(off) title("% Women in Parliament at 18-21 years") saving(CSES_formative_goodscale, replace)

	
	* make table
	esttab M1 M2 M3 using appendix4_table1.rtf, b(3) se(3) nogap wide replace
	
	
	
** APPENDIX 4 - analyses for samples with cronbach's alpha >.59 (EES)

	use "EES_gender_knowledge_ajpsreplication.dta" , clear
	
	* generate variable that captures sample with good knowledge scale  (CRONBACH'S ALPHA >.6)
	generate goodscale=1 if countrycode=="BG"
	replace goodscale=1 if countrycode=="MT"
	replace goodscale=1 if countrycode=="PT"
	replace goodscale=1 if countrycode=="IT"
	replace goodscale=1 if countrycode=="SI"
	replace goodscale=1 if countrycode=="RO"
	replace goodscale=1 if countrycode=="PL"
	replace goodscale=1 if countrycode=="FR"
	replace goodscale=1 if countrycode=="HU"
	replace goodscale=1 if countrycode=="NL"
	replace goodscale=1 if countrycode=="SK"
	replace goodscale=1 if countrycode=="CY"
	replace goodscale=1 if countrycode=="ES"
	replace goodscale=1 if countrycode=="LV"
	replace goodscale=1 if countrycode=="UK"
	replace goodscale=1 if countrycode=="CZ"
	
	* coding of additional variables for analyses
	
	egen cohort = cut(birthyear), at(1900 1905 1910 1915 1920 1925 1930 1935 1940 1945 1950 1955 1960 1965 1970 1975 1980 1985 1990 1995 2000)
	replace cohort=1920 if cohort==1915
	replace cohort=1920 if cohort==1910
	
	* Model 1 - main effect gender gap
	set more off
	xtmixed polknowledge_st i.female age edu  i.female##c.lsq_prev i.female##c.gdp_growth i.svy_mode || countrycode: || cohort: ///
	if women_parliament_survey!=. & women_parliament_18_21!=. & goodscale==1, var
	eststo M1
	
	* Model 2 - interaction women survey year
	
		* estimate model
	xtmixed polknowledge_st i.female##c.women_parliament_survey age edu  i.female##c.lsq_prev i.female##c.gdp_growth i.svy_mode || countrycode: || cohort: ///
	if women_parliament_survey!=. & women_parliament_18_21!=. & goodscale==1, var
	eststo M2

	* Model 3 - interaction women formative years
		
		* estimate model
	xtmixed polknowledge_st i.female##c.women_parliament_survey i.female##c.women_parliament_18_21 age edu  i.female##c.lsq_prev i.female##c.gdp_growth i.svy_mode || countrycode: || cohort: ///
	if women_parliament_survey!=. & women_parliament_18_21!=. & goodscale==1, var
	eststo M3

		* calculate marginal effects and construct Figure 1 (right panel) in Appendix 4
	margins , dydx(female)  at(women_parliament_18_21=(0(2)47))
	marginsplot, level(95)  yline(0) recast(line) recastci(rline)  ytitle("AME Female", axis(1)) ///
	addplot(hist women_parliament_18_21 if e(sample)==1, percent bin(40) yaxis(2) yscale(axis(2) alt  )   yscale(range(0(10)100) axis(2)) ///
	ytitle("Percentage of observations", axis(2)) )  xlabel(0(2)47) ylabel(-0.15(0.05)0.01) ///
	xtitle("% Women in Parliament at 18-21 years")  legend(off) title("% Women in Parliament at 18-21 years") saving(EES_formative_goodscale, replace)


	* make table
	esttab M1 M2 M3 using appendix4_table2.rtf, b(3) se(3) nogap wide replace
	
	

	
** APPENDIX 5 - analyses with different time window formative years

	** CSES DATA **
	use  "CSES_gender_knowledge_ajpsreplication.dta", clear
	
	drop if polknowledge==.
	
	split A1004, p("_")
	drop A10042
	rename A10041 iso
	
	egen cohort = cut(birthyear), at(1900 1905 1910 1915 1920 1925 1930 1935 1940 1945 1950 1955 1960 1965 1970 1975 1980 1985 1990 1995 2000)
	replace cohort=1910 if cohort==1905
	replace cohort=1910 if cohort==1900

	* CSES, 16-18
	set more off
		
		* estimate model
	xtmixed polknowledge i.female##c.women_parliament_survey i.female##c.women_parliament_16_18 age college i.female##c.lsq i.female##c.democ	i.female##c.gdp_growth ///
	i.female##i.Z_Qcontent i.female##i.womencontent i.female##i.Qstructure i.svy_mode ///
	|| iso: || A1004: || cohort: if women_parliament_survey!=. & women_parliament_16_18!=., var
	eststo M_16
	
		* calculate marginal effects and construct Figure 1 (left panel) in Appendix 5
	margins , dydx(female)  at(women_parliament_16_18=(0(2)46)) 
	
	marginsplot, level(95)  yline(0) recast(line) recastci(rline)  xtitle("% Women in Parliament at 16-18 years") ///
	addplot(hist women_parliament_16_18, percent bin(30) yaxis(2) yscale(axis(2) alt  )   yscale(range(0(10)100) axis(2)) ///
	ytitle("Percentage of observations", axis(2)) ) ///
	ytitle("AME Female")  legend(off) title("% Women in Parliament at 16-18 years") saving(CSES_formative_16_18, replace)
	
	
	* CSES 16-21
	
		* estimate model
	xtmixed polknowledge i.female##c.women_parliament_survey i.female##c.women_parliament_16_21 age college i.female##c.lsq i.female##c.democ	i.female##c.gdp_growth ///
	i.female##i.Z_Qcontent i.female##i.womencontent i.female##i.Qstructure i.svy_mode ///
	|| iso: || A1004: || cohort: if women_parliament_survey!=. & women_parliament_16_21!=., var
	eststo M_21
	
		* calculate marginal effects and construct Figure 1 (middle panel) in Appendix 5
	margins , dydx(female)  at(women_parliament_16_21=(0(2)46)) 
	
	marginsplot, level(95)  yline(0) recast(line) recastci(rline)  xtitle("% Women in Parliament at 16-21 years") ///
	addplot(hist women_parliament_16_21, percent bin(30) yaxis(2) yscale(axis(2) alt  )   yscale(range(0(10)100) axis(2)) ///
	ytitle("Percentage of observations", axis(2)) ) ///
	ytitle("AME Female")  legend(off) title("% Women in Parliament at 16-21 years") saving(CSES_formative_16_21, replace)

	* Compile table
	esttab M_16 M_21 using appendix5_table1.rtf, b(3) se(3) nogap wide replace	

	
	** EES DATA **
	use "EES_gender_knowledge_ajpsreplication.dta" , clear
	
	egen cohort = cut(birthyear), at(1900 1905 1910 1915 1920 1925 1930 1935 1940 1945 1950 1955 1960 1965 1970 1975 1980 1985 1990 1995 2000)
	replace cohort=1920 if cohort==1915
	replace cohort=1920 if cohort==1910
	
			
	* EES 16-18
	
		* estimate model
	xtmixed polknowledge_st i.female##c.women_parliament_survey i.female##c.women_parliament_16_18 age edu  i.female##c.lsq_prev i.female##c.gdp_growth i.svy_mode || countrycode: || cohort: ///
	if women_parliament_survey!=. & women_parliament_16_18!=., var
	eststo M_16

		* calculate marginal effects and construct Figure 2 (left panel) in Appendix 5
	margins , dydx(female)  at(women_parliament_16_18=(0(2)47))
	marginsplot, level(95)  yline(0) recast(line) recastci(rline)  ytitle("AME Female", axis(1)) ///
	addplot(hist women_parliament_16_18 if e(sample)==1, percent bin(40) yaxis(2) yscale(axis(2) alt  )   yscale(range(0(10)100) axis(2)) ///
	ytitle("Percentage of observations", axis(2)) )  xlabel(0(2)47) ylabel(-0.15(0.05)0.01) ///
	xtitle("% Women in Parliament at 16-18 years")  legend(off) title("% Women in Parliament at 16-18 years") saving(EES_formative_16_18, replace)


	* EES 16-21
			
		* estimate model
	xtmixed polknowledge_st i.female##c.women_parliament_survey i.female##c.women_parliament_16_21 age edu  i.female##c.lsq_prev i.female##c.gdp_growth i.svy_mode || countrycode: || cohort: ///
	if women_parliament_survey!=. & women_parliament_16_21!=., var
	eststo M_21

		* calculate marginal effects and construct Figure 2 (right panel) in Appendix 5
	margins , dydx(female)  at(women_parliament_16_21=(0(2)47))
	marginsplot, level(95)  yline(0) recast(line) recastci(rline)  ytitle("AME Female", axis(1)) ///
	addplot(hist women_parliament_16_21 if e(sample)==1, percent bin(40) yaxis(2) yscale(axis(2) alt  )   yscale(range(0(10)100) axis(2)) ///
	ytitle("Percentage of observations", axis(2)) )  xlabel(0(2)47) ylabel(-0.15(0.05)0.01) ///
	xtitle("% Women in Parliament at 16-21 years")  legend(off) title("% Women in Parliament at 16-21 years") saving(EES_formative_18_21, replace)

	* Compile table
	esttab M_16 M_21 using appendix5_table2.rtf, b(3) se(3) nogap wide replace
	

	
** APPENDIX 6 - ordered logit models [note: drop the country level for convergence]

	** CSES DATA **
	use  "CSES_gender_knowledge_ajpsreplication.dta", clear
	
	drop if polknowledge==.
	
	split A1004, p("_")
	drop A10042
	rename A10041 iso
	
	egen cohort = cut(birthyear), at(1900 1905 1910 1915 1920 1925 1930 1935 1940 1945 1950 1955 1960 1965 1970 1975 1980 1985 1990 1995 2000)
	replace cohort=1910 if cohort==1905
	replace cohort=1910 if cohort==1900
	
	drop if women_parliament_survey==. 
	drop if women_parliament_18_21==.
	
	* Model 1 - main effect, gender gap 
	set more off
		
	meologit polknowledge i.female age college i.female##c.lsq i.female##c.democ	i.female##c.gdp_growth ///
	i.female##i.Z_Qcontent i.female##i.womencontent i.female##i.Qstructure i.svy_mode ///
	 || A1004: || cohort:  ,intpoints(10)  intmethod(mcaghermite)
	
	eststo M1
	sum women_parliament_survey if e(sample)==1
	sum women_parliament_18_21 if e(sample)==1

	* Model 2 - interaction women survey year
		
		* estimate model
	meologit polknowledge i.female##c.women_parliament_survey age college i.female##c.lsq i.female##c.democ	i.female##c.gdp_growth ///
	i.female##i.Z_Qcontent i.female##i.womencontent i.female##i.Qstructure i.svy_mode ///
	 || A1004: || cohort:  ,intpoints(10)  intmethod(mcaghermite)
	eststo M2
	
	* Model 3 - interaction women, formative years
		
		* estimate model
	meologit polknowledge i.female##c.women_parliament_survey i.female##c.women_parliament_18_21 age college i.female##c.lsq i.female##c.democ	i.female##c.gdp_growth ///
	i.female##i.Z_Qcontent i.female##i.womencontent i.female##i.Qstructure i.svy_mode ///
	 || A1004: || cohort:  ,intpoints(10)  intmethod(mcaghermite)
	eststo M3
	
	* Compile table
	esttab M1 M2 M3 using appendix6_table1.rtf, b(3) se(3) nogap wide replace

	
	** EES DATA **
	use "EES_gender_knowledge_ajpsreplication.dta" , clear
	
	egen cohort = cut(birthyear), at(1900 1905 1910 1915 1920 1925 1930 1935 1940 1945 1950 1955 1960 1965 1970 1975 1980 1985 1990 1995 2000)
	replace cohort=1920 if cohort==1915
	replace cohort=1920 if cohort==1910
	
	drop if women_parliament_survey==. 
	drop if women_parliament_18_21==.
	
	* Model 1 - main effect gender gap
		
	meologit polknowledge_st i.female age edu  i.female##c.lsq_prev i.female##c.gdp_growth i.svy_mode || countrycode: || cohort: ///
	  ,intpoints(10)  intmethod(mcaghermite)
	eststo M1
	
	* Model 2 - interaction women survey year
	
		* estimate model
	meologit polknowledge_st i.female##c.women_parliament_survey age edu  i.female##c.lsq_prev i.female##c.gdp_growth i.svy_mode || countrycode: || cohort: ///
	  ,intpoints(10)  intmethod(mcaghermite)
	eststo M2
	
	* Model 3 - interaction women formative years
		
		* estimate model
	meologit polknowledge_st i.female##c.women_parliament_survey i.female##c.women_parliament_18_21 age edu  i.female##c.lsq_prev i.female##c.gdp_growth i.svy_mode || countrycode: || cohort: ///
	  ,intpoints(10)  intmethod(mcaghermite)
	eststo M3
	
	* Compile table
	esttab M1 M2 M3 using appendix6_table2.rtf, b(3) se(3) nogap wide replace



** APPENDIX 7 - ADDITIONAL INDIVIDUAL LEVEL CONTROLS (interest, media, gender values) EES

	use "EES_gender_knowledge_ajpsreplication.dta" , clear
	
	egen cohort = cut(birthyear), at(1900 1905 1910 1915 1920 1925 1930 1935 1940 1945 1950 1955 1960 1965 1970 1975 1980 1985 1990 1995 2000)
	replace cohort=1920 if cohort==1915
	replace cohort=1920 if cohort==1910
	
	gen polinterest_st=(polinterest-1)/(4-1)
	gen news_st=(follownews-0)/(7-0)
	
	* Model 1 (full model): interest
	set more off
		* estimate model
	xtmixed polknowledge_st i.female##c.women_parliament_survey i.female##c.women_parliament_18_21 age edu polinterest_st i.female##c.lsq_prev i.female##c.gdp_growth i.svy_mode || countrycode: || cohort: ///
	if women_parliament_survey!=. & women_parliament_18_21!=., var
	eststo M_interest

		* calculate marginal effects and construct Figure 1 (left panel) in Appendix 7
	margins , dydx(female)  at(women_parliament_18_21=(0(2)47))
	marginsplot, level(95)  yline(0) recast(line) recastci(rline)  ytitle("AME Female", axis(1)) ///
	addplot(hist women_parliament_18_21 if e(sample)==1, percent bin(40) yaxis(2) yscale(axis(2) alt  )   yscale(range(0(10)100) axis(2)) ///
	ytitle("Percentage of observations", axis(2)) )  xlabel(0(2)47) ylabel(-0.15(0.05)0.01) ///
	xtitle("% Women in Parliament at 18-21 years")  legend(off) title("% Women in Parliament at 18-21 years") saving(EES_interest, replace)

		
	* Model 2 (full model): media
	
			* estimate model
	xtmixed polknowledge_st i.female##c.women_parliament_survey i.female##c.women_parliament_18_21 age edu news_st i.female##c.lsq_prev i.female##c.gdp_growth i.svy_mode || countrycode: || cohort: ///
	if women_parliament_survey!=. & women_parliament_18_21!=., var
	eststo M_media

		* calculate marginal effects and construct Figure 1 (middle panel) in Appendix 7
	margins , dydx(female)  at(women_parliament_18_21=(0(2)47))
	marginsplot, level(95)  yline(0) recast(line) recastci(rline)  ytitle("AME Female", axis(1)) ///
	addplot(hist women_parliament_18_21 if e(sample)==1, percent bin(40) yaxis(2) yscale(axis(2) alt  )   yscale(range(0(10)100) axis(2)) ///
	ytitle("Percentage of observations", axis(2)) )  xlabel(0(2)47) ylabel(-0.15(0.05)0.01) ///
	xtitle("% Women in Parliament at 18-21 years")  legend(off) title("% Women in Parliament at 18-21 years") saving(EES_media, replace)

		
	
	* Model 3 (full model): gender values
	
	xtmixed polknowledge_st i.female##c.women_parliament_survey i.female##c.women_parliament_18_21 age edu ///
	i.female##c.abortion i.female##c.womenfamily i.female##c.lsq_prev i.female##c.gdp_growth i.svy_mode || countrycode: || cohort: ///
	if women_parliament_survey!=. & women_parliament_18_21!=., var
	eststo M_values

		* calculate marginal effects and construct Figure 1 (right panel) in Appendix 7
	margins , dydx(female)  at(women_parliament_18_21=(0(2)47))
	marginsplot, level(95)  yline(0) recast(line) recastci(rline)  ytitle("AME Female", axis(1)) ///
	addplot(hist women_parliament_18_21 if e(sample)==1, percent bin(40) yaxis(2) yscale(axis(2) alt  )   yscale(range(0(10)100) axis(2)) ///
	ytitle("Percentage of observations", axis(2)) )  xlabel(0(2)47) ylabel(-0.15(0.05)0.01) ///
	xtitle("% Women in Parliament at 18-21 years")  legend(off) title("% Women in Parliament at 18-21 years") saving(EES_values, replace)

	
	* Compile table
	esttab M_interest M_media M_values using appendix7_table.rtf, b(3) se(3) nogap wide replace


	
** APPENDIX 8 - ADDITIONAL AGGREGATE LEVEL CONTROLS: % women labour force, % women tertiary degree + individual control (female x age interaction)

	** CSES DATA **
	use  "CSES_gender_knowledge_ajpsreplication.dta", clear
	
	drop if polknowledge==.
	
	split A1004, p("_")
	drop A10042
	rename A10041 iso	
	
	egen cohort = cut(birthyear), at(1900 1905 1910 1915 1920 1925 1930 1935 1940 1945 1950 1955 1960 1965 1970 1975 1980 1985 1990 1995 2000)
	replace cohort=1910 if cohort==1905
	replace cohort=1910 if cohort==1900
	
	* Model 1 - female x labor force
	xtmixed polknowledge i.female##c.women_parliament_survey i.female##c.women_parliament_18_21 age college i.female##c.female_labor i.female##c.lsq i.female##c.democ	i.female##c.gdp_growth ///
	i.female##i.Z_Qcontent i.female##i.womencontent i.female##i.Qstructure i.svy_mode ///
	|| iso: || A1004: || cohort: if women_parliament_survey!=. & women_parliament_18_21!=., var
	eststo M_labour

		* calculate marginal effects and construct Figure 1 (left panel) in Appendix 8
	margins , dydx(female)  at(women_parliament_18_21=(0(2)46)) 
	marginsplot, level(95)  yline(0) recast(line) recastci(rline)  xtitle("% Women in Parliament at 18-21 years") ///
	addplot(hist women_parliament_18_21, percent bin(30) yaxis(2) yscale(axis(2) alt  )   yscale(range(0(10)100) axis(2)) ///
	ytitle("Percentage of observations", axis(2)) ) ///
	ytitle("AME Female")  legend(off) title("% Women in Parliament at 18-21 years") saving(CSES_formative_labor, replace)

	
	* Model 2 - female x tertiary
	
	xtmixed polknowledge i.female##c.women_parliament_survey i.female##c.women_parliament_18_21 age college i.female##c.tertiary_women_ipo i.female##c.lsq i.female##c.democ	i.female##c.gdp_growth ///
	i.female##i.Z_Qcontent i.female##i.womencontent i.female##i.Qstructure i.svy_mode ///
	|| iso: || A1004: || cohort: if women_parliament_survey!=. & women_parliament_18_21!=., var
	eststo M_edu
	
		* calculate marginal effects and construct Figure 1 (middle panel) in Appendix 8
	margins , dydx(female)  at(women_parliament_18_21=(0(2)46)) 
	marginsplot, level(95)  yline(0) recast(line) recastci(rline)  xtitle("% Women in Parliament at 18-21 years") ///
	addplot(hist women_parliament_18_21, percent bin(30) yaxis(2) yscale(axis(2) alt  )   yscale(range(0(10)100) axis(2)) ///
	ytitle("Percentage of observations", axis(2)) ) ///
	ytitle("AME Female")  legend(off) title("% Women in Parliament at 18-21 years") saving(CSES_formative_edu, replace)

	
	* Model 3 - female x age
	
	xtmixed polknowledge i.female##c.women_parliament_survey i.female##c.women_parliament_18_21 i.female##c.age college i.female##c.lsq i.female##c.democ	i.female##c.gdp_growth ///
	i.female##i.Z_Qcontent i.female##i.womencontent i.female##i.Qstructure i.svy_mode ///
	|| iso: || A1004: || cohort: if women_parliament_survey!=. & women_parliament_18_21!=., var
	eststo M_age

		* calculate marginal effects and construct Figure 1 (right panel) in Appendix 8
	margins , dydx(female)  at(women_parliament_18_21=(0(2)46)) 
	marginsplot, level(95)  yline(0) recast(line) recastci(rline)  xtitle("% Women in Parliament at 18-21 years") ///
	addplot(hist women_parliament_18_21, percent bin(30) yaxis(2) yscale(axis(2) alt  )   yscale(range(0(10)100) axis(2)) ///
	ytitle("Percentage of observations", axis(2)) ) ///
	ytitle("AME Female")  legend(off) title("% Women in Parliament at 18-21 years") saving(CSES_formative_age, replace)

	* Compile table
	esttab M_labour M_edu M_age using appendix8_table1.rtf, b(3) se(3) nogap wide replace
	
	
	** EES DATA **
	use "EES_gender_knowledge_ajpsreplication.dta" , clear
	
	egen cohort = cut(birthyear), at(1900 1905 1910 1915 1920 1925 1930 1935 1940 1945 1950 1955 1960 1965 1970 1975 1980 1985 1990 1995 2000)
	replace cohort=1920 if cohort==1915
	replace cohort=1920 if cohort==1910
	
	* Model 1 - female x labour
	
	xtmixed polknowledge_st i.female##c.women_parliament_survey i.female##c.women_parliament_18_21 age edu  i.female##c.lsq_prev i.female##c.gdp_growth i.svy_mode ///
	i.female##c.female_labor || countrycode: || cohort: ///
	if women_parliament_survey!=. & women_parliament_18_21!=., var
	eststo M_labour

		* calculate marginal effects and construct Figure 2 (left panel) in Appendix 8
	margins , dydx(female)  at(women_parliament_18_21=(0(2)47))
	marginsplot, level(95)  yline(0) recast(line) recastci(rline)  ytitle("AME Female", axis(1)) ///
	addplot(hist women_parliament_18_21 if e(sample)==1, percent bin(40) yaxis(2) yscale(axis(2) alt  )   yscale(range(0(10)100) axis(2)) ///
	ytitle("Percentage of observations", axis(2)) )  xlabel(0(2)47) ylabel(-0.15(0.05)0.01) ///
	xtitle("% Women in Parliament at 18-21 years")  legend(off) title("% Women in Parliament at 18-21 years") saving(EES_formative_labor, replace)

	* Model 2 - female x tertiary
	
	xtmixed polknowledge_st i.female##c.women_parliament_survey i.female##c.women_parliament_18_21 age edu  i.female##c.lsq_prev i.female##c.gdp_growth i.svy_mode ///
	i.female##c.tertiary_women || countrycode: || cohort: ///
	if women_parliament_survey!=. & women_parliament_18_21!=., var
	eststo M_edu

		* calculate marginal effects and construct Figure 2 (middle panel) in Appendix 8
	margins , dydx(female)  at(women_parliament_18_21=(0(2)47))
	marginsplot, level(95)  yline(0) recast(line) recastci(rline)  ytitle("AME Female", axis(1)) ///
	addplot(hist women_parliament_18_21 if e(sample)==1, percent bin(40) yaxis(2) yscale(axis(2) alt  )   yscale(range(0(10)100) axis(2)) ///
	ytitle("Percentage of observations", axis(2)) )  xlabel(0(2)47) ylabel(-0.15(0.05)0.01) ///
	xtitle("% Women in Parliament at 18-21 years")  legend(off) title("% Women in Parliament at 18-21 years") saving(EES_formative_edu, replace)
	
	* Model 3 - female x age
	
	xtmixed polknowledge_st i.female##c.women_parliament_survey i.female##c.women_parliament_18_21 i.female##c.age edu  i.female##c.lsq_prev i.female##c.gdp_growth i.svy_mode ///
	 || countrycode: || cohort: ///
	if women_parliament_survey!=. & women_parliament_18_21!=., var
	eststo M_age

		* calculate marginal effects and construct Figure 2 (right panel) in Appendix 8
	margins , dydx(female)  at(women_parliament_18_21=(0(2)47))
	marginsplot, level(95)  yline(0) recast(line) recastci(rline)  ytitle("AME Female", axis(1)) ///
	addplot(hist women_parliament_18_21 if e(sample)==1, percent bin(40) yaxis(2) yscale(axis(2) alt  )   yscale(range(0(10)100) axis(2)) ///
	ytitle("Percentage of observations", axis(2)) )  xlabel(0(2)47) ylabel(-0.15(0.05)0.01) ///
	xtitle("% Women in Parliament at 18-21 years")  legend(off) title("% Women in Parliament at 18-21 years") saving(EES_formative_age, replace)

	* Compile table
	esttab M_labour M_edu M_age using appendix8_table2.rtf, b(3) se(3) nogap wide replace
	
	
** APPENDIX 9 - OTHER INDICATOR THAT IMPACTS DURING FORMATIVE YEARS: DEMOCRATIZATION
	use  "CSES_gender_knowledge_ajpsreplication.dta", clear
	
	drop if polknowledge==.
	
	split A1004, p("_")
	drop A10042
	rename A10041 iso
	
	egen cohort = cut(birthyear), at(1900 1905 1910 1915 1920 1925 1930 1935 1940 1945 1950 1955 1960 1965 1970 1975 1980 1985 1990 1995 2000)
	replace cohort=1910 if cohort==1905
	replace cohort=1910 if cohort==1900
	
	encode A1004, gen(A1004_num)
	set more off

	xtmixed polknowledge i.female##c.women_parliament_survey i.female##c.women_parliament_18_21 age college i.female##c.lsq i.female##c.democ ///
		i.female##c.democ_18_21 i.female##c.gdp_growth ///
	i.female##i.Z_Qcontent i.female##i.womencontent i.female##i.Qstructure i.svy_mode ///
	|| iso: || A1004: || cohort: if women_parliament_survey!=. & women_parliament_18_21!=., var
	eststo M_demoformative
	
		* calculate marginal effects and construct Figure 1 in Appendix 9
	margins , dydx(female)  at(women_parliament_18_21=(0(2)47))
	marginsplot, level(95)  yline(0) recast(line) recastci(rline)  ytitle("AME Female", axis(1)) ///
	addplot(hist women_parliament_18_21 if e(sample)==1, percent bin(40) yaxis(2) yscale(axis(2) alt  )   yscale(range(0(10)100) axis(2)) ///
	ytitle("Percentage of observations", axis(2)) )  xlabel(0(2)47) ylabel(-0.15(0.05)0.01) ///
	xtitle("% Women in Parliament at 18-21 years")  legend(off) title("% Women in Parliament at 18-21 years") saving(CSES_demoformative, replace)

	
	esttab M_demoformative using appendix9_table.rtf, b(3) se(3) nogap wide replace
	
	
	
** APPENDIX 10 - MORE GENERAL INDICATOR OF GENDER EQUALITY

	** CSES DATA **
	use  "CSES_gender_knowledge_ajpsreplication.dta", clear
	
	drop if polknowledge==.
	
	split A1004, p("_")
	drop A10042
	rename A10041 iso
	
	egen cohort = cut(birthyear), at(1900 1905 1910 1915 1920 1925 1930 1935 1940 1945 1950 1955 1960 1965 1970 1975 1980 1985 1990 1995 2000)
	replace cohort=1910 if cohort==1905
	replace cohort=1910 if cohort==1900
	
	xtmixed polknowledge  age  college i.female##c.lsq i.female##c.democ	i.female##c.gdp_growth ///
	 i.female##i.Z_Qcontent i.female##i.womencontent i.female##i.Qstructure i.svy_mode ///
	i.female##c.genderequality_survey ///
	|| iso: || A1004: || cohort: if women_parliament_survey!=. & women_parliament_18_21!=., var
	eststo M1
	
	xtmixed polknowledge  age  college i.female##c.lsq i.female##c.democ	i.female##c.gdp_growth ///
	 i.female##i.Z_Qcontent i.female##i.womencontent i.female##i.Qstructure i.svy_mode ///
	 i.female##c.genderequality_survey i.female##c.genderequality_18_21  ///
	|| iso: || A1004: || cohort: if women_parliament_survey!=. & women_parliament_18_21!=., var
	eststo M2
	
	* Compile table
	esttab M1 M2 using appendix10_table1.rtf, b(3) se(3) nogap wide replace

	
	
** APPENDIX 11 - DIFFERENT EFFECTS IN DIFFERENT AGE GROUPS **


	** CSES DATA 
	use  "CSES_gender_knowledge_ajpsreplication.dta", clear
	
	drop if polknowledge==.
	
	split A1004, p("_")
	drop A10042
	rename A10041 iso
	
	egen cohort = cut(birthyear), at(1900 1905 1910 1915 1920 1925 1930 1935 1940 1945 1950 1955 1960 1965 1970 1975 1980 1985 1990 1995 2000)
	replace cohort=1910 if cohort==1905
	replace cohort=1910 if cohort==1900
	
	* < 31
	xtmixed polknowledge i.female##c.women_parliament_survey i.female##c.women_parliament_18_21 ///
		age  college i.female##c.lsq i.female##c.democ	i.female##c.gdp_growth ///
	i.female##i.Z_Qcontent i.female##i.womencontent i.female##i.Qstructure i.svy_mode ///
	|| iso: || A1004: || cohort: if women_parliament_survey!=. & age<31, var
	eststo M_31min
	
	
		* calculate marginal effects and construct Figure 1 (left panel) in Appendix 11
	margins , dydx(female)  at(women_parliament_18_21=(0(2)46)) 
		
	marginsplot, level(95)  yline(0) recast(line) recastci(rline)  xtitle("% Women in Parliament at 18-21 years") ///
	addplot(hist women_parliament_18_21 if e(sample)==1, percent bin(30) yaxis(2) yscale(axis(2) alt  )   yscale(range(0(10)100) axis(2)) ///
	ytitle("Percentage of observations", axis(2)) ) xsize(6) ysize(4) ///
	ytitle("AME Female")  legend(off) title("% Women in Parliament at 18-21 years") saving(CSES_31min, replace)

	* 31+ respondents
	xtmixed polknowledge i.female##c.women_parliament_survey i.female##c.women_parliament_18_21 ///
	age  college i.female##c.lsq i.female##c.democ	i.female##c.gdp_growth ///
	i.female##i.Z_Qcontent i.female##i.womencontent i.female##i.Qstructure i.svy_mode ///
	|| iso: || A1004: || cohort:  if women_parliament_survey!=. & age>30 , var
	eststo M_31plus
	
		* calculate marginal effects and construct Figure 1 (middle panel) in Appendix 11
	margins , dydx(female)  at(women_parliament_18_21=(0(2)40)) 
		
	marginsplot, level(95)  yline(0) recast(line) recastci(rline)  xtitle("% Women in Parliament at 18-21 years") ///
	addplot(hist women_parliament_18_21 if e(sample)==1, percent bin(30) yaxis(2) yscale(axis(2) alt  )   yscale(range(0(10)100) axis(2)) ///
	ytitle("Percentage of observations", axis(2)) ) xsize(6) ysize(4) ///
	ytitle("AME Female")  legend(off) title("% Women in Parliament at 18-21 years") saving(CSES_31plus, replace)
	
	* 56+ respondents
	xtmixed polknowledge i.female##c.women_parliament_survey i.female##c.women_parliament_18_21 ///
		age  college i.female##c.lsq i.female##c.democ	i.female##c.gdp_growth ///
	i.female##i.Z_Qcontent i.female##i.womencontent i.female##i.Qstructure i.svy_mode ///
	|| iso: || A1004: || cohort:  if women_parliament_survey!=. & age>55, var
	
	eststo M_56plus

		* calculate marginal effects and construct Figure 1 (right panel) in Appendix 11)
	margins , dydx(female)  at(women_parliament_18_21=(0(2)30)) 
		
	marginsplot, level(95)  yline(0) recast(line) recastci(rline)  xtitle("% Women in Parliament at 18-21 years") ///
	addplot(hist women_parliament_18_21 if e(sample)==1, percent bin(30) yaxis(2) yscale(axis(2) alt  )   yscale(range(0(10)100) axis(2)) ///
	ytitle("Percentage of observations", axis(2)) ) xsize(6) ysize(4) ///
	ytitle("AME Female")  legend(off) title("% Women in Parliament at 18-21 years") saving(CSES_56plus, replace)
	
	* Compile table
	esttab M_31min M_31plus M_56plus using appendix11_table1.rtf , b(3) se(3) nogap wide replace

	
	
** APPENDIX 12 -  ALTERNATIVE OPERATIONALIZATION OF DV: POLITICAL EXPRESSION

	** CSES DATA **
	use  "CSES_gender_knowledge_ajpsreplication.dta", clear
	
	drop if polknowledge==.
	
	split A1004, p("_")
	drop A10042
	rename A10041 iso	
	
	egen cohort = cut(birthyear), at(1900 1905 1910 1915 1920 1925 1930 1935 1940 1945 1950 1955 1960 1965 1970 1975 1980 1985 1990 1995 2000)
	replace cohort=1910 if cohort==1905
	replace cohort=1910 if cohort==1900
	
	* Model 1 - main effect, gender gap 
	set more off
		
	xtmixed polexpression_st i.female age college i.female##c.lsq i.female##c.democ	i.female##c.gdp_growth ///
	i.female##i.Z_Qcontent i.female##i.womencontent i.female##i.Qstructure i.svy_mode ///
	|| iso: || A1004: || cohort: if women_parliament_survey!=. & women_parliament_18_21!=., var
	
	eststo M1
	sum women_parliament_survey if e(sample)==1
	sum women_parliament_18_21 if e(sample)==1

	* Model 2 - interaction women survey year
		
		* estimate model
	xtmixed polexpression_st i.female##c.women_parliament_survey age college i.female##c.lsq i.female##c.democ	i.female##c.gdp_growth ///
	i.female##i.Z_Qcontent i.female##i.womencontent i.female##i.Qstructure i.svy_mode ///
	|| iso: || A1004: || cohort: if women_parliament_survey!=. & women_parliament_18_21!=., var
	eststo M2
	
	* Model 3 - interaction women, formative years
		
		* estimate model
	xtmixed polexpression_st i.female##c.women_parliament_survey i.female##c.women_parliament_18_21 age college i.female##c.lsq i.female##c.democ i.female##c.gdp_growth ///
	i.female##i.Z_Qcontent i.female##i.womencontent i.female##i.Qstructure i.svy_mode ///
	|| iso: || A1004: || cohort: if women_parliament_survey!=. & women_parliament_18_21!=., var
	eststo M3
	
		* calculate marginal effects and construct Figure 1 (left panel) in Appendix 12
	margins , dydx(female)  at(women_parliament_18_21=(0(2)46)) 
	marginsplot, level(95)  yline(0) recast(line) recastci(rline)  xtitle("% Women in Parliament at 18-21 years") ///
	addplot(hist women_parliament_18_21, percent bin(30) yaxis(2) yscale(axis(2) alt  )   yscale(range(0(10)100) axis(2)) ///
	ytitle("Percentage of observations", axis(2)) ) ///
	ytitle("AME Female")  legend(off) title("% Women in Parliament at 18-21 years") saving(CSES_formative_expr, replace)

	* Compile table
	esttab M1 M2 M3 using appendix12_table1.rtf, b(3) se(3) nogap wide replace

	
	
	** EES DATA **
	use "EES_gender_knowledge_ajpsreplication.dta" , clear
	
	egen cohort = cut(birthyear), at(1900 1905 1910 1915 1920 1925 1930 1935 1940 1945 1950 1955 1960 1965 1970 1975 1980 1985 1990 1995 2000)
	replace cohort=1920 if cohort==1915
	replace cohort=1920 if cohort==1910
	
	gen polexpression_st=polexpression/7
	
	* Model 1 - main effect gender gap
		
	xtmixed polexpression_st i.female age edu  i.female##c.lsq_prev i.female##c.gdp_growth i.svy_mode || countrycode: || cohort: ///
	if women_parliament_survey!=. & women_parliament_18_21!=., var
	eststo M1
	
	* Model 2 - interaction women survey year
	
		* estimate model
	xtmixed polexpression_st i.female##c.women_parliament_survey age edu  i.female##c.lsq_prev i.female##c.gdp_growth i.svy_mode || countrycode: || cohort: ///
	if women_parliament_survey!=. & women_parliament_18_21!=., var
	eststo M2

	
	* Model 3 - interaction women formative years
		
		* estimate model
	xtmixed polexpression_st i.female##c.women_parliament_survey i.female##c.women_parliament_18_21 age edu  i.female##c.lsq_prev i.female##c.gdp_growth i.svy_mode || countrycode: || cohort: ///
	if women_parliament_survey!=. & women_parliament_18_21!=., var
	eststo M3

		* calculate marginal effects and construct Figure 1 (right panel) in Appendix 12
	margins , dydx(female)  at(women_parliament_18_21=(0(2)47))
	marginsplot, level(95)  yline(0) recast(line) recastci(rline)  ytitle("AME Female", axis(1)) ///
	addplot(hist women_parliament_18_21 if e(sample)==1, percent bin(40) yaxis(2) yscale(axis(2) alt  )   yscale(range(0(10)100) axis(2)) ///
	ytitle("Percentage of observations", axis(2)) )  xlabel(0(2)47) ylabel(-0.15(0.05)0.01) ///
	xtitle("% Women in Parliament at 18-21 years")  legend(off) title("% Women in Parliament at 18-21 years") saving(EES_formative_expr, replace)
	
	* Compile table
	esttab M1 M2 M3 using appendix12_table2.rtf, b(3) se(3) nogap wide replace


	
** APPENDIX 13 EVOLUTION OF % WOMEN IN PARLIAMENT 	
	
	** CSES SAMPLE **
	use "women_parliament_1945_2016_for_cses.dta", clear
	
	drop if cses_code=="BGR"			// --> drop countries not included in analyses
	drop if cses_code=="BLR"
	drop if cses_code=="KEN"
	drop if cses_code=="KGZ"
	drop if cses_code=="LTU"
	drop if cses_code=="MNE"
	drop if cses_code=="SRB"
	drop if cses_code=="TUR"
	drop if cses_code=="URY"
	
		* country specific
	sort cses_code
	twoway scatter women_parliament year , by(cses_code)
	
	
	** EES SAMPLE **
	use "women_parliament_1945_2016_for_ees.dta", clear
	
		* country specific
	sort ees_code
	twoway scatter women_parliament year ,by(ees_code)


	

	
	
	
	
	
	

	
	
	
