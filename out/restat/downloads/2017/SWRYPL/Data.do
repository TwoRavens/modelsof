**********************************************		
**********************************************
*  OFF SERVER DATA
**********************************************
**********************************************

	* Get experimental data
	use DATA\ExperimentalData, clear
	
	* Cleanup and reshape lottery data for ease of rank dependent estimation
	qui {
		* adjust some WEW lotteries that are not rank ordered
		foreach q in 1 2 3 4 {
		foreach p in A B {
			rename prize`p'`q' VPRIZE`p'`q'
			generate prob`p'`q'_ = prob`p'`q'
			generate VPRIZE`p'`q'_ = VPRIZE`p'`q'
		}
		}

		foreach q in rWEW3 rWEW7 rWEW10 rWEW11 rWEW14 rWEW15 {
			replace probA1 = probA2_ if qid=="`q'"
			replace VPRIZEA1 = VPRIZEA2_ if qid=="`q'"
			replace probA2 = probA1_ if qid=="`q'"
			replace VPRIZEA2 = VPRIZEA1_ if qid=="`q'"
		}
		foreach q in rWEW4 rWEW8 rWEW7 rWEW8 rWEW12 rWEW16 rWEW19 rWEW20 rWEW23 rWEW24 {
			replace probA1 = probA2_ if qid=="`q'"
			replace VPRIZEA1 = VPRIZEA2_ if qid=="`q'"
			replace probA2 = probA3_ if qid=="`q'"
			replace VPRIZEA2 = VPRIZEA3_ if qid=="`q'"
			replace probA3 = probA1_ if qid=="`q'"
			replace VPRIZEA3 = VPRIZEA1_ if qid=="`q'"
		}
		foreach q in rWEW3 rWEW7 rWEW10 rWEW11 rWEW14 rWEW15 rWEW18 rWEW22 {
			replace probB1 = probB2_ if qid=="`q'"
			replace VPRIZEB1 = VPRIZEB2_ if qid=="`q'"
			replace probB2 = probB1_ if qid=="`q'"
			replace VPRIZEB2 = VPRIZEB1_ if qid=="`q'"
		}
		foreach q in rWEW4 rWEW8 rWEW12 rWEW16 rWEW19 rWEW20 rWEW23 rWEW24 {
			replace probB1 = probB2_ if qid=="`q'"
			replace VPRIZEB1 = VPRIZEB2_ if qid=="`q'"
			replace probB2 = probB3_ if qid=="`q'"
			replace VPRIZEB2 = VPRIZEB3_ if qid=="`q'"
			replace probB3 = probB1_ if qid=="`q'"
			replace VPRIZEB3 = VPRIZEB1_ if qid=="`q'"
		}

		foreach q in 1 2 3 4 {
		foreach p in A B {
			drop prob`p'`q'_
			drop VPRIZE`p'`q'_
		}
		}

		* shift over one ... also including the r lotteries
		forvalues x=1/61 {
		foreach y in A B {
			forvalues z=3(-1)1 {
				local zz=`z'+1
				replace prob`y'`zz' = prob`y'`z' if qid=="ls`x'" | qid=="rWEW`x'"  | qid=="r`x'"
				replace VPRIZE`y'`zz' = VPRIZE`y'`z' if qid=="ls`x'"  | qid=="rWEW`x'"  | qid=="r`x'"
			}
			replace prob`y'1 = 0 if qid=="ls`x'"  | qid=="rWEW`x'" | qid=="r`x'"
			replace VPRIZE`y'1 = 0 if qid=="ls`x'"  | qid=="rWEW`x'" | qid=="r`x'"
		}
		}
		}

		* now get the roundings of probabilities right for stata 
		foreach q in 1 2 3 4 {
			foreach p in A B {
				generate prob`p'`q'_ = .    
			}
		}

		forvalues z = 0(1)100 {
			foreach q in 1 2 3 4 {
				foreach p in A B {
					replace prob`p'`q'_ = `z'/100 if (abs(`z'/100 - prob`p'`q') < 0.0001 )    
				}
			}
		}
		foreach q in 1 2 3 4 {
			foreach p in A B {
				drop prob`p'`q'
				rename prob`p'`q'_  prob`p'`q'
			}
		}
	
	* Append Additional Experimental Data	
	save TempData/ExperimentData.dta, replace
	
	* SIMULATION OF REGISTER DATA
	* Generate Sample ID
	generate S_1 	= (sampleIDX==1)
	generate S_2 	= (sampleIDX==2)
	generate S_3 	= (sampleIDX==3)
		
	* Only keep variables of interest
	keep pnr sampleIDX task decision VPRIZE* prob* qid Totalpay RApay S_*

	* Save Experimental Data	
	save TempData/ExperimentalData, replace
		
	* Now do matrix of covariates on sample treatments and completion of experiment	
	use TempData/ExperimentalData.dta, replace
	keep pnr S_* Totalpay RApay 
	rename Totalpay totalpay 
	rename RApay riskpay
	duplicates drop
	save TempData/ExperimentalData_X.dta, replace		
	
	*** READ IN MEAN AND COVARIANCE MATRIXES EXPORTED FROM THE SEVER
	* Means
	use DATA\meanM_E, clear
	mkmat mean_1, matrix(MMX)
	
	* Covariance
	use DATA\corrM_E, clear
	mkmat corr_*, matrix(CVMX)

	* size of correlation matrix
	local CVMXn = rowsof(CVMX)
		
	* Set the number of unknows from outside of the server in the matrix 
	local K0 = 18
	
	* Set the start for the knowns
	local K1 = `K0' + 1
	
	* Define mata program to generate symetric matrizes
	clear mata
	mata:
	real matrix foo()
	{
		temp = st_matrix("V_c")
		temp = makesymmetric(temp)
		st_matrix("V2", temp)
		return(1)
	}
	end
		
	use TempData/ExperimentalData_X.dta, clear
		
	* Partition the matrix on what is known (22), what is not known (11) and the covariance
	mat V11 = CVMX[1..`K0',1..`K0']
	mat V22 = CVMX[`K1'..`CVMXn',`K1'..`CVMXn']
	mat V12 = CVMX[1..`K0',`K1'..`CVMXn']
				
	* the variance of the conditional distribution is fixed...
	mat V_c = V11 - V12*inv(V22)*(V12')
	mata: V2 = foo()	
	mat list V2
		
	* Invert the means
	mat mu1 = MMX[1..`K0',1]
	mat mu2 = MMX[`K1'..`CVMXn',1]
		
	* ...but the mean changes
	* so first take the realizations of what we have out in a matrix
	set matsize 11000
	mkmat S_1 S_2 S_3 riskpay totalpay , matrix(X)
	mat tX = X'

	* now compute the mean of the conditional disitribution for each observation
	set emptycells drop
	mat mu_c = mu1#J(1,_N,1) + V12*inv(V22)*(tX - mu2#J(1,_N,1))

	* make them variables
	mat putback = mu_c'
		
		          
		
	* get names of variables
	mat colnames putback =  ///
	mean_male   			///
	mean_age 				///
	mean_married 			///
	mean_hsize				///
	mean_income 			///
	mean_assets_total				///
	mean_assets_realesta  			///
	mean_assets_stocks				///
	mean_assets_bond 	   ///
	mean_assets_banks	  ///
	mean_assets_pension	  ///
	mean_assets_cars	  ///
	mean_liab_total		  ///
	mean_liab_mortgage	  ///
	mean_liab_bankdebt	  ///
	mean_wealth_net		  ///
	mean_wealth_T		  ///
	mean_truncated 
	svmat putback, names(col)

	* now generate the fake variables from the multivariate normal distribution
	
	
	drawnorm male age married hsize income assets_total assets_realesta assets_stocks assets_bond assets_banks assets_pension assets_cars liab_total liab_bankdebt liab_mortgage wealth_net wealth_T truncated , cov(V2) 
	foreach y in male age married hsize income assets_total assets_realesta assets_stocks assets_bond assets_banks assets_pension assets_cars liab_total liab_bankdebt liab_mortgage wealth_net wealth_T truncated  {
		replace `y' = `y' + mean_`y'
	}
	* save data
	save TempData/ExperimentalData_XX.dta, replace

	keep pnr male age married hsize income assets_total assets_realesta assets_stocks assets_bond assets_banks assets_pension assets_cars liab_total liab_bankdebt liab_mortgage wealth_net wealth_T truncated S_* riskpay totalpay
	
	* Now add the private liabilities at 0
	generate liab_private  = 0
	
	* Now fix the fake dummies which are dummies.
	foreach X in male married truncated {
		replace `X' = 1 if `X'>0.5
		replace `X' = 0 if `X'~=1			
	}

	* Now correct bounded variables 
	foreach x in income assets_total assets_realesta assets_stocks assets_bond assets_banks assets_pension assets_cars liab_total liab_bankdebt liab_mortgage wealth_T {
		replace `x' = (`x'>0)*`x' + (`x'<=0)*exp(1)
	}
	
	* Truncated the wealth correctly
	replace wealth_T  = exp(1) if truncated==1
	replace wealth_T  = exp(1) if wealth_net<0  
	
	* Save final simulated covariates
	save TempData/ExperimentalDataFake, replace
	
	* Get the original experimental data
	use TempData/ExperimentalData.dta, replace 
	merge m:1 pnr using TempData/ExperimentalDataFake	
	rename decision choice
	save Data, replace
	
	* compare covariance matrices
	correlate income assets_total assets_realesta assets_stocks assets_bond assets_banks assets_pension assets_cars liab_total liab_bankdebt liab_mortgage wealth_T S_* riskpay totalpay, cov
	
	* List the real one
	matrix list CVMX
	
	
	
/*  ON SERVER DATA GENERATION */

/*
**************************************************
*	Get experimental data from the two 2015 experiments
***************************************************
	
* Get experimental data from first round of experiments
	* use "$e_data\2_runde\risktime_results.dta", clear
	use DSTdata

* describe data
	des
	
* now keep variables of interest
	save TempData/temp, replace

***************************************************
* ONLY READ IN INITIAL RISK AVERSION TASKS
***************************************************

* Now clean up RA tasks
	use TempData/temp, clear
	keep if type == 1
	keep pnr par_single stratum period decision r_l* r_r* qid dato_stempel
	save TempData//tmp, replace
	keep pnr
	duplicates drop
	generate pnrS = pnr
	destring pnr, replace
	save TempData/tmp2, replace
	use TempData/tmp, clear
	tostring _all, replace
	order pnr stratum  period decision r_l* r_r* qid
	foreach y in a p {
	foreach z in r l {
	foreach x in 1 2 3 4 {
			replace r_`z'`y'`x' = subinstr(r_`z'`y'`x',",",".",.)
	}
	}
	}
	destring _all, replace
	generate taskRA= (period>0)
	rename period task

	* Remove those which was restarted.
	sort pnr dato_stempel
	egen seqN = seq(), by(pnr)
	egen seqM = max(seqN), by(pnr)
	drop if seqN<3 & seqM==62 
	drop if seqN>60 & seqM==120
	drop seqN seqM
	rename r_la1 VPRIZEA1
	rename r_la2 VPRIZEA2
	rename r_la3 VPRIZEA3
	rename r_la4 VPRIZEA4
	
	rename r_ra1 VPRIZEB1
	rename r_ra2 VPRIZEB2
	rename r_ra3 VPRIZEB3
	rename r_ra4 VPRIZEB4
	
	rename r_lp1 probA1
	rename r_lp2 probA2
	rename r_lp3 probA3
	rename r_lp4 probA4
	
	rename r_rp1 probB1
	rename r_rp2 probB2
	rename r_rp3 probB3
	rename r_rp4 probB4

	generate testA = probA1 + probA2 + probA3 + probA4
	generate testB = probB1 + probB2 + probB3 + probB4

* Convert probabilities to 0-1 scale
forvalues x=1(1)4 {
	forvalues y = 1(1)9 {
		replace probA`x' = probA`x'*10 if probA`x'==`y'	& testA~=1
		replace probB`x' = probB`x'*10 if probB`x'==`y'	& testB~=1	
	}
}

forvalues x=1(1)4 {
		replace probA`x' = probA`x'*100 if testA==1	
		replace probB`x' = probB`x'*100 if testB==1	
}


generate scaleA = probA1 + probA2 + probA3 + probA4
generate scaleB = probB1 + probB2 + probB3 + probB4

replace probA1 = probA1 / scaleA
replace probA2 = probA2 / scaleA
replace probA3 = probA3 / scaleA
replace probA4 = probA4 / scaleA

replace probB1 = probB1 / scaleB
replace probB2 = probB2 / scaleB
replace probB3 = probB3 / scaleB
replace probB4 = probB4 / scaleB

	* Label variables
	label variable decision "Decision in task"
	label variable taskRA 	"Risk Aversion Task"
	label variable task 	"Task number"
	label variable VPRIZEA1 	"Option A: Amount of the First Prize"
	label variable VPRIZEA2 	"Option A: Amount of the Second Prize"
	label variable VPRIZEA3 	"Option A: Amount of the Third Prize"
	label variable VPRIZEA4 	"Option A: Amount of the Fourth Prize"
	label variable VPRIZEA1 	"Option B: Amount of the First Prize"
	label variable VPRIZEA2 	"Option B: Amount of the Second Prize"
	label variable VPRIZEA3 	"Option B: Amount of the Third Prize"
	label variable VPRIZEA4 	"Option B: Amount of the Fourth Prize"
	label variable probA1 		"Option A: Probability of the First Prize"
	label variable probA2 		"Option A: Probability of the Second Prize"
	label variable probA3 		"Option A: Probability of the Third Prize"
	label variable probA4 		"Option A: Probability of the Fourth Prize"
	label variable probA1 		"Option B: Probability of the First Prize"
	label variable probA2 		"Option B: Probability of the Second Prize"
	label variable probA3 		"Option B: Probability of the Third Prize"
	label variable probA4 		"Option B: Probability of the Fourth Prize"
	
	* Make sure there are no missing values
	keep pnr task decision VPR** prob* qid dato_stempel taskRA stratumid
	
	* 
	generate choice = 0
	replace choice = 1 if decision==1
	compress

* 	Merge back string pnr	
	merge m:1 pnr using TempData/tmp2

* 	Identify the dates
	generate date_ = substr(dato_stempel,1,10)
	generate date = date(date_, "YMD")
	format date %td
	generate householddecision = (date_=="2015-03-26" | date_=="2015-03-25" | date_=="2015-03-24" ) 
	
* 	only keep right pnr	
	drop pnr
	rename pnrS pnr

* Generate year variable	
	generate year = year(date)
	
* Identify sample
	generate sample = 1
	generate sampleIDX = .
	replace sampleIDX = 1 if stratumid==1
	replace sampleIDX = 2 if stratumid==2
	replace sampleIDX = 3 if stratumid==2 & householddecision==1
	replace sampleIDX = 4 if stratumid==3
	replace sampleIDX = 5 if stratumid==4
			
*   Now save the data as risk averions task from the first experiment
	save TempData/RA.dta, replace
	
* Get experimental data from second round of experiments
	use "$e_data\3_runde\risktime_results.dta", clear
	
* describe data
	des
	
* now keep variables of interest
	save TempData/temp, replace

* Now clean up
	use TempData/temp, clear
	keep if type == "1"
	keep pnr par_single stratum period decision r_l* r_r* qid dato_stempel
	tostring _all, replace
	order pnr stratum  period decision r_l* r_r* qid
	foreach y in a p {
	foreach z in r l {
	foreach x in 1 2 3 4 {
			replace r_`z'`y'`x' = subinstr(r_`z'`y'`x',",",".",.)
	}
	}
	}
	destring par_single stratum period decision r_l* r_r* qid dato_stempel, replace
	generate taskRA= (period>0)
	rename period task

	duplicates drop
	generate dateS= substr(dato_stempel, 12, 6)
	
	keep if stratumid==1
	

	* Remove those which was restarted.
	sort pnr dato_stempel
	egen seqN = seq(), by(pnr)
	egen seqM = max(seqN), by(pnr)
	drop if seqN<3 & seqM==62 
	drop if seqN>60 & seqM==120
	drop seqN seqM
	rename r_la1 VPRIZEA1
	rename r_la2 VPRIZEA2
	rename r_la3 VPRIZEA3
	rename r_la4 VPRIZEA4
	
	rename r_ra1 VPRIZEB1
	rename r_ra2 VPRIZEB2
	rename r_ra3 VPRIZEB3
	rename r_ra4 VPRIZEB4
	
	rename r_lp1 probA1
	rename r_lp2 probA2
	rename r_lp3 probA3
	rename r_lp4 probA4
	
	rename r_rp1 probB1
	rename r_rp2 probB2
	rename r_rp3 probB3
	rename r_rp4 probB4

	generate testA = probA1 + probA2 + probA3 + probA4
	generate testB = probB1 + probB2 + probB3 + probB4

* Convert probabilities to 0-1 scale
forvalues x=1(1)4 {
	forvalues y = 1(1)9 {
		replace probA`x' = probA`x'*10 if probA`x'==`y'	& testA~=1
		replace probB`x' = probB`x'*10 if probB`x'==`y'	& testB~=1	
	}
}

forvalues x=1(1)4 {
		replace probA`x' = probA`x'*100 if testA==1	
		replace probB`x' = probB`x'*100 if testB==1	
}


generate scaleA = probA1 + probA2 + probA3 + probA4
generate scaleB = probB1 + probB2 + probB3 + probB4

replace probA1 = probA1 / scaleA
replace probA2 = probA2 / scaleA
replace probA3 = probA3 / scaleA
replace probA4 = probA4 / scaleA

replace probB1 = probB1 / scaleB
replace probB2 = probB2 / scaleB
replace probB3 = probB3 / scaleB
replace probB4 = probB4 / scaleB

	* Label variables
	label variable decision "Decision in task"
	label variable taskRA 	"Risk Aversion Task"
	label variable task 	"Task number"
	label variable VPRIZEA1 	"Option A: Amount of the First Prize"
	label variable VPRIZEA2 	"Option A: Amount of the Second Prize"
	label variable VPRIZEA3 	"Option A: Amount of the Third Prize"
	label variable VPRIZEA4 	"Option A: Amount of the Fourth Prize"
	label variable VPRIZEA1 	"Option B: Amount of the First Prize"
	label variable VPRIZEA2 	"Option B: Amount of the Second Prize"
	label variable VPRIZEA3 	"Option B: Amount of the Third Prize"
	label variable VPRIZEA4 	"Option B: Amount of the Fourth Prize"
	label variable probA1 		"Option A: Probability of the First Prize"
	label variable probA2 		"Option A: Probability of the Second Prize"
	label variable probA3 		"Option A: Probability of the Third Prize"
	label variable probA4 		"Option A: Probability of the Fourth Prize"
	label variable probA1 		"Option B: Probability of the First Prize"
	label variable probA2 		"Option B: Probability of the Second Prize"
	label variable probA3 		"Option B: Probability of the Third Prize"
	label variable probA4 		"Option B: Probability of the Fourth Prize"
	
	* Make sure there are no missing values
	keep pnr task decision VPR** prob* qid dato_stempel taskRA stratumid
		* 
	generate choice = 0
	replace choice = 1 if decision==1
	compress

* 	Identify the dates
	egen maxtask = max(task), by(pnr)
	replace task = task -11
	replace task = task - 19 if maxtask>71

* Generate year variable	
	generate year = 2015
	
* Identify sample
	generate sample = 2
	generate sampleIDX = .
	replace sampleIDX = 11 if stratumid==1
	
*   Now save the data as risk averions task
	save TempData/RA2.dta, replace			
			
**********************************************************
* COLLATE INTO ONE BIG FILE AND CLEAN UP EXPERIMENTAL DATA
**********************************************************	
	
	use TempData/RA, clear
	append using TempData/RA2
	
	******************************************
	* Only keep relevant experimental data
	keep task prob* VPRIZE* qid dato_stempel pnr choice date year sampleIDX
	compress	
	
	* Only keep relevant experimental sample (do not iclude criminals and households)
	keep if sampleIDX ==1 |  sampleIDX ==2 | sampleIDX ==11
	
	* Cleanup and reshape lottery data for ease of rank dependent estimation
	qui {
		* adjust some WEW lotteries that are not rank ordered
		foreach q in 1 2 3 4 {
		foreach p in A B {
			generate prob`p'`q'_ = prob`p'`q'
			generate VPRIZE`p'`q'_ = VPRIZE`p'`q'
		}
		}

		foreach q in rWEW3 rWEW7 rWEW10 rWEW11 rWEW14 rWEW15 {
			replace probA1 = probA2_ if qid=="`q'"
			replace VPRIZEA1 = VPRIZEA2_ if qid=="`q'"
			replace probA2 = probA1_ if qid=="`q'"
			replace VPRIZEA2 = VPRIZEA1_ if qid=="`q'"
		}
		foreach q in rWEW4 rWEW8 rWEW7 rWEW8 rWEW12 rWEW16 rWEW19 rWEW20 rWEW23 rWEW24 {
			replace probA1 = probA2_ if qid=="`q'"
			replace VPRIZEA1 = VPRIZEA2_ if qid=="`q'"
			replace probA2 = probA3_ if qid=="`q'"
			replace VPRIZEA2 = VPRIZEA3_ if qid=="`q'"
			replace probA3 = probA1_ if qid=="`q'"
			replace VPRIZEA3 = VPRIZEA1_ if qid=="`q'"
		}
		foreach q in rWEW3 rWEW7 rWEW10 rWEW11 rWEW14 rWEW15 rWEW18 rWEW22 {
			replace probB1 = probB2_ if qid=="`q'"
			replace VPRIZEB1 = VPRIZEB2_ if qid=="`q'"
			replace probB2 = probB1_ if qid=="`q'"
			replace VPRIZEB2 = VPRIZEB1_ if qid=="`q'"
		}
		foreach q in rWEW4 rWEW8 rWEW12 rWEW16 rWEW19 rWEW20 rWEW23 rWEW24 {
			replace probB1 = probB2_ if qid=="`q'"
			replace VPRIZEB1 = VPRIZEB2_ if qid=="`q'"
			replace probB2 = probB3_ if qid=="`q'"
			replace VPRIZEB2 = VPRIZEB3_ if qid=="`q'"
			replace probB3 = probB1_ if qid=="`q'"
			replace VPRIZEB3 = VPRIZEB1_ if qid=="`q'"
		}

		foreach q in 1 2 3 4 {
		foreach p in A B {
			drop prob`p'`q'_
			drop VPRIZE`p'`q'_
		}
		}

		* shift over one ... also including the r lotteries
		forvalues x=1/61 {
		foreach y in A B {
			forvalues z=3(-1)1 {
				local zz=`z'+1
				replace prob`y'`zz' = prob`y'`z' if qid=="ls`x'" | qid=="rWEW`x'"  | qid=="r`x'"
				replace VPRIZE`y'`zz' = VPRIZE`y'`z' if qid=="ls`x'"  | qid=="rWEW`x'"  | qid=="r`x'"
			}
			replace prob`y'1 = 0 if qid=="ls`x'"  | qid=="rWEW`x'" | qid=="r`x'"
			replace VPRIZE`y'1 = 0 if qid=="ls`x'"  | qid=="rWEW`x'" | qid=="r`x'"
		}
		}
		}

		* now get the roundings of probabilities right for stata 
		foreach q in 1 2 3 4 {
			foreach p in A B {
				generate prob`p'`q'_ = .    
			}
		}

		forvalues z = 0(1)100 {
			foreach q in 1 2 3 4 {
				foreach p in A B {
					replace prob`p'`q'_ = `z'/100 if (abs(`z'/100 - prob`p'`q') < 0.0001 )    
				}
			}
		}
		foreach q in 1 2 3 4 {
			foreach p in A B {
				drop prob`p'`q'
				rename prob`p'`q'_  prob`p'`q'
			}
		}
	
	* Append Additional Experimental Data	
	save TempData/ExperimentData.dta, replace
	
**************************************************
* GET EXPERIMENTAL PAYMENTS FROM PAYMENT RECORDS
**************************************************
	
* merge financial data with experimental data
	use TempData/ExperimentData, clear
	egen record = seq(), by(pnr)	
	keep if record==1
	keep pnr sampleIDX
	duplicates drop
	merge 1:1 pnr using X:\Rawdata\703278\Eksterndata_705060ngl\Spil_DST\2_runde\praemiedb.dta
	drop if _merge == 2
	keep pnr* beloeb pct a1_beloeb a2_beloeb a3a_beloeb a3b_beloeb a4_beloeb a5_beloeb sampleIDX
	foreach x in beloeb pct a1_beloeb a2_beloeb a3a_beloeb a3b_beloeb a4_beloeb a5_beloeb {
		rename `x' S1`x'	
	}
	merge 1:1 pnr using X:\Rawdata\703278\Eksterndata_705060ngl\Spil_DST\3_runde\praemiedb.dta
	drop if _merge == 2
	keep pnr S1* a1_beloeb a2_beloeb a3_beloeb a4_beloeb a6_beloeb beloeb pct sampleIDX
	replace beloeb = S1beloeb if beloeb==.
	replace pct = S1pct if pct==.
	replace S1a1_beloeb = a1_beloeb if S1a1_beloeb==.
	replace S1a1_beloeb = 0 if S1a1_beloeb ==.	
	generate totalpay = S1a1_beloeb+ S1a2_beloeb+ S1a3a_beloeb+ S1a3b_beloeb+ S1a4_beloeb+ S1a5_beloeb if a2_beloeb==.
	replace totalpay = a1_beloeb+ a2_beloeb+ a3_beloeb+ a4_beloeb+ a6_beloeb if a6_beloeb~=.
	replace totalpay = 0 if totalpay==.
	
	keep pnr S1a1_beloeb totalpay
	duplicates drop
	rename S1a1_beloeb riskpay
	
	la variable riskpay				"Payment in risk task"
	la variable totalpay			"Payment in total"
		
	save TempData/payments, replace

**********************************************		
**********************************************
*  ADMINISTRATIVE REGISTRY DATA
**********************************************
**********************************************
	
**********************************************
* DEMOGRAPHICS FROM CPR REGISTER		     *
**********************************************
		clear
		use $raw\bef2015, clear
		* Male dummy
		rename koen male
		replace male = 2-male
		* age 
		generate age = 2015- year(foed_dag) -1
		* married dummy
		generate married = (civst=="G")
		* household size
		egen hsize = seq(), by(familie_id)
		
		keep pnr male age married hsize kom
		duplicates drop
		compress
		
		* Make use individuals are unique
		egen seqN = seq(), by(pnr)
		tab seqN
		egen maxSeq = max(seqN), by(pnr)
		drop if maxSeq>1
		keep pnr male age married hsize kom
		
		* Label demographic variables
		label variable age "Age in years"
		label variable married "Married"
		label variable male "Male"
		label variable hsize "Household size in count"
		label variable kom "Municipality"
		
		save TempData\Demog, replace
	
***************************************************************
*		FINANCIAL WEALTH  AND INCOME DATA FROM TAX REGISTRY   *
***************************************************************

		* Get family link to link value of cars
		use $raw\bef2014, clear
		keep pnr familie_id
		duplicates drop
		save TempData/famlink2014, replace
		
		* Now get tax records
		use $raw\ind2014.dta, clear
		drop if pnr==""
		keep pnr formrest_ny05 qaktivf_ny05 qpassivn koejd perindkialt pantakt bankgaeld oblgaeld pantgaeld bankakt kursakt oblakt 
		rename formrest_ny05 	netwealth
		rename qaktivf_ny05     assets
		rename qpassivn			debt
		rename koejd			housingvalue		
		rename perindkialt		income
		rename pantakt		 	privateloan_assets
		rename bankgaeld	 	bank_debt
		rename oblgaeld		 	bond_debt
		rename pantgaeld	 	privateloan_debt
		rename bankakt		 	bank_assets
		rename kursakt		 	stock_assets
		rename oblakt		 	bond_assets		
		
		duplicates drop
		compress

		* Make sure individuals are unique
		egen seqN = seq(), by(pnr)
		tab seqN
		egen maxSeq = max(seqN), by(pnr)
		drop if maxSeq>1
		drop seqN maxSeq
		save TempData/wealthRec2014, replace
		
		* Get value of cars on familie level
		use $raw\formbil2013, clear
		collapse (sum) vejledende_salgspris, by(familie_id)
		rename vejledende_salgspris carvalue
		save TempData/wealthcar2013, replace
		
		* Get value of directly held property
		use $raw\formejer2014, clear
		drop if pnr==""
		collapse (sum) markedsvaerdi, by(pnr)
		rename markedsvaerdi koejd_market
		save TempData/valueproperty2014, replace
	
		* Get value of inderectly hold property
		use $raw\formand2014, clear
		drop if pnr==""
		collapse (sum) markedsvaerdi, by(pnr)
		rename markedsvaerdi koejdA_market
		save TempData/valuepropertyA2014, replace
	
		* Get pension wealth
		use $raw\PENSFORM2014, clear
		drop if pnr==""	
		* generate pension amount
		foreach x in andakkrgublb andkolbonusblb andsaebonusblb garanydelsblb pensdepotblb {
			replace `x' = 0 if `x'==.	
		}
		
		generate amount = andakkrgublb + andkolbonusblb + andsaebonusblb + garanydelsblb + pensdepotblb
		collapse (sum) amount, by(pnr)
		rename amount pension
		save TempData/wealthpension2014, replace
			
		* Now merge wealth components together together 
		use TempData/wealthRec2014, clear
		* get family link for car values
		merge 1:1 pnr using TempData/famlink2014
		keep if _merge~=2
		drop _merge
		merge m:1 familie_id using TempData/wealthcar2013
		drop if _merge==2
		drop _merge	
		merge 1:1 pnr using TempData/valueproperty2014
		drop if _merge==2
		drop _merge
		merge 1:1 pnr using Tempdata/valuepropertyA2014
		drop if _merge==2
		drop _merge
		merge 1:1 pnr using Tempdata/wealthpension2014
		drop if _merge==2
		drop _merge
		foreach y in koejd_market koejdA_market carvalue pension {	
			replace `y' = 0 if `y'==.	
		}
		
		* define our variables of interest
		generate assets_realestate  = koejd_market + koejdA_market
		generate assets_stocks      = stock_assets
		generate assets_banks		= bank_assets 
		generate assets_bonds		= privateloan_assets + bond_assets
		generate assets_pension		= pension
		generate assets_cars		= carvalue
	
		egen assets_total		 = rowtotal(assets_*)
	
		generate liab_bankdebt 	 = bank_debt 
		generate liab_mortgage 	 = bond_debt 
		generate liab_private	 = privateloan_debt  
	
		egen liab_total			 = rowtotal(liab_*)
	
		* Generate net position
		generate wealth_net 	 = assets_total - liab_total  

		* Generate truncated netwealth varialbe
		generate wealth_T = (wealth_net>exp(1))
		generate truncated = (wealth_net<exp(1))
		replace  wealth_T = wealth_net * wealth_T
		replace  wealth_T = exp(1) if wealth_T<exp(1)
	
		* Keep relevant variables
		keep pnr assets* liab_* wealth_* truncated income
		
		duplicates drop
		compress
	
		* Make use individuals are unique
		egen seqN = seq(), by(pnr)
		tab seqN
		egen maxSeq = max(seqN), by(pnr)
		drop if maxSeq>1
		keep pnr assets* liab_* wealth_*  truncated income
	
		la variable income 				"Income"
	
		la variable assets_total 		"Total assets"
		la variable assets_realestate	"Real estate"
		la variable assets_stocks		"Shares and mutual funds"
		la variable assets_banks		"Deposits in banks"
		la variable assets_bond			"Bonds and mortgages"
		la variable assets_pension		"Pension"
		la variable assets_cars			"Cars"
		
		la variable liab_total 		"Total liabilities"
		la variable liab_bankdebt	"Non-mortgage debt in financial institution"
		la variable liab_mortgage	"Mortgage"
		la variable liab_private	"Privately issued debt"
		
		la variable wealth_net 		"Net wealth"
		la variable wealth_T		"Net wealth truncated to zero"
		
		save TempData/Wealth, replace
	
***********************************************************
* COLLATE ALL REGISTER INFORMATION AND EXPERIMENTAL DATA
***********************************************************

*		Regression in paper run using the olde PNR key. Use missing link to remove subjects
		* merge financial data with experimental data
		use TempData/RA.dta, clear
		append using TempData/RA2.dta
		keep pnr 
		duplicates drop
		rename pnr pnr_705060
		merge m:1 pnr_705060 using X:\Rawdata\703278\PNRNGL_2015
		drop if _merge==1
		keep pnr_705060
		rename pnr_705060 pnr
		save TempData/selection, replace
		
		use TempData/Demog, clear
		capture drop _merge
		merge 1:1 pnr using TempData/Wealth
		drop if _merge~=3
		drop _merge
		save TempData/DataReg, replace
		
		merge 1:m pnr using TempData/ExperimentData.dta
		* drop individuals without wealth or income information
		drop if _merge ~=3
		drop _merge
		merge m:1 pnr using TempData/payments.dta
		drop if _merge ~=3
		drop _merge
		merge m:1 pnr using TempData/selection.dta
		drop if _merge ~=3
		drop _merge
				
* 		Save Final data
		save Data, replace		
		
***************************************************************************************************
*		Generate fake covariates to use off the server
***************************************************************************************************	
	
	* drop the non merged
	use Data, replace
	keep pnr riskpay totalpay sampleIDX male age married hsize income assets_total assets_realesta assets_stocks assets_bond assets_banks assets_pension assets_cars liab_total liab_bankdebt liab_mortgage wealth_net wealth_T truncated
	duplicates drop
	
	* Generate Sample ID
	generate S_1 	= (sampleIDX==1)
	generate S_2 	= (sampleIDX==2)
	generate S_11 	= (sampleIDX==3)
		
	* Remove missing values
	foreach x in male age married hsize income assets_total assets_realesta assets_stocks assets_bond assets_banks assets_pension assets_cars liab_total liab_bankdebt liab_mortgage wealth_net wealth_T truncated S_1 S_2 S_3 riskpay totalpay {
			replace `x' = 0 if `x' ==.	
	}
	keep pnr male age married hsize income assets_total assets_realesta assets_stocks assets_bond assets_banks assets_pension assets_cars liab_total liab_bankdebt liab_mortgage wealth_net wealth_T truncated S_1 S_2 S_3 riskpay totalpay
	save TempData/dataS, replace
	
	* generate matrixes for outside of the server
	clear all
	use TempData/dataS, clear
	qui summ male
	matrix meanM = r(mean)
	foreach x in age married hsize income assets_total assets_realesta assets_stocks assets_bond assets_banks assets_pension assets_cars liab_total liab_bankdebt liab_mortgage wealth_net wealth_T truncated S_1 S_2 S_3 riskpay totalpay {
		qui summ `x'
		local mean = r(mean)
		matrix meanM = meanM \ `mean'
	}
	matrix list meanM

	preserve
	matrix meanM_E = meanM
	clear
	svmat meanM_E, names(mean_)
	save ToMove/meanM_E, replace
	restore		
	
	corr male age married hsize income assets_total assets_realesta assets_stocks assets_bond assets_banks assets_pension assets_cars liab_total liab_bankdebt liab_mortgage liab_private wealth_net wealth_T S_1 S_2 S_11 riskpay totalpay, covariance 
	matrix corrM = r(C)
	matrix list corrM
	preserve
	matrix corrM_E = corrM
	clear
	svmat corrM_E, names(corr_)
	save ToMove/corrM_E, replace
	restore		
	
	* generate covariates off server
	
	*/
	
	
