* Set working directory
cd "..."

use "UK Election Data.dta", clear



****************************** SUMMARY STATISTICS

*** Table A1: Summary statistics: RD and full BES samples
summ con leave high_school min15 min16 male white black asian age fathermanual survey birthyear if yearat14>=1936 & yearat14<=1958
summ con leave high_school min15 min16 male white black asian age fathermanual survey birthyear



****************************** GRAPHICAL ANALYSIS

bysort yearat14 : g weight_14 = _N
bysort yearat14 : egen meanleave14 = mean(leave)

g leave_l8 = leave<9 if leave!=.
by yearat14, sort : egen meanleave_l8 = mean(leave_l8)
g leave_l9 = leave<10 if leave!=.
by yearat14, sort : egen meanleave_l9 = mean(leave_l9)
g leave_l10 = leave<11 if leave!=.
by yearat14, sort : egen meanleave_l10 = mean(leave_l10)
g leave_l11 = leave<12 if leave!=.
by yearat14, sort : egen meanleave_l11 = mean(leave_l11)

*** Figure 3: 1947 compulsory schooling reform and student leaving age by cohort
twoway (lpoly leave_l8 yearat14 if yearat14<1947 & yearat14>=1925, lcolor(gs14) clwidth(thick) degree(4)) ///
  (lpoly leave_l8 yearat14 if yearat14>=1947 & yearat14<=1970, lcolor(gs14) clwidth(thick) degree(4)) ///
  (scatter meanleave_l8 yearat14 if yearat14>=1925 & yearat14<=1970 [weight=weight_14], msize(tiny) mcolor(gs14)) ///
  (lpoly leave_l9 yearat14 if yearat14<1947 & yearat14>=1925, lcolor(gs10) clwidth(thick) degree(4)) ///
  (lpoly leave_l9 yearat14 if yearat14>=1947 & yearat14<=1970, lcolor(gs10) clwidth(thick) degree(4)) ///
  (scatter meanleave_l9 yearat14 if yearat14>=1925 & yearat14<=1970 [weight=weight_14], msize(tiny) mcolor(gs10)) ///
  (lpoly leave_l10 yearat14 if yearat14<1947 & yearat14>=1925, lcolor(gs6) clwidth(thick) degree(4)) ///
  (lpoly leave_l10 yearat14 if yearat14>=1947 & yearat14<=1970, lcolor(gs6) clwidth(thick) degree(4)) ///
  (scatter meanleave_l10 yearat14 if yearat14>=1925 & yearat14<=1970 [weight=weight_14], msize(tiny) mcolor(gs6)) ///
  (lpoly leave_l11 yearat14 if yearat14<1947 & yearat14>=1925, lcolor(black) clwidth(thick) degree(4)) ///
  (lpoly leave_l11 yearat14 if yearat14>=1947 & yearat14<=1970, lcolor(black) clwidth(thick) degree(4)) ///
  (scatter meanleave_l11 yearat14 if yearat14>=1925 & yearat14<=1970 [weight=weight_14], msize(tiny) mcolor(black)), ///
  graphregion(fcolor(white) lcolor(white)) ylab(,nogrid) ytitle(Proportion leaving) xtitle(Cohort: year aged 14) xline(1946.5, lcolor(black) lpattern(dash)) xlab(1925(5)1970) ///
  legend(nobox region(fcolor(white) margin(zero) lcolor(white)) lab(3 "Leave before 14") lab(6 "Leave before 15") lab(9 "Leave before 16") lab(12 "Leave before 17") order(3 6 9 12) row(1)) 

*** Figure A3: 1972 compulsory schooling reform and student leaving age by cohort
twoway (lpoly leave_l8 yearat14 if yearat14<1972 & yearat14>=1950, lcolor(gs14) clwidth(thick) degree(4)) ///
  (lpoly leave_l8 yearat14 if yearat14>=1972 & yearat14<=1995, lcolor(gs14) clwidth(thick) degree(4)) ///
  (scatter meanleave_l8 yearat14 if yearat14>=1950 & yearat14<=1995 [weight=weight_14], msize(tiny) mcolor(gs14)) ///
  (lpoly leave_l9 yearat14 if yearat14<1972 & yearat14>=1950, lcolor(gs10) clwidth(thick) degree(4)) ///
  (lpoly leave_l9 yearat14 if yearat14>=1972 & yearat14<=1995, lcolor(gs10) clwidth(thick) degree(4)) ///
  (scatter meanleave_l9 yearat14 if yearat14>=1950 & yearat14<=1995 [weight=weight_14], msize(tiny) mcolor(gs10)) ///
  (lpoly leave_l10 yearat14 if yearat14<1972 & yearat14>=1950, lcolor(gs6) clwidth(thick) degree(4)) ///
  (lpoly leave_l10 yearat14 if yearat14>=1972 & yearat14<=1995, lcolor(gs6) clwidth(thick) degree(4)) ///
  (scatter meanleave_l10 yearat14 if yearat14>=1950 & yearat14<=1995 [weight=weight_14], msize(tiny) mcolor(gs6)) ///
  (lpoly leave_l11 yearat14 if yearat14<1972 & yearat14>=1950, lcolor(black) clwidth(thick) degree(4)) ///
  (lpoly leave_l11 yearat14 if yearat14>=1972 & yearat14<=1995, lcolor(black) clwidth(thick) degree(4)) ///
  (scatter meanleave_l11 yearat14 if yearat14>=1950 & yearat14<=1995 [weight=weight_14], msize(tiny) mcolor(black)), ///
  graphregion(fcolor(white) lcolor(white)) ylab(,nogrid) ytitle(Proportion leaving) xtitle(Cohort: year aged 15) xline(1971.5, lcolor(black) lpattern(dash)) xlab(1950(5)1995) ///
  legend(nobox region(fcolor(white) margin(zero) lcolor(white)) symxsize(20) lab(3 "Leave before 14") lab(6 "Leave before 15") lab(9 "Leave before 16") lab(12 "Leave before 17") order(3 6 9 12) row(1)) 


  
****************************** ANALYSIS

*** Table 1: Estimates of schooling’s effect on voting Conservative
* Note: The Stata package "rdrobust" must be installed (see https://sites.google.com/site/rdpackages/rdrobust). The first stage F statistics are computed from the t statistics from the first stage regressions.
rdrobust con yearat14, c(1947) fuzzy(leave) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust con yearat14, c(1947) fuzzy(high_school) p(1) q(2) kernel(tri) bwselect(IK)



*** Table A2: Using the 1972 reform to identify the extent of coarsening bias
* Note: The Stata package "estout2" must be installed.
eststo clear
eststo, title("OLS"): xi: reg con min15 min16 syearat14-syearat14cub, ro
eststo, title("2SLS"): xi: ivregress 2sls con (leave = min15 min16) syearat14-syearat14cub, ro first
capture g leave_15 = leave==10
eststo, title("2SLS"): xi: ivreg2 con (leave_15 high_school = min15 min16) syearat14-syearat14cub, ro first
estout, style(tex) cells(b(star fmt(3)) se(par)) stats(N, fmt(0)) label legend starlevels(* 0.1 ** 0.05 *** 0.01) keep(min15 min16 leave leave_15 high_school) ///
  varlabels(min15 "Post 1947 reform" min16 "Post 1972 reform" leave "Years of schooling" high_school "Completed high school" leave_15 "Penultimate")
