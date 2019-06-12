/* Evidence Part 1 */

collapse debtserv iasum revenuesum othersum lngdppc growth tot resgdp_y lnemlending wbcodeNUM, by(wbcode year)

xtset wbcodeNUM year 

 #delimit;
xtreg debtserv l.debtserv l.iasum, fe r cluster(wbcode);
est store eA;
xtreg debtserv l.debtserv l.revenuesum l.othersum, fe r cluster(wbcode);
est store eB;
xtreg debtserv l.debtserv l.revenuesum l.othersum l.lngdppc l.growth l.tot l.resgdp_y l.lnemlending, fe r cluster(wbcode);
est store eC; 
estout eA eB eC, starlevels(* .1 ** .05 *** .01) 
 cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)));
 
 *** Robust to excluding top 10% of sample (ratio of 35 of higher)
 *** Robust to country and year fixed effects
 *** Robust to multiple imputation on (lngdppc growth tot) - see code at end of file
 
 ===

 /* Evidence Part 2 */
 
 /* Main analysis */
 
  #delimit;
 xtpmg d.lnbond d.iasum
 dpolity2 dgrowth  dydefault dresgdp_y dtot dxdebt ddebtserv dlnemlending qdate_*, 
 lr(l.lnbond l.iasum
 l12.polity2 l12.growth l12.ydefault l12.resgdp_y l12.tot l12.xdebt l12.debtserv l12.lnemlending) 
 dfe ec(ec) cluster(wbcode);
 gen s=e(sample);
 qui tab s if s==1;
 estadd r(N);
 drop s;
 est store e0; 
 
 #delimit;
 xtpmg d.lnbond d.revenuesum d.othersum 
 dpolity2 dgrowth dydefault dresgdp_y dtot dxdebt ddebtserv dlnemlending qdate_*, 
 lr(l.lnbond l.revenuesum l.othersum
 l12.polity2 l12.growth l12.ydefault l12.resgdp_y l12.tot l12.xdebt l12.debtserv l12.lnemlending) 
 dfe ec(ec) cluster(wbcode);
 gen s=e(sample);
 qui tab s if s==1;
 estadd r(N);
 drop s;
 est store e1;
 
    #delimit;
 estout e0 e1, starlevels(* .1 ** .05 *** .01) 
 cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)));
 
 *** Robust to including fdipgdp
 *** Robust to including Fitch monthly ratings
 *** Robust to multiple imputation on (growth tot xdebt debtserv) - see code at end of file

   ===
 
 /* Causal mediation */

 collapse lnbond iasum revenuesum othersum polity2 growth ydefault resgdp_y tot xdebt ///
 debtserv lnemlending, by(wbcode date)
 
 encode wbcode, gen(wbcodeNUM)
 xtset wbcodeNUM date
 
 gen breach=0 if iasum==0
 replace breach=1 if iasum!=0
 
 gen ro=1 if revenuesum>0
 replace ro=0 if ro==.
 
 drop if lnbond==.
 
 medeff (regress iasum ro l12.polity2 l12.growth l12.ydefault l12.resgdp_y l12.tot l12.xdebt l12.debtserv ///
 l12.lnemlending) ///
 (regress lnbond iasum ro l12.polity2 l12.growth l12.ydefault l12.resgdp_y l12.tot l12.xdebt l12.debtserv ///
 l12.lnemlending), ///
 mediate(iasum) treat(ro) level(90) vce(cluster wbcode)
 
===
 
/* Robustness */

 /* MA 6 mo on IAs */

 #delimit;
 xtpmg d.lnbond d.IAma
 dpolity2 dgrowth  dydefault dresgdp_y dtot dxdebt ddebtserv dlnemlending qdate_*, 
 lr(l.lnbond l.IAma
 l12.polity2 l12.growth l12.ydefault l12.resgdp_y l12.tot l12.xdebt l12.debtserv l12.lnemlending) 
 dfe ec(ec) cluster(wbcode);
 gen s=e(sample);
 qui tab s if s==1;
 estadd r(N);
 drop s;
 est store e4; 
 
 #delimit;
 xtpmg d.lnbond d.revma d.otherma 
 dpolity2 dgrowth  dydefault dresgdp_y dtot dxdebt ddebtserv dlnemlending qdate_*, 
 lr(l.lnbond l.revma l.otherma
 l12.polity2 l12.growth l12.ydefault l12.resgdp_y l12.tot l12.xdebt l12.debtserv l12.lnemlending) 
 dfe ec(ec) cluster(wbcode);
 gen s=e(sample);
 qui tab s if s==1;
 estadd r(N);
 drop s;
 est store e5;
 
     #delimit;
 estout e4 e5, starlevels(* .1 ** .05 *** .01) 
 cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)));
 
/* Resolution */

  #delimit;
 xtpmg d.lnbond d.revenuesum d.othersum d.state_en d.invest_settle_end
 dpolity2 dgrowth  dydefault dresgdp_y dtot dxdebt ddebtserv dlnemlending qdate_*, 
 lr(l.lnbond l.revenuesum l.othersum l.state_end l.invest_settle_end
 l12.polity2 l12.growth l12.ydefault l12.resgdp_y l12.tot l12.xdebt l12.debtserv l12.lnemlending) 
 dfe ec(ec) cluster(wbcode);
 gen s=e(sample);
 qui tab s if s==1;
 estadd r(N);
 drop s;
 est store e24;
 
  #delimit;
 xtpmg d.lnbond d.revenuesum d.othersum d.revenue_end d.other_end
 dpolity2 dgrowth  dydefault dresgdp_y dtot dxdebt ddebtserv dlnemlending qdate_*, 
 lr(l.lnbond l.revenuesum l.othersum l.revenue_end l.other_end
 l12.polity2 l12.growth l12.ydefault l12.resgdp_y l12.tot l12.xdebt l12.debtserv l12.lnemlending) 
 dfe ec(ec) cluster(wbcode);
 gen s=e(sample);
 qui tab s if s==1;
 estadd r(N);
 drop s;
 est store e25;

 #delimit;
 xtpmg d.lnbond d.revenuesum d.othersum d.revenue_investwin d.other_investwin
 d.revenue_state d.other_state
 dpolity2 dgrowth  dydefault dresgdp_y dtot dxdebt ddebtserv dlnemlending qdate_*, 
 lr(l.lnbond l.revenuesum l.othersum l.revenue_investwin l.other_investwin
 l.revenue_state l.other_state
 l12.polity2 l12.growth l12.ydefault l12.resgdp_y l12.tot l12.xdebt l12.debtserv l12.lnemlending) 
 dfe ec(ec) cluster(wbcode);
 gen s=e(sample);
 qui tab s if s==1;
 estadd r(N);
 drop s;
 est store e26;
 
 #delimit;
 estout e24 e25 e26, starlevels(* .1 ** .05 *** .01) 
 cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)));
 
 /* ARG VEN ECU */
 
  #delimit;
 xtpmg d.lnbond d.revenuesum d.othersum 
 dpolity2 dgrowth  dydefault dresgdp_y dtot dxdebt ddebtserv dlnemlending qdate_* if wbcode!="ECU", 
 lr(l.lnbond l.revenuesum l.othersum
 l12.polity2 l12.growth l12.ydefault l12.resgdp_y l12.tot l12.xdebt l12.debtserv l12.lnemlending) 
 dfe ec(ec) cluster(wbcode);
 gen s=e(sample);
 qui tab s if s==1;
 estadd r(N);
 drop s;
 est store ea;
 
 #delimit;
 xtpmg d.lnbond d.revenuesum d.othersum 
 dpolity2 dgrowth  dydefault dresgdp_y dtot dxdebt ddebtserv dlnemlending qdate_* if wbcode!="VEN", 
 lr(l.lnbond l.revenuesum l.othersum
 l12.polity2 l12.growth l12.ydefault l12.resgdp_y l12.tot l12.xdebt l12.debtserv l12.lnemlending) 
 dfe ec(ec) cluster(wbcode);
 gen s=e(sample);
 qui tab s if s==1;
 estadd r(N);
 drop s;
 est store eb;
 
 #delimit;
 xtpmg d.lnbond d.revenuesum d.othersum 
 dpolity2 dgrowth  dydefault dresgdp_y dtot dxdebt ddebtserv dlnemlending qdate_* if wbcode!="ARG", 
 lr(l.lnbond l.revenuesum l.othersum
 l12.polity2 l12.growth l12.ydefault l12.resgdp_y l12.tot l12.xdebt l12.debtserv l12.lnemlending) 
 dfe ec(ec) cluster(wbcode);
 gen s=e(sample);
 qui tab s if s==1;
 estadd r(N);
 drop s;
 est store ec;
 
 #delimit;
 xtpmg d.lnbond d.revenuesum d.othersum 
 dpolity2 dgrowth  dydefault dresgdp_y dtot dxdebt ddebtserv dlnemlending qdate_* if wbcode=="ARG" | wbcode=="ECU" | wbcode=="VEN", 
 lr(l.lnbond l.revenuesum l.othersum
 l12.polity2 l12.growth l12.ydefault l12.resgdp_y l12.tot l12.xdebt l12.debtserv l12.lnemlending)  
 dfe ec(ec) cluster(wbcode);
 gen s=e(sample);
 qui tab s if s==1;
 estadd r(N);
 drop s;
 est store ee;
 
    #delimit;
 estout ea eb ec ee, starlevels(* .1 ** .05 *** .01) 
 cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)));
 
 ===
 
/* Appendix: CDS */

#delimit;
 xtpmg d.lncds d.iasum
 dpolity2 dgrowth  dydefault dresgdp_y dtot dxdebt ddebtserv dlnemlending qdate_*, 
 lr(l.lncds l.iasum
 l12.polity2 l12.growth l12.ydefault l12.resgdp_y l12.tot l12.xdebt l12.debtserv l12.lnemlending) 
 dfe ec(ec) cluster(wbcode);
 gen s=e(sample);
 qui tab s if s==1;
 estadd r(N);
 drop s;
 est store ea;
 
#delimit;
 xtpmg d.lncds d.revenuesum d.othersum
 dpolity2 dgrowth  dydefault dresgdp_y dtot dxdebt ddebtserv dlnemlending qdate_*, 
 lr(l.lncds l.revenuesum l.othersum
 l12.polity2 l12.growth l12.ydefault l12.resgdp_y l12.tot l12.xdebt l12.debtserv l12.lnemlending) 
 dfe ec(ec) cluster(wbcode);
 gen s=e(sample);
 qui tab s if s==1;
 estadd r(N);
 drop s;
 est store eb;


  #delimit;
 estout ea eb, starlevels(* .1 ** .05 *** .01) 
 cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)));


====
 
 /* Non-results when using IA filing month or underlying event date as expropriation marker. */
 
 /* I first measure expropriation simply by the month in which a public IA began. Analyses exclude Argentina, 
 as dozens of revenue IAs can be attributed to legislative action in January 2002. The origin of these IAs approximates 
 the incidence of a financial crisis and default, which causes multicollinearity problems. */
 
 #delimit;
 xtpmg d.lnbond d.ia_start
 dpolity2 dgrowth  dydefault dresgdp_y dtot dxdebt ddebtserv dlnemlending qdate_* if wbcode!="ARG", 
 lr(l.lnbond l.ia_start
 l12.polity2 l12.growth l12.ydefault l12.resgdp_y l12.tot l12.xdebt l12.debtserv l12.lnemlending) 
 dfe ec(ec) cluster(wbcode);
 gen s=e(sample);
 qui tab s if s==1;
 estadd r(N);
 drop s;
 est store e20;
 
 #delimit;
 xtpmg d.lnbond d.revenue_start d.other_start 
 dpolity2 dgrowth  dydefault dresgdp_y dtot dxdebt ddebtserv dlnemlending qdate_* if wbcode!="ARG", 
 lr(l.lnbond l.revenue_start l.other_start
 l12.polity2 l12.growth l12.ydefault l12.resgdp_y l12.tot l12.xdebt l12.debtserv l12.lnemlending) 
 dfe ec(ec) cluster(wbcode);
 gen s=e(sample);
 qui tab s if s==1;
 estadd r(N);
 drop s;
 est store e21;
 
/* Next, a significant data collection effort led us to uncover 110 country-month-years in which an expropriation 
event occurred in 19 of the sample countries. A date qualified if the expropriation event was caused by the passing 
of legislation; if the government otherwise declared an expropriation; if a firm publicly declared that it had been 
expropriated; or if the press reported that an expropriation occurred.  While there are selection issues at play in this 
sample, it is important to note that at the time of the expropriation event, no one knew that the event would eventually 
lead to an IA. Thus, we can think of these 110 months as a (non-random) sample of the timing of actual expropriation events. 
Again, this analysis excludes Argentina. */
 
 
  #delimit;
 xtpmg d.lnbond d.breach_date
 dpolity2 dgrowth  dydefault dresgdp_y dtot dxdebt ddebtserv dlnemlending qdate_* if wbcode!="ARG", 
 lr(l.lnbond l.breach_date
 l12.polity2 l12.growth l12.ydefault l12.resgdp_y l12.tot l12.xdebt l12.debtserv l12.lnemlending) 
 dfe ec(ec) cluster(wbcode);
 gen s=e(sample);
 qui tab s if s==1;
 estadd r(N);
 drop s;
 est store e22;
 
 #delimit;
 xtpmg d.lnbond d.revenue_date d.other_date 
 dpolity2 dgrowth  dydefault dresgdp_y dtot dxdebt ddebtserv dlnemlending qdate_* if wbcode!="ARG", 
 lr(l.lnbond l.revenue_date l.other_date
 l12.polity2 l12.growth l12.ydefault l12.resgdp_y l12.tot l12.xdebt l12.debtserv l12.lnemlending) 
 dfe ec(ec) cluster(wbcode);
 gen s=e(sample);
 qui tab s if s==1;
 estadd r(N);
 drop s;
 est store e23;
 
      #delimit;
 estout e20 e21 e22 e23, starlevels(* .1 ** .05 *** .01) 
 cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)));

===

/* Multiple Imputation code */

/* MI for Evidence Part 1 */

collapse debtserv iasum revenuesum othersum lngdppc growth tot resgdp_y lnemlending wbcodeNUM, by(wbcode year)

xtset wbcodeNUM year 

sum iasum revenuesum othersum lngdppc growth tot resgdp_y lnemlending

mi set mlong
mi register imputed lngdppc growth tot

set seed 29390
mi impute mvn lngdppc growth tot = resgdp_y lnemlending, force add(10)

 #delimit;
mi estimate, noisily: xtreg debtserv l.debtserv l.iasum, fe r cluster(wbcode);
est store eA;
mi estimate, noisily: xtreg debtserv l.debtserv l.revenuesum l.othersum, fe r cluster(wbcode);
est store eB;
mi estimate, noisily: xtreg debtserv l.debtserv l.revenuesum l.othersum l.lngdppc l.growth l.tot l.resgdp_y l.lnemlending, fe r cluster(wbcode);
est store eC; 

estout eA eB eC, starlevels(* .1 ** .05 *** .01) 
 cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)));

 /* MI for Evidence Part 2 */
 
 keep lnbond revenuesum othersum polity2 growth ydefault resgdp_y tot xdebt debtserv lnemlending wbcode wbcodeNUM date qdate_*

drop qdate_1 qdate_2 qdate_3 qdate_4 qdate_5 qdate_6 qdate_7 qdate_8
drop qdate_32 qdate_33 qdate_34
drop qdate_57
drop qdate_73 qdate_74 qdate_75 qdate_76

drop if lnbond==.

sum lnbond revenuesum othersum polity2 growth ydefault resgdp_y tot xdebt debtserv lnemlending wbcode wbcodeNUM date

mi set mlong
mi register imputed growth tot xdebt debtserv 

set seed 29390
mi impute mvn growth tot xdebt debtserv = polity2 ydefault resgdp_y lnemlending, force add(10)

sort wbcodeNUM date

gen dpolity2 = polity2 - l12.polity2
gen dgrowth = growth - l12.growth
gen dydefault = ydefault - l12.ydefault
gen dresgdp_y = resgdp_y - l12.resgdp_y
gen dtot = tot - l12.tot
gen dxdebt = xdebt - l12.xdebt
gen ddebtserv = debtserv - l12.debtserv
gen dlnemlending = lnemlending - l12.lnemlending

 
 #delimit;
mi estimate, noisily cmdok esampvaryok: xtpmg d.lnbond d.revenuesum d.othersum 
 dpolity2 dgrowth dydefault dresgdp_y dtot dxdebt ddebtserv dlnemlending qdate_*, 
 lr(l.lnbond l.revenuesum l.othersum
 l12.polity2 l12.growth l12.ydefault l12.resgdp_y l12.tot l12.xdebt l12.debtserv l12.lnemlending) 
 dfe ec(ec) cluster(wbcode);
 gen s=e(sample);
 qui tab s if s==1;
 estadd r(N);
 drop s;
 est store e1;
 
    #delimit;
 estout e1, starlevels(* .1 ** .05 *** .01) 
 cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)));
 
