/*
Do file for replicating the results of Table 4 in Appendix D
using a Cox model
*/

use "Lektzian_Patterson_Political_Cleavages_and_Economic_Sanctions.dta", clear

* Changes in the abundant relative to other factors
	stset santime, failure(failureMBK== 1) id(caseid)  exit(failureMBK== 1), 
	stcox TradeOpenPKM CdAbtoMdSc TOPKMCdAbtoMdSc  ///
	STEcCstMS numsansenders USSen MZTotMIDCountTS  ///
	ATatopallyTSP Inst POLpolity2, vce(cluster caseid) nohr
	
* Changes in the scarce relative to other factors
use "Lektzian_Patterson_Political_Cleavages_and_Economic_Sanctions.dta", clear
	stset santime, failure(failureMBK== 1 ) id(caseid)  exit(failureMBK== 1), 
	stcox TradeOpenPKM CdSctoAbMd TOPKMCdSctoAbMd  ///
	STEcCstMS numsansenders USSen MZTotMIDCountTS    ///
	ATatopallyTSP Inst POLpolity2, vce(cluster caseid) nohr

exit
