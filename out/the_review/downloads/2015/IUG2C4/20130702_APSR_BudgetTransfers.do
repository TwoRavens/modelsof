cd "C:\Users\ejm5\Dropbox\District People Councils\Statafiles"
use budget_pop.dta
log using budget_analysis.smcl, replace

replace total_trans=total_trans/1000/population
replace non_target=non_target/1000/population
replace target=target/1000/population


/*T-Tests*/
xtset id year
ttest  rev_share if year>=2008 & year<=2010, by(treatment)
ttest  total_trans  if year>=2008 & year<=2010, by(treatment)
ttest  non_target if year>=2008 & year<=2010, by(treatment)
ttest  target if year>=2008 & year<=2010, by(treatment)

generate growth_rev_share=(rev_share-l2.rev_share)/rev_share if year==2010
generate growth_total_trans=(total_trans-l2.total_trans)/total_trans if year==2010 
generate growth_non_target=(non_target-l2.non_target)/non_target if year==2010
generate growth_target=(target-l2.target)/target if year==2010

ttest  growth_rev_share , by(treatment)
ttest  growth_total_trans , by(treatment)
ttest  growth_non_target , by(treatment)
ttest  growth_target , by(treatment)


/*Collapse to Aggregates*/
collapse (mean)  rev_share total_trans non_target target (semean) serev=rev_share setotal=total_trans sesnon=non_target setarget=target, by(treatment year)

generate low_rev= rev_share-(1.6*serev)
generate high_rev= rev_share+(1.6*serev)

generate low_total= total-(1.6*setotal)
generate high_total= total+(1.6*setotal)

generate low_non= non-(1.6*sesnon)
generate high_non= non+(1.6*sesnon)

generate low_tar= target-(1.6*setarget)
generate high_tar= target+(1.6*setarget)



/*Graph - Revenue Share*/
#delimit;
twoway (rcap low_rev high_rev year if treatment==0, lcolor(gs7) lwidth(thick)) (rcap low_rev high_rev year if treatment==1,  lcolor(gs13) lwidth(thick))  
(line  rev_share year if treatment==0, lpattern(dash) lcolor(gs3) lwidth(medthick))   
(line  rev_share year if treatment==1, lpattern(solid) lcolor(black) lwidth(medthick)) ,  
 xtitle("") ytitle("Revenue Retained(%)", size(medium) margin(small)) ylab(,labsize(small)) xlab(,labsize(small)) 
 subtitle("T-test of Growth in Control v. Treatment ('08-'10): p= 0.67", size(small)) title("4. Revenue Sharing", size(large)) legend(off)
 graphregion(fcolor(white) ifcolor(white)) plotregion(fcolor(white) ifcolor(white)) ;
graph save budget_rev.gph, replace;


/*Graph - Total Transfer*/;
#delimit;
twoway (rcap low_total high_total year if treatment==0, lcolor(gs7) lwidth(thick)) (rcap low_total high_total year if treatment==1,  lcolor(gs13) lwidth(thick))
  (line  total_trans year if treatment==0, lpattern(dash) lcolor(gs3) lwidth(medthick))   
  (line  total_trans year if treatment==1, lpattern(solid) lcolor(black) lwidth(medthick)) ,   
  xtitle("") ytitle("Mill. VND per capita", size(medium) margin(small)) ylab(,labsize(small)) xlab(,labsize(small))   
  subtitle("T-test of Growth in Control v. Treatment ('08-'10): p= 0.84", size(small)) title("1. Total Transfers to  Province", size(large)) legend(off)
  graphregion(fcolor(white) ifcolor(white)) plotregion(fcolor(white) ifcolor(white)) ;
graph save budget_total.gph, replace;


/*Graph - Equalizing Transfers*/;
#delimit;
twoway (rcap low_non high_non year if treatment==0, lcolor(gs7) lwidth(thick)) (rcap low_non high_non year if treatment==1,  lcolor(gs13) lwidth(thick))  
(line non_target year if treatment==0, lpattern(dash) lcolor(gs3) lwidth(medthick))   
(line  non_target year if treatment==1, lpattern(solid) lcolor(black) lwidth(medthick)) ,   
xtitle("") ytitle("Mill. VND per capita", size(medium) margin(small)) ylab(,labsize(small)) xlab(,labsize(small))  
subtitle("T-test of Growth in Control v. Treatment ('08-'10): p= 0.73", size(small)) title("2. Equalizing Transfers", size(large)) legend(off)
graphregion(fcolor(white) ifcolor(white)) plotregion(fcolor(white) ifcolor(white)) ;
graph save budget_equal.gph, replace;


/*Graph - Target Transfers*/;
#delimit;
twoway (rcap low_tar high_tar year if treatment==0, lcolor(gs7) lwidth(thick)) (rcap low_tar high_tar year if treatment==1,  lcolor(gs13) lwidth(thick))  
(line target year if treatment==0, lpattern(dash) lcolor(gs3) lwidth(medthick))   
(line  target year if treatment==1, lpattern(solid) lcolor(black) lwidth(medthick)) ,   
xtitle("") ytitle("Mill. VND per capita", size(medium) margin(small)) ylab(,labsize(small)) xlab(,labsize(small))  
subtitle("T-test of Growth in Control v. Treatment ('08-'10): p= 0.46", size(small)) title("3. Target Transfers", size(large)) legend(off)
graphregion(fcolor(white) ifcolor(white)) plotregion(fcolor(white) ifcolor(white)) ;
graph save budget_target.gph, replace;


#delimit;
graph combine budget_total.gph budget_equal.gph budget_target.gph budget_rev.gph, rows(2) cols(2) xcommon;
graph save budget_combined.gph, replace;


#delimit;
graph combine budget_total.gph budget_equal.gph budget_target.gph budget_rev.gph liabilities.gph equity.gph, rows(3) cols(2) imargin(small)
graphregion(fcolor(white) ifcolor(white)) plotregion(fcolor(white) ifcolor(white)) ;
graph save budget_SOE_combined.gph, replace;


