******************************************************************************
** TITLE:	Compulsory voting rules, reluctant voters and proximity	voting	**
** AUTHORS:	Dassonneville, Feitosa, Hooghe, Lau & Stiers 					**
** PURPOSE:	Replication of main results and supplementary materials			**
** DATE:	February, 2018 													**
******************************************************************************


/* set the working to the folder where you saved all the materials for replication */

	cd "/Users/ruthdassonneville/Box Sync/Compulsory Voting and correct voting/Replication materials dataverse"



**************************************
** MAIN RESULTS: MANUSCRIPT 		**
**************************************


/* FIGURE 1: impact of CV on choosing most proximate party -
the following code is used to estimate the logit models (reported
in appendix G, H and I) and to obtain the average marginal effect of being
reluctant to turn out to vote */


** Australia **

	use "Australia_2001_for_replication.dta" , clear
	logit voteclosest turnout i.gender age i.education pid 	// reported in Appendix G
	margins , dydx(turnout)									// illustrated in Fig 1

	use "Australia_2004_for_replication.dta" , clear
	logit voteclosest turnout i.gender age i.education pid 	// reported in Appendix G
	margins , dydx(turnout)									// illustrated in Fig 1

	use "Australia_2007_for_replication.dta" , clear
	logit voteclosest turnout i.gender age i.education pid 	// reported in Appendix G
	margins , dydx(turnout)									// illustrated in Fig 1

	use "Australia_2010_for_replication.dta" , clear
	logit voteclosest turnout i.gender age i.education pid 	// reported in Appendix G
	margins , dydx(turnout)									// illustrated in Fig 1

	use "Australia_2013_for_replication.dta" , clear
	logit voteclosest turnout i.gender age i.education pid 	// reported in Appendix G
	margins , dydx(turnout)									// illustrated in Fig 1

** Belgium (Flanders) **

	use "Flanders_1991_for_replication.dta" , clear			// reported in Appendix H
	logit voteclosest turnout i.gender age i.education		// illustrated in Fig 1
	margins , dydx(turnout)
	
	use "Flanders_1999_for_replication.dta" , clear			// reported in Appendix H
	logit voteclosest turnout i.gender age i.education		// illustrated in Fig 1
	margins , dydx(turnout)
	
	use "Flanders_2014_for_replication.dta" , clear			
	logit voteclosest turnout i.gender age i.education pidstrength	// reported in Appendix H
	margins , dydx(turnout)									// illustrated in Fig 1
	
** Belgium (Wallonia) **

	use "Wallonia_1991_for_replication.dta" , clear			// reported in Appendix H
	logit voteclosest turnout i.gender age i.education		// illustrated in Fig 1
	margins , dydx(turnout)
	
	use "Wallonia_1999_for_replication.dta" , clear			// reported in Appendix H
	logit voteclosest turnout i.gender age i.education		// illustrated in Fig 1
	margins , dydx(turnout)
	
	use "Wallonia_2014_for_replication.dta" , clear			
	logit voteclosest turnout i.gender age i.education pidstrength	// reported in Appendix H
	margins , dydx(turnout)									// illustrated in Fig 1
	
** Brazil **

	use "Brazil_2002_for_replication" , clear
	logit voteclosest turnout i.gender age i.education pid [pweight=weight]	// reported in Appendix I
	margins , dydx(turnout)						// illustrated in Fig 1
	
	use "Brazil_2006_for_replication" , clear
	logit voteclosest turnout i.gender age i.education pid [pweight=weight]	// reported in Appendix I
	margins , dydx(turnout)						// illustrated in Fig 1
	
	use "Brazil_2010_for_replication" , clear
	logit voteclosest turnout i.gender age i.education pid // reported in Appendix I
	margins , dydx(turnout)						// illustrated in Fig 1
	
	use "Brazil_2014_for_replication" , clear
	logit voteclosest turnout i.gender age i.education pid [pweight=weight]	// reported in Appendix I
	margins , dydx(turnout)						// illustrated in Fig 1
	
	

/* FIGURE 2: moderating impact of CV on effect of ideological distance on voting for a party -
the following code is used to estimate the logit models (reported in appendix K, L and M) and to obtain 
the coefficient of the interaction "CV x ideological distance" that is reported in Figure 2 */

** Australia **
	
	use "Australia_2001_for_replication.dta" , clear
	*reshape data to long format
	reshape long voteforparty distancetoparty pidstrength , i(acc) j(Party)
	*generate interaction
	gen distanceXturnout=distancetoparty*turnout
	*estimate model
	xi: asclogit voteforparty distancetoparty distanceXturnout pidstrength ///
	, case(acc) alternatives(Party) casevars(turnout i.gender age i.education ///
	socialclass religiousattendance)
	estat ic

	use "Australia_2004_for_replication.dta" , clear
	*reshape data to long format
	reshape long voteforparty distancetoparty pidstrength , i(acc) j(Party)
	*generate interaction
	gen distanceXturnout=distancetoparty*turnout
	*estimate model
	xi: asclogit voteforparty distancetoparty distanceXturnout pidstrength ///
	, case(acc) alternatives(Party) casevars(turnout i.gender age i.education ///
	socialclass religiousattendance)
	estat ic
	
	use "Australia_2007_for_replication.dta" , clear
	*reshape data to long format
	reshape long voteforparty distancetoparty pidstrength , i(acc) j(Party)
	*generate interaction
	gen distanceXturnout=distancetoparty*turnout
	*estimate model
	xi: asclogit voteforparty distancetoparty distanceXturnout pidstrength ///
	, case(acc) alternatives(Party) casevars(turnout i.gender age i.education ///
	socialclass religiousattendance)
	estat ic
	
	use "Australia_2010_for_replication.dta" , clear
	*reshape data to long format
	reshape long voteforparty distancetoparty pidstrength , i(uniqueid) j(Party)
	*generate interaction
	gen distanceXturnout=distancetoparty*turnout
	*estimate model
	xi: asclogit voteforparty distancetoparty distanceXturnout pidstrength ///
	, case(uniqueid) alternatives(Party) casevars(turnout i.gender age i.education ///
	socialclass religiousattendance)
	estat ic
	
	use "Australia_2013_for_replication.dta" , clear
	*reshape data to long format
	reshape long voteforparty distancetoparty pidstrength , i(uniqueid) j(Party)
	*generate interaction
	gen distanceXturnout=distancetoparty*turnout
	*estimate model
	xi: asclogit voteforparty distancetoparty distanceXturnout pidstrength ///
	, case(uniqueid) alternatives(Party) casevars(turnout i.gender age i.education ///
	socialclass religiousattendance)
	estat ic
	
** Belgium (Flanders) **

	use "Flanders_1991_for_replication.dta" , clear
	*reshape data to long format
	reshape long voteforparty distancetoparty , i(V0_0) j(Party)
	*generate interaction
	gen distanceXturnout=distancetoparty*turnout
	*estimate model
	xi: asclogit voteforparty distancetoparty distanceXturnout , case(V0_0) alternatives(Party) ///
	casevars(turnout i.gender age i.education socialclass religiousattendance) basealternative(2)
	estat ic
	
	use "Flanders_1999_for_replication.dta" , clear
	*reshape data to long format
	reshape long voteforparty distancetoparty , i(R0_0) j(Party)
	*generate interaction
	gen distanceXturnout=distancetoparty*turnout
	*estimate model
	xi: asclogit voteforparty distancetoparty distanceXturnout , case(R0_0) alternatives(Party) ///
	casevars(turnout i.gender age i.education socialclass religiousattendance) basealternative(4)
	estat ic
	
	use "Flanders_2014_for_replication.dta" , clear
	*reshape data to long format
	reshape long voteforparty distancetoparty , i(intnr) j(Party)
	*generate interaction
	gen distanceXturnout=distancetoparty*turnout
	*estimate model
	xi: asclogit voteforparty distancetoparty distanceXturnout , case(intnr) alternatives(Party) ///
	casevars(turnout i.gender age i.education income religiousattendance) basealternative(3)
	estat ic
	
	
** Belgium (Wallonia) **

	/* note that for the analysis of Wallonia 1991, we included education as a continuous
	variable because a model with education as a categorical variable did not converge */
	
	use "Wallonia_1991_for_replication.dta" , clear
	*reshape data to long format
	reshape long voteforparty distancetoparty , i(V0_0) j(Party)
	*generate interaction
	gen distanceXturnout=distancetoparty*turnout
	*estimate model
	xi: asclogit voteforparty distancetoparty distanceXturnout , case(V0_0) alternatives(Party) ///
	casevars(turnout i.gender age education socialclass religiousattendance)
	estat ic
	
	use "Wallonia_1999_for_replication.dta" , clear
	*reshape data to long format
	reshape long voteforparty distancetoparty , i(R0_0) j(Party)
	*generate interaction
	gen distanceXturnout=distancetoparty*turnout
	*estimate model
	xi: asclogit voteforparty distancetoparty distanceXturnout , case(R0_0) alternatives(Party) ///
	casevars(turnout i.gender age i.education socialclass religiousattendance) basealternative(9)
	estat ic
	
	use "Wallonia_2014_for_replication.dta" , clear
	*reshape data to long format
	reshape long voteforparty distancetoparty , i(intnr) j(Party)
	*generate interaction
	gen distanceXturnout=distancetoparty*turnout
	*estimate model
	xi: asclogit voteforparty distancetoparty distanceXturnout , case(intnr) alternatives(Party) ///
	casevars(turnout i.gender age i.education income religiousattendance) basealternative(20)
	estat ic

	
** Brazil **

	use "Brazil_2002_for_replication" , clear
	*reshape data to long format
	reshape long voteforparty distancetoparty pidstrength , i(id) j(Party)
	*generate interaction
	gen distanceXturnout=distance*turnout
	*analysis
	xi: asclogit voteforparty distancetoparty pidstrength distanceXturnout [pweight=weight] , case(id) ///
	alternatives(Party) casevars(turnout i.gender age i.education socialclass) 
	estat ic
	
	use "Brazil_2006_for_replication" , clear
	*reshape data to long format
	reshape long voteforparty distancetoparty pidstrength , i(id) j(Party)
	*generate interaction
	gen distanceXturnout=distance*turnout
	*analysis
	xi: asclogit voteforparty distancetoparty pidstrength distanceXturnout [pweight=weight] , case(id) ///
	alternatives(Party) casevars(turnout i.gender age i.education socialclass) 
	estat ic
	
	use "Brazil_2010_for_replication" , clear
	*reshape data to long format
	reshape long voteforparty distancetoparty pidstrength , i(id) j(Party)
	*generate interaction
	gen distanceXturnout=distance*turnout
	*analysis
	xi: asclogit voteforparty distancetoparty pidstrength distanceXturnout , case(id) ///
	alternatives(Party) casevars(turnout i.gender age i.education socialclass) 
	estat ic

	use "Brazil_2014_for_replication" , clear
	reshape long voteforparty distancetoparty pidstrength , i(id) j(Party)
	*generate interaction
	gen distanceXturnout=distance*turnout
	*analysis
	xi: asclogit voteforparty distancetoparty pidstrength distanceXturnout [pweight=weight] , case(id) ///
	alternatives(Party) casevars(turnout i.gender age i.education socialclass) 
	estat ic
	

/* Figure 3 summarizes reported levels of turnout in the Selects datasets,
to create the figure, the compulsory voting variable is generated first */

	use "Switzerland_1971_2011_for_replication" ,clear
	
	* generate a cv variable, 0 = voluntary, 1 = cv no punishment, 2 = cv with sanctions
	/* sg3 variable is used to code this variable, this variable captures cantons (see
	Selects-codebook: https://forsbase.unil.ch/file_download/02ca5f85468de6341fe0076d3e1c44eb/5a2762d0/fedora-2/objects/FB-WORK:768/datastreams/FILE-001/content?asOfDateTime=2017-09-19T11:04:41.811Z */
	
	gen cv_rules=0 if sg3==19		// aargau
	replace cv_rules=1 if sg3==16 	// appenzell inner rhodes					
	replace cv_rules=1 if sg3==15 & year<1996 // appenzel outer rhodes
	replace cv_rules=0 if sg3==15 & year>=1996
	replace cv_rules=0 if sg3==13	// basel landschaft
	replace cv_rules=0 if sg3==12 	// basel stadt
	replace cv_rules=1 if sg3==2 & year<1981	// bern
	replace cv_rules=0 if sg3==2 & year>=1981
	replace cv_rules=0 if sg3==10	// fribourg
	replace cv_rules=0 if sg3==25	// geneva
	replace cv_rules=1 if sg3==8	// glarus
	replace cv_rules=0 if sg3==18	// graubunden
	replace cv_rules=0 if sg3==26	// jura
	replace cv_rules=0 if sg3==3	// lucerne
	replace cv_rules=0 if sg3==24	// neuchatel
	replace cv_rules=1 if sg3==7	// nidwalden
	replace cv_rules=1 if sg3==6	// obwalden
	replace cv_rules=2 if sg3==14	// shaffhausen
	replace cv_rules=0 if sg3==5	// schwyz
	replace cv_rules=0 if sg3==1	// solothum
	replace cv_rules=2 if sg3==17 & year<1979	// sankt gallen
	replace cv_rules=0 if sg3==17 & year>=1979
	replace cv_rules=2 if sg3==20 & year<1985	// thurgau
	replace cv_rules=0 if sg3==20 & year>=1985
	replace cv_rules=1 if sg3==21	// ticino
	replace cv_rules=1 if sg3==4	// uri
	replace cv_rules=0 if sg3==23	// valais
	replace cv_rules=0 if sg3==22	// vaud
	replace cv_rules=0 if sg3==9	// zug
	replace cv_rules=2 if sg3==1 & year<1985	// zurich
	replace cv_rules=0 if sg3==1 & year>=1985

	
	** participation variable (self reported turnout)
	gen turnout=vp1
	egen grp=group(year cv_rules)
	
	label define groups  1 "1971 no cv" 2 "1971 weak cv" 3 "1971 strict cv" 4 "1975 no cv" ///
	5 "1975 weak cv" 6 "1975 strict cv" 7 "1979 no cv" 8 "1979 weak cv" 9 "1979 strict cv" 10 "1987 no cv" ///
	11 "1987 weak cv" 12 "1987 strict cv" 13 "1991 no cv" 14 "1991 weak cv" 15 "1991 strict cv" 16 "1995 no cv" ///
	17 "1995 weak cv" 18 "1995 strict cv" 19 "1999 no cv" 20 "1999 weak cv" 21 "1999 strict cv" 22 "2003 no cv" ///
	23 "2003 weak cv" 24 "2003 strict cv" 25 "2007 no cv" 26 "2007 weak cv" 27 "2007 strict cv" 28 "2011 no cv" ///
	29 "2011 weak cv" 30 "2011 strict cv"
    label values  grp groups

	graph dot (mean) turnout,  over(grp) 
	
	
	
/* Table 2: logistic regression model explaining voting for the most proximate party in Switzerland,
analyses on pooled sample of election-specific samples of matched respondents. For more information
on the matching procedures, see Appendix E */

** no CV cantons vs. CV cantons **

	use "Switzerland_matched_cvweak_logit.dta" ,clear
	
	logit voteclosest cv_weak female age   i.education pid  i.year, cluster(year)
	estat classification

** CV with sanctions vs. all others **

	use "Switzerland_matched_cvstrict_logit.dta" ,clear
	
	logit voteclosest cv_strictvsno female age   i.education pid  i.year, cluster(year)
	estat classification


/* Table 3: conditional logit model explaining vote choice in Swiss elections,  
analyses on pooled datasets */


** no CV cantons vs. CV cantons **

	use "Switzerland_matched_cvweak_clogit.dta" ,clear
	
	* reshape to long format
	gen id = _n
	reshape long voteparty distparty partisanparty, i(id) j(party)
	drop if distparty==.
	
	* generate interaction
	gen distanceXcv=distparty*cv_weak
	
	* clogit model estimation
	clogit voteparty distparty distanceXcv partisanparty, group(id) cluster(year)
	estat ic	
	
	
** CV strict vs. all others **

	use "Switzerland_matched_cvstrict_clogit.dta" ,clear
	
	gen id = _n
	reshape long voteparty distparty partisanparty, i(id) j(party)
	drop if distparty==.
	
	gen distanceXcv=distparty*cv_strictvsno
	
	*clogit
	clogit voteparty distparty distanceXcv partisanparty, group(id) cluster(year)
	estat ic	


	
	
	
	
	
	
	
	
	
**************************************
** SUPPLEMENTARY MATERIALS			**
**************************************


** APPENDIX A: cv and turnout in Switzerland **

	* Note: Table A.1. is a description of compulsory voting rules by canton (source: Funk 2007) 
	
	
	* Table A.2. - Aggregate level turnout in Switzerland, by election and CV rules
	
	use "Switzerland_aggregate_turnout.dta", clear

	* generate a cv variable, 0 = voluntary, 1 = cv no punishment, 2 = cv with sanctions
	
	gen cv_rules=0 if canton=="AG"		// aargau
	replace cv_rules=1 if canton=="AI" 	// appenzell inner rhodes					
	replace cv_rules=1 if canton=="AR" & election<1996 // appenzel outer rhodes
	replace cv_rules=0 if canton=="AR" & election>=1996
	replace cv_rules=0 if canton=="BL"	// basel landschaft
	replace cv_rules=0 if canton=="BS" 	// basel stadt
	replace cv_rules=1 if canton=="BE" & election<1981	// bern
	replace cv_rules=0 if canton=="BE" & election>=1981
	replace cv_rules=0 if canton=="FR"	// fribourg
	replace cv_rules=0 if canton=="GE"	// geneva
	replace cv_rules=1 if canton=="GL"	// glarus
	replace cv_rules=0 if canton=="GR"	// graubunden
	replace cv_rules=0 if canton=="JU"	// jura
	replace cv_rules=0 if canton=="LU"	// lucerne
	replace cv_rules=0 if canton=="NE"	// neuchatel
	replace cv_rules=1 if canton=="NW"	// nidwalden
	replace cv_rules=1 if canton=="OW"	// obwalden
	replace cv_rules=2 if canton=="SH"	// shaffhausen
	replace cv_rules=0 if canton=="SZ"	// schwyz
	replace cv_rules=0 if canton=="SO"	// solothum
	replace cv_rules=2 if canton=="SG" & election<1979	// sankt gallen
	replace cv_rules=0 if canton=="SG" & election>=1979
	replace cv_rules=2 if canton=="TG" & election<1985	// thurgau
	replace cv_rules=0 if canton=="TG" & election>=1985
	replace cv_rules=1 if canton=="TI"	// ticino
	replace cv_rules=1 if canton=="UR"	// uri
	replace cv_rules=0 if canton=="VS"	// valais
	replace cv_rules=0 if canton=="VD"	// vaud
	replace cv_rules=0 if canton=="ZG"	// zug
	replace cv_rules=2 if canton=="ZH" & election<1985	// zurich
	replace cv_rules=0 if canton=="ZH" & election>=1985

	drop if canton=="CH"							// Switzerland in general
	
	* graph
	graph bar percent , over(cv_rules)   by(election)



** APPENDIX B: distributions willingness/reluctance to vote in Australia, Belgium and Brazil **

	* Australia
	
	use "Australia_2001_for_replication.dta" , clear
	tab turnout, g(turnoutgroups)
	graph bar turnoutgroups* , ascategory title("Australia 2001") ylabel(0(.2).8)

	use "Australia_2004_for_replication.dta" , clear
	tab turnout, g(turnoutgroups)
	graph bar turnoutgroups* , ascategory title("Australia 2004") ylabel(0(.2).8) 

	use "Australia_2007_for_replication.dta" , clear
	tab turnout, g(turnoutgroups)
	graph bar turnoutgroups* , ascategory title("Australia 2007") ylabel(0(.2).8) 

	use "Australia_2010_for_replication.dta" , clear
	tab turnout, g(turnoutgroups)
	graph bar turnoutgroups* , ascategory title("Australia 2010") ylabel(0(.2).8) 

	use "Australia_2013_for_replication.dta" , clear
	tab turnout, g(turnoutgroups)
	graph bar turnoutgroups* , ascategory title("Australia 2013") ylabel(0(.2).8) 


	* Belgium (Flanders + Wallonia)
	
	use "Flanders_1991_for_replication.dta" , clear	
	tab turnout, g(turnoutgroups)
	graph bar turnoutgroups* , ascategory title("Belgium (Flanders) 1991") ylabel(0(.2).6) 

	use "Flanders_1999_for_replication.dta" , clear	
	tab turnout, g(turnoutgroups)
	graph bar turnoutgroups* , ascategory title("Belgium (Flanders) 1999") ylabel(0(.2).6) 

	use "Flanders_2014_for_replication.dta" , clear	
	tab turnout, g(turnoutgroups)
	graph bar turnoutgroups* , ascategory title("Belgium (Flanders) 2014") ylabel(0(.2).6) 

	use "Wallonia_1991_for_replication.dta" , clear	
	tab turnout, g(turnoutgroups)
	graph bar turnoutgroups* , ascategory title("Belgium (Wallonia) 1991") ylabel(0(.2).6) 

	use "Wallonia_1999_for_replication.dta" , clear	
	tab turnout, g(turnoutgroups)
	graph bar turnoutgroups* , ascategory title("Belgium (Wallonia) 1999") ylabel(0(.2).6) 

	use "Wallonia_2014_for_replication.dta" , clear	
	tab turnout, g(turnoutgroups)
	graph bar turnoutgroups* , ascategory title("Belgium (Wallonia) 2014") ylabel(0(.2).6) 
	
	
	* Brazil
	
	use "Brazil_2002_for_replication" , clear
	tab turnout , g(turnoutgroups)
	graph bar turnoutgroups* , ascategory title("Brazil 2002") ylabel(0(.2).6) 
	
	use "Brazil_2006_for_replication" , clear
	tab turnout , g(turnoutgroups)
	graph bar turnoutgroups* , ascategory title("Brazil 2006") ylabel(0(.2).6) 
	
	use "Brazil_2010_for_replication" , clear
	tab turnout , g(turnoutgroups)
	graph bar turnoutgroups* , ascategory title("Brazil 2010") ylabel(0(.2).6) 
	
	use "Brazil_2014_for_replication" , clear
	tab turnout , g(turnoutgroups)
	graph bar turnoutgroups* , ascategory title("Brazil 2014") ylabel(0(.2).6) 
	
	
** APPENDIX C: information on the operationalization of variables (Australia, Belgium and Brazil) **

** APPENDIX D: reported turnout in Swiss election studies **

	use "Switzerland_1971_2011_for_replication" ,clear
	
	gen turnout=vp1
	tab year turnout, row
	
** APPENDIX E: matching, propensity matching results by year

	/* See R-scripts for the propensity score matching codes and results :
		1. matching_logit_cv.R
		2. matching_logit_cvsanctions.R
		3. matching_clogit_cv.R
		4. matching_clogit_cvsanctions.R 
	*/
		
		
** APPENDIX F: information on the operationalization of variables (Switzerland) **

** APPENDIX G: see syntax main results (codes for obtaining information for Figure 1)

** APPENDIX H: see syntax main results (codes for obtaining information for Figure 1)

** APPENDIX I: see syntax main results (codes for obtaining information for Figure 1)
	
** APPENDIX J: distribution of correct voting in the election studies included
	
	use "Australia_2001_for_replication.dta" , clear
	tab voteclosest
	
	use "Australia_2004_for_replication.dta" , clear
	tab voteclosest
	
	use "Australia_2007_for_replication.dta" , clear
	tab voteclosest
	
	use "Australia_2010_for_replication.dta" , clear
	tab voteclosest
	
	use "Australia_2013_for_replication.dta" , clear
	tab voteclosest
	
	use "Flanders_1991_for_replication.dta" , clear
	tab voteclosest
	
	use "Flanders_1999_for_replication.dta" , clear
	tab voteclosest	
	
	use "Flanders_2014_for_replication.dta" , clear
	tab voteclosest	
	
	use "Wallonia_1991_for_replication.dta" , clear
	tab voteclosest
	
	use "Wallonia_1999_for_replication.dta" , clear
	tab voteclosest	
	
	use "Wallonia_2014_for_replication.dta" , clear
	tab voteclosest	
	
	use "Brazil_2002_for_replication.dta" , clear
	tab voteclosest
	
	use "Brazil_2006_for_replication.dta" , clear
	tab voteclosest	
	
	use "Brazil_2010_for_replication.dta" , clear
	tab voteclosest
	
	use "Brazil_2014_for_replication.dta" , clear
	tab voteclosest	

	
** APPENDIX K: see syntax main results (codes for obtaining information for Figure 2)

** APPENDIX L: see syntax main results (codes for obtaining information for Figure 2)

** APPENDIX K: see syntax main results (codes for obtaining information for Figure 2)

** APPENDIX M: see syntax main results (codes for obtaining information for Figure 2)

/* APPENDIX N: logit models voting for the most proximate party, excluding partisanship from the models,
re-estimation of all models, with the exception of the Belgian 1991 and 1999 elections (in the Flemish
and Walloon region), where partisanship was not included in the surveys */

** Australia **

	use "Australia_2001_for_replication.dta" , clear
	logit voteclosest turnout i.gender age i.education 
	margins , dydx(turnout)
	
	use "Australia_2004_for_replication.dta" , clear
	logit voteclosest turnout i.gender age i.education 
	margins , dydx(turnout)
	
	use "Australia_2007_for_replication.dta" , clear
	logit voteclosest turnout i.gender age i.education 
	margins , dydx(turnout)
	
	use "Australia_2010_for_replication.dta" , clear
	logit voteclosest turnout i.gender age i.education 
	margins , dydx(turnout)

	use "Australia_2013_for_replication.dta" , clear
	logit voteclosest turnout i.gender age i.education 
	margins , dydx(turnout)
	
** Belgium (Flanders) **	
	
	* 1991 election: no pid available -- see main results
	
	* 1999 election: no pid available -- see main results	
	
	use "Flanders_2014_for_replication.dta" , clear
	logit voteclosest turnout i.gender age i.education 
	margins , dydx(turnout)
	
** Belgium (Wallonia) **	
	
	* 1991 election: no pid available -- see main results
	
	* 1999 election: no pid available -- see main results	
	
	use "Wallonia_2014_for_replication.dta" , clear
	logit voteclosest turnout i.gender age i.education 
	margins , dydx(turnout)
	
** Brazil **
	
	use "Brazil_2002_for_replication" , clear
	logit voteclosest turnout i.gender age i.education[pweight=weight]
	margins , dydx(turnout)
	
	use "Brazil_2006_for_replication" , clear
	logit voteclosest turnout i.gender age i.education[pweight=weight]
	margins , dydx(turnout)
	
	use "Brazil_2010_for_replication" , clear
	logit voteclosest turnout i.gender age i.education
	margins , dydx(turnout)
	
	use "Brazil_2014_for_replication" , clear
	logit voteclosest turnout i.gender age i.education[pweight=weight]
	margins , dydx(turnout)
	
/* APPENDIX O: ideological differences between willing and reluctant voters, 
first a dichotomous variable is generated to distinguish between willing (certain) voters and
all voters who are not certain they would always vote. Then, the mean ideological position 
(left-right) of both groups is compared */

** Australia **

	use "Australia_2001_for_replication.dta", clear
	ttest ideology_self, by(turnoutdich)

	use "Australia_2004_for_replication.dta", clear
	ttest ideology_self, by(turnoutdich)
	
	use "Australia_2007_for_replication.dta", clear
	ttest ideology_self, by(turnoutdich)
	
	use "Australia_2010_for_replication.dta", clear
	ttest ideology_self, by(turnoutdich)
	
	use "Australia_2013_for_replication.dta", clear
	ttest ideology_self, by(turnoutdich)
	
** Belgium (Flanders) **
	use "Flanders_1991_for_replication.dta", clear
	ttest ideology_self, by(turnoutdich)

	use "Flanders_1999_for_replication.dta", clear
	ttest ideology_self, by(turnoutdich)	
	
	use "Flanders_2014_for_replication.dta", clear
	ttest ideology_self, by(turnoutdich)	
	
** Belgium (Wallonia) **

	use "Wallonia_1991_for_replication.dta", clear
	ttest ideology_self, by(turnoutdich)
	
	use "Wallonia_1999_for_replication.dta", clear
	ttest ideology_self, by(turnoutdich)	

	use "Wallonia_2014_for_replication.dta", clear
	ttest ideology_self, by(turnoutdich)	
	
** Brazil **

	use "Brazil_2002_for_replication.dta" , clear
	ttest ideology_self, by(turnoutdich)

	use "Brazil_2006_for_replication.dta" , clear
	ttest ideology_self, by(turnoutdich)
	
	use "Brazil_2010_for_replication.dta" , clear
	ttest ideology_self, by(turnoutdich)
	
	use "Brazil_2014_for_replication.dta" , clear
	ttest ideology_self, by(turnoutdich)
	
