
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
* Do-File: maineffect.do
************************************
************************************


*Loading data
use "$datapath\repdata.dta", clear


************************************
*Calculating ATE over officers
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

*Keeping only observations in model
gen keep=1 if e(sample)
drop if keep!=1

*Sampling cofficients form Model 3
set seed 84139627
	#delimit ;
	estsimp nbreg nvictims
		 infantry artillery communications engineering 
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 planrepprop samegarr armmatprop
		 if army==1, cluster(area);
	#delimit cr
	
	*Checking if sampling is similar to previous results
	sum b1-b16
	
*Number of observations for which substantive effects are calculated 
count if keep==1
local n=r(N)	
	
	
********************************************
*Simulating expected counts for different branches across all officers
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
	
	*Creating yaxis
	gen branch=regexs(0) if regexm(_j, "[a-z]+$")
	gen yaxis=1 if branch=="eng"
	replace yaxis=2 if branch=="com"
	replace yaxis=3 if branch=="art"
	replace yaxis=4 if branch=="inf"
	sort yaxis
	
	
********************************************
*Plotting QoI - ATE over each officer
********************************************	
	
*Dot-Line plot
#delimit ;		
twoway rspike p25 p975 yaxis, //95% CI
                 horizontal lcolor(gs5) lwidth(thin)
	  || rspike p5 p95 yaxis, //90% CI
                 horizontal lcolor(black) lwidth(thick)
	  || scatter yaxis mean,				  
				 msymbol(o) msize(*1.2) mcolor(black) mfcolor(white) mlalign(outside)
				 yscale(range(0.5 4.5) noline)
				 xscale(range(-10 140) noline titlegap(*+10)) 
				 ysize(1) xsize(1.25)
				 ylabel(1 "Engineering" 2 "Communications" 3 "Artillery" 4 "Infantry", nogrid labsize(small) angle(0))
				 xlabel(-20(10)140, labsize(small)) 
				 ytitle("")
				 xtitle("Change in expected number of victims", size(small))
				 legend(off)
				 xline(0,lpattern(shortdash) lwidth(thin) lcolor(black))
				 scheme(s2mono) plotregion(lcolor(black)) graphregion(fcolor(white) ilcolor(white) lcolor(white)); 
#delimit cr	
graph export "$figurepath\figure7.pdf", as(pdf) replace	

capture graph close 
clear

