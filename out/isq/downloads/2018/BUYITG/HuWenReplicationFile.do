/*HU-WEN Models and predicted probabilities*/
/*This do file should be run when using the dataset HuWenReplication.dta*/
/*note: this do file replicates results reported in the ISQ article for the Hu/Wen (2003-2008) period.
The first two regressions are those reported in Table 4.
Alternative specification regressions reported in ISQ article follow.
After that, the predicted probabilities reported in the article are generated*/

/*Note that variable names used in the article are presented in the variable labels in the Stata data file*/

/*Baseline Regression; results reported in Table 4, Column 1*/
poisson totalPresPremvisits   metalindex lnOil AsiaUSdefense risingpower autocracy  Asia Africa s3un4608i_visUSA_2003 usdefense us_sanctions_halftime un_sanctions_halftime lnpop boundarydum lnpci  lnFDIin  lnFDIoutStock

/*use number of days spent in a particular country as DV; results reported in Table 4, second column*/
nbreg totalPresPremDays metalindex lnOil AsiaUSdefense risingpower autocracy  Asia Africa s3un4608i_visUSA_2003 usdefense us_sanctions_halftime un_sanctions_halftime lnpop boundarydum lnpci  lnFDIin  lnFDIoutStock

/*Alternative specifications*/

/*substitute defense spending for population*/
poisson totalPresPremvisits   metalindex lnOil AsiaUSdefense risingpower autocracy  Asia Africa s3un4608i_visUSA_2003 usdefense us_sanctions_halftime un_sanctions_halftime lnDefensesp03 boundarydum lnpci  lnFDIin  lnFDIoutStock

/*substitute GDP for population*/
poisson totalPresPremvisits   metalindex lnOil AsiaUSdefense risingpower autocracy  Asia Africa s3un4608i_visUSA_2003 usdefense us_sanctions_halftime un_sanctions_halftime lngdp boundarydum lnpci  lnFDIin  lnFDIoutStock

/*substitute trade for population*/
poisson totalPresPremvisits   metalindex lnOil AsiaUSdefense risingpower autocracy  Asia Africa s3un4608i_visUSA_2003 usdefense us_sanctions_halftime un_sanctions_halftime lnTrade boundarydum lnpci  lnFDIin  lnFDIoutStock

/*substitute US arms sales for US alliance variable, AsiaUSarms is the interactive variable*/
poisson totalPresPremvisits  lnUSarms_03_08 metalindex lnOil AsiaUSarms risingpower autocracy  Asia Africa s3un4608i_visUSA_2003 us_sanctions_halftime un_sanctions_halftime lnpop boundarydum lnpci  lnFDIin  lnFDIoutStock

/*substitute US troops dummy variable in place of US alliance variable; AsiaUStroops is the interactive variable*/
poisson totalPresPremvisits   UStroopdummy metalindex lnOil AsiaUStroops risingpower autocracy  Asia Africa s3un4608i_visUSA_2003 us_sanctions_halftime un_sanctions_halftime lnpop boundarydum lnpci  lnFDIin  lnFDIoutStock

/*Count only visits that didn't involve international conferences in the dependent variable*/
poisson totalPresPremNonConf metalindex lnOil AsiaUSdefense risingpower autocracy  Asia Africa s3un4608i_visUSA_2003 usdefense us_sanctions_halftime un_sanctions_halftime lnpop boundarydum lnpci  lnFDIin  lnFDIoutStock


/*Predicted probabilities; to replicate probabilities and expected # of trips reported in Table 5*/

poisson totalPresPremvisits   metalindex lnOil AsiaUSdefense risingpower autocracy  Asia Africa s3un4608i_visUSA_2003 usdefense us_sanctions_halftime un_sanctions_halftime lnpop boundarydum lnpci  lnFDIin  lnFDIoutStock

/*average country
Note: for logged values, use log of average.
If mean value not in the 25-75 percentile range, use median value instead (did this for oil, pop, inward and outward FDI)*/

prvalue, x(metalindex 0 lnOil 16 AsiaUSdefense 0 risingpower 0 autocracy 0  Asia 0 Africa 0 s3un4608i_visUSA_2003 -.53 usdefense 0 us_sanctions_halftime 0 un_sanctions_halftime 0 lnpop 15.9 boundarydum 0 lnpci 8.7  lnFDIin 13.7  lnFDIoutStock 14)

/*population at 25 percentile*/

prvalue, x(metalindex 0 lnOil 16 AsiaUSdefense 0 risingpower 0 autocracy 0  Asia 0 Africa 0 s3un4608i_visUSA_2003 -.53 usdefense 0 us_sanctions_halftime 0 un_sanctions_halftime 0 lnpop 14.8 boundarydum 0 lnpci 8.7  lnFDIin 13.7  lnFDIoutStock 14)

/*pop at 75 percentile*/
prvalue, x(metalindex 0 lnOil 16 AsiaUSdefense 0 risingpower 0 autocracy 0  Asia 0 Africa 0 s3un4608i_visUSA_2003 -.53 usdefense 0 us_sanctions_halftime 0 un_sanctions_halftime 0 lnpop 17.1 boundarydum 0 lnpci 8.7  lnFDIin 13.7  lnFDIoutStock 14)

/*pci at 25 percentile*/
prvalue, x(metalindex 0 lnOil 16 AsiaUSdefense 0 risingpower 0 autocracy 0  Asia 0 Africa 0 s3un4608i_visUSA_2003 -.53 usdefense 0 us_sanctions_halftime 0 un_sanctions_halftime 0 lnpop 15.9 boundarydum 0 lnpci 7.7  lnFDIin 13.7  lnFDIoutStock 14)

/*pci at 75 percentile*/
prvalue, x(metalindex 0 lnOil 16 AsiaUSdefense 0 risingpower 0 autocracy 0  Asia 0 Africa 0 s3un4608i_visUSA_2003 -.53 usdefense 0 us_sanctions_halftime 0 un_sanctions_halftime 0 lnpop 15.9 boundarydum 0 lnpci 9.7  lnFDIin 13.7  lnFDIoutStock 14)

/*outward FDI at 25 percentile (=0)*/
prvalue, x(metalindex 0 lnOil 16 AsiaUSdefense 0 risingpower 0 autocracy 0  Asia 0 Africa 0 s3un4608i_visUSA_2003 -.53 usdefense 0 us_sanctions_halftime 0 un_sanctions_halftime 0 lnpop 15.9 boundarydum 0 lnpci 8.7  lnFDIin 13.7  lnFDIoutStock 0)

/*outward FDI at 75 percetile*/
prvalue, x(metalindex 0 lnOil 16 AsiaUSdefense 0 risingpower 0 autocracy 0  Asia 0 Africa 0 s3un4608i_visUSA_2003 -.53 usdefense 0 us_sanctions_halftime 0 un_sanctions_halftime 0 lnpop 15.9 boundarydum 0 lnpci 8.7  lnFDIin 13.7  lnFDIoutStock 16.4)

/*Pakistan*/
prvalue, x(metalindex .0002 lnOil 19.6 AsiaUSdefense 1 risingpower 0 autocracy 1  Asia 1 Africa 0 s3un4608i_visUSA_2003 -.55 usdefense 1 us_sanctions_halftime 0 un_sanctions_halftime 0 lnpop 18.8 boundarydum 1 lnpci 7.9  lnFDIin 15  lnFDIoutStock 17.1)

/*Pakistan not bordering China and not in Asia*/
prvalue, x(metalindex .0002 lnOil 19.6 AsiaUSdefense 0 risingpower 0 autocracy 1  Asia 0 Africa 0 s3un4608i_visUSA_2003 -.55 usdefense 1 us_sanctions_halftime 0 un_sanctions_halftime 0 lnpop 18.8 boundarydum 0 lnpci 7.9  lnFDIin 15  lnFDIoutStock 17.1)

/*Cuba*/
prvalue, x(metalindex .009 lnOil 20.4 AsiaUSdefense 0 risingpower 0 autocracy 1  Asia 0 Africa 0 s3un4608i_visUSA_2003 -.68 usdefense 0 us_sanctions_halftime 1 un_sanctions_halftime 0 lnpop 16.2 boundarydum 0 lnpci 8.8  lnFDIin 16.5  lnFDIoutStock 16.5)

/*Cuba not target of US sanctions*/
prvalue, x(metalindex .009 lnOil 20.4 AsiaUSdefense 0 risingpower 0 autocracy 1  Asia 0 Africa 0 s3un4608i_visUSA_2003 -.68 usdefense 0 us_sanctions_halftime 0 un_sanctions_halftime 0 lnpop 16.2 boundarydum 0 lnpci 8.8  lnFDIin 16.5  lnFDIoutStock 16.5)

/*S Africa*/
prvalue, x(metalindex .04 lnOil 16.6 AsiaUSdefense 0 risingpower 1 autocracy 0  Asia 0 Africa 1 s3un4608i_visUSA_2003 -.58 usdefense 0 us_sanctions_halftime 0 un_sanctions_halftime 0 lnpop 17.6 boundarydum 0 lnpci 9.2  lnFDIin 17.3  lnFDIoutStock 17.6)

/*S Africa not in Africa*/
prvalue, x(metalindex .04 lnOil 16.6 AsiaUSdefense 0 risingpower 1 autocracy 0  Asia 0 Africa 0 s3un4608i_visUSA_2003 -.58 usdefense 0 us_sanctions_halftime 0 un_sanctions_halftime 0 lnpop 17.6 boundarydum 0 lnpci 9.2  lnFDIin 17.3  lnFDIoutStock 17.6)
