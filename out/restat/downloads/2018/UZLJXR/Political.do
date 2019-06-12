** Berkowitz, Ma and Nishioka (Updated 12-25-2015) Figures 2-4


  cd C:\Users\shuichiro\Documents\Research\_Berkowitz&Ma&Nishioka\_RIRB\_Data
	
  //** Fig 2 **//
  
	clear
    import excel "_pw_r.xlsx", sheet("year") firstrow
	replace north = 1-1/exp(north)
	replace east = 1-1/exp(east)
	replace south = 1-1/exp(south)
	replace west = 1-1/exp(west)
    tsset year
	twoway (tsline north, lcolor(gray) lpattern(dash) lwidth(medthick)) (tsline east, lcolor(green) lpattern(longdash) lwidth(medthick)) ///
	(tsline south, lcolor(blue) lpattern(dash_dot) lwidth(medthick)) (tsline west, lcolor(black) lpattern(shortdash) lwidth(medthick)), ///
	legend(rows(1)) title(Fig. 2. Political weight on excess employment) ytitle(political weight (% to profits)) xtitle("")
	graph export _trend_pw_irb.emf, replace

	
  //** Fig 3 **//
  
    clear
    import excel "_GMM.xlsx", sheet("sectors") firstrow
    save _GMM.dta, replace
	
	clear
    import excel "_pw.xlsx", sheet("_pw_2") firstrow
	replace pw = exp(pw_2)
	save _pw.dta, replace
  
    use _LS_dta.dta, clear
    merge m:m cic_3 using "_GMM.dta"
    drop _merge
    erase _GMM.dta
	merge m:m year using "_pw.dta"
    drop _merge
    erase _pw.dta
	
	keep if bp_dum == 1
	gen markup_m = 1.11
	
	gen oel = bs_1/(1+((1-bs_3)/bs_3)*((real_cap/aemployee)^((bs_2-1)/bs_2)))
	gen p_ps = (markup_m-1)/(markup_m-1+bs_1)-((pw-1)/(markup_m-1+bs_1))*oel
	gen p_profit = p_ps*value_added
	
	collapse (sum)value_added (sum)profit (sum)p_profit, by(owner_n year)
	
	gen shareP = profit/value_added
	gen shareP_p = p_profit/value_added
	
    twoway (tsline shareP if owner_n == 0, lcolor(blue) lwidth(medthick)) (tsline shareP_p if owner_n == 0, lcolor(black) lwidth(medthick) lpattern(dash)), ///
	legend(order(1 "actual (SOE)" 2 "predicted (SOE)") rows(1)) title("Fig 3. Actual and predicted profit shares" "(aggregate and SOEs)") ytitle(profit shares) xtitle("")
	graph export _trend_pps.emf, replace
	
	
  //** Fig 4 **//
  
    clear
    import excel "_GMM.xlsx", sheet("sectors") firstrow
    save _GMM.dta, replace
	
	clear
    import excel "_pw.xlsx", sheet("_pw_2") firstrow
	replace pw = exp(pw_2)
	save _pw.dta, replace
  
    use _LS_dta.dta, clear
    merge m:m cic_3 using "_GMM.dta"
    drop _merge
    erase _GMM.dta
	merge m:m year using "_pw.dta"
    drop _merge
    erase _pw.dta
	
	keep if bp_dum == 1
	gen markup_m = 1.11
	
	gen ln_kl = ln(kl)
	egen bs_1_m = mean(bs_1)
	egen bs_2_m = mean(bs_2)
	egen bs_3_m = mean(bs_3)
	gen oel = bs_1_m/(1+((1-bs_3_m)/bs_3_m)*((real_cap/aemployee)^((bs_2_m-1)/bs_2_m)))
	gen p_ps = (markup_m-1)/(markup_m-1+bs_1_m)-((pw-1)/(markup_m-1+bs_1_m))*oel
	
	twoway (scatter p_ps ln_kl if owner_n == 0 & year == 1998, msymbol(oh) mcolor(gs10)) (scatter p_ps ln_kl if owner_n == 0 & year == 2007, msymbol(th) mcolor(green)), ///
	legend(order(1 "1998 (SOE)" 2 "2007 (SOE)") rows(1)) yline(0) title("Fig 4. Predicted profit shares for SOEs") ytitle(fitted profit share) xtitle(ln(capital intensity) by firms)
	graph export _pps.emf, replace


clear
