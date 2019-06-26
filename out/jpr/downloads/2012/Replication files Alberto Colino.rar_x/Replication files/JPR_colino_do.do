*Install the Poisson Quasi-maximum likelihood estimator command
ssc install xtpqml
*Indicate to the program the longitudinal nature of the dataset
xtset id year,yearly

*RESET test

*Estimate the model
xtpqml emp y98 y99 bc bcy98 bcy99 age lwage if year>=1996 & year<=2001,fe cluster(id)
*Get fitted values of the linear index
predict xb,xb
*Square the fitted values
gen xb2=xb^2
*Estimate the model with the additional regressor
xtpqml emp y98 y99 bc bcy98 bcy99 age lwage xb2 if year>=1996 & year<=2001,fe cluster(id)
*test the significance of the additional regressor
test xb2=0

*R-squared

*Estimate the model
xtpqml emp y98 y99 bc bcy98 bcy99 age lwage if year>=1996 & year<=2001,fe cluster(id)
*Get fitted values of the endogenous variable
predict fitted
*Compute correlation between endogenous and fitted values
qui cor fitted emp
*Display R-squared as the square of the correlation between the endogenous and the fitted values
di as txt "R-squared"(`r(rho)')^2

drop xb xb2 fitted

*RESET test

*Estimate the model
xtpqml emp y98 y99 bc bcy98 bcy99 age lwage lfin if year>=1996 & year<=2001,fe cluster(id)
*Get fitted values of the linear index
predict xb,xb
*Square the fitted values
gen xb2=xb^2
*Estimate the model with the additional regressor
xtpqml emp y98 y99 bc bcy98 bcy99 age lwage lfin xb2 if year>=1996 & year<=2001,fe cluster(id)
*test the significance of the additional regressor
test xb2=0

*R-squared

*Estimate the model
xtpqml emp y98 y99 bc bcy98 bcy99 age lwage lfin if year>=1996 & year<=2001,fe cluster(id)
*Get fitted values of the endogenous variable
predict fitted
*Compute correlation between endogenous and fitted values
qui cor fitted emp
*Display R-squared as the square of the correlation between the endogenous and the fitted values
di as txt "R-squared"(`r(rho)')^2

drop xb xb2 fitted

*RESET test

*Estimate the model
xtpqml emp y98 y99 bc bcy98 bcy99 age lwage lfin lfin2 if year>=1996 & year<=2001,fe cluster(id)
*Get fitted values of the linear index
predict xb,xb
*Square the fitted values
gen xb2=xb^2
*Estimate the model with the additional regressor
xtpqml emp y98 y99 bc bcy98 bcy99 age lwage lfin lfin2 xb2 if year>=1996 & year<=2001,fe cluster(id)
*test the significance of the additional regressor
test xb2=0

*R-squared

*Estimate the model
xtpqml emp y98 y99 bc bcy98 bcy99 age lwage lfin lfin2 if year>=1996 & year<=2001,fe cluster(id)
*Get fitted values of the endogenous variable
predict fitted
*Compute correlation between endogenous and fitted values
qui cor fitted emp
*Display R-squared as the square of the correlation between the endogenous and the fitted values
di as txt "R-squared"(`r(rho)')^2

drop xb xb2 fitted

*RESET test (Modelo sólo año 1998)

*Estimate the model
xtpqml emp y98 bc bcy98 age lwage if year>=1996 & year<=2000,fe cluster(id)
*Get fitted values of the linear index
predict xb,xb
*Square the fitted values
gen xb2=xb^2
*Estimate the model with the additional regressor
xtpqml emp y98 bc bcy98 age lwage xb2 if year>=1996 & year<=2000,fe cluster(id)
*test the significance of the additional regressor
test xb2=0

*R-squared

*Estimate the model
xtpqml emp y98 bc bcy98 age lwage if year>=1996 & year<=2000,fe cluster(id)
*Get fitted values of the endogenous variable
predict fitted
*Compute correlation between endogenous and fitted values
qui cor fitted emp
*Display R-squared as the square of the correlation between the endogenous and the fitted values
di as txt "R-squared"(`r(rho)')^2

drop xb xb2 fitted

*RESET test 

*Estimate the model
xtpqml emp y98 bc bcy98 age lwage lfin if year>=1996 & year<=2000,fe cluster(id)
*Get fitted values of the linear index
predict xb,xb
*Square the fitted values
gen xb2=xb^2
*Estimate the model with the additional regressor
xtpqml emp y98 bc bcy98 age lwage lfin xb2 if year>=1996 & year<=2000,fe cluster(id)
*test the significance of the additional regressor
test xb2=0

*R-squared

*Estimate the model
xtpqml emp y98 bc bcy98 age lwage lfin if year>=1996 & year<=2000,fe cluster(id)
*Get fitted values of the endogenous variable
predict fitted
*Compute correlation between endogenous and fitted values
qui cor fitted emp
*Display R-squared as the square of the correlation between the endogenous and the fitted values
di as txt "R-squared"(`r(rho)')^2

drop xb xb2 fitted

*RESET test 

*Estimate the model
xtpqml emp y98 bc bcy98 age lwage lfin lfin2 if year>=1996 & year<=2000,fe cluster(id)
*Get fitted values of the linear index
predict xb,xb
*Square the fitted values
gen xb2=xb^2
*Estimate the model with the additional regressor
xtpqml emp y98 bc bcy98 age lwage lfin lfin2 xb2 if year>=1996 & year<=2000,fe cluster(id)
*test the significance of the additional regressor
test xb2=0

*R-squared

*Estimate the model
xtpqml emp y98 bc bcy98 age lwage lfin lfin2 if year>=1996 & year<=2000,fe cluster(id)
*Get fitted values of the endogenous variable
predict fitted
*Compute correlation between endogenous and fitted values
qui cor fitted emp
*Display R-squared as the square of the correlation between the endogenous and the fitted values
di as txt "R-squared"(`r(rho)')^2

drop xb xb2 fitted


*RESET test (Modelo tregua 2006)

*Estimate the model
xtpqml emp y06 bc bcy06 age lwage if year>=2004 & year<=2006,fe cluster(id)
*Get fitted values of the linear index
predict xb,xb
*Square the fitted values
gen xb2=xb^2
*Estimate the model with the additional regressor
xtpqml emp y06 bc bcy06 age lwage xb2 if year>=2004 & year<=2006,fe cluster(id)
*test the significance of the additional regressor
test xb2=0

*R-squared

*Estimate the model
xtpqml emp y06 bc bcy06 age lwage if year>=2004 & year<=2006,fe cluster(id)
*Get fitted values of the endogenous variable
predict fitted
*Compute correlation between endogenous and fitted values
qui cor fitted emp
*Display R-squared as the square of the correlation between the endogenous and the fitted values
di as txt "R-squared"(`r(rho)')^2

drop xb xb2 fitted


*RESET test

*Estimate the model
xtpqml emp y06 bc bcy06 age lwage lfin if year>=2004 & year<=2006,fe cluster(id)
*Get fitted values of the linear index
predict xb,xb
*Square the fitted values
gen xb2=xb^2
*Estimate the model with the additional regressor
xtpqml emp y06 bc bcy06 age lwage lfin xb2 if year>=2004 & year<=2006,fe cluster(id)
*test the significance of the additional regressor
test xb2=0

*R-squared

*Estimate the model
xtpqml emp y06 bc bcy06 age lwage lfin if year>=2004 & year<=2006,fe cluster(id)
*Get fitted values of the endogenous variable
predict fitted
*Compute correlation between endogenous and fitted values
qui cor fitted emp
*Display R-squared as the square of the correlation between the endogenous and the fitted values
di as txt "R-squared"(`r(rho)')^2

drop xb xb2 fitted


*RESET test

*Estimate the model
xtpqml emp y06 bc bcy06 age lwage lfin lfin2 if year>=2004 & year<=2006,fe cluster(id)
*Get fitted values of the linear index
predict xb,xb
*Square the fitted values
gen xb2=xb^2
*Estimate the model with the additional regressor
xtpqml emp y06 bc bcy06 age lwage lfin lfin2 xb2 if year>=2004 & year<=2006,fe cluster(id)
*test the significance of the additional regressor
test xb2=0

*R-squared

*Estimate the model
xtpqml emp y06 bc bcy06 age lwage lfin lfin2 if year>=2004 & year<=2006,fe cluster(id)
*Get fitted values of the endogenous variable
predict fitted
*Compute correlation between endogenous and fitted values
qui cor fitted emp
*Display R-squared as the square of the correlation between the endogenous and the fitted values
di as txt "R-squared"(`r(rho)')^2
