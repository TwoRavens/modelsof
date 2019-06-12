
cd "O:\Fixed vs Random\LATEST\for PSRM\sims"

drop _all
matrix drop _all
scalar drop _all

set matsize 11000
set seed 12345

*create matrix to store results
mat A = (1,2,3,4,5,6,7,8,9,10,1,2,3,4,5,6,7,8,9, ///
20,1,2,3,4,5,6,7,8,9,30,1,2,3,4,5,6,7,8,9,40,1,2,3,4,5,6,7,8,9,50,1,2,3,4, ///
5,6,7,8,9,60,1)

mat colnames A = N n Contextual L2corX5 L2Var L1Var ///
REX1b REX2b REX3b REZ1b REZ2b REZ3b REconsb REX1v REX2v REX3v REZ1v REZ2v REZ3v REconsv ///
REWBX1b REWBX2b REWBX3b REWBX3barjb REWBZ1b REWBZ2b REWBZ3b REWBconsb REWBX1v REWBX2v ///
REWBX3v REWBX3barjv REWBZ1v REWBZ2v REWBZ3v REWBconsv ///
FEX1b FEX2b FEX3b FEconsb FEX1v FEX2v FEX3v FEconsv ///
FEVDuX1b FEVDuX2b FEVDuX3b FEVDuZ1b FEVDuZ2b FEVDuZ3b FEVDuetab FEVDuconsb FEVDuX1v ///
FEVDuX2v FEVDuX3v FEVDuZ1v FEVDuZ2v FEVDuZ3v FEVDuetav FEVDuconsv ///
corr

*specify parameters
forvalues N = 100/100 { 				//number of countries
forvalues n = 20/20 { 				//number of observations per country
forvalues Contextual = -1/0 { 		//Size of contextual effect associated with X1 
									//(ie, the difference between the within and the between effect)
forvalues cor = -1/3 {			//Correlation between Z2 and u
	local L2corr = `cor'/5
forvalues L2Var = 4/4 {				//Variance of level 2 residuals
forvalues L1Var = 3/3 {				//Variance of level 1 residuals


forvalues sims = 1/1000 {
clear
*Set number of countries
set obs `N'
*give ID for each country
gen j = _n
*specify the correlation between higher level variables and higher level residuals, ///
*and generate them
matrix C = (1,0,0,0,0 \ 0,1,0,0,0 \ 0,0,1,0,`L2corr' \ 0,0,0,1,0 \ 0,0,`L2corr',0,1)

drawnorm Z1 Z2 Z3 X3barj u, means(0,0,0,0,0) sds(1,1,1,1,`L2Var') corr(C)

*Set number of occasions for each country
expand `n'
sort j
gen i = _n
egen occasion = seq(),from(1) to(`n')
*generate level 1 variance
gen e = rnormal(0,`L1Var')
*generate 'within' components of t-varying variables
gen X3w = rnormal(0,1)
gen X1 = rnormal(0,1)
gen X2 = rnormal(0,1)
*Combine within and between variables into one variable
gen X3 = X3barj + X3w
gen UwithXj = u + (`Contextual'*X3barj)

corr X3 UwithXj
mat corr = r(rho)

*Generate Y
gen Y = 1 + (0.5*X1) + (2*X2) - (1.5*X3) + (`Contextual'*X3barj) ///
- (2.5*Z1) + (1.8*Z2) + (3*Z3) + u + e

*set data as time-series
tsset j occasion, yearly

*Run the models saving beta estimates and SEs

xtreg Y X1 X2 X3 Z1 Z2 Z3
mat REb = e(b)
mat REvars = vecdiag(e(V))

xtreg Y X1 X2 X3w X3barj Z1 Z2 Z3
mat REwbb = e(b)
mat REwbvars = vecdiag(e(V))

xtreg Y X1 X2 X3, fe
mat FEb = e(b)
mat FEvars = vecdiag(e(V))

xtfevd Y X1 X2 X3 Z1 Z2 Z3, invariant(Z1 Z2 Z3)
mat FEVDub = e(b)
mat FEVDuvars = vecdiag(e(V))

*Make matrix of results
mat info = (`N',`n',`Contextual',`cor',`L2Var',`L1Var')
mat A = (A \ info,REb,REvars,REwbb,REwbvars,FEb,FEvars,FEVDub,FEVDuvars,corr)

}
}
}
}
}
}
}

mat A = A[2...,.]
clear 
svmat A, names(col)

note: closing state `c(seed)'

gen B1true = 0.5
gen B2true = 2
gen B3true = -1.5
gen B3Btrue = Contextual - 1.5 //Between = Contextual + Within
gen B4true = -2.5
gen B5true = 1.8
gen B6true = 3

***********Measures for X3/B3*********************
*Bias

gen BiasB3FE = (FEX3b / B3true)
gen BiasB3RE = (REX3b / B3true)
gen BiasB3REWB = (REWBX3b / B3true)
gen BiasB3FEVDu = (FEVDuX3b / B3true)

egen MBiasB3FE = mean(BiasB3FE), by(N n Contextual L2corX5 L2Var L1Var)
egen MBiasB3RE = mean(BiasB3RE), by(N n Contextual L2corX5 L2Var L1Var)
egen MBiasB3REWB = mean(BiasB3REWB), by(N n Contextual L2corX5 L2Var L1Var)
egen MBiasB3FEVDu = mean(BiasB3FEVDu), by(N n Contextual L2corX5 L2Var L1Var)

drop Bias*

*RMSE

gen SqErB3FE = (FEX3b - B3true)^2
gen SqErB3RE = (REX3b - B3true)^2
gen SqErB3REWB = (REWBX3b - B3true)^2
gen SqErB3FEVDu = (FEVDuX3b - B3true)^2

egen MSEB3FE = mean(SqErB3FE), by(N n Contextual L2corX5 L2Var L1Var)
egen MSEB3RE = mean(SqErB3RE), by(N n Contextual L2corX5 L2Var L1Var)
egen MSEB3REWB = mean(SqErB3REWB), by(N n Contextual L2corX5 L2Var L1Var)
egen MSEB3FEVDu = mean(SqErB3FEVDu), by(N n Contextual L2corX5 L2Var L1Var)

gen RMSEB3FE = sqrt(MSEB3FE)
gen RMSEB3RE = sqrt(MSEB3RE)
gen RMSEB3REWB = sqrt(MSEB3REWB)
gen RMSEB3FEVDu = sqrt(MSEB3FEVDu)

drop SqEr* MSE*


***********Measures for Z3/B6*********************
*Bias

gen BiasB6RE = (REZ3b / B6true)
gen BiasB6REWB = (REWBZ3b / B6true)
gen BiasB6FEVDu = (FEVDuZ3b / B6true)

egen MBiasB6RE = mean(BiasB6RE), by(N n Contextual L2corX5 L2Var L1Var)
egen MBiasB6REWB = mean(BiasB6REWB), by(N n Contextual L2corX5 L2Var L1Var)
egen MBiasB6FEVDu = mean(BiasB6FEVDu), by(N n Contextual L2corX5 L2Var L1Var)

drop Bias*

*RMSE

gen SqErB6RE = (REZ3b - B6true)^2
gen SqErB6REWB = (REWBZ3b - B6true)^2
gen SqErB6FEVDu = (FEVDuZ3b - B6true)^2

egen MSEB6RE = mean(SqErB6RE), by(N n Contextual L2corX5 L2Var L1Var)
egen MSEB6REWB = mean(SqErB6REWB), by(N n Contextual L2corX5 L2Var L1Var)
egen MSEB6FEVDu = mean(SqErB6FEVDu), by(N n Contextual L2corX5 L2Var L1Var)

gen RMSEB6RE = sqrt(MSEB6RE)
gen RMSEB6REWB = sqrt(MSEB6REWB)
gen RMSEB6FEVDu = sqrt(MSEB6FEVDu)

drop SqEr* MSE*

********Measures for X3barj************

*Bias

gen BiasB3BREWB = (REWBX3barjb / B3Btrue)
egen MBiasB3BREWB = mean(BiasB3BREWB), by(N n Contextual L2corX5 L2Var L1Var)
drop Bias*

*RMSE

gen SqErB3BREWB = (REWBX3barjb - B3Btrue)^2
egen MSEB3BREWB = mean(SqErB3BREWB), by(N n Contextual L2corX5 L2Var L1Var)
gen RMSEB3BREWB = sqrt(MSEB3BREWB)



****************Optimism*********************

**************X3



egen MeanB3FE = mean(FEX3b), by(N n Contextual L2corX5 L2Var L1Var)
egen MeanB3RE = mean(REX3b), by(N n Contextual L2corX5 L2Var L1Var)
egen MeanB3REWB = mean(REWBX3b), by(N n Contextual L2corX5 L2Var L1Var)
egen MeanB3FEVDu = mean(FEVDuX3b), by(N n Contextual L2corX5 L2Var L1Var)

gen SqErB3FE = (FEX3b - MeanB3FE)^2
gen SqErB3RE = (REX3b - MeanB3RE)^2
gen SqErB3REWB = (REWBX3b - MeanB3REWB)^2
gen SqErB3FEVDu = (FEVDuX3b - MeanB3FEVDu)^2

egen TotSqErB3FE = total(SqErB3FE), by(N n Contextual L2corX5 L2Var L1Var)
egen TotSqErB3RE = total(SqErB3RE), by(N n Contextual L2corX5 L2Var L1Var)
egen TotSqErB3REWB = total(SqErB3REWB), by(N n Contextual L2corX5 L2Var L1Var)
egen TotSqErB3FEVDu = total(SqErB3FEVDu), by(N n Contextual L2corX5 L2Var L1Var)

gen OptTopB3FE = sqrt(TotSqErB3FE)
gen OptTopB3RE = sqrt(TotSqErB3RE)
gen OptTopB3REWB = sqrt(TotSqErB3REWB)
gen OptTopB3FEVDu = sqrt(TotSqErB3FEVDu)

drop Mean* SqEr* Tot*

egen sumvarB3FE = total(FEX3v), by(N n Contextual L2corX5 L2Var L1Var)
egen sumvarB3RE = total(REX3v), by(N n Contextual L2corX5 L2Var L1Var)
egen sumvarB3REWB = total(REWBX3v), by(N n Contextual L2corX5 L2Var L1Var)
egen sumvarB3FEVDu = total(FEVDuX3v), by(N n Contextual L2corX5 L2Var L1Var)

gen OptBotB3FE = sqrt(sumvarB3FE)
gen OptBotB3RE = sqrt(sumvarB3RE)
gen OptBotB3REWB = sqrt(sumvarB3REWB)
gen OptBotB3FEVDu = sqrt(sumvarB3FEVDu)

gen optB3FE = OptTopB3FE / OptBotB3FE
gen optB3RE = OptTopB3RE / OptBotB3RE
gen optB3REWB = OptTopB3REWB / OptBotB3REWB
gen optB3FEVDu = OptTopB3FEVDu / OptBotB3FEVDu

drop sumvar* Opt*

********Z3
*Optimism

egen MeanB6RE = mean(REZ3b), by(N n Contextual L2corX5 L2Var L1Var)
egen MeanB6REWB = mean(REWBZ3b), by(N n Contextual L2corX5 L2Var L1Var)
egen MeanB6FEVDu = mean(FEVDuZ3b), by(N n Contextual L2corX5 L2Var L1Var)

gen SqErB6RE = (REZ3b - MeanB6RE)^2
gen SqErB6REWB = (REWBZ3b - MeanB6REWB)^2
gen SqErB6FEVDu = (FEVDuZ3b - MeanB6FEVDu)^2

egen TotSqErB6RE = total(SqErB6RE), by(N n Contextual L2corX5 L2Var L1Var)
egen TotSqErB6REWB = total(SqErB6REWB), by(N n Contextual L2corX5 L2Var L1Var)
egen TotSqErB6FEVDu = total(SqErB6FEVDu), by(N n Contextual L2corX5 L2Var L1Var)

gen OptTopB6RE = sqrt(TotSqErB6RE)
gen OptTopB6REWB = sqrt(TotSqErB6REWB)
gen OptTopB6FEVDu = sqrt(TotSqErB6FEVDu)

drop Mean* SqEr* Tot*

egen sumvarB6RE = total(REZ3v), by(N n Contextual L2corX5 L2Var L1Var)
egen sumvarB6REWB = total(REWBZ3v), by(N n Contextual L2corX5 L2Var L1Var)
egen sumvarB6FEVDu = total(FEVDuZ3v), by(N n Contextual L2corX5 L2Var L1Var)

gen OptBotB6RE = sqrt(sumvarB6RE)
gen OptBotB6REWB = sqrt(sumvarB6REWB)
gen OptBotB6FEVDu = sqrt(sumvarB6FEVDu)

gen optB6RE = OptTopB6RE / OptBotB6RE
gen optB6REWB = OptTopB6REWB / OptBotB6REWB
gen optB6FEVDu = OptTopB6FEVDu / OptBotB6FEVDu

drop sumvar* Opt*


********B3b

egen MeanB3bREWB = mean(REWBX3barjb), by(N n Contextual L2corX5 L2Var L1Var)
gen SqErB3bREWB = (REWBX3barjb - MeanB3bREWB)^2
egen TotSqErB3bREWB = total(SqErB3bREWB), by(N n Contextual L2corX5 L2Var L1Var)
gen OptTopB3bREWB = sqrt(TotSqErB3bREWB)

drop Mean* SqEr* Tot*

egen sumvarB3bREWB = total(REWBX3barjv), by(N n Contextual L2corX5 L2Var L1Var)
gen OptBotB3bREWB = sqrt(sumvarB3bREWB)
gen optB3bREWB = OptTopB3bREWB / OptBotB3bREWB

drop sumvar* Opt*

save simulations1, replace








