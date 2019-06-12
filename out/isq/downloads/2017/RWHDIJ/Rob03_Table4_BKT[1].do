/*
Do file for replicating the results of Table 4 in Appendix E
using a Cox model
*/

use "Lektzian_Patterson_Political_Cleavages_and_Economic_Sanctions.dta", clear

* Changes in the abundant relative to other factors
	logit successMBK TradeOpenPKM CdAbtoMdSc TOPKMCdAbtoMdSc  ///
	STEcCstMS numsansenders USSen MZTotMIDCountTS  ///
	ATatopallyTSP Inst POLpolity2 failyearsMBK sp1failyearsMBK sp2failyearsMBK ///
	sp3failyearsMBK, cluster(caseid)

* Changes in the scarce relative to other factors
	logit successMBK TradeOpenPKM CdSctoAbMd TOPKMCdSctoAbMd  ///
	STEcCstMS numsansenders USSen MZTotMIDCountTS    ///
	ATatopallyTSP Inst POLpolity2 failyearsMBK ///
	sp1failyearsMBK sp2failyearsMBK sp3failyearsMBK , cluster(caseid)

exit
