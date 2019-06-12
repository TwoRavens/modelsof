* Who Profits from Patents? Rent-Sharing at Innovative Firms
* Figure 2
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019

* This .do file plots dose impacts on wage bill and surplus per worker




*--------- FIGURE 2 ---------*
  /* This csv pulls data from the .log file QJE_dose_dollar.log. To locate results
  in the .log file, look for the A[2,21] lists of results for s1_emp and wb_emp. */
  import delimited using "$data/QJEtables_dose_dollar/csv/data_dose9.csv", varn(1) clear
  
  * Calculate lower and upper bounds of the confidence intervals
  gen coeff_up=coeff+$ci*stderr
  gen coeff_dn=coeff-$ci*stderr
  
  * Offset slightly
  gen mu = m + .4
  
  * Graph
  twoway ///
    (scatter coeff mu if variable=="s1_emp", ///
      c(l) lpattern(dash) lcolor(navy) mcolor(navy) msymbol(D)) ///
    (rcap coeff_up coeff_dn mu if variable=="s1_emp", ///
      lpattern(dash) lcolor(navy) c(l) m(i)) ///
    (scatter coeff m if variable=="wb_emp", ///
      c(l) lpattern(solid) lcolor(cranberry) mcolor(cranberry) msymbol(O)) ///
    (rcap coeff_up coeff_dn m if variable=="wb_emp", ///
      lpattern(solid) lcolor(cranberry) c(l) m(i)), ///
    plotregion(fcolor(white)) graphregion(fcolor(white) lcolor(white)) ///
    xlabel(0(4)20) yline(0.0, lp(shortdash) lc(gs11)) xline($Q5, lc(red) lp(solid)) ///
    title("") ytitle("Thousands of 2014 USD per worker") ///
      xtitle("Predicted patent value (millions of 1982 USD)") ///
    legend(order(1 "Surplus per worker" 3 "Wage bill per worker") ///
      region(lcolor(white)))
  graph export "$figures/figure2.pdf", replace
  
