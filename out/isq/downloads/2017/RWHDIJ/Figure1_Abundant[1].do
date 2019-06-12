* Produces Figure 1: Cum Change in Abundant to non-abundant factors
* for high cost sanctions using sanction years
clear all
use "Lektzian_Patterson_Political_Cleavages_and_Economic_Sanctions.dta", clear

*First we fit the model:
	logit successMBK TradeOpenPKM CdAbtoMdSc TOPKMCdAbtoMdSc  ///
	STEcCstMS numsansenders USSen MZTotMIDCountTS  ///
	ATatopallyTSP Inst POLpolity2 time time2 time3 , cluster(caseid)

/*
Next we compute the predicted value of success as the change in 
capital abundance increases for trade open countries.  We do this using forvalues 
to make several calls to prvalue and praccum.  For non trade open 
countries TOPKMCdAbtoMdSc is always 0 because TradeOpenPKM is 0.
*/

sum CdAbtoMdSc, detail 
sum CdAbtoMdSc if e(sample)==1 & TradeOpenPKM==1, detail 
sum CdAbtoMdSc if e(sample)==1 & TradeOpenPKM==0, detail 
sum CdAbtoMdSc if e(sample)==1, detail 

/*
We are computing the predicted probabilities for a case where the target is
not an ally, an institution is involved in the sender coalition, the US is 
the sender, the US sanctions unilaterally, and there is no MID.
*/

forvalues count = -3.02(.25)4.96 {
	quietly prvalue, x(TradeOpenPKM=0 CdAbtoMdSc=`count' TOPKMCdAbtoMdSc=0 ///
	Inst=1 STEcCstMS=1 USSen=1 ATatopallyTSP=0  MZTotMIDCountTS=0) rest(mean) 
	praccum, using(mat_nto) xis(`count')
}
praccum, using(mat_nto) gen(pnto)

/*
The using() after praccum specifies a name for a matrix to add additional 
predictions.  xis indicates the value of the x variable associated with 
the predicted values that are accumulated.  In the calls to prvalue, only 
the variable CdAbtoMdSc is changing so we could have used prgen.  But for the 
capital abundant countries we must use praccum because both CdAbtoMdSc and TOPKMCdAbtoMdSc 
change together:
*/

forvalues count = -3.02(.25)4.96 {
	quietly prvalue, x(TradeOpenPKM=1 CdAbtoMdSc=`count' TOPKMCdAbtoMdSc=`count' ///
	Inst=1 STEcCstMS=1 USSen=1 ATatopallyTSP=0 MZTotMIDCountTS=0) rest(mean) 
	praccum, using(mat_to) xis(`count')
 }
praccum, using(mat_to) gen(pto)

/*
In this case, changes in capital ratio, as specified with xis(), are stored 
in pncax and pcax.  These variables will be identical because we used the 
same levels for both capital abundant and non capital abundant countries.  
The probability of success for non capital abundant countries is contained 
in the variable pncap1.  The predictions for capital abundant countries are 
stored in pcap1.  Now we just have to clean up the variable labels and plot 
the predictions.
*/

label var pntop1 "Pr(Success|Trade Closed)"
label var ptop1 "Pr(Success|Trade Open)"
label var pntox "Cumulative Change in Abundant to non-Abundant Factors"

graph twoway connected ptop1 pntop1  pntox, ///
lpattern(l ##_##-##_##) msymbol(i i) lwidth(medthick medthick) xlabel(-3(1)5) ylabel(0(.25)1) ///
caption("High Cost Sanctions", ring(0) position(20) bmargin("2 0 2 0") justification(center) size(med) ) ///
ytitle("Probability of success" "(Sanction Years)") 

graph save Graph "Abundant-nonAbundant-Years-HighCost.gph", replace

drop pntox pntop0 pntop1 ptox ptop0 ptop1

sum CdAbtoMdSc if e(sample)==1, detail

/*
The following steps repeat for each quadrant of Figure 1.  Thus I show the code
for producing each quadrant, but do not repeat the annotation as it is 
identical to that above.
*/

***************************************************************************
* Produces Figure 1: Cum Change in Abundant to non-abundant factors
* for low cost sanctions using sanction years.
  
clear all
use "Lektzian_Patterson_Political_Cleavages_and_Economic_Sanctions.dta", clear

	logit successMBK TradeOpenPKM CdAbtoMdSc TOPKMCdAbtoMdSc  ///
	STEcCstMS numsansenders USSen MZTotMIDCountTS  ///
	ATatopallyTSP Inst POLpolity2 time time2 time3 , cluster(caseid)

forvalues count = -3.02(.25)4.96 {
	quietly prvalue, x(TradeOpenPKM=0 CdAbtoMdSc=`count' TOPKMCdAbtoMdSc=0 ///
	Inst=1 STEcCstMS=0 USSen=1 ATatopallyTSP=0  MZTotMIDCountTS=0) rest(mean) 
	praccum, using(mat_nto) xis(`count')
}
praccum, using(mat_nto) gen(pnto)

forvalues count = -3.02(.25)4.96 {
	quietly prvalue, x(TradeOpenPKM=1 CdAbtoMdSc=`count' TOPKMCdAbtoMdSc=`count' ///
	Inst=1 STEcCstMS=0 USSen=1 ATatopallyTSP=0 MZTotMIDCountTS=0) rest(mean) 
	praccum, using(mat_to) xis(`count')
 }
praccum, using(mat_to) gen(pto)

label var pntop1 "Pr(Success|Trade Closed)"
label var ptop1 "Pr(Success|Trade Open)"
label var pntox "Cumulative Change in Abundant to non-Abundant Factors"

graph twoway connected ptop1 pntop1  pntox, ///
lpattern(l ##_##-##_##) msymbol(i i) lwidth(medthick medthick) xlabel(-3(1)5) ylabel(0(.25)1) ///
caption("Low Cost Sanctions", ring(0) position(20) bmargin("2 0 2 0") justification(center) size(med) ) ///
ytitle("Probability of success" "(Sanction Years)") 

graph save Graph "Abundant-nonAbundant-Years-LowCost.gph", replace

drop pntox pntop0 pntop1 ptox ptop0 ptop1

********************************************************************************
* Produces Figure 1: Cum Change in Abundant to non-abundant factors
* for high cost sanctions using sanction cases
clear all
use "Lektzian_Patterson_Political_Cleavages_and_Economic_Sanctions.dta", clear

keep if sanendyear==1

*First we fit the model:

	logit successMBK TradeOpenPKM CdAbtoMdSc TOPKMCdAbtoMdSc  ///
	STEcCstMS numsansenders USSen MZTotMIDCountTS  ///
	ATatopallyTSP Inst POLpolity2 time time2 time3 , cluster(caseid)

sum CdAbtoMdSc, detail 
sum CdAbtoMdSc if e(sample)==1 & TradeOpenPKM==1, detail 
sum CdAbtoMdSc if e(sample)==1 & TradeOpenPKM==0, detail 
sum CdAbtoMdSc if e(sample)==1, detail 

forvalues count = -3.02(.25)3.61 {
	quietly prvalue, x(TradeOpenPKM=0 CdAbtoMdSc=`count' TOPKMCdAbtoMdSc=0 ///
	Inst=1 STEcCstMS=1 USSen=1 ATatopallyTSP=0 MZTotMIDCountTS=0) rest(mean) 
	praccum, using(mat_nto) xis(`count')
}
praccum, using(mat_nto) gen(pnto)

forvalues count = -3.02(.25)3.61 {
	quietly prvalue, x(TradeOpenPKM=1 CdAbtoMdSc=`count' TOPKMCdAbtoMdSc=`count' ///
	Inst=1 STEcCstMS=1 USSen=1 ATatopallyTSP=0 MZTotMIDCountTS=0) rest(mean) 
	praccum, using(mat_to) xis(`count')
 }
praccum, using(mat_to) gen(pto)

label var pntop1 "Pr(Success|Trade Closed)"
label var ptop1 "Pr(Success|Trade Open)"
label var pntox "Cumulative Change in Abundant to non-Abundant Factors"

graph twoway connected ptop1 pntop1  pntox, ///
lpattern(l ##_##-##_##) msymbol(i i) lwidth(medthick medthick) xlabel(-3(1)4) ylabel(0(.25)1) ///
caption("High Cost Sanctions", ring(0) position(20) bmargin("2 0 2 0") justification(center) size(med) ) ///
ytitle("Probability of success" "(Sanction Cases)") 

graph save Graph "Abundant-nonAbundant-Cases-HighCost.gph", replace

drop pntox pntop0 pntop1 ptox ptop0 ptop1

*******************************************************************************
* Produces Figure 1: Cum Change in Abundant to non-abundant factors
* for low cost sanctions using sanction years

clear all
use "Lektzian_Patterson_Political_Cleavages_and_Economic_Sanctions.dta", clear

keep if sanendyear==1

*First we fit the model:

	logit successMBK TradeOpenPKM CdAbtoMdSc TOPKMCdAbtoMdSc  ///
	STEcCstMS numsansenders USSen MZTotMIDCountTS  ///
	ATatopallyTSP Inst POLpolity2 time time2 time3 , cluster(caseid)

forvalues count = -3.02(.25)3.61 {
	quietly prvalue, x(TradeOpenPKM=0 CdAbtoMdSc=`count' TOPKMCdAbtoMdSc=0 ///
	Inst=1 STEcCstMS=0 USSen=1 ATatopallyTSP=0  MZTotMIDCountTS=0) rest(mean) 
	praccum, using(mat_nto) xis(`count')
}
praccum, using(mat_nto) gen(pnto)

forvalues count = -3.02(.25)3.61 {
	quietly prvalue, x(TradeOpenPKM=1 CdAbtoMdSc=`count' TOPKMCdAbtoMdSc=`count' ///
	Inst=1 STEcCstMS=0 USSen=1 ATatopallyTSP=0 MZTotMIDCountTS=0) rest(mean) 
	praccum, using(mat_to) xis(`count')
 }
praccum, using(mat_to) gen(pto)

label var pntop1 "Pr(Success|Trade Closed)"
label var ptop1 "Pr(Success|Trade Open)"
label var pntox "Cumulative Change in Abundant to non-Abundant Factors"

graph twoway connected ptop1 pntop1  pntox, ///
lpattern(l ##_##-##_##) msymbol(i i) lwidth(medthick medthick) xlabel(-3(1)4) ylabel(0(.25)1) ///
caption("Low Cost Sanctions", ring(0) position(20) bmargin("2 0 2 0") justification(center) size(med) ) ///
ytitle("Probability of success" "(Sanction Cases)") 

graph save Graph "Abundant-nonAbundant-Cases-LowCost.gph", replace

drop pntox pntop0 pntop1 ptox ptop0 ptop1

Exit
