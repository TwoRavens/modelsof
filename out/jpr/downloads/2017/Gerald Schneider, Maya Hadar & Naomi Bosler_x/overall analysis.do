*****/Table II (main document)
*****/dan hotels and imco stocks 14 day model 

use "CARs.dta"

**/Dan Hotels
nbreg num_events_14 danhotels_3
nbreg num_events_14 danhotels_5

**/Imco Industries
nbreg num_events_14 imco_3
nbreg num_events_14 imco_5

****/Newspapers Analysis, 14 days model 

use "data.dta"

****/NEW YORK TIMES 
nbreg num_events_14 nyt_sf

****/JERUSALEM POST
nbreg num_events_14 jp_sf

****/HAARETZ 
nbreg num_events_14 haaretz_sf

****/BAR (main text)

use "dataforbar14_3.dta"
graph bar Accuracy1 Accuracy2 Recall Precision, over (predictor, sort(n) label(labsize(2.5)angle(45)))


****/BAR (Figure A2-1 appendix)

use "dataforbar7_5.dta"
graph bar Accuracy1 Accuracy2 Recall Precision, over (predictor, sort(n) label(labsize(2.5)angle(45)))


*****/dan hotels and imco stocks 7 day model (Table A2-I + II appendix)
*****/both event windows (3 and 5)

use "CARs.dta"

**/Dan Hotels
nbreg num_events_7 danhotels_3, vce (robust)
nbreg num_events_7 danhotels_3
nbreg num_events_7 danhotels_5, vce (robust)
nbreg num_events_7 danhotels_5

**/Imco Industries
nbreg num_events_7 imco_3, vce (robust)
nbreg num_events_7 imco_3
nbreg num_events_7 imco_5, vce (robust)
nbreg num_events_7 imco_5

use "data.dta"

****/NEW YORK TIMES 
nbreg num_events_7 nyt_sf, vce (robust)
nbreg num_events_7 nyt_sf

****/JERUSALEM POST
nbreg num_events_7 jp_sf, vce (robust)
nbreg num_events_7 jp_sf

****/HAARETZ 
nbreg num_events_7 haaretz_sf, vce (robust)
nbreg num_events_7 haaretz_sf

****/Table A3: appendix

use "CARs.dta"

**/Dan Hotels
nbreg num_events_14 danhotels_3, vce (robust)
nbreg num_events_14 danhotels_5, vce (robust)

**/Imco Industries
nbreg num_events_14 imco_3, vce (robust)
nbreg num_events_14 imco_5, vce (robust)

use "data.dta"

****/NEW YORK TIMES 
nbreg num_events_14 nyt_sf, vce (robust)

****/JERUSALEM POST
nbreg num_events_14 jp_sf, vce (robust)

****/HAARETZ 
nbreg num_events_14 haaretz_sf, vce (robust)

****/Table A4: OLS appendix 14 days

use "CARs.dta"

**/Dan Hotels
reg num_events_14 danhotels_3
reg num_events_14 danhotels_5

**/Imco Industries
reg num_events_14 imco_3
reg num_events_14 imco_5

**/Dan Hotels
reg num_events_14 danhotels_3 pre_14 
reg num_events_14 danhotels_5 pre_14 


**/Imco Industries
reg num_events_14 imco_3
reg num_events_14 imco_5


****/Table A5: OLS appendix 7 days

use "CARs.dta"

**/Dan Hotels
reg num_events_7 danhotels_3
reg num_events_7 danhotels_5


**/Imco Industries
reg num_events_7 imco_3
reg num_events_7 imco_5


use "data.dta"

****/NEW YORK TIMES 
reg num_events_7 nyt_sf


****/JERUSALEM POST
reg num_events_7 jp_sf


****/HAARETZ 
reg num_events_7 haaretz_sf



****/ROC analysis (appendix)

use "CARs.dta"

****/ROC analysis Danhotels both models
roctab success14 danhotels_3, graph ytitle("True positive rate", size(3)) xtitle("False positive rate", size(3)) ylabel(0(0.25)1, labsize(small) nogrid) xlabel(0(0.25)1, labsize(small) nogrid) scheme(s1mono) ysize(4) xsize(4) mcolor(gs2) msize(medsmall) rlopts(lpattern(dash))
roctab success14 danhotels_5, graph ytitle("True positive rate", size(3)) xtitle("False positive rate", size(3)) ylabel(0(0.25)1, labsize(small) nogrid) xlabel(0(0.25)1, labsize(small) nogrid) scheme(s1mono) ysize(4) xsize(4) mcolor(gs2) msize(medsmall) rlopts(lpattern(dash))

****/ROC analysis Imco both models
gen invimco_3=imco_3*-1 
gen invimco_5=imco_5*-1 
roctab success14 invimco_3, graph ytitle("True positive rate", size(3)) xtitle("False positive rate", size(3)) ylabel(0(0.25)1, labsize(small) nogrid) xlabel(0(0.25)1, labsize(small) nogrid) scheme(s1mono) ysize(4) xsize(4) mcolor(gs2) msize(medsmall) rlopts(lpattern(dash))
roctab success14 invimco_5, graph ytitle("True positive rate", size(3)) xtitle("False positive rate", size(3)) ylabel(0(0.25)1, labsize(small) nogrid) xlabel(0(0.25)1, labsize(small) nogrid) scheme(s1mono) ysize(4) xsize(4) mcolor(gs2) msize(medsmall) rlopts(lpattern(dash))

****/ROC analysis Newspapers
roctab success14 nyt_num, graph ytitle("True positive rate", size(3)) xtitle("False positive rate", size(3)) ylabel(0(0.25)1, labsize(small) nogrid) xlabel(0(0.25)1, labsize(small) nogrid) scheme(s1mono) ysize(4) xsize(4) mcolor(gs2) msize(medsmall) rlopts(lpattern(dash))
roctab success14 jp_num, graph ytitle("True positive rate", size(3)) xtitle("False positive rate", size(3)) ylabel(0(0.25)1, labsize(small) nogrid) xlabel(0(0.25)1, labsize(small) nogrid) scheme(s1mono) ysize(4) xsize(4) mcolor(gs2) msize(medsmall) rlopts(lpattern(dash))
roctab success14 haaretz_num, graph ytitle("True positive rate", size(3)) xtitle("False positive rate", size(3)) ylabel(0(0.25)1, labsize(small) nogrid) xlabel(0(0.25)1, labsize(small) nogrid) scheme(s1mono) ysize(4) xsize(4) mcolor(gs2) msize(medsmall) rlopts(lpattern(dash))



*****/Table A6: Brier's scores calculated for the 10 and 14 violent events thresholds (appendix)

***Dan hotels 3 days time window
logit success14 danhotels_3
predict dan14
brier success14 dan14

logit success10 danhotels_3
predict dan10
brier success10 dan10

***Dan hotels 5 days time window
logit success14 danhotels_5
predict dan14_5
brier success14 dan14_5

logit success10 danhotels_5
predict dan10_5
brier success10 dan10_5

***Dan hotels 3 days time window
logit success14 imco_3
predict imco14_3
brier success14 imco14_3

logit success10 imco_3
predict imco10_3
brier success10 imco10_3

***imco 5 days time window
logit success14 imco_5
predict imco14_5
brier success14 imco14_5

logit success10 imco_5
predict imco10_5
brier success10 imco10_5

***NTY
logit success10 nyt_num
predict nyt10
brier success10 nyt10

logit success14 nyt_num
predict nyt14
brier success14 nyt14

***Jerusalem Post
logit success10 jp_num
predict jp10
brier success10 jp10

logit success14 jp_num
predict jp14
brier success10 jp14

***Haaretz
logit success10 haaretz_num
predict haaretz10
brier success10 haaretz10

logit success14 haaretz_num
predict haaretz14
brier success10 haaretz14

***Appendix III
*** the Analysis is the same as for Table II, using different data accordingn to the different estimation windows. 
***data files are attached is a zip file

