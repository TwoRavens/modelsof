************************************
* Program to replicate figures and tables in Voting after the bombing
************************************

clear
use h:\voting_after_bombing\dataVAB


**************************************
* FIGURE 1
**************************************
gen rata=pp/psoe
collapse rata if id!=53, by(year dtreat)
label variable rata "Ratio conservatives over socialists votes"
twoway (line rata year if dtreat==1,lpattern(solid) lcolor(black) legend(label(1 "Resident voters"))) (line rata year if dtreat==0, lpattern(dash) lcolor(black) legend(label(2 "Non-resident voters"))), ylabel(0(1)2) xlabel(1989 1993 1996 2000 2004)


************
* estimation 
************
clear
use h:\voting_after_bombing\dataVAB
gen rata=pp/psoe

egen idcluster=group(year dtreat)

gen d04=0
replace d04=1 if year==2004
gen d00=0
replace d00=1 if year==2000
gen d96=0
replace d96=1 if year==1996
gen d93=0
replace d93=1 if year==1993
gen d89=0
replace d89=1 if year==1989
gen dt=dtreat*d04



****************************************
* TABLE 2. All the sample
*****************************************
regress rata d04 d00 d96 d93 dtreat dt if id!=53, cluster(idcluster)
* test of the ratio smaller than 1
test _b[d04]+_b[dtreat]+_b[_cons]=1.0
local sign_dt=sign(_b[d04]+_b[dtreat]+_b[_cons]-1)
display "H0: ratio<=1 p-value=" ttail(r(df_r), `sign_dt'*sqrt(r(F)))

regress rata d04 d00 d96 d93 dtreat dt if id!=53, cluster(id)
regress rata d04 d00 d96 d93 dtreat dt if id!=53
iis idcluster
tis year
xtreg rata d04 d00 d96 d93 dtreat dt if id!=53, be
xtset, clear



********************************************
*** TABLE 2. Placebo exercise
********************************************
gen dtp=0
replace dtp=1 if year==2000 & dtreat==1
regress rata d00 d96 d93 dtreat dtp if id!=53 & year!=2004, cluster(idcluster) 
regress rata d00 d96 d93 dtreat dtp if id!=53 & year!=2004, cluster(id)
iis id
tis year
xtreg rata d00 d96 d93 dtreat dtp if id!=53 & year!=2004, fe robust
xtset, clear
iis idcluster
tis year
xtreg rata d00 d96 d93 dtreat dtp if id!=53 & year!=2004, be
xtset, clear



*****************************************************
******** counterfactual vote for conservative party
*****************************************************

** scale factor for the sum of the proportions of pp and psoe

gen sumboth=pp+psoe
qui sum sumboth if dtreat==1 & id==53 & year!=2004
scalar meansum=r(mean)
gen y04=sumboth if dtreat==1 & year==2004 & id!=53
qui sum y04 
scalar sum04=r(mean)
drop y04 sumboth
scalar factor=meansum/sum04

** using actual sum of pp+psoe

regress rata d04 d00 d96 d93 dtreat dt if id!=53, cluster(idcluster)
mat coef=get(_b)
* notation- nb: no bombing
gen nbrat=rata-coef[1,6]*dt
* counterfactual participation rate (nobombing part)
qui regress part d04 d00 d96 d93 dtreat dt if id!=53, cluster(idcluster)
mat coef1=get(_b)
gen nbpart=part-coef1[1,6]*dt
gen nbtvpp=nbrat/(1+nbrat)*(pp+psoe)*factor*voters*nbpart/10000
egen nbapp=sum(nbtvpp) if id!=53, by(year dtreat)
gen nbtv=voters*nbpart/100
egen nbavot=sum(nbtv) if id!=53, by(year dtreat)
gen nbpp=nbapp/nbavot
tabulate year dtreat if year==2004, summarize(nbpp) nostandard nofreq noobs wrap nolabel
drop nbrat nbpart nbtvpp nbapp nbtv nbavot nbpp

*** using adjusted sum of pp+psoe

gen trend=1
replace trend=2 if year==1993
replace trend=3 if year==1996
replace trend=4 if year==2000
replace trend=5 if year==2004
gen sumboth=pp+psoe
qui regress sumboth dtreat trend if id!=53, cluster(idcluster)
predict xb
egen predsum=mean(xb) if id!=53, by(year dtreat)
qui tabulate year dtreat, summarize(predsum) nostandard nofreq noobs wrap nolabel
qui regress rata d04 d00 d96 d93 dtreat dt if id!=53, cluster(idcluster)
mat coef=get(_b)
* notation- nb: no bombing
gen nbrat=rata-coef[1,6]*dt
* counterfactual participation rate (nobombing part)
regress part d04 d00 d96 d93 dtreat dt if id!=53, cluster(idcluster)
mat coef1=get(_b)
gen nbpart=part-coef1[1,6]*dt
gen nbtvpp=nbrat/(1+nbrat)*predsum*factor*voters*nbpart/10000
egen nbapp=sum(nbtvpp) if id!=53, by(year dtreat)
gen nbtv=voters*nbpart/100
egen nbavot=sum(nbtv) if id!=53, by(year dtreat)
gen nbpp=nbapp/nbavot
tabulate year dtreat if year==2004, summarize(nbpp) nostandard nofreq noobs wrap nolabel
drop nbrat nbpart nbtvpp nbapp nbtv nbavot nbpp


************************************
* FIGURE 2. Synthetic control group
************************************

label variable rata "Ratio votes conservatives over socialists"
drop if dtreat==1 & id!=53
drop if dtreat==0 & id==53
egen idnew=group(id dtreat)
tsset idnew year
*synth rata pp(1989) psoe(1989) rata(1996) rata(2000), trunit(53) trperiod(2004) fig
synth rata pp(1989) pp(1993) rata(1996) rata(2000), trunit(53) trperiod(2004) fig



**********************************
* regression using the averages
**********************************
clear
use h:\voting_after_bombing\dataVAB
egen idcluster=group(year dtreat)
gen rata=pp/psoe
gen d04=0
replace d04=1 if year==2004
gen d00=0
replace d00=1 if year==2000
gen d96=0
replace d96=1 if year==1996
gen d93=0
replace d93=1 if year==1993
gen d89=0
replace d89=1 if year==1989
gen dt=dtreat*d04
collapse rata d04 d00 d96 d93 dtreat dt, by(year idcluster)
regress rata d04 d00 d96 d93 dtreat dt
test _b[d04]+_b[dtreat]+_b[_cons]=1
local sign_dt=sign(_b[d04]+_b[dtreat]+_b[_cons]-1)
display "H0: ratio<1 p-value=" ttail(r(df_r), `sign_dt'*sqrt(r(F)))
*regress rata d04 d00 d96 d93 dtreat dt, robust


