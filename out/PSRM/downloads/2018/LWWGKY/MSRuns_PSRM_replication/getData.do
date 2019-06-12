clear *

// combine and anonymize survey data
//  --> rawLimesurveyData/rawCodingData
//  --> rawLimesurveyData/workerInfo
do notForUpload/preProcessForReplication

*************************************************
* mTurk ad coding data cleanup
*************************************************
clear *

// creates hitlevel_work1.dta
do makeHitLevelData
// creates codelevel_work1.dta
do makeCodeLevelData

// creates adlevel_work1.dta
// do makeAdlevel.do

// creates validity_dataset.dta
do makeValidityData.do

exit
