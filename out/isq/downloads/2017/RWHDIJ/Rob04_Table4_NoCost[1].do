/*
Do file for replicating the results of Table 4 in Appendix F
using a Cox model
*/

use "Lektzian_Patterson_Political_Cleavages_and_Economic_Sanctions.dta", clear

* Changes in the abundant relative to other factors
	logit successMBK TradeOpenPKM CdAbtoMdSc TOPKMCdAbtoMdSc  ///
	numsansenders USSen MZTotMIDCountTS  ///
	ATatopallyTSP Inst POLpolity2 time time2 time3 , cluster(caseid)

* Changes in the scarce relative to other factors
	logit successMBK TradeOpenPKM CdSctoAbMd TOPKMCdSctoAbMd  ///
	numsansenders USSen MZTotMIDCountTS    ///
	ATatopallyTSP Inst POLpolity2 time time2 time3 , cluster(caseid)

exit
