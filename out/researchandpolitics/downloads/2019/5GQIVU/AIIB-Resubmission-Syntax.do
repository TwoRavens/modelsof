log using "E:\SanDiskSecureAccessV2.0\2017-08-27-ViniciusPenDrive\MainFiles\2017\02-AIIB\Data\AIIB-Resubmission-Log.smcl", replace
*/ opening the dataset /*
use "E:\SanDiskSecureAccessV2.0\2017-08-27-ViniciusPenDrive\MainFiles\2017\02-AIIB\Data\AIIB-ForResubmission.dta", clear
*/  we start by running models reported on table 1. Let's begin by model 1 /*
logit aiibmou usalignment chinaalignment polity2 adbmember usmilitaryalliance gdppercapita distancetobeijing
*/ we now generate the output of model 1 to table 1 /*
outreg2 using table1.doc
*/ we now run model 2, ignoring political alignment and using only the variables on exports /*
logit aiibmou exportstous exportstochina polity2 adbmember usmilitaryalliance gdppercapita distancetobeijing
*/ we now generate the output of model 2 to table 1 /*
outreg2 using table1.doc
*/ we now run model 3, considering both political alignment and the variables on exports to the US and China/*
logit aiibmou usalignment chinaalignment exportstous exportstochina polity2 adbmember usmilitaryalliance gdppercapita distancetobeijing
*/ we now generate the output of model 3 to table 1 /*
outreg2 using table1.doc
*/ we reduce the sample to Asia Pacific countries only to verify whether the effects hold /*
*/ this is necessary as, in fact, only countries in that region signed the AIIB memorandum of understanding (MoU) in 2014 /*
keep if asiapacific==1
*/ we now run model 4, considering only political alignment/*
logit aiibmou usalignment chinaalignment polity2 adbmember usmilitaryalliance gdppercapita distancetobeijing
*/ we now generate the output of model 4 to table 1 /*
outreg2 using table1.doc
*/ we now run model 5, ignoring political alignment and using only the variables on exports /*
logit aiibmou exportstous exportstochina polity2 adbmember usmilitaryalliance gdppercapita distancetobeijing
*/ we now generate the output of model 5 to table 1 /*
outreg2 using table1.doc
*/ we now run model 6, considering both political alignment and the variables on exports to the US and China/*
logit aiibmou usalignment chinaalignment exportstous exportstochina polity2 adbmember usmilitaryalliance gdppercapita distancetobeijing
*/ we now generate the output of model 6 to table 1 /*
outreg2 using table1.doc
*/ let's close the dataset and reopen it to have all observations available. They are necessary for generating the results reported in table 2 /*
clear
use "E:\SanDiskSecureAccessV2.0\2017-08-27-ViniciusPenDrive\MainFiles\2017\02-AIIB\Data\AIIB-ForResubmission.dta", clear
*/  Let's begin by model 1 of table 2. With such a purpose, we delete data on states that signed the MoU /*
*/The goal is to assess what led states to be later joiners to the project/*
keep if aiibmou==0
logit aiibmember usalignment chinaalignment polity2 adbmember usmilitaryalliance gdppercapita distancetobeijing asiapacific
*/ we now generate the output of model 1 to table 2 /*
outreg2 using table2.doc
*/ we now run model 2, ignoring political alignment and using only the variables on exports /*
logit aiibmember exportstous exportstochina polity2 adbmember usmilitaryalliance gdppercapita distancetobeijing asiapacific
*/ we now generate the output of model 2 to table 2 /*
outreg2 using table2.doc
*/ we now run model 3, considering both political alignment and the variables on exports to the US and China/*
logit aiibmember usalignment chinaalignment exportstous exportstochina polity2 adbmember usmilitaryalliance gdppercapita distancetobeijing asiapacific
*/ we now generate the output of model 3 to table 2 /*
outreg2 using table2.doc
*/ we now make a robustness check by considering only AIIB non-regional members. The goal is to assess whether ADB non-regional members--democratic, Western U.S.-allies--joined the AIIB with the same status /*
clear
use "E:\SanDiskSecureAccessV2.0\2017-08-27-ViniciusPenDrive\MainFiles\2017\02-AIIB\Data\AIIB-ForResubmission.dta", clear
keep if aiibmember==1
*/we then consider only the sample of AIIB members/*
*/due to the small number of observations, we ignore variables that did not show much significance in previous models/*
logit aiibnonregionalmember usalignment chinaalignment  polity2 usmilitaryalliance gdppercapita distancetobeijing adbnonregionalmember
*/ we now generate the output of model 4 to table 2 /*
outreg2 using table2.doc
*/ we now close the dataset and open it again to assess hypothesis 2b, on AIIB membership considering both early and late joiners/*
clear
use "E:\SanDiskSecureAccessV2.0\2017-08-27-ViniciusPenDrive\MainFiles\2017\02-AIIB\Data\AIIB-ForResubmission.dta", clear
logit aiibmember usalignment chinaalignment exportstous exportstochina polity2 adbmember usmilitaryalliance gdppercapita distancetobeijing asiapacific
*/ we now generate the output of model 5, reported above, to table 2 /*
outreg2 using table2.doc
*/ finally we run model 6, which considers political alignment only /*
logit aiibmember usalignment chinaalignment polity2 adbmember usmilitaryalliance gdppercapita distancetobeijing asiapacific
*/ we now generate the output of model 6, reported above, to table 2 /*
outreg2 using table2.doc
*/ all models have been run. Let's close the dataset /*
clear
log close
