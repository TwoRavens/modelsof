/* Aggregate Tables.do */
/* This do files creates 5 tables of aggregate estimates */
/* Table 1: Demongraphic Summaries */
/* Table 2: Temporal Stability of Preference Parameters (quasi-hyperbolic discounting)*/
/* Table A1: Temporal Stability of Preference Parameters (hyperbolic discounting)*/
/* Table A2: Exploration of Heterogeneity */
/* Table 4 : Temporal Stability of Preference Parameters, including non-monotones */


log on
/* Table 1 */
/* Summary Table */

local biglist "agitenthou depcount age refund unempdummy male raceBlack collexp raceBlackimputed maleimputed collexpimputed distanceless2 pobox "foreach x of local biglist {qui ttest `x' if  inconsistent == 0 & year==2007 & rownumber ==1 , by(returneesample)scalar mean11 = round(r(mu_1), .01)scalar sd11 = round(r(sd_1), .01)scalar mean12 = round(r(mu_2), .01)scalar sd12 = round(r(sd_2), .01)scalar yearp1 = round(r(p), .001) qui ttest `x' if  inconsistent == 0 & year==2008 & rownumber ==1, by(returneesample)scalar mean21 = round(r(mu_1), .01)scalar sd21 = round(r(sd_1), .01)scalar mean22 = round(r(mu_2), .01)scalar sd22 = round(r(sd_2), .01)qui ttest `x' if inconsistent == 0 & returneesample==0 & rownumber ==1, by(year)scalar yearp2 = round(r(p), .001)display "`x' &"   mean11 "&" mean12  "&" mean21 "&" mean22 "& p = " yearp1 "& p = " yearp2 "\\"display "&"   "(" sd11 ")" "&" "(" sd12 ")" "&" "(" sd21 ")" "&" "(" sd22 ")"  "& & \\"}

log off

/* Table 2: Temporal Stability of Preference Parameters */
global demogsmall "agitenthou depcount age" 
ml model lf ML_quasi (b: choice optionA optionB t k  = year08) (d: year08)  (mu: year08 ) if  inconsistent == 0 , technique(bhhh) clu(uniqid) maximize ml display
test year08
scalar c1 = r(chi2)
scalar p1 = r(p)
est store col1

ml model lf ML_quasi (b: choice optionA optionB t k  = year08 $demogsmall) (d: year08 $demogsmall)  (mu: year08) if inconsistent == 0 , technique(bhhh) clu(uniqid) maximize ml display
test year08
scalar c2 = r(chi2)
scalar p2 = r(p)
est store col2

ml model lf ML_quasi (b: choice optionA optionB t k  = year08) (d: year08)  (mu: year08 ) if  inconsistent == 0 & returneesample == 0  , technique(bhhh) clu(uniqid) maximize ml display
test year08
scalar c3 = r(chi2)
scalar p3 = r(p)
est store col3

ml model lf ML_quasi (b: choice optionA optionB t k  = year08 $demogsmall) (d: year08 $demogsmall)  (mu: year08) if inconsistent == 0 & returneesample == 0 , technique(bhhh) clu(uniqid) maximize ml display
test year08
scalar c4 = r(chi2)
scalar p4 = r(p)
est store col4

ml model lf ML_quasi (b: choice optionA optionB t k  = year08) (d: year08)  (mu: year08 ) if  inconsistent == 0 & returneesample == 1 , technique(bhhh) clu(uniqid) maximize ml display
test year08
scalar c5 = r(chi2)
scalar p5 = r(p)
est store col5

ml model lf ML_quasi (b: choice optionA optionB t k  = year08 $demogsmall) (d: year08 $demogsmall)  (mu: year08) if  inconsistent == 0 & returneesample == 1 , technique(bhhh) clu(uniqid) maximize ml display
test year08
scalar c6 = r(chi2)
scalar p6 = r(p)
est store col6

log on
/* Table 2: Temporal Stability of Preference Parameters */
estout col1 col2 col3 col4 col5 col6, cells(b(star fmt(%7.3f)) se(par) ) starlevels(* .1 ** .05 *** .01) stats(N ll) style(tex) label varlabels(_cons Constant) disp "$\chi^2(3) = " round(c1, .01) "&" "$\chi^2(3) = " round(c2, .01) "&" "$\chi^2(3) = " round(c3, .01) "&" "$\chi^2(3) = " round(c4, .01) "&" "$\chi^2(3) = " round(c5, .01) "&" "$\chi^2(3) = " round(c6, .01) "\\" disp "$(p = " round(p1, .01) ")$&" "$(p = " round(p2, .01) ")$&" "$(p = " round(p3, .01) ")$&" "$(p = " round(p4, .01) ")$&" "$(p = " round(p5, .01) ")$&" "$(p = " round(p6, .01) ")$\\" 
log off



/* Appendix Table A1: Pure Hyperbolic Discounting Model */
ml model lf ML_hyp (a: choice optionA optionB t k  = year08)  (mu: year08 ) if  inconsistent == 0 , technique(bhhh) clu(uniqid) maximize ml display
test year08
scalar c1 = r(chi2)
scalar p1 = r(p)
est store col1ml model lf ML_hyp (a: choice optionA optionB t k  = year08 $demogsmall)  (mu: year08 ) if  inconsistent == 0 , technique(bhhh) clu(uniqid) maximize ml display
test year08
scalar c2 = r(chi2)
scalar p2 = r(p)
est store col2ml model lf ML_hyp (a: choice optionA optionB t k  = year08)  (mu: year08 ) if  inconsistent == 0 & returneesample == 0, technique(bhhh) clu(uniqid) maximize ml display
test year08
scalar c3 = r(chi2)
scalar p3 = r(p)
est store col3ml model lf ML_hyp (a: choice optionA optionB t k  = year08 $demogsmall)  (mu: year08 ) if  inconsistent == 0 & returneesample == 0 , technique(bhhh) clu(uniqid) maximize ml display
test year08
scalar c4 = r(chi2)
scalar p4 = r(p)
est store col4


ml model lf ML_hyp (a: choice optionA optionB t k  = year08)  (mu: year08 ) if inconsistent == 0 & returneesample == 1 , technique(bhhh) clu(uniqid) maximize ml display
test year08
scalar c5 = r(chi2)
scalar p5 = r(p)
est store col5ml model lf ML_hyp (a: choice optionA optionB t k  = year08 $demogsmall)  (mu: year08 ) if  inconsistent == 0 & returneesample == 1, technique(bhhh) clu(uniqid) maximize ml display
test year08
scalar c6 = r(chi2)
scalar p6 = r(p)
est store col6log on
/* Table A1: Hyperbolic Discounting Parameters*/
estout col1 col2 col3 col4 col5 col6, cells(b(star fmt(%7.3f)) se(par) ) starlevels(* .1 ** .05 *** .01) stats(N ll) style(tex) label varlabels(_cons Constant) disp "$\chi^2(3) = " round(c1, .01) "&" "$\chi^2(3) = " round(c2, .01) "&" "$\chi^2(3) = " round(c3, .01) "&" "$\chi^2(3) = " round(c4, .01) "&" "$\chi^2(3) = " round(c5, .01) "&" "$\chi^2(3) = " round(c6, .01) "\\" disp "$(p = " round(p1, .01) ")$&" "$(p = " round(p2, .01) ")$&" "$(p = " round(p3, .01) ")$&" "$(p = " round(p4, .01) ")$&" "$(p = " round(p5, .01) ")$&" "$(p = " round(p6, .01) ")$\\" 
log off

/*Table A2: Quas-Hyperbolic Discounting Investigation of Censoring, Exploration of Heterogeneity*/
capture drop meanchoiceegen meanchoice = mean(choice), by(uniqid)

ml model lf ML_quasi (b: choice optionA optionB t k  = year08) (d: year08)  (mu: year08 ) if  inconsistent == 0 , technique(bhhh) clu(uniqid) maximize ml display
test year08
scalar c1 = r(chi2)
scalar p1 = r(p)
est store col1


ml model lf ML_quasi (b: choicex optionAx optionB t k  = year08) (d: year08)  (mu: year08 ) if inconsistent == 0 , technique(bhhh) clu(uniqid) maximize ml display
test year08
scalar c2 = r(chi2)
scalar p2 = r(p)
est store col2


ml model lf ML_quasi (b: choice optionA optionB t k  = year08) (d: year08)  (mu: year08 ) if  inconsistent == 0 & meanchoice != 0 & meanchoice != 1 , technique(bhhh) clu(uniqid) maximize difficult init(0.762 0 0.962 0 0.17 0.02, copy) iter(50)ml display
test year08
scalar c3 = r(chi2)
scalar p3 = r(p)
est store col3

log on
/*Table A2: Exploration of Heterogeneity */
estout col1 col2 col3, cells(b(star fmt(%7.3f)) se(par) ) starlevels(* .1 ** .05 *** .01) stats(N ll) style(tex) label varlabels(_cons Constant) disp "$\chi^2(3) = " round(c1, .01) "&" "$\chi^2(3) = " round(c2, .01) "&" "$\chi^2(3) = " round(c3, .01) "\\" disp "$(p = " round(p1, .01) ")$&" "$(p = " round(p2, .01) ")$&" "$(p = " round(p3, .01) ")$\\" 
log off



/* Robustness Table 4 */
/* Table 4 : Temporal Stability of Preference Parameters, including non-monotones */
global demogsmall "agitenthou depcount age" 
ml model lf ML_quasi (b: choice optionA optionB t k  = year08) (d: year08)  (mu: year08 ) , technique(bhhh) clu(uniqid) maximize ml display
test year08
scalar c1 = r(chi2)
scalar p1 = r(p)
est store col1

ml model lf ML_quasi (b: choice optionA optionB t k  = year08 $demogsmall) (d: year08 $demogsmall)  (mu: year08)  , technique(bhhh) clu(uniqid) maximize ml display
test year08
scalar c2 = r(chi2)
scalar p2 = r(p)
est store col2

ml model lf ML_quasi (b: choice optionA optionB t k  = year08) (d: year08)  (mu: year08 ) if   !(postgroup == 1 | lagpostgroup == 1)  , technique(bhhh) clu(uniqid) maximize ml display
test year08
scalar c3 = r(chi2)
scalar p3 = r(p)
est store col3

ml model lf ML_quasi (b: choice optionA optionB t k  = year08 $demogsmall) (d: year08 $demogsmall)  (mu: year08) if  !(postgroup == 1 | lagpostgroup == 1) , technique(bhhh) clu(uniqid) maximize ml display
test year08
scalar c4 = r(chi2)
scalar p4 = r(p)
est store col4

ml model lf ML_quasi (b: choice optionA optionB t k  = year08) (d: year08)  (mu: year08 ) if  (postgroup == 1 | lagpostgroup == 1) , technique(bhhh) clu(uniqid) maximize ml display
test year08
scalar c5 = r(chi2)
scalar p5 = r(p)
est store col5

ml model lf ML_quasi (b: choice optionA optionB t k  = year08 $demogsmall) (d: year08 $demogsmall)  (mu: year08) if  (postgroup == 1 | lagpostgroup == 1) , technique(bhhh) clu(uniqid) maximize ml display
test year08
scalar c6 = r(chi2)
scalar p6 = r(p)
est store col6

log on
/* Table 4 : Temporal Stability of Preference Parameters, including non-monotones */
estout col1 col2 col3 col4 col5 col6, cells(b(star fmt(%7.3f)) se(par) ) starlevels(* .1 ** .05 *** .01) stats(N ll) style(tex) label varlabels(_cons Constant) disp "$\chi^2(3) = " round(c1, .01) "&" "$\chi^2(3) = " round(c2, .01) "&" "$\chi^2(3) = " round(c3, .01) "&" "$\chi^2(3) = " round(c4, .01) "&" "$\chi^2(3) = " round(c5, .01) "&" "$\chi^2(3) = " round(c6, .01) "\\" disp "$(p = " round(p1, .01) ")$&" "$(p = " round(p2, .01) ")$&" "$(p = " round(p3, .01) ")$&" "$(p = " round(p4, .01) ")$&" "$(p = " round(p5, .01) ")$&" "$(p = " round(p6, .01) ")$\\" 
log off
