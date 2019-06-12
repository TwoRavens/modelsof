/* Table 3: Determinants of longer Membership in GATT/WTO 1950-2007, All Countries*/
set more off
/*Column I Ordinary least Squares (Robust St. Errors)*/	
reg yjndtmsnumberyearsunder4606 democ igosjoined regionalWTOmembership openk grgdpch rgdpch pop, robust cluster (ccode)

set more off
/* Column II Negative Binomial Regression Model (Robust St. Errors)*/	
nbreg yjndtmsnumberyearsunder4606 democ igosjoined regionalWTOmembership openk grgdpch rgdpch pop, robust cluster (ccode)

set more off
/* Column III Feasible Generalized Least Squares Model*/
iis ccode
tis year
xtgls yjndtmsnumberyearsunder4606 democ igosjoined regionalWTOmembership openk grgdpch rgdpch pop, panels(heteroskedastic)

set more off
/* Column IV Generalized Least Squares Model Fixed Effects (Robust St. Errors)*/
xtset ccode year
xtreg yjndtmsnumberyearsunder4606 democ igosjoined regionalWTOmembership openk grgdpch rgdpch pop, fe robust

set more off
/* Column V Generalized Least Squares Model Random Effects (Robust St. Errors)*/	
xtset ccode year
xtreg yjndtmsnumberyearsunder4606 democ igosjoined regionalWTOmembership openk grgdpch rgdpch pop, re robust

set more off
/* Column VI Cox Proportional Hazard Model*/ 
stset year, id (ccode)failure(yjnddummy==1)
stcox democ igosjoined regionalWTOmembership openk grgdpch rgdpch pop, vce (robust) cluster (ccode)


/*Table 4: Years under GATT/WTO and its effect on Democratic Rights 1950-2007, All Countries*/  
set more off
/* 3-Stage Least Squares Model Number of Years Under GATT/WTO and Competitiveness of Participation 1948-2007 No Lag*/
reg3 (parcomp yjndtmsnumberyearsunder4606 interstatewarlag1 civilwarintensitylag1 UKColony  openklag1 grgdpchlag1 rgdpchlag1 poplag1) (yjndtmsnumberyearsunder4606 democ igosjoined regionalWTOmembership openk grgdpch rgdpch pop)

set more off
/* 3-Stage Least Squares Model Number of Years Under GATT/WTO and Competitiveness of Participation 1948-2007 Includes Lag*/
reg3 (parcomp parcomplag1 yjndtmsnumberyearsunder4606 interstatewarlag1 civilwarintensitylag1 UKColony  openklag1 grgdpchlag1 rgdpchlag1 poplag1) (yjndtmsnumberyearsunder4606 democ igosjoined regionalWTOmembership openk grgdpch rgdpch pop)

set more off
/* Ordered Logit Number of Years Under GATT/WTO and Free & Fair Elections 1981-2007 No Lag*/
bootstrap, reps(1000): ologit (elecsd yjndtmsnumberyearsunder4606 interstatewarlag1 civilwarintensitylag1 UKColony  openklag1 grgdpchlag1 rgdpchlag1 poplag1 GATTWTOinversemills)

set more off
/* Ordered Logit Number of Years Under GATT/WTO and Free & Fair Elections 1981-2007 Includes Lag*/
bootstrap, reps(1000): ologit (elecsd elecsdlag1 yjndtmsnumberyearsunder4606 interstatewarlag1 civilwarintensitylag1 UKColony  openklag1 grgdpchlag1 rgdpchlag1 poplag1 GATTWTOinversemills)

set more off
/* 3-Stage Least Squares Model Number of Years Under GATT/WTO and Access to Public Information 2004-2008 No Lag*/
reg3  (publicaccesstoinformation yjndtmsnumberyearsunder4606 literacy8007ipolate interstatewarlag1 civilwarintensitylag1 UKColonyinterp openklag1interp grgdpchlag1interp rgdpchlag1interp poplag1interp) (yjndtmsnumberyearsunder4606 democinterp igosjoinedinterp2 regionalWTOmembership openkinterp grgdpchinterp rgdpchinterp popinterp)

set more off
/* 3-Stage Least Squares Model Number of Years Under GATT/WTO and Access to Public Information 2004-2008 Includes Lag*/
reg3  (publicaccesstoinformation publicaccesstoinformationlag1 yjndtmsnumberyearsunder4606 literacy8007ipolate interstatewarlag1 civilwarintensitylag1 UKColonyinterp openklag1interp grgdpchlag1interp rgdpchlag1interp poplag1interp) (yjndtmsnumberyearsunder4606 democinterp igosjoinedinterp2 regionalWTOmembership openkinterp grgdpchinterp rgdpchinterp popinterp)


/* Table 5: Years under WTO and its effect on Democratic Rights 1995-2008, Only New WTO Members & Non Member Countries*/  
set more off
/* 3-Stage Least Squares Model Number of Years Under WTO, Only New WTO Members and Competitiveness of Participation 1995-2007 No Lag*/
reg3 (parcomp yjnd09peaceyrs interstatewarlag1 civilwarintensitylag1 UKColony  openklag1 grgdpchlag1 rgdpchlag1 poplag1) (yjndtmsnumberyearsunder4606 democ igosjoined regionalWTOmembership openk grgdpch rgdpch pop) 

set more off
/* 3-Stage Least Squares Model Number of Years Under WTO, Only New WTO Members and Competitiveness of Participation 1995-2007 Includes Lag*/
reg3 (parcomp parcomplag1 yjnd09peaceyrs interstatewarlag1 civilwarintensitylag1 UKColony  openklag1 grgdpchlag1 rgdpchlag1 poplag1) (yjndtmsnumberyearsunder4606 democ igosjoined regionalWTOmembership openk grgdpch rgdpch pop) 

set more off
/* Ordered Logit Number of Years Under WTO, Only New WTO Members and changes in Free and Fair Elections 1995-2007 No Lag*/
set more off
bootstrap, reps(1000): ologit (elecsd yjnd09peaceyrs interstatewarlag1 civilwarintensitylag1 UKColony  openklag1 grgdpchlag1 rgdpchlag1 poplag1)

set more off
/*Ordered Logit Number of Years Under WTO, Only New WTO Members and changes in Free and Fair Elections 1995-2007 Includes Lag*/
set more off
bootstrap, reps(1000): ologit (elecsd elecsdlag1 yjnd09peaceyrs interstatewarlag1 civilwarintensitylag1 UKColony  openklag1 grgdpchlag1 rgdpchlag1 poplag1 )

set more off
/* 3-Stage Least Squares Model Number of Years Under WTO, Only New WTO Members and Access to Public Information 2004-2008 No Lag*/
reg3  (publicaccesstoinformation yjnd09peaceyrs literacy8007ipolate interstatewarlag1 civilwarintensitylag1 UKColonyinterp openklag1interp grgdpchlag1interp rgdpchlag1interp poplag1interp) (yjndtmsnumberyearsunder4606 democinterp igosjoinedinterp2 regionalWTOmembership openkinterp grgdpchinterp rgdpchinterp popinterp)

set more off
/*3-Stage Least Squares Model Number of Years Under WTO, Only New WTO Members and Access to Public Information 2004-2008 Includes Lag*/
reg3  (publicaccesstoinformation publicaccesstoinformationlag1 yjnd09peaceyrs literacy8007ipolate interstatewarlag1 civilwarintensitylag1 UKColonyinterp openklag1interp grgdpchlag1interp rgdpchlag1interp poplag1interp) (yjndtmsnumberyearsunder4606 democinterp igosjoinedinterp2 regionalWTOmembership openkinterp grgdpchinterp rgdpchinterp popinterp)


/* Table 6: Predictions: The Impact of Years under GATT/WTO on Democratic Rights 1950-2007, All Countries*/ 
/*Number of Years Under GATT/WTO and Competitiveness of Participation 1948-2004 Includes Lags*/
reg3 (parcomp parcomplag1 yjndtmsnumberyearsunder4606 interstatewarlag1 civilwarintensitylag1 UKColony  openklag1 grgdpchlag1 rgdpchlag1 poplag1) (yjndtmsnumberyearsunder4606 democ igosjoined regionalWTOmembership openk grgdpch rgdpch pop)
mfx compute, at (yjndtmsnumberyearsunder4606=0)
mfx compute, at (yjndtmsnumberyearsunder4606=12.63388)
mfx compute, at (yjndtmsnumberyearsunder4606=28.62088)
mfx compute, at (yjndtmsnumberyearsunder4606=59)

/*Number of Years Under GATT/WTO and Free and Fair Elections 1981-2004 Includes Lags*/
set more off       
ologit  (elecsd elecsdlag1 yjndtmsnumberyearsunder4606 interstatewarlag1 civilwarintensitylag1 UKColony  openklag1 grgdpchlag1 rgdpchlag1 poplag1 GATTWTOinversemills)
mfx, predict (p outcome(2)) at (yjndtmsnumberyearsunder4606=0)
mfx, predict (p outcome(2)) at (yjndtmsnumberyearsunder4606=12.63388)
mfx, predict (p outcome(2)) at (yjndtmsnumberyearsunder4606=28.62088)
mfx, predict (p outcome(2)) at (yjndtmsnumberyearsunder4606=59)
mfx, predict (p outcome(1)) at (yjndtmsnumberyearsunder4606=0)
mfx, predict (p outcome(1)) at (yjndtmsnumberyearsunder4606=12.63388)
mfx, predict (p outcome(1)) at (yjndtmsnumberyearsunder4606=28.62088)
mfx, predict (p outcome(1)) at (yjndtmsnumberyearsunder4606=59)
mfx, predict (p outcome(0)) at (yjndtmsnumberyearsunder4606=0)
mfx, predict (p outcome(0)) at (yjndtmsnumberyearsunder4606=12.63388)
mfx, predict (p outcome(0)) at (yjndtmsnumberyearsunder4606=28.62088)
mfx, predict (p outcome(0)) at (yjndtmsnumberyearsunder4606=59)


















