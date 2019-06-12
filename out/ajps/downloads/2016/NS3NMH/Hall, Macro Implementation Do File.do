
***All data analyses in this article were carried out using Stata/MP 14.1 for Mac (64-bit Intel).***

*Note: These commands require the gcause and kpss pakaages are required*
findit gcause
findit kpss

***Open "MacroImplementation.dta"***

***Data Graph***
twoway line cumpun year if year>1950 & year<2010, lpattern(dash) || ///
	line cumconinc year if year>1950 & year<2010, yaxis(2) lpattern(dot) lcolor(gs1)|| ///
	line incarceration_rate year if year>1950 & year<2010, ///
	ytitle("Congressional Policy", axis(1) margin(small)) ytitle("Supreme Court Policy", axis(2) margin(small)) ///
	ytitle("Incarceration Rate", axis(3) margin(small)) yaxis(3) scheme(s1mono) xsize(6)  ///
	legend(label(1 "Congressional Policy") label(2 "Supreme Court Policy") ///
	label(3 "Incarceration Rate") region(lp(blank))) xlabel(1950(20)2010) ///
	xtitle("Year", margin(small))

***Table 1 (ECM)***
reg dincarceration_rate lincarceration_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug

***LRM for Table 1 (Figure 3a)***
	*Run the model with contemporaneous and delta X variables
	reg dincarceration_rate lincarceration_rate d.zcumconinc zcumconinc d.zcumpun_detr zcumpun_detr ldzPres2 d.zcrimerate zcrimerate d.zdrug zdrugmort

	*Predict Yhat
	predict incarceration_ratefit, xb

	*Replace the lagged y with the fitted values of Y.  The dependent variable is now the contemporaneous Y.  
	reg incarceration_rate incarceration_ratefit d.zcumconinc zcumconinc d.zcumpun_detr zcumpun_detr ldzPres2 d.zcrimerate zcrimerate d.zdrug zdrugmort

***LRMs Over Time for Table 1 (Figure 3b)***
***Open "LRM_Decay.dta"***
twoway line courteff congeff drugeff year, scheme(s1mono) xlabel(1(1)22) ylabel(0(10)100) title("") ///
ytitle("Annual Effect on New Incarcerations", size(medium) margin(medsmall)) ///
xtitle("Year in Which Effect Takes Place", size(medium) margin(medsmall)) ///
legend(region(lp(blank))) lpattern(solid dash dot) lwidth(thin thin thick) lcolor(gs2 gs6 gs2)


***Open "MacroImplementation.dta"***

***Table 2 (SEM)***
program indireff, rclass
  sem (dfile_rate <- lfile_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug) ///
  (dconviction_rate <- lconviction_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug) ///
  (dplea_rate <- lplea_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug) ///
  (dincarceration_rate <- lincarceration_rate dconviction_rate lconviction_rate dplea_rate lplea_rate dfile_rate lfile_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug), nocapslatent
  estat teffects
  mat bi = r(indirect)
  mat bd = r(direct)
  mat bt = r(total)
  return scalar flfile_rate = el(bd,1,1)
  return scalar fdcumconinc = el(bd,1,2)
  return scalar flcumconinc = el(bd,1,3)
  return scalar fdcumpun_detr = el(bd,1,4)
  return scalar flcumpun_detr = el(bd,1,5)
  return scalar fldPres2 = el(bd,1,6)
  return scalar fdcrimerate = el(bd,1,7)
  return scalar flcrimerate = el(bd,1,8)
  return scalar fddrug = el(bd,1,9)
  return scalar fldrug = el(bd,1,10)
  return scalar cdcumconinc = el(bd,1,11)
  return scalar clcumconinc = el(bd,1,12)
  return scalar cdcumpun_detr = el(bd,1,13)
  return scalar clcumpun_detr = el(bd,1,14)
  return scalar cldPres2 = el(bd,1,15)
  return scalar cdcrimerate = el(bd,1,16)
  return scalar clcrimerate = el(bd,1,17)
  return scalar cddrug = el(bd,1,18)
  return scalar cldrug = el(bd,1,19)
  return scalar clconviction_rate = el(bd,1,20)
  return scalar pdcumconinc = el(bd,1,21)
  return scalar plcumconinc = el(bd,1,22)
  return scalar pdcumpun_detr = el(bd,1,23)
  return scalar plcumpun_detr = el(bd,1,24)
  return scalar pldPres2 = el(bd,1,25)
  return scalar pdcrimerate = el(bd,1,26)
  return scalar plcrimerate = el(bd,1,27)
  return scalar pddrug = el(bd,1,28)
  return scalar pldrug = el(bd,1,29)
  return scalar plplea_rate = el(bd,1,30)
  return scalar idfile_rate = el(bd,1,31)
  return scalar idconviction_rate = el(bd,1,32)
  return scalar idplea_rate = el(bd,1,33)
  return scalar ilfile_rate = el(bd,1,34)
  return scalar idcumconinc = el(bd,1,35)
  return scalar ilcumconinc = el(bd,1,36)
  return scalar idcumpun_detr = el(bd,1,37)
  return scalar ilcumpun_detr = el(bd,1,38)
  return scalar ildPres2 = el(bd,1,39)
  return scalar idcrimerate = el(bd,1,40)
  return scalar ilcrimerate = el(bd,1,41)
  return scalar iddrug = el(bd,1,42)
  return scalar ildrug = el(bd,1,43)
  return scalar ilconviction_rate = el(bd,1,44)
  return scalar ilplea_rate = el(bd,1,45)
  return scalar ilincarceration_rate = el(bd,1,46)
  return scalar dcumconinc = el(bi,1,35)
  return scalar lcumconinc = el(bi,1,36)
  return scalar dcumpun_detr = el(bi,1,37)
  return scalar lcumpun_detr = el(bi,1,38)
  return scalar ldPres2 = el(bi,1,39)
  return scalar dcrimerate = el(bi,1,40)
  return scalar lcrimerate = el(bi,1,41)
  return scalar ddrug = el(bi,1,42)
  return scalar ldrug = el(bi,1,43)
end

set seed 358395

bootstrap r(fdcumconinc) r(flcumconinc) r(fdcumpun_detr) r(flcumpun_detr) r(fldPres2) r(fdcrimerate) r(flcrimerate) r(fddrug) r(fldrug) r(flfile_rate), reps(1000): indireff
estat bootstrap, bc percentile 
estimates store m1

bootstrap r(cdcumconinc) r(clcumconinc) r(cdcumpun_detr) r(clcumpun_detr) r(cldPres2) r(cdcrimerate) r(clcrimerate) r(cddrug) r(cldrug) r(clconviction_rate), reps(1000): indireff
estat bootstrap, bc percentile
estimates store m2

bootstrap r(pdcumconinc) r(plcumconinc) r(pdcumpun_detr) r(plcumpun_detr) r(pldPres2) r(pdcrimerate) r(plcrimerate) r(pddrug) r(pldrug) r(plplea_rate), reps(1000): indireff
estat bootstrap, bc percentile
estimates store m3

bootstrap r(idcumconinc) r(ilcumconinc) r(idcumpun_detr) r(ilcumpun_detr) r(ildPres2) r(idcrimerate) r(ilcrimerate) r(iddrug) r(ildrug) r(ilincarceration_rate) r(idfile_rate) r(ilfile_rate) r(idconviction_rate) r(ilconviction_rate) r(idplea_rate) r(ilplea_rate), reps(1000): indireff
estat bootstrap, bc percentile 
estimates store m4

bootstrap r(dcumconinc) r(lcumconinc) r(dcumpun_detr) r(lcumpun_detr) r(ldPres2) r(dcrimerate) r(lcrimerate) r(ddrug) r(ldrug), reps(1000): indireff
estat bootstrap, bc percentile 
estimates store m5

***Table 3 (IV)***
program indireffhat, rclass
  sem (dfile_rate <- lfile_rate dhat lhat dcumpun_detr lcumpun_detr ldPres2 lPres2 dcrimerate lcrimerate ddrug ldrug l18zapp) ///
  (dconviction_rate <- lconviction_rate dhat lhat dcumpun_detr lcumpun_detr ldPres2 lPres2 dcrimerate lcrimerate ddrug ldrug l18zapp) ///
  (dplea_rate <- lplea_rate dhat lhat dcumpun_detr lcumpun_detr ldPres2 lPres2 dcrimerate lcrimerate ddrug ldrug l18zapp) ///
  (dincarceration_rate <- lincarceration_rate dconviction_rate lconviction_rate dplea_rate lplea_rate dfile_rate lfile_rate dhat lhat dcumpun_detr lcumpun_detr ldPres2 lPres2 dcrimerate lcrimerate ddrug ldrug l18zapp), nocapslatent
  estat teffects
  mat bi = r(indirect)
  mat bd = r(direct)
  mat bt = r(total)
  return scalar flfile_rate = el(bd,1,1)
  return scalar fdhat = el(bd,1,2)
  return scalar flhat = el(bd,1,3)
  return scalar fdcumpun_detr = el(bd,1,4)
  return scalar flcumpun_detr = el(bd,1,5)
  return scalar fldPres2 = el(bd,1,6)
  return scalar flPres2 = el(bd,1,7)
  return scalar fdcrimerate = el(bd,1,8)
  return scalar flcrimerate = el(bd,1,9)
  return scalar fddrug = el(bd,1,10)
  return scalar fldrug = el(bd,1,11)
  return scalar fl18app = el(bd,1,12)
  return scalar cdhat = el(bd,1,13)
  return scalar clhat = el(bd,1,14)
  return scalar cdcumpun_detr = el(bd,1,15)
  return scalar clcumpun_detr = el(bd,1,16)
  return scalar cldPres2 = el(bd,1,17)
  return scalar clPres2 = el(bd,1,18)
  return scalar cdcrimerate = el(bd,1,19)
  return scalar clcrimerate = el(bd,1,20)
  return scalar cddrug = el(bd,1,21)
  return scalar cldrug = el(bd,1,22)
  return scalar cl18app = el(bd,1,23)
  return scalar clconviction_rate = el(bd,1,24)
  return scalar pdhat = el(bd,1,25)
  return scalar plhat = el(bd,1,26)
  return scalar pdcumpun_detr = el(bd,1,27)
  return scalar plcumpun_detr = el(bd,1,28)
  return scalar pldPres2 = el(bd,1,29)
  return scalar plPres2 = el(bd,1,30)
  return scalar pdcrimerate = el(bd,1,31)
  return scalar plcrimerate = el(bd,1,32)
  return scalar pddrug = el(bd,1,33)
  return scalar pldrug = el(bd,1,34)
  return scalar pl18app = el(bd,1,35)
  return scalar plplea_rate = el(bd,1,36)
  return scalar idfile_rate = el(bd,1,37)
  return scalar idconviction_rate = el(bd,1,38)
  return scalar idplea_rate = el(bd,1,39)
  return scalar ilfile_rate = el(bd,1,40)
  return scalar idhat = el(bd,1,41)
  return scalar ilhat = el(bd,1,42)
  return scalar idcumpun_detr = el(bd,1,43)
  return scalar ilcumpun_detr = el(bd,1,44)
  return scalar ildPres2 = el(bd,1,45)
  return scalar ilPres2 = el(bd,1,46)
  return scalar idcrimerate = el(bd,1,47)
  return scalar ilcrimerate = el(bd,1,48)
  return scalar iddrug = el(bd,1,49)
  return scalar ildrug = el(bd,1,50)
  return scalar il18app = el(bd,1,51)
  return scalar ilconviction_rate = el(bd,1,52)
  return scalar ilplea_rate = el(bd,1,53)
  return scalar ilincarceration_rate = el(bd,1,54)
  return scalar dhat = el(bi,1,41)
  return scalar lhat = el(bi,1,42)
  return scalar dcumpun_detr = el(bi,1,43)
  return scalar lcumpun_detr = el(bi,1,44)
  return scalar ldPres2 = el(bi,1,45)
  return scalar lPres2 = el(bi,1,46)
  return scalar dcrimerate = el(bi,1,47)
  return scalar lcrimerate = el(bi,1,48)
  return scalar ddrug = el(bi,1,49)
  return scalar ldrug = el(bd,1,50)
  return scalar l18app = el(bd,1,51)
end

set seed 358395

bootstrap r(fdhat) r(flhat) r(fdcumpun_detr) r(flcumpun_detr) r(fldPres2) r(flPres2) r(fdcrimerate) r(flcrimerate) r(fddrug) r(fldrug) r(fl18app) r(flfile_rate), reps(1000): indireffhat
estat bootstrap, bc percentile 

bootstrap r(cdhat) r(clhat) r(cdcumpun_detr) r(clcumpun_detr) r(cldPres2) r(clPres2) r(cdcrimerate) r(clcrimerate) r(cddrug) r(cldrug) r(cl18app) r(clconviction_rate), reps(1000): indireffhat
estat bootstrap, bc percentile

bootstrap r(pdhat) r(plhat) r(pdcumpun_detr) r(plcumpun_detr) r(pldPres2) r(plPres2) r(pdcrimerate) r(plcrimerate) r(pddrug) r(pldrug) r(pl18app) r(plplea_rate), reps(1000): indireffhat
estat bootstrap, bc percentile

bootstrap r(idhat) r(ilhat) r(idcumpun_detr) r(ilcumpun_detr) r(ildPres2) r(ilPres2) r(idcrimerate) r(ilcrimerate) r(iddrug) r(ildrug) r(il18app) r(ilincarceration_rate) r(idfile_rate) r(ilfile_rate) r(idconviction_rate) r(ilconviction_rate) r(idplea_rate) r(ilplea_rate), reps(1000): indireffhat
estat bootstrap, bc percentile 

bootstrap r(dhat) r(lhat) r(dcumpun_detr) r(lcumpun_detr) r(ldPres2) r(lPres2) r(dcrimerate) r(lcrimerate) r(ddrug) r(ldrug) r(l18app), reps(1000): indireffhat
estat bootstrap, bc percentile

***Granger Causality test***
varsoc incarceration_rate cumconinc
gcause cumconinc incarceration_rate, lags(3)
gcause incarceration_rate cumconinc, lags(3)

varsoc incarceration_rate cumpun
gcause cumpun incarceration_rate, lags(2)
gcause incarceration_rate cumpun, lags(2)

varsoc file_rate cumconinc
gcause cumconinc file_rate, lags(4)
gcause file_rate cumconinc, lags(4)

varsoc conviction_rate cumconinc
gcause cumconinc conviction_rate, lags(2)
gcause conviction_rate cumconinc, lags(2)

varsoc plea_rate cumconinc
gcause cumconinc plea_rate, lags(2)
gcause plea_rate cumconinc, lags(2)

varsoc file_rate cumpun
gcause cumpun file_rate, lags(2)
gcause file_rate cumpun, lags(2)

varsoc file_rate incarceration_rate
gcause file_rate incarceration_rate, lags(2)
gcause incarceration_rate file_rate, lags(2)

varsoc conviction_rate incarceration_rate
gcause incarceration_rate conviction_rate, lags(2)
gcause incarceration_rate cumconinc, lags(2)

varsoc plea_rate incarceration_rate
gcause plea_rate incarceration_rate, lags(1)
gcause incarceration_rate plea_rate, lags(1)



***Supporting Information***
**Section 1: Additional Information on Policy Measures**
*Table SI-1: Alternative Measure of Supreme Court Policy*
merge 1:1 year using "StateCaseMeasure.dta", keepusing(cumconinc_state)
drop if _merge==2
drop _merge

tsset year
gen dcumconinc_state=d.cumconinc_state
gen lcumconinc_state=l.cumconinc_state

reg dincarceration_rate lincarceration_rate dcumconinc_state lcumconinc_state dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug

**Seciton 2: Error Correction Tests**
*Table SI-2: Testing for Stationarity of Undifferenced Variables*
dfuller incarceration_rate
kpss incarceration_rate

dfuller file_rate
kpss file_rate

dfuller conviction_rate
kpss conviction_rate

dfuller plea_rate
kpss plea_rate

dfuller cumconinc
kpss cumconinc

dfuller cumpun_detr
kpss cumpun_detr

dfuller Pres2
kpss Pres2

dfuller crimerate
kpss crimerate

dfuller drugmort
kpss drugmort

*Table SI-3: Testing for Stationarity of First-differenced Variables*
dfuller dincarceration_rate
kpss dincarceration_rate

dfuller dfile_rate
kpss dfile_rate

dfuller dconviction_rate
kpss dconviction_rate

dfuller dplea_rate
kpss dplea_rate

dfuller dcumconinc
kpss dcumconinc

dfuller dcumpun_detr
kpss dcumpun_detr

dfuller dPres2
kpss dPres2

dfuller dcrimerate
kpss dcrimerate

dfuller ddrug
kpss ddrug

*Table SI-4: Testing for Stationarity of Model Residuals*
reg dincarceration_rate lincarceration_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug
predict m1hat
dfuller m1hat
kpss m1hat

reg dfile_rate lfile_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug
predict m2hat
dfuller m2hat
kpss m2hat

reg dconviction_rate lconviction_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug
predict m3hat
dfuller m3hat
kpss m3hat

reg dplea_rate lplea_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug
predict m4hat
dfuller m4hat
kpss m4hat

reg dincarceration_rate lincarceration_rate dconviction_rate lconviction_rate dplea_rate lplea_rate dfile_rate lfile_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug
predict m5hat
dfuller m5hat
kpss m5hat

*Table SI-5: Testing for Weak Exogeneity*
reg dcumconinc lcumconinc lincarceration_rate dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug

reg dcumpun_detr lcumpun_detr lincarceration_rate dcumconinc lcumconinc ldPres2 dcrimerate lcrimerate ddrug ldrug

reg dfile_rate lfile_rate lincarceration_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug

reg dconviction_rate lconviction_rate lincarceration_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug

reg dplea_rate lplea_rate lincarceration_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug

*Table SI-6: Testing Additional Lag Lengths*
reg dincarceration_rate lincarceration_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug

reg dincarceration_rate lincarceration_rate dcumconinc lcumconinc l2.cumconinc dcumpun_detr lcumpun_detr l2.cumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug

reg dincarceration_rate lincarceration_rate dcumconinc lcumconinc l2. cumconinc l3.cumconinc dcumpun_detr lcumpun_detr l2.cumpun_detr l3.cumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug

reg dincarceration_rate lincarceration_rate dcumconinc lcumconinc l2.cumconinc l3.cumconinc l4.cumconinc dcumpun_detr lcumpun_detr l2.cumpun_detr l3.cumpun_detr l4.cumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug

reg dincarceration_rate lincarceration_rate dcumconinc lcumconinc l2.cumconinc l3.cumconinc l4.cumconinc l5.cumconinc dcumpun_detr lcumpun_detr l2.cumpun_detr l3.cumpun_detr l4.cumpun_detr l5.cumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug

**Section 3: Detrended Measure of Supreme Court Policy**
*Figure SI-1: Congressional Policy with and without a Linear Trend*
twoway line cumpun cumpun_detr year, scheme(s1mono)

*Figure SI-2: Supreme Court Policy with and without a Linear Trend*
twoway line cumconinc cumconinc_detr year, scheme(s1mono)

*Table SI-7: Macro Policy and Federal Incarceration with Detrended Supreme Court Policy*
reg dincarceration_rate lincarceration_rate dcumconinc_detr lcumconinc_detr dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug

**Section 4: Alternative Measures of Presidential Policy**
*Table SI-8: Macro Policy and Federal Incarceration with Presidential Ideology Scores*
reg dincarceration_rate lincarceration_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres dcrimerate lcrimerate ddrug ldrug

reg dincarceration_rate lincarceration_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldreppres dcrimerate lcrimerate ddrug ldrug

**Section 5: Additional Control Variables**
*Table SI-9: Macro Policy and Federal Incarceration with Public Opinion Controls*
reg dincarceration_rate lincarceration_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 ///
dcrimerate lcrimerate ddrug ldrug dcon_crimemood lcon_crimemood 

reg dincarceration_rate lincarceration_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 ///
dcrimerate lcrimerate ddrug ldrug dpun_sent lpun_sent

reg dincarceration_rate lincarceration_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 ///
dcrimerate lcrimerate ddrug ldrug dpunitiveness lpunitiveness

*Table SI-10: Macro Policy and Federal Incarceration with Partisanship Controls*
reg dincarceration_rate lincarceration_rate _dcumconinc _lcumconinc _dcumpun_detr _lcumpun_detr _ldPres2 dcrimerate ///
lcrimerate ddrug ldrug drepstrength lrepstrength dcourtreps lcourtreps

*Table SI-11: Macro Policy and Federal Incarceration with Ideology Controls*
reg dincarceration_rate lincarceration_rate _dcumconinc _lcumconinc _dcumpun_detr _lcumpun_detr _ldPres2 ///
dcrimerate lcrimerate ddrug ldrug dCongId lCongId dcourt lcourt

**Section 6: Mediation Analysis with ECMs**
*Table SI-12: Macro Policy, Mediators, and Federal Incarceration*
reg dincarceration_rate lincarceration_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug

reg dfile_rate lfile_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug

reg dconviction_rate lconviction_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug

reg dplea_rate lplea_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug

*Table SI-13: Mediators and Federal Incarceration*
reg dincarceration_rate lincarceration_rate dconviction_rate lconviction_rate dplea_rate lplea_rate dfile_rate lfile_rate dcrimerate lcrimerate ddrug ldrug

**Section 7: SEM Results**
*Table SI-14: Structural Equation Model Results*
sem (dfile_rate <- lfile_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug) ///
(dconviction_rate <- lconviction_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug) ///
(dplea_rate <- lplea_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug) ///
(dincarceration_rate <- lincarceration_rate dconviction_rate lconviction_rate dplea_rate lplea_rate dfile_rate lfile_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug), nocapslatent

*Table SI-15: Second Stage of Instrumental Variables Model*
sem (dfile_rate <- lfile_rate dhat lhat dcumpun_detr lcumpun_detr ldPres2 lPres2 dcrimerate lcrimerate ddrug ldrug) /// 
(dconviction_rate <- lconviction_rate dhat lhat dcumpun_detr lcumpun_detr ldPres2 lPres2 dcrimerate lcrimerate ddrug ldrug) ///
(dplea_rate <- lplea_rate dhat lhat dcumpun_detr lcumpun_detr ldPres2 lPres2 dcrimerate lcrimerate ddrug ldrug) ///
(dincarceration_rate <- lincarceration_rate dconviction_rate lconviction_rate dplea_rate lplea_rate dfile_rate lfile_rate ///
dhat lhat dcumpun_detr lcumpun_detr ldPres2 lPres2 dcrimerate lcrimerate ddrug ldrug), nocapslatent

**Section 8: First Stage of IV Model**
*Table SI-16: First Stage of Instrumental Variables Model*
reg dcumconinc lcumconinc dzretseglib lzretseglib dcumpun_detr lcumpun_detr ldPres2 lPres2 dcrimerate lcrimerate ddrug ldrug l18zapp

**Section 9: IV Granger “Causality” Tests**
*Table SI-17: Granger “Causality” Tests with Supreme Court Policy Instrument*

varsoc incarceration_rate hat
gcause hat incarceration_rate, lags(3)
gcause incarceration_rate hat, lags(3)

varsoc file_rate hat
gcause hat file_rate, lags(2)
gcause file_rate hat, lags(2)

varsoc conviction_rate hat
gcause hat conviction_rate, lags(2)
gcause conviction_rate hat, lags(2)

varsoc plea_rate hat
gcause hat plea_rate, lags(2)
gcause plea_rate hat, lags(2)

***Section 10: Criminal Justice Spending as a Policy Measure***
*Table SI-18: Criminal Justice Spending as a Policy Measure*

reg dincarceration_rate lincarceration_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug djust_spend ljust_spend 

reg dincarceration_rate lincarceration_rate dcumconinc lcumconinc ldPres2 dcrimerate lcrimerate ddrug ldrug djust_spend ljust_spend 

***Section 11: Modeling Presidential Preferences***
*Table SI-19: Modeling Presidential Preferences*

reg dincarceration_rate lincarceration_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr dPres2 lPres2 dcrimerate lcrimerate ddrug ldrug

reg dincarceration_rate lincarceration_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr dPres2 dcrimerate lcrimerate ddrug ldrug

reg dincarceration_rate lincarceration_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr ldPres2 dcrimerate lcrimerate ddrug ldrug

reg dincarceration_rate lincarceration_rate dcumconinc lcumconinc dcumpun_detr lcumpun_detr dPres2 ldPres2 lPres2 dcrimerate lcrimerate ddrug ldrug
