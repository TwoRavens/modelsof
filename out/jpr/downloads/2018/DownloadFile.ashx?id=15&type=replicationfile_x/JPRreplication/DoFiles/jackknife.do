
***********************************
***********************************
* REPLICATION
*
* IDEOLOGY AND STATE TERROR
* How officer beliefs shaped repression during Argentina’s ‘Dirty War’
*
* JOURNAL OF PEACE RESEARCH
*
* Author: Adam Scharpf (University of Mannheim)		   
* 	
* Date: Feb 2018		
*
* Do-File: jackknife.do
************************************
************************************


************************************
*	PROCEDURE
*	1) Estimate main regression model
*	2) Keep only observations in model (model obs)
*	3) Re-estimate main regression model EXCLUDING one subzone
*	4) Only use observations in estimated model (model obs w/o subzone obs)
* 	5) Calculate ATE
* 	6) Repeat step 3-5 for all subzones
************************************

*Loading data
use "$datapath\repdata.dta", clear

*Changing directy to "jackknife" folder
cd "Jackknife"


************************************
*ROBUSTNESS CHECK: Subzone-based Jackknife
************************************	

*Model 3: Subzone	
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering 
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 planrepprop samegarr armmatprop
		 if army==1, cluster(area);
	#delimit cr
	
	*Creating identifier for obs in analysis	
	gen obsjack=1 if e(sample) 
		
	*Saving data set for repeated loading
	save "datatojackknife.dta", replace
	
	*Writing subzones of empirical model in local
	levelsof subzone if obsjack==1, local(subzone) 								

********************************************
*Jackknifing subzones
********************************************	
	
	*Looping over subzones
	foreach sz of local subzone {	
	
	*Displaying region to be excluded
	disp "EXCLUDED SUBZONE:" 
	disp "`sz'"
	
	*Loading data set
	use "datatojackknife.dta", clear	
	
	*Estimating main regression model without specific subzone
	#delimit ;
	nbreg nvictims
			infantry artillery communications engineering 
		    rankhigh homedeploy polcon oem 
		    experience comdur multunits
		    planrepprop samegarr armmatprop
		    if obsjack==1 & 
			subzone!="`sz'", cluster(area);
	#delimit cr	
	
	*Keeping only observations that are part of previous analysis
	gen keep=1 if e(sample)
	drop if keep!=1
	
	*Determining number of observations for which substantive effects are calculated 
	count if keep==1
	local n=r(N)
	
	*Setting seed
	set seed 84139627
	
	*Sampling coefficients for main regression model (without subzone obs)
	#delimit ;
	estsimp nbreg nvictims
			infantry artillery communications engineering 
		    rankhigh homedeploy polcon oem 
		    experience comdur multunits
		    planrepprop samegarr armmatprop
		    , cluster(area);
	#delimit cr	
		
	
********************************************
*Simulating expected counts for different branches across all officers in analysis
********************************************
	
	*Note: Reference category is cavalry
	
	*Expected counts if branch is "Cavalry" 
	forvalues i=1/`n' {
	setx [`i']
	setx infantry 0 artillery 0 communications 0 engineering 0
	setx
	simqi, ev genev(ec_cav_`i')
	}
	
	*Expected counts if branch is "INFANTRY"
	forvalues i=1/`n' {
	setx [`i']
	setx infantry 1 artillery 0 communications 0 engineering 0
	setx
	simqi, ev genev(ec_inf_`i')
	}
	
	*Expected counts if branch is "ARTILLERY"
	forvalues i=1/`n' {
	setx [`i']
	setx infantry 0 artillery 1 communications 0 engineering 0
	setx
	simqi, ev genev(ec_art_`i')
	}
	
	*Expected counts if branch is "COMMUNICATIONS"
	forvalues i=1/`n' {
	setx [`i']
	setx infantry 0 artillery 0 communications 1 engineering 0
	setx
	simqi, ev genev(ec_com_`i')
	}
	
	*Expected counts if branch is "ENGINEERING"
	forvalues i=1/`n' {
	setx [`i']
	setx infantry 0 artillery 0 communications 0 engineering 1
	setx
	simqi, ev genev(ec_eng_`i')
	}


********************************************
*Calculating average expected counts for different branches
********************************************	
	
	*First difference for each branch vs. CAVALRY
	forvalues i=1/`n' {
	gen fd_inf_`i'=ec_inf_`i' - ec_cav_`i'
	gen fd_art_`i'=ec_art_`i' - ec_cav_`i'
	gen fd_com_`i'=ec_com_`i' - ec_cav_`i'
	gen fd_eng_`i'=ec_eng_`i' - ec_cav_`i'
	}
	
	*Averaging across single officers
	egen mean_fd_inf=rowmean(fd_inf_*)
	egen mean_fd_art=rowmean(fd_art_*)
	egen mean_fd_com=rowmean(fd_com_*)
	egen mean_fd_eng=rowmean(fd_eng_*)
	
	*Calculating ATEs and CIs
	keep mean_fd_inf mean_fd_art mean_fd_com mean_fd_eng
	
	foreach var of varlist mean_fd_inf mean_fd_art mean_fd_com mean_fd_eng {
	local new = substr("`var'", -3,.)
    rename `var' `new'
	}
	
	ds
	foreach var of varlist `r(varlist)' {
	quietly sum `var'
	gen mean_`var'=r(mean) in 1
	quietly _pctile `var', p(2.5,5.0,95.0,97.5)
	gen p25_`var'=r(r1) in 1
	gen p50_`var'=r(r2) in 1
	gen p95_`var'=r(r3) in 1
	gen p975_`var'=r(r4) in 1
	}
		
	*Reshaping data
	keep mean* p25* p50* p95* p975*
	keep in 1
	gen id=1
	reshape long mean@ p25@ p50@ p95@ p975@, i(id) string	 

	*Generating jackknife variable
	gen dropsubzone="`sz'"
	
	*Saving jackknife results for respective (excluded) subzone
	save "jackknifeATE_sz_`sz'.dta", replace
	
	}
	
********************************************
*Preparing jackknife datasets for plotting
********************************************		
	
	*Appending datasets with simulated results 
	clear
	use "jackknifeATE_sz_4.dta", clear
	local subzones="11 12 13 14 15 21 22 23 24 31 32 33 51 52 53 CF"
	foreach sz of local subzones {
	append using "jackknifeATE_sz_`sz'.dta"
	}	
	
	*Generating variable that identifies subzones on y-axis
	egen yaxis=group(dropsubzone)
	replace yaxis=yaxis+1
	replace yaxis=1 if dropsubzone=="CF"
	replace yaxis=(18-yaxis)*2 													
	
	*Labelling yaxis
	labmask yaxis, values(dropsubzone)
	
	*Extracting expected values foreach each army branch
	gen branchhelp=regexs(0) if regexm(_j, "[a-z]+$")
	gen branch=1 if branchhelp=="inf"
	replace branch=2 if branchhelp=="art"	
	replace branch=3 if branchhelp=="com"		
	replace branch=4 if branchhelp=="eng"
		
	*Labeling branches	
	label define branches 1 "Infantry" 2 "Artillery" 3 "Communications" 4 "Engineering"
	label val branch branches	
	
	
********************************************
*FIGURE A.15
********************************************		
	#delimit ;		
	twoway rspike p25 p975 yaxis,
                 horizontal lcolor(gs5) lwidth(thin)
	  || rspike p5 p95 yaxis,
                 horizontal lcolor(black) lwidth(thick)
	  || scatter yaxis mean,		  
				 msymbol(o) msize(*1.2) mcolor(black) mfcolor(white) mlalign(outside)
				 by(branch, rows(1) note("") graphregion(color(white)) legend(off)) 
				 xsize(2) ysize(1) 
				 xscale(range(-50 300) noline)
				 yscale(range(1 35) noline titlegap(*-25))
 	             ylabel(2(2)34, valuelabel nogrid angle(0)) 
				 xlabel(0(100)300, angle(horizontal) nogrid)
				 xticks(-50(50)300)
				 xline(0,lpattern(shortdash) lcolor(black) lwidth(medthin))
				 subtitle(, size(*1) lcolor(black))
				 ytitle("Subzones", size(*1))
				 scheme(s2mono) plotregion(lcolor(black)); 
	#delimit cr		
	graph export "$figurepath\figureA15.pdf", replace as(pdf) 

capture graph close 
clear
