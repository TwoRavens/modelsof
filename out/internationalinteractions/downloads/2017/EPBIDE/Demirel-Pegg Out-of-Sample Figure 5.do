use "E\Demirel-Pegg.dta", clear


*Out-of-Sample Predictions for Critical Event Model* Estimates are in Appendix Table C-3
zinb protcamp weeknum treat weeknumafter repression accommodation if week<tw(1983w25), inflate(weeknum treat weeknumafter repression accommodation)
estat ic
predict p2 if e(sample)==1
***e(sample)==1 is a variable that is hidden so it predicts values for every data point included in the regression (1983w25)
predict p3 if e(sample)==0

*Out-of-Sample for Cooptation Model*
zinb protcamp weeknum accommodation if week<tw(1983w25), inflate(accommodation)
estat ic
predict p4 if e(sample)==1
predict p5 if e(sample)==0

*p3 (CEvent) and p5(Coopt) are out of sample
**AIC and BIC - full model good***

*For Figure 5 in Text* 
twoway (tsline protcamp) (tsline p3) (tsline p5)

*Graph Editor used*
