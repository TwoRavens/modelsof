*Mitchell & Zawahri, JPR do file
*The Effectiveness of Treaty Design in Addressing Water Disputes"

use "icowdyadMZ.dta", clear

*Table 1, Model 1
logit midissyr rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower if year>1944, cluster(dyad)

*Table 1, Model 2
logit attbilat rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower if year>1944, cluster(dyad)

*Table 1, Model 3
logit att3rd rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower if year>1944, cluster(dyad)

*Table 1, Model 4 (note: uses mean COPDAB scale with missing data coded as zero and the scale flipped so positive (1) represents a situation where the mean of the events was positive and a negative (-1) represents a situation where the mean of events was negative. Model estimated only in 1966-1992 due to limitation of COPDAB/WEIS spliced data that Clayton gave me.
ologit gscaleord rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower if year>1965 & year<1993, cluster(dyad)

*Predicted Probabilities
estsimp logit midissyr rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower if year>1944, cluster(dyad)
estsimp logit attbilat rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower if year>1944, cluster(dyad)
estsimp logit att3rd rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower if year>1944, cluster(dyad)

setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344    
simqi, pr
setx rbo2 0 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 3 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 0 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 14 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 0 enforcement2 0.6487 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 10 enforcement2 0.6487 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 3 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 0 icowsal 6.6654 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 10 icowsal 6.6654 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr

setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 1.21 icowsal 4 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 1.21 icowsal 11 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.5503681 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.9655874 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.7814 recmidwt 0 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.7814 recmidwt 3.2 upstreampower .0170563 downstreampower .0189344  
simqi, pr

*+/- 1s.d.
setx rbo2 0 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 1.265 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 0 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 5.107 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 0 enforcement2 0.6487 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 3.672 enforcement2 0.6487 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 1.44 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 0 icowsal 6.6654 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 3.038 icowsal 6.6654 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr

setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 1.21 icowsal 4.66 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 1.21 icowsal 8.66 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.66 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.9 recmidwt 0.1686 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.7814 recmidwt 0 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.7814 recmidwt 0.623 upstreampower .0170563 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.7814 recmidwt 0.1686 upstreampower 0 downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.7814 recmidwt 0.1686 upstreampower .0595677  downstreampower .0189344  
simqi, pr
setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower 0 
simqi, pr
setx rbo2 0.5818 infoexchange2 1.8476 monitoring2 1.3587 enforcement2 0.6487 conflictresolution2 1.21 icowsal 6.6654 relcaps 0.7814 recmidwt 0.1686 upstreampower .0170563 downstreampower .0662025  
simqi, pr

use "sadataMZ.dta", clear
*Table 2, Model 1
logit agree rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 upstreampower downstreampower if year>1944, cluster(dyad)

*Table 2, Model 2
logit comply2 rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 upstreampower downstreampower if year>1944 & agree==1, cluster(dyad)

*Table 2, Model 3
logit claimend2 rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 upstreampower downstreampower  if year>1944 & agree==1, cluster(dyad)

*predicted probabilities
estsimp logit agree rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 upstreampower downstreampower if year>1944, cluster(dyad)
estsimp logit comply2 rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 upstreampower downstreampower if year>1944 & agree==1, cluster(dyad)
estsimp logit claimend2 rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 upstreampower downstreampower  if year>1944 & agree==1, cluster(dyad) 

*+/- 1s.d.
setx rbo2 0 infoexchange2 1.6772 monitoring2 1.3924 enforcement2 0.6709 conflictresolution2 1.2532 upstreampower .0170638 downstreampower .0244072  
simqi, pr
setx rbo2 1.2256 infoexchange2 1.6772 monitoring2 1.3924 enforcement2 0.6709 conflictresolution2 1.2532 upstreampower .0170638 downstreampower .0244072  
simqi, pr
setx rbo2 0.5633 infoexchange2 0 monitoring2 1.3924 enforcement2 0.6709 conflictresolution2 1.2532 upstreampower .0170638 downstreampower .0244072  
simqi, pr
setx rbo2 0.5633 infoexchange2 1.2256 monitoring2 1.3924 enforcement2 0.6709 conflictresolution2 1.2532 upstreampower .0170638 downstreampower .0244072  
simqi, pr
setx rbo2 0.5633 infoexchange2 1.6772 monitoring2 0 enforcement2 0.6709 conflictresolution2 1.2532 upstreampower .0170638 downstreampower .0244072  
simqi, pr
setx rbo2 0.5633 infoexchange2 1.6772 monitoring2 3.8153 enforcement2 0.6709 conflictresolution2 1.2532 upstreampower .0170638 downstreampower .0244072  
simqi, pr
setx rbo2 0.5633 infoexchange2 1.6772 monitoring2 1.3924 enforcement2 0 conflictresolution2 1.2532 upstreampower .0170638 downstreampower .0244072  
simqi, pr
setx rbo2 0.5633 infoexchange2 1.6772 monitoring2 1.3924 enforcement2 1.4882 conflictresolution2 1.2532 upstreampower .0170638 downstreampower .0244072  
simqi, pr
setx rbo2 0.5633 infoexchange2 1.6772 monitoring2 1.3924 enforcement2 0.6709 conflictresolution2 0 upstreampower .0170638 downstreampower .0244072  
simqi, pr
setx rbo2 0.5633 infoexchange2 1.6772 monitoring2 1.3924 enforcement2 0.6709 conflictresolution2 3.175 upstreampower .0170638 downstreampower .0244072  
simqi, pr

setx rbo2 0.5633 infoexchange2 1.6772 monitoring2 1.3924 enforcement2 0.6709 conflictresolution2 1.2532 upstreampower .0003 downstreampower .0244072  
simqi, pr
setx rbo2 0.5633 infoexchange2 1.6772 monitoring2 1.3924 enforcement2 0.6709 conflictresolution2 1.2532 upstreampower .06626 downstreampower .0244072  
simqi, pr
setx rbo2 0.5633 infoexchange2 1.6772 monitoring2 1.3924 enforcement2 0.6709 conflictresolution2 1.2532 upstreampower .0170638 downstreampower .0002  
simqi, pr
setx rbo2 0.5633 infoexchange2 1.6772 monitoring2 1.3924 enforcement2 0.6709 conflictresolution2 1.2532 upstreampower .0170638 downstreampower .0828
simqi, pr

*Robustness checks
*Adding a variable that equals one if the claim ever had one or more river treaties
*Table 1, Model 1
logit midissyr rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower treaty if year>1944, cluster(dyad)
*Table 1, Model 2
logit attbilat rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower treaty if year>1944, cluster(dyad)
*Table 1, Model 3
logit att3rd rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower treaty if year>1944, cluster(dyad)
*Table 1, Model 4 (note: uses mean COPDAB scale with missing data coded as zero and the scale flipped so positive (1) represents a situation where the mean of the events was positive and a negative (-1) represents a situation where the mean of events was negative. Model estimated only in 1966-1992 due to limitation of COPDAB/WEIS spliced data that Clayton gave me.
ologit gscaleord rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower treaty if year>1965 & year<1993, cluster(dyad)

*Cross-tabs with treaty and DVs
tab treaty midissyr, row column chi2
tab treaty attbilat, row column chi2
tab treaty att3rd, row column chi2

*Using Minimum GDP per capita measure from Z&M ISQ
*Table 1, Model 1
logit midissyr rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt minlgdpen if year>1944, cluster(dyad)
*Table 1, Model 2
logit attbilat rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt minlgdpen if year>1944, cluster(dyad)
*Table 1, Model 3
logit att3rd rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt minlgdpen if year>1944, cluster(dyad)
*Table 1, Model 4 (note: uses mean COPDAB scale with missing data coded as zero and the scale flipped so positive (1) represents a situation where the mean of the events was positive and a negative (-1) represents a situation where the mean of events was negative. Model estimated only in 1966-1992 due to limitation of COPDAB/WEIS spliced data that Clayton gave me.
ologit gscaleord rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt minlgdpen if year>1965 & year<1993, cluster(dyad)

*Adding measure for multilateral basin
*Table 1, Model 1
logit midissyr rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower multibasin if year>1944, cluster(dyad)
*Table 1, Model 2
logit attbilat rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower multibasin if year>1944, cluster(dyad)
*Table 1, Model 3
logit att3rd rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower multibasin if year>1944, cluster(dyad)
*Table 1, Model 4 (note: uses mean COPDAB scale with missing data coded as zero and the scale flipped so positive (1) represents a situation where the mean of the events was positive and a negative (-1) represents a situation where the mean of events was negative. Model estimated only in 1966-1992 due to limitation of COPDAB/WEIS spliced data that Clayton gave me.
ologit gscaleord rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower multibasin if year>1965 & year<1993, cluster(dyad)

*Bivariate probit results
biprobit (midissyr= rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower) ///
(rbo2=multibasin upstreampower downstreampower democ6 icowsal) if year > 1944, robust cluster(dyad)
biprobit (midissyr= rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower) ///
(infoexchange2=multibasin upstreampower downstreampower democ6 icowsal) if year > 1944, robust cluster(dyad)
biprobit (midissyr= rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower) ///
(monitoring2=multibasin upstreampower downstreampower democ6 icowsal) if year > 1944, robust cluster(dyad)
biprobit (midissyr= rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower) ///
(enforcement2=multibasin upstreampower downstreampower democ6 icowsal) if year > 1944, robust cluster(dyad)
biprobit (midissyr= rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower) ///
(conflictresolution2=multibasin upstreampower downstreampower democ6 icowsal) if year > 1944, robust cluster(dyad)

biprobit (attbilat= rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower) ///
(rbo2=multibasin upstreampower downstreampower democ6 icowsal) if year > 1944, robust cluster(dyad)
biprobit (attbilat= rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower) ///
(infoexchange2=multibasin upstreampower downstreampower democ6 icowsal) if year > 1944, robust cluster(dyad)
biprobit (attbilat= rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower) ///
(monitoring2=multibasin upstreampower downstreampower democ6 icowsal) if year > 1944, robust cluster(dyad)
biprobit (attbilat= rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower) ///
(enforcement2=multibasin upstreampower downstreampower democ6 icowsal) if year > 1944, robust cluster(dyad)
biprobit (attbilat= rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower) ///
(conflictresolution2=multibasin upstreampower downstreampower democ6 icowsal) if year > 1944, robust cluster(dyad)

biprobit (att3rd= rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower) ///
(rbo2=multibasin upstreampower downstreampower democ6 icowsal) if year > 1944, robust cluster(dyad)
biprobit (att3rd= rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower) ///
(infoexchange2=multibasin upstreampower downstreampower democ6 icowsal) if year > 1944, robust cluster(dyad)
biprobit (att3rd=rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower) ///
(monitoring2=multibasin upstreampower downstreampower democ6 icowsal) if year > 1944, robust cluster(dyad)
biprobit (att3rd= rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower) ///
(enforcement2=multibasin upstreampower downstreampower democ6 icowsal) if year > 1944, robust cluster(dyad)
biprobit (att3rd= rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower) ///
(conflictresolution2=multibasin upstreampower downstreampower democ6 icowsal) if year > 1944, robust cluster(dyad)

*Adding Year to the models
*Table 1, Model 1
logit midissyr rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower year if year>1944, cluster(dyad)
*Table 1, Model 2
logit attbilat rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower year if year>1944, cluster(dyad)
*Table 1, Model 3
logit att3rd rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower year if year>1944, cluster(dyad)
*Table 1, Model 4 (note: uses mean COPDAB scale with missing data coded as zero and the scale flipped so positive (1) represents a situation where the mean of the events was positive and a negative (-1) represents a situation where the mean of events was negative. Model estimated only in 1966-1992 due to limitation of COPDAB/WEIS spliced data that Clayton gave me.
ologit gscaleord rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower year if year>1965 & year<1993, cluster(dyad)

*Using treaty counter years as IVs
*Table 1, Model 1
logit midissyr rboyrsum2 infoexchangeyrsum2 monitoringyrsum2 enforcementyrsum2 conflictresolutionyrsum2 icowsal relcaps recmidwt upstreampower downstreampower if year>1944, cluster(dyad)
*Table 1, Model 2
logit attbilat rboyrsum2 infoexchangeyrsum2 monitoringyrsum2 enforcementyrsum2 conflictresolutionyrsum2 icowsal relcaps recmidwt upstreampower downstreampower if year>1944, cluster(dyad)
*Table 1, Model 3
logit att3rd rboyrsum2 infoexchangeyrsum2 monitoringyrsum2 enforcementyrsum2 conflictresolutionyrsum2 icowsal relcaps recmidwt upstreampower downstreampower if year>1944, cluster(dyad)
*Table 1, Model 4 (note: uses mean COPDAB scale with missing data coded as zero and the scale flipped so positive (1) represents a situation where the mean of the events was positive and a negative (-1) represents a situation where the mean of events was negative. Model estimated only in 1966-1992 due to limitation of COPDAB/WEIS spliced data that Clayton gave me.
ologit gscaleord rboyrsum2 infoexchangeyrsum2 monitoringyrsum2 enforcementyrsum2 conflictresolutionyrsum2  icowsal relcaps recmidwt upstreampower downstreampower if year>1965 & year<1993, cluster(dyad)

*Adding post 1997 dummy to the models
*Table 1, Model 1
logit midissyr rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower dummy1997 if year>1944, cluster(dyad)
*Table 1, Model 2
logit attbilat rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower dummy1997 if year>1944, cluster(dyad)
*Table 1, Model 3
logit att3rd rbo2 infoexchange2 monitoring2 enforcement2 conflictresolution2 icowsal relcaps recmidwt upstreampower downstreampower dummy1997 if year>1944, cluster(dyad)

