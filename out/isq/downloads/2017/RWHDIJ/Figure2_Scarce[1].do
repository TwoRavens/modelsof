* Produces Figure 2: Cum Change in Scarce to non-Scarce Factors
* For High Cost Sanction Years
clear all
use "Lektzian_Patterson_Political_Cleavages_and_Economic_Sanctions.dta", clear
*First we fit the model:

logit successMBK TradeOpenPKM CdSctoAbMd TOPKMCdSctoAbMd  ///
STEcCstMS numsansenders USSen MZTotMIDCountTS    ///
ATatopallyTSP Inst POLpolity2 time time2 time3 , cluster(caseid)

/*
Next we compute the predicted value of success as the change in 
capital abundance increases for trade open countries that  
are average on all other characteristics.  We do this using forvalues 
to make several calls to prvalue and praccum.  For non trade open 
countries TOPKMCdAbtoMdSc is always 0 because TradeOpenPKM is 0.
*/

sum CdSctoAbMd if e(sample)==1, detail

forvalues count = -7.060539(.25)7.739103 {
	quietly prvalue, x(TradeOpenPKM=0 CdSctoAbMd=`count' TOPKMCdSctoAbMd=0 ///
	Inst=1 STEcCstMS=1 USSen=1 ATatopallyTSP=0 numsansenders=1 MZTotMIDCountTS=0) rest(mean) 
	praccum, using(mat_nto) xis(`count')
}
praccum, using(mat_nto) gen(pnto)

/*
The using() after praccum specifies a name for a matrix to add additional 
predictions.  xis indicates the value of the x variable associated with 
the predicted values that are accumulated.  In the calls to prvalue, only 
the variable CHKR is changing so we could have used prgen.  But for the 
capital abundant countries we must use praccum because both CHKR and KACHKR 
change together:
*/

forvalues count = -7.060539(.25)7.739103 {
	quietly prvalue, x(TradeOpenPKM=1 CdSctoAbMd=`count' TOPKMCdSctoAbMd=`count' ///
	Inst=1 STEcCstMS=1 USSen=1 ATatopallyTSP=0 numsansenders=1 MZTotMIDCountTS=0) rest(mean) 
	praccum, using(mat_to) xis(`count')
 }
praccum, using(mat_to) gen(pto)

/*
In this case, changes in capital ratio, as specified with xis(), are stored 
in pncax and pcax.  These variables will be identical because we used the 
same levels for both trade closed and non trade closed countries.  
The probability of success for non trade closed countries is contained 
in the variable pncap1.  The predictions for capital abundant countries are 
stored in pcap1.  Now we just have to clean up the variable labels and plot 
the predictions.
*/

label var pntop1 "Pr(success|Trade closed)"
label var ptop1 "Pr(success|Trade open)"
label var pntox "Cumulative Change in Scarce to non-Scarce Factors"

graph twoway connected ptop1 pntop1  pntox, ///
lpattern(l ##_##-##_##) msymbol(i i) lwidth(medthick medthick) xlabel(-7(1)8) ylabel(0(.25)1) ///
caption("High Cost Sanctions", ring(0) position(20) bmargin("2 0 2 0") justification(center) size(med) ) ///
ytitle("Probability of success" "(Sanction Years)") 

graph save Graph "Scarce-nonScarce-Years-HighCost.gph", replace

drop pntox pntop0 pntop1 ptox ptop0 ptop1

/*
The following steps repeat for each quadrant of Figure 1.  Thus I show the code
for producing each quadrant, but do not repeat the annotation as it is 
identical to that above.
*/

********************************************************************************
* For Low Cost Sanction Years
clear all
use "Lektzian_Patterson_Political_Cleavages_and_Economic_Sanctions.dta", clear

	logit successMBK TradeOpenPKM CdSctoAbMd TOPKMCdSctoAbMd  ///
	STEcCstMS numsansenders USSen MZTotMIDCountTS    ///
	ATatopallyTSP Inst POLpolity2 time time2 time3 , cluster(caseid)


sum CdSctoAbMd, detail

forvalues count = -7.060539(.25)7.739103 {
	quietly prvalue, x(TradeOpenPKM=0 CdSctoAbMd=`count' TOPKMCdSctoAbMd=0 ///
	Inst=1 STEcCstMS=0 USSen=1 ATatopallyTSP=0 numsansenders=1 MZTotMIDCountTS=0) rest(mean) 
	praccum, using(mat_nto) xis(`count')
}
praccum, using(mat_nto) gen(pnto)

forvalues count = -7.060539(.25)7.739103 {
	quietly prvalue, x(TradeOpenPKM=1 CdSctoAbMd=`count' TOPKMCdSctoAbMd=`count' ///
	Inst=1 STEcCstMS=0 USSen=1 ATatopallyTSP=0 numsansenders=1 MZTotMIDCountTS=0) rest(mean) 
	praccum, using(mat_to) xis(`count')
 }
praccum, using(mat_to) gen(pto)

label var pntop1 "Pr(success|Trade Closed)"
label var ptop1 "Pr(success|Trade Open)"
label var pntox "Cumulative Change in Scarce to non-Scarce Factors"

graph twoway connected ptop1 pntop1 pntox, ///
lpattern(l ##_##-##_##) msymbol(i i) lwidth(medthick medthick) xlabel(-7(1)8) ylabel(0(.25)1) ///
caption("Low Cost Sanctions", ring(0) position(20) bmargin("2 0 2 0") justification(center) size(med) ) ///
ytitle("Probability of success" "(Sanction Years)") 

graph save Graph "Scarce-nonScarce-Years-LowCost.gph", replace

drop pntox pntop0 pntop1 ptox ptop0 ptop1

*******************************************************************************
* For High Cost Sanction Cases

clear all
use "Lektzian_Patterson_Political_Cleavages_and_Economic_Sanctions.dta", clear

keep if sanendyear==1

	logit successMBK TradeOpenPKM CdSctoAbMd TOPKMCdSctoAbMd  ///
	STEcCstMS numsansenders USSen MZTotMIDCountTS    ///
	ATatopallyTSP Inst POLpolity2 time , cluster(caseid)


sum CdSctoAbMd if e(sample)==1 & TradeOpenPKM==1, detail

forvalues count = -5.573934(.25)7.739103 {
	quietly prvalue, x(TradeOpenPKM=0 CdSctoAbMd=`count' TOPKMCdSctoAbMd=0 ///
	Inst=1 STEcCstMS=1 USSen=1 ATatopallyTSP=0 MZTotMIDCountTS=0) rest(mean) 
	praccum, using(mat_nto) xis(`count')
}
praccum, using(mat_nto) gen(pnto)

forvalues count = -5.573934(.25)7.739103 {
	quietly prvalue, x(TradeOpenPKM=1 CdSctoAbMd=`count' TOPKMCdSctoAbMd=`count' ///
	Inst=1 STEcCstMS=1 USSen=1 ATatopallyTSP=0 MZTotMIDCountTS=0) rest(mean) 
	praccum, using(mat_to) xis(`count')
 }
praccum, using(mat_to) gen(pto)

label var pntop1 "Pr(success|Trade Closed)"
label var ptop1 "Pr(success|Trade open)"
label var pntox "Cumulative Change in Scarce to non-Scarce Factors"

graph twoway connected ptop1 pntop1 pntox, ///
lpattern(l ##_##-##_##) msymbol(i i) lwidth(medthick medthick) xlabel(-6(1)8) ylabel(0(.2)1) ///
caption("High Cost Sanctions", ring(0) position(20) bmargin("2 0 2 0") justification(center) size(med) ) ///
ytitle("Probability of success" "(Sanction Cases)") 


graph save Graph "Scarce-nonScarce-Cases-HighCost.gph", replace

drop pncax pntop0 pntop1 ptox ptop0 ptop1

********************************************************************************
* For Low Cost Sanction Cases

clear all
use "Lektzian_Patterson_Political_Cleavages_and_Economic_Sanctions.dta", clear

keep if sanendyear==1

	logit successMBK TradeOpenPKM CdSctoAbMd TOPKMCdSctoAbMd  ///
	STEcCstMS numsansenders USSen MZTotMIDCountTS    ///
	ATatopallyTSP Inst POLpolity2 time , cluster(caseid)

sum CdSctoAbMd, detail

forvalues count = -5.573934(.25)7.739103 {
	quietly prvalue, x(TradeOpenPKM=0 CdSctoAbMd=`count' TOPKMCdSctoAbMd=0 ///
	Inst=1 STEcCstMS=0 USSen=1 ATatopallyTSP=0 MZTotMIDCountTS=0) rest(mean) 
	praccum, using(mat_nto) xis(`count')
}
praccum, using(mat_nto) gen(pnto)


forvalues count = -5.573934(.25)7.739103 {
	quietly prvalue, x(TradeOpenPKM=1 CdSctoAbMd=`count' TOPKMCdSctoAbMd=`count' ///
	Inst=1 STEcCstMS=0 USSen=1 ATatopallyTSP=0 MZTotMIDCountTS=0) rest(mean) 
	praccum, using(mat_to) xis(`count')
 }
praccum, using(mat_to) gen(pto)


label var pntop1 "Pr(success|Trade Closed)"
label var ptop1 "Pr(success|Trade open)"
label var pntox "Cumulative Change in Scarce to non-Scarce Factors"

graph twoway connected ptop1 pntop1 pntox, ///
lpattern(l ##_##-##_##) msymbol(i i) lwidth(medthick medthick) xlabel(-6(1)8) ylabel(0(.2)1) ///
caption("Low Cost Sanctions", ring(0) position(20) bmargin("2 0 2 0") justification(center) size(med) ) ///
ytitle("Probability of success" "(Sanction Cases)") 


graph save Graph "Scarce-nonScarce-Cases-LowCost.gph", replace

drop pntox pntop0 pntop1 ptox ptop0 ptop1
