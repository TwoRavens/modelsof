/************* Estimations and Figures *******************/
clear all
set mem 100m
set more off
global datain  "C:\JECDynamics\Data\"
global dataout "C:\JECDynamics\Results\"
global datatmp "C:\JECDynamics\Temp\"
global fig  "C:\JECDynamics\Figures\"

use "${dataout}Datageneration2.dta", clear
gen cpo=sum(PO)
gen cpn=sum(PN)
gen cpr=sum(PR)
gen cprn=sum(PRN)

* Figure 4 p. 1731: cumulative number of weeks against weeks for four alternative measures of cheating
twoway scatter cpo t, ms(i) c(l) clpattern(dash) lw(medium) cmissing(n) || scatter cpn t, ms(i) c(l) clpattern(dot) lw(medium) cmissing(n) || /*
*/ scatter cpr t, ms(i) c(l) clpattern(solid) lw(medium) cmissing(n) || scatter cprn t, ms(i) c(l) clpattern(dash_dot) lw(medium) cmissing(n) xtitle(weeks) /*
*/ ytitle(weeks) xlabel(0(52)328) ylabel(0(52)328) legend(off) lpattern(l -) color(black black) scheme(s1manual)

* Extrapolate business cycle from Q (variable Qtilde in the article = BCQ1 here)
hprescott Q, stub(HP)
rename HP_Q_sm_1 BCQ1
gen Deviations=PR
replace Deviations = . if PR==1
gen Lakesopen=L
replace Lakesopen=. if L==0
replace Lakesopen=80000*Lakesopen

* Figure 2 p.1727: Total demand and its business cycle
twoway scatter Q t, ms(i) c(j) clpattern(dash) lwidth(medium) sort||scatter BCQ1 t, ms(i) c(l) lw(thick) sort xlabel(0(52)328) /*
*/ ||scatter Deviations t, ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) saving("${fig}QBC.gph", replace) /*
*/ ytitle(Quantity) xtitle(weeks) legend(off) lpattern(l -) color(black black) scheme(s1manual)


* 2SLS simultaneous estimation of the demand and pricing equations for PO and PR, as documented in Table 4 p. 1730
reg3 (q L gr m1-m12) (gr q S1-S4 PO m1-m12), 2sls 
* Porter (1983) With Year Dummies
outreg2 L gr S1 S2 S3 S4 PO q using "${dataout}tablePorter", bdec(3) addstat(sd, `e(rmse_1)',ss, `e(rmse_2)') tex replace
* Porter (1983) With Year Dummies
reg3 (q L gr m1-m12 yr1-yr6) (gr q S1-S4 PO m1-m12), 2sls /* With year dummies */
outreg2 L gr S1 S2 S3 S4 PO q using "${dataout}tablePorter", bdec(3) addstat(sd, `e(rmse_1)',ss, `e(rmse_2)') tex append
* Our PR Without Year Dummies
reg3 (q L gr m1-m12) (gr q S1-S4 PR m1-m12), 2sls
outreg2 L gr S1 S2 S3 S4 PO q using "${dataout}tablePorter", bdec(3) addstat(sd, `e(rmse_1)',ss, `e(rmse_2)') tex replace
* Our PR With Year Dummies
reg3 (q L gr m1-m12 yr1-yr6) (gr q S1-S4 PR m1-m12), 2sls /* PR With year dummies */
outreg2 L gr S1 S2 S3 S4 PO q using "${dataout}tablePorter", bdec(3) addstat(sd, `e(rmse_1)',ss, `e(rmse_2)') tex append

/********************************* Cartel Stability Eastimates (Table 5 p. 1733) ******************************/
gen PR1=PR[_n+1]
arima PR1 N L NWO NWC ER, arima(1,0,1) vce(r)
predict PRhat 
gen PRnew=PRhat>.5
replace PRnew=. if PRhat==.
gen tmp=abs(PR1-PRnew)
tab tmp
count if PRhat>1
count if PRhat<0
drop PRhat PRnew tmp

arima PR1 N L NWO NWC Big1 ER, arima(1,0,1) vce(r)
predict PRhat 
gen PRnew=PRhat>.5
replace PRnew=. if PRhat==.
gen tmp=abs(PR1-PRnew)
tab tmp
count if PRhat>1
count if PRhat<0
drop PRhat PRnew tmp

arima PR1 N L NWO NWC Big2 ER, arima(1,0,1) vce(r)
predict PRhat 
gen PRnew=PRhat>.5
replace PRnew=. if PRhat==.
gen tmp=abs(PR1-PRnew)
tab tmp
count if PRhat>1
count if PRhat<0
drop PRhat PRnew tmp

arima PR1 N L NWO NWC BigQ ER, arima(1,0,1) vce(r)
predict PRhat 
gen PRnew=PRhat>.5
replace PRnew=. if PRhat==.
gen tmp=abs(PR1-PRnew)
tab tmp
count if PRhat>1
count if PRhat<0
drop PRhat PRnew tmp

arima PR1 N L NWO NWC Small1 ER, arima(1,0,1) vce(r)
predict PRhat 
gen PRnew=PRhat>.5
replace PRnew=. if PRhat==.
gen tmp=abs(PR1-PRnew)
tab tmp
count if PRhat>1
count if PRhat<0
drop tmp

*Generate new variables
egen hpct=pctile(MNCY), p(99)
replace hpct=. if MNCY==.
egen lpct=pctile(MNCY), p(1)
replace lpct=. if MNCY==.
gen dMNCYhigh=MNCY>hpct
replace dMNCYhigh=. if MNCY==.
gen dMNCYlow=MNCY<lpct
replace dMNCYlow=. if MNCY==.

* Table 6 Estimates p. 1735
* 2SLS Regression (Linear)
xi: reg3 (q L gr dMNCYhigh dMNCYlow MNCY NWO NWC grstar m1-m12 yr1-yr6) (gr NWO NWC q PRhat grstar m1-m12 S1-S4), 2sls          
* Omega 1 below is Omega 2 in the article, and viceversa
gen om1=[q]NWO*NWO+[q]NWC*NWC+[q]MNCY*MNCY+[q]dMNCYhigh*dMNCYhigh+[q]dMNCYlow*dMNCYlow
summ om1
test [q]NWO [q]NWC [q]MNCY [q]dMNCYhigh [q]dMNCYlow
gen om2=[gr]PRhat*PRhat+[gr]NWO*NWO+[gr]NWC*NWC+[gr]grstar*grstar
summ om2
test [gr]PRhat [gr]NWO [gr]NWC [gr]grstar
gen pcm=1-exp(-[gr]PRhat*PRhat-[gr]NWO*NWO-[gr]NWC*NWC-[gr]grstar*grstar)
summ pcm
gen PCM=pcm /* price-cost margin or degree of oligopolistic power */

predict quhat, eq(q) r
predict gruhat, eq(gr) r
gen tmpq=q
gen tmpgr=gr
replace tmpq=. if quhat==.|gruhat==.
replace tmpgr=. if quhat==.|gruhat==.
egen mq=mean(tmpq)
egen mgr=mean(tmpgr)
gen tmp1=(quhat)^2
replace tmp1=. if quhat==.|gruhat==.
gen tmp2=(q-mq)^2
replace tmp2=. if quhat==.|gruhat==.
egen stmp1=sum(tmp1)
egen stmp2=sum(tmp2)
gen r2d=1-stmp1/stmp2
drop stmp* tmp*
gen tmp1=(gruhat)^2
replace tmp1=. if quhat==.|gruhat==.
gen tmp2=(gr-mgr)^2
replace tmp2=. if quhat==.|gruhat==.
egen stmp1=sum(tmp1)
egen stmp2=sum(tmp2)
gen r2s=1-stmp1/stmp2
summ r2d r2s
drop stmp* tmp* r2*

gen quhat1=quhat+om1
gen tmpom1=om1
replace tmpom1=. if quhat==.|gruhat==.
gen tmpom2=om2
replace tmpom2=. if quhat==.|gruhat==.
egen mom1=mean(tmpom1)
gen gruhat1=gruhat+om2
egen mom2=mean(tmpom2)
gen tmp1=(quhat1-mom1)^2
replace tmp1=. if quhat==.|gruhat==.
gen tmp2=(q-mq)^2
replace tmp2=. if quhat==.|gruhat==.
egen stmp1=sum(tmp1)
egen stmp2=sum(tmp2)
gen r2d=1-stmp1/stmp2
drop stmp* tmp*
gen tmp1=(gruhat1-mom2)^2
replace tmp1=. if quhat==.|gruhat==.
gen tmp2=(gr-mgr)^2
replace tmp2=. if quhat==.|gruhat==.
egen stmp1=sum(tmp1)
egen stmp2=sum(tmp2)
gen r2s=1-stmp1/stmp2
summ r2d r2s
drop stmp* tmp* r2* quhat* gruhat* mq mgr mom1 mom2 tmp*

* Replace 10 missing values (a requirement to estimate business cycles below!)
replace PCM=PCM[_n+1] if PCM[_n]==.
replace PCM=PCM[_n+1] if PCM[_n]==.
replace PCM=PCM[_n+1] if PCM[_n]==.

* Extrapolate business cycle from PCM (variable BCpcm)
hprescott PCM, stub(HP)
rename HP_PCM_sm_1 BCpcm
drop Lakesopen* Deviations
gen Lakesopen=L
replace Lakesopen=.5*Lakesopen
gen Deviations=PR
replace Deviations = . if PR==1

* Figure 5 p. 1736: estimated pcm and its business cycle
twoway scatter pcm t, ms(i) c(j) clpattern(dash) lwidth(medium) sort||scatter BCpcm t, ms(i) c(l) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) xlabel(0(52)328) /*
*/ ylabel(-.5(.5).5) ytitle(PCM) /*
*/ xtitle(weeks [Linear]) legend(off) saving("${fig}pcmBCpoly.gph", replace) lpattern(l -) color(black black) scheme(s1manual)

gen BCQ2= BCQ1^2
gen BCQ3= BCQ1^3
gen BCQ4= BCQ1^4
gen boom=BCQ1[_n]>BCQ1[_n-1]
gen rec=BCQ1[_n]<=BCQ1[_n-1]

* Table 7 p. 1738 column 1 Post-regression estimation of pcm during boom and recession
reg BCpcm BCQ1 BCQ2 BCQ3 BCQ4 N if boom==1&PR==1
predict BCpcm_up_hat if PR==1
reg BCpcm BCQ1 BCQ2 BCQ3 N if rec==1&PR==1
test BCQ1 BCQ2 BCQ3
predict BCpcm_down_hat if PR==1

* Figure 7 p. 1737: pcm Booms and Recessions (Proxied by Lakes Closed/Open) as a Polynomial function of Quantity 
twoway scatter BCpcm_up_hat BCQ1, ms(i) c(j) lpattern(l) sort cmissing(n)||scatter BCpcm_down_hat BCQ1, ms(i) c(j) clpattern(dash) lwidth(thick) /* 
*/ cmissing(n) sort ylabel(.1(.1).6) xtitle(Business Cycles Q [Linear]) ytitle(Estimated PCM Booms and Recessions) legend(off) /*
*/ saving("${fig}pcmu_dBCQBCpoly.gph", replace) lpattern(l -) color(black black) scheme(s1manual)

egen BCQmin=min(BCQ1)
egen tmpBCQ=max(BCQ1-BCQmin)
gen BCQnorm=(BCQ1-BCQmin)/(2*tmpBCQ)

* Figure 6 p. 1737: Normalized quantity business cycles and estimated price-cost margin
twoway scatter BCpcm t, ms(i) c(j) lpattern(l) sort||scatter BCQnorm t, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ||scatter Deviations t,  ms(t) mc(black) cmissing(n) ||scatter Lakesopen t,  ms(d) mc(black) cmissing(n) xlabel(0(52)328) /*
*/ ylabel(0(.1).5) ytitle(Quantitity and Estimated PCM Cycles) xtitle(weeks [Linear]) legend(off) /*
*/ saving("${fig}pcmBCQBCpoly.gph", replace) lpattern(l -) color(black black) scheme(s1manual)

* Extrapolate business cycles from the estimated profit (PROF)
gen profit=GR*pcm*Q/10000 /* Because prices are expressed in 100 lbs and quantities in tons, profits have to be understood in 200,000$ */
replace Lakesopen=2*Lakesopen
gen PROF=profit 
* Replace 10 missing values (a requirement to estimate business cycles below!)
replace PROF=PROF[_n+1] if PROF[_n]==.
replace PROF=PROF[_n+1] if PROF[_n]==.
replace PROF=PROF[_n+1] if PROF[_n]==.
hprescott PROF, stub(HP)
rename HP_PROF_sm_1 BCprofit

* Figure 5 p. 1736: Estimated profit and its business cycles
twoway scatter profit t, ms(i) c(j) clpattern(dash) lwidth(medium) sort||scatter BCprofit t, ms(i) c(l) lwidth(thick) sort /*
*/ ||scatter Deviations t,  ms(t) mc(black) cmissing(n) ||scatter Lakesopen t,  ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(-0.5(.5)1) /*
*/ ytitle(Estimated Profit Cycles) xtitle(weeks [Linear]) legend(off) saving("${fig}profBCpoly.gph", replace) lpattern(l -)/*
*/ color(black black) scheme(s1manual)

replace Lakesopen=Lakesopen/2
* Normalized quantity business cycles and estimated profit
twoway scatter BCprofit t, ms(i) c(j) lpattern(l) sort||scatter BCQnorm t, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ||scatter Deviations t,  ms(t) mc(black) cmissing(n) ||scatter Lakesopen t,  ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(0(0.1)0.5)/*
*/ ytitle(Quantitity and Estimated Profit Cycles) xtitle(weeks [Linear]) legend(off) saving("${fig}profBCQBCpoly.gph", replace) /*
*/ lpattern(l -) color(black black) scheme(s1manual)
drop pcm om1 om2 profit Lakesopen HP* BCpcm PCM BCpcm_* BCprofit PROF Deviations Lakesopen*

/************** Regression with Partial Adjustment Model **********************/
* 2SLS Regression (Linear)
xi: reg3 (q q_1 L gr NWO NWC dMNCYhigh dMNCYlow MNCY  grstar yr1-yr6 m1-m12) (gr NWO NWC q PRhat grstar m1-m12 S1-S4), 2sls /* With year dummies */
gen om1=[q]NWO*NWO+[q]NWC*NWC+[q]MNCY*MNCY+[q]dMNCYhigh*dMNCYhigh+[q]dMNCYlow*dMNCYlow
summ om1
test [q]NWO [q]NWC [q]MNCY [q]dMNCYhigh [q]dMNCYlow
gen om2=[gr]PRhat*PRhat+[gr]NWO*NWO+[gr]NWC*NWC+[gr]grstar*grstar
summ om2
test [gr]PRhat [gr]NWO [gr]NWC [gr]grstar
gen pcm=1-exp(-[gr]PRhat*PRhat-[gr]NWO*NWO-[gr]NWC*NWC-[gr]grstar*grstar)
summ pcm
gen PCM=pcm 

predict quhat, eq(q) r
predict gruhat, eq(gr) r
gen tmpq=q
gen tmpgr=gr
replace tmpq=. if quhat==.|gruhat==.
replace tmpgr=. if quhat==.|gruhat==.
egen mq=mean(tmpq)
egen mgr=mean(tmpgr)
gen tmp1=(quhat)^2
replace tmp1=. if quhat==.|gruhat==.
gen tmp2=(q-mq)^2
replace tmp2=. if quhat==.|gruhat==.
egen stmp1=sum(tmp1)
egen stmp2=sum(tmp2)
gen r2d=1-stmp1/stmp2
drop stmp* tmp*
gen tmp1=(gruhat)^2
replace tmp1=. if quhat==.|gruhat==.
gen tmp2=(gr-mgr)^2
replace tmp2=. if quhat==.|gruhat==.
egen stmp1=sum(tmp1)
egen stmp2=sum(tmp2)
gen r2s=1-stmp1/stmp2
summ r2d r2s
drop stmp* tmp* r2*

gen quhat1=quhat+om1
gen tmpom1=om1
replace tmpom1=. if quhat==.|gruhat==.
gen tmpom2=om2
replace tmpom2=. if quhat==.|gruhat==.
egen mom1=mean(tmpom1)
gen gruhat1=gruhat+om2
egen mom2=mean(tmpom2)
gen tmp1=(quhat1-mom1)^2
replace tmp1=. if quhat==.|gruhat==.
gen tmp2=(q-mq)^2
replace tmp2=. if quhat==.|gruhat==.
egen stmp1=sum(tmp1)
egen stmp2=sum(tmp2)
gen r2d=1-stmp1/stmp2
drop stmp* tmp*
gen tmp1=(gruhat1-mom2)^2
replace tmp1=. if quhat==.|gruhat==.
gen tmp2=(gr-mgr)^2
replace tmp2=. if quhat==.|gruhat==.
egen stmp1=sum(tmp1)
egen stmp2=sum(tmp2)
gen r2s=1-stmp1/stmp2
summ r2d r2s
drop stmp* tmp* r2* quhat* gruhat* mq mgr mom1 mom2 tmp*

replace PCM=PCM[_n+1] if PCM[_n]==.
replace PCM=PCM[_n+1] if PCM[_n]==.
replace PCM=PCM[_n+1] if PCM[_n]==.

gen Deviations=PR
replace Deviations = . if PR==1
gen Lakesopen=L
replace Lakesopen=. if L==0
replace Lakesopen=.5*Lakesopen
hprescott PCM, stub(HP)
rename HP_PCM_sm_1 BCpcm

twoway scatter pcm t, ms(i) c(j) clpattern(dash) lwidth(medium) sort||scatter BCpcm t, ms(i) c(l) lwidth(thick) sort /*
*/||scatter Deviations t, ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(-.5(.5).5) ytitle(PCM) /*
*/ xtitle(weeks [Linear with PA]) legend(off) saving("${fig}pcmBCpoly_1.gph", replace) lpattern(l -) color(black black) scheme(s1manual)

reg BCpcm BCQ1 BCQ2 BCQ3 BCQ4 N if boom==1&PR==1
predict BCpcm_up_hat if PR==1
reg BCpcm BCQ1 BCQ2 BCQ3 N if rec==1&PR==1
predict BCpcm_down_hat if PR==1

twoway scatter BCpcm_up_hat BCQ1, ms(i) c(j) lpattern(l) sort||scatter BCpcm_down_hat BCQ1, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ylabel(.1(.1).6) xtitle(Business Cycles Q [Linear with PA]) ytitle(Estimated PCM Booms and Recessions) legend(off) saving("${fig}pcmu_dBCQBCpoly_1.gph", replace) /*
*/ lpattern(l -) color(black black) scheme(s1manual)

twoway scatter BCpcm t, ms(i) c(j) lpattern(l) sort||scatter BCQnorm t, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(0(.1).5) /*
*/ ytitle(Quantitity and Estimated PCM Cycles) xtitle(weeks [Linear with PA]) legend(off) saving("${fig}pcmBCQBCpoly_1.gph", replace) /*
*/ lpattern(l -) color(black black) scheme(s1manual)

gen profit=GR*pcm*Q/10000
replace Lakesopen=2*Lakesopen
gen PROF=profit 

replace PROF=PROF[_n+1] if PROF[_n]==.
replace PROF=PROF[_n+1] if PROF[_n]==.
replace PROF=PROF[_n+1] if PROF[_n]==.

hprescott PROF, stub(HP)
rename HP_PROF_sm_1 BCprofit

twoway scatter profit t, ms(i) c(j) clpattern(dash) lwidth(medium) sort||scatter BCprofit t, ms(i) c(l) lwidth(thick) sort ||scatter Deviations t, /*
*/ ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(-.5(.5)1) ytitle(Profit)/*
*/ xtitle(weeks [Linear with PA]) legend(off) saving("${fig}profBCpoly_1.gph", replace) lpattern(l -) color(black black) scheme(s1manual)

replace Lakesopen=Lakesopen/2
twoway scatter BCprofit t, ms(i) c(j) lpattern(l) sort||scatter BCQnorm t, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(0(.1).5) /*
*/ ytitle(Quantitity and Estimated Profit Cycles) xtitle(weeks [Linear with PA]) legend(off) saving("${fig}profBCQBCpoly_1.gph", replace)/*
*/ lpattern(l -) color(black black) scheme(s1manual)

drop om1 om2 pcm profit Lakesopen HP* BCpcm PCM BCpcm_* BCprofit PROF Lakesopen* Deviations

/************ Import Data from Kernel Estimation run in R ********************/
sort t
merge t using "${datain}pcm.dta"
drop _merge
summ pcm
gen PCM=pcm 

replace PCM=PCM[_n+1] if PCM[_n]==.
replace PCM=PCM[_n+1] if PCM[_n]==.
replace PCM=PCM[_n+1] if PCM[_n]==.

gen Deviations=PR
replace Deviations = . if PR==1
gen Lakesopen=L
replace Lakesopen=. if L==0
replace Lakesopen=.5*Lakesopen

hprescott PCM, stub(HP)
rename HP_PCM_sm_1 BCpcm

twoway scatter pcm t, ms(i) c(j) clpattern(dash) lwidth(medium) sort||scatter BCpcm t, ms(i) c(l) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(-.5(.5).5) ytitle(PCM) /*
*/ xtitle(weeks [semiparametric]) legend(off) saving("${fig}pcmBCkrnl.gph", replace) lpattern(l -) color(black black) scheme(s1manual)

reg BCpcm BCQ1 BCQ2 BCQ3 BCQ4 N if boom==1&PR==1
predict BCpcm_up_hat if PR==1
reg BCpcm BCQ1 BCQ2 BCQ3 N if rec==1&PR==1
predict BCpcm_down_hat if PR==1

twoway scatter BCpcm_up_hat BCQ1, ms(i) c(j) lpattern(l) sort||scatter BCpcm_down_hat BCQ1, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ylabel(.1(.1).6) xtitle(Business Cycles Q [semiparametric]) ytitle(Estimated PCM Booms and Recessions) legend(off) saving("${fig}pcmu_dBCQBCkrnl.gph", replace) /*
*/ lpattern(l -) color(black black) scheme(s1manual)

twoway scatter BCpcm t, ms(i) c(j) lpattern(l) sort||scatter BCQnorm t, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(0(.1).5) /*
*/ ytitle(Quantitity and Estimated PCM Cycles) xtitle(weeks [semiparametric]) legend(off) saving("${fig}pcmBCQBCkrnl.gph", replace) /*
*/ lpattern(l -) color(black black) scheme(s1manual)

gen profit=GR*pcm*Q/10000
replace Lakesopen=2*Lakesopen
gen PROF=profit 

replace PROF=PROF[_n+1] if PROF[_n]==.
replace PROF=PROF[_n+1] if PROF[_n]==.
replace PROF=PROF[_n+1] if PROF[_n]==.

hprescott PROF, stub(HP)
rename HP_PROF_sm_1 BCprofit

replace profit=. if profit>1 /*It is ony one observation, just to have more comparable Figures*/
twoway scatter profit t, ms(i) c(j) clpattern(dash) lwidth(medium) sort||scatter BCprofit t, ms(i) c(l) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(-.5(.5)1)/*
*/ ytitle(Estimated Profit Cycles) xtitle(weeks [semiparametric]) legend(off) saving("${fig}profBCkrnl.gph", replace) lpattern(l -)/*
*/ color(black black) scheme(s1manual)

replace Lakesopen=Lakesopen/2
twoway scatter BCprofit t, ms(i) c(j) lpattern(l) sort||scatter BCQnorm t, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(0(.1).5)/*
*/ ytitle(Quantitity and Estimated Profit Cycles) xtitle(weeks [semiparametric]) legend(off) saving("${fig}profBCQBCkrnl.gph", replace)/*
*/ lpattern(l -) color(black black) scheme(s1manual)

drop pcm profit Lakesopen HP* BCpcm PCM BCpcm_* BCprofit PROF Lakesopen* Deviation

/************ Import Data from the semiparametric estimation of the Partial Adjustment Model run in R ********************/
sort t
merge t using "${datain}pcmlag.dta"
drop _merge
summ pcm
gen PCM=pcm 

replace PCM=PCM[_n+1] if PCM[_n]==.
replace PCM=PCM[_n+1] if PCM[_n]==.
replace PCM=PCM[_n+1] if PCM[_n]==.
gen Deviations=PR
replace Deviations = . if PR==1
gen Lakesopen=L
replace Lakesopen=. if L==0
replace Lakesopen=.5*Lakesopen

hprescott PCM, stub(HP)
rename HP_PCM_sm_1 BCpcm

twoway scatter pcm t, ms(i) c(j) clpattern(dash) lwidth(medium) sort||scatter BCpcm t, ms(i) c(l) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(-.5(.5).5) ytitle(PCM) /*
*/ xtitle(weeks [Semiparametric with PA]) legend(off) saving("${fig}pcmBCkrnl_1.gph", replace) lpattern(l -) color(black black) scheme(s1manual)

reg BCpcm BCQ1 BCQ2 BCQ3 BCQ4 N if boom==1&PR==1
predict BCpcm_up_hat if PR==1
reg BCpcm BCQ1 BCQ2 BCQ3 N if rec==1&PR==1
predict BCpcm_down_hat if PR==1

twoway scatter BCpcm_up_hat BCQ1, ms(i) c(j) lpattern(l) sort||scatter BCpcm_down_hat BCQ1, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ylabel(.1(.1).6) xtitle(Business Cycles Q [Semiparametric with PA]) ytitle(Estimated PCM Booms and Recessions) legend(off) saving("${fig}pcmu_dBCQBCkrnl_1.gph", replace) /*
*/ lpattern(l -) color(black black) scheme(s1manual)

twoway scatter BCpcm t, ms(i) c(j) lpattern(l) sort||scatter BCQnorm t, ms(i) c(j) clpattern(dash) lwidth(thick) sort /* 
*/ ||scatter Deviations t, ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(0(.1).5) /*
*/ ytitle(Quantitity and Estimated PCM Cycles) xtitle(weeks [Semiparametric with PA]) legend(off) saving("${fig}pcmBCQBCkrnl_1.gph", replace) /*
*/ lpattern(l -) color(black black) scheme(s1manual)

gen profit=GR*pcm*Q/10000
replace Lakesopen=2*Lakesopen
gen PROF=profit 

replace PROF=PROF[_n+1] if PROF[_n]==.
replace PROF=PROF[_n+1] if PROF[_n]==.
replace PROF=PROF[_n+1] if PROF[_n]==.

hprescott PROF, stub(HP)
rename HP_PROF_sm_1 BCprofit

twoway scatter profit t, ms(i) c(j) clpattern(dash) lwidth(medium) sort||scatter BCprofit t, ms(i) c(l) lwidth(thick) sort /* 
*/ ||scatter Deviations t, ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(-.5(.5)1) /*
*/ ytitle(Profit) xtitle(weeks [Semiparametric with PA]) legend(off) saving("${fig}profBCkrnl_1.gph", replace)/*
*/ lpattern(l -) color(black black) scheme(s1manual)

replace Lakesopen=Lakesopen/2
twoway scatter BCprofit t, ms(i) c(j) lpattern(l) sort||scatter BCQnorm t, ms(i) c(j) clpattern(dash) lwidth(thick) sort /*
*/ ||scatter Deviations t, ms(t) mc(black) cmissing(n) ||scatter Lakesopen t, ms(d) mc(black) cmissing(n) xlabel(0(52)328) ylabel(0(.1).5) /*
*/ ytitle(Quantitity and Estimated Profit Cycles) xtitle(weeks [Semiparametric with PA]) legend(off) saving("${fig}profBCQBCkrnl_1.gph", replace)/*
*/ lpattern(l -) color(black black) scheme(s1manual)
