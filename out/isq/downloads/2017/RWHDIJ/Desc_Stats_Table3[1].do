* Reproducing some descriptive statistics and Table 3

use "Lektzian_Patterson_Political_Cleavages_and_Economic_Sanctions.dta", clear

* Some simple descriptive statistics
* Run the model to establish the sample
logit successMBK TradeOpenPKM CdAbtoMdSc TOPKMCdAbtoMdSc  ///
STEcCstMS numsansenders USSen MZTotMIDCountTS  ///
ATatopallyTSP Inst POLpolity2 time time2 time3 , cluster(caseid)

* Overall rate of success in the sample 
* Count Successes
count if successMBK==0 & sanendyear==1 & year!=2005 & e(sample)==1
* Count Failures
count if successMBK==1 & sanendyear==1  & e(sample)==1


* Number of individual countries  targeted by sanctions (85), 

codebook target if SInit==1 & e(sample)==1, tab(100)  

* Create Table 3: Descriptive Statistics for Sanctions Years
	logit successMBK TradeOpenPKM CdAbtoMdSc TOPKMCdAbtoMdSc  ///
	STEcCstMS numsansenders USSen MZTotMIDCountTS  ///
	ATatopallyTSP Inst POLpolity2 time time2 time3 , cluster(caseid)

	sum success TradeOpenPKM CdAbtoMdSc CdSctoAbMd ///
	STEcCstMS numsansenders USSen MZTotMIDCountTS    ///
	ATatopallyTSP Inst POLpolity2 time time2 time3 if e(sample)==1

* Create Table 3: Descriptive Statistics for Sanctions Cases
	keep if sanendyear==1

	logit successMBK TradeOpenPKM CdAbtoMdSc TOPKMCdAbtoMdSc  ///
	STEcCstMS numsansenders USSen MZTotMIDCountTS  ///
	ATatopallyTSP Inst POLpolity2 time time2 time3 , cluster(caseid)

	sum success TradeOpenPKM CdAbtoMdSc CdSctoAbMd ///
	STEcCstMS numsansenders USSen MZTotMIDCountTS    ///
	ATatopallyTSP Inst POLpolity2 time time2 time3 if e(sample)==1
	
exit














