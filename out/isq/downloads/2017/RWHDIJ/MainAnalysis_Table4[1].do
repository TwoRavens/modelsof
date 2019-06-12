* Do file for replicating the results of Table 4

* Changes in the abundant relative to other factors
use "Lektzian_Patterson_Political_Cleavages_and_Economic_Sanctions.dta", clear

	* Sanction Years Data
		logit successMBK TradeOpenPKM CdAbtoMdSc TOPKMCdAbtoMdSc  ///
		STEcCstMS numsansenders USSen MZTotMIDCountTS  ///
		ATatopallyTSP Inst POLpolity2 time time2 time3 , cluster(caseid)

	* Sanction Case Data
		keep if sanendyear==1
		logit successMBK TradeOpenPKM CdAbtoMdSc TOPKMCdAbtoMdSc  ///
		STEcCstMS numsansenders USSen MZTotMIDCountTS  ///
		ATatopallyTSP Inst POLpolity2 time, cluster(caseid)
	
* Changes in the scarce relative to other factors
* need to reopen the data before running this model
use "Lektzian_Patterson_Political_Cleavages_and_Economic_Sanctions.dta", clear

	* Sanction Years Data
		logit successMBK TradeOpenPKM CdSctoAbMd TOPKMCdSctoAbMd  ///
		STEcCstMS numsansenders USSen MZTotMIDCountTS    ///
		ATatopallyTSP Inst POLpolity2 time time2 time3 , cluster(caseid)

	* Sanction Case Data
		keep if sanendyear==1
		logit successMBK TradeOpenPKM CdSctoAbMd TOPKMCdSctoAbMd  ///
		STEcCstMS numsansenders USSen MZTotMIDCountTS    ///
		ATatopallyTSP Inst POLpolity2 time, cluster(caseid)

exit
