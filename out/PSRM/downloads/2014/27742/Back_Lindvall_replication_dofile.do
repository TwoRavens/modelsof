
* Set directory and open data
  
  cd 
 
  use Back_Lindvall_replication_data.dta, clear
  
* Sort and tsset
  
  sort countryn year
  tsset countryn year
    
* MAIN ARTICLE
    
* TABLE 1. Coalitions and Changes in Government Debt, 1961–2008 (same as in article version)
 
* model 1

  xtpcse D1.debtgdp_imp L1.D1.debtgdp_imp L1.debtgdp_imp gdpgr01 D1.unemp01 debt_service if L1.p_polity2 > 4, pairwise

* model 2

  xtpcse D1.debtgdp_imp L1.D1.debtgdp_imp L1.debtgdp_imp gdpgr01 D1.unemp01 debt_service L1.coalition if L1.p_polity2 > 4, pairwise

* model 3

  xtpcse D1.debtgdp_imp L1.D1.debtgdp_imp L1.debtgdp_imp gdpgr01 D1.unemp01 debt_service L1.coalition L1.psi if L1.p_polity2 > 4, pairwise

* model 4

  xtpcse D1.debtgdp_imp L1.D1.debtgdp_imp L1.debtgdp_imp gdpgr01 D1.unemp01 debt_service L1.coalition L1.psi L1.electionyear L1.minority L1.irange L1.pres L1.fed L1.strbic if L1.p_polity2 > 4, pairwise

* model 5

  xtpcse D1.debtgdp_imp L1.D1.debtgdp_imp L1.debtgdp_imp gdpgr01 D1.unemp01 debt_service L1.coalition L1.psi L1.electionyear L1.minority L1.irange L1.pres L1.fed L1.strbic i.countryn if L1.p_polity2 > 4, pairwise

* model 6

  xtpcse D1.debtgdp_imp L1.D1.debtgdp_imp L1.debtgdp_imp gdpgr01 D1.unemp01 debt_service L1.coalition L1.psi L1.electionyear L1.minority L1.irange L1.pres L1.fed L1.strbic L1.ER L1.DR L1.BBR L1.RR if L1.p_polity2 > 4, pairwise

*******
  
  use Back_Lindvall_replication_data.dta, clear
  
* TABLE 2: Descriptive statistics (new version, added info on fiscal rules which we had not included in previous version, see attached word-file)

* descriptives for variables included in models 1-5 (e(sample)==model 4)
  xtpcse D1.debtgdp_imp L1.D1.debtgdp_imp L1.debtgdp_imp gdpgr01 D1.unemp01 debt_service L1.coalition L1.psi L1.electionyear L1.minority L1.irange L1.pres L1.fed L1.strbic if L1.p_polity2 > 4, pairwise
  tabstat debtgdp_imp gdpgr01 unemp01 debt_service coalition psi electionyear minority irange pres fed strbic if e(sample)==1, stats(min max mean sd) columns(stats)  
  
  use Back_Lindvall_replication_data.dta, clear
  
* descriptives for variables added in model 6 (e(sample)==model 6, smaller)
  xtpcse D1.debtgdp_imp L1.D1.debtgdp_imp L1.debtgdp_imp gdpgr01 D1.unemp01 debt_service L1.coalition L1.psi L1.electionyear L1.minority L1.irange L1.pres L1.fed L1.strbic L1.ER L1.DR L1.BBR L1.RR if L1.p_polity2 > 4, pairwise
  tabstat ER DR BBR RR if e(sample)==1, stats(min max mean sd) columns(stats)

 *******
 
 use Back_Lindvall_replication_data.dta, clear
 
 * FIGURE 1. Debt and Coalitions, 1960–2008 (new version, following suggestions by the reviewers, see attached word-file)

  drop if year<1960
  drop if year>2008

  * To get percent on the y axis, as suggested by the reviewer
  replace debtgdp_imp = debtgdp_imp*100
   
  * this code is included to make the grey bars for periods for coalition governments look better 
  replace coalition = coalition*164
  
  * observe, we here changed the dotted lines to dashed lines (since the dots were hard to see)
  
  graph twoway ///
  (bar coalition year, yaxis(1) color(gs14) lcolor(gs14)) ///
  (line debtgdp_imp year, yaxis(1) lpattern(solid)) ///
  (line psi year, yaxis(2) lpattern(dash)) ///
  if country=="Australia", scheme(lean2) xtitle("") legend(off) ysize(8) xsize (10) ///
  ytitle("Debt") ///
  ytitle("Commitment Potential", axis(2)) ///
  yscale(range(0 165)) ///
  yscale(range(0 1) axis(2)) ///
  ylabel(0 (50) 150, nogrid) ///
  ylabel(0 (0.5) 1, nogrid axis(2)) 

  graph twoway ///
  (bar coalition year, yaxis(1) color(gs14) lcolor(gs14)) ///
  (line debtgdp_imp year, yaxis(1) lpattern(solid)) ///
  (line psi year, yaxis(2) lpattern(dash)) ///
  if country=="Austria", scheme(lean2) xtitle("") legend(off) ysize(8) xsize (10) ///
  ytitle("Debt") ///
  ytitle("Commitment Potential", axis(2)) ///
  yscale(range(0 165)) ///
  yscale(range(0 1) axis(2)) ///
  ylabel(0 (50) 150, nogrid) ///
  ylabel(0 (0.5) 1, nogrid axis(2)) 

  graph twoway ///
  (bar coalition year, yaxis(1) color(gs14) lcolor(gs14)) ///
  (line debtgdp_imp year, yaxis(1) lpattern(solid)) ///
  (line psi year, yaxis(2) lpattern(dash)) ///
  if country=="Belgium", scheme(lean2) xtitle("") legend(off) ysize(8) xsize (10) ///
  ytitle("Debt") ///
  ytitle("Commitment Potential", axis(2)) ///
  yscale(range(0 165)) ///
  yscale(range(0 1) axis(2)) ///
  ylabel(0 (50) 150, nogrid) ///
  ylabel(0 (0.5) 1, nogrid axis(2)) 
  
  graph twoway ///
  (bar coalition year, yaxis(1) color(gs14) lcolor(gs14)) ///
  (line debtgdp_imp year, yaxis(1) lpattern(solid)) ///
  (line psi year, yaxis(2) lpattern(dash)) ///
  if country=="Canada", scheme(lean2) xtitle("") legend(off) ysize(8) xsize (10) ///
  ytitle("Debt") ///
  ytitle("Commitment Potential", axis(2)) ///
  yscale(range(0 165)) ///
  yscale(range(0 1) axis(2)) ///
  ylabel(0 (50) 150, nogrid) ///
  ylabel(0 (0.5) 1, nogrid axis(2))  
  
  graph twoway ///
  (bar coalition year, yaxis(1) color(gs14) lcolor(gs14)) ///
  (line debtgdp_imp year, yaxis(1) lpattern(solid)) ///
  (line psi year, yaxis(2) lpattern(dash)) ///
  if country=="Denmark", scheme(lean2) xtitle("") legend(off) ysize(8) xsize (10) ///
  ytitle("Debt") ///
  ytitle("Commitment Potential", axis(2)) ///
  yscale(range(0 165)) ///
  yscale(range(0 1) axis(2)) ///
  ylabel(0 (50) 150, nogrid) ///
  ylabel(0 (0.5) 1, nogrid axis(2)) 
  
  graph twoway ///
  (bar coalition year, yaxis(1) color(gs14) lcolor(gs14)) ///
  (line debtgdp_imp year, yaxis(1) lpattern(solid)) ///
  (line psi year, yaxis(2) lpattern(dash)) ///
  if country=="Finland", scheme(lean2) xtitle("") legend(off) ysize(8) xsize (10) ///
  ytitle("Debt") ///
  ytitle("Commitment Potential", axis(2)) ///
  yscale(range(0 165)) ///
  yscale(range(0 1) axis(2)) ///
  ylabel(0 (50) 150, nogrid) ///
  ylabel(0 (0.5) 1, nogrid axis(2)) 

  graph twoway ///
  (bar coalition year, yaxis(1) color(gs14) lcolor(gs14)) ///
  (line debtgdp_imp year, yaxis(1) lpattern(solid)) ///
  (line psi year, yaxis(2) lpattern(dash)) ///
  if country=="France", scheme(lean2) xtitle("") legend(off) ysize(8) xsize (10) ///
  ytitle("Debt") ///
  ytitle("Commitment Potential", axis(2)) ///
  yscale(range(0 165)) ///
  yscale(range(0 1) axis(2)) ///
  ylabel(0 (50) 150, nogrid) ///
  ylabel(0 (0.5) 1, nogrid axis(2)) 
  
  graph twoway ///
  (bar coalition year, yaxis(1) color(gs14) lcolor(gs14)) ///
  (line debtgdp_imp year, yaxis(1) lpattern(solid)) ///
  (line psi year, yaxis(2) lpattern(dash)) ///
  if country=="Germany", scheme(lean2) xtitle("") legend(off) ysize(8) xsize (10) ///
  ytitle("Debt") ///
  ytitle("Commitment Potential", axis(2)) ///
  yscale(range(0 165)) ///
  yscale(range(0 1) axis(2)) ///
  ylabel(0 (50) 150, nogrid) ///
  ylabel(0 (0.5) 1, nogrid axis(2)) 
  
  graph twoway ///
  (bar coalition year, yaxis(1) color(gs14) lcolor(gs14)) ///
  (line debtgdp_imp year, yaxis(1) lpattern(solid)) ///
  (line psi year, yaxis(2) lpattern(dash)) ///
  if country=="Greece", scheme(lean2) xtitle("") legend(off) ysize(8) xsize (10) ///
  ytitle("Debt") ///
  ytitle("Commitment Potential", axis(2)) ///
  yscale(range(0 165)) ///
  yscale(range(0 1) axis(2)) ///
  ylabel(0 (50) 150, nogrid) ///
  ylabel(0 (0.5) 1, nogrid axis(2)) 

  graph twoway ///
  (bar coalition year, yaxis(1) color(gs14) lcolor(gs14)) ///
  (line debtgdp_imp year, yaxis(1) lpattern(solid)) ///
  (line psi year, yaxis(2) lpattern(dash)) ///
  if country=="Ireland", scheme(lean2) xtitle("") legend(off) ysize(8) xsize (10) ///
  ytitle("Debt") ///
  ytitle("Commitment Potential", axis(2)) ///
  yscale(range(0 165)) ///
  yscale(range(0 1) axis(2)) ///
  ylabel(0 (50) 150, nogrid) ///
  ylabel(0 (0.5) 1, nogrid axis(2)) 
  
  graph twoway ///
  (bar coalition year, yaxis(1) color(gs14) lcolor(gs14)) ///
  (line debtgdp_imp year, yaxis(1) lpattern(solid)) ///
  (line psi year, yaxis(2) lpattern(dash)) ///
  if country=="Italy", scheme(lean2) xtitle("") legend(off) ysize(8) xsize (10) ///
  ytitle("Debt") ///
  ytitle("Commitment Potential", axis(2)) ///
  yscale(range(0 165)) ///
  yscale(range(0 1) axis(2)) ///
  ylabel(0 (50) 150, nogrid) ///
  ylabel(0 (0.5) 1, nogrid axis(2)) 
  
  graph twoway ///
  (bar coalition year, yaxis(1) color(gs14) lcolor(gs14)) ///
  (line debtgdp_imp year, yaxis(1) lpattern(solid)) ///
  (line psi year, yaxis(2) lpattern(dash)) ///
  if country=="Japan", scheme(lean2) xtitle("") legend(off) ysize(8) xsize (10) ///
  ytitle("Debt") ///
  ytitle("Commitment Potential", axis(2)) ///
  yscale(range(0 165)) ///
  yscale(range(0 1) axis(2)) ///
  ylabel(0 (50) 150, nogrid) ///
  ylabel(0 (0.5) 1, nogrid axis(2))   

  graph twoway ///
  (bar coalition year, yaxis(1) color(gs14) lcolor(gs14)) ///
  (line debtgdp_imp year, yaxis(1) lpattern(solid)) ///
  (line psi year, yaxis(2) lpattern(dash)) ///
  if country=="Netherlands", scheme(lean2) xtitle("") legend(off) ysize(8) xsize (10) ///
  ytitle("Debt") ///
  ytitle("Commitment Potential", axis(2)) ///
  yscale(range(0 165)) ///
  yscale(range(0 1) axis(2)) ///
  ylabel(0 (50) 150, nogrid) ///
  ylabel(0 (0.5) 1, nogrid axis(2)) 

  graph twoway ///
  (bar coalition year, yaxis(1) color(gs14) lcolor(gs14)) ///
  (line debtgdp_imp year, yaxis(1) lpattern(solid)) ///
  (line psi year, yaxis(2) lpattern(dash)) ///
  if country=="Norway", scheme(lean2) xtitle("") legend(off) ysize(8) xsize (10) ///
  ytitle("Debt") ///
  ytitle("Commitment Potential", axis(2)) ///
  yscale(range(0 165)) ///
  yscale(range(0 1) axis(2)) ///
  ylabel(0 (50) 150, nogrid) ///
  ylabel(0 (0.5) 1, nogrid axis(2))  

  graph twoway ///
  (bar coalition year, yaxis(1) color(gs14) lcolor(gs14)) ///
  (line debtgdp_imp year, yaxis(1) lpattern(solid)) ///
  (line psi year, yaxis(2) lpattern(dash)) ///
  if country=="New Zealand", scheme(lean2) xtitle("") legend(off) ysize(8) xsize (10) ///
  ytitle("Debt") ///
  ytitle("Commitment Potential", axis(2)) ///
  yscale(range(0 165)) ///
  yscale(range(0 1) axis(2)) ///
  ylabel(0 (50) 150, nogrid) ///
  ylabel(0 (0.5) 1, nogrid axis(2)) 
  
  graph twoway ///
  (bar coalition year, yaxis(1) color(gs14) lcolor(gs14)) ///
  (line debtgdp_imp year, yaxis(1) lpattern(solid)) ///
  (line psi year, yaxis(2) lpattern(dash)) ///
  if country=="Portugal", scheme(lean2) xtitle("") legend(off) ysize(8) xsize (10) ///
  ytitle("Debt") ///
  ytitle("Commitment Potential", axis(2)) ///
  yscale(range(0 165)) ///
  yscale(range(0 1) axis(2)) ///
  ylabel(0 (50) 150, nogrid) ///
  ylabel(0 (0.5) 1, nogrid axis(2))  
  
  graph twoway ///
  (bar coalition year, yaxis(1) color(gs14) lcolor(gs14)) ///
  (line debtgdp_imp year, yaxis(1) lpattern(solid)) ///
  (line psi year, yaxis(2) lpattern(dash)) ///
  if country=="Spain", scheme(lean2) xtitle("") legend(off) ysize(8) xsize (10) ///
  ytitle("Debt") ///
  ytitle("Commitment Potential", axis(2)) ///
  yscale(range(0 165)) ///
  yscale(range(0 1) axis(2)) ///
  ylabel(0 (50) 150, nogrid) ///
  ylabel(0 (0.5) 1, nogrid axis(2))    
  
  graph twoway ///
  (bar coalition year, yaxis(1) color(gs14) lcolor(gs14)) ///
  (line debtgdp_imp year, yaxis(1) lpattern(solid)) ///
  (line psi year, yaxis(2) lpattern(dash)) ///
  if country=="Sweden", scheme(lean2) xtitle("") legend(off) ysize(8) xsize (10) ///
  ytitle("Debt") ///
  ytitle("Commitment Potential", axis(2)) ///
  yscale(range(0 165)) ///
  yscale(range(0 1) axis(2)) ///
  ylabel(0 (50) 150, nogrid) ///
  ylabel(0 (0.5) 1, nogrid axis(2))  
  
  graph twoway ///
  (bar coalition year, yaxis(1) color(gs14) lcolor(gs14)) ///
  (line debtgdp_imp year, yaxis(1) lpattern(solid)) ///
  (line psi year, yaxis(2) lpattern(dash)) ///
  if country=="Switzerland", scheme(lean2) xtitle("") legend(off) ysize(8) xsize (10) ///
  ytitle("Debt") ///
  ytitle("Commitment Potential", axis(2)) ///
  yscale(range(0 165)) ///
  yscale(range(0 1) axis(2)) ///
  ylabel(0 (50) 150, nogrid) ///
  ylabel(0 (0.5) 1, nogrid axis(2))  

  graph twoway ///
  (bar coalition year, yaxis(1) color(gs14) lcolor(gs14)) ///
  (line debtgdp_imp year, yaxis(1) lpattern(solid)) ///
  (line psi year, yaxis(2) lpattern(dash)) ///
  if country=="UK", scheme(lean2) xtitle("") legend(off) ysize(8) xsize (10) ///
  ytitle("Debt") ///
  ytitle("Commitment Potential", axis(2)) ///
  yscale(range(0 165)) ///
  yscale(range(0 1) axis(2)) ///
  ylabel(0 (50) 150, nogrid) ///
  ylabel(0 (0.5) 1, nogrid axis(2)) 

 ********
 
 * FIGURE 2. Debt and Commitment, 1960-2008(new version, very minor modifications, see wordfile)
 
  use Back_Lindvall_replication_data.dta, clear
  
  drop if year<1960
  
  drop if year>2008
  
  replace psi = . if coalition != 1
  
  replace debtgdp_imp = debtgdp_imp*100 
  
  collapse (mean) debtgdp_imp coalition psi, by(country)
  
  generate pos = 3
  replace pos = 6 if country == "Switzerland"
  replace pos = 12 if country == "Australia"
  
  twoway (scatter debtgdp_imp psi if coalition>0.33, mlab(country) mlabvpos(pos)) (lfit debtgdp_imp psi if coalition>0.33), ///
  scheme(lean2) ///
  xtitle("Mean Commitment Potential of Coalitions") legend(off) ysize(10) xsize (10) ///
  ytitle("Mean Debt (Percent)") ///
  yscale(range(0 100)) ///
  ylabel(0 (20) 100, nogrid) ///
  xscale(range(0.6 1)) ///
  xlabel(0.6 (0.1) 1) 
  
  
  ********
  
* FIGURE 3. The Effect of Coalition Government (new version, following suggestions by the reviewers, see attached word-file)

* Import excel file with predicted values

  import excel "Predictions_figure3.xlsx", sheet("Blad1") firstrow clear

* Drop out-of-sample values (as suggested by reviewers)

  drop if psi<0.1

* Rescale variables (as suggested by reviewers)  
  
  foreach i in pred_3 low_3 high_3 pred_4 low_4 high_4 pred_5 low_5 high_5 low_90_3 high_90_3 low_90_4 high_90_4 low_90_5 high_90_5 {
  replace `i' = `i'*100
  }
  
* Figure (a)

  twoway (rarea low_3 high_3 psi, color(gs14)) (rarea low_90_3 high_90_3 psi, color(gs12)) (line pred_3 psi, lpattern(solid)) (function y = 0, lpattern(solid)), scheme(tufte) xsize(5) ysize(5) ylabel(-1 (1) 3,nogrid) legend(off) xtitle("Commitment Potential of Coalition") ytitle("Effect of Coalition") xscale(range(0 1)) yscale(range(-1.5 3.5))

* Figure (b)

  twoway (rarea low_4 high_4 psi, color(gs14)) (rarea low_90_4 high_90_4 psi, color(gs12)) (line pred_4 psi, lpattern(solid)) (function y = 0, lpattern(solid)), scheme(tufte) xsize(5) ysize(5) ylabel(-1 (1) 3,nogrid) legend(off) xtitle("Commitment Potential of Coalition") ytitle("Effect of Coalition") xscale(range(0 1)) yscale(range(-1.5 3.5))

* Figure (c)

  twoway (rarea low_5 high_5 psi, color(gs14)) (rarea low_90_5 high_90_5 psi, color(gs12)) (line pred_5 psi, lpattern(solid)) (function y = 0, lpattern(solid)), scheme(tufte) xsize(5) ysize(5) ylabel(-1 (1) 3,nogrid) legend(off) xtitle("Commitment Potential of Coalition") ytitle("Effect of Coalition") xscale(range(0 1)) yscale(range(-1.5 3.5))

  *********
  
   
* SUPPLEMENTARY MATERIALS (same as in article version)

use Back_Lindvall_replication_data.dta, clear

* TABLE 1. Interactive Models of Changes in Debt, 1961-2008

* model 1

  xtpcse D1.debtgdp_imp L1.D1.debtgdp_imp L1.debtgdp_imp gdpgr01 D1.unemp01 debt_service L1.coalition L1.coalition_interaction if L1.p_polity2 > 4, pairwise

* model 2

  xtpcse D1.debtgdp_imp L1.D1.debtgdp_imp L1.debtgdp_imp gdpgr01 D1.unemp01 debt_service L1.coalition L1.coalition_interaction L1.psi L1.psi_interaction if L1.p_polity2 > 4, pairwise

* TABLE 2. Models With Alternative Measures of Debt, 1961-2008

* (model) RR

  xtpcse D1.debtgdp01 L1.D1.debtgdp01 L1.debtgdp01 gdpgr01 D1.unemp01 debt_service_rr L1.coalition L1.psi if L1.p_polity2 > 4, pairwise

* (model) OECD

  xtpcse D1.debt01 L1.D1.debt01 L1.debt01 gdpgr01 D1.unemp01 debt_service_arm L1.coalition L1.psi if L1.p_polity2 > 4, pairwise

* (model) IMF

  xtpcse D1.debt_imf01 L1.D1.debt_imf01 L1.debt_imf01 gdpgr01 D1.unemp01 debt_service_imf L1.coalition L1.psi if L1.p_polity2 > 4, pairwise

* (model) RR

  xtpcse D1.debtgdp01 L1.D1.debtgdp01 L1.debtgdp01 gdpgr01 D1.unemp01 debt_service_rr L1.coalition L1.psi L1.electionyear L1.minority L1.irange L1.pres L1.fed L1.strbic if L1.p_polity2 > 4, pairwise

* (model) OECD

  xtpcse D1.debt01 L1.D1.debt01 L1.debt01 gdpgr01 D1.unemp01 debt_service_arm L1.coalition L1.psi L1.electionyear L1.minority L1.irange L1.pres L1.fed L1.strbic if L1.p_polity2 > 4, pairwise

* (model) IMF

  xtpcse D1.debt_imf01 L1.D1.debt_imf01 L1.debt_imf01 gdpgr01 D1.unemp01 debt_service_imf L1.coalition L1.psi L1.electionyear L1.minority L1.irange L1.pres L1.fed L1.strbic if L1.p_polity2 > 4, pairwise





