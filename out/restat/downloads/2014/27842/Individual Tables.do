/* Individual Tables.do */
/* This do file has two parts */
/* Part 1 */
/* Part 1 constructs individual estimates following the method outlined in section 3.3 */
/* Individual estimates of quasi-hyperbolic discounting parameters are created for each subject */
/* Two estimates are created for each individual in the returnee sample and changes are calculated */
/* Individual estimates of exponential discounting parameters are created for each subject  */
/* Two estimates are created for each individual in the returnee sample and changes are calculated*/
/* Part 2 */
/* Part 2 creates 3 tables of individual estimates */
/* Table 3: Correlates of Instability */
/* Appendix Table A3: Extended Correlates of Instability */
/* Table 5: Selection: Returning and Participating */

/*** Individual Estimates ***/
/* Individual Discounting Calculations */
capture drop logratiomid
gen logratiomid = log(xmid/50)

capture drop laglogratiomid
gen laglogratiomid = log(lagxmid/50)

capture drop t0
gen t0 = (t==0)


/* Calculation of Quasi-Hyperbolic Discounting Parameters */
capture drop betai
capture drop deltai
gen deltai = .
gen betai = .


forvalues i = 1(1)1684 {
qui reg logratiomid t0 k if uniqid == `i', nocons 
qui nlcom (beta: exp(_b[t0])) (delta: exp(_b[k])), post
qui capture replace betai = _b[beta] if uniqid == `i'
qui capture replace deltai = _b[delta] if uniqid == `i'
}

/* Calculation of Lagged Quasi-Hyperbolic Discounting Parameters for Returnee Sample */
capture drop lagbetai
capture drop lagdeltai
gen lagdeltai = .
gen lagbetai = .

forvalues i = 1(1)1684 {
qui capture reg laglogratiomid t0 k if uniqid == `i' & returneesample==1, nocons 
qui capture nlcom (beta: exp(_b[t0])) (delta: exp(_b[k])), post
qui capture replace lagbetai = _b[beta] if uniqid == `i'  & returneesample==1
qui capture replace lagdeltai = _b[delta] if uniqid == `i'  & returneesample==1
}



/* Calculation of Exponential Discounting Parameters */
capture drop deltai2
gen deltai2 = .


forvalues i = 1(1)1684 {
qui reg logratiomid k if uniqid == `i', nocons 
qui nlcom (delta: exp(_b[k])), post
qui capture replace deltai2 = _b[delta] if uniqid == `i'
}

capture drop lagdeltai2
gen lagdeltai2 = .

/* Calculation of Lagged Exponential Discounting Parameters for Returnee Sample */
forvalues i = 1(1)1684 {
qui capture reg laglogratiomid k if uniqid == `i' & returneesample==1, nocons 
qui capture nlcom  (delta: exp(_b[k])), post
qui capture replace lagdeltai2 = _b[delta] if uniqid == `i'  & returneesample==1
}



/***** Define Changes *****/
/* At the Parameter Level */
capture drop difbetai
gen difbetai = betai-lagbetai

capture drop absdifbetai
gen absdifbetai = abs(difbetai)

capture drop difbetaidum
gen difbetaidum = (difbetai != 0)
replace difbetaidum = . if difbetai ==.

capture drop difdeltai
gen difdeltai = deltai-lagdeltai

capture drop absdifdeltai
gen absdifdeltai = abs(difdeltai)

capture drop difdeltaidum
gen difdeltaidum = (difdeltai != 0)
replace difdeltaidum = . if difdeltai ==.

capture drop difdeltai2
gen difdeltai2 = deltai2-lagdeltai2

/* At the Choice Level */
capture drop difchoice
gen difchoice = choice - lagchoice
replace difchoice = . if choice == . | lagchoice == .

capture drop absdifchoice
gen absdifchoice = abs(difchoice)

capture drop difchoicedum
gen difchoicedum = (difchoice != 0)
replace difchoicedum = . if difchoice == .

/* At the Choice Set Level */
capture drop diftotalchoice
gen diftotalchoice = totalchoice - totallagchoice
replace diftotalchoice = . if totalchoice == . | totallagchoice == .

capture drop absdiftotalchoice
gen absdiftotalchoice = abs(diftotalchoice)

capture drop diftotalchoicedum
gen diftotalchoicedum = (diftotalchoice != 0)
replace diftotalchoicedum = . if diftotalchoice ==.




/* Define Control Variables */
global demogbig "agitenthou agitenthousq refundtenthou unempdummy depcount age agesq male raceBlack collexp maleimputed raceBlackimputed collexpimputed " 
global difs "deltaagi deltarefund deltaunempdummy deltadepcount"
global absdifs "absdeltaagi absdeltarefund absdeltaunempdummy absdeltadepcount "




/* Table 3 */
/* Correlates of Instability */

xi: reg difchoice  $demogbig  i.t*i.k if  returneesample ==1, clu(uniqid)
est store col1

xi: reg difchoice  $difs $demogbig  i.t*i.k if  returneesample ==1, clu(uniqid)
est store col2


xi: reg diftotalchoice  $demogbig  i.t*i.k if (rownumber == 1 | rownumber ==8 | rownumber ==15) & returneesample ==1, clu(uniqid)
est store col3

xi: reg diftotalchoice  $difs $demogbig  i.t*i.k if (rownumber == 1 | rownumber ==8 | rownumber ==15) & returneesample ==1, clu(uniqid)
est store col4

reg difbetai  $demogbig  if returneesample == 1 & rownumber ==1, r
est store col5

reg difbetai  $difs $demogbig  if returneesample == 1 & rownumber ==1, r
est store col6

reg difdeltai  $demogbig  if returneesample == 1 & rownumber ==1, r
est store col7

reg difdeltai $difs $demogbig  if returneesample == 1 & rownumber ==1, r
est store col8 

log on
/* Table 3 */
/* Correlates of Instability */
estout col1 col2 col3 col4 col5 col6 col7 col8, cells(b(star fmt(%7.3f)) se(par) ) starlevels(* .1 ** .05 *** .01)   stats(N r2) style(tex) label varlabels(_cons Constant) 
log off



/* Appendix Table A3 */
/* Extended Correlates of Instability */
/* Panel A: Absolute Differences */
xi: reg absdifchoice  $demogbig  i.t*i.k if  returneesample ==1, clu(uniqid)
est store col1

xi: reg absdifchoice  $difs $demogbig  i.t*i.k if  returneesample ==1, clu(uniqid)
est store col2


xi: reg absdiftotalchoice  $demogbig  i.t*i.k if (rownumber == 1 | rownumber ==8 | rownumber ==15) & returneesample ==1, clu(uniqid)
est store col3

xi: reg absdiftotalchoice  $difs $demogbig  i.t*i.k if (rownumber == 1 | rownumber ==8 | rownumber ==15) & returneesample ==1, clu(uniqid)
est store col4


reg absdifbetai  $demogbig  if returneesample == 1 & rownumber ==1, r
est store col5

reg absdifbetai $difs $demogbig  if returneesample == 1 & rownumber ==1, r
est store col6

reg absdifdeltai  $demogbig  if returneesample == 1 & rownumber ==1, r
est store col7

reg absdifdeltai $difs $demogbig  if returneesample == 1 & rownumber ==1, r
est store col8 

log on 
/* Appendix Table A3 */
/* Extended Correlates of Instability */
/* Panel A: Absolute Differences */
estout col1 col2 col3 col4 col5 col6 col7 col8, cells(b(star fmt(%7.3f)) se(par) ) starlevels(* .1 ** .05 *** .01)   stats(N r2) style(tex) label varlabels(_cons Constant) 
log off



/* Appendix Table A3 */
/* Extended Correlates of Instability */
/* Panel B: Difference Dummy */
xi: reg difchoicedum  $demogbig  i.t*i.k if  returneesample ==1, clu(uniqid)
est store col1

xi: reg difchoicedum  $difs $demogbig  i.t*i.k if  returneesample ==1, clu(uniqid)
est store col2


xi: reg diftotalchoicedum  $demogbig  i.t*i.k if (rownumber == 1 | rownumber ==8 | rownumber ==15) & returneesample ==1, clu(uniqid)
est store col3

xi: reg diftotalchoicedum  $difs $demogbig  i.t*i.k if (rownumber == 1 | rownumber ==8 | rownumber ==15) & returneesample ==1, clu(uniqid)
est store col4

reg difbetaidum  $demogbig  if returneesample == 1 & rownumber ==1, r
est store col5

reg difbetaidum  $difs $demogbig  if returneesample == 1 & rownumber ==1, r
est store col6

reg difdeltaidum  $demogbig  if returneesample == 1 & rownumber ==1, r
est store col7

reg difdeltaidum $difs $demogbig  if returneesample == 1 & rownumber ==1, r
est store col8 

log on
/* Appendix Table A3 */
/* Extended Correlates of Instability */
/* Panel B: Difference Dummy */
estout col1 col2 col3 col4 col5 col6 col7 col8, cells(b(star fmt(%7.3f)) se(par) ) starlevels(* .1 ** .05 *** .01)   stats(N r2) style(tex) label varlabels(_cons Constant) 
log off









/* Table 5: Attrition */
capture drop returnpart
gen returnpart = (postgroup ==1)
replace returnpart = . if postgroup == .

capture drop returnpartno
gen returnpartno = (postgroup ==2)
replace returnpartno = . if postgroup == .

capture drop return 
gen return = (postgroup ==1 | postgroup ==2 | postgroup ==3)
replace return = . if postgroup == .

capture drop returnrox
gen returnrox = (postgroup ==1 | postgroup ==2)
replace returnrox = . if postgroup == .


capture drop noreturnother
gen noreturnother = (postgroup ==3)
replace noreturnother = . if postgroup == .

capture drop noreturn
gen noreturn = (postgroup ==4)
replace noreturn = . if postgroup == .


probit returnrox $demogbig   distanceless2 pobox if rownumber ==1,r 
est store col1

probit returnrox $demogbig  distanceless2 pobox deltai betai inconsistent if rownumber ==1 ,r
test deltai betai inconsistent 
scalar c2 = r(F)
scalar p2 = r(p)
est store col2

probit returnpart $demogbig   distanceless2 pobox if rownumber ==1  & returnrox ==1,r
est store col3

probit returnpart $demogbig   distanceless2 pobox deltai betai inconsistent if rownumber ==1  & returnrox ==1,r
test deltai betai inconsistent 
scalar c4 = r(F)
scalar p4 = r(p)
est store col4

log on
/* Table 5: Selection: Returning and Participating */
estout col1 col2 col3 col4, cells(b(star fmt(%7.3f)) se(par) ) starlevels(* .1 ** .05 *** .01) stats(N r2) style(tex) label varlabels(_cons Constant) 
log off

