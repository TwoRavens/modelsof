/************************************************************************************************************************************
Conti and Pudney
Survey Design and the Analysis of Satisfaction
Review of Economics and Statistics, 2011
************************************************************************************************************************************/

***FIGURE 2
clear
set mem 100m
use "C:\Users\Gabriella\Documents\Research\Papers\SP_SATIS\SATIS.dta", clear
histogram jbsat if male==0, discrete fraction fcolor(cranberry) yscale(range(0 0.5)) ylabel (0(0.1)0.5) xtitle(Interview measure - females)
graph save Graph "C:\Users\Gabriella\Documents\Research\Papers\SP_SATIS\jbsat_females.gph", replace
histogram lfsat5 if male==0, discrete fraction fcolor(cranberry) yscale(range(0 0.5)) ylabel (0(0.1)0.5) xtitle(SC measure - females)
graph save Graph "C:\Users\Gabriella\Documents\Research\Papers\SP_SATIS\lfsat5_females.gph", replace
histogram jbsat if male==1, discrete fraction fcolor(cranberry) yscale(range(0 0.5)) ylabel (0(0.1)0.5) xtitle(Interview measure - males)
graph save Graph "C:\Users\Gabriella\Documents\Research\Papers\SP_SATIS\jbsat_males.gph", replace
histogram lfsat5 if male==1, discrete fraction fcolor(cranberry) yscale(range(0 0.5)) ylabel (0(0.1)0.5) xtitle(SC measure - males)
graph save Graph "C:\Users\Gabriella\Documents\Research\Papers\SP_SATIS\lfsat5_males.gph", replace
graph combine "C:\Users\Gabriella\Documents\Research\Papers\SP_SATIS\jbsat_males.gph" ///
    "C:\Users\Gabriella\Documents\Research\Papers\SP_SATIS\lfsat5_males.gph" ///
    "C:\Users\Gabriella\Documents\Research\Papers\SP_SATIS\jbsat_females.gph" ///
    "C:\Users\Gabriella\Documents\Research\Papers\SP_SATIS\lfsat5_females.gph"
graph save Graph "C:\Users\Gabriella\Documents\Research\Papers\SP_SATIS\jbsat_lfsat5_males_females_new.gph", replace

