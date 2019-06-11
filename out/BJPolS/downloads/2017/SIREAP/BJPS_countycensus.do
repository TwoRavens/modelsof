

use "BJPS_countycensus.dta", replace

 ******************************************************************************
* Table A6
*******************************************************************************


eststo clear
reg erate1 averlogoilsale1,  robust cluster(ID)
eststo
reg erate1 averloggassale1,  robust cluster(ID)
eststo
reg erate1 averlogoilgassales1,  robust cluster(ID)
eststo

reg erate1 averlogoilsale1 averp_Uighur1 averdensity1,  robust cluster(ID)
eststo
reg erate1 averloggassale1 averp_Uighur1 averdensity1,  robust cluster(ID)
eststo
reg erate1 averlogoilgassales1 averp_Uighur1 averdensity1,  robust cluster(ID)
eststo

reg erate1 averlogoilsale1 averp_Uighur1 averdensity1 averlogrevenue1 averloggrant1 averlogpgdp1 averbingtuan1 slope distance,  robust cluster(ID)
eststo
reg erate1 averloggassale1 averp_Uighur1 averdensity1 averlogrevenue1 averloggrant1 averlogpgdp1 averbingtuan1 slope distance,  robust cluster(ID)
eststo
reg erate1 averlogoilgassales1 averp_Uighur1 averdensity1 averlogrevenue1 averloggrant1 averlogpgdp1 averbingtuan1 slope distance,  robust cluster(ID)
eststo
esttab, se(3) b(3) star(* .1 ** .05 *** .01) tex






 ******************************************************************************
* Table A7
*******************************************************************************


eststo clear
reg demrate averlogoilsale1 averp_Uighur1 averdensity1 averlogrevenue1 averloggrant1 averlogpgdp1 averbingtuan1 slope distance,  robust cluster(ID)
eststo
reg demrate averloggassale1 averp_Uighur1 averdensity1 averlogrevenue1 averloggrant1 averlogpgdp1 averbingtuan1 slope distance,  robust cluster(ID)
eststo
reg demrate averlogoilgassales1 averp_Uighur1 averdensity1 averlogrevenue1 averloggrant1 averlogpgdp1 averbingtuan1 slope distance,  robust cluster(ID)
eststo


reg dhan averlogoilsale1  averdensity1 averlogrevenue1 averloggrant1 averlogpgdp1 averbingtuan1 slope distance,  robust cluster(ID)
eststo
reg dhan averloggassale1 averdensity1 averlogrevenue1 averloggrant1 averlogpgdp1 averbingtuan1 slope distance,  robust cluster(ID)
eststo
reg dhan averlogoilgassales1 averp_Uighur1 averdensity1 averlogrevenue1 averloggrant1 averlogpgdp1 averbingtuan1 slope distance,  robust cluster(ID)
eststo

reg duy averlogoilsale1 averdensity1 averlogrevenue1 averloggrant1 averlogpgdp1 averbingtuan1 slope distance,  robust cluster(ID)
eststo
reg duy averloggassale1 averdensity1 averlogrevenue1 averloggrant1 averlogpgdp1 averbingtuan1 slope distance,  robust cluster(ID)
eststo
reg duy averlogoilgassales1 averp_Uighur1 averdensity1 averlogrevenue1 averloggrant1 averlogpgdp1 averbingtuan1 slope distance,  robust cluster(ID)
eststo
esttab, se(3) b(3) star(* .1 ** .05 *** .01) tex




