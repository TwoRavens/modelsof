clear *

// pull together wmp & bonica variables
do makeCmagAndIdeologyData

// creates hitlevel_work1.dta (one observation per coder per ad)
do makeHitLevelData

// creates codelevel_work1.dta (one observation per coding decision)
do makeCodeLevelData

// creates validity_dataset.dta (with validity measures)
do makeValidityData

// Dataset with 2016 ANES for coder :: American public appendix table
do makeAnesWorkerComparisonDataset
