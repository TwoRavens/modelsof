/* Analysis.do implements the statistical estimation for the DK Asset Integration Paper */

* set globals
	* Scale all monetary amounts
	global scale 		"10000" 
	* Set the models to contextual
	global contextual 	"y"
	* Set constant on the omega level to help it converge (still bounded omega>0)
	global high 	  	"0.1"	

*******************************
* Individual estimation on CRRA
********************************

* BASIC ANALYSIS OF THE RISK DATA
capture log close _all
log using ToMove/individual.log, replace text 
set more off
global doPAI "y"
global doPAIRDU "y"
global doINDIVIDUAL_A "y"
global doINDIVIDUAL_C "y"
global doINDIVIDUAL_C2 "y"
global doINDIVIDUAL_SUM "y"
global doINDIVIDUAL_FIG "y"

use Data, replace

* Global level for classify
global sigLL 0.05 

* get a sequential ID
sort pnr
egen int sid=group(pnr)
 
* get records
capture drop record
bysort sid: egen int record=seq()

* generage age2
generate age2 = age*age

* Set counter
generate int counter = _n
generate ll = 0

* save data for restarts
save TempData/tmpI, replace

* retain characteristics
keep if record==1
generate net_estates 	= assets_realesta - liab_mortgage
generate net_deposits 	= assets_banks - liab_bankdebt
generate net_financial 	= assets_stocks + assets_bond	 - liab_private 
generate net_pension 	= assets_pension 
generate net_cars 		= assets_cars 
generate net_income 	= income
generate net_income2 	=income*income
keep sid $demog
sort sid
save TempData/sample_characteristics, replace

* PAI-EUT for individuals
if "$doPAI" == "y" {
log using ToMove/PAIind.log, replace name(risk_EUTind)
set seed 1001

* get data for a restart
use TempData/tmpI, clear

* pick out one record per subject
capture: drop record
bysort sid: egen int record=seq()
capture: drop sid
egen int sid=group(pnr)
tab sid

* pooled estimate PAI - CRRA
qui tab choice if sid==1
global nLL = r(N)
matrix start_1 = 0.8, -2, -1.5, -2.5
ml model lf ML_crra_PAI (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T = ) (LNmu: ) (LNrho: ) (LNomega: ) , cluster(pnr) missing maximize technique(nr) difficult init(start_1, copy)  tolerance(0.01) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance trace
local r = [r]_cons
local LNmu = [LNmu]_cons
local LNrho = [LNrho]_cons
local LNomega = [LNomega]_cons
* extractLL

* save individual estimates
generate r_pai_pe=.
generate r_pai_se=.
generate r_pai_p=.
generate r_pai_low=.
generate r_pai_hi=.

generate LNrho_pai_pe=.
generate LNrho_pai_se=.
generate LNrho_pai_p=.
generate LNrho_pai_low=.
generate LNrho_pai_hi=.

generate LNomega_pai_pe=.
generate LNomega_pai_se=.
generate LNomega_pai_p=.
generate LNomega_pai_low=.
generate LNomega_pai_hi=.

forvalues i=1/4 {
	forvalues j=1/4 {
		generate pai_v`i'`j'=.
	}
}

generate pai_converged=.
generate pai_iter=.
generate pai_ll=.
generate pai_rn=.
generate pai_nai = . 
generate pai_naiW = . 
generate pai_fai = .
generate pai_const=.
		
* estimate for individuals (using the sequential id generated above)
sort sid
qui forvalues s=1/454 {
    noi di "Estimating PAI model for subject #`s'..."
	qui tab choice if sid==`s'
	global nLL = r(N)
	est clear
	
	qui capture: ml model lf ML_crra_PAI (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T = ) (LNmu: ) (LNrho: ) (LNomega: ) if sid==`s' , missing maximize technique(nr) difficult init(`r' `LNmu' `LNrho' `LNomega', copy)  tolerance(0.01) ltolerance(0.01) nrtolerance(0.01) iterate(30)
	 
    * flag if not converged, then if converged save the results
    if _rc ~= 0 | e(ic) == 30 {
		local constV = log(1/10)
		matrix start_1 = `r', `LNmu' , `constV', `LNomega'
		constraint define 1 [LNrho]_cons = `constV'

		qui capture: ml model lf ML_crra_PAI (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T = ) (LNmu: ) (LNrho: ) (LNomega: ) if sid==`s' , missing maximize technique(nr) difficult init(start_1, copy)  tolerance(0.01) ltolerance(0.01) nrtolerance(0.01) iterate(30) const(1)
	 	* flag if not converged, then if converged save the results
		if _rc ~= 0 | e(ic) == 30 {
			qui replace pai_converged = 0 if sid==`s'
			noi di "   >> PAI model could not solve for subject #`s'"
		}
		else {

			qui {

				capture {
					* recovering the covariance matrix
					matrix cov = e(V)
					matrix list cov
					forvalues i=1/4 {
						forvalues j=1/4 {
							local v`i'`j' = cov[`i',`j']
							replace pai_v`i'`j' = `v`i'`j'' if sid==`s'
						}
					}
					capture {
						predictnl r_pe = xb(r), se(r_se) p(r_p) ci(r_low r_hi)
					}
					foreach v in pe se p low hi {
						replace r_pai_`v' = r_`v' if sid==`s'
						drop r_`v'
					}
					
					capture {
						predictnl LNomega_pe = xb(LNomega), se(LNomega_se) p(LNomega_p) ci(LNomega_low LNomega_hi)
					}
					foreach v in pe se p low hi {
						replace LNomega_pai_`v' = LNomega_`v' if sid==`s'
						drop LNomega_`v'
					}

					capture {
						predictnl LNrho_pe = xb(LNrho), se(LNrho_se) p(LNrho_p) ci(LNrho_low LNrho_hi)
					}
					foreach v in pe se p low hi {
						replace LNrho_pai_`v' = LNrho_`v' if sid==`s'
						drop LNrho_`v'
					}				

					test [r]_cons = 1
					replace pai_rn = r(p) if sid==`s'

					testnl $high * exp([LNomega]_cons) =0
					replace pai_nai = r(p) if sid==`s'
					
					summ  wealth_T if sid==`s'
					local wealthTest = r(mean)					
					testnl `wealthTest' * $high * exp([LNomega]_cons) =0					
					replace paiW_nai = r(p) if sid==`s'
					
					testnl exp([LNomega]_cons) == 1
					replace pai_fai = r(p) if sid==`s'

					replace pai_converged = e(converged) if sid==`s'
					replace pai_iter = e(ic) if sid==`s'
					
					replace pai_const=1  if sid==`s'
					
					* Now save the specific likelihood values											
					local nLL = $nLL
					qui extractLL
					summ counter if sid==`s' & record==1
					local start = r(mean)
					qui {
						forvalues x=1/`nLL' {
							local xx = `start' - 1 + `x'
							summ ll_extract if _n == `x'
							replace pai_ll = r(mean) if _n ==`xx'
							global ll_`x' = .
						}
					}									
					drop ll_extract										
				}		
			}		
		}	
    }
    else {

        qui {

            capture {
				* recovering the covariance matrix
				matrix cov = e(V)
				matrix list cov
				forvalues i=1/4 {
					forvalues j=1/4 {
						local v`i'`j' = cov[`i',`j']
						replace pai_v`i'`j' = `v`i'`j'' if sid==`s'
					}
				}
				capture {
					predictnl r_pe = xb(r), se(r_se) p(r_p) ci(r_low r_hi)
				}
				foreach v in pe se p low hi {
					replace r_pai_`v' = r_`v' if sid==`s'
					drop r_`v'
				}
				
				capture {
					predictnl LNomega_pe = xb(LNomega), se(LNomega_se) p(LNomega_p) ci(LNomega_low LNomega_hi)
				}
				foreach v in pe se p low hi {
					replace LNomega_pai_`v' = LNomega_`v' if sid==`s'
					drop LNomega_`v'
				}

				capture {
					predictnl LNrho_pe = xb(LNrho), se(LNrho_se) p(LNrho_p) ci(LNrho_low LNrho_hi)
				}
				foreach v in pe se p low hi {
					replace LNrho_pai_`v' = LNrho_`v' if sid==`s'
					drop LNrho_`v'
				}				

				test [r]_cons = 1
				replace pai_rn = r(p) if sid==`s'

				testnl $high * exp([LNomega]_cons) =0
				replace pai_nai = r(p) if sid==`s'
				
				summ  wealth_T if sid==`s'
				local wealthTest = r(mean)					
				testnl `wealthTest' * $high * exp([LNomega]_cons) =0					
				replace paiW_nai = r(p) if sid==`s'
									
				testnl exp([LNomega]_cons) == 1
				replace pai_fai = r(p) if sid==`s'

				replace pai_converged = e(converged) if sid==`s'
				replace pai_iter = e(ic) if sid==`s'
				
				replace pai_const=0  if sid==`s'
				
				* Now save the specific likelihood values											
				local nLL = $nLL
				qui extractLL
				summ counter if sid==`s' & record==1
				local start = r(mean)
				qui {
					forvalues x=1/`nLL' {
						local xx = `start' - 1 + `x'
						summ ll_extract if _n == `x'
						replace pai_ll = r(mean) if _n ==`xx'
						global ll_`x' = .
					}
				}									
				drop ll_extract										
			}		
        }		
    }
}


* see convergence
tab pai_converged if record==1
tab pai_iter if pai_converged==1 & record==1

* save the individual estimates
keep if record==1
keep sid pnr pai_* r_pai_* *pai*
sort sid
save TempData/pai_crra_estimates, replace

log close risk_EUTind
* end of EUT for individuals

}

* PAI-RDU for individuals
if "$doPAIRDU" == "y" {
capture log close _all
log using ToMove/PAIRDUind.log, replace name(risk_EUTind)
set more off
set seed 1001

* get data for a restart
use TempData/tmpI, clear

* pick out one record per subject
capture: drop record
bysort sid: egen int record=seq()
capture: drop sid
egen int sid=group(pnr)
tab sid

* pooled estimate PAI - CRRA - RDEU with Prelect weighting
qui tab choice if sid==1
global nLL = r(N)
local constV = log(1/10)
matrix start_1 = 0.8, 0, -2, `constV', -2.5
constraint define 1 [LNrho]_cons = `constV'
* PARTIAL ASSET INTEGRATION ON CONSTRAINED 1-COEF PRELEC  - CONSTRAINED
ml model lf ML_crra_PAI_P1 (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T  =)  (LNphi: )  (LNmu: ) (LNrho: ) (LNomega: ), cluster(pnr) missing maximize technique(nr) difficult init(start_1, copy) tolerance(0.1) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance trace search(off)	 const(1 2) 
* let go of phi
ml model lf ML_crra_PAI_P1 (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T  =)  (LNphi: )  (LNmu: ) (LNrho: ) (LNomega: ), cluster(pnr) missing maximize technique(nr) difficult continue tolerance(0.1) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance trace search(off) const(1)	 
* PARTIAL ASSET INTEGRATION ON UNCONSTRAINED 2-COEF PRELEC  - CONSTRAINED
ml model lf ML_crra_PAI_P (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T  =)   (LNphi: )  (LNeta: )  (LNmu: ) (LNrho: ) (LNomega: ), cluster(pnr) missing maximize technique(nr) difficult continue tolerance(0.1) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance trace search(off)	const(1)
local r = [r]_cons
local LNphi = [LNphi]_cons
local LNeta = [LNeta]_cons
local LNmu = [LNmu]_cons
local LNrho = [LNrho]_cons
local LNomega = [LNomega]_cons
extractLL

* save individual estimates
generate r_pair_pe=.
generate r_pair_se=.
generate r_pair_p=.
generate r_pair_low=.
generate r_pair_hi=.

generate LNphi_pair_pe=.
generate LNphi_pair_se=.
generate LNphi_pair_p=.
generate LNphi_pair_low=.
generate LNphi_pair_hi=.

generate LNeta_pair_pe=.
generate LNeta_pair_se=.
generate LNeta_pair_p=.
generate LNeta_pair_low=.
generate LNeta_pair_hi=.

generate LNrho_pair_pe=.
generate LNrho_pair_se=.
generate LNrho_pair_p=.
generate LNrho_pair_low=.
generate LNrho_pair_hi=.

generate LNomega_pair_pe=.
generate LNomega_pair_se=.
generate LNomega_pair_p=.
generate LNomega_pair_low=.
generate LNomega_pair_hi=.


forvalues i=1/6 {
	forvalues j=1/6 {
		generate pair_v`i'`j'=.
	}
}

generate pair_converged=.
generate pair_const=.
generate pair_iter=.
generate pair_ll=.
generate pair_rn=.
generate pair_eut = .

generate pair_nai = . 
generate pairW_nai = . 
generate pair_fai = .

* estimate for individuals (using the sequential id generated above)
sort sid
forvalues s=1/454 {
    
	di "Estimating PAI RDEU model for subject #`s'..."
	qui tab choice if sid==`s'
	global nLL = r(N)
	est clear
	qui capture: ml model lf ML_crra_PAI_P (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T = ) (LNphi:) (LNeta:)  (LNmu: ) (LNrho: ) (LNomega: ) if sid==`s' , missing maximize technique(nr) difficult init(`r' `LNphi' `LNeta' `LNmu'  `LNrho' `LNomega', copy)  tolerance(0.001) ltolerance(0.001) nrtolerance(0.001) iterate(30)
	   
    * flag if not converged, then if converged save the results
    if _rc ~= 0 | e(ic) == 30 {
		qui capture: ml model lf ML_crra_PAI_P (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T = ) (LNphi:) (LNeta:)  (LNmu: ) (LNrho: ) (LNomega: ) if sid==`s' , missing maximize technique(nr) difficult init(.4795111  -.1701061   .1160446  -2.344359  -2, copy)  tolerance(0.001) ltolerance(0.001) nrtolerance(0.001) iterate(30)
			if _rc ~= 0 | e(ic) == 30 {	
					local constV = log(1/10)
					matrix start_1 = 0.5, -0.1, 0, 2, `constV', -2
					constraint define 1 [LNrho]_cons = `constV'
					qui capture: ml model lf ML_crra_PAI_P (r: choice probA1 probA2 probA3 probA4 probB1 probB2 probB3 probB4 VPRIZEA1 VPRIZEA2 VPRIZEA3 VPRIZEA4 VPRIZEB1 VPRIZEB2 VPRIZEB3 VPRIZEB4 wealth_T  =)   (LNphi: )  (LNeta: )  (LNmu: ) (LNrho: ) (LNomega: )  if sid==`s', missing maximize technique(nr) difficult init(start_1, copy)  tolerance(0.1) ltolerance(0.01) nrtolerance(0.01)  showtolerance shownrtolerance trace search(off) iter(30) const(1)				
					if _rc ~= 0 | e(ic) == 30 {	
						qui replace pair_converged = 0 if sid==`s'
						di "   >> PAI RDU model could not solve for subject #`s'"	
						
					}
					else noi {
						noi {
						
							capture {
							* recovering the covariance matrix
							matrix cov = e(V)
							matrix list cov
							forvalues i=1/6 {
								forvalues j=1/6 {
									local v`i'`j' = cov[`i',`j']
									replace pair_v`i'`j' = `v`i'`j'' if sid==`s'
								}
							}
							capture {
								predictnl r_pe = xb(r), se(r_se) p(r_p) ci(r_low r_hi)
							}
							foreach v in pe se p low hi {
								replace r_pair_`v' = r_`v' if sid==`s'
								drop r_`v'
							}
							capture {
								predictnl LNphi_pe = xb(LNphi), se(LNphi_se) p(LNphi_p) ci(LNphi_low LNphi_hi)
							}
							foreach v in pe se p low hi {
								replace LNphi_pair_`v' = LNphi_`v' if sid==`s'
								drop LNphi_`v'
							}
							capture {
								predictnl LNeta_pe = xb(LNeta), se(LNeta_se) p(LNeta_p) ci(LNeta_low LNeta_hi)
							}
							foreach v in pe se p low hi {
								replace LNeta_pair_`v' = LNeta_`v' if sid==`s'
								drop LNeta_`v'
							}
								
							capture {
								predictnl LNomega_pe = xb(LNomega), se(LNomega_se) p(LNomega_p) ci(LNomega_low LNomega_hi)
							}
							foreach v in pe se p low hi {
								replace LNomega_pair_`v' = LNomega_`v' if sid==`s'
								drop LNomega_`v'
							}

							capture {
								predictnl LNrho_pe = xb(LNrho), se(LNrho_se) p(LNrho_p) ci(LNrho_low LNrho_hi)
							}
							foreach v in pe se p low hi {
								replace LNrho_pair_`v' = LNrho_`v' if sid==`s'
								drop LNrho_`v'
							}
						
							test [r]_cons = 1
							replace pair_rn = r(p) if sid==`s'

							testnl $high * exp([LNomega]_cons) =0
							replace pair_nai = r(p) if sid==`s'
							
							summ  wealth_T if sid==`s'
							local wealthTest = r(mean)					
							testnl `wealthTest' * $high * exp([LNomega]_cons) =0					
							replace pairW_nai = r(p) if sid==`s'
							
							testnl exp([LNomega]_cons) == 1
							replace pair_fai = r(p) if sid==`s'
							
							testnl (exp([LNphi]_cons = 1)) ((exp([LNeta]_cons) = 1))				
							replace pair_eut = r(p) if sid==`s'

							test [r]_cons = 1
							replace pair_rn = r(p) if sid==`s'

							replace pair_converged = e(converged) if sid==`s'
							replace pair_iter = e(ic) if sid==`s'
							
							replace pair_const=1  if sid==`s'
							
							* Now save the specific likelihood values											
							local nLL = $nLL
							qui extractLL
							summ counter if sid==`s' & record==1
							local start = r(mean)
							qui {
								forvalues x=1/`nLL' {
									local xx = `start' - 1 + `x'
									summ ll_extract if _n == `x'
									replace pair_ll = r(mean) if _n ==`xx'
									global ll_`x' = .
								}
							}									
							drop ll_extract										
						}		
					}		
			}
		}
		else noi {
			noi {
				capture {
					* recovering the covariance matrix
					matrix cov = e(V)
					matrix list cov
					forvalues i=1/6 {
						forvalues j=1/6 {
							local v`i'`j' = cov[`i',`j']
							replace pair_v`i'`j' = `v`i'`j'' if sid==`s'
						}
					}
				}	
				capture {
					predictnl r_pe = xb(r), se(r_se) p(r_p) ci(r_low r_hi)
				}
				foreach v in pe se p low hi {
					replace r_pair_`v' = r_`v' if sid==`s'
					drop r_`v'
				}
				capture {
					predictnl LNphi_pe = xb(LNphi), se(LNphi_se) p(LNphi_p) ci(LNphi_low LNphi_hi)
				}
				foreach v in pe se p low hi {
					replace LNphi_pair_`v' = LNphi_`v' if sid==`s'
					drop LNphi_`v'
				}
				capture {
					predictnl LNeta_pe = xb(LNeta), se(LNeta_se) p(LNeta_p) ci(LNeta_low LNeta_hi)
				}
				foreach v in pe se p low hi {
					replace LNeta_pair_`v' = LNeta_`v' if sid==`s'
					drop LNeta_`v'
				}
					
				capture {
					predictnl LNomega_pe = xb(LNomega), se(LNomega_se) p(LNomega_p) ci(LNomega_low LNomega_hi)
				}
				foreach v in pe se p low hi {
					replace LNomega_pair_`v' = LNomega_`v' if sid==`s'
					drop LNomega_`v'
				}

				capture {
					predictnl LNrho_pe = xb(LNrho), se(LNrho_se) p(LNrho_p) ci(LNrho_low LNrho_hi)
				}
				foreach v in pe se p low hi {
					replace LNrho_pair_`v' = LNrho_`v' if sid==`s'
					drop LNrho_`v'
				}
			
				test [r]_cons = 1
				replace pair_rn = r(p) if sid==`s'

				testnl $high * exp([LNomega]_cons) =0
				replace pair_nai = r(p) if sid==`s'
				
				summ  wealth_T if sid==`s'
				local wealthTest = r(mean)					
				testnl `wealthTest' * $high * exp([LNomega]_cons) =0					
				replace pairW_nai = r(p) if sid==`s'
							
				testnl exp([LNomega]_cons) == 1
				replace pair_fai = r(p) if sid==`s'
				
				testnl (exp([LNphi]_cons = 1)) ((exp([LNeta]_cons) = 1))				
				replace pair_eut = r(p) if sid==`s'

				test [r]_cons = 1
				replace pair_rn = r(p) if sid==`s'

				replace pair_converged = e(converged) if sid==`s'
				replace pair_iter = e(ic) if sid==`s'
				
				replace pair_const=0  if sid==`s'
				
				* Now save the specific likelihood values											
				local nLL = $nLL
				qui extractLL
				summ counter if sid==`s' & record==1
				local start = r(mean)
				qui {
					forvalues x=1/`nLL' {
						local xx = `start' - 1 + `x'
						summ ll_extract if _n == `x'
						replace pair_ll = r(mean) if _n ==`xx'
						global ll_`x' = .
					}
				}									
				drop ll_extract										
			}		
        }		
	}
	else noi {
        noi {
            capture {
				* recovering the covariance matrix
				matrix cov = e(V)
				matrix list cov
				forvalues i=1/6 {
					forvalues j=1/6 {
						local v`i'`j' = cov[`i',`j']
						replace pair_v`i'`j' = `v`i'`j'' if sid==`s'
					}
				}
				capture {
					predictnl r_pe = xb(r), se(r_se) p(r_p) ci(r_low r_hi)
				}
				foreach v in pe se p low hi {
					replace r_pair_`v' = r_`v' if sid==`s'
					drop r_`v'
				}
				capture {
					predictnl LNphi_pe = xb(LNphi), se(LNphi_se) p(LNphi_p) ci(LNphi_low LNphi_hi)
				}
				foreach v in pe se p low hi {
					replace LNphi_pair_`v' = LNphi_`v' if sid==`s'
					drop LNphi_`v'
				}
				capture {
					predictnl LNeta_pe = xb(LNeta), se(LNeta_se) p(LNeta_p) ci(LNeta_low LNeta_hi)
				}
				foreach v in pe se p low hi {
					replace LNeta_pair_`v' = LNeta_`v' if sid==`s'
					drop LNeta_`v'
				}
					
				capture {
					predictnl LNomega_pe = xb(LNomega), se(LNomega_se) p(LNomega_p) ci(LNomega_low LNomega_hi)
				}
				foreach v in pe se p low hi {
					replace LNomega_pair_`v' = LNomega_`v' if sid==`s'
					drop LNomega_`v'
				}

				capture {
					predictnl LNrho_pe = xb(LNrho), se(LNrho_se) p(LNrho_p) ci(LNrho_low LNrho_hi)
				}
				foreach v in pe se p low hi {
					replace LNrho_pair_`v' = LNrho_`v' if sid==`s'
					drop LNrho_`v'
				}
			
				test [r]_cons = 1
				replace pair_rn = r(p) if sid==`s'

				testnl $high * exp([LNomega]_cons) =0
				replace pair_nai = r(p) if sid==`s'
				
				testnl exp([LNomega]_cons) == 1
				replace pair_fai = r(p) if sid==`s'
				
				testnl (exp([LNphi]_cons = 1)) ((exp([LNeta]_cons) = 1))				
				replace pair_eut = r(p) if sid==`s'

				test [r]_cons = 1
				replace pair_rn = r(p) if sid==`s'

				replace pair_converged = e(converged) if sid==`s'
				replace pair_iter = e(ic) if sid==`s'
				replace pair_const=0  if sid==`s'
				
				* Now save the specific likelihood values											
				local nLL = $nLL
				qui extractLL
				summ counter if sid==`s' & record==1
				local start = r(mean)
				qui {
					forvalues x=1/`nLL' {
						local xx = `start' - 1 + `x'
						summ ll_extract if _n == `x'
						replace pair_ll = r(mean) if _n ==`xx'
						global ll_`x' = .
					}
				}									
				drop ll_extract										
			}		
        }		
    }
}

* see convergence
tab pair_converged if record==1
tab pair_iter if pair_converged==1 & record==1

* save the individual estimates
keep if record==1
keep sid pnr pair_* r_pair_* *pair*
sort sid
save TempData/pair_crra_estimates, replace

log close risk_EUTind
* end of EUT for individuals

}

* Collate estimates
use TempData/tmpI, clear
keep if record==1
sort sid
capture: drop _merge
merge 1:1 sid using TempData/pai_crra_estimates
drop _merge
merge 1:1 sid using TempData/pair_crra_estimates

* add in characteristics
drop _merge
merge 1:1 sid using TempData/sample_characteristics
drop _merge

* Now do quick tabulations of the 
save TempData/estimates, replace

* collate estimates of EUT and RDU
if "$doINDIVIDUAL_A" == "y" {
log using ToMove/IndividualPAI_EUT-RDU.log, replace name(log1)

***************************
* Now do aggregae tabulations with PAI_EUT estimates
*****************************
use TempData/estimates, replace

* Do binning of omega
	generate omega = $high * exp(LNomega_pai_pe)
	generate omegaB = ""
	replace omegaB = "1. <0.001"  if 				  omega<=0.001 & omega~=.
	replace omegaB = "2. <0.05"  if omega>0.001 	& omega<=0.05
	replace omegaB = "3. <0.30"  if omega>0.05  	& omega<=0.30
	replace omegaB = "4. >0.30"  if omega>0.30  	& omega~=.
	replace omegaB = "5. MI"   if omega==.

* Now bin R
	generate 	r = r_pai_pe
	generate rB = ""
	replace rB = "1. <0"  		if r<0 		& r~=.
	replace rB = "2. 0.5"  		if r>=0 	&    r<0.5
	replace rB = "3. 1"    		if r>=0.5 	&    r<1
	replace rB = "4. >1"     	if r>=1	  	& r~=.
	replace rB = "5. MI"   		if r==.
	
tab omegaB , missing
tab rB, missing 

tab omegaB rB, missing

* Preprae omegaB rB
	egen groupV = group(omegaB rB)
	summ groupV
	local startN = 1
	local endN = r(max)
	qui forvalues x = `startN'(1)`endN' {
		display "looking at group `x'"
		count if group ==`x'	
		if r(N) < 4 & r(N) > 0 & r(N)~=. {
			capture drop seqN
			egen seqN = seq(), by(group)
			drop if seqN > 1 & group==`x'
			expand 999 if group ==`x'
			drop seqN
		}	
	}


* Tabulate with missing (999)
tab omegaB rB, missing 

* Tabulate without missing
egen Out = count(groupV), by(groupV)
drop if Out==999
tab omegaB rB, missing 

* Now do the same with the omega* wealth
	use TempData/estimates, replace
	generate omegaW = $high * exp(LNomega_pai_pe) * wealth_net
	generate omegaWB = ""
	replace omegaWB = "1. 10"     if 			  omegaW<=10 & omegaW~=.
	replace omegaWB = "2. 1000"   if omegaW>10 	& omegaW<=1000
	replace omegaWB = "3. 100000"  if omegaW>1000 	& omegaW<=100000
	replace omegaWB = "4. >100000" if omegaW>100000   	& omegaW~=.
	replace omegaWB = "5. MI"    if omegaW==.

	* Now bin R
	generate 	r = r_pai_pe
	generate rB= ""
	replace rB = "1. <0"  		if r<0 		& r~=.
	replace rB = "2. 0.5"  		if r>=0 	&    r<0.5
	replace rB = "3. 1"    		if r>=0.5 	&    r<1
	replace rB = "4. >1"     	if r>=1	  	& r~=.
	replace rB = "5. MI"   		if r==.

* Tabulations
tab omegaWB, missing
tab rB, missing 

* Prepare omegaB rBfor cross tabulations
	egen groupV = group(rB omegaWB)
	summ groupV
	local startN = 1
	local endN = r(max)
	qui forvalues x = `startN'(1)`endN' {
		display "looking at group `x'"
		count if group ==`x'	
		if r(N) < 4 & r(N) > 0 & r(N)~=. {
			capture drop seqN
			egen seqN = seq(), by(group)
			drop if seqN > 1 & group==`x'
			expand 999 if group ==`x'
			drop seqN
		}	
	}

* Tabulate with missing (999)
tab omegaWB rB, missing 

* Tabulate without missing
egen Out = count(groupV), by(groupV)
drop if Out==999
tab omegaWB rB , missing

* Aggerate tests of EUT
use TempData/estimates, replace

* Now tabulate the p-values at the 10% floor level
generate below10 = (pai_nai<0.1)
replace below10 = . if pai_nai==.
tab below10, missing

* Now tabulate the p-values at the 5% floor level
generate below5 = (pai_nai<0.05)
replace below5 = . if pai_nai==.
tab below5, missing

* Now tabulate the p-values at the 1% floor level
generate below1 = (pai_nai<0.01)
replace below1 = . if pai_nai==.
tab below1, missing

***************************
* Now do the same with PAI-RDU estimates
*****************************
* Now do simple tabulations of individual estimations
use TempData/estimates, replace

* Do binning of omega
	generate omega = $high * exp(LNomega_pair_pe)
	generate omegaB = ""
	replace omegaB = "1. <0.001"  if 				  omega<=0.001 	& omega~=.
	replace omegaB = "2. <0.05"  if omega>0.001 	& omega<=0.05
	replace omegaB = "3. <0.30"  if omega>0.05  	& omega<=0.30
	replace omegaB = "4. >0.30"  if omega>0.30  	& omega~=.
	replace omegaB = "5. MI"   if omega==.

	* Now bin R
	generate 	r = r_pair_pe
	generate rB = ""	
	replace rB = "1. <0"  		if r<0 		& r~=.
	replace rB = "2. 0.5"  		if r>=0 	& r<0.5
	replace rB = "3. 1"    		if r>=0.5 	& r<1
	replace rB = "4. >1"     	if r>=1	  	& r~=.
	replace rB = "5. MI"   		if r==.
	
* Tabulations
	tab omegaB, missing
	tab rB, missing

	* Preprae omegaB rB
	egen groupV = group(omegaB rB)
	summ groupV
	local startN = 1
	local endN = r(max)
	qui forvalues x = `startN'(1)`endN' {
		display "looking at group `x'"
		count if group ==`x'	
		if r(N) < 4 & r(N) > 0 & r(N)~=. {
			capture drop seqN
			egen seqN = seq(), by(group)
			drop if seqN > 1 & group==`x'
			expand 999 if group ==`x'
			drop seqN
		}	
	}

* Tabulate with missing (999)
	tab rB omegaB, missing  

* Tabulate without missing
	egen Out = count(groupV), by(groupV)
	drop if Out==999
	tab rB omegaB, missing

* Now do the same with the omega* wealth
	use TempData/estimates, replace

	generate omegaW = $high * exp(LNomega_pair_pe) * wealth_net
	generate omegaWB = ""
	replace omegaWB = "1. 10"     if 			  omegaW<=10 & omegaW~=.
	replace omegaWB = "2. 1000"   if omegaW>10 	& omegaW<=1000
	replace omegaWB = "3. 100000"  if omegaW>1000 	& omegaW<=100000
	replace omegaWB = "4. >100000" if omegaW>100000   	& omegaW~=.
	replace omegaWB = "5. MI"    if omegaW==.

	* Now bin R
	generate 	r = r_pair_pe
	generate rB = ""	
	replace rB = "1. <0"  		if r<0 		& r~=.
	replace rB = "2. 0.5"  		if r>=0 	&    r<0.5
	replace rB = "3. 1"    		if r>=0.5 	&    r<1
	replace rB = "4. >1"     	if r>=1	  	& r~=.
	replace rB = "5. MI"   		if r==.

* Tabulations
	tab omegaWB, missing
	tab rB, missing 

	* Prepare omegaB rBfor cross tabulations
	egen groupV = group(rB omegaWB)
	summ groupV
	local startN = 1
	local endN = r(max)
	qui forvalues x = `startN'(1)`endN' {
		display "looking at group `x'"
		count if group ==`x'	
		if r(N) < 4 & r(N) > 0 & r(N)~=. {
			capture drop seqN
			egen seqN = seq(), by(group)
			drop if seqN > 1 & group==`x'
			expand 999 if group ==`x'
			drop seqN
		}	
	}

* Tabulate with missing (999)
tab omegaWB rB, missing

* Tabulate without missing
egen Out = count(groupV), by(groupV)
drop if Out==999
tab omegaWB rB, missing

* RDEU Tests of NAI
use TempData/estimates, replace
* Now tabulate the p-values at the 10% floor level
generate below10r = (pair_nai<0.1)
replace below10r = . if pair_nai==.
tab below10r, missing

* Now tabulate the p-values at the 5% floor level
generate below5r = (pair_nai<0.05)
replace below5r = . if pair_nai==.
tab below5r, missing

* Now tabulate the p-values at the 1% floor level
generate below1r = (pair_nai<0.01)
replace below1r = . if pair_nai==.
tab below1r, missing

* RDEU Tests of EUT
* Now tabulate the p-values at the 10% floor level
generate below10r_eut = (pair_eut<0.1)
replace below10r_eut = . if pair_eut==.
tab below10r_eut, missing

* Now tabulate the p-values at the 5% floor level
generate below5r_eut = (pair_eut<0.05)
replace below5r_eut = . if pair_eut==.
tab below5r_eut, missing

* Now tabulate the p-values at the 1% floor level
generate below1r_eut = (pair_eut<0.01)
replace below1r_eut = . if pair_eut==.
tab below1r_eut, missing

log close log1
}

* collate estimates of EUT and RDU
if "$doINDIVIDUAL_A_HIGH" == "y" {
log using ToMove/IndividualPAI_EUT-RDU_HIGN.log, replace name(log1)

***************************
* Now do aggregae tabulations with PAI_EUT estimates
*****************************
	use TempData/estimates, replace
	egen SEN = seq(), by(pnr)
	generate liqW = assets_stocks + assets_banks + assets_bonds
	qui summ liqW if SEN==1, detail
	local q2 = r(p50)
	generate insample = (liqW>`q2')
	keep if insample ==1
	
	generate RDU = .
	replace  RDU = (pair_eut<$sigLL) if pair_eut~=.
	replace  RDU = 0 				 if pai_rn~=. & RDU==.

	tab RDU, missing
	generate omega = .
	replace  omega = $high * exp(LNomega_pai_pe)  if RDU==0
	replace  omega = 0 if pai_nai < $sigLL  & pai_nai~=.  & RDU==0
	
	replace  omega = $high * exp(LNomega_pair_pe)  if RDU==1
	replace  omega = 0 if pair_nai < $sigLL  & pair_nai~=.  & RDU==1 
	
	generate omegaB = ""
	replace omegaB = "1. <0.001"  if 				  omega<=0.001 & omega~=.
	replace omegaB = "2. <0.05"  if omega>0.001 	& omega<=0.05
	replace omegaB = "3. <0.30"  if omega>0.05  	& omega<=0.30
	replace omegaB = "4. >0.30"  if omega>0.30  	& omega~=.
	replace omegaB = "5. MI"   if omega==.

	* Now bin R
	generate 	r = .
	replace 	r = r_pai_pe if RDU==0
	replace  	r = 0 if r_pai_p > $sigLL  & RDU==0
	replace  	r = r_pair_pe if r_pair_p > $sigLL  & RDU==1
	replace  	r = 0 if r_pair_p > $sigLL  & RDU==1
	
	generate rB = ""			
	replace rB = "1. <0"  		if r<0 		& r~=.
	replace rB = "2. 0.5"  		if r>=0 	& r<0.5
	replace rB = "3. 1"    		if r>=0.5 	& r<1
	replace rB = "4. >1"     	if r>=1	  	& r~=.
	replace rB = "5. MI"   		if r==.

* Tabulations not looking at the RDU dummy
tab omegaB, missing  
tab rB, missing 

* Now seperate them out by the classification
tab omegaB RDU, missing 
tab rB RDU, missing

* Preprae omegaB rB
	egen groupV = group(omegaB rB)
	summ groupV
	local startN = 1
	local endN = r(max)
	qui forvalues x = `startN'(1)`endN' {
		display "looking at group `x'"
		count if group ==`x'	
		if r(N) < 4 & r(N) > 0 & r(N)~=. {
			capture drop seqN
			egen seqN = seq(), by(group)
			drop if seqN > 1 & group==`x'
			expand 999 if group ==`x'
			drop seqN
		}	
	}


* Tabulate with missing (999)
tab omegaB rB, missing 

* Tabulate without missing
egen Out = count(groupV), by(groupV)
drop if Out==999
tab omegaB rB, missing 

* Now do the same with the omega* wealth
	use TempData/estimates, replace
	egen SEN = seq(), by(pnr)
	generate liqW = assets_stocks + assets_banks + assets_bonds
	qui summ liqW if SEN==1, detail
	local q2 = r(p50)
	generate insample = (liqW>`q2')
	keep if insample ==1
	
	generate RDU = .
	replace  RDU = (pair_eut<$sigLL) if pair_eut~=.
	replace  RDU = 0 				 if pai_rn~=. & RDU==.
	
	generate omegaW = .
	replace  omegaW = $high * exp(LNomega_pai_pe) * wealth_net  if RDU==0
	replace  omegaW = 0 if pai_nai < $sigLL  & pai_nai~=.   & RDU==0
	
	replace  omegaW = $high * exp(LNomega_pair_pe) * wealth_net  if RDU==1
	replace  omegaW = 0 if pair_nai < $sigLL  & pair_nai~=.  & RDU==1 

	generate omegaWB = ""
	replace omegaWB = "1. 10"     	if omegaW<=10 		& omegaW~=.
	replace omegaWB = "2. 1000"   	if omegaW>10 		& omegaW<=1000
	replace omegaWB = "3. 100000"  	if omegaW>1000 		& omegaW<=100000
	replace omegaWB = "4. >100000" 	if omegaW>100000   	& omegaW~=.
	replace omegaWB = "5. MI"    	if omegaW==.

	* Now bin R
	generate 	r = r_pai_pe if RDU==0
	replace  	r = 0 if r_pai_p > $sigLL  & RDU==0
	replace  	r = r_pair_pe if r_pair_p < $sigLL  & RDU==1
	replace  	r = 0 if r_pair_p > $sigLL  & RDU==1
	
	generate rB = ""			
	replace rB = "1. <0"  		if r<0 		& r~=.
	replace rB = "2. 0.5"  		if r>=0 	& r<0.5 & r~=.
	replace rB = "3. 1"    		if r>=0.5 	& r<1 & r~=.
	replace rB = "4. >1"     	if r>=1	  	& r~=.
	replace rB = "5. MI"   		if r==.
	
* Tabulations not looking at the RDU dummy
tab omegaWB, missing 
tab rB, missing 

* Now seperate them out by the classification
tab omegaWB RDU, missing 
tab rB 		RDU, missing

* Prepare omegaB rBfor cross tabulations
	egen groupV = group(rB omegaWB)
	summ groupV
	local startN = 1
	local endN = r(max)
	qui forvalues x = `startN'(1)`endN' {
		display "looking at group `x'"
		count if group ==`x'	
		if r(N) < 4 & r(N) > 0 & r(N)~=. {
			capture drop seqN
			egen seqN = seq(), by(group)
			drop if seqN > 1 & group==`x'
			expand 999 if group ==`x'
			drop seqN
		}	
	}

* Tabulate with missing (999)
tab omegaWB rB, missing 

* Tabulate without missing
egen Out = count(groupV), by(groupV)
drop if Out==999
tab omegaWB rB, missing  

* Tabulate nai
use TempData/estimates, replace
generate RDU = .
replace  RDU = (pair_eut<$sigLL) if pair_eut~=.
replace  RDU = 0 				 if pai_rn~=. & RDU==.

generate belowL = .
replace  belowL = (pai_nai<$sigLL) if RDU==0
replace  belowL = (pair_nai<$sigLL) if RDU==1
tab belowL RDU, missing 

log close log1
}

* collate estimates of EUT and RDU
if "$doINDIVIDUAL_C" == "y" {
log using ToMove/IndividualCatagorized.log, replace name(log1)
***************************
* Now do aggregae tabulations with PAI_RDU estimates
*****************************

use TempData/estimates, replace
generate RDU = .
replace  RDU = (pair_eut<$sigLL) if pair_eut~=.
replace  RDU = 0 				 if pai_rn~=. & RDU==.

save TempData/temp, replace

	generate omega = $high * exp(LNomega_pair_pe)  if RDU==1
	replace  omega = $high * exp(LNomega_pai_pe) if RDU==0
	
	generate omegaB = ""
	replace omegaB = "1. <0.001"  if 				  omega<=0.001 & omega~=.
	replace omegaB = "2. <0.05"  if omega>0.001 	& omega<=0.05
	replace omegaB = "3. <0.30"  if omega>0.05  	& omega<=0.30
	replace omegaB = "4. >0.30"  if omega>0.30  	& omega~=.
	replace omegaB = "5. MI"   if omega==.

	* Now bin R
	generate 	r = r_pair_pe if RDU==1
	replace 	r = r_pai_pe if RDU==0
	
	generate rB = ""		
	replace rB = "1. <0"  		if r<0 		& r~=.
	replace rB = "2. 0.5"  		if r>=0 	&    r<0.5
	replace rB = "3. 1"    		if r>=0.5 	&    r<1
	replace rB = "4. >1"     	if r>=1	  	& r~=.
	replace rB = "5. MI"   		if r==.

* Tabulations not looking at the RDU dummy
tab omegaB, missing
tab rB, missing

* Now seperate them out by the classification
tab omegaB RDU, missing 
tab rB RDU, missing

* Preprae omegaB rB for missing
	egen groupV = group(omegaB rB)
	summ groupV
	local startN = 1
	local endN = r(max)
	qui forvalues x = `startN'(1)`endN' {
		display "looking at group `x'"
		count if group ==`x'	
		if r(N) < 4 & r(N) > 0 & r(N)~=. {
			capture drop seqN
			egen seqN = seq(), by(group)
			drop if seqN > 1 & group==`x'
			expand 999 if group ==`x'
			drop seqN
		}	
	}

* Tabulate with missing (999)
tab omegaB rB, missing 

* Tabulate without missing
egen Out = count(groupV), by(groupV)
drop if Out==999
tab omegaB rB, missing 

* Now do the same with the omega* wealth
use TempData/temp, replace
	generate omegaW = $high * exp(LNomega_pair_pe) * wealth_net if RDU==1
	replace  omegaW = $high * exp(LNomega_pai_pe) * wealth_net if RDU==0
	
	generate omegaWB = ""
	replace omegaWB = "1. 10"     if 			  omegaW<=10 & omegaW~=.
	replace omegaWB = "2. 1000"   if omegaW>10 	& omegaW<=1000
	replace omegaWB = "3. 100000"  if omegaW>1000 	& omegaW<=100000
	replace omegaWB = "4. >100000" if omegaW>100000   	& omegaW~=.
	replace omegaWB = "5. MI"    if omegaW==.
	
	* Now bin R
	generate 	r = r_pair_pe if RDU==1
	replace 	r = r_pai_pe if RDU==0
	
	generate rB = ""		
	replace rB = "1. <0"  		if r<0 		& r~=.
	replace rB = "2. 0.5"  		if r>=0 	&    r<0.5
	replace rB = "3. 1"    		if r>=0.5 	&    r<1
	replace rB = "4. >1"     	if r>=1	  	& r~=.
	replace rB = "5. MI"   		if r==.
	
* Tabulations not looking at the RDU dummy
tab omegaWB, missing 
tab rB, missing 

* Now seperate them out by the classification
tab omegaWB RDU, missing 
tab rB RDU, missing

* Prepare omegaB rBfor cross tabulations
	egen groupV = group(rB omegaWB)
	summ groupV
	local startN = 1
	local endN = r(max)
	qui forvalues x = `startN'(1)`endN' {
		display "looking at group `x'"
		count if group ==`x'	
		if r(N) < 4 & r(N) > 0 & r(N)~=. {
			capture drop seqN
			egen seqN = seq(), by(group)
			drop if seqN > 1 & group==`x'
			expand 999 if group ==`x'
			drop seqN
		}	
	}

* Tabulate with missing (999)
tab omegaWB rB, missing

* Tabulate without missing
egen Out = count(groupV), by(groupV)
drop if Out==999
tab omegaWB rB, missing 

* Tests of NAI
use TempData/temp, replace
generate test = pair_nai if RDU==1
replace  test = pai_nai if RDU==0

* Now tabulate the p-values at the 10% floor level
generate below10r = (test<0.1)
replace below10r = . if test==.
tab below10r, missing

* Now tabulate the p-values at the 5% floor level
generate below5r = (test<0.05)
replace below5r = . if test==.
tab below5r, missing  

* Now tabulate the p-values at the 1% floor level
generate below1r = (test<0.01)
replace below1r = . if test==.
tab below1r , missing

log close log1

}

* collate estimates of EUT and RDU
if "$doINDIVIDUAL_C2" == "y" {
local level = round($sigLL*100)
log using ToMove/IndividualTable7.log, replace name(log1)
***************************
* Now do aggregae tabulations with PAI_EUT estimates
*****************************
	local sigs = $sigLL
	display "Significance level set to `sigs'"
	
	use TempData/estimates, replace
	generate RDU = .
	replace  RDU = (pair_eut<$sigLL) if pair_eut~=.
	replace  RDU = 0 				 if pai_rn~=. & RDU==.

	tab RDU, missing
	generate omega = .
	replace  omega = $high * exp(LNomega_pai_pe)  if RDU==0
	replace  omega = 0 if pai_nai < $sigLL  & pai_nai~=.  & RDU==0
	
	replace  omega = $high * exp(LNomega_pair_pe)  if RDU==1
	replace  omega = 0 if pair_nai < $sigLL  & pair_nai~=.  & RDU==1 
	
	generate omegaB = ""
	replace omegaB = "1. <0.001"  if 				  omega<=0.001 & omega~=.
	replace omegaB = "2. <0.05"  if omega>0.001 	& omega<=0.05
	replace omegaB = "3. <0.30"  if omega>0.05  	& omega<=0.30
	replace omegaB = "4. >0.30"  if omega>0.30  	& omega~=.
	replace omegaB = "5. MI"   if omega==.

	* Now bin R
	generate 	r = .
	replace 	r = r_pai_pe if RDU==0
	replace  	r = 0 if r_pai_p > $sigLL  & RDU==0
	replace  	r = r_pair_pe if r_pair_p <= $sigLL  & RDU==1
	replace  	r = 0 if r_pair_p > $sigLL  & RDU==1
	
	generate rB = ""			
	replace rB = "1. <0"  		if r<0 		& r~=.
	replace rB = "2. 0.5"  		if r>=0 	& r<0.5
	replace rB = "3. 1"    		if r>=0.5 	& r<1
	replace rB = "4. >1"     	if r>=1	  	& r~=.
	replace rB = "5. MI"   		if r==.

* Tabulations not looking at the RDU dummy
tab omegaB, missing  
tab rB, missing 

* Now seperate them out by the classification
tab omegaB RDU, missing 
tab rB RDU, missing

* Preprae omegaB rB
	egen groupV = group(omegaB rB)
	summ groupV
	local startN = 1
	local endN = r(max)
	qui forvalues x = `startN'(1)`endN' {
		display "looking at group `x'"
		count if group ==`x'	
		if r(N) < 4 & r(N) > 0 & r(N)~=. {
			capture drop seqN
			egen seqN = seq(), by(group)
			drop if seqN > 1 & group==`x'
			expand 999 if group ==`x'
			drop seqN
		}	
	}


* Tabulate with missing (999)
tab omegaB rB, missing 

* Tabulate without missing
egen Out = count(groupV), by(groupV)
drop if Out==999
tab omegaB rB, missing 

* Now do the same with the omega* wealth
	use TempData/estimates, replace
	generate RDU = .
	replace  RDU = (pair_eut<$sigLL) if pair_eut~=.
	replace  RDU = 0 				 if pai_rn~=. & RDU==.
	
	generate omegaW = .
	replace  omegaW = $high * exp(LNomega_pai_pe) * wealth_net  if RDU==0
	replace  omegaW = 0 if pai_nai < $sigLL  & pai_nai~=.   & RDU==0
	
	replace  omegaW = $high * exp(LNomega_pair_pe) * wealth_net  if RDU==1
	replace  omegaW = 0 if pair_nai < $sigLL  & pair_nai~=.  & RDU==1 

	generate omegaWB = ""
	replace omegaWB = "1. 10"     	if omegaW<=10 		& omegaW~=.
	replace omegaWB = "2. 1000"   	if omegaW>10 		& omegaW<=1000
	replace omegaWB = "3. 100000"  	if omegaW>1000 		& omegaW<=100000
	replace omegaWB = "4. >100000" 	if omegaW>100000   	& omegaW~=.
	replace omegaWB = "5. MI"    	if omegaW==.

	* Now bin R
	generate 	r = r_pai_pe if RDU==0
	replace  	r = 0 if r_pai_p > $sigLL  & RDU==0
	replace  	r = r_pair_pe if r_pair_p <= $sigLL  & RDU==1
	replace  	r = 0 if r_pair_p > $sigLL  & RDU==1
	
	generate rB = ""			
	replace rB = "1. <0"  		if r<0 		& r~=.
	replace rB = "2. 0.5"  		if r>=0 	& r<0.5 & r~=.
	replace rB = "3. 1"    		if r>=0.5 	& r<1 & r~=.
	replace rB = "4. >1"     	if r>=1	  	& r~=.
	replace rB = "5. MI"   		if r==.
	
* Tabulations not looking at the RDU dummy
tab omegaWB, missing 
tab rB, missing 

* Now seperate them out by the classification
tab omegaWB RDU, missing 
tab rB 		RDU, missing

* Prepare omegaB rBfor cross tabulations
	egen groupV = group(rB omegaWB)
	summ groupV
	local startN = 1
	local endN = r(max)
	qui forvalues x = `startN'(1)`endN' {
		display "looking at group `x'"
		count if group ==`x'	
		if r(N) < 4 & r(N) > 0 & r(N)~=. {
			capture drop seqN
			egen seqN = seq(), by(group)
			drop if seqN > 1 & group==`x'
			expand 999 if group ==`x'
			drop seqN
		}	
	}

* Tabulate with missing (999)
tab omegaWB rB, missing 

* Tabulate without missing
egen Out = count(groupV), by(groupV)
drop if Out==999
tab omegaWB rB, missing  

* Tabulate nai
use TempData/estimates, replace
generate RDU = .
replace  RDU = (pair_eut<$sigLL) if pair_eut~=.
replace  RDU = 0 				 if pai_rn~=. & RDU==.

generate belowL = .
replace  belowL = (pai_nai<$sigLL) if RDU==0
replace  belowL = (pair_nai<$sigLL) if RDU==1
tab belowL RDU, missing 

log close log1

}


* collate estimates of EUT and RDU
if "$doINDIVIDUAL_SUM" == "y" {

log using ToMove/IndividualSummary.log, replace name(log1)
***************************
* Now do aggregae tabulations with PAI_EUT estimates
*****************************
	
	* Now do the same with the omega* wealth
	use TempData/estimates, replace
	generate RDU = .
	replace  RDU = (pair_eut<$sigLL) if pair_eut~=.
	replace  RDU = 0 				 if pai_rn~=. & RDU==.
	
	generate omegaW = .
	replace  omegaW = $high * exp(LNomega_pai_pe) * wealth_net  if RDU==0
	replace  omegaW = $high * exp(LNomega_pair_pe) * wealth_net  if RDU==1
		
	* Classify individuals into the three groups	
	generate omegaG = ""
	replace omegaG = "1. <10000 "   if omegaW<=10000 		& omegaW~=.
	replace omegaG = "2. <100000"   if omegaW>10000 		& omegaW<=100000
	replace omegaG = "3. <500000"  	if omegaW>100000 		& omegaW<=500000
	
	* generate the preferences
	generate r = .
	generate omega = .
	generate rho    = .
	generate sigma  =.
	generate eta =.
	generate phi = .
	
	replace r 			= 	r_pai_pe if RDU==0
	replace omega 		= 	$high * exp(LNomega_pai_pe) if RDU==0
	replace rho    		= 	1 - exp(LNrho_pai_pe) if RDU==0
	replace sigma  		= 	1 / exp(LNrho_pai_pe) if RDU==0
	replace eta 		= 	1 if RDU==0
	replace phi 		= 	1 if RDU==0
	
	replace r 			= 	r_pair_pe if RDU==1
	replace omega 		= 	$high * exp(LNomega_pair_pe) if RDU==1
	replace rho    		= 	1 - exp(LNrho_pair_pe) if RDU==1
	replace sigma  		=	1 / exp(LNrho_pair_pe) if RDU==1
	replace eta 		= 	exp(LNeta_pair_pe) if RDU==1
	replace phi 		= 	exp(LNphi_pair_pe) if RDU==1
	
	* drop sequence
	drop if r < 0
	drop if r > 2
	drop if eta < 0.5
	drop if eta > 1.5
	drop if phi < 0.5
	drop if phi > 1.5	
	tabstat r omega rho eta phi, by(omegaG) col(stat) longstub nototal stats(mean sd N)
			
log close log1

}

* collate estimates of EUT and RDU
if "$doINDIVIDUAL_FIG" == "y" {

	log using ToMove/IndividualBorg.log, replace name(log1)
***************************
* Now do aggregae tabulations with PAI_EUT estimates
*****************************
	
	use TempData/estimates, replace
	generate EUT = .
	replace  EUT = 1- (pair_eut<$sigLL) if pair_eut~=.
	replace  EUT = 1 				 	if pai_rn~=. & EUT==.

	
	* generate the preferences
	generate r = .
	generate omega = .
	generate rho    = .
	generate sigma  =.
	generate eta =.
	generate phi = .
	
	replace r 		= r_pai_pe if EUT==1
	replace r		= 0 if r_pai_p < $sigLL  & pai_nai~=.  & EUT==1
	replace omega 	= $high * exp(LNomega_pai_pe) if EUT==1
	replace omega 	= 0 if pai_nai < $sigLL  & pai_nai~=.  & EUT==1
	replace rho    	= 1 - exp(LNrho_pai_pe) if EUT==1
	replace sigma  	= 1 / exp(LNrho_pai_pe) if EUT==1
	replace eta 	= 1 if EUT==1
	replace phi 	= 1 if EUT==1
	
	replace r 		= r_pair_pe if EUT==0
	replace r		= 0 if r_pair_p < $sigLL  & pair_nai~=.  & EUT==0
	replace omega 	= $high * exp(LNomega_pair_pe) if EUT==0
	replace omega 	= 0 if pair_nai < $sigLL  & pair_nai~=.  & EUT==0
	replace rho    	= 1 - exp(LNrho_pair_pe) if EUT==0
	replace sigma  	= 1 / exp(LNrho_pair_pe) if EUT==0
	replace eta 	= exp(LNeta_pair_pe) if EUT==0
	replace phi 	= exp(LNphi_pair_pe) if EUT==0
	
	* save estimated file
	save TempData/tmp_estimates, replace
	
	* scale wealth to match "1"
	global scale "1"
	
	
	qui {
		forvalues id = 1/454 {			
			* get estiamtes
			use TempData/tmp_estimates, clear
			keep if sid == `id'
			
			qui summ r
			local r = r(mean)
				
			if `r' ~= . & `r' < 5 & `r' > -5 {
				qui summ rho
				local rho = r(mean)
				
				if `rho' ~= 1 & `rho'~= . {
					qui di "evaluating raio of CE to EC for subject `id' ..."
				
					* expand to 100
					expand 100
					
					* scale wealth
					generate w = wealth_T/$scale
					
					generate L = _n*1000/$scale
					generate S = 1000/$scale
					generate prob = 0.5
					
					* with RDU generate the weights and apply to the L prize
					generate wprob = exp( (-eta) * (-ln(prob))^phi)
					generate ev = prob*L + (1-prob)*S
					generate A = (wprob*(omega*w^rho + L^rho)^((1-r)/rho) )+ ((1-wprob)*(omega*w^rho + S^rho)^((1-r)/rho))
					qui summ A
					local A = r(N)
					if `A' ~= 0  {
						generate ce = (A^(rho/(1-r)) - omega*w^rho)^(1/rho)
				
						generate ratio = ce/ev
						
						format wealth_T L %15.0fc
						format ce ev %15.0fc
						format ratio %15.2f
				
						foreach v in L S ev ce {
						
							replace `v' = `v'*$scale
						
						}
				
						* get cpmfodemce omtervaæs
						qui centile ratio, centile(1 2.5 5 50 05 97.5 99)
					
						* get the mean
						qui mean ratio
						
						drop A
				
						replace L = L/$scale
						
						qui foreach S in 0 100 1000 10000 {
							qui di "evaluating CE for lower prize s = `S'..."
						
							drop ev ce ratio S 
							generate int S = `S'/$scale
							generate ev = prob*L + (1-prob)*S
							generate A = (wprob*(omega*w^rho + L^rho)^((1-r)/rho) )+ ((1-wprob)*(omega*w^rho + S^rho)^((1-r)/rho))
							generate ce = (A^(rho/(1-r)) - omega*w^rho)^(1/rho)
							generate ratio = ce/ev
							drop if S>=L
							drop A
							foreach v in L S ev ce {
							
								replace `v' = `v'*$scale
							
							}
							save TempData/tmp`S', replace
							replace L = L/$scale
						}
						* Collate
						use TempData/tmp0, clear
						qui foreach S in 100 1000 10000 {
							append using TempData/tmp`S'
							erase TempData/tmp`S'.dta			
						}
						erase TempData/tmp0.dta
						compress
						save TempData/ce_`id', replace
					}
					else {
						clear 
						set obs 1
						generate sid = `id'
						save TempData/ce_`id', replace
					}
				}	
				else {
					clear 
					set obs 1
					generate sid = `id'
					save TempData/ce_`id', replace
				}
			}			
			else {
				clear 
				set obs 1
				generate sid = `id'
				save TempData/ce_`id', replace
			}
		}
		
		
	* No collate over all subects
	use TempData/ce_1, clear
	forvalues sid = 2/454 {
		capture append using ce_`sid'
		capture erase ce_`sid'.dta
	}
	erase  TempData/ce_1.dta	
	}
	
	qui summ ratio
	
	* generate historam values for 20 bins
	twoway__histogram_gen ratio, bin(20) generate(height ratio_value, replace) fraction
	list ratio_value height in 1/20, noobs
	centile ratio, centile(1 2.5 5 50 95 97.5 99)
	mean ratio
	
	log close log1


}

**********************
* APPENDIX FIGURE B3:
**********************

* GET RATIO ESTIMATES FROM SERVER:
clear all
set obs 20
egen seq = seq()
generate ratio = 0.05 + 0.1*(seq)
generate fraction = .
replace fraction = .120623  if seq==1
replace fraction = .0234798   if seq==2
replace fraction = .0347323   if seq==3
replace fraction =  .0296587   if seq==4
replace fraction = .0383092   if seq==5
replace fraction =  .0338573   if seq==6
replace fraction =  .0547351   if seq==7
replace fraction =   .0532077   if seq==8
replace fraction =    .0662716   if seq==9
replace fraction =    .232181   if seq==10
replace fraction =   .0768257   if seq==11
replace fraction =  .0593712   if seq==12
replace fraction =    .0680217   if seq==13
replace fraction =  .0256904   if seq==14
replace fraction =   .0211464   if seq==15
replace fraction =  .017347   if seq==16
replace fraction =    .008781   if seq==17
replace fraction =    .0088731   if seq==18
replace fraction =   .0043137   if seq==19
replace fraction =    .0225741   if seq==20

* read in the data
list, noobs
twoway (connected fraction ratio, sort mcolor(blue) lcolor(blue) lwidth(thick)), ytitle(Fraction) ytitle(, size(medlarge) orientation(horizontal)) ylabel(, labsize(medlarge) angle(horizontal)) xtitle(Ratio of CE to EV) xtitle(, size(medlarge)) xline(1, lwidth(medium) lpattern(dash) lcolor(red)) xlabel(0(0.25)2, labsize(medlarge)) title("Figure B5: Distribution of Ratios of" "Certainty Equivalent to Expected Value") saving(ToMove/AI_figureB5, replace)



