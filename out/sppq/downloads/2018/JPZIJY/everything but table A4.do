
* All code run in Stata/SE 15.1 for Windows (64-bit x86-64)

* Set your working directory.
* cd ""

* Open "everything but table A4.dta" and then run this.
use "everything but table A4.dta", clear



* To make figures have the same format as in the paper, uncomment the next couple commands.
* set our scheme. Without option "permanently, this is only for this session.
* set scheme s2mono 
* this is permanent. To undo it, run this: graph set window fontface default
* graph set window fontface "Times New Roman"

* The logged version of the variables are already in the data file. For reference though:
* gen const_age_ln = ln( const_age + 1 )
* gen const_length_ln = ln( const_length + 1 )
* gen new_adopted_ln = ln( new_adopted + 1 )

* Also in the data set, but for reference: This is needed in one of the charts (to make the log scale work, since log of zero is undefined).
* gen new_adopted_inc = new_adopted + 1


* ********* MAIN MANUSCRIPT
* Commands appear in the order referenced in the manuscript. Thus, table 1, then figure 1, then table 2. Statistics refererences only in text (without a table/figure) are also addressed below.

* Descriptive statistics about ideological distance between branches given on page 13
sum ideo_distance, d
* Descriptive statistics about state supreme court caseloads given on page 14
sum totalcases, d

* Table 1
reg stcdc new_adopted_ln const_length_ln const_age_ln
ivregress 2sls stcdc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit )
ivregress liml stcdc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit )
ivpoisson gmm stcdc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit ), multiplicative
ivpoisson gmm stcdc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit ) judges_partisan totalcases ideo_distance sessionlength_total, multiplicative

* The text's discussion on page 17 of model (1b) from Table 1 gives several predicted values.
ivregress 2sls stcdc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit )
* identify the 25th and 75th percentiles of independent variables:
sum const_length const_length_ln const_age const_age_ln new_adopted new_adopted_ln, d
* baseline:
di _b[const_age_ln]*4.672829 + _b[const_length_ln]*10.02131 + _b[new_adopted_ln]*1.609438 + _b[_cons]
* move const length from 25th to 75th percentile, with other values at median:
di _b[const_age_ln]*4.672829 + _b[const_length_ln]*9.590863 + _b[new_adopted_ln]*1.609438 + _b[_cons]
di _b[const_age_ln]*4.672829 + _b[const_length_ln]*10.35936 + _b[new_adopted_ln]*1.609438 + _b[_cons]
* move amendments:
di _b[const_age_ln]*4.672829 + _b[const_length_ln]*10.02131 + _b[new_adopted_ln]*1.098612 + _b[_cons]
di _b[const_age_ln]*4.672829 + _b[const_length_ln]*10.02131 + _b[new_adopted_ln]*2.197225 + _b[_cons]
* move const age:
di _b[const_age_ln]*3.637586 + _b[const_length_ln]*10.02131 + _b[new_adopted_ln]*1.609438 + _b[_cons]
di _b[const_age_ln]*4.867535 + _b[const_length_ln]*10.02131 + _b[new_adopted_ln]*1.609438 + _b[_cons]

* Discussion on page 18 of model (1b) from table 1 gives several statistics evaluating the instrumental model, based primarily on the following code:
ivregress 2sls stcdc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit )
* Durbin and Wu-Hausman tests:
estat endogenous
* Sargan and Basmann tests:
estat overid
* adj R2 and partial F statistic for first stage ("partial F" means for the 3 "pure" instruments only):
estat firststage
* F statistic for the complete first stage model:
quietly reg new_adopted_ln const_length_ln const_age_ln complexity totalsize leg_limit
di e(F)

* The text references (page 19) two instrumental tobit models that give similar results to those reported in table 1. These are they:
* conditional maximum-likelihood tobit:
ivtobit stcdc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit ), ll(0) mle
* Newey's minimum chi-squared two-step estimator:
ivtobit stcdc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit ), ll(0) twostep


* Figure 1. Plot only from 10th to 90th percentile on each independent variable.
ivpoisson gmm stcdc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit ), multiplicative
gen L_age_pois = exp( _b[_cons] + _b[const_age_ln]*const_age_ln + _b[const_length_ln]*10.02131 + _b[new_adopted_ln]*1.609438 )
gen L_length_pois = exp( _b[_cons] + _b[const_age_ln]*4.672829 + _b[const_length_ln]*const_length_ln + _b[new_adopted_ln]*1.609438 )
gen L_amend_pois = exp( _b[_cons] + _b[const_age_ln]*4.672829 + _b[const_length_ln]*10.02131 + _b[new_adopted_ln]*new_adopted_ln )
ivpoisson gmm stcdc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit ) judges_partisan totalcases ideo_distance sessionlength_total, multiplicative
gen L_age_pois_cont = exp( _b[_cons] + _b[const_age_ln]*const_age_ln + _b[const_length_ln]*10.02131 + _b[new_adopted_ln]*1.609438 +_b[judges_partisan]*0 + _b[totalcases]*558 + _b[ideo_distance]*0.52 + _b[sessionlength_total]*118.2143 )
gen L_length_pois_cont = exp( _b[_cons] + _b[const_age_ln]*4.672829 + _b[const_length_ln]*const_length_ln + _b[new_adopted_ln]*1.609438 +_b[judges_partisan]*0 + _b[totalcases]*558 + _b[ideo_distance]*0.52 + _b[sessionlength_total]*118.2143 )
gen L_amend_pois_cont = exp( _b[_cons] + _b[const_age_ln]*4.672829 + _b[const_length_ln]*10.02131 + _b[new_adopted_ln]*new_adopted_ln +_b[judges_partisan]*0 + _b[totalcases]*558 + _b[ideo_distance]*0.52 + _b[sessionlength_total]*118.2143 )
gen L_ideo_pois_cont = exp( _b[_cons] + _b[const_age_ln]*4.672829 + _b[const_length_ln]*10.02131 + _b[new_adopted_ln]*1.609438 +_b[judges_partisan]*0 + _b[totalcases]*558 + _b[ideo_distance]*ideo_distance + _b[sessionlength_total]*118.2143 )
graph twoway ( connect L_age_pois const_age, sort msymbol(none) lpattern(solid) ) ( connect L_age_pois_cont const_age, sort msymbol(none) lpattern(shortdash) ) if const_age >= 25 & const_age <= 148, ytitle( "Predicted invalidations" ) scheme( s2mono ) graphregion( fcolor( white ) )  xtitle( "Constitution age in 1996" ) yscale( r( 0 26 ) ) ylabel( 0(5)25 ) xlabel(25(25)150) legend( order( 1 "Model 1d" 2 "Model 1e" ) col(2) size(vsmall) ) graphregion( fcolor( white ) lcolor( white ) ) name(L_age_pois, replace)
graph twoway ( connect L_length_pois const_length, sort msymbol(none) lpattern(solid) ) ( connect L_length_pois_cont const_length, sort msymbol(none) lpattern(shortdash) ) if const_length >=10411 & const_length <=51701, ytitle( "Predicted invalidations" ) scheme( s2mono ) graphregion( fcolor( white ) )  xtitle( "Constitution length, 1994-97" ) yscale( r( 0 26 ) ) ylabel( 0(5)25 ) legend( order( 1 "Model 1d" 2 "Model 1e" ) col(2) size(vsmall) ) graphregion( fcolor( white ) lcolor( white ) ) name(L_length_pois, replace)
graph twoway ( connect L_amend_pois new_adopted, sort msymbol(none) lpattern(solid) ) ( connect L_amend_pois_cont new_adopted, sort msymbol(none) lpattern(shortdash) ) if e(sample) & new_adopted >= 1 & new_adopted <=11, ytitle( "Predicted invalidations" ) scheme( s2mono ) graphregion( fcolor( white ) )  xtitle( "Amendments, 1994-97" ) yscale( r( 0 26 ) ) ylabel( 0(5)25 ) xlabel(0(2)12) legend( order( 1 "Model 1d" 2 "Model 1e" ) col(2) size(vsmall) ) graphregion( fcolor( white ) lcolor( white ) ) name(L_amend_pois, replace)
graph twoway ( connect L_ideo_pois_cont ideo_distance, sort msymbol(none) lpattern(shortdash) ) if ideo_distance >= 0.1824 & ideo_distance <= 1.087, ytitle( "Predicted invalidations" ) scheme( s2mono ) graphregion( fcolor( white ) )  xtitle( "Mean ideological distance" ) yscale( r( 0 26 ) ) ylabel( 0(5)25 ) xlabel(0(0.2)1.2) legend( order( 1 "With controls (1e)" ) col(2) ) graphregion( fcolor( white ) lcolor( white ) ) name(L_ideo_pois, replace)
* The preceding code should have created the 4 constituent parts of Figure 1. To combine it all together, uncomment and run the following line, which requires you to first download and install the "graph combine one legend" package, grc1leg (nb: that's "gee are see one ell ee gee").
* grc1leg L_amend_pois L_length_pois L_age_pois L_ideo_pois, col(2) graphregion( fcolor( white ) lcolor( white ) )
drop L*


* Desciptive statistics on page 20 comparing the two dependent variables:
sum stc stcdc, d
* And the correlation on page 20, footnote 20:
pwcorr stc stcdc, sig

* Table 2
reg stc new_adopted_ln const_length_ln const_age_ln
ivregress 2sls stc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit )
ivregress liml stc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit )
ivpoisson gmm stc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit ), multiplicative
ivpoisson gmm stc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit ) judges_partisan totalcases ideo_distance sessionlength_total, multiplicative






* ********* SUPPLEMENT

* Figure A1
reg stcdc const_length_ln
gen L = _b[_cons] + _b[const_length_ln]*const_length_ln
graph twoway (connect L const_length, sort msymbol(none)) (scatter stcdc const_length, msymbol(none) mlabel(stateab) mlabpos(0) ), xtitle( "Constitution length, 1994-97 (log scale)" ) ytitle( "Invalidations, 1995-98" ) legend( off ) scheme( s2mono ) graphregion( fcolor( white ) )  xscale(log) xlabel(5000 10000 20000 40000 80000)
drop L

* Figure A2
reg stcdc new_adopted_ln
gen L = _b[_cons] + _b[new_adopted_ln]*new_adopted_ln
graph twoway (connect L new_adopted_inc, sort msymbol(none)) (scatter stcdc new_adopted_inc, msymbol(none) mlabel(stateab) mlabpos(0) ), xtitle( "Amendments, 1994-97 (incremented log scale)" ) ytitle( "Invalidations, 1995-98" ) legend( off ) scheme( s2mono ) graphregion( fcolor( white ) )  xscale(log) xlabel( 1 2 4 8 16 32 )
drop L

* Figure A3
reg stcdc const_age_ln
gen L = _b[_cons] + _b[const_age_ln]*const_age_ln
graph twoway (connect L const_age, sort msymbol(none)) (scatter stcdc const_age, msymbol(none) mlabel(stateab) mlabpos(0) ), xtitle( "Constitution age in 1996 (log scale)" ) ytitle( "Invalidations, 1995-98" ) legend( off ) scheme( s2mono ) graphregion( fcolor( white ) )  xscale(log) xlabel( 7.5 15 30 60 120 240 )
drop L

* Figure A4
reg stcdc ideo_distance
gen L = _b[_cons] + _b[ideo_distance]*ideo_distance
graph twoway (connect L ideo_distance, sort msymbol(none)) (scatter stcdc ideo_distance, msymbol(none) mlabel(stateab) mlabpos(0) ), xtitle( "Average ideological distance, 1995-98" ) ytitle( "Invalidations, 1995-98" ) legend( off ) scheme( s2mono ) graphregion( fcolor( white ) )
drop L

* Table A1
pwcorr stcdc new_adopted_ln const_length_ln const_age_ln judges_partisan totalcases ideo_distance sessionlength_total, sig

* Table A2
reg stcdc new_adopted_ln const_length_ln const_age_ln judges_partisan totalcases ideo_distance sessionlength_total
ivregress 2sls stcdc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit ) judges_partisan totalcases ideo_distance sessionlength_total
ivregress liml stcdc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit ) judges_partisan totalcases ideo_distance sessionlength_total
ivpoisson gmm stcdc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit ) judges_partisan totalcases ideo_distance sessionlength_total, multiplicative

* Table A3
reg stc new_adopted_ln const_length_ln const_age_ln judges_partisan totalcases ideo_distance sessionlength_total
ivregress 2sls stc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit ) judges_partisan totalcases ideo_distance sessionlength_total
ivregress liml stc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit ) judges_partisan totalcases ideo_distance sessionlength_total
ivpoisson gmm stc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit ) judges_partisan totalcases ideo_distance sessionlength_total, multiplicative

* Table A4 is addressed in a separate code file.

* Table A5
ivpoisson gmm uscdc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit ), multiplicative
ivpoisson gmm usc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit ), multiplicative
ivpoisson gmm uscdc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit ) stcdc, multiplicative
ivpoisson gmm usc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit ) stc, multiplicative

* Correlations in the supplement in discussion of Table A5:
pwcorr stcdc uscdc, sig
pwcorr stc usc, sig

* Table A6
ivpoisson gmm stcdc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit ), multiplicative
ivpoisson gmm stc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit ), multiplicative
ivpoisson gmm stcdc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit ) uscdc, multiplicative
ivpoisson gmm stc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit ) usc, multiplicative
