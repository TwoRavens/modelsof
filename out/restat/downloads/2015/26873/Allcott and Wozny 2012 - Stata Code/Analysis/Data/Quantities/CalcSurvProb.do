# delimit cr

/********************************************************
CalcSurvProb.do
Nathan Wozny 9/02/09
Estimate survival probabilities for each vehicle.
********************************************************/
/* Setup*/
local maxage=25


set seed 0 
forvalues br = 0/52 {

	** Get a vector of K random variables that holds for the entire bootstrap replication.
		local K = 23
		matrix define Ztemp = [rnormal()]
		forvalues k = 2/`K' {
			matrix define Z1 = [rnormal()]
			matrix Ztemp = Ztemp,Z1
		}

	/* Load up the temporary file stored from PolkQuantities.do */
	use SurvivalProbabilityData.dta,clear
	
	/* Get MPG */
	sort CarID ModelYear
	merge CarID ModelYear using ../EPAMPG/EPAByID, uniqusing keep(GPMA)
	tab _merge
	drop _merge
	rename GPMA GPM
	
	/* Get FirmID */
	sort CarID ModelYear
	merge CarID ModelYear using ../Matchups/IDToNames, uniqusing nokeep keep(Firm)
	tab _merge
	drop _merge
	bysort Firm: gen NumInFirm = _N
	replace Firm = "Uncommon" if NumInFirm/_N<0.01
	egen FirmID = group(Firm)
	drop Firm NumInFirm
	
	* get NHTS age-specific quantity adjustments
	gen Age = Year - ModelYear
	drop if Age==.
	sort Age
	merge Age using ../NHTS/NHTSQAgeAdj, uniqusing nokeep
	assert _merge==3
	if `br'==52 replace Quantity = round(Quantity * NHTSQAdj,1)
	drop _merge NHTSQAdj
	
	gen MY = ModelYear-1966
	
	gen AgeGPM = Age*GPM
	sort CarID ModelYear Age
	by CarID ModelYear: gen NextQuantity=Quantity[_n+1] if Age>=0 & Age[_n+1]==Age+1
	/* diagnostic */
	gen SurvProb = NextQuantity/Quantity
	sum SurvProb if Age==0
	sum SurvProb if Age==1
	sum SurvProb if Age==5
	sum SurvProb if Age==10
	sum SurvProb if Age==15
	sum SurvProb [aw=Quantity] if Age==0
	sum SurvProb [aw=Quantity] if Age==1
	sum SurvProb [aw=Quantity] if Age==5
	sum SurvProb [aw=Quantity] if Age==10
	sum SurvProb [aw=Quantity] if Age==15
	drop SurvProb
	char Age [omit] 0
	
	** Generate age buckets
		* This will fit everything 20 and over as the same probability, and everything 1 and lower with the same (i.e. 1 and 0). Note that in the estimation, survival probability is actually better from 1 to 2 than from 0 to 1.
	gen AgeB = Age
	replace AgeB = 20 if AgeB>=20
	xi i.AgeB, pre(_I) noomit
	drop _IAgeB_1 _IAgeB_0
	xi i.FirmID*Age, pre(_FA)
	*xi i.Age
	*drop _IAge_1
	
	
	/* Start by computing annual survival probabilities:
	   AnnSurvProb`s' = P(survive to t+s+1 | survive to t+s) */
	*xi: bprobit NextQuantity Quantity MY i.Age i.FirmID*Age i.VClass if Age>=0 & Age<`maxage'
	*xi: bprobit NextQuantity Quantity MY i.FirmID*Age i.Age if Age>=0 & Age<`maxage'
	
	if `br'==51 global SPVars "MY GPM _FA* _I*"
	else global SPVars "MY GPM AgeGPM _I*"
	
	bprobit NextQuantity Quantity $SPVars if Age>=1, cluster(CarID)
	gen OrigAge = Age
	
	forvalues s=0/`maxage' {
	    * Predict annual survival probability `i' years in the future, i.e. as if the age of the car were Age+`i'
	    replace Age = OrigAge + `s'
	    forvalues i=2/19 {
	        replace _IAgeB_`i' = (OrigAge==`i'-`s')
	    }
		replace _IAgeB_20 = (OrigAge>=20-`s')
		
	    replace AgeGPM = Age*GPM
		
		** Get the predicted probabilities from coefficients
			** If bootstrap replication is 0 or greater than 50, this means to use the actual parameter estimates.
			if `br' == 0 | `br' > 50 {
				gen Phi`s' = _b[_cons]
				foreach var of varlist $SPVars {
					replace Phi`s' = Phi`s' + `var'*_b[`var']
				}
			}
			** Otherwise take a draw from the distribution of coefficients implied by the standard errors.
			else {
				matrix Beta = e(b)
				matrix V = e(V)
				matrix A = cholesky(V)
				
					matrix BetaDraw = (Beta' + A*Ztemp')'
					matrix list BetaDraw
					matrix list Beta
				* Construct the phi
				gen Phi`s' = BetaDraw[1,`K']
				local k = 1
				foreach var of varlist $SPVars {
					replace Phi`s' = Phi`s' + `var'*BetaDraw[1,`k']
					local k = `k'+1
				}
			}
			gen AnnSurvProb`s' = normal(Phi`s')
		
		* This line tests, showing that we are correctly reproducing the probit coefficients
		* predict AnnSurvProbTest`s' if Age<`maxage', pr
		
		replace AnnSurvProb`s' = 0 if Age>=`maxage' | AnnSurvProb`s'<0
	    replace AnnSurvProb`s' = 1 if AnnSurvProb`s' > 1 & AnnSurvProb`s' < .
	}
	
	/* diagnostic */
	sum AnnSurvProb* if OrigAge==0 & ModelYear==2005
	replace AnnSurvProb0 = 1 if OrigAge==0
	sum AnnSurvProb* if OrigAge==0
	sum AnnSurvProb* if OrigAge==1
	sum AnnSurvProb* if OrigAge==5
	sum AnnSurvProb* if OrigAge==10
	sum AnnSurvProb* if OrigAge==15
	/* Now compute s-year survival probabilities:
	   SurvProb`s' = P(survive to t+s | survive to t) */
	gen SurvProb0 = 1
	forvalues s=1/`maxage' {
	    local s1 = `s'-1
	    gen SurvProb`s'=SurvProb`s1'*AnnSurvProb`s1'
	}
	
	/* As a diagnostic measure, calculate the life expectancy from this year for each vehicle. */
	gen LifeExp = 0
	forvalues s=1/`maxage' {
	    replace LifeExp = LifeExp + SurvProb`s' if OrigAge<`maxage'-`s'
	}
	
	drop NextQuantity AnnSurvProb* Age OrigAge AgeGPM MY _I* Phi* AgeB
	
	sort CarID ModelYear Year
	save SurvProb_`br', replace


} /* Close the Bootstrap replication loop */



** Get the instrumented survival probability
include CalcSurvProbInst.do 

*
