
****************************************************************************************************
*Replication for:On the Frontline Every Day? Subnational Deployment of United Nations Peacekeepers *
*Authors: Andrea Ruggeri, Han Dourssen, Ismene Gizelis									 		   *
*Do file date: 18/02/2016																 		   *
*Do file author: AR																				   *
*Machine: MacBook, Oxford																		   *
*Journal: British Journal of Political Science													   *
*Further materila: www.aruggeri.eu															       *
****************************************************************************************************

*********************
*Load data			*
*********************
use "RDG_BJPS2016.dta", clear
*************
*Table 1	*
*************
*Model1
logit PKO lag1conflict lag2conflict  borddist capdist avgttime   yrsWOdep  yrsWOdep2 yrsWOdep3  onset gridN , cluster(gid)   
est store mod1
fitstat
lroc, nograph
listcoef, percent 
*Model 1 Bis
relogit PKO lag1conflict lag2conflict  borddist capdist avgttime   yrsWOdep  yrsWOdep2 yrsWOdep3  onset  gridN  , cluster(gid)   
est store mod1b
*Model 2 
logit PKO   lag1conflict lag2conflict  avgttime yrsWOdep  yrsWOdep2 yrsWOdep3 onset gridN    , cluster(gid)   
est store mod2
listcoef, percent
fitstat
lroc, nograph
*Model 3 
logit PKO   lag1conflict lag2conflict  borddist capdist  yrsWOdep  yrsWOdep2 yrsWOdep3 onset gridN     , cluster(gid)   
est store mod3
listcoef, percent
fitstat
lroc, nograph
*Model 4 
logit PKO lag1conflict lag2conflict  borddist capdist  avgttime yrsWOdep  yrsWOdep2 yrsWOdep3 onset gridN   avgprecip avgmnt avgadjimr ppp2000_40   , cluster(gid)   
est store mod4
listcoef, percent 
fitstat
lroc, nograph
*Model 4bis 
relogit PKO lag1conflict lag2conflict  borddist capdist  avgttime   yrsWOdep  yrsWOdep2 yrsWOdep3 onset gridN   avgprecip avgmnt avgadjimr ppp2000_40   , cluster(gid)   
est store mod4b
estout mod1 mod1b mod2 mod3 mod4 mod4b, cells(b (star fmt(3)) se)  stats(alpha bic N chi2)  style(fixed)
**********
*Figure 1*
**********
use "RDG_BJPS2016.dta", clear
logit  PKO avgttime borddist capdist lag1conflict lag2conflict   yrsWOdep  yrsWOdep2 yrsWOdep3 onset gridN     
margins, at(avgttime=(0(60) 2000) lag2conflict=(0 1) ) atmeans
marginsplot, recast(line) recastci(rline) scheme(s1mono)
**********************
*Table 2 			*
**********************
use "RDG_BJPS2016pr10cw.dta", clear
relogit PKO avgttime borddist capdist lag1conflict lag2conflict   yrsWOdep  yrsWOdep2 yrsWOdep3 onset gridN   avgprecip avgmnt avgadjimr ppp2000_40 , cluster(gid)
use "RDG_BJPS2016bigsmall.dta" , clear
relogit PKO  BIGtime  SMALLtime BIGbord SMALLbord BIGcap SMALLcap lag1conflict lag2conflict   yrsWOdep  yrsWOdep2 yrsWOdep3 onset gridN   avgprecip avgmnt avgadjimr ppp2000_40   , cluster(newgid)  nocon 
**********
*Figure 2* 
**********
use "PKOspLAGSbjps.dta", clear
logit  PKO avgttime borddist capdist lag1conflict lag2conflict   yrsWOdep  yrsWOdep2 yrsWOdep3 onset gridN  
estimates store base
logit  PKO avgttime borddist capdist lag1conflict lag2conflict   yrsWOdep  yrsWOdep2 yrsWOdep3 onset gridN  avgprecip avgmnt avgadjimr ppp2000_40   spLag2_PKO   
estimates store spPKO
logit  PKO avgttime borddist capdist lag1conflict lag2conflict   yrsWOdep  yrsWOdep2 yrsWOdep3 onset gridN  avgprecip avgmnt avgadjimr ppp2000_40   spLag2_Conflict   
estimates store spCON
logit  PKO avgttime borddist capdist lag1conflict lag2conflict   yrsWOdep  yrsWOdep2 yrsWOdep3 onset gridN  avgprecip avgmnt avgadjimr ppp2000_40   spLag2_UNstrenght   
estimates store spPKOw
coefplot base spPKO spPKOw, keep(  lag2conflict avgttime spLag2_PKO spLag2_Conflict spLag2_UNstrenght )  scheme(s1mono) label   xline(0 , lp(.)) ciopts(lp(-)) ///
legend(pos(5) ring(0) col(1)  lab(2 "Baseline") lab(4 "SpPKO")  lab(6 "SpPKOsize")) ///
note("Omitted controls, same specifications as Model 4 Table 1 plus spatial lags")

**********
*Figure 3*
**********
use "Sierraleonedeployment.dta",clear
twoway (line strCAP modate, lc(balck)  sort) (line strNOCAP modate, lc(black) lp(dash)sort), ///
ytitle("Peacekeepers Deployed")  xtitle("") scheme(s1mono) ///
title( "UN Peacekeepers Deployment in Sierra Leone") subtitle("Capital VS Country") ///
legend(label(1 "UN Capital") label(2 "UN non-capital"))
