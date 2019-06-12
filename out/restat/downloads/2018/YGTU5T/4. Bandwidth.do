********************************************************************************
*                                                                              *
*                           BANDWIDTH OPTIMISATION                             *
*                                                                              *
********************************************************************************

cd "U:\"  // Set directory
use "NVM_20002014.dta", clear

global sharp = 0            // Allow for optimisation of bandwidth
global fuzzy = 1             // Allow for optimisation of bandwidth
global min = 1               // Set minimum value for third-order terms
local minvalue = 0.0001      // Set minimum value for 

set matsize 1000

// Determine treatment and control variables.
global dependent dlogprice
*global dependent dlogdaysonmarket
global treatment dkw
global instrument dscorerule
global house dlogsize drooms dmaintgood dcentralheating dlisted 
global neighbourhood dlogincome dlogpopdens dshforeign dshyoung dshold dhhsize dluinfr dluind dluopens dluwater dshwsocialrent dshwprivrent //dkw0_500 dkw500_1000 dkw1000_1500 dkw1500_2000 dkw2000_2500 
*global adjustment ddaysinv //dkw_y1 dkw_y2 dkw_y3 //ddaysinv1 ddaysinv2 ddaysinv3 ddaysinv4 ddaysinv5
global year dyear*
global score zscore_* 

quietly local c = 7.30 // Cut-off
quietly global dT = 2.5 // Cut-off distance
quietly tostring pc4, g(pc2)
quietly replace pc2 = substr(pc2,1,3)
quietly destring pc2, force replace 
quietly g weight = .
quietly global fe pc4
quietly global se pc4
quietly xtset $fe
quietly g distcbd2 = distcbd^2
quietly g distcbd3 = distcbd^3

replace dkwinvpp = dkwinvpp/333.9277
g dkwXkwrank = dkw*(kwrank-83/2)
g dkwXlogincome = dkw*logincome
g dkwXlogpopdens = dkw*logpopdens
g dkwXshforeign = dkw*shforeign
g dkwXshyoung = dkw*shyoung
g dkwXshold = dkw*shold
g dkwXhhsize = dkw*hhsize
g dkwXkwinvpsqm = dkw*kwinvpsqm
g dkwXkwinvpsqm2 = dkw*kwinvpsqm2

/// Step 0: Keep relevant observations
quietly keep if (inkw == 1 | kwdist > $dT)
quietly drop if $dependent == .
quietly local N = _N // Number of observations

drop if beforeafter == 1
*keep if ((yearmin<2005 | yearmin>2011) & (year>2011 | year <2005))


quietly if $sharp == 1 {
	drop if kwexcl == 1

	/******************************************************************************/
	/*Step 1: Estimation of density f(c) and conditional variance sigma-squared(c)*/
	/******************************************************************************/

	/*Calculating the pilot bandwidth h1*/
	summarize zscore, detail
	local Sx = r(sd)
	local N = r(N)
	local h1 = 1.84*`Sx'*(`N'^(-1/5))

	/* Calculating the number of units on either side of the threshold and the average outcomes*/
	count if (`c'-`h1')<=zscore & zscore<`c'
	local Nh1n = r(N)

	count if `c'<=zscore & zscore<=(`c'+`h1')
	local Nh1p = r(N)

	ameans $dependent if (`c'-`h1')<=zscore & zscore<`c'
	local Yh1n = r(mean)

	ameans $dependent if `c'<=zscore & zscore<=(`c'+`h1')
	local Yh1p = r(mean)

	/* Estimating the density of X at c and the conditional variance of Y given X_i=c at x=c */
	local fxc = (`Nh1p'+`Nh1n')/(2*`N'*`h1')

	generate n$dependent =($dependent-`Yh1n')^2 
	summarize n$dependent if (`c'-`h1')<=zscore & zscore<`c', detail
	local Y1sum =r(sum)

	generate p$dependent =($dependent-`Yh1p')^2 
	summarize p$dependent if `c'<=zscore & zscore<=(`c'+`h1'), detail
	local Y2sum =r(sum)

	local sigma2c = (1/(`Nh1p'+`Nh1n'))*(`Y1sum'+`Y2sum')


	/******************************************************************************/
	/*                Step 2: Estimation of second derivatives                    */
	/******************************************************************************/

	/*Calculating the pilot bandwidth h2*/

	summarize zscore if zscore>=`c', detail
	scalar medXp = r(p50)

	summarize zscore if zscore<`c', detail
	scalar medXn = r(p50)

	regress $dependent $treatment zscore_1 zscore_2 zscore_3 $house $neighbourhood $adjustment $year if zscore >= medXn & zscore <= medXp

	local m3c=6*_b[zscore_3] 

	count if zscore>=`c'
	local Np=r(N)

	count if zscore<`c'
	local Nn=r(N)

	if $min == 1 {
		local h2p=3.56*((`sigma2c'/(`fxc'*max((`m3c')^2, `minvalue')))^(1/7))*(`Np'^(-1/7))
		local h2n=3.56*((`sigma2c'/(`fxc'*max((`m3c')^2, `minvalue')))^(1/7))*(`Nn'^(-1/7))
	}
	else {
		local h2p=3.56*((`sigma2c'/(`fxc'*(`m3c')^2))^(1/7))*(`Np'^(-1/7))
		local h2n=3.56*((`sigma2c'/(`fxc'*(`m3c')^2))^(1/7))*(`Nn'^(-1/7))
	}
	
	/*Calculating the estimates of the second derivatives*/
	count if `c'<=zscore & zscore<=(`c'+`h2p')
	local N2p=r(N)

	count if (`c'-`h2n')<=zscore & zscore<`c'
	local N2n=r(N)

	generate constant = 1
	regress $dependent constant zscore_1 zscore_2  $house $neighbourhood $adjustment $year if `c'<=zscore & zscore<=(`c'+`h2p')
	local m2pc=2*_b[zscore_2]
	regress $dependent constant zscore_1 zscore_2  $house $neighbourhood $adjustment $year if (`c'-`h2n')<=zscore & zscore<`c'
	local m2nc=2*_b[zscore_2] 

	/**************************************************************************************/
	/*Step 3: Calculation of regularization terms and calculation of the optimal bandwidth*/
	**************************************************************************************/
	
	/*Calculating the regularization terms*/
	local rp=(720*`sigma2c')/(`N2p'*((`h2p')^4))
	local rn=(720*`sigma2c')/(`N2n'*((`h2n')^4))

	/*Calculating the optimal bandwidth*/

	local CK = 5.4
	local h_sharp= `CK'*(((2*`sigma2c')/(`fxc'*(((`m2pc'-`m2nc')^2)+(`rp'+`rn'))))^(1/5))*`N'^(-1/5)

	regress $dependent $treatment $house $adjustment $neighbourhood $year constant if zscore > (`c'-`h_sharp') & zscore < (`c'+`h_sharp'), cluster($se)
	local beta_sharp = _b[$treatment]
	local sdbeta_sharp = _se[$treatment]
	local tbeta_sharp = abs(`beta_sharp'/`sdbeta_sharp')

}

quietly if $fuzzy == 1 {

	/**********************************************************************************/
	/* Step 1.1: Estimation of density f(c) and conditional variance sigma-squared(c) */
	/**********************************************************************************/

	/*Calculating the pilot bandwidth h1*/
	quietly summarize zscore, detail
	local Sx = r(sd)
	local N = r(N)
	local h1 = 1.84*`Sx'*(`N'^(-1/5))

	/* Calculating the number of units on either side of the threshold and the average outcomes*/
	quietly count if (`c'-`h1')<=zscore & zscore<`c'
	local Nh1n = r(N)

	quietly count if `c'<=zscore & zscore<=(`c'+`h1')
	local Nh1p = r(N)

	quietly ameans $treatment if (`c'-`h1')<=zscore & zscore<`c'
	local Wh1n = r(mean)

	quietly ameans $treatment if `c'<=zscore & zscore<=(`c'+`h1')
	local Wh1p = r(mean)

	/* Estimating the density of X at c and the conditional variance of Y given X_i=c at x=c */
	local fxc = (`Nh1p'+`Nh1n')/(2*`N'*`h1')

	generate n$treatment =($treatment-`Wh1n')^2 
	quietly summarize n$treatment if (`c'-`h1')<=zscore & zscore<`c', detail
	local W1sum =r(sum)

	generate p$treatment =($treatment-`Wh1p')^2 
	quietly summarize p$treatment if `c'<=zscore & zscore<=(`c'+`h1'), detail
	local W2sum =r(sum)

	local Wsigma2c = (1/(`Nh1p'+`Nh1n'))*(`W1sum'+`W2sum')


	/******************************************************************************/
	/*                Step 1.1: Estimation of second derivatives                  */
	/******************************************************************************/

	/*Calculating the pilot bandwidth h2*/

	quietly summarize zscore if zscore>=`c', detail
	scalar medXp = r(p50)

	quietly summarize zscore if zscore<`c', detail
	scalar medXn = r(p50)

	quietly regress $treatment $treatment  zscore_1 zscore_2 zscore_3 $house $neighbourhood $adjustment $year if zscore >= medXn & zscore <= medXp

	local m3c=6*_b[zscore_3] 

	quietly count if zscore>=`c'
	local Np=r(N)

	quietly count if zscore<`c'
	local Nn=r(N)
	
	if $min == 1 {
		local h2p=3.56*((`Wsigma2c'/(`fxc'*max((`m3c')^2, `minvalue')))^(1/7))*(`Np'^(-1/7))
		local h2n=3.56*((`Wsigma2c'/(`fxc'*max((`m3c')^2, `minvalue')))^(1/7))*(`Nn'^(-1/7))
	}
	else {	
		local h2p=3.56*((`Wsigma2c'/(`fxc'*(`m3c')^2))^(1/7))*(`Np'^(-1/7))
		local h2n=3.56*((`Wsigma2c'/(`fxc'*(`m3c')^2))^(1/7))*(`Nn'^(-1/7))
	}
	
	/*Calculating the estimates of the second derivatives*/
	quietly count if `c'<=zscore & zscore<=(`c'+`h2p')
	local N2p=r(N)

	count if (`c'-`h2n')<=zscore & zscore<`c'
	local N2n=r(N)

	generate constant = 1
	regress $treatment constant zscore_1 zscore_2 $house $neighbourhood $adjustment $year if `c'<=zscore & zscore<=(`c'+`h2p')
	local Wm2pc=2*_b[zscore_2]
	regress $treatment constant zscore_1 zscore_2 $house $neighbourhood $adjustment $year if (`c'-`h2n')<=zscore & zscore<`c'
	local Wm2nc=2*_b[zscore_2] 

	/********************************************************************************************/
	/* Step 1.3: Calculation of regularization terms and calculation of the 1st stage bandwidth */
	/********************************************************************************************/

	/*Calculating the regularization terms*/
	local Wrp=(720*`Wsigma2c')/(`N2p'*((`h2p')^4))
	local Wrn=(720*`Wsigma2c')/(`N2n'*((`h2n')^4))

	/*Calculating the optimal bandwidth*/

	local CK = 5.4
	local hfs= `CK'*(((2*`Wsigma2c')/(`fxc'*(((`Wm2pc'-`Wm2nc')^2)+(`Wrp'+`Wrn'))))^(1/5))*`N'^(-1/5)

	disp `hfs'

	regress $treatment $instrument $house $neighbourhood $adjustment $year constant if zscore > (`c'-`hfs') & zscore < (`c'+`hfs')
	predict pred$treatment, xb
	
	/**********************************************************************************/
	/* Step 2.1: Estimation of density f(c) and conditional variance sigma-squared(c) */
	/**********************************************************************************/

	/*Calculating the pilot bandwidth h1*/
	summarize zscore, detail
	local Sx = r(sd)
	local N = r(N)
	local h1 = 1.84*`Sx'*(`N'^(-1/5))

	/* Calculating the number of units on either side of the threshold and the average outcomes*/
	count if (`c'-`h1')<=zscore & zscore<`c'
	local Nh1n = r(N)

	count if `c'<=zscore & zscore<=(`c'+`h1')
	local Nh1p = r(N)

	ameans $dependent if (`c'-`h1')<=zscore & zscore<`c'
	local Yh1n = r(mean)

	ameans $dependent if `c'<=zscore & zscore<=(`c'+`h1')
	local Yh1p = r(mean)

	/* Estimating the density of X at c and the conditional variance of Y given X_i=c at x=c */
	local fxc = (`Nh1p'+`Nh1n')/(2*`N'*`h1')

	generate n$dependent =($dependent-`Yh1n')^2 
	summarize n$dependent if (`c'-`h1')<=zscore & zscore<`c', detail
	local Y1sum =r(sum)

	generate p$dependent =($dependent-`Yh1p')^2 
	summarize p$dependent if `c'<=zscore & zscore<=(`c'+`h1'), detail
	local Y2sum =r(sum)

	local Ysigma2c = (1/(`Nh1p'+`Nh1n'))*(`Y1sum'+`Y2sum')
	
	/* Estimate covariances of Y and W at x=c */
	
	corr $dependent $treatment if (`c'-`h1')<=zscore & zscore<`c', covariance
	local YWn = r(cov_12)
	corr $dependent $treatment if `c'<=zscore & zscore<=(`c'+`h1'), covariance
	local YWp = r(cov_12)
	
	local YWsigma2c = `YWn'+`YWp'
	
	
	/******************************************************************************/
	/*                Step 2.2: Estimation of second derivatives                  */
	/******************************************************************************/

	/*Calculating the pilot bandwidth h2*/

	summarize zscore if zscore>=`c', detail
	scalar medXp = r(p50)

	summarize zscore if zscore<`c', detail
	scalar medXn = r(p50)

	regress $dependent $treatment  zscore_1 zscore_2 zscore_3 $house $neighbourhood $adjustment $year if zscore >= medXn & zscore <= medXp

	local m3c=6*_b[zscore_3] 

	count if zscore>=`c'
	local Np=r(N)

	count if zscore<`c'
	local Nn=r(N)
	
	if $min == 1 {
		local h2p=3.56*((`Ysigma2c'/(`fxc'*max((`m3c')^2, `minvalue')))^(1/7))*(`Np'^(-1/7))
		local h2n=3.56*((`Ysigma2c'/(`fxc'*max((`m3c')^2, `minvalue')))^(1/7))*(`Nn'^(-1/7))
	}
	else {
		local h2p=3.56*((`Ysigma2c'/(`fxc'*(`m3c')^2))^(1/7))*(`Np'^(-1/7))
		local h2n=3.56*((`Ysigma2c'/(`fxc'*(`m3c')^2))^(1/7))*(`Nn'^(-1/7))
	}
	
	/*Calculating the estimates of the second derivatives*/
	quietly count if `c'<=zscore & zscore<=(`c'+`h2p')
	local N2p=r(N)

	quietly count if (`c'-`h2n')<=zscore & zscore<`c'
	local N2n=r(N)

	regress $dependent constant zscore_1 zscore_2 $house $neighbourhood $adjustment $year if `c'<=zscore & zscore<=(`c'+`h2p')
	local Ym2pc=2*_b[zscore_2]
	regress $dependent constant zscore_1 zscore_2 $house $neighbourhood $adjustment $year if (`c'-`h2n')<=zscore & zscore<`c'
	local Ym2nc=2*_b[zscore_2] 

	/********************************************************************************************/
	/* Step 2.3: Calculation of regularization terms and calculation of the 2nd stage bandwidth */
	/********************************************************************************************/

	/*Calculating the regularization terms*/
	local Yrp=(720*`Ysigma2c')/(`N2p'*((`h2p')^4))
	local Yrn=(720*`Ysigma2c')/(`N2n'*((`h2n')^4))

	/*Calculating the optimal bandwidth*/

	local CK = 5.4
	local hss = `CK'*(((2*`Ysigma2c')/(`fxc'*(((`Ym2pc'-`Ym2nc')^2)+(`Yrp'+`Yrn'))))^(1/5))*`N'^(-1/5)

	regress $dependent pred$treatment $house $neighbourhood $adjustment $year constant if zscore > (`c'-`hss') & zscore < (`c'+`hss')
	local tfrd = _b[pred$treatment]	
	
	/******************************************************************************************/
	/*             Step 3: Calculation of the optimal bandwidth and the effect                */
	/******************************************************************************************/
	
	local h_fuzzy = `CK'*(((2*`Ysigma2c'+`tfrd'^2*2*`Wsigma2c'-2*`tfrd'*`YWsigma2c')/(`fxc'*(((`Ym2pc'-`Ym2nc')-`tfrd'*(`Wm2pc'-`Wm2nc'))^2+(`Yrp'+`Yrn')+`tfrd'*(`Wrp'+`Wrn'))))^( 1/5))*`N'^(-1/5)

	ivregress 2sls $dependent ($treatment = $instrument) $house $neighbourhood $adjustment $year constant if zscore > (`c'-`h_fuzzy') & zscore < (`c'+`h_fuzzy'), cluster($se)
	local beta_fuzzy = _b[$treatment]
	local sdbeta_fuzzy = _se[$treatment ]
	local tbeta_fuzzy = abs(`beta_fuzzy'/`sdbeta_fuzzy')
	
	}
	
disp "beta =" `beta_sharp' " sd beta" `sdbeta_sharp' " T-stat beta = " `tbeta_sharp' " bandwidth SRD = " `h_sharp'
disp "beta =" `beta_fuzzy' " sd beta" `sdbeta_fuzzy' " T-stat beta = " `tbeta_fuzzy' " bandwidth FRD = " `h_fuzzy'

