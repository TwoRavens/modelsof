**************************************************************************************
** title:		Do women vote less correctly?				 						**
** authors:		ruth dassonneville, mary k. nugent, marc hooghe and richard lau 	**
** datasets:	"cses_gender_proximity.dta" and "lau et al_cses_correct.dta" 		**
** date:		february 2019														**
**************************************************************************************


/* This do-file replicates all main and the supplementary analyses that are
reported in the article 'Do women vote less correctly? The effect of gender on 
ideological proximity voting and correct voting. All analyses were performed with Stata 15 */



*****************************
*							*
*	set working directory	*
*							*
*****************************

	/* this line should be changed to correspond to the directory in which the replication files are saved */
	cd  "/Users/ruthdassonneville/Dropbox/do women vote less correctly_jop_replication/"

	
	
*********************************************************	
*														*	
*	First set of analyses: proximity voting (cses data)	*
*														*
*********************************************************	

	* load data
	use "cses_gender_proximity.dta", clear
	
	* limit dataset to samples with at least 250 resondents
	gen col_voteclosest_coded=1 if col_voteclosest!=.

	sort A1004
	by A1004: egen N_col_voteclosest_coded=sum(col_voteclosest_coded)

	keep if N_col_voteclosest_coded>249
	drop if A1004=="ROU_2012"				// levels of correct voting close to zero

	* combine weights
	gen weight=sampleweight*demoweight
	
	* bivariate results: effect of gender on proximity voting
	encode A1004, gen(election) 
	order election, before(A1004)
	numlabel, add force
	tab election
	
	set more off
	tempname gender_bivariate
	
	postfile `gender_bivariate' sample b_female se_female using gender_bivariate.dta, replace
	
	foreach lname of numlist 1(1)134 {  		// loop to repeat the same command for each election sample
	local t : label election `lname'
		noisily logit  col_voteclosest female if election==`lname' [pweight=weight]
		eststo M_`lname': margins ,  dydx(*) post
		post `gender_bivariate' (`lname') (`=_b[female]') (`=_se[female]')
		}
		
	postclose `gender_bivariate'

	* use estimates for plotting (note that election labels are added manually, following the size of the estimated coefficient
	use "gender_bivariate.dta", clear
	
	sort b_female
	gen order=_n
	
	sort sample
	
	label define A1004 1 "ALB_2005" 2 "AUS_1996" 3 "AUS_2004" 4 "AUS_2007" 5 "AUS_2013" ///
	6 "AUT_2008" 7 "AUT_2013" 8 "BEL_1999" 9 "BGR_2001" 10 "BGR_2014" 11 "BRA_2002" ///
	12 "BRA_2010"	13 "BRA_2014" 14 "CAN_1997" 15 "CAN_2004" 16 "CAN_2008" 17 "CAN_2011" ///
	18 "CHE_1999" 19 "CHE_2003" 20 "CHE_2007" 21 "CHE_2011" 22 "CHL_2005" 23 "CHL_2009" ///
	24 "CZE_1996" 25 "CZE_2002" 26 "CZE_2006" 27 "CZE_2010" 28 "CZE_2013" 29 "DEU_1998" ///
	30 "DEU_2002" 31 "DEU_2005" 32 "DEU_2009" 33 "DEU_2013" 34 "DNK_1998" ///
	35 "DNK_2001" 36 "DNK_2007" 37 "ESP_1996" 38 "ESP_2000" 39 "ESP_2004" 40 "ESP_2008" ///
	41 "EST_2011" 42 "FIN_2003" 43 "FIN_2007" 44 "FIN_2011" 45 "FIN_2015" 46 "FRA_2007" ///
	47 "GBR_1997" 48 "GBR_2005" 49 "GBR_2015" 50 "GRC_2009" 51 "GRC_2012" 52 "HKG_1998" ///
	53 "HKG_2008" 54 "HKG_2012" 55 "HRV_2007" 56 "HUN_1998" 57 "HUN_2002" 58 "IRL_2002" ///
	59 "IRL_2007" 60 "IRL_2011" 61 "ISL_1999" 62 "ISL_2003" 63 "ISL_2007" 64 "ISL_2009" ///
	65 "ISL_2013" 66 "ISR_1996" 67 "ISR_2003" 68 "ISR_2006" 69 "ISR_2013" 70 "ITA_2006" ///
	71 "KEN_2013" 72 "KOR_2004" 73 "KOR_2008" 74 "KOR_2012" 75 "LVA_2010" 76 "MEX_1997" ///
	77 "MEX_2000" 78 "MEX_2003" 79 "MEX_2006" 80 "MEX_2009" 81 "MEX_2012" 82 "MEX_2015" ///
	83 "MNE_2012" 84 "NLD_1998" 85 "NLD_2002" 86 "NLD_2006" 87 "NLD_2010" 88 "NOR_1997" ///
	89 "NOR_2001" 90 "NOR_2005" 91 "NOR_2009" 92 "NOR_2013" 93 "NZL_1996" 94 "NZL_2002" ///
	95 "NZL_2008" 96 "NZL_2011" 97 "NZL_2014" 98 "PER_2001" 99 "PER_2006" 100 "PER_2011" ///
	101 "PHL_2004" 102 "POL_1997" 103 "POL_2001" 104 "POL_2005" 105 "POL_2007" 106 "POL_2011" ///
	107 "PRT_2002" 108 "PRT_2005" 109 "PRT_2009" 110 "PRT_2015" 111 "ROU_1996" 112 "RUS_1999" ///
	113 "SRB_2012" 114 "SVK_2010" 115 "SVK_2016" 116 "SVN_1996" 117 "SVN_2004" 118 "SVN_2008" ///
	119 "SVN_2011" 120 "SWE_1998" 121 "SWE_2002" 122 "SWE_2006" 123 "SWE_2014" 124 "THA_2007" ///
	125 "TUR_2011" 126 "TUR_2015" 127 "TWN_2001" 128 "UKR_1998" 129 "URY_2009" 130 "USA_2004" ///
	131 "USA_2008" 132 "USA_2012" 133 "ZAF_2009" 134 "ZAF_2014"
	
	
	label define order 1	"USA_2012" 2	"FRA_2007" 3	"MEX_2000" 4 "SVN_2004" ///
	5	"TWN_2001" 6	"CZE_1996" 7	"POL_2007" 8	"DEU_2005" 9	"TUR_2011" ///
	10	"NOR_2013" 11	"CAN_2011" 12	"DEU_2002" 13	"HKG_1998" 14 "AUS_2004" 15	"ESP_2004" ///
	16	"HRV_2007" 17	"HKG_2012" 18	"CZE_2006" 19	"SVN_1996" 20	"PER_2011" ///
	21	"NZL_2008" 22	"CZE_2010" 23	"SVK_2010" 24	"ITA_2006" 25	"CHE_2003" ///
	26	"POL_1997" 27	"CHL_2009" 28	"PRT_2005" 29	"GBR_2015" 30	"USA_2008" ///
	31	"MEX_2015" 32	"HUN_2002" 33	"EST_2011" 34	"KOR_2008" 35	"PHL_2004" ///
	36	"DEU_2009" 37	"NZL_2002" 38	"SVN_2011" 39	"ROU_1996" 40	"LVA_2010" ///
	41	"SVK_2016" 42	"NLD_2010" 43	"FIN_2015" 44	"ISL_2003" 45	"CAN_2008" ///
	46	"DEU_1998" 47	"ZAF_2014" 48	"DNK_2007" 49	"ISR_1996" 50	"IRL_2002" ///
	51	"ISR_2006" 52	"AUS_2007" 53	"AUS_2013" 54	"ISL_2013" 55	"AUT_2008" ///
	56	"NZL_2014" 57	"IRL_2007" 58	"NZL_1996" 59	"PER_2006" 60	"MNE_2012" ///
	61	"NOR_2009" 62	"SWE_2002" 63	"DNK_1998" 64	"FIN_2007" 65	"RUS_1999" ///
	66	"ISL_2007" 67	"NLD_2002" 68	"HKG_2008" 69	"CAN_1997" 70	"NOR_2001" ///
	71	"CHE_2007" 72	"MEX_2012" 73	"KOR_2004" 74	"KEN_2013" 75	"NLD_1998" ///
	76	"CHE_1999" 77	"SVN_2008" 78	"GRC_2012" 79	"CHE_2011" 80	"HUN_1998" ///
	81	"PRT_2015" 82	"ESP_2008" 83	"BEL_1999" 84	"POL_2011" 85	"GBR_2005" ///
	86	"SRB_2012" 87	"AUT_2013" 88	"ESP_1996" 89	"CHL_2005" 90	"POL_2001" ///
	91	"BGR_2001" 92	"FIN_2011" 93	"IRL_2011" 94	"NZL_2011" 95	"ESP_2000" ///
	96	"DNK_2001" 97	"NLD_2006" 98	"PRT_2002" 99	"USA_2004" 100	"ISR_2013" ///
	101	"CZE_2013" 102	"SWE_2006" 103	"MEX_2009" 104	"FIN_2003" 105	"BRA_2010" ///
	106	"CAN_2004" 107	"PER_2001" 108	"GRC_2009" 109	"ISL_1999" 110	"MEX_1997" ///
	111	"GBR_1997" 112	"NOR_2005" 113	"AUS_1996" 114	"SWE_2014" 115	"URY_2009" ///
	116	"DEU_2013" 117	"CZE_2002" 118	"ZAF_2009" 119	"POL_2005" 120	"ISL_2009" ///
	121	"MEX_2006" 122	"TUR_2015" 123	"ISR_2003" 124	"BGR_2014" 125	"MEX_2003" ///
	126	"PRT_2009" 127	"THA_2007" 128	"BRA_2014" 129	"NOR_1997" 130	"ALB_2005" ///
	131	"KOR_2012" 132	"UKR_1998" 133	"SWE_1998" 134	"BRA_2002"
	
	label values order order
	
	gen lower=b_female-(1.96*se_female)
	gen upper=b_female+(1.96*se_female)

	tw rspike lower upper order  || scatter b_female order  , msymbol(circle) xla(1/134 , valuelabel ang(v) noticks) xtitle("") sort(b_female)
	
	

*****************************************************************************	
*																			*	
*	Second set of analyses: correct voting (Lau et al. (2014) cses dataset)	*
*																			*
*****************************************************************************	

	* load the data
	use "lau et al_cses_correct.dta", clear
	
	* missings correct voting variables, coding of variables
	recode CorrVt11 CorrVt12 CorrVt21 CorrVt22 (9=.)
	
	gen correctvote=CorrVt21		// weighted + directional
	
	gen female=Female

	encode ContryYr, gen(election) 
	numlabel, add
	tab election
	
	* bivariate results: effect of gender on correct voting
	set more off
	tempname gender_bivariate2
	
	postfile `gender_bivariate2' sample b_female se_female using gender_bivariate2.dta, replace
	
	foreach lname of numlist 1(1)58 {  		// loop to repeat the same command for each election sample
	local t : label election `lname'
		noisily logit  correctvote female if election==`lname' 
		eststo M_`lname': margins ,  dydx(*) post
		post `gender_bivariate2' (`lname') (`=_b[female]') (`=_se[female]')
		}
		
	postclose `gender_bivariate2'

	* use estimates for plotting
	use "gender_bivariate2.dta", clear
	
	sort b_female
	gen order=_n
	
	label define order 54				"SWE_2002" 16	"CZE_2002" 25	"FRA_2002" 50	"ROU_2004" 32	"ISL_2003" 52	"SVN_2004" 38	"NLD_2002" ///
	15	"CZE_1996" 34	"ITA_2006" 19	"DNK_1998" 53	"SWE_1998" 31	"ISL_1999" 6	"BEL_2003" 48	"PRT_2005" 21	"ESP_1996" 51	"SVN_1996" ///
	44	"PER_2006" 8	"BRA_2002" 43	"PER_2001" 24	"FIN_2003" 17	"DEU_1998" 1	"ALB_2005" 4	"BELF1999" 12	"CHE_2003" 18	"DEU_2002" ///
	56	"TWN_2004" 7	"BGR_2001" 47	"PRT_2002" 20	"DNK_2001" 57	"USA_1996" 2	"AUS_1996" 49	"ROU_1996" 3	"AUS_2004" 13	"CHL_1999" ///
	29	"HUN_2002" 28	"HUN_1998" 40	"NOR_2001" 23	"ESP_2004" 58	"USA_2004" 37	"NLD_1998" 45	"POL_1997" 42	"NZL_2002" 55	"TWN_1996" ///
	22	"ESP_2000" 10	"CAN_2004" 27	"GBR_2005" 35	"JPN_1996" 9	"CAN_1997" 11	"CHE_1999" 46	"POL_2001" 41	"NZL_1996" 5	"BELW1999" ///
	36	"MEX_2000" 26	"GBR_1997" 33	"ISR_1996" 30	"IRL_2002" 39	"NOR_1997" 14	"CHL_2005"
	
	label values order order
	
	gen lower=b_female-(1.96*se_female)
	gen upper=b_female+(1.96*se_female)

	tw rspike lower upper order  || scatter b_female order  , msymbol(circle) xla(1/58 , valuelabel ang(v) noticks) xtitle("") sort(b_female)

	

*********************************		
*								*
*	Supplementary materials		*	
*								*
*********************************		
	


* APPENDIX 1:  percentage of voters choosing the most proximate party, by election sample

	use "cses_gender_proximity.dta", clear
	
	* limit dataset to samples with at least 250 resondents
	gen col_voteclosest_coded=1 if col_voteclosest!=.

	sort A1004
	by A1004: egen N_col_voteclosest_coded=sum(col_voteclosest_coded)

	keep if N_col_voteclosest_coded>249
	drop if A1004=="ROU_2012"				// levels of correct voting close to zero

	* combine weights
	gen weight=sampleweight*demoweight
		
	* descriptives	
	by A1004 : tab col_voteclosest [aw=weight]
	tab col_voteclosest [aw=weight]
	

* APPENDIX 2: 	percentage of voters voting correctly, by election sample

	use "lau et al_cses_correct.dta", clear
	
	recode CorrVt11 CorrVt12 CorrVt21 CorrVt22 (9=.)
	gen correctvote=CorrVt21		// weighted + directional
	
	replace ContryYr="BEL_1999" if ContryYr=="BELF1999" 	// combine Belgian F and W samples for summary
	replace ContryYr="BEL_1999" if ContryYr=="BELW1999" 
	
	tab ContryYr correctvote, row
	tab correctvote
	

* APPENDIX 3: 	political knowledge

	* estimates by sample
	use "cses_gender_proximity.dta", clear
	
	keep if polknowledge!=.

	gen weight=sampleweight*demoweight
	
	encode A1004, gen(election) 
	order election, before(A1004)
	numlabel, add force
	tab election
	
	set more off
	tempname gender_bivariate3
	
	postfile `gender_bivariate3' sample b_female se_female using gender_bivariate3.dta, replace
	
	foreach lname of numlist 1(1)141 {  		// loop to repeat the same command for each election sample
	local t : label election `lname'
		noisily reg  polknowledge female if election==`lname' [pweight=weight]
		post `gender_bivariate3' (`lname') (`=_b[female]') (`=_se[female]')
		}
		
	postclose `gender_bivariate3'

	use "gender_bivariate3.dta", clear
	
	
	* controling for survey mode and question format
	use "cses_gender_proximity.dta", clear
	
	keep if polknowledge!=.
	
	encode A1004, gen(election) 
	order election, before(A1004)
	numlabel, add force
	tab election
	
	
	gen svymode=1 if A1023==1		// ftf
	replace svymode=2 if A1023==2	// telephone
	replace svymode=3 if A1023==3	// self-adm
	replace svymode=4 if A1023==4	// mix
	replace svymode=4 if A1023==5	// mix
	replace svymode=1 if B1023==1	// ftf
	replace svymode=2 if B1023==2	// telephone
	replace svymode=3 if B1023==3	// self-adm
	replace svymode=4 if B1023==4	// mix
	replace svymode=4 if B1023==5	// mix
	replace svymode=1 if C1023==1	// ftf
	replace svymode=2 if C1023==2	// telephone
	replace svymode=3 if C1023==3	// self-adm
	replace svymode=4 if C1023==4	// mix
	
	replace A1004="BELF1999" if A1004=="BEL_1999" & flanders==1
	replace A1004="BELW1999" if A1004=="BEL_1999" & wallonia==1
	
	replace A1004="BELF2003" if A1004=="BEL_2003" & flanders==1
	replace A1004="BELW2003" if A1004=="BEL_2003" & wallonia==1
	
	merge m:1 A1004BE using "JFR_data_formerging.dta"
	
	set more off
	eststo M1: xtmixed polknowledge female i.Qstructure i.svymode || A1004BE: , var
	
	
	* types of knowledge
	
	gen polknowledge1_institutions=1 if A1004=="CZE_2006"
	replace polknowledge1_institutions=1 if A1004=="DEU_2009"
	replace polknowledge1_institutions=1 if A1004=="NOR_2009"
	replace polknowledge1_institutions=1 if A1004=="BEL_2003"
	replace polknowledge1_institutions=1 if A1004=="KOR_2004"
	replace polknowledge1_institutions=1 if A1004=="MEX_1997"
	replace polknowledge1_institutions=1 if A1004=="MEX_2000"
	replace polknowledge1_institutions=1 if A1004=="JPN_2007"
	replace polknowledge1_institutions=1 if A1004=="BRA_2006"
	replace polknowledge1_institutions=1 if A1004=="ROU_2004"
	replace polknowledge1_institutions=1 if A1004=="BRA_2010"
	replace polknowledge1_institutions=1 if A1004=="AUS_2007"
	replace polknowledge1_institutions=1 if A1004=="NZL_2008"
	replace polknowledge1_institutions=1 if A1004=="AUS_1996"
	replace polknowledge1_institutions=1 if A1004=="SWE_2006"
	replace polknowledge1_institutions=1 if A1004=="FRA_2007"
	replace polknowledge1_institutions=1 if A1004=="MEX_2003"
	replace polknowledge1_institutions=1 if A1004=="GRC_2009"
	replace polknowledge1_institutions=1 if A1004=="CZE_1996"
	replace polknowledge1_institutions=1 if A1004=="SWE_1998"
	replace polknowledge1_institutions=1 if A1004=="EST_2011"
	replace polknowledge1_institutions=1 if A1004=="SVK_2010"
	replace polknowledge1_institutions=1 if A1004=="JPN_2004"
	replace polknowledge1_institutions=1 if A1004=="GBR_1997"
	replace polknowledge1_institutions=1 if A1004=="NLD_1998"
	replace polknowledge1_institutions=1 if A1004=="ROU_2009"
	replace polknowledge1_institutions=1 if A1004=="NZL_2002"
	replace polknowledge1_institutions=1 if A1004=="FIN_2007"
	replace polknowledge1_institutions=1 if A1004=="THA_2007"
	replace polknowledge1_institutions=1 if A1004=="NZL_1996"
	replace polknowledge1_institutions=1 if A1004=="CZE_2010"
	replace polknowledge1_institutions=1 if A1004=="ISR_2006"
	replace polknowledge1_institutions=1 if A1004=="GBR_2005"
	replace polknowledge1_institutions=1 if A1004=="PRT_2009"
	replace polknowledge1_institutions=1 if A1004=="ISR_1996"
	replace polknowledge1_institutions=1 if A1004=="PHL_2010"
	replace polknowledge1_institutions=1 if A1004=="UKR_1998"
	replace polknowledge1_institutions=1 if A1004=="KOR_2008"
	replace polknowledge1_institutions=1 if A1004=="DNK_2007"
	replace polknowledge1_institutions=1 if A1004=="CHL_2009"
	replace polknowledge1_institutions=1 if A1004=="RUS_2004"
	replace polknowledge1_institutions=1 if A1004=="PHL_2004"
	replace polknowledge1_institutions=1 if A1004=="ISR_2003"
	replace polknowledge1_institutions=1 if A1004=="HKG_2008"
	replace polknowledge1_institutions=1 if A1004=="MEX_2006"
	replace polknowledge1_institutions=1 if A1004=="HKG_2004"

	gen polknowledge1_politicians=1 if A1004=="BELF1999"
	replace polknowledge1_politicians=1 if A1004=="CAN_1997"
	replace polknowledge1_politicians=1 if A1004=="DEU_1998"
	replace polknowledge1_politicians=1 if A1004=="HKG_1998"
	replace polknowledge1_politicians=1 if A1004=="NOR_1997"
	replace polknowledge1_politicians=1 if A1004=="POL_1997"
	replace polknowledge1_politicians=1 if A1004=="PRT_2002"
	replace polknowledge1_politicians=1 if A1004=="CHE_1999"
	replace polknowledge1_politicians=1 if A1004=="TWN_1996"
	replace polknowledge1_politicians=1 if A1004=="USA_1996"
	replace polknowledge1_politicians=1 if A1004=="ALB_2005"
	replace polknowledge1_politicians=1 if A1004=="AUS_2004"
	replace polknowledge1_politicians=1 if A1004=="BRA_2002"
	replace polknowledge1_politicians=1 if A1004=="CAN_2004"
	replace polknowledge1_politicians=1 if A1004=="CHL_2005"
	replace polknowledge1_politicians=1 if A1004=="FIN_2003"
	replace polknowledge1_politicians=1 if A1004=="FRA_2002"
	replace polknowledge1_politicians=1 if A1004=="DEU_2002"
	replace polknowledge1_politicians=1 if A1004=="HUN_2002"
	replace polknowledge1_politicians=1 if A1004=="IRL_2002"
	replace polknowledge1_politicians=1 if A1004=="ITA_2006"
	replace polknowledge1_politicians=1 if A1004=="KGZ_2005"
	replace polknowledge1_politicians=1 if A1004=="NLD_2002"
	replace polknowledge1_politicians=1 if A1004=="NOR_2001"
	replace polknowledge1_politicians=1 if A1004=="PRT_2002"
	replace polknowledge1_politicians=1 if A1004=="PRT_2005"
	replace polknowledge1_politicians=1 if A1004=="SVN_2004"
	replace polknowledge1_politicians=1 if A1004=="ESP_2004"
	replace polknowledge1_politicians=1 if A1004=="CHE_2003"
	replace polknowledge1_politicians=1 if A1004=="TWN_2001"
	replace polknowledge1_politicians=1 if A1004=="USA_2004"
	replace polknowledge1_politicians=1 if A1004=="CAN_2008"
	replace polknowledge1_politicians=1 if A1004=="HRV_2007"
	replace polknowledge1_politicians=1 if A1004=="FIN_2011"
	replace polknowledge1_politicians=1 if A1004=="ISL_2007"
	replace polknowledge1_politicians=1 if A1004=="ISL_2009"
	replace polknowledge1_politicians=1 if A1004=="IRL_2007"
	replace polknowledge1_politicians=1 if A1004=="LVA_2010"
	replace polknowledge1_politicians=1 if A1004=="MEX_2009"
	replace polknowledge1_politicians=1 if A1004=="NLD_2006"
	replace polknowledge1_politicians=1 if A1004=="NLD_2010"
	replace polknowledge1_politicians=1 if A1004=="NOR_2005"
	replace polknowledge1_politicians=1 if A1004=="ZAF_2009"
	replace polknowledge1_politicians=1 if A1004=="ESP_2008"
	replace polknowledge1_politicians=1 if A1004=="CHE_2007"
	replace polknowledge1_politicians=1 if A1004=="USA_2008"

	generate polknowledge1_international=1 if A1004=="ESP_1996"
	replace polknowledge1_international=1 if A1004=="ESP_2000"
	replace polknowledge1_international=1 if A1004=="PER_2006"
	replace polknowledge1_international=1 if A1004=="POL_2001"
	replace polknowledge1_international=1 if A1004=="TWN_2004"
	replace polknowledge1_international=1 if A1004=="PER_2011"
	replace polknowledge1_international=1 if A1004=="POL_2007"
	replace polknowledge1_international=1 if A1004=="TWN_2008"

	generate polknowledge1_policy=1 if A1004=="JPN_1996"
	replace polknowledge1_policy=1 if A1004=="ROU_1996"
	replace polknowledge1_policy=1 if A1004=="SWE_2002"
	replace polknowledge1_policy=1 if A1004=="AUT_2008"
	replace polknowledge1_policy=1 if A1004=="DEU_2005"
	replace polknowledge1_policy=1 if A1004=="POL_2005"

	generate polknowledge2_institutions=1 if A1004=="AUS_1996"
	replace polknowledge2_institutions=1 if A1004=="DEU_1998"
	replace polknowledge2_institutions=1 if A1004=="GBR_1997"
	replace polknowledge2_institutions=1 if A1004=="HKG_1998"
	replace polknowledge2_institutions=1 if A1004=="HUN_1998"
	replace polknowledge2_institutions=1 if A1004=="MEX_1997"
	replace polknowledge2_institutions=1 if A1004=="MEX_2000"
	replace polknowledge2_institutions=1 if A1004=="NZL_1996"
	replace polknowledge2_institutions=1 if A1004=="NOR_1997"
	replace polknowledge2_institutions=1 if A1004=="POL_1997"
	replace polknowledge2_institutions=1 if A1004=="ESP_1996"
	replace polknowledge2_institutions=1 if A1004=="ESP_2000"
	replace polknowledge2_institutions=1 if A1004=="CHE_1999"
	replace polknowledge2_institutions=1 if A1004=="ALB_2005"
	replace polknowledge2_institutions=1 if A1004=="AUS_2004"
	replace polknowledge2_institutions=1 if A1004=="BEL_2003"
	replace polknowledge2_institutions=1 if A1004=="FRA_2002"
	replace polknowledge2_institutions=1 if A1004=="DEU_2002"
	replace polknowledge2_institutions=1 if A1004=="GBR_2005"
	replace polknowledge2_institutions=1 if A1004=="HKG_2004"
	replace polknowledge2_institutions=1 if A1004=="HUN_2002"
	replace polknowledge2_institutions=1 if A1004=="JPN_2004"
	replace polknowledge2_institutions=1 if A1004=="MEX_2003"
	replace polknowledge2_institutions=1 if A1004=="NZL_2002"
	replace polknowledge2_institutions=1 if A1004=="NOR_2001"
	replace polknowledge2_institutions=1 if A1004=="PER_2006"
	replace polknowledge2_institutions=1 if A1004=="PHL_2004"
	replace polknowledge2_institutions=1 if A1004=="PRT_2005"
	replace polknowledge2_institutions=1 if A1004=="KOR_2004"
	replace polknowledge2_institutions=1 if A1004=="ESP_2004"
	replace polknowledge2_institutions=1 if A1004=="CHE_2003"
	replace polknowledge2_institutions=1 if A1004=="TWN_2004"
	replace polknowledge2_institutions=1 if A1004=="AUS_2007"
	replace polknowledge2_institutions=1 if A1004=="CHL_2009"
	replace polknowledge2_institutions=1 if A1004=="HRV_2007"
	replace polknowledge2_institutions=1 if A1004=="CZE_2010"
	replace polknowledge2_institutions=1 if A1004=="DNK_2007"
	replace polknowledge2_institutions=1 if A1004=="FIN_2007"
	replace polknowledge2_institutions=1 if A1004=="FIN_2011"
	replace polknowledge2_institutions=1 if A1004=="FRA_2007"
	replace polknowledge2_institutions=1 if A1004=="DEU_2009"
	replace polknowledge2_institutions=1 if A1004=="GRC_2009"
	replace polknowledge2_institutions=1 if A1004=="HKG_2008"
	replace polknowledge2_institutions=1 if A1004=="JPN_2007"
	replace polknowledge2_institutions=1 if A1004=="LVA_2010"
	replace polknowledge2_institutions=1 if A1004=="MEX_2009"
	replace polknowledge2_institutions=1 if A1004=="NZL_2008"
	replace polknowledge2_institutions=1 if A1004=="NOR_2005"
	replace polknowledge2_institutions=1 if A1004=="PHL_2010"
	replace polknowledge2_institutions=1 if A1004=="ROU_2009"
	replace polknowledge2_institutions=1 if A1004=="KOR_2008"
	replace polknowledge2_institutions=1 if A1004=="SWE_2006"
	replace polknowledge2_institutions=1 if A1004=="CHE_2007"
	replace polknowledge2_institutions=1 if A1004=="THA_2007"

	generate polknowledge2_politicians=1 if A1004=="CAN_1997"
	replace polknowledge2_politicians=1 if A1004=="CZE_1996"
	replace polknowledge2_politicians=1 if A1004=="ISR_1996"
	replace polknowledge2_politicians=1 if A1004=="SWE_1998"
	replace polknowledge2_politicians=1 if A1004=="TWN_1996"
	replace polknowledge2_politicians=1 if A1004=="USA_1996"
	replace polknowledge2_politicians=1 if A1004=="BRA_2002"
	replace polknowledge2_politicians=1 if A1004=="CHL_2005"
	replace polknowledge2_politicians=1 if A1004=="IRL_2002"
	replace polknowledge2_politicians=1 if A1004=="ISR_2003"
	replace polknowledge2_politicians=1 if A1004=="ITA_2006"
	replace polknowledge2_politicians=1 if A1004=="KGZ_2005"
	replace polknowledge2_politicians=1 if A1004=="NLD_2002"
	replace polknowledge2_politicians=1 if A1004=="POL_2001"
	replace polknowledge2_politicians=1 if A1004=="ROU_2004"
	replace polknowledge2_politicians=1 if A1004=="RUS_2004"
	replace polknowledge2_politicians=1 if A1004=="TWN_2001"
	replace polknowledge2_politicians=1 if A1004=="BRA_2006"
	replace polknowledge2_politicians=1 if A1004=="BRA_2010"
	replace polknowledge2_politicians=1 if A1004=="EST_2011"
	replace polknowledge2_politicians=1 if A1004=="ISL_2007"
	replace polknowledge2_politicians=1 if A1004=="ISL_2009"
	replace polknowledge2_politicians=1 if A1004=="ISR_2006"
	replace polknowledge2_politicians=1 if A1004=="MEX_2006"
	replace polknowledge2_politicians=1 if A1004=="NLD_2006"
	replace polknowledge2_politicians=1 if A1004=="NLD_2010"
	replace polknowledge2_politicians=1 if A1004=="NOR_2009"
	replace polknowledge2_politicians=1 if A1004=="PER_2011"
	replace polknowledge2_politicians=1 if A1004=="SVK_2010"
	replace polknowledge2_politicians=1 if A1004=="ZAF_2009"
	replace polknowledge2_politicians=1 if A1004=="TWN_2008"
	replace polknowledge2_politicians=1 if A1004=="USA_2008"

	generate polknowledge2_international=1 if A1004=="NLD_1998"
	replace polknowledge2_international=1 if A1004=="PRT_2002"
	replace polknowledge2_international=1 if A1004=="UKR_1998"
	replace polknowledge2_international=1 if A1004=="PRT_2002"
	replace polknowledge2_international=1 if A1004=="SVN_2004"
	replace polknowledge2_international=1 if A1004=="USA_2004"
	replace polknowledge2_international=1 if A1004=="CAN_2008"
	replace polknowledge2_international=1 if A1004=="CZE_2006"
	replace polknowledge2_international=1 if A1004=="POL_2007"
	replace polknowledge2_international=1 if A1004=="PRT_2009"

	generate polknowledge2_policy=1 if A1004=="BELF1999"
	replace polknowledge2_policy=1 if A1004=="JPN_1996"
	replace polknowledge2_policy=1 if A1004=="ROU_1996"
	replace polknowledge2_policy=1 if A1004=="CAN_2004"
	replace polknowledge2_policy=1 if A1004=="FIN_2003"
	replace polknowledge2_policy=1 if A1004=="SWE_2002"
	replace polknowledge2_policy=1 if A1004=="AUT_2008"
	replace polknowledge2_policy=1 if A1004=="DEU_2005"
	replace polknowledge2_policy=1 if A1004=="IRL_2007"
	replace polknowledge2_policy=1 if A1004=="POL_2005"
	replace polknowledge2_policy=1 if A1004=="ESP_2008"

	generate polknowledge3_institutions=1 if A1004=="AUS_1996"
	replace polknowledge3_institutions=1 if A1004=="CZE_1996"
	replace polknowledge3_institutions=1 if A1004=="GBR_1997"
	replace polknowledge3_institutions=1 if A1004=="HKG_1998"
	replace polknowledge3_institutions=1 if A1004=="MEX_1997"
	replace polknowledge3_institutions=1 if A1004=="MEX_2000"
	replace polknowledge3_institutions=1 if A1004=="NZL_1996"
	replace polknowledge3_institutions=1 if A1004=="CHE_1999"
	replace polknowledge3_institutions=1 if A1004=="ALB_2005"
	replace polknowledge3_institutions=1 if A1004=="BEL_2003"
	replace polknowledge3_institutions=1 if A1004=="CHL_2005"
	replace polknowledge3_institutions=1 if A1004=="GBR_2005"
	replace polknowledge3_institutions=1 if A1004=="HKG_2004"
	replace polknowledge3_institutions=1 if A1004=="ITA_2006"
	replace polknowledge3_institutions=1 if A1004=="JPN_2004"
	replace polknowledge3_institutions=1 if A1004=="NZL_2002"
	replace polknowledge3_institutions=1 if A1004=="ROU_2004"
	replace polknowledge3_institutions=1 if A1004=="SVN_2004"
	replace polknowledge3_institutions=1 if A1004=="CHE_2003"
	replace polknowledge3_institutions=1 if A1004=="TWN_2001"
	replace polknowledge3_institutions=1 if A1004=="TWN_2004"
	replace polknowledge3_institutions=1 if A1004=="AUS_2007"
	replace polknowledge3_institutions=1 if A1004=="BRA_2006"
	replace polknowledge3_institutions=1 if A1004=="BRA_2010"
	replace polknowledge3_institutions=1 if A1004=="HRV_2007"
	replace polknowledge3_institutions=1 if A1004=="CZE_2006"
	replace polknowledge3_institutions=1 if A1004=="FIN_2007"
	replace polknowledge3_institutions=1 if A1004=="DEU_2009"
	replace polknowledge3_institutions=1 if A1004=="GRC_2009"
	replace polknowledge3_institutions=1 if A1004=="HKG_2008"
	replace polknowledge3_institutions=1 if A1004=="ISL_2007"
	replace polknowledge3_institutions=1 if A1004=="ISL_2009"
	replace polknowledge3_institutions=1 if A1004=="JPN_2007"
	replace polknowledge3_institutions=1 if A1004=="LVA_2010"
	replace polknowledge3_institutions=1 if A1004=="MEX_2006"
	replace polknowledge3_institutions=1 if A1004=="MEX_2009"
	replace polknowledge3_institutions=1 if A1004=="NZL_2008"
	replace polknowledge3_institutions=1 if A1004=="NOR_2005"
	replace polknowledge3_institutions=1 if A1004=="PER_2011"
	replace polknowledge3_institutions=1 if A1004=="PHL_2010"
	replace polknowledge3_institutions=1 if A1004=="POL_2007"
	replace polknowledge3_institutions=1 if A1004=="CHE_2007"
	replace polknowledge3_institutions=1 if A1004=="TWN_2008"
	replace polknowledge3_institutions=1 if A1004=="THA_2007"

	generate polknowledge3_politicians=1 if A1004=="CAN_1997"
	replace polknowledge3_politicians=1 if A1004=="HUN_1998"
	replace polknowledge3_politicians=1 if A1004=="NLD_1998"
	replace polknowledge3_politicians=1 if A1004=="NOR_1997"
	replace polknowledge3_politicians=1 if A1004=="PRT_2002"
	replace polknowledge3_politicians=1 if A1004=="ESP_1996"
	replace polknowledge3_politicians=1 if A1004=="ESP_2000"
	replace polknowledge3_politicians=1 if A1004=="SWE_1998"
	replace polknowledge3_politicians=1 if A1004=="TWN_1996"
	replace polknowledge3_politicians=1 if A1004=="UKR_1998"
	replace polknowledge3_politicians=1 if A1004=="USA_1996"
	replace polknowledge3_politicians=1 if A1004=="BRA_2002"
	replace polknowledge3_politicians=1 if A1004=="FRA_2002"
	replace polknowledge3_politicians=1 if A1004=="HUN_2002"
	replace polknowledge3_politicians=1 if A1004=="IRL_2002"
	replace polknowledge3_politicians=1 if A1004=="KGZ_2005"
	replace polknowledge3_politicians=1 if A1004=="MEX_2003"
	replace polknowledge3_politicians=1 if A1004=="NLD_2002"
	replace polknowledge3_politicians=1 if A1004=="NOR_2001"
	replace polknowledge3_politicians=1 if A1004=="PER_2006"
	replace polknowledge3_politicians=1 if A1004=="PHL_2004"
	replace polknowledge3_politicians=1 if A1004=="PRT_2002"
	replace polknowledge3_politicians=1 if A1004=="RUS_2004"
	replace polknowledge3_politicians=1 if A1004=="KOR_2004"
	replace polknowledge3_politicians=1 if A1004=="USA_2004"
	replace polknowledge3_politicians=1 if A1004=="CAN_2008"
	replace polknowledge3_politicians=1 if A1004=="FRA_2007"
	replace polknowledge3_politicians=1 if A1004=="NLD_2006"
	replace polknowledge3_politicians=1 if A1004=="NLD_2010"
	replace polknowledge3_politicians=1 if A1004=="PRT_2009"
	replace polknowledge3_politicians=1 if A1004=="ZAF_2009"
	replace polknowledge3_politicians=1 if A1004=="KOR_2008"
	replace polknowledge3_politicians=1 if A1004=="SWE_2006"
	replace polknowledge3_politicians=1 if A1004=="USA_2008"

	generate polknowledge3_international=1 if A1004=="BELF1999"
	replace polknowledge3_international=1 if A1004=="DEU_1998"
	replace polknowledge3_international=1 if A1004=="POL_1997"
	replace polknowledge3_international=1 if A1004=="FIN_2003"
	replace polknowledge3_international=1 if A1004=="DEU_2002"
	replace polknowledge3_international=1 if A1004=="POL_2001"
	replace polknowledge3_international=1 if A1004=="PRT_2005"
	replace polknowledge3_international=1 if A1004=="ESP_2004"
	replace polknowledge3_international=1 if A1004=="CZE_2010"
	replace polknowledge3_international=1 if A1004=="EST_2011"
	replace polknowledge3_international=1 if A1004=="FIN_2011"
	replace polknowledge3_international=1 if A1004=="ROU_2009"
	replace polknowledge3_international=1 if A1004=="SVK_2010"

	generate polknowledge3_policy=1 if A1004=="ISR_1996"
	replace polknowledge3_policy=1 if A1004=="AUS_2004"
	replace polknowledge3_policy=1 if A1004=="CAN_2004"
	replace polknowledge3_policy=1 if A1004=="ISR_2003"
	replace polknowledge3_policy=1 if A1004=="SWE_2002"
	replace polknowledge3_policy=1 if A1004=="AUT_2008"
	replace polknowledge3_policy=1 if A1004=="DNK_2007"
	replace polknowledge3_policy=1 if A1004=="DEU_2005"
	replace polknowledge3_policy=1 if A1004=="IRL_2007"
	replace polknowledge3_policy=1 if A1004=="ISR_2006"
	replace polknowledge3_policy=1 if A1004=="NOR_2009"
	replace polknowledge3_policy=1 if A1004=="POL_2005"
	replace polknowledge3_policy=1 if A1004=="ESP_2008"


	recode polknowledge1_institutions polknowledge1_politicians ///
	polknowledge1_international polknowledge1_policy polknowledge2_institutions ///
	polknowledge2_politicians polknowledge2_international polknowledge2_policy ///
	polknowledge3_institutions polknowledge3_politicians polknowledge3_international ///
	polknowledge3_policy (.=0)

	generate total_institutions=polknowledge1_institutions+polknowledge2_institutions+polknowledge3_institutions
	generate total_politicians=polknowledge1_politicians+polknowledge2_politicians+polknowledge3_politicians
	generate total_international=polknowledge1_international+polknowledge2_international+polknowledge3_international
	generate total_policy=polknowledge1_policy+polknowledge2_policy+polknowledge3_policy

	generate polinfo_1=polinfo1_mod1 if Module==1
	replace polinfo_1=polinfo1_mod2 if Module==2
	replace polinfo_1=polinfo1_mod3 if Module==3

	generate polinfo_2=polinfo2_mod1 if Module==1
	replace polinfo_2=polinfo2_mod2 if Module==2
	replace polinfo_2=polinfo2_mod3 if Module==3

	generate polinfo_3=polinfo3_mod1 if Module==1
	replace polinfo_3=polinfo3_mod2 if Module==2
	replace polinfo_3=polinfo3_mod3 if Module==3

	generate institutionalknowledge=((polinfo_1 * polknowledge1_institutions) + (polinfo_2 * polknowledge2_institutions) ///
	+ (polinfo_3 * polknowledge3_institutions))/total_institutions
	generate politiciansknowledge=((polinfo_1 * polknowledge1_politicians) + (polinfo_2 * polknowledge2_politicians) ///
	+ (polinfo_3 * polknowledge3_politicians))/total_politicians
	generate internationalknowledge=((polinfo_1 * polknowledge1_international) + (polinfo_2 * polknowledge2_international) ///
	+ (polinfo_3 * polknowledge3_international))/total_international
	generate policyknowledge=((polinfo_1 * polknowledge1_policy) + (polinfo_2 * polknowledge2_policy) ///
	+ (polinfo_3 * polknowledge3_policy))/total_policy

	replace institutionalknowledge=polinfo3_mod4 if Module==4
	replace politiciansknowledge=polinfo1_mod4 if Module==4
	replace internationalknowledge=polinfo4_mod4 if Module==4
	replace policyknowledge=polinfo2_mod4 if Module==4

	ttest polknowledge if Module!=4, by(female)
	ttest institutionalknowledge if Module!=4, by(female)
	ttest politiciansknowledge if Module!=4, by(female)
	ttest internationalknowledge if Module!=4, by(female)
	ttest policyknowledge if Module!=4, by(female)
	
	ttest polknowledge if Module==4, by(female)
	ttest institutionalknowledge if Module==4, by(female)
	ttest politiciansknowledge if Module==4, by(female)
	ttest internationalknowledge if Module==4, by(female)
	ttest policyknowledge if Module==4, by(female)
	
	* gender gap for types of knowledge, controling for mode and question format effects
	eststo M2: xtmixed institutionalknowledge female i.Qstructure i.svymode || A1004BE: , var
	eststo M3: xtmixed politiciansknowledge female i.Qstructure i.svymode || A1004BE: , var
	eststo M4: xtmixed internationalknowledge female i.Qstructure i.svymode || A1004BE: , var
	eststo M5: xtmixed policyknowledge female i.Qstructure i.svymode || A1004BE: , var

	
* APPENDIX 4: Gender differences in proximity voting and correct voting, additional controls

	* proximity voting
	use "cses_gender_proximity.dta", clear
	
	* limit dataset to samples with at least 250 resondents
	gen col_voteclosest_coded=1 if col_voteclosest!=.

	sort A1004
	by A1004: egen N_col_voteclosest_coded=sum(col_voteclosest_coded)

	keep if N_col_voteclosest_coded>249
	drop if A1004=="ROU_2012"				// levels of correct voting close to zero
	
	keep if age!=.
	keep if college!=.
	keep if income!=.

	* combine weights
	gen weight=sampleweight*demoweight

	* bivariate analysis
	encode A1004, gen(election) 
	order election, before(A1004)
	numlabel, add force
	tab election
	
	set more off
	tempname gender_bivariate4
	
	postfile `gender_bivariate4' sample b_female se_female using gender_bivariate4.dta, replace
	
	foreach lname of numlist 1(1)130 {  		// loop to repeat the same command for each election sample
	local t : label election `lname'
		noisily logit  col_voteclosest female age college income if election==`lname' [pweight=weight]
		eststo M_`lname': margins ,  dydx(*) post
		post `gender_bivariate4' (`lname') (`=_b[female]') (`=_se[female]')
		}
		
	postclose `gender_bivariate4'

	use "gender_bivariate4.dta", clear


	* correct voting
	
	use "lau et al_cses_correct.dta", clear
	
	recode CorrVt11 CorrVt12 CorrVt21 CorrVt22 (9=.)
	
	gen correctvote=CorrVt21		// weighted + directional
	
	keep if Income!=.
	keep if Educatin!=.
	keep if Age!=.
	
	gen female=Female
	
	encode ContryYr, gen(ContryYr2)
	replace ContryYr2=4 if ContryYr2==5

	tab ContryYr2
	
	set more off
	tempname gender_bivariate5
	
	postfile `gender_bivariate5' sample b_female se_female using gender_bivariate5.dta, replace
	
	foreach lname of numlist 1 2 3 4 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 ///
	24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 ///
	51 52 53 54 55 56 57 58 {  		// loop to repeat the same command for each election sample
	local t : label ContryYr2 `lname'
		noisily logit  correctvote female Age Educatin Income if ContryYr2==`lname' 
		eststo M_`lname': margins ,  dydx(*) post
		post `gender_bivariate5' (`lname') (`=_b[female]') (`=_se[female]')
		}
		
	postclose `gender_bivariate5'

	use "gender_bivariate5.dta", clear
	

	
* APPENDIX 5: gender differences for different operationalizations of correct voting


	use "lau et al_cses_correct.dta", clear
	
	recode CorrVt11 CorrVt12 CorrVt21 CorrVt22 (9=.)

	ttest CorrVt11, by(Female)
	ttest CorrVt12, by(Female)
	ttest CorrVt21, by(Female)
	ttest CorrVt22, by(Female)
	
	
* APPENDIX 6: explaining proximity voting and correct voting, men and women

	* 1. proximity voting
	use "cses_gender_proximity.dta", clear
	
	* limit dataset to samples with at least 250 resondents
	gen col_voteclosest_coded=1 if col_voteclosest!=.

	sort A1004
	by A1004: egen N_col_voteclosest_coded=sum(col_voteclosest_coded)

	keep if N_col_voteclosest_coded>249
	drop if A1004=="ROU_2012"				// levels of correct voting close to zero

	* combine weights
	gen weight=sampleweight*demoweight
	
	* analyses
		
	eststo M1 : xtmelogit col_voteclosest female age college income ///
	polknowledge  efficacy partyid || A1004: , var
	
	eststo M2 : xtmelogit col_voteclosest i.female##c.age i.female##i.college i.female##c.income ///
	i.female##c.polknowledge  i.female##c.efficacy i.female##i.partyid || A1004: , var
	
	* 2. correct voting
	use "lau et al_cses_correct.dta", clear
	
	recode CorrVt11 CorrVt12 CorrVt21 CorrVt22 (9=.)
	
	gen correctvote=CorrVt21		// weighted + directional

	eststo M3 : xtmelogit correctvote Female Age  Educatin Income ///
	PolKnow Efficacy || ContryYr: , var
	
	eststo M4 : xtmelogit correctvote i.Female##c.Age  i.Female##c.Educatin i.Female##c.Income ///
	i.Female##c.PolKnow i.Female##c.Efficacy || ContryYr: , var

	esttab M1 M2 M3 M4 using table_app6.tex, b(3) se(3) nogap replace
	
	

* APPENDIX 7: summary and descriptive statitistics for all variables

	* 1. cses proximity (Modules 1-4)
	use "cses_gender_proximity.dta", clear
	
	* limit dataset to samples with at least 250 resondents
	gen col_voteclosest_coded=1 if col_voteclosest!=.

	sort A1004
	by A1004: egen N_col_voteclosest_coded=sum(col_voteclosest_coded)

	keep if N_col_voteclosest_coded>249
	drop if A1004=="ROU_2012"				// levels of correct voting close to zero

	* combine weights
	gen weight=sampleweight*demoweight
	
	* retrieve descriptives
	gen filter=1
	replace filter=0 if mi(col_voteclosest, female, age, college, income, polknowledge, efficacy, partyid )

	sum col_voteclosest female age college income polknowledge efficacy partyid if filter==1
	
	* 2. cses correct voting (Modules 1-2)
	use "lau et al_cses_correct.dta", clear
	
	recode CorrVt11 CorrVt12 CorrVt21 CorrVt22 (9=.)
	
	gen correctvote=CorrVt21		// weighted + directional
	
	gen filter=1
	replace filter=0 if mi(correctvote, Female, Age, Educatin, Income, PolKnow, Efficacy )
	
	sum correctvote Female Age Educatin Income PolKnow Efficacy if filter==1


* APPENDIX 8: explaining variation in proximity voting, cross-level interactions

	use "cses_gender_proximity.dta", clear
	
	* limit dataset to samples with at least 250 resondents
	gen col_voteclosest_coded=1 if col_voteclosest!=.

	sort A1004
	by A1004: egen N_col_voteclosest_coded=sum(col_voteclosest_coded)

	keep if N_col_voteclosest_coded>249
	drop if A1004=="ROU_2012"				// levels of correct voting close to zero

	* combine weights
	gen weight=sampleweight*demoweight
	
	* analyses
	eststo M1 : xtmelogit col_voteclosest female age college income ///
	polknowledge  efficacy partyid env i.female##c.lsq i.female##c.women_parliament || A1004: , var
	
	eststo M2 : xtmelogit col_voteclosest female age college income ///
	polknowledge  efficacy partyid env i.female##c.lsq i.female##c.women_leaders || A1004: , var
	
	eststo M3 : xtmelogit col_voteclosest female age college income ///
	polknowledge  efficacy partyid env i.female##c.lsq i.female##c.time_women_suffrage || A1004: , var

	eststo M4 : xtmelogit col_voteclosest female age college income ///
	polknowledge  efficacy partyid env i.female##c.lsq i.female##c.v2x_gender || A1004: , var

	
	esttab M1 M2 M3 M4 using table_app7.tex, b(3) se(3) nogap replace

	
	
	
* APPENDIX 9: ideological understanding, gender gaps and its role for explaining proximity and correct voting
	
	use "cses_gender_proximity.dta", clear
	
	
	* limit dataset to samples with at least 250 resondents
	gen col_voteclosest_coded=1 if col_voteclosest!=.

	sort A1004
	by A1004: egen N_col_voteclosest_coded=sum(col_voteclosest_coded)

	keep if N_col_voteclosest_coded>249
	drop if A1004=="ROU_2012"				// levels of correct voting close to zero

	* combine weights
	gen weight=sampleweight*demoweight

	* descriptives ideological understanding
	
	gen knowledgeparties_01=knowledgeparties/3
	tab knowledgeparties_01
	
	* correlation ideological understanding - factula knowledge
	
	pwcorr knowledgeparties_01 polknowledge, sig
	
	* explaining ideological understanding
	
	eststo M1 : mixed polknowledge female ///
	|| A1004:   , var
	
	eststo M2 : mixed knowledgeparties_01 female ///
	|| A1004: , var
	
	eststo M3 : mixed knowledgeparties_01 female age college income ///
	  efficacy partyid   || A1004: , var
	  
	eststo M4 : mixed knowledgeparties_01 female age college income ///
	  efficacy partyid env lsq   || A1004: , var

	esttab M1 M2 M3 M4 using table1_app9.tex, b(3) se(3) nogap replace
	esttab M1 M2 M3 M5 using table1_app9.rtf, b(3) se(3) nogap replace
	  
	  
	* bivariate test of gender gap in ideological understanding
	
	keep if knowledgeparties!=.
	
	encode A1004, gen(election) 
	order election, before(A1004)
	numlabel, add force
	tab election
		
	set more off
	tempname gender_bivariate6
	
	postfile `gender_bivariate6' sample b_female se_female using gender_bivariate6.dta, replace
	
	foreach lname of numlist 1(1)125 {  		// loop to repeat the same command for each election sample
	local t : label election `lname'
		noisily reg  knowledgeparties female if election==`lname' [pweight=weight]
		post `gender_bivariate6' (`lname') (`=_b[female]') (`=_se[female]')
		}
		
	postclose `gender_bivariate6'

	 
	* explaining proximity voting with different types of knowledge 
	
	use "cses_gender_proximity.dta", clear
	
	* limit dataset to samples with at least 250 resondents
	gen col_voteclosest_coded=1 if col_voteclosest!=.

	sort A1004
	by A1004: egen N_col_voteclosest_coded=sum(col_voteclosest_coded)

	keep if N_col_voteclosest_coded>249
	drop if A1004=="ROU_2012"				// levels of correct voting close to zero

	* combine weights
	gen weight=sampleweight*demoweight
	
	* analyses
	gen knowledgeparties_01=knowledgeparties/3
	
	eststo M1 : melogit col_voteclosest female age college income ///
	polknowledge  efficacy partyid || A1004: 
	
	eststo M2 : melogit col_voteclosest female age college income ///
	knowledgeparties_01  efficacy partyid || A1004: 
	
	eststo M3 : melogit col_voteclosest female age college income ///
	polknowledge knowledgeparties_01  efficacy partyid || A1004: 
	
		  
	esttab  M1 M2 M3 using table2_app9.tex, b(3) se(3) nogap replace
	esttab  M1 M2 M3 using table2_app9.rtf, b(3) se(3) nogap replace

	
	
	* explaining correct voting with different types of knowledge
	
	use "cses_gender_proximity.dta", clear
	
	keep if Module==1 | Module==2
	
	tostring A1009 ,  replace  format("%12.0f")
		
	gen MCYI=""
	recast str30 MCYI
	format %30s MCYI
	
	replace MCYI=string(Module)+A1004BE+"_"+A1009
	recast str30 MCYI
	format %30s MCYI
		
	drop if A1004=="DEU_2002" 		// online sample Germany 2002 	
		
	merge 1:1 MCYI using "lau et al_cses_correct.dta"  
	  
	recode CorrVt11 CorrVt12 CorrVt21 CorrVt22 (9=.)
	
	gen knowledgeparties_01=knowledgeparties/3
	
	eststo M1 : melogit CorrVt22 female age college income ///
	polknowledge   efficacy partyid || A1004:  
	
	eststo M2 : melogit CorrVt22 female age college income ///
	knowledgeparties_01  efficacy partyid || A1004:  
	
	eststo M3 : melogit CorrVt22 female age college income ///
	polknowledge knowledgeparties_01  efficacy partyid || A1004:  
	
	  
	esttab  M1 M2 M3 using table3_app9.tex, b(3) se(3) nogap replace
	esttab  M1 M2 M3 using table3_app9.rtf, b(3) se(3) nogap replace

	
	
	
	

	
