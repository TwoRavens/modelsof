


Replication data for Buhaug, Cederman & Gledtisch (2014) "Square Pegs in Round Holes...", International Studies Quarterly


use 



*** Analysis

// Macros for standardized control variables
global CONTROLS1 downatall powershare sip2l lpopl lgdpcapl 
global CONTROLS2 sip2l lpopl lgdpcapl 
global CONTROLS3 powershare sip2l lpopl lgdpcapl 



// Macros for standardized time controls
global TIME1 incidencel
global TIME2 mpyrs mspline*
global TIME3 warlfl
global TIME4 fpeaceyears fspline*
global TIME5 conflictl
global TIME6 flnewpeacey
global TIME7 fl_newcwlag






* descriptives for conflict/non-conflict sample
sum ethfrac if year>=1960 & incidum==0
sum ethfrac if year>=1960 & incidum==1
ttest ethfrac, by(incidum)

sum mgini_intx if year>=1960 & incidum==0 
sum mgini_intx if year>=1960 & incidum==1 
ttest mgini_intx , by(incidum)

sum max_rdisc if year>=1960 & incidum==0 
sum max_rdisc if year>=1960 & incidum==1 
ttest max_rdisc , by(incidum)

sum maxhighx if year>=1960 & incidum==0 
sum maxhighx if year>=1960 & incidum==1 
ttest maxhighx , by(incidum)

sum maxlowx if year>=1960 & incidum==0 
sum maxlowx if year>=1960 & incidum==1 
ttest maxlowx , by(incidum)




*** TABLE 1 - UPPSALA/PRIO CONFLICT DATA (1960-2005)

// Model 1: Base model with conventional measures of grievances
logit onset01 ethfrac mgini_intx $CONTROLS2 $TIME1 if year>=1960, cl(cowcode) nolog

// Model 2: Adding measures of pol. and econ. HIs
logit onset01 ethfrac mgini_intx max_rdisc maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960, cl(cowcode) nolog

// Model 3: Mlogit - separating between (i) ethnic territorial, (ii) ethnic governmental, and (iii) non-ethnic conflict
mlogit epronset01 ethfrac mgini_intx max_rdisc maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960, cl(cowcode) nolog





*** TABE 3 - FEARON & LAITIN CIVIL WAR DATA (1960-1999)

// Model 4: Logit: Use Fearon & Laitin civil war data
logit onsetfl ethfrac mgini_intx max_rdisc maxhighx maxlowx $CONTROLS1 $TIME3 if year>=1960, cl(cowcode) nolog

// Model 5: Mlogit: Use Fearon & Laitin civil war data
mlogit flonsetcat ethfrac mgini_intx max_rdisc maxhighx maxlowx $CONTROLS1 $TIME3 if year>=1960, cl(cowcode) nolog






*** out-of-sample predictions (training period: 1960-99; prediction period 2000-09) with ACD onset [onset2]

// VI + controls only
* training model 1960-99

logit onset2 ethfrac mgini_intx $CONTROLS2 $TIME1 if year>=1960 & year<2000, cl(cowcode) nolog
predict p_vi, p

* compare aggregate 1999 estimate with true onset observations for 2000-09
gen p_vi00_09 = (1-(1-p_vi)^10) if year==1999
replace p_vi00_09=p_vi00_09[_n-1] if p_vi00_09==. & year>1999 & cowcode==cowcode[_n-1]
lab var p_vi00_09 "aggregate probability 2000-09 VI model
sort cowcode year
gen p_vi00_09dum=0 if p_vi00_09<0.5
replace p_vi00_09dum=1 if p_vi00_09>=0.5 & p_vi00_09!=.
by cowcode: egen ons00_09=max(onset2) if year>1999
* TABLE 2
tab ons00_09 p_vi00_09dum if year==2000
 

// HI + controls only
* Note! sample held constant between models to facilitate direct comparison (see below for full valid sample)

logit onset2 max_rdisc maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960 & year<2000 & mgini_intx!=. & ethfrac!=., cl(cowcode) nolog
predict p_hi, p

* compare aggregate 1999 estimate with true onset observations for 2000-09
sort cowcode year
gen p_hi00_09 = (1-(1-p_hi)^10) if year==1999
replace p_hi00_09=p_hi00_09[_n-1] if p_hi00_09==. & year>1999 & cowcode==cowcode[_n-1]
lab var p_hi00_09 "aggregate probability 2000-09 HI model - fixed sample
sort cowcode year
gen p_hi00_09dum=0 if p_hi00_09<0.5
replace p_hi00_09dum=1 if p_hi00_09>=0.5 & p_hi00_09!=.
* TABLE 2 (CONT'D)
tab ons00_09 p_hi00_09dum if year==2000 & p_vi00_09dum!=.


* FIGURE 2 - ROC plots for VI and HI predictions FOR SAME SAMPLE AS VI MODEL
rocgold  ons00_09 p_vi00_09 p_hi00_09 if year==2000, graph noref summary


* FIGURE 3 - visual inspection of VI and HI predictions
twoway (scatter p_hi00_09 p_vi00_09 if year==2000 & ons00_09==0, mcolor(gs10) msymbol(lgx)) ///
(scatter p_hi00_09 p_vi00_09 if year==2000 & ons00_09==1, mcolor(gs6) msymbol(triangle_hollow)), ///
ytitle(HI model) yscale(range(0 1)) ylabel(#6) xtitle(VI model) xscale(range(0 1)) ///
legend(order(1 "no onset" 2 "onset") rows(2) position(11) ring(0))























// "VI" W/O ELF AND GINI + controls only
* training model 1960-98

logit fl_newons $CONTROLS2 $TIME7 if year>=1960 & year<1999, cl(cowcode) nolog
predict p_flvi, p

* compare aggregate 1998 estimate with true onset observations for 1999-08
gen p_vifl99_08 = (1-(1-p_flvi)^10) if year==1998
replace p_vifl99_08=p_vifl99_08[_n-1] if p_vifl99_08==. & year>1998 & cowcode==cowcode[_n-1]
lab var p_vifl99_08 "aggregate probability 1999-08 VI model for Fearon beta data
sort cowcode year
gen p_vifl99_08dum=0 if p_vifl99_08<0.5
replace p_vifl99_08dum=1 if p_vifl99_08>=0.5 & p_vifl99_08!=.
by cowcode: egen flons99_08=max(fl_newons) if year>1998 & year<2009
tab flons99_08 p_vifl99_08dum if year==1999
 

// HI W/O DOWNATALL + controls only

logit fl_newons max_rdisc maxhighx maxlowx $CONTROLS3 $TIME7 if year>=1960 & year<1999 & mgini_intx!=. & ethfrac!=., cl(cowcode) nolog
predict p_flhi, p

* compare aggregate 1998 estimate with true onset observations for 1999-08
sort cowcode year
gen p_hifl99_08 = (1-(1-p_flhi)^10) if year==1998
replace p_hifl99_08=p_hifl99_08[_n-1] if p_hifl99_08==. & year>1998 & cowcode==cowcode[_n-1]
lab var p_hifl99_08 "aggregate probability 1999-08 HI model for Fearon beta data
sort cowcode year
gen p_hifl99_08dum=0 if p_hi00_09<0.5
replace p_hi00_09dum=1 if p_hifl99_08>=0.5 & p_hifl99_08!=.
tab flons99_08 p_hifl99_08dum if year==1999 & p_vifl99_08dum!=.


* ROC plots for VI and HI predictions FOR SAME SAMPLE AS VI MODEL
rocgold  flons99_08 p_vifl99_08 p_hifl99_08 if year==1999, graph noref summary









*** REPLACE HI AND VI INDICATORS WITH ALTERNATIVE MEASURES

// Model 4a: Replace ELF with Reynal-Querol's polarization (H1)
logit onset01 RQ mgini_intx max_rdisc maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960, cl(cowcode) nolog
outreg2 using tab3, nolabel 2aster dec(3) word replace

// Model 4b: Replace ELF with Reynal-Querol's polarization (H1)
mlogit epronset01 RQ mgini_intx max_rdisc maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960, cl(cowcode) nolog
outreg2 using tab3, nolabel 2aster dec(3) word append


// Model 5a: Replace mgini (WIID) with Boix' ineqality measures (H2)
logit onset01 ethfrac ff_boixx iod_boixx ff_iodx max_rdisc maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960, cl(cowcode) nolog
outreg2 using tab4, nolabel 2aster dec(3) word replace

// Model 5b: Replace mgini (WIID) with Boix' ineqality measures (H2)
mlogit epronset01 ethfrac ff_boixx iod_boixx ff_iodx max_rdisc maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960, cl(cowcode) nolog
outreg2 using tab4, nolabel 2aster dec(3) word append


// Model 6a: Replace max r score with Nstar calculated for discriminated groups (H3)
logit onset01 ethfrac mgini_intx nstar_disc maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960, cl(cowcode) nolog
outreg2 using tab5, nolabel 2aster dec(3) word replace

// Model 6b: Replace max r score with Nstar(H3)
mlogit epronset01 ethfrac mgini_intx nstar_disc maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960, cl(cowcode) nolog
outreg2 using tab5, nolabel 2aster dec(3) word append


// Model 7a: Replace maxhigh and maxlow with G-econ-generated BGI (H4)
logit onset01 ethfrac mgini_intx max_rdisc bgi_gecon $CONTROLS1 $TIME1 if year>=1960, cl(cowcode) nolog
outreg2 using tab6, nolabel 2aster dec(3) word replace

// Model 7b: Replace maxhigh and maxlow with G-econ-generated BGI (H4)
mlogit epronset01 ethfrac mgini_intx max_rdisc bgi_gecon $CONTROLS1 $TIME1 if year>=1960, cl(cowcode) nolog
outreg2 using tab6, nolabel 2aster dec(3) word append




*** fixed effects
// xtlogit for Model 2
xtlogit onset01 ethfrac mgini_intx max_rdisc maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960, fe nolog
outreg2 using tab_mod2fe, nolabel 2aster dec(3) word replace

// xtreg for Model 2
xtreg onset01 ethfrac mgini_intx max_rdisc maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960, fe 
outreg2 using tab_mod2fe, nolabel 2aster dec(3) word append


// xtlogit for ethnic territorial onset
xtlogit eprterrons01 ethfrac mgini_intx max_rdisc maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960, fe nolog
outreg2 using tab_terrfe, nolabel 2aster dec(3) word replace

// xtreg for ethnic territorial onset
xtreg eprterrons01 ethfrac mgini_intx max_rdisc maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960, fe 
outreg2 using tab_terrfe, nolabel 2aster dec(3) word append

// xtlogit for ethnic gov't onset
xtlogit eprgovons01 ethfrac mgini_intx max_rdisc maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960, fe nolog
outreg2 using tab_govfe, nolabel 2aster dec(3) word replace

// xtreg for ethnic gov't onset
xtreg eprgovons01 ethfrac mgini_intx max_rdisc maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960, fe 
outreg2 using tab_govfe, nolabel 2aster dec(3) word append

// xtlogit for non-ethnic onset
xtlogit eprnonethons01 ethfrac mgini_intx max_rdisc maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960, fe nolog
outreg2 using tab_nonethfe, nolabel 2aster dec(3) word replace

// xtreg for non-ethnic onset
xtreg eprnonethons01 ethfrac mgini_intx max_rdisc maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960, fe 
outreg2 using tab_nonethfe, nolabel 2aster dec(3) word append




*** Assessment of variable influence - logit model
* ROC curves for Model 2 
logit onset01 ethfrac mgini_intx max_rdisc maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960, cl(cowcode) nolog
lroc, ytitle(True positives) xtitle(False positives) msymbol(smplus)


* ROC curves for Model 1
logit onset01 ethfrac mgini_intx $CONTROLS1 $TIME1 if year>=1960 & max_rdisc!=. & maxlowx!=., cl(cowcode) nolog
lroc, ytitle(True positives) xtitle(False positives) msymbol(smplus) 


* w/o ELF
logit onset01 mgini_intx max_rdisc maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960 & ethfrac !=., cl(cowcode) nolog
lroc, ytitle(True positives) xtitle(False positives) msymbol(smplus)

* w/o mgini
logit onset01 ethfrac max_rdisc maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960 & mgini_intx!=., cl(cowcode) nolog
lroc, ytitle(True positives) xtitle(False positives) msymbol(smplus)

* w/o Max r
logit onset01 ethfrac mgini_intx maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960 & max_rdisc !=., cl(cowcode) nolog
lroc, ytitle(True positives) xtitle(False positives) msymbol(smplus)

* w/o maxhigh & maxlow
logit onset01 ethfrac mgini_intx max_rdisc $CONTROLS1 $TIME1 if year>=1960 & maxhighx!=., cl(cowcode) nolog
lroc, ytitle(True positives) xtitle(False positives) msymbol(smplus)

* w/o GDP
* ROC curves for Model 2 plus models dropping single vars for H1-H4
logit onset01 ethfrac mgini_intx max_rdisc maxhighx maxlowx lpopl sip2l $TIME1 if year>=1960 & lgdpcapl!=., cl(cowcode) nolog
lroc, ytitle(True positives) xtitle(False positives) msymbol(smplus)




*** Assessment of variable influence - mlogit model
* ROC curves for ethnic territorial conflict (Model 3 outcome 1) 
logit ethterrons01 ethfrac mgini_intx max_rdisc maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960, cl(cowcode) nolog
lroc, ytitle(True positives) xtitle(False positives) msymbol(smplus)

* w/o ELF
logit ethterrons01 mgini_intx max_rdisc maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960 & ethfrac !=., cl(cowcode) nolog
lroc, ytitle(True positives) xtitle(False positives) msymbol(smplus)

* w/o mgini
logit ethterrons01 ethfrac max_rdisc maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960 & mgini_intx!=., cl(cowcode) nolog
lroc, ytitle(True positives) xtitle(False positives) msymbol(smplus)

* w/o max r
logit ethterrons01 ethfrac mgini_intx maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960 & max_rdisc !=., cl(cowcode) nolog
lroc, ytitle(True positives) xtitle(False positives) msymbol(smplus)

* w/o maxhigh & maxlow
logit ethterrons01 ethfrac mgini_intx max_rdisc $CONTROLS1 $TIME1 if year>=1960 & maxhighx!=., cl(cowcode) nolog
lroc, ytitle(True positives) xtitle(False positives) msymbol(smplus)




* ROC curves for ethnic govt conflict (Model 3 outcome 2) 
logit ethgovons01 ethfrac mgini_intx max_rdisc maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960, cl(cowcode) nolog
lroc, ytitle(True positives) xtitle(False positives) msymbol(smplus)

* w/o ELF
logit ethgovons01 mgini_intx max_rdisc maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960 & ethfrac !=., cl(cowcode) nolog
lroc, ytitle(True positives) xtitle(False positives) msymbol(smplus)

* w/o mgini
logit ethgovons01 ethfrac max_rdisc maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960 & mgini_intx!=., cl(cowcode) nolog
lroc, ytitle(True positives) xtitle(False positives) msymbol(smplus)

* w/o max r
logit ethgovons01 ethfrac mgini_intx maxhighx maxlowx $CONTROLS1 $TIME1 if year>=1960 & max_rdisc !=., cl(cowcode) nolog
lroc, ytitle(True positives) xtitle(False positives) msymbol(smplus)

* w/o maxhigh & maxlow
logit ethgovons01 ethfrac mgini_intx max_rdisc $CONTROLS1 $TIME1 if year>=1960 & maxhighx!=., cl(cowcode) nolog
lroc, ytitle(True positives) xtitle(False positives) msymbol(smplus)





*** scatter plot of IDV covariance
* GINI vs. maxlow
twoway (scatter maxlowx mgini_intx if year==2000, mcolor(gs4) msymbol(x)) ///
(scatter maxlowx mgini_intx if year==2000 & (maxlowx>1.8 | mgini_intx>65), mcolor(gs4) msymbol(x) ///
mlabel(abbrev) mlabcolor(gs4) mlabposition(6)), ytitle(NHI) xtitle(GINI) legend(off)


* ELF vs max_rdisc
twoway (scatter max_rdisc ethfrac if year==2000, mcolor(gs4) msymbol(x)) ///
(scatter max_rdisc ethfrac if year==2000 & max_rdisc >0.15, mcolor(gs4) msymbol(x) ///
mlabel(abbrev) mlabcolor(gs4) mlabposition(6)), ytitle(LDG) xtitle(ELF) legend(off)
 

* ELF vs Nstar
twoway (scatter nstardisc ethfrac if year==2000, mcolor(gs4) msymbol(x)) ///
(scatter nstardisc ethfrac if year==2000 & nstardisc>0.1, mcolor(gs4) msymbol(x) ///
mlabel(abbrev) mlabcolor(gs4) mlabposition(6)), ytitle(N*) xtitle(ELF) legend(off)
 

* GINI vs. maxhigh (w/o Saudi Arabia due to missing)
twoway (scatter maxhighx mgini_intx if year==2000 & cowcode!=670, mcolor(gs4) msymbol(x)) ///
(scatter maxhighx mgini_intx if year==2000 & (maxhighx>1.5 | mgini_intx>65)& cowcode!=670, mcolor(gs4) msymbol(x) ///
mlabel(abbrev) mlabcolor(gs4) mlabposition(6)), ytitle(Pos. income ineq.) xtitle(GINI) legend(off)


* Max r vs. maxlow 
twoway (scatter maxlowx max_rdisc if year>=1960, mcolor(gs4) msymbol(x)), ///
ytitle(Neg. economic ineq) xtitle(Rel. size of largest discr. grp.) legend(off)


* Nstar vs. maxlow 
twoway (scatter maxlowx nstardisc if year>=1960, mcolor(gs4) msymbol(x)), ///
ytitle(Neg. economic ineq) xtitle(N*) legend(off)








*** 4 well-selected cases to highligh difference between gini and HI
scatter maxlowx mgini_intx if year==2000 & (cowcode==345 | cowcode==20 | cowcode==560 | cowcode==150), mlabel(stateabb) ///
ytitle(Neg. income ineq.) xtitle(Gini) legend(off)

*** 4 well-selected cases to highligh difference between ELF and max r
scatter max_rdisc ethfrac if year==2000 & (cowcode==666 | cowcode==375 | cowcode==540 | cowcode==20), mlabel(stateabb) ///
ytitle(Rel. size of largest discr. grp.) xtitle(ELF) legend(off)





