**********************************
*	Title: hivlabor_bootstrap3.do
*	Date: 3 July 2009
*	Author: Zoe McLaren
*	Description: 
*		1. Generates bootstrapped standard errors for RW and CF methods.  Inputs them into "total" table.
*Sub-file of hivlabor.do
**********************************
version 8
args j

cap program drop bsloop
program define bsloop
preserve
bsample
local j = `1'
matrix input rw = ()

*RW section
	logit unemployed positive [pweight=pscoreweight] if subgroup`j'==1
	mfx
	matrix rw = e(Xmfx_dydx)
	scalar rwmean = rw[1,1]

*CF section
	cap drop yhat0
	cap drop yhat1
	cap drop cftot
	logit unemployed $special $pscorefunc [pweight=weight] if positive==0 & subgroup`j'==1
 	predict yhat0 if positive==1 & subgroup`j'==1
	noisily summ yhat0
	logit unemployed $special $pscorefunc [pweight=weight] if positive==1 & subgroup`j'==1
 	predict yhat1 if positive==1 & subgroup`j'==1
	gen cftot = yhat1-yhat0 if positive==1 & subgroup`j'==1
	noisily sum cftot
	scalar cftotmean = r(mean)

restore
end

count if subgroup`j'==1
set seed 6363
simul rwmean=rwmean cftotmean=cftotmean, rep(1000): bsloop `j'
bstat, stat(rwmean, cftotmean)
matrix bsse`j' = e(se)

exit
