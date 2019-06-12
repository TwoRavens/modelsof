/*    REPLICATION NOTES  
Date:        		29 April 2014
Code Version:		Final Version
Author:      		Findley, Nielson, Sharman
Purpose:     		These files reproduce all results reported in tables for AJPS
					"Causes of Non-Compliance Paper" (Year XXXX; Vol. XX; Issue XX)
Publications:		Paper: "Causes of Non-Compliance.final.29Mar2014.docx"					
					Append: "Appendix.Causes of Non-Compliance.final.29Mar2014.docx"
Data Used:   		Primary data collected by authors
File Names:   		"AJPS Replication Do.29Mar14.do" (file that estimates the models reported in paper)
Input Files:		"Causes of Non-Compliance.Intl.29Mar2014.dta" (Intl data)
					"Causes of Non-Compliance.US.29Mar2014.dta" (US data)
Output Files: 		"Causes of Non-Compliance.29Mar14.smcl"
Machine:     		MGF; Macbook
Version:			Stata 13.1
Preregistration:	Experimental design preregistered with EGAP (www.e-gap.org); 
Replication:		Materials will be availble at http://michael-findley.com
*/


clear
set more off

*NOTE: Need to set path to the folder with the two data files
*cd "CHANGE FILE PATH HERE"

*log using "Causes of Non-Compliance.29Mar14.smcl", replace
use "Causes of Non-Compliance.Intl.29Mar14.dta", clear

///////////////////////////////////////////////////////////////////////////////////////
//	*************************   MAIN PAPER MODELS    ******************************* //
///////////////////////////////////////////////////////////////////////////////////////

*Replicate Table 1: Show raw tabulation counts and pr tests

tab reply oecdvtaxhaven
tab reply oecdvdevelop
ttest reply, by(oecdvtaxhaven)
ttest reply, by(oecdvdevelop)	

tab noncompliant1 oecdvtaxhaven
tab noncompliant1 oecdvdevelop
ttest noncompliant1, by(oecdvtaxhaven)
ttest noncompliant1, by(oecdvdevelop)

tab partcompliant1 oecdvtaxhaven
tab partcompliant1 oecdvdevelop
ttest partcompliant1, by(oecdvtaxhaven)
ttest partcompliant1, by(oecdvdevelop)

tab compliant1 oecdvtaxhaven
tab compliant1 oecdvdevelop
ttest compliant1, by(oecdvtaxhaven)
ttest compliant1, by(oecdvdevelop)

tab refusal1 oecdvtaxhaven
tab refusal1 oecdvdevelop
ttest refusal1, by(oecdvtaxhaven)
ttest refusal1, by(oecdvdevelop)


*Replicate Table 2: Show raw tabulation counts and pr tests

tab reply fatfcompare
tab reply premiumcompare
tab reply corruptioncompare
tab reply terrorcompare
prtest reply, by(fatfcompare)
prtest reply, by(premiumcompare)
prtest reply, by(corruptioncompare)
prtest reply, by(terrorcompare)

tab noncompliant1 fatfcompare
tab noncompliant1 premiumcompare
tab noncompliant1 corruptioncompare
tab noncompliant1 terrorcompare
prtest noncompliant1, by(fatfcompare)
prtest noncompliant1, by(premiumcompare)
prtest noncompliant1, by(corruptioncompare)
prtest noncompliant1, by(terrorcompare)

tab partcompliant1 fatfcompare
tab partcompliant1 premiumcompare
tab partcompliant1 corruptioncompare
tab partcompliant1 terrorcompare
prtest partcompliant1, by(fatfcompare)
prtest partcompliant1, by(premiumcompare)
prtest partcompliant1, by(corruptioncompare)
prtest partcompliant1, by(terrorcompare)

tab compliant1 fatfcompare
tab compliant1 premiumcompare
tab compliant1 corruptioncompare
tab compliant1 terrorcompare
prtest compliant1, by(fatfcompare)
prtest compliant1, by(premiumcompare)
prtest compliant1, by(corruptioncompare)
prtest compliant1, by(terrorcompare)

tab refusal1 fatfcompare
tab refusal1 premiumcompare
tab refusal1 corruptioncompare
tab refusal1 terrorcompare
prtest refusal1, by(fatfcompare)
prtest refusal1, by(premiumcompare)
prtest refusal1, by(corruptioncompare)
prtest refusal1, by(terrorcompare)


*Replicate Table 3: Show predicted probabilities from multinomial models
*Users will need to "ssc install spost9_ado" in order to run the "prvalue" command

mprobit multioutcome fatfcompare companytype1 OECDDum TaxHaven, cluster(id_number) base(0)
quietly prvalue, x(fatfcompare=0) rest(median) save
prvalue, x(fatfcompare=1) rest(median) diff

mprobit multioutcome premiumcompare companytype1 OECDDum TaxHaven, cluster(id_number) base(0)
quietly prvalue, x(premiumcompare=0) rest(median) save
prvalue, x(premiumcompare=1) rest(median) diff

mprobit multioutcome corruptioncompare companytype1 OECDDum TaxHaven, cluster(id_number) base(0)
quietly prvalue, x(corruptioncompare=0) rest(median) save
prvalue, x(corruptioncompare=1) rest(median) diff

mprobit multioutcome terrorcompare companytype1 OECDDum TaxHaven, cluster(id_number) base(0)
quietly prvalue, x(terrorcompare=0) rest(median) save
prvalue, x(terrorcompare=1) rest(median) diff


*Replicate Table 4: Show raw tabulation counts and pr tests for U.S. sample

use "Causes of Non-Compliance.US.29Mar14.dta", clear

tab reply fatfcompare
tab reply irscompare
tab reply corruptioncompare
tab reply terrorcompare
prtest reply, by(fatfcompare)
prtest reply, by(irscompare)
prtest reply, by(corruptioncompare)
prtest reply, by(terrorcompare)

tab noncompliant1 fatfcompare
tab noncompliant1 irscompare
tab noncompliant1 corruptioncompare
tab noncompliant1 terrorcompare
prtest noncompliant1, by(fatfcompare)
prtest noncompliant1, by(irscompare)
prtest noncompliant1, by(corruptioncompare)
prtest noncompliant1, by(terrorcompare)

tab partcompliant1 fatfcompare
tab partcompliant1 irscompare
tab partcompliant1 corruptioncompare
tab partcompliant1 terrorcompare
prtest partcompliant1, by(fatfcompare)
prtest partcompliant1, by(irscompare)
prtest partcompliant1, by(corruptioncompare)
prtest partcompliant1, by(terrorcompare)

tab compliant1 fatfcompare
tab compliant1 irscompare
tab compliant1 corruptioncompare
tab compliant1 terrorcompare
prtest compliant1, by(fatfcompare)
prtest compliant1, by(irscompare)
prtest compliant1, by(corruptioncompare)
prtest compliant1, by(terrorcompare)

tab refusal1 fatfcompare
tab refusal1 irscompare
tab refusal1 corruptioncompare
tab refusal1 terrorcompare
prtest refusal1, by(fatfcompare)
prtest refusal1, by(irscompare)
prtest refusal1, by(corruptioncompare)
prtest refusal1, by(terrorcompare)


*Replicate Table 5: Show predicted probabilities from multinomial models for U.S. sample

mprobit multioutcome fatfcompare companytype1 easybiz mediumbiz, cluster(id_number) base(0)
quietly prvalue, x(fatfcompare=0) rest(median) save
prvalue, x(fatfcompare=1) rest(median) diff

mprobit multioutcome irscompare companytype1 easybiz mediumbiz, cluster(id_number) base(0)
quietly prvalue, x(irscompare=0) rest(median) save
prvalue, x(irscompare=1) rest(median) diff

mprobit multioutcome corruptioncompare companytype1 easybiz mediumbiz, cluster(id_number) base(0)
quietly prvalue, x(corruptioncompare=0) rest(median) save
prvalue, x(corruptioncompare=1) rest(median) diff

mprobit multioutcome terrorcompare companytype1 easybiz mediumbiz, cluster(id_number) base(0)
quietly prvalue, x(terrorcompare=0) rest(median) save
prvalue, x(terrorcompare=1) rest(median) diff



///////////////////////////////////////////////////////////////////////////////////////
//	*************************    APPENDIX MODELS     ******************************* //
///////////////////////////////////////////////////////////////////////////////////////


*Replicate Table A1: Results based on pre-registration document

*Intl Sample
use "Causes of Non-Compliance.Intl.29Mar14.dta", clear

tab reply fatfcompare
tab reply premiumcompare
tab reply corruptioncompare
tab reply terrorcompare

ttest reply, by(fatfcompare)
ttest reply, by(premiumcompare)
ttest reply, by(corruptioncompare)
ttest reply, by(terrorcompare)
	
tab comply3 fatfcompare
tab comply3 premiumcompare
tab comply3 corruptioncompare
tab comply3 terrorcompare
	
ttest comply3, by(fatfcompare)
ttest comply3, by(premiumcompare)
ttest comply3, by(corruptioncompare)
ttest comply3, by(terrorcompare)

*U.S. Sample
use "Causes of Non-Compliance.US.29Mar14.dta", clear

tab reply fatfcompare
tab reply irscompare
tab reply corruptioncompare
tab reply terrorcompare

ttest reply, by(fatfcompare)
ttest reply, by(irscompare)
ttest reply, by(corruptioncompare)
ttest reply, by(terrorcompare)
	
tab comply3 fatfcompare
tab comply3 irscompare
tab comply3 corruptioncompare
tab comply3 terrorcompare
	
ttest comply3, by(fatfcompare)
ttest comply3, by(irscompare)
ttest comply3, by(corruptioncompare)
ttest comply3, by(terrorcompare)


*Replicate Table B1-B5: Multinomial outcomes rotating base condition

*Intl Sample
use "Causes of Non-Compliance.Intl.29Mar14.dta", clear

mprobit multioutcome fatfcompare, cluster(id_number) base(0)
mprobit multioutcome premiumcompare, cluster(id_number) base(0)
mprobit multioutcome corruptioncompare, cluster(id_number) base(0)
mprobit multioutcome terrorcompare, cluster(id_number) base(0)

mprobit multioutcome fatfcompare, cluster(id_number) base(1)
mprobit multioutcome premiumcompare, cluster(id_number) base(1)
mprobit multioutcome corruptioncompare, cluster(id_number) base(1)
mprobit multioutcome terrorcompare, cluster(id_number) base(1)

mprobit multioutcome fatfcompare, cluster(id_number) base(2)
mprobit multioutcome premiumcompare, cluster(id_number) base(2)
mprobit multioutcome corruptioncompare, cluster(id_number) base(2)
mprobit multioutcome terrorcompare, cluster(id_number) base(2)

mprobit multioutcome fatfcompare, cluster(id_number) base(3)
mprobit multioutcome premiumcompare, cluster(id_number) base(3)
mprobit multioutcome corruptioncompare, cluster(id_number) base(3)
mprobit multioutcome terrorcompare, cluster(id_number) base(3)

mprobit multioutcome fatfcompare, cluster(id_number) base(4)
mprobit multioutcome premiumcompare, cluster(id_number) base(4)
mprobit multioutcome corruptioncompare, cluster(id_number) base(4)
mprobit multioutcome terrorcompare, cluster(id_number) base(4)

*Replicate Table B6: Multinomial outcomes with 9 outcomes
mprobit multioutcome9 fatfcompare, cluster(id_number) base(0) 
mprobit multioutcome9 premiumcompare, cluster(id_number) base(0) 
mprobit multioutcome9 corruptioncompare, cluster(id_number) base(0) 
mprobit multioutcome9 terrorcompare, cluster(id_number) base(0) 

*Replicate Table B7: Multinomial outcomes with letter fixed effects
mlogit multioutcome fatfcompare letter1*, cluster(id_number) base(0)
mlogit multioutcome premiumcompare letter1*, cluster(id_number) base(0)
mlogit multioutcome corruptioncompare letter1*, cluster(id_number) base(0)
mlogit multioutcome terrorcompare letter1*, cluster(id_number) base(0)

*Replicate Table B8: Multinomial logit with covariates
mlogit multioutcome fatfcompare companytype1 OECDDum TaxHaven, cluster(id_number) base(0)
mlogit multioutcome premiumcompare companytype1 OECDDum TaxHaven, cluster(id_number) base(0)
mlogit multioutcome corruptioncompare companytype1 OECDDum TaxHaven, cluster(id_number) base(0)
mlogit multioutcome terrorcompare companytype1 OECDDum TaxHaven, cluster(id_number) base(0)


*Replicate Table C1: Response and compliance rates dichotomized
tab reply fatfcompare
tab reply premiumcompare
tab reply corruptioncompare
tab reply terrorcompare

ttest reply, by(fatfcompare)
ttest reply, by(premiumcompare)
ttest reply, by(corruptioncompare)
ttest reply, by(terrorcompare)
	
tab comply3 fatfcompare
tab comply3 premiumcompare
tab comply3 corruptioncompare
tab comply3 terrorcompare
	
ttest comply3, by(fatfcompare)
ttest comply3, by(premiumcompare)
ttest comply3, by(corruptioncompare)
ttest comply3, by(terrorcompare)


*Replicate Table C2: Estimate a selection model
sartsel sartoricomply fatfcompare companytype1 OECDDum TaxHaven, corr(1)
sartsel sartoricomply premiumcompare companytype1 OECDDum TaxHaven, corr(1)
sartsel sartoricomply corruptioncompare companytype1 OECDDum TaxHaven, corr(1)
sartsel sartoricomply terrorcompare companytype1 OECDDum TaxHaven, corr(1)


*Replicate Table C3: Estimate a nested logit model

logit reply fatfcompare, r
mlogit multioutcomenest fatfcompare, r base(0)

logit reply premiumcompare, r
mlogit multioutcomenest premiumcompare, r base(0)

logit reply corruptioncompare, r
mlogit multioutcomenest corruptioncompare, r base(0)

logit reply terrorcompare, r
mlogit multioutcomenest terrorcompare, r base(0)


*Replicate Table D1: Multinomial probit results for U.S.

use "Causes of Non-Compliance.US.29Mar14.dta", clear

mprobit multioutcome fatfcompare, cluster(id_number) base(0)
mprobit multioutcome irscompare, cluster(id_number) base(0)
mprobit multioutcome corruptioncompare, cluster(id_number) base(0)
mprobit multioutcome terrorcompare , cluster(id_number) base(0)

*Replicate Table D2: Multinomial logit with covariates for U.S.

mlogit multioutcome fatfcompare companytype1 ca nv de wy easybiz mediumbiz , cluster(id_number) base(0)
mlogit multioutcome irscompare companytype1 ca nv de wy easybiz mediumbiz, cluster(id_number) base(0)
mlogit multioutcome corruptioncompare companytype1 ca nv de wy easybiz mediumbiz, cluster(id_number) base(0)
mlogit multioutcome terrorcompare companytype1 ca nv de wy easybiz mediumbiz, cluster(id_number) base(0)

*Replicate Table D3: Selection model for U.S. sample

*each of these for Table D4
sartsel sartoricomply fatfcompare companytype1 easybiz mediumbiz, corr(1)
sartsel sartoricomply irscompare companytype1 easybiz mediumbiz, corr(1)
sartsel sartoricomply corruptioncompare companytype1 easybiz mediumbiz, corr(1)
sartsel sartoricomply terrorcompare companytype1 easybiz mediumbiz, corr(1)

