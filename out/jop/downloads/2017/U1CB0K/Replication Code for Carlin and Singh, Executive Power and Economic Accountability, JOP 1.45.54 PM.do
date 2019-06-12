
***This code replicates the models and figures in the paper Executive Power and Economic Accountability by Ryan Carlin and Shane Singh, which appears in the Journal of Politics.





*Model 1
xtlogit approveprez c.socioretro c.negrettoilp income proximity age female  GDPpercapita_PPP  months_log maj_seat , i(cntryyearnum) 

*run this code to aid in the creation of the figures
sum negrettoilp if e(sample), detail
global neg_high=r(p90)
global neg_low=r(p10)
global neg_min = r(min)
global neg_max = r(max)

sum decree_log if e(sample), detail
global decree_high=r(p90)
global decree_low=r(p10)
global decree_min = r(min)
global decree_max = r(max)

*Model 2
xtlogit approveprez c.socioretro c.decree_log income proximity age female  GDPpercapita_PPP  months_log maj_seat , i(cntryyearnum) 

*Model 3
xtlogit approveprez c.socioretro##c.negrettoilp income proximity age female  GDPpercapita_PPP  months_log maj_seat , i(cntryyearnum) 

margins, dydx(socioretro) at(negrettoilp =($neg_min(5)$neg_max)) predict(pu0) atmeans 	
marginsplot, ///
     recast(line) recastci(rcap) scheme(s1color) xdimension(negrettoilp) ///
     ci1opts(color(pink*.15) lwidth(medthick))  /// 
     plot1opts(lcolor(pink*2) lwidth(medthick))  ///  
	 xtitle(Legislative Powers of President) title("") ytitle(M.E. of Economic Evals. on Pr(Approve of President)) xlabel(20(20)100) 	 ///
	 name(negretto_socioretro_MEs, replace)

margins, at(negrettoilp =($neg_low $neg_high)  socioretro=(1(.5)5)) predict(pu0) atmeans 
marginsplot, ///
     recast(line) recastci(rcap) scheme(s1color) xdimension(socioretro) ///
     ci1opts(color(gs9) lwidth(medthick)) ci2opts(color(blue*.15) lwidth(medthick) lpattern(dash))  /// 
     plot1opts(lcolor(black) lwidth(medthick)) plot2opts(lcolor(blue*1.5) lwidth(medthick) lpattern(dash))  ///  
	 xtitle(Economic Evaluations) title("") ytitle(Pr(Approve of President)) xlabel(1(1)5) ///	 
     legend(order(3 "Weak Legislative Powers" 4 "Strong Legislative Powers") rows(2))  ///
	 name(negretto_socioretro_predicted, replace)
	 
*Model 4
xtlogit approveprez c.socioretro##c.decree_log income proximity age female  GDPpercapita_PPP  months_log maj_seat , i(cntryyearnum) 

margins, dydx(socioretro) at(decree_log =($decree_min(.5)$decree_max)) predict(pu0) atmeans 	
marginsplot, ///
     recast(line) recastci(rcap) scheme(s1color) xdimension(decree_log) ///
     ci1opts(color(pink*.15) lwidth(medthick))  /// 
     plot1opts(lcolor(pink*2) lwidth(medthick))  ///  
	 xtitle(Number of Decrees Issued (ln)) title("") ytitle(M.E. of Economic Evals. on Pr(Approve of President)) xlabel(0(1)7) 	 ///
	 name(decrees_socioretro_MEs, replace)

margins, at(decree_log =($decree_low $decree_high)  socioretro=(1(.5)5)) predict(pu0) atmeans 
marginsplot, ///
     recast(line) recastci(rcap) scheme(s1color) xdimension(socioretro) ///
     ci1opts(color(gs9) lwidth(medthick)) ci2opts(color(blue*.15) lwidth(medthick) lpattern(dash))  /// 
     plot1opts(lcolor(black) lwidth(medthick)) plot2opts(lcolor(blue*1.5) lwidth(medthick) lpattern(dash))  ///  
	 xtitle(Economic Evaluations) title("") ytitle(Pr(Approve of President)) xlabel(1(1)5) ///	 
     legend(order(3 "Low Number of Decrees" 4 "High Number of Decrees") rows(2))  ///
	 name(decrees_socioretro_predicted, replace)
	 

*Figure 1
graph combine ///
	negretto_socioretro_MEs ///
    decrees_socioretro_MEs   ///
    , rows(2)  ysize(7) graphregion(color(white)) scale(.6) name(a, replace) ycommon
	
graph combine ///
	negretto_socioretro_predicted ///
    decrees_socioretro_predicted   ///
    , rows(2)  ysize(7) graphregion(color(white)) scale(.6) name(b,replace)	  ycommon
	 

graph combine a b ///
    , rows(1)  xsize(3.25) graphregion(color(white)) scale(1.2)
	 
	 
*Model 5
xtlogit approveprez c.socioretro##c.negrettoilp##c.decree_log  income proximity age female  GDPpercapita_PPP months_log maj_seat , i(cntryyearnum) 
margins, dydx(socioretro) at(negrettoilp=($neg_min(5)$neg_max)  decree_log =($decree_low $decree_high)) predict(pu0) atmeans 
marginsplot, ///
     recast(line) recastci(rcap) scheme(s1color) xdimension(negrettoilp) ///
     ci1opts(color(red*.15) lwidth(medthick)) ci2opts(color(green*.15) lwidth(medthick) lpattern(dash))  /// 
     plot1opts(lcolor(red*1.5) lwidth(medthick)) plot2opts(lcolor(green*1.5) lwidth(medthick) lpattern(dash)) ///  
	 xtitle(Legislative Powers of President) title("") ytitle(M.E. of Econ. Evals. on Pr(Approve of President)) xlabel(20(20)100) 	///
	 legend(order(3 "Low Number of Decrees" 4 "High Number of Decrees") rows(2))  ///
 	 name(negretto_decrees_socioretro_MEs, replace)

margins, dydx(socioretro) at(negrettoilp=($neg_low $neg_high)  decree_log =($decree_min(.5)$decree_max)) predict(pu0) atmeans 
marginsplot, ///
     recast(line) recastci(rcap) scheme(s1color) xdimension(decree_log) ///
     ci1opts(color(red*.15) lwidth(medthick)) ci2opts(color(green*.15) lwidth(medthick) lpattern(dash))  /// 
     plot1opts(lcolor(red*1.5) lwidth(medthick)) plot2opts(lcolor(green*1.5) lwidth(medthick) lpattern(dash)  lpattern(dash)) ///  
	 xtitle(Number of Decrees Issued (ln)) title("") ytitle(M.E. of Econ. Evals. on Pr(Approve of President)) xlabel(0(1)7) 	///
	 legend(order(3 "Weak Legislative Powers" 4 "Strong Legislative Powers") rows(2))  ///
  	 name(decrees_negretto_socioretro_MEs, replace)


xtlogit approveprez c.negrettoilp##c.decree_log##c.socioretro income proximity age female  GDPpercapita_PPP months_log maj_seat , i(cntryyearnum) //*Estimate Model 5 again to create predictive plot for Figure 2
margins, at(negrettoilp=($neg_low $neg_high)  decree_log =($decree_low $decree_high) socioretro=(1(.5)5)) predict(pu0) atmeans post vsquish
mat t=J(36,3,.)
mat a = (1\1.5\2\2.5\3\3.5\4\4.5\5\1\1.5\2\2.5\3\3.5\4\4.5\5\1\1.5\2\2.5\3\3.5\4\4.5\5\1\1.5\2\2.5\3\3.5\4\4.5\5)
forvalues i=1/36 {
  mat t[`i',1] = _b[`i'._at]                       /* get probability estimates */
  mat t[`i',2] = _b[`i'._at] - 1.96*_se[`i'._at]   /* compute lower limit       */
  mat t[`i',3] = _b[`i'._at] + 1.96*_se[`i'._at]   /* compute upper limit       */
  }

mat t=t,a   
mat colnames t = prob ll ul at                     /* fix column names          */
svmat t, names(col)                                /* save matrix as data       */

twoway (line prob at in 1/9, lcolor(black) lwidth(medthick))  (line prob at in 28/36, lpattern(dash) lwidth(medthick) lcolor(blue*1.5)) (rcap  ll ul at in 1/9, color(gs9) lwidth(medthick))  (rcap  ll ul at in 28/36, lpattern(dash) lcolor(blue*.15) lwidth(medthick)), ///
		legend(order(1 "Weak Legislative Powers, Low Number of Decrees" 2 "Strong Legislative Powers, High Number of Decrees") rows(2) size(small))  ///
       	xtitle(Economic Evaluations) xlabel(1(1)5) ytitle(Pr(Approve of President), margin(small)) scheme(s1mono) ///
		name(three_way_socioretro_predicted, replace)

drop prob-at	 

*Figure 2
graph combine ///
	negretto_decrees_socioretro_MEs ///
    decrees_negretto_socioretro_MEs   ///
    , rows(1)  ysize(7) graphregion(color(white)) scale(.6) name(c, replace) ycommon
	
 
graph combine c three_way_socioretro_predicted  ///
    ,  rows(2) xsize(3) graphregion(color(white)) scale(1.2) //*use graph editor to change scale of lower graph to .5 and aspect ratio to 1.15
	 
	 
