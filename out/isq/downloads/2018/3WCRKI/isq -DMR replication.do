/*	Replication do-file for Donno, Metzger, and Russett ISQ piece
	
	Last Updated: 08JAN14
*/


// load file
use "isq - replic data.dta", clear

***********************************************************
// Table 1: Descriptive Statistics
	sum member pHat strInst_epol intvInst_epol security_epol econBGN avgPolityEx3_d systemSize allAllies eligible demSwitch7_l5 igoContig_fresh polityDifferenceEx3 numMems if(blanks!=1 & selection!=1)

	
// Table 2: States with Highest Security Risk, 1950-2000
qui{
	preserve
	keep if blanks==1

	bysort ccode (year): egen avgMID = mean(allMID)						// overall averages (across WHOLE sample)
	bysort ccode (year): egen secRisk = mean(pHat)						// overall pHat averages (across WHOLE sample)
	bysort ccode (year): egen avgIGO = mean(numMems)					// overall IGO averages (across WHOLE sample)


	keep ccode year secRisk avgMID avgIGO
	bysort ccode (year): gen counterOv = _n
	keep if(counterOv==1)

	// print the *overall* averages
	gsort -secRisk
	noi list ccode secRisk avgMID avgIGO in 1/15, sep(500)
	restore
	drop if(blanks==1)


	preserve
	drop if(selection==1)
}


// Table 3: Determinants of IGO MS, 1950-2000 [main results table]
	* Model 1
	probit member 	pHat strInst_epol intvInst_epol security_epol econBGN ///
					systemSize avgPolityEx3_d eligible ///
					R36_igoNF _R36_igoNFspline1 _R36_igoNFspline2 ///
					, cluster(ccodeYr)

	* Model 2
	probit member 	pHat strInst_epol intvInst_epol security_epol econBGN ///
					systemSize avgPolityEx3_d eligible ///
					demSwitch7_l5 igoContig_fresh polityDifferenceEx3 numMems  ///
					R36_igoNF _R36_igoNFspline1 _R36_igoNFspline2 ///
					, cluster(ccodeYr)

	* Model 3
	probit member 	pHat strInst_epol intvInst_epol security_epol econBGN ///
					strInst_epol_pHat intvInst_epol_pHat security_epol_pHat econBGN_pHat ///
					systemSize avgPolityEx3_d eligible ///
					demSwitch7_l5 igoContig_fresh polityDifferenceEx3 numMems  ///
					R36_igoNF _R36_igoNFspline1 _R36_igoNFspline2 ///
					, cluster(ccodeYr)
					
	* Model 4
	probit member 	pHat strInst_epol intvInst_epol security_epol econBGN ///
					allAllies ///
					systemSize avgPolityEx3_d eligible ///
					demSwitch7_l5 igoContig_fresh polityDifferenceEx3 numMems  ///
					R36_igoNF _R36_igoNFspline1 _R36_igoNFspline2 ///
					, cluster(ccodeYr)
					
	* Model 5
	probit member 	pHat strInst_epol intvInst_epol security_epol econBGN ///
					allAllies allAllies_security ///
					systemSize avgPolityEx3_d eligible ///
					demSwitch7_l5 igoContig_fresh polityDifferenceEx3 numMems  ///
					R36_igoNF _R36_igoNFspline1 _R36_igoNFspline2 ///
					, cluster(ccodeYr)
					
					
					
					
					
***********************************************************
*******  			APPENDIX TABLES					*******
***********************************************************
// Supplementary Appendix 2
	* Model 1
	probit member	pHat strInst_epol intvInst_epol ///
					avgPolityEx3_d systemSize eligible ///
					demSwitch7_l5 igoContig_fresh polityDifferenceEx3 numMems  ///
					R36_igoNF _R36_igoNFspline1 _R36_igoNFspline2 ///
					, cluster(ccodeYr)
					
	* Model 2
	probit member	pHat strInst_epol security_epol ///
					avgPolityEx3_d systemSize eligible ///
					demSwitch7_l5 igoContig_fresh polityDifferenceEx3 numMems  ///
					R36_igoNF _R36_igoNFspline1 _R36_igoNFspline2 ///
					, cluster(ccodeYr)	
					
	* Model 3
	probit member	pHat  ///
					secIntv_epol ///
					avgPolityEx3_d systemSize eligible ///
					demSwitch7_l5 igoContig_fresh polityDifferenceEx3 numMems  ///
					R36_igoNF _R36_igoNFspline1 _R36_igoNFspline2 ///
					, cluster(ccodeYr)	
					
	* Model 4
	probit member	pHat  ///
					secIntv_epol  ///
					avgPolityEx3_d systemSize eligible ///
					secIntv_epol_pHat ///
					demSwitch7_l5 igoContig_fresh polityDifferenceEx3 numMems  ///
					R36_igoNF _R36_igoNFspline1 _R36_igoNFspline2 ///
					, cluster(ccodeYr)					

					
// Supplementary Appendix 3
	* Model 1
	probit member	pHat strInst_epol intvInst_epol security_epol ///
					avgPolityEx3_d systemSize eligible ///
					demSwitch7_l5 igoContig_fresh polityDifferenceEx3 numMems  ///
					postCW ///
					R36_igoNF _R36_igoNFspline1 _R36_igoNFspline2 ///
					, cluster(ccodeYr)				

	* Model 2
	probit member	pHat strInst_epol intvInst_epol security_epol ///
					avgPolityEx3_d systemSize eligible ///
					demSwitch7_l5 igoContig_fresh polityDifferenceEx3 numMems  ///
					sScoreUS ///
					R36_igoNF _R36_igoNFspline1 _R36_igoNFspline2 ///
					, cluster(ccodeYr)	

	* Model 3
	probit member	pHat strInst_epol intvInst_epol security_epol ///
					avgPolityEx3_d systemSize eligible ///
					demSwitch7_l5 igoContig_fresh polityDifferenceEx3 numMems  ///
					global ///
					R36_igoNF _R36_igoNFspline1 _R36_igoNFspline2 ///
					, cluster(ccodeYr)
					
	* Model 4
	probit member	pHat strInst_epol intvInst_epol security_epol ///
					avgPolityEx3_d systemSize eligible ///
					demSwitch7_l5 igoContig_fresh polityDifferenceEx3 numMems  ///
					percNotMS ///
					R36_igoNF _R36_igoNFspline1 _R36_igoNFspline2 ///
					, cluster(ccodeYr)

	* Model 5
	probit member	pHat strInst_epol intvInst_epol security_epol ///
					avgPolityEx3_d systemSize eligible ///
					demSwitch7_l5 igoContig_fresh polityDifferenceEx3 numMems  ///
					avgPolityEx3Auto_d ///
					R36_igoNF _R36_igoNFspline1 _R36_igoNFspline2 ///
					, cluster(ccodeYr)
	
	* Model 6
	probit member	pHat strInst_epol intvInst_epol security_epol ///
					avgPolityEx3_d systemSize eligible ///
					igoContig_fresh polityDifferenceEx3 numMems  ///
					polCh ///
					R36_igoNF _R36_igoNFspline1 _R36_igoNFspline2 ///
					, cluster(ccodeYr)

					
// Supplementary Appendix 4
	* Model 1
	probit member	pHat strInst_epol intvInst_epol security_epol ///
					avgPolityEx3_d systemSize eligible ///
					demSwitch7_l5 igoContig_fresh polityDifferenceEx3 numMems  ///
					stateAge ///
					R36_igoNF _R36_igoNFspline1 _R36_igoNFspline2 ///
					, cluster(ccodeYr)				

	* Model 2
	probit member	pHat strInst_epol intvInst_epol security_epol ///
					avgPolityEx3_d systemSize eligible ///
					demSwitch7_l5 igoContig_fresh polityDifferenceEx3 numMems  ///
					igoAge ///
					R36_igoNF _R36_igoNFspline1 _R36_igoNFspline2 ///
					, cluster(ccodeYr)	

	* Model 3
	probit member	pHat strInst_epol intvInst_epol security_epol ///
					avgPolityEx3_d systemSize eligible ///
					demSwitch7_l5 igoContig_fresh polityDifferenceEx3 numMems  ///
					igoAge igoAge_pHat ///
					R36_igoNF _R36_igoNFspline1 _R36_igoNFspline2 ///
					, cluster(ccodeYr)
					
	* Model 4
	probit member	pHat strInst_epol intvInst_epol security_epol ///
					avgPolityEx3_d systemSize eligible ///
					demSwitch7_l5 igoContig_fresh polityDifferenceEx3 numMems  ///
					igoAge igoAge_strInst_epol igoAge_intvInst_epol ///
					R36_igoNF _R36_igoNFspline1 _R36_igoNFspline2 ///
					, cluster(ccodeYr)
					
					
// Supplementary Appendix 5
restore

	* Model 1
	heckman onsetFMIDperc 	pHat strInst_epol intvInst_epol security_epol ///
							avgPolityEx3_d systemSize  ///
							igoTotal ///
							fMidR36-_fMidR36spline3, ///
				select(member = pHat__Sel2 strInst_epol__Sel2 intvInst_epol__Sel2 security_epol__Sel2 ///
								avgPolityEx3_d__Sel2 systemSize__Sel2   ///
								functSpec__Sel2 ///
								R36_igoNF__Sel2 _R36_igoNFspline1__Sel2 _R36_igoNFspline2__Sel2) 
								
	* Model 2
	heckman onsetFMIDperc 	pHat strInst_epol intvInst_epol security_epol ///
							avgPolityEx3_d systemSize   ///
							demSwitch7_l5 igoContig_fresh polityDifferenceEx3 numMems ///
							igoTotal ///
							fMidR36-_fMidR36spline3, ///
				select(member = pHat__Sel2 strInst_epol__Sel2 intvInst_epol__Sel2 security_epol__Sel2 ///
								avgPolityEx3_d__Sel2 systemSize__Sel2  ///
								demSwitch7_l5__Sel2 igoContig_fresh__Sel2 polityDifferenceEx3__Sel2 numMems__Sel2 ///
								functSpec__Sel2 ///
								R36_igoNF__Sel2 _R36_igoNFspline1__Sel2 _R36_igoNFspline2__Sel2) 
