*************************************************
**********	Graphics	*************************
*************************************************

*********	Figure 1	**********************
twoway (lfit bailout modifiable,scheme(s1mono) xlabel(0 .2 .4 .6 .8 1)) (scatter bailout modifiable,mlabel(group) xtitle("Modifiable Revenues") ytitle("Moody's Bailout Probabilities") mlabel(group) mlabvpos(clock) legend(off))
