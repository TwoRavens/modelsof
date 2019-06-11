

use "Orbis_citypairs_July2017.dta", replace
set more off

global RD_covars1 "totnr_weekly1989 ltotCTRY_obs1989 ltotCTRY_passengers1989 ltotCTRY_weekly1989 abstimezonediff" 


*******************************************************
**************** TABLE 6: RDD ORBIS.    ***************
*******************************************************
	
	*use "Orbis_citypairs_July2017.dta", replace  	// Data with proprietary variables from ICAO/Orbis
	 use "Data_for_Tables6&8.dta", replace	  		// Data without proprietary variables 
	 
	capture erase "results/Table_6.xls"
	capture erase "results/Table_6.txt"	
	
	*--- RF ---*
		*ROBUST S.E.
		foreach bw in  500 1000 {
			rdrobust guo_company_nr airportdist, p(1) h(`bw' `bw') c(6000) 		
			outreg2 using "results/Table_6.xls", aster(se) ctitle("p=`p' bw=`bw' Sharp") dec(3)
		}
		foreach p in 1 2 {
			rdrobust guo_company_nr airportdist, p(`p') c(6000)
			outreg2 using "results/Table_6.xls", aster(se) ctitle("p=`p' bw=optimal Sharp") dec(3)
			rdrobust guo_company_nr airportdist, p(`p') c(6000)  covs($RD_covars1) 	
			outreg2 using "results/Table_6.xls", aster(se) ctitle("p=`p' bw=optimal covar Sharp") dec(3)
		}	
		*CLUSTERED S.E.
		foreach bw in  500 1000 {
			rdrobust guo_company_nr airportdist, p(1) h(`bw' `bw') c(6000) vce(nncluster countrypair)		
			outreg2 using "results/Table_6.xls", aster(se) ctitle("p=`p' bw=`bw' Sharp") dec(3)
		}
		foreach p in 1 2 {
			rdrobust guo_company_nr airportdist, p(`p') c(6000) vce(nncluster countrypair)
			outreg2 using "results/Table_6.xls", aster(se) ctitle("p=`p' bw=optimal Sharp") dec(3)
			rdrobust guo_company_nr airportdist, p(`p') c(6000)  covs($RD_covars1) vce(nncluster countrypair)	
			outreg2 using "results/Table_6.xls", aster(se) ctitle("p=`p' bw=optimal covar Sharp") dec(3)
		}	
	*--- Fuzzy IV ---*
		*ROBUST S.E.			
		rdrobust guo_company_nr airportdist, p(1) c(6000) fuzzy(totnr_weekly2014) 
		outreg2 using "results/Table_6.xls", ctitle("p=1 bw=optimal Fuzzy") 
		rdrobust guo_company_nr airportdist, p(1) c(6000) fuzzy(totnr_weekly2014) covs($RD_covars1)
		outreg2 using "results/Table_6.xls", ctitle("p=1 bw=optimal covar Fuzzy")
		*CLUSTERED S.E.
		rdrobust guo_company_nr airportdist, p(1) c(6000) fuzzy(totnr_weekly2014) vce(nncluster countrypair)
		outreg2 using "results/Table_6.xls", ctitle("p=1 bw=optimal nncluster Fuzzy")
		rdrobust guo_company_nr airportdist, p(1) c(6000) fuzzy(totnr_weekly2014) vce(nncluster countrypair) covs($RD_covars1) 
		outreg2 using "results/Table_6.xls", ctitle("p=1 bw=optimal covar  nncluster Fuzzy")

			

*************************************************************
**************** TABLE 8: DIRECTION OF FDI    ***************
*************************************************************

	*use "Orbis_citypairs_July2017.dta", replace		// Data with proprietary variables from ICAO/Orbis
	 use "Data_for_Tables6&8.dta", replace	  			// Data without proprietary variables 
	set more off
	capture erase "results/Table_8.xls"
	capture erase "results/Table_8.txt"	
	///// BANDWIDTH SELECTION FOR REDUCED FORM///
		rdbwselect guo_company_nr_richer airportdist							   , p(1) c(6000) fuzzy(totnr_weekly2014) 					 // Result: h(687.178 687.178) b(1266.327 1266.327)
		rdbwselect guo_company_nr_richer airportdist							   , p(1) c(6000) fuzzy(totnr_weekly2014) covs($RD_covars1)  // Result: h(908.546 908.546) b(1453.714 1453.714)
		rdbwselect guo_company_nr_poorer airportdist							   , p(1) c(6000) fuzzy(totnr_weekly2014) 					 // Result: h(793.601 793.601) b(1674.957 1674.957) 	
		rdbwselect guo_company_nr_poorer airportdist							   , p(1) c(6000) fuzzy(totnr_weekly2014) covs($RD_covars1)  // Result: h(519.119 519.11)  b(1402.481 1402.481) 	
		* Different Income Groups
		rdbwselect guo_company_nr_richer airportdist  if incgroup!=incgroup_d, p(1) c(6000) fuzzy(totnr_weekly2014) covs($RD_covars1)  // Result: h(1052.163 1052.163)  b(1691.093 1691.093) 
		rdbwselect guo_company_nr_poorer airportdist  if incgroup!=incgroup_d, p(1) c(6000) fuzzy(totnr_weekly2014) covs($RD_covars1)  // Result: h(1021.075 1021.075)  b(1628.872 1628.872)  	
		* One is High income
		rdbwselect guo_company_nr_richer airportdist  if incgroup!=incgroup_d & (incgroup==4 | incgroup_d==4), p(1) c(6000) fuzzy(totnr_weekly2014) covs($RD_covars1)  // Result: h(923.867 923.867)  b(1515.711 1515.711) 
		rdbwselect guo_company_nr_poorer airportdist  if incgroup!=incgroup_d & (incgroup==4 | incgroup_d==4), p(1) c(6000) fuzzy(totnr_weekly2014) covs($RD_covars1)  // Result: h(937.818 937.818)  b(1565.506 1565.506)  	
		* One is Low income
		rdbwselect guo_company_nr_richer airportdist  if incgroup!=incgroup_d & (incgroup==1 | incgroup_d==1), p(1) c(6000) fuzzy(totnr_weekly2014) covs($RD_covars1)  // Manually set: h(1000 1000)  // NB. NO CONVREGENCE RESULTS SO USING MANURAL 
		rdbwselect guo_company_nr_poorer airportdist  if incgroup!=incgroup_d & (incgroup==1 | incgroup_d==1), p(1) c(6000) fuzzy(totnr_weekly2014) covs($RD_covars1)  // Manually set: h(1000 1000)  // NB. NO CONVREGENCE RESULTS SO USING MANURAL  
	
	*FIRST STAGE AND IV
	set more off
	capture erase "results/Table_8.xls"
	capture erase "results/Table_8.txt"	
		* All pairs
		rdrobust guo_company_nr_richer airportdist							   , p(1) c(6000) fuzzy(totnr_weekly2014) 
		outreg2 using "results/Table_8.xls", ctitle("p=`p' bw=optimal Fuzzy")
		rdrobust guo_company_nr_richer airportdist							   , p(1) c(6000) fuzzy(totnr_weekly2014) covs($RD_covars1)
		outreg2 using "results/Table_8.xls", ctitle("p=`p' bw=optimal Fuzzy")
		rdrobust guo_company_nr_poorer airportdist							   , p(1) c(6000) fuzzy(totnr_weekly2014) 
		outreg2 using "results/Table_8.xls", ctitle("p=`p' bw=optimal Fuzzy")
		rdrobust guo_company_nr_poorer airportdist							   , p(1) c(6000) fuzzy(totnr_weekly2014) covs($RD_covars1) 	
		outreg2 using "results/Table_8.xls", ctitle("p=`p' bw=optimal Fuzzy")
		* Different Income Groups
		rdrobust guo_company_nr_richer airportdist  if incgroup!=incgroup_d, p(1) c(6000) fuzzy(totnr_weekly2014) covs($RD_covars1)
		outreg2 using "results/Table_8.xls", ctitle("p=`p' bw=optimal Fuzzy")
		rdrobust guo_company_nr_poorer airportdist  if incgroup!=incgroup_d, p(1) c(6000) fuzzy(totnr_weekly2014) covs($RD_covars1) 	
		outreg2 using "results/Table_8.xls", ctitle("p=`p' bw=optimal Fuzzy")
		* One is High income
		rdrobust guo_company_nr_richer airportdist  if incgroup!=incgroup_d & (incgroup==4 | incgroup_d==4), p(1) c(6000) fuzzy(totnr_weekly2014) covs($RD_covars1)
		outreg2 using "results/Table_8.xls", ctitle("p=`p' bw=optimal Fuzzy")
		rdrobust guo_company_nr_poorer airportdist  if incgroup!=incgroup_d & (incgroup==4 | incgroup_d==4), p(1) c(6000) fuzzy(totnr_weekly2014) covs($RD_covars1) 	
		outreg2 using "results/Table_8.xls", ctitle("p=`p' bw=optimal Fuzzy")
		* One is Low income
		rdrobust guo_company_nr_richer airportdist  if incgroup!=incgroup_d & (incgroup==1 | incgroup_d==1), p(1) c(6000) fuzzy(totnr_weekly2014) h(1000 1000) covs($RD_covars1)
		outreg2 using "results/Table_8.xls", ctitle("p=`p' bw=optimal Fuzzy")
		rdrobust guo_company_nr_poorer airportdist  if incgroup!=incgroup_d & (incgroup==1 | incgroup_d==1), p(1) c(6000) fuzzy(totnr_weekly2014) h(1000 1000) covs($RD_covars1)	
		outreg2 using "results/Table_8.xls", ctitle("p=`p' bw=optimal Fuzzy")

	
	////// REDUCED FORM //////
	set more off
	capture erase "results/Table_8_RF.xls"
	capture erase "results/Table_8_RF.txt"
	* All pairs
		rdrobust guo_company_nr_richer airportdist							   , p(1) c(6000)  h(687.178 687.178) b(1266.327 1266.327)
		outreg2 using "results/Table_8_RF.xls", ctitle("p=`p' bw=optimal Fuzzy")
		rdrobust guo_company_nr_richer airportdist							   , p(1) c(6000)  h(908.546 908.546) b(1453.714 1453.714) covs($RD_covars1) 
		outreg2 using "results/Table_8_RF.xls", ctitle("p=`p' bw=optimal Fuzzy")
		rdrobust guo_company_nr_poorer airportdist							   , p(1) c(6000)  h(793.601 793.601) b(1674.957 1674.957)  	
		outreg2 using "results/Table_8_RF.xls", ctitle("p=`p' bw=optimal Fuzzy")
		rdrobust guo_company_nr_poorer airportdist							   , p(1) c(6000)  h(519.119 519.11)  b(1402.481 1402.481) covs($RD_covars1) 	
		outreg2 using "results/Table_8_RF.xls", ctitle("p=`p' bw=optimal Fuzzy")
		* Different Income Groups
		rdrobust guo_company_nr_richer airportdist  if incgroup!=incgroup_d, p(1) c(6000) h(1052.163 1052.163)  b(1691.093 1691.093) covs($RD_covars1)
		outreg2 using "results/Table_8_RF.xls", ctitle("p=`p' bw=optimal Fuzzy")
		rdrobust guo_company_nr_poorer airportdist  if incgroup!=incgroup_d, p(1) c(6000) h(1021.075 1021.075)  b(1628.872 1628.872) covs($RD_covars1) 	
		outreg2 using "results/Table_8_RF.xls", ctitle("p=`p' bw=optimal Fuzzy")
		* One is High income
		rdrobust guo_company_nr_richer airportdist  if incgroup!=incgroup_d & (incgroup==4 | incgroup_d==4), p(1) c(6000) h(923.867 923.867) b(1515.711 1515.711) covs($RD_covars1)
		outreg2 using "results/Table_8_RF.xls", ctitle("p=`p' bw=optimal Fuzzy")
		rdrobust guo_company_nr_poorer airportdist  if incgroup!=incgroup_d & (incgroup==4 | incgroup_d==4), p(1) c(6000) h(937.818 937.818) b(1565.506 1565.506) covs($RD_covars1) 	
		outreg2 using "results/Table_8_RF.xls", ctitle("p=`p' bw=optimal Fuzzy")
		* One is Low income
		rdrobust guo_company_nr_richer airportdist  if incgroup!=incgroup_d & (incgroup==1 | incgroup_d==1), p(1) c(6000) h(1000 1000) covs($RD_covars1)
		outreg2 using "results/Table_8_RF.xls", ctitle("p=`p' bw=optimal Fuzzy")
		rdrobust guo_company_nr_poorer airportdist  if incgroup!=incgroup_d & (incgroup==1 | incgroup_d==1), p(1) c(6000) h(1000 1000) covs($RD_covars1) 	
		outreg2 using "results/Table_8_RF.xls", ctitle("p=`p' bw=optimal Fuzzy")

