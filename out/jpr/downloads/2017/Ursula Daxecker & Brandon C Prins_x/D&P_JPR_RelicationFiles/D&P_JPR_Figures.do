
use "D&P_JPR_Data.dta"

*POOLED MODELS, PREDICTION FIGURES, In and out of sample*
*Figure 2*
*NBREG, comparing model with piracy to one with natural resources and null model, model 2 table 1*
tsset ucdpid yearmonth
set scheme s1color
quietly nbreg gedconfeventnew   l.allincidents   onshoreoil diamond    l12.rpe_gdpimp l12.lnpopWB l.gedconfeventnew   i.year, cluster(ucdpid)
predict probhat1 if e(sample)
gen new=1 if e(sample)
sum probhat1 gedconfeventnew  if e(sample)
nbreg gedconfeventnew     onshoreoil diamond    l12.rpe_gdpimp l12.lnpopWB l.gedconfeventnew   i.year if new==1, cluster(ucdpid)
predict probhat2 if e(sample)
sum probhat2 gedconfeventnew  if e(sample)
quietly nbreg gedconfeventnew   l.gedconfeventnew  i.year  if allincidents!=.&new==1, cluster(ucdpid)   
predict probhat3 if e(sample)
sum probhat3 gedconfeventnew  if e(sample)
*Figure to compare predicted vs. actual values, dashed line is prediction*
set scheme lean1
twoway (mband gedconfeventnew  yearmonth, lcolor(gs8) lpattern(shortdash)) (mband probhat1  yearmonth , lcolor(cyan))  (mband probhat2 yearmonth, lcolor(red) lpattern()) (mband probhat3 yearmonth, lcolor(yellow) lpattern()) if e(sample), tlab(1994m1 (24) 2014m3) xlabel(,labsize(vsmall)) ylabel(0(1)8,labsize(vsmall))  xtitle("") tline(2011m1) text(0.2 598 "<-In-Sample", size(vsmall)) text(0.2 628 "Out-of-Sample->", size(vsmall)) legend(lab (1 "Observed") lab (2 "With 1-Month Piracy Lag") lab (3 "With Oil and Diamonds") lab (4 "Null Model")  pos(6) row(1) size(vsmall)) title("Observed and Forecasted Conflict Events", size(vsmall))   ytitle("Median Count Conflict Events", size(vsmall)) saving("figure2woil", replace)
drop probhat1 probhat2 probhat3  new
graph save  "Figure 2 JPR forecasting.gph", replace
graph export  "Figure 2 JPR forecasting.png", width(4000) as(png) replace

*Figure 3*
*NBREG, comparing model with single lag to moving average, model 2 and 4 in table 1*
tsset ucdpid yearmonth
set scheme s1color
quietly nbreg gedconfeventnew   l.allincidents   onshoreoil diamond    l12.rpe_gdpimp l12.lnpopWB l.gedconfeventnew   i.year, cluster(ucdpid)
predict probhat1 if e(sample)
gen new=1 if e(sample)
sum probhat1 gedconfeventnew  if e(sample)
quietly nbreg gedconfeventnew   allincidents6movavg   onshoreoil diamond    l12.rpe_gdpimp l12.lnpopWB l.gedconfeventnew   i.year, cluster(ucdpid)
predict probhat2 if e(sample)
sum probhat2 gedconfeventnew  if e(sample)
*Figure to compare predicted vs. actual values, dashed line is prediction*
set scheme lean1
twoway (mband gedconfeventnew  yearmonth, lcolor(gs8) lpattern(shortdash)) (mband probhat1  yearmonth, lcolor(cyan))  (mband probhat2 yearmonth, lcolor(magenta) lpattern()) if e(sample) ,tlab(1994m1(24)2014m3) xlab(,labsize(vsmall)) ylabel(0(1)12,labsize(vsmall)) scheme(lean1)  xtitle("") tline(2011m1) text(0.2 598 "<-In-Sample", size(vsmall)) text(0.2 628 "Out-of-Sample->", size(vsmall)) ttext(612 2011m1 "Sample") legend(lab (1 "Observed") lab (2 "With 1-Month Piracy Lag") lab (3 "With 6-Month MA Piracy Lag")  pos(6) row(1) size(vsmall)) title("Observed and Forecasted Conflict Events, In- and Out-of-Sample", size(vsmall))   ytitle("Median Count Conflict Events", size(vsmall)) saving("insamples", replace)
drop probhat1 probhat2  new
graph save  "Figure 2 JPR forecasting.gph", replace
graph export  "Figure 2 JPR forecasting.png", width(4000) as(png) replace






