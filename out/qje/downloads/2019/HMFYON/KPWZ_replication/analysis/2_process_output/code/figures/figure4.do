* Who Profits from Patents? Rent-Sharing at Innovative Firms
* Figure 4
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019

* This .do file plots event study results. The dependent variable is wages per worker.




*--------- FIGURE 4 ---------*

	import delimited using "$data/ES30/ES_firmFX_wb_emp.csv", clear varn(1)

    *Start setup
    * Don't want time horizon = 5, so remove first and last obs in each group
    keep if   inlist(var,"Dn4W_Q5","Dn3W_Q5","Dn2W_Q5","D0W_Q5","D1W_Q5","D2W_Q5","D3W_Q5","D4W_Q5") ///
            | inlist(var,"Dn4W_nQ5","Dn3W_nQ5","Dn2W_nQ5","D0W_nQ5","D1W_nQ5","D2W_nQ5","D3W_nQ5","D4W_nQ5") ///
            | inlist(var,"Dn5pW_Q5","D5pW_Q5","Dn5pW_nQ5","D5pW_nQ5")

    local new_obs = _N + 2
    loc new_obs_m1 = `new_obs'-1
    * Add one more observation so we have an additional time period for -1, which will be normalized
    set obs `=_N + 2'

    * compute the relative years
    g t = mod(_n,10) - 6 if mod(_n,10) < 5 & mod(_n,10) != 0
    replace t = mod(_n,10) - 5 if mod(_n,10) >= 5
    replace t = 5 if mod(_n,10) == 0
    replace t = -1 in `new_obs_m1'/`new_obs'

    * generate indicator for Q5 and nQ5
    gen q5 = 1
    replace q5 = 0 if substr(var,-3,.)=="nQ5" | _n==`new_obs'

    sort q5 t

    * Normalized period (t = -1 -> 0)
    replace coef = 0 if missing(coef)
    replace stderr = 0 if missing(stderr)

    rename (coef stderr) (b se)

    * compute the confidence intervals
    gen fig_upper=b+$ci*se
    gen fig_lower=b-$ci*se
    gen fig_t = t
    rename b* fig_b*

    replace fig_t = fig_t+.15 if q5==1

    * set values for figures
    loc c1 "dknavy"
    loc c2 "ebblue"
    loc c3 "red"
    loc ytitle "Thousands of 2014 USD per worker"
    loc coeff = 3.65

    gen ll = `coeff' if t == 0
    replace ll = `coeff' if t == 5
    replace t = 5.15 if t==5

	* graph
    twoway ///
      (connected fig_b fig_t if q5==1, xline(-0.0, lc(gs11) lp(longdash)) ///
        yline(0, lc(gs11) lp(longdash)) lpattern(solid) lcolor(`c1') mcolor(`c1') msymbol(O)) ///
      (rcap fig_upper fig_lower fig_t  if q5==1, lpattern(solid) lcolor(`c1') c(l) m(i)) ///
      (connected fig_b fig_t if q5==0, lpattern(dash) lcolor(`c2') mcolor(`c2') msymbol(D)) ///
      (rcap fig_upper fig_lower fig_t  if q5==0, lpattern(dash) lcolor(`c2') c(l) m(i)) ///
      (line ll t if q5==1, lcolor(`c3') lpattern(shortdash)), ///
      plotregion(fcolor(white) lcolor(white)) graphregion(fcolor(white) lcolor(white)) ///
      title("") ytitle("`ytitle'") xtitle("Years since initial decision") ///
      xlab(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "{&ge}5") ///
      legend(order(1 "High value (Q5)" 3 "Lower value (<Q5)") ///
      region(lcolor(white)))
    graph export "$figures/figure4.pdf", replace
	
	

