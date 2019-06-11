clear 
set more off

cd "/Users/dyanag/Dropbox/PROJECTS/Airplanes/data/Working Data/"


********************************************************
*******     REGRESSIONS: CITYPAIR-LEVEL      ***********
********************************************************

global RD_covars1 "totnr_weekly1989 ltotCTRY_obs1989 ltotCTRY_passengers1989 ltotCTRY_weekly1989 abstimezonediff" 


*-------- TABLE 1 ---------*
*use "FirstStage_RDD_July2017.dta", replace // Data with proprietary variables from ICAO/Orbis
 use "Data_for_Table1.dta", replace 		// Data without proprietary variables 
			set more off
			capture erase "results/RDD_Table1.xls"
			capture erase "results/RDD_Table1.txt"	
			capture erase "results/RDD_Table1_ClSE.xls"
			capture erase "results/RDD_Table1_ClSE.txt"		
			*--- Sharp RD ("First Stage") ---*
			*---- ROBUST S.E. -------*
			foreach bw in  500 1000 {
				qui: rdrobust totnr_weekly2014 airportdist, p(1) h(`bw' `bw') c(6000) 		
				outreg2 using "results/RDD_Table1.xls", aster(se) ctitle("p=`p' bw=`bw' Sharp") dec(4)
			}
			foreach p in 1 {
				qui: rdrobust totnr_weekly2014 airportdist, p(`p') c(6000)
				outreg2 using "results/RDD_Table1.xls", aster(se) ctitle("p=`p' bw=optimal Sharp") dec(4)
				qui: rdrobust totnr_weekly2014 airportdist, p(`p') c(6000)  covs($RD_covars1) 	
				outreg2 using "results/RDD_Table1.xls", aster(se) ctitle("p=`p' bw=optimal covar Sharp") dec(4)
			}	
			foreach p in 2 {
				qui: rdrobust totnr_weekly2014 airportdist, p(`p') c(6000)
				outreg2 using "results/RDD_Table1.xls", aster(se) ctitle("p=`p' bw=optimal Sharp") dec(4)
				qui: rdrobust totnr_weekly2014 airportdist, p(`p') c(6000)  covs($RD_covars1) 	
				outreg2 using "results/RDD_Table1.xls", aster(se) ctitle("p=`p' bw=optimal covar Sharp") dec(4)
			}	
			qui: rdrobust totnr_weekly1989 airportdist, p(1) c(6000) 		
				outreg2 using "results/RDD_Table1.xls", aster(se) ctitle("p=`p' bw=`bw' Sharp") dec(4)
			*BY DECADE: 1990-2010
			foreach depvar in weekly_90to2000 weekly_00to10 weekly_90to2010 {
				qui: rdrobust `depvar' airportdist, p(1) c(6000) covs($RD_covars1)
				outreg2 using "results/RDD_Table1.xls", aster(se) ctitle("`i'") dec(4)
			}

			*----- CLUSTERED S.E. -----*
			foreach bw in  500 1000 {
				qui: rdrobust totnr_weekly2014 airportdist, p(1) h(`bw' `bw') c(6000) vce(nncluster countrypair)		
				outreg2 using "results/RDD_Table1_ClSE.xls", aster(se) ctitle("p=`p' bw=`bw' Sharp") dec(4)
			}
			foreach p in 1 {
				qui: rdrobust totnr_weekly2014 airportdist, p(`p') c(6000) vce(nncluster countrypair)
				outreg2 using "results/RDD_Table1_ClSE.xls", aster(se) ctitle("p=`p' bw=optimal Sharp") dec(4)
				qui: rdrobust totnr_weekly2014 airportdist, p(`p') c(6000)  covs($RD_covars1) vce(nncluster countrypair)	
				outreg2 using "results/RDD_Table1_ClSE.xls", aster(se) ctitle("p=`p' bw=optimal covar Sharp") dec(4)
			}	
			foreach p in 2 {
				qui: rdrobust totnr_weekly2014 airportdist, p(`p') c(6000) vce(nncluster countrypair)
				outreg2 using "results/RDD_Table1_ClSE.xls", aster(se) ctitle("p=`p' bw=optimal Sharp") dec(4)
				qui: rdrobust totnr_weekly2014 airportdist, p(`p') c(6000)  covs($RD_covars1) vce(nncluster countrypair)	
				outreg2 using "results/RDD_Table1_ClSE.xls", aster(se) ctitle("p=`p' bw=optimal covar Sharp") dec(4)
			}	
			qui: rdrobust totnr_weekly1989 airportdist, p(1) c(6000) vce(nncluster countrypair)		
				outreg2 using "results/RDD_Table1_ClSE.xls", aster(se) ctitle("p=`p' bw=`bw' Sharp") dec(4)
			*BY DECADE: 1990-2010
			foreach depvar in weekly_90to2000 weekly_00to10 weekly_90to2010 {
				qui: rdrobust `depvar' airportdist, p(1) c(6000) covs($RD_covars1) vce(nncluster countrypair) 
				outreg2 using "results/RDD_Table1_ClSE.xls", aster(se) ctitle("`i'") dec(4)
			}
			sum totnr_weekly2014 weekly_90to2000 weekly_00to10 weekly_90to2010 
	
