/*JIANG-ZHU Models and predicted probabilities*/
/*This do file should be run when using the dataset JiangZhuReplication.dta*/
/*note: this do file replicates results reported in the ISQ article for the Jiang/Zhu (1998-2002) period.
The first two regressions are those reported in Table 2.
Alternative specification regressions reported in ISQ article follow.
After that, the predicted probabilities reported in the article are generated*/

/*Note that variable names used in the article are presented in the variable labels in the Stata data file*/


/*baseline regression, results reported in Table 2, first column*/

poisson totalPresPremvisits   metalindex lnOil AsiaUSdefense risingpower autocracy  Asia Africa s3un4608i_visUSA_98 usdefense us_sanctions_halftime un_sanctions_halftime lnpop boundarydum lnpci  lnFDIin  lnFDIoutStock

/*use number of days spent in a particular country as DV; results reported in Table 2, second column*/

nbreg totalPresPremDays metalindex lnOil AsiaUSdefense risingpower autocracy  Asia Africa s3un4608i_visUSA_98 usdefense us_sanctions_halftime un_sanctions_halftime lnpop boundarydum lnpci  lnFDIin  lnFDIoutStock


/*Alternative Specifications*/

/*Substitute defense spending in for population*/
poisson totalPresPremvisits   metalindex lnOil AsiaUSdefense risingpower autocracy  Asia Africa s3un4608i_visUSA_98 usdefense us_sanctions_halftime un_sanctions_halftime lnDefensesp98 boundarydum lnpci  lnFDIin  lnFDIoutStock

/*Substitute GDP for population*/
poisson totalPresPremvisits   metalindex lnOil AsiaUSdefense risingpower autocracy  Asia Africa s3un4608i_visUSA_98 usdefense us_sanctions_halftime un_sanctions_halftime lngdp boundarydum lnpci  lnFDIin  lnFDIoutStock

/*Substitute Trade for population*/
poisson totalPresPremvisits   metalindex lnOil AsiaUSdefense risingpower autocracy  Asia Africa s3un4608i_visUSA_98 usdefense us_sanctions_halftime un_sanctions_halftime lnTrade boundarydum lnpci  lnFDIin  lnFDIoutStock

/*use US arms transfers instead of alliance variable; AsiaUSarms is the interactive variable*/
poisson totalPresPremvisits  lnUSarms_98_03 metalindex lnOil AsiaUSarms risingpower autocracy  Asia Africa s3un4608i_visUSA_98 us_sanctions_halftime un_sanctions_halftime lnpop boundarydum lnpci  lnFDIin  lnFDIoutStock

/*use US troops dummy variable instead of alliance variable; AsiaUStroops is the interactive variable*/
poisson totalPresPremvisits   UStroopdummy metalindex lnOil AsiaUStroops risingpower autocracy  Asia Africa s3un4608i_visUSA_98 us_sanctions_halftime un_sanctions_halftime lnpop boundarydum lnpci  lnFDIin  lnFDIoutStock

/*Count only visits that didn't involve international conferences in the dependent variable*/
poisson totalPresPremNonConf metalindex lnOil AsiaUSdefense risingpower autocracy  Asia Africa s3un4608i_visUSA_98 usdefense us_sanctions_halftime un_sanctions_halftime lnpop boundarydum lnpci  lnFDIin  lnFDIoutStock


/*Predicted probabilities; to replicate probabilities and expected # of trips reported in Table 3*/

poisson totalPresPremvisits   metalindex lnOil AsiaUSdefense risingpower autocracy  Asia Africa s3un4608i_visUSA_98 usdefense us_sanctions_halftime un_sanctions_halftime lnpop boundarydum lnpci  lnFDIin  lnFDIoutStock

/*average country
Note: for logged values, use log of average.
If mean value not in the 25-75 percentile range, use median value instead (did this for oil, pop, inward and outward FDI)*/

prvalue, x(metalindex 0 lnOil 16 AsiaUSdefense 0 risingpower 0 autocracy 0 Asia 0 Africa 0 s3un4608i_visUSA_98 -.3 usdefense 0 us_sanctions_halftime 0 un_sanctions_halftime 0 lnpop 15.88 boundarydum 0 lnpci 8.4  lnFDIin 12.04  lnFDIoutStock 13.07)

/*population set at 25 percentile*/

prvalue, x(metalindex 0 lnOil 16 AsiaUSdefense 0 risingpower 0 autocracy 0 Asia 0 Africa 0 s3un4608i_visUSA_98 -.3 usdefense 0 us_sanctions_halftime 0 un_sanctions_halftime 0 lnpop 14.73 boundarydum 0 lnpci 8.4  lnFDIin 12.04  lnFDIoutStock 13.07)

/*population at 75 percentile*/
prvalue, x(metalindex 0 lnOil 16 AsiaUSdefense 0 risingpower 0 autocracy 0 Asia 0 Africa 0 s3un4608i_visUSA_98 -.3 usdefense 0 us_sanctions_halftime 0 un_sanctions_halftime 0 lnpop 16.98 boundarydum 0 lnpci 8.4  lnFDIin 12.04  lnFDIoutStock 13.07)

/*pci at 25 percentile*/
prvalue, x(metalindex 0 lnOil 16 AsiaUSdefense 0 risingpower 0 autocracy 0 Asia 0 Africa 0 s3un4608i_visUSA_98 -.3 usdefense 0 us_sanctions_halftime 0 un_sanctions_halftime 0 lnpop 15.88 boundarydum 0 lnpci 7.59  lnFDIin 12.04  lnFDIoutStock 13.07)

/*pci at 75 percentile*/
prvalue, x(metalindex 0 lnOil 16 AsiaUSdefense 0 risingpower 0 autocracy 0 Asia 0 Africa 0 s3un4608i_visUSA_98 -.3 usdefense 0 us_sanctions_halftime 0 un_sanctions_halftime 0 lnpop 15.88 boundarydum 0 lnpci 9.44  lnFDIin 12.04  lnFDIoutStock 13.07)

/*both pci and pop at 25 percentile*/
prvalue, x(metalindex 0 lnOil 16 AsiaUSdefense 0 risingpower 0 autocracy 0 Asia 0 Africa 0 s3un4608i_visUSA_98 -.3 usdefense 0 us_sanctions_halftime 0 un_sanctions_halftime 0 lnpop 14.73 boundarydum 0 lnpci 7.59  lnFDIin 12.04  lnFDIoutStock 13.07)

/*both pci and pop at 75 percentile*/
prvalue, x(metalindex 0 lnOil 16 AsiaUSdefense 0 risingpower 0 autocracy 0 Asia 0 Africa 0 s3un4608i_visUSA_98 -.3 usdefense 0 us_sanctions_halftime 0 un_sanctions_halftime 0 lnpop 16.98 boundarydum 0 lnpci 9.44  lnFDIin 12.04  lnFDIoutStock 13.07)

/*Pakistan (use to assess border effects)*/
prvalue, x(metalindex .0002 lnOil 19.2 AsiaUSdefense 1 risingpower 0 autocracy 0 Asia 1 Africa 0 s3un4608i_visUSA_98 -.42 usdefense 1 us_sanctions_halftime 1 un_sanctions_halftime 0 lnpop 18.7 boundarydum 1 lnpci 7.8  lnFDIin 13.4  lnFDIoutStock 14.6)

/*Pakistan not bordering or in Asia*/

prvalue, x(metalindex .0002 lnOil 19.2 AsiaUSdefense 0 risingpower 0 autocracy 0 Asia 0 Africa 0 s3un4608i_visUSA_98 -.42 usdefense 1 us_sanctions_halftime 1 un_sanctions_halftime 0 lnpop 18.7 boundarydum 0 lnpci 7.8  lnFDIin 13.4  lnFDIoutStock 14.6)
