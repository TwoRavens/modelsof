

// We have included in the original dataset the sPSNS index following the synatx reported below:
gen sPSNS = 0.835 if cntry==18
replace sPSNS = 0.484 if cntry==1
replace sPSNS = 0.901 if cntry==2
replace sPSNS = 0.876 if cntry==3
replace sPSNS = 0.834 if cntry==5
replace sPSNS = 0.794 if cntry==23
replace sPSNS = 0.862 if cntry==8
replace sPSNS = 0.777 if cntry==4
replace sPSNS = 0.921 if cntry==6
replace sPSNS = 0.915 if cntry==15
replace sPSNS = 0.834 if cntry==9
replace sPSNS = 0.837 if cntry==10
replace sPSNS = 0.741 if cntry==12
replace sPSNS = 0.872 if cntry==17
replace sPSNS = 0.873 if cntry==19
replace sPSNS = 0.887 if cntry==20
replace sPSNS = 0.806 if cntry==22
replace sPSNS = 0.891 if cntry==21
replace sPSNS = 0.803 if cntry==7
replace sPSNS = 0.897 if cntry==24
replace sPSNS = 0.798 if cntry==25
replace sPSNS = 0.824 if cntry==26
replace sPSNS = 0.779 if cntry==14
replace sPSNS = 0.804 if cntry==28

*/
/// Cyprus, Malta, Luxembourg, Lithuania excluded 
drop if cntry== 16
drop if cntry== 14
drop if cntry== 11
drop if cntry== 13

eststo clear
//Null model
eststo: xtmixed ptv || cntry: || respid: ||

//mlrsq
mlrsq
esttab, se aic bic r2 scalars("cr2 R-squared (BLUPs)") b(3) wide label mtitles replace

//Model A without sPSNS index and related interactions
eststo clear
eststo: xtmixed ptv  y_born  y_female y_married y_educ y_churchatt y_unemployed y_polint y_minority ///
lrdist01 y_worker y_religiosity y_unionmemb y_faminc y_membgood  partysize_01 party_is_close ///
|| cntry: || respid: ||

predict b*, reffects

//mlrsq
mlrsq
esttab, se aic bic r2 scalars("cr2 R-squared (BLUPs)") b(3) wide label mtitles replace


//Model B with interactions
eststo: xtmixed ptv  y_born  y_female y_married y_educ y_churchatt y_unemployed y_polint y_faminc y_membgood  ///
partysize_01 party_is_close y_religiosity c.sPSNS##c.(y_minority lrdist01 y_worker  y_unionmemb)  ///
|| cntry: , cov(un)|| respid: , cov(un)||


//Model C with all interactions (final model)

eststo: xtmixed ptv  y_born  y_female y_married y_educ y_churchatt y_unemployed y_polint y_faminc y_membgood  ///
partysize_01 party_is_close c.sPSNS##c.(y_minority lrdist01 y_worker y_religiosity y_unionmemb)  ///
|| cntry: , cov(un)|| respid: , cov(un)||


predict rs2, rstandard
qnorm rs2

predict c*, reffects

/* Note: we have followed Brambor et al.[2006] in order to interpret the significance and the sign of the interactions
 */

margins, dydx (lrdist01) at (sPSNS= (0.5 (0.1) 0.9)) vsquish 
marginsplot, recast(line) recastci(rarea) ciopts(lpattern(dot))

margins, at (lrdist01= (0 (0.1) 1) sPSNS=(0.5 (0.1) 0.9)) vsquish
marginsplot, noci x(lrdist01) recast(line)

margins, at (lrdist01= (0(0.1)1) sPSNS=(0.5 0.9)) vsquish
marginsplot, x(lrdist01) recastci(rarea) recast(line)ciopts(lpattern(dot))

margins, dydx (y_minority) at (sPSNS= (0.5 (0.1) 0.9)) vsquish 
marginsplot, recast(line) recastci(rarea) ciopts(lpattern(dot))

margins, at (y_minority= (-3(1)5) sPSNS=(0.5 (0.1) 0.9)) vsquish
marginsplot, noci x(y_minority) recast(line)

margins, dydx (y_worker) at (sPSNS= (0.5 (0.1) 0.9)) vsquish 
marginsplot, recast(line) recastci(rarea) ciopts(lpattern(dot))

margins, at (y_worker= (-3(1)2) sPSNS=(0.5 (0.1) 0.9)) vsquish
marginsplot, noci x(y_worker) recast(line)

margins, dydx (y_unionmemb) at (sPSNS= (0.5 (0.1) 0.9)) vsquish 
marginsplot, recast(line) recastci(rarea) ciopts(lpattern(dot))

margins, at (y_unionmemb= (-2(1)1) sPSNS=(0.5 (0.1) 0.9)) vsquish
marginsplot, noci x(y_unionmemb) recast(line) 

margins, dydx (y_religiosity) at (sPSNS= (0.5 (0.1) 0.9)) vsquish 
marginsplot, recast(line) recastci(rarea) ciopts(lpattern(dot))

margins, at (y_religiosity= (-2(1)3) sPSNS=(0.5 (0.1) 0.9)) vsquish
marginsplot, noci x(y_religiosity) recast(line)

margins, at (y_faminc= (-4(1)3) sPSNS=(0.5  0.9)) vsquish
marginsplot, x(y_faminc) recastci(rarea) recast(line)ciopts(lpattern(dot))

margins, dydx (y_faminc) at (sPSNS= (0.484 0.741 0.803 0.862 0.921)) vsquish 
marginsplot, recast(line) recastci(rarea) ciopts(lpattern(dot))

margins, at (y_membgood= (-3(1)3) sPSNS=(0.5  0.9)) vsquish
marginsplot, x(y_membgood) recastci(rarea) recast(line)ciopts(lpattern(dot))

margins, dydx (y_membgood) at (sPSNS= (0.484 0.741 0.803 0.862 0.921)) vsquish 
marginsplot, recast(line) recastci(rarea) ciopts(lpattern(dot))

margins, at (partysize_01= (0.4(0.1)1) sPSNS=(0.5  0.9)) vsquish
marginsplot, x(partysize_01) recastci(rarea) recast(line)ciopts(lpattern(dot))

margins, dydx (partysize_01) at (sPSNS= (0.484 0.741 0.803 0.862 0.921)) vsquish 
marginsplot, recast(line) recastci(rarea) ciopts(lpattern(dot))

margins, dydx (party_is_close) at (sPSNS= (0.5 (0.1) 0.9)) vsquish 
marginsplot, recast(line) recastci(rarea) ciopts(lpattern(dot)) 

margins party_is_close,  at (sPSNS=(0.5 (0.1) 0.9)) vsquish
marginsplot, recast(line) recastci(rarea) ciopts(lpattern(dot))
/*

margins, dydx (lrdist01) at (sPSNS= (0.484 0.741 0.804 0.921)) vsquish

margins, at(lrdist01= (0 1) sPSNS=(0.484 0.741 0.804 0.921)) vsquish


marginsplot, x(lrdist01) recast(line) xlabel(0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1) ciopts(lpattern(dot))

marginsplot, x(lrdist01) recast(line)addplot(scatter ptv lrdist01, msym(oh) jitter(1)) xlabel(0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1)

*/

// mlrsq
esttab , se aic bic r2 scalars("cr2 R-squared (BLUPs)") b(3) wide label mtitles replace



//check for multi-collinearity of y-hats
pwcorr y_female y_born y_educ y_unionmemb y_churchatt y_polint y_minority y_married y_unemployed y_worker y_religiosity y_faminc y_membgood, sig

reg ptv  y_born  y_female y_married y_educ y_churchatt y_unemployed y_polint y_faminc y_membgood  ///
partysize_01 party_is_close y_minority lrdist01 y_worker y_religiosity y_unionmemb
estat vif

//Note: a complete random slopes model with all interactions leads to computational problems
//check with separated random slopes models and single interactions
set more off
eststo: xtmixed ptv  y_born  y_female y_married y_educ y_churchatt y_unemployed y_polint y_faminc y_membgood y_minority y_religiosity y_worker y_unionmemb ///
partysize_01 party_is_close c.sPSNS##c.lrdist01  ///
|| cntry: lrdist01, cov(un) || respid: , cov(un)||

eststo: xtmixed ptv  y_born  y_female y_married y_educ y_churchatt y_unemployed y_polint y_faminc y_membgood y_minority y_religiosity lrdist01 y_unionmemb ///
partysize_01 party_is_close c.sPSNS##c.y_worker  ///
|| cntry: y_worker, cov(un) || respid: , cov(un)||

eststo: xtmixed ptv  y_born  y_female y_married y_educ y_churchatt y_unemployed y_polint y_faminc y_membgood y_minority y_religiosity lrdist01 y_worker ///
partysize_01 party_is_close c.sPSNS##c.y_unionmemb  ///
|| cntry: y_unionmemb, cov(un) || respid: , cov(un)||

eststo: xtmixed ptv  y_born  y_female y_married y_educ y_churchatt y_unemployed y_polint y_faminc y_membgood y_religiosity  lrdist01 y_worker y_unionmemb ///
partysize_01 party_is_close c.sPSNS##c.y_minority  ///
|| cntry: y_minority, cov(un) || respid: , cov(un)||

eststo: xtmixed ptv  y_born  y_female y_married y_educ y_churchatt y_unemployed y_polint y_faminc y_membgood y_minority lrdist01 y_worker y_unionmemb  ///
partysize_01 party_is_close c.sPSNS##c.y_religiosity  ///
|| cntry: y_religiosity, cov(un) || respid: , cov(un)||

esttab , se aic bic r2 scalars("cr2 R-squared (BLUPs)") b(3) wide label mtitles replace


margins, dydx (lrdist01) at (sPSNS= (0.5 (0.1) 0.9)) vsquish 
marginsplot, recast(line) recastci(rarea) ciopts(lpattern(dot))


margins, dydx (y_worker) at (sPSNS= (0.5 (0.1) 0.9)) vsquish 
marginsplot, recast(line) recastci(rarea) ciopts(lpattern(dot))


margins, dydx (y_unionmemb) at (sPSNS= (0.5 (0.1) 0.9)) vsquish 
marginsplot, recast(line) recastci(rarea) ciopts(lpattern(dot))


margins, dydx (y_minority) at (sPSNS= (0.5 (0.1) 0.9)) vsquish 
marginsplot, recast(line) recastci(rarea) ciopts(lpattern(dot))


margins, dydx (y_religiosity) at (sPSNS= (0.5 (0.1) 0.9)) vsquish 
marginsplot, recast(line) recastci(rarea) ciopts(lpattern(dot))

//other checks with random slopes models, country random effects plotted against sPSNS

eststo: xtmixed ptv y_born  y_female y_married y_educ y_churchatt y_unemployed y_polint y_faminc y_membgood y_minority y_religiosity lrdist01 y_unionmemb ///
partysize_01 party_is_close sPSNS y_worker  ///
|| cntry: y_unionmemb, cov(un) || respid: , cov(un)||

predict fitptv, fitted level(cntry)
twoway connected fitptv y_unionmember if cntry<=23, connect(L)

predict b*, reffects 
generate slopes = b1 + _b[y_unionmemb] 
generate intercepts = b2 + _b[_cons] 
list cntry slopes
table cntry, contents (mean slopes)
scatter slopes sPSNS, by(cntry, total)
scatter intercepts sPSNS, by(cntry, total)
scatter slopes sPSNS, by(cntry, total style(compact)) 
mean slopes
mean sPSNS
scatter slopes sPSNS, yline(0.6) xline(0.8) by(cntry, total) ytitle(union_slopes)
graph dot (mean) slopes, over(cntry, gap(cntry) sort(slopes)) cw linetype(line) ytitle (Random Slopes Unions)
scatter slopes sPSNS, yline(0.6) xline(0.8) ytitle(union_slopes)
scatter slopes sPSNS, yline(0.6) xline(0.8) mlabel(cntry) ytitle(union_slopes)


eststo: xtmixed ptv y_born  y_female y_married y_educ y_churchatt y_unemployed y_polint y_faminc y_membgood y_minority y_religiosity lrdist01 y_unionmemb ///
partysize_01 party_is_close sPSNS y_worker  ///
|| cntry: y_worker, cov(un) || respid: , cov(un)||

predict c*, reffects 
generate worker_slopes = c1 + _b[y_worker] 
mean worker_slopes
scatter worker_slopes sPSNS, yline(0.5) xline(0.8) by(cntry, total)
graph dot (mean) worker_slopes, over(cntry, gap(cntry) sort(worker_slopes)) cw linetype(line) ytitle (Random Slopes Worker)
scatter worker_slopes sPSNS, yline(0.5) xline(0.8) mlabel(cntry)
