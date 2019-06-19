/* GetGI.do */
/* Allcott and Wozny 2009 */

/* This file take a long dataset with Year Month CarID Age GPM and gets a G
based on survival probabilities and gas price expectations.
This file also computes I, the intensive margin adjustment, based on consistent assumptions.
It first calculates the instrument G0, then does the MPG age adjustment, then computes G and I.
Then computes G_, which are instruments for G to deal with measurement error.
*/

/* Notes:
GPM should be adjusted _before_ this code to adjust for the Greene et al (2007) .07 MPG/year MPG decay. This takes those adjusted numbers and further adjusts when looking into future.
Need to previously set values of locals: adjustintensive, usefutures, and usepredictedfutures.
I is defined such that the coefficient should be - 1. So I>0 implies a utility loss.
Gasoline flows are assumed to occur at the middle of the year, i.e. discount rate is 1/(1+r)^(t+.5)
*/

	/* Set the sr_elast, the short-run elasticity of VMT demand, if adjusting intensive margin */ /* IM */
		if "`adjustintensive'"=="1" | "`adjustintensive'"=="2" | "`adjustintensive'"=="3" | "`adjustintensive'"=="4" { 
			local sr_elast = -0.2 
		} 
		if "`adjustintensive'"=="5" | "`adjustintensive'"=="6" | "`adjustintensive'"=="7" | "`adjustintensive'"=="8" { 
			local sr_elast = -0.5 
		} 
		if "`adjustintensive'"=="A" | "`adjustintensive'"=="B" | "`adjustintensive'"=="C" | "`adjustintensive'"=="D" { 
			local sr_elast = -0.9 
		} 

/* Get the MeanReversionConstant if needed */
if `usepredictedfutures'==1 & `testmeanreversionconstant' ~= 1 {
	use Data/GasPrices/MeanReversionConstant.dta ,clear
	local MeanReversionConstant = MeanReversionConstant[1]
}
if `testmeanreversionconstant' == 1 {
	local MeanReversionConstant =  `meanreversionconstant'
}

/* Fit the VMT based on NHTS 2001 data if needed */
if `m'==0 {
	use Data/NHTS/EVMTData.dta, clear
	*reg OVMT FutureGPM FutureAgexLE21 FutureAgeLE21 _C* [pweight = Weight], robust nocons
	if `testmeanreversionconstant'==2 {
		reg OVMT FutureAgexLE21 FutureAgeLE21 [pweight = Weight], robust nocons
	}
	else {
		reg OVMT FutureAgexLE21 FutureAgeLE21 _C* [pweight = Weight], robust nocons
	}
	*reg OVMT FutureAgexLE21 FutureAgeLE21  _CNHTSClass_1 [pweight = Weight], robust
	est store VMTEstimation
	* Set number of regressors in VMT estimation for GR calc.
	*local K = 7 
	local K = 6
	*local K=4
	* Save to dataset for GR std error calc 
	preserve
	matrix Vtheta = e(V)
	svmat Vtheta
	keep if Vtheta1<.
	keep Vtheta*
	save Data/Vtheta, replace
	restore
	
				if `Bootstrap' == 1 {
					** Get a vector of K random variables that holds for the entire bootstrap replication
					matrix define Ztemp = [rnormal()]
					forvalues k = 2/`K' {
						matrix define Z1 = [rnormal()]
						matrix Ztemp = Ztemp,Z1
					}
				}
}

/* Open the AutoPQX.dta dataset and begin to construct G. */
use AutoPQX.dta,clear


/* WE NO LONGER DO THIS - USE GROUPING ESTIMATOR INSTEAD */
					/* If instrumenting using average GPM for all vehicles ja regardless of model year, replace GPM and GPME for this entire routine. 
					if `jaavgpm' == 1 {
						*gen StoredGPM = GPM
						*gen StoredGPME = GPME
						
						bysort CarID Age: egen MeanGPM = mean(GPM)
						bysort CarID Age: egen MeanGPME = mean(GPME)
						
						replace GPM = MeanGPM
						replace GPME = MeanGPME
						
						drop MeanGPM MeanGPME
					}
*/
if `usegpme'==1 {
		rename GPM GPMA
		rename GPME GPM
}

/* Prepare data to fit VMT */
** For fitting FutureVMT, Generate NHTS Class dummies to match the VMT regression:
gen NHTSClass = VClass
replace NHTSClass = 1 if VClass>=2&VClass<=6
replace NHTSClass = 910 if VClass==9|VClass==10

gen _CNHTSClass_1 = (NHTSClass==1)
gen _CNHTSClass_7 = (NHTSClass==7)
gen _CNHTSClass_8 = (NHTSClass==8)
gen _CNHTSClass_910 = (NHTSClass==910)


/* merge gas price futures */
sort ModelYear
merge ModelYear using Data/GasPrices/GasPriceExpectationsInstrument.dta, uniqusing keep(GasPrice GasPriceUnadjusted Eg*) nokeep
tab _merge
drop _merge

/* merge gas price instrument for new vehicles */
sort ModelYear Year Month
merge ModelYear Year Month using Data/GasPrices/GasPriceExpectationsInstrumentNew.dta, uniqusing keep(NewGasPrice NewGasPriceUnadjusted NewEg*) nokeep
drop _merge

foreach var in GasPrice GasPriceUnadjusted Eg0 Eg1 Eg2 Eg3 Eg4 Eg5 Eg6 Eg7 Eg8 Eg9 {
	replace `var' = New`var' if Age <= 0  
	drop New`var'
}

/* merge survival probabilities */
* Use Age==0 survival probabilities for Age<0 vehicles
gen OrigYear=Year
replace Year=ModelYear if Year<ModelYear
sort CarID ModelYear Year
merge CarID ModelYear Year using Data/Quantities/SurvProbNew.dta, uniqusing keep(SurvProb*) nokeep
tab _merge
drop _merge
replace Year=OrigYear
drop OrigYear

/* GET G0 INSTRUMENT */


** Most of this code is identical to the below, except that we change the age calculation, merge using GasPriceExpectationsInstrument, and call the new variable G0.
gen G0 = 0
gen lagG0 = 0
	
	** Only need for non-bootstrapped:
	if `Bootstrap' == 0 {
	
*forvalues yrsinfuture = 1/`timehorizon' {
forvalues yrsinfuture = 0/`timehorizon' {  /* Start with zero. The futures strip is the same, but this is just notation for the discounting, etc) */
	gen FutureAge =`yrsinfuture'
*	xi i.FutureAge, pre(_)
	gen FutureAgeLE21=cond(FutureAge<=21,1,0)
	gen FutureAgexLE21 = FutureAgeLE21*FutureAge
	

	** Future GPM
	* Greene, et al, (2007) report that fuel economy in used cars (in MPG, not GPM) degrades at an average of 0.07 MPG per year.
    * Note we need to use unadjusted GPM here because we are correcting GPM from the time the vehicle was new.
	gen FutureGPM = (UnadjGPM^(-1)-.07*(`yrsinfuture'+.5))^(-1)

	if `usefutures'==1 {
		gen FutureGasPrice = .
		capture replace FutureGasPrice = Eg`yrsinfuture'
		if `usepredictedfutures'==1 {	
			replace FutureGasPrice = (GasPrice-1.50)*exp(`MeanReversionConstant'*`yrsinfuture') + 1.50    if FutureGasPrice==.
		}
		if `usepredictedfutures'==0 {
			* If we don't predict futures prices, we use the spot price for the instrument just as a best guess.
			replace FutureGasPrice = GasPrice
		}
	} /* close if `usefutures' */
	if (`usefutures' == 0 | `usefutures' ==3) & `testmeanreversionconstant' ~= 1 { /* Assume Martingale */
		gen FutureGasPrice = GasPrice
	}
	if `usefutures' == 2 & `testmeanreversionconstant' ~= 1 { /* Assume Martingale */
		gen FutureGasPrice = GasPriceUnadjusted
	}
	if `usefutures' == 0 & `testmeanreversionconstant' == 1 { /* Assume spot with mean reversion to $1.50 */
		gen FutureGasPrice = (GasPrice-1.50)*exp(`MeanReversionConstant'*`yrsinfuture') + 1.50
	}
	
    sum FutureGasPrice
    capture sum Eg`yrsinfuture'

	* TEMP *
	di "m=`m', usesurv=`usesurv', sr_elast=`sr_elast', adjustintensive=`adjustintensive'"
	
	** Predict future VMT
	if `m'==0 {
		est restore VMTEstimation	
		predict FutureVMTat2001GasPrices
		if "`adjustintensive'" ~="0" /* IM */ { /* Adjust VMT for the intensive margin elasticity */
			if "`adjustintensive'" == "2"|"`adjustintensive'"=="6"|"`adjustintensive'"=="B" { /* Constant elasticity demand curve */
				gen FutureVMT = FutureVMTat2001GasPrices * exp(`sr_elast'*log(FutureGasPrice/1.61))
			}
			else { /* Linear demand curve. Secants are -245 and -1040 (approximately) for zeta = -0.05 and -0.2, respectively. */
				if `sr_elast' == -0.05 {
					gen FutureVMT = FutureVMTat2001GasPrices - (FutureGasPrice-1.61)*245
				}
				if `sr_elast' == -0.2 {
					gen FutureVMT = FutureVMTat2001GasPrices - (FutureGasPrice-1.61)*1040
				}
				if `sr_elast' == -0.5 {
					gen FutureVMT = FutureVMTat2001GasPrices - (FutureGasPrice-1.61)*1950
				}
				if `sr_elast' == -0.9 {
					gen FutureVMT = FutureVMTat2001GasPrices - (FutureGasPrice-1.61)*3000
				}
				if `sr_elast' != -0.05 & `sr_elast' != -0.2 & `sr_elast' != -0.5 & `sr_elast' != -0.9 {
					error("Need to calculate secant.")
				}
			}
		}
		if "`adjustintensive'" == "0" {
			gen FutureVMT = FutureVMTat2001GasPrices
		}
	}

	if `m' != 0 {
		gen FutureVMT = `m'
		gen FutureVMTat2001GasPrices=0 /* Must generate in order to delete later*/
	}

	** Merge Future Survival Probability. SurvProb=0 for vehicles past their lifetime.
	if `usesurv'==1 {
		* Want to get the probability that a vehicle in yrsinfuture=0 survives to age 1, which by Nathan's convention is SurvProb1. So generate new variable yrsinfuture + 1 to merge that.
		local yrsinfuture1 = `yrsinfuture'+1
		*rename SurvProb`yrsinfuture1' SurvProb
		gen SurvProb = SurvProb`yrsinfuture1'*(FutureAge+`yrsinfuture'<=`lifetime')
	}
	if `usesurv'==0 {
		gen SurvProb = 1*(FutureAge+`yrsinfuture'<=`lifetime')
	}


	gen G0s = FutureGasPrice * FutureVMT * FutureGPM * 1/(1+`r')^(`yrsinfuture'+0.5)*SurvProb

	/* Add to G */
	replace G0 = G0 + G0s
	drop FutureAge FutureAgeLE21 FutureAgexLE21 FutureGPM FutureGasPrice FutureVMT FutureVMTat2001GasPrices SurvProb G0s

} /* close `yrsinfuture' loop */
} /* close if `Bootstrap' == 0 loop */

drop GasPrice GasPriceUnadjusted Eg* SurvProb*

** Gas price lag
if `gaspricelag'!=0 { /* If it does equal zero, this is our primary specification; don't adjust months */
	/* If it does not, adjust the months so that we import lagged gas prices */	
	replace Month = Month - `gaspricelag'
	replace Year = Year - 1 if Month<=0
	replace Month = Month + 12 if Month<=0
}

** Future Gas Price
sort Year Month
merge Year Month using Data/GasPrices/GasPriceExpectations.dta, uniqusing keep(GasPrice GasPriceUnadjusted MCSGasPrice Eg*) nokeep
tab _merge
drop _merge

** Undoing gas price lag month adjustment.
if `gaspricelag'!=0 { /* Now need to undo the month adjustments that imported lagged gas price data */
	replace Month = Month + `gaspricelag'
	replace Year = Year + 1 if Month>12
	replace Month = Month - 12 if Month>12
}

** Merge survival probabilities
* Use Age==0 survival probabilities for Age<0 vehicles
gen OrigYear=Year
replace Year=ModelYear if Year<ModelYear
sort CarID ModelYear Year
if `Bootstrap'==0 {
	if `testmeanreversionconstant'==3	merge CarID ModelYear Year using Data/Quantities/SurvProb_51.dta, uniqusing keep(SurvProb*) nokeep
	else if `testmeanreversionconstant'==4	merge CarID ModelYear Year using Data/Quantities/SurvProb_52.dta, uniqusing keep(SurvProb*) nokeep
	else merge CarID ModelYear Year using Data/Quantities/SurvProb_0.dta, uniqusing keep(SurvProb*) nokeep
}
if `Bootstrap'==1 {
	merge CarID ModelYear Year using Data/Quantities/SurvProb_`br'.dta, uniqusing keep(SurvProb*) nokeep
}
tab _merge
drop _merge
replace Year=OrigYear
drop OrigYear

/* COMPUTE DISCOUNTED FUTURE GAS COSTS G */

gen G = 0
gen I = 0

** GR. Generate variables to hold parameters for the F matrix. K = 6 parameters for VMT. 
if `primary'==1 {
	forvalues k = 1/`K' {
		gen F`k' = 0
	}
}
** 

forvalues yrsinfuture = 0/`timehorizon' {
	
	** Generate Age (and age dummies, for VMT prediction.
	gen FutureAge = Age + `yrsinfuture'
	gen FutureAgeLE21=cond(FutureAge<=21,1,0)
	gen FutureAgexLE21 = FutureAgeLE21*FutureAge



	** Future GPM
	* Greene, et al, (2007) report that fuel economy in used cars (in MPG, not GPM) degrades at an average of 0.07 MPG per year.
	gen FutureGPM = (GPM^(-1)-.07*(`yrsinfuture'+0.5))^(-1)

	if `usefutures'==1 {
		gen FutureGasPrice = .
		** Replace missing values only if we have imported futures prices for Eg`yrsinfuture'
		capture replace FutureGasPrice = Eg`yrsinfuture'
		if `usepredictedfutures'==1 {
			replace FutureGasPrice = (GasPrice-1.50)*exp(`MeanReversionConstant'*`yrsinfuture') + 1.50 if FutureGasPrice==.
		}
		if `usepredictedfutures'==0 {
			* Now make zero if empty, just so G can be calculated later.
			replace FutureGasPrice=0 if FutureGasPrice==.
		}
	} /* close if `usefutures' */
	if `usefutures' == 0 & `testmeanreversionconstant' ~= 1 { /* Assume Martingale */
		gen FutureGasPrice = GasPrice
	}
	if `usefutures' == 2 & `testmeanreversionconstant' ~= 1 { /* Assume Martingale */
		gen FutureGasPrice = GasPriceUnadjusted
	}
	if `usefutures' == 3 & `testmeanreversionconstant' ~= 1 { /* Michigan Survey of Consumers */
		gen FutureGasPrice = MCSGasPrice
	}
if `usefutures' == 0 & `testmeanreversionconstant' == 1 { /* Assume spot with mean reversion to $1.50 */
		gen FutureGasPrice = (GasPrice-1.50)*exp(`MeanReversionConstant'*`yrsinfuture') + 1.50
	}

	** Predict future VMT
	if `m'==0 {
		est restore VMTEstimation
		if `Bootstrap' == 0 {
			predict FutureVMTat2001GasPrices
		}
		if `Bootstrap' == 1 {
			* Original regression:
			* reg OVMT FutureGPM FutureAgexLE21 FutureAgeLE21 _C* [pweight = Weight], robust nocons			
			* reg OVMT FutureAgexLE21 FutureAgeLE21 _C* [pweight = Weight], robust nocons			
			* reg OVMT FutureAgexLE21 FutureAgeLE21 _CNHTSClass_1 [pweight = Weight], robust
			** Draw from variance-covariance matrix:
			matrix Beta = e(b)
			matrix V = e(V)
			matrix A = cholesky(V)
			
			matrix BetaDraw = (Beta' + A*Ztemp')'
			*matrix list Ztemp
			*matrix list BetaDraw
			if `K' == 7 {
				gen FutureVMTat2001GasPrices = FutureGPM*BetaDraw[1,1] + FutureAgexLE21*BetaDraw[1,2] + FutureAgeLE21*BetaDraw[1,3] +  _CNHTSClass_1 *BetaDraw[1,4] +  _CNHTSClass_7*BetaDraw[1,5] +  _CNHTSClass_8*BetaDraw[1,6] +  _CNHTSClass_910*BetaDraw[1,7]
			}
			if `K' == 6 {
				gen FutureVMTat2001GasPrices = FutureAgexLE21*BetaDraw[1,1] + FutureAgeLE21*BetaDraw[1,2] +  _CNHTSClass_1 *BetaDraw[1,3] +  _CNHTSClass_7*BetaDraw[1,4] +  _CNHTSClass_8*BetaDraw[1,5] +  _CNHTSClass_910*BetaDraw[1,6]
			}
			if `K' == 4 {
				gen FutureVMTat2001GasPrices = FutureAgexLE21*BetaDraw[1,1] + FutureAgeLE21*BetaDraw[1,2] +  _CNHTSClass_1 *BetaDraw[1,3] +  _cons*BetaDraw[1,4]
			}
		}
		if "`adjustintensive'" ~= "0" /* IM */ { /* Adjust VMT for the intensive margin elasticity */
			if "`adjustintensive'" == "2"|"`adjustintensive'"=="6"|"`adjustintensive'"=="B" { /* Constant elasticity demand curve */
				gen FutureVMT = FutureVMTat2001GasPrices * exp(`sr_elast'*log(FutureGasPrice/1.61))
			} 
			else { /* Linear demand curve. Secants are -245 and -1040 (approximately) for zeta = -0.05 and -0.2, respectively. */
				if `sr_elast' == -0.05 {
					gen FutureVMT = FutureVMTat2001GasPrices - (FutureGasPrice-1.61)*245
				}
				if `sr_elast' == -0.2 {
					gen FutureVMT = FutureVMTat2001GasPrices - (FutureGasPrice-1.61)*1040
				}
				if `sr_elast' == -0.5 {
					gen FutureVMT = FutureVMTat2001GasPrices - (FutureGasPrice-1.61)*1950
				}
				if `sr_elast' == -0.9 {
					gen FutureVMT = FutureVMTat2001GasPrices - (FutureGasPrice-1.61)*3000
				}
				if `sr_elast' != -0.05 & `sr_elast' != -0.2 & `sr_elast' != -0.5 & `sr_elast' != -0.9 {
					error("Need to calculate secant.")
				}
			}
		}
		if "`adjustintensive'" == "0" {
			gen FutureVMT = FutureVMTat2001GasPrices
		}
	}
	if `m' != 0 {
		gen FutureVMT = `m'
		gen FutureVMTat2001GasPrices=0 /* Must generate in order to delete later*/
	}

	** Merge Future Survival Probability. SurvProb=0 for vehicles past their lifetime.
	if `usesurv'==1 {
		* Want to get the probability that a vehicle in yrsinfuture=0 survives to age 1, which by Nathan's convention is SurvProb1. So generate new variable yrsinfuture + 1 to merge that.
		local yrsinfuture1 = `yrsinfuture'+1
		gen SurvProb = SurvProb`yrsinfuture1'*(FutureAge+`yrsinfuture'<=`lifetime')
	}
	if `usesurv'==0 {
		gen SurvProb = 1*(FutureAge+`yrsinfuture'<=`lifetime')
	}

	* Assume that the gas flows occur in the middle of the year. So discount by `yrsinfuture' + 0.5
	gen Gs = FutureGasPrice * FutureVMT * FutureGPM * 1/(1+`r')^(`yrsinfuture'+0.5)*SurvProb

	gen Is = 0

	** GR
	if `primary'==1 {
		* Adjustments for uncertainty in VMT estimation:
		* The regression is: reg OVMT FutureGPM FutureAgexLE21 FutureAgeLE21 _C* [pweight = Weight], robust nocons
		* The regression is: reg OVMT FutureAgexLE21 FutureAgeLE21 _C* [pweight = Weight], robust nocons
		* The regression is: reg OVMT FutureAgexLE21 FutureAgeLE21 _CNHTSClass_1 [pweight = Weight], robust
		*gen F1s  = FutureGasPrice * FutureGPM * 1/(1+`r')^(`yrsinfuture'+0.5)*SurvProb     *   FutureGPM
		gen F1s  = FutureGasPrice * FutureGPM * 1/(1+`r')^(`yrsinfuture'+0.5)*SurvProb     *   FutureAgexLE21
		gen F2s  = FutureGasPrice * FutureGPM * 1/(1+`r')^(`yrsinfuture'+0.5)*SurvProb     *   FutureAgeLE21
		gen F3s  = FutureGasPrice * FutureGPM * 1/(1+`r')^(`yrsinfuture'+0.5)*SurvProb     *   _CNHTSClass_1
		gen F4s  = FutureGasPrice * FutureGPM * 1/(1+`r')^(`yrsinfuture'+0.5)*SurvProb     *   _CNHTSClass_7
		gen F5s  = FutureGasPrice * FutureGPM * 1/(1+`r')^(`yrsinfuture'+0.5)*SurvProb     *   _CNHTSClass_8
		gen F6s  = FutureGasPrice * FutureGPM * 1/(1+`r')^(`yrsinfuture'+0.5)*SurvProb     *   _CNHTSClass_910
		
		
		/* Adjustments for uncertainty in survival probability estimation: */
	}
	**

	/* IM */ 
	if "`adjustintensive'" ~= "0" {
		if "`adjustintensive'" == "1"|"`adjustintensive'"=="5"|"`adjustintensive'"=="A" {
			* This is the lower bound I 
			replace Is = -1*(FutureVMTat2001GasPrices - FutureVMT) * (1.61 + 0 * (FutureGasPrice-1.61)) * GPM * 1/(1+`r')^(`yrsinfuture'+0.5)*SurvProb
		} 
		if "`adjustintensive'" == "2"|"`adjustintensive'"=="6"|"`adjustintensive'"=="B" { 
			** Constant elasticity demand curve 
			* First find the constant Kappa0 that fits the equation: log(1.61) = `sr_elast' * log(FutureVMTat2001GasPrices + Kappa0
			gen Kappa0 = log(FutureVMTat2001GasPrices)-`sr_elast'*log(1.61)
			* Then use that to fit the area underneath the VMT demand curve: g/f = `sr_elast' * log(VMT) + IMConstant, evaluated from FutureVMT to FutureVMTat2001GasPrices
			replace Is = 1* (FutureVMT^(1+1/`sr_elast') - FutureVMTat2001GasPrices^(1+1/`sr_elast') ) * exp(-Kappa0/`sr_elast')/(1+1/`sr_elast') * GPM * 1/(1+`r')^(`yrsinfuture'+0.5)*SurvProb
			drop Kappa0
		}
		
		if "`adjustintensive'" == "3"|"`adjustintensive'"=="7"|"`adjustintensive'"=="C" { 
			* Linear demand curve 
			replace Is = -1*(FutureVMTat2001GasPrices - FutureVMT) * (1.61 + 0.5 * (FutureGasPrice-1.61)) * GPM * 1/(1+`r')^(`yrsinfuture'+0.5)*SurvProb
		}
		if "`adjustintensive'" == "4"|"`adjustintensive'"=="8"|"`adjustintensive'"=="D" {
			* Upper bound I
			replace Is = -1*(FutureVMTat2001GasPrices - FutureVMT) * (1.61 + 1 * (FutureGasPrice-1.61)) * GPM * 1/(1+`r')^(`yrsinfuture'+0.5)*SurvProb
		}
		
	}

	if `usepredictedfutures'==0 {
		/* Assume that there is no change in G when futures are unobserved. FutureGasPrice is zero in this case, meaning that G=0 here */
			/* This code assumes we are using ja fixed effects. Within each vehicle, if it is missing any futures prices for any yrsinfuture value, it will set G=0 for that year. */
			** Also replace Is with zeros if the Gs is also zero. Without this, we'll compute Is as if GasPrice equals 0! This would be wrong.
		gsort CarID Age ModelYear
		replace Gs = 0 if Gs[_n-1]==0 & CarID==CarID[_n-1] & Age==Age[_n-1]
		replace Is = 0 if Gs[_n-1]==0 & CarID==CarID[_n-1] & Age==Age[_n-1]
		gsort CarID Age -ModelYear
		replace Gs = 0 if Gs[_n-1]==0 & CarID==CarID[_n-1] & Age==Age[_n-1]
		replace Is = 0 if Gs[_n-1]==0 & CarID==CarID[_n-1] & Age==Age[_n-1]
	}


	/* Add to G and I */
	replace G = G + Gs
	replace I = I + Is	

	** GR
	if `primary'==1 {
		forvalues k = 1/`K' {
			replace F`k' = F`k'+F`k's
			drop F`k's
		}
	}
	** 

	drop FutureAge FutureAgeLE21 FutureAgexLE21 FutureGPM FutureGasPrice FutureVMT FutureVMTat2001GasPrices SurvProb Gs Is

}

** GR
if `primary'==1 & `Bootstrap' == 0 {
	** Save the Fs in a separate file so that it does not blow up the size of AutoPQXG.dta
	* First save the current data in a temporary file
	tempfile Temp
	save `Temp'

	* Then keep only the observations we need
	keep CarID ModelYear Age Year Month G F*

	sort CarID ModelYear Year Month
	* Save each F file separately.
	saveold F`params'.dta,replace

	* Reopen the temporary file:
	use `Temp', clear
}
**


** Note we don't keep GPM, so we do not need to undo any changes we made to this variable.
keep CarID ModelYear Year Month G G0 I
if `Bootstrap' == 0 {
	rename G0 GInst`params'
	rename G G`params'
	rename I I`params'
}

if `Bootstrap' == 1 {
	drop I G0
	rename G G`params'_`br'
}
	
sort CarID ModelYear Year Month
merge CarID ModelYear Year Month using AutoPQXG.dta
drop _merge
sort CarID ModelYear Year Month
saveold AutoPQXG.dta,replace
*
