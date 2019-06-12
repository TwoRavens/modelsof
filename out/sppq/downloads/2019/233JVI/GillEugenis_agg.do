* use "GillEugenis_agg.dta"

// The code that follows requires the following packages:
// * fitstat

version 15.1

// Table 1, Bottom Half (Descriptives)

tabstat c1vshare c2vshare chnumber c2lncash c1lastopp c1lnmedia murderlog lawyerlog ///
 c1fem c2fem c1ranked c2ranked c1prior c2prior partisan if challenger==1 ///
 & c1inc==1, statistics(mean sd min max n) c(s) format(%9.2f) 
 
// Table 4: Election-Centered Model of Challenger Vote Share

reg c2vshare c1fem##i.c2fem c.c2lncash c.chnumber i.c1prior c.c1lastopp ///
 c.c1lnmedia i.c2ranked i.c2prior i.partisan c.lawyerlog c.murderlog i.year if ///
 challenger==1 & c1inc==1, cluster(stateid) cformat(%9.3f) 

testparm i.year
fitstat

// Figure 2: 

margins c1fem#c2fem
marginsplot, yline(50)

// Bivariate Relationships from Footnotes

tab2 c1fem c1app if c1inc==1 , r all // fn. 10

// Diagnostics

// OLS Model
reg c2vshare c1fem##i.c2fem c.c2lncash c.chnumber i.c1prior c.c1lastopp ///
 c.c1lnmedia i.c2ranked i.c2prior i.partisan c.lawyerlog c.murderlog i.year if ///
 challenger==1 & c1inc==1, cluster(stateid) cformat(%9.3f) 

predict res, residual
predict c2vhat

histogram c2vshare if challenger==1 & c1inc==1, frequency normal kdensity
sktest c2vshare if challenger==1 & c1inc==1

sktest res
rvfplot

preserve
set seed 111
sample 100, count
twoway (scatter c2vshare c2vhat) (lfit c2vshare c2vhat)
restore

estat vif

testparm i.year

drop res c2vhat

// Heckman Model

heckman c2vshare c2lncash chnumber i.c1prior c.c1lastopp i.c1fem##i.c2fem i.c2ranked ///
 i.c2prior c.c1lnmedia i.partisan c.lawyerlog c.murderlog i.year , ///
 select(challenger = c.lawyerlog i.partisan i.c1fem i.c1prior#c.c1last c.c1negpln ///
 c.c1rank c.c1lncash i.year) cluster(stateid)
 

// Random Effects Model (Not Significant Nor Appropriate) 

xtreg c2vshare c2lncash chnumber i.c1prior c.c1lastopp i.c1fem##i.c2fem i.c2ranked ///
 i.c2prior c.c1lnmedia i.partisan c.lawyerlog c.murderlog i.year if c1inc==1
estimates store rando

xtreg c2vshare c2lncash chnumber i.c1prior c.c1lastopp i.c1fem##i.c2fem i.c2ranked ///
 i.c2prior c.c1lnmedia i.partisan c.lawyerlog c.murderlog i.year if c1inc==1, fe
estimates store fixie

hausman fixie rando

drop _est_rando _est_fixie

