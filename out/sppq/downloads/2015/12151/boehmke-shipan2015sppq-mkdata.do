version 13
#delimit;
set more off;
clear;
set memory 500m;
  quietly log;
  local logon = r(status);
  if "`logon'" == "on" {; log close; };
log using mkdata-stateover02, text replace;

/*	************************************************************************	*/
/*	************************************************************************	*/
/* 	Note that we include this file for reference, but have not included all of 	*/
/*	the constitutive data sets to recreate it from scratch. Inclusion of this	*/
/*	file is intended to clarify our coding decisions, variable creation,		*/
/*	or variable modification schemes. Notably, that file starts with an		*/
/*	already generated file of nursing home inspection results compiled from 	*/
/*	Federal data sources for another project.  					*/
/*	************************************************************************	*/
/*	************************************************************************	*/
	
	
/*	************************************************************************	*/
/*     	File Name:	mkdata-stateover01.do						*/
/*     	Date:   	October 19, 2006						*/
/*      Author: 	Frederick J. Boehmke						*/
/*      Purpose:	Create data set of nursing home inspection results merged	*/
/*			with state partisan control and legislative professionalism.	*/
/*      Input File:	../nursingcont/data/mkdata-nursing.dta,				*/
/*			BoehmkeShipan080714.dta						*/
/*      Output File:	mkdata-stateover01.dta			 			*/
/*	************************************************************************	*/
/*	************************************************************************	*/
/*     	File Name:	mkdata-stateover02.do						*/
/*     	Date:   	February 08, 2014						*/
/*      Author: 	Frederick J. Boehmke						*/
/*      Purpose:	Update nursing data through 2011.				*/
/*      Input File:	../nursingcont/data/mkdata-nursing02.dta,			*/
/*			BoehmkeShipan080714.dta						*/
/*      Output File:	mkdata-stateover02.log,			 			*/
/*      		mkdata-stateover02.dta			 			*/
/*	************************************************************************	*/
/*     	Date:   	February 08, 2014						*/
/*      Author: 	Frederick J. Boehmke						*/
/*      Purpose:	Add additional legislative professionalism variables.		*/
/*      Input File:	data/Legislator Compensation Data_2_24.xlsx,			*/
/*			BoehmkeShipan080714.dta						*/
/*	************************************************************************	*/
/*     	Date:   	March 20, 2014							*/
/*      Author: 	Frederick J. Boehmke						*/
/*      Purpose:	Use revised nursing home inspections data.			*/
/*      Input File:	../nursingcont/data/mkdata-nursing03.dta,			*/
/*	************************************************************************	*/
/*     	Date:   	October 13, 2014						*/
/*      Author: 	Frederick J. Boehmke						*/
/*      Purpose:	Add in data on term limits for RR at SPPQ.			*/
/*      Input File:	$researchdir/Data/termlimits.dta				*/
/*	************************************************************************	*/


	/* Read in the nursing home level data for 2002-2011 from Boehmke. */

use ../nursingcont/data/mkdata-nursing03, clear;

  keep if year >=2002 & year <= 2011;

	joinby state using "$researchdir\Data\statecodes.dta", unmatched(master);
  
  sort stateno year;
  
  save mkdata-stateover02, replace;

	/* Merge in Klarner's legislative control data. */

merge m:1 stateno year using "$researchdir/Data/legcomp1935-2011.dta", keep(match master) 
	generate(_merge_legcomp) keepusing(govparty uptot-lowvac);

	/* Merge in state ideology data. */

merge m:1 stateno year using "$researchdir/Data/ideology1960-2010.dta", keep(match master) 
	generate(_merge_ideology);

  save mkdata-stateover02, replace;

	/* Merge in Shor and McCarty state ideology data. */

generat st = state;
	
merge m:1 st year using "$researchdir/Data/shor-mccarty/shor mccarty 1993-2011 state aggregate data May 2013.dta", keep(match master) 
	generate(_merge_shormccarty)  keepusing(*_chamber *_majority);

  save mkdata-stateover02, replace;

	/* Merge in state legislative professionalism data. */

use "$researchdir/Data/legprof1963-2009.dta", clear;
	
  generat year = year_squire;
	
  keep if year >= 1996 & !missing(year);

  xtset stateno year;

  tsfill, full;	

	/* Interpolate values. */
  
  by stateno: ipolate legp_squire year, generate(legp_squire_ipol);
  
  merge 1:m stateno year using mkdata-stateover02, keep(match using) 
	generate(_merge_legprof);

  save mkdata-stateover02, replace;

	/* Merge in salary data. */

import excel using "data/Legislator Compensation Data_2_24.xlsx", firstrow clear case(lower);

  destring annualsalary, replace;
  
  rename annualsalary salary;
  
  joinby year using "$researchdir/Data/cpi1913-2012.dta";

	generat rsalary = salary*cpi2002/1000;
  
  rename state statenam;

	keep statenam year salary rsalary;
  
  joinby statenam using "$researchdir/Data/statecodes.dta";
  
  merge 1:m statenam year using mkdata-stateover02, keep(match using) generat(_merge_salary);
		
		/* Merge in term limits data. */
		
merge m:1 stateno using "$researchdir/Data/termlimits.dta", keep(match master) generat(_merge_termlimits);

  generat termlimits = 0;
  replace termlimits = 1 if year >= min(tlhseimp, tlsenimp) & !missing(tlhseimp, tlsenimp);
  
  drop tladopt-tlrepeal;
  
	/* Generate some variables. */

generat house_dem_pct = (lowdem)/(lowtot);
generat sen_dem_pct = (updem)/(uptot);
generat leg_dem_pct = (lowdem+updem)/(lowtot+uptot);

generat house_rep_pct = (lowrep)/(lowtot);
generat sen_rep_pct = (uprep)/(uptot);
generat leg_rep_pct = (lowrep+uprep)/(lowtot+uptot);

generat house_dem_pct_sal = house_dem_pct*rsalary;
generat sen_dem_pct_sal =  sen_dem_pct*rsalary;
generat leg_dem_pct_sal = leg_dem_pct*rsalary;

generat house_dem_pct_legp = house_dem_pct*legp_squire_ipol;
generat sen_dem_pct_legp =  sen_dem_pct*legp_squire_ipol;
generat leg_dem_pct_legp = leg_dem_pct*legp_squire_ipol;

generat hou_chamber_legp = hou_chamber*legp_squire_ipol;
generat sen_chamber_legp = sen_chamber*legp_squire_ipol;

generat hou_majority_legp = hou_majority*legp_squire_ipol;
generat sen_majority_legp = sen_majority*legp_squire_ipol;

		/* This leaves independents out. */

generat govdem = 1 if govparty == 1;
replace govdem = 0 if govparty == 0;

generat unifiedD = (govdem == 1 & house_dem_pct > 0.5 & sen_dem_pct > 0.5);
generat unifiedR = (govdem == 0 & house_rep_pct > 0.5 & sen_rep_pct > 0.5);

generat leg_dem_pct_uniD = leg_dem_pct*unifiedD;
generat leg_dem_pct_uniR = leg_dem_pct*unifiedR;

		/* Independents are coded 0.5. */

generat leg_dem_pct_govD = leg_dem_pct if govdem == 1;
replace leg_dem_pct_govD = 0 if govdem != 1;
generat leg_dem_pct_govR = leg_dem_pct if govdem == 0;
replace leg_dem_pct_govR = 0 if govdem != 0;

generat leg_dem_pct_uniD_sal = leg_dem_pct*unifiedD*rsalary;
generat leg_dem_pct_uniR_sal = leg_dem_pct*unifiedR*rsalary;

generat leg_dem_pct_uniD_legp = leg_dem_pct*unifiedD*legp_squire_ipol;
generat leg_dem_pct_uniR_legp = leg_dem_pct*unifiedR*legp_squire_ipol;

generat leg_dem_pct_nouni = leg_dem_pct - leg_dem_pct_uniD - leg_dem_pct_uniR;
generat leg_dem_pct_nouni_sal = leg_dem_pct_sal - leg_dem_pct_uniD_sal - leg_dem_pct_uniR_sal;
 
generat leg_dem_pct_govD_sal = leg_dem_pct_govD*rsalary;
generat leg_dem_pct_govR_sal = leg_dem_pct_govR*rsalary;

generat leg_dem_pct_govD_legp = leg_dem_pct_govD*legp_squire;
generat leg_dem_pct_govR_legp = leg_dem_pct_govR*legp_squire_ipol;

generat rsalary_uniD  = unifiedD*rsalary;
generat rsalary_uniR  = unifiedR*rsalary;
generat rsalary_nouni = (1 - unifiedR - unifiedD)*rsalary;

generat legp_uniD  = unifiedD*legp_squire_ipol;
generat legp_uniR  = unifiedR*legp_squire_ipol;
generat legp_nouni = (1 - unifiedR - unifiedD)*legp_squire_ipol;

generat rsalary_govD  = rsalary if govdem == 1;
replace rsalary_govD  = 0 if govdem != 1;
generat rsalary_govR  = rsalary if govdem == 0;
replace rsalary_govR  = 0 if govdem != 0;

generat legp_govD  = legp_squire_ipol if govdem == 1;
replace legp_govD  = 0 if govdem != 1;
generat legp_govR  = legp_squire_ipol if govdem == 0;
replace legp_govR  = 0 if govdem != 0;

  tsset, clear;
  xtset stateno	;

drop def_A-def_betw;
  
label data "Legislative capacity and nursing home oversight (Boehmke and Shipan 2014).";
  
  label variable def_all 		"Number of Deficiencies";
  label variable def_sev 		"Number of Severe Deficiencies";
  label variable def_nonsev 		"Number of Non-Severe Deficiencies";

  label variable bedsocc 		"Beds Occupied (%)";
  label variable licstaff 		"Licensed Staff Hours per Resident";
  label variable hospital 		"Hospital-Based";
  label variable med_both 		"Medicare and Medicaid";
  label variable med_caid 		"Medicaid Only";
  label variable med_care 		"Medicare Only";
  label variable multiown 		"Part of a Chain";
  label variable numres 		"Number of Residents";
  label variable own_nonp 		"Nonprofit";
  label variable own_prof 		"For Profit";
  label variable own_govt 		"Government Owned";
  label variable rnhrspc 		"RN Hours per Resident";
  label variable cnahrspc 		"Nurse Assistant Hours per Resident";

  compress;

  save mkdata-stateover02, replace;

log close;
clear;
exit, STATA;
